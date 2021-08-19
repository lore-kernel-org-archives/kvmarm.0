Return-Path: <SRS0=/4wP=NK=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C7754C4338F
	for <kvmarm@archiver.kernel.org>; Thu, 19 Aug 2021 10:47:41 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 456B561155
	for <kvmarm@archiver.kernel.org>; Thu, 19 Aug 2021 10:47:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 456B561155
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D5E314B0EE;
	Thu, 19 Aug 2021 06:47:40 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 62HJRl5y4TcB; Thu, 19 Aug 2021 06:47:36 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5C61D4B0ED;
	Thu, 19 Aug 2021 06:47:36 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id F10E84B0ED
 for <kvmarm@lists.cs.columbia.edu>; Thu, 19 Aug 2021 06:47:34 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id VUJscebH-u-1 for <kvmarm@lists.cs.columbia.edu>;
 Thu, 19 Aug 2021 06:47:34 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id E39214ACC9
 for <kvmarm@lists.cs.columbia.edu>; Thu, 19 Aug 2021 06:47:33 -0400 (EDT)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 2194461154;
 Thu, 19 Aug 2021 10:47:32 +0000 (UTC)
Received: from sofa.misterjones.org ([185.219.108.64] helo=hot-poop.lan)
 by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.94.2)
 (envelope-from <maz@kernel.org>)
 id 1mGfa6-005x1C-0z; Thu, 19 Aug 2021 11:47:30 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvm@vger.kernel.org, Ricardo Koller <ricarkol@google.com>,
 kvmarm@lists.cs.columbia.edu
Subject: Re: [PATCH] KVM: arm64: vgic: drop WARN from vgic_get_irq
Date: Thu, 19 Aug 2021 11:47:24 +0100
Message-Id: <162937003857.598624.13282260461070232329.b4-ty@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210818213205.598471-1-ricarkol@google.com>
References: <20210818213205.598471-1-ricarkol@google.com>
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvm@vger.kernel.org, ricarkol@google.com,
 kvmarm@lists.cs.columbia.edu, jingzhangos@google.com, pshier@google.com,
 oupton@google.com, james.morse@arm.com, rananta@google.com,
 suzuki.poulose@arm.com, catalin.marinas@arm.com, drjones@redhat.com,
 reijiw@google.com, alexandru.elisei@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: catalin.marinas@arm.com, pshier@google.com, rananta@google.com
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

On Wed, 18 Aug 2021 14:32:05 -0700, Ricardo Koller wrote:
> vgic_get_irq(intid) is used all over the vgic code in order to get a
> reference to a struct irq. It warns whenever intid is not a valid number
> (like when it's a reserved IRQ number). The issue is that this warning
> can be triggered from userspace (e.g., KVM_IRQ_LINE for intid 1020).
> 
> Drop the WARN call from vgic_get_irq.

Applied to next, thanks!

[1/1] KVM: arm64: vgic: drop WARN from vgic_get_irq
      commit: b9a51949cebcd57bfb9385d9da62ace52564898c

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
