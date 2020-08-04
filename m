Return-Path: <SRS0=bLIx=BO=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 27B18C433E0
	for <kvmarm@archiver.kernel.org>; Tue,  4 Aug 2020 17:16:39 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id B4C6A207FC
	for <kvmarm@archiver.kernel.org>; Tue,  4 Aug 2020 17:16:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="po6Awiu2"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B4C6A207FC
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 625CB4B1CF;
	Tue,  4 Aug 2020 13:16:38 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id e+ugHPeMXY46; Tue,  4 Aug 2020 13:16:37 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0418B4B72D;
	Tue,  4 Aug 2020 13:16:37 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 72CE94B475
 for <kvmarm@lists.cs.columbia.edu>; Tue,  4 Aug 2020 13:16:36 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Q1QbVjls0xJB for <kvmarm@lists.cs.columbia.edu>;
 Tue,  4 Aug 2020 13:16:35 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 3A7FA4B7BD
 for <kvmarm@lists.cs.columbia.edu>; Tue,  4 Aug 2020 13:16:33 -0400 (EDT)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 00B8F207FC;
 Tue,  4 Aug 2020 17:16:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1596561392;
 bh=KgUSQXHnQmyfVqBx7P8DiLDgLrGMLQ5sEeXPjkKaMgo=;
 h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
 b=po6Awiu2jyPPa8K7P1obOSX43I7xN26lmV3hDkANXkQYWOVML8pKHGk7i8bZvGsXJ
 C7YOUuBeHSAf5ybIvPArid5p2sVn2opD172H2vkd7LXJ3RBWN+wElJAYGQ02xwutbi
 T1rDroNvCn5e/s/uutC20fI/FKFmzW8QVPCvkUro=
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
 by disco-boy.misterjones.org with esmtpsa
 (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128) (Exim 4.92)
 (envelope-from <maz@kernel.org>)
 id 1k30YA-00HReQ-IA; Tue, 04 Aug 2020 18:16:30 +0100
MIME-Version: 1.0
Date: Tue, 04 Aug 2020 18:16:30 +0100
From: Marc Zyngier <maz@kernel.org>
To: =?UTF-8?Q?Alex_Benn=C3=A9e?= <alex.bennee@linaro.org>
Subject: Re: [PATCH  v1 3/3] kernel/configs: don't include PCI_QUIRKS in KVM
 guest configs
In-Reply-To: <87lfiumnc8.fsf@linaro.org>
References: <20200804124417.27102-1-alex.bennee@linaro.org>
 <20200804124417.27102-4-alex.bennee@linaro.org>
 <f80cfa932a650d8f7e8fc02a1656b4c2@kernel.org> <87r1smmpw5.fsf@linaro.org>
 <b78f8715bbaec8fc728a85d614b00688@kernel.org> <87lfiumnc8.fsf@linaro.org>
User-Agent: Roundcube Webmail/1.4.5
Message-ID: <dd535598ec1886f93f374ed5720b6c74@kernel.org>
X-Sender: maz@kernel.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: alex.bennee@linaro.org, kvm@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 kvmarm@lists.cs.columbia.edu, christoffer.dall@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org,
 kvm@vger.kernel.org, linux-kernel@vger.kernel.org
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

