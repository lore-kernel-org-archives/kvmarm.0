Return-Path: <SRS0=xqRQ=MZ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 80E14C4338F
	for <kvmarm@archiver.kernel.org>; Mon,  2 Aug 2021 13:39:25 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id F0BB760FC4
	for <kvmarm@archiver.kernel.org>; Mon,  2 Aug 2021 13:39:24 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org F0BB760FC4
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 84D9E4A4C0;
	Mon,  2 Aug 2021 09:39:24 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Mee03IoneUHE; Mon,  2 Aug 2021 09:39:23 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 70DCF4A19F;
	Mon,  2 Aug 2021 09:39:23 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 13ABE4A19F
 for <kvmarm@lists.cs.columbia.edu>; Mon,  2 Aug 2021 09:39:22 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id fOyX2ouCY+Sr for <kvmarm@lists.cs.columbia.edu>;
 Mon,  2 Aug 2021 09:39:21 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 0625649F82
 for <kvmarm@lists.cs.columbia.edu>; Mon,  2 Aug 2021 09:39:20 -0400 (EDT)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id E1B5D60F6D;
 Mon,  2 Aug 2021 13:39:19 +0000 (UTC)
Received: from sofa.misterjones.org ([185.219.108.64] helo=hot-poop.lan)
 by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.94.2)
 (envelope-from <maz@kernel.org>)
 id 1mAYA1-002SiR-T6; Mon, 02 Aug 2021 14:39:18 +0100
From: Marc Zyngier <maz@kernel.org>
To: linux-arm-kernel@lists.infradead.org, Marc Zyngier <maz@kernel.org>,
 kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
Subject: Re: [PATCH v2 0/4] kvm-arm64: Fix PMU reset values (and more)
Date: Mon,  2 Aug 2021 14:39:10 +0100
Message-Id: <162791148977.3441299.3278138161976148684.b4-ty@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210719123902.1493805-1-maz@kernel.org>
References: <20210719123902.1493805-1-maz@kernel.org>
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org, maz@kernel.org,
 kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, drjones@redhat.com,
 robin.murphy@arm.com, alexandru.elisei@arm.com, alexandre.chartre@oracle.com,
 linux@arm.linux.org.uk, kernel-team@android.com, suzuki.poulose@arm.com,
 james.morse@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: kernel-team@android.com, Robin Murphy <robin.murphy@arm.com>,
 Russell King <linux@arm.linux.org.uk>
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

On Mon, 19 Jul 2021 13:38:58 +0100, Marc Zyngier wrote:
> This is the second version of the series initially posted at [1].
> 
> * From v1:
>   - Simplified masking in patch #1
>   - Added a patch dropping PMSWINC_EL0 as a shadow register, though it
>     is still advertised to userspace for the purpose of backward
>     compatibility of VM save/restore
>   - Collected ABs/RBs, with thanks
> 
> [...]

Applied to next, thanks!

[1/4] KVM: arm64: Narrow PMU sysreg reset values to architectural requirements
      commit: 0ab410a93d627ae73136d1a52c096262360b7992
[2/4] KVM: arm64: Drop unnecessary masking of PMU registers
      commit: f5eff40058a856c23c5ec2f31756f107a2b1ef84
[3/4] KVM: arm64: Disabling disabled PMU counters wastes a lot of time
      commit: ca4f202d08ba7f24cc97dce14c6d20ec7a679135
[4/4] KVM: arm64: Remove PMSWINC_EL0 shadow register
      commit: 7a3ba3095a32f9c4ec8f30d680fea5150e12c3f3

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
