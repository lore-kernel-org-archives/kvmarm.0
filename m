Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CE876C3F6B0
	for <kvmarm@archiver.kernel.org>; Wed, 24 Aug 2022 03:21:37 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 89EF84C282;
	Tue, 23 Aug 2022 23:21:37 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id uPvpP2KlELbw; Tue, 23 Aug 2022 23:21:36 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6D6974C2BE;
	Tue, 23 Aug 2022 23:21:36 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5A3AD4C28A
 for <kvmarm@lists.cs.columbia.edu>; Tue, 23 Aug 2022 23:21:33 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id tVPzZKURHVYb for <kvmarm@lists.cs.columbia.edu>;
 Tue, 23 Aug 2022 23:21:30 -0400 (EDT)
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com
 [209.85.210.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id ABDCA4C311
 for <kvmarm@lists.cs.columbia.edu>; Tue, 23 Aug 2022 23:21:28 -0400 (EDT)
Received: by mail-pf1-f202.google.com with SMTP id
 14-20020a056a00072e00b0053689e4d0e5so3385298pfm.5
 for <kvmarm@lists.cs.columbia.edu>; Tue, 23 Aug 2022 20:21:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
 :date:reply-to:from:to:cc;
 bh=0Zu9CHYeQLsVtyyQt2AMWvNl6eTy619WBuTXQTtixSA=;
 b=D55RlPmRHY3855ha+O8WFuydY7xxV00RTpgiyt0tc+7sqW+ZITwJ8rHH4cS6Rgj2Tp
 EHuWTZwJYb/z5yGCzhd4wR6f3rStHwPGFgRn6L9kMUUWot/3PnViuvUo20Btnb7i66Tw
 dO9NyUSAB9cSeN4t5FJi7jZBt1djQF7nRCc7u2BDQCLlF0FJx0JuKeXkajK/Bb3xsZqK
 6tk7zhNHVsj4IdF9tAKxyVew8z6dGtaEOw8q0I3USCIsdic62o4PAhO7p8dmL04RYw3+
 vJCAytqgW15ccVK1stFdEfYnKwvHjs8FRvcUj5bQpNDEkEcfzdtOUCoq+wKJQBUaP8ql
 g1NA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
 :date:reply-to:x-gm-message-state:from:to:cc;
 bh=0Zu9CHYeQLsVtyyQt2AMWvNl6eTy619WBuTXQTtixSA=;
 b=aa1PA7VbIrSVb6LzbH3pPNsEZQlTbaUuQHRDwk7DN2nRxo0NVH2l2I1Y4kiGMUJzmd
 /E2QwfxcDQgwpJ4971i3wi4YTU56DM9E7XGss+fpwN22mvqanGrVoozSuTMj0rfpC5UG
 0Q41aYTiFNInApxyrssBvUJGJusdNLfac9CB1W0c+xNk27HVeY8bIFIKdo/OGWW59Ebf
 jkFKktEPj3ardWXGXZvca1/aPr7A1hrP/z2PlWdRA7uBlCMHRFUxqXZqBdCev2gIFxgE
 2rNSSth6UoZ5oRYE8wVn3DBrTNI7dt1rqbbejdO4F8MGvuVy3FTtFV1Okb7MYcUP0zNR
 Kx+A==
X-Gm-Message-State: ACgBeo3/z0GwkQkkqtCNWYj0wFTVCW2GeRk/n23nIdR1lOgWfIhFqVAr
 79Hgy5B0eSdDC2c1EFOWrmVtv5pJYL8=
X-Google-Smtp-Source: AA6agR573qzRI9fRUFVPY21n41Xn0zzpTI2fab3hBfHK20jtmnw9qYoXs3mBXpBUgtjKB0V2MjEeiqR0SSg=
X-Received: from zagreus.c.googlers.com
 ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:aa7:814d:0:b0:535:c875:dd4f with SMTP id
 d13-20020aa7814d000000b00535c875dd4fmr27515181pfn.4.1661311287578; Tue, 23
 Aug 2022 20:21:27 -0700 (PDT)
Date: Wed, 24 Aug 2022 03:21:14 +0000
In-Reply-To: <20220824032115.3563686-1-seanjc@google.com>
Message-Id: <20220824032115.3563686-6-seanjc@google.com>
Mime-Version: 1.0
References: <20220824032115.3563686-1-seanjc@google.com>
X-Mailer: git-send-email 2.37.1.595.g718a3a8f04-goog
Subject: [PATCH v4 5/6] KVM: selftests: Make arm64's MMIO ucall multi-VM
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
global in the host and copying it to the guest needs to happen atomically.
To fix that bug, add atomic_sync_global_pointer_to_guest() to sync
"global" pointers that hold per-VM values, i.e. technically need to be
handled in a thread-safe manner.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 .../selftests/kvm/include/kvm_util_base.h     | 16 +++++++++++++++
 .../testing/selftests/kvm/lib/aarch64/ucall.c | 20 ++++++++++++++-----
 2 files changed, 31 insertions(+), 5 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/kvm_util_base.h b/tools/testing/selftests/kvm/include/kvm_util_base.h
index 24fde97f6121..9ec7fbe941aa 100644
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
@@ -714,6 +716,20 @@ kvm_userspace_memory_region_find(struct kvm_vm *vm, uint64_t start,
 	memcpy(&(g), _p, sizeof(g));				\
 })
 
