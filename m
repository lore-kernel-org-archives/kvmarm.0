Return-Path: <SRS0=IB6K=76=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1D807C433E0
	for <kvmarm@archiver.kernel.org>; Wed, 17 Jun 2020 10:50:26 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id A31DC20720
	for <kvmarm@archiver.kernel.org>; Wed, 17 Jun 2020 10:50:25 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A31DC20720
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 346474B197;
	Wed, 17 Jun 2020 06:50:25 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id cfubH2p8-2uL; Wed, 17 Jun 2020 06:50:24 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 122DA4B1AA;
	Wed, 17 Jun 2020 06:50:24 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B33524B197
 for <kvmarm@lists.cs.columbia.edu>; Wed, 17 Jun 2020 06:50:23 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id kl49yzc1QORA for <kvmarm@lists.cs.columbia.edu>;
 Wed, 17 Jun 2020 06:50:22 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7355A4B188
 for <kvmarm@lists.cs.columbia.edu>; Wed, 17 Jun 2020 06:50:22 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 1B32B31B;
 Wed, 17 Jun 2020 03:50:22 -0700 (PDT)
Received: from [192.168.1.84] (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id ACC3F3F71F;
 Wed, 17 Jun 2020 03:50:20 -0700 (PDT)
Subject: Re: [PATCH] KVM: arm64: kvm_reset_vcpu() return code incorrect with
 SVE
To: Marc Zyngier <maz@kernel.org>
References: <20200617104339.35094-1-steven.price@arm.com>
 <c9761495762abe174e6546122916fc38@kernel.org>
From: Steven Price <steven.price@arm.com>
Message-ID: <969fe724-de5a-897b-fd55-ca48656e1c46@arm.com>
Date: Wed, 17 Jun 2020 11:50:15 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <c9761495762abe174e6546122916fc38@kernel.org>
Content-Language: en-GB
Cc: Catalin Marinas <catalin.marinas@arm.com>, linux-kernel@vger.kernel.org,
 Dave Martin <Dave.Martin@arm.com>, linux-arm-kernel@lists.infradead.org,
 Will Deacon <will@kernel.org>, kvmarm@lists.cs.columbia.edu
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

T24gMTcvMDYvMjAyMCAxMTo0NywgTWFyYyBaeW5naWVyIHdyb3RlOgo+IEhpIFN0ZXZlbiwKPiAK
PiBPbiAyMDIwLTA2LTE3IDExOjQzLCBTdGV2ZW4gUHJpY2Ugd3JvdGU6Cj4+IElmIFNWRSBpcyBl
bmFibGVkIHRoZW4gJ3JldCcgY2FuIGJlIGFzc2lnbmVkIHRoZSByZXR1cm4gdmFsdWUgb2YKPj4g
a3ZtX3ZjcHVfZW5hYmxlX3N2ZSgpIHdoaWNoIG1heSBiZSAwIGNhdXNpbmcgZnV0dXJlICJnb3Rv
IG91dCIgc2l0ZXMgdG8KPj4gZXJyb25lb3VzbHkgcmV0dXJuIDAgb24gZmFpbHVyZSByYXRoZXIg
dGhhbiAtRUlOVkFMIGFzIGV4cGVjdGVkLgo+Pgo+PiBSZW1vdmUgdGhlIGluaXRpYWxpc2F0aW9u
IG9mICdyZXQnIGFuZCBtYWtlIHNldHRpbmcgdGhlIHJldHVybiB2YWx1ZQo+PiBleHBsaWNpdCB0
byBhdm9pZCB0aGlzIHNpdHVhdGlvbiBpbiB0aGUgZnV0dXJlLgo+Pgo+PiBGaXhlczogOWEzY2Rm
MjZlMzM2ICgiS1ZNOiBhcm02NC9zdmU6IEFsbG93IHVzZXJzcGFjZSB0byBlbmFibGUgU1ZFIAo+
PiBmb3IgdmNwdXMiKQo+PiBSZXBvcnRlZC1ieTogSmFtZXMgTW9yc2UgPGphbWVzLm1vcnNlQGFy
bS5jb20+Cj4+IFNpZ25lZC1vZmYtYnk6IFN0ZXZlbiBQcmljZSA8c3RldmVuLnByaWNlQGFybS5j
b20+Cj4+IC0tLQo+PiBUaGUgcHJvYmxlbWF0aWMgY2h1bmsgaXNuJ3QgdmlzaWJsZSBpbiB0aGUg
ZGlmZiwgc28gcmVwcm9kdWNlZCBoZXJlOgo+Pgo+PiDCoMKgwqDCoGlmICgha3ZtX2FybV92Y3B1
X3N2ZV9maW5hbGl6ZWQodmNwdSkpIHsKPj4gwqDCoMKgwqDCoMKgwqAgaWYgKHRlc3RfYml0KEtW
TV9BUk1fVkNQVV9TVkUsIHZjcHUtPmFyY2guZmVhdHVyZXMpKSB7Cj4+IMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqAgcmV0ID0ga3ZtX3ZjcHVfZW5hYmxlX3N2ZSh2Y3B1KTsKPj4gwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoCBpZiAocmV0KQo+PiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgZ290
byBvdXQ7Cj4+IMKgwqDCoMKgwqDCoMKgIH0KPj4gwqDCoMKgwqB9IGVsc2Ugewo+PiDCoMKgwqDC
oMKgwqDCoCBrdm1fdmNwdV9yZXNldF9zdmUodmNwdSk7Cj4+IMKgwqDCoMKgfQo+Pgo+PiDCoGFy
Y2gvYXJtNjQva3ZtL3Jlc2V0LmMgfCAxMCArKysrKysrLS0tCj4+IMKgMSBmaWxlIGNoYW5nZWQs
IDcgaW5zZXJ0aW9ucygrKSwgMyBkZWxldGlvbnMoLSkKPj4KPj4gZGlmZiAtLWdpdCBhL2FyY2gv
YXJtNjQva3ZtL3Jlc2V0LmMgYi9hcmNoL2FybTY0L2t2bS9yZXNldC5jCj4+IGluZGV4IGQzYjIw
OTAyMzcyNy4uZjEwNTc2MDNiNzU2IDEwMDY0NAo+PiAtLS0gYS9hcmNoL2FybTY0L2t2bS9yZXNl
dC5jCj4+ICsrKyBiL2FyY2gvYXJtNjQva3ZtL3Jlc2V0LmMKPj4gQEAgLTI0NSw3ICsyNDUsNyBA
QCBzdGF0aWMgaW50IGt2bV92Y3B1X2VuYWJsZV9wdHJhdXRoKHN0cnVjdCBrdm1fdmNwdSAKPj4g
KnZjcHUpCj4+IMKgICovCj4+IMKgaW50IGt2bV9yZXNldF92Y3B1KHN0cnVjdCBrdm1fdmNwdSAq
dmNwdSkKPj4gwqB7Cj4+IC3CoMKgwqAgaW50IHJldCA9IC1FSU5WQUw7Cj4+ICvCoMKgwqAgaW50
IHJldDsKPj4gwqDCoMKgwqAgYm9vbCBsb2FkZWQ7Cj4+IMKgwqDCoMKgIHUzMiBwc3RhdGU7Cj4+
Cj4+IEBAIC0yNjksMTUgKzI2OSwxOSBAQCBpbnQga3ZtX3Jlc2V0X3ZjcHUoc3RydWN0IGt2bV92
Y3B1ICp2Y3B1KQo+Pgo+PiDCoMKgwqDCoCBpZiAodGVzdF9iaXQoS1ZNX0FSTV9WQ1BVX1BUUkFV
VEhfQUREUkVTUywgdmNwdS0+YXJjaC5mZWF0dXJlcykgfHwKPj4gwqDCoMKgwqDCoMKgwqDCoCB0
ZXN0X2JpdChLVk1fQVJNX1ZDUFVfUFRSQVVUSF9HRU5FUklDLCB2Y3B1LT5hcmNoLmZlYXR1cmVz
KSkgewo+PiAtwqDCoMKgwqDCoMKgwqAgaWYgKGt2bV92Y3B1X2VuYWJsZV9wdHJhdXRoKHZjcHUp
KQo+PiArwqDCoMKgwqDCoMKgwqAgaWYgKGt2bV92Y3B1X2VuYWJsZV9wdHJhdXRoKHZjcHUpKSB7
Cj4+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIHJldCA9IC1FSU5WQUw7Cj4+IMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoCBnb3RvIG91dDsKPj4gK8KgwqDCoMKgwqDCoMKgIH0KPj4gwqDCoMKgwqAg
fQo+Pgo+PiDCoMKgwqDCoCBzd2l0Y2ggKHZjcHUtPmFyY2gudGFyZ2V0KSB7Cj4+IMKgwqDCoMKg
IGRlZmF1bHQ6Cj4+IMKgwqDCoMKgwqDCoMKgwqAgaWYgKHRlc3RfYml0KEtWTV9BUk1fVkNQVV9F
TDFfMzJCSVQsIHZjcHUtPmFyY2guZmVhdHVyZXMpKSB7Cj4+IC3CoMKgwqDCoMKgwqDCoMKgwqDC
oMKgIGlmICghY3B1c19oYXZlX2NvbnN0X2NhcChBUk02NF9IQVNfMzJCSVRfRUwxKSkKPj4gK8Kg
wqDCoMKgwqDCoMKgwqDCoMKgwqAgaWYgKGNwdXNfaGF2ZV9jb25zdF9jYXAoQVJNNjRfSEFTXzMy
QklUX0VMMSkpIHsKPiAKPiBEbyB5b3UgcmVhbGx5IG1lYW4gdGhpcz8gU2VlbXMgY291bnRlci1w
cm9kdWN0aXZlLi4uIDotKAoKQ2xlYXJseSBub3QuLi4gSSdtIHJlYWxseSBub3Qgc3VyZSBob3cg
SSBtYW5hZ2VkIHRvIHNjcmV3IHRoYXQgdXAgc28gCmJhZGx5IDooCgpJJ20gZ2xhZCBzb21lb25l
IGlzIGF3YWtlIQoKU29ycnkgYWJvdXQgdGhhdCwKClN0ZXZlCgo+PiArwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgIHJldCA9IC1FSU5WQUw7Cj4+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgIGdvdG8gb3V0Owo+PiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCB9Cj4+IMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoCBwc3RhdGUgPSBWQ1BVX1JFU0VUX1BTVEFURV9TVkM7Cj4+IMKg
wqDCoMKgwqDCoMKgwqAgfSBlbHNlIHsKPj4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIHBzdGF0
ZSA9IFZDUFVfUkVTRVRfUFNUQVRFX0VMMTsKPiAKPiBUaGFua3MsCj4gCj4gIMKgwqDCoMKgwqDC
oMKgIE0uCgpfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXwpr
dm1hcm0gbWFpbGluZyBsaXN0Cmt2bWFybUBsaXN0cy5jcy5jb2x1bWJpYS5lZHUKaHR0cHM6Ly9s
aXN0cy5jcy5jb2x1bWJpYS5lZHUvbWFpbG1hbi9saXN0aW5mby9rdm1hcm0K
