From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: [PATCH v3 1/8] KVM: Add kvm_arch_vcpu_{un}blocking callbacks
Date: Tue, 29 Sep 2015 16:48:58 +0200
Message-ID: <1443538145-11990-2-git-send-email-christoffer.dall@linaro.org>
References: <1443538145-11990-1-git-send-email-christoffer.dall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4AB5B41172
 for <kvmarm@lists.cs.columbia.edu>; Tue, 29 Sep 2015 10:47:35 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id h7H-XyZm75m9 for <kvmarm@lists.cs.columbia.edu>;
 Tue, 29 Sep 2015 10:47:34 -0400 (EDT)
Received: from mail-la0-f44.google.com (mail-la0-f44.google.com
 [209.85.215.44])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 0FD47411E3
 for <kvmarm@lists.cs.columbia.edu>; Tue, 29 Sep 2015 10:47:33 -0400 (EDT)
Received: by laclj5 with SMTP id lj5so11600064lac.3
 for <kvmarm@lists.cs.columbia.edu>; Tue, 29 Sep 2015 07:49:07 -0700 (PDT)
In-Reply-To: <1443538145-11990-1-git-send-email-christoffer.dall@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
Cc: Marc Zyngier <marc.zyngier@arm.com>, Andre Przywara <andre.przywara@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

Some times it is useful for architecture implementations of KVM to know
when the VCPU thread is about to block or when it comes back from
blocking (arm/arm64 needs to know this to properly implement timers, for
example).

Therefore provide a generic architecture callback function in line with
what we do elsewhere for KVM generic-arch interactions.

Reviewed-by: Marc Zyngier <marc.zyngier@arm.com>
Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
---
 arch/arm/include/asm/kvm_host.h     | 3 +++
 arch/arm64/include/asm/kvm_host.h   | 3 +++
 arch/mips/include/asm/kvm_host.h    | 2 ++
 arch/powerpc/include/asm/kvm_host.h | 2 ++
 arch/s390/include/asm/kvm_host.h    | 2 ++
 arch/x86/include/asm/kvm_host.h     | 3 +++
 include/linux/kvm_host.h            | 2 ++
 virt/kvm/kvm_main.c                 | 3 +++
 8 files changed, 20 insertions(+)

diff --git a/arch/arm/include/asm/kvm_host.h b/arch/arm/include/asm/kvm_host.h
index 3df1e97..ca41d94 100644
--- a/arch/arm/include/asm/kvm_host.h
+++ b/arch/arm/include/asm/kvm_host.h
@@ -233,4 +233,7 @@ static inline void kvm_arm_setup_debug(struct kvm_vcpu *vcpu) {}
 static inline void kvm_arm_clear_debug(struct kvm_vcpu *vcpu) {}
 static inline void kvm_arm_reset_debug_ptr(struct kvm_vcpu *vcpu) {}
 
+static inline void kvm_arch_vcpu_blocking(struct kvm_vcpu *vcpu) {}
+static inline void kvm_arch_vcpu_unblocking(struct kvm_vcpu *vcpu) {}
+
 #endif /* __ARM_KVM_HOST_H__ */
diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 4562459..5dae2d8 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -254,4 +254,7 @@ void kvm_arm_setup_debug(struct kvm_vcpu *vcpu);
 void kvm_arm_clear_debug(struct kvm_vcpu *vcpu);
 void kvm_arm_reset_debug_ptr(struct kvm_vcpu *vcpu);
 
+static inline void kvm_arch_vcpu_blocking(struct kvm_vcpu *vcpu) {}
+static inline void kvm_arch_vcpu_unblocking(struct kvm_vcpu *vcpu) {}
+
 #endif /* __ARM64_KVM_HOST_H__ */
diff --git a/arch/mips/include/asm/kvm_host.h b/arch/mips/include/asm/kvm_host.h
index 3a54dbc..b0fa534 100644
--- a/arch/mips/include/asm/kvm_host.h
+++ b/arch/mips/include/asm/kvm_host.h
@@ -846,5 +846,7 @@ static inline void kvm_arch_flush_shadow_memslot(struct kvm *kvm,
 		struct kvm_memory_slot *slot) {}
 static inline void kvm_arch_vcpu_uninit(struct kvm_vcpu *vcpu) {}
 static inline void kvm_arch_sched_in(struct kvm_vcpu *vcpu, int cpu) {}
