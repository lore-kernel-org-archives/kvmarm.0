Return-Path: <SRS0=nG5+=5I=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4CED0C4332B
	for <kvmarm@archiver.kernel.org>; Mon, 23 Mar 2020 08:25:36 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id CF6D32074D
	for <kvmarm@archiver.kernel.org>; Mon, 23 Mar 2020 08:25:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="tZ4grYy2"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org CF6D32074D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 64A274B0B4;
	Mon, 23 Mar 2020 04:25:35 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 0WsUiE4Y4mob; Mon, 23 Mar 2020 04:25:33 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0F12C4B0A3;
	Mon, 23 Mar 2020 04:25:33 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 485304B085
 for <kvmarm@lists.cs.columbia.edu>; Mon, 23 Mar 2020 04:25:31 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id wJ7oJYzcV-ej for <kvmarm@lists.cs.columbia.edu>;
 Mon, 23 Mar 2020 04:25:30 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 055704B07F
 for <kvmarm@lists.cs.columbia.edu>; Mon, 23 Mar 2020 04:25:29 -0400 (EDT)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id D447F2072E;
 Mon, 23 Mar 2020 08:25:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1584951929;
 bh=tqQ8PlsQArzeFElGfgu0kJhz7Czy0eqAc18ZQGW6JD8=;
 h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
 b=tZ4grYy2alHlUvPC7sxjJFVOb1mrLYtqyhRfBHfGnbDbVuviyeian+drdS/c1uww+
 6ZKBvhncRTZ8u0v/xdXoKvOz3n5fT6bjzdUDR4GPsILVepol0jbF2YhVx4JwV9nDtv
 5UaxhARaZQ4WTIaDKxaZmT0MmNSNNhz2LBe5rROs=
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
 by disco-boy.misterjones.org with esmtpsa
 (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128) (Exim 4.92)
 (envelope-from <maz@kernel.org>)
 id 1jGIOl-00Etsi-6T; Mon, 23 Mar 2020 08:25:27 +0000
MIME-Version: 1.0
Date: Mon, 23 Mar 2020 08:25:27 +0000
From: Marc Zyngier <maz@kernel.org>
To: Zenghui Yu <yuzenghui@huawei.com>
Subject: Re: [PATCH v5 20/23] KVM: arm64: GICv4.1: Plumb SGI implementation
 selection in the distributor
In-Reply-To: <cf5d7cf3-076f-47a7-83cf-717a619dc13e@huawei.com>
References: <20200304203330.4967-1-maz@kernel.org>
 <20200304203330.4967-21-maz@kernel.org>
 <72832f51-bbde-8502-3e03-189ac20a0143@huawei.com>
 <4a06fae9c93e10351276d173747d17f4@kernel.org>
 <1c9fdfc8-bdb2-88b6-4bdc-2b9254dfa55c@huawei.com>
 <256b58a9679412c96600217f316f424f@kernel.org>
 <cf5d7cf3-076f-47a7-83cf-717a619dc13e@huawei.com>
Message-ID: <1c10593ac5b75f37c6853fbc74daa481@kernel.org>
X-Sender: maz@kernel.org
User-Agent: Roundcube Webmail/1.3.10
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: yuzenghui@huawei.com, linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org, lorenzo.pieralisi@arm.com, jason@lakedaemon.net,
 rrichter@marvell.com, tglx@linutronix.de, eric.auger@redhat.com,
 james.morse@arm.com, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
 Jason Cooper <jason@lakedaemon.net>, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org, Robert Richter <rrichter@marvell.com>,
 Thomas Gleixner <tglx@linutronix.de>, kvmarm@lists.cs.columbia.edu,
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

