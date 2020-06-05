Return-Path: <SRS0=LNXb=7S=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 81537C433DF
	for <kvmarm@archiver.kernel.org>; Fri,  5 Jun 2020 16:07:09 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id F25F8206DB
	for <kvmarm@archiver.kernel.org>; Fri,  5 Jun 2020 16:07:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="kAwlBp93"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org F25F8206DB
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8DEAC4B0F4;
	Fri,  5 Jun 2020 12:07:08 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id EZzsK01OQexa; Fri,  5 Jun 2020 12:07:07 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6CCD34B15C;
	Fri,  5 Jun 2020 12:07:07 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2D7C24B157
 for <kvmarm@lists.cs.columbia.edu>; Fri,  5 Jun 2020 12:07:06 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id yZMn7W0VAouB for <kvmarm@lists.cs.columbia.edu>;
 Fri,  5 Jun 2020 12:07:05 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 0B29E4B0F4
 for <kvmarm@lists.cs.columbia.edu>; Fri,  5 Jun 2020 12:07:05 -0400 (EDT)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id BAE20206DB;
 Fri,  5 Jun 2020 16:07:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1591373223;
 bh=qa+Dbbe426FjY6ZEs9ap2ICeUIcuX0jwcMsPaK3q2YE=;
 h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
 b=kAwlBp93mN6NwiDuXYv+VJtn9c8N7Gzvb7Qay6MkUATRUPrR6teC7MUIHDIiyHq6Q
 Ue7HBovTAItWuhX4c6I3uJo4mRjERrcqC1GP1UCtiVKFxf/sbgraVOtBubQfDSpEcF
 SaL0wLDDwTWQ7gdoz7y7YGdCJXMhZhAUo0Kf+Anw=
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
 by disco-boy.misterjones.org with esmtpsa
 (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128) (Exim 4.92)
 (envelope-from <maz@kernel.org>)
 id 1jhEs2-000Ype-2Q; Fri, 05 Jun 2020 17:07:02 +0100
MIME-Version: 1.0
Date: Fri, 05 Jun 2020 17:07:02 +0100
From: Marc Zyngier <maz@kernel.org>
To: Alexandru Elisei <alexandru.elisei@arm.com>
Subject: Re: [kvmtool][PATCH] arm64: Obtain text offset from kernel image
In-Reply-To: <e9045c9e-f1c1-a6aa-9a19-37dc7ea02038@arm.com>
References: <20200605104907.1307967-1-maz@kernel.org>
 <e9045c9e-f1c1-a6aa-9a19-37dc7ea02038@arm.com>
User-Agent: Roundcube Webmail/1.4.4
Message-ID: <8eeb07b54718d83de6262434c08774fa@kernel.org>
X-Sender: maz@kernel.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: alexandru.elisei@arm.com, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org, will@kernel.org, ardb@kernel.org,
 julien.thierry.kdev@gmail.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: Will Deacon <will@kernel.org>, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org, Ard Biesheuvel <ardb@kernel.org>
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

