Return-Path: <SRS0=PaY3=E5=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A2A3CC63777
	for <kvmarm@archiver.kernel.org>; Mon, 23 Nov 2020 09:27:15 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id E57D720781
	for <kvmarm@archiver.kernel.org>; Mon, 23 Nov 2020 09:27:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="OEHWSkSi"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E57D720781
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4BC064B8F6;
	Mon, 23 Nov 2020 04:27:14 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id D00WIYkHpPAJ; Mon, 23 Nov 2020 04:27:13 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 30CB14B9A4;
	Mon, 23 Nov 2020 04:27:13 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id F3B0E4B930
 for <kvmarm@lists.cs.columbia.edu>; Mon, 23 Nov 2020 04:27:11 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id UXaKbOFM62qg for <kvmarm@lists.cs.columbia.edu>;
 Mon, 23 Nov 2020 04:27:10 -0500 (EST)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id BE75F4B8F6
 for <kvmarm@lists.cs.columbia.edu>; Mon, 23 Nov 2020 04:27:10 -0500 (EST)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 952B720773;
 Mon, 23 Nov 2020 09:27:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1606123629;
 bh=tKKya71aIfR/58bDPs9+LCebGD0IANotinwA5misRc8=;
 h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
 b=OEHWSkSi7cMWAlYqNXglNL846Y+HLs2L4s5husu6wOMdHlTXHEyan0J/Uz0I4zhHS
 lw+1zMzIfKEQYuRRaLy6ylaou1f7r50dYjm/3NaECxQlTIo+beNuw0O3YoMdBiVr49
 sDyUBmAzkajfLoNUb79ttjP07S61K1o8Uk3g0hY8=
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
 by disco-boy.misterjones.org with esmtpsa (TLS1.2) tls
 TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256 (Exim 4.94)
 (envelope-from <maz@kernel.org>)
 id 1kh87n-00CruO-KX; Mon, 23 Nov 2020 09:27:07 +0000
MIME-Version: 1.0
Date: Mon, 23 Nov 2020 09:27:07 +0000
From: Marc Zyngier <maz@kernel.org>
To: Shenming Lu <lushenming@huawei.com>
Subject: Re: [RFC PATCH v1 3/4] KVM: arm64: GICv4.1: Restore VLPI's pending
 state to physical side
In-Reply-To: <20201123065410.1915-4-lushenming@huawei.com>
References: <20201123065410.1915-1-lushenming@huawei.com>
 <20201123065410.1915-4-lushenming@huawei.com>
User-Agent: Roundcube Webmail/1.4.9
Message-ID: <5c724bb83730cdd5dcf7add9a812fa92@kernel.org>
X-Sender: maz@kernel.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: lushenming@huawei.com, james.morse@arm.com,
 julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com, eric.auger@redhat.com,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
 kvm@vger.kernel.org, linux-kernel@vger.kernel.org, christoffer.dall@arm.com,
 alex.williamson@redhat.com, kwankhede@nvidia.com, cohuck@redhat.com,
 cjia@nvidia.com, wanghaibin.wang@huawei.com, yuzenghui@huawei.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: Neo Jia <cjia@nvidia.com>, kvm@vger.kernel.org,
 Cornelia Huck <cohuck@redhat.com>, linux-kernel@vger.kernel.org,
 Kirti Wankhede <kwankhede@nvidia.com>,
 Alex Williamson <alex.williamson@redhat.com>, kvmarm@lists.cs.columbia.edu,
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

