Return-Path: <SRS0=1n5P=4H=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1226C34047
	for <kvmarm@archiver.kernel.org>; Wed, 19 Feb 2020 11:14:48 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 63FFF2067D
	for <kvmarm@archiver.kernel.org>; Wed, 19 Feb 2020 11:14:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="EK4/zBLp"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 63FFF2067D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BAA604AF1B;
	Wed, 19 Feb 2020 06:14:47 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id XMHHR7kq+HJL; Wed, 19 Feb 2020 06:14:46 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 99D464AF28;
	Wed, 19 Feb 2020 06:14:46 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4936B4AF27
 for <kvmarm@lists.cs.columbia.edu>; Wed, 19 Feb 2020 06:14:45 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ngvYjLnFQOPz for <kvmarm@lists.cs.columbia.edu>;
 Wed, 19 Feb 2020 06:14:44 -0500 (EST)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id CB53E4AF06
 for <kvmarm@lists.cs.columbia.edu>; Wed, 19 Feb 2020 06:14:43 -0500 (EST)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 6951D24658;
 Wed, 19 Feb 2020 11:14:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1582110882;
 bh=t4vzpweClqjBcv8dfE7UQXkgRAqeUVPdgkwMN4FVeg0=;
 h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
 b=EK4/zBLpN2Xq0bcVNbO+o/rj59zbrufMthyreklPzIrj8cSI8s0564Ksfw2oidBY3
 KgznGxD07C86IQalFv6CpZhpI5y6vQmkbOnKMCwOictJJaUaDDNukIPALdp3hEbEeM
 YgiPWlcfva2qKdv6d8hjBH7dqi/QrIzd/2YsxfTk=
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
 by disco-boy.misterjones.org with esmtpsa
 (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128) (Exim 4.92)
 (envelope-from <maz@kernel.org>)
 id 1j4NJQ-006UOX-Ds; Wed, 19 Feb 2020 11:14:40 +0000
MIME-Version: 1.0
Date: Wed, 19 Feb 2020 11:14:40 +0000
From: Marc Zyngier <maz@kernel.org>
To: James Morse <james.morse@arm.com>
Subject: Re: [PATCH 3/5] kvm: arm64: Limit PMU version to ARMv8.1
In-Reply-To: <ed7f31d5-9a2b-6ea0-85f8-74fcd7d9ac61@arm.com>
References: <20200216185324.32596-1-maz@kernel.org>
 <20200216185324.32596-4-maz@kernel.org>
 <eb0294ef-5ad2-9940-2d59-b92220948ffc@arm.com>
 <c0a848e3ababff4ee9ecaa4b246d5875@kernel.org>
 <ed7f31d5-9a2b-6ea0-85f8-74fcd7d9ac61@arm.com>
Message-ID: <89155997285a33615093210d6c4de26d@kernel.org>
X-Sender: maz@kernel.org
User-Agent: Roundcube Webmail/1.3.10
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: james.morse@arm.com, linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, peter.maydell@linaro.org,
 julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
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
Content-Type: text/plain; charset="utf-8"; Format="flowed"
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

