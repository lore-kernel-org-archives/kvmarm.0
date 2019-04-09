Return-Path: <SRS0=N2lg=SL=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2B04AC10F0E
	for <kvmarm@archiver.kernel.org>; Tue,  9 Apr 2019 14:57:10 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id A7B2A20833
	for <kvmarm@archiver.kernel.org>; Tue,  9 Apr 2019 14:57:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A7B2A20833
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id F10EE4A44E;
	Tue,  9 Apr 2019 10:57:08 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id XVB8Yty4stse; Tue,  9 Apr 2019 10:57:06 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9454D4A479;
	Tue,  9 Apr 2019 10:57:06 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 356A94A36D
 for <kvmarm@lists.cs.columbia.edu>; Tue,  9 Apr 2019 10:57:05 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id KOxEKKavf8VW for <kvmarm@lists.cs.columbia.edu>;
 Tue,  9 Apr 2019 10:57:03 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7FF324A369
 for <kvmarm@lists.cs.columbia.edu>; Tue,  9 Apr 2019 10:57:03 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.72.51.249])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C7EB415AB;
 Tue,  9 Apr 2019 07:57:02 -0700 (PDT)
Received: from [10.37.12.144] (unknown [10.37.12.144])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 4ACF63F68F;
 Tue,  9 Apr 2019 07:57:00 -0700 (PDT)
Subject: Re: [PATCH] kvm: arm: Skip stage2 huge mappings for unaligned ipa
 backed by THP
To: yuzenghui@huawei.com, linux-arm-kernel@lists.infradead.org
References: <1554203176-3958-1-git-send-email-suzuki.poulose@arm.com>
 <2ea55b9c-09da-c3d0-3616-aa6be85b5a46@huawei.com>
 <a9c084fb-0c84-e632-a192-b361773a0bc8@arm.com>
 <44ffad26-a407-4603-0bb6-145f7290adbe@huawei.com>
 <730c25b4-dbc5-8d8b-514c-4ed8641701ce@arm.com>
 <1b398e29-e2d5-2a58-b4ca-c72979a170d8@huawei.com>
From: Suzuki K Poulose <suzuki.poulose@arm.com>
Message-ID: <520e277c-f096-a84b-8405-636b19e4cc46@arm.com>
Date: Tue, 9 Apr 2019 15:59:16 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.7.0
MIME-Version: 1.0
In-Reply-To: <1b398e29-e2d5-2a58-b4ca-c72979a170d8@huawei.com>
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
Message-ID: <20190409145916.hZ2MK6GckUEhjppMzMXW7XGN-362LxVHIYNbhp_Osnk@z>

