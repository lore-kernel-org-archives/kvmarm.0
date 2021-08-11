Return-Path: <SRS0=13S2=NC=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C82BDC4338F
	for <kvmarm@archiver.kernel.org>; Wed, 11 Aug 2021 09:36:59 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 58E3060F21
	for <kvmarm@archiver.kernel.org>; Wed, 11 Aug 2021 09:36:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 58E3060F21
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id EEDDD49F83;
	Wed, 11 Aug 2021 05:36:58 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id m8jBhe1OoNbQ; Wed, 11 Aug 2021 05:36:53 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id ACF2849E8C;
	Wed, 11 Aug 2021 05:36:53 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DE03A4A319
 for <kvmarm@lists.cs.columbia.edu>; Wed, 11 Aug 2021 05:36:51 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 94XYHpSPm8Jo for <kvmarm@lists.cs.columbia.edu>;
 Wed, 11 Aug 2021 05:36:47 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5A9B4405D8
 for <kvmarm@lists.cs.columbia.edu>; Wed, 11 Aug 2021 05:36:47 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id D657D113E;
 Wed, 11 Aug 2021 02:36:46 -0700 (PDT)
Received: from [10.163.67.241] (unknown [10.163.67.241])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 736E53F70D;
 Wed, 11 Aug 2021 02:36:44 -0700 (PDT)
Subject: Re: [PATCH 1/5] KVM: arm64: Drop direct PAGE_[SHIFT|SIZE] usage as
 page size
To: Marc Zyngier <maz@kernel.org>
References: <1628578961-29097-1-git-send-email-anshuman.khandual@arm.com>
 <1628578961-29097-2-git-send-email-anshuman.khandual@arm.com>
 <25ee7799069492f2501003faec7f9732@kernel.org>
 <0b47c654-7e9b-a7ca-bdf4-f9607062200e@arm.com> <87zgto9z9i.wl-maz@kernel.org>
From: Anshuman Khandual <anshuman.khandual@arm.com>
Message-ID: <4a4d320e-f09c-5198-d3cb-397d837190b1@arm.com>
Date: Wed, 11 Aug 2021 15:07:36 +0530
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <87zgto9z9i.wl-maz@kernel.org>
Content-Language: en-US
Cc: Will Deacon <will@kernel.org>, linux-kernel@vger.kernel.org,
 Catalin Marinas <catalin.marinas@arm.com>, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org
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

