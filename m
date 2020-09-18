Return-Path: <SRS0=n0cH=C3=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87397C43466
	for <kvmarm@archiver.kernel.org>; Fri, 18 Sep 2020 15:57:17 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 199CA238A0
	for <kvmarm@archiver.kernel.org>; Fri, 18 Sep 2020 15:57:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="l6RL7JR2"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 199CA238A0
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 888E24B1DA;
	Fri, 18 Sep 2020 11:57:16 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, body has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id ZWIwNqxsiCa9; Fri, 18 Sep 2020 11:57:15 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E4D774B1DB;
	Fri, 18 Sep 2020 11:57:12 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3AD3D4B1D2
 for <kvmarm@lists.cs.columbia.edu>; Fri, 18 Sep 2020 11:57:12 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Z804DJ2C42Qm for <kvmarm@lists.cs.columbia.edu>;
 Fri, 18 Sep 2020 11:57:11 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 5D40B4B171
 for <kvmarm@lists.cs.columbia.edu>; Fri, 18 Sep 2020 11:57:11 -0400 (EDT)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 79C622389E;
 Fri, 18 Sep 2020 15:57:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1600444630;
 bh=vA5PLQQRY/xkPeBiOz82rbt8QOuSuBotaq2VJex7mHM=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=l6RL7JR2ZsNkzQTluyv0GWIIOr7ekA9QSeYW3P5knpa4kCV/LhgRriDJlUoAIisKR
 MshF83VRQgX8RM1UrzT2jEtvMR415TDAdhOYRJFG8dsZrYtZin0pO/HLnWA3/0R5Lv
 8ImBdo4W2hbrIOSYewDE3qLqwr9XHbjl3mnxzs44=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78]
 helo=why.lan) by disco-boy.misterjones.org with esmtpsa
 (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256) (Exim 4.92)
 (envelope-from <maz@kernel.org>)
 id 1kJIl3-00D3F2-1Y; Fri, 18 Sep 2020 16:57:09 +0100
From: Marc Zyngier <maz@kernel.org>
To: linux-arm-kernel@lists.infradead.org,
 Alexandru Elisei <alexandru.elisei@arm.com>, kvmarm@lists.cs.columbia.edu,
 julien.thierry.kdev@gmail.com, Xiaofei Tan <tanxiaofei@huawei.com>,
 linux-kernel@vger.kernel.org, suzuki.poulose@arm.com, james.morse@arm.com,
 will@kernel.org, catalin.marinas@arm.com
Subject: Re: [PATCH v3] KVM: arm64: fix doc warnings in mmu code
Date: Fri, 18 Sep 2020 16:57:00 +0100
Message-Id: <160044458392.1301915.5239370632867337903.b4-ty@kernel.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <1600307269-50957-1-git-send-email-tanxiaofei@huawei.com>
References: <1600307269-50957-1-git-send-email-tanxiaofei@huawei.com>
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org,
 alexandru.elisei@arm.com, kvmarm@lists.cs.columbia.edu,
 julien.thierry.kdev@gmail.com, tanxiaofei@huawei.com,
 linux-kernel@vger.kernel.org, suzuki.poulose@arm.com, james.morse@arm.com,
 will@kernel.org, catalin.marinas@arm.com, linuxarm@huawei.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: linuxarm@huawei.com
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

On Thu, 17 Sep 2020 09:47:49 +0800, Xiaofei Tan wrote:
> Fix following warnings caused by mismatch bewteen function parameters
> and comments.
> arch/arm64/kvm/mmu.c:128: warning: Function parameter or member 'mmu' not described in '__unmap_stage2_range'
> arch/arm64/kvm/mmu.c:128: warning: Function parameter or member 'may_block' not described in '__unmap_stage2_range'
> arch/arm64/kvm/mmu.c:128: warning: Excess function parameter 'kvm' description in '__unmap_stage2_range'
> arch/arm64/kvm/mmu.c:499: warning: Function parameter or member 'writable' not described in 'kvm_phys_addr_ioremap'
> arch/arm64/kvm/mmu.c:538: warning: Function parameter or member 'mmu' not described in 'stage2_wp_range'
> arch/arm64/kvm/mmu.c:538: warning: Excess function parameter 'kvm' description in 'stage2_wp_range'

Applied to next, thanks!

[1/1] KVM: arm64: Fix doc warnings in mmu code
      commit: c9c0279cc02b4e161686de7ccd1973357f29db8c

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
