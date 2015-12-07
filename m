From: Andrew Jones <drjones@redhat.com>
Subject: Re: [PATCH v4 0/4] KVM: arm64: BUG FIX: Correctly handle zero
 register transfers
Date: Mon, 7 Dec 2015 16:36:31 -0600
Message-ID: <20151207223631.GJ4402@hawk.localdomain>
References: <cover.1449230499.git.p.fedin@samsung.com>
 <20151205003334.GB3117@hawk.localdomain>
 <011601d130ca$64cc9070$2e65b150$@samsung.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="xXmbgvnjoT4axfJE"
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <011601d130ca$64cc9070$2e65b150$@samsung.com>
Sender: kvm-owner@vger.kernel.org
To: Pavel Fedin <p.fedin@samsung.com>
Cc: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, 'Marc Zyngier' <marc.zyngier@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu


--xXmbgvnjoT4axfJE
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Dec 07, 2015 at 11:36:28AM +0300, Pavel Fedin wrote:
>  Hello!
> 
> > FYI, I tried writing test cases for this issue with kvm-unit-tests. The
> > issue didn't reproduce for me. It's quite possible my test cases are
> > flawed, so I'm not making any claims about the validity of the series
> 
>  This is indeed very interesting, so i'll take a look at it.
>  For now i've just only took a quick glance at the code, and i have at least one suggestion. Could you happen to have sp == 0 in
> check_xzr_sysreg()? In this case it will magically work.
>  Also, you could try to write a test which tries to overwrite xzr. Something like:
> 
> volatile int *addr1;
> volatile int *addr2;
> 
> asm volatile("str %3, [%1]\n\t"
>              "ldr wzr, [%1]\n\t"
>              "str wzr, [%2]\n\t",
>              "ldr %0, [%2]\n\t"
>              :"=r"(res):"r"(addr1), "r"(addr2), "r"(some_nonzero_val):"memory");
> 
>  Then check for res == some_nonzero_val. If they are equal, you've got the bug :)
>

Besides the fixes mentioned in other mails, I did add this load to xzr
tests too. For mmio we get the expected failure. mrs seems to work
though, but maybe that's expected.

qemu-system-aarch64 -machine virt,accel=kvm -cpu host \
  -device virtio-serial-device -device virtconsole,chardev=ctd \
  -chardev testdev,id=ctd -display none -serial stdio \
  -kernel arm/xzr-test.flat -smp 2

PASS: mmio: sanity check: read 0x55555555
FAIL: mmio: 'str wzr' check: read 0x0badc0de
FAIL: mmio: 'ldr wzr' check: read 0x0badc0de
PASS: sysreg: sp = 0x00000000401affe0
FAIL: sysreg: from xzr check: read 0xffffc0de0badc0de
PASS: sysreg: to xzr check: read 0x0000000000000000

SUMMARY: 6 tests, 3 unexpected failures
Return value from qemu: 3

Updated test attached.

drew 

--xXmbgvnjoT4axfJE
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="0001-arm64-add-xzr-emulator-test.patch"

>From ef5af811a72c14977e7958ee94b0c7b0fb99e6e8 Mon Sep 17 00:00:00 2001
From: Andrew Jones <drjones@redhat.com>
Date: Fri, 4 Dec 2015 23:55:53 +0100
Subject: [kvm-unit-tests PATCH] arm64: add xzr emulator test

---
v2:
 - added Pavel's fixes
 - changed target sysreg

 arm/xzr-test.c          | 89 +++++++++++++++++++++++++++++++++++++++++++++++++
 config/config-arm64.mak |  4 ++-
 2 files changed, 92 insertions(+), 1 deletion(-)
 create mode 100644 arm/xzr-test.c

diff --git a/arm/xzr-test.c b/arm/xzr-test.c
new file mode 100644
index 0000000000000..cf92dcc2d4e00
--- /dev/null
+++ b/arm/xzr-test.c
@@ -0,0 +1,89 @@
+#include <libcflat.h>
+#include <chr-testdev.h>
+#include <asm/setup.h>
+#include <asm/smp.h>
+#include <asm/mmu.h>
+#include <asm/io.h>
+#include <asm/thread_info.h>
+
+
+static void check_xzr_sysreg(void)
+{
+	uint64_t val;
+
+#if 0
+	flush_tlb_all();
+	mmu_disable(); /* Tell KVM to set HCR_TVM for this VCPU */
+#endif
+
+	val = current_stack_pointer;
+	report("sysreg: sp = 0x%016lx", val != 0, val);
+
+	asm volatile("msr sp_el0, %0" : : "r" (0xdeadc0de0badc0de));
+	isb();
+
+#if 0
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
+#endif
+	asm volatile("msr dbgbvr0_el1, xzr");
+	isb();
+	asm volatile("mrs %0, dbgbvr0_el1" : "=r" (val));
+	isb();
+	report("sysreg: from xzr check: read 0x%016lx", val == 0, val);
+	asm volatile("mrs xzr, dbgbvr0_el1");
+	isb();
+	asm volatile("mov %0, xzr" : "=r" (val));
+	report("sysreg: to xzr check: read 0x%016lx", val == 0, val);
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
+	asm volatile("msr sp_el0, %0" : : "r" (0xdeadc0de0badc0de));
+	isb();
+
+	writel(0x55555555, addr);
+	val = readl(addr);
+	report("mmio: sanity check: read 0x%08lx", val == 0x55555555, val);
+
+	mb();
+	asm volatile("str wzr, [%0]" : : "r" (addr));
+	val = readl(addr);
+	report("mmio: 'str wzr' check: read 0x%08lx", val == 0, val);
+	mb();
+	asm volatile("ldr wzr, [%0]" : : "r" (addr));
+	report("mmio: 'ldr wzr' check: read 0x%08lx", val == 0, val);
+
+	writel(0, addr);
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


--xXmbgvnjoT4axfJE--
