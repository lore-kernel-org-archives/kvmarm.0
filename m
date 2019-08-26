Return-Path: <SRS0=oEtv=WW=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7E406C3A5A5
	for <kvmarm@archiver.kernel.org>; Mon, 26 Aug 2019 08:38:14 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 04AF020874
	for <kvmarm@archiver.kernel.org>; Mon, 26 Aug 2019 08:38:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 04AF020874
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 465874A5A3;
	Mon, 26 Aug 2019 04:38:13 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id wmzmEeJ1dI+L; Mon, 26 Aug 2019 04:38:11 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E95524A5A4;
	Mon, 26 Aug 2019 04:38:11 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8338E4A563
 for <kvmarm@lists.cs.columbia.edu>; Mon, 26 Aug 2019 04:38:10 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 1dEe4fUKQM36 for <kvmarm@lists.cs.columbia.edu>;
 Mon, 26 Aug 2019 04:38:09 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 13EAF4A558
 for <kvmarm@lists.cs.columbia.edu>; Mon, 26 Aug 2019 04:38:08 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 5FDA528;
 Mon, 26 Aug 2019 01:38:08 -0700 (PDT)
Received: from localhost (e113682-lin.copenhagen.arm.com [10.32.144.41])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id E6E3B3F59C;
 Mon, 26 Aug 2019 01:38:07 -0700 (PDT)
Date: Mon, 26 Aug 2019 10:38:06 +0200
From: Christoffer Dall <christoffer.dall@arm.com>
To: Jan Kiszka <jan.kiszka@web.de>
Subject: Re: KVM works on RPi4
Message-ID: <20190826083806.GA12352@e113682-lin.lund.arm.com>
References: <1d1198c2-f362-840d-cb14-9a6d74da745c@web.de>
 <20190629234232.484ca3c0@why>
 <9fa56744-9925-6f49-b2a4-368e13fbbc41@web.de>
 <3f6ea07b-975b-3d66-e12d-f0a9cadb83a9@web.de>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <3f6ea07b-975b-3d66-e12d-f0a9cadb83a9@web.de>
User-Agent: Mutt/1.5.24 (2015-08-30)
Cc: Marc Zyngier <marc.zyngier@arm.com>, kvmarm@lists.cs.columbia.edu,
 kvm <kvm@vger.kernel.org>
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

