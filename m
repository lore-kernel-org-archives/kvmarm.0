From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v6 12/21] KVM: ARM64: Add reset and access handlers for
 PMCNTENSET and PMCNTENCLR register
Date: Wed, 9 Dec 2015 08:56:45 +0000
Message-ID: <20151209085645.29fd224c@arm.com>
References: <1449578860-15808-1-git-send-email-zhaoshenglong@huawei.com>
 <1449578860-15808-13-git-send-email-zhaoshenglong@huawei.com>
 <56670865.2050705@arm.com> <5667E7EE.90908@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 11E7F412C2
 for <kvmarm@lists.cs.columbia.edu>; Wed,  9 Dec 2015 03:55:00 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 6nl39Gu-eUsQ for <kvmarm@lists.cs.columbia.edu>;
 Wed,  9 Dec 2015 03:54:59 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4AC5740C9D
 for <kvmarm@lists.cs.columbia.edu>; Wed,  9 Dec 2015 03:54:58 -0500 (EST)
In-Reply-To: <5667E7EE.90908@huawei.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Shannon Zhao <zhaoshenglong@huawei.com>
Cc: kvm@vger.kernel.org, shannon.zhao@linaro.org, will.deacon@arm.com, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

T24gV2VkLCA5IERlYyAyMDE1IDE2OjM1OjU4ICswODAwClNoYW5ub24gWmhhbyA8emhhb3NoZW5n
bG9uZ0BodWF3ZWkuY29tPiB3cm90ZToKCj4gCj4gCj4gT24gMjAxNS8xMi85IDA6NDIsIE1hcmMg
WnluZ2llciB3cm90ZToKPiA+PiArdm9pZCBrdm1fcG11X2VuYWJsZV9jb3VudGVyKHN0cnVjdCBr
dm1fdmNwdSAqdmNwdSwgdTMyIHZhbCwgYm9vbCBhbGxfZW5hYmxlKQo+ID4+ID4gK3sKPiA+PiA+
ICsJaW50IGk7Cj4gPj4gPiArCXN0cnVjdCBrdm1fcG11ICpwbXUgPSAmdmNwdS0+YXJjaC5wbXU7
Cj4gPj4gPiArCXN0cnVjdCBrdm1fcG1jICpwbWM7Cj4gPj4gPiArCj4gPj4gPiArCWlmICghYWxs
X2VuYWJsZSkKPiA+PiA+ICsJCXJldHVybjsKPiA+IFlvdSBoYXZlIHRoZSB2Y3B1LiBDYW4geW91
IG1vdmUgdGhlIGNoZWNrIGZvciBQTUNSX0VMMC5FIGhlcmUgaW5zdGVhZCBvZgo+ID4gaGF2aW5n
IGl0IGluIGJvdGggb2YgdGhlIGNhbGxlcnM/Cj4gPiAKPiBCdXQgaXQgc3RpbGwgbmVlZHMgdG8g
Y2hlY2sgUE1DUl9FTDAuRSBpbiBrdm1fcG11X2hhbmRsZV9wbWNyKCkuIFdoZW4KPiBQTUNSX0VM
MC5FID09IDEsIGl0IGNhbGxzIGt2bV9wbXVfZW5hYmxlX2NvdW50ZXIoKSwgb3RoZXJ3aXNlIGl0
IGNhbGxzCj4ga3ZtX3BtdV9kaXNhYmxlX2NvdW50ZXIoKS4gU28gYXMgaXQgY2hlY2tzIGFscmVh
ZHksIGp1c3QgcGFzcyB0aGUgcmVzdWx0Cj4gYXMgYSBwYXJhbWV0ZXIuCgpJJ3ZlIHNlZW4gdGhh
dCwgYnV0IGl0IG1ha2VzIHRoZSBjb2RlIGxvb2sgdWdseS4gQXQgYW55IHJhdGUsIHlvdSBtaWdo
dAphcyB3ZWxsIG5vdCBjYWxsIGVuYWJsZV9jb3VudGVyIGlmIFBNQ1IuRT09MC4gQnV0IHNwbGl0
dGluZyB0aGUgbG9va3VwCm9mIHRoZSBiaXQgYW5kIHRoZSB0ZXN0IGxpa2UgeW91IGRvIGlzIG5v
dCBuaWNlIGF0IGFsbC4gTWFraW5nIGl0CnNlbGYtY29udGFpbmVkIGxvb2tzIGEgbG90IGJldHRl
ciwgYW5kIHlvdSBkb24ndCBoYXZlIHRvIHRoaW5rIGFib3V0CnRoZSBjYWxsZXIuCgo+ID4+ID4g
Kwo+ID4+ID4gKwlmb3JfZWFjaF9zZXRfYml0KGksIChjb25zdCB1bnNpZ25lZCBsb25nICopJnZh
bCwgQVJNVjhfTUFYX0NPVU5URVJTKSB7Cj4gPiBOb25vbm9ub25vLi4uIElmIHlvdSBtdXN0IGhh
dmUgdG8gdXNlIGEgbG9uZywgdXNlIGEgbG9uZy4gRG9uJ3QgY2FzdCBpdAo+ID4gdG8gYSBkaWZm
ZXJlbnQgdHlwZSAoaGludDogYmlnIGVuZGlhbikuCj4gPiAKPiA+PiA+ICsJCXBtYyA9ICZwbXUt
PnBtY1tpXTsKPiA+PiA+ICsJCWlmIChwbWMtPnBlcmZfZXZlbnQpIHsKPiA+PiA+ICsJCQlwZXJm
X2V2ZW50X2VuYWJsZShwbWMtPnBlcmZfZXZlbnQpOwo+ID4+ID4gKwkJCWlmIChwbWMtPnBlcmZf
ZXZlbnQtPnN0YXRlICE9IFBFUkZfRVZFTlRfU1RBVEVfQUNUSVZFKQo+ID4+ID4gKwkJCQlrdm1f
ZGVidWcoImZhaWwgdG8gZW5hYmxlIHBlcmYgZXZlbnRcbiIpOwo+ID4+ID4gKwkJfQo+ID4+ID4g
Kwl9Cj4gPj4gPiArfQo+ID4+ID4gKwo+ID4+ID4gKy8qKgo+ID4+ID4gKyAqIGt2bV9wbXVfZGlz
YWJsZV9jb3VudGVyIC0gZGlzYWJsZSBzZWxlY3RlZCBQTVUgY291bnRlcgo+ID4+ID4gKyAqIEB2
Y3B1OiBUaGUgdmNwdSBwb2ludGVyCj4gPj4gPiArICogQHZhbDogdGhlIHZhbHVlIGd1ZXN0IHdy
aXRlcyB0byBQTUNOVEVOQ0xSIHJlZ2lzdGVyCj4gPj4gPiArICoKPiA+PiA+ICsgKiBDYWxsIHBl
cmZfZXZlbnRfZGlzYWJsZSB0byBzdG9wIGNvdW50aW5nIHRoZSBwZXJmIGV2ZW50Cj4gPj4gPiAr
ICovCj4gPj4gPiArdm9pZCBrdm1fcG11X2Rpc2FibGVfY291bnRlcihzdHJ1Y3Qga3ZtX3ZjcHUg
KnZjcHUsIHUzMiB2YWwpCj4gPj4gPiArewo+ID4+ID4gKwlpbnQgaTsKPiA+PiA+ICsJc3RydWN0
IGt2bV9wbXUgKnBtdSA9ICZ2Y3B1LT5hcmNoLnBtdTsKPiA+PiA+ICsJc3RydWN0IGt2bV9wbWMg
KnBtYzsKPiA+PiA+ICsKPiA+IFdoeSBhcmUgZW5hYmxlIGFuZCBkaXNhYmxlIGFzeW1tZXRyaWMg
KGhhbmRsaW5nIG9mIFBNQ1IuRSk/Cj4gPiAKPiBUbyBlbmFibGUgYSBjb3VudGVyLCBpdCBuZWVk
cyBib3RoIHRoZSBQTUNSX0VMMC5FIGFuZCB0aGUgY29ycmVzcG9uZGluZwo+IGJpdCBvZiBQTUNO
VEVOU0VUX0VMMCBzZXQgdG8gMS4gQnV0IHRvIGRpc2FibGUgYSBjb3VudGVyLCBpdCBvbmx5IG5l
ZWRzCj4gb25lIG9mIHRoZW0gYW5kIHdoZW4gUE1DUl9FTDAuRSA9PSAw77yMIGl0IGRpc2FibGVz
IGFsbCB0aGUgY291bnRlcnMuCgpPSy4KCglNLgotLSAKSmF6eiBpcyBub3QgZGVhZC4gSXQganVz
dCBzbWVsbHMgZnVubnkuCl9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fCmt2bWFybSBtYWlsaW5nIGxpc3QKa3ZtYXJtQGxpc3RzLmNzLmNvbHVtYmlhLmVkdQpo
dHRwczovL2xpc3RzLmNzLmNvbHVtYmlhLmVkdS9tYWlsbWFuL2xpc3RpbmZvL2t2bWFybQo=
