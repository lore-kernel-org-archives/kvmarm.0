Return-Path: <SRS0=RZNQ=GD=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.6 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 02DCEC433E0
	for <kvmarm@archiver.kernel.org>; Thu, 31 Dec 2020 11:59:14 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id CD586223E8
	for <kvmarm@archiver.kernel.org>; Thu, 31 Dec 2020 11:59:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org CD586223E8
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 21C374B285;
	Thu, 31 Dec 2020 06:59:12 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id HSt7sq2jUjIr; Thu, 31 Dec 2020 06:59:11 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 05D484B286;
	Thu, 31 Dec 2020 06:59:11 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 011AD4B282
 for <kvmarm@lists.cs.columbia.edu>; Thu, 31 Dec 2020 06:59:09 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 0Fu6usjT3erS for <kvmarm@lists.cs.columbia.edu>;
 Thu, 31 Dec 2020 06:59:07 -0500 (EST)
Received: from szxga05-in.huawei.com (szxga05-in.huawei.com [45.249.212.191])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id B77594B286
 for <kvmarm@lists.cs.columbia.edu>; Thu, 31 Dec 2020 06:59:06 -0500 (EST)
Received: from DGGEMS404-HUB.china.huawei.com (unknown [172.30.72.60])
 by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4D669c1H9Mzj1r4;
 Thu, 31 Dec 2020 19:58:12 +0800 (CST)
Received: from [10.174.184.196] (10.174.184.196) by
 DGGEMS404-HUB.china.huawei.com (10.3.19.204) with Microsoft SMTP Server id
 14.3.498.0; Thu, 31 Dec 2020 19:58:53 +0800
Subject: Re: [PATCH RFC] KVM: arm64: vgic: Decouple the check of the
 EnableLPIs bit from the ITS LPI translation
To: Marc Zyngier <maz@kernel.org>
References: <20201231062813.714-1-lushenming@huawei.com>
 <683134bdea8a22d3bb784117dcfe17a1@kernel.org>
From: Shenming Lu <lushenming@huawei.com>
Message-ID: <cf530279-4c68-c7de-f87e-1236ce0241cf@huawei.com>
Date: Thu, 31 Dec 2020 19:58:41 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.2.2
MIME-Version: 1.0
In-Reply-To: <683134bdea8a22d3bb784117dcfe17a1@kernel.org>
Content-Language: en-US
X-Originating-IP: [10.174.184.196]
X-CFilter-Loop: Reflected
Cc: linux-kernel@vger.kernel.org, Will Deacon <will@kernel.org>,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
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