SGkgWmVuZ2h1aQoKT24gMDQvMDkvMjAxOSAwOTowNSBBTSwgWmVuZ2h1aSBZdSB3cm90ZToKPiAK
PiAKPiBPbiAyMDE5LzQvOSAyOjQwLCBTdXp1a2kgSyBQb3Vsb3NlIHdyb3RlOgo+PiBIaSBaZW5o
dWksCj4+Cj4+IE9uIDA0LzA4LzIwMTkgMDQ6MTEgUE0sIFplbmdodWkgWXUgd3JvdGU6Cj4+PiBI
aSBTdXp1a2ksCj4+Pgo+Pj4gVGhhbmtzIGZvciB0aGUgcmVwbHkuCj4+Pgo+Pgo+PiAuLi4KPj4K
Pj4+Pj4gSGkgU3V6dWtpLAo+Pj4+Pgo+Pj4+PiBXaHkgbm90IG1ha2luZyB1c2Ugb2YgZmF1bHRf
c3VwcG9ydHNfc3RhZ2UyX2h1Z2VfbWFwcGluZygpP8KgIExldCBpdCBkbwo+Pj4+PiBzb21lIGNo
ZWNrcyBmb3IgdXMuCj4+Pj4+Cj4+Pj4+IGZhdWx0X3N1cHBvcnRzX3N0YWdlMl9odWdlX21hcHBp
bmcoKSB3YXMgaW50ZW5kZWQgdG8gZG8gYSAqdHdvLXN0ZXAqCj4+Pj4+IGNoZWNrIHRvIHRlbGwg
dXMgdGhhdCBjYW4gd2UgY3JlYXRlIHN0YWdlMiBodWdlIGJsb2NrIG1hcHBpbmdzLCBhbmQgCj4+
Pj4+IHRoaXMKPj4+Pj4gY2hlY2sgaXMgYm90aCBmb3IgaHVnZXRsYmZzIGFuZCBUSFAuwqAgV2l0
aCBjb21taXQgYTgwODY4ZjM5ODU1NDg0MmIxNCwKPj4+Pj4gd2UgcGFzcyBQQUdFX1NJWkUgYXMg
Im1hcF9zaXplIiBmb3Igbm9ybWFsIHNpemUgcGFnZXMgKHdoaWNoIHR1cm5lZCAKPj4+Pj4gb3V0
Cj4+Pj4+IHRvIGJlIGFsbW9zdCBtZWFuaW5nbGVzcyksIGFuZCB1bmZvcnR1bmF0ZWx5IHRoZSBU
SFAgY2hlY2sgbm8gbG9uZ2VyCj4+Pj4+IHdvcmtzLgo+Pj4+Cj4+Pj4gVGhhdHMgY29ycmVjdC4K
Pj4+Pgo+Pj4+Pgo+Pj4+PiBTbyB3ZSB3YW50IHRvIHJld29yayAqVEhQKiBjaGVjayBwcm9jZXNz
LsKgIFlvdXIgcGF0Y2ggZml4ZXMgdGhlIGZpcnN0Cj4+Pj4+IGNoZWNraW5nLXN0ZXAsIGJ1dCB0
aGUgc2Vjb25kIGlzIHN0aWxsIG1pc3NlZCwgYW0gSSB3cm9uZz8KPj4+Pgo+Pj4+IEl0IGZpeGVz
IHRoZSBzdGVwIGV4cGxpY2l0bHkgZm9yIHRoZSBUSFAgYnkgbWFraW5nIHN1cmUgdGhhdCB0aGUg
R1BBIAo+Pj4+IGFuZAo+Pj4+IHRoZSBIVkEgYXJlIGFsaWduZWQgdG8gdGhlIG1hcCBzaXplLgo+
Pj4KPj4+IFllcywgSSB1bmRlcnN0YW5kIGhvdyB5b3VyIHBhdGNoIGhhZCBmaXhlZCB0aGUgaXNz
dWUuwqAgQnV0IHdoYXQgSSdtCj4+PiByZWFsbHkgY29uY2VybmVkIGFib3V0IGhlcmUgaXMgdGhl
ICpzZWNvbmQqIGNoZWNraW5nLXN0ZXAgaW4KPj4+IGZhdWx0X3N1cHBvcnRzX3N0YWdlMl9odWdl
X21hcHBpbmcoKS4KPj4+Cj4+PiBXZSBoYXZlIHRvIGNoZWNrIGlmIHdlIGFyZSBtYXBwaW5nIGEg
bm9uLWJsb2NrIGFsaWduZWQgb3Igbm9uLWJsb2NrCj4+PiBzaXplZCBtZW1zbG90LCBpZiBzbywg
d2UgY2FuIG5vdCBjcmVhdGUgYmxvY2sgbWFwcGluZ3MgZm9yIHRoZSBiZWdpbm5pbmcKPj4+IGFu
ZCBlbmQgb2YgdGhpcyBtZW1zbG90LsKgIFRoaXMgaXMgd2hhdCB0aGUgc2Vjb25kIHBhcnQgb2YK
Pj4+IGZhdWx0X3N1cHBvcnRzX3N0YWdlMl9odWdlX21hcHBpbmcoKSBoYWQgZG9uZS4KPj4+Cj4+
PiBJIGhhdmVuJ3Qgc2VlbiB0aGlzIGNoZWNraW5nLXN0ZXAgaW4geW91ciBwYXRjaCwgZGlkIEkg
bWlzcyBzb21ldGhpbmc/Cj4+Pgo+Pgo+PiBJIHNlZS4KPj4KPj4+PiBJIGRvbid0IHRoaW5rIHRo
aXMgY2FsbHMgZm9yIGEgVk1fQlVHX09OKCkuIEl0IGlzIHNpbXBseSBhIGNhc2Ugd2hlcmUKPj4+
PiB0aGUgR1BBIGlzIG5vdCBhbGlnbmVkIHRvIEhWQSwgYnV0IGZvciBub3JtYWwgVk1BIHRoYXQg
Y291bGQgYmUgbWFkZSAKPj4+PiBUSFAuCj4+Pj4KPj4+PiBXZSBoYWQgdGhpcyBWTV9CVUdfT04o
KSwgd2hpY2ggd291bGQgaGF2ZSBuZXZlciBoaXQgYmVjYXVzZSB3ZSB3b3VsZAo+Pj4+IGhhdmUg
c2V0IGZvcmNlX3B0ZSBpZiB0aGV5IHdlcmUgbm90IGFsaWduZWQuCj4+Pgo+Pj4gWWVzLCBJIGFn
cmVlLgo+Pj4KPj4+Pj4+ICvCoMKgwqDCoMKgwqDCoCAvKiBTa2lwIG1lbXNsb3RzIHdpdGggdW5h
bGlnbmVkIElQQSBhbmQgdXNlciBhZGRyZXNzICovCj4+Pj4+PiArwqDCoMKgwqDCoMKgwqAgaWYg
KChnZm4gJiBtYXNrKSAhPSAocGZuICYgbWFzaykpCj4+Pj4+PiArwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoCByZXR1cm4gZmFsc2U7Cj4+Pj4+PiDCoMKgwqDCoMKgwqDCoMKgwqAgaWYgKHBmbiAmIG1h
c2spIHsKPj4+Pj4+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgICppcGFwICY9IFBNRF9NQVNL
Owo+Pj4+Pj4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAga3ZtX3JlbGVhc2VfcGZuX2NsZWFu
KHBmbik7Cj4+Pj4+Pgo+Pj4+Pgo+Pj4+PiAtLS04Pi0tLQo+Pj4+Pgo+Pj4+PiBSZXdvcmsgZmF1
bHRfc3VwcG9ydHNfc3RhZ2UyX2h1Z2VfbWFwcGluZygpLCBsZXQgaXQgY2hlY2sgVEhQIGFnYWlu
Lgo+Pj4+Pgo+Pj4+PiBTaWduZWQtb2ZmLWJ5OiBaZW5naHVpIFl1IDx5dXplbmdodWlAaHVhd2Vp
LmNvbT4KPj4+Pj4gLS0tCj4+Pj4+IMKgwqB2aXJ0L2t2bS9hcm0vbW11LmMgfCAxMSArKysrKysr
KysrLQo+Pj4+PiDCoMKgMSBmaWxlIGNoYW5nZWQsIDEwIGluc2VydGlvbnMoKyksIDEgZGVsZXRp
b24oLSkKPj4+Pj4KPj4+Pj4gZGlmZiAtLWdpdCBhL3ZpcnQva3ZtL2FybS9tbXUuYyBiL3ZpcnQv
a3ZtL2FybS9tbXUuYwo+Pj4+PiBpbmRleCAyN2M5NTgzLi41ZTFiMjU4IDEwMDY0NAo+Pj4+PiAt
LS0gYS92aXJ0L2t2bS9hcm0vbW11LmMKPj4+Pj4gKysrIGIvdmlydC9rdm0vYXJtL21tdS5jCj4+
Pj4+IEBAIC0xNjMyLDYgKzE2MzIsMTUgQEAgc3RhdGljIGJvb2wgCj4+Pj4+IGZhdWx0X3N1cHBv
cnRzX3N0YWdlMl9odWdlX21hcHBpbmcoc3RydWN0IGt2bV9tZW1vcnlfc2xvdCAqbWVtc2xvdCwK
Pj4+Pj4gwqDCoMKgwqDCoCB1YWRkcl9lbmQgPSB1YWRkcl9zdGFydCArIHNpemU7Cj4+Pj4+Cj4+
Pj4+IMKgwqDCoMKgwqAgLyoKPj4+Pj4gK8KgwqDCoMKgICogSWYgdGhlIG1lbXNsb3QgaXMgX25v
dF8gYmFja2VkIGJ5IGh1Z2V0bGJmcywgdGhlbiBjaGVjayBpZiBpdAo+Pj4+PiArwqDCoMKgwqAg
KiBjYW4gYmUgYmFja2VkIGJ5IHRyYW5zcGFyZW50IGh1Z2VwYWdlcy4KPj4+Pj4gK8KgwqDCoMKg
ICoKPj4+Pj4gK8KgwqDCoMKgICogQ3VycmVudGx5IG9ubHkgUE1EX1NJWkUgVEhQcyBhcmUgc3Vw
cG9ydGVkLCByZXZpc2l0IGl0IGxhdGVyLgo+Pj4+PiArwqDCoMKgwqAgKi8KPj4+Pj4gK8KgwqDC
oCBpZiAobWFwX3NpemUgPT0gUEFHRV9TSVpFKQo+Pj4+PiArwqDCoMKgwqDCoMKgwqAgbWFwX3Np
emUgPSBQTURfU0laRTsKPj4+Pj4gKwo+Pj4+Cj4+Pj4gVGhpcyBsb29rcyBoYWNraXNoLiBXaGF0
IGlzIHdlIHN1cHBvcnQgUFVEX1NJWkUgaHVnZSBwYWdlIGluIHRoZSBmdXR1cmUKPj4+PiA/Cj4+
Pgo+Pj4gWWVzLCB0aGlzIG1pZ2h0IG1ha2UgdGhlIGNvZGUgYSBsaXR0bGUgZGlmZmljdWx0IHRv
IHVuZGVyc3RhbmQuIEJ1dCBieQo+Pj4gZG9pbmcgc28sIHdlIGZvbGxvdyB0aGUgc2FtZSBsb2dp
YyBiZWZvcmUgY29tbWl0IGE4MDg2OGYzOTg1NTQ4NDJiMTQsCj4+PiB0aGF0IHNhaWQsIHdlIGRv
IHRoZSB0d28tc3RlcCBjaGVja2luZyBmb3Igbm9ybWFsIHNpemUgcGFnZXMgaW4KPj4+IGZhdWx0
X3N1cHBvcnRzX3N0YWdlMl9odWdlX21hcHBpbmcoKSwgdG8gZGVjaWRlIGlmIHdlIGNhbiBjcmVh
dGUgVEhQCj4+PiBtYXBwaW5ncyBmb3IgdGhlc2UgcGFnZXMuCj4+Pgo+Pj4gQXMgZm9yIFBVRF9T
SVpFIFRIUHMsIHRvIGJlIGhvbmVzdCwgSSBoYXZlIG5vIGlkZWEgbm93IDooCj4+Cj4+IEhvdyBh
Ym91dCB0aGUgZm9sbG93aW5nIGRpZmYgPwo+Pgo+PiBkaWZmIC0tZ2l0IGEvdmlydC9rdm0vYXJt
L21tdS5jIGIvdmlydC9rdm0vYXJtL21tdS5jCj4+IGluZGV4IDk3YjU0MTcuLjk4ZTVjZWMgMTAw
NjQ0Cj4+IC0tLSBhL3ZpcnQva3ZtL2FybS9tbXUuYwo+PiArKysgYi92aXJ0L2t2bS9hcm0vbW11
LmMKPj4gQEAgLTE3OTEsNyArMTc5MSw4IEBAIHN0YXRpYyBpbnQgdXNlcl9tZW1fYWJvcnQoc3Ry
dWN0IGt2bV92Y3B1ICp2Y3B1LCAKPj4gcGh5c19hZGRyX3QgZmF1bHRfaXBhLAo+PiDCoMKgwqDC
oMKgwqDCoMKgwqDCoCAqIGN1cnJlbnRseSBzdXBwb3J0ZWQuIFRoaXMgY29kZSB3aWxsIG5lZWQg
dG8gYmUKPj4gwqDCoMKgwqDCoMKgwqDCoMKgwqAgKiB1cGRhdGVkIHRvIHN1cHBvcnQgb3RoZXIg
VEhQIHNpemVzLgo+PiDCoMKgwqDCoMKgwqDCoMKgwqDCoCAqLwo+PiAtwqDCoMKgwqDCoMKgwqAg
aWYgKHRyYW5zcGFyZW50X2h1Z2VwYWdlX2FkanVzdCgmcGZuLCAmZmF1bHRfaXBhKSkKPj4gK8Kg
wqDCoMKgwqDCoMKgIGlmIChmYXVsdF9zdXBwb3J0c19zdGFnZTJfaHVnZV9tYXBwaW5ncyhtZW1z
bG90LCBodmEsIAo+PiBQTURfU0laRSkgJiYKPj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqAgdHJh
bnNwYXJlbnRfaHVnZXBhZ2VfYWRqdXN0KCZwZm4sICZmYXVsdF9pcGEpKQo+PiDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoCB2bWFfcGFnZXNpemUgPSBQTURfU0laRTsKPj4gwqDCoMKgwqDCoCB9
Cj4gCj4gSSB0aGluayB0aGlzIGlzIGdvb2QgZW5vdWdoIGZvciB0aGUgaXNzdWUuCj4gCj4gKE9u
ZSBtaW5vciBjb25jZXJuOiBXaXRoIHRoaXMgY2hhbmdlLCBpdCBzZWVtcyB0aGF0IHdlIG5vIGxv
bmdlciBuZWVkCj4gImZvcmNlX3B0ZSIgYW5kIGNhbiBqdXN0IHVzZSAibG9nZ2luZ19hY3RpdmUi
IGluc3RlYWQuIEJ1dCB0aGlzIGlzIG5vdAo+IG11Y2ggcmVsYXRlZCB0byB3aGF0IHdlJ3JlIGZp
eGluZy4pCgpJIHdvdWxkIHN0aWxsIGxlYXZlIHRoZSBmb3JjZV9wdGUgdGhlcmUgdG8gYXZvaWQg
Y2hlY2tpbmcgZm9yIGEgVEhQIGNhc2UKaW4gYSBzaXR1YXRpb24gd2hlcmUgd2UgZm9yY2VkIHRv
IFBURSBsZXZlbCBtYXBwaW5nIG9uIGEgaHVnZXBhZ2UgYmFja2VkClZNQS4gSXQgd291bGQgc2Vy
dmUgdG8gYXZvaWQgYW5vdGhlciBjaGVjay4KCkNoZWVycwpTdXp1a2kKCgo+IAo+IAo+IHRoYW5r
cy4KPiAKPiAKCl9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
Cmt2bWFybSBtYWlsaW5nIGxpc3QKa3ZtYXJtQGxpc3RzLmNzLmNvbHVtYmlhLmVkdQpodHRwczov
L2xpc3RzLmNzLmNvbHVtYmlhLmVkdS9tYWlsbWFuL2xpc3RpbmZvL2t2bWFybQo=
