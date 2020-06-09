Return-Path: <SRS0=btD/=7W=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 74675C433DF
	for <kvmarm@archiver.kernel.org>; Tue,  9 Jun 2020 08:22:05 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id F28F420812
	for <kvmarm@archiver.kernel.org>; Tue,  9 Jun 2020 08:22:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="DxIYUeaT"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org F28F420812
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 976FE4B359;
	Tue,  9 Jun 2020 04:22:04 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id F7Mvom0zg5h7; Tue,  9 Jun 2020 04:22:03 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5153A4B35C;
	Tue,  9 Jun 2020 04:22:03 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id F0A344B359
 for <kvmarm@lists.cs.columbia.edu>; Tue,  9 Jun 2020 04:22:01 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id TryhbWrwONqA for <kvmarm@lists.cs.columbia.edu>;
 Tue,  9 Jun 2020 04:22:00 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 933F14B2AA
 for <kvmarm@lists.cs.columbia.edu>; Tue,  9 Jun 2020 04:22:00 -0400 (EDT)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 6F8FE2074B;
 Tue,  9 Jun 2020 08:21:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1591690919;
 bh=EaUPE0MLylp3QMql7lT+w0hyY9uDzBkCCTG+b26rYjM=;
 h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
 b=DxIYUeaTrM8Bki4mVpUPCf34oJcMFnaHDN8aGL/FCErmCOCAIuSrInXcGCFcFWVLx
 m3jUkUfvsgu9ahl2e4XHwUl/3DntfgbyIPt88MZ2jkF4ZwOP9Y+Bnrm93+kEYx7a0H
 a87nXVvkbe87FvNdGnJe2sKdvRwFmflD+UvvQyhc=
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
 by disco-boy.misterjones.org with esmtpsa
 (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128) (Exim 4.92)
 (envelope-from <maz@kernel.org>)
 id 1jiZW9-001OsZ-QA; Tue, 09 Jun 2020 09:21:58 +0100
MIME-Version: 1.0
Date: Tue, 09 Jun 2020 09:21:57 +0100
From: Marc Zyngier <maz@kernel.org>
To: Auger Eric <eric.auger@redhat.com>
Subject: Re: [PATCH] KVM: arm64: Allow in-atomic injection of SPIs
In-Reply-To: <45a8e2fc-afa2-1909-8f0e-dc6993193894@redhat.com>
References: <20200526161136.451312-1-maz@kernel.org>
 <0a3875f0-9918-51f3-08eb-29a72eeb1306@redhat.com>
 <e3a8ea9947616f895021310127fe1477@kernel.org>
 <45a8e2fc-afa2-1909-8f0e-dc6993193894@redhat.com>
User-Agent: Roundcube Webmail/1.4.4
Message-ID: <a4d4e0b62368b764eab87ad4f47fd0e7@kernel.org>
X-Sender: maz@kernel.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: eric.auger@redhat.com, linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, james.morse@arm.com,
 julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 kernel-team@android.com, kvmarm@lists.cs.columbia.edu
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

