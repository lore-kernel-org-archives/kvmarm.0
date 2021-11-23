Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 59D18C4332F
	for <kvmarm@archiver.kernel.org>; Tue, 23 Nov 2021 14:23:04 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C16724B1DD;
	Tue, 23 Nov 2021 09:23:03 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id U+jl7uDVH+OS; Tue, 23 Nov 2021 09:23:01 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D1B4A4B18F;
	Tue, 23 Nov 2021 09:23:01 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4821E4B1DD
 for <kvmarm@lists.cs.columbia.edu>; Tue, 23 Nov 2021 09:23:00 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id UPFI9vP76mtG for <kvmarm@lists.cs.columbia.edu>;
 Tue, 23 Nov 2021 09:22:59 -0500 (EST)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 5565F4B18F
 for <kvmarm@lists.cs.columbia.edu>; Tue, 23 Nov 2021 09:22:59 -0500 (EST)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 67E976052B;
 Tue, 23 Nov 2021 14:22:58 +0000 (UTC)
Received: from sofa.misterjones.org ([185.219.108.64] helo=why.lan)
 by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.94.2)
 (envelope-from <maz@kernel.org>)
 id 1mpWhE-007Ijf-9C; Tue, 23 Nov 2021 14:22:56 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org
Subject: [PATCH 0/2] KVM/arm64: Early PSTATE evaluation fixes
Date: Tue, 23 Nov 2021 14:22:45 +0000
Message-Id: <20211123142247.62532-1-maz@kernel.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, james.morse@arm.com,
 suzuki.poulose@arm.com, alexandru.elisei@arm.com, will@kernel.org,
 qperret@google.com, tabba@google.com, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: kernel-team@android.com, Will Deacon <will@kernel.org>
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

There are a number of cases where we evaluate PSTATE early on guest
exit. Nothing wrong with that. Except that we actually synchronise
KVM's view of PSTATE pretty late, way after we needed it. Oopsie boo.

Thankfully, there are only two paths that require it: GICv3 emulation
for 32bit guests, and trap handling of 32bit guests in protected
mode. There is no known need of the former (though you could enable it
on the command line), and the latter is still a work in progress. In
any case, this needs fixing.

Funnily enough, this is something that I had already solved on NV, so
the solution isn't that different from what I have there.

Unless someone shouts, I intend to merge these as fixes.

Marc Zyngier (2):
  KVM: arm64: Save PSTATE early on exit
  KVM: arm64: Move pkvm's special 32bit handling into a generic
    infrastructure

 arch/arm64/kvm/hyp/include/hyp/switch.h    | 14 ++++++++++++++
 arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h |  7 ++++++-
 arch/arm64/kvm/hyp/nvhe/switch.c           |  8 +-------
 arch/arm64/kvm/hyp/vhe/switch.c            |  4 ++++
 4 files changed, 25 insertions(+), 8 deletions(-)

-- 
2.30.2

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