SGkgQWxleCwKCk9uIDIwMjAtMDYtMDUgMTM6MTYsIEFsZXhhbmRydSBFbGlzZWkgd3JvdGU6Cj4g
SGkgTWFyYywKPiAKPiBPbiA2LzUvMjAgMTE6NDkgQU0sIE1hcmMgWnluZ2llciB3cm90ZToKPj4g
UmVjZW50IGNoYW5nZXMgbWFkZSB0byBMaW51eCA1LjggaGF2ZSBvdXRsaW5lZCB0aGF0IGt2bXRv
b2wKPj4gaGFyZGNvZGVzIHRoZSB0ZXh0IG9mZnNldCBpbnN0ZWFkIG9mIHJlYWRpbmcgaXQgZnJv
bSB0aGUgYXJtNjQKPj4gaW1hZ2UgaXRzZWxmLgo+PiAKPj4gVG8gYWRkcmVzcyB0aGlzLCBpbXBv
cnQgdGhlIGltYWdlIGhlYWRlciBzdHJ1Y3R1cmUgaW50byBrdm10b29sCj4+IGFuZCBkbyB0aGUg
cmlnaHQgdGhpbmcuIDMyYml0IGd1ZXN0cyBhcmUgc3RpbGwgbG9hZGVkIHRvIHRoZWlyCj4+IHVz
dWFsIGxvY2F0aW9ucy4KPj4gCj4+IFJlcG9ydGVkLWJ5OiBBcmQgQmllc2hldXZlbCA8YXJkYkBr
ZXJuZWwub3JnPgo+PiBTaWduZWQtb2ZmLWJ5OiBNYXJjIFp5bmdpZXIgPG1hekBrZXJuZWwub3Jn
Pgo+PiAtLS0KPj4gIE1ha2VmaWxlICAgICAgICAgICAgICAgICAgICAgICAgICAgfCAgMSArCj4+
ICBhcm0vYWFyY2gzMi9pbmNsdWRlL2t2bS9rdm0tYXJjaC5oIHwgIDIgKy0KPj4gIGFybS9hYXJj
aDY0L2luY2x1ZGUvYXNtL2ltYWdlLmggICAgfCA1OSAKPj4gKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrCj4+ICBhcm0vYWFyY2g2NC9pbmNsdWRlL2t2bS9rdm0tYXJjaC5oIHwgIDUgKy0t
Cj4+ICBhcm0vYWFyY2g2NC9rdm0uYyAgICAgICAgICAgICAgICAgIHwgMzAgKysrKysrKysrKysr
KysrCj4+ICBhcm0va3ZtLmMgICAgICAgICAgICAgICAgICAgICAgICAgIHwgIDIgKy0KPj4gIDYg
ZmlsZXMgY2hhbmdlZCwgOTQgaW5zZXJ0aW9ucygrKSwgNSBkZWxldGlvbnMoLSkKPj4gIGNyZWF0
ZSBtb2RlIDEwMDY0NCBhcm0vYWFyY2g2NC9pbmNsdWRlL2FzbS9pbWFnZS5oCj4+ICBjcmVhdGUg
bW9kZSAxMDA2NDQgYXJtL2FhcmNoNjQva3ZtLmMKPj4gCj4+IFsuLl0KPiAKPiBUaGlzIGlzIGEg
Z3JlYXQgYWRkaXRpb24gdG8ga3ZtdG9vbCwgdGhhbmsgeW91ISBCZWZvcmUgSSBkbyBhIG1vcmUg
Cj4gaW4tZGVwdGgKPiByZXZpZXcsIEkgaGF2ZSBzb21lIGdlbmVyYWwgcXVlc3Rpb25zLgo+IAo+
IFJlZ2FyZGluZyB0aGUgYWN0dWFsIHZhbHVlIG9mIHRleHRfb2Zmc2V0LCB0aGUgYm9vdGluZy5y
c3QgZG9jdW1lbnQgCj4gc2F5czoKPiAKPiAiUHJpb3IgdG8gdjMuMTcsIHRoZSBlbmRpYW5uZXNz
IG9mIHRleHRfb2Zmc2V0IHdhcyBub3Qgc3BlY2lmaWVkLsKgIEluCj4gdGhlc2UgY2FzZXMKPiBp
bWFnZV9zaXplIGlzIHplcm8gYW5kIHRleHRfb2Zmc2V0IGlzIDB4ODAwMDAgaW4gdGhlIGVuZGlh
bm5lc3Mgb2YgdGhlIAo+IGtlcm5lbC7CoAo+IFdoZXJlIGltYWdlX3NpemUgaXMgbm9uLXplcm8g
aW1hZ2Vfc2l6ZSBpcyBsaXR0bGUtZW5kaWFuIGFuZCBtdXN0IGJlIAo+IHJlc3BlY3RlZC7CoAo+
IFdoZXJlIGltYWdlX3NpemUgaXMgemVybywgdGV4dF9vZmZzZXQgY2FuIGJlIGFzc3VtZWQgdG8g
YmUgMHg4MDAwMCIuCj4gCj4gQWxsIGhlYWRlciBmaWVsZHMgYXJlIGRlY2xhcmVkIGxpdHRsZS1l
bmRpYW4sIHdoaWNoIGxvb2tzIHRvIG1lIGxpa2UgaXQgCj4gd291bGQKPiBicmVhayBrZXJuZWxz
IG9sZGVyIHRoYW4gMy4xNy4gSWYgdGhhdCB3YXMgaW50ZW50aW9uYWwsIEkgdGhpbmsgaXQncyAK
PiB3b3J0aAo+IGRvY3VtZW50aW5nIHNvbWV3aGVyZSwgb3IgYXQgbGVhc3QgYSBjb21tZW50IGZv
ciB0aGUgCj4ga3ZtX19hcmNoX2dldF9rZXJuX29mZnNldAo+IGZ1bmN0aW9uLgoKVEJILCBJIGRp
ZG4ndCBnaXZlIHByZS0zLjE3ICpiaWctZW5kaWFuKiBtdWNoIHRob3VnaHQuIEhhcHB5IHRvIGRv
Y3VtZW50Cml0IHRob3VnaC4KCj4gCj4gTm93IHRoYXQgd2UgYXJlIHBhcnNpbmcgdGhlIGtlcm5l
bCBoZWFkZXIsIGhhdmUgeW91IGNvbnNpZGVyZWQKPiBjaGVja2luZyB0aGUgbWFnaWMKPiBudW1i
ZXIgdG8gbWFrZSBzdXJlIHRoZSB1c2VyIHNwZWNpZmllZCBhIHZhbGlkIGtlcm5lbCBpbWFnZT8g
SXQgbWlnaHQKPiBzYXZlIHNvbWVvbmUKPiBzb21lIHRpbWUgZGVidWdnaW5nIHdoeSB0aGUga2Vy
bmVsIGlzbid0IGJvb3RpbmcsIGlmLCBmb3IgZXhhbXBsZSwgdGhleSAKPiBhcmUKPiBib290aW5n
IGFuIGFybXY3IGtlcm5lbCwgYnV0IHRoZXkgZm9yZ290IHRvIHNwZWNpZnkgLS1hYXJjaDMyLgoK
VGhhdCdkIGJlIGludGVyZXN0aW5nLiBJJ2QgYmUgcmVsdWN0YW50IHRvIHByZXZlbnQgaXQgZnJv
bSBib290aW5nCmFsdG9nZXRoZXIsIGJ1dCBJIGNhbiBkZWZpbml0ZWx5IGRldGVjdCB0aGUgbGFj
ayBvZiBzaWduYXR1cmUgYW5kCnByaW50IGEgd2FybmluZy4KClRoYW5rcywKCiAgICAgICAgIE0u
Ci0tIApKYXp6IGlzIG5vdCBkZWFkLiBJdCBqdXN0IHNtZWxscyBmdW5ueS4uLgpfX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXwprdm1hcm0gbWFpbGluZyBsaXN0
Cmt2bWFybUBsaXN0cy5jcy5jb2x1bWJpYS5lZHUKaHR0cHM6Ly9saXN0cy5jcy5jb2x1bWJpYS5l
ZHUvbWFpbG1hbi9saXN0aW5mby9rdm1hcm0K
