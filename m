From: Shannon Zhao <zhaoshenglong@huawei.com>
Subject: Re: [PATCH v6 12/21] KVM: ARM64: Add reset and access handlers for
 PMCNTENSET and PMCNTENCLR register
Date: Wed, 9 Dec 2015 16:35:58 +0800
Message-ID: <5667E7EE.90908@huawei.com>
References: <1449578860-15808-1-git-send-email-zhaoshenglong@huawei.com>
 <1449578860-15808-13-git-send-email-zhaoshenglong@huawei.com>
 <56670865.2050705@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4C6D9410EB
 for <kvmarm@lists.cs.columbia.edu>; Wed,  9 Dec 2015 03:35:08 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 0Kk-2omrIQuH for <kvmarm@lists.cs.columbia.edu>;
 Wed,  9 Dec 2015 03:35:06 -0500 (EST)
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [58.251.152.64])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id C59ED40C9D
 for <kvmarm@lists.cs.columbia.edu>; Wed,  9 Dec 2015 03:35:05 -0500 (EST)
In-Reply-To: <56670865.2050705@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Marc Zyngier <marc.zyngier@arm.com>, kvmarm@lists.cs.columbia.edu, christoffer.dall@linaro.org
Cc: kvm@vger.kernel.org, will.deacon@arm.com, linux-arm-kernel@lists.infradead.org, shannon.zhao@linaro.org
List-Id: kvmarm@lists.cs.columbia.edu

