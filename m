Return-Path: <SRS0=1Vfj=WT=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5E7C1C3A5A1
	for <kvmarm@archiver.kernel.org>; Fri, 23 Aug 2019 02:25:16 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id CAF7023404
	for <kvmarm@archiver.kernel.org>; Fri, 23 Aug 2019 02:25:15 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org CAF7023404
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 02D034A59A;
	Thu, 22 Aug 2019 22:25:15 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Rhzxfney9dkf; Thu, 22 Aug 2019 22:25:13 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8831F4A5F7;
	Thu, 22 Aug 2019 22:25:13 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id F31F34A589
 for <kvmarm@lists.cs.columbia.edu>; Thu, 22 Aug 2019 22:25:11 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 3XVBwY84peA9 for <kvmarm@lists.cs.columbia.edu>;
 Thu, 22 Aug 2019 22:25:10 -0400 (EDT)
Received: from huawei.com (szxga07-in.huawei.com [45.249.212.35])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id CE3DD4A590
 for <kvmarm@lists.cs.columbia.edu>; Thu, 22 Aug 2019 22:25:09 -0400 (EDT)
Received: from DGGEMS407-HUB.china.huawei.com (unknown [172.30.72.59])
 by Forcepoint Email with ESMTP id F1D7B3D5F4C4697DD8F9;
 Fri, 23 Aug 2019 10:25:04 +0800 (CST)
Received: from [127.0.0.1] (10.184.12.158) by DGGEMS407-HUB.china.huawei.com
 (10.3.19.207) with Microsoft SMTP Server id 14.3.439.0; Fri, 23 Aug 2019
 10:24:57 +0800
Subject: Re: Can we boot a 512U kvm guest?
To: Auger Eric <eric.auger@redhat.com>, <kvmarm@lists.cs.columbia.edu>,
 <qemu-arm@nongnu.org>
References: <86aa9609-7dc9-1461-ae47-f50897cd0875@huawei.com>
 <da5c87d6-8b66-75f9-e720-9f1d80a76d7d@redhat.com>
From: Zenghui Yu <yuzenghui@huawei.com>
Message-ID: <d248e304-9004-02e6-d535-c69bc15d2b41@huawei.com>
Date: Fri, 23 Aug 2019 10:21:56 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:64.0) Gecko/20100101
 Thunderbird/64.0
MIME-Version: 1.0
In-Reply-To: <da5c87d6-8b66-75f9-e720-9f1d80a76d7d@redhat.com>
Content-Language: en-US
X-Originating-IP: [10.184.12.158]
X-CFilter-Loop: Reflected
Cc: zhang.zhanghailiang@huawei.com, kvm@vger.kernel.org,
 Marc Zyngier <maz@kernel.org>
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
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset="utf-8"; Format="flowed"
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

