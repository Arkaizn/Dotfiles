/** @enum {number} */
export const RejectReason = {
  CLEARED: 0,
  MAX_NUMBER_OF_TRIES: 1,
};

export class AsyncHandler {
  async _delay(ms) {
    return new Promise((resolve, reject) => {
      this._reject = reject;
      clearTimeout(this._timeoutId);
      this._timeoutId = setTimeout(() => {
        this._reject = undefined;
        resolve();
      }, ms);
    });
  }
  
  async when(condition, numberOfTries = 0) {
    if (numberOfTries == 50) {
      throw RejectReason.MAX_NUMBER_OF_TRIES;
    }
  
    if (condition()) {
      return undefined;
    }
  
    await this._delay(5);
    return await this.when(condition, numberOfTries + 1);
  }

  clear() {
    clearTimeout(this._timeoutId);
    if (this._reject) {
      this._reject(RejectReason.CLEARED);
      this._reject = undefined;
    }
  }
}
  