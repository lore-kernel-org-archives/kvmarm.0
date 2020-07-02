Return-Path: <SRS0=CSPl=AN=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EDAA8C433DF
	for <kvmarm@archiver.kernel.org>; Thu,  2 Jul 2020 15:51:31 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 79EEA20771
	for <kvmarm@archiver.kernel.org>; Thu,  2 Jul 2020 15:51:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="edhW3U+Q"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 79EEA20771
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id EAAE24B16D;
	Thu,  2 Jul 2020 11:51:30 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, body has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 9-4-p9QR-ttx; Thu,  2 Jul 2020 11:51:29 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C3CCA4B18F;
	Thu,  2 Jul 2020 11:51:29 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 37DFB4B16D
 for <kvmarm@lists.cs.columbia.edu>; Thu,  2 Jul 2020 11:51:28 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ScAwfZxSKh84 for <kvmarm@lists.cs.columbia.edu>;
 Thu,  2 Jul 2020 11:51:27 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id EA28A4B16A
 for <kvmarm@lists.cs.columbia.edu>; Thu,  2 Jul 2020 11:51:26 -0400 (EDT)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id C2D4020771;
 Thu,  2 Jul 2020 15:51:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1593705085;
 bh=LatYfnFQW+JJJ0wcc9nAbgxLlp9C7ksydLETo+4P4Ko=;
 h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
 b=edhW3U+Qy2Pa4QcZijlqaZoTFlbilTvv6fxYldqRNT/apMaG8kJUFkRk/3i+qPD9E
 s4CBvVG+lhQDeagtt7AkWSFgDz9Q40XSOMhPU7alTW4RlSRkqwWxcgpOMBgLSL3Bqf
 jg6d2o5RYlaY/Y2NeWht3O7U57vdtBdlxuoCO6js=
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
 by disco-boy.misterjones.org with esmtpsa
 (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128) (Exim 4.92)
 (envelope-from <maz@kernel.org>)
 id 1jr1Ui-008T23-6U; Thu, 02 Jul 2020 16:51:24 +0100
MIME-Version: 1.0
Date: Thu, 02 Jul 2020 16:51:24 +0100
From: Marc Zyngier <maz@kernel.org>
To: Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: Re: [PATCH] kvmtool: arm64: Report missing support for 32bit guests
In-Reply-To: <0657181e-dff8-5bcc-add6-1b41df2993af@arm.com>
References: <20200701142002.51654-1-suzuki.poulose@arm.com>
 <1aa7885c0d1554c8797e65b13bd05e82@misterjones.org>
 <0657181e-dff8-5bcc-add6-1b41df2993af@arm.com>
User-Agent: Roundcube Webmail/1.4.5
Message-ID: <31468a9ac80f34f1cb267c453dc914bb@kernel.org>
X-Sender: maz@kernel.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: suzuki.poulose@arm.com, kvm@vger.kernel.org,
 andre.przywara@arm.com, sami.mujawar@arm.com, will@kernel.org,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: kvm@vger.kernel.org, andre.przywara@arm.com, sami.mujawar@arm.com,
 will@kernel.org, kvmarm@lists.cs.columbia.edu,
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
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset="utf-8"; Format="flowed"
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

