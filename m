Return-Path: <SRS0=e8LN=FA=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D7F98C56202
	for <kvmarm@archiver.kernel.org>; Thu, 26 Nov 2020 15:57:37 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 16105221E2
	for <kvmarm@archiver.kernel.org>; Thu, 26 Nov 2020 15:57:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="0FVOyftv"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 16105221E2
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9789D4BB46;
	Thu, 26 Nov 2020 10:57:36 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id kJAjeYuALYsS; Thu, 26 Nov 2020 10:57:35 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6D6784BB10;
	Thu, 26 Nov 2020 10:57:35 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A9EA94BAF3
 for <kvmarm@lists.cs.columbia.edu>; Thu, 26 Nov 2020 10:57:34 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id YeWpYv4AXaIU for <kvmarm@lists.cs.columbia.edu>;
 Thu, 26 Nov 2020 10:57:33 -0500 (EST)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id A681E4BA4E
 for <kvmarm@lists.cs.columbia.edu>; Thu, 26 Nov 2020 10:57:33 -0500 (EST)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 673C921D40;
 Thu, 26 Nov 2020 15:57:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1606406252;
 bh=Cd+lqHcWQa2Lfyc0AEv5uFc3rl+QCTnok0WlZltox6w=;
 h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
 b=0FVOyftviVxfR6AqRCei/O8Hs41Kog3LoDPsdsCmDt6oU1ivHYCbmBUSsz4E6M9Wc
 NDpXx/YU/JpFSW6cOj+uixK+ZRAA3N2FsZGjgKGemNwXbuSv8mDU+puEQPdJmdQLSd
 30EGNrv0NA0x0nUxwCJUSC//Rha7BpNybub7M+E0=
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
 by disco-boy.misterjones.org with esmtpsa (TLS1.2) tls
 TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256 (Exim 4.94)
 (envelope-from <maz@kernel.org>)
 id 1kiJeE-00DqgV-CU; Thu, 26 Nov 2020 15:57:30 +0000
MIME-Version: 1.0
Date: Thu, 26 Nov 2020 15:57:30 +0000
From: Marc Zyngier <maz@kernel.org>
To: Alexandru Elisei <alexandru.elisei@arm.com>
Subject: Re: [PATCH 6/8] KVM: arm64: Remove dead PMU sysreg decoding code
In-Reply-To: <b05e1334-e7d0-5c00-3442-d383d0358bcd@arm.com>
References: <20201113182602.471776-1-maz@kernel.org>
 <20201113182602.471776-7-maz@kernel.org>
 <1ed6dfd6-4ace-a562-bc2f-054a5c853fa6@arm.com>
 <3ae09ecc95b732129f71076b4b59c873@kernel.org>
 <b05e1334-e7d0-5c00-3442-d383d0358bcd@arm.com>
User-Agent: Roundcube Webmail/1.4.9
Message-ID: <b16befcfa43b2d9d04140a2c3bd85302@kernel.org>
X-Sender: maz@kernel.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: alexandru.elisei@arm.com,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
 kvm@vger.kernel.org, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: kernel-team@android.com, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
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