CgpPbiAyMDE1LzEyLzkgMDo0MiwgTWFyYyBaeW5naWVyIHdyb3RlOgo+PiArdm9pZCBrdm1fcG11
X2VuYWJsZV9jb3VudGVyKHN0cnVjdCBrdm1fdmNwdSAqdmNwdSwgdTMyIHZhbCwgYm9vbCBhbGxf
ZW5hYmxlKQo+PiA+ICt7Cj4+ID4gKwlpbnQgaTsKPj4gPiArCXN0cnVjdCBrdm1fcG11ICpwbXUg
PSAmdmNwdS0+YXJjaC5wbXU7Cj4+ID4gKwlzdHJ1Y3Qga3ZtX3BtYyAqcG1jOwo+PiA+ICsKPj4g
PiArCWlmICghYWxsX2VuYWJsZSkKPj4gPiArCQlyZXR1cm47Cj4gWW91IGhhdmUgdGhlIHZjcHUu
IENhbiB5b3UgbW92ZSB0aGUgY2hlY2sgZm9yIFBNQ1JfRUwwLkUgaGVyZSBpbnN0ZWFkIG9mCj4g
aGF2aW5nIGl0IGluIGJvdGggb2YgdGhlIGNhbGxlcnM/Cj4gCkJ1dCBpdCBzdGlsbCBuZWVkcyB0
byBjaGVjayBQTUNSX0VMMC5FIGluIGt2bV9wbXVfaGFuZGxlX3BtY3IoKS4gV2hlbgpQTUNSX0VM
MC5FID09IDEsIGl0IGNhbGxzIGt2bV9wbXVfZW5hYmxlX2NvdW50ZXIoKSwgb3RoZXJ3aXNlIGl0
IGNhbGxzCmt2bV9wbXVfZGlzYWJsZV9jb3VudGVyKCkuIFNvIGFzIGl0IGNoZWNrcyBhbHJlYWR5
LCBqdXN0IHBhc3MgdGhlIHJlc3VsdAphcyBhIHBhcmFtZXRlci4KCj4+ID4gKwo+PiA+ICsJZm9y
X2VhY2hfc2V0X2JpdChpLCAoY29uc3QgdW5zaWduZWQgbG9uZyAqKSZ2YWwsIEFSTVY4X01BWF9D
T1VOVEVSUykgewo+IE5vbm9ub25vbm8uLi4gSWYgeW91IG11c3QgaGF2ZSB0byB1c2UgYSBsb25n
LCB1c2UgYSBsb25nLiBEb24ndCBjYXN0IGl0Cj4gdG8gYSBkaWZmZXJlbnQgdHlwZSAoaGludDog
YmlnIGVuZGlhbikuCj4gCj4+ID4gKwkJcG1jID0gJnBtdS0+cG1jW2ldOwo+PiA+ICsJCWlmIChw
bWMtPnBlcmZfZXZlbnQpIHsKPj4gPiArCQkJcGVyZl9ldmVudF9lbmFibGUocG1jLT5wZXJmX2V2
ZW50KTsKPj4gPiArCQkJaWYgKHBtYy0+cGVyZl9ldmVudC0+c3RhdGUgIT0gUEVSRl9FVkVOVF9T
VEFURV9BQ1RJVkUpCj4+ID4gKwkJCQlrdm1fZGVidWcoImZhaWwgdG8gZW5hYmxlIHBlcmYgZXZl
bnRcbiIpOwo+PiA+ICsJCX0KPj4gPiArCX0KPj4gPiArfQo+PiA+ICsKPj4gPiArLyoqCj4+ID4g
KyAqIGt2bV9wbXVfZGlzYWJsZV9jb3VudGVyIC0gZGlzYWJsZSBzZWxlY3RlZCBQTVUgY291bnRl
cgo+PiA+ICsgKiBAdmNwdTogVGhlIHZjcHUgcG9pbnRlcgo+PiA+ICsgKiBAdmFsOiB0aGUgdmFs
dWUgZ3Vlc3Qgd3JpdGVzIHRvIFBNQ05URU5DTFIgcmVnaXN0ZXIKPj4gPiArICoKPj4gPiArICog
Q2FsbCBwZXJmX2V2ZW50X2Rpc2FibGUgdG8gc3RvcCBjb3VudGluZyB0aGUgcGVyZiBldmVudAo+
PiA+ICsgKi8KPj4gPiArdm9pZCBrdm1fcG11X2Rpc2FibGVfY291bnRlcihzdHJ1Y3Qga3ZtX3Zj
cHUgKnZjcHUsIHUzMiB2YWwpCj4+ID4gK3sKPj4gPiArCWludCBpOwo+PiA+ICsJc3RydWN0IGt2
bV9wbXUgKnBtdSA9ICZ2Y3B1LT5hcmNoLnBtdTsKPj4gPiArCXN0cnVjdCBrdm1fcG1jICpwbWM7
Cj4+ID4gKwo+IFdoeSBhcmUgZW5hYmxlIGFuZCBkaXNhYmxlIGFzeW1tZXRyaWMgKGhhbmRsaW5n
IG9mIFBNQ1IuRSk/Cj4gClRvIGVuYWJsZSBhIGNvdW50ZXIsIGl0IG5lZWRzIGJvdGggdGhlIFBN
Q1JfRUwwLkUgYW5kIHRoZSBjb3JyZXNwb25kaW5nCmJpdCBvZiBQTUNOVEVOU0VUX0VMMCBzZXQg
dG8gMS4gQnV0IHRvIGRpc2FibGUgYSBjb3VudGVyLCBpdCBvbmx5IG5lZWRzCm9uZSBvZiB0aGVt
IGFuZCB3aGVuIFBNQ1JfRUwwLkUgPT0gMO+8jCBpdCBkaXNhYmxlcyBhbGwgdGhlIGNvdW50ZXJz
LgoKVGhhbmtzLAotLSAKU2hhbm5vbgoKX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX18Ka3ZtYXJtIG1haWxpbmcgbGlzdAprdm1hcm1AbGlzdHMuY3MuY29sdW1i
aWEuZWR1Cmh0dHBzOi8vbGlzdHMuY3MuY29sdW1iaWEuZWR1L21haWxtYW4vbGlzdGluZm8va3Zt
YXJtCg==