T24gMjAyMC0wNy0wMiAxNjozNywgU3V6dWtpIEsgUG91bG9zZSB3cm90ZToKPiBIaSBNYXJjCj4g
Cj4gT24gMDcvMDEvMjAyMCAwNDo0MiBQTSwgTWFyYyBaeW5naWVyIHdyb3RlOgo+PiBPbiAyMDIw
LTA3LTAxIDE1OjIwLCBTdXp1a2kgSyBQb3Vsb3NlIHdyb3RlOgo+Pj4gV2hlbiB0aGUgaG9zdCBk
b2Vzbid0IHN1cHBvcnQgMzJiaXQgZ3Vlc3RzLCB0aGUga3ZtdG9vbCBmYWlscwo+Pj4gd2l0aG91
dCBhIHByb3BlciBtZXNzYWdlIG9uIHdoYXQgaXMgd3JvbmcuIGkuZSwKPj4+IAo+Pj4gwqAkIGxr
dm0gcnVuIC1jIDEgSW1hZ2UgLS1hYXJjaDMyCj4+PiDCoCAjIGxrdm0gcnVuIC1rIEltYWdlIC1t
IDI1NiAtYyAxIC0tbmFtZSBndWVzdC0xMDU2MTgKPj4+IMKgIEZhdGFsOiBVbmFibGUgdG8gaW5p
dGlhbGlzZSB2Y3B1Cj4+PiAKPj4+IEdpdmVuIHRoYXQgdGhlcmUgaXMgbm8gb3RoZXIgZWFzeSB3
YXkgdG8gY2hlY2sgaWYgdGhlIGhvc3Qgc3VwcG9ydHMgCj4+PiAzMmJpdAo+Pj4gZ3Vlc3RzLCBp
dCBpcyBhbHdheXMgZ29vZCB0byByZXBvcnQgdGhpcyBieSBjaGVja2luZyB0aGUgY2FwYWJpbGl0
eSwgCj4+PiByYXRoZXIKPj4+IHRoYW4gbGVhdmluZyB0aGUgdXNlcnMgdG8gaHVudCB0aGlzIGRv
d24gYnkgbG9va2luZyBhdCB0aGUgY29kZSEKPj4+IAo+Pj4gQWZ0ZXIgdGhpcyBwYXRjaDoKPj4+
IAo+Pj4gwqAkIGxrdm0gcnVuIC1jIDEgSW1hZ2UgLS1hYXJjaDMyCj4+PiDCoCAjIGxrdm0gcnVu
IC1rIEltYWdlIC1tIDI1NiAtYyAxIC0tbmFtZSBndWVzdC0xMDU2OTUKPj4+IMKgIEZhdGFsOiAz
MmJpdCBndWVzdHMgYXJlIG5vdCBzdXBwb3J0ZWQKPj4gCj4+IEZhbmN5IQo+PiAKPj4+IAo+Pj4g
Q2M6IFdpbGwgRGVhY29uIDx3aWxsQGtlcm5lbC5vcmc+Cj4+PiBSZXBvcnRlZC1ieTogU2FtaSBN
dWphd2FyIDxzYW1pLm11amF3YXJAYXJtLmNvbT4KPj4+IFNpZ25lZC1vZmYtYnk6IFN1enVraSBL
IFBvdWxvc2UgPHN1enVraS5wb3Vsb3NlQGFybS5jb20+Cj4+PiAtLS0KPj4+IMKgYXJtL2t2bS1j
cHUuYyB8IDQgKysrKwo+Pj4gwqAxIGZpbGUgY2hhbmdlZCwgNCBpbnNlcnRpb25zKCspCj4+PiAK
Pj4+IGRpZmYgLS1naXQgYS9hcm0va3ZtLWNwdS5jIGIvYXJtL2t2bS1jcHUuYwo+Pj4gaW5kZXgg
NTU0NDE0Zi4uMmFjZWNhZSAxMDA2NDQKPj4+IC0tLSBhL2FybS9rdm0tY3B1LmMKPj4+ICsrKyBi
L2FybS9rdm0tY3B1LmMKPj4+IEBAIC00Niw2ICs0NiwxMCBAQCBzdHJ1Y3Qga3ZtX2NwdSAqa3Zt
X2NwdV9fYXJjaF9pbml0KHN0cnVjdCBrdm0gCj4+PiAqa3ZtLAo+Pj4gdW5zaWduZWQgbG9uZyBj
cHVfaWQpCj4+PiDCoMKgwqDCoMKgwqDCoMKgIC5mZWF0dXJlcyA9IEFSTV9WQ1BVX0ZFQVRVUkVf
RkxBR1Moa3ZtLCBjcHVfaWQpCj4+PiDCoMKgwqDCoCB9Owo+Pj4gCj4+PiArwqDCoMKgIGlmIChr
dm0tPmNmZy5hcmNoLmFhcmNoMzJfZ3Vlc3QgJiYKPj4+ICvCoMKgwqDCoMKgwqDCoCAha3ZtX19z
dXBwb3J0c19leHRlbnNpb24oa3ZtLCBLVk1fQ0FQX0FSTV9FTDFfMzJCSVQpKQo+PiAKPj4gQ2Fu
IHlvdSBwbGVhc2UgY2hlY2sgdGhhdCB0aGlzIHN0aWxsIGNvbXBpbGVzIGZvciAzMmJpdCBob3N0
Pwo+IAo+IFllcywgaXQgZG9lcy4gSSBoYXZlIGJ1aWx0IHRoaXMgb24gYW4gYXJtMzIgcm9vdGZz
IHdpdGggbWFrZSBBUkNIPWFybS4KPiBUaGUga3ZtLT5jZmcuYXJjaCBpcyBjb21tb24gYWNyb3Nz
IGFybS9hcm02NCBhbmQgaXMgZGVmaW5lZCBoZXJlIDoKPiAKPiBhcm0vaW5jbHVkZS9hcm0tY29t
bW9uL2t2bS1jb25maWctYXJjaC5oCgpJIHdhcyB3b3JyaWVkIGFib3V0IHRoZSBhdmFpbGFiaWxp
dHkgb2YgS1ZNX0NBUF9BUk1fRUwxXzMyQklULApidXQgYmVpbmcgYSBjYXBhYmlsaXR5LCBpdCBp
cyBjb21tb24gdG8gYWxsIGFyY2hlcy4gSXQgaXMKS1ZNX0FSTV9WQ1BVX0VMMV8zMkJJVCB0aGF0
IGlzIDMyYml0IG9ubHksIGJ1dCB0aGF0J3Mgbm90IHdoYXQKeW91IGFyZSB1c2luZy4gVG9vIG1h
bnkgZmxhZ3MhIDstKQoKVGhhbmtzLAoKICAgICAgICAgTS4KLS0gCkphenogaXMgbm90IGRlYWQu
IEl0IGp1c3Qgc21lbGxzIGZ1bm55Li4uCl9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fCmt2bWFybSBtYWlsaW5nIGxpc3QKa3ZtYXJtQGxpc3RzLmNzLmNvbHVt
YmlhLmVkdQpodHRwczovL2xpc3RzLmNzLmNvbHVtYmlhLmVkdS9tYWlsbWFuL2xpc3RpbmZvL2t2
bWFybQo=