T24gMjAyMC0xMS0yNiAxNTo1NCwgQWxleGFuZHJ1IEVsaXNlaSB3cm90ZToKPiBIaSBNYXJjLAo+
IAo+IE9uIDExLzI2LzIwIDM6MzQgUE0sIE1hcmMgWnluZ2llciB3cm90ZToKPj4gSGkgQWxleCwK
Pj4gCj4+IE9uIDIwMjAtMTEtMjYgMTU6MTgsIEFsZXhhbmRydSBFbGlzZWkgd3JvdGU6Cj4+PiBI
aSBNYXJjLAo+Pj4gCj4+PiBJIGNoZWNrZWQgYW5kIGluZGVlZCB0aGUgcmVtYWluaW5nIGNhc2Vz
IGNvdmVyIGFsbCByZWdpc3RlcnMgdGhhdCB1c2UKPj4+IHRoaXMgYWNjZXNzb3IuCj4+PiAKPj4+
IEhvd2V2ZXIsIEknbSBhIGJpdCB0b3JuIGhlcmUuIFRoZSB3YXJuaW5nIHRoYXQgSSBnb3Qgd2hl
biB0cnlpbmcgdG8gCj4+PiBydW4gYSBndWVzdAo+Pj4gd2l0aCB0aGUgUE1VIGZlYXR1cmUgZmxh
ZyBzZXQsIGJ1dCBub3QgaW5pdGlhbGl6ZWQgKHJlcG9ydGVkIGF0IFsxXSkKPj4+IHdhcyBhbHNv
IG5vdAo+Pj4gc3VwcG9zZWQgdG8gZXZlciBiZSByZWFjaGVkOgo+Pj4gCj4+PiBzdGF0aWMgdTMy
IGt2bV9wbXVfZXZlbnRfbWFzayhzdHJ1Y3Qga3ZtICprdm0pCj4+PiB7Cj4+PiDCoMKgwqAgc3dp
dGNoIChrdm0tPmFyY2gucG11dmVyKSB7Cj4+PiDCoMKgwqAgY2FzZSAxOsKgwqDCoCDCoMKgwqAg
wqDCoMKgIC8qIEFSTXY4LjAgKi8KPj4+IMKgwqDCoCDCoMKgwqAgcmV0dXJuIEdFTk1BU0soOSwg
MCk7Cj4+PiDCoMKgwqAgY2FzZSA0OsKgwqDCoCDCoMKgwqAgwqDCoMKgIC8qIEFSTXY4LjEgKi8K
Pj4+IMKgwqDCoCBjYXNlIDU6wqDCoMKgIMKgwqDCoCDCoMKgwqAgLyogQVJNdjguNCAqLwo+Pj4g
wqDCoMKgIGNhc2UgNjrCoMKgwqAgwqDCoMKgIMKgwqDCoCAvKiBBUk12OC41ICovCj4+PiDCoMKg
wqAgwqDCoMKgIHJldHVybiBHRU5NQVNLKDE1LCAwKTsKPj4+IMKgwqDCoCBkZWZhdWx0OsKgwqDC
oCDCoMKgwqAgLyogU2hvdWxkbid0IGJlIGhlcmUsIGp1c3QgZm9yIHNhbml0eSAqLwo+Pj4gwqDC
oMKgIMKgwqDCoCBXQVJOX09OQ0UoMSwgIlVua25vd24gUE1VIHZlcnNpb24gJWRcbiIsIGt2bS0+
YXJjaC5wbXV2ZXIpOwo+Pj4gwqDCoMKgIMKgwqDCoCByZXR1cm4gMDsKPj4+IMKgwqDCoCB9Cj4+
PiB9Cj4+PiAKPj4+IEkgcmVhbGl6ZSBpdCdzIG5vdCBleGFjdGx5IHRoZSBzYW1lIHRoaW5nIGFu
ZCBJJ2xsIGxlYXZlIGl0IHVwIHRvIHlvdQo+Pj4gaWYgeW91IHdhbnQKPj4+IHRvIGFkZCBhIHdh
cm5pbmcgZm9yIHRoZSBjYXNlcyB0aGF0IHNob3VsZCBuZXZlciBoYXBwZW4uIEknbSBmaW5lIAo+
Pj4gZWl0aGVyIHdheToKPj4gCj4+IEkgYWxyZWFkeSBoYXZlIHF1ZXVlZCBzdWNoIGEgd2Fybmlu
Z1sxXS4gSXQgdHVybnMgb3V0IHRoYXQgTExWTSB3YXJucwo+PiBpZHggY2FuIGJlIGxlZnQgdW5p
bml0aWFsaXplZCwgYW5kIHNob3V0cy4gTGV0IG1lIGtub3cgaWYgdGhhdCB3b3Jrcwo+PiBmb3Ig
eW91Lgo+IAo+IExvb2tzIGdvb2QgdG8gbWUsIHVuc2lnbmVkIGxvbmcgaXMgNjQgYml0cyBhbmQg
aW5zdHJ1Y3Rpb25zIGFyZSAzMgo+IGJpdHMsIHNvIHdlJ2xsIG5ldmVyIHJ1biBpbnRvIGEgc2l0
dWF0aW9uIHdoZXJlIGEgdmFsaWQgZW5jb2RpbmcgaXMgCj4gfjBVTC4KPiAKPiBZb3UgY2FuIGFk
ZCBteSBSZXZpZXdlZC1ieSB0byB0aGlzIHBhdGNoIChhbmQgdG8gdGhlIG9uZSBhdCBbMV0gaWYg
aXQncyAKPiBzdGlsbAo+IHBvc3NpYmxlKS4KCkl0J3MgYSBmaXh1cCwgc28gaXQgd2lsbCBnZXQg
Zm9sZGVkIGludG8gdGhlIG9yaWdpbmFsIHBhdGNoLgoKVGhhbmtzIGZvciBzcGVuZGluZyB0aW1l
IHJldmlld2luZyAoYW5kIGZpeGluZykgdGhpcyEKCiAgICAgICBNLgotLSAKSmF6eiBpcyBub3Qg
ZGVhZC4gSXQganVzdCBzbWVsbHMgZnVubnkuLi4KX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX18Ka3ZtYXJtIG1haWxpbmcgbGlzdAprdm1hcm1AbGlzdHMuY3Mu
Y29sdW1iaWEuZWR1Cmh0dHBzOi8vbGlzdHMuY3MuY29sdW1iaWEuZWR1L21haWxtYW4vbGlzdGlu
Zm8va3ZtYXJtCg==
