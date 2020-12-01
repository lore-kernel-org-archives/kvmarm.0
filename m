Return-Path: <SRS0=s1GN=FF=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 075E9C64E7A
	for <kvmarm@archiver.kernel.org>; Tue,  1 Dec 2020 10:59:08 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 30E5A206CB
	for <kvmarm@archiver.kernel.org>; Tue,  1 Dec 2020 10:59:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="Hh/Scuta"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 30E5A206CB
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 663734BD55;
	Tue,  1 Dec 2020 05:59:06 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id GdOt-yUpO1Be; Tue,  1 Dec 2020 05:59:04 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7EA0D4BD56;
	Tue,  1 Dec 2020 05:59:04 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E17AC4BCF1
 for <kvmarm@lists.cs.columbia.edu>; Tue,  1 Dec 2020 05:59:03 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id vMkXVNQK6uOC for <kvmarm@lists.cs.columbia.edu>;
 Tue,  1 Dec 2020 05:59:02 -0500 (EST)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id C00D34B37E
 for <kvmarm@lists.cs.columbia.edu>; Tue,  1 Dec 2020 05:59:02 -0500 (EST)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 6AC6C20809;
 Tue,  1 Dec 2020 10:58:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1606820339;
 bh=fjeXvv1+eOJ5uqv6M23051ubV3+oKlwmWBbroYxu4fw=;
 h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
 b=Hh/ScutavvVCdCl58vcCojICg7CUUG5ERNrak0LxRYScrExjctS6PH40T0x1BYSkQ
 o0GVgS1ppX077mlPbIml6Z4xF2DkBGekEKRDTslWE0H8Vxa/nLK4wxF/oIEoyg+cHe
 z74rNevxrT0YthG8Hguh1Bjx2nwzVQpxpD8Pu6+A=
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
 by disco-boy.misterjones.org with esmtpsa (TLS1.2) tls
 TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256 (Exim 4.94)
 (envelope-from <maz@kernel.org>)
 id 1kk3N1-00F13G-9R; Tue, 01 Dec 2020 10:58:55 +0000
MIME-Version: 1.0
Date: Tue, 01 Dec 2020 10:58:54 +0000
From: Marc Zyngier <maz@kernel.org>
To: luojiaxing <luojiaxing@huawei.com>
Subject: Re: [RFC PATCH v1 1/4] irqchip/gic-v4.1: Plumb get_irqchip_state VLPI
 callback
In-Reply-To: <316fe41d-f004-f004-4f31-6fe6e7ff64b7@huawei.com>
References: <20201123065410.1915-1-lushenming@huawei.com>
 <20201123065410.1915-2-lushenming@huawei.com>
 <869dbc36-c510-fd00-407a-b05e068537c8@huawei.com>
 <875z5p6ayp.wl-maz@kernel.org>
 <316fe41d-f004-f004-4f31-6fe6e7ff64b7@huawei.com>
User-Agent: Roundcube Webmail/1.4.9
Message-ID: <7f578fa825b946f74e9ebdee557d6804@kernel.org>
X-Sender: maz@kernel.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: luojiaxing@huawei.com, lushenming@huawei.com,
 james.morse@arm.com, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com,
 eric.auger@redhat.com, linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org, christoffer.dall@arm.com,
 alex.williamson@redhat.com, kwankhede@nvidia.com, cohuck@redhat.com,
 cjia@nvidia.com, wanghaibin.wang@huawei.com, yuzenghui@huawei.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: Cornelia Huck <cohuck@redhat.com>, Neo Jia <cjia@nvidia.com>,
 kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 Kirti Wankhede <kwankhede@nvidia.com>, Shenming Lu <lushenming@huawei.com>,
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