SGkgRXJpYywKCk9uIDIwMTkvOC8yMiAxNzowOCwgQXVnZXIgRXJpYyB3cm90ZToKPiBIaSBaZW5n
aHVpLAo+IAo+IE9uIDgvMTMvMTkgMTA6NTAgQU0sIFplbmdodWkgWXUgd3JvdGU6Cj4+IEhpIGZv
bGtzLAo+Pgo+PiBTaW5jZSBjb21taXQgZTI1MDI4YzhkZWQwICgiS1ZNOiBhcm0vYXJtNjQ6IEJ1
bXAgVkdJQ19WM19NQVhfQ1BVUyB0bwo+PiA1MTIiKSwgd2Ugc2VlbWVkIHRvIGJlIGFsbG93ZWQg
dG8gYm9vdCBhIDUxMlUgZ3Vlc3QuwqAgQnV0IEkgZmFpbGVkIHRvCj4+IHN0YXJ0IGl0IHVwIHdp
dGggdGhlIGxhdGVzdCBRRU1VLsKgIEkgZ3Vlc3MgdGhlcmUgYXJlIGF0IGxlYXN0ICp0d28qCj4+
IHJlYXNvbnMgKGxpbWl0YXRpb25zKS4KPj4KPj4gRmlyc3QgSSBnb3QgYSBRRU1VIGFib3J0Ogo+
PiAgwqDCoMKgwqAia3ZtX3NldF9pcnE6IEludmFsaWQgYXJndW1lbnQiCj4+Cj4+IEVuYWJsZSB0
aGUgdHJhY2Vfa3ZtX2lycV9saW5lKCkgdW5kZXIgZGVidWdmcywgd2hlbiBpdCBjb21lZCB3aXRo
Cj4+IHZjcHUtMjU2LCBJIGdvdDoKPj4gIMKgwqDCoMKgIkluamVjdCBVTktOT1dOIGludGVycnVw
dCAoMyksIHZjcHUtPmlkeDogMCwgbnVtOiAyMywgbGV2ZWw6IDAiCj4+IGFuZCBrdm1fdm1faW9j
dGxfaXJxX2xpbmUoKSByZXR1cm5zIC1FSU5WQUwgdG8gdXNlci1zcGFjZS4uLgo+Pgo+PiBTbyB0
aGUgdGhpbmcgaXMgdGhhdCB3ZSBvbmx5IGhhdmUgOCBiaXRzIGZvciB2Y3B1X2luZGV4IGZpZWxk
IChbMjM6MTZdKQo+PiBpbiBLVk1fSVJRX0xJTkUgaW9jdGwuwqAgaXJxX3R5cGUgZmllbGQgd2ls
bCBiZSBjb3JydXB0ZWQgaWYgd2UgaW5qZWN0IGEKPj4gUFBJIHRvIHZjcHUtMjU2LCB3aG9zZSB2
Y3B1X2luZGV4IHdpbGwgdGFrZSA5IGJpdHMuCj4+Cj4+IEkgdGVtcG9yYXJpbHkgcGF0Y2hlZCB0
aGUgS1ZNIGFuZCBRRU1VIHdpdGggdGhlIGZvbGxvd2luZyBkaWZmOgo+Pgo+PiAtLS04PC0tLQo+
PiBkaWZmIC0tZ2l0IGEvYXJjaC9hcm02NC9pbmNsdWRlL3VhcGkvYXNtL2t2bS5oCj4+IGIvYXJj
aC9hcm02NC9pbmNsdWRlL3VhcGkvYXNtL2t2bS5oCj4+IGluZGV4IDk1NTE2YTQuLjM5YTBmYjEg
MTAwNjQ0Cj4+IC0tLSBhL2FyY2gvYXJtNjQvaW5jbHVkZS91YXBpL2FzbS9rdm0uaAo+PiArKysg
Yi9hcmNoL2FybTY0L2luY2x1ZGUvdWFwaS9hc20va3ZtLmgKPj4gQEAgLTMyNSwxMCArMzI1LDEw
IEBAIHN0cnVjdCBrdm1fdmNwdV9ldmVudHMgewo+PiAgwqAjZGVmaW5lwqDCoCBLVk1fQVJNX1ZD
UFVfVElNRVJfSVJRX1BUSU1FUsKgwqDCoMKgwqDCoMKgIDEKPj4KPj4gIMKgLyogS1ZNX0lSUV9M
SU5FIGlycSBmaWVsZCBpbmRleCB2YWx1ZXMgKi8KPj4gLSNkZWZpbmUgS1ZNX0FSTV9JUlFfVFlQ
RV9TSElGVMKgwqDCoMKgwqDCoMKgIDI0Cj4+IC0jZGVmaW5lIEtWTV9BUk1fSVJRX1RZUEVfTUFT
S8KgwqDCoMKgwqDCoMKgIDB4ZmYKPj4gKyNkZWZpbmUgS1ZNX0FSTV9JUlFfVFlQRV9TSElGVMKg
wqDCoMKgwqDCoMKgIDI4Cj4+ICsjZGVmaW5lIEtWTV9BUk1fSVJRX1RZUEVfTUFTS8KgwqDCoMKg
wqDCoMKgIDB4Zgo+PiAgwqAjZGVmaW5lIEtWTV9BUk1fSVJRX1ZDUFVfU0hJRlTCoMKgwqDCoMKg
wqDCoCAxNgo+PiAtI2RlZmluZSBLVk1fQVJNX0lSUV9WQ1BVX01BU0vCoMKgwqDCoMKgwqDCoCAw
eGZmCj4+ICsjZGVmaW5lIEtWTV9BUk1fSVJRX1ZDUFVfTUFTS8KgwqDCoMKgwqDCoMKgIDB4ZmZm
Cj4+ICDCoCNkZWZpbmUgS1ZNX0FSTV9JUlFfTlVNX1NISUZUwqDCoMKgwqDCoMKgwqAgMAo+PiAg
wqAjZGVmaW5lIEtWTV9BUk1fSVJRX05VTV9NQVNLwqDCoMKgwqDCoMKgwqAgMHhmZmZmCj4+Cj4+
IC0tLTg8LS0tCj4+Cj4+IEl0IG1ha2VzIHRoaW5ncyBhIGJpdCBiZXR0ZXIsIGl0IGFsc28gaW1t
ZWRpYXRlbHkgQlJFQUtzIHRoZSBhcGkgd2l0aAo+PiBvbGQgdmVyc2lvbnMuCj4+Cj4+Cj4+IE5l
eHQgY29tZXMgb25lIG1vcmUgUUVNVSBhYm9ydCAod2l0aCB0aGUgImZpeCIgYWJvdmUpOgo+PiAg
wqDCoMKgwqAiRmFpbGVkIHRvIHNldCBkZXZpY2UgYWRkcmVzczogTm8gc3BhY2UgbGVmdCBvbiBk
ZXZpY2UiCj4+Cj4+IFdlIHJlZ2lzdGVyIHR3byBpbyBkZXZpY2VzIChyZF9kZXYgYW5kIHNnaV9k
ZXYpIG9uIEtWTV9NTUlPX0JVUyBmb3IKPj4gZWFjaCByZWRpc3RyaWJ1dG9yLiA1MTIgdmNwdXMg
dGFrZSAxMDI0IGlvIGRldmljZXMsIHdoaWNoIGlzIGJleW9uZCB0aGUKPj4gbWF4aW11bSBsaW1p
dGF0aW9uIG9mIHRoZSBjdXJyZW50IGtlcm5lbCAtIE5SX0lPQlVTX0RFVlMgKDEwMDApLgo+PiBT
byB3ZSBnZXQgYSBFTk9TUEMgZXJyb3IgaGVyZS4KPiAKPiBEbyB5b3UgcGxhbiB0byBzZW5kIGEg
cGF0Y2ggZm9yIGluY3JlYXNpbmcgdGhlIE5SX0lPQlVTX0RFVlM/IE90aGVyd2lzZQo+IEkgY2Fu
IGRvIGl0LgoKWy4uLl0KCj4gWW91IG1lbnRpb25lZCB5b3Ugc3RhcnRlZCB3b3JraW5nIG9uIHRo
ZSBRRU1VIGZpeC4gRG8geW91IHBsYW4gdG8gc3VibWl0Cj4gcGF0Y2hlcyB0byB0aGUgTUwgb3Ig
ZG8geW91IHdhbnQgbWUgdG8gYXR0ZW1wdCB0byBmaXggdGhlIHNpdHVhdGlvbiBvbgo+IHVzZXJz
cGFjZT8KQWN0dWFsbHksIEkgaGF2ZW4ndCBzdGFydGVkIGFueXRoaW5nIHlldC4gIEl0IHdvdWxk
IGJlIGdyZWF0IGlmIHlvdSBjYW4KaGVscCB0byBmaXggdGhpcyBpbiBRRU1VLiAgWWVzLCBwbGVh
c2UgaGVscC4gOikKCkFuZCBwbGVhc2UgY2MgbWUgd2hlbiB5b3Ugc2VuZCB0aGUgcGF0Y2ggc28g
dGhhdCBJIGNhbiBkbyBzb21lIHRlc3RzIGluCnRoZSBmcmVlIHRpbWUuCgoKTWFueSB0aGFua3Ms
CnplbmdodWkKCl9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
Cmt2bWFybSBtYWlsaW5nIGxpc3QKa3ZtYXJtQGxpc3RzLmNzLmNvbHVtYmlhLmVkdQpodHRwczov
L2xpc3RzLmNzLmNvbHVtYmlhLmVkdS9tYWlsbWFuL2xpc3RpbmZvL2t2bWFybQo=
