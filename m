Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1BE75C433EF
	for <kvmarm@archiver.kernel.org>; Thu,  9 Jun 2022 12:12:35 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 83E294B374;
	Thu,  9 Jun 2022 08:12:35 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id ftc1qAMrijtB; Thu,  9 Jun 2022 08:12:34 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 562584B383;
	Thu,  9 Jun 2022 08:12:34 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D71AC4B394
 for <kvmarm@lists.cs.columbia.edu>; Thu,  9 Jun 2022 08:12:33 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id GWNSJPe9dBMP for <kvmarm@lists.cs.columbia.edu>;
 Thu,  9 Jun 2022 08:12:32 -0400 (EDT)
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 986834B36E
 for <kvmarm@lists.cs.columbia.edu>; Thu,  9 Jun 2022 08:12:32 -0400 (EDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ams.source.kernel.org (Postfix) with ESMTPS id D79FFB82D50;
 Thu,  9 Jun 2022 12:12:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5EF18C3411D;
 Thu,  9 Jun 2022 12:12:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1654776749;
 bh=nkrdzTl27ZX5FsRH9FRkRpM8Q0maYGT0vYT7F3D+ysY=;
 h=From:To:Cc:Subject:Date:From;
 b=l5MCbUfVka0iAhpTNF/yDW/bmtdbIbhYZr4QODS/KhOn44H6NTFleyN5DVKzO1deg
 W1uF5NlLM7FP4RH86nZ7ZX0CkE+U8u+9wvKqCxBdhVvbrRFPE2XYp0tB/opRryfhjR
 V0IqcBRuiUv94bM9hrObL2uhZj1vXPyq+l6PDoOBgm847eIIAPi0S2czPN0pVb/NSy
 YQFFApYZHqbHLU0rMk67EoANigbSNmqtqK96wepWphvrIZrUegfGe3gw3SGlEzmx9w
 8TwuyDdDpYVO6PFTTCQoaZbxfqlhilNv2Xx8pSzcKyfQzQsf9vP5jd3+5vwEAWTbzo
 n+QcXnB2wPTjQ==
From: Will Deacon <will@kernel.org>
To: kvmarm@lists.cs.columbia.edu
Subject: [PATCH 0/6] KVM/arm64: Minor/trivial fixes from pKVM mega-patch
Date: Thu,  9 Jun 2022 13:12:17 +0100
Message-Id: <20220609121223.2551-1-will@kernel.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Cc: Marc Zyngier <maz@kernel.org>, kernel-team@android.com,
 Will Deacon <will@kernel.org>, linux-arm-kernel@lists.infradead.org
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

Hi folks,

These six KVM/arm64 patches are very minor fixes (including "fixes" to
comments) which were previously posted as part of the pKVM mega-patch
but which can be merged independently of the rest of that. Marc -- I'm
not sure whether it's even worth taking these for 5.19, but here they
are so you can have a look and decide yourself.

Series based on 5.19-rc1.

Cheers,

Will

Cc: Marc Zyngier <maz@kernel.org>
Cc: Alexandru Elisei <alexandru.elisei@arm.com>
Cc: kernel-team@android.com
Cc: kvmarm@lists.cs.columbia.edu
Cc: linux-arm-kernel@lists.infradead.org

--->8

Marc Zyngier (2):
  KVM: arm64: Handle all ID registers trapped for a protected VM
  KVM: arm64: Drop stale comment

Will Deacon (4):
  KVM: arm64: Return error from kvm_arch_init_vm() on allocation failure
  KVM: arm64: Ignore 'kvm-arm.mode=protected' when using VHE
  KVM: arm64: Extend comment in has_vhe()
  KVM: arm64: Remove redundant hyp_assert_lock_held() assertions

 .../admin-guide/kernel-parameters.txt         |  1 -
 arch/arm64/include/asm/kvm_host.h             |  5 ---
 arch/arm64/include/asm/virt.h                 |  3 ++
 arch/arm64/kernel/cpufeature.c                | 10 +----
 arch/arm64/kvm/arm.c                          | 10 ++++-
 arch/arm64/kvm/hyp/nvhe/mem_protect.c         |  4 --
 arch/arm64/kvm/hyp/nvhe/sys_regs.c            | 42 +++++++++++++++----
 7 files changed, 46 insertions(+), 29 deletions(-)

-- 
2.36.1.255.ge46751e96f-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
