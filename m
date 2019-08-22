Return-Path: <SRS0=16Xb=WS=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B8055C3A59D
	for <kvmarm@archiver.kernel.org>; Thu, 22 Aug 2019 09:50:36 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 54568233A2
	for <kvmarm@archiver.kernel.org>; Thu, 22 Aug 2019 09:50:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 54568233A2
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9846A4A58B;
	Thu, 22 Aug 2019 05:50:35 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 5jDeXkHKJHws; Thu, 22 Aug 2019 05:50:34 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7E2354A589;
	Thu, 22 Aug 2019 05:50:34 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9AC894A589
 for <kvmarm@lists.cs.columbia.edu>; Thu, 22 Aug 2019 05:50:32 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id MlMnDoSqJcvR for <kvmarm@lists.cs.columbia.edu>;
 Thu, 22 Aug 2019 05:50:31 -0400 (EDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 66BE74A56E
 for <kvmarm@lists.cs.columbia.edu>; Thu, 22 Aug 2019 05:50:31 -0400 (EDT)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com
 [10.5.11.11])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mx1.redhat.com (Postfix) with ESMTPS id 7A5733DE02;
 Thu, 22 Aug 2019 09:50:30 +0000 (UTC)
Received: from [10.36.116.105] (ovpn-116-105.ams2.redhat.com [10.36.116.105])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 63748600CD;
 Thu, 22 Aug 2019 09:50:26 +0000 (UTC)
Subject: Re: Can we boot a 512U kvm guest?
To: Marc Zyngier <maz@kernel.org>, Zenghui Yu <yuzenghui@huawei.com>,
 kvmarm@lists.cs.columbia.edu, qemu-arm@nongnu.org
References: <86aa9609-7dc9-1461-ae47-f50897cd0875@huawei.com>
 <da5c87d6-8b66-75f9-e720-9f1d80a76d7d@redhat.com>
 <fbeb47df-7ea2-04ce-5fe3-a6a6a4751b8b@kernel.org>
From: Auger Eric <eric.auger@redhat.com>
Message-ID: <681f59e8-a193-6d3e-0bcc-5e52f4203868@redhat.com>
Date: Thu, 22 Aug 2019 11:50:25 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <fbeb47df-7ea2-04ce-5fe3-a6a6a4751b8b@kernel.org>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16
 (mx1.redhat.com [10.5.110.29]); Thu, 22 Aug 2019 09:50:30 +0000 (UTC)
Cc: zhang.zhanghailiang@huawei.com, kvm@vger.kernel.org
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