T24gMjAyMC0wOC0wNCAxNjo0MCwgQWxleCBCZW5uw6llIHdyb3RlOgo+IE1hcmMgWnluZ2llciA8
bWF6QGtlcm5lbC5vcmc+IHdyaXRlczoKPiAKPj4gT24gMjAyMC0wOC0wNCAxNTo0NCwgQWxleCBC
ZW5uw6llIHdyb3RlOgo+Pj4gTWFyYyBaeW5naWVyIDxtYXpAa2VybmVsLm9yZz4gd3JpdGVzOgo+
Pj4gCj4+Pj4gT24gMjAyMC0wOC0wNCAxMzo0NCwgQWxleCBCZW5uw6llIHdyb3RlOgo+Pj4+PiBU
aGUgVklSVElPX1BDSSBzdXBwb3J0IGlzIGFuIGlkZWFsaXNlZCBQQ0kgYnVzLCB3ZSBkb24ndCBu
ZWVkIGEgCj4+Pj4+IGJ1bmNoCj4+Pj4+IG9mIGJsb2F0IGZvciByZWFsIHdvcmxkIGhhcmR3YXJl
IGZvciBhIFZpcnRJTyBndWVzdC4KPj4+PiAKPj4+PiBXaG8gc2F5cyB0aGlzIGd1ZXN0IHdpbGwg
b25seSBoYXZlIHZpcnRpbyBkZXZpY2VzPwo+Pj4gCj4+PiBUaGlzIGlzIHRydWUgLSBhbHRob3Vn
aCB3aGF0IGlzIHRoZSBwb2ludCBvZiBrdm1fZ3Vlc3QuY29uZmlnPyBXZQo+Pj4gY2VydGFpbmx5
IHR1cm4gb24gYSB3aG9sZSBidW5jaCBvZiB2aXJ0IG9wdGltaXNlZCBwYXRod2F5cyB3aXRoCj4+
PiBQQVJBVklSVAo+Pj4gYW5kIEhZUEVSVklTT1JfR1VFU1QgYWxvbmcgd2l0aCB0aGUgcmVzdCBv
ZiBWaXJ0SU8uCj4+IAo+PiBNb3N0IG9mIHdoaWNoIGFjdHVhbGx5IHF1YWxpZmllcyBhcyBibG9h
dCBpdHNlbGYgYXMgZmFyIGFzIEtWTS9hcm02NAo+PiBpcyBjb25jZXJuZWQuLi4KPiAKPiBTbyBo
ZXJlIGlzIHRoZSBxdWVzdGlvbiAtIGRvZXMgdGhlIGtlcm5lbCBjYXJlIGFib3V0IGhhdmluZyBh
IGJsZXNzZWQKPiBjb25maWcgZm9yIGEgbWluaW1hbCB2aWFibGUgZ3Vlc3Q/IFRoZXkgYXJlIGNl
cnRhaW5seSB1c2VkIGluIHRoZSBjbG91ZAo+IGJ1dCBJIHVuZGVyc3RhbmQgdGhlIGtlcm5lbCBp
cyB0cnlpbmcgdG8gZ2V0IGF3YXkgZnJvbSBoYXZpbmcgYSB6b28gb2YKPiBjb25maWdzLiBXaGF0
IGlzIHRoZSBhY3R1YWwgcG9pbnQgb2Yga3ZtX2d1ZXN0LmNvbmZpZz8gSnVzdCBhbiBlYXN5Cj4g
ZW5hYmxpbmcgZm9yIGRldmVsb3BlcnM/CgpUaGUgY2xvdWQgdmVuZG9yIEkga25vdyBjZXJ0YWlu
bHkgZG9lc24ndCBwcm92aWRlIGEgImR1bWJlZCBkb3duIgprZXJuZWwgY29uZmlndXJhdGlvbi4g
V2hhdCB0aGV5IHJ1biBpcyBlaXRoZXIgYSBkaXN0cm8ga2VybmVsCm9yIHNvbWV0aGluZyB0aGF0
IGZpdHMgdGhlaXIgZW52aXJvbm1lbnQgKHdoaWNoIGRvZXMgaW5jbHVkZQpIVyBQQ0kgZGV2aWNl
cywgYW5kIGhhcmRseSBhbnkgdmlydGlvIGRldmljZSkuCgpNeSB0YWtlIGlzIHRoYXQgdGhpcyBr
dm0tc3BlY2lhbCBjb25maWcgaXNuJ3QgdGhhdCB1c2VmdWwgaW4KdGhlIHJlYWwgd29ybGQsIGFu
ZCBJIGRvbid0IGJlbGlldmUgdGhlcmUgaXMgc3VjaCB0aGluZyBhcyBhCiJtaW5pbWFsIHZpYWJs
ZSBndWVzdCIgY29uZmlnLCBjZXJ0YWlubHkgbm90IGFjcm9zcyBhcmNoaXRlY3R1cmVzCmFuZCBW
TU1zLiBIb3BlZnVsbHkgaXQgZml0cyBzb21lb25lJ3MgZGV2ZWxvcG1lbnQgd29ya2Zsb3csIGJ1
dAp0aGF0J3MgcHJvYmFibHkgaXQuCgogICAgICAgICAgTS4KLS0gCkphenogaXMgbm90IGRlYWQu
IEl0IGp1c3Qgc21lbGxzIGZ1bm55Li4uCl9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fCmt2bWFybSBtYWlsaW5nIGxpc3QKa3ZtYXJtQGxpc3RzLmNzLmNvbHVt
YmlhLmVkdQpodHRwczovL2xpc3RzLmNzLmNvbHVtYmlhLmVkdS9tYWlsbWFuL2xpc3RpbmZvL2t2
bWFybQo=
