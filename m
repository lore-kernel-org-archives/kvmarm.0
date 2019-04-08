Return-Path: <SRS0=T7i1=SK=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B5E19C10F14
	for <kvmarm@archiver.kernel.org>; Mon,  8 Apr 2019 18:38:01 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 46D36206C0
	for <kvmarm@archiver.kernel.org>; Mon,  8 Apr 2019 18:38:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 46D36206C0
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A2F834A47B;
	Mon,  8 Apr 2019 14:38:00 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id t3-dZuDdeSmA; Mon,  8 Apr 2019 14:37:58 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 070CF4A477;
	Mon,  8 Apr 2019 14:37:58 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 20EC54A418
 for <kvmarm@lists.cs.columbia.edu>; Mon,  8 Apr 2019 14:37:57 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id WDwnjiFPqo9n for <kvmarm@lists.cs.columbia.edu>;
 Mon,  8 Apr 2019 14:37:55 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6E63D4A3A3
 for <kvmarm@lists.cs.columbia.edu>; Mon,  8 Apr 2019 14:37:55 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.72.51.249])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 7804E15BE;
 Mon,  8 Apr 2019 11:37:54 -0700 (PDT)
Received: from [10.37.12.66] (unknown [10.37.12.66])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 1342F3F718;
 Mon,  8 Apr 2019 11:37:51 -0700 (PDT)
Subject: Re: [PATCH] kvm: arm: Skip stage2 huge mappings for unaligned ipa
 backed by THP
To: yuzenghui@huawei.com, linux-arm-kernel@lists.infradead.org
References: <1554203176-3958-1-git-send-email-suzuki.poulose@arm.com>
 <2ea55b9c-09da-c3d0-3616-aa6be85b5a46@huawei.com>
 <a9c084fb-0c84-e632-a192-b361773a0bc8@arm.com>
 <44ffad26-a407-4603-0bb6-145f7290adbe@huawei.com>
From: Suzuki K Poulose <suzuki.poulose@arm.com>
Message-ID: <730c25b4-dbc5-8d8b-514c-4ed8641701ce@arm.com>
Date: Mon, 8 Apr 2019 19:40:09 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.7.0
MIME-Version: 1.0
In-Reply-To: <44ffad26-a407-4603-0bb6-145f7290adbe@huawei.com>
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
Message-ID: <20190408184009.rrVASaq0KOyGIzqup3-mR_l9nmMAv524lClBONSlH8s@z>