T24gMjAyMC0wNi0wOSAwODo0OCwgQXVnZXIgRXJpYyB3cm90ZToKPiBIaSBNYXJjLAo+IAo+IE9u
IDYvOC8yMCA3OjE5IFBNLCBNYXJjIFp5bmdpZXIgd3JvdGU6Cj4+IEhpIEVyaWMsCj4+IAo+PiBP
biAyMDIwLTA2LTA4IDE3OjU4LCBBdWdlciBFcmljIHdyb3RlOgo+Pj4gSGkgTWFyYywKPj4+IAo+
Pj4gT24gNS8yNi8yMCA2OjExIFBNLCBNYXJjIFp5bmdpZXIgd3JvdGU6Cj4+Pj4gT24gYSBzeXN0
ZW0gdGhhdCB1c2VzIFNQSXMgdG8gaW1wbGVtZW50IE1TSXMgKGFzIGl0IHdvdWxkIGJlCj4+Pj4g
dGhlIGNhc2Ugb24gYSBHSUN2MiBzeXN0ZW0gZXhwb3NpbmcgYSBHSUN2Mm0gdG8gaXRzIGd1ZXN0
cyksCj4+Pj4gd2UgZGVueSB0aGUgcG9zc2liaWxpdHkgb2YgaW5qZWN0aW5nIFNQSXMgb24gdGhl
IGluLWF0b21pYwo+Pj4+IGZhc3QtcGF0aC4KPj4+PiAKPj4+PiBUaGlzIHJlc3VsdHMgaW4gYSB2
ZXJ5IGxhcmdlIGFtb3VudCBvZiBjb250ZXh0LXN3aXRjaGVzCj4+Pj4gKHJvdWdobHkgZXF1aXZh
bGVudCB0byB0d2ljZSB0aGUgaW50ZXJydXB0IHJhdGUpIG9uIHRoZSBob3N0LAo+Pj4+IGFuZCBz
dWJvcHRpbWFsIHBlcmZvcm1hbmNlIGZvciB0aGUgZ3Vlc3QgKGFzIG1lYXN1cmVkIHdpdGgKPj4+
PiBhIHRlc3Qgd29ya2xvYWQgaW52b2x2aW5nIGEgdmlydGlvIGludGVyZmFjZSBiYWNrZWQgYnkg
dmhvc3QtbmV0KS4KPj4+PiBHaXZlbiB0aGF0IEdJQ3YyIHN5c3RlbXMgYXJlIHVzdWFsbHkgb24g
dGhlIGxvdy1lbmQgb2YgdGhlIHNwZWN0cnVtCj4+Pj4gcGVyZm9ybWFuY2Ugd2lzZSwgdGhleSBj
b3VsZCBkbyB3aXRob3V0IHRoZSBhZ2dyYXZhdGlvbi4KPj4+PiAKPj4+PiBXZSBzb2x2ZWQgdGhp
cyBmb3IgR0lDdjMrSVRTIGJ5IGhhdmluZyBhIHRyYW5zbGF0aW9uIGNhY2hlLiBCdXQKPj4+PiBT
UElzIGRvIG5vdCBuZWVkIGFueSBleHRyYSBpbmZyYXN0cnVjdHVyZSwgYW5kIGNhbiBiZSBpbW1l
ZGlhdGVseQo+Pj4+IGluamVjdGVkIGluIHRoZSB2aXJ0dWFsIGRpc3RyaWJ1dG9yIGFzIHRoZSBs
b2NraW5nIGlzIGFscmVhZHkKPj4+PiBoZWF2eSBlbm91Z2ggdGhhdCB3ZSBkb24ndCBuZWVkIHRv
IHdvcnJ5IGFib3V0IGFueXRoaW5nLgo+Pj4+IAo+Pj4+IFRoaXMgaGFsdmVzIHRoZSBudW1iZXIg
b2YgY29udGV4dCBzd2l0Y2hlcyBmb3IgdGhlIHNhbWUgd29ya2xvYWQuCj4+Pj4gCj4+Pj4gU2ln
bmVkLW9mZi1ieTogTWFyYyBaeW5naWVyIDxtYXpAa2VybmVsLm9yZz4KPj4+PiAtLS0KPj4+PiDC
oGFyY2gvYXJtNjQva3ZtL3ZnaWMvdmdpYy1pcnFmZC5jIHwgMjAgKysrKysrKysrKysrKysrKy0t
LS0KPj4+PiDCoGFyY2gvYXJtNjQva3ZtL3ZnaWMvdmdpYy1pdHMuY8KgwqAgfMKgIDMgKy0tCj4+
Pj4gwqAyIGZpbGVzIGNoYW5nZWQsIDE3IGluc2VydGlvbnMoKyksIDYgZGVsZXRpb25zKC0pCj4+
Pj4gCj4+Pj4gZGlmZiAtLWdpdCBhL2FyY2gvYXJtNjQva3ZtL3ZnaWMvdmdpYy1pcnFmZC5jCj4+
Pj4gYi9hcmNoL2FybTY0L2t2bS92Z2ljL3ZnaWMtaXJxZmQuYwo+Pj4+IGluZGV4IGQ4Y2RmZWE1
Y2M5Ni4uMTFhOWY4MTExNWFiIDEwMDY0NAo+Pj4+IC0tLSBhL2FyY2gvYXJtNjQva3ZtL3ZnaWMv
dmdpYy1pcnFmZC5jCj4+Pj4gKysrIGIvYXJjaC9hcm02NC9rdm0vdmdpYy92Z2ljLWlycWZkLmMK
Pj4+IFRoZXJlIGlzIHN0aWxsIGEgY29tbWVudCBhYm92ZSBzYXlpbmcKPj4+IMKgKiBDdXJyZW50
bHkgb25seSBkaXJlY3QgTVNJIGluamVjdGlvbiBpcyBzdXBwb3J0ZWQuCj4+IAo+PiBJIGJlbGll
dmUgdGhpcyBjb21tZW50IHRvIGJlIGNvcnJlY3QuIFRoZXJlIGlzIG5vIHBhdGggb3RoZXIKPj4g
dGhhbiBNU0kgaW5qZWN0aW9uIHRoYXQgbGVhZHMgdXMgaGVyZS4gQ2FzZSBpbiBwb2ludCwgd2Ug
b25seQo+PiBldmVyIGluamVjdCBhIHJpc2luZyBlZGdlIHRocm91Z2ggdGhpcyBBUEksIG5ldmVy
IGEgZmFsbGluZyBvbmUuCj4gCj4gSXNuJ3QgdGhpcyBwYXRoIGVudGVyZWQgd2hlbmV2ZXIgeW91
IGhhdmUgZWl0aGVyIG9mIHRoZSBjb21ibyBiZWluZyAKPiB1c2VkPwo+IEtWTV9TRVRfTVNJX1JP
VVRJTkcgKyBLVk1fSVJRRkQKPiBLVk1fU0VUX0dTSV9ST1VUSU5HICsgS1ZNX0lSUUZECgpJJ3Zl
IGFsd2F5cyBjb25zaWRlcmVkIHRoZXNlIHRvIGJlIE1TSXMsIGJ1dCBtYXliZSBJJ20gbmFycm93
IG1pbmRlZC4uLiAKOy0pCgo+IEkgaGFkIGluIG1pbmQgZGlyZWN0IE1TSSBpbmplY3Rpb24gd2Fz
IEtWTV9TSUdOQUxfTVNJLwo+IGt2bV9zZW5kX3VzZXJzcGFjZV9tc2kva3ZtX3NldF9tc2kKCkZh
aXIgZW5vdWdoLiBaZW5ndWkgd2FzIGFsc28gdW5oYXBweSBhYm91dCB0aGlzIGNvbW1lbnQsIHNv
IEknbGwKcmVtb3ZlIGl0LiBBZnRlciBhbGwsIHdlIHNob3VsZG4ndCBjYXJlIHdoZXRoZXIgdGhh
dCdzIGEgTVNJIG9yIG5vdC4KCj4+IAo+Pj4+IEBAIC0xMDcsMTUgKzEwNywyNyBAQCBpbnQga3Zt
X2FyY2hfc2V0X2lycV9pbmF0b21pYyhzdHJ1Y3QKPj4+PiBrdm1fa2VybmVsX2lycV9yb3V0aW5n
X2VudHJ5ICplLAo+Pj4+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBzdHJ1
Y3Qga3ZtICprdm0sIGludCBpcnFfc291cmNlX2lkLCBpbnQgbGV2ZWwsCj4+Pj4gwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIGJvb2wgbGluZV9zdGF0dXMpCj4+Pj4gwqB7Cj4+
Pj4gLcKgwqDCoCBpZiAoZS0+dHlwZSA9PSBLVk1fSVJRX1JPVVRJTkdfTVNJICYmIHZnaWNfaGFz
X2l0cyhrdm0pICYmIAo+Pj4+IGxldmVsKSB7Cj4+Pj4gK8KgwqDCoCBpZiAoIWxldmVsKQo+Pj4+
ICvCoMKgwqDCoMKgwqDCoCByZXR1cm4gLUVXT1VMREJMT0NLOwo+Pj4+ICsKPj4+PiArwqDCoMKg
IHN3aXRjaCAoZS0+dHlwZSkgewo+Pj4+ICvCoMKgwqAgY2FzZSBLVk1fSVJRX1JPVVRJTkdfTVNJ
OiB7Cj4+Pj4gwqDCoMKgwqDCoMKgwqDCoCBzdHJ1Y3Qga3ZtX21zaSBtc2k7Cj4+Pj4gCj4+Pj4g
K8KgwqDCoMKgwqDCoMKgIGlmICghdmdpY19oYXNfaXRzKGt2bSkpCj4+Pj4gK8KgwqDCoMKgwqDC
oMKgwqDCoMKgwqAgcmV0dXJuIC1FSU5WQUw7Cj4+PiBTaG91bGRuJ3Qgd2UgcmV0dXJuIC1FV09V
TERCTE9DSyBieSBkZWZhdWx0Pwo+Pj4gUUVNVSBkb2VzIG5vdCB1c2UgdGhhdCBwYXRoIHdpdGgg
R0lDdjJtIGJ1dCBpbiAKPj4+IGt2bV9zZXRfcm91dGluZ19lbnRyeSgpIEkKPj4+IGRvbid0IHNl
ZSBhbnkgY2hlY2sgcmVsYXRlZCB0byB0aGUgSVRTLgo+PiAKPj4gRmFpciBlbm91Z2guIEkgcmVh
bGx5IGRvbid0IGFudGljaXBhdGUgYW55b25lIHRvIGJlIHVzaW5nCj4+IEtWTV9JUlFfUk9VVElO
R19NU0kgd2l0aCBhbnl0aGluZyBidXQgdGhlIElUUywgYnV0IHdobyBrbm93cywKPj4gcGVvcGxl
IGFyZSBjcmF6eSEgOy0pCj4+IAo+Pj4+ICsKPj4+PiDCoMKgwqDCoMKgwqDCoMKgIGt2bV9wb3B1
bGF0ZV9tc2koZSwgJm1zaSk7Cj4+Pj4gLcKgwqDCoMKgwqDCoMKgIGlmICghdmdpY19pdHNfaW5q
ZWN0X2NhY2hlZF90cmFuc2xhdGlvbihrdm0sICZtc2kpKQo+Pj4+IC3CoMKgwqDCoMKgwqDCoMKg
wqDCoMKgIHJldHVybiAwOwo+Pj4+ICvCoMKgwqDCoMKgwqDCoCByZXR1cm4gdmdpY19pdHNfaW5q
ZWN0X2NhY2hlZF90cmFuc2xhdGlvbihrdm0sICZtc2kpOwo+Pj4gCj4+Pj4gwqDCoMKgwqAgfQo+
Pj4+IAo+Pj4+IC3CoMKgwqAgcmV0dXJuIC1FV09VTERCTE9DSzsKPj4+PiArwqDCoMKgIGNhc2Ug
S1ZNX0lSUV9ST1VUSU5HX0lSUUNISVA6Cj4+Pj4gK8KgwqDCoMKgwqDCoMKgIC8qIEluamVjdGlu
ZyBTUElzIGlzIGFsd2F5cyBwb3NzaWJsZSBpbiBhdG9taWMgY29udGV4dCAqLwo+Pj4+ICvCoMKg
wqDCoMKgwqDCoCByZXR1cm4gdmdpY19pcnFmZF9zZXRfaXJxKGUsIGt2bSwgaXJxX3NvdXJjZV9p
ZCwgMSwKPj4+PiBsaW5lX3N0YXR1cyk7Cj4+PiB3aGF0IGFib3V0IHRoZcKgwqDCoMKgIG11dGV4
X2xvY2soJmt2bS0+bG9jaykgY2FsbGVkIGZyb20gd2l0aGluCj4+PiB2Z2ljX2lycWZkX3NldF9p
cnEva3ZtX3ZnaWNfaW5qZWN0X2lycS92Z2ljX2xhenlfaW5pdAo+PiAKPj4gSG9seSBjcmFwLiBU
aGUgbGF6eSBHSUMgaW5pdCBzdHJpa2VzIGFnYWluIDotKC4KPj4gSG93IGFib3V0IHRoaXMgb24g
dG9wIG9mIHRoZSBleGlzdGluZyBwYXRjaDoKPj4gCj4+IGRpZmYgLS1naXQgYS9hcmNoL2FybTY0
L2t2bS92Z2ljL3ZnaWMtaXJxZmQuYwo+PiBiL2FyY2gvYXJtNjQva3ZtL3ZnaWMvdmdpYy1pcnFm
ZC5jCj4+IGluZGV4IDExYTlmODExMTVhYi4uNmU1Y2EwNGQ1NTg5IDEwMDY0NAo+PiAtLS0gYS9h
cmNoL2FybTY0L2t2bS92Z2ljL3ZnaWMtaXJxZmQuYwo+PiArKysgYi9hcmNoL2FybTY0L2t2bS92
Z2ljL3ZnaWMtaXJxZmQuYwo+PiBAQCAtMTE1LDE5ICsxMTUsMjMgQEAgaW50IGt2bV9hcmNoX3Nl
dF9pcnFfaW5hdG9taWMoc3RydWN0Cj4+IGt2bV9rZXJuZWxfaXJxX3JvdXRpbmdfZW50cnkgKmUs
Cj4+IMKgwqDCoMKgwqDCoMKgwqAgc3RydWN0IGt2bV9tc2kgbXNpOwo+PiAKPj4gwqDCoMKgwqDC
oMKgwqDCoCBpZiAoIXZnaWNfaGFzX2l0cyhrdm0pKQo+PiAtwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oCByZXR1cm4gLUVJTlZBTDsKPj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqAgYnJlYWs7Cj4+IAo+
PiDCoMKgwqDCoMKgwqDCoMKgIGt2bV9wb3B1bGF0ZV9tc2koZSwgJm1zaSk7Cj4+IMKgwqDCoMKg
wqDCoMKgwqAgcmV0dXJuIHZnaWNfaXRzX2luamVjdF9jYWNoZWRfdHJhbnNsYXRpb24oa3ZtLCAm
bXNpKTsKPj4gwqDCoMKgwqAgfQo+PiAKPj4gwqDCoMKgwqAgY2FzZSBLVk1fSVJRX1JPVVRJTkdf
SVJRQ0hJUDoKPj4gLcKgwqDCoMKgwqDCoMKgIC8qIEluamVjdGluZyBTUElzIGlzIGFsd2F5cyBw
b3NzaWJsZSBpbiBhdG9taWMgY29udGV4dCAqLwo+PiArwqDCoMKgwqDCoMKgwqAgLyoKPj4gK8Kg
wqDCoMKgwqDCoMKgwqAgKiBJbmplY3RpbmcgU1BJcyBpcyBhbHdheXMgcG9zc2libGUgaW4gYXRv
bWljIGNvbnRleHQKPj4gK8KgwqDCoMKgwqDCoMKgwqAgKiBhcyBsb25nIGFzIHRoZSBkYW1uIHZn
aWMgaXMgaW5pdGlhbGl6ZWQuCj4+ICvCoMKgwqDCoMKgwqDCoMKgICovCj4+ICvCoMKgwqDCoMKg
wqDCoCBpZiAodW5saWtlbHkoIXZnaWNfaW5pdGlhbGl6ZWQoa3ZtKSkpCj4+ICvCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgIGJyZWFrOwo+IFllcyB0aGlzIHNob3VsZCBwcmV2ZW50IHRoZSB3YWl0IHNp
dHVhdGlvbi4gQnV0IG1heSBiZSB3b3J0aCB0byBkZWVwCj4gaW50byB0aGUgY2FsbCBzdGFjay4g
V29uJ3QgYW5hbHl6ZXJzIGNvbXBsYWluIGF0IHNvbWUgcG9pbnQ/CgpJIGhhdmUgZ29uZSBhbGwg
dGhlIHdheSBpbiB0aGUgY2FsbCBzdGFjaywgdG8gYmUgc3VyZS4gVGhlIGluaXQgaXMKdGhlIG9u
bHkgcG9pbnQgd2UgdXNlIGEgbXV0ZXgsIGFuZCB3ZSdyZSB1bmRlciBhIGhhcmQgc3BpbmxvY2sg
anVzdAphZnRlciAoYWxsIHRoZSBpbmplY3Rpb24gcHJvcGVyIGlzIGhhcHBlbmluZyB3aXRoIGlu
dGVycnVwdCBkaXNhYmxlZCkuCgpBcyBmb3IgdGhpbmdzIGxpa2UgbG9ja2RlcCwgdGhleSB0cmFj
ayB0aGUgZHluYW1pYyBzdGF0ZSwgYW5kIG5vdAp3aGV0aGVyIGNlcnRhaW4gYnJhbmNoZXMgYXJl
IHNpbXBseSAicG9zc2libGUiLiBBIGNvZGUgYW5hbHlzZXIKdGhhdCB3b3VsZG4ndCB0YWtlIGNv
bnRyb2wgZmxvdyBpbnRvIGFjY291bnQgd291bGQgYmUgcHJldHR5IGJyb2tlbiEgOy0pCgpUaGFu
a3MsCgogICAgICAgICBNLgotLSAKSmF6eiBpcyBub3QgZGVhZC4gSXQganVzdCBzbWVsbHMgZnVu
bnkuLi4KX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18Ka3Zt
YXJtIG1haWxpbmcgbGlzdAprdm1hcm1AbGlzdHMuY3MuY29sdW1iaWEuZWR1Cmh0dHBzOi8vbGlz
dHMuY3MuY29sdW1iaWEuZWR1L21haWxtYW4vbGlzdGluZm8va3ZtYXJtCg==