SGkgWmVuZ2h1aSwKClsuLi5dCgo+PiBBbmQgYWN0dWFsbHksIG1heWJlIHdlIGNhbiBoYW5kbGUg
dGhhdCBwcmV0dHkgY2hlYXBseS4gSWYgdXNlcnNwYWNlCj4+IHRyaWVzIHRvIHJlc3RvcmUgR0lD
RF9UWVBFUjIgdG8gYSB2YWx1ZSB0aGF0IGlzbid0IHdoYXQgS1ZNIGNhbgo+PiBvZmZlciwgd2Ug
anVzdCByZXR1cm4gYW4gZXJyb3IuIEV4YWN0bHkgbGlrZSB3ZSBkbyBmb3IgR0lDRF9JSURSLgo+
PiBIZW5jZSB0aGUgZm9sbG93aW5nIHBhdGNoOgo+PiAKPj4gZGlmZiAtLWdpdCBhL3ZpcnQva3Zt
L2FybS92Z2ljL3ZnaWMtbW1pby12My5jIAo+PiBiL3ZpcnQva3ZtL2FybS92Z2ljL3ZnaWMtbW1p
by12My5jCj4+IGluZGV4IDI4YjYzOWZkMWFiYy4uZTcyZGNjNDU0MjQ3IDEwMDY0NAo+PiAtLS0g
YS92aXJ0L2t2bS9hcm0vdmdpYy92Z2ljLW1taW8tdjMuYwo+PiArKysgYi92aXJ0L2t2bS9hcm0v
dmdpYy92Z2ljLW1taW8tdjMuYwo+PiBAQCAtMTU2LDYgKzE1Niw3IEBAIHN0YXRpYyBpbnQgdmdp
Y19tbWlvX3VhY2Nlc3Nfd3JpdGVfdjNfbWlzYyhzdHJ1Y3QgCj4+IGt2bV92Y3B1ICp2Y3B1LAo+
PiAgwqDCoMKgwqAgc3RydWN0IHZnaWNfZGlzdCAqZGlzdCA9ICZ2Y3B1LT5rdm0tPmFyY2gudmdp
YzsKPj4gCj4+ICDCoMKgwqDCoCBzd2l0Y2ggKGFkZHIgJiAweDBjKSB7Cj4+ICvCoMKgwqAgY2Fz
ZSBHSUNEX1RZUEVSMjoKPj4gIMKgwqDCoMKgIGNhc2UgR0lDRF9JSURSOgo+PiAgwqDCoMKgwqDC
oMKgwqDCoCBpZiAodmFsICE9IHZnaWNfbW1pb19yZWFkX3YzX21pc2ModmNwdSwgYWRkciwgbGVu
KSkKPj4gIMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCByZXR1cm4gLUVJTlZBTDsKPj4gCj4+IEJl
aW5nIGEgUk8gcmVnaXN0ZXIsIHdyaXRpbmcgc29tZXRoaW5nIHRoYXQgaXNuJ3QgY29tcGF0aWJs
ZSB3aXRoIHRoZQo+PiBwb3NzaWJsZSBiZWhhdmlvdXIgb2YgdGhlIGh5cGVydmlzb3Igd2lsbCBq
dXN0IHJldHVybiBhbiBlcnJvci4KPiAKPiBUaGlzIGlzIHJlYWxseSBhIG5pY2UgcG9pbnQgdG8g
YWRkcmVzcyBteSBjb25jZXJuISBJJ20gaGFwcHkgdG8gc2VlCj4gdGhpcyBpbiB2NiBub3cuCj4g
Cj4+IAo+PiBXaGF0IGRvIHlvdSB0aGluaz8KPiAKPiBJIGFncmVlZCB3aXRoIHlvdSwgd2l0aCBh
IGJpdCBuZXJ2b3VzIHRob3VnaC4gU29tZSBvbGQgZ3Vlc3RzICh3aGljaAo+IGhhdmUgbm8ga25v
d2xlZGdlIGFib3V0IEdJQ3Y0LjEgdlNHSXMgYW5kIGRvbid0IGNhcmUgYWJvdXQgbkFTU0dJY2Fw
Cj4gYXQgYWxsKSB3aWxsIGFsc28gZmFpbCB0byBtaWdyYXRlIGZyb20gQSB0byBCLCBqdXN0IGJl
Y2F1c2Ugbm93IHdlCj4gcHJlc2VudCB0d28gZGlmZmVyZW50ICh1bnVzZWQpIEdJQ0RfVFlQRVIy
IHJlZ2lzdGVycyB0byB0aGVtLgo+IAo+IElzIGl0IGEgbGl0dGxlIHVuZmFpciB0byB0aGVtIDot
KSA/CgpJIG5ldmVyIHByZXRlbmRlZCB0byBiZSBmYWlyISA7LSkKCkknbSBoYXBweSB0byBwcmV2
ZW50IG1pZ3JhdGluZyBmcm9tIGEgdjQuMSBzeXN0ZW0gKEEpIHRvIGEgdjQuMApzeXN0ZW0gKEIp
LiBBcyBzb29uIGFzIHRoZSBndWVzdCBoYXMgcnVuLCBpdCBpc24ndCBzYWZlIHRvIGRvIHNvCihp
dCBtYXkgaGF2ZSByZWFkIFRZUEVSMiwgYW5kIG5vdyBrbm93cyBhYm91dCB2U0dJcykuIFdlICpj
b3VsZCoKdHJhY2sgdGhpcyBhbmQgZmluZCB3YXlzIHRvIG1pZ3JhdGUgdGhpcyBzdGF0ZSBhcyB3
ZWxsLCBidXQgaXQKZmVlbHMgZnJhZ2lsZS4KCk1pZ3JhdGluZyBmcm9tIEIgdG8gQSBpcyBtb3Jl
IGFwcGVhbGluZy4gSXQgc2hvdWxkIGJlIHBvc3NpYmxlIHRvCmRvIHNvIHdpdGhvdXQgbXVjaCBk
aWZmaWN1bHR5IChqdXN0IGNoZWNrIHRoYXQgdGhlIG5BU1NHSWNhcCBiaXQKaXMgZWl0aGVyIDAg
b3IgZXF1YWwgdG8gS1ZNJ3MgdmlldyBvZiB0aGUgY2FwYWJpbGl0eSkuCgpCdXQgb3ZlcmFsbCBJ
IHNlcmlvdXNseSBkb3VidCB3ZSBjYW4gZWFzaWx5IG1pZ3JhdGUgZ3Vlc3RzIGFjcm9zcwp2ZXJ5
IGRpZmZlcmVudCBIVy4gV2UndmUgYmVlbiB0YWxraW5nIGFib3V0IHRoaXMgZm9yIHllYXJzLCBh
bmQKd2Ugc3RpbGwgZG9uJ3QgaGF2ZSBhIGdvb2Qgc29sdXRpb24gZm9yIGl0IGdpdmVuIHRoZSBk
aXZlcnNpdHkKb2YgdGhlIGVjb3N5c3RlbS4uLiA6LS8KClRoYW5rcywKCiAgICAgICAgIE0uCi0t
IApKYXp6IGlzIG5vdCBkZWFkLiBJdCBqdXN0IHNtZWxscyBmdW5ueS4uLgpfX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXwprdm1hcm0gbWFpbGluZyBsaXN0Cmt2
bWFybUBsaXN0cy5jcy5jb2x1bWJpYS5lZHUKaHR0cHM6Ly9saXN0cy5jcy5jb2x1bWJpYS5lZHUv
bWFpbG1hbi9saXN0aW5mby9rdm1hcm0K
