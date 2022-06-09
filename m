Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 40617C43334
	for <kvmarm@archiver.kernel.org>; Thu,  9 Jun 2022 12:27:07 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C3A814B39C;
	Thu,  9 Jun 2022 08:27:06 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id YGTdn7AjgFn5; Thu,  9 Jun 2022 08:27:02 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E52404B3A3;
	Thu,  9 Jun 2022 08:27:02 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0CEA24B39C
 for <kvmarm@lists.cs.columbia.edu>; Thu,  9 Jun 2022 08:27:02 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id KxmwNzLd95xg for <kvmarm@lists.cs.columbia.edu>;
 Thu,  9 Jun 2022 08:27:00 -0400 (EDT)
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id DF53A4B32B
 for <kvmarm@lists.cs.columbia.edu>; Thu,  9 Jun 2022 08:27:00 -0400 (EDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by dfw.source.kernel.org (Postfix) with ESMTPS id 15FD361366;
 Thu,  9 Jun 2022 12:27:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 711A7C34114;
 Thu,  9 Jun 2022 12:26:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1654777619;
 bh=+usV+CgG9YFW6IEXmZQyi6B4aomPnWEgI3/MH7XRczs=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=Yx0lE9hg22SqYU+6Ucc5KliVRUnOMJuFeGtn7xctqlLOI5x3B4W39l1zedr4A8Iug
 +mIk39X+PJlPahU6yeO6K6RB9zW6yzm97lnMoyE4s2zfBWqV7/gpC8wikcBq3OLK1a
 vRZ7gGcTxPsDcoD4MwJmVVdh7MmyByY5KXqjY5WPVqILCWzxdPeC6G48PpjEgrsYyn
 l/erWDb/vTIoARcC4YSMrHgCX3viynOnZgKRea1OepFeUOIDSA1i+mmiZKoq3+tdLH
 dXp2I/DUHKl5ymEdqtGT7SIG3Ml5D2W8m9i6AWdteSMKvaVUvw2YZ4VUTJSvsSlr6K
 KmvG+qL6QF1ug==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
 by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.94.2)
 (envelope-from <maz@kernel.org>)
 id 1nzHFY-00Groj-W2; Thu, 09 Jun 2022 13:26:57 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.cs.columbia.edu,
	Will Deacon <will@kernel.org>
Subject: Re: [PATCH 0/6] KVM/arm64: Minor/trivial fixes from pKVM mega-patch
Date: Thu,  9 Jun 2022 13:26:52 +0100
Message-Id: <165477760499.331007.13922004364455904037.b4-ty@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220609121223.2551-1-will@kernel.org>
References: <20220609121223.2551-1-will@kernel.org>
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.cs.columbia.edu, will@kernel.org,
 linux-arm-kernel@lists.infradead.org, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: kernel-team@android.com, linux-arm-kernel@lists.infradead.org
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

On Thu, 9 Jun 2022 13:12:17 +0100, Will Deacon wrote:
> These six KVM/arm64 patches are very minor fixes (including "fixes" to
> comments) which were previously posted as part of the pKVM mega-patch
> but which can be merged independently of the rest of that. Marc -- I'm
> not sure whether it's even worth taking these for 5.19, but here they
> are so you can have a look and decide yourself.
> 
> Series based on 5.19-rc1.
> 
> [...]

Applied to fixes, thanks!

[1/6] KVM: arm64: Return error from kvm_arch_init_vm() on allocation failure
      commit: ae187fec75aa670a551d9662f83e3947d3f02a69
[2/6] KVM: arm64: Handle all ID registers trapped for a protected VM
      commit: fa7a17214488ef7df347dcd1a5594f69ea17f4dc
[3/6] KVM: arm64: Ignore 'kvm-arm.mode=protected' when using VHE
      commit: cde5042adf11b0a30a6ce0ec3d071afcf8d2efaf
[4/6] KVM: arm64: Extend comment in has_vhe()
      commit: 112f3bab41113dc53b4f35e9034b2208245bc002
[5/6] KVM: arm64: Remove redundant hyp_assert_lock_held() assertions
      commit: 5879c97f37022ff22a3f13174c24fcf2807fdbc0
[6/6] KVM: arm64: Drop stale comment
      commit: bcbfb588cf323929ac46767dd14e392016bbce04

Cheers,

	M.
-- 
Marc Zyngier <maz@kernel.org>

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
