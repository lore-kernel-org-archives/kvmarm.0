Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A6BEBC6FA82
	for <kvmarm@archiver.kernel.org>; Thu, 22 Sep 2022 17:02:03 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 602A64B639;
	Thu, 22 Sep 2022 13:02:03 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id JNktZx94a9t1; Thu, 22 Sep 2022 13:02:02 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 393974B62C;
	Thu, 22 Sep 2022 13:02:02 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 07E0D4B24C
 for <kvmarm@lists.cs.columbia.edu>; Thu, 22 Sep 2022 13:01:59 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id qckIZMx7yhHA for <kvmarm@lists.cs.columbia.edu>;
 Thu, 22 Sep 2022 13:01:56 -0400 (EDT)
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 3119F40BD3
 for <kvmarm@lists.cs.columbia.edu>; Thu, 22 Sep 2022 13:01:56 -0400 (EDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by dfw.source.kernel.org (Postfix) with ESMTPS id 45E75636B1;
 Thu, 22 Sep 2022 17:01:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C8D6C433D6;
 Thu, 22 Sep 2022 17:01:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1663866115;
 bh=Ck/O3xTFyNsn3pXALp+pBC+2zu95kxeuiXwd91ircVE=;
 h=From:To:Cc:Subject:Date:From;
 b=qgVvrTZzYqRKg9l5SRppQrZihLSM/6L11xeZWJAqw/kafrlfShjitaODMY2YgpmDZ
 ZG4v1mm+Rwsw/KftVstcNI7lGAvuG4H+AS3S14mhHywQ8VXeoeWOZfp/BOv4R3+Juc
 IwEjmczXjmmUQGDkN135NyWpnTkI5JEFGfjUCp0+ya3tG+vC9YPQTzP4WUKmAa6KAe
 GEPdqqfQV0vRoA7CpjIqYnGdjLAZs90lcQYvHl2CQ1nocaoIo8H5Co7XxuBRSHFejc
 4yRFf57tmM26c44snlLmX0mOnRKRPfRc3I+7Y3k3fJRcOORiOVo/80k46KuM8Aqr6+
 RZGCiPymk8ilg==
Received: from sofa.misterjones.org ([185.219.108.64] helo=why.lan)
 by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.95)
 (envelope-from <maz@kernel.org>) id 1obPaC-00Bxdo-Ru;
 Thu, 22 Sep 2022 18:01:52 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.cs.columbia.edu,
	kvm@vger.kernel.org
Subject: [PATCH 0/6] KVM: Fix dirty-ring ordering on weakly ordered
 architectures
Date: Thu, 22 Sep 2022 18:01:27 +0100
Message-Id: <20220922170133.2617189-1-maz@kernel.org>
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
+	select HAVE_KVM_DIRTY_RING_ORDERED
 	select HAVE_KVM_MSI
 	select HAVE_KVM_IRQCHIP
 	select HAVE_KVM_IRQ_ROUTING

This has been very lightly tested on an arm64 box with Gavin's v3 [2] series.

[1] https://lore.kernel.org/lkml/YyiV%2Fl7O23aw5aaO@xz-m1.local/T/
[2] https://lore.kernel.org/r/20220922003214.276736-1-gshan@redhat.com

Marc Zyngier (6):
  KVM: Use acquire/release semantics when accessing dirty ring GFN state
  KVM: Add KVM_CAP_DIRTY_LOG_RING_ORDERED capability and config option
  KVM: x86: Select CONFIG_HAVE_KVM_DIRTY_RING_ORDERED
  KVM: Document weakly ordered architecture requirements for dirty ring
  KVM: selftests: dirty-log: Upgrade dirty_gfn_set_collected() to
    store-release
  KVM: selftests: dirty-log: Use KVM_CAP_DIRTY_LOG_RING_ORDERED of
    available

 Documentation/virt/kvm/api.rst               | 16 +++++++++++++---
 arch/x86/kvm/Kconfig                         |  1 +
 include/linux/kvm_dirty_ring.h               |  6 +++---
 include/uapi/linux/kvm.h                     |  1 +
 tools/testing/selftests/kvm/dirty_log_test.c |  6 ++++--
 tools/testing/selftests/kvm/lib/kvm_util.c   |  5 ++++-
 virt/kvm/Kconfig                             | 14 ++++++++++++++
 virt/kvm/Makefile.kvm                        |  2 +-
 virt/kvm/dirty_ring.c                        |  4 ++--
 virt/kvm/kvm_main.c                          | 11 +++++++++--
 10 files changed, 52 insertions(+), 14 deletions(-)

-- 
2.34.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
