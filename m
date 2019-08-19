Return-Path: <SRS0=xA+Y=WP=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 83E2AC3A59B
	for <kvmarm@archiver.kernel.org>; Mon, 19 Aug 2019 07:33:30 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 0B27D2086C
	for <kvmarm@archiver.kernel.org>; Mon, 19 Aug 2019 07:33:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0B27D2086C
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=linutronix.de
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 612D54A5C6;
	Mon, 19 Aug 2019 03:33:29 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id QPK8PHsl8o+h; Mon, 19 Aug 2019 03:33:28 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 42BAE4A561;
	Mon, 19 Aug 2019 03:33:28 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2590A4A561
 for <kvmarm@lists.cs.columbia.edu>; Mon, 19 Aug 2019 03:33:27 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id HWKphnsaiU0g for <kvmarm@lists.cs.columbia.edu>;
 Mon, 19 Aug 2019 03:33:26 -0400 (EDT)
Received: from Galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 0B4834A552
 for <kvmarm@lists.cs.columbia.edu>; Mon, 19 Aug 2019 03:33:26 -0400 (EDT)
Received: from bigeasy by Galois.linutronix.de with local (Exim 4.80)
 (envelope-from <bigeasy@linutronix.de>)
 id 1hzcAM-0006WM-3i; Mon, 19 Aug 2019 09:33:22 +0200
Date: Mon, 19 Aug 2019 09:33:21 +0200
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Julien Grall <julien.grall@arm.com>
Subject: Re: KVM Arm64 and Linux-RT issues
Message-ID: <20190819073321.b3q2bxnslwwmdssn@linutronix.de>
References: <cd310858-2c0f-6af1-bf82-ee1e01a2cfb8@arm.com>
 <alpine.DEB.2.21.1907270053360.1791@nanos.tec.linutronix.de>
 <86zhkzn319.wl-maz@kernel.org>
 <960b5ed1-6d0f-3cee-da37-6061b4946c1a@arm.com>
 <20190813125835.5v26s4iuv44lw2xg@linutronix.de>
 <adc0b2e2-3a2e-5685-8eb5-2ce927d2139e@arm.com>
 <865zn1nidx.wl-maz@kernel.org>
 <1f76c277-665a-e962-8cbe-b3c4ecad41b0@arm.com>
 <20190816152317.pbhctfiyurjrepju@linutronix.de>
 <e9a77a95-ce0e-27a4-acb0-e997eb656e14@arm.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <e9a77a95-ce0e-27a4-acb0-e997eb656e14@arm.com>
User-Agent: NeoMutt/20180716
Cc: "linux-rt-users@vger.kernel.org" <linux-rt-users@vger.kernel.org>,
 Marc Zyngier <maz@kernel.org>, Andre Przywara <andre.przywara@arm.com>,
 Thomas Gleixner <tglx@linutronix.de>, anna-maria@linutronix.de,
 "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>
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

T24gMjAxOS0wOC0xNiAxNzozMjozOCBbKzAxMDBdLCBKdWxpZW4gR3JhbGwgd3JvdGU6Cj4gSGkg
U2ViYXN0aWFuLApIaSBKdWxpZW4sCgo+IGhydGltZXJfY2FsbGJhY2tfcnVubmluZygpIHdpbGwg
YmUgcmV0dXJuaW5nIHRydWUgYXMgdGhlIGNhbGxiYWNrIGlzCj4gcnVubmluZyBzb21ld2hlcmUg
ZWxzZS4gVGhpcyBtZWFucyBocnRpbWVyX3RyeV90b19jYW5jZWwoKQo+IHdvdWxkIHJldHVybiAt
MS4gVGhlcmVmb3JlIGhydGltZXJfZ3JhYl9leHBpcnlfbG9jaygpIHdvdWxkCj4gYmUgY2FsbGVk
Lgo+IAo+IERpZCBJIG1pc3MgYW55dGhpbmc/Cgpub3BlLCB5b3UgYXJlIHJpZ2h0LiBJIGFzc3Vt
ZWQgdGhhdCB3ZSBoYWQgY29kZSB0byBkZWFsIHdpdGggdGhpcyBidXQKZGlkbid0IGZpbmQgaXTi
gKYKCmRpZmYgLS1naXQgYS9rZXJuZWwvdGltZS9ocnRpbWVyLmMgYi9rZXJuZWwvdGltZS9ocnRp
bWVyLmMKaW5kZXggN2Q3ZGI4ODAyMTMxMS4uNDBkODNjNzA5NTAzZSAxMDA2NDQKLS0tIGEva2Vy
bmVsL3RpbWUvaHJ0aW1lci5jCisrKyBiL2tlcm5lbC90aW1lL2hydGltZXIuYwpAQCAtOTM0LDcg
KzkzNCw3IEBAIHZvaWQgaHJ0aW1lcl9ncmFiX2V4cGlyeV9sb2NrKGNvbnN0IHN0cnVjdCBocnRp
bWVyICp0aW1lcikKIHsKIAlzdHJ1Y3QgaHJ0aW1lcl9jbG9ja19iYXNlICpiYXNlID0gdGltZXIt
PmJhc2U7CiAKLQlpZiAoYmFzZSAmJiBiYXNlLT5jcHVfYmFzZSkgeworCWlmIChiYXNlICYmIGJh
c2UtPmNwdV9iYXNlICYmIGJhc2UtPmluZGV4IDwgTUFTS19TSElGVCkgewogCQlzcGluX2xvY2so
JmJhc2UtPmNwdV9iYXNlLT5zb2Z0aXJxX2V4cGlyeV9sb2NrKTsKIAkJc3Bpbl91bmxvY2soJmJh
c2UtPmNwdV9iYXNlLT5zb2Z0aXJxX2V4cGlyeV9sb2NrKTsKIAl9CgpUaGlzIHNob3VsZCBkZWFs
IHdpdGggaXQuCgo+IENoZWVycywKClNlYmFzdGlhbgpfX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fXwprdm1hcm0gbWFpbGluZyBsaXN0Cmt2bWFybUBsaXN0cy5j
cy5jb2x1bWJpYS5lZHUKaHR0cHM6Ly9saXN0cy5jcy5jb2x1bWJpYS5lZHUvbWFpbG1hbi9saXN0
aW5mby9rdm1hcm0K
