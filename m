Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5A9B6C6FA83
	for <kvmarm@archiver.kernel.org>; Mon, 26 Sep 2022 14:51:34 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E4DA54B7DE;
	Mon, 26 Sep 2022 10:51:33 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id va+STgN3eT7M; Mon, 26 Sep 2022 10:51:32 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 23ECB4B82D;
	Mon, 26 Sep 2022 10:51:31 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 744EA4B177
 for <kvmarm@lists.cs.columbia.edu>; Mon, 26 Sep 2022 10:51:29 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id USydCpH21HWb for <kvmarm@lists.cs.columbia.edu>;
 Mon, 26 Sep 2022 10:51:28 -0400 (EDT)
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 1CD3E4B768
 for <kvmarm@lists.cs.columbia.edu>; Mon, 26 Sep 2022 10:51:28 -0400 (EDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ams.source.kernel.org (Postfix) with ESMTPS id 3004EB80ABC;
 Mon, 26 Sep 2022 14:51:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B6D5C433B5;
 Mon, 26 Sep 2022 14:51:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1664203885;
 bh=SZA3KzsHt16PF+DaIYBz7Nb49624LswRe+Ox5z2sq34=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=k1LixNiwiplcKqe80TOHWv6ipi93flRcW96VaPramWhh3r0x5c+Mg1kjDhkX81i+T
 vOUBv99xCffx5QPhrYunu9hX6KVdCmgeG8MalLfO6LKQB96tuweCY7TQzPja+CoPeo
 7hBt9v/sfen+SOnAHKyIISA561HLooQQoBkG6VWCLm6YuYdu4u/u+UL/3DSWqhoZfr
 LdpjDJoWeD/Wr8nGBtiu6GgA7wkgGkovYNaSDrIXu+sKz8ovvBqExt1fyGVVKcYu7D
 asIo1SgwBOW45ygeQQ8LYHd1XlDyGoC+QKgKxGhdK3HCAb7wh/idCwMQyC/n3k6DhS
 f3SxdRr+PwycA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=why.lan)
 by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.95)
 (envelope-from <maz@kernel.org>) id 1ocpS7-00Cips-KI;
 Mon, 26 Sep 2022 15:51:23 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.cs.columbia.edu,
	kvm@vger.kernel.org
Subject: [PATCH v2 2/6] KVM: Add KVM_CAP_DIRTY_LOG_RING_ACQ_REL capability and
 config option
Date: Mon, 26 Sep 2022 15:51:16 +0100
Message-Id: <20220926145120.27974-3-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220926145120.27974-1-maz@kernel.org>
References: <20220926145120.27974-1-maz@kernel.org>
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

In order to differenciate between architectures that require no extra
synchronisation when accessing the dirty ring and those who do,
add a new capability (KVM_CAP_DIRTY_LOG_RING_ACQ_REL) that identify
the latter sort. TSO architectures can obviously advertise both, while
relaxed architectures must only advertise the ACQ_REL version.

This requires some configuration symbol rejigging, with HAVE_KVM_DIRTY_RING
being only indirectly selected by two top-level config symbols:
- HAVE_KVM_DIRTY_RING_TSO for strongly ordered architectures (x86)
- HAVE_KVM_DIRTY_RING_ACQ_REL for weakly ordered architectures (arm64)

Suggested-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/x86/kvm/Kconfig     |  2 +-
 include/uapi/linux/kvm.h |  1 +
 virt/kvm/Kconfig         | 14 ++++++++++++++
 virt/kvm/kvm_main.c      |  9 ++++++++-
 4 files changed, 24 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/Kconfig b/arch/x86/kvm/Kconfig
index e3cbd7706136..876748b236ff 100644
--- a/arch/x86/kvm/Kconfig
+++ b/arch/x86/kvm/Kconfig
@@ -28,7 +28,7 @@ config KVM
 	select HAVE_KVM_IRQCHIP
 	select HAVE_KVM_PFNCACHE
 	select HAVE_KVM_IRQFD
-	select HAVE_KVM_DIRTY_RING
+	select HAVE_KVM_DIRTY_RING_TSO
 	select IRQ_BYPASS_MANAGER
 	select HAVE_KVM_IRQ_BYPASS
 	select HAVE_KVM_IRQ_ROUTING
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index eed0315a77a6..0d5d4419139a 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1177,6 +1177,7 @@ struct kvm_ppc_resize_hpt {
 #define KVM_CAP_VM_DISABLE_NX_HUGE_PAGES 220
 #define KVM_CAP_S390_ZPCI_OP 221
 #define KVM_CAP_S390_CPU_TOPOLOGY 222
+#define KVM_CAP_DIRTY_LOG_RING_ACQ_REL 223
 
 #ifdef KVM_CAP_IRQ_ROUTING
 
diff --git a/virt/kvm/Kconfig b/virt/kvm/Kconfig
index a8c5c9f06b3c..800f9470e36b 100644
--- a/virt/kvm/Kconfig
+++ b/virt/kvm/Kconfig
@@ -19,6 +19,20 @@ config HAVE_KVM_IRQ_ROUTING
 config HAVE_KVM_DIRTY_RING
        bool
 
+# Only strongly ordered architectures can select this, as it doesn't
+# put any explicit constraint on userspace ordering. They can also
+# select the _ACQ_REL version.
+config HAVE_KVM_DIRTY_RING_TSO
+       bool
+       select HAVE_KVM_DIRTY_RING
+       depends on X86
+
+# Weakly ordered architectures can only select this, advertising
+# to userspace the additional ordering requirements.
+config HAVE_KVM_DIRTY_RING_ACQ_REL
+       bool
+       select HAVE_KVM_DIRTY_RING
+
 config HAVE_KVM_EVENTFD
        bool
        select EVENTFD
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 584a5bab3af3..5b064dbadaf4 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -4475,7 +4475,13 @@ static long kvm_vm_ioctl_check_extension_generic(struct kvm *kvm, long arg)
 	case KVM_CAP_NR_MEMSLOTS:
 		return KVM_USER_MEM_SLOTS;
 	case KVM_CAP_DIRTY_LOG_RING:
-#ifdef CONFIG_HAVE_KVM_DIRTY_RING
+#ifdef CONFIG_HAVE_KVM_DIRTY_RING_TSO
+		return KVM_DIRTY_RING_MAX_ENTRIES * sizeof(struct kvm_dirty_gfn);
+#else
+		return 0;
+#endif
+	case KVM_CAP_DIRTY_LOG_RING_ACQ_REL:
+#ifdef CONFIG_HAVE_KVM_DIRTY_RING_ACQ_REL
 		return KVM_DIRTY_RING_MAX_ENTRIES * sizeof(struct kvm_dirty_gfn);
 #else
 		return 0;
@@ -4580,6 +4586,7 @@ static int kvm_vm_ioctl_enable_cap_generic(struct kvm *kvm,
 		return 0;
 	}
 	case KVM_CAP_DIRTY_LOG_RING:
+	case KVM_CAP_DIRTY_LOG_RING_ACQ_REL:
 		return kvm_vm_ioctl_enable_dirty_log_ring(kvm, cap->args[0]);
 	default:
 		return kvm_vm_ioctl_enable_cap(kvm, cap);
-- 
2.34.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
