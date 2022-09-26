Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7AFA0C07E9D
	for <kvmarm@archiver.kernel.org>; Mon, 26 Sep 2022 14:51:35 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 167B14B81E;
	Mon, 26 Sep 2022 10:51:35 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id HUnYZGguEEfd; Mon, 26 Sep 2022 10:51:33 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4201C4B812;
	Mon, 26 Sep 2022 10:51:31 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9A1154B177
 for <kvmarm@lists.cs.columbia.edu>; Mon, 26 Sep 2022 10:51:29 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id zBEX5L57Ul6S for <kvmarm@lists.cs.columbia.edu>;
 Mon, 26 Sep 2022 10:51:28 -0400 (EDT)
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 190804B750
 for <kvmarm@lists.cs.columbia.edu>; Mon, 26 Sep 2022 10:51:28 -0400 (EDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ams.source.kernel.org (Postfix) with ESMTPS id 9A52EB80AC2;
 Mon, 26 Sep 2022 14:51:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4592EC433C1;
 Mon, 26 Sep 2022 14:51:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1664203885;
 bh=hACMPGN0g0CPIyg4hB23YBM8Mp+BbK53zAB1c30ImtU=;
 h=From:To:Cc:Subject:Date:From;
 b=tOId5mgp41bT91YpJWA6RGQCKvex7cmCkXAiFe0+gk6Wjg3HJBvPWqa40dPJ1Skwe
 Piy+0t0QjDuJFxcXXsyc1L+qxER4rtiSTFuHqF9Ra72CJpMillEEUOi7XE2GVTayoL
 e1+FwVwYdfzp6jKKsmbzgkfSX4CSGX9xFAhdHUoOkh51y+QjToUBcpEYzAlSTmHiH9
 uS2q7DVDLLfXExQuQ3/bVnw5ojtLU0Rd1m2nLAdPxFGvZz2b7b0jTbeGKC6eEvMIDC
 xXeDTpHzURvuITqwj8QG36jmrJK90L35TeCAOGrPo+WmBrMq6emhO6+4rcIwehCzaA
 wqXCGPh4dL7nw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=why.lan)
 by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.95)
 (envelope-from <maz@kernel.org>) id 1ocpS7-00Cips-1I;
 Mon, 26 Sep 2022 15:51:23 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.cs.columbia.edu,
	kvm@vger.kernel.org
Subject: [PATCH v2 0/6] KVM: Fix dirty-ring ordering on weakly ordered
 architectures
Date: Mon, 26 Sep 2022 15:51:14 +0100
Message-Id: <20220926145120.27974-1-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
 catalin.marinas@arm.com, bgardon@google.com, shuah@kernel.org,
 andrew.jones@linux.dev, will@kernel.org, dmatlack@google.com,
 peterx@redhat.com, pbonzini@redhat.com, zhenyzha@redhat.com,
 shan.gavin@gmail.com, gshan@redhat.com, james.morse@arm.com,
 suzuki.poulose@arm.com, alexandru.elisei@arm.com, oliver.upton@linux.dev
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: will@kernel.org, catalin.marinas@arm.com, andrew.jones@linux.dev,
 shan.gavin@gmail.com, bgardon@google.com, dmatlack@google.com,
 pbonzini@redhat.com, zhenyzha@redhat.com, shuah@kernel.org
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

[Same distribution list as Gavin's dirty-ring on arm64 series]

This is an update on the initial series posted as [0].

As Gavin started posting patches enabling the dirty-ring infrastructure
on arm64 [1], it quickly became apparent that the API was never intended
to work on relaxed memory ordering architectures (owing to its x86
origins).

This series tries to retrofit some ordering into the existing API by:

- relying on acquire/release semantics which are the default on x86,
  but need to be explicit on arm64

- adding a new capability that indicate which flavor is supported, either
  with explicit ordering (arm64) or both implicit and explicit (x86),
  as suggested by Paolo at KVM Forum

- documenting the requirements for this new capability on weakly ordered
  architectures

- updating the selftests to do the right thing

Ideally, this series should be a prefix of Gavin's, plus a small change
to his series:

diff --git a/arch/arm64/kvm/Kconfig b/arch/arm64/kvm/Kconfig
index 0309b2d0f2da..7785379c5048 100644
--- a/arch/arm64/kvm/Kconfig
+++ b/arch/arm64/kvm/Kconfig
@@ -32,7 +32,7 @@ menuconfig KVM
 	select KVM_VFIO
 	select HAVE_KVM_EVENTFD
 	select HAVE_KVM_IRQFD
-	select HAVE_KVM_DIRTY_RING
+	select HAVE_KVM_DIRTY_RING_ACQ_REL
 	select HAVE_KVM_MSI
 	select HAVE_KVM_IRQCHIP
 	select HAVE_KVM_IRQ_ROUTING

This has been very lightly tested on an arm64 box with Gavin's v3 [2] series.

* From v1:
  - Repainted the config symbols and new capability so that their
    naming is more acceptable and causes less churn
  - Fixed a couple of blunders as pointed out by Peter and Paolo
  - Updated the documentation

[0] https://lore.kernel.org/r/20220922170133.2617189-1-maz@kernel.org
[1] https://lore.kernel.org/lkml/YyiV%2Fl7O23aw5aaO@xz-m1.local/T/
[2] https://lore.kernel.org/r/20220922003214.276736-1-gshan@redhat.com

Marc Zyngier (6):
  KVM: Use acquire/release semantics when accessing dirty ring GFN state
  KVM: Add KVM_CAP_DIRTY_LOG_RING_ACQ_REL capability and config option
  KVM: x86: Select CONFIG_HAVE_KVM_DIRTY_RING_ACQ_REL
  KVM: Document weakly ordered architecture requirements for dirty ring
  KVM: selftests: dirty-log: Upgrade flag accesses to acquire/release
    semantics
  KVM: selftests: dirty-log: Use KVM_CAP_DIRTY_LOG_RING_ACQ_REL if
    available

 Documentation/virt/kvm/api.rst               | 17 +++++++++++++++--
 arch/x86/kvm/Kconfig                         |  3 ++-
 include/uapi/linux/kvm.h                     |  1 +
 tools/testing/selftests/kvm/dirty_log_test.c |  8 +++++---
 tools/testing/selftests/kvm/lib/kvm_util.c   |  5 ++++-
 virt/kvm/Kconfig                             | 14 ++++++++++++++
 virt/kvm/dirty_ring.c                        |  4 ++--
 virt/kvm/kvm_main.c                          |  9 ++++++++-
 8 files changed, 51 insertions(+), 10 deletions(-)

-- 
2.34.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