+/*
+ * Sync a global pointer to the guest that has a per-VM value, in which case
+ * writes to the host copy of the "global" must be serialized (in case a test
+ * is being truly crazy and spawning multiple VMs concurrently).
+ */
+#define atomic_sync_global_pointer_to_guest(vm, g, val) ({	\
+	typeof(g) *_p = addr_gva2hva(vm, (vm_vaddr_t)&(g));	\
+								\
+	while (cmpxchg(&g, NULL, val))				\
+		;						\
+	memcpy(_p, &(g), sizeof(g));				\
+	WRITE_ONCE(g, NULL);					\
+})
+
 void assert_on_unhandled_exception(struct kvm_vcpu *vcpu);
 
 void vcpu_arch_dump(FILE *stream, struct kvm_vcpu *vcpu,
diff --git a/tools/testing/selftests/kvm/lib/aarch64/ucall.c b/tools/testing/selftests/kvm/lib/aarch64/ucall.c
index f02ae27c3e43..acb47c813477 100644
--- a/tools/testing/selftests/kvm/lib/aarch64/ucall.c
+++ b/tools/testing/selftests/kvm/lib/aarch64/ucall.c
@@ -6,20 +6,30 @@
  */
 #include "kvm_util.h"
 
+/*
+ * This "global" holds different per-VM values, it must not be accessed from
+ * host code except to sync the guest value, and that must be done atomically.
+ */
 static vm_vaddr_t *ucall_exit_mmio_addr;
 
+static void ucall_set_mmio_addr(struct kvm_vm *vm, vm_paddr_t mmio_gpa)
+{
+	vm->ucall_mmio_addr = mmio_gpa;
+
+	atomic_sync_global_pointer_to_guest(vm, ucall_exit_mmio_addr,
+					    (vm_vaddr_t *)mmio_gpa);
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
@@ -32,7 +42,7 @@ void *ucall_arch_get_ucall(struct kvm_vcpu *vcpu)
 	struct kvm_run *run = vcpu->run;
 
 	if (run->exit_reason == KVM_EXIT_MMIO &&
-	    run->mmio.phys_addr == (uint64_t)ucall_exit_mmio_addr) {
+	    run->mmio.phys_addr == vcpu->vm->ucall_mmio_addr) {
 		vm_vaddr_t gva;
 
 		TEST_ASSERT(run->mmio.is_write && run->mmio.len == 8,
-- 
2.37.1.595.g718a3a8f04-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
