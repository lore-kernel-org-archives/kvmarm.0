Return-Path: <SRS0=T7i1=SK=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4438FC10F14
	for <kvmarm@archiver.kernel.org>; Mon,  8 Apr 2019 10:33:22 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id B84CD20870
	for <kvmarm@archiver.kernel.org>; Mon,  8 Apr 2019 10:33:21 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B84CD20870
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 058404A44E;
	Mon,  8 Apr 2019 06:33:21 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id S-urcnv7JlBB; Mon,  8 Apr 2019 06:33:18 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4D9B84A474;
	Mon,  8 Apr 2019 06:33:18 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5EFB94A44E
 for <kvmarm@lists.cs.columbia.edu>; Mon,  8 Apr 2019 06:33:17 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id uGpdanWLDcRq for <kvmarm@lists.cs.columbia.edu>;
 Mon,  8 Apr 2019 06:33:15 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BA21F4A321
 for <kvmarm@lists.cs.columbia.edu>; Mon,  8 Apr 2019 06:33:15 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.72.51.249])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 055AC15AD;
 Mon,  8 Apr 2019 03:33:15 -0700 (PDT)
Received: from [192.168.0.21] (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id
 025113F718; Mon,  8 Apr 2019 03:33:12 -0700 (PDT)
Subject: Re: [PATCH] kvm: arm: Skip stage2 huge mappings for unaligned ipa
 backed by THP
To: yuzenghui@huawei.com, linux-arm-kernel@lists.infradead.org
References: <1554203176-3958-1-git-send-email-suzuki.poulose@arm.com>
 <2ea55b9c-09da-c3d0-3616-aa6be85b5a46@huawei.com>
From: Suzuki K Poulose <suzuki.poulose@arm.com>
Message-ID: <a9c084fb-0c84-e632-a192-b361773a0bc8@arm.com>
Date: Mon, 8 Apr 2019 11:35:30 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.7.0
MIME-Version: 1.0
In-Reply-To: <2ea55b9c-09da-c3d0-3616-aa6be85b5a46@huawei.com>
Content-Language: en-US
Cc: kvm@vger.kernel.org, marc.zyngier@arm.com, linux-kernel@vger.kernel.org,
 kvmarm@lists.cs.columbia.edu
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
Content-Type: text/plain; charset="UTF-8"; format="flowed"
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
Message-ID: <20190408103530.mIf-qx1xiMZMZuWKUhq3yzbzAIXotlIsVxFnAhTIfPg@z>

T24gMDQvMDgvMjAxOSAwNDo1MCBBTSwgWmVuZ2h1aSBZdSB3cm90ZToKPiAKPiAKPiBPbiAyMDE5
LzQvMiAxOTowNiwgU3V6dWtpIEsgUG91bG9zZSB3cm90ZToKPj4gV2l0aCBjb21taXQgYTgwODY4
ZjM5ODU1NDg0MmIxNCwgd2Ugbm8gbG9uZ2VyIGVuc3VyZSB0aGF0IHRoZQo+PiBUSFAgcGFnZSBp
cyBwcm9wZXJseSBhbGlnbmVkIGluIHRoZSBndWVzdCBJUEEuIFNraXAgdGhlIHN0YWdlMgo+PiBo
dWdlIG1hcHBpbmcgZm9yIHVuYWxpZ25lZCBJUEEgYmFja2VkIGJ5IHRyYW5zcGFyZW50IGh1Z2Vw
YWdlcy4KPj4KPj4gRml4ZXM6IGE4MDg2OGYzOTg1NTQ4NDJiMTQgKCJLVk06IGFybS9hcm02NDog
RW5mb3JjZSBQVEUgbWFwcGluZ3MgYXQgCj4+IHN0YWdlMiB3aGVuIG5lZWRlZCIpCj4+IFJlcG9y
dGVkLWJ5OiBFcmljIEF1Z2VyIDxlcmljLmF1Z2VyQHJlZGhhdC5jb20+Cj4+IENjOiBNYXJjIFp5
bmdpZXIgPG1hcmMuenluZ2llckBhcm0uY29tPgo+PiBDYzogQ2hpcnN0b2ZmZXIgRGFsbCA8Y2hy
aXN0b2ZmZXIuZGFsbEBhcm0uY29tPgo+PiBDYzogWmVuZ2h1aSBZdSA8eXV6ZW5naHVpQGh1YXdl
aS5jb20+Cj4+IENjOiBaaGVuZyBYaWFuZyA8emhlbmd4aWFuZzlAaHVhd2VpLmNvbT4KPj4gVGVz
dGVkLWJ5OiBFcmljIEF1Z2VyIDxlcmljLmF1Z2VyQGFybS5jb20+Cj4+IFNpZ25lZC1vZmYtYnk6
IFN1enVraSBLIFBvdWxvc2UgPHN1enVraS5wb3Vsb3NlQGFybS5jb20+Cj4gCj4gSGkgU3V6dWtp
LAo+IAo+IFdoeSBub3QgbWFraW5nIHVzZSBvZiBmYXVsdF9zdXBwb3J0c19zdGFnZTJfaHVnZV9t
YXBwaW5nKCk/wqAgTGV0IGl0IGRvCj4gc29tZSBjaGVja3MgZm9yIHVzLgo+IAo+IGZhdWx0X3N1
cHBvcnRzX3N0YWdlMl9odWdlX21hcHBpbmcoKSB3YXMgaW50ZW5kZWQgdG8gZG8gYSAqdHdvLXN0
ZXAqCj4gY2hlY2sgdG8gdGVsbCB1cyB0aGF0IGNhbiB3ZSBjcmVhdGUgc3RhZ2UyIGh1Z2UgYmxv
Y2sgbWFwcGluZ3MsIGFuZCB0aGlzCj4gY2hlY2sgaXMgYm90aCBmb3IgaHVnZXRsYmZzIGFuZCBU
SFAuwqAgV2l0aCBjb21taXQgYTgwODY4ZjM5ODU1NDg0MmIxNCwKPiB3ZSBwYXNzIFBBR0VfU0la
RSBhcyAibWFwX3NpemUiIGZvciBub3JtYWwgc2l6ZSBwYWdlcyAod2hpY2ggdHVybmVkIG91dAo+
IHRvIGJlIGFsbW9zdCBtZWFuaW5nbGVzcyksIGFuZCB1bmZvcnR1bmF0ZWx5IHRoZSBUSFAgY2hl
Y2sgbm8gbG9uZ2VyCj4gd29ya3MuCgpUaGF0cyBjb3JyZWN0LgoKPiAKPiBTbyB3ZSB3YW50IHRv
IHJld29yayAqVEhQKiBjaGVjayBwcm9jZXNzLsKgIFlvdXIgcGF0Y2ggZml4ZXMgdGhlIGZpcnN0
Cj4gY2hlY2tpbmctc3RlcCwgYnV0IHRoZSBzZWNvbmQgaXMgc3RpbGwgbWlzc2VkLCBhbSBJIHdy
b25nPwoKSXQgZml4ZXMgdGhlIHN0ZXAgZXhwbGljaXRseSBmb3IgdGhlIFRIUCBieSBtYWtpbmcg
c3VyZSB0aGF0IHRoZSBHUEEgYW5kCnRoZSBIVkEgYXJlIGFsaWduZWQgdG8gdGhlIG1hcCBzaXpl
LgoKPiAKPiBDYW4geW91IHBsZWFzZSBnaXZlIGEgbG9vayBhdCB0aGUgYmVsb3cgZGlmZj8KPiAK
PiAKPiB0aGFua3MsCj4gCj4gemVuZ2h1aQo+IAo+PiAtLS0KPj4gwqAgdmlydC9rdm0vYXJtL21t
dS5jIHwgNCArKystCj4+IMKgIDEgZmlsZSBjaGFuZ2VkLCAzIGluc2VydGlvbnMoKyksIDEgZGVs
ZXRpb24oLSkKPj4KPj4gZGlmZiAtLWdpdCBhL3ZpcnQva3ZtL2FybS9tbXUuYyBiL3ZpcnQva3Zt
L2FybS9tbXUuYwo+PiBpbmRleCAyN2M5NTgzLi40YTIyZjViIDEwMDY0NAo+PiAtLS0gYS92aXJ0
L2t2bS9hcm0vbW11LmMKPj4gKysrIGIvdmlydC9rdm0vYXJtL21tdS5jCj4+IEBAIC0xNDEyLDcg
KzE0MTIsOSBAQCBzdGF0aWMgYm9vbCAKPj4gdHJhbnNwYXJlbnRfaHVnZXBhZ2VfYWRqdXN0KGt2
bV9wZm5fdCAqcGZucCwgcGh5c19hZGRyX3QgKmlwYXApCj4+IMKgwqDCoMKgwqDCoMKgwqDCoMKg
ICogcGFnZSBhY2NvcmRpbmdseS4KPj4gwqDCoMKgwqDCoMKgwqDCoMKgwqAgKi8KPj4gwqDCoMKg
wqDCoMKgwqDCoMKgIG1hc2sgPSBQVFJTX1BFUl9QTUQgLSAxOwo+PiAtwqDCoMKgwqDCoMKgwqAg
Vk1fQlVHX09OKChnZm4gJiBtYXNrKSAhPSAocGZuICYgbWFzaykpOwo+IFNvbWVob3csIEknZCBw
cmVmZXIga2VlcGluZyB0aGUgVk1fQlVHX09OKCkgaGVyZSwgbGV0IGl0IHJlcG9ydCBzb21lCj4g
cG90ZW50aWFsIGlzc3VlcyBpbiB0aGUgZnV0dXJlIChvZiBjb3Vyc2UgSSBob3BlIG5vbmU6KSAp
CgpJIGRvbid0IHRoaW5rIHRoaXMgY2FsbHMgZm9yIGEgVk1fQlVHX09OKCkuIEl0IGlzIHNpbXBs
eSBhIGNhc2Ugd2hlcmUKdGhlIEdQQSBpcyBub3QgYWxpZ25lZCB0byBIVkEsIGJ1dCBmb3Igbm9y
bWFsIFZNQSB0aGF0IGNvdWxkIGJlIG1hZGUgVEhQLgoKV2UgaGFkIHRoaXMgVk1fQlVHX09OKCks
IHdoaWNoIHdvdWxkIGhhdmUgbmV2ZXIgaGl0IGJlY2F1c2Ugd2Ugd291bGQKaGF2ZSBzZXQgZm9y
Y2VfcHRlIGlmIHRoZXkgd2VyZSBub3QgYWxpZ25lZC4KCj4+ICvCoMKgwqDCoMKgwqDCoCAvKiBT
a2lwIG1lbXNsb3RzIHdpdGggdW5hbGlnbmVkIElQQSBhbmQgdXNlciBhZGRyZXNzICovCj4+ICvC
oMKgwqDCoMKgwqDCoCBpZiAoKGdmbiAmIG1hc2spICE9IChwZm4gJiBtYXNrKSkKPj4gK8KgwqDC
oMKgwqDCoMKgwqDCoMKgwqAgcmV0dXJuIGZhbHNlOwo+PiDCoMKgwqDCoMKgwqDCoMKgwqAgaWYg
KHBmbiAmIG1hc2spIHsKPj4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgKmlwYXAgJj0gUE1E
X01BU0s7Cj4+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIGt2bV9yZWxlYXNlX3Bmbl9jbGVh
bihwZm4pOwo+Pgo+IAo+IC0tLTg+LS0tCj4gCj4gUmV3b3JrIGZhdWx0X3N1cHBvcnRzX3N0YWdl
Ml9odWdlX21hcHBpbmcoKSwgbGV0IGl0IGNoZWNrIFRIUCBhZ2Fpbi4KPiAKPiBTaWduZWQtb2Zm
LWJ5OiBaZW5naHVpIFl1IDx5dXplbmdodWlAaHVhd2VpLmNvbT4KPiAtLS0KPiAgwqB2aXJ0L2t2
bS9hcm0vbW11LmMgfCAxMSArKysrKysrKysrLQo+ICDCoDEgZmlsZSBjaGFuZ2VkLCAxMCBpbnNl
cnRpb25zKCspLCAxIGRlbGV0aW9uKC0pCj4gCj4gZGlmZiAtLWdpdCBhL3ZpcnQva3ZtL2FybS9t
bXUuYyBiL3ZpcnQva3ZtL2FybS9tbXUuYwo+IGluZGV4IDI3Yzk1ODMuLjVlMWIyNTggMTAwNjQ0
Cj4gLS0tIGEvdmlydC9rdm0vYXJtL21tdS5jCj4gKysrIGIvdmlydC9rdm0vYXJtL21tdS5jCj4g
QEAgLTE2MzIsNiArMTYzMiwxNSBAQCBzdGF0aWMgYm9vbCAKPiBmYXVsdF9zdXBwb3J0c19zdGFn
ZTJfaHVnZV9tYXBwaW5nKHN0cnVjdCBrdm1fbWVtb3J5X3Nsb3QgKm1lbXNsb3QsCj4gIMKgwqDC
oMKgIHVhZGRyX2VuZCA9IHVhZGRyX3N0YXJ0ICsgc2l6ZTsKPiAKPiAgwqDCoMKgwqAgLyoKPiAr
wqDCoMKgwqAgKiBJZiB0aGUgbWVtc2xvdCBpcyBfbm90XyBiYWNrZWQgYnkgaHVnZXRsYmZzLCB0
aGVuIGNoZWNrIGlmIGl0Cj4gK8KgwqDCoMKgICogY2FuIGJlIGJhY2tlZCBieSB0cmFuc3BhcmVu
dCBodWdlcGFnZXMuCj4gK8KgwqDCoMKgICoKPiArwqDCoMKgwqAgKiBDdXJyZW50bHkgb25seSBQ
TURfU0laRSBUSFBzIGFyZSBzdXBwb3J0ZWQsIHJldmlzaXQgaXQgbGF0ZXIuCj4gK8KgwqDCoMKg
ICovCj4gK8KgwqDCoCBpZiAobWFwX3NpemUgPT0gUEFHRV9TSVpFKQo+ICvCoMKgwqDCoMKgwqDC
oCBtYXBfc2l6ZSA9IFBNRF9TSVpFOwo+ICsKClRoaXMgbG9va3MgaGFja2lzaC4gV2hhdCBpcyB3
ZSBzdXBwb3J0IFBVRF9TSVpFIGh1Z2UgcGFnZSBpbiB0aGUgZnV0dXJlCj8KCj4gK8KgwqDCoCAv
Kgo+ICDCoMKgwqDCoMKgICogUGFnZXMgYmVsb25naW5nIHRvIG1lbXNsb3RzIHRoYXQgZG9uJ3Qg
aGF2ZSB0aGUgc2FtZSBhbGlnbm1lbnQKPiAgwqDCoMKgwqDCoCAqIHdpdGhpbiBhIFBNRC9QVUQg
Zm9yIHVzZXJzcGFjZSBhbmQgSVBBIGNhbm5vdCBiZSBtYXBwZWQgd2l0aCAKPiBzdGFnZS0yCj4g
IMKgwqDCoMKgwqAgKiBQTUQvUFVEIGVudHJpZXMsIGJlY2F1c2Ugd2UnbGwgZW5kIHVwIG1hcHBp
bmcgdGhlIHdyb25nIHBhZ2VzLgo+IEBAIC0xNjQzLDcgKzE2NTIsNyBAQCBzdGF0aWMgYm9vbCAK
PiBmYXVsdF9zdXBwb3J0c19zdGFnZTJfaHVnZV9tYXBwaW5nKHN0cnVjdCBrdm1fbWVtb3J5X3Ns
b3QgKm1lbXNsb3QsCj4gIMKgwqDCoMKgwqAgKsKgwqDCoCB8YWJjZGV8ZmdowqAgU3RhZ2UtMSBi
bG9ja8KgIHzCoMKgwqAgU3RhZ2UtMSBibG9jayB0dnx4eXp8Cj4gIMKgwqDCoMKgwqAgKsKgwqDC
oCArLS0tLS0rLS0tLS0tLS0tLS0tLS0tLS0tLS0rLS0tLS0tLS0tLS0tLS0tLS0tLS0rLS0tKwo+
ICDCoMKgwqDCoMKgICoKPiAtwqDCoMKgwqAgKsKgwqDCoCBtZW1zbG90LT5iYXNlX2dmbiA8PCBQ
QUdFX1NJWkU6Cj4gK8KgwqDCoMKgICrCoMKgwqAgbWVtc2xvdC0+YmFzZV9nZm4gPDwgUEFHRV9T
SElGVDoKClRoYXQgY291bGQgYmUgZml4ZWQuCgo+ICDCoMKgwqDCoMKgICrCoMKgwqDCoMKgICst
LS0rLS0tLS0tLS0tLS0tLS0tLS0tLS0rLS0tLS0tLS0tLS0tLS0tLS0tLS0rLS0tLS0rCj4gIMKg
wqDCoMKgwqAgKsKgwqDCoMKgwqAgfGFiY3xkZWbCoCBTdGFnZS0yIGJsb2NrwqAgfMKgwqDCoCBT
dGFnZS0yIGJsb2NrwqDCoCB8dHZ4eXp8Cj4gIMKgwqDCoMKgwqAgKsKgwqDCoMKgwqAgKy0tLSst
LS0tLS0tLS0tLS0tLS0tLS0tLSstLS0tLS0tLS0tLS0tLS0tLS0tLSstLS0tLSsKCgpCdXQgcGVy
c29uYWxseSBJIGRvbid0IHRoaW5rIHRoaXMgaXMgdGhlIHJpZ2h0IHdheSB0byBmaXggaXQuIEFu
ZCBhcwptZW50aW9uZWQsIHRoZSBWTV9CVUdfT04oKSBpcyB1bm5lY2Vzc2FyeSBhbmQgY291bGQg
ZWFzaWx5IGJlIHRyaWdnZXJlZApieSB0aGUgdXNlciBieSB1c2luZyB1bmFsaWduZWQgR1BBL0hW
QS4gQWxsIHdlIG5lZWQgdG8gZG8gaXMsIHVzZSBwYWdlCm1hcHBpbmcgaW4gc3VjaCBjYXNlcywg
d2hpY2ggd2UgZG8gd2l0aCBteSBwYXRjaC4KCgpDaGVlcnMKU3V6dWtpCl9fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fCmt2bWFybSBtYWlsaW5nIGxpc3QKa3Zt
YXJtQGxpc3RzLmNzLmNvbHVtYmlhLmVkdQpodHRwczovL2xpc3RzLmNzLmNvbHVtYmlhLmVkdS9t
YWlsbWFuL2xpc3RpbmZvL2t2bWFybQo=