T24gMjAyMC8xMi8zMSAxNjo1NywgTWFyYyBaeW5naWVyIHdyb3RlOgo+IEhpIFNoZW1taW5nLAo+
IAo+IE9uIDIwMjAtMTItMzEgMDY6MjgsIFNoZW5taW5nIEx1IHdyb3RlOgo+PiBXaGVuIHRoZSBF
bmFibGVMUElzIGJpdCBpcyBzZXQgdG8gMCwgYW55IElUUyBMUEkgcmVxdWVzdHMgaW4gdGhlCj4+
IFJlZGlzdHJpYnV0b3Igd291bGQgYmUgaWdub3JlZC4gQW5kIHRoaXMgY2hlY2sgaXMgaW5kZXBl
bmRlbnQgZnJvbQo+PiB0aGUgSVRTIExQSSB0cmFuc2xhdGlvbi4gU28gaXQgbWlnaHQgYmUgYmV0
dGVyIHRvIG1vdmUgdGhlIGNoZWNrCj4+IG9mIHRoZSBFbmFibGVMUElzIGJpdCBvdXQgb2YgdGhl
IExQSSByZXNvbHZpbmcsIGFuZCBhbHNvIGFkZCBpdAo+PiB0byB0aGUgcGF0aCB0aGF0IHVzZXMg
dGhlIHRyYW5zbGF0aW9uIGNhY2hlLgo+IAo+IEJ1dCBieSBkb2luZyB0aGF0LCB5b3UgYXJlIG1v
dmluZyB0aGUgb3ZlcmhlYWQgb2YgY2hlY2tpbmcgZm9yCj4gRW5hYmxlTFBJcyBmcm9tIHRoZSBz
bG93IHBhdGggKHRyYW5zbGF0aW9uIHdhbGspIHRvIHRoZSBmYXN0Cj4gcGF0aCAoY2FjaGUgaGl0
KSwgd2hpY2ggc2VlbXMgY291bnRlci1wcm9kdWN0aXZlLgoKT2gsIEkgZGlkbid0IG5vdGljZSB0
aGUgb3ZlcmhlYWQgb2YgdGhlIGNoZWNraW5nLCBJIHRob3VnaHQgaXQgd291bGQKYmUgbmVnbGln
aWJsZS4uLgoKPiAKPj4gQmVzaWRlcyBpdCBzZWVtcyB0aGF0Cj4+IGJ5IHRoaXMgdGhlIGludmFs
aWRhdGluZyBvZiB0aGUgdHJhbnNsYXRpb24gY2FjaGUgY2F1c2VkIGJ5IHRoZSBMUEkKPj4gZGlz
YWJsaW5nIGlzIHVubmVjZXNzYXJ5Lgo+Pgo+PiBOb3Qgc3VyZSBpZiBJIGhhdmUgbWlzc2VkIHNv
bWV0aGluZy4uLiBUaGFua3MuCj4gCj4gSSBhbSBjZXJ0YWlubHkgbWlzc2luZyB0aGUgcHVycG9z
ZSBvZiB0aGlzIHBhdGNoLgo+IAo+IFRoZSBlZmZlY3Qgb2YgRW5hYmxlTFBJcyBiZWluZyB6ZXJv
IGlzIHRvIGRyb3AgdGhlIHJlc3VsdCBvZiBhbnkKPiB0cmFuc2xhdGlvbiAoYSBuZXcgcGVuZGlu
ZyBiaXQpIG9uIHRoZSBmbG9vci4gR2l2ZW4gdGhhdCwgaXQgaXMKPiBpbW1hdGVyaWFsIHdoZXRo
ZXIgdGhpcyBjYXVzZXMgYSBuZXcgdHJhbnNsYXRpb24gb3IgaGl0cyBpbiB0aGUKPiBjYWNoZSwg
YXMgdGhlIHJlc3VsdCBpcyBzdGlsbCB0byBub3QgcGVuZCBhIG5ldyBpbnRlcnJ1cHQuCj4gCj4g
SSBnZXQgdGhlIGZlZWxpbmcgdGhhdCB5b3UgYXJlIHRyeWluZyB0byBvcHRpbWlzZSBmb3IgdGhl
IHVudXN1YWwKPiBjYXNlIHdoZXJlIEVuYWJsZUxQSXMgaXMgMCAqYW5kKiB5b3UgaGF2ZSBhIHNj
cmVhbWluZyBkZXZpY2UKPiBpbmplY3RpbmcgdG9ucyBvZiBpbnRlcnJ1cHQuIElmIHRoYXQgaXMg
dGhlIGNhc2UsIEkgZG9uJ3QgdGhpbmsKPiB0aGlzIGlzIHdvcnRoIGl0LgoKSW4gZmFjdCwgSSBq
dXN0IGZvdW5kIChpbWFnaW5pbmcpIHRoYXQgaWYgdGhlIEVuYWJsZUxQSXMgYml0IGlzIDAsCnRo
ZSBrdm1fdmdpY192NF9zZXRfZm9yd2FyZGluZygpIHdvdWxkIGZhaWwgd2hlbiBwZXJmb3JtaW5n
IHRoZSBMUEkKdHJhbnNsYXRpb24sIGJ1dCBpbmRlZWQgd2UgZG9uJ3QgdHJ5IHRvIHBlbmQgYW55
IGludGVycnVwdHMgdGhlcmUuLi4KCkJ5IHRoZSB3YXksIGl0IHNlZW1zIHRoYXQgdGhlIExQSSBk
aXNhYmxpbmcgd291bGQgbm90IGFmZmVjdCB0aGUKaW5qZWN0aW9uIG9mIFZMUElzLi4uCgpUaGFu
a3MsClNoZW5taW5nCgo+IAo+IFRoYW5rcywKPiAKPiDCoMKgwqDCoMKgwqDCoCBNLgo+IAo+Pgo+
PiBTaWduZWQtb2ZmLWJ5OiBTaGVubWluZyBMdSA8bHVzaGVubWluZ0BodWF3ZWkuY29tPgo+PiAt
LS0KPj4gwqBhcmNoL2FybTY0L2t2bS92Z2ljL3ZnaWMtaXRzLmPCoMKgwqDCoCB8IDkgKysrKyst
LS0tCj4+IMKgYXJjaC9hcm02NC9rdm0vdmdpYy92Z2ljLW1taW8tdjMuYyB8IDQgKy0tLQo+PiDC
oDIgZmlsZXMgY2hhbmdlZCwgNiBpbnNlcnRpb25zKCspLCA3IGRlbGV0aW9ucygtKQo+Pgo+PiBk
aWZmIC0tZ2l0IGEvYXJjaC9hcm02NC9rdm0vdmdpYy92Z2ljLWl0cy5jIGIvYXJjaC9hcm02NC9r
dm0vdmdpYy92Z2ljLWl0cy5jCj4+IGluZGV4IDQwY2JhY2E4MTMzMy4uZjUzNDQ2YmMxNTRlIDEw
MDY0NAo+PiAtLS0gYS9hcmNoL2FybTY0L2t2bS92Z2ljL3ZnaWMtaXRzLmMKPj4gKysrIGIvYXJj
aC9hcm02NC9rdm0vdmdpYy92Z2ljLWl0cy5jCj4+IEBAIC02ODMsOSArNjgzLDYgQEAgaW50IHZn
aWNfaXRzX3Jlc29sdmVfbHBpKHN0cnVjdCBrdm0gKmt2bSwgc3RydWN0Cj4+IHZnaWNfaXRzICpp
dHMsCj4+IMKgwqDCoMKgIGlmICghdmNwdSkKPj4gwqDCoMKgwqDCoMKgwqDCoCByZXR1cm4gRV9J
VFNfSU5UX1VOTUFQUEVEX0lOVEVSUlVQVDsKPj4KPj4gLcKgwqDCoCBpZiAoIXZjcHUtPmFyY2gu
dmdpY19jcHUubHBpc19lbmFibGVkKQo+PiAtwqDCoMKgwqDCoMKgwqAgcmV0dXJuIC1FQlVTWTsK
Pj4gLQo+PiDCoMKgwqDCoCB2Z2ljX2l0c19jYWNoZV90cmFuc2xhdGlvbihrdm0sIGl0cywgZGV2
aWQsIGV2ZW50aWQsIGl0ZS0+aXJxKTsKPj4KPj4gwqDCoMKgwqAgKmlycSA9IGl0ZS0+aXJxOwo+
PiBAQCAtNzM4LDYgKzczNSw5IEBAIHN0YXRpYyBpbnQgdmdpY19pdHNfdHJpZ2dlcl9tc2koc3Ry
dWN0IGt2bSAqa3ZtLAo+PiBzdHJ1Y3QgdmdpY19pdHMgKml0cywKPj4gwqDCoMKgwqAgaWYgKGVy
cikKPj4gwqDCoMKgwqDCoMKgwqDCoCByZXR1cm4gZXJyOwo+Pgo+PiArwqDCoMKgIGlmICghaXJx
LT50YXJnZXRfdmNwdS0+YXJjaC52Z2ljX2NwdS5scGlzX2VuYWJsZWQpCj4+ICvCoMKgwqDCoMKg
wqDCoCByZXR1cm4gLUVCVVNZOwo+PiArCj4+IMKgwqDCoMKgIGlmIChpcnEtPmh3KQo+PiDCoMKg
wqDCoMKgwqDCoMKgIHJldHVybiBpcnFfc2V0X2lycWNoaXBfc3RhdGUoaXJxLT5ob3N0X2lycSwK
Pj4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgSVJR
Q0hJUF9TVEFURV9QRU5ESU5HLCB0cnVlKTsKPj4gQEAgLTc1Nyw3ICs3NTcsOCBAQCBpbnQgdmdp
Y19pdHNfaW5qZWN0X2NhY2hlZF90cmFuc2xhdGlvbihzdHJ1Y3Qga3ZtCj4+ICprdm0sIHN0cnVj
dCBrdm1fbXNpICptc2kpCj4+Cj4+IMKgwqDCoMKgIGRiID0gKHU2NCltc2ktPmFkZHJlc3NfaGkg
PDwgMzIgfCBtc2ktPmFkZHJlc3NfbG87Cj4+IMKgwqDCoMKgIGlycSA9IHZnaWNfaXRzX2NoZWNr
X2NhY2hlKGt2bSwgZGIsIG1zaS0+ZGV2aWQsIG1zaS0+ZGF0YSk7Cj4+IC3CoMKgwqAgaWYgKCFp
cnEpCj4+ICsKPj4gK8KgwqDCoCBpZiAoIWlycSB8fCAhaXJxLT50YXJnZXRfdmNwdS0+YXJjaC52
Z2ljX2NwdS5scGlzX2VuYWJsZWQpCj4+IMKgwqDCoMKgwqDCoMKgwqAgcmV0dXJuIC1FV09VTERC
TE9DSzsKPj4KPj4gwqDCoMKgwqAgcmF3X3NwaW5fbG9ja19pcnFzYXZlKCZpcnEtPmlycV9sb2Nr
LCBmbGFncyk7Cj4+IGRpZmYgLS1naXQgYS9hcmNoL2FybTY0L2t2bS92Z2ljL3ZnaWMtbW1pby12
My5jCj4+IGIvYXJjaC9hcm02NC9rdm0vdmdpYy92Z2ljLW1taW8tdjMuYwo+PiBpbmRleCAxNWE2
Yzk4ZWU5MmYuLjdiMDc0OWY3NjYwZCAxMDA2NDQKPj4gLS0tIGEvYXJjaC9hcm02NC9rdm0vdmdp
Yy92Z2ljLW1taW8tdjMuYwo+PiArKysgYi9hcmNoL2FybTY0L2t2bS92Z2ljL3ZnaWMtbW1pby12
My5jCj4+IEBAIC0yNDIsMTAgKzI0Miw4IEBAIHN0YXRpYyB2b2lkIHZnaWNfbW1pb193cml0ZV92
M3JfY3RscihzdHJ1Y3Qga3ZtX3ZjcHUgKnZjcHUsCj4+Cj4+IMKgwqDCoMKgIHZnaWNfY3B1LT5s
cGlzX2VuYWJsZWQgPSB2YWwgJiBHSUNSX0NUTFJfRU5BQkxFX0xQSVM7Cj4+Cj4+IC3CoMKgwqAg
aWYgKHdhc19lbmFibGVkICYmICF2Z2ljX2NwdS0+bHBpc19lbmFibGVkKSB7Cj4+ICvCoMKgwqAg
aWYgKHdhc19lbmFibGVkICYmICF2Z2ljX2NwdS0+bHBpc19lbmFibGVkKQo+PiDCoMKgwqDCoMKg
wqDCoMKgIHZnaWNfZmx1c2hfcGVuZGluZ19scGlzKHZjcHUpOwo+PiAtwqDCoMKgwqDCoMKgwqAg
dmdpY19pdHNfaW52YWxpZGF0ZV9jYWNoZSh2Y3B1LT5rdm0pOwo+PiAtwqDCoMKgIH0KPj4KPj4g
wqDCoMKgwqAgaWYgKCF3YXNfZW5hYmxlZCAmJiB2Z2ljX2NwdS0+bHBpc19lbmFibGVkKQo+PiDC
oMKgwqDCoMKgwqDCoMKgIHZnaWNfZW5hYmxlX2xwaXModmNwdSk7Cj4gCl9fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fCmt2bWFybSBtYWlsaW5nIGxpc3QKa3Zt
YXJtQGxpc3RzLmNzLmNvbHVtYmlhLmVkdQpodHRwczovL2xpc3RzLmNzLmNvbHVtYmlhLmVkdS9t
YWlsbWFuL2xpc3RpbmZvL2t2bWFybQo=