T24gMjAyMC0xMi0wMSAwOTozOCwgbHVvamlheGluZyB3cm90ZToKPiBPbiAyMDIwLzExLzI4IDE4
OjE4LCBNYXJjIFp5bmdpZXIgd3JvdGU6Cj4+IE9uIFNhdCwgMjggTm92IDIwMjAgMDc6MTk6NDgg
KzAwMDAsCj4+IGx1b2ppYXhpbmcgPGx1b2ppYXhpbmdAaHVhd2VpLmNvbT4gd3JvdGU6Cgo+Pj4g
SG93IGNhbiB5b3UgY29uZmlybSB0aGF0IHRoZSBpbnRlcnJ1cHQgcGVuZGluZyBzdGF0dXMgaXMg
dGhlIGxhdGVzdD8KPj4+IElzIGl0IHBvc3NpYmxlIHRoYXQgdGhlIGludGVycnVwdCBwZW5kaW5n
IHN0YXR1cyBpcyBzdGlsbCBjYWNoZWQgaW4KPj4+IHRoZSBHSUNSIGJ1dCBub3Qgc3luY2hyb25p
emVkIHRvIHRoZSBtZW1vcnkuCj4+IFRoYXQncyBhIGNvbnNlcXVlbmNlIG9mIHRoZSB2UEUgaGF2
aW5nIGJlZW4gdW5tYXBwZWQ6Cj4+IAo+PiAiQSBWTUFQUCB3aXRoIHtWLEFsbG9jfT09ezAsMX0g
Y2xlYW5zIGFuZCBpbnZhbGlkYXRlcyBhbnkgY2FjaGluZyBvZgo+PiB0aGUgVmlydHVhbCBQZW5k
aW5nIFRhYmxlIGFuZCBWaXJ0dWFsIENvbmZpZ3VyYXRpb24gVGFibGUgYXNzb2NpYXRlZAo+PiB3
aXRoIHRoZSB2UEVJRCBoZWxkIGluIHRoZSBHSUMuIgo+IAo+IAo+IFllcywgaW4gYWRkaXRpb24g
dG8gdGhhdCwgaWYgYSB2UEUgaXMgc2NoZWR1bGVkIG91dCBvZiB0aGUgUEUsIHRoZQo+IGNhY2hl
IGNsZWFyaW5nIGFuZCB3cml0ZS1iYWNrIHRvIFZQVCBhcmUgYWxzbyBwZXJmb3JtZWQsIEkgdGhp
bmsuCgpUaGVyZSBpcyBubyBzdWNoIGFyY2hpdGVjdHVyYWwgcmVxdWlyZW1lbnQuCgo+IEhvd2V2
ZXIsIEkgZmVlbCBhIGxpdHRlciBjb25mdXNpbmcgdG8gcmVhZCB0aGlzIGNvbW1lbnQgYXQgZmly
c3QgLMKgCj4gYmVjYXVzZSBpdCBpcyBub3Qgb25seSBWTUFQUCB0aGF0IGNhdXNlcyBjYWNoZSBj
bGVhcmluZy4KCkkgY2FuJ3Qgc2VlIGFueXRoaW5nIGVsc2UgdGhhdCBndWFyYW50ZWUgdGhhdCB0
aGUgY2FjaGVzIGFyZSBjbGVhbiwKYW5kIHRoYXQgdGhlcmUgaXMgbm8gcG9zc2libGUgd3JpdGUg
dG8gdGhlIFBFIHRhYmxlLgoKPiBJIGRvbid0IGtub3cgd2h5IFZNQVBQIHdhcyBtZW50aW9uZWQg
aGVyZSB1bnRpbCBJIGNoZWNrIHRoZSBvdGhlciB0d28KPiBwYXRjaGVzICgiS1ZNOiBhcm02NDog
R0lDdjQuMTogVHJ5IHRvIHNhdmUgaHcgcGVuZGluZyBzdGF0ZSBpbgo+IHNhdmVfcGVuZGluZ190
YWJsZXMiKS4KPiAKPiBTbyBJIHRoaW5rIG1heSBiZSBpdCdzIGJldHRlciB0byBhZGQgc29tZSBi
YWNrZ3JvdW5kIGRlc2NyaXB0aW9uIGhlcmUuCgpXZWxsLCByZWx5aW5nIG9uIHRoZSBzdGFuZGFy
ZCBpcnFjaGlwIHN0YXRlIG1ldGhvZHMgdG8gcGVlayBhdCB0aGUKcGVuZGluZyBzdGF0ZSBpc24n
dCB2ZXJ5IHJlbGlhYmxlLCBhcyB5b3UgY291bGQgYmUgdGVtcGVkIHRvIGNhbGwgaW50bwp0aGlz
IGV2ZW4gd2hlbiB0aGUgVlBFIGlzIG1hcHBlZC4gV2hpY2ggaXMgd2h5IEkndmUgc3VnZ2VzdGVk
CmEgZGlmZmVyZW50IGltcGxlbWVudGF0aW9uLgoKICAgICAgICAgTS4KLS0gCkphenogaXMgbm90
IGRlYWQuIEl0IGp1c3Qgc21lbGxzIGZ1bm55Li4uCl9fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fCmt2bWFybSBtYWlsaW5nIGxpc3QKa3ZtYXJtQGxpc3RzLmNz
LmNvbHVtYmlhLmVkdQpodHRwczovL2xpc3RzLmNzLmNvbHVtYmlhLmVkdS9tYWlsbWFuL2xpc3Rp
bmZvL2t2bWFybQo=
