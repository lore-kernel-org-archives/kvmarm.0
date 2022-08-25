Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A3EEAECAAA2
	for <kvmarm@archiver.kernel.org>; Thu, 25 Aug 2022 23:25:40 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5C0E74E247;
	Thu, 25 Aug 2022 19:25:40 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id DVCgKXO-6OQY; Thu, 25 Aug 2022 19:25:39 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 87F7E4E257;
	Thu, 25 Aug 2022 19:25:38 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0BAEA4E229
 for <kvmarm@lists.cs.columbia.edu>; Thu, 25 Aug 2022 19:25:37 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id oc+zskF8pZOv for <kvmarm@lists.cs.columbia.edu>;
 Thu, 25 Aug 2022 19:25:35 -0400 (EDT)
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com
 [209.85.210.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id E0E0C4E246
 for <kvmarm@lists.cs.columbia.edu>; Thu, 25 Aug 2022 19:25:33 -0400 (EDT)
Received: by mail-pf1-f202.google.com with SMTP id
 c142-20020a621c94000000b005324991c5b8so9723394pfc.15
 for <kvmarm@lists.cs.columbia.edu>; Thu, 25 Aug 2022 16:25:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
 :date:reply-to:from:to:cc;
 bh=gMN8DAWXzBJk9iSBUfW/QyFFZWZuY8KBpYav4gTwpSU=;
 b=k/VnPS3Avcyf8y12Dai2ATcxUmpDEFAlHtqHWSKGhxjT4Vhlo5GsmzjzRovXIQoToK
 /cVnaYr1ykESlLVNNK+t2ufwentaza0JW4BtboHI9Qw5XauRoBxkJ/LyoQWOKOFiEGSS
 n2G3NVh/e1Mqwx+mvIROA5QEpmujoLPwX5icVZ2O/E1FhBbbE5MyCHYy3lBaAPoGMPyB
 Fbql0NmIiOpXf61dCJzjhY8uPTCZSQNe9T+DA4FM9plfxEWLbxHR+3oVvrcvveq/goce
 vvXk5VPAuVoOQ8+nMdblfbru4J2Ipl2Jcjxwm/E9+nZvI14q8jW5EE1Fu7yGL6JMksCY
 94aw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
 :date:reply-to:x-gm-message-state:from:to:cc;
 bh=gMN8DAWXzBJk9iSBUfW/QyFFZWZuY8KBpYav4gTwpSU=;
 b=5jNIXarPdgbc3C2D40F6FkyauNhI8DAMQgKJ++gbN2H6BcufQ5RYchGiFmHfeJo9if
 vYMYgvZEtj2aMs01sGM1EQ3ZcSYzkUBgltTi/QvkaJ2j/2VcU1lJ5UuROIDjzBMl5NXe
 teq5blYJiMCsgVzhfInlh1fp9uE1sjwd3+czOCNYJfnyIljRFIF0UfQSvHSng1Mnpljq
 eFSfHZrEkkyjUHeoeYnYih+LxlcF06x2whMbXBSsdjO4eAFrWwop3PIoMMWVfDEkXMET
 QR4lm/YUL4lTOxh3FxrR7ggZR2oWmJCoz630QXWsUzwv0fxdMdF722ZM+XV+gp6qgQBV
 yK5Q==
X-Gm-Message-State: ACgBeo2eMbo2yYzxPomDr3uSldm1nXFK/yST5lWv9W8LUA4PzllrH5h7
 5qCciKoOrIYx7yli8gdpGMrXQVjSeqg=
X-Google-Smtp-Source: AA6agR4puys/Z5jXTPDaJYPynDwF4eqnZlaLYimDxxudykXc1F+A7TB7h00cz8hneIZ8xf4MI9E8Jl/4Eh0=
X-Received: from zagreus.c.googlers.com
 ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:10ca:b0:536:ec31:827c with SMTP id
 d10-20020a056a0010ca00b00536ec31827cmr1221322pfu.67.1661469933060; Thu, 25
 Aug 2022 16:25:33 -0700 (PDT)
Date: Thu, 25 Aug 2022 23:25:20 +0000
In-Reply-To: <20220825232522.3997340-1-seanjc@google.com>
Mime-Version: 1.0
References: <20220825232522.3997340-1-seanjc@google.com>
X-Mailer: git-send-email 2.37.2.672.g94769d06f0-goog
Message-ID: <20220825232522.3997340-6-seanjc@google.com>
Subject: [PATCH v5 5/7] KVM: selftests: Make arm64's MMIO ucall multi-VM
 friendly
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>, 
 Anup Patel <anup@brainfault.org>, Paul Walmsley <paul.walmsley@sifive.com>, 
 Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
 Christian Borntraeger <borntraeger@linux.ibm.com>,
 Janosch Frank <frankja@linux.ibm.com>, 
 Claudio Imbrenda <imbrenda@linux.ibm.com>,
 Nathan Chancellor <nathan@kernel.org>, 
 Nick Desaulniers <ndesaulniers@google.com>
Cc: llvm@lists.linux.dev, Peter Gonda <pgonda@google.com>, kvm@vger.kernel.org,
 David Hildenbrand <david@redhat.com>, Tom Rix <trix@redhat.com>,
 linux-kernel@vger.kernel.org, Colton Lewis <coltonlewis@google.com>,
 kvm-riscv@lists.infradead.org, Atish Patra <atishp@atishpatra.org>,
 linux-riscv@lists.infradead.org, Andrew Jones <andrew.jones@linux.dev>,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
Reply-To: Sean Christopherson <seanjc@google.com>
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

Fix a mostly-theoretical bug where ARM's ucall MMIO setup could result in
different VMs stomping on each other by cloberring the global pointer.

Fix the most obvious issue by saving the MMIO gpa into the VM.

A more subtle bug is that creating VMs in parallel (on multiple tasks)
could result in a VM using the wrong address.  Synchronizing a global to
a guest effectively snapshots the value on a per-VM basis, i.e. the
"global" is already prepped to work with multiple VMs, but setting the
global in the host is not thread-safe.  To fix that bug, add
write_guest_global() to allow stuffing a VM's copy of a "global" without
modifying the host value.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 .../selftests/kvm/include/kvm_util_base.h     | 15 +++++++++++++++
 .../testing/selftests/kvm/lib/aarch64/ucall.c | 19 ++++++++++++++-----
 2 files changed, 29 insertions(+), 5 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/kvm_util_base.h b/tools/testing/selftests/kvm/include/kvm_util_base.h
index 24fde97f6121..59d52b58a1a6 100644
--- a/tools/testing/selftests/kvm/include/kvm_util_base.h
+++ b/tools/testing/selftests/kvm/include/kvm_util_base.h
@@ -16,6 +16,7 @@
 #include <linux/kvm.h>
 #include "linux/rbtree.h"
 
+#include <asm/atomic.h>
 
 #include <sys/ioctl.h>
 
@@ -81,6 +82,7 @@ struct kvm_vm {
 	struct sparsebit *vpages_mapped;
 	bool has_irqchip;
 	bool pgd_created;
+	vm_paddr_t ucall_mmio_addr;
 	vm_paddr_t pgd;
 	vm_vaddr_t gdt;
 	vm_vaddr_t tss;
@@ -714,6 +716,19 @@ kvm_userspace_memory_region_find(struct kvm_vm *vm, uint64_t start,
 	memcpy(&(g), _p, sizeof(g));				\
 })
 
+/*
+ * Write a global value, but only in the VM's (guest's) domain.  Primarily used
+ * for "globals" that hold per-VM values (VMs always duplicate code and global
+ * data into their own region of physical memory), but can be used anytime it's
+ * undesirable to change the host's copy of the global.
+ */
+#define write_guest_global(vm, g, val) ({			\
+	typeof(g) *_p = addr_gva2hva(vm, (vm_vaddr_t)&(g));	\
+	typeof(g) _val = val;					\
+								\
+	memcpy(_p, &(_val), sizeof(g));				\
+})
+
 void assert_on_unhandled_exception(struct kvm_vcpu *vcpu);
 
 void vcpu_arch_dump(FILE *stream, struct kvm_vcpu *vcpu,
diff --git a/tools/testing/selftests/kvm/lib/aarch64/ucall.c b/tools/testing/selftests/kvm/lib/aarch64/ucall.c
index f02ae27c3e43..1c38bd260f90 100644
--- a/tools/testing/selftests/kvm/lib/aarch64/ucall.c
+++ b/tools/testing/selftests/kvm/lib/aarch64/ucall.c
@@ -6,20 +6,29 @@
  */
 #include "kvm_util.h"
 
+/*
+ * ucall_exit_mmio_addr holds per-VM values (global data is duplicated by each
+ * VM), it must not be accessed from host code.
+ */
 static vm_vaddr_t *ucall_exit_mmio_addr;
 
+static void ucall_set_mmio_addr(struct kvm_vm *vm, vm_paddr_t mmio_gpa)
+{
+	vm->ucall_mmio_addr = mmio_gpa;
+
+	write_guest_global(vm, ucall_exit_mmio_addr, (vm_vaddr_t *)mmio_gpa);
+}
+
 void ucall_arch_init(struct kvm_vm *vm, vm_paddr_t mmio_gpa)
 {
 	virt_pg_map(vm, mmio_gpa, mmio_gpa);
 
-	ucall_exit_mmio_addr = (vm_vaddr_t *)mmio_gpa;
-	sync_global_to_guest(vm, ucall_exit_mmio_addr);
+	ucall_set_mmio_addr(vm, mmio_gpa);
 }
 
 void ucall_arch_uninit(struct kvm_vm *vm)
 {
-	ucall_exit_mmio_addr = 0;
-	sync_global_to_guest(vm, ucall_exit_mmio_addr);
+	ucall_set_mmio_addr(vm, (vm_paddr_t)NULL);
 }
 
 void ucall_arch_do_ucall(vm_vaddr_t uc)
@@ -32,7 +41,7 @@ void *ucall_arch_get_ucall(struct kvm_vcpu *vcpu)
 	struct kvm_run *run = vcpu->run;
 
 	if (run->exit_reason == KVM_EXIT_MMIO &&
-	    run->mmio.phys_addr == (uint64_t)ucall_exit_mmio_addr) {
+	    run->mmio.phys_addr == vcpu->vm->ucall_mmio_addr) {
 		vm_vaddr_t gva;
 
 		TEST_ASSERT(run->mmio.is_write && run->mmio.len == 8,
-- 
2.37.2.672.g94769d06f0-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