T24gMjAyMC0wMi0xOSAxMDoxOCwgSmFtZXMgTW9yc2Ugd3JvdGU6Cj4gSGkgTWFyYywKPiAKPiBP
biAyLzE5LzIwIDk6NDYgQU0sIE1hcmMgWnluZ2llciB3cm90ZToKPj4gT24gMjAyMC0wMi0xOCAx
Nzo0MywgSmFtZXMgTW9yc2Ugd3JvdGU6Cj4+PiBIaSBNYXJjLAo+Pj4gCj4+PiBPbiAxNi8wMi8y
MDIwIDE4OjUzLCBNYXJjIFp5bmdpZXIgd3JvdGU6Cj4+Pj4gT3VyIFBNVSBjb2RlIGlzIG9ubHkg
aW1wbGVtZW50aW5nIHRoZSBBUk12OC4xIGZlYXR1cmVzLCBzbyBsZXQncwo+Pj4+IHN0aWNrIHRv
IHRoaXMgd2hlbiByZXBvcnRpbmcgdGhlIGZlYXR1cmUgc2V0IHRvIHRoZSBndWVzdC4KPj4+IAo+
Pj4+IGRpZmYgLS1naXQgYS9hcmNoL2FybTY0L2t2bS9zeXNfcmVncy5jIGIvYXJjaC9hcm02NC9r
dm0vc3lzX3JlZ3MuYwo+Pj4+IGluZGV4IDY4MmZlZGQ3NzAwZi4uMDZiMmQwZGM2YzczIDEwMDY0
NAo+Pj4+IC0tLSBhL2FyY2gvYXJtNjQva3ZtL3N5c19yZWdzLmMKPj4+PiArKysgYi9hcmNoL2Fy
bTY0L2t2bS9zeXNfcmVncy5jCj4+Pj4gQEAgLTEwOTMsNiArMTA5MywxMSBAQCBzdGF0aWMgdTY0
IHJlYWRfaWRfcmVnKGNvbnN0IHN0cnVjdCBrdm1fdmNwdQo+Pj4+ICp2Y3B1LAo+Pj4+IMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgRkVBVFVSRShJRF9BQTY0SVNBUjFfR1BBKSB8
Cj4+Pj4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBGRUFUVVJFKElEX0FBNjRJ
U0FSMV9HUEkpKTsKPj4+PiDCoMKgwqDCoMKgwqDCoMKgIGJyZWFrOwo+Pj4+ICvCoMKgwqAgY2Fz
ZSBTWVNfSURfQUE2NERGUjBfRUwxOgo+Pj4+ICvCoMKgwqDCoMKgwqDCoCAvKiBMaW1pdCBQTVUg
dG8gQVJNdjguMSAqLwo+Pj4gCj4+PiBOb3QganVzdCBsaW1pdCwgYnV0IHVwZ3JhZGUgdG9vISAo
Zm9yY2U/KQo+Pj4gVGhpcyBsb29rcyBzYWZlIGJlY2F1c2UgQVJNVjhfUE1VX0VWVFlQRV9FVkVO
VCBhbHdheXMgaW5jbHVkZXMgdGhlCj4+PiBleHRyYSBiaXRzIHRoaXMgYWRkZWQsIGFuZCB0aGUg
cmVnaXN0ZXIgaXMgYWx3YXlzIHRyYXBwZWQuCj4+IAo+PiBUaGF0J3MgZGVmaW5pdGVseSBub3Qg
d2hhdCBJIGludGVuZGVkISBMZXQgbWUgZml4IHRoYXQgb25lLgo+IAo+IFdoYXQgZ29lcyB3cm9u
Zz8KPiAKPiBUaGUgcmVnaXN0ZXIgZGVzY3JpcHRpb24gc2F5cyB0byBzdXBwb3J0IHY4LjEgeW91
IG5lZWQ6Cj4gfCBFeHRlbmRlZCAxNi1iaXQgUE1FVlRZUEVSPG4+X0VMMC5ldnRDb3VudCBmaWVs
ZAo+IHwgSWYgRUwyIGlzIGltcGxlbWVudGVkLCB0aGUgTURDUl9FTDIuSFBNRCBjb250cm9sIGJp
dAo+IAo+IEl0IGxvb2tzIGxpa2UgdGhlIGV4dGVuZGVkIFBNRVZUWVBFUiB3b3VsZCB3b3JrIHZp
YSB0aGUgZW11bGF0aW9uLCBhbmQKPiBFTDIgZ3Vlc3RzIGFyZSB0b3RhbGx5IGNyYXp5Lgo+IAo+
IElzIHRoZSBTVEFMTF8qIGJpdHMgaW4gQVJNdjguMS1QTVUgdGhlIHByb2JsZW0sIC4uLiBvciB0
aGUgZXh0cmEgd29yawo+IGZvciBOVj8KCldoYXQgZ29lcyB3cm9uZyBpcyB0aGF0IG9uIGEgdjgu
MCBzeXN0ZW0sIHRoZSBndWVzdCBjb3VsZCBiZSB0ZW1wdGVkIHRvCnVzZSBldmVudHMgaW4gdGhl
IDB4MDQwMC0weGZmZmYgcmFuZ2UuIEl0IHdvdWxkbid0IGJyZWFrIGFueXRoaW5nLCBidXQKaXQg
d291bGRuJ3QgZ2l2ZSB0aGUgZXhwZWN0ZWQgcmVzdWx0LgoKSSBkb24ndCBjYXJlIG11Y2ggZm9y
IFBNVSBzdXBwb3J0IGluIEVMMiBndWVzdHMgYXQgdGhpcyBzdGFnZS4KCj4+PiBUaGUgUE1VIHZl
cnNpb24gaXMgYWxzbyByZWFkYWJsZSB2aWEgSURfREZSMF9FTDEuUGVyZk1vbiwgc2hvdWxkIHRo
YXQKPj4+IGJlIHNhbml0aXNlZCB0byBiZSB0aGUgc2FtZT8gKEkgZG9uJ3QgdGhpbmsgd2UndmUg
aGlkZGVuIGFuIGFhcmNoNjQKPj4+IGZlYXR1cmUgdGhhdCBhbHNvIGV4aXN0ZWQgaW4gYWFyY2gz
MiBiZWZvcmUpLgo+PiAKPj4gSW5kZWVkLCB5ZXQgYW5vdGhlciBvdmVyc2lnaHQuIEknbGwgZml4
IHRoYXQgdG9vLgo+IAo+IChXZWlyZCB2YXJpYXRpb24gaW4gdGhlIGFhcmNoMzIgYW5kIGFhcmNo
NjQgSUQgcmVnaXN0ZXJzIGlzbid0IAo+IHNvbWV0aGluZwo+IEkgY2FyZSBhYm91dCAuLi4gd2hv
IHdvdWxkIGV2ZXIgbG9vayBhdCBib3RoPykKCkEgNjRiaXQgZ3Vlc3QgcnVubmluZyBhIDMyYml0
IEVMMD8KCiAgICAgICAgIE0uCi0tIApKYXp6IGlzIG5vdCBkZWFkLiBJdCBqdXN0IHNtZWxscyBm
dW5ueS4uLgpfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXwpr
dm1hcm0gbWFpbGluZyBsaXN0Cmt2bWFybUBsaXN0cy5jcy5jb2x1bWJpYS5lZHUKaHR0cHM6Ly9s
aXN0cy5jcy5jb2x1bWJpYS5lZHUvbWFpbG1hbi9saXN0aW5mby9rdm1hcm0K
