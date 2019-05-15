Return-Path: <SRS0=1iCv=TP=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 43896C04E87
	for <kvmarm@archiver.kernel.org>; Wed, 15 May 2019 16:38:44 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id C733520873
	for <kvmarm@archiver.kernel.org>; Wed, 15 May 2019 16:38:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C733520873
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3E74F4A4A0;
	Wed, 15 May 2019 12:38:43 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id oetRtruGtiW7; Wed, 15 May 2019 12:38:41 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BC6F24A483;
	Wed, 15 May 2019 12:38:41 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 826D94A3A5
 for <kvmarm@lists.cs.columbia.edu>; Wed, 15 May 2019 12:38:40 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id TZYlMHRZB3Gl for <kvmarm@lists.cs.columbia.edu>;
 Wed, 15 May 2019 12:38:39 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E19C74A379
 for <kvmarm@lists.cs.columbia.edu>; Wed, 15 May 2019 12:38:38 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.72.51.249])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 4841C80D;
 Wed, 15 May 2019 09:38:38 -0700 (PDT)
Received: from donnerap.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com
 [10.72.51.249])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 8DDE13F703;
 Wed, 15 May 2019 09:38:35 -0700 (PDT)
Date: Wed, 15 May 2019 17:38:32 +0100
From: Andre Przywara <andre.przywara@arm.com>
To: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [RFC PATCH] KVM: arm/arm64: Enable direct irqfd MSI injection
Message-ID: <20190515173832.62afdd90@donnerap.cambridge.arm.com>
In-Reply-To: <20190318133040.1cfad9a4@why.wild-wind.fr.eu.org>
References: <1552833373-19828-1-git-send-email-yuzenghui@huawei.com>
 <86o969z42z.wl-marc.zyngier@arm.com>
 <20190318133040.1cfad9a4@why.wild-wind.fr.eu.org>
Organization: ARM
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; aarch64-unknown-linux-gnu)
MIME-Version: 1.0
Cc: mst@redhat.com, kvm@vger.kernel.org, "Raslan,
 KarimAllah" <karahmed@amazon.de>, linux-kernel@vger.kernel.org,
 pbonzini@redhat.com, kvmarm@lists.cs.columbia.edu,
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
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

On Mon, 18 Mar 2019 13:30:40 +0000
Marc Zyngier <marc.zyngier@arm.com> wrote:

Hi,

> On Sun, 17 Mar 2019 19:35:48 +0000
> Marc Zyngier <marc.zyngier@arm.com> wrote:
> 
> [...]
> 
> > A first approach would be to keep a small cache of the last few
> > successful translations for this ITS, cache that could be looked-up by
> > holding a spinlock instead. A hit in this cache could directly be
> > injected. Any command that invalidates or changes anything (DISCARD,
> > INV, INVALL, MAPC with V=0, MAPD with V=0, MOVALL, MOVI) should nuke
> > the cache altogether.  
> 
> And to explain what I meant with this, I've pushed a branch[1] with a
> basic prototype. It is good enough to get a VM to boot, but I wouldn't
> trust it for anything serious just yet.
> 
> If anyone feels like giving it a go and check whether it has any
> benefit performance wise, please do so.

So I took a stab at the performance aspect, and it took me a while to find
something where it actually makes a difference. The trick is to create *a
lot* of interrupts. This is my setup now:
- GICv3 and ITS
- 5.1.0 kernel vs. 5.1.0 plus Marc's rebased "ITS cache" patches on top
- 4 VCPU guest on a 4 core machine
- passing through a M.2 NVMe SSD (or a USB3 controller) to the guest
- running FIO in the guest, with:
  - 4K block size, random reads, queue depth 16, 4 jobs (small)
  - 1M block size, sequential reads, QD 1, 1 job (big)

For the NVMe disk I see a whopping 19% performance improvement with Marc's
series (for the small blocks). For a SATA SSD connected via USB3.0 I still
see 6% improvement. For NVMe there were 50,000 interrupts per second on
the host, the USB3 setup came only up to 10,000/s. For big blocks (with
IRQs in the low thousands/s) the win is less, but still a measurable 3%.

Now that I have the setup, I can rerun experiments very quickly (given I
don't loose access to the machine), so let me know if someone needs
further tests.

Cheers,
Andre.

> [1] https://git.kernel.org/pub/scm/linux/kernel/git/maz/arm-platforms.git/log/?h=kvm-arm64/its-translation-cache

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
