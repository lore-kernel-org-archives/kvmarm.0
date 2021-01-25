Return-Path: <SRS0=+Nyp=G4=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AAC59C433DB
	for <kvmarm@archiver.kernel.org>; Mon, 25 Jan 2021 16:19:00 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 20D8922AAA
	for <kvmarm@archiver.kernel.org>; Mon, 25 Jan 2021 16:18:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 20D8922AAA
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 905334B45F;
	Mon, 25 Jan 2021 11:18:59 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id GrzqTC3U5tpg; Mon, 25 Jan 2021 11:18:58 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 818654B61A;
	Mon, 25 Jan 2021 11:18:58 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6DF1B4B614
 for <kvmarm@lists.cs.columbia.edu>; Mon, 25 Jan 2021 11:18:57 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id DsW44hnL0BkR for <kvmarm@lists.cs.columbia.edu>;
 Mon, 25 Jan 2021 11:18:56 -0500 (EST)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 7E3B24B45F
 for <kvmarm@lists.cs.columbia.edu>; Mon, 25 Jan 2021 11:18:56 -0500 (EST)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 61CCE229C5;
 Mon, 25 Jan 2021 16:18:55 +0000 (UTC)
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78]
 helo=hot-poop.lan)
 by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.94)
 (envelope-from <maz@kernel.org>)
 id 1l44Zp-009uYc-Ce; Mon, 25 Jan 2021 16:18:53 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.cs.columbia.edu, Andrew Scull <ascull@google.com>,
 kernel-team@android.com
Subject: Re: (subset) [PATCH 0/2] __do_hyp_init fix and tweak
Date: Mon, 25 Jan 2021 16:18:44 +0000
Message-Id: <161159149159.2330090.18058973818718400886.b4-ty@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210125145415.122439-1-ascull@google.com>
References: <20210125145415.122439-1-ascull@google.com>
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: kvmarm@lists.cs.columbia.edu, ascull@google.com,
 kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
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

On Mon, 25 Jan 2021 14:54:13 +0000, Andrew Scull wrote:
> These apply on 5.11-rc4. The second is a fix for a clobbered register,
> the first is more cosmetic.
> 
> Thanks, David, for helping with build and boot tests after my logistical
> issues.
> 
> Andrew Scull (2):
>   KVM: arm64: Simplify __kvm_hyp_init HVC detection
>   KVM: arm64: Don't clobber x4 in __do_hyp_init
> 
> [...]

Applied to kvm-arm64/misc-5.12, thanks!

[1/2] KVM: arm64: Simplify __kvm_hyp_init HVC detection
      commit: 87b26801f02ca9d7a110eb598dae8cd5d3bcace2

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
