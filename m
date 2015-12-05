From: Andrew Jones <drjones@redhat.com>
Subject: Re: [PATCH v4 0/4] KVM: arm64: BUG FIX: Correctly handle zero
 register transfers
Date: Fri, 4 Dec 2015 18:33:34 -0600
Message-ID: <20151205003334.GB3117@hawk.localdomain>
References: <cover.1449230499.git.p.fedin@samsung.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="MGYHOYXEY6WxJCY8"
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <cover.1449230499.git.p.fedin@samsung.com>
Sender: kvm-owner@vger.kernel.org
To: Pavel Fedin <p.fedin@samsung.com>
Cc: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu


--MGYHOYXEY6WxJCY8
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Dec 04, 2015 at 03:03:10PM +0300, Pavel Fedin wrote:
> ARM64 CPU has zero register which is read-only, with a value of 0.
> However, KVM currently incorrectly recognizes it being SP (because
> Rt == 31, and in struct user_pt_regs 'regs' array is followed by SP),
> resulting in invalid value being read, or even SP corruption on write.
> 
> The problem has been discovered by performing an operation
> 
>  *((volatile int *)reg) = 0;
> 
> which compiles as "str xzr, [xx]", and resulted in strange values being
> written.
> 
> v3 => v4:
> - Unwrapped assignment in patch 0003
> 
> v2 => v3:
> - Brought back some const modifiers in unaffected functions
> 
> v1 => v2:
> - Changed type of transfer value to u64 and store it directly in
>   struct sys_reg_params instead of a pointer
> - Use lower_32_bits()/upper_32_bits() where appropriate
> - Fixed wrong usage of 'Rt' instead of 'Rt2' in kvm_handle_cp_64(),
>   overlooked in v1
> - Do not write value back when reading
> 
> Pavel Fedin (4):
>   KVM: arm64: Correctly handle zero register during MMIO
>   KVM: arm64: Remove const from struct sys_reg_params
>   KVM: arm64: Correctly handle zero register in system register accesses
>   KVM: arm64: Get rid of old vcpu_reg()
>

FYI, I tried writing test cases for this issue with kvm-unit-tests. The
issue didn't reproduce for me. It's quite possible my test cases are
flawed, so I'm not making any claims about the validity of the series (I
also see that it has already been acked and pulled). But, if Pavel doesn't
mind trying them out on his system, then it'd be good to know if they
reproduce there. I'd like to find out if it's a test case problem or
something else strange going on with environments.

kvm-unit-tests patch attached

Thanks,
drew

--MGYHOYXEY6WxJCY8
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="0001-arm64-add-xzr-emulator-test.patch"

>From 6576833b5e45801f0226316afae7daf0936a0aee Mon Sep 17 00:00:00 2001
From: Andrew Jones <drjones@redhat.com>
Date: Fri, 4 Dec 2015 23:55:53 +0100
Subject: [kvm-unit-tests PATCH] arm64: add xzr emulator test

---
 arm/xzr-test.c          | 61 +++++++++++++++++++++++++++++++++++++++++++++++++
 config/config-arm64.mak |  4 +++-
 2 files changed, 64 insertions(+), 1 deletion(-)
 create mode 100644 arm/xzr-test.c

diff --git a/arm/xzr-test.c b/arm/xzr-test.c
new file mode 100644
index 0000000000000..77a11461c955c
--- /dev/null
+++ b/arm/xzr-test.c
@@ -0,0 +1,61 @@
+#include <libcflat.h>
+#include <chr-testdev.h>
+#include <asm/setup.h>
+#include <asm/smp.h>
+#include <asm/mmu.h>
+#include <asm/io.h>
+
+static void check_xzr_sysreg(void)
+{
+	uint64_t val;
+
+	flush_tlb_all();
+	mmu_disable(); /* Tell KVM to set HCR_TVM for this VCPU */
+
+	asm volatile("msr ttbr0_el1, %0" : : "r" (0x5555555555555555 & PAGE_MASK));
+	isb();
+	asm volatile("mrs %0, ttbr0_el1" : "=r" (val));
+	isb();
+	report("sysreg: sanity check: read 0x%016lx", val == (0x5555555555555555 & PAGE_MASK), val);
+
+	asm volatile("msr ttbr0_el1, xzr");
+	isb();
+	asm volatile("mrs %0, ttbr0_el1" : "=r" (val));
+	isb();
+	report("sysreg: xzr check: read 0x%016lx", val == 0, val);
+
+	halt();
+}
+
+static uint32_t *steal_mmio_addr(void)
+{
+	/*
+	 * Steal an MMIO addr from chr-testdev. Before calling exit()
+	 * chr-testdev must be reinit.
+	 */
+	return (uint32_t *)(0x0a003e00UL /* base */ + 0x40 /* queue pfn */);
+}
+
+int main(void)
+{
+	volatile uint32_t *addr = steal_mmio_addr();
+	uint32_t val;
+	long i;
+
+	writel(0x55555555, addr);
+	val = readl(addr);
+	report("mmio: sanity check: read 0x%08lx", val == 0x55555555, val);
+
+	mb();
+	asm volatile("str wzr, [%0]" : : "r" (addr));
+	val = readl(addr);
+	report("mmio: 'str wzr' check: read 0x%08lx", val == 0, val);
+
+	chr_testdev_init();
+
+	smp_boot_secondary(1, check_xzr_sysreg);
+	for (i = 0; i < 1000000000; ++i)
+		cpu_relax();
+
+	return report_summary();
+}
diff --git a/config/config-arm64.mak b/config/config-arm64.mak
index d61b703c8140e..65b355175f8a0 100644
--- a/config/config-arm64.mak
+++ b/config/config-arm64.mak
@@ -12,9 +12,11 @@ cflatobjs += lib/arm64/processor.o
 cflatobjs += lib/arm64/spinlock.o
 
 # arm64 specific tests
-tests =
+tests = $(TEST_DIR)/xzr-test.flat
 
 include config/config-arm-common.mak
 
 arch_clean: arm_clean
 	$(RM) lib/arm64/.*.d
+
+$(TEST_DIR)/xzr-test.elf: $(cstart.o) $(TEST_DIR)/xzr-test.o
-- 
1.8.3.1


--MGYHOYXEY6WxJCY8--