SGkgSmFuLAoKT24gU3VuLCBKdW4gMzAsIDIwMTkgYXQgMTI6MTg6NTlQTSArMDIwMCwgSmFuIEtp
c3prYSB3cm90ZToKPiBPbiAzMC4wNi4xOSAxMTozNCwgSmFuIEtpc3prYSB3cm90ZToKPiA+T24g
MzAuMDYuMTkgMDA6NDIsIE1hcmMgWnluZ2llciB3cm90ZToKPiA+Pk9uIFNhdCwgMjkgSnVuIDIw
MTkgMTk6MDk6MzcgKzAyMDAKPiA+PkphbiBLaXN6a2EgPGphbi5raXN6a2FAd2ViLmRlPiB3cm90
ZToKPiA+Pj5Ib3dldmVyLCBhcyB0aGUgUmFzcGJlcnJ5IGtlcm5lbCBpcyBub3QgeWV0IHJlYWR5
IGZvciA2NC1iaXQgKGFuZAo+ID4+PnVwc3RyZWFtIGlzIG5vdCBpbiBzaWdodCksIEkgaGFkIHRv
IHVzZSBsZWdhY3kgMzItYml0IG1vZGUuIEFuZCB0aGVyZSB3ZQo+ID4+PnN0dW1ibGUgb3ZlciB0
aGUgY29yZSBkZXRlY3Rpb24uIFRoaXMgbGl0dGxlIHBhdGNoIG1hZGUgaXQgd29yaywgdGhvdWdo
Ogo+ID4+Pgo+ID4+PmRpZmYgLS1naXQgYS9hcmNoL2FybS9rdm0vZ3Vlc3QuYyBiL2FyY2gvYXJt
L2t2bS9ndWVzdC5jCj4gPj4+aW5kZXggMmI4ZGU4ODViMmJmLi4wMTYwNmFhZDczY2MgMTAwNjQ0
Cj4gPj4+LS0tIGEvYXJjaC9hcm0va3ZtL2d1ZXN0LmMKPiA+Pj4rKysgYi9hcmNoL2FybS9rdm0v
Z3Vlc3QuYwo+ID4+PkBAIC0yOTAsNiArMjkwLDcgQEAgaW50IF9fYXR0cmlidXRlX2NvbnN0X18g
a3ZtX3RhcmdldF9jcHUodm9pZCkKPiA+Pj7CoMKgwqDCoMKgIGNhc2UgQVJNX0NQVV9QQVJUX0NP
UlRFWF9BNzoKPiA+Pj7CoMKgwqDCoMKgwqDCoMKgwqAgcmV0dXJuIEtWTV9BUk1fVEFSR0VUX0NP
UlRFWF9BNzsKPiA+Pj7CoMKgwqDCoMKgIGNhc2UgQVJNX0NQVV9QQVJUX0NPUlRFWF9BMTU6Cj4g
Pj4+K8KgwqDCoCBjYXNlIEFSTV9DUFVfUEFSVF9DT1JURVhfQTcyOgo+ID4+PsKgwqDCoMKgwqDC
oMKgwqDCoCByZXR1cm4gS1ZNX0FSTV9UQVJHRVRfQ09SVEVYX0ExNTsKPiA+Pj7CoMKgwqDCoMKg
IGRlZmF1bHQ6Cj4gPj4+wqDCoMKgwqDCoMKgwqDCoMKgIHJldHVybiAtRUlOVkFMOwo+ID4+Pgo+
ID4+PlRoYXQgcmFpc2VzIHRoZSBxdWVzdGlvbiBpZiB0aGlzIGlzIGhhY2sgb3IgYSB2YWxpZCBj
aGFuZ2UgYW5kIGlmIHRoZXJlCj4gPj4+aXMgZ2VuZXJhbCBpbnRlcmVzdCBpbiBtYXBwaW5nIDY0
LWJpdCBjb3JlcyBvbiAzMi1iaXQgaWYgdGhleSBoYXBwZW4gdG8KPiA+Pj5ydW4gaW4gMzItYml0
IG1vZGUuCj4gPj4KPiA+PlRoZSByZWFsIHRoaW5nIHRvIGRvIGhlcmUgd291bGQgYmUgdG8gbW92
ZSB0byBhIGdlbmVyaWMgdGFyZ2V0LCBtdWNoCj4gPj5saWtlIHdlIGRpZCBvbiB0aGUgNjRiaXQg
c2lkZS4gQ291bGQgeW91IGludmVzdGlnYXRlIHRoYXQgaW5zdGVhZD8gSXQKPiA+PndvdWxkIGFs
c28gYWxsb3cgS1ZNIHRvIGJlIHVzZWQgb24gb3RoZXIgMzJiaXQgY29yZXMgc3VjaCBhcwo+ID4+
QTEyL0ExNy9BMzIuCj4gPgo+ID5Zb3UgbWVhbiBzb21ldGhpbmcgbGlrZSBLVk1fQVJNX1RBUkdF
VF9HRU5FUklDX1Y4PyBOZWVkIHRvIHN0dWR5IHRoYXQuLi4KPiA+Cj4gCj4gSG1tLCBsb29raW5n
IGF0IHdoYXQgS1ZNX0FSTV9UQVJHRVRfQ09SVEVYX0E3IGFuZCAuLi5fQTE1IGRpZmZlcmVudGlh
dGVzLCBJCj4gZm91bmQgbm90aGluZyBzbyBmYXI6Cj4gCj4ga3ZtX3Jlc2V0X3ZjcHU6Cj4gICAg
ICAgICBzd2l0Y2ggKHZjcHUtPmFyY2gudGFyZ2V0KSB7Cj4gICAgICAgICBjYXNlIEtWTV9BUk1f
VEFSR0VUX0NPUlRFWF9BNzoKPiAgICAgICAgIGNhc2UgS1ZNX0FSTV9UQVJHRVRfQ09SVEVYX0Ex
NToKPiAgICAgICAgICAgICAgICAgcmVzZXRfcmVncyA9ICZjb3J0ZXhhX3JlZ3NfcmVzZXQ7Cj4g
ICAgICAgICAgICAgICAgIHZjcHUtPmFyY2gubWlkciA9IHJlYWRfY3B1aWRfaWQoKTsKPiAgICAg
ICAgICAgICAgICAgYnJlYWs7Cj4gCj4gQW5kIGFyY2gvYXJtL2t2bS9jb3Byb2NfYTE1LmMgbG9v
a3MgbGlrZSBhIGNvcHkgb2YgY29wcm9jX2E3LmMsIGp1c3Qgd2l0aCBzb21lCj4gc3ltYm9scyBy
ZW5hbWVkLgo+IAo+IFdoYXQncyB0aGUgcHVycG9zZSBvZiBhbGwgdGhhdD8gUGxhbm5lZCBmb3Ig
c29tZXRoaW5nIGJpZ2dlciBidXQgbmV2ZXIKPiBpbXBsZW1lbnRlZD8gRnJvbSB0aGF0IHBlcnNw
ZWN0aXZlLCB0aGVyZSBzZWVtcyB0byBiZSBubyBuZWVkIHRvIGFyY2gudGFyZ2V0IGFuZAo+IGt2
bV9jb3Byb2NfdGFyZ2V0X3RhYmxlIGF0IGFsbC4KPiAKClRoZXJlIHdhcyBzb21lIHNwZWN1bGF0
aW9uIGludm9sdmVkIGhlcmUsIGFuZCB3ZSBuZWVkZWQgdG8gZmlndXJlIG91dApob3cgd2Ugd291
bGQgZGVhbCB3aXRoIGltcGxlbWVudGF0aW9uIGRlZmluZWQgYmVoYXZpb3IsIHNvIHdlIGJ1aWx0
IHRoaXMKc3VwcG9ydCBmb3IgZWFjaCB0eXBlIG9mIENQVSBldGMuCgpJbiByZWFsaXR5LCBtb3N0
IENQVXMgdGhhdCB3ZSBzdXBwb3J0IGFyZSBwcmV0dHkgc2ltaWxhciBhbmQgdGhhdCdzIHdoeQp3
ZSBkaWQgdGhlIGdlbmVyaWMgQ1BVIHR5cGUgaW5zdGVhZC4gIEluIHByYWN0aWNlLCB0aGVyZSBt
aWdodCBiZSBhIG1vcmUKbGlnaHQtd2VpZ2h0IGFwcHJhb2NoIHRvIGhhbmRsaW5nIHRoZSBtaW5v
ciBkaWZmZXJlbmNlcyBiZXR3ZWVuIENQVQppbXBsZW1lbnRhdGlvbnMgdGhhbiB3aGF0IHdlIGhh
dmUgaGVyZS4KCgpUaGFua3MsCgogICAgQ2hyaXN0b2ZmZXIKX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX18Ka3ZtYXJtIG1haWxpbmcgbGlzdAprdm1hcm1AbGlz
dHMuY3MuY29sdW1iaWEuZWR1Cmh0dHBzOi8vbGlzdHMuY3MuY29sdW1iaWEuZWR1L21haWxtYW4v
bGlzdGluZm8va3ZtYXJtCg==
