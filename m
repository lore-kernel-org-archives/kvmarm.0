Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3164EC4167B
	for <kvmarm@archiver.kernel.org>; Tue, 20 Dec 2022 20:09:37 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9101A4B63E;
	Tue, 20 Dec 2022 15:09:36 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id VJ5U2EIzADJU; Tue, 20 Dec 2022 15:09:35 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 626884B5ED;
	Tue, 20 Dec 2022 15:09:35 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DC9834B5E8
 for <kvmarm@lists.cs.columbia.edu>; Tue, 20 Dec 2022 15:09:33 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id sA5wBj+i3YBJ for <kvmarm@lists.cs.columbia.edu>;
 Tue, 20 Dec 2022 15:09:32 -0500 (EST)
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id B7DD64B125
 for <kvmarm@lists.cs.columbia.edu>; Tue, 20 Dec 2022 15:09:32 -0500 (EST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by dfw.source.kernel.org (Postfix) with ESMTPS id 38F7B615A0;
 Tue, 20 Dec 2022 20:09:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 973E4C433F1;
 Tue, 20 Dec 2022 20:09:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1671566971;
 bh=aejWCEP1Ig9CRiir1tLF+G/2ScDfsu7H9JTlto5/gDA=;
 h=From:To:Cc:Subject:Date:From;
 b=cgoL9l7oRHWxhVS0Y9LeBDv5/kXb27c3pcperwcn7+YbNfvyzu2E+PfU+mVUB1Qoc
 T/DKtxSUkyhDMODvew+mnkqFJJ9OChUygfQR+3PiHLJdNBYiLJ74X7qiWncaRZvQZI
 nU9XVULhkYEIaWbTPAhw7LsfDDRWLJjM0U7aRk3qVh9faJePTbnBI0MwDOkQ27odOB
 Cr0rV0D3H3Z3mS4ne3tlXY7G/5vEY3LwIKEIRcjFjIh4FFlZSCpcYifvshZ7WvhbhK
 KBdLnZbxflIJUzzdKL3nSUlm7iPbEA7xGz5g8w8Eff3KMTaalGw+TJFEy9n0ovI+cE
 j3KioqWzKN57Q==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
 by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.95)
 (envelope-from <maz@kernel.org>) id 1p7ivZ-00Dzct-9E;
 Tue, 20 Dec 2022 20:09:29 +0000
From: Marc Zyngier <maz@kernel.org>
To: <kvmarm@lists.cs.columbia.edu>, <kvmarm@lists.linux.dev>,
 kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH 0/3] KVM: arm64: Fix handling of S1PTW S2 fault on RO memslots
Date: Tue, 20 Dec 2022 20:09:20 +0000
Message-Id: <20221220200923.1532710-1-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.cs.columbia.edu, kvmarm@lists.linux.dev,
 kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, james.morse@arm.com,
 suzuki.poulose@arm.com, alexandru.elisei@arm.com, oliver.upton@linux.dev,
 ardb@kernel.org, will@kernel.org, qperret@google.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: Will Deacon <will@kernel.org>
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

Recent developments on the EFI front have resulted in guests that
simply won't boot if the page tables are in a read-only memslot and
that you're a bit unlucky in the way S2 gets paged in... The core
issue is related to the fact that we treat a S1PTW as a write, which
is close enough to what needs to be done. Until to get to RO memslots.

The first patch fixes this and is definitely a stable candidate. It
splits the faulting of page tables in two steps (RO translation fault,
followed by a writable permission fault -- should it even happen).
The second one is a potential optimisation. I'm not even sure it is
worth it. The last patch is totally optional, only tangentially
related, and randomly repainting stuff (maybe that's contagious, who
knows).

The whole thing is on top of Linus' tree as of today. The reason for
this very random choice is that there is a patch in v6.1-rc7 that
hides the problem, and that patch is reverted in rc8 (see commit
0ba09b1733878afe838fe35c310715fda3d46428). I also wanted to avoid
conflicts with kvmarm/next, so here you go.

I've tested the series on A55, M1 and M2. The original issue seems to
trigger best with 16kB pages, so please test with *other* page sizes!

	M.

Marc Zyngier (3):
  KVM: arm64: Fix S1PTW handling on RO memslots
  KVM: arm64: Handle S1PTW translation with TCR_HA set as a write
  KVM: arm64: Convert FSC_* over to ESR_ELx_FSC_*

 arch/arm64/include/asm/esr.h            |  9 ++++
 arch/arm64/include/asm/kvm_arm.h        | 15 -------
 arch/arm64/include/asm/kvm_emulate.h    | 60 ++++++++++++++++++++-----
 arch/arm64/kvm/hyp/include/hyp/fault.h  |  2 +-
 arch/arm64/kvm/hyp/include/hyp/switch.h |  2 +-
 arch/arm64/kvm/mmu.c                    | 21 +++++----
 6 files changed, 71 insertions(+), 38 deletions(-)

-- 
2.34.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