SGkgTWFyYywKCk9uIDgvMjIvMTkgMTE6MjkgQU0sIE1hcmMgWnluZ2llciB3cm90ZToKPiBIaSBF
cmljLAo+IAo+IE9uIDIyLzA4LzIwMTkgMTA6MDgsIEF1Z2VyIEVyaWMgd3JvdGU6Cj4+IEhpIFpl
bmdodWksCj4+Cj4+IE9uIDgvMTMvMTkgMTA6NTAgQU0sIFplbmdodWkgWXUgd3JvdGU6Cj4+PiBI
aSBmb2xrcywKPj4+Cj4+PiBTaW5jZSBjb21taXQgZTI1MDI4YzhkZWQwICgiS1ZNOiBhcm0vYXJt
NjQ6IEJ1bXAgVkdJQ19WM19NQVhfQ1BVUyB0bwo+Pj4gNTEyIiksIHdlIHNlZW1lZCB0byBiZSBh
bGxvd2VkIHRvIGJvb3QgYSA1MTJVIGd1ZXN0LsKgIEJ1dCBJIGZhaWxlZCB0bwo+Pj4gc3RhcnQg
aXQgdXAgd2l0aCB0aGUgbGF0ZXN0IFFFTVUuwqAgSSBndWVzcyB0aGVyZSBhcmUgYXQgbGVhc3Qg
KnR3byoKPj4+IHJlYXNvbnMgKGxpbWl0YXRpb25zKS4KPj4+Cj4+PiBGaXJzdCBJIGdvdCBhIFFF
TVUgYWJvcnQ6Cj4+PiDCoMKgwqDCoCJrdm1fc2V0X2lycTogSW52YWxpZCBhcmd1bWVudCIKPj4+
Cj4+PiBFbmFibGUgdGhlIHRyYWNlX2t2bV9pcnFfbGluZSgpIHVuZGVyIGRlYnVnZnMsIHdoZW4g
aXQgY29tZWQgd2l0aAo+Pj4gdmNwdS0yNTYsIEkgZ290Ogo+Pj4gwqDCoMKgwqAiSW5qZWN0IFVO
S05PV04gaW50ZXJydXB0ICgzKSwgdmNwdS0+aWR4OiAwLCBudW06IDIzLCBsZXZlbDogMCIKPj4+
IGFuZCBrdm1fdm1faW9jdGxfaXJxX2xpbmUoKSByZXR1cm5zIC1FSU5WQUwgdG8gdXNlci1zcGFj
ZS4uLgo+Pj4KPj4+IFNvIHRoZSB0aGluZyBpcyB0aGF0IHdlIG9ubHkgaGF2ZSA4IGJpdHMgZm9y
IHZjcHVfaW5kZXggZmllbGQgKFsyMzoxNl0pCj4+PiBpbiBLVk1fSVJRX0xJTkUgaW9jdGwuwqAg
aXJxX3R5cGUgZmllbGQgd2lsbCBiZSBjb3JydXB0ZWQgaWYgd2UgaW5qZWN0IGEKPj4+IFBQSSB0
byB2Y3B1LTI1Niwgd2hvc2UgdmNwdV9pbmRleCB3aWxsIHRha2UgOSBiaXRzLgo+Pj4KPj4+IEkg
dGVtcG9yYXJpbHkgcGF0Y2hlZCB0aGUgS1ZNIGFuZCBRRU1VIHdpdGggdGhlIGZvbGxvd2luZyBk
aWZmOgo+Pj4KPj4+IC0tLTg8LS0tCj4+PiBkaWZmIC0tZ2l0IGEvYXJjaC9hcm02NC9pbmNsdWRl
L3VhcGkvYXNtL2t2bS5oCj4+PiBiL2FyY2gvYXJtNjQvaW5jbHVkZS91YXBpL2FzbS9rdm0uaAo+
Pj4gaW5kZXggOTU1MTZhNC4uMzlhMGZiMSAxMDA2NDQKPj4+IC0tLSBhL2FyY2gvYXJtNjQvaW5j
bHVkZS91YXBpL2FzbS9rdm0uaAo+Pj4gKysrIGIvYXJjaC9hcm02NC9pbmNsdWRlL3VhcGkvYXNt
L2t2bS5oCj4+PiBAQCAtMzI1LDEwICszMjUsMTAgQEAgc3RydWN0IGt2bV92Y3B1X2V2ZW50cyB7
Cj4+PiDCoCNkZWZpbmXCoMKgIEtWTV9BUk1fVkNQVV9USU1FUl9JUlFfUFRJTUVSwqDCoMKgwqDC
oMKgwqAgMQo+Pj4KPj4+IMKgLyogS1ZNX0lSUV9MSU5FIGlycSBmaWVsZCBpbmRleCB2YWx1ZXMg
Ki8KPj4+IC0jZGVmaW5lIEtWTV9BUk1fSVJRX1RZUEVfU0hJRlTCoMKgwqDCoMKgwqDCoCAyNAo+
Pj4gLSNkZWZpbmUgS1ZNX0FSTV9JUlFfVFlQRV9NQVNLwqDCoMKgwqDCoMKgwqAgMHhmZgo+Pj4g
KyNkZWZpbmUgS1ZNX0FSTV9JUlFfVFlQRV9TSElGVMKgwqDCoMKgwqDCoMKgIDI4Cj4+PiArI2Rl
ZmluZSBLVk1fQVJNX0lSUV9UWVBFX01BU0vCoMKgwqDCoMKgwqDCoCAweGYKPj4+IMKgI2RlZmlu
ZSBLVk1fQVJNX0lSUV9WQ1BVX1NISUZUwqDCoMKgwqDCoMKgwqAgMTYKPj4+IC0jZGVmaW5lIEtW
TV9BUk1fSVJRX1ZDUFVfTUFTS8KgwqDCoMKgwqDCoMKgIDB4ZmYKPj4+ICsjZGVmaW5lIEtWTV9B
Uk1fSVJRX1ZDUFVfTUFTS8KgwqDCoMKgwqDCoMKgIDB4ZmZmCj4+PiDCoCNkZWZpbmUgS1ZNX0FS
TV9JUlFfTlVNX1NISUZUwqDCoMKgwqDCoMKgwqAgMAo+Pj4gwqAjZGVmaW5lIEtWTV9BUk1fSVJR
X05VTV9NQVNLwqDCoMKgwqDCoMKgwqAgMHhmZmZmCj4+Pgo+Pj4gLS0tODwtLS0KPj4+Cj4+PiBJ
dCBtYWtlcyB0aGluZ3MgYSBiaXQgYmV0dGVyLCBpdCBhbHNvIGltbWVkaWF0ZWx5IEJSRUFLcyB0
aGUgYXBpIHdpdGgKPj4+IG9sZCB2ZXJzaW9ucy4KPj4+Cj4+Pgo+Pj4gTmV4dCBjb21lcyBvbmUg
bW9yZSBRRU1VIGFib3J0ICh3aXRoIHRoZSAiZml4IiBhYm92ZSk6Cj4+PiDCoMKgwqDCoCJGYWls
ZWQgdG8gc2V0IGRldmljZSBhZGRyZXNzOiBObyBzcGFjZSBsZWZ0IG9uIGRldmljZSIKPj4+Cj4+
PiBXZSByZWdpc3RlciB0d28gaW8gZGV2aWNlcyAocmRfZGV2IGFuZCBzZ2lfZGV2KSBvbiBLVk1f
TU1JT19CVVMgZm9yCj4+PiBlYWNoIHJlZGlzdHJpYnV0b3IuIDUxMiB2Y3B1cyB0YWtlIDEwMjQg
aW8gZGV2aWNlcywgd2hpY2ggaXMgYmV5b25kIHRoZQo+Pj4gbWF4aW11bSBsaW1pdGF0aW9uIG9m
IHRoZSBjdXJyZW50IGtlcm5lbCAtIE5SX0lPQlVTX0RFVlMgKDEwMDApLgo+Pj4gU28gd2UgZ2V0
IGEgRU5PU1BDIGVycm9yIGhlcmUuCj4+Cj4+IERvIHlvdSBwbGFuIHRvIHNlbmQgYSBwYXRjaCBm
b3IgaW5jcmVhc2luZyB0aGUgTlJfSU9CVVNfREVWUz8gT3RoZXJ3aXNlCj4+IEkgY2FuIGRvIGl0
Lgo+IAo+IEkgcmVhbGx5IHdvbmRlciB3aGV0aGVyIHRoYXQncyBhIHNlbnNpYmxlIHRoaW5nIHRv
IGRvIG9uIGl0cyBvd24uCj4gCj4gTG9va2luZyBhdCB0aGUgaW1wbGVtZW50YXRpb24gb2Yga3Zt
X2lvX2J1c19yZWdpc3Rlcl9kZXYgKHdoaWNoIGNvcGllcwo+IHRoZSB3aG9sZSBhcnJheSBlYWNo
IHRpbWUgd2UgaW5zZXJ0IGEgZGV2aWNlKSwgd2UgaGF2ZSBhbiBvYnZpb3VzIGlzc3VlCj4gd2l0
aCBzeXN0ZW1zIHRoYXQgY3JlYXRlIGEgbGFyZ2UgbnVtYmVyIG9mIGRldmljZSBzdHJ1Y3R1cmVz
LCBsZWFkaW5nIHRvCj4gbGFyZ2UgdHJhbnNpZW50IG1lbW9yeSB1c2FnZSBhbmQgc2xvdyBndWVz
dCBzdGFydC4KPiAKPiBXZSBjb3VsZCBhbHNvIHRyeSBhbmQgcmVkdWNlIHRoZSBudW1iZXIgb2Yg
ZGV2aWNlcyB3ZSBpbnNlcnQgYnkgbWFraW5nCj4gdGhlIHJlZGlzdHJpYnV0b3IgYSBzaW5nbGUg
ZGV2aWNlICh3aGljaCBpdCBpcyBpbiByZWFsaXR5KS4gSXQgcHJvYmFibHkKPiBtZWFucyB3ZSBu
ZWVkIHRvIG1ha2UgdGhlIE1NSU8gZGVjb2RpbmcgbW9yZSBmbGV4aWJsZS4KClllcyBpdCBtYWtl
cyBzZW5zZS4gSWYgbm8gb2JqZWN0aW9uLCBJIGNhbiB3b3JrIG9uIHRoaXMgYXMgSSBhbSB0aGUK
c291cmNlIG9mIHRoZSBtZXNzIDstKQoKVGhhbmtzCgpFcmljCj4gCj4gVGhhbmtzLAo+IAo+IAlN
Lgo+IApfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXwprdm1h
cm0gbWFpbGluZyBsaXN0Cmt2bWFybUBsaXN0cy5jcy5jb2x1bWJpYS5lZHUKaHR0cHM6Ly9saXN0
cy5jcy5jb2x1bWJpYS5lZHUvbWFpbG1hbi9saXN0aW5mby9rdm1hcm0K