+static inline void kvm_arch_vcpu_blocking(struct kvm_vcpu *vcpu) {}
+static inline void kvm_arch_vcpu_unblocking(struct kvm_vcpu *vcpu) {}
 
 #endif /* __MIPS_KVM_HOST_H__ */
diff --git a/arch/powerpc/include/asm/kvm_host.h b/arch/powerpc/include/asm/kvm_host.h
index 195886a..c60e361 100644
--- a/arch/powerpc/include/asm/kvm_host.h
+++ b/arch/powerpc/include/asm/kvm_host.h
@@ -717,5 +717,7 @@ static inline void kvm_arch_memslots_updated(struct kvm *kvm, struct kvm_memslot
 static inline void kvm_arch_flush_shadow_all(struct kvm *kvm) {}
 static inline void kvm_arch_sched_in(struct kvm_vcpu *vcpu, int cpu) {}
 static inline void kvm_arch_exit(void) {}
+static inline void kvm_arch_vcpu_blocking(struct kvm_vcpu *vcpu) {}
+static inline void kvm_arch_vcpu_unblocking(struct kvm_vcpu *vcpu) {}
 
 #endif /* __POWERPC_KVM_HOST_H__ */
diff --git a/arch/s390/include/asm/kvm_host.h b/arch/s390/include/asm/kvm_host.h
index 6ce4a0b..5219b4e 100644
--- a/arch/s390/include/asm/kvm_host.h
+++ b/arch/s390/include/asm/kvm_host.h
@@ -643,5 +643,7 @@ static inline void kvm_arch_memslots_updated(struct kvm *kvm, struct kvm_memslot
 static inline void kvm_arch_flush_shadow_all(struct kvm *kvm) {}
 static inline void kvm_arch_flush_shadow_memslot(struct kvm *kvm,
 		struct kvm_memory_slot *slot) {}
+static inline void kvm_arch_vcpu_blocking(struct kvm_vcpu *vcpu) {}
+static inline void kvm_arch_vcpu_unblocking(struct kvm_vcpu *vcpu) {}
 
 #endif
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 349f80a..b926137 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1232,4 +1232,7 @@ int x86_set_memory_region(struct kvm *kvm,
 bool kvm_vcpu_is_reset_bsp(struct kvm_vcpu *vcpu);
 bool kvm_vcpu_is_bsp(struct kvm_vcpu *vcpu);
 
+static inline void kvm_arch_vcpu_blocking(struct kvm_vcpu *vcpu) {}
+static inline void kvm_arch_vcpu_unblocking(struct kvm_vcpu *vcpu) {}
+
 #endif /* _ASM_X86_KVM_HOST_H */
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 1bef9e2..4a86f5f 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -625,6 +625,8 @@ int kvm_vcpu_write_guest(struct kvm_vcpu *vcpu, gpa_t gpa, const void *data,
 void kvm_vcpu_mark_page_dirty(struct kvm_vcpu *vcpu, gfn_t gfn);
 
 void kvm_vcpu_block(struct kvm_vcpu *vcpu);
+void kvm_arch_vcpu_blocking(struct kvm_vcpu *vcpu);
+void kvm_arch_vcpu_unblocking(struct kvm_vcpu *vcpu);
 void kvm_vcpu_kick(struct kvm_vcpu *vcpu);
 int kvm_vcpu_yield_to(struct kvm_vcpu *target);
 void kvm_vcpu_on_spin(struct kvm_vcpu *vcpu);
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 04146a2..ed11fb7 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -2018,6 +2018,8 @@ void kvm_vcpu_block(struct kvm_vcpu *vcpu)
 		} while (single_task_running() && ktime_before(cur, stop));
 	}
 
+	kvm_arch_vcpu_blocking(vcpu);
+
 	for (;;) {
 		prepare_to_wait(&vcpu->wq, &wait, TASK_INTERRUPTIBLE);
 
@@ -2031,6 +2033,7 @@ void kvm_vcpu_block(struct kvm_vcpu *vcpu)
 	finish_wait(&vcpu->wq, &wait);
 	cur = ktime_get();
 
+	kvm_arch_vcpu_unblocking(vcpu);
 out:
 	block_ns = ktime_to_ns(cur) - ktime_to_ns(start);
 
-- 
2.1.2.330.g565301e.dirty
