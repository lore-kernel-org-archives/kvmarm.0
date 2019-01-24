From: Christoffer Dall <christoffer.dall@arm.com>
Subject: [PATCH 02/14] arm64: KVM: Allow for direct call of HYP functions when
 using VHE
Date: Thu, 24 Jan 2019 15:00:20 +0100
Message-ID: <20190124140032.8588-3-christoffer.dall@arm.com>
References: <20190124140032.8588-1-christoffer.dall@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 43C854A3A7
 for <kvmarm@lists.cs.columbia.edu>; Thu, 24 Jan 2019 09:00:51 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id XrM5ghegAtLn for <kvmarm@lists.cs.columbia.edu>;
 Thu, 24 Jan 2019 09:00:43 -0500 (EST)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B25884A3E8
 for <kvmarm@lists.cs.columbia.edu>; Thu, 24 Jan 2019 09:00:41 -0500 (EST)
In-Reply-To: <20190124140032.8588-1-christoffer.dall@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
Cc: Marc Zyngier <marc.zyngier@arm.com>, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

From: Marc Zyngier <marc.zyngier@arm.com>

When running VHE, there is no need to jump via some stub to perform
a "HYP" function call, as there is a single address space.

Let's thus change kvm_call_hyp() and co to perform a direct call
in this case. Although this results in a bit of code expansion,
it allows the compiler to check for type compatibility, something
that we are missing so far.

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
Acked-by: Christoffer Dall <christoffer.dall@arm.com>
---
 arch/arm64/include/asm/kvm_host.h | 32 +++++++++++++++++++++++++++++--
 1 file changed, 30 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index e54cb7c88a4e..8b7702bdb219 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -370,8 +370,36 @@ void kvm_arm_halt_guest(struct kvm *kvm);
 void kvm_arm_resume_guest(struct kvm *kvm);
 
 u64 __kvm_call_hyp(void *hypfn, ...);
-#define kvm_call_hyp(f, ...) __kvm_call_hyp(kvm_ksym_ref(f), ##__VA_ARGS__)
-#define kvm_call_hyp_ret(f, ...) kvm_call_hyp(f, ##__VA_ARGS__)
+
+/*
+ * The couple of isb() below are there to guarantee the same behaviour
+ * on VHE as on !VHE, where the eret to EL1 acts as a context
+ * synchronization event.
+ */
+#define kvm_call_hyp(f, ...)						\
+	do {								\
+		if (has_vhe()) {					\
+			f(__VA_ARGS__);					\
+			isb();						\
+		} else {						\
+			__kvm_call_hyp(kvm_ksym_ref(f), ##__VA_ARGS__); \
+		}							\
+	} while(0)
+
+#define kvm_call_hyp_ret(f, ...)					\
+	({								\
+		typeof(f(__VA_ARGS__)) ret;				\
+									\
+		if (has_vhe()) {					\
+			ret = f(__VA_ARGS__);				\
+			isb();						\
+		} else {						\
+			ret = __kvm_call_hyp(kvm_ksym_ref(f),		\
+					     ##__VA_ARGS__);		\
+		}							\
+									\
+		ret;							\
+	})
 
 void force_vm_exit(const cpumask_t *mask);
 void kvm_mmu_wp_memory_region(struct kvm *kvm, int slot);
-- 
2.18.0