CgpPbiA4LzExLzIxIDE6NDEgUE0sIE1hcmMgWnluZ2llciB3cm90ZToKPiBPbiBXZWQsIDExIEF1
ZyAyMDIxIDA2OjM0OjQ2ICswMTAwLAo+IEFuc2h1bWFuIEtoYW5kdWFsIDxhbnNodW1hbi5raGFu
ZHVhbEBhcm0uY29tPiB3cm90ZToKPj4KPj4KPj4KPj4gT24gOC8xMC8yMSA3OjAzIFBNLCBNYXJj
IFp5bmdpZXIgd3JvdGU6Cj4+PiBPbiAyMDIxLTA4LTEwIDA4OjAyLCBBbnNodW1hbiBLaGFuZHVh
bCB3cm90ZToKPj4+PiBBbGwgaW5zdGFuY2VzIGhlcmUgY291bGQganVzdCBkaXJlY3RseSB0ZXN0
IGFnYWluc3QgQ09ORklHX0FSTTY0X1hYS19QQUdFUwo+Pj4+IGluc3RlYWQgb2YgZXZhbHVhdGlu
ZyB2aWEgUEFHRV9TSElGVCBvciBQQUdFX1NJWkUuIFdpdGggdGhpcyBjaGFuZ2UsIHRoZXJlCj4+
Pj4gd2lsbCBiZSBubyBzdWNoIHVzYWdlIGxlZnQuCj4+Pj4KPj4+PiBDYzogTWFyYyBaeW5naWVy
IDxtYXpAa2VybmVsLm9yZz4KPj4+PiBDYzogSmFtZXMgTW9yc2UgPGphbWVzLm1vcnNlQGFybS5j
b20+Cj4+Pj4gQ2M6IEFsZXhhbmRydSBFbGlzZWkgPGFsZXhhbmRydS5lbGlzZWlAYXJtLmNvbT4K
Pj4+PiBDYzogU3V6dWtpIEsgUG91bG9zZSA8c3V6dWtpLnBvdWxvc2VAYXJtLmNvbT4KPj4+PiBD
YzogQ2F0YWxpbiBNYXJpbmFzIDxjYXRhbGluLm1hcmluYXNAYXJtLmNvbT4KPj4+PiBDYzogV2ls
bCBEZWFjb24gPHdpbGxAa2VybmVsLm9yZz4KPj4+PiBDYzogbGludXgtYXJtLWtlcm5lbEBsaXN0
cy5pbmZyYWRlYWQub3JnCj4+Pj4gQ2M6IGt2bWFybUBsaXN0cy5jcy5jb2x1bWJpYS5lZHUKPj4+
PiBDYzogbGludXgta2VybmVsQHZnZXIua2VybmVsLm9yZwo+Pj4+IFNpZ25lZC1vZmYtYnk6IEFu
c2h1bWFuIEtoYW5kdWFsIDxhbnNodW1hbi5raGFuZHVhbEBhcm0uY29tPgo+Pj4+IC0tLQo+Pj4+
IMKgYXJjaC9hcm02NC9rdm0vaHlwL3BndGFibGUuYyB8IDYgKysrLS0tCj4+Pj4gwqBhcmNoL2Fy
bTY0L21tL21tdS5jwqDCoMKgwqDCoMKgwqDCoMKgIHwgMiArLQo+Pj4+IMKgMiBmaWxlcyBjaGFu
Z2VkLCA0IGluc2VydGlvbnMoKyksIDQgZGVsZXRpb25zKC0pCj4+Pj4KPj4+PiBkaWZmIC0tZ2l0
IGEvYXJjaC9hcm02NC9rdm0vaHlwL3BndGFibGUuYyBiL2FyY2gvYXJtNjQva3ZtL2h5cC9wZ3Rh
YmxlLmMKPj4+PiBpbmRleCAwNTMyMWY0MTY1ZTMuLmE2MTEyYjZkNmVmNiAxMDA2NDQKPj4+PiAt
LS0gYS9hcmNoL2FybTY0L2t2bS9oeXAvcGd0YWJsZS5jCj4+Pj4gKysrIGIvYXJjaC9hcm02NC9r
dm0vaHlwL3BndGFibGUuYwo+Pj4+IEBAIC04NSw3ICs4NSw3IEBAIHN0YXRpYyBib29sIGt2bV9s
ZXZlbF9zdXBwb3J0c19ibG9ja19tYXBwaW5nKHUzMiBsZXZlbCkKPj4+PiDCoMKgwqDCoMKgICog
UmVqZWN0IGludmFsaWQgYmxvY2sgbWFwcGluZ3MgYW5kIGRvbid0IGJvdGhlciB3aXRoIDRUQiBt
YXBwaW5ncyBmb3IKPj4+PiDCoMKgwqDCoMKgICogNTItYml0IFBBcy4KPj4+PiDCoMKgwqDCoMKg
ICovCj4+Pj4gLcKgwqDCoCByZXR1cm4gIShsZXZlbCA9PSAwIHx8IChQQUdFX1NJWkUgIT0gU1pf
NEsgJiYgbGV2ZWwgPT0gMSkpOwo+Pj4+ICvCoMKgwqAgcmV0dXJuICEobGV2ZWwgPT0gMCB8fCAo
IUlTX0VOQUJMRUQoQ09ORklHX0FSTTY0XzRLX1BBR0VTKSAmJiBsZXZlbCA9PSAxKSk7Cj4+Pj4g
wqB9Cj4+Pj4KPj4+PiDCoHN0YXRpYyBib29sIGt2bV9ibG9ja19tYXBwaW5nX3N1cHBvcnRlZCh1
NjQgYWRkciwgdTY0IGVuZCwgdTY0IHBoeXMsIHUzMiBsZXZlbCkKPj4+PiBAQCAtMTU1LDcgKzE1
NSw3IEBAIHN0YXRpYyB1NjQga3ZtX3B0ZV90b19waHlzKGt2bV9wdGVfdCBwdGUpCj4+Pj4gwqB7
Cj4+Pj4gwqDCoMKgwqAgdTY0IHBhID0gcHRlICYgS1ZNX1BURV9BRERSX01BU0s7Cj4+Pj4KPj4+
PiAtwqDCoMKgIGlmIChQQUdFX1NISUZUID09IDE2KQo+Pj4+ICvCoMKgwqAgaWYgKElTX0VOQUJM
RUQoQ09ORklHX0FSTTY0XzY0S19QQUdFUykpCj4+Pj4gwqDCoMKgwqDCoMKgwqDCoCBwYSB8PSBG
SUVMRF9HRVQoS1ZNX1BURV9BRERSXzUxXzQ4LCBwdGUpIDw8IDQ4Owo+Pj4+Cj4+Pj4gwqDCoMKg
wqAgcmV0dXJuIHBhOwo+Pj4+IEBAIC0xNjUsNyArMTY1LDcgQEAgc3RhdGljIGt2bV9wdGVfdCBr
dm1fcGh5c190b19wdGUodTY0IHBhKQo+Pj4+IMKgewo+Pj4+IMKgwqDCoMKgIGt2bV9wdGVfdCBw
dGUgPSBwYSAmIEtWTV9QVEVfQUREUl9NQVNLOwo+Pj4+Cj4+Pj4gLcKgwqDCoCBpZiAoUEFHRV9T
SElGVCA9PSAxNikKPj4+PiArwqDCoMKgIGlmIChJU19FTkFCTEVEKENPTkZJR19BUk02NF82NEtf
UEFHRVMpKQo+Pj4+IMKgwqDCoMKgwqDCoMKgwqAgcHRlIHw9IEZJRUxEX1BSRVAoS1ZNX1BURV9B
RERSXzUxXzQ4LCBwYSA+PiA0OCk7Cj4+Pj4KPj4+PiDCoMKgwqDCoCByZXR1cm4gcHRlOwo+Pj4+
IGRpZmYgLS1naXQgYS9hcmNoL2FybTY0L21tL21tdS5jIGIvYXJjaC9hcm02NC9tbS9tbXUuYwo+
Pj4+IGluZGV4IDlmZjBkZTFiMmI5My4uOGZkZmNhMTc5ODE1IDEwMDY0NAo+Pj4+IC0tLSBhL2Fy
Y2gvYXJtNjQvbW0vbW11LmMKPj4+PiArKysgYi9hcmNoL2FybTY0L21tL21tdS5jCj4+Pj4gQEAg
LTI5Niw3ICsyOTYsNyBAQCBzdGF0aWMgdm9pZCBhbGxvY19pbml0X2NvbnRfcG1kKHB1ZF90ICpw
dWRwLAo+Pj4+IHVuc2lnbmVkIGxvbmcgYWRkciwKPj4+PiDCoHN0YXRpYyBpbmxpbmUgYm9vbCB1
c2VfMUdfYmxvY2sodW5zaWduZWQgbG9uZyBhZGRyLCB1bnNpZ25lZCBsb25nIG5leHQsCj4+Pj4g
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIHVuc2lnbmVkIGxvbmcgcGh5cykKPj4+PiDCoHsKPj4+
PiAtwqDCoMKgIGlmIChQQUdFX1NISUZUICE9IDEyKQo+Pj4+ICvCoMKgwqAgaWYgKCFJU19FTkFC
TEVEKENPTkZJR19BUk02NF80S19QQUdFUykpCj4+Pj4gwqDCoMKgwqDCoMKgwqDCoCByZXR1cm4g
ZmFsc2U7Cj4+Pj4KPj4+PiDCoMKgwqDCoCBpZiAoKChhZGRyIHwgbmV4dCB8IHBoeXMpICYgflBV
RF9NQVNLKSAhPSAwKQo+Pj4KPj4+IEkgcGVyc29uYWxseSBmaW5kIGl0IGEgbG90IGxlc3MgcmVh
ZGFibGUuCj4+Pgo+Pj4gQWxzbywgdGhlcmUgaXMgbm8gZXZhbHVhdGlvbiB3aGF0c29ldmVyLiBB
bGwgdGhlIGNvZGUgZ3VhcmRlZAo+Pj4gYnkgYSBQQUdFX1NJWkUvUEFHRV9TSElGVCB0aGF0IGRv
ZXNuJ3QgbWF0Y2ggdGhlIGNvbmZpZ3VyYXRpb24KPj4+IGlzIGRyb3BwZWQgYXQgY29tcGlsZSB0
aW1lLgo+Pgo+PiBUaGUgcHJpbWFyeSBpZGVhIGhlcmUgaXMgdG8gdW5pZnkgYXJvdW5kIElTX0VO
QUJMRUQoQ09ORklHX0FSTTY0X1hYS19QQUdFUykKPj4gdXNhZ2UgaW4gYXJtNjQsIHJhdGhlciB0
aGFuIGhhdmluZyBtdWx0aXBsZSBtZXRob2RzIHRvIHRlc3QgcGFnZSBzaXplIHdoZW4KPj4gZXZl
ciByZXF1aXJlZC4KPiAKPiBJJ20gc29ycnksIGJ1dCBJIGZpbmQgdGhlIGlkaW9tIGV4dHJlbWVs
eSBwYWluZnVsIHRvIHBhcnNlLiBJZiB5b3UgYXJlCgpPa2F5LCBpdCB3YXMgbm90IGV4cGxhaW5l
ZCB2ZXJ5IHdlbGwuIE15IGJhZC4KCj4gYW5ub3llZCB3aXRoIHRoZSAnUEFHRV9TSElGVCA9PSAx
Mi8xNC8xNicsIGNvbnNpZGVyIHJlcGxhY2luZyBpdCB3aXRoCj4gJ1BBR0VfU0laRSA9PSBTWl80
LzE2LzY0SycgaW5zdGVhZC4KClN1cmUsIHVuZGVyc3Rvb2QuIEJ1dCB0aGUgcHJvYmxlbSBoZXJl
IGlzIG5vdCB3aXRoIFBBR0VfU0hJRlQvUEFHRV9TSVpFCmJhc2VkIHRlc3RzIGJ1dCByYXRoZXIg
aGF2aW5nIG11bHRpcGxlIHdheXMgb2YgZG9pbmcgdGhlIHNhbWUgdGhpbmcgaW4KYXJtNjQgdHJl
ZS4gUGxlYXNlIGZpbmQgZnVydGhlciBleHBsYW5hdGlvbiBiZWxvdy4KCj4gCj4gSVNfRU5BQkxF
RChDT05GSUdfQVJNNjRfWFhLX1BBR0VTKSBhbHNvIGdpdmVzIHRoZSB3cm9uZyBpbXByZXNzaW9u
Cj4gdGhhdCAqbXVsdGlwbGUqIHBhZ2Ugc2l6ZXMgY2FuIGJlIHNlbGVjdGVkIGF0IGFueSBnaXZl
biB0aW1lLiBUaGF0J3MKPiBvYnZpb3VzbHkgbm90IHRoZSBjYXNlLCB3aGljaCBhY3R1YWxseSBt
YWtlcyBQQUdFX1NJWkUgYSBtdWNoIGJldHRlcgo+IGNob2ljZS4KClBBR0VfU0hJRlQgYW5kIFBB
R0VfU0laRSBhcmUgZGVyaXZlZCBmcm9tIENPTkZJR19BUk02NF9YWEtfUEFHRVMuIEhlbmNlCndo
eSBub3QganVzdCBkaXJlY3RseSB1c2UgdGhlIG9yaWdpbmFsIHVzZXIgc2VsZWN0ZWQgY29uZmln
IG9wdGlvbiB0aGF0CmV2ZW50dWFsbHkgZGVjaWRlcyBQQUdFX1NISUZUIGFuZCBQQUdFX1NJWkUu
Cgpjb25maWcgQVJNNjRfUEFHRV9TSElGVAogICAgICAgIGludAogICAgICAgIGRlZmF1bHQgMTYg
aWYgQVJNNjRfNjRLX1BBR0VTCiAgICAgICAgZGVmYXVsdCAxNCBpZiBBUk02NF8xNktfUEFHRVMK
ICAgICAgICBkZWZhdWx0IDEyCgphcmNoL2FybTY0L2luY2x1ZGUvYXNtL3BhZ2UtZGVmLmg6I2Rl
ZmluZSBQQUdFX1NISUZUCUNPTkZJR19BUk02NF9QQUdFX1NISUZUCmFyY2gvYXJtNjQvaW5jbHVk
ZS9hc20vcGFnZS1kZWYuaDojZGVmaW5lIFBBR0VfU0laRQkoX0FDKDEsIFVMKSA8PCBQQUdFX1NI
SUZUKQoKQWxzbyB0aGVyZSBhcmUgYWxyZWFkeSBzaW1pbGFyIElTX0VOQUJMRUQoKSBpbnN0YW5j
ZXMgd2hpY2ggZG8gbm90CmNyZWF0ZSBtdWNoIGNvbmZ1c2lvbi4gVGhlIHBvaW50IGhlcmUgYmVp
bmcsIHRvIGhhdmUganVzdCBhIHNpbmdsZQptZXRob2QgdGhhdCBjaGVja3MgY29tcGlsZWQgcGFn
ZSBzaXplIHN1cHBvcnQsIGluc3RlYWQgb2YgdGhyZWUKZGlmZmVyZW50IHdheXMgb2YgZG9pbmcg
dGhlIHNhbWUgdGhpbmcuCgotIElTX0VOQUJMRUQoQ09ORklHX0FSTTY0X1hYS19QQUdFUykKLSBp
ZiAoUEFHRV9TSElGVCA9PSBYWCkKLSBpZiAoUEFHRV9TSVpFID09IFhYKQoKJGdpdCBncmVwIElT
X0VOQUJMRUQgYXJjaC9hcm02NC8gfCBncmVwIFBBR0VTCgphcmNoL2FybTY0L2luY2x1ZGUvYXNt
L3ZtYWxsb2MuaDoJcmV0dXJuIElTX0VOQUJMRUQoQ09ORklHX0FSTTY0XzRLX1BBR0VTKSAmJgph
cmNoL2FybTY0L21tL21tdS5jOgkJQlVHX09OKCFJU19FTkFCTEVEKENPTkZJR19BUk02NF8xNktf
UEFHRVMpKTsKYXJjaC9hcm02NC9tbS9tbXUuYzoJCUJVR19PTighSVNfRU5BQkxFRChDT05GSUdf
QVJNNjRfMTZLX1BBR0VTKSk7Cgo+IAo+IEFzIHRoaW5ncyBzdGFuZCwgSSBkb24ndCBwbGFuIHRv
IHRha2Ugc3VjaCBhIHBhdGNoLgoKU3VyZSwgd2lsbCBkcm9wIGl0IGZyb20gdGhlIHNlcmllcyBp
ZiB0aGUgYWJvdmUgZXhwbGFuYXRpb24gYW5kCnRoZSByYXRpb25hbGUgZm9yIHRoZSBwYXRjaCBz
dGlsbCBkb2VzIG5vdCBjb252aW5jZSB5b3UuCgo+IAo+IFRoYW5rcywKPiAKPiAJTS4KPiAKX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18Ka3ZtYXJtIG1haWxp
bmcgbGlzdAprdm1hcm1AbGlzdHMuY3MuY29sdW1iaWEuZWR1Cmh0dHBzOi8vbGlzdHMuY3MuY29s
dW1iaWEuZWR1L21haWxtYW4vbGlzdGluZm8va3ZtYXJtCg==
