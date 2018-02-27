From: Christoffer Dall <cdall@kernel.org>
Subject: [PATCH v5 25/40] KVM: arm64: Introduce framework for accessing
 deferred sysregs
Date: Tue, 27 Feb 2018 12:34:14 +0100
Message-ID: <20180227113429.637-26-cdall@kernel.org>
References: <20180227113429.637-1-cdall@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <20180227113429.637-1-cdall@kernel.org>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
Cc: Andrew Jones <drjones@redhat.com>, kvm@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>, Tomasz Nowicki <tn@semihalf.com>, Julien Grall <julien.grall@arm.com>, Yury Norov <ynorov@caviumnetworks.com>, Dave Martin <Dave.Martin@arm.com>, Shih-Wei Li <shihwei@cs.columbia.edu>
List-Id: kvmarm@lists.cs.columbia.edu

From: Christoffer Dall <christoffer.dall@linaro.org>

We are about to defer saving and restoring some groups of system
registers to vcpu_put and vcpu_load on supported systems.  This means
that we need some infrastructure to access system registes which
supports either accessing the memory backing of the register or directly
accessing the system registers, depending on the state of the system
when we access the register.

We do this by defining read/write accessor functions, which can handle
both "immediate" and "deferrable" system registers.  Immediate registers
are always saved/restored in the world-switch path, but deferrable
registers are only saved/restored in vcpu_put/vcpu_load when supported
and sysregs_loaded_on_cpu will be set in that case.

Note that we don't use the deferred mechanism yet in this patch, but only
introduce infrastructure.  This is to improve convenience of review in
the subsequent patches where it is clear which registers become
deferred.

Reviewed-by: Marc Zyngier <marc.zyngier@arm.com>
Reviewed-by: Andrew Jones <drjones@redhat.com>
Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
---

Notes:
    Changes since v4:
     - Slightly reworded commentary based on Drew's feedback
    
    Changes since v3:
     - Changed to a switch-statement based approach to improve
       readability.
    
    Changes since v2:
     - New patch (deferred register handling has been reworked)

 arch/arm64/include/asm/kvm_host.h |  8 ++++++--
 arch/arm64/kvm/sys_regs.c         | 33 +++++++++++++++++++++++++++++++++
 2 files changed, 39 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 179bb9d5760b..ab46bc70add6 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -284,6 +284,10 @@ struct kvm_vcpu_arch {
 
 	/* Virtual SError ESR to restore when HCR_EL2.VSE is set */
 	u64 vsesr_el2;
+
+	/* True when deferrable sysregs are loaded on the physical CPU,
+	 * see kvm_vcpu_load_sysregs and kvm_vcpu_put_sysregs. */
+	bool sysregs_loaded_on_cpu;
 };
 
 #define vcpu_gp_regs(v)		(&(v)->arch.ctxt.gp_regs)
@@ -296,8 +300,8 @@ struct kvm_vcpu_arch {
  */
 #define __vcpu_sys_reg(v,r)	((v)->arch.ctxt.sys_regs[(r)])
 
-#define vcpu_read_sys_reg(v,r)	__vcpu_sys_reg(v,r)
-#define vcpu_write_sys_reg(v,n,r)	do { __vcpu_sys_reg(v,r) = n; } while (0)
+u64 vcpu_read_sys_reg(struct kvm_vcpu *vcpu, int reg);
+void vcpu_write_sys_reg(struct kvm_vcpu *vcpu, u64 val, int reg);
 
 /*
  * CP14 and CP15 live in the same array, as they are backed by the
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 7514db002430..c809f0d1a059 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -35,6 +35,7 @@
 #include <asm/kvm_coproc.h>
 #include <asm/kvm_emulate.h>
 #include <asm/kvm_host.h>
+#include <asm/kvm_hyp.h>
 #include <asm/kvm_mmu.h>
 #include <asm/perf_event.h>
 #include <asm/sysreg.h>
@@ -76,6 +77,38 @@ static bool write_to_read_only(struct kvm_vcpu *vcpu,
 	return false;
 }
 
+u64 vcpu_read_sys_reg(struct kvm_vcpu *vcpu, int reg)
+{
+	if (!vcpu->arch.sysregs_loaded_on_cpu)
+		goto immediate_read;
+
+	/*
+	 * System registers listed in the switch are not saved on every
+	 * exit from the guest but are only saved on vcpu_put.
+	 */
+	switch (reg) {
+	}
+
+immediate_read:
+	return __vcpu_sys_reg(vcpu, reg);
+}
+
+void vcpu_write_sys_reg(struct kvm_vcpu *vcpu, u64 val, int reg)
+{
+	if (!vcpu->arch.sysregs_loaded_on_cpu)
+		goto immediate_write;
+
+	/*
+	 * System registers listed in the switch are not restored on every
+	 * entry to the guest but are only restored on vcpu_load.
+	 */
+	switch (reg) {
+	}
+
+immediate_write:
+	 __vcpu_sys_reg(vcpu, reg) = val;
+}
+
 /* 3 bits per cache level, as per CLIDR, but non-existent caches always 0 */
 static u32 cache_levels;
 
-- 
2.14.2