T24gMjAyMC0xMS0yMyAwNjo1NCwgU2hlbm1pbmcgTHUgd3JvdGU6Cj4gRnJvbTogWmVuZ2h1aSBZ
dSA8eXV6ZW5naHVpQGh1YXdlaS5jb20+Cj4gCj4gV2hlbiBzZXR0aW5nIHRoZSBmb3J3YXJkaW5n
IHBhdGggb2YgYSBWTFBJLCBpdCBpcyBtb3JlIGNvbnNpc3RlbnQgdG8KCkknbSBub3Qgc3VyZSBp
dCBpcyBtb3JlIGNvbnNpc3RlbnQuIEl0IGlzIGEgKm5ldyogYmVoYXZpb3VyLCBiZWNhdXNlIGl0
IApvbmx5Cm1hdHRlcnMgZm9yIG1pZ3JhdGlvbiwgd2hpY2ggaGFzIGJlZW4gc28gZmFyIHVuc3Vw
cG9ydGVkLgoKPiBhbHNvIHRyYW5zZmVyIHRoZSBwZW5kaW5nIHN0YXRlIGZyb20gaXJxLT5wZW5k
aW5nX2xhdGNoIHRvIFZQVCAKPiAoZXNwZWNpYWxseQo+IGluIG1pZ3JhdGlvbiwgdGhlIHBlbmRp
bmcgc3RhdGVzIG9mIFZMUElzIGFyZSByZXN0b3JlZCBpbnRvIGt2beKAmXMgdmdpYwo+IGZpcnN0
KS4gQW5kIHdlIGN1cnJlbnRseSBzZW5kICJJTlQrVlNZTkMiIHRvIHRyaWdnZXIgYSBWTFBJIHRv
IHBlbmRpbmcuCj4gCj4gU2lnbmVkLW9mZi1ieTogWmVuZ2h1aSBZdSA8eXV6ZW5naHVpQGh1YXdl
aS5jb20+Cj4gU2lnbmVkLW9mZi1ieTogU2hlbm1pbmcgTHUgPGx1c2hlbm1pbmdAaHVhd2VpLmNv
bT4KPiAtLS0KPiAgYXJjaC9hcm02NC9rdm0vdmdpYy92Z2ljLXY0LmMgfCAxMiArKysrKysrKysr
KysKPiAgMSBmaWxlIGNoYW5nZWQsIDEyIGluc2VydGlvbnMoKykKPiAKPiBkaWZmIC0tZ2l0IGEv
YXJjaC9hcm02NC9rdm0vdmdpYy92Z2ljLXY0LmMgCj4gYi9hcmNoL2FybTY0L2t2bS92Z2ljL3Zn
aWMtdjQuYwo+IGluZGV4IGI1ZmE3M2M5ZmQzNS4uY2MzYWI5Y2VhMTgyIDEwMDY0NAo+IC0tLSBh
L2FyY2gvYXJtNjQva3ZtL3ZnaWMvdmdpYy12NC5jCj4gKysrIGIvYXJjaC9hcm02NC9rdm0vdmdp
Yy92Z2ljLXY0LmMKPiBAQCAtNDE4LDYgKzQxOCwxOCBAQCBpbnQga3ZtX3ZnaWNfdjRfc2V0X2Zv
cndhcmRpbmcoc3RydWN0IGt2bSAqa3ZtLCAKPiBpbnQgdmlycSwKPiAgCWlycS0+aG9zdF9pcnEJ
PSB2aXJxOwo+ICAJYXRvbWljX2luYygmbWFwLnZwZS0+dmxwaV9jb3VudCk7Cj4gCj4gKwkvKiBU
cmFuc2ZlciBwZW5kaW5nIHN0YXRlICovCj4gKwlyZXQgPSBpcnFfc2V0X2lycWNoaXBfc3RhdGUo
aXJxLT5ob3N0X2lycSwKPiArCQkJCSAgICBJUlFDSElQX1NUQVRFX1BFTkRJTkcsCj4gKwkJCQkg
ICAgaXJxLT5wZW5kaW5nX2xhdGNoKTsKPiArCVdBUk5fUkFURUxJTUlUKHJldCwgIklSUSAlZCIs
IGlycS0+aG9zdF9pcnEpOwo+ICsKPiArCS8qCj4gKwkgKiBMZXQgaXQgYmUgcHJ1bmVkIGZyb20g
YXBfbGlzdCBsYXRlciBhbmQgZG9uJ3QgYm90aGVyCj4gKwkgKiB0aGUgTGlzdCBSZWdpc3Rlci4K
PiArCSAqLwo+ICsJaXJxLT5wZW5kaW5nX2xhdGNoID0gZmFsc2U7CgpJdCBvY2N1cnMgdG8gbWUg
dGhhdCBjYWxsaW5nIGludG8gaXJxX3NldF9pcnFjaGlwX3N0YXRlKCkgZm9yIGEgbGFyZ2UKbnVt
YmVyIG9mIGludGVycnVwdHMgY2FuIHRha2UgYSBzaWduaWZpY2FudCBhbW91bnQgb2YgdGltZS4g
SXQgaXMgYWxzbwpvZGQgdGhhdCB5b3UgZHVtcCB0aGUgVlBUIHdpdGggdGhlIFZQRSB1bm1hcHBl
ZCwgYnV0IHJlbHkgb24gdGhlIFZQRQpiZWluZyBtYXBwZWQgZm9yIHRoZSBvcHBvc2l0ZSBvcGVy
YXRpb24uCgpTaG91bGRuJ3QgdGhlc2UgYmUgc3ltbWV0cmljLCBhbGwgcGVyZm9ybWVkIHdoaWxl
IHRoZSBWUEUgaXMgdW5tYXBwZWQ/Ckl0IHdvdWxkIGFsc28gc2F2ZSBhIGxvdCBvZiBJVFMgdHJh
ZmZpYy4KCj4gKwo+ICBvdXQ6Cj4gIAltdXRleF91bmxvY2soJml0cy0+aXRzX2xvY2spOwo+ICAJ
cmV0dXJuIHJldDsKClRoYW5rcywKCiAgICAgICAgIE0uCi0tIApKYXp6IGlzIG5vdCBkZWFkLiBJ
dCBqdXN0IHNtZWxscyBmdW5ueS4uLgpfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fXwprdm1hcm0gbWFpbGluZyBsaXN0Cmt2bWFybUBsaXN0cy5jcy5jb2x1bWJp
YS5lZHUKaHR0cHM6Ly9saXN0cy5jcy5jb2x1bWJpYS5lZHUvbWFpbG1hbi9saXN0aW5mby9rdm1h
cm0K