SGkgWmVuaHVpLAoKT24gMDQvMDgvMjAxOSAwNDoxMSBQTSwgWmVuZ2h1aSBZdSB3cm90ZToKPiBI
aSBTdXp1a2ksCj4gCj4gVGhhbmtzIGZvciB0aGUgcmVwbHkuCj4gCgouLi4KCj4+PiBIaSBTdXp1
a2ksCj4+Pgo+Pj4gV2h5IG5vdCBtYWtpbmcgdXNlIG9mIGZhdWx0X3N1cHBvcnRzX3N0YWdlMl9o
dWdlX21hcHBpbmcoKT/CoCBMZXQgaXQgZG8KPj4+IHNvbWUgY2hlY2tzIGZvciB1cy4KPj4+Cj4+
PiBmYXVsdF9zdXBwb3J0c19zdGFnZTJfaHVnZV9tYXBwaW5nKCkgd2FzIGludGVuZGVkIHRvIGRv
IGEgKnR3by1zdGVwKgo+Pj4gY2hlY2sgdG8gdGVsbCB1cyB0aGF0IGNhbiB3ZSBjcmVhdGUgc3Rh
Z2UyIGh1Z2UgYmxvY2sgbWFwcGluZ3MsIGFuZCB0aGlzCj4+PiBjaGVjayBpcyBib3RoIGZvciBo
dWdldGxiZnMgYW5kIFRIUC7CoCBXaXRoIGNvbW1pdCBhODA4NjhmMzk4NTU0ODQyYjE0LAo+Pj4g
d2UgcGFzcyBQQUdFX1NJWkUgYXMgIm1hcF9zaXplIiBmb3Igbm9ybWFsIHNpemUgcGFnZXMgKHdo
aWNoIHR1cm5lZCBvdXQKPj4+IHRvIGJlIGFsbW9zdCBtZWFuaW5nbGVzcyksIGFuZCB1bmZvcnR1
bmF0ZWx5IHRoZSBUSFAgY2hlY2sgbm8gbG9uZ2VyCj4+PiB3b3Jrcy4KPj4KPj4gVGhhdHMgY29y
cmVjdC4KPj4KPj4+Cj4+PiBTbyB3ZSB3YW50IHRvIHJld29yayAqVEhQKiBjaGVjayBwcm9jZXNz
LsKgIFlvdXIgcGF0Y2ggZml4ZXMgdGhlIGZpcnN0Cj4+PiBjaGVja2luZy1zdGVwLCBidXQgdGhl
IHNlY29uZCBpcyBzdGlsbCBtaXNzZWQsIGFtIEkgd3Jvbmc/Cj4+Cj4+IEl0IGZpeGVzIHRoZSBz
dGVwIGV4cGxpY2l0bHkgZm9yIHRoZSBUSFAgYnkgbWFraW5nIHN1cmUgdGhhdCB0aGUgR1BBIGFu
ZAo+PiB0aGUgSFZBIGFyZSBhbGlnbmVkIHRvIHRoZSBtYXAgc2l6ZS4KPiAKPiBZZXMsIEkgdW5k
ZXJzdGFuZCBob3cgeW91ciBwYXRjaCBoYWQgZml4ZWQgdGhlIGlzc3VlLsKgIEJ1dCB3aGF0IEkn
bQo+IHJlYWxseSBjb25jZXJuZWQgYWJvdXQgaGVyZSBpcyB0aGUgKnNlY29uZCogY2hlY2tpbmct
c3RlcCBpbgo+IGZhdWx0X3N1cHBvcnRzX3N0YWdlMl9odWdlX21hcHBpbmcoKS4KPiAKPiBXZSBo
YXZlIHRvIGNoZWNrIGlmIHdlIGFyZSBtYXBwaW5nIGEgbm9uLWJsb2NrIGFsaWduZWQgb3Igbm9u
LWJsb2NrCj4gc2l6ZWQgbWVtc2xvdCwgaWYgc28sIHdlIGNhbiBub3QgY3JlYXRlIGJsb2NrIG1h
cHBpbmdzIGZvciB0aGUgYmVnaW5uaW5nCj4gYW5kIGVuZCBvZiB0aGlzIG1lbXNsb3QuwqAgVGhp
cyBpcyB3aGF0IHRoZSBzZWNvbmQgcGFydCBvZgo+IGZhdWx0X3N1cHBvcnRzX3N0YWdlMl9odWdl
X21hcHBpbmcoKSBoYWQgZG9uZS4KPiAKPiBJIGhhdmVuJ3Qgc2VlbiB0aGlzIGNoZWNraW5nLXN0
ZXAgaW4geW91ciBwYXRjaCwgZGlkIEkgbWlzcyBzb21ldGhpbmc/Cj4gCgpJIHNlZS4KCj4+IEkg
ZG9uJ3QgdGhpbmsgdGhpcyBjYWxscyBmb3IgYSBWTV9CVUdfT04oKS4gSXQgaXMgc2ltcGx5IGEg
Y2FzZSB3aGVyZQo+PiB0aGUgR1BBIGlzIG5vdCBhbGlnbmVkIHRvIEhWQSwgYnV0IGZvciBub3Jt
YWwgVk1BIHRoYXQgY291bGQgYmUgbWFkZSBUSFAuCj4+Cj4+IFdlIGhhZCB0aGlzIFZNX0JVR19P
TigpLCB3aGljaCB3b3VsZCBoYXZlIG5ldmVyIGhpdCBiZWNhdXNlIHdlIHdvdWxkCj4+IGhhdmUg
c2V0IGZvcmNlX3B0ZSBpZiB0aGV5IHdlcmUgbm90IGFsaWduZWQuCj4gCj4gWWVzLCBJIGFncmVl
Lgo+IAo+Pj4+ICvCoMKgwqDCoMKgwqDCoCAvKiBTa2lwIG1lbXNsb3RzIHdpdGggdW5hbGlnbmVk
IElQQSBhbmQgdXNlciBhZGRyZXNzICovCj4+Pj4gK8KgwqDCoMKgwqDCoMKgIGlmICgoZ2ZuICYg
bWFzaykgIT0gKHBmbiAmIG1hc2spKQo+Pj4+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIHJldHVy
biBmYWxzZTsKPj4+PiDCoMKgwqDCoMKgwqDCoMKgwqAgaWYgKHBmbiAmIG1hc2spIHsKPj4+PiDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCAqaXBhcCAmPSBQTURfTUFTSzsKPj4+PiDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoCBrdm1fcmVsZWFzZV9wZm5fY2xlYW4ocGZuKTsKPj4+Pgo+Pj4K
Pj4+IC0tLTg+LS0tCj4+Pgo+Pj4gUmV3b3JrIGZhdWx0X3N1cHBvcnRzX3N0YWdlMl9odWdlX21h
cHBpbmcoKSwgbGV0IGl0IGNoZWNrIFRIUCBhZ2Fpbi4KPj4+Cj4+PiBTaWduZWQtb2ZmLWJ5OiBa
ZW5naHVpIFl1IDx5dXplbmdodWlAaHVhd2VpLmNvbT4KPj4+IC0tLQo+Pj4gwqDCoHZpcnQva3Zt
L2FybS9tbXUuYyB8IDExICsrKysrKysrKystCj4+PiDCoMKgMSBmaWxlIGNoYW5nZWQsIDEwIGlu
c2VydGlvbnMoKyksIDEgZGVsZXRpb24oLSkKPj4+Cj4+PiBkaWZmIC0tZ2l0IGEvdmlydC9rdm0v
YXJtL21tdS5jIGIvdmlydC9rdm0vYXJtL21tdS5jCj4+PiBpbmRleCAyN2M5NTgzLi41ZTFiMjU4
IDEwMDY0NAo+Pj4gLS0tIGEvdmlydC9rdm0vYXJtL21tdS5jCj4+PiArKysgYi92aXJ0L2t2bS9h
cm0vbW11LmMKPj4+IEBAIC0xNjMyLDYgKzE2MzIsMTUgQEAgc3RhdGljIGJvb2wgCj4+PiBmYXVs
dF9zdXBwb3J0c19zdGFnZTJfaHVnZV9tYXBwaW5nKHN0cnVjdCBrdm1fbWVtb3J5X3Nsb3QgKm1l
bXNsb3QsCj4+PiDCoMKgwqDCoMKgIHVhZGRyX2VuZCA9IHVhZGRyX3N0YXJ0ICsgc2l6ZTsKPj4+
Cj4+PiDCoMKgwqDCoMKgIC8qCj4+PiArwqDCoMKgwqAgKiBJZiB0aGUgbWVtc2xvdCBpcyBfbm90
XyBiYWNrZWQgYnkgaHVnZXRsYmZzLCB0aGVuIGNoZWNrIGlmIGl0Cj4+PiArwqDCoMKgwqAgKiBj
YW4gYmUgYmFja2VkIGJ5IHRyYW5zcGFyZW50IGh1Z2VwYWdlcy4KPj4+ICvCoMKgwqDCoCAqCj4+
PiArwqDCoMKgwqAgKiBDdXJyZW50bHkgb25seSBQTURfU0laRSBUSFBzIGFyZSBzdXBwb3J0ZWQs
IHJldmlzaXQgaXQgbGF0ZXIuCj4+PiArwqDCoMKgwqAgKi8KPj4+ICvCoMKgwqAgaWYgKG1hcF9z
aXplID09IFBBR0VfU0laRSkKPj4+ICvCoMKgwqDCoMKgwqDCoCBtYXBfc2l6ZSA9IFBNRF9TSVpF
Owo+Pj4gKwo+Pgo+PiBUaGlzIGxvb2tzIGhhY2tpc2guIFdoYXQgaXMgd2Ugc3VwcG9ydCBQVURf
U0laRSBodWdlIHBhZ2UgaW4gdGhlIGZ1dHVyZQo+PiA/Cj4gCj4gWWVzLCB0aGlzIG1pZ2h0IG1h
a2UgdGhlIGNvZGUgYSBsaXR0bGUgZGlmZmljdWx0IHRvIHVuZGVyc3RhbmQuIEJ1dCBieQo+IGRv
aW5nIHNvLCB3ZSBmb2xsb3cgdGhlIHNhbWUgbG9naWMgYmVmb3JlIGNvbW1pdCBhODA4NjhmMzk4
NTU0ODQyYjE0LAo+IHRoYXQgc2FpZCwgd2UgZG8gdGhlIHR3by1zdGVwIGNoZWNraW5nIGZvciBu
b3JtYWwgc2l6ZSBwYWdlcyBpbgo+IGZhdWx0X3N1cHBvcnRzX3N0YWdlMl9odWdlX21hcHBpbmco
KSwgdG8gZGVjaWRlIGlmIHdlIGNhbiBjcmVhdGUgVEhQCj4gbWFwcGluZ3MgZm9yIHRoZXNlIHBh
Z2VzLgo+IAo+IEFzIGZvciBQVURfU0laRSBUSFBzLCB0byBiZSBob25lc3QsIEkgaGF2ZSBubyBp
ZGVhIG5vdyA6KAoKSG93IGFib3V0IHRoZSBmb2xsb3dpbmcgZGlmZiA/CgpkaWZmIC0tZ2l0IGEv
dmlydC9rdm0vYXJtL21tdS5jIGIvdmlydC9rdm0vYXJtL21tdS5jCmluZGV4IDk3YjU0MTcuLjk4
ZTVjZWMgMTAwNjQ0Ci0tLSBhL3ZpcnQva3ZtL2FybS9tbXUuYworKysgYi92aXJ0L2t2bS9hcm0v
bW11LmMKQEAgLTE3OTEsNyArMTc5MSw4IEBAIHN0YXRpYyBpbnQgdXNlcl9tZW1fYWJvcnQoc3Ry
dWN0IGt2bV92Y3B1ICp2Y3B1LCAKcGh5c19hZGRyX3QgZmF1bHRfaXBhLAogIAkJICogY3VycmVu
dGx5IHN1cHBvcnRlZC4gVGhpcyBjb2RlIHdpbGwgbmVlZCB0byBiZQogIAkJICogdXBkYXRlZCB0
byBzdXBwb3J0IG90aGVyIFRIUCBzaXplcy4KICAJCSAqLwotCQlpZiAodHJhbnNwYXJlbnRfaHVn
ZXBhZ2VfYWRqdXN0KCZwZm4sICZmYXVsdF9pcGEpKQorCQlpZiAoZmF1bHRfc3VwcG9ydHNfc3Rh
Z2UyX2h1Z2VfbWFwcGluZ3MobWVtc2xvdCwgaHZhLCBQTURfU0laRSkgJiYKKwkJICAgIHRyYW5z
cGFyZW50X2h1Z2VwYWdlX2FkanVzdCgmcGZuLCAmZmF1bHRfaXBhKSkKICAJCQl2bWFfcGFnZXNp
emUgPSBQTURfU0laRTsKICAJfQoKLS0gCjIuNy40CgoKClN1enVraQpfX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXwprdm1hcm0gbWFpbGluZyBsaXN0Cmt2bWFy
bUBsaXN0cy5jcy5jb2x1bWJpYS5lZHUKaHR0cHM6Ly9saXN0cy5jcy5jb2x1bWJpYS5lZHUvbWFp
bG1hbi9saXN0aW5mby9rdm1hcm0K
