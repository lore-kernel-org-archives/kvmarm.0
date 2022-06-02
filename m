Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D2BFACCA478
	for <kvmarm@archiver.kernel.org>; Thu,  2 Jun 2022 08:30:40 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4356B49B0E;
	Thu,  2 Jun 2022 04:30:40 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id MlkuEz52n+aF; Thu,  2 Jun 2022 04:30:39 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 20C7F40FD6;
	Thu,  2 Jun 2022 04:30:39 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C1E83411BD
 for <kvmarm@lists.cs.columbia.edu>; Thu,  2 Jun 2022 04:30:37 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ceVtDcuunkkZ for <kvmarm@lists.cs.columbia.edu>;
 Thu,  2 Jun 2022 04:30:36 -0400 (EDT)
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 9CD7C40BEF
 for <kvmarm@lists.cs.columbia.edu>; Thu,  2 Jun 2022 04:30:36 -0400 (EDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by dfw.source.kernel.org (Postfix) with ESMTPS id 8EC3660F30;
 Thu,  2 Jun 2022 08:30:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1B74C3411C;
 Thu,  2 Jun 2022 08:30:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1654158635;
 bh=vzY+G8+ASqCckXvQ6YmgGfQtJZDGIWLvqqnwao/JorY=;
 h=From:To:Cc:Subject:Date:From;
 b=FKrKjZIJXf8NSwXpdMQplv+lflcmI/vGdP15boyX6V9G8I3IBsENIov1YcxVs4rmG
 15ij0D6YDHrxvT22FpmGegYXwGYFNGvYP8Rq/K1dOBuufxKXuTbGc8HiGuHHaVegWg
 qQZsJ5Kf5gExnHzrNRNJGqF+IBiHBmVb/H2AZnSeTJEBuUr8dVaHDn+IzI+/pcOTS1
 1yhQ7blxRs/OXdDADdtwUP5sFj/9MfnCzSXEmHwRF9bUYfFePoqb1UCpStwhfktcyX
 22Ottjkzq2nguarEhDjHKG6YsEj7C6KVuSFZi4MBJTdJS/sDN35ftP+H8dCb+k6oro
 eHIaCw/vDv62A==
Received: from sofa.misterjones.org ([185.219.108.64] helo=why.lan)
 by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.94.2)
 (envelope-from <maz@kernel.org>)
 id 1nwgDw-00F9Sj-Op; Thu, 02 Jun 2022 09:30:32 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org,
 kvm@vger.kernel.org
Subject: [PATCH 0/3] KVM: arm64: Fix userspace access to HW pending state
Date: Thu,  2 Jun 2022 09:30:22 +0100
Message-Id: <20220602083025.1110433-1-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, eauger@redhat.com,
 ricarkol@google.com, james.morse@arm.com, suzuki.poulose@arm.com,
 alexandru.elisei@arm.com, oupton@google.com, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: kernel-team@android.com, Eric Auger <eauger@redhat.com>
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

Eric reported that a Seattle system was pretty unhappy about VM
migration, and the trace pointed to a glaring bug in the way the GICv2
emulation code reported the interrupt pending state to userspace for
HW interrupts, specially if the interrupt state is per-CPU, as this is
the case for the timer...

Fixing this actually results in a minor cleanup, followed by a bit of
extra hardening so that we can catch further issues in this area
without completely taking the system down.

Unless someone screams, I plan to take these in as fixes as quickly as
possible, with the first patch being an obvious stable candidate. I'd
appreciate it if people could verify that VM migration still works
correctly for both GICv2 and GICv3.

Thanks,

	M.

Marc Zyngier (3):
  KVM: arm64: Don't read a HW interrupt pending state in user context
  KVM: arm64: Replace vgic_v3_uaccess_read_pending with
    vgic_uaccess_read_pending
  KVM: arm64: Warn if accessing timer pending state outside of vcpu
    context

 arch/arm64/kvm/arch_timer.c        |  3 +++
 arch/arm64/kvm/vgic/vgic-mmio-v2.c |  4 +--
 arch/arm64/kvm/vgic/vgic-mmio-v3.c | 40 ++----------------------------
 arch/arm64/kvm/vgic/vgic-mmio.c    | 19 +++++++++++---
 arch/arm64/kvm/vgic/vgic-mmio.h    |  3 +++
 5 files changed, 26 insertions(+), 43 deletions(-)

-- 
2.34.1
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
