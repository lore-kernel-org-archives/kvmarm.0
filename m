Return-Path: <SRS0=KLQI=YK=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4373DFA372A
	for <kvmarm@archiver.kernel.org>; Thu, 17 Oct 2019 13:31:02 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 81548205F4
	for <kvmarm@archiver.kernel.org>; Thu, 17 Oct 2019 13:31:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 81548205F4
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C7EF34A99D;
	Thu, 17 Oct 2019 09:31:00 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 6Cig0AeNPeuy; Thu, 17 Oct 2019 09:30:51 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 392BD4A9EC;
	Thu, 17 Oct 2019 09:30:51 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8AF8C4A9A4
 for <kvmarm@lists.cs.columbia.edu>; Thu, 17 Oct 2019 09:30:49 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id aLfDx5S2r4aj for <kvmarm@lists.cs.columbia.edu>;
 Thu, 17 Oct 2019 09:30:39 -0400 (EDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 7DB524A99D
 for <kvmarm@lists.cs.columbia.edu>; Thu, 17 Oct 2019 09:30:39 -0400 (EDT)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com
 [10.5.11.23])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mx1.redhat.com (Postfix) with ESMTPS id A862910DCCA1;
 Thu, 17 Oct 2019 13:30:38 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.43.2.160])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 74C74450F;
 Thu, 17 Oct 2019 13:30:33 +0000 (UTC)
Date: Thu, 17 Oct 2019 15:30:31 +0200
From: Andrew Jones <drjones@redhat.com>
To: Thomas Huth <thuth@redhat.com>
Subject: Re: [kvm-unit-tests PATCH] Switch the order of the parameters in
 report() and report_xfail()
Message-ID: <20191017133031.wmc7y26nsd63zle6@kamzik.brq.redhat.com>
References: <20191017131552.30913-1-thuth@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20191017131552.30913-1-thuth@redhat.com>
User-Agent: NeoMutt/20180716
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.6.2
 (mx1.redhat.com [10.5.110.64]); Thu, 17 Oct 2019 13:30:38 +0000 (UTC)
Cc: Laurent Vivier <lvivier@redhat.com>, kvm@vger.kernel.org,
 David Hildenbrand <david@redhat.com>, kvm-ppc@vger.kernel.org,
 Bill Wendling <morbo@google.com>, Paolo Bonzini <pbonzini@redhat.com>,
 kvmarm@lists.cs.columbia.edu
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


Hi Thomas and Paolo,

This will conflict badly with "[kvm-unit-tests PATCH v2 0/6] arm: Use
stable test output lines" and likely with pretty much anything else
in flight - since pretty much everything adds report() lines. I'm not
sure why "[kvm-unit-tests PATCH v2 0/6] arm: Use stable test output
lines" hasn't been merged yet. Paolo, do you want me to do PULL
requests for all the arm-related patches? If so, I can do one tomorrow
for what's currently reviewed and waiting. I'd prefer they all get
merged before this patch. We should also confirm all other architectures
have their reviewed and waiting patches merged first too, IMHO.

Thanks,
drew


On Thu, Oct 17, 2019 at 03:15:52PM +0200, Thomas Huth wrote:
> Commit c09c54c66b1df ("lib: use an argument which doesn't require
> default argument promotion") fixed a warning that occurs with Clang,
> but introduced a regression: If the "pass" parameter is a value
> which has only set the condition bits in the upper 32 bits of a
> 64 bit value, the condition is now false since the value is truncated
> to "unsigned int" so that the upper bits are simply discarded.
> 
> To fix this, it would be best to use "bool" for the "pass" parameter
> again. But we can not use "bool" if it is the last parameter before
> the variable argument list, so we have to swap the parameters around
> and make the format string the last parameter.
> 
> This patch (except the changes in lib/libcflat.h and lib/report.c)
> has basically been created with following coccinelle script (with
> some manual tweaking of long and disabled lines afterwards):
> 
> @@
> expression fmt;
> expression pass;
> expression list args;
> @@
>  report(
> -fmt, pass
> +pass, fmt
>  , args);
> 
> @@
> expression fmt;
> expression pass;
> expression list args;
> @@
>  report_xfail(
> -fmt, xfail, pass
> +xfail, pass, fmt
>  , args);
> 
> Fixes: c09c54c66b1d ("lib: use an argument which doesn't require ...")
> Signed-off-by: Thomas Huth <thuth@redhat.com>
> ---
>  arm/gic.c                 |  67 +++--
>  arm/pci-test.c            |   4 +-
>  arm/pmu.c                 |   9 +-
>  arm/psci.c                |  10 +-
>  arm/selftest.c            |  14 +-
>  arm/spinlock-test.c       |   2 +-
>  arm/timer.c               |  16 +-
>  lib/libcflat.h            |   8 +-
>  lib/report.c              |   8 +-
>  lib/s390x/interrupt.c     |   5 +-
>  lib/x86/fault_test.c      |   2 +-
>  powerpc/emulator.c        |  44 +--
>  powerpc/rtas.c            |  32 +-
>  powerpc/selftest.c        |   4 +-
>  powerpc/spapr_hcall.c     |  30 +-
>  powerpc/sprs.c            |   5 +-
>  powerpc/tm.c              |   6 +-
>  s390x/cpumodel.c          |   2 +-
>  s390x/diag288.c           |   2 +-
>  s390x/diag308.c           |   4 +-
>  s390x/emulator.c          |  18 +-
>  s390x/gs.c                |   2 +-
>  s390x/intercept.c         |  16 +-
>  s390x/pfmf.c              |   9 +-
>  s390x/selftest.c          |  23 +-
>  s390x/skey.c              |  11 +-
>  s390x/skrf.c              |  10 +-
>  s390x/smp.c               |  37 +--
>  s390x/sthyi.c             |  41 +--
>  s390x/stsi.c              |   8 +-
>  s390x/vector.c            |   6 +-
>  x86/apic.c                | 148 +++++-----
>  x86/asyncpf.c             |  11 +-
>  x86/cmpxchg8b.c           |   2 +-
>  x86/debug.c               |  69 +++--
>  x86/emulator.c            | 290 +++++++++---------
>  x86/eventinj.c            |  30 +-
>  x86/hypercall.c           |   6 +-
>  x86/hyperv_clock.c        |   9 +-
>  x86/hyperv_connections.c  |  28 +-
>  x86/hyperv_stimer.c       |  28 +-
>  x86/hyperv_synic.c        |   4 +-
>  x86/idt_test.c            |   8 +-
>  x86/intel-iommu.c         |  25 +-
>  x86/ioapic.c              |  57 ++--
>  x86/memory.c              |  17 +-
>  x86/msr.c                 |   2 +-
>  x86/pcid.c                |  10 +-
>  x86/pku.c                 |  20 +-
>  x86/pmu.c                 |  25 +-
>  x86/rdpru.c               |   2 +-
>  x86/smap.c                |  28 +-
>  x86/smptest.c             |   2 +-
>  x86/svm.c                 |  14 +-
>  x86/syscall.c             |   4 +-
>  x86/taskswitch2.c         |  26 +-
>  x86/tsc.c                 |   4 +-
>  x86/tsc_adjust.c          |  22 +-
>  x86/tscdeadline_latency.c |   2 +-
>  x86/umip.c                |  24 +-
>  x86/vmx.c                 | 167 +++++------
>  x86/vmx.h                 |   9 +-
>  x86/vmx_tests.c           | 599 ++++++++++++++++++++------------------
>  x86/xsave.c               |  80 ++---
>  64 files changed, 1152 insertions(+), 1075 deletions(-)
> 
> diff --git a/arm/gic.c b/arm/gic.c
> index ed5642e..2e52e0e 100644
> --- a/arm/gic.c
> +++ b/arm/gic.c
> @@ -88,7 +88,7 @@ static void check_acked(cpumask_t *mask)
>  			}
>  		}
>  		if (nr_pass == nr_cpus) {
> -			report("Completed in %d ms", !bad, ++i * 100);
> +			report(!bad, "Completed in %d ms", ++i * 100);
>  			return;
>  		}
>  	}
> @@ -105,8 +105,9 @@ static void check_acked(cpumask_t *mask)
>  		}
>  	}
>  
> -	report("Timed-out (5s). ACKS: missing=%d extra=%d unexpected=%d",
> -	       false, missing, extra, unexpected);
> +	report(false,
> +	       "Timed-out (5s). ACKS: missing=%d extra=%d unexpected=%d",
> +	       missing, extra, unexpected);
>  }
>  
>  static void check_spurious(void)
> @@ -350,7 +351,7 @@ static void test_typer_v2(uint32_t reg)
>  {
>  	int nr_gic_cpus = ((reg >> 5) & 0x7) + 1;
>  
> -	report("all %d CPUs have interrupts", nr_cpus == nr_gic_cpus,
> +	report(nr_cpus == nr_gic_cpus, "all %d CPUs have interrupts",
>  	       nr_gic_cpus);
>  }
>  
> @@ -368,15 +369,16 @@ static void test_byte_access(void *base_addr, u32 pattern, u32 mask)
>  {
>  	u32 reg = readb(base_addr + 1);
>  
> -	report("byte reads successful (0x%08x => 0x%02x)",
> -	       reg == (BYTE(pattern, 1) & (mask >> 8)),
> +	report(reg == (BYTE(pattern, 1) & (mask >> 8)),
> +	       "byte reads successful (0x%08x => 0x%02x)",
>  	       pattern & mask, reg);
>  
>  	pattern = REPLACE_BYTE(pattern, 2, 0x1f);
>  	writeb(BYTE(pattern, 2), base_addr + 2);
>  	reg = readl(base_addr);
> -	report("byte writes successful (0x%02x => 0x%08x)",
> -	       reg == (pattern & mask), BYTE(pattern, 2), reg);
> +	report(reg == (pattern & mask),
> +	       "byte writes successful (0x%02x => 0x%08x)", BYTE(pattern, 2),
> +	       reg);
>  }
>  
>  static void test_priorities(int nr_irqs, void *priptr)
> @@ -396,33 +398,33 @@ static void test_priorities(int nr_irqs, void *priptr)
>  	pri_mask = readl(first_spi);
>  
>  	reg = ~pri_mask;
> -	report("consistent priority masking (0x%08x)",
> -	       (((reg >> 16) == (reg & 0xffff)) &&
> -	        ((reg & 0xff) == ((reg >> 8) & 0xff))), pri_mask);
> +	report((((reg >> 16) == (reg & 0xffff)) &&
> +	       ((reg & 0xff) == ((reg >> 8) & 0xff))),
> +	       "consistent priority masking (0x%08x)", pri_mask);
>  
>  	reg = reg & 0xff;
>  	for (pri_bits = 8; reg & 1; reg >>= 1, pri_bits--)
>  		;
> -	report("implements at least 4 priority bits (%d)",
> -	       pri_bits >= 4, pri_bits);
> +	report(pri_bits >= 4, "implements at least 4 priority bits (%d)",
> +	       pri_bits);
>  
>  	pattern = 0;
>  	writel(pattern, first_spi);
> -	report("clearing priorities", readl(first_spi) == pattern);
> +	report(readl(first_spi) == pattern, "clearing priorities");
>  
>  	/* setting all priorities to their max valus was tested above */
>  
> -	report("accesses beyond limit RAZ/WI",
> -	       test_readonly_32(priptr + nr_irqs, true));
> +	report(test_readonly_32(priptr + nr_irqs, true),
> +	       "accesses beyond limit RAZ/WI");
>  
>  	writel(pattern, priptr + nr_irqs - 4);
> -	report("accessing last SPIs",
> -	       readl(priptr + nr_irqs - 4) == (pattern & pri_mask));
> +	report(readl(priptr + nr_irqs - 4) == (pattern & pri_mask),
> +	       "accessing last SPIs");
>  
>  	pattern = 0xff7fbf3f;
>  	writel(pattern, first_spi);
> -	report("priorities are preserved",
> -	       readl(first_spi) == (pattern & pri_mask));
> +	report(readl(first_spi) == (pattern & pri_mask),
> +	       "priorities are preserved");
>  
>  	/* The PRIORITY registers are byte accessible. */
>  	test_byte_access(first_spi, pattern, pri_mask);
> @@ -449,21 +451,22 @@ static void test_targets(int nr_irqs)
>  	/* Check that bits for non implemented CPUs are RAZ/WI. */
>  	if (nr_cpus < 8) {
>  		writel(0xffffffff, targetsptr + GIC_FIRST_SPI);
> -		report("bits for %d non-existent CPUs masked",
> -		       !(readl(targetsptr + GIC_FIRST_SPI) & ~cpu_mask),
> +		report(!(readl(targetsptr + GIC_FIRST_SPI) & ~cpu_mask),
> +		       "bits for %d non-existent CPUs masked",
>  		       8 - nr_cpus);
>  	} else {
>  		report_skip("CPU masking (all CPUs implemented)");
>  	}
>  
> -	report("accesses beyond limit RAZ/WI",
> -	       test_readonly_32(targetsptr + nr_irqs, true));
> +	report(test_readonly_32(targetsptr + nr_irqs, true),
> +	       "accesses beyond limit RAZ/WI");
>  
>  	pattern = 0x0103020f;
>  	writel(pattern, targetsptr + GIC_FIRST_SPI);
>  	reg = readl(targetsptr + GIC_FIRST_SPI);
> -	report("register content preserved (%08x => %08x)",
> -	       reg == (pattern & cpu_mask), pattern & cpu_mask, reg);
> +	report(reg == (pattern & cpu_mask),
> +	       "register content preserved (%08x => %08x)",
> +	       pattern & cpu_mask, reg);
>  
>  	/* The TARGETS registers are byte accessible. */
>  	test_byte_access(targetsptr + GIC_FIRST_SPI, pattern, cpu_mask);
> @@ -496,14 +499,14 @@ static void gic_test_mmio(void)
>  
>  	report_info("IIDR: 0x%08x", readl(gic_dist_base + GICD_IIDR));
>  
> -	report("GICD_TYPER is read-only",
> -	       test_readonly_32(gic_dist_base + GICD_TYPER, false));
> -	report("GICD_IIDR is read-only",
> -	       test_readonly_32(gic_dist_base + GICD_IIDR, false));
> +	report(test_readonly_32(gic_dist_base + GICD_TYPER, false),
> +               "GICD_TYPER is read-only");
> +	report(test_readonly_32(gic_dist_base + GICD_IIDR, false),
> +               "GICD_IIDR is read-only");
>  
>  	reg = readl(idreg);
> -	report("ICPIDR2 is read-only (0x%08x)",
> -	       test_readonly_32(idreg, false),
> +	report(test_readonly_32(idreg, false),
> +	       "ICPIDR2 is read-only (0x%08x)",
>  	       reg);
>  
>  	test_priorities(nr_irqs, gic_dist_base + GICD_IPRIORITYR);
> diff --git a/arm/pci-test.c b/arm/pci-test.c
> index cf128ac..879b254 100644
> --- a/arm/pci-test.c
> +++ b/arm/pci-test.c
> @@ -25,8 +25,8 @@ int main(void)
>  	if (ret == -1)
>  		report_skip("No PCI test device");
>  	else
> -		report("PCI test device passed %d/%d tests",
> -			ret >= NR_TESTS, ret > 0 ? ret : 0, NR_TESTS);
> +		report(ret >= NR_TESTS, "PCI test device passed %d/%d tests",
> +		       ret > 0 ? ret : 0, NR_TESTS);
>  
>  	return report_summary();
>  }
> diff --git a/arm/pmu.c b/arm/pmu.c
> index 1de7d77..d5a03a6 100644
> --- a/arm/pmu.c
> +++ b/arm/pmu.c
> @@ -268,7 +268,7 @@ static void pmccntr64_test(void)
>  	if (pmu_version == 0x3) {
>  		if (ERRATA(9e3f7a296940)) {
>  			write_sysreg(0xdead, PMCCNTR64);
> -			report("pmccntr64", read_sysreg(PMCCNTR64) == 0xdead);
> +			report(read_sysreg(PMCCNTR64) == 0xdead, "pmccntr64");
>  		} else
>  			report_skip("Skipping unsafe pmccntr64 test. Set ERRATA_9e3f7a296940=y to enable.");
>  	}
> @@ -297,9 +297,10 @@ int main(int argc, char *argv[])
>  
>  	report_prefix_push("pmu");
>  
> -	report("Control register", check_pmcr());
> -	report("Monotonically increasing cycle count", check_cycles_increase());
> -	report("Cycle/instruction ratio", check_cpi(cpi));
> +	report(check_pmcr(), "Control register");
> +	report(check_cycles_increase(),
> +	       "Monotonically increasing cycle count");
> +	report(check_cpi(cpi), "Cycle/instruction ratio");
>  
>  	pmccntr64_test();
>  
> diff --git a/arm/psci.c b/arm/psci.c
> index 5cb4d5c..7f47a21 100644
> --- a/arm/psci.c
> +++ b/arm/psci.c
> @@ -133,12 +133,12 @@ int main(void)
>  
>  	report_info("PSCI version %d.%d", PSCI_VERSION_MAJOR(ver),
>  					  PSCI_VERSION_MINOR(ver));
> -	report("invalid-function", psci_invalid_function());
> -	report("affinity-info-on", psci_affinity_info_on());
> -	report("affinity-info-off", psci_affinity_info_off());
> +	report(psci_invalid_function(), "invalid-function");
> +	report(psci_affinity_info_on(), "affinity-info-on");
> +	report(psci_affinity_info_off(), "affinity-info-off");
>  
>  	if (ERRATA(6c7a5dce22b3))
> -		report("cpu-on", psci_cpu_on_test());
> +		report(psci_cpu_on_test(), "cpu-on");
>  	else
>  		report_skip("Skipping unsafe cpu-on test. Set ERRATA_6c7a5dce22b3=y to enable.");
>  
> @@ -146,7 +146,7 @@ done:
>  #if 0
>  	report_summary();
>  	psci_invoke(PSCI_0_2_FN_SYSTEM_OFF, 0, 0, 0);
> -	report("system-off", false);
> +	report(false, "system-off");
>  	return 1; /* only reaches here if system-off fails */
>  #else
>  	return report_summary();
> diff --git a/arm/selftest.c b/arm/selftest.c
> index 28a17f7..8d79b86 100644
> --- a/arm/selftest.c
> +++ b/arm/selftest.c
> @@ -43,13 +43,13 @@ static void check_setup(int argc, char **argv)
>  			phys_addr_t memsize = PHYS_END - PHYS_OFFSET;
>  			phys_addr_t expected = ((phys_addr_t)val)*1024*1024;
>  
> -			report("size = %" PRIu64 " MB", memsize == expected,
> +			report(memsize == expected, "size = %" PRIu64 " MB",
>  							memsize/1024/1024);
>  			++nr_tests;
>  
>  		} else if (strcmp(argv[i], "smp") == 0) {
>  
> -			report("nr_cpus = %d", nr_cpus == (int)val, nr_cpus);
> +			report(nr_cpus == (int)val, "nr_cpus = %d", nr_cpus);
>  			++nr_tests;
>  		}
>  
> @@ -291,8 +291,8 @@ static void user_psci_system_off(struct pt_regs *regs, unsigned int esr)
>  
>  static void check_vectors(void *arg __unused)
>  {
> -	report("und", check_und());
> -	report("svc", check_svc());
> +	report(check_und(), "und");
> +	report(check_svc(), "svc");
>  	if (is_user()) {
>  #ifdef __arm__
>  		install_exception_handler(EXCPTN_UND, user_psci_system_off);
> @@ -338,8 +338,8 @@ static void cpu_report(void *data __unused)
>  	uint64_t mpidr = get_mpidr();
>  	int cpu = smp_processor_id();
>  
> -	report("CPU(%3d) mpidr=%010" PRIx64,
> -		mpidr_to_cpu(mpidr) == cpu, cpu, mpidr);
> +	report(mpidr_to_cpu(mpidr) == cpu, "CPU(%3d) mpidr=%010" PRIx64, cpu,
> +	       mpidr);
>  }
>  
>  int main(int argc, char **argv)
> @@ -366,7 +366,7 @@ int main(int argc, char **argv)
>  
>  	} else if (strcmp(argv[1], "smp") == 0) {
>  
> -		report("PSCI version", psci_check());
> +		report(psci_check(), "PSCI version");
>  		on_cpus(cpu_report, NULL);
>  
>  	} else {
> diff --git a/arm/spinlock-test.c b/arm/spinlock-test.c
> index d55471b..a63fb41 100644
> --- a/arm/spinlock-test.c
> +++ b/arm/spinlock-test.c
> @@ -67,7 +67,7 @@ static void test_spinlock(void *data __unused)
>  
>  		lock_ops.unlock(&global_lock);
>  	}
> -	report("CPU%d: Done - Errors: %d", errors == 0, cpu, errors);
> +	report(errors == 0, "CPU%d: Done - Errors: %d", cpu, errors);
>  }
>  
>  int main(int argc, char **argv)
> diff --git a/arm/timer.c b/arm/timer.c
> index f2f6019..68dce46 100644
> --- a/arm/timer.c
> +++ b/arm/timer.c
> @@ -222,19 +222,19 @@ static void test_timer(struct timer_info *info)
>  	info->write_cval(later);
>  	info->write_ctl(ARCH_TIMER_CTL_ENABLE);
>  	isb();
> -	report("not pending before", !gic_timer_pending(info));
> +	report(!gic_timer_pending(info), "not pending before");
>  
>  	info->write_cval(now - 1);
>  	isb();
> -	report("interrupt signal pending", gic_timer_pending(info));
> +	report(gic_timer_pending(info), "interrupt signal pending");
>  
>  	/* Disable the timer again and prepare to take interrupts */
>  	info->write_ctl(0);
>  	set_timer_irq_enabled(info, true);
> -	report("interrupt signal no longer pending", !gic_timer_pending(info));
> +	report(!gic_timer_pending(info), "interrupt signal no longer pending");
>  
> -	report("latency within 10 ms", test_cval_10msec(info));
> -	report("interrupt received", info->irq_received);
> +	report(test_cval_10msec(info), "latency within 10 ms");
> +	report(info->irq_received, "interrupt received");
>  
>  	/* Disable the timer again */
>  	info->write_ctl(0);
> @@ -248,8 +248,8 @@ static void test_timer(struct timer_info *info)
>  	wfi();
>  	local_irq_enable();
>  	left = info->read_tval();
> -	report("interrupt received after TVAL/WFI", info->irq_received);
> -	report("timer has expired (%d)", left < 0, left);
> +	report(info->irq_received, "interrupt received after TVAL/WFI");
> +	report(left < 0, "timer has expired (%d)", left);
>  }
>  
>  static void test_vtimer(void)
> @@ -296,7 +296,7 @@ static void test_init(void)
>  	if (ptimer_unsupported && !ERRATA(7b6b46311a85)) {
>  		report_skip("Skipping ptimer tests. Set ERRATA_7b6b46311a85=y to enable.");
>  	} else if (ptimer_unsupported) {
> -		report("ptimer: read CNTP_CTL_EL0", false);
> +		report(false, "ptimer: read CNTP_CTL_EL0");
>  		report_info("ptimer: skipping remaining tests");
>  	}
>  
> diff --git a/lib/libcflat.h b/lib/libcflat.h
> index b6635d9..d6d1323 100644
> --- a/lib/libcflat.h
> +++ b/lib/libcflat.h
> @@ -99,10 +99,10 @@ void report_prefix_pushf(const char *prefix_fmt, ...)
>  					__attribute__((format(printf, 1, 2)));
>  extern void report_prefix_push(const char *prefix);
>  extern void report_prefix_pop(void);
> -extern void report(const char *msg_fmt, unsigned pass, ...)
> -					__attribute__((format(printf, 1, 3)));
> -extern void report_xfail(const char *msg_fmt, bool xfail, unsigned pass, ...)
> -					__attribute__((format(printf, 1, 4)));
> +extern void report(bool pass, const char *msg_fmt, ...)
> +					__attribute__((format(printf, 2, 3)));
> +extern void report_xfail(bool xfail, bool pass, const char *msg_fmt, ...)
> +					__attribute__((format(printf, 3, 4)));
>  extern void report_abort(const char *msg_fmt, ...)
>  					__attribute__((format(printf, 1, 2)))
>  					__attribute__((noreturn));
> diff --git a/lib/report.c b/lib/report.c
> index 2a5f549..2255dc3 100644
> --- a/lib/report.c
> +++ b/lib/report.c
> @@ -104,18 +104,18 @@ static void va_report(const char *msg_fmt,
>  	spin_unlock(&lock);
>  }
>  
> -void report(const char *msg_fmt, unsigned pass, ...)
> +void report(bool pass, const char *msg_fmt, ...)
>  {
>  	va_list va;
> -	va_start(va, pass);
> +	va_start(va, msg_fmt);
>  	va_report(msg_fmt, pass, false, false, va);
>  	va_end(va);
>  }
>  
> -void report_xfail(const char *msg_fmt, bool xfail, unsigned pass, ...)
> +void report_xfail(bool xfail, bool pass, const char *msg_fmt, ...)
>  {
>  	va_list va;
> -	va_start(va, pass);
> +	va_start(va, msg_fmt);
>  	va_report(msg_fmt, pass, xfail, false, va);
>  	va_end(va);
>  }
> diff --git a/lib/s390x/interrupt.c b/lib/s390x/interrupt.c
> index 5cade23..1d83154 100644
> --- a/lib/s390x/interrupt.c
> +++ b/lib/s390x/interrupt.c
> @@ -46,8 +46,9 @@ uint16_t clear_pgm_int(void)
>  void check_pgm_int_code(uint16_t code)
>  {
>  	mb();
> -	report("Program interrupt: expected(%d) == received(%d)",
> -	       code == lc->pgm_int_code, code, lc->pgm_int_code);
> +	report(code == lc->pgm_int_code,
> +	       "Program interrupt: expected(%d) == received(%d)", code,
> +	       lc->pgm_int_code);
>  }
>  
>  static void fixup_pgm_int(void)
> diff --git a/lib/x86/fault_test.c b/lib/x86/fault_test.c
> index b9db399..078dae3 100644
> --- a/lib/x86/fault_test.c
> +++ b/lib/x86/fault_test.c
> @@ -47,6 +47,6 @@ void test_run(struct fault_test *test)
>  {
>  	bool passed = fault_test(&(test->arg));
>  
> -	report("%s", passed, test->name);
> +	report(passed, "%s", test->name);
>  }
>  
> diff --git a/powerpc/emulator.c b/powerpc/emulator.c
> index a7f454e..147878e 100644
> --- a/powerpc/emulator.c
> +++ b/powerpc/emulator.c
> @@ -53,7 +53,7 @@ static void test_illegal(void)
>  
>  	asm volatile (".long 0");
>  
> -	report("exception", is_invalid == 8); /* illegal instruction */
> +	report(is_invalid == 8, "exception"); /* illegal instruction */
>  
>  	report_prefix_pop();
>  }
> @@ -66,7 +66,7 @@ static void test_64bit(void)
>  
>  	asm("mfmsr %[msr]": [msr] "=r" (msr));
>  
> -	report("detected", msr & 0x8000000000000000UL);
> +	report(msr & 0x8000000000000000UL, "detected");
>  
>  	report_prefix_pop();
>  }
> @@ -106,13 +106,13 @@ static void test_lswi(void)
>  	 * mode, but QEMU does not support it. So in case we do not get an
>  	 * exception, this is an expected failure and we run the other tests
>  	 */
> -	report_xfail("alignment", !alignment, alignment);
> +	report_xfail(!alignment, alignment, "alignment");
>  	if (alignment) {
>  		report_prefix_pop();
>  		return;
>  	}
>  #endif
> -	report("partial", regs[0] == 0x01020300 && regs[1] == (uint64_t)-1);
> +	report(regs[0] == 0x01020300 && regs[1] == (uint64_t)-1, "partial");
>  
>  	/* check NB = 0 ==> 32 bytes. */
>  	asm volatile ("li r19,-1;"
> @@ -142,11 +142,11 @@ static void test_lswi(void)
>  		      "r11", "r12", "r13", "r14", "r15", "r16", "r17",
>  		      "r18", "r19", "memory");
>  
> -	report("length", regs[0] == 0x01020304 && regs[1] == 0x05060708 &&
> -			 regs[2] == 0x090a0b0c && regs[3] == 0x0d0e0f10 &&
> -			 regs[4] == 0x11121314 && regs[5] == 0x15161718 &&
> -			 regs[6] == 0x191a1b1c && regs[7] == 0x1d1e1f20 &&
> -			 regs[8] == (uint64_t)-1);
> +	report(regs[0] == 0x01020304 && regs[1] == 0x05060708 &&
> +	       regs[2] == 0x090a0b0c && regs[3] == 0x0d0e0f10 &&
> +	       regs[4] == 0x11121314 && regs[5] == 0x15161718 &&
> +	       regs[6] == 0x191a1b1c && regs[7] == 0x1d1e1f20 &&
> +	       regs[8] == (uint64_t)-1, "length");
>  
>  	/* check wrap around to r0 */
>  	asm volatile ("li r31,-1;"
> @@ -162,8 +162,8 @@ static void test_lswi(void)
>  		      /* modify two registers from r31, wrap around to r0 */
>  		      "r31", "r0", "memory");
>  
> -	report("wrap around to r0", regs[0] == 0x01020304 &&
> -			            regs[1] == 0x05060708);
> +	report(regs[0] == 0x01020304 && regs[1] == 0x05060708,
> +	       "wrap around to r0");
>  
>  	/* check wrap around doesn't break RA */
>  	asm volatile ("mr r29,r1\n"
> @@ -189,7 +189,7 @@ static void test_lswi(void)
>  	 * overwrite the register.
>  	 * In all the cases, the register must stay untouched
>  	 */
> -	report("Don't overwrite Ra", regs[2] == (uint64_t)addr);
> +	report(regs[2] == (uint64_t)addr, "Don't overwrite Ra");
>  
>  	report_prefix_pop();
>  }
> @@ -250,13 +250,13 @@ static void test_lswx(void)
>  	 * mode, but QEMU does not support it. So in case we do not get an
>  	 * exception, this is an expected failure and we run the other tests
>  	 */
> -	report_xfail("alignment", !alignment, alignment);
> +	report_xfail(!alignment, alignment, "alignment");
>  	if (alignment) {
>  		report_prefix_pop();
>  		return;
>  	}
>  #endif
> -	report("partial", regs[0] == 0x01020300 && regs[1] == (uint64_t)-1);
> +	report(regs[0] == 0x01020300 && regs[1] == (uint64_t)-1, "partial");
>  
>  	/* check an old know bug: the number of bytes is used as
>  	 * the number of registers, so try 32 bytes.
> @@ -290,11 +290,11 @@ static void test_lswx(void)
>  		      "xer", "r11", "r12", "r13", "r14", "r15", "r16", "r17",
>  		      "r18", "r19", "memory");
>  
> -	report("length", regs[0] == 0x01020304 && regs[1] == 0x05060708 &&
> -			 regs[2] == 0x090a0b0c && regs[3] == 0x0d0e0f10 &&
> -			 regs[4] == 0x11121314 && regs[5] == 0x15161718 &&
> -			 regs[6] == 0x191a1b1c && regs[7] == 0x1d1e1f20 &&
> -			 regs[8] == (uint64_t)-1);
> +	report(regs[0] == 0x01020304 && regs[1] == 0x05060708 &&
> +	       regs[2] == 0x090a0b0c && regs[3] == 0x0d0e0f10 &&
> +	       regs[4] == 0x11121314 && regs[5] == 0x15161718 &&
> +	       regs[6] == 0x191a1b1c && regs[7] == 0x1d1e1f20 &&
> +	       regs[8] == (uint64_t)-1, "length");
>  
>  	/* check wrap around to r0 */
>  
> @@ -312,8 +312,8 @@ static void test_lswx(void)
>  		      /* modify two registers from r31, wrap around to r0 */
>  		      "xer", "r31", "r0", "memory");
>  
> -	report("wrap around to r0", regs[0] == 0x01020304 &&
> -			            regs[1] == 0x05060708);
> +	report(regs[0] == 0x01020304 && regs[1] == 0x05060708,
> +	       "wrap around to r0");
>  
>  	/* check wrap around to r0 over RB doesn't break RB */
>  
> @@ -342,7 +342,7 @@ static void test_lswx(void)
>  	 * overwrite the register.
>  	 * In all the cases, the register must stay untouched
>  	 */
> -	report("Don't overwrite Rb", regs[1] == (uint64_t)addr);
> +	report(regs[1] == (uint64_t)addr, "Don't overwrite Rb");
>  
>  	report_prefix_pop();
>  }
> diff --git a/powerpc/rtas.c b/powerpc/rtas.c
> index 5d43f33..9f5ec4b 100644
> --- a/powerpc/rtas.c
> +++ b/powerpc/rtas.c
> @@ -45,21 +45,21 @@ static void check_get_time_of_day(unsigned long start)
>  	unsigned long t1, t2, count;
>  
>  	ret = rtas_token("get-time-of-day", &token);
> -	report("token available", ret == 0);
> +	report(ret == 0, "token available");
>  	if (ret)
>  		return;
>  
>  	ret = rtas_call(token, 0, 8, now);
> -	report("execution", ret == 0);
> +	report(ret == 0, "execution");
>  
> -	report("second",  now[5] >= 0 && now[5] <= 59);
> -	report("minute", now[4] >= 0 && now[4] <= 59);
> -	report("hour", now[3] >= 0 && now[3] <= 23);
> -	report("day", now[2] >= 1 && now[2] <= 31);
> -	report("month", now[1] >= 1 && now[1] <= 12);
> -	report("year", now[0] >= 1970);
> -	report("accuracy (< 3s)", mktime(now[0], now[1], now[2],
> -					 now[3], now[4], now[5]) - start < 3);
> +	report(now[5] >= 0 && now[5] <= 59, "second");
> +	report(now[4] >= 0 && now[4] <= 59, "minute");
> +	report(now[3] >= 0 && now[3] <= 23, "hour");
> +	report(now[2] >= 1 && now[2] <= 31, "day");
> +	report(now[1] >= 1 && now[1] <= 12, "month");
> +	report(now[0] >= 1970, "year");
> +	report(mktime(now[0], now[1], now[2], now[3], now[4], now[5]) - start < 3,
> +	       "accuracy (< 3s)");
>  
>  	ret = rtas_call(token, 0, 8, now);
>  	t1 = mktime(now[0], now[1], now[2], now[3], now[4], now[5]);
> @@ -69,7 +69,7 @@ static void check_get_time_of_day(unsigned long start)
>  		t2 = mktime(now[0], now[1], now[2], now[3], now[4], now[5]);
>  		count++;
>  	} while (t1 + DELAY > t2 && count < MAX_LOOP);
> -	report("running", t1 + DELAY <= t2);
> +	report(t1 + DELAY <= t2, "running");
>  }
>  
>  static void check_set_time_of_day(void)
> @@ -80,24 +80,24 @@ static void check_set_time_of_day(void)
>  	unsigned long t1, t2, count;
>  
>  	ret = rtas_token("set-time-of-day", &stod_token);
> -	report("token available", ret == 0);
> +	report(ret == 0, "token available");
>  	if (ret)
>  		return;
>  
>  	/* 23:59:59 28/2/2000 */
>  
>  	ret = rtas_call(stod_token, 7, 1, NULL, 2000, 2, 28, 23, 59, 59);
> -	report("execution", ret == 0);
> +	report(ret == 0, "execution");
>  
>  	/* check it has worked */
>  	ret = rtas_token("get-time-of-day", &gtod_token);
>  	assert(ret == 0);
>  	ret = rtas_call(gtod_token, 0, 8, date);
> -	report("re-read", ret == 0);
> +	report(ret == 0, "re-read");
>  	t1 = mktime(2000, 2, 28, 23, 59, 59);
>  	t2 = mktime(date[0], date[1], date[2],
>  		    date[3], date[4], date[5]);
> -	report("result", t2 - t1 < 2);
> +	report(t2 - t1 < 2, "result");
>  
>  	/* check it is running */
>  	count = 0;
> @@ -107,7 +107,7 @@ static void check_set_time_of_day(void)
>  			    date[3], date[4], date[5]);
>  		count++;
>  	} while (t1 + DELAY > t2 && count < MAX_LOOP);
> -	report("running", t1 + DELAY <= t2);
> +	report(t1 + DELAY <= t2, "running");
>  }
>  
>  int main(int argc, char **argv)
> diff --git a/powerpc/selftest.c b/powerpc/selftest.c
> index 4e29fd6..7acff71 100644
> --- a/powerpc/selftest.c
> +++ b/powerpc/selftest.c
> @@ -28,13 +28,13 @@ static void check_setup(int argc, char **argv)
>  			phys_addr_t memsize = PHYSICAL_END - PHYSICAL_START;
>  			phys_addr_t expected = ((phys_addr_t)val)*1024*1024;
>  
> -			report("size = %" PRIu64 " MB", memsize == expected,
> +			report(memsize == expected, "size = %" PRIu64 " MB",
>  							memsize/1024/1024);
>  			++nr_tests;
>  
>  		} else if (strcmp(argv[i], "smp") == 0) {
>  
> -			report("nr_cpus = %d", nr_cpus == (int)val, nr_cpus);
> +			report(nr_cpus == (int)val, "nr_cpus = %d", nr_cpus);
>  			++nr_tests;
>  		}
>  
> diff --git a/powerpc/spapr_hcall.c b/powerpc/spapr_hcall.c
> index 524d896..823a574 100644
> --- a/powerpc/spapr_hcall.c
> +++ b/powerpc/spapr_hcall.c
> @@ -39,18 +39,18 @@ static void test_h_set_sprg0(int argc, char **argv)
>  
>  	rc = hcall(H_SET_SPRG0, 0xcafebabedeadbeefULL);
>  	sprg0 = mfspr(SPR_SPRG0);
> -	report("sprg0 = 0xcafebabedeadbeef",
> -		rc == H_SUCCESS && sprg0 == 0xcafebabedeadbeefULL);
> +	report(rc == H_SUCCESS && sprg0 == 0xcafebabedeadbeefULL,
> +	       "sprg0 = 0xcafebabedeadbeef");
>  
>  	rc = hcall(H_SET_SPRG0, 0xaaaaaaaa55555555ULL);
>  	sprg0 = mfspr(SPR_SPRG0);
> -	report("sprg0 = 0xaaaaaaaa55555555",
> -		rc == H_SUCCESS && sprg0 == 0xaaaaaaaa55555555ULL);
> +	report(rc == H_SUCCESS && sprg0 == 0xaaaaaaaa55555555ULL,
> +	       "sprg0 = 0xaaaaaaaa55555555");
>  
>  	rc = hcall(H_SET_SPRG0, sprg0_orig);
>  	sprg0 = mfspr(SPR_SPRG0);
> -	report("sprg0 = %#" PRIx64,
> -		rc == H_SUCCESS && sprg0 == sprg0_orig, sprg0_orig);
> +	report(rc == H_SUCCESS && sprg0 == sprg0_orig, "sprg0 = %#" PRIx64,
> +	       sprg0_orig);
>  }
>  
>  /**
> @@ -72,23 +72,23 @@ static void test_h_page_init(int argc, char **argv)
>  
>  	memset(dst, 0xaa, PAGE_SIZE);
>  	rc = hcall(H_PAGE_INIT, H_ZERO_PAGE, dst, src);
> -	report("h_zero_page", rc == H_SUCCESS && *(uint64_t*)dst == 0);
> +	report(rc == H_SUCCESS && *(uint64_t *)dst == 0, "h_zero_page");
>  
>  	*(uint64_t*)src = 0xbeefc0dedeadcafeULL;
>  	rc = hcall(H_PAGE_INIT, H_COPY_PAGE, dst, src);
> -	report("h_copy_page",
> -		rc == H_SUCCESS && *(uint64_t*)dst == 0xbeefc0dedeadcafeULL);
> +	report(rc == H_SUCCESS && *(uint64_t *)dst == 0xbeefc0dedeadcafeULL,
> +	       "h_copy_page");
>  
>  	*(uint64_t*)src = 0x9abcdef012345678ULL;
>  	rc = hcall(H_PAGE_INIT, H_COPY_PAGE|H_ZERO_PAGE, dst, src);
> -	report("h_copy_page+h_zero_page",
> -		rc == H_SUCCESS &&  *(uint64_t*)dst == 0x9abcdef012345678ULL);
> +	report(rc == H_SUCCESS && *(uint64_t *)dst == 0x9abcdef012345678ULL,
> +	       "h_copy_page+h_zero_page");
>  
>  	rc = hcall(H_PAGE_INIT, H_ZERO_PAGE, dst + 0x123, src);
> -	report("h_zero_page unaligned dst", rc == H_PARAMETER);
> +	report(rc == H_PARAMETER, "h_zero_page unaligned dst");
>  
>  	rc = hcall(H_PAGE_INIT, H_COPY_PAGE, dst, src + 0x123);
> -	report("h_copy_page unaligned src", rc == H_PARAMETER);
> +	report(rc == H_PARAMETER, "h_copy_page unaligned src");
>  }
>  
>  static int h_random(uint64_t *val)
> @@ -122,7 +122,7 @@ static void test_h_random(int argc, char **argv)
>  		report_skip("h-call is not available");
>  		return;
>  	}
> -	report("h-call can be used successfully", rc == H_SUCCESS);
> +	report(rc == H_SUCCESS, "h-call can be used successfully");
>  
>  	val0 = 0ULL;
>  	val1 = ~0ULL;
> @@ -136,7 +136,7 @@ static void test_h_random(int argc, char **argv)
>  		val1 &= rval;
>  	} while (i-- > 0 && (val0 != ~0ULL || val1 != 0ULL));
>  
> -	report("no stuck bits", rc == H_SUCCESS && val0 == ~0ULL && val1 == 0);
> +	report(rc == H_SUCCESS && val0 == ~0ULL && val1 == 0, "no stuck bits");
>  }
>  
>  struct {
> diff --git a/powerpc/sprs.c b/powerpc/sprs.c
> index 3c2d98c..d3c8780 100644
> --- a/powerpc/sprs.c
> +++ b/powerpc/sprs.c
> @@ -299,8 +299,9 @@ int main(int argc, char **argv)
>  	puts("Checking SPRs...\n");
>  	for (i = 0; i < 1024; i++) {
>  		if (before[i] != 0 || after[i] != 0)
> -			report("SPR %d:\t%#018lx <==> %#018lx",
> -				before[i] == after[i], i, before[i], after[i]);
> +			report(before[i] == after[i],
> +			       "SPR %d:\t%#018lx <==> %#018lx", i, before[i],
> +			       after[i]);
>  	}
>  
>  	return report_summary();
> diff --git a/powerpc/tm.c b/powerpc/tm.c
> index c588985..65cacdf 100644
> --- a/powerpc/tm.c
> +++ b/powerpc/tm.c
> @@ -127,7 +127,7 @@ static void test_h_cede_tm(int argc, char **argv)
>  		mdelay(5);
>  	}
>  
> -	report("H_CEDE TM", i == 500);
> +	report(i == 500, "H_CEDE TM");
>  }
>  
>  struct {
> @@ -150,8 +150,8 @@ int main(int argc, char **argv)
>  		report_skip("TM is not available");
>  		goto done;
>  	}
> -	report("TM available in all 'ibm,pa-features' properties",
> -	       cpus_with_tm == nr_cpus);
> +	report(cpus_with_tm == nr_cpus,
> +	       "TM available in all 'ibm,pa-features' properties");
>  
>  	all = argc == 1 || !strcmp(argv[1], "all");
>  
> diff --git a/s390x/cpumodel.c b/s390x/cpumodel.c
> index 3811ee1..5d232c6 100644
> --- a/s390x/cpumodel.c
> +++ b/s390x/cpumodel.c
> @@ -47,7 +47,7 @@ int main(void)
>  	report_prefix_push("dependency");
>  	for (i = 0; i < ARRAY_SIZE(dep); i++) {
>  		if (test_facility(dep[i][0])) {
> -			report("%d implies %d", test_facility(dep[i][1]),
> +			report(test_facility(dep[i][1]), "%d implies %d",
>  				dep[i][0], dep[i][1]);
>  		} else {
>  			report_skip("facility %d not present", dep[i][0]);
> diff --git a/s390x/diag288.c b/s390x/diag288.c
> index b4934bf..e2ecdc8 100644
> --- a/s390x/diag288.c
> +++ b/s390x/diag288.c
> @@ -101,7 +101,7 @@ static void test_bite(void)
>  		     "0:	nop\n"
>  		     "		j	0b\n"
>  		     "1:");
> -	report("restart", true);
> +	report(true, "restart");
>  }
>  
>  int main(void)
> diff --git a/s390x/diag308.c b/s390x/diag308.c
> index 6b4ffa6..7fc4abd 100644
> --- a/s390x/diag308.c
> +++ b/s390x/diag308.c
> @@ -29,12 +29,12 @@ static void test_priv(void)
>  extern int diag308_load_reset(u64);
>  static void test_subcode0(void)
>  {
> -	report("load modified clear done", diag308_load_reset(0));
> +	report(diag308_load_reset(0), "load modified clear done");
>  }
>  
>  static void test_subcode1(void)
>  {
> -	report("load normal reset done", diag308_load_reset(1));
> +	report(diag308_load_reset(1), "load normal reset done");
>  }
>  
>  /* Expect a specification exception when using an uneven register */
> diff --git a/s390x/emulator.c b/s390x/emulator.c
> index bce7b79..1ee0df5 100644
> --- a/s390x/emulator.c
> +++ b/s390x/emulator.c
> @@ -28,10 +28,10 @@ static inline void __test_spm_ipm(uint8_t cc, uint8_t key)
>  		      "ipm %0\n"
>  		      : "+r"(out) : "r"(in) : "cc");
>  
> -	report("bit 32 and 33 set to zero", !(out & 0xc0000000UL));
> -	report("bit 0-31, 40-63 unchanged",
> -		(out & ~0xff000000ULL) == ~0xff000000ULL);
> -	report("cc and key applied", !((in ^ out) & 0x3f000000UL));
> +	report(!(out & 0xc0000000UL), "bit 32 and 33 set to zero");
> +	report((out & ~0xff000000ULL) == ~0xff000000ULL,
> +	       "bit 0-31, 40-63 unchanged");
> +	report(!((in ^ out) & 0x3f000000UL), "cc and key applied");
>  
>  	report_prefix_pop();
>  }
> @@ -165,7 +165,7 @@ static inline void __test_basic_cpacf_opcode(unsigned int opcode)
>  		report_skip("not available");
>  		return;
>  	}
> -	report("query indicated in query", cpacf_query_func(opcode, 0));
> +	report(cpacf_query_func(opcode, 0), "query indicated in query");
>  
>  	switch (opcode) {
>  	case CPACF_KMCTR:
> @@ -272,8 +272,8 @@ static void test_dxc(void)
>  		     : : "r"(0) : "memory");
>  	check_pgm_int_code(PGM_INT_CODE_DATA);
>  
> -	report("dxc in LC", lc->dxc_vxc == 0xff);
> -	report("dxc in FPC", get_fpc_dxc() == 0xff);
> +	report(lc->dxc_vxc == 0xff, "dxc in LC");
> +	report(get_fpc_dxc() == 0xff, "dxc in FPC");
>  	report_prefix_pop();
>  
>  	/* DXC (0xff) is to be stored in LC only on a trap (CRT) without AFP */
> @@ -289,8 +289,8 @@ static void test_dxc(void)
>  	afp_enable();
>  	check_pgm_int_code(PGM_INT_CODE_DATA);
>  
> -	report("dxc in LC", lc->dxc_vxc == 0xff);
> -	report("dxc not in FPC", get_fpc_dxc() == 0);
> +	report(lc->dxc_vxc == 0xff, "dxc in LC");
> +	report(get_fpc_dxc() == 0, "dxc not in FPC");
>  	report_prefix_pop();
>  }
>  
> diff --git a/s390x/gs.c b/s390x/gs.c
> index 26f22e8..f685aa9 100644
> --- a/s390x/gs.c
> +++ b/s390x/gs.c
> @@ -121,7 +121,7 @@ static void test_load(void)
>  
>  	guarded = 0;
>  	v = load_guarded(&gs_area);
> -	report("load guarded %ld", guarded, v);
> +	report(guarded, "load guarded %ld", v);
>  	guarded = 0;
>  }
>  
> diff --git a/s390x/intercept.c b/s390x/intercept.c
> index 404b4c6..3696e33 100644
> --- a/s390x/intercept.c
> +++ b/s390x/intercept.c
> @@ -33,7 +33,7 @@ static void test_stpx(void)
>  		" spx	%0\n"
>  		: "+Q"(old_prefix), "+Q"(tst_prefix)
>  		: "Q"(new_prefix));
> -	report("store prefix", old_prefix == 0 && tst_prefix == new_prefix);
> +	report(old_prefix == 0 && tst_prefix == new_prefix, "store prefix");
>  
>  	expect_pgm_int();
>  	low_prot_enable();
> @@ -71,7 +71,7 @@ static void test_spx(void)
>  		: "+Q"(old_prefix)
>  		: "Q"(new_prefix)
>  		: "memory");
> -	report("stfl to new prefix", pagebuf[GEN_LC_STFL] != 0);
> +	report(pagebuf[GEN_LC_STFL] != 0, "stfl to new prefix");
>  
>  	expect_pgm_int();
>  	asm volatile(" spx 0(%0) " : : "r"(1));
> @@ -88,7 +88,7 @@ static void test_stap(void)
>  	uint16_t cpuid = 0xffff;
>  
>  	asm volatile ("stap %0\n" : "+Q"(cpuid));
> -	report("get cpu address", cpuid != 0xffff);
> +	report(cpuid != 0xffff, "get cpu address");
>  
>  	expect_pgm_int();
>  	low_prot_enable();
> @@ -111,9 +111,9 @@ static void test_stidp(void)
>  	struct cpuid id = {};
>  
>  	asm volatile ("stidp %0\n" : "+Q"(id));
> -	report("type set", id.type);
> -	report("version valid", !id.version || id.version == 0xff);
> -	report("reserved bits not set", !id.reserved);
> +	report(id.type, "type set");
> +	report(!id.version || id.version == 0xff, "version valid");
> +	report(!id.reserved, "reserved bits not set");
>  
>  	expect_pgm_int();
>  	low_prot_enable();
> @@ -145,8 +145,8 @@ static void test_testblock(void)
>  		: "=d" (cc)
>  		: "a"(pagebuf + 0x123)
>  		: "memory", "0", "cc");
> -	report("page cleared",
> -	       cc == 0 && pagebuf[0] == 0 &&  pagebuf[PAGE_SIZE - 1] == 0);
> +	report(cc == 0 && pagebuf[0] == 0 && pagebuf[PAGE_SIZE - 1] == 0,
> +	       "page cleared");
>  
>  	expect_pgm_int();
>  	low_prot_enable();
> diff --git a/s390x/pfmf.c b/s390x/pfmf.c
> index e81f7c5..ac57fe4 100644
> --- a/s390x/pfmf.c
> +++ b/s390x/pfmf.c
> @@ -45,7 +45,7 @@ static void test_4k_key(void)
>  	pfmf(r1.val, pagebuf);
>  	skey.val = get_storage_key(pagebuf);
>  	skey.val &= SKEY_ACC | SKEY_FP;
> -	report("set storage keys", skey.val == 0x30);
> +	report(skey.val == 0x30, "set storage keys");
>  out:
>  	report_prefix_pop();
>  }
> @@ -75,7 +75,7 @@ static void test_1m_key(void)
>  			break;
>  		}
>  	}
> -	report("set storage keys", rp);
> +	report(rp, "set storage keys");
>  out:
>  	report_prefix_pop();
>  }
> @@ -91,7 +91,8 @@ static void test_4k_clear(void)
>  	report_prefix_push("4K");
>  	memset(pagebuf, 42, PAGE_SIZE);
>  	pfmf(r1.val, pagebuf);
> -	report("clear memory", !memcmp(pagebuf, pagebuf + PAGE_SIZE, PAGE_SIZE));
> +	report(!memcmp(pagebuf, pagebuf + PAGE_SIZE, PAGE_SIZE),
> +	       "clear memory");
>  	report_prefix_pop();
>  }
>  
> @@ -110,7 +111,7 @@ static void test_1m_clear(void)
>  	pfmf(r1.val, pagebuf);
>  	for (i = 0; i < PAGE_SIZE * 256; i++)
>  		sum |= pagebuf[i];
> -	report("clear memory", !sum);
> +	report(!sum, "clear memory");
>  	report_prefix_pop();
>  }
>  
> diff --git a/s390x/selftest.c b/s390x/selftest.c
> index f4acdc4..4c16646 100644
> --- a/s390x/selftest.c
> +++ b/s390x/selftest.c
> @@ -26,7 +26,7 @@ static void test_fp(void)
>  		"	std %1, %0\n"
>  		: "=m" (c) : "f" (a), "m" (b));
>  
> -	report("3.0/2.0 == 1.5", c == 1.5);
> +	report(c == 1.5, "3.0/2.0 == 1.5");
>  }
>  
>  static void test_pgm_int(void)
> @@ -49,11 +49,12 @@ static void test_malloc(void)
>  	*tmp2 = 123456789;
>  	mb();
>  
> -	report("malloc: got vaddr", (uintptr_t)tmp & 0xf000000000000000ul);
> -	report("malloc: access works", *tmp == 123456789);
> -	report("malloc: got 2nd vaddr", (uintptr_t)tmp2 & 0xf000000000000000ul);
> -	report("malloc: access works", (*tmp2 == 123456789));
> -	report("malloc: addresses differ", tmp != tmp2);
> +	report((uintptr_t)tmp & 0xf000000000000000ul, "malloc: got vaddr");
> +	report(*tmp == 123456789, "malloc: access works");
> +	report((uintptr_t)tmp2 & 0xf000000000000000ul,
> +	       "malloc: got 2nd vaddr");
> +	report((*tmp2 == 123456789), "malloc: access works");
> +	report(tmp != tmp2, "malloc: addresses differ");
>  
>  	expect_pgm_int();
>  	configure_dat(0);
> @@ -69,11 +70,11 @@ int main(int argc, char**argv)
>  {
>  	report_prefix_push("selftest");
>  
> -	report("true", true);
> -	report("argc == 3", argc == 3);
> -	report("argv[0] == PROGNAME", !strcmp(argv[0], "s390x/selftest.elf"));
> -	report("argv[1] == test", !strcmp(argv[1], "test"));
> -	report("argv[2] == 123", !strcmp(argv[2], "123"));
> +	report(true, "true");
> +	report(argc == 3, "argc == 3");
> +	report(!strcmp(argv[0], "s390x/selftest.elf"), "argv[0] == PROGNAME");
> +	report(!strcmp(argv[1], "test"), "argv[1] == test");
> +	report(!strcmp(argv[2], "123"), "argv[2] == 123");
>  
>  	setup_vm();
>  
> diff --git a/s390x/skey.c b/s390x/skey.c
> index 5020e99..86d15e2 100644
> --- a/s390x/skey.c
> +++ b/s390x/skey.c
> @@ -35,8 +35,7 @@ static void test_set_mb(void)
>  
>  	ret1.val = get_storage_key(end - PAGE_SIZE) & (SKEY_ACC | SKEY_FP);
>  	ret2.val = get_storage_key(end - PAGE_SIZE * 2) & (SKEY_ACC | SKEY_FP);
> -	report("multi block",
> -	       ret1.val == ret2.val && ret1.val == skey.val);
> +	report(ret1.val == ret2.val && ret1.val == skey.val, "multi block");
>  }
>  
>  static void test_chg(void)
> @@ -48,7 +47,7 @@ static void test_chg(void)
>  	skey1.val = get_storage_key(pagebuf);
>  	pagebuf[0] = 3;
>  	skey2.val = get_storage_key(pagebuf);
> -	report("chg bit test", !skey1.str.ch && skey2.str.ch);
> +	report(!skey1.str.ch && skey2.str.ch, "chg bit test");
>  }
>  
>  static void test_set(void)
> @@ -64,8 +63,8 @@ static void test_set(void)
>  	 * CH are set by the machine for memory references and changes
>  	 * and hence might change between a set and a get.
>  	 */
> -	report("set key test",
> -	       skey.str.acc == ret.str.acc && skey.str.fp == ret.str.fp);
> +	report(skey.str.acc == ret.str.acc && skey.str.fp == ret.str.fp,
> +	       "set key test");
>  }
>  
>  /* Returns true if we are running under z/VM 6.x */
> @@ -106,7 +105,7 @@ static void test_priv(void)
>  	report_prefix_pop();
>  
>  	skey.val = get_storage_key(pagebuf);
> -	report("skey did not change on exception", skey.str.acc != 3);
> +	report(skey.str.acc != 3, "skey did not change on exception");
>  
>  	report_prefix_push("iske");
>  	if (is_zvm6) {
> diff --git a/s390x/skrf.c b/s390x/skrf.c
> index e77ff35..9cae589 100644
> --- a/s390x/skrf.c
> +++ b/s390x/skrf.c
> @@ -21,11 +21,11 @@ static uint8_t pagebuf[PAGE_SIZE * 2] __attribute__((aligned(PAGE_SIZE * 2)));
>  static void test_facilities(void)
>  {
>  	report_prefix_push("facilities");
> -	report("!10", !test_facility(10));
> -	report("!14", !test_facility(14));
> -	report("!66", !test_facility(66));
> -	report("!145", !test_facility(145));
> -	report("!149", !test_facility(140));
> +	report(!test_facility(10), "!10");
> +	report(!test_facility(14), "!14");
> +	report(!test_facility(66), "!66");
> +	report(!test_facility(145), "!145");
> +	report(!test_facility(140), "!149");
>  	report_prefix_pop();
>  }
>  
> diff --git a/s390x/smp.c b/s390x/smp.c
> index 8782cfc..ab7e46c 100644
> --- a/s390x/smp.c
> +++ b/s390x/smp.c
> @@ -44,7 +44,7 @@ static void test_start(void)
>  	while (!testflag) {
>  		mb();
>  	}
> -	report("start", 1);
> +	report(1, "start");
>  }
>  
>  static void test_stop(void)
> @@ -56,7 +56,7 @@ static void test_stop(void)
>  	 * implementation
>  	 */
>  	while (!smp_cpu_stopped(1)) {}
> -	report("stop", 1);
> +	report(1, "stop");
>  }
>  
>  static void test_stop_store_status(void)
> @@ -69,8 +69,8 @@ static void test_stop_store_status(void)
>  	lc->grs_sa[15] = 0;
>  	smp_cpu_stop_store_status(1);
>  	mb();
> -	report("prefix", lc->prefix_sa == (uint32_t)(uintptr_t)cpu->lowcore);
> -	report("stack", lc->grs_sa[15]);
> +	report(lc->prefix_sa == (uint32_t)(uintptr_t)cpu->lowcore, "prefix");
> +	report(lc->grs_sa[15], "stack");
>  	report_prefix_pop();
>  }
>  
> @@ -85,8 +85,9 @@ static void test_store_status(void)
>  	report_prefix_push("running");
>  	smp_cpu_restart(1);
>  	sigp(1, SIGP_STORE_STATUS_AT_ADDRESS, (uintptr_t)status, &r);
> -	report("incorrect state", r == SIGP_STATUS_INCORRECT_STATE);
> -	report("status not written", !memcmp(status, (void*)status + PAGE_SIZE, PAGE_SIZE));
> +	report(r == SIGP_STATUS_INCORRECT_STATE, "incorrect state");
> +	report(!memcmp(status, (void *)status + PAGE_SIZE, PAGE_SIZE),
> +	       "status not written");
>  	report_prefix_pop();
>  
>  	memset(status, 0, PAGE_SIZE);
> @@ -94,7 +95,7 @@ static void test_store_status(void)
>  	smp_cpu_stop(1);
>  	sigp(1, SIGP_STORE_STATUS_AT_ADDRESS, (uintptr_t)status, NULL);
>  	while (!status->prefix) { mb(); }
> -	report("status written", 1);
> +	report(1, "status written");
>  	free_pages(status, PAGE_SIZE * 2);
>  	report_prefix_pop();
>  
> @@ -113,7 +114,7 @@ static void ecall(void)
>  	load_psw_mask(mask);
>  	testflag = 1;
>  	while (lc->ext_int_code != 0x1202) { mb(); }
> -	report("ecall", 1);
> +	report(1, "ecall");
>  	testflag= 1;
>  }
>  
> @@ -148,7 +149,7 @@ static void emcall(void)
>  	load_psw_mask(mask);
>  	testflag= 1;
>  	while (lc->ext_int_code != 0x1201) { mb(); }
> -	report("ecall", 1);
> +	report(1, "ecall");
>  	testflag = 1;
>  }
>  
> @@ -186,19 +187,19 @@ static void test_reset_initial(void)
>  	sigp(1, SIGP_STORE_STATUS_AT_ADDRESS, (uintptr_t)status, NULL);
>  
>  	report_prefix_push("clear");
> -	report("psw", !status->psw.mask && !status->psw.addr);
> -	report("prefix", !status->prefix);
> -	report("fpc", !status->fpc);
> -	report("cpu timer", !status->cputm);
> -	report("todpr", !status->todpr);
> +	report(!status->psw.mask && !status->psw.addr, "psw");
> +	report(!status->prefix, "prefix");
> +	report(!status->fpc, "fpc");
> +	report(!status->cputm, "cpu timer");
> +	report(!status->todpr, "todpr");
>  	report_prefix_pop();
>  
>  	report_prefix_push("initialized");
> -	report("cr0 == 0xE0", status->crs[0] == 0xE0UL);
> -	report("cr14 == 0xC2000000", status->crs[14] == 0xC2000000UL);
> +	report(status->crs[0] == 0xE0UL, "cr0 == 0xE0");
> +	report(status->crs[14] == 0xC2000000UL, "cr14 == 0xC2000000");
>  	report_prefix_pop();
>  
> -	report("cpu stopped", smp_cpu_stopped(1));
> +	report(smp_cpu_stopped(1), "cpu stopped");
>  	free_pages(status, PAGE_SIZE);
>  	report_prefix_pop();
>  }
> @@ -214,7 +215,7 @@ static void test_reset(void)
>  	smp_cpu_setup(1, psw);
>  
>  	sigp_retry(1, SIGP_CPU_RESET, 0, NULL);
> -	report("cpu stopped", smp_cpu_stopped(1));
> +	report(smp_cpu_stopped(1), "cpu stopped");
>  	report_prefix_pop();
>  }
>  
> diff --git a/s390x/sthyi.c b/s390x/sthyi.c
> index 04a7b4f..68c57cb 100644
> --- a/s390x/sthyi.c
> +++ b/s390x/sthyi.c
> @@ -78,21 +78,21 @@ static void test_function_code(uint64_t addr)
>  	uint64_t urc = 0;
>  	int cc = sthyi((uint64_t)pagebuf, 42, &urc, 0, 2);
>  
> -	report("Illegal fcode", cc == 3 && urc == CODE_UNSUPP);
> +	report(cc == 3 && urc == CODE_UNSUPP, "Illegal fcode");
>  }
>  
>  static void test_fcode0_hdr(struct sthyi_hdr_sctn *hdr)
>  {
>  	report_prefix_push("Header");
>  
> -	report("length", hdr->INFHDLN >= sizeof(*hdr) && !(hdr->INFHDLN % 8));
> -	report("Machine sctn length", (hdr->INFMLEN >= sizeof(struct sthyi_mach_sctn)
> -				       && !(hdr->INFMLEN % 8)));
> -	report("Partition section length", (hdr->INFPLEN >= sizeof(struct sthyi_par_sctn)
> -					    && !(hdr->INFPLEN % 8)));
> +	report(hdr->INFHDLN >= sizeof(*hdr) && !(hdr->INFHDLN % 8), "length");
> +	report((hdr->INFMLEN >= sizeof(struct sthyi_mach_sctn) && !(hdr->INFMLEN % 8)),
> +	       "Machine sctn length");
> +	report((hdr->INFPLEN >= sizeof(struct sthyi_par_sctn) && !(hdr->INFPLEN % 8)),
> +	       "Partition section length");
>  
> -	report("Machine offset", hdr->INFMOFF >= hdr->INFHDLN);
> -	report("Partition offset", hdr->INFPOFF >= hdr->INFHDLN);
> +	report(hdr->INFMOFF >= hdr->INFHDLN, "Machine offset");
> +	report(hdr->INFPOFF >= hdr->INFHDLN, "Partition offset");
>  	report_prefix_pop();
>  }
>  
> @@ -102,18 +102,22 @@ static void test_fcode0_mach(struct sthyi_mach_sctn *mach)
>  
>  	report_prefix_push("Machine");
>  	if (mach->INFMVAL1 & MACH_ID_VLD) {
> -		report("type", memcmp(mach->INFMTYPE, null_buf, sizeof(mach->INFMTYPE)));
> -		report("manufacturer", memcmp(mach->INFMMANU, null_buf, sizeof(mach->INFMMANU)));
> -		report("sequence", memcmp(mach->INFMSEQ, null_buf, sizeof(mach->INFMSEQ)));
> -		report("plant", memcmp(mach->INFMPMAN, null_buf, sizeof(mach->INFMPMAN)));
> +		report(memcmp(mach->INFMTYPE, null_buf, sizeof(mach->INFMTYPE)),
> +		       "type");
> +		report(memcmp(mach->INFMMANU, null_buf, sizeof(mach->INFMMANU)),
> +		       "manufacturer");
> +		report(memcmp(mach->INFMSEQ, null_buf, sizeof(mach->INFMSEQ)),
> +		       "sequence");
> +		report(memcmp(mach->INFMPMAN, null_buf, sizeof(mach->INFMPMAN)),
> +		       "plant");
>  	}
>  
>  	if (mach->INFMVAL1 & MACH_NAME_VLD)
> -		report("name", memcmp(mach->INFMNAME, null_buf,
> -				      sizeof(mach->INFMNAME)));
> +		report(memcmp(mach->INFMNAME, null_buf, sizeof(mach->INFMNAME)),
> +		       "name");
>  
>  	if (mach->INFMVAL1 & MACH_CNT_VLD)
> -		report("core counts", sum);
> +		report(sum, "core counts");
>  	report_prefix_pop();
>  }
>  
> @@ -123,11 +127,12 @@ static void test_fcode0_par(struct sthyi_par_sctn *par)
>  
>  	report_prefix_push("Partition");
>  	if (par->INFPVAL1 & PART_CNT_VLD)
> -		report("core counts", sum);
> +		report(sum, "core counts");
>  
>  	if (par->INFPVAL1 & PART_STSI_SUC) {
> -		report("number", par->INFPPNUM);
> -		report("name", memcmp(par->INFPPNAM, null_buf, sizeof(par->INFPPNAM)));
> +		report(par->INFPPNUM, "number");
> +		report(memcmp(par->INFPPNAM, null_buf, sizeof(par->INFPPNAM)),
> +		       "name");
>  	}
>  	report_prefix_pop();
>  }
> diff --git a/s390x/stsi.c b/s390x/stsi.c
> index c5bd0a2..e9206bc 100644
> --- a/s390x/stsi.c
> +++ b/s390x/stsi.c
> @@ -70,10 +70,10 @@ static inline unsigned long stsi_get_fc(void *addr)
>  
>  static void test_fc(void)
>  {
> -	report("invalid fc",  stsi(pagebuf, 7, 0, 0) == 3);
> -	report("invalid selector 1", stsi(pagebuf, 1, 0, 1) == 3);
> -	report("invalid selector 2", stsi(pagebuf, 1, 1, 0) == 3);
> -	report("query fc >= 2",  stsi_get_fc(pagebuf) >= 2);
> +	report(stsi(pagebuf, 7, 0, 0) == 3, "invalid fc");
> +	report(stsi(pagebuf, 1, 0, 1) == 3, "invalid selector 1");
> +	report(stsi(pagebuf, 1, 1, 0) == 3, "invalid selector 2");
> +	report(stsi_get_fc(pagebuf) >= 2, "query fc >= 2");
>  }
>  
>  int main(void)
> diff --git a/s390x/vector.c b/s390x/vector.c
> index d40f647..0159ba1 100644
> --- a/s390x/vector.c
> +++ b/s390x/vector.c
> @@ -49,7 +49,7 @@ static void test_add(void)
>  		     : [v3]  "=Q" (prm.c)
>  		     : [v1]  "Q" (prm.a), [v2]  "Q" (prm.b)
>  		     : "v0", "v1", "v2", "memory");
> -	report("adding 21", prm.c == 42);
> +	report(prm.c == 42, "adding 21");
>  }
>  
>  /* z14 vector extension test */
> @@ -75,7 +75,7 @@ static void test_ext1_nand(void)
>  		     : [v3]  "=Q" (prm.c)
>  		     : [v1]  "Q" (prm.a), [v2]  "Q" (prm.b)
>  		     : "v0", "v1", "v2", "memory");
> -	report("nand ff", !prm.c);
> +	report(!prm.c, "nand ff");
>  }
>  
>  /* z14 bcd extension test */
> @@ -102,7 +102,7 @@ static void test_bcd_add(void)
>  		     : [v3]  "=Q" (prm.c)
>  		     : [v1]  "Q" (prm.a), [v2]  "Q" (prm.b)
>  		     : "v0", "v1", "v2", "memory");
> -	report("bcd add 21", prm.c == 0x42c);
> +	report(prm.c == 0x42c, "bcd add 21");
>  }
>  
>  static void init(void)
> diff --git a/x86/apic.c b/x86/apic.c
> index eb785c4..2aacad6 100644
> --- a/x86/apic.c
> +++ b/x86/apic.c
> @@ -16,7 +16,7 @@ static void test_lapic_existence(void)
>  
>      version = (u8)apic_read(APIC_LVR);
>      printf("apic version: %x\n", version);
> -    report("apic existence", version >= 0x10 && version <= 0x15);
> +    report(version >= 0x10 && version <= 0x15, "apic existence");
>  }
>  
>  #define TSC_DEADLINE_TIMER_VECTOR 0xef
> @@ -37,8 +37,8 @@ static void __test_tsc_deadline_timer(void)
>  
>      wrmsr(MSR_IA32_TSCDEADLINE, rdmsr(MSR_IA32_TSC));
>      asm volatile ("nop");
> -    report("tsc deadline timer", tdt_count == 1);
> -    report("tsc deadline timer clearing", rdmsr(MSR_IA32_TSCDEADLINE) == 0);
> +    report(tdt_count == 1, "tsc deadline timer");
> +    report(rdmsr(MSR_IA32_TSCDEADLINE) == 0, "tsc deadline timer clearing");
>  }
>  
>  static int enable_tsc_deadline_timer(void)
> @@ -82,22 +82,22 @@ static void test_enable_x2apic(void)
>          printf("x2apic enabled\n");
>  
>          apicbase = orig_apicbase & ~(APIC_EN | APIC_EXTD);
> -        report("x2apic enabled to invalid state",
> -               test_write_apicbase_exception(apicbase | APIC_EXTD));
> -        report("x2apic enabled to apic enabled",
> -               test_write_apicbase_exception(apicbase | APIC_EN));
> -
> -        report("x2apic enabled to disabled state",
> -               !test_write_apicbase_exception(apicbase | 0));
> -        report("disabled to invalid state",
> -               test_write_apicbase_exception(apicbase | APIC_EXTD));
> -        report("disabled to x2apic enabled",
> -               test_write_apicbase_exception(apicbase | APIC_EN | APIC_EXTD));
> -
> -        report("apic disabled to apic enabled",
> -               !test_write_apicbase_exception(apicbase | APIC_EN));
> -        report("apic enabled to invalid state",
> -               test_write_apicbase_exception(apicbase | APIC_EXTD));
> +        report(test_write_apicbase_exception(apicbase | APIC_EXTD),
> +               "x2apic enabled to invalid state");
> +        report(test_write_apicbase_exception(apicbase | APIC_EN),
> +               "x2apic enabled to apic enabled");
> +
> +        report(!test_write_apicbase_exception(apicbase | 0),
> +               "x2apic enabled to disabled state");
> +        report(test_write_apicbase_exception(apicbase | APIC_EXTD),
> +               "disabled to invalid state");
> +        report(test_write_apicbase_exception(apicbase | APIC_EN | APIC_EXTD),
> +               "disabled to x2apic enabled");
> +
> +        report(!test_write_apicbase_exception(apicbase | APIC_EN),
> +               "apic disabled to apic enabled");
> +        report(test_write_apicbase_exception(apicbase | APIC_EXTD),
> +               "apic enabled to invalid state");
>  
>          if (orig_apicbase & APIC_EXTD)
>              enable_x2apic();
> @@ -112,8 +112,8 @@ static void test_enable_x2apic(void)
>      } else {
>          printf("x2apic not detected\n");
>  
> -        report("enable unsupported x2apic",
> -               test_write_apicbase_exception(APIC_EN | APIC_EXTD));
> +        report(test_write_apicbase_exception(APIC_EN | APIC_EXTD),
> +               "enable unsupported x2apic");
>      }
>  }
>  
> @@ -124,11 +124,11 @@ static void verify_disabled_apic_mmio(void)
>      u32 cr8 = read_cr8();
>  
>      memset((void *)APIC_DEFAULT_PHYS_BASE, 0xff, PAGE_SIZE);
> -    report("*0xfee00030: %x", *lvr == ~0, *lvr);
> -    report("CR8: %lx", read_cr8() == cr8, read_cr8());
> +    report(*lvr == ~0, "*0xfee00030: %x", *lvr);
> +    report(read_cr8() == cr8, "CR8: %lx", read_cr8());
>      write_cr8(cr8 ^ MAX_TPR);
> -    report("CR8: %lx", read_cr8() == (cr8 ^ MAX_TPR), read_cr8());
> -    report("*0xfee00080: %x", *tpr == ~0, *tpr);
> +    report(read_cr8() == (cr8 ^ MAX_TPR), "CR8: %lx", read_cr8());
> +    report(*tpr == ~0, "*0xfee00080: %x", *tpr);
>      write_cr8(cr8);
>  }
>  
> @@ -144,26 +144,27 @@ static void test_apic_disable(void)
>      assert_msg(orig_apicbase & APIC_EN, "APIC not enabled.");
>  
>      disable_apic();
> -    report("Local apic disabled", !(rdmsr(MSR_IA32_APICBASE) & APIC_EN));
> -    report("CPUID.1H:EDX.APIC[bit 9] is clear", !this_cpu_has(X86_FEATURE_APIC));
> +    report(!(rdmsr(MSR_IA32_APICBASE) & APIC_EN), "Local apic disabled");
> +    report(!this_cpu_has(X86_FEATURE_APIC),
> +           "CPUID.1H:EDX.APIC[bit 9] is clear");
>      verify_disabled_apic_mmio();
>  
>      reset_apic();
> -    report("Local apic enabled in xAPIC mode",
> -	   (rdmsr(MSR_IA32_APICBASE) & (APIC_EN | APIC_EXTD)) == APIC_EN);
> -    report("CPUID.1H:EDX.APIC[bit 9] is set", this_cpu_has(X86_FEATURE_APIC));
> -    report("*0xfee00030: %x", *lvr == apic_version, *lvr);
> -    report("*0xfee00080: %x", *tpr == cr8, *tpr);
> +    report((rdmsr(MSR_IA32_APICBASE) & (APIC_EN | APIC_EXTD)) == APIC_EN,
> +           "Local apic enabled in xAPIC mode");
> +    report(this_cpu_has(X86_FEATURE_APIC), "CPUID.1H:EDX.APIC[bit 9] is set");
> +    report(*lvr == apic_version, "*0xfee00030: %x", *lvr);
> +    report(*tpr == cr8, "*0xfee00080: %x", *tpr);
>      write_cr8(cr8 ^ MAX_TPR);
> -    report("*0xfee00080: %x", *tpr == (cr8 ^ MAX_TPR) << 4, *tpr);
> +    report(*tpr == (cr8 ^ MAX_TPR) << 4, "*0xfee00080: %x", *tpr);
>      write_cr8(cr8);
>  
>      if (enable_x2apic()) {
>  	apic_write(APIC_SPIV, 0x1ff);
> -	report("Local apic enabled in x2APIC mode",
> -	   (rdmsr(MSR_IA32_APICBASE) & (APIC_EN | APIC_EXTD)) ==
> -	   (APIC_EN | APIC_EXTD));
> -	report("CPUID.1H:EDX.APIC[bit 9] is set", this_cpu_has(X86_FEATURE_APIC));
> +	report((rdmsr(MSR_IA32_APICBASE) & (APIC_EN | APIC_EXTD)) == (APIC_EN | APIC_EXTD),
> +               "Local apic enabled in x2APIC mode");
> +	report(this_cpu_has(X86_FEATURE_APIC),
> +               "CPUID.1H:EDX.APIC[bit 9] is set");
>  	verify_disabled_apic_mmio();
>  	if (!(orig_apicbase & APIC_EXTD))
>  	    reset_apic();
> @@ -184,16 +185,16 @@ static void test_apicbase(void)
>  
>      report_prefix_push("apicbase");
>  
> -    report("relocate apic",
> -           *(volatile u32 *)(ALTERNATE_APIC_BASE + APIC_LVR) == lvr);
> +    report(*(volatile u32 *)(ALTERNATE_APIC_BASE + APIC_LVR) == lvr,
> +           "relocate apic");
>  
>      value = orig_apicbase | (1UL << cpuid_maxphyaddr());
> -    report("reserved physaddr bits",
> -           test_for_exception(GP_VECTOR, do_write_apicbase, &value));
> +    report(test_for_exception(GP_VECTOR, do_write_apicbase, &value),
> +           "reserved physaddr bits");
>  
>      value = orig_apicbase | 1;
> -    report("reserved low bits",
> -           test_for_exception(GP_VECTOR, do_write_apicbase, &value));
> +    report(test_for_exception(GP_VECTOR, do_write_apicbase, &value),
> +           "reserved low bits");
>  
>      wrmsr(MSR_IA32_APICBASE, orig_apicbase);
>      apic_write(APIC_SPIV, 0x1ff);
> @@ -217,29 +218,29 @@ static void __test_apic_id(void * unused)
>          reset_apic();
>  
>      id = apic_id();
> -    report("xapic id matches cpuid", initial_xapic_id == id);
> +    report(initial_xapic_id == id, "xapic id matches cpuid");
>  
>      newid = (id + 1) << 24;
> -    report("writeable xapic id",
> -            !test_for_exception(GP_VECTOR, do_write_apic_id, &newid) &&
> -	    (id == apic_id() || id + 1 == apic_id()));
> +    report(!test_for_exception(GP_VECTOR, do_write_apic_id, &newid) &&
> +           (id == apic_id() || id + 1 == apic_id()),
> +           "writeable xapic id");
>  
>      if (!enable_x2apic())
>          goto out;
>  
> -    report("non-writeable x2apic id",
> -            test_for_exception(GP_VECTOR, do_write_apic_id, &newid));
> -    report("sane x2apic id", initial_xapic_id == (apic_id() & 0xff));
> +    report(test_for_exception(GP_VECTOR, do_write_apic_id, &newid),
> +           "non-writeable x2apic id");
> +    report(initial_xapic_id == (apic_id() & 0xff), "sane x2apic id");
>  
>      /* old QEMUs do not set initial x2APIC ID */
> -    report("x2apic id matches cpuid",
> -           initial_xapic_id == (initial_x2apic_id & 0xff) &&
> -           initial_x2apic_id == apic_id());
> +    report(initial_xapic_id == (initial_x2apic_id & 0xff) && 
> +           initial_x2apic_id == apic_id(),
> +           "x2apic id matches cpuid");
>  
>  out:
>      reset_apic();
>  
> -    report("correct xapic id after reset", initial_xapic_id == apic_id());
> +    report(initial_xapic_id == apic_id(), "correct xapic id after reset");
>  
>      /* old KVMs do not reset xAPIC ID */
>      if (id != apic_id())
> @@ -279,7 +280,7 @@ static void test_self_ipi(void)
>          pause();
>      } while (rdtsc() - start < 1000000000 && ipi_count == 0);
>  
> -    report("self ipi", ipi_count == 1);
> +    report(ipi_count == 1, "self ipi");
>  }
>  
>  volatile int nmi_counter_private, nmi_counter, nmi_hlt_counter, sti_loop_active;
> @@ -343,7 +344,7 @@ static void test_sti_nmi(void)
>  	}
>      }
>      sti_loop_active = 0;
> -    report("nmi-after-sti", nmi_hlt_counter == 0);
> +    report(nmi_hlt_counter == 0, "nmi-after-sti");
>  }
>  
>  static volatile bool nmi_done, nmi_flushed;
> @@ -417,7 +418,7 @@ static void test_multiple_nmi(void)
>  	}
>      }
>      nmi_done = true;
> -    report("multiple nmi", ok);
> +    report(ok, "multiple nmi");
>  }
>  
>  static void pending_nmi_handler(isr_regs_t *regs)
> @@ -445,7 +446,7 @@ static void test_pending_nmi(void)
>          if (nmi_received != 2)
>              break;
>      }
> -    report("pending nmi", nmi_received == 2);
> +    report(nmi_received == 2, "pending nmi");
>  }
>  
>  static volatile int lvtt_counter = 0;
> @@ -485,8 +486,8 @@ static void test_apic_timer_one_shot(void)
>       * cases, the following should satisfy on all modern
>       * processors.
>       */
> -    report("APIC LVT timer one shot", (lvtt_counter == 1) &&
> -           (tsc2 - tsc1 >= interval));
> +    report((lvtt_counter == 1) && (tsc2 - tsc1 >= interval),
> +           "APIC LVT timer one shot");
>  }
>  
>  static atomic_t broadcast_counter;
> @@ -527,11 +528,11 @@ static void test_physical_broadcast(void)
>  	printf("starting broadcast (%s)\n", enable_x2apic() ? "x2apic" : "xapic");
>  	apic_icr_write(APIC_DEST_PHYSICAL | APIC_DM_FIXED | APIC_INT_ASSERT |
>  			BROADCAST_VECTOR, broadcast_address);
> -	report("APIC physical broadcast address", broadcast_received(ncpus));
> +	report(broadcast_received(ncpus), "APIC physical broadcast address");
>  
>  	apic_icr_write(APIC_DEST_PHYSICAL | APIC_DM_FIXED | APIC_INT_ASSERT |
>  			BROADCAST_VECTOR | APIC_DEST_ALLINC, 0);
> -	report("APIC physical broadcast shorthand", broadcast_received(ncpus));
> +	report(broadcast_received(ncpus), "APIC physical broadcast shorthand");
>  }
>  
>  static void wait_until_tmcct_common(uint32_t initial_count, bool stop_when_half, bool should_wrap_around)
> @@ -583,15 +584,15 @@ static void test_apic_change_mode(void)
>  
>  	apic_change_mode(APIC_LVT_TIMER_PERIODIC);
>  
> -	report("TMICT value reset", apic_read(APIC_TMICT) == tmict);
> +	report(apic_read(APIC_TMICT) == tmict, "TMICT value reset");
>  
>  	/* Testing one-shot */
>  	apic_change_mode(APIC_LVT_TIMER_ONESHOT);
>  	apic_write(APIC_TMICT, tmict);
> -	report("TMCCT should have a non-zero value", apic_read(APIC_TMCCT));
> +	report(apic_read(APIC_TMCCT), "TMCCT should have a non-zero value");
>  
>  	wait_until_tmcct_is_zero(tmict, false);
> -	report("TMCCT should have reached 0", !apic_read(APIC_TMCCT));
> +	report(!apic_read(APIC_TMCCT), "TMCCT should have reached 0");
>  
>  	/*
>  	 * Write TMICT before changing mode from one-shot to periodic TMCCT should
> @@ -600,20 +601,22 @@ static void test_apic_change_mode(void)
>  	apic_write(APIC_TMICT, tmict);
>  	wait_until_tmcct_is_zero(tmict, true);
>  	apic_change_mode(APIC_LVT_TIMER_PERIODIC);
> -	report("TMCCT should have a non-zero value", apic_read(APIC_TMCCT));
> +	report(apic_read(APIC_TMCCT), "TMCCT should have a non-zero value");
>  
>  	/*
>  	 * After the change of mode, the counter should not be reset and continue
>  	 * counting down from where it was
>  	 */
> -	report("TMCCT should not be reset to TMICT value", apic_read(APIC_TMCCT) < (tmict / 2));
> +	report(apic_read(APIC_TMCCT) < (tmict / 2),
> +	       "TMCCT should not be reset to TMICT value");
>  	/*
>  	 * Specifically wait for timer wrap around and skip 0.
>  	 * Under KVM lapic there is a possibility that a small amount of consecutive
>  	 * TMCCR reads return 0 while hrtimer is reset in an async callback
>  	 */
>  	wait_until_tmcct_wrap_around(tmict, false);
> -	report("TMCCT should be reset to the initial-count", apic_read(APIC_TMCCT) > (tmict / 2));
> +	report(apic_read(APIC_TMCCT) > (tmict / 2),
> +	       "TMCCT should be reset to the initial-count");
>  
>  	wait_until_tmcct_is_zero(tmict, true);
>  	/*
> @@ -621,13 +624,14 @@ static void test_apic_change_mode(void)
>  	 * TMCCT should be > 0 and count-down to 0
>  	 */
>  	apic_change_mode(APIC_LVT_TIMER_ONESHOT);
> -	report("TMCCT should not be reset to init", apic_read(APIC_TMCCT) < (tmict / 2));
> +	report(apic_read(APIC_TMCCT) < (tmict / 2),
> +	       "TMCCT should not be reset to init");
>  	wait_until_tmcct_is_zero(tmict, false);
> -	report("TMCCT should have reach zero", !apic_read(APIC_TMCCT));
> +	report(!apic_read(APIC_TMCCT), "TMCCT should have reach zero");
>  
>  	/* now tmcct == 0 and tmict != 0 */
>  	apic_change_mode(APIC_LVT_TIMER_PERIODIC);
> -	report("TMCCT should stay at zero", !apic_read(APIC_TMCCT));
> +	report(!apic_read(APIC_TMCCT), "TMCCT should stay at zero");
>  }
>  
>  #define KVM_HC_SEND_IPI 10
> @@ -638,7 +642,7 @@ static void test_pv_ipi(void)
>      unsigned long a0 = 0xFFFFFFFF, a1 = 0, a2 = 0xFFFFFFFF, a3 = 0x0;
>  
>      asm volatile("vmcall" : "=a"(ret) :"a"(KVM_HC_SEND_IPI), "b"(a0), "c"(a1), "d"(a2), "S"(a3));
> -    report("PV IPIs testing", !ret);
> +    report(!ret, "PV IPIs testing");
>  }
>  
>  int main(void)
> diff --git a/x86/asyncpf.c b/x86/asyncpf.c
> index de3d592..80bbe45 100644
> --- a/x86/asyncpf.c
> +++ b/x86/asyncpf.c
> @@ -55,21 +55,22 @@ static void pf_isr(struct ex_regs *r)
>  
>  	switch (reason) {
>  		case 0:
> -			report("unexpected #PF at %#lx", false, read_cr2());
> +			report(false, "unexpected #PF at %#lx", read_cr2());
>  			break;
>  		case KVM_PV_REASON_PAGE_NOT_PRESENT:
>  			phys = virt_to_pte_phys(phys_to_virt(read_cr3()), virt);
>  			install_pte(phys_to_virt(read_cr3()), 1, virt, phys, 0);
>  			write_cr3(read_cr3());
> -			report("Got not present #PF token %lx virt addr %p phys addr %#" PRIx64,
> -					true, read_cr2(), virt, phys);
> +			report(true,
> +			       "Got not present #PF token %lx virt addr %p phys addr %#" PRIx64,
> +			       read_cr2(), virt, phys);
>  			while(phys) {
>  				safe_halt(); /* enables irq */
>  				irq_disable();
>  			}
>  			break;
>  		case KVM_PV_REASON_PAGE_READY:
> -			report("Got present #PF token %lx", true, read_cr2());
> +			report(true, "Got present #PF token %lx", read_cr2());
>  			if ((uint32_t)read_cr2() == ~0)
>  				break;
>  			install_pte(phys_to_virt(read_cr3()), 1, virt, phys | PT_PRESENT_MASK | PT_WRITABLE_MASK, 0);
> @@ -77,7 +78,7 @@ static void pf_isr(struct ex_regs *r)
>  			phys = 0;
>  			break;
>  		default:
> -			report("unexpected async pf reason %d", false, reason);
> +			report(false, "unexpected async pf reason %d", reason);
>  			break;
>  	}
>  }
> diff --git a/x86/cmpxchg8b.c b/x86/cmpxchg8b.c
> index c56d295..bbba2f9 100644
> --- a/x86/cmpxchg8b.c
> +++ b/x86/cmpxchg8b.c
> @@ -14,7 +14,7 @@ static void test_cmpxchg8b(u32 *mem)
>          "lock cmpxchg8b (%0)\n"
>          "pop %%ebx" : : "D" (mem),
>          "d" (2), "a" (1), "c" (4), [ebx_val] "i" (3) : "memory");
> -    report("cmpxchg8b", mem[0] == 3 && mem[1] == 4);
> +    report(mem[0] == 3 && mem[1] == 4, "cmpxchg8b");
>  }
>  
>  int main(void)
> diff --git a/x86/debug.c b/x86/debug.c
> index 7365c25..c5db4c6 100644
> --- a/x86/debug.c
> +++ b/x86/debug.c
> @@ -81,25 +81,25 @@ int main(int ac, char **av)
>  
>  	extern unsigned char sw_bp;
>  	asm volatile("int3; sw_bp:");
> -	report("#BP", bp_addr == (unsigned long)&sw_bp);
> +	report(bp_addr == (unsigned long)&sw_bp, "#BP");
>  
>  	n = 0;
>  	extern unsigned char hw_bp1;
>  	set_dr0(&hw_bp1);
>  	set_dr7(0x00000402);
>  	asm volatile("hw_bp1: nop");
> -	report("hw breakpoint (test that dr6.BS is not set)",
> -	       n == 1 &&
> -	       db_addr[0] == ((unsigned long)&hw_bp1) && dr6[0] == 0xffff0ff1);
> +	report(n == 1 &&
> +	       db_addr[0] == ((unsigned long)&hw_bp1) && dr6[0] == 0xffff0ff1,
> +	       "hw breakpoint (test that dr6.BS is not set)");
>  
>  	n = 0;
>  	extern unsigned char hw_bp2;
>  	set_dr0(&hw_bp2);
>  	set_dr6(0x00004002);
>  	asm volatile("hw_bp2: nop");
> -	report("hw breakpoint (test that dr6.BS is not cleared)",
> -	       n == 1 &&
> -	       db_addr[0] == ((unsigned long)&hw_bp2) && dr6[0] == 0xffff4ff1);
> +	report(n == 1 &&
> +	       db_addr[0] == ((unsigned long)&hw_bp2) && dr6[0] == 0xffff4ff1,
> +	       "hw breakpoint (test that dr6.BS is not cleared)");
>  
>  	n = 0;
>  	set_dr6(0);
> @@ -114,11 +114,11 @@ int main(int ac, char **av)
>  		"push %%rax\n\t"
>  		"popf\n\t"
>  		: "=r" (start) : : "rax");
> -	report("single step",
> -	       n == 3 &&
> -	       db_addr[0] == start+1+6 && dr6[0] == 0xffff4ff0 &&
> -	       db_addr[1] == start+1+6+1 && dr6[1] == 0xffff4ff0 &&
> -	       db_addr[2] == start+1+6+1+1 && dr6[2] == 0xffff4ff0);
> +	report(n == 3 &&
> +	       db_addr[0] == start + 1 + 6 && dr6[0] == 0xffff4ff0 &&
> +	       db_addr[1] == start + 1 + 6 + 1 && dr6[1] == 0xffff4ff0 &&
> +	       db_addr[2] == start + 1 + 6 + 1 + 1 && dr6[2] == 0xffff4ff0,
> +	       "single step");
>  
>  	/*
>  	 * cpuid and rdmsr (among others) trigger VM exits and are then
> @@ -141,15 +141,15 @@ int main(int ac, char **av)
>  		"rdmsr\n\t"
>  		"popf\n\t"
>  		: "=r" (start) : : "rax", "ebx", "ecx", "edx");
> -	report("single step emulated instructions",
> -	       n == 7 &&
> -	       db_addr[0] == start+1+6 && dr6[0] == 0xffff4ff0 &&
> -	       db_addr[1] == start+1+6+1 && dr6[1] == 0xffff4ff0 &&
> -	       db_addr[2] == start+1+6+1+3 && dr6[2] == 0xffff4ff0 &&
> -	       db_addr[3] == start+1+6+1+3+2 && dr6[3] == 0xffff4ff0 &&
> -	       db_addr[4] == start+1+6+1+3+2+5 && dr6[4] == 0xffff4ff0 &&
> -	       db_addr[5] == start+1+6+1+3+2+5+2 && dr6[5] == 0xffff4ff0 &&
> -	       db_addr[6] == start+1+6+1+3+2+5+2+1 && dr6[6] == 0xffff4ff0);
> +	report(n == 7 &&
> +	       db_addr[0] == start + 1 + 6 && dr6[0] == 0xffff4ff0 &&
> +	       db_addr[1] == start + 1 + 6 + 1 && dr6[1] == 0xffff4ff0 &&
> +	       db_addr[2] == start + 1 + 6 + 1 + 3 && dr6[2] == 0xffff4ff0 &&
> +	       db_addr[3] == start + 1 + 6 + 1 + 3 + 2 && dr6[3] == 0xffff4ff0 &&
> +	       db_addr[4] == start + 1 + 6 + 1 + 3 + 2 + 5 && dr6[4] == 0xffff4ff0 &&
> +	       db_addr[5] == start + 1 + 6 + 1 + 3 + 2 + 5 + 2 && dr6[5] == 0xffff4ff0 &&
> +	       db_addr[6] == start + 1 + 6 + 1 + 3 + 2 + 5 + 2 + 1 && dr6[6] == 0xffff4ff0,
> +	       "single step emulated instructions");
>  
>  	n = 0;
>  	set_dr1((void *)&value);
> @@ -160,9 +160,9 @@ int main(int ac, char **av)
>  		"mov $42,%%rax\n\t"
>  		"mov %%rax,%0\n\t; hw_wp1:"
>  		: "=m" (value) : : "rax");
> -	report("hw watchpoint (test that dr6.BS is not cleared)",
> -	       n == 1 &&
> -	       db_addr[0] == ((unsigned long)&hw_wp1) && dr6[0] == 0xffff4ff2);
> +	report(n == 1 &&
> +	       db_addr[0] == ((unsigned long)&hw_wp1) && dr6[0] == 0xffff4ff2,
> +	       "hw watchpoint (test that dr6.BS is not cleared)");
>  
>  	n = 0;
>  	set_dr6(0);
> @@ -172,18 +172,17 @@ int main(int ac, char **av)
>  		"mov $42,%%rax\n\t"
>  		"mov %%rax,%0\n\t; hw_wp2:"
>  		: "=m" (value) : : "rax");
> -	report("hw watchpoint (test that dr6.BS is not set)",
> -	       n == 1 &&
> -	       db_addr[0] == ((unsigned long)&hw_wp2) && dr6[0] == 0xffff0ff2);
> +	report(n == 1 &&
> +	       db_addr[0] == ((unsigned long)&hw_wp2) && dr6[0] == 0xffff0ff2,
> +	       "hw watchpoint (test that dr6.BS is not set)");
>  
>  	n = 0;
>  	set_dr6(0);
>  	extern unsigned char sw_icebp;
>  	asm volatile(".byte 0xf1; sw_icebp:");
> -	report("icebp",
> -	       n == 1 &&
> -	       db_addr[0] == (unsigned long)&sw_icebp &&
> -	       dr6[0] == 0xffff0ff0);
> +	report(n == 1 &&
> +	       db_addr[0] == (unsigned long)&sw_icebp && dr6[0] == 0xffff0ff0,
> +	       "icebp");
>  
>  	set_dr7(0x400);
>  	value = KERNEL_DS;
> @@ -203,7 +202,7 @@ int main(int ac, char **av)
>  		"mov %0,%%ss\n\t"
>  		".byte 0x2e, 0x2e, 0xf1"
>  		: "=m" (value) : : "rax");
> -	report("MOV SS + watchpoint + ICEBP", n == 3);
> +	report(n == 3, "MOV SS + watchpoint + ICEBP");
>  
>  	/*
>  	 * Here the #DB handler is invoked twice, once as a software exception
> @@ -215,7 +214,7 @@ int main(int ac, char **av)
>  		"mov %0,%%ss\n\t"
>  		"int $1"
>  		: "=m" (value) : : "rax");
> -	report("MOV SS + watchpoint + int $1", n == 7);
> +	report(n == 7, "MOV SS + watchpoint + int $1");
>  
>  	/*
>  	 * Here the #DB and #BP handlers are invoked once each.
> @@ -228,7 +227,7 @@ int main(int ac, char **av)
>  		"sw_bp2:"
>  		: "=m" (value) : : "rax");
>  	extern unsigned char sw_bp2;
> -	report("MOV SS + watchpoint + INT3",
> -	       n == 3 && bp_addr == (unsigned long)&sw_bp2);
> +	report(n == 3 && bp_addr == (unsigned long)&sw_bp2,
> +	       "MOV SS + watchpoint + INT3");
>  	return report_summary();
>  }
> diff --git a/x86/emulator.c b/x86/emulator.c
> index 621caf9..8fe03b8 100644
> --- a/x86/emulator.c
> +++ b/x86/emulator.c
> @@ -42,7 +42,7 @@ static void test_stringio(void)
>  		     : : "i"((short)TESTDEV_IO_PORT),
>  		       "S"(st1), "c"(sizeof(st1) - 1));
>  	asm volatile("inb %1, %0\n\t" : "=a"(r) : "i"((short)TESTDEV_IO_PORT));
> -	report("outsb up", r == st1[sizeof(st1) - 2]); /* last char */
> +	report(r == st1[sizeof(st1) - 2], "outsb up"); /* last char */
>  
>  	asm volatile("std \n\t"
>  		     "movw %0, %%dx \n\t"
> @@ -51,7 +51,7 @@ static void test_stringio(void)
>  		       "S"(st1 + sizeof(st1) - 2), "c"(sizeof(st1) - 1));
>  	asm volatile("cld \n\t" : : );
>  	asm volatile("in %1, %0\n\t" : "=a"(r) : "i"((short)TESTDEV_IO_PORT));
> -	report("outsb down", r == st1[0]);
> +	report(r == st1[0], "outsb down");
>  }
>  
>  static void test_cmps_one(unsigned char *m1, unsigned char *m3)
> @@ -64,67 +64,68 @@ static void test_cmps_one(unsigned char *m1, unsigned char *m3)
>  		     "repe/cmpsb"
>  		     : "+S"(rsi), "+D"(rdi), "+c"(rcx), [tmp]"=&r"(tmp)
>  		     : : "cc");
> -	report("repe/cmpsb (1)", rcx == 0 && rsi == m1 + 30 && rdi == m3 + 30);
> +	report(rcx == 0 && rsi == m1 + 30 && rdi == m3 + 30, "repe/cmpsb (1)");
>  
>  	rsi = m1; rdi = m3; rcx = 30;
>  	asm volatile("or $1, %[tmp]\n\t" // clear ZF
>  		     "repe/cmpsb"
>  		     : "+S"(rsi), "+D"(rdi), "+c"(rcx), [tmp]"=&r"(tmp)
>  		     : : "cc");
> -	report("repe/cmpsb (1.zf)", rcx == 0 && rsi == m1 + 30 && rdi == m3 + 30);
> +	report(rcx == 0 && rsi == m1 + 30 && rdi == m3 + 30,
> +	       "repe/cmpsb (1.zf)");
>  
>  	rsi = m1; rdi = m3; rcx = 15;
>  	asm volatile("xor %[tmp], %[tmp] \n\t"
>  		     "repe/cmpsw"
>  		     : "+S"(rsi), "+D"(rdi), "+c"(rcx), [tmp]"=&r"(tmp)
>  		     : : "cc");
> -	report("repe/cmpsw (1)", rcx == 0 && rsi == m1 + 30 && rdi == m3 + 30);
> +	report(rcx == 0 && rsi == m1 + 30 && rdi == m3 + 30, "repe/cmpsw (1)");
>  
>  	rsi = m1; rdi = m3; rcx = 7;
>  	asm volatile("xor %[tmp], %[tmp] \n\t"
>  		     "repe/cmpsl"
>  		     : "+S"(rsi), "+D"(rdi), "+c"(rcx), [tmp]"=&r"(tmp)
>  		     : : "cc");
> -	report("repe/cmpll (1)", rcx == 0 && rsi == m1 + 28 && rdi == m3 + 28);
> +	report(rcx == 0 && rsi == m1 + 28 && rdi == m3 + 28, "repe/cmpll (1)");
>  
>  	rsi = m1; rdi = m3; rcx = 4;
>  	asm volatile("xor %[tmp], %[tmp] \n\t"
>  		     "repe/cmpsq"
>  		     : "+S"(rsi), "+D"(rdi), "+c"(rcx), [tmp]"=&r"(tmp)
>  		     : : "cc");
> -	report("repe/cmpsq (1)", rcx == 0 && rsi == m1 + 32 && rdi == m3 + 32);
> +	report(rcx == 0 && rsi == m1 + 32 && rdi == m3 + 32, "repe/cmpsq (1)");
>  
>  	rsi = m1; rdi = m3; rcx = 130;
>  	asm volatile("xor %[tmp], %[tmp] \n\t"
>  		     "repe/cmpsb"
>  		     : "+S"(rsi), "+D"(rdi), "+c"(rcx), [tmp]"=&r"(tmp)
>  		     : : "cc");
> -	report("repe/cmpsb (2)",
> -	       rcx == 29 && rsi == m1 + 101 && rdi == m3 + 101);
> +	report(rcx == 29 && rsi == m1 + 101 && rdi == m3 + 101,
> +	       "repe/cmpsb (2)");
>  
>  	rsi = m1; rdi = m3; rcx = 65;
>  	asm volatile("xor %[tmp], %[tmp] \n\t"
>  		     "repe/cmpsw"
>  		     : "+S"(rsi), "+D"(rdi), "+c"(rcx), [tmp]"=&r"(tmp)
>  		     : : "cc");
> -	report("repe/cmpsw (2)",
> -	       rcx == 14 && rsi == m1 + 102 && rdi == m3 + 102);
> +	report(rcx == 14 && rsi == m1 + 102 && rdi == m3 + 102,
> +	       "repe/cmpsw (2)");
>  
>  	rsi = m1; rdi = m3; rcx = 32;
>  	asm volatile("xor %[tmp], %[tmp] \n\t"
>  		     "repe/cmpsl"
>  		     : "+S"(rsi), "+D"(rdi), "+c"(rcx), [tmp]"=&r"(tmp)
>  		     : : "cc");
> -	report("repe/cmpll (2)",
> -	       rcx == 6 && rsi == m1 + 104 && rdi == m3 + 104);
> +	report(rcx == 6 && rsi == m1 + 104 && rdi == m3 + 104,
> +	       "repe/cmpll (2)");
>  
>  	rsi = m1; rdi = m3; rcx = 16;
>  	asm volatile("xor %[tmp], %[tmp] \n\t"
>  		     "repe/cmpsq"
>  		     : "+S"(rsi), "+D"(rdi), "+c"(rcx), [tmp]"=&r"(tmp)
>  		     : : "cc");
> -	report("repe/cmpsq (2)",
> -	       rcx == 3 && rsi == m1 + 104 && rdi == m3 + 104);
> +	report(rcx == 3 && rsi == m1 + 104 && rdi == m3 + 104,
> +	       "repe/cmpsq (2)");
>  
>  }
>  
> @@ -150,35 +151,35 @@ static void test_scas(void *mem)
>  
>      di = mem;
>      asm ("scasb; setz %0" : "=rm"(z), "+D"(di) : "a"(0xff11));
> -    report("scasb match", di == mem + 1 && z);
> +    report(di == mem + 1 && z, "scasb match");
>  
>      di = mem;
>      asm ("scasb; setz %0" : "=rm"(z), "+D"(di) : "a"(0xff54));
> -    report("scasb mismatch", di == mem + 1 && !z);
> +    report(di == mem + 1 && !z, "scasb mismatch");
>  
>      di = mem;
>      asm ("scasw; setz %0" : "=rm"(z), "+D"(di) : "a"(0xff2211));
> -    report("scasw match", di == mem + 2 && z);
> +    report(di == mem + 2 && z, "scasw match");
>  
>      di = mem;
>      asm ("scasw; setz %0" : "=rm"(z), "+D"(di) : "a"(0xffdd11));
> -    report("scasw mismatch", di == mem + 2 && !z);
> +    report(di == mem + 2 && !z, "scasw mismatch");
>  
>      di = mem;
>      asm ("scasl; setz %0" : "=rm"(z), "+D"(di) : "a"(0xff44332211ul));
> -    report("scasd match", di == mem + 4 && z);
> +    report(di == mem + 4 && z, "scasd match");
>  
>      di = mem;
>      asm ("scasl; setz %0" : "=rm"(z), "+D"(di) : "a"(0x45332211));
> -    report("scasd mismatch", di == mem + 4 && !z);
> +    report(di == mem + 4 && !z, "scasd mismatch");
>  
>      di = mem;
>      asm ("scasq; setz %0" : "=rm"(z), "+D"(di) : "a"(0x77665544332211ul));
> -    report("scasq match", di == mem + 8 && z);
> +    report(di == mem + 8 && z, "scasq match");
>  
>      di = mem;
>      asm ("scasq; setz %0" : "=rm"(z), "+D"(di) : "a"(3));
> -    report("scasq mismatch", di == mem + 8 && !z);
> +    report(di == mem + 8 && !z, "scasq mismatch");
>  }
>  
>  static void test_cr8(void)
> @@ -189,7 +190,7 @@ static void test_cr8(void)
>  	src = 3;
>  	asm volatile("mov %[src], %%cr8; mov %%cr8, %[dst]"
>  		     : [dst]"+r"(dst), [src]"+r"(src));
> -	report("mov %%cr8", dst == 3 && src == 3);
> +	report(dst == 3 && src == 3, "mov %%cr8");
>  }
>  
>  static void test_push(void *mem)
> @@ -214,10 +215,10 @@ static void test_push(void *mem)
>  		       [reg]"r"(-17l), [mem]"r"(&memw)
>  		     : "memory");
>  
> -	report("push $imm8", stack_top[-1] == -7ul);
> -	report("push %%reg", stack_top[-2] == -17ul);
> -	report("push mem", stack_top[-3] == 0x123456789abcdeful);
> -	report("push $imm", stack_top[-4] == -7070707);
> +	report(stack_top[-1] == -7ul, "push $imm8");
> +	report(stack_top[-2] == -17ul, "push %%reg");
> +	report(stack_top[-3] == 0x123456789abcdeful, "push mem");
> +	report(stack_top[-4] == -7070707, "push $imm");
>  }
>  
>  static void test_pop(void *mem)
> @@ -232,7 +233,7 @@ static void test_pop(void *mem)
>  	asm volatile("pushq %[val] \n\t"
>  		     "popq (%[mem])"
>  		     : : [val]"m"(memw), [mem]"r"(mem) : "memory");
> -	report("pop mem", *(unsigned long *)mem == memw);
> +	report(*(unsigned long *)mem == memw, "pop mem");
>  
>  	memw = 7 - memw;
>  	asm volatile("mov %%rsp, %[tmp] \n\t"
> @@ -243,7 +244,7 @@ static void test_pop(void *mem)
>  		     : [tmp]"=&r"(tmp), [tmp2]"=m"(tmp2)
>  		     : [val]"r"(memw), [stack_top]"r"(stack_top)
>  		     : "memory");
> -	report("pop mem (2)", tmp2 == memw);
> +	report(tmp2 == memw, "pop mem (2)");
>  
>  	memw = 129443 - memw;
>  	asm volatile("mov %%rsp, %[tmp] \n\t"
> @@ -254,7 +255,7 @@ static void test_pop(void *mem)
>  		     : [tmp]"=&r"(tmp), [tmp2]"=r"(tmp2)
>  		     : [val]"r"(memw), [stack_top]"r"(stack_top)
>  		     : "memory");
> -	report("pop reg", tmp2 == memw);
> +	report(tmp2 == memw, "pop reg");
>  
>  	asm volatile("mov %%rsp, %[tmp] \n\t"
>  		     "mov %[stack_top], %%rsp \n\t"
> @@ -264,7 +265,7 @@ static void test_pop(void *mem)
>  		     "1: mov %[tmp], %%rsp"
>  		     : [tmp]"=&r"(tmp) : [stack_top]"r"(stack_top)
>  		     : "memory");
> -	report("ret", 1);
> +	report(1, "ret");
>  
>  	stack_top[-1] = 0x778899;
>  	asm volatile("mov %[stack_top], %%r8 \n\t"
> @@ -277,7 +278,7 @@ static void test_pop(void *mem)
>  		     "mov %%r8, %[tmp3]"
>  		     : [tmp]"=&r"(tmp), [tmp3]"=&r"(tmp3) : [stack_top]"r"(stack_top-1)
>  		     : "memory", "r8", "r9");
> -	report("leave", tmp == (ulong)stack_top && tmp3 == 0x778899);
> +	report(tmp == (ulong)stack_top && tmp3 == 0x778899, "leave");
>  
>  	rbp = 0xaa55aa55bb66bb66ULL;
>  	rsp = (unsigned long)stack_top;
> @@ -291,10 +292,10 @@ static void test_pop(void *mem)
>  		     "xchg %%r8, %[rsp] \n\t"
>  		     "xchg %%r9, %[rbp]"
>  		     : [rsp]"+a"(rsp), [rbp]"+b"(rbp) : : "memory", "r8", "r9");
> -	report("enter",
> -	       rsp == (unsigned long)stack_top - 8 - 0x1238
> +	report(rsp == (unsigned long)stack_top - 8 - 0x1238
>  	       && rbp == (unsigned long)stack_top - 8
> -	       && stack_top[-1] == 0xaa55aa55bb66bb66ULL);
> +	       && stack_top[-1] == 0xaa55aa55bb66bb66ULL,
> +	       "enter");
>  }
>  
>  static void test_ljmp(void *mem)
> @@ -307,7 +308,7 @@ static void test_ljmp(void *mem)
>      asm volatile ("rex64/ljmp *%0"::"m"(*m));
>      res = 0;
>  jmpf:
> -    report("ljmp", res);
> +    report(res, "ljmp");
>  }
>  
>  static void test_incdecnotneg(void *mem)
> @@ -318,36 +319,36 @@ static void test_incdecnotneg(void *mem)
>      *m = 0;
>  
>      asm volatile ("incl %0":"+m"(*m));
> -    report("incl",  *m == 1);
> +    report(*m == 1, "incl");
>      asm volatile ("decl %0":"+m"(*m));
> -    report("decl",  *m == 0);
> +    report(*m == 0, "decl");
>      asm volatile ("incb %0":"+m"(*m));
> -    report("incb",  *m == 1);
> +    report(*m == 1, "incb");
>      asm volatile ("decb %0":"+m"(*m));
> -    report("decb",  *m == 0);
> +    report(*m == 0, "decb");
>  
>      asm volatile ("lock incl %0":"+m"(*m));
> -    report("lock incl",  *m == 1);
> +    report(*m == 1, "lock incl");
>      asm volatile ("lock decl %0":"+m"(*m));
> -    report("lock decl",  *m == 0);
> +    report(*m == 0, "lock decl");
>      asm volatile ("lock incb %0":"+m"(*m));
> -    report("lock incb",  *m == 1);
> +    report(*m == 1, "lock incb");
>      asm volatile ("lock decb %0":"+m"(*m));
> -    report("lock decb",  *m == 0);
> +    report(*m == 0, "lock decb");
>  
>      *m = v;
>  
>      asm ("lock negq %0" : "+m"(*m)); v = -v;
> -    report("lock negl", *m == v);
> +    report(*m == v, "lock negl");
>      asm ("lock notq %0" : "+m"(*m)); v = ~v;
> -    report("lock notl", *m == v);
> +    report(*m == v, "lock notl");
>  
>      *mb = vb;
>  
>      asm ("lock negb %0" : "+m"(*mb)); vb = -vb;
> -    report("lock negb", *mb == vb);
> +    report(*mb == vb, "lock negb");
>      asm ("lock notb %0" : "+m"(*mb)); vb = ~vb;
> -    report("lock notb", *mb == vb);
> +    report(*mb == vb, "lock notb");
>  }
>  
>  static void test_smsw(uint64_t *h_mem)
> @@ -359,7 +360,7 @@ static void test_smsw(uint64_t *h_mem)
>  	msw_orig = read_cr0();
>  
>  	asm("smsw %0" : "=r"(msw));
> -	report("smsw (1)", msw == msw_orig);
> +	report(msw == msw_orig, "smsw (1)");
>  
>  	memset(mem, 0, 16);
>  	pmsw = (void *)mem;
> @@ -368,13 +369,13 @@ static void test_smsw(uint64_t *h_mem)
>  	for (i = 0; i < 8; ++i)
>  		if (i != 4 && pmsw[i])
>  			zero = 0;
> -	report("smsw (2)", msw == pmsw[4] && zero);
> +	report(msw == pmsw[4] && zero, "smsw (2)");
>  
>  	/* Trigger exit on smsw */
>  	*h_mem = 0x12345678abcdeful;
>  	asm volatile("smsw %0" : "+m"(*h_mem));
> -	report("smsw (3)", msw == (unsigned short)*h_mem &&
> -		(*h_mem & ~0xfffful) == 0x12345678ab0000ul);
> +	report(msw == (unsigned short)*h_mem &&
> +	       (*h_mem & ~0xfffful) == 0x12345678ab0000ul, "smsw (3)");
>  }
>  
>  static void test_lmsw(void)
> @@ -388,18 +389,18 @@ static void test_lmsw(void)
>  	msw = cr0 ^ 8;
>  	asm("lmsw %0" : : "r"(msw));
>  	printf("before %lx after %lx\n", cr0, read_cr0());
> -	report("lmsw (1)", (cr0 ^ read_cr0()) == 8);
> +	report((cr0 ^ read_cr0()) == 8, "lmsw (1)");
>  
>  	pmsw = (void *)mem;
>  	*pmsw = cr0;
>  	asm("lmsw %0" : : "m"(*pmsw));
>  	printf("before %lx after %lx\n", cr0, read_cr0());
> -	report("lmsw (2)", cr0 == read_cr0());
> +	report(cr0 == read_cr0(), "lmsw (2)");
>  
>  	/* lmsw can't clear cr0.pe */
>  	msw = (cr0 & ~1ul) ^ 4;  /* change EM to force trap */
>  	asm("lmsw %0" : : "r"(msw));
> -	report("lmsw (3)", (cr0 ^ read_cr0()) == 4 && (cr0 & 1));
> +	report((cr0 ^ read_cr0()) == 4 && (cr0 & 1), "lmsw (3)");
>  
>  	/* back to normal */
>  	msw = cr0;
> @@ -419,8 +420,8 @@ static void test_xchg(void *mem)
>  		     : [rax]"=r"(rax)
>  		     : [memq]"r"(memq)
>  		     : "memory", "rax");
> -	report("xchg reg, r/m (1)",
> -	       rax == 0xfedcba98765432ef && *memq == 0x123456789abcd10);
> +	report(rax == 0xfedcba98765432ef && *memq == 0x123456789abcd10,
> +	       "xchg reg, r/m (1)");
>  
>  	asm volatile("mov $0x123456789abcdef, %%rax\n\t"
>  		     "mov %%rax, (%[memq])\n\t"
> @@ -430,8 +431,8 @@ static void test_xchg(void *mem)
>  		     : [rax]"=r"(rax)
>  		     : [memq]"r"(memq)
>  		     : "memory", "rax");
> -	report("xchg reg, r/m (2)",
> -	       rax == 0xfedcba987654cdef && *memq == 0x123456789ab3210);
> +	report(rax == 0xfedcba987654cdef && *memq == 0x123456789ab3210,
> +	       "xchg reg, r/m (2)");
>  
>  	asm volatile("mov $0x123456789abcdef, %%rax\n\t"
>  		     "mov %%rax, (%[memq])\n\t"
> @@ -441,8 +442,8 @@ static void test_xchg(void *mem)
>  		     : [rax]"=r"(rax)
>  		     : [memq]"r"(memq)
>  		     : "memory", "rax");
> -	report("xchg reg, r/m (3)",
> -	       rax == 0x89abcdef && *memq == 0x123456776543210);
> +	report(rax == 0x89abcdef && *memq == 0x123456776543210,
> +	       "xchg reg, r/m (3)");
>  
>  	asm volatile("mov $0x123456789abcdef, %%rax\n\t"
>  		     "mov %%rax, (%[memq])\n\t"
> @@ -452,8 +453,8 @@ static void test_xchg(void *mem)
>  		     : [rax]"=r"(rax)
>  		     : [memq]"r"(memq)
>  		     : "memory", "rax");
> -	report("xchg reg, r/m (4)",
> -	       rax == 0x123456789abcdef && *memq == 0xfedcba9876543210);
> +	report(rax == 0x123456789abcdef && *memq == 0xfedcba9876543210,
> +	       "xchg reg, r/m (4)");
>  }
>  
>  static void test_xadd(void *mem)
> @@ -469,8 +470,8 @@ static void test_xadd(void *mem)
>  		     : [rax]"=r"(rax)
>  		     : [memq]"r"(memq)
>  		     : "memory", "rax");
> -	report("xadd reg, r/m (1)",
> -	       rax == 0xfedcba98765432ef && *memq == 0x123456789abcdff);
> +	report(rax == 0xfedcba98765432ef && *memq == 0x123456789abcdff,
> +	       "xadd reg, r/m (1)");
>  
>  	asm volatile("mov $0x123456789abcdef, %%rax\n\t"
>  		     "mov %%rax, (%[memq])\n\t"
> @@ -480,8 +481,8 @@ static void test_xadd(void *mem)
>  		     : [rax]"=r"(rax)
>  		     : [memq]"r"(memq)
>  		     : "memory", "rax");
> -	report("xadd reg, r/m (2)",
> -	       rax == 0xfedcba987654cdef && *memq == 0x123456789abffff);
> +	report(rax == 0xfedcba987654cdef && *memq == 0x123456789abffff,
> +	       "xadd reg, r/m (2)");
>  
>  	asm volatile("mov $0x123456789abcdef, %%rax\n\t"
>  		     "mov %%rax, (%[memq])\n\t"
> @@ -491,8 +492,8 @@ static void test_xadd(void *mem)
>  		     : [rax]"=r"(rax)
>  		     : [memq]"r"(memq)
>  		     : "memory", "rax");
> -	report("xadd reg, r/m (3)",
> -	       rax == 0x89abcdef && *memq == 0x1234567ffffffff);
> +	report(rax == 0x89abcdef && *memq == 0x1234567ffffffff,
> +	       "xadd reg, r/m (3)");
>  
>  	asm volatile("mov $0x123456789abcdef, %%rax\n\t"
>  		     "mov %%rax, (%[memq])\n\t"
> @@ -502,8 +503,8 @@ static void test_xadd(void *mem)
>  		     : [rax]"=r"(rax)
>  		     : [memq]"r"(memq)
>  		     : "memory", "rax");
> -	report("xadd reg, r/m (4)",
> -	       rax == 0x123456789abcdef && *memq == 0xffffffffffffffff);
> +	report(rax == 0x123456789abcdef && *memq == 0xffffffffffffffff,
> +	       "xadd reg, r/m (4)");
>  }
>  
>  static void test_btc(void *mem)
> @@ -515,14 +516,14 @@ static void test_btc(void *mem)
>  	asm ("btcl $32, %0" :: "m"(a[0]) : "memory");
>  	asm ("btcl $1, %0" :: "m"(a[1]) : "memory");
>  	asm ("btcl %1, %0" :: "m"(a[0]), "r"(66) : "memory");
> -	report("btcl imm8, r/m", a[0] == 1 && a[1] == 2 && a[2] == 4);
> +	report(a[0] == 1 && a[1] == 2 && a[2] == 4, "btcl imm8, r/m");
>  
>  	asm ("btcl %1, %0" :: "m"(a[3]), "r"(-1) : "memory");
> -	report("btcl reg, r/m", a[0] == 1 && a[1] == 2 && a[2] == 0x80000004);
> +	report(a[0] == 1 && a[1] == 2 && a[2] == 0x80000004, "btcl reg, r/m");
>  
>  	asm ("btcq %1, %0" : : "m"(a[2]), "r"(-1l) : "memory");
> -	report("btcq reg, r/m", a[0] == 1 && a[1] == 0x80000002 &&
> -		a[2] == 0x80000004 && a[3] == 0);
> +	report(a[0] == 1 && a[1] == 0x80000002 && a[2] == 0x80000004 && a[3] == 0,
> +	       "btcq reg, r/m");
>  }
>  
>  static void test_bsfbsr(void *mem)
> @@ -534,37 +535,37 @@ static void test_bsfbsr(void *mem)
>  
>  	*memw = 0xc000;
>  	asm("bsfw %[mem], %[a]" : [a]"=a"(ax) : [mem]"m"(*memw));
> -	report("bsfw r/m, reg", ax == 14);
> +	report(ax == 14, "bsfw r/m, reg");
>  
>  	*meml = 0xc0000000;
>  	asm("bsfl %[mem], %[a]" : [a]"=a"(eax) : [mem]"m"(*meml));
> -	report("bsfl r/m, reg", eax == 30);
> +	report(eax == 30, "bsfl r/m, reg");
>  
>  	*memq = 0xc00000000000;
>  	asm("bsfq %[mem], %[a]" : [a]"=a"(rax) : [mem]"m"(*memq));
> -	report("bsfq r/m, reg", rax == 46);
> +	report(rax == 46, "bsfq r/m, reg");
>  
>  	*memq = 0;
>  	asm("bsfq %[mem], %[a]; setz %[z]"
>  	    : [a]"=a"(rax), [z]"=rm"(z) : [mem]"m"(*memq));
> -	report("bsfq r/m, reg", z == 1);
> +	report(z == 1, "bsfq r/m, reg");
>  
>  	*memw = 0xc000;
>  	asm("bsrw %[mem], %[a]" : [a]"=a"(ax) : [mem]"m"(*memw));
> -	report("bsrw r/m, reg", ax == 15);
> +	report(ax == 15, "bsrw r/m, reg");
>  
>  	*meml = 0xc0000000;
>  	asm("bsrl %[mem], %[a]" : [a]"=a"(eax) : [mem]"m"(*meml));
> -	report("bsrl r/m, reg", eax == 31);
> +	report(eax == 31, "bsrl r/m, reg");
>  
>  	*memq = 0xc00000000000;
>  	asm("bsrq %[mem], %[a]" : [a]"=a"(rax) : [mem]"m"(*memq));
> -	report("bsrq r/m, reg", rax == 47);
> +	report(rax == 47, "bsrq r/m, reg");
>  
>  	*memq = 0;
>  	asm("bsrq %[mem], %[a]; setz %[z]"
>  	    : [a]"=a"(rax), [z]"=rm"(z) : [mem]"m"(*memq));
> -	report("bsrq r/m, reg", z == 1);
> +	report(z == 1, "bsrq r/m, reg");
>  }
>  
>  static void test_imul(ulong *mem)
> @@ -573,39 +574,39 @@ static void test_imul(ulong *mem)
>  
>      *mem = 51; a = 0x1234567812345678UL;
>      asm ("imulw %1, %%ax" : "+a"(a) : "m"(*mem));
> -    report("imul ax, mem", a == 0x12345678123439e8);
> +    report(a == 0x12345678123439e8, "imul ax, mem");
>  
>      *mem = 51; a = 0x1234567812345678UL;
>      asm ("imull %1, %%eax" : "+a"(a) : "m"(*mem));
> -    report("imul eax, mem", a == 0xa06d39e8);
> +    report(a == 0xa06d39e8, "imul eax, mem");
>  
>      *mem = 51; a = 0x1234567812345678UL;
>      asm ("imulq %1, %%rax" : "+a"(a) : "m"(*mem));
> -    report("imul rax, mem", a == 0xA06D39EBA06D39E8UL);
> +    report(a == 0xA06D39EBA06D39E8UL, "imul rax, mem");
>  
>      *mem  = 0x1234567812345678UL; a = 0x8765432187654321L;
>      asm ("imulw $51, %1, %%ax" : "+a"(a) : "m"(*mem));
> -    report("imul ax, mem, imm8", a == 0x87654321876539e8);
> +    report(a == 0x87654321876539e8, "imul ax, mem, imm8");
>  
>      *mem = 0x1234567812345678UL;
>      asm ("imull $51, %1, %%eax" : "+a"(a) : "m"(*mem));
> -    report("imul eax, mem, imm8", a == 0xa06d39e8);
> +    report(a == 0xa06d39e8, "imul eax, mem, imm8");
>  
>      *mem = 0x1234567812345678UL;
>      asm ("imulq $51, %1, %%rax" : "+a"(a) : "m"(*mem));
> -    report("imul rax, mem, imm8", a == 0xA06D39EBA06D39E8UL);
> +    report(a == 0xA06D39EBA06D39E8UL, "imul rax, mem, imm8");
>  
>      *mem  = 0x1234567812345678UL; a = 0x8765432187654321L;
>      asm ("imulw $311, %1, %%ax" : "+a"(a) : "m"(*mem));
> -    report("imul ax, mem, imm", a == 0x8765432187650bc8);
> +    report(a == 0x8765432187650bc8, "imul ax, mem, imm");
>  
>      *mem = 0x1234567812345678UL;
>      asm ("imull $311, %1, %%eax" : "+a"(a) : "m"(*mem));
> -    report("imul eax, mem, imm", a == 0x1d950bc8);
> +    report(a == 0x1d950bc8, "imul eax, mem, imm");
>  
>      *mem = 0x1234567812345678UL;
>      asm ("imulq $311, %1, %%rax" : "+a"(a) : "m"(*mem));
> -    report("imul rax, mem, imm", a == 0x1D950BDE1D950BC8L);
> +    report(a == 0x1D950BDE1D950BC8L, "imul rax, mem, imm");
>  }
>  
>  static void test_muldiv(long *mem)
> @@ -616,26 +617,26 @@ static void test_muldiv(long *mem)
>      *mem = 0; a = 1; d = 2;
>      asm (ASM_TRY("1f") "divq %3; movb $0, %2; 1:"
>  	 : "+a"(a), "+d"(d), "+q"(ex) : "m"(*mem));
> -    report("divq (fault)", a == 1 && d == 2 && ex);
> +    report(a == 1 && d == 2 && ex, "divq (fault)");
>  
>      *mem = 987654321098765UL; a = 123456789012345UL; d = 123456789012345UL;
>      asm (ASM_TRY("1f") "divq %3; movb $0, %2; 1:"
>  	 : "+a"(a), "+d"(d), "+q"(ex) : "m"(*mem));
> -    report("divq (1)",
> -	   a == 0x1ffffffb1b963b33ul && d == 0x273ba4384ede2ul && !ex);
> +    report(a == 0x1ffffffb1b963b33ul && d == 0x273ba4384ede2ul && !ex,
> +           "divq (1)");
>      aa = 0x1111111111111111; dd = 0x2222222222222222;
>      *mem = 0x3333333333333333; a = aa; d = dd;
>      asm("mulb %2" : "+a"(a), "+d"(d) : "m"(*mem));
> -    report("mulb mem", a == 0x1111111111110363 && d == dd);
> +    report(a == 0x1111111111110363 && d == dd, "mulb mem");
>      *mem = 0x3333333333333333; a = aa; d = dd;
>      asm("mulw %2" : "+a"(a), "+d"(d) : "m"(*mem));
> -    report("mulw mem", a == 0x111111111111c963 && d == 0x2222222222220369);
> +    report(a == 0x111111111111c963 && d == 0x2222222222220369, "mulw mem");
>      *mem = 0x3333333333333333; a = aa; d = dd;
>      asm("mull %2" : "+a"(a), "+d"(d) : "m"(*mem));
> -    report("mull mem", a == 0x962fc963 && d == 0x369d036);
> +    report(a == 0x962fc963 && d == 0x369d036, "mull mem");
>      *mem = 0x3333333333333333; a = aa; d = dd;
>      asm("mulq %2" : "+a"(a), "+d"(d) : "m"(*mem));
> -    report("mulq mem", a == 0x2fc962fc962fc963 && d == 0x369d0369d0369d0);
> +    report(a == 0x2fc962fc962fc963 && d == 0x369d0369d0369d0, "mulq mem");
>  }
>  
>  typedef unsigned __attribute__((vector_size(16))) sse128;
> @@ -665,24 +666,24 @@ static __attribute__((target("sse"))) void test_sse(sse_union *mem)
>      write_cr4(read_cr4() | 0x200); /* OSFXSR */
>      v.u[0] = 1; v.u[1] = 2; v.u[2] = 3; v.u[3] = 4;
>      asm("movdqu %1, %0" : "=m"(*mem) : "x"(v.sse));
> -    report("movdqu (read)", sseeq(&v, mem));
> +    report(sseeq(&v, mem), "movdqu (read)");
>      mem->u[0] = 5; mem->u[1] = 6; mem->u[2] = 7; mem->u[3] = 8;
>      asm("movdqu %1, %0" : "=x"(v.sse) : "m"(*mem));
> -    report("movdqu (write)", sseeq(mem, &v));
> +    report(sseeq(mem, &v), "movdqu (write)");
>  
>      v.u[0] = 1; v.u[1] = 2; v.u[2] = 3; v.u[3] = 4;
>      asm("movaps %1, %0" : "=m"(*mem) : "x"(v.sse));
> -    report("movaps (read)", sseeq(mem, &v));
> +    report(sseeq(mem, &v), "movaps (read)");
>      mem->u[0] = 5; mem->u[1] = 6; mem->u[2] = 7; mem->u[3] = 8;
>      asm("movaps %1, %0" : "=x"(v.sse) : "m"(*mem));
> -    report("movaps (write)", sseeq(&v, mem));
> +    report(sseeq(&v, mem), "movaps (write)");
>  
>      v.u[0] = 1; v.u[1] = 2; v.u[2] = 3; v.u[3] = 4;
>      asm("movapd %1, %0" : "=m"(*mem) : "x"(v.sse));
> -    report("movapd (read)", sseeq(mem, &v));
> +    report(sseeq(mem, &v), "movapd (read)");
>      mem->u[0] = 5; mem->u[1] = 6; mem->u[2] = 7; mem->u[3] = 8;
>      asm("movapd %1, %0" : "=x"(v.sse) : "m"(*mem));
> -    report("movapd (write)", sseeq(&v, mem));
> +    report(sseeq(&v, mem), "movapd (write)");
>  }
>  
>  static void test_mmx(uint64_t *mem)
> @@ -693,10 +694,10 @@ static void test_mmx(uint64_t *mem)
>      asm volatile("fninit");
>      v = 0x0102030405060708ULL;
>      asm("movq %1, %0" : "=m"(*mem) : "y"(v));
> -    report("movq (mmx, read)", v == *mem);
> +    report(v == *mem, "movq (mmx, read)");
>      *mem = 0x8070605040302010ull;
>      asm("movq %1, %0" : "=y"(v) : "m"(*mem));
> -    report("movq (mmx, write)", v == *mem);
> +    report(v == *mem, "movq (mmx, write)");
>  }
>  
>  static void test_rip_relative(unsigned *mem, char *insn_ram)
> @@ -711,17 +712,17 @@ static void test_rip_relative(unsigned *mem, char *insn_ram)
>  
>      *mem = 0;
>      asm("callq *%1" : "+m"(*mem) : "r"(insn_ram));
> -    report("movb $imm, 0(%%rip)", *mem == 0x10000);
> +    report(*mem == 0x10000, "movb $imm, 0(%%rip)");
>  }
>  
>  static void test_shld_shrd(u32 *mem)
>  {
>      *mem = 0x12345678;
>      asm("shld %2, %1, %0" : "+m"(*mem) : "r"(0xaaaaaaaaU), "c"((u8)3));
> -    report("shld (cl)", *mem == ((0x12345678 << 3) | 5));
> +    report(*mem == ((0x12345678 << 3) | 5), "shld (cl)");
>      *mem = 0x12345678;
>      asm("shrd %2, %1, %0" : "+m"(*mem) : "r"(0x55555555U), "c"((u8)3));
> -    report("shrd (cl)", *mem == ((0x12345678 >> 3) | (5u << 29)));
> +    report(*mem == ((0x12345678 >> 3) | (5u << 29)), "shrd (cl)");
>  }
>  
>  static void test_cmov(u32 *mem)
> @@ -733,7 +734,7 @@ static void test_cmov(u32 *mem)
>  	     "cmovnel (%[mem]), %%eax\n\t"
>  	     "movq %%rax, %[val]\n\t"
>  	     : [val]"=r"(val) : [mem]"r"(mem) : "%rax", "cc");
> -	report("cmovnel", val == 0x12345678ul);
> +	report(val == 0x12345678ul, "cmovnel");
>  }
>  
>  static unsigned long rip_advance;
> @@ -760,7 +761,7 @@ static void test_mmx_movq_mf(uint64_t *mem)
>      asm(KVM_FEP "movq_start: movq %mm0, (%rax); movq_end:");
>      /* exit MMX mode */
>      asm volatile("fnclex; emms");
> -    report("movq mmx generates #MF", exceptions == 1);
> +    report(exceptions == 1, "movq mmx generates #MF");
>      handle_exception(MF_VECTOR, 0);
>  }
>  
> @@ -774,7 +775,7 @@ static void test_jmp_noncanonical(uint64_t *mem)
>  	rip_advance = &nc_jmp_end - &nc_jmp_start;
>  	handle_exception(GP_VECTOR, advance_rip_and_note_exception);
>  	asm volatile ("nc_jmp_start: jmp *%0; nc_jmp_end:" : : "m"(*mem));
> -	report("jump to non-canonical address", exceptions == 1);
> +	report(exceptions == 1, "jump to non-canonical address");
>  	handle_exception(GP_VECTOR, 0);
>  }
>  
> @@ -783,7 +784,7 @@ static void test_movabs(uint64_t *mem)
>      /* mov $0x9090909090909090, %rcx */
>      unsigned long rcx;
>      asm(KVM_FEP "mov $0x9090909090909090, %0" : "=c" (rcx) : "0" (0));
> -    report("64-bit mov imm2", rcx == 0x9090909090909090);
> +    report(rcx == 0x9090909090909090, "64-bit mov imm2");
>  }
>  
>  static void test_smsw_reg(uint64_t *mem)
> @@ -793,14 +794,14 @@ static void test_smsw_reg(uint64_t *mem)
>  	const unsigned long in_rax = 0x1234567890abcdeful;
>  
>  	asm(KVM_FEP "smsww %w0\n\t" : "=a" (rax) : "0" (in_rax));
> -	report("16-bit smsw reg", (u16)rax == (u16)cr0 &&
> -				  rax >> 16 == in_rax >> 16);
> +	report((u16)rax == (u16)cr0 && rax >> 16 == in_rax >> 16,
> +	       "16-bit smsw reg");
>  
>  	asm(KVM_FEP "smswl %k0\n\t" : "=a" (rax) : "0" (in_rax));
> -	report("32-bit smsw reg", rax == (u32)cr0);
> +	report(rax == (u32)cr0, "32-bit smsw reg");
>  
>  	asm(KVM_FEP "smswq %q0\n\t" : "=a" (rax) : "0" (in_rax));
> -	report("64-bit smsw reg", rax == cr0);
> +	report(rax == cr0, "64-bit smsw reg");
>  }
>  
>  static void test_nop(uint64_t *mem)
> @@ -808,7 +809,7 @@ static void test_nop(uint64_t *mem)
>  	unsigned long rax;
>  	const unsigned long in_rax = 0x1234567890abcdeful;
>  	asm(KVM_FEP "nop\n\t" : "=a" (rax) : "0" (in_rax));
> -	report("nop", rax == in_rax);
> +	report(rax == in_rax, "nop");
>  }
>  
>  static void test_mov_dr(uint64_t *mem)
> @@ -819,7 +820,7 @@ static void test_mov_dr(uint64_t *mem)
>  	unsigned long dr6_fixed_1 = rtm_support ? 0xfffe0ff0ul : 0xffff0ff0ul;
>  	asm(KVM_FEP "movq %0, %%dr6\n\t"
>  	    KVM_FEP "movq %%dr6, %0\n\t" : "=a" (rax) : "a" (in_rax));
> -	report("mov_dr6", rax == dr6_fixed_1);
> +	report(rax == dr6_fixed_1, "mov_dr6");
>  }
>  
>  static void test_push16(uint64_t *mem)
> @@ -834,7 +835,7 @@ static void test_push16(uint64_t *mem)
>  			"movq %[rsp1], %%rsp\n\t" :
>  			[rsp1]"=r"(rsp1), [rsp2]"=r"(rsp2), [r]"=r"(r)
>  			: [v]"m"(*mem) : "memory");
> -	report("push16", rsp1 == rsp2);
> +	report(rsp1 == rsp2, "push16");
>  }
>  
>  static void test_crosspage_mmio(volatile uint8_t *mem)
> @@ -845,9 +846,9 @@ static void test_crosspage_mmio(volatile uint8_t *mem)
>      mem[4095] = 0x99;
>      mem[4096] = 0x77;
>      asm volatile("mov %1, %0" : "=r"(w) : "m"(*pw) : "memory");
> -    report("cross-page mmio read", w == 0x7799);
> +    report(w == 0x7799, "cross-page mmio read");
>      asm volatile("mov %1, %0" : "=m"(*pw) : "r"((uint16_t)0x88aa));
> -    report("cross-page mmio write", mem[4095] == 0xaa && mem[4096] == 0x88);
> +    report(mem[4095] == 0xaa && mem[4096] == 0x88, "cross-page mmio write");
>  }
>  
>  static void test_string_io_mmio(volatile uint8_t *mem)
> @@ -859,7 +860,7 @@ static void test_string_io_mmio(volatile uint8_t *mem)
>  
>  	asm volatile ("cld; rep insb" : : "d" (TESTDEV_IO_PORT), "D" (mmio), "c" (1024));
>  
> -	report("string_io_mmio", mmio[1023] == 0x99);
> +	report(mmio[1023] == 0x99, "string_io_mmio");
>  }
>  
>  /* kvm doesn't allow lidt/lgdt from mmio, so the test is disabled */
> @@ -878,7 +879,8 @@ static void test_lgdt_lidt(volatile uint8_t *mem)
>      sgdt(&fresh);
>      lgdt(&orig);
>      sti();
> -    report("lgdt (long address)", orig.limit == fresh.limit && orig.base == fresh.base);
> +    report(orig.limit == fresh.limit && orig.base == fresh.base,
> +           "lgdt (long address)");
>  
>      sidt(&orig);
>      *(struct descriptor_table_ptr *)mem = (struct descriptor_table_ptr) {
> @@ -890,7 +892,8 @@ static void test_lgdt_lidt(volatile uint8_t *mem)
>      sidt(&fresh);
>      lidt(&orig);
>      sti();
> -    report("lidt (long address)", orig.limit == fresh.limit && orig.base == fresh.base);
> +    report(orig.limit == fresh.limit && orig.base == fresh.base,
> +           "lidt (long address)");
>  }
>  #endif
>  
> @@ -909,14 +912,15 @@ static void test_sreg(volatile uint16_t *mem)
>      // check for null segment load
>      *mem = 0;
>      asm volatile("mov %0, %%ss" : : "m"(*mem));
> -    report("mov null, %%ss", read_ss() == 0);
> +    report(read_ss() == 0, "mov null, %%ss");
>  
>      // check for exception when ss.rpl != cpl on null segment load
>      exceptions = 0;
>      handle_exception(GP_VECTOR, ss_bad_rpl);
>      *mem = 3;
>      asm volatile("mov %0, %%ss; ss_bad_rpl_cont:" : : "m"(*mem));
> -    report("mov null, %%ss (with ss.rpl != cpl)", exceptions == 1 && read_ss() == 0);
> +    report(exceptions == 1 && read_ss() == 0,
> +           "mov null, %%ss (with ss.rpl != cpl)");
>      handle_exception(GP_VECTOR, 0);
>      write_ss(ss);
>  }
> @@ -941,7 +945,7 @@ static void test_lldt(volatile uint16_t *mem)
>      asm volatile("lldt %0" : : "m"(*mem));
>      lgdt(&orig_gdt);
>      sti();
> -    report("lldt", sldt() == *mem);
> +    report(sldt() == *mem, "lldt");
>  }
>  #endif
>  
> @@ -958,32 +962,32 @@ static void test_ltr(volatile uint16_t *mem)
>      *trp &= ~busy_mask;
>      *mem = tr;
>      asm volatile("ltr %0" : : "m"(*mem) : "memory");
> -    report("ltr", str() == tr && (*trp & busy_mask));
> +    report(str() == tr && (*trp & busy_mask), "ltr");
>  }
>  
>  static void test_simplealu(u32 *mem)
>  {
>      *mem = 0x1234;
>      asm("or %1, %0" : "+m"(*mem) : "r"(0x8001));
> -    report("or", *mem == 0x9235);
> +    report(*mem == 0x9235, "or");
>      asm("add %1, %0" : "+m"(*mem) : "r"(2));
> -    report("add", *mem == 0x9237);
> +    report(*mem == 0x9237, "add");
>      asm("xor %1, %0" : "+m"(*mem) : "r"(0x1111));
> -    report("xor", *mem == 0x8326);
> +    report(*mem == 0x8326, "xor");
>      asm("sub %1, %0" : "+m"(*mem) : "r"(0x26));
> -    report("sub", *mem == 0x8300);
> +    report(*mem == 0x8300, "sub");
>      asm("clc; adc %1, %0" : "+m"(*mem) : "r"(0x100));
> -    report("adc(0)", *mem == 0x8400);
> +    report(*mem == 0x8400, "adc(0)");
>      asm("stc; adc %1, %0" : "+m"(*mem) : "r"(0x100));
> -    report("adc(0)", *mem == 0x8501);
> +    report(*mem == 0x8501, "adc(0)");
>      asm("clc; sbb %1, %0" : "+m"(*mem) : "r"(0));
> -    report("sbb(0)", *mem == 0x8501);
> +    report(*mem == 0x8501, "sbb(0)");
>      asm("stc; sbb %1, %0" : "+m"(*mem) : "r"(0));
> -    report("sbb(1)", *mem == 0x8500);
> +    report(*mem == 0x8500, "sbb(1)");
>      asm("and %1, %0" : "+m"(*mem) : "r"(0xfe77));
> -    report("and", *mem == 0x8400);
> +    report(*mem == 0x8400, "and");
>      asm("test %1, %0" : "+m"(*mem) : "r"(0xf000));
> -    report("test", *mem == 0x8400);
> +    report(*mem == 0x8400, "test");
>  }
>  
>  static void illegal_movbe_handler(struct ex_regs *regs)
> @@ -1005,7 +1009,7 @@ static void test_illegal_movbe(void)
>  	handle_exception(UD_VECTOR, illegal_movbe_handler);
>  	asm volatile(".byte 0x0f; .byte 0x38; .byte 0xf0; .byte 0xc0;\n\t"
>  		     " bad_movbe_cont:" : : : "rax");
> -	report("illegal movbe", exceptions == 1);
> +	report(exceptions == 1, "illegal movbe");
>  	handle_exception(UD_VECTOR, 0);
>  }
>  
> @@ -1042,7 +1046,7 @@ int main(void)
>  		     : [t2]"=r"(t2)
>  		     : [t1]"r"(t1), [mem]"r"(mem)
>  		     : "memory");
> -	report("mov reg, r/m (1)", t2 == 0x123456789abcdef);
> +	report(t2 == 0x123456789abcdef, "mov reg, r/m (1)");
>  
>  	test_simplealu(mem);
>  	test_cmps(mem);
> diff --git a/x86/eventinj.c b/x86/eventinj.c
> index c38848e..aa7c233 100644
> --- a/x86/eventinj.c
> +++ b/x86/eventinj.c
> @@ -226,7 +226,7 @@ int main(void)
>  	asm volatile ("divl %3": "=a"(res)
>  		      : "d"(0), "a"(1500), "m"(test_divider));
>  	printf("Result is %d\n", res);
> -	report("DE exception", res == 150);
> +	report(res == 150, "DE exception");
>  
>  	/* generate soft exception (BP) that will fault on IDT and stack */
>  	test_count = 0;
> @@ -236,7 +236,7 @@ int main(void)
>  	flush_stack();
>  	asm volatile ("int $3");
>  	printf("After int 3\n");
> -	report("BP exception", test_count == 1);
> +	report(test_count == 1, "BP exception");
>  
>  #ifndef __x86_64__
>  	/* generate soft exception (OF) that will fault on IDT */
> @@ -246,7 +246,7 @@ int main(void)
>  	printf("Try into\n");
>  	asm volatile ("addb $127, %b0\ninto"::"a"(127));
>  	printf("After into\n");
> -	report("OF exception", test_count == 1);
> +	report(test_count == 1, "OF exception");
>  
>  	/* generate soft exception (OF) using two bit instruction that will
>  	   fault on IDT */
> @@ -256,7 +256,7 @@ int main(void)
>  	printf("Try into\n");
>  	asm volatile ("addb $127, %b0\naddr16 into"::"a"(127));
>  	printf("After into\n");
> -	report("2 byte OF exception", test_count == 1);
> +	report(test_count == 1, "2 byte OF exception");
>  #endif
>  
>  	/* generate HW interrupt that will fault on IDT */
> @@ -268,7 +268,7 @@ int main(void)
>  	io_delay();
>  	irq_disable();
>  	printf("After vec 33 to self\n");
> -	report("vec 33", test_count == 1);
> +	report(test_count == 1, "vec 33");
>  
>  	/* generate soft interrupt that will fault on IDT and stack */
>  	test_count = 0;
> @@ -277,7 +277,7 @@ int main(void)
>  	flush_stack();
>  	asm volatile ("int $33");
>  	printf("After int $33\n");
> -	report("int $33", test_count == 1);
> +	report(test_count == 1, "int $33");
>  
>  	/* Inject two HW interrupt than open iterrupt windows. Both interrupt
>  	   will fault on IDT access */
> @@ -291,7 +291,7 @@ int main(void)
>  	asm volatile("nop");
>  	irq_disable();
>  	printf("After vec 32 and 33 to self\n");
> -	report("vec 32/33", test_count == 2);
> +	report(test_count == 2, "vec 32/33");
>  
>  
>  	/* Inject HW interrupt, do sti and than (while in irq shadow) inject
> @@ -306,7 +306,7 @@ int main(void)
>  	asm volatile ("sti; int $33");
>  	irq_disable();
>  	printf("After vec 32 and int $33\n");
> -	report("vec 32/int $33", test_count == 2);
> +	report(test_count == 2, "vec 32/int $33");
>  
>  	/* test that TPR is honored */
>  	test_count = 0;
> @@ -320,7 +320,7 @@ int main(void)
>  	io_delay();
>  	apic_write(APIC_TASKPRI, 0x2 << 4);
>  	printf("After 33/62 TPR test\n");
> -	report("TPR", test_count == 1);
> +	report(test_count == 1, "TPR");
>  	apic_write(APIC_TASKPRI, 0x0);
>  	while(test_count != 2); /* wait for second irq */
>  	irq_disable();
> @@ -334,7 +334,7 @@ int main(void)
>  	flush_stack();
>  	asm volatile ("int $33");
>  	printf("After int33\n");
> -	report("NP exception", test_count == 2);
> +	report(test_count == 2, "NP exception");
>  
>  	/* generate NMI that will fault on IDT */
>  	test_count = 0;
> @@ -349,7 +349,7 @@ int main(void)
>  	irq_enable();
>  	asm volatile ("nop");
>  	irq_disable();
> -	report("NMI", test_count == 2);
> +	report(test_count == 2, "NMI");
>  
>  	/* generate NMI that will fault on IRET */
>  	printf("Before NMI IRET test\n");
> @@ -364,7 +364,7 @@ int main(void)
>  	asm volatile ("nop");
>  	irq_disable();
>  	printf("After NMI to self\n");
> -	report("NMI", test_count == 2);
> +	report(test_count == 2, "NMI");
>  	stack_phys = (ulong)virt_to_phys(alloc_page());
>  	stack_va = alloc_vpage();
>  
> @@ -384,7 +384,7 @@ int main(void)
>  		      : "d"(0), "a"(1500), "m"(test_divider));
>  	restore_stack();
>  	printf("Result is %d\n", res);
> -	report("DE PF exceptions", res == 150);
> +	report(res == 150, "DE PF exceptions");
>  
>  	/* Generate NP and PF exceptions serially */
>  	printf("Before NP test\n");
> @@ -402,7 +402,7 @@ int main(void)
>  	asm volatile ("int $33");
>  	restore_stack();
>  	printf("After int33\n");
> -	report("NP PF exceptions", test_count == 2);
> +	report(test_count == 2, "NP PF exceptions");
>  
>  	pt = alloc_page();
>  	cr3 = (void*)read_cr3();
> @@ -426,7 +426,7 @@ int main(void)
>  	asm volatile("int $33");
>  	restore_stack();
>  	printf("After int 33 with shadowed stack\n");
> -	report("int 33 with shadowed stack", test_count == 1);
> +	report(test_count == 1, "int 33 with shadowed stack");
>  
>  	return report_summary();
>  }
> diff --git a/x86/hypercall.c b/x86/hypercall.c
> index 37fec8e..7fbbf30 100644
> --- a/x86/hypercall.c
> +++ b/x86/hypercall.c
> @@ -71,10 +71,12 @@ int main(int ac, char **av)
>  	topmost[4093] = 0x0f;
>  	topmost[4094] = 0x01;
>  	topmost[4095] = 0xc1;
> -	report("VMCALL on edge of canonical address space (intel)", test_edge());
> +	report(test_edge(),
> +	       "VMCALL on edge of canonical address space (intel)");
>  
>  	topmost[4095] = 0xd9;
> -	report("VMMCALL on edge of canonical address space (AMD)", test_edge());
> +	report(test_edge(),
> +	       "VMMCALL on edge of canonical address space (AMD)");
>  #endif
>  
>  	return report_summary();
> diff --git a/x86/hyperv_clock.c b/x86/hyperv_clock.c
> index d57591f..99775a9 100644
> --- a/x86/hyperv_clock.c
> +++ b/x86/hyperv_clock.c
> @@ -112,7 +112,7 @@ static void check_test(int ncpus)
>  	for (i = ncpus - 1; i >= 0; i--)
>  		pass &= ok[i];
>  
> -	report("TSC reference precision test", pass);
> +	report(pass, "TSC reference precision test");
>  }
>  
>  static void hv_perf_test(void *data)
> @@ -159,8 +159,8 @@ int main(int ac, char **av)
>  
>  	hv_clock = alloc_page();
>  	wrmsr(HV_X64_MSR_REFERENCE_TSC, (u64)(uintptr_t)hv_clock | 1);
> -	report("MSR value after enabling",
> -	       rdmsr(HV_X64_MSR_REFERENCE_TSC) == ((u64)(uintptr_t)hv_clock | 1));
> +	report(rdmsr(HV_X64_MSR_REFERENCE_TSC) == ((u64)(uintptr_t)hv_clock | 1),
> +	       "MSR value after enabling");
>  
>  	hvclock_get_time_values(&shadow, hv_clock);
>  	if (shadow.tsc_sequence == 0 || shadow.tsc_sequence == 0xFFFFFFFF) {
> @@ -189,7 +189,8 @@ int main(int ac, char **av)
>  	perf_test(ncpus);
>  
>  	wrmsr(HV_X64_MSR_REFERENCE_TSC, 0LL);
> -	report("MSR value after disabling", rdmsr(HV_X64_MSR_REFERENCE_TSC) == 0);
> +	report(rdmsr(HV_X64_MSR_REFERENCE_TSC) == 0,
> +	       "MSR value after disabling");
>  
>  	return nerr > 0 ? 1 : 0;
>  }
> diff --git a/x86/hyperv_connections.c b/x86/hyperv_connections.c
> index 8eade41..55cc033 100644
> --- a/x86/hyperv_connections.c
> +++ b/x86/hyperv_connections.c
> @@ -292,36 +292,36 @@ int main(int ac, char **av)
>  		on_cpu(i, setup_cpu, (void *)read_cr3());
>  
>  	ncpus_ok = run_test(ncpus, 0, WAIT_CYCLES, do_msg, msg_ok);
> -	report("send message to self: %d/%d",
> -	       ncpus_ok == ncpus, ncpus_ok, ncpus);
> +	report(ncpus_ok == ncpus, "send message to self: %d/%d", ncpus_ok,
> +	       ncpus);
>  
>  	run_test(ncpus, 0, 0, clear_msg, NULL);
>  
>  	ncpus_ok = run_test(ncpus, 1, WAIT_CYCLES, do_msg, msg_ok);
> -	report("send message to another cpu: %d/%d",
> -	       ncpus_ok == ncpus, ncpus_ok, ncpus);
> +	report(ncpus_ok == ncpus, "send message to another cpu: %d/%d",
> +	       ncpus_ok, ncpus);
>  
>  	ncpus_ok = run_test(ncpus, 1, WAIT_CYCLES, do_msg, msg_busy);
> -	report("send message to busy slot: %d/%d",
> -	       ncpus_ok == ncpus, ncpus_ok, ncpus);
> +	report(ncpus_ok == ncpus, "send message to busy slot: %d/%d",
> +	       ncpus_ok, ncpus);
>  
>  	ncpus_ok = run_test(ncpus, 0, WAIT_CYCLES, clear_msg, msg_ok);
> -	report("receive pending message: %d/%d",
> -	       ncpus_ok == ncpus, ncpus_ok, ncpus);
> +	report(ncpus_ok == ncpus, "receive pending message: %d/%d", ncpus_ok,
> +	       ncpus);
>  
>  	ncpus_ok = run_test(ncpus, 0, WAIT_CYCLES, do_evt, evt_ok);
> -	report("signal event on self: %d/%d",
> -	       ncpus_ok == ncpus, ncpus_ok, ncpus);
> +	report(ncpus_ok == ncpus, "signal event on self: %d/%d", ncpus_ok,
> +	       ncpus);
>  
>  	run_test(ncpus, 0, 0, clear_evt, NULL);
>  
>  	ncpus_ok = run_test(ncpus, 1, WAIT_CYCLES, do_evt, evt_ok);
> -	report("signal event on another cpu: %d/%d",
> -	       ncpus_ok == ncpus, ncpus_ok, ncpus);
> +	report(ncpus_ok == ncpus, "signal event on another cpu: %d/%d",
> +	       ncpus_ok, ncpus);
>  
>  	ncpus_ok = run_test(ncpus, 1, WAIT_CYCLES, do_evt, evt_busy);
> -	report("signal event already set: %d/%d",
> -	       ncpus_ok == ncpus, ncpus_ok, ncpus);
> +	report(ncpus_ok == ncpus, "signal event already set: %d/%d", ncpus_ok,
> +	       ncpus);
>  
>  	for (i = 0; i < ncpus; i++)
>  		on_cpu(i, teardown_cpu, NULL);
> diff --git a/x86/hyperv_stimer.c b/x86/hyperv_stimer.c
> index b6332fd..ddfc844 100644
> --- a/x86/hyperv_stimer.c
> +++ b/x86/hyperv_stimer.c
> @@ -96,7 +96,7 @@ static void process_stimer_msg(struct svcpu *svcpu,
>  
>      if (msg->header.message_type != HVMSG_TIMER_EXPIRED &&
>          msg->header.message_type != HVMSG_NONE) {
> -        report("invalid Hyper-V SynIC msg type", false);
> +        report(false, "invalid Hyper-V SynIC msg type");
>          report_summary();
>          abort();
>      }
> @@ -106,7 +106,7 @@ static void process_stimer_msg(struct svcpu *svcpu,
>      }
>  
>      if (msg->header.payload_size < sizeof(*payload)) {
> -        report("invalid Hyper-V SynIC msg payload size", false);
> +        report(false, "invalid Hyper-V SynIC msg payload size");
>          report_summary();
>          abort();
>      }
> @@ -114,7 +114,7 @@ static void process_stimer_msg(struct svcpu *svcpu,
>      /* Now process timer expiration message */
>  
>      if (payload->timer_index >= ARRAY_SIZE(svcpu->timer)) {
> -        report("invalid Hyper-V SynIC timer index", false);
> +        report(false, "invalid Hyper-V SynIC timer index");
>          report_summary();
>          abort();
>      }
> @@ -234,7 +234,7 @@ static void stimer_test_periodic(int vcpu, struct stimer *timer1,
>             (atomic_read(&timer2->fire_count) < 1000)) {
>          pause();
>      }
> -    report("Hyper-V SynIC periodic timers test vcpu %d", true, vcpu);
> +    report(true, "Hyper-V SynIC periodic timers test vcpu %d", vcpu);
>      stimer_shutdown(timer1);
>      stimer_shutdown(timer2);
>  }
> @@ -246,7 +246,7 @@ static void stimer_test_one_shot(int vcpu, struct stimer *timer)
>      while (atomic_read(&timer->fire_count) < 1) {
>          pause();
>      }
> -    report("Hyper-V SynIC one-shot test vcpu %d", true, vcpu);
> +    report(true, "Hyper-V SynIC one-shot test vcpu %d", vcpu);
>      stimer_shutdown(timer);
>  }
>  
> @@ -257,7 +257,8 @@ static void stimer_test_auto_enable_one_shot(int vcpu, struct stimer *timer)
>      while (atomic_read(&timer->fire_count) < 1) {
>          pause();
>      }
> -    report("Hyper-V SynIC auto-enable one-shot timer test vcpu %d", true, vcpu);
> +    report(true, "Hyper-V SynIC auto-enable one-shot timer test vcpu %d",
> +           vcpu);
>      stimer_shutdown(timer);
>  }
>  
> @@ -268,7 +269,8 @@ static void stimer_test_auto_enable_periodic(int vcpu, struct stimer *timer)
>      while (atomic_read(&timer->fire_count) < 1000) {
>          pause();
>      }
> -    report("Hyper-V SynIC auto-enable periodic timer test vcpu %d", true, vcpu);
> +    report(true, "Hyper-V SynIC auto-enable periodic timer test vcpu %d",
> +           vcpu);
>      stimer_shutdown(timer);
>  }
>  
> @@ -286,8 +288,8 @@ static void stimer_test_one_shot_busy(int vcpu, struct stimer *timer)
>          rmb();
>      while (!msg->header.message_flags.msg_pending);
>  
> -    report("no timer fired while msg slot busy: vcpu %d",
> -           !atomic_read(&timer->fire_count), vcpu);
> +    report(!atomic_read(&timer->fire_count),
> +           "no timer fired while msg slot busy: vcpu %d", vcpu);
>  
>      msg->header.message_type = HVMSG_NONE;
>      wmb();
> @@ -296,7 +298,7 @@ static void stimer_test_one_shot_busy(int vcpu, struct stimer *timer)
>      while (atomic_read(&timer->fire_count) < 1) {
>          pause();
>      }
> -    report("timer resumed when msg slot released: vcpu %d", true, vcpu);
> +    report(true, "timer resumed when msg slot released: vcpu %d", vcpu);
>  
>      stimer_shutdown(timer);
>  }
> @@ -354,17 +356,17 @@ int main(int ac, char **av)
>  {
>  
>      if (!synic_supported()) {
> -        report("Hyper-V SynIC is not supported", true);
> +        report(true, "Hyper-V SynIC is not supported");
>          goto done;
>      }
>  
>      if (!stimer_supported()) {
> -        report("Hyper-V SynIC timers are not supported", true);
> +        report(true, "Hyper-V SynIC timers are not supported");
>          goto done;
>      }
>  
>      if (!hv_time_ref_counter_supported()) {
> -        report("Hyper-V time reference counter is not supported", true);
> +        report(true, "Hyper-V time reference counter is not supported");
>          goto done;
>      }
>  
> diff --git a/x86/hyperv_synic.c b/x86/hyperv_synic.c
> index 9a5f53f..b6c7104 100644
> --- a/x86/hyperv_synic.c
> +++ b/x86/hyperv_synic.c
> @@ -90,7 +90,7 @@ static void synic_test_prepare(void *ctx)
>      }
>      r = rdmsr(HV_X64_MSR_EOM);
>      if (r != 0) {
> -        report("Hyper-V SynIC test, EOM read %#" PRIx64, false, r);
> +        report(false, "Hyper-V SynIC test, EOM read %#" PRIx64, r);
>          return;
>      }
>  
> @@ -177,7 +177,7 @@ int main(int ac, char **av)
>              ok &= atomic_read(&isr_enter_count[i]) == 16;
>          }
>  
> -        report("Hyper-V SynIC test", ok);
> +        report(ok, "Hyper-V SynIC test");
>      } else {
>          printf("Hyper-V SynIC is not supported");
>      }
> diff --git a/x86/idt_test.c b/x86/idt_test.c
> index 844c860..aa29733 100644
> --- a/x86/idt_test.c
> +++ b/x86/idt_test.c
> @@ -31,11 +31,11 @@ int main(void)
>      printf("Starting IDT test\n");
>      setup_idt();
>      r = test_gp(&rflags_rf);
> -    report("Testing #GP", r == GP_VECTOR);
> -    report("Testing #GP rflags.rf", rflags_rf);
> +    report(r == GP_VECTOR, "Testing #GP");
> +    report(rflags_rf, "Testing #GP rflags.rf");
>      r = test_ud2(&rflags_rf);
> -    report("Testing #UD", r == UD_VECTOR);
> -    report("Testing #UD rflags.rf", rflags_rf);
> +    report(r == UD_VECTOR, "Testing #UD");
> +    report(rflags_rf, "Testing #UD rflags.rf");
>  
>      return report_summary();
>  }
> diff --git a/x86/intel-iommu.c b/x86/intel-iommu.c
> index f24170d..25feec0 100644
> --- a/x86/intel-iommu.c
> +++ b/x86/intel-iommu.c
> @@ -56,7 +56,7 @@ static void vtd_test_dmar(void)
>  	 * Check data match between 0-3 bytes and 4-7 bytes of the
>  	 * page.
>  	 */
> -	report(VTD_TEST_DMAR_4B, *((uint32_t *)page + 1) == DMA_TEST_WORD);
> +	report(*((uint32_t *)page + 1) == DMA_TEST_WORD, VTD_TEST_DMAR_4B);
>  
>  	free_page(page);
>  
> @@ -102,7 +102,7 @@ static void vtd_test_ir(void)
>  	edu_reg_writel(dev, EDU_REG_INTR_RAISE, 0);
>  
>  	/* We are good as long as we reach here */
> -	report(VTD_TEST_IR_IOAPIC, edu_intr_recved == true);
> +	report(edu_intr_recved == true, VTD_TEST_IR_IOAPIC);
>  
>  	/*
>  	 * Setup EDU PCI device MSI, using interrupt remapping. By
> @@ -125,7 +125,7 @@ static void vtd_test_ir(void)
>  		cpu_relax();
>  
>  	/* We are good as long as we reach here */
> -	report(VTD_TEST_IR_MSI, edu_intr_recved == true);
> +	report(edu_intr_recved == true, VTD_TEST_IR_MSI);
>  
>  	report_prefix_pop();
>  }
> @@ -139,15 +139,16 @@ int main(int argc, char *argv[])
>  
>  	report_prefix_push("vtd_init");
>  
> -	report("fault status check", vtd_readl(DMAR_FSTS_REG) == 0);
> -	report("QI enablement", vtd_readl(DMAR_GSTS_REG) & VTD_GCMD_QI);
> -	report("DMAR table setup", vtd_readl(DMAR_GSTS_REG) & VTD_GCMD_ROOT);
> -	report("IR table setup", vtd_readl(DMAR_GSTS_REG) & VTD_GCMD_IR_TABLE);
> -	report("DMAR enablement", vtd_readl(DMAR_GSTS_REG) & VTD_GCMD_DMAR);
> -	report("IR enablement", vtd_readl(DMAR_GSTS_REG) & VTD_GCMD_IR);
> -	report("DMAR support 39 bits address width",
> -	       vtd_readq(DMAR_CAP_REG) & VTD_CAP_SAGAW);
> -	report("DMAR support huge pages", vtd_readq(DMAR_CAP_REG) & VTD_CAP_SLLPS);
> +	report(vtd_readl(DMAR_FSTS_REG) == 0, "fault status check");
> +	report(vtd_readl(DMAR_GSTS_REG) & VTD_GCMD_QI, "QI enablement");
> +	report(vtd_readl(DMAR_GSTS_REG) & VTD_GCMD_ROOT, "DMAR table setup");
> +	report(vtd_readl(DMAR_GSTS_REG) & VTD_GCMD_IR_TABLE, "IR table setup");
> +	report(vtd_readl(DMAR_GSTS_REG) & VTD_GCMD_DMAR, "DMAR enablement");
> +	report(vtd_readl(DMAR_GSTS_REG) & VTD_GCMD_IR, "IR enablement");
> +	report(vtd_readq(DMAR_CAP_REG) & VTD_CAP_SAGAW,
> +	       "DMAR support 39 bits address width");
> +	report(vtd_readq(DMAR_CAP_REG) & VTD_CAP_SLLPS,
> +	       "DMAR support huge pages");
>  
>  	report_prefix_pop();
>  
> diff --git a/x86/ioapic.c b/x86/ioapic.c
> index c32dabd..c3083a8 100644
> --- a/x86/ioapic.c
> +++ b/x86/ioapic.c
> @@ -22,8 +22,8 @@ static void ioapic_reg_version(void)
>  	data_write = data_read ^ 0xffffffff;
>  
>  	ioapic_write_reg(version_offset, data_write);
> -	report("version register read only test",
> -	       data_read == ioapic_read_reg(version_offset));
> +	report(data_read == ioapic_read_reg(version_offset),
> +	       "version register read only test");
>  }
>  
>  static void ioapic_reg_id(void)
> @@ -38,8 +38,7 @@ static void ioapic_reg_id(void)
>  	ioapic_write_reg(id_offset, data_write);
>  
>  	diff = data_read ^ ioapic_read_reg(id_offset);
> -	report("id register only bits [24:27] writable",
> -	       diff == 0x0f000000);
> +	report(diff == 0x0f000000, "id register only bits [24:27] writable");
>  }
>  
>  static void ioapic_arbitration_id(void)
> @@ -52,12 +51,12 @@ static void ioapic_arbitration_id(void)
>  	write = 0x0f000000;
>  
>  	ioapic_write_reg(id_offset, write);
> -	report("arbitration register set by id",
> -	       ioapic_read_reg(arb_offset) == write);
> +	report(ioapic_read_reg(arb_offset) == write,
> +	       "arbitration register set by id");
>  
>  	ioapic_write_reg(arb_offset, 0x0);
> -	report("arbtration register read only",
> -               ioapic_read_reg(arb_offset) == write);
> +	report(ioapic_read_reg(arb_offset) == write,
> +	       "arbtration register read only");
>  }
>  
>  static volatile int g_isr_76;
> @@ -74,7 +73,7 @@ static void test_ioapic_edge_intr(void)
>  	ioapic_set_redir(0x0e, 0x76, TRIGGER_EDGE);
>  	toggle_irq_line(0x0e);
>  	asm volatile ("nop");
> -	report("edge triggered intr", g_isr_76 == 1);
> +	report(g_isr_76 == 1, "edge triggered intr");
>  }
>  
>  static volatile int g_isr_77;
> @@ -92,7 +91,7 @@ static void test_ioapic_level_intr(void)
>  	ioapic_set_redir(0x0e, 0x77, TRIGGER_LEVEL);
>  	set_irq_line(0x0e, 1);
>  	asm volatile ("nop");
> -	report("level triggered intr", g_isr_77 == 1);
> +	report(g_isr_77 == 1, "level triggered intr");
>  }
>  
>  static int g_78, g_66, g_66_after_78;
> @@ -125,8 +124,8 @@ static void test_ioapic_simultaneous(void)
>  	toggle_irq_line(0x0e);
>  	irq_enable();
>  	asm volatile ("nop");
> -	report("ioapic simultaneous edge interrupts",
> -	       g_66 && g_78 && g_66_after_78 && g_66_rip == g_78_rip);
> +	report(g_66 && g_78 && g_66_after_78 && g_66_rip == g_78_rip,
> +	       "ioapic simultaneous edge interrupts");
>  }
>  
>  static volatile int g_tmr_79 = -1;
> @@ -147,8 +146,8 @@ static void test_ioapic_edge_tmr(bool expected_tmr_before)
>  	tmr_before = apic_read_bit(APIC_TMR, 0x79);
>  	toggle_irq_line(0x0e);
>  	asm volatile ("nop");
> -	report("TMR for ioapic edge interrupts (expected %s)",
> -	       tmr_before == expected_tmr_before && !g_tmr_79,
> +	report(tmr_before == expected_tmr_before && !g_tmr_79,
> +	       "TMR for ioapic edge interrupts (expected %s)",
>  	       expected_tmr_before ? "true" : "false");
>  }
>  
> @@ -161,8 +160,8 @@ static void test_ioapic_level_tmr(bool expected_tmr_before)
>  	tmr_before = apic_read_bit(APIC_TMR, 0x79);
>  	set_irq_line(0x0e, 1);
>  	asm volatile ("nop");
> -	report("TMR for ioapic level interrupts (expected %s)",
> -	       tmr_before == expected_tmr_before && g_tmr_79,
> +	report(tmr_before == expected_tmr_before && g_tmr_79,
> +	       "TMR for ioapic level interrupts (expected %s)",
>  	       expected_tmr_before ? "true" : "false");
>  }
>  
> @@ -187,8 +186,8 @@ static void test_ioapic_edge_tmr_smp(bool expected_tmr_before)
>  	i = 0;
>  	while(g_tmr_79 == -1) i++;
>  	printf("%d iterations before interrupt received\n", i);
> -	report("TMR for ioapic edge interrupts (expected %s)",
> -	       tmr_before == expected_tmr_before && !g_tmr_79,
> +	report(tmr_before == expected_tmr_before && !g_tmr_79,
> +	       "TMR for ioapic edge interrupts (expected %s)",
>  	       expected_tmr_before ? "true" : "false");
>  }
>  
> @@ -212,8 +211,8 @@ static void test_ioapic_level_tmr_smp(bool expected_tmr_before)
>  	i = 0;
>  	while(g_tmr_79 == -1) i++;
>  	printf("%d iterations before interrupt received\n", i);
> -	report("TMR for ioapic level interrupts (expected %s)",
> -	       tmr_before == expected_tmr_before && g_tmr_79,
> +	report(tmr_before == expected_tmr_before && g_tmr_79,
> +	       "TMR for ioapic level interrupts (expected %s)",
>  	       expected_tmr_before ? "true" : "false");
>  }
>  
> @@ -236,7 +235,7 @@ static void test_ioapic_level_coalesce(void)
>  	ioapic_set_redir(0x0e, 0x98, TRIGGER_LEVEL);
>  	set_irq_line(0x0e, 1);
>  	asm volatile ("nop");
> -	report("coalesce simultaneous level interrupts", g_isr_98 == 1);
> +	report(g_isr_98 == 1, "coalesce simultaneous level interrupts");
>  }
>  
>  static int g_isr_99;
> @@ -255,7 +254,7 @@ static void test_ioapic_level_sequential(void)
>  	set_irq_line(0x0e, 1);
>  	set_irq_line(0x0e, 1);
>  	asm volatile ("nop");
> -	report("sequential level interrupts", g_isr_99 == 2);
> +	report(g_isr_99 == 2, "sequential level interrupts");
>  }
>  
>  static volatile int g_isr_9a;
> @@ -287,7 +286,7 @@ static void test_ioapic_level_retrigger(void)
>  
>  	asm volatile ("sti");
>  
> -	report("retriggered level interrupts without masking", g_isr_9a == 2);
> +	report(g_isr_9a == 2, "retriggered level interrupts without masking");
>  }
>  
>  static volatile int g_isr_81;
> @@ -309,13 +308,13 @@ static void test_ioapic_edge_mask(void)
>  	set_irq_line(0x0e, 0);
>  
>  	asm volatile ("nop");
> -	report("masked level interrupt", g_isr_81 == 0);
> +	report(g_isr_81 == 0, "masked level interrupt");
>  
>  	set_mask(0x0e, false);
>  	set_irq_line(0x0e, 1);
>  
>  	asm volatile ("nop");
> -	report("unmasked level interrupt", g_isr_81 == 1);
> +	report(g_isr_81 == 1, "unmasked level interrupt");
>  }
>  
>  static volatile int g_isr_82;
> @@ -336,12 +335,12 @@ static void test_ioapic_level_mask(void)
>  	set_irq_line(0x0e, 1);
>  
>  	asm volatile ("nop");
> -	report("masked level interrupt", g_isr_82 == 0);
> +	report(g_isr_82 == 0, "masked level interrupt");
>  
>  	set_mask(0x0e, false);
>  
>  	asm volatile ("nop");
> -	report("unmasked level interrupt", g_isr_82 == 1);
> +	report(g_isr_82 == 1, "unmasked level interrupt");
>  }
>  
>  static volatile int g_isr_83;
> @@ -362,7 +361,7 @@ static void test_ioapic_level_retrigger_mask(void)
>  	asm volatile ("nop");
>  	set_mask(0x0e, false);
>  	asm volatile ("nop");
> -	report("retriggered level interrupts with mask", g_isr_83 == 2);
> +	report(g_isr_83 == 2, "retriggered level interrupts with mask");
>  
>  	set_irq_line(0x0e, 0);
>  	set_mask(0x0e, false);
> @@ -402,7 +401,7 @@ static void test_ioapic_self_reconfigure(void)
>  	ioapic_write_redir(0xe, e);
>  	set_irq_line(0x0e, 1);
>  	e = ioapic_read_redir(0xe);
> -	report("Reconfigure self", g_isr_84 == 1 && e.remote_irr == 0);
> +	report(g_isr_84 == 1 && e.remote_irr == 0, "Reconfigure self");
>  }
>  
>  
> diff --git a/x86/memory.c b/x86/memory.c
> index 4f8949b..22c50c9 100644
> --- a/x86/memory.c
> +++ b/x86/memory.c
> @@ -36,21 +36,21 @@ int main(int ac, char **av)
>  	expected = !this_cpu_has(X86_FEATURE_CLFLUSH); /* CLFLUSH */
>  	ud = 0;
>  	asm volatile("clflush (%0)" : : "b" (&target));
> -	report("clflush (%s)", ud == expected, expected ? "ABSENT" : "present");
> +	report(ud == expected, "clflush (%s)", expected ? "ABSENT" : "present");
>  
>  	expected = !this_cpu_has(X86_FEATURE_XMM); /* SSE */
>  	ud = 0;
>  	asm volatile("sfence");
> -	report("sfence (%s)", ud == expected, expected ? "ABSENT" : "present");
> +	report(ud == expected, "sfence (%s)", expected ? "ABSENT" : "present");
>  
>  	expected = !this_cpu_has(X86_FEATURE_XMM2); /* SSE2 */
>  	ud = 0;
>  	asm volatile("lfence");
> -	report("lfence (%s)", ud == expected, expected ? "ABSENT" : "present");
> +	report(ud == expected, "lfence (%s)", expected ? "ABSENT" : "present");
>  
>  	ud = 0;
>  	asm volatile("mfence");
> -	report("mfence (%s)", ud == expected, expected ? "ABSENT" : "present");
> +	report(ud == expected, "mfence (%s)", expected ? "ABSENT" : "present");
>  
>  	/* 4-byte instructions: */
>  	isize = 4;
> @@ -59,26 +59,27 @@ int main(int ac, char **av)
>  	ud = 0;
>  	/* clflushopt (%rbx): */
>  	asm volatile(".byte 0x66, 0x0f, 0xae, 0x3b" : : "b" (&target));
> -	report("clflushopt (%s)", ud == expected, expected ? "ABSENT" : "present");
> +	report(ud == expected, "clflushopt (%s)",
> +	       expected ? "ABSENT" : "present");
>  
>  	expected = !this_cpu_has(X86_FEATURE_CLWB); /* CLWB */
>  	ud = 0;
>  	/* clwb (%rbx): */
>  	asm volatile(".byte 0x66, 0x0f, 0xae, 0x33" : : "b" (&target));
> -	report("clwb (%s)", ud == expected, expected ? "ABSENT" : "present");
> +	report(ud == expected, "clwb (%s)", expected ? "ABSENT" : "present");
>  
>  	ud = 0;
>  	/* clwb requires a memory operand, the following is NOT a valid
>  	 * CLWB instruction (modrm == 0xF0).
>  	 */
>  	asm volatile(".byte 0x66, 0x0f, 0xae, 0xf0");
> -	report("invalid clwb", ud);
> +	report(ud, "invalid clwb");
>  
>  	expected = !this_cpu_has(X86_FEATURE_PCOMMIT); /* PCOMMIT */
>  	ud = 0;
>  	/* pcommit: */
>  	asm volatile(".byte 0x66, 0x0f, 0xae, 0xf8");
> -	report("pcommit (%s)", ud == expected, expected ? "ABSENT" : "present");
> +	report(ud == expected, "pcommit (%s)", expected ? "ABSENT" : "present");
>  
>  	return report_summary();
>  }
> diff --git a/x86/msr.c b/x86/msr.c
> index beb321f..de2cb6d 100644
> --- a/x86/msr.c
> +++ b/x86/msr.c
> @@ -91,7 +91,7 @@ static void test_msr_rw(int msr_index, unsigned long long input, unsigned long l
>          printf("testing %s: output = %#x:%#x expected = %#x:%#x\n", sptr,
>                 (u32)(r >> 32), (u32)r, (u32)(expected >> 32), (u32)expected);
>      }
> -    report("%s", expected == r, sptr);
> +    report(expected == r, "%s", sptr);
>  }
>  
>  int main(int ac, char **av)
> diff --git a/x86/pcid.c b/x86/pcid.c
> index 273e96b..ad9d30c 100644
> --- a/x86/pcid.c
> +++ b/x86/pcid.c
> @@ -29,7 +29,7 @@ static int invpcid_checking(unsigned long type, void *desc)
>  static void test_cpuid_consistency(int pcid_enabled, int invpcid_enabled)
>  {
>      int passed = !(!pcid_enabled && invpcid_enabled);
> -    report("CPUID consistency", passed);
> +    report(passed, "CPUID consistency");
>  }
>  
>  static void test_pcid_enabled(void)
> @@ -56,7 +56,7 @@ static void test_pcid_enabled(void)
>      passed = 1;
>  
>  report:
> -    report("Test on PCID when enabled", passed);
> +    report(passed, "Test on PCID when enabled");
>  }
>  
>  static void test_pcid_disabled(void)
> @@ -71,7 +71,7 @@ static void test_pcid_disabled(void)
>      passed = 1;
>  
>  report:
> -    report("Test on PCID when disabled", passed);
> +    report(passed, "Test on PCID when disabled");
>  }
>  
>  static void test_invpcid_enabled(void)
> @@ -108,7 +108,7 @@ static void test_invpcid_enabled(void)
>      passed = 1;
>  
>  report:
> -    report("Test on INVPCID when enabled", passed);
> +    report(passed, "Test on INVPCID when enabled");
>  }
>  
>  static void test_invpcid_disabled(void)
> @@ -123,7 +123,7 @@ static void test_invpcid_disabled(void)
>      passed = 1;
>  
>  report:
> -    report("Test on INVPCID when disabled", passed);
> +    report(passed, "Test on INVPCID when disabled");
>  }
>  
>  int main(int ac, char **av)
> diff --git a/x86/pku.c b/x86/pku.c
> index 62fb261..90915e9 100644
> --- a/x86/pku.c
> +++ b/x86/pku.c
> @@ -95,42 +95,48 @@ int main(int ac, char **av)
>      set_cr0_wp(1);
>      write_pkru(pkru_ad);
>      test = 21;
> -    report("write to supervisor page when pkru is ad and wp == 1", pf_count == 0 && test == 21);
> +    report(pf_count == 0 && test == 21,
> +           "write to supervisor page when pkru is ad and wp == 1");
>  
>      init_test();
>      set_cr0_wp(0);
>      write_pkru(pkru_ad);
>      test = 22;
> -    report("write to supervisor page when pkru is ad and wp == 0", pf_count == 0 && test == 22);
> +    report(pf_count == 0 && test == 22,
> +           "write to supervisor page when pkru is ad and wp == 0");
>  
>      init_test();
>      set_cr0_wp(1);
>      write_pkru(pkru_wd);
>      test = 23;
> -    report("write to supervisor page when pkru is wd and wp == 1", pf_count == 0 && test == 23);
> +    report(pf_count == 0 && test == 23,
> +           "write to supervisor page when pkru is wd and wp == 1");
>  
>      init_test();
>      set_cr0_wp(0);
>      write_pkru(pkru_wd);
>      test = 24;
> -    report("write to supervisor page when pkru is wd and wp == 0", pf_count == 0 && test == 24);
> +    report(pf_count == 0 && test == 24,
> +           "write to supervisor page when pkru is wd and wp == 0");
>  
>      init_test();
>      write_pkru(pkru_wd);
>      set_cr0_wp(0);
>      USER_VAR(test) = 25;
> -    report("write to user page when pkru is wd and wp == 0", pf_count == 0 && test == 25);
> +    report(pf_count == 0 && test == 25,
> +           "write to user page when pkru is wd and wp == 0");
>  
>      init_test();
>      write_pkru(pkru_wd);
>      set_cr0_wp(1);
>      USER_VAR(test) = 26;
> -    report("write to user page when pkru is wd and wp == 1", pf_count == 1 && test == 26 && save == 25);
> +    report(pf_count == 1 && test == 26 && save == 25,
> +           "write to user page when pkru is wd and wp == 1");
>  
>      init_test();
>      write_pkru(pkru_ad);
>      (void)USER_VAR(test);
> -    report("read from user page when pkru is ad", pf_count == 1 && save == 26);
> +    report(pf_count == 1 && save == 26, "read from user page when pkru is ad");
>  
>      // TODO: implicit kernel access from ring 3 (e.g. int)
>  
> diff --git a/x86/pmu.c b/x86/pmu.c
> index cb8c9e3..a4e483b 100644
> --- a/x86/pmu.c
> +++ b/x86/pmu.c
> @@ -234,7 +234,7 @@ static void check_gp_counter(struct pmu_event *evt)
>  	for (i = 0; i < num_counters; i++, cnt.ctr++) {
>  		cnt.count = 0;
>  		measure(&cnt, 1);
> -		report("%s-%d", verify_event(cnt.count, evt), evt->name, i);
> +		report(verify_event(cnt.count, evt), "%s-%d", evt->name, i);
>  	}
>  }
>  
> @@ -261,7 +261,8 @@ static void check_fixed_counters(void)
>  		cnt.count = 0;
>  		cnt.ctr = fixed_events[i].unit_sel;
>  		measure(&cnt, 1);
> -		report("fixed-%d", verify_event(cnt.count, &fixed_events[i]), i);
> +		report(verify_event(cnt.count, &fixed_events[i]), "fixed-%d",
> +		       i);
>  	}
>  }
>  
> @@ -293,7 +294,7 @@ static void check_counters_many(void)
>  		if (!verify_counter(&cnt[i]))
>  			break;
>  
> -	report("all counters", i == n);
> +	report(i == n, "all counters");
>  }
>  
>  static void check_counter_overflow(void)
> @@ -330,13 +331,13 @@ static void check_counter_overflow(void)
>  			cnt.config &= ~EVNTSEL_INT;
>  		idx = event_to_global_idx(&cnt);
>  		measure(&cnt, 1);
> -		report("cntr-%d", cnt.count == 1, i);
> +		report(cnt.count == 1, "cntr-%d", i);
>  		status = rdmsr(MSR_CORE_PERF_GLOBAL_STATUS);
> -		report("status-%d", status & (1ull << idx), i);
> +		report(status & (1ull << idx), "status-%d", i);
>  		wrmsr(MSR_CORE_PERF_GLOBAL_OVF_CTRL, status);
>  		status = rdmsr(MSR_CORE_PERF_GLOBAL_STATUS);
> -		report("status clear-%d", !(status & (1ull << idx)), i);
> -		report("irq-%d", check_irq() == (i % 2), i);
> +		report(!(status & (1ull << idx)), "status clear-%d", i);
> +		report(check_irq() == (i % 2), "irq-%d", i);
>  	}
>  
>  	report_prefix_pop();
> @@ -351,7 +352,7 @@ static void check_gp_counter_cmask(void)
>  	};
>  	cnt.config |= (0x2 << EVNTSEL_CMASK_SHIFT);
>  	measure(&cnt, 1);
> -	report("cmask", cnt.count < gp_events[1].min);
> +	report(cnt.count < gp_events[1].min, "cmask");
>  }
>  
>  static void do_rdpmc_fast(void *ptr)
> @@ -391,13 +392,13 @@ static void check_rdpmc(void)
>  		x &= (1ull << eax.split.bit_width) - 1;
>  
>  		wrmsr(MSR_IA32_PERFCTR0 + i, val);
> -		report("cntr-%d", rdpmc(i) == x, i);
> +		report(rdpmc(i) == x, "cntr-%d", i);
>  
>  		exc = test_for_exception(GP_VECTOR, do_rdpmc_fast, &cnt);
>  		if (exc)
>  			report_skip("fast-%d", i);
>  		else
> -			report("fast-%d", cnt.count == (u32)val, i);
> +			report(cnt.count == (u32)val, "fast-%d", i);
>  	}
>  	for (i = 0; i < edx.split.num_counters_fixed; i++) {
>  		uint64_t x = val & ((1ull << edx.split.bit_width_fixed) - 1);
> @@ -407,13 +408,13 @@ static void check_rdpmc(void)
>  		};
>  
>  		wrmsr(MSR_CORE_PERF_FIXED_CTR0 + i, x);
> -		report("fixed cntr-%d", rdpmc(i | (1 << 30)) == x, i);
> +		report(rdpmc(i | (1 << 30)) == x, "fixed cntr-%d", i);
>  
>  		exc = test_for_exception(GP_VECTOR, do_rdpmc_fast, &cnt);
>  		if (exc)
>  			report_skip("fixed fast-%d", i);
>  		else
> -			report("fixed fast-%d", cnt.count == (u32)x, i);
> +			report(cnt.count == (u32)x, "fixed fast-%d", i);
>  	}
>  
>  	report_prefix_pop();
> diff --git a/x86/rdpru.c b/x86/rdpru.c
> index 3cdb2d6..127ba1c 100644
> --- a/x86/rdpru.c
> +++ b/x86/rdpru.c
> @@ -19,7 +19,7 @@ int main(int ac, char **av)
>  	if (this_cpu_has(X86_FEATURE_RDPRU))
>  		report_skip("RDPRU raises #UD");
>  	else
> -		report("RDPRU raises #UD", rdpru_checking() == UD_VECTOR);
> +		report(rdpru_checking() == UD_VECTOR, "RDPRU raises #UD");
>  
>  	return report_summary();
>  }
> diff --git a/x86/smap.c b/x86/smap.c
> index c0376e3..59cca53 100644
> --- a/x86/smap.c
> +++ b/x86/smap.c
> @@ -70,14 +70,16 @@ static void check_smap_nowp(void)
>  
>  	init_test(0);
>  	USER_VAR(test) = 0x99;
> -	report("write from user page with SMAP=0, AC=0, WP=0, PTE.U=1 && PTE.W=0", pf_count == 0);
> +	report(pf_count == 0,
> +	       "write from user page with SMAP=0, AC=0, WP=0, PTE.U=1 && PTE.W=0");
>  
>  	write_cr4(read_cr4() | X86_CR4_SMAP);
>  	write_cr3(read_cr3());
>  
>  	init_test(0);
>  	(void)USER_VAR(test);
> -	report("read from user page with SMAP=1, AC=0, WP=0, PTE.U=1 && PTE.W=0", pf_count == 1 && save == 0x99);
> +	report(pf_count == 1 && save == 0x99,
> +	       "read from user page with SMAP=1, AC=0, WP=0, PTE.U=1 && PTE.W=0");
>  
>  	/* Undo changes */
>  	*get_pte(phys_to_virt(read_cr3()), USER_ADDR(test)) |= PT_WRITABLE_MASK;
> @@ -124,28 +126,32 @@ int main(int ac, char **av)
>  		init_test(i);
>  		clac();
>  		test = 42;
> -		report("write to supervisor page", pf_count == 0 && test == 42);
> +		report(pf_count == 0 && test == 42,
> +		       "write to supervisor page");
>  
>  		init_test(i);
>  		stac();
>  		(void)USER_VAR(test);
> -		report("read from user page with AC=1", pf_count == 0);
> +		report(pf_count == 0, "read from user page with AC=1");
>  
>  		init_test(i);
>  		clac();
>  		(void)USER_VAR(test);
> -		report("read from user page with AC=0", pf_count == 1 && save == 42);
> +		report(pf_count == 1 && save == 42,
> +		       "read from user page with AC=0");
>  
>  		init_test(i);
>  		stac();
>  		save = 0;
>  		USER_VAR(test) = 43;
> -		report("write to user page with AC=1", pf_count == 0 && test == 43);
> +		report(pf_count == 0 && test == 43,
> +		       "write to user page with AC=1");
>  
>  		init_test(i);
>  		clac();
>  		USER_VAR(test) = 44;
> -		report("read from user page with AC=0", pf_count == 1 && test == 44 && save == 43);
> +		report(pf_count == 1 && test == 44 && save == 43,
> +		       "read from user page with AC=0");
>  
>  		init_test(i);
>  		stac();
> @@ -156,7 +162,8 @@ int main(int ac, char **av)
>  		    "and $~(" xstr(USER_BASE) "), %"R "sp \n"
>  		    "pop %"R "ax\n"
>  		    "movl %eax, test");
> -		report("write to user stack with AC=1", pf_count == 0 && test == 44);
> +		report(pf_count == 0 && test == 44,
> +		       "write to user stack with AC=1");
>  
>  		init_test(i);
>  		clac();
> @@ -167,7 +174,8 @@ int main(int ac, char **av)
>  		    "and $~(" xstr(USER_BASE) "), %"R "sp \n"
>  		    "pop %"R "ax\n"
>  		    "movl %eax, test");
> -		report("write to user stack with AC=0", pf_count == 1 && test == 45 && save == -1);
> +		report(pf_count == 1 && test == 45 && save == -1,
> +		       "write to user stack with AC=0");
>  
>  		/* This would be trapped by SMEP */
>  		init_test(i);
> @@ -175,7 +183,7 @@ int main(int ac, char **av)
>  		asm("jmp 1f + "xstr(USER_BASE)" \n"
>  		    "1: jmp 2f - "xstr(USER_BASE)" \n"
>  		    "2:");
> -		report("executing on user page with AC=0", pf_count == 0);
> +		report(pf_count == 0, "executing on user page with AC=0");
>  	}
>  
>  	check_smap_nowp();
> diff --git a/x86/smptest.c b/x86/smptest.c
> index 2d271e7..1b0ae3e 100644
> --- a/x86/smptest.c
> +++ b/x86/smptest.c
> @@ -26,6 +26,6 @@ int main(void)
>      for (i = 0; i < ncpus; ++i)
>  	on_cpu(i, ipi_test, (void *)(long)i);
>  
> -    report("IPI to each CPU", nipis == ncpus);
> +    report(nipis == ncpus, "IPI to each CPU");
>      return report_summary();
>  }
> diff --git a/x86/svm.c b/x86/svm.c
> index 4ddfaa4..dfac4de 100644
> --- a/x86/svm.c
> +++ b/x86/svm.c
> @@ -285,7 +285,7 @@ static void test_run(struct test *test, struct vmcb *vmcb)
>          ++test->exits;
>      } while (!test->finished(test));
>  
> -    report("%s", test->succeeded(test), test->name);
> +    report(test->succeeded(test), "%s", test->name);
>  }
>  
>  static bool smp_supported(void)
> @@ -434,7 +434,7 @@ static void test_dr_intercept(struct test *test)
>          }
>  
>          if (test->scratch != i) {
> -            report("dr%u read intercept", false, i);
> +            report(false, "dr%u read intercept", i);
>              failcnt++;
>          }
>      }
> @@ -470,7 +470,7 @@ static void test_dr_intercept(struct test *test)
>          }
>  
>          if (test->scratch != i) {
> -            report("dr%u write intercept", false, i);
> +            report(false, "dr%u write intercept", i);
>              failcnt++;
>          }
>      }
> @@ -568,7 +568,7 @@ static void test_msr_intercept(struct test *test)
>  
>          /* Check that a read intercept occurred for MSR at msr_index */
>          if (test->scratch != msr_index)
> -            report("MSR 0x%lx read intercept", false, msr_index);
> +            report(false, "MSR 0x%lx read intercept", msr_index);
>  
>          /*
>           * Poor man approach to generate a value that
> @@ -580,7 +580,7 @@ static void test_msr_intercept(struct test *test)
>  
>          /* Check that a write intercept occurred for MSR with msr_value */
>          if (test->scratch != msr_value)
> -            report("MSR 0x%lx write intercept", false, msr_index);
> +            report(false, "MSR 0x%lx write intercept", msr_index);
>      }
>  
>      test->scratch = -2;
> @@ -848,7 +848,7 @@ static void test_ioio(struct test *test)
>      return;
>  
>  fail:
> -    report("stage %d", false, get_test_stage(test));
> +    report(false, "stage %d", get_test_stage(test));
>      test->scratch = -1;
>  }
>  
> @@ -923,7 +923,7 @@ static void sel_cr0_bug_test(struct test *test)
>       * are not in guest-mode anymore so we can't trigger an intercept.
>       * Trigger a tripple-fault for now.
>       */
> -    report("sel_cr0 test. Can not recover from this - exiting", false);
> +    report(false, "sel_cr0 test. Can not recover from this - exiting");
>      exit(report_summary());
>  }
>  
> diff --git a/x86/syscall.c b/x86/syscall.c
> index e2d6514..b4f5ac0 100644
> --- a/x86/syscall.c
> +++ b/x86/syscall.c
> @@ -17,7 +17,7 @@ static void test_syscall_lazy_load(void)
>      asm volatile("pushf; syscall; syscall_target: popf" : "=c"(tmp) : : "r11");
>      write_ss(ss);
>      // will crash horribly if broken
> -    report("MSR_*STAR eager loading", true);
> +    report(true, "MSR_*STAR eager loading");
>  }
>  
>  /*
> @@ -95,7 +95,7 @@ static void test_syscall_tf(void)
>      if (code_segment_upon_db != USER_CS32) {
>          printf("wrong CS (%#04x)!\n", code_segment_upon_db);
>      }
> -    report("syscall TF handling", code_segment_upon_db == USER_CS32);
> +    report(code_segment_upon_db == USER_CS32, "syscall TF handling");
>  }
>  
>  int main(int ac, char **av)
> diff --git a/x86/taskswitch2.c b/x86/taskswitch2.c
> index 0badaf5..4dc6337 100644
> --- a/x86/taskswitch2.c
> +++ b/x86/taskswitch2.c
> @@ -124,7 +124,7 @@ static void test_kernel_mode_int(void)
>  	printf("Triggering nmi 2\n");
>  	asm volatile ("int $2");
>  	printf("Return from nmi %d\n", test_count);
> -	report("NMI int $2", test_count == 1);
> +	report(test_count == 1, "NMI int $2");
>  
>  	/* test that external NMI triggers task gate */
>  	test_count = 0;
> @@ -133,7 +133,7 @@ static void test_kernel_mode_int(void)
>  	apic_icr_write(APIC_DEST_PHYSICAL | APIC_DM_NMI | APIC_INT_ASSERT, 0);
>  	io_delay();
>  	printf("Return from APIC nmi\n");
> -	report("NMI external", test_count == 1);
> +	report(test_count == 1, "NMI external");
>  
>  	/* test that external interrupt triggesr task gate */
>  	test_count = 0;
> @@ -144,7 +144,7 @@ static void test_kernel_mode_int(void)
>  	io_delay();
>  	irq_disable();
>  	printf("Return from APIC IRQ\n");
> -	report("IRQ external", test_count == 1);
> +	report(test_count == 1, "IRQ external");
>  
>  	/* test that HW exception triggesr task gate */
>  	set_intr_task_gate(0, de_tss);
> @@ -152,7 +152,7 @@ static void test_kernel_mode_int(void)
>  	asm volatile ("divl %3": "=a"(res)
>  		      : "d"(0), "a"(1500), "m"(test_divider));
>  	printf("Result is %d\n", res);
> -	report("DE exeption", res == 150);
> +	report(res == 150, "DE exeption");
>  
>  	/* test if call HW exeption DE by int $0 triggers task gate */
>  	test_count = 0;
> @@ -160,7 +160,7 @@ static void test_kernel_mode_int(void)
>  	printf("Call int 0\n");
>  	asm volatile ("int $0");
>  	printf("Return from int 0\n");
> -	report("int $0", test_count == 1);
> +	report(test_count == 1, "int $0");
>  
>  	/* test if HW exception OF triggers task gate */
>  	test_count = 0;
> @@ -168,7 +168,7 @@ static void test_kernel_mode_int(void)
>  	printf("Call into\n");
>  	asm volatile ("addb $127, %b0\ninto"::"a"(127));
>  	printf("Return from into\n");
> -	report("OF exeption", test_count);
> +	report(test_count, "OF exeption");
>  
>  	/* test if HW exception BP triggers task gate */
>  	test_count = 0;
> @@ -176,7 +176,7 @@ static void test_kernel_mode_int(void)
>  	printf("Call int 3\n");
>  	asm volatile ("int $3");
>  	printf("Return from int 3\n");
> -	report("BP exeption", test_count == 1);
> +	report(test_count == 1, "BP exeption");
>  
>  	/*
>  	 * test that PF triggers task gate and error code is placed on
> @@ -189,7 +189,7 @@ static void test_kernel_mode_int(void)
>  	printf("Access unmapped page\n");
>  	*fault_addr = 0;
>  	printf("Return from pf tss\n");
> -	report("PF exeption", test_count == 1);
> +	report(test_count == 1, "PF exeption");
>  }
>  
>  static void test_gdt_task_gate(void)
> @@ -202,12 +202,12 @@ static void test_gdt_task_gate(void)
>  	   incorrect instruction length calculation */
>  	asm volatile("lcall $" xstr(TSS_INTR) ", $0xf4f4f4f4");
>  	printf("Return from call\n");
> -	report("lcall", test_count == 1);
> +	report(test_count == 1, "lcall");
>  
>  	/* call the same task again and check that it restarted after iret */
>  	test_count = 0;
>  	asm volatile("lcall $" xstr(TSS_INTR) ", $0xf4f4f4f4");
> -	report("lcall2", test_count == 2);
> +	report(test_count == 2, "lcall2");
>  
>  	/* test that calling a task by ljmp works */
>  	test_count = 0;
> @@ -215,7 +215,7 @@ static void test_gdt_task_gate(void)
>  	printf("Jumping to a task by ljmp\n");
>  	asm volatile ("ljmp $" xstr(TSS_INTR) ", $0xf4f4f4f4");
>  	printf("Jump back succeeded\n");
> -	report("ljmp", test_count == 1);
> +	report(test_count == 1, "ljmp");
>  }
>  
>  static void test_vm86_switch(void)
> @@ -260,7 +260,7 @@ static void test_vm86_switch(void)
>          "popf\n"
>          "iret\n"
>      );
> -    report("VM86", 1);
> +    report(1, "VM86");
>  }
>  
>  #define IOPL_SHIFT 12
> @@ -277,7 +277,7 @@ static void test_conforming_switch(void)
>  	tss_intr.eflags |= 3 << IOPL_SHIFT;
>  	set_gdt_entry(CONFORM_CS_SEL, 0, 0xffffffff, 0x9f, 0xc0);
>  	asm volatile("lcall $" xstr(TSS_INTR) ", $0xf4f4f4f4");
> -	report("lcall with cs.rpl != cs.dpl", test_count == 1);
> +	report(test_count == 1, "lcall with cs.rpl != cs.dpl");
>  }
>  
>  int main(void)
> diff --git a/x86/tsc.c b/x86/tsc.c
> index b56d578..bc403fc 100644
> --- a/x86/tsc.c
> +++ b/x86/tsc.c
> @@ -16,7 +16,7 @@ static void test_rdtscp(u64 aux)
>  
>         wrmsr(MSR_TSC_AUX, aux);
>         rdtscp(&ecx);
> -       report("Test RDTSCP %" PRIu64, ecx == aux, aux);
> +       report(ecx == aux, "Test RDTSCP %" PRIu64, aux);
>  }
>  
>  static void test_rdpid(u64 aux)
> @@ -25,7 +25,7 @@ static void test_rdpid(u64 aux)
>  
>         wrmsr(MSR_TSC_AUX, aux);
>         asm (".byte 0xf3, 0x0f, 0xc7, 0xf8" : "=a" (eax));
> -       report("Test rdpid %%eax %" PRId64, eax == aux, aux);
> +       report(eax == aux, "Test rdpid %%eax %" PRId64, aux);
>  }
>  
>  int main(void)
> diff --git a/x86/tsc_adjust.c b/x86/tsc_adjust.c
> index 76cb5ee..1f26b7a 100644
> --- a/x86/tsc_adjust.c
> +++ b/x86/tsc_adjust.c
> @@ -7,20 +7,20 @@ int main(void)
>  	u64 est_delta_time;
>  
>  	if (this_cpu_has(X86_FEATURE_TSC_ADJUST)) { // MSR_IA32_TSC_ADJUST Feature is enabled?
> -		report("MSR_IA32_TSC_ADJUST msr initialization",
> -				rdmsr(MSR_IA32_TSC_ADJUST) == 0x0);
> +		report(rdmsr(MSR_IA32_TSC_ADJUST) == 0x0,
> +		       "MSR_IA32_TSC_ADJUST msr initialization");
>  		t3 = 100000000000ull;
>  		t1 = rdtsc();
>  		wrmsr(MSR_IA32_TSC_ADJUST, t3);
>  		t2 = rdtsc();
> -		report("MSR_IA32_TSC_ADJUST msr read / write",
> -				rdmsr(MSR_IA32_TSC_ADJUST) == t3);
> -		report("TSC adjustment for MSR_IA32_TSC_ADJUST value",
> -				(t2 - t1) >= t3);
> +		report(rdmsr(MSR_IA32_TSC_ADJUST) == t3,
> +		       "MSR_IA32_TSC_ADJUST msr read / write");
> +		report((t2 - t1) >= t3,
> +		       "TSC adjustment for MSR_IA32_TSC_ADJUST value");
>  		t3 = 0x0;
>  		wrmsr(MSR_IA32_TSC_ADJUST, t3);
> -		report("MSR_IA32_TSC_ADJUST msr read / write",
> -				rdmsr(MSR_IA32_TSC_ADJUST) == t3);
> +		report(rdmsr(MSR_IA32_TSC_ADJUST) == t3,
> +		       "MSR_IA32_TSC_ADJUST msr read / write");
>  		t4 = 100000000000ull;
>  		t1 = rdtsc();
>  		wrtsc(t4);
> @@ -30,11 +30,11 @@ int main(void)
>  		// (based on MSR_IA32_TSC_ADJUST msr value) should be small
>  		est_delta_time = t4 - t5 - t1;
>  		// arbitray 2x latency (wrtsc->rdtsc) threshold
> -		report("MSR_IA32_TSC_ADJUST msr adjustment on tsc write",
> -				est_delta_time <= (2 * (t2 - t4)));
> +		report(est_delta_time <= (2 * (t2 - t4)),
> +		       "MSR_IA32_TSC_ADJUST msr adjustment on tsc write");
>  	}
>  	else {
> -		report("MSR_IA32_TSC_ADJUST feature not enabled", true);
> +		report(true, "MSR_IA32_TSC_ADJUST feature not enabled");
>  	}
>  	return report_summary();
>  }
> diff --git a/x86/tscdeadline_latency.c b/x86/tscdeadline_latency.c
> index b320252..4e6ac18 100644
> --- a/x86/tscdeadline_latency.c
> +++ b/x86/tscdeadline_latency.c
> @@ -34,7 +34,7 @@ static void test_lapic_existence(void)
>  
>      lvr = apic_read(APIC_LVR);
>      printf("apic version: %x\n", lvr);
> -    report("apic existence", (u16)lvr == 0x14);
> +    report((u16)lvr == 0x14, "apic existence");
>  }
>  
>  #define TSC_DEADLINE_TIMER_VECTOR 0xef
> diff --git a/x86/umip.c b/x86/umip.c
> index 06ee633..7eee294 100644
> --- a/x86/umip.c
> +++ b/x86/umip.c
> @@ -73,18 +73,18 @@ static void test_umip_nogp(const char *msg)
>      puts(msg);
>  
>      do_smsw();
> -    report("no exception from smsw", gp_count == 0);
> +    report(gp_count == 0, "no exception from smsw");
>      do_sgdt();
> -    report("no exception from sgdt", gp_count == 0);
> +    report(gp_count == 0, "no exception from sgdt");
>      do_sidt();
> -    report("no exception from sidt", gp_count == 0);
> +    report(gp_count == 0, "no exception from sidt");
>      do_sldt();
> -    report("no exception from sldt", gp_count == 0);
> +    report(gp_count == 0, "no exception from sldt");
>      do_str();
> -    report("no exception from str", gp_count == 0);
> +    report(gp_count == 0, "no exception from str");
>      if (read_cs() & 3) {
>          do_movcr();
> -        report("exception from mov %%cr0, %%eax", gp_count == 1);
> +        report(gp_count == 1, "exception from mov %%cr0, %%eax");
>      }
>  }
>  
> @@ -95,19 +95,19 @@ static void test_umip_gp(const char *msg)
>  #if 0
>      /* Skip this, because it cannot be emulated correctly.  */
>      do_smsw();
> -    report("exception from smsw", gp_count == 1);
> +    report(gp_count == 1, "exception from smsw");
>  #endif
>      do_sgdt();
> -    report("exception from sgdt", gp_count == 1);
> +    report(gp_count == 1, "exception from sgdt");
>      do_sidt();
> -    report("exception from sidt", gp_count == 1);
> +    report(gp_count == 1, "exception from sidt");
>      do_sldt();
> -    report("exception from sldt", gp_count == 1);
> +    report(gp_count == 1, "exception from sldt");
>      do_str();
> -    report("exception from str", gp_count == 1);
> +    report(gp_count == 1, "exception from str");
>      if (read_cs() & 3) {
>          do_movcr();
> -        report("exception from mov %%cr0, %%eax", gp_count == 1);
> +        report(gp_count == 1, "exception from mov %%cr0, %%eax");
>      }
>  }
>  
> diff --git a/x86/vmx.c b/x86/vmx.c
> index 647ab49..5803dc7 100644
> --- a/x86/vmx.c
> +++ b/x86/vmx.c
> @@ -358,11 +358,12 @@ static void test_vmwrite_vmread(void)
>  	assert(!make_vmcs_current(vmcs));
>  
>  	set_all_vmcs_fields(0x42);
> -	report("VMWRITE/VMREAD", __check_all_vmcs_fields(0x42, &max_index));
> +	report(__check_all_vmcs_fields(0x42, &max_index), "VMWRITE/VMREAD");
>  
>  	vmcs_enum_max = rdmsr(MSR_IA32_VMX_VMCS_ENUM) & VMCS_FIELD_INDEX_MASK;
> -	report("VMX_VMCS_ENUM.MAX_INDEX expected at least: %x, actual: %x",
> -		vmcs_enum_max >= max_index, max_index, vmcs_enum_max);
> +	report(vmcs_enum_max >= max_index,
> +	       "VMX_VMCS_ENUM.MAX_INDEX expected at least: %x, actual: %x",
> +	       max_index, vmcs_enum_max);
>  
>  	assert(!vmcs_clear(vmcs));
>  	free_page(vmcs);
> @@ -377,15 +378,15 @@ static void test_vmcs_high(void)
>  	assert(!make_vmcs_current(vmcs));
>  
>  	vmcs_write(TSC_OFFSET, 0x0123456789ABCDEFull);
> -	report("VMREAD TSC_OFFSET after VMWRITE TSC_OFFSET",
> -	       vmcs_read(TSC_OFFSET) == 0x0123456789ABCDEFull);
> -	report("VMREAD TSC_OFFSET_HI after VMWRITE TSC_OFFSET",
> -	       vmcs_read(TSC_OFFSET_HI) == 0x01234567ull);
> +	report(vmcs_read(TSC_OFFSET) == 0x0123456789ABCDEFull,
> +	       "VMREAD TSC_OFFSET after VMWRITE TSC_OFFSET");
> +	report(vmcs_read(TSC_OFFSET_HI) == 0x01234567ull,
> +	       "VMREAD TSC_OFFSET_HI after VMWRITE TSC_OFFSET");
>  	vmcs_write(TSC_OFFSET_HI, 0x76543210ul);
> -	report("VMREAD TSC_OFFSET_HI after VMWRITE TSC_OFFSET_HI",
> -	       vmcs_read(TSC_OFFSET_HI) == 0x76543210ul);
> -	report("VMREAD TSC_OFFSET after VMWRITE TSC_OFFSET_HI",
> -	       vmcs_read(TSC_OFFSET) == 0x7654321089ABCDEFull);
> +	report(vmcs_read(TSC_OFFSET_HI) == 0x76543210ul,
> +	       "VMREAD TSC_OFFSET_HI after VMWRITE TSC_OFFSET_HI");
> +	report(vmcs_read(TSC_OFFSET) == 0x7654321089ABCDEFull,
> +	       "VMREAD TSC_OFFSET after VMWRITE TSC_OFFSET_HI");
>  
>  	assert(!vmcs_clear(vmcs));
>  	free_page(vmcs);
> @@ -416,33 +417,33 @@ static void test_vmcs_lifecycle(void)
>  	VMCLEAR(0);
>  	VMPTRLD(0);
>  	set_all_vmcs_fields(0);
> -	report("current:VMCS0 active:[VMCS0]", check_all_vmcs_fields(0));
> +	report(check_all_vmcs_fields(0), "current:VMCS0 active:[VMCS0]");
>  
>  	VMCLEAR(0);
>  	VMPTRLD(0);
> -	report("current:VMCS0 active:[VMCS0]", check_all_vmcs_fields(0));
> +	report(check_all_vmcs_fields(0), "current:VMCS0 active:[VMCS0]");
>  
>  	VMCLEAR(1);
> -	report("current:VMCS0 active:[VMCS0]", check_all_vmcs_fields(0));
> +	report(check_all_vmcs_fields(0), "current:VMCS0 active:[VMCS0]");
>  
>  	VMPTRLD(1);
>  	set_all_vmcs_fields(1);
> -	report("current:VMCS1 active:[VMCS0,VCMS1]", check_all_vmcs_fields(1));
> +	report(check_all_vmcs_fields(1), "current:VMCS1 active:[VMCS0,VCMS1]");
>  
>  	VMPTRLD(0);
> -	report("current:VMCS0 active:[VMCS0,VCMS1]", check_all_vmcs_fields(0));
> +	report(check_all_vmcs_fields(0), "current:VMCS0 active:[VMCS0,VCMS1]");
>  	VMPTRLD(1);
> -	report("current:VMCS1 active:[VMCS0,VCMS1]", check_all_vmcs_fields(1));
> +	report(check_all_vmcs_fields(1), "current:VMCS1 active:[VMCS0,VCMS1]");
>  	VMPTRLD(1);
> -	report("current:VMCS1 active:[VMCS0,VCMS1]", check_all_vmcs_fields(1));
> +	report(check_all_vmcs_fields(1), "current:VMCS1 active:[VMCS0,VCMS1]");
>  
>  	VMCLEAR(0);
> -	report("current:VMCS1 active:[VCMS1]", check_all_vmcs_fields(1));
> +	report(check_all_vmcs_fields(1), "current:VMCS1 active:[VCMS1]");
>  
>  	/* VMPTRLD should not erase VMWRITEs to the current VMCS */
>  	set_all_vmcs_fields(2);
>  	VMPTRLD(1);
> -	report("current:VMCS1 active:[VCMS1]", check_all_vmcs_fields(2));
> +	report(check_all_vmcs_fields(2), "current:VMCS1 active:[VCMS1]");
>  
>  	for (i = 0; i < ARRAY_SIZE(vmcs); i++) {
>  		VMCLEAR(i);
> @@ -654,14 +655,16 @@ static void test_vmclear_flushing(void)
>  	assert(!vmcs_clear(vmcs[0]));
>  	memcpy(vmcs[1], vmcs[0], basic.size);
>  	assert(!make_vmcs_current(vmcs[1]));
> -	report("test vmclear flush (current VMCS)", check_all_vmcs_fields(0x86));
> +	report(check_all_vmcs_fields(0x86),
> +	       "test vmclear flush (current VMCS)");
>  
>  	set_all_vmcs_fields(0x87);
>  	assert(!make_vmcs_current(vmcs[0]));
>  	assert(!vmcs_clear(vmcs[1]));
>  	memcpy(vmcs[2], vmcs[1], basic.size);
>  	assert(!make_vmcs_current(vmcs[2]));
> -	report("test vmclear flush (!current VMCS)", check_all_vmcs_fields(0x87));
> +	report(check_all_vmcs_fields(0x87),
> +	       "test vmclear flush (!current VMCS)");
>  
>  	for (i = 0; i < ARRAY_SIZE(vmcs); i++) {
>  		assert(!vmcs_clear(vmcs[i]));
> @@ -683,22 +686,21 @@ static void test_vmclear(void)
>  
>  	/* Unaligned page access */
>  	tmp_root = (struct vmcs *)((intptr_t)vmcs_root + 1);
> -	report("test vmclear with unaligned vmcs",
> -	       vmcs_clear(tmp_root) == 1);
> +	report(vmcs_clear(tmp_root) == 1, "test vmclear with unaligned vmcs");
>  
>  	/* gpa bits beyond physical address width are set*/
>  	tmp_root = (struct vmcs *)((intptr_t)vmcs_root |
>  				   ((u64)1 << (width+1)));
> -	report("test vmclear with vmcs address bits set beyond physical address width",
> -	       vmcs_clear(tmp_root) == 1);
> +	report(vmcs_clear(tmp_root) == 1,
> +	       "test vmclear with vmcs address bits set beyond physical address width");
>  
>  	/* Pass VMXON region */
>  	tmp_root = (struct vmcs *)bsp_vmxon_region;
> -	report("test vmclear with vmxon region",
> -	       vmcs_clear(tmp_root) == 1);
> +	report(vmcs_clear(tmp_root) == 1, "test vmclear with vmxon region");
>  
>  	/* Valid VMCS */
> -	report("test vmclear with valid vmcs region", vmcs_clear(vmcs_root) == 0);
> +	report(vmcs_clear(vmcs_root) == 0,
> +	       "test vmclear with valid vmcs region");
>  
>  	test_vmclear_flushing();
>  }
> @@ -955,8 +957,9 @@ void check_ept_ad(unsigned long *pml4, u64 guest_cr3,
>  		if (!bad_pt_ad) {
>  			bad_pt_ad |= (ept_pte & (EPT_ACCESS_FLAG|EPT_DIRTY_FLAG)) != expected_pt_ad;
>  			if (bad_pt_ad)
> -				report("EPT - guest level %d page table A=%d/D=%d",
> -				       false, l,
> +				report(false,
> +				       "EPT - guest level %d page table A=%d/D=%d",
> +				       l,
>  				       !!(expected_pt_ad & EPT_ACCESS_FLAG),
>  				       !!(expected_pt_ad & EPT_DIRTY_FLAG));
>  		}
> @@ -970,8 +973,7 @@ void check_ept_ad(unsigned long *pml4, u64 guest_cr3,
>  	}
>  
>  	if (!bad_pt_ad)
> -		report("EPT - guest page table structures A=%d/D=%d",
> -		       true,
> +		report(true, "EPT - guest page table structures A=%d/D=%d",
>  		       !!(expected_pt_ad & EPT_ACCESS_FLAG),
>  		       !!(expected_pt_ad & EPT_DIRTY_FLAG));
>  
> @@ -980,11 +982,11 @@ void check_ept_ad(unsigned long *pml4, u64 guest_cr3,
>  	gpa = (pt[offset] & PT_ADDR_MASK) | (guest_addr & offset_in_page);
>  
>  	if (!get_ept_pte(pml4, gpa, 1, &ept_pte)) {
> -		report("EPT - guest physical address is not mapped", false);
> +		report(false, "EPT - guest physical address is not mapped");
>  		return;
>  	}
> -	report("EPT - guest physical address A=%d/D=%d",
> -	       (ept_pte & (EPT_ACCESS_FLAG|EPT_DIRTY_FLAG)) == expected_gpa_ad,
> +	report((ept_pte & (EPT_ACCESS_FLAG | EPT_DIRTY_FLAG)) == expected_gpa_ad,
> +	       "EPT - guest physical address A=%d/D=%d",
>  	       !!(expected_gpa_ad & EPT_ACCESS_FLAG),
>  	       !!(expected_gpa_ad & EPT_DIRTY_FLAG));
>  }
> @@ -1344,12 +1346,12 @@ static int test_vmx_feature_control(void)
>  	}
>  
>  	wrmsr(MSR_IA32_FEATURE_CONTROL, 0);
> -	report("test vmxon with FEATURE_CONTROL cleared",
> -	       test_for_exception(GP_VECTOR, &do_vmxon_off, NULL));
> +	report(test_for_exception(GP_VECTOR, &do_vmxon_off, NULL),
> +	       "test vmxon with FEATURE_CONTROL cleared");
>  
>  	wrmsr(MSR_IA32_FEATURE_CONTROL, FEATURE_CONTROL_VMXON_ENABLED_OUTSIDE_SMX);
> -	report("test vmxon without FEATURE_CONTROL lock",
> -	       test_for_exception(GP_VECTOR, &do_vmxon_off, NULL));
> +	report(test_for_exception(GP_VECTOR, &do_vmxon_off, NULL),
> +	       "test vmxon without FEATURE_CONTROL lock");
>  
>  	wrmsr(MSR_IA32_FEATURE_CONTROL,
>  		  FEATURE_CONTROL_VMXON_ENABLED_OUTSIDE_SMX |
> @@ -1358,10 +1360,10 @@ static int test_vmx_feature_control(void)
>  	ia32_feature_control = rdmsr(MSR_IA32_FEATURE_CONTROL);
>  	vmx_enabled =
>  		ia32_feature_control & FEATURE_CONTROL_VMXON_ENABLED_OUTSIDE_SMX;
> -	report("test enable VMX in FEATURE_CONTROL", vmx_enabled);
> +	report(vmx_enabled, "test enable VMX in FEATURE_CONTROL");
>  
> -	report("test FEATURE_CONTROL lock bit",
> -	       test_for_exception(GP_VECTOR, &do_write_feature_control, NULL));
> +	report(test_for_exception(GP_VECTOR, &do_write_feature_control, NULL),
> +	       "test FEATURE_CONTROL lock bit");
>  
>  	return !vmx_enabled;
>  }
> @@ -1375,7 +1377,7 @@ static int test_vmxon(void)
>  	/* Unaligned page access */
>  	vmxon_region = (u64 *)((intptr_t)bsp_vmxon_region + 1);
>  	ret1 = _vmx_on(vmxon_region);
> -	report("test vmxon with unaligned vmxon region", ret1);
> +	report(ret1, "test vmxon with unaligned vmxon region");
>  	if (!ret1) {
>  		ret = 1;
>  		goto out;
> @@ -1384,7 +1386,7 @@ static int test_vmxon(void)
>  	/* gpa bits beyond physical address width are set*/
>  	vmxon_region = (u64 *)((intptr_t)bsp_vmxon_region | ((u64)1 << (width+1)));
>  	ret1 = _vmx_on(vmxon_region);
> -	report("test vmxon with bits set beyond physical address width", ret1);
> +	report(ret1, "test vmxon with bits set beyond physical address width");
>  	if (!ret1) {
>  		ret = 1;
>  		goto out;
> @@ -1393,7 +1395,7 @@ static int test_vmxon(void)
>  	/* invalid revision indentifier */
>  	*bsp_vmxon_region = 0xba9da9;
>  	ret1 = vmx_on();
> -	report("test vmxon with invalid revision identifier", ret1);
> +	report(ret1, "test vmxon with invalid revision identifier");
>  	if (!ret1) {
>  		ret = 1;
>  		goto out;
> @@ -1402,7 +1404,7 @@ static int test_vmxon(void)
>  	/* and finally a valid region */
>  	*bsp_vmxon_region = basic.revision;
>  	ret = vmx_on();
> -	report("test vmxon with valid vmxon region", !ret);
> +	report(!ret, "test vmxon with valid vmxon region");
>  
>  out:
>  	return ret;
> @@ -1418,25 +1420,26 @@ static void test_vmptrld(void)
>  
>  	/* Unaligned page access */
>  	tmp_root = (struct vmcs *)((intptr_t)vmcs + 1);
> -	report("test vmptrld with unaligned vmcs",
> -	       make_vmcs_current(tmp_root) == 1);
> +	report(make_vmcs_current(tmp_root) == 1,
> +	       "test vmptrld with unaligned vmcs");
>  
>  	/* gpa bits beyond physical address width are set*/
>  	tmp_root = (struct vmcs *)((intptr_t)vmcs |
>  				   ((u64)1 << (width+1)));
> -	report("test vmptrld with vmcs address bits set beyond physical address width",
> -	       make_vmcs_current(tmp_root) == 1);
> +	report(make_vmcs_current(tmp_root) == 1,
> +	       "test vmptrld with vmcs address bits set beyond physical address width");
>  
>  	/* Pass VMXON region */
>  	assert(!vmcs_clear(vmcs));
>  	assert(!make_vmcs_current(vmcs));
>  	tmp_root = (struct vmcs *)bsp_vmxon_region;
> -	report("test vmptrld with vmxon region",
> -	       make_vmcs_current(tmp_root) == 1);
> -	report("test vmptrld with vmxon region vm-instruction error",
> -	       vmcs_read(VMX_INST_ERROR) == VMXERR_VMPTRLD_VMXON_POINTER);
> +	report(make_vmcs_current(tmp_root) == 1,
> +	       "test vmptrld with vmxon region");
> +	report(vmcs_read(VMX_INST_ERROR) == VMXERR_VMPTRLD_VMXON_POINTER,
> +	       "test vmptrld with vmxon region vm-instruction error");
>  
> -	report("test vmptrld with valid vmcs region", make_vmcs_current(vmcs) == 0);
> +	report(make_vmcs_current(vmcs) == 0,
> +	       "test vmptrld with valid vmcs region");
>  }
>  
>  static void test_vmptrst(void)
> @@ -1447,7 +1450,7 @@ static void test_vmptrst(void)
>  	vmcs1 = alloc_page();
>  	init_vmcs(&vmcs1);
>  	ret = vmcs_save(&vmcs2);
> -	report("test vmptrst", (!ret) && (vmcs1 == vmcs2));
> +	report((!ret) && (vmcs1 == vmcs2), "test vmptrst");
>  }
>  
>  struct vmx_ctl_msr {
> @@ -1476,17 +1479,17 @@ static void test_vmx_caps(void)
>  
>  	printf("\nTest suite: VMX capability reporting\n");
>  
> -	report("MSR_IA32_VMX_BASIC",
> -	       (basic.revision & (1ul << 31)) == 0 &&
> +	report((basic.revision & (1ul << 31)) == 0 &&
>  	       basic.size > 0 && basic.size <= 4096 &&
>  	       (basic.type == 0 || basic.type == 6) &&
> -	       basic.reserved1 == 0 && basic.reserved2 == 0);
> +	       basic.reserved1 == 0 && basic.reserved2 == 0,
> +	       "MSR_IA32_VMX_BASIC");
>  
>  	val = rdmsr(MSR_IA32_VMX_MISC);
> -	report("MSR_IA32_VMX_MISC",
> -	       (!(ctrl_cpu_rev[1].clr & CPU_URG) || val & (1ul << 5)) &&
> +	report((!(ctrl_cpu_rev[1].clr & CPU_URG) || val & (1ul << 5)) &&
>  	       ((val >> 16) & 0x1ff) <= 256 &&
> -	       (val & 0x80007e00) == 0);
> +	       (val & 0x80007e00) == 0,
> +	       "MSR_IA32_VMX_MISC");
>  
>  	for (n = 0; n < ARRAY_SIZE(vmx_ctl_msr); n++) {
>  		ctrl.val = rdmsr(vmx_ctl_msr[n].index);
> @@ -1498,27 +1501,27 @@ static void test_vmx_caps(void)
>  			ok = ctrl.clr == true_ctrl.clr;
>  			ok = ok && ctrl.set == (true_ctrl.set | default1);
>  		}
> -		report("%s", ok, vmx_ctl_msr[n].name);
> +		report(ok, "%s", vmx_ctl_msr[n].name);
>  	}
>  
>  	fixed0 = rdmsr(MSR_IA32_VMX_CR0_FIXED0);
>  	fixed1 = rdmsr(MSR_IA32_VMX_CR0_FIXED1);
> -	report("MSR_IA32_VMX_IA32_VMX_CR0_FIXED0/1",
> -	       ((fixed0 ^ fixed1) & ~fixed1) == 0);
> +	report(((fixed0 ^ fixed1) & ~fixed1) == 0,
> +	       "MSR_IA32_VMX_IA32_VMX_CR0_FIXED0/1");
>  
>  	fixed0 = rdmsr(MSR_IA32_VMX_CR4_FIXED0);
>  	fixed1 = rdmsr(MSR_IA32_VMX_CR4_FIXED1);
> -	report("MSR_IA32_VMX_IA32_VMX_CR4_FIXED0/1",
> -	       ((fixed0 ^ fixed1) & ~fixed1) == 0);
> +	report(((fixed0 ^ fixed1) & ~fixed1) == 0,
> +	       "MSR_IA32_VMX_IA32_VMX_CR4_FIXED0/1");
>  
>  	val = rdmsr(MSR_IA32_VMX_VMCS_ENUM);
> -	report("MSR_IA32_VMX_VMCS_ENUM",
> -	       (val & VMCS_FIELD_INDEX_MASK) >= 0x2a &&
> -	       (val & 0xfffffffffffffc01Ull) == 0);
> +	report((val & VMCS_FIELD_INDEX_MASK) >= 0x2a &&
> +	       (val & 0xfffffffffffffc01Ull) == 0,
> +	       "MSR_IA32_VMX_VMCS_ENUM");
>  
>  	val = rdmsr(MSR_IA32_VMX_EPT_VPID_CAP);
> -	report("MSR_IA32_VMX_EPT_VPID_CAP",
> -	       (val & 0xfffff07ef98cbebeUll) == 0);
> +	report((val & 0xfffff07ef98cbebeUll) == 0,
> +	       "MSR_IA32_VMX_EPT_VPID_CAP");
>  }
>  
>  /* This function can only be called in guest */
> @@ -1724,7 +1727,7 @@ static int test_run(struct vmx_test *test)
>  		int ret = 0;
>  		if (test->init || test->guest_main || test->exit_handler ||
>  		    test->syscall_handler) {
> -			report("V2 test cannot specify V1 callbacks.", 0);
> +			report(0, "V2 test cannot specify V1 callbacks.");
>  			ret = 1;
>  		}
>  		if (ret)
> @@ -1769,7 +1772,7 @@ static int test_run(struct vmx_test *test)
>  		run_teardown_step(&teardown_steps[--teardown_count]);
>  
>  	if (launched && !guest_finished)
> -		report("Guest didn't run to completion.", 0);
> +		report(0, "Guest didn't run to completion.");
>  
>  out:
>  	if (vmx_off()) {
> @@ -1871,11 +1874,11 @@ void enter_guest_with_bad_controls(void)
>  			"Called enter_guest() after guest returned.");
>  
>  	__enter_guest(ABORT_ON_INVALID_GUEST_STATE, &failure);
> -	report("failure occurred early", failure.early);
> -	report("FLAGS set correctly",
> -	       (failure.flags & VMX_ENTRY_FLAGS) == X86_EFLAGS_ZF);
> -	report("VM-Inst Error # is %d (VM entry with invalid control field(s))",
> -	       vmcs_read(VMX_INST_ERROR) == VMXERR_ENTRY_INVALID_CONTROL_FIELD,
> +	report(failure.early, "failure occurred early");
> +	report((failure.flags & VMX_ENTRY_FLAGS) == X86_EFLAGS_ZF,
> +               "FLAGS set correctly");
> +	report(vmcs_read(VMX_INST_ERROR) == VMXERR_ENTRY_INVALID_CONTROL_FIELD,
> +	       "VM-Inst Error # is %d (VM entry with invalid control field(s))",
>  	       VMXERR_ENTRY_INVALID_CONTROL_FIELD);
>  
>  	/*
> @@ -1975,7 +1978,7 @@ int main(int argc, const char *argv[])
>  			goto exit;
>  	} else {
>  		if (vmx_on()) {
> -			report("vmxon", 0);
> +			report(0, "vmxon");
>  			goto exit;
>  		}
>  	}
> @@ -2006,7 +2009,7 @@ int main(int argc, const char *argv[])
>  	}
>  
>  	if (!matched)
> -		report("command line didn't match any tests!", matched);
> +		report(matched, "command line didn't match any tests!");
>  
>  exit:
>  	return report_summary();
> diff --git a/x86/vmx.h b/x86/vmx.h
> index a8bc847..2b2cd83 100644
> --- a/x86/vmx.h
> +++ b/x86/vmx.h
> @@ -841,7 +841,7 @@ void __abort_test(void);
>  #define TEST_ASSERT(cond) \
>  do { \
>  	if (!(cond)) { \
> -		report("%s:%d: Assertion failed: %s", 0, \
> +		report(0, "%s:%d: Assertion failed: %s", \
>  		       __FILE__, __LINE__, #cond); \
>  		dump_stack(); \
>  		__abort_test(); \
> @@ -852,7 +852,7 @@ do { \
>  #define TEST_ASSERT_MSG(cond, fmt, args...) \
>  do { \
>  	if (!(cond)) { \
> -		report("%s:%d: Assertion failed: %s\n" fmt, 0, \
> +		report(0, "%s:%d: Assertion failed: %s\n" fmt, \
>  		       __FILE__, __LINE__, #cond, ##args); \
>  		dump_stack(); \
>  		__abort_test(); \
> @@ -869,9 +869,10 @@ do { \
>  		char _bin_b[BINSTR_SZ]; \
>  		binstr(_a, _bin_a); \
>  		binstr(_b, _bin_b); \
> -		report("%s:%d: %s failed: (%s) == (%s)\n" \
> +		report(0, \
> +		       "%s:%d: %s failed: (%s) == (%s)\n" \
>  		       "\tLHS: %#018lx - %s - %lu\n" \
> -		       "\tRHS: %#018lx - %s - %lu%s" fmt, 0, \
> +		       "\tRHS: %#018lx - %s - %lu%s" fmt, \
>  		       __FILE__, __LINE__, \
>  		       assertion ? "Assertion" : "Expectation", a_str, b_str, \
>  		       (unsigned long) _a, _bin_a, (unsigned long) _a, \
> diff --git a/x86/vmx_tests.c b/x86/vmx_tests.c
> index 4aebc3f..47dfaf8 100644
> --- a/x86/vmx_tests.c
> +++ b/x86/vmx_tests.c
> @@ -55,12 +55,12 @@ static inline void vmcall(void)
>  
>  static void basic_guest_main(void)
>  {
> -	report("Basic VMX test", 1);
> +	report(1, "Basic VMX test");
>  }
>  
>  static int basic_exit_handler(void)
>  {
> -	report("Basic VMX test", 0);
> +	report(0, "Basic VMX test");
>  	print_vmexit_info();
>  	return VMX_TEST_EXIT;
>  }
> @@ -70,7 +70,7 @@ static void vmenter_main(void)
>  	u64 rax;
>  	u64 rsp, resume_rsp;
>  
> -	report("test vmlaunch", 1);
> +	report(1, "test vmlaunch");
>  
>  	asm volatile(
>  		"mov %%rsp, %0\n\t"
> @@ -80,7 +80,7 @@ static void vmenter_main(void)
>  		"mov %%rsp, %2\n\t"
>  		: "=r"(rsp), "=r"(rax), "=r"(resume_rsp)
>  		: "g"(0xABCD));
> -	report("test vmresume", (rax == 0xFFFF) && (rsp == resume_rsp));
> +	report((rax == 0xFFFF) && (rsp == resume_rsp), "test vmresume");
>  }
>  
>  static int vmenter_exit_handler(void)
> @@ -93,14 +93,14 @@ static int vmenter_exit_handler(void)
>  	switch (reason) {
>  	case VMX_VMCALL:
>  		if (regs.rax != 0xABCD) {
> -			report("test vmresume", 0);
> +			report(0, "test vmresume");
>  			return VMX_TEST_VMEXIT;
>  		}
>  		regs.rax = 0xFFFF;
>  		vmcs_write(GUEST_RIP, guest_rip + 3);
>  		return VMX_TEST_RESUME;
>  	default:
> -		report("test vmresume", 0);
> +		report(0, "test vmresume");
>  		print_vmexit_info();
>  	}
>  	return VMX_TEST_VMEXIT;
> @@ -168,18 +168,17 @@ static int preemption_timer_exit_handler(void)
>  		switch (vmx_get_test_stage()) {
>  		case 1:
>  		case 2:
> -			report("busy-wait for preemption timer",
> -			       ((rdtsc() - tsc_val) >> preempt_scale) >=
> -			       preempt_val);
> +			report(((rdtsc() - tsc_val) >> preempt_scale) >= preempt_val,
> +			       "busy-wait for preemption timer");
>  			vmx_set_test_stage(3);
>  			vmcs_write(PREEMPT_TIMER_VALUE, preempt_val);
>  			return VMX_TEST_RESUME;
>  		case 3:
>  			guest_halted =
>  				(vmcs_read(GUEST_ACTV_STATE) == ACTV_HLT);
> -			report("preemption timer during hlt",
> -			       ((rdtsc() - tsc_val) >> preempt_scale) >=
> -			       preempt_val && guest_halted);
> +			report(((rdtsc() - tsc_val) >> preempt_scale) >= preempt_val
> +			        && guest_halted,
> +			       "preemption timer during hlt");
>  			vmx_set_test_stage(4);
>  			vmcs_write(PIN_CONTROLS,
>  				   vmcs_read(PIN_CONTROLS) & ~PIN_PREEMPT);
> @@ -188,11 +187,11 @@ static int preemption_timer_exit_handler(void)
>  			vmcs_write(GUEST_ACTV_STATE, ACTV_ACTIVE);
>  			return VMX_TEST_RESUME;
>  		case 4:
> -			report("preemption timer with 0 value",
> -			       saved_rip == guest_rip);
> +			report(saved_rip == guest_rip,
> +			       "preemption timer with 0 value");
>  			break;
>  		default:
> -			report("Invalid stage.", false);
> +			report(false, "Invalid stage.");
>  			print_vmexit_info();
>  			break;
>  		}
> @@ -201,8 +200,8 @@ static int preemption_timer_exit_handler(void)
>  		vmcs_write(GUEST_RIP, guest_rip + insn_len);
>  		switch (vmx_get_test_stage()) {
>  		case 0:
> -			report("Keep preemption value",
> -			       vmcs_read(PREEMPT_TIMER_VALUE) == preempt_val);
> +			report(vmcs_read(PREEMPT_TIMER_VALUE) == preempt_val,
> +			       "Keep preemption value");
>  			vmx_set_test_stage(1);
>  			vmcs_write(PREEMPT_TIMER_VALUE, preempt_val);
>  			ctrl_exit = (vmcs_read(EXI_CONTROLS) |
> @@ -210,16 +209,16 @@ static int preemption_timer_exit_handler(void)
>  			vmcs_write(EXI_CONTROLS, ctrl_exit);
>  			return VMX_TEST_RESUME;
>  		case 1:
> -			report("Save preemption value",
> -			       vmcs_read(PREEMPT_TIMER_VALUE) < preempt_val);
> +			report(vmcs_read(PREEMPT_TIMER_VALUE) < preempt_val,
> +			       "Save preemption value");
>  			return VMX_TEST_RESUME;
>  		case 2:
> -			report("busy-wait for preemption timer", 0);
> +			report(0, "busy-wait for preemption timer");
>  			vmx_set_test_stage(3);
>  			vmcs_write(PREEMPT_TIMER_VALUE, preempt_val);
>  			return VMX_TEST_RESUME;
>  		case 3:
> -			report("preemption timer during hlt", 0);
> +			report(0, "preemption timer during hlt");
>  			vmx_set_test_stage(4);
>  			/* fall through */
>  		case 4:
> @@ -229,18 +228,19 @@ static int preemption_timer_exit_handler(void)
>  			saved_rip = guest_rip + insn_len;
>  			return VMX_TEST_RESUME;
>  		case 5:
> -			report("preemption timer with 0 value (vmcall stage 5)", 0);
> +			report(0,
> +			       "preemption timer with 0 value (vmcall stage 5)");
>  			break;
>  		default:
>  			// Should not reach here
> -			report("unexpected stage, %d", false,
> +			report(false, "unexpected stage, %d",
>  			       vmx_get_test_stage());
>  			print_vmexit_info();
>  			return VMX_TEST_VMEXIT;
>  		}
>  		break;
>  	default:
> -		report("Unknown exit reason, %ld", false, reason);
> +		report(false, "Unknown exit reason, %ld", reason);
>  		print_vmexit_info();
>  	}
>  	vmcs_write(PIN_CONTROLS, vmcs_read(PIN_CONTROLS) & ~PIN_PREEMPT);
> @@ -324,7 +324,7 @@ static void test_ctrl_pat_main(void)
>  		printf("\tENT_LOAD_PAT is not supported.\n");
>  	else {
>  		if (guest_ia32_pat != 0) {
> -			report("Entry load PAT", 0);
> +			report(0, "Entry load PAT");
>  			return;
>  		}
>  	}
> @@ -332,7 +332,7 @@ static void test_ctrl_pat_main(void)
>  	vmcall();
>  	guest_ia32_pat = rdmsr(MSR_IA32_CR_PAT);
>  	if (ctrl_enter_rev.clr & ENT_LOAD_PAT)
> -		report("Entry load PAT", guest_ia32_pat == ia32_pat);
> +		report(guest_ia32_pat == ia32_pat, "Entry load PAT");
>  }
>  
>  static int test_ctrl_pat_exit_handler(void)
> @@ -350,12 +350,13 @@ static int test_ctrl_pat_exit_handler(void)
>  			printf("\tEXI_SAVE_PAT is not supported\n");
>  			vmcs_write(GUEST_PAT, 0x6);
>  		} else {
> -			report("Exit save PAT", guest_pat == 0x6);
> +			report(guest_pat == 0x6, "Exit save PAT");
>  		}
>  		if (!(ctrl_exit_rev.clr & EXI_LOAD_PAT))
>  			printf("\tEXI_LOAD_PAT is not supported\n");
>  		else
> -			report("Exit load PAT", rdmsr(MSR_IA32_CR_PAT) == ia32_pat);
> +			report(rdmsr(MSR_IA32_CR_PAT) == ia32_pat,
> +			       "Exit load PAT");
>  		vmcs_write(GUEST_PAT, ia32_pat);
>  		vmcs_write(GUEST_RIP, guest_rip + 3);
>  		return VMX_TEST_RESUME;
> @@ -391,7 +392,7 @@ static void test_ctrl_efer_main(void)
>  		printf("\tENT_LOAD_EFER is not supported.\n");
>  	else {
>  		if (guest_ia32_efer != (ia32_efer ^ EFER_NX)) {
> -			report("Entry load EFER", 0);
> +			report(0, "Entry load EFER");
>  			return;
>  		}
>  	}
> @@ -399,7 +400,7 @@ static void test_ctrl_efer_main(void)
>  	vmcall();
>  	guest_ia32_efer = rdmsr(MSR_EFER);
>  	if (ctrl_enter_rev.clr & ENT_LOAD_EFER)
> -		report("Entry load EFER", guest_ia32_efer == ia32_efer);
> +		report(guest_ia32_efer == ia32_efer, "Entry load EFER");
>  }
>  
>  static int test_ctrl_efer_exit_handler(void)
> @@ -417,13 +418,14 @@ static int test_ctrl_efer_exit_handler(void)
>  			printf("\tEXI_SAVE_EFER is not supported\n");
>  			vmcs_write(GUEST_EFER, ia32_efer);
>  		} else {
> -			report("Exit save EFER", guest_efer == ia32_efer);
> +			report(guest_efer == ia32_efer, "Exit save EFER");
>  		}
>  		if (!(ctrl_exit_rev.clr & EXI_LOAD_EFER)) {
>  			printf("\tEXI_LOAD_EFER is not supported\n");
>  			wrmsr(MSR_EFER, ia32_efer ^ EFER_NX);
>  		} else {
> -			report("Exit load EFER", rdmsr(MSR_EFER) == (ia32_efer ^ EFER_NX));
> +			report(rdmsr(MSR_EFER) == (ia32_efer ^ EFER_NX),
> +			       "Exit load EFER");
>  		}
>  		vmcs_write(GUEST_PAT, ia32_efer);
>  		vmcs_write(GUEST_RIP, guest_rip + 3);
> @@ -445,13 +447,13 @@ static void cr_shadowing_main(void)
>  	vmx_set_test_stage(0);
>  	guest_cr0 = read_cr0();
>  	if (vmx_get_test_stage() == 1)
> -		report("Read through CR0", 0);
> +		report(0, "Read through CR0");
>  	else
>  		vmcall();
>  	vmx_set_test_stage(1);
>  	guest_cr4 = read_cr4();
>  	if (vmx_get_test_stage() == 2)
> -		report("Read through CR4", 0);
> +		report(0, "Read through CR4");
>  	else
>  		vmcall();
>  	// Test write through
> @@ -460,13 +462,13 @@ static void cr_shadowing_main(void)
>  	vmx_set_test_stage(2);
>  	write_cr0(guest_cr0);
>  	if (vmx_get_test_stage() == 3)
> -		report("Write throuth CR0", 0);
> +		report(0, "Write throuth CR0");
>  	else
>  		vmcall();
>  	vmx_set_test_stage(3);
>  	write_cr4(guest_cr4);
>  	if (vmx_get_test_stage() == 4)
> -		report("Write through CR4", 0);
> +		report(0, "Write through CR4");
>  	else
>  		vmcall();
>  	// Test read shadow
> @@ -474,22 +476,22 @@ static void cr_shadowing_main(void)
>  	vmcall();
>  	cr0 = read_cr0();
>  	if (vmx_get_test_stage() != 5)
> -		report("Read shadowing CR0", cr0 == guest_cr0);
> +		report(cr0 == guest_cr0, "Read shadowing CR0");
>  	vmx_set_test_stage(5);
>  	cr4 = read_cr4();
>  	if (vmx_get_test_stage() != 6)
> -		report("Read shadowing CR4", cr4 == guest_cr4);
> +		report(cr4 == guest_cr4, "Read shadowing CR4");
>  	// Test write shadow (same value with shadow)
>  	vmx_set_test_stage(6);
>  	write_cr0(guest_cr0);
>  	if (vmx_get_test_stage() == 7)
> -		report("Write shadowing CR0 (same value with shadow)", 0);
> +		report(0, "Write shadowing CR0 (same value with shadow)");
>  	else
>  		vmcall();
>  	vmx_set_test_stage(7);
>  	write_cr4(guest_cr4);
>  	if (vmx_get_test_stage() == 8)
> -		report("Write shadowing CR4 (same value with shadow)", 0);
> +		report(0, "Write shadowing CR4 (same value with shadow)");
>  	else
>  		vmcall();
>  	// Test write shadow (different value)
> @@ -499,28 +501,32 @@ static void cr_shadowing_main(void)
>  		"mov %%rsi, %%cr0\n\t"
>  		::"m"(tmp)
>  		:"rsi", "memory", "cc");
> -	report("Write shadowing different X86_CR0_TS", vmx_get_test_stage() == 9);
> +	report(vmx_get_test_stage() == 9,
> +	       "Write shadowing different X86_CR0_TS");
>  	vmx_set_test_stage(9);
>  	tmp = guest_cr0 ^ X86_CR0_MP;
>  	asm volatile("mov %0, %%rsi\n\t"
>  		"mov %%rsi, %%cr0\n\t"
>  		::"m"(tmp)
>  		:"rsi", "memory", "cc");
> -	report("Write shadowing different X86_CR0_MP", vmx_get_test_stage() == 10);
> +	report(vmx_get_test_stage() == 10,
> +	       "Write shadowing different X86_CR0_MP");
>  	vmx_set_test_stage(10);
>  	tmp = guest_cr4 ^ X86_CR4_TSD;
>  	asm volatile("mov %0, %%rsi\n\t"
>  		"mov %%rsi, %%cr4\n\t"
>  		::"m"(tmp)
>  		:"rsi", "memory", "cc");
> -	report("Write shadowing different X86_CR4_TSD", vmx_get_test_stage() == 11);
> +	report(vmx_get_test_stage() == 11,
> +	       "Write shadowing different X86_CR4_TSD");
>  	vmx_set_test_stage(11);
>  	tmp = guest_cr4 ^ X86_CR4_DE;
>  	asm volatile("mov %0, %%rsi\n\t"
>  		"mov %%rsi, %%cr4\n\t"
>  		::"m"(tmp)
>  		:"rsi", "memory", "cc");
> -	report("Write shadowing different X86_CR4_DE", vmx_get_test_stage() == 12);
> +	report(vmx_get_test_stage() == 12,
> +	       "Write shadowing different X86_CR4_DE");
>  }
>  
>  static int cr_shadowing_exit_handler(void)
> @@ -538,16 +544,20 @@ static int cr_shadowing_exit_handler(void)
>  	case VMX_VMCALL:
>  		switch (vmx_get_test_stage()) {
>  		case 0:
> -			report("Read through CR0", guest_cr0 == vmcs_read(GUEST_CR0));
> +			report(guest_cr0 == vmcs_read(GUEST_CR0),
> +			       "Read through CR0");
>  			break;
>  		case 1:
> -			report("Read through CR4", guest_cr4 == vmcs_read(GUEST_CR4));
> +			report(guest_cr4 == vmcs_read(GUEST_CR4),
> +			       "Read through CR4");
>  			break;
>  		case 2:
> -			report("Write through CR0", guest_cr0 == vmcs_read(GUEST_CR0));
> +			report(guest_cr0 == vmcs_read(GUEST_CR0),
> +			       "Write through CR0");
>  			break;
>  		case 3:
> -			report("Write through CR4", guest_cr4 == vmcs_read(GUEST_CR4));
> +			report(guest_cr4 == vmcs_read(GUEST_CR4),
> +			       "Write through CR4");
>  			break;
>  		case 4:
>  			guest_cr0 = vmcs_read(GUEST_CR0) ^ (X86_CR0_TS | X86_CR0_MP);
> @@ -558,16 +568,16 @@ static int cr_shadowing_exit_handler(void)
>  			vmcs_write(CR4_READ_SHADOW, guest_cr4 & (X86_CR4_TSD | X86_CR4_DE));
>  			break;
>  		case 6:
> -			report("Write shadowing CR0 (same value)",
> -					guest_cr0 == (vmcs_read(GUEST_CR0) ^ (X86_CR0_TS | X86_CR0_MP)));
> +			report(guest_cr0 == (vmcs_read(GUEST_CR0) ^ (X86_CR0_TS | X86_CR0_MP)),
> +			       "Write shadowing CR0 (same value)");
>  			break;
>  		case 7:
> -			report("Write shadowing CR4 (same value)",
> -					guest_cr4 == (vmcs_read(GUEST_CR4) ^ (X86_CR4_TSD | X86_CR4_DE)));
> +			report(guest_cr4 == (vmcs_read(GUEST_CR4) ^ (X86_CR4_TSD | X86_CR4_DE)),
> +			       "Write shadowing CR4 (same value)");
>  			break;
>  		default:
>  			// Should not reach here
> -			report("unexpected stage, %d", false,
> +			report(false, "unexpected stage, %d",
>  			       vmx_get_test_stage());
>  			print_vmexit_info();
>  			return VMX_TEST_VMEXIT;
> @@ -577,19 +587,19 @@ static int cr_shadowing_exit_handler(void)
>  	case VMX_CR:
>  		switch (vmx_get_test_stage()) {
>  		case 4:
> -			report("Read shadowing CR0", 0);
> +			report(0, "Read shadowing CR0");
>  			vmx_inc_test_stage();
>  			break;
>  		case 5:
> -			report("Read shadowing CR4", 0);
> +			report(0, "Read shadowing CR4");
>  			vmx_inc_test_stage();
>  			break;
>  		case 6:
> -			report("Write shadowing CR0 (same value)", 0);
> +			report(0, "Write shadowing CR0 (same value)");
>  			vmx_inc_test_stage();
>  			break;
>  		case 7:
> -			report("Write shadowing CR4 (same value)", 0);
> +			report(0, "Write shadowing CR4 (same value)");
>  			vmx_inc_test_stage();
>  			break;
>  		case 8:
> @@ -606,7 +616,7 @@ static int cr_shadowing_exit_handler(void)
>  			break;
>  		default:
>  			// Should not reach here
> -			report("unexpected stage, %d", false,
> +			report(false, "unexpected stage, %d",
>  			       vmx_get_test_stage());
>  			print_vmexit_info();
>  			return VMX_TEST_VMEXIT;
> @@ -614,7 +624,7 @@ static int cr_shadowing_exit_handler(void)
>  		vmcs_write(GUEST_RIP, guest_rip + insn_len);
>  		return VMX_TEST_RESUME;
>  	default:
> -		report("Unknown exit reason, %ld", false, reason);
> +		report(false, "Unknown exit reason, %ld", reason);
>  		print_vmexit_info();
>  	}
>  	return VMX_TEST_VMEXIT;
> @@ -641,47 +651,47 @@ static void iobmp_main(void)
>  	vmx_set_test_stage(0);
>  	inb(0x5000);
>  	outb(0x0, 0x5000);
> -	report("I/O bitmap - I/O pass", vmx_get_test_stage() == 0);
> +	report(vmx_get_test_stage() == 0, "I/O bitmap - I/O pass");
>  	// test IO width, in/out
>  	((u8 *)io_bitmap_a)[0] = 0xFF;
>  	vmx_set_test_stage(2);
>  	inb(0x0);
> -	report("I/O bitmap - trap in", vmx_get_test_stage() == 3);
> +	report(vmx_get_test_stage() == 3, "I/O bitmap - trap in");
>  	vmx_set_test_stage(3);
>  	outw(0x0, 0x0);
> -	report("I/O bitmap - trap out", vmx_get_test_stage() == 4);
> +	report(vmx_get_test_stage() == 4, "I/O bitmap - trap out");
>  	vmx_set_test_stage(4);
>  	inl(0x0);
> -	report("I/O bitmap - I/O width, long", vmx_get_test_stage() == 5);
> +	report(vmx_get_test_stage() == 5, "I/O bitmap - I/O width, long");
>  	// test low/high IO port
>  	vmx_set_test_stage(5);
>  	((u8 *)io_bitmap_a)[0x5000 / 8] = (1 << (0x5000 % 8));
>  	inb(0x5000);
> -	report("I/O bitmap - I/O port, low part", vmx_get_test_stage() == 6);
> +	report(vmx_get_test_stage() == 6, "I/O bitmap - I/O port, low part");
>  	vmx_set_test_stage(6);
>  	((u8 *)io_bitmap_b)[0x1000 / 8] = (1 << (0x1000 % 8));
>  	inb(0x9000);
> -	report("I/O bitmap - I/O port, high part", vmx_get_test_stage() == 7);
> +	report(vmx_get_test_stage() == 7, "I/O bitmap - I/O port, high part");
>  	// test partial pass
>  	vmx_set_test_stage(7);
>  	inl(0x4FFF);
> -	report("I/O bitmap - partial pass", vmx_get_test_stage() == 8);
> +	report(vmx_get_test_stage() == 8, "I/O bitmap - partial pass");
>  	// test overrun
>  	vmx_set_test_stage(8);
>  	memset(io_bitmap_a, 0x0, PAGE_SIZE);
>  	memset(io_bitmap_b, 0x0, PAGE_SIZE);
>  	inl(0xFFFF);
> -	report("I/O bitmap - overrun", vmx_get_test_stage() == 9);
> +	report(vmx_get_test_stage() == 9, "I/O bitmap - overrun");
>  	vmx_set_test_stage(9);
>  	vmcall();
>  	outb(0x0, 0x0);
> -	report("I/O bitmap - ignore unconditional exiting",
> -	       vmx_get_test_stage() == 9);
> +	report(vmx_get_test_stage() == 9,
> +	       "I/O bitmap - ignore unconditional exiting");
>  	vmx_set_test_stage(10);
>  	vmcall();
>  	outb(0x0, 0x0);
> -	report("I/O bitmap - unconditional exiting",
> -	       vmx_get_test_stage() == 11);
> +	report(vmx_get_test_stage() == 11,
> +	       "I/O bitmap - unconditional exiting");
>  }
>  
>  static int iobmp_exit_handler(void)
> @@ -702,21 +712,22 @@ static int iobmp_exit_handler(void)
>  			vmx_inc_test_stage();
>  			break;
>  		case 2:
> -			report("I/O bitmap - I/O width, byte",
> -					(exit_qual & VMX_IO_SIZE_MASK) == _VMX_IO_BYTE);
> -			report("I/O bitmap - I/O direction, in", exit_qual & VMX_IO_IN);
> +			report((exit_qual & VMX_IO_SIZE_MASK) == _VMX_IO_BYTE,
> +			       "I/O bitmap - I/O width, byte");
> +			report(exit_qual & VMX_IO_IN,
> +			       "I/O bitmap - I/O direction, in");
>  			vmx_inc_test_stage();
>  			break;
>  		case 3:
> -			report("I/O bitmap - I/O width, word",
> -					(exit_qual & VMX_IO_SIZE_MASK) == _VMX_IO_WORD);
> -			report("I/O bitmap - I/O direction, out",
> -					!(exit_qual & VMX_IO_IN));
> +			report((exit_qual & VMX_IO_SIZE_MASK) == _VMX_IO_WORD,
> +			       "I/O bitmap - I/O width, word");
> +			report(!(exit_qual & VMX_IO_IN),
> +			       "I/O bitmap - I/O direction, out");
>  			vmx_inc_test_stage();
>  			break;
>  		case 4:
> -			report("I/O bitmap - I/O width, long",
> -					(exit_qual & VMX_IO_SIZE_MASK) == _VMX_IO_LONG);
> +			report((exit_qual & VMX_IO_SIZE_MASK) == _VMX_IO_LONG,
> +			       "I/O bitmap - I/O width, long");
>  			vmx_inc_test_stage();
>  			break;
>  		case 5:
> @@ -743,7 +754,7 @@ static int iobmp_exit_handler(void)
>  			break;
>  		default:
>  			// Should not reach here
> -			report("unexpected stage, %d", false,
> +			report(false, "unexpected stage, %d",
>  			       vmx_get_test_stage());
>  			print_vmexit_info();
>  			return VMX_TEST_VMEXIT;
> @@ -764,7 +775,7 @@ static int iobmp_exit_handler(void)
>  			break;
>  		default:
>  			// Should not reach here
> -			report("unexpected stage, %d", false,
> +			report(false, "unexpected stage, %d",
>  			       vmx_get_test_stage());
>  			print_vmexit_info();
>  			return VMX_TEST_VMEXIT;
> @@ -958,7 +969,8 @@ static void insn_intercept_main(void)
>  			/* skip hlt, it stalls the guest and is tested below */
>  			if (insn_table[cur_insn].insn_func != insn_hlt)
>  				insn_table[cur_insn].insn_func();
> -			report("execute %s", vmx_get_test_stage() == cur_insn * 2,
> +			report(vmx_get_test_stage() == cur_insn * 2,
> +					"execute %s",
>  					insn_table[cur_insn].name);
>  		} else if (insn_table[cur_insn].type != INSN_ALWAYS_TRAP)
>  			printf("\tCPU_CTRL%d.CPU_%s always traps.\n",
> @@ -968,7 +980,8 @@ static void insn_intercept_main(void)
>  		vmcall();
>  
>  		insn_table[cur_insn].insn_func();
> -		report("intercept %s", vmx_get_test_stage() == cur_insn * 2 + 1,
> +		report(vmx_get_test_stage() == cur_insn * 2 + 1,
> +				"intercept %s",
>  				insn_table[cur_insn].name);
>  
>  		vmx_set_test_stage(cur_insn * 2 + 1);
> @@ -1179,16 +1192,16 @@ static void ept_common(void)
>  	vmx_set_test_stage(0);
>  	if (*((u32 *)data_page2) != MAGIC_VAL_1 ||
>  			*((u32 *)data_page1) != MAGIC_VAL_1)
> -		report("EPT basic framework - read", 0);
> +		report(0, "EPT basic framework - read");
>  	else {
>  		*((u32 *)data_page2) = MAGIC_VAL_3;
>  		vmcall();
>  		if (vmx_get_test_stage() == 1) {
>  			if (*((u32 *)data_page1) == MAGIC_VAL_3 &&
>  					*((u32 *)data_page2) == MAGIC_VAL_2)
> -				report("EPT basic framework", 1);
> +				report(1, "EPT basic framework");
>  			else
> -				report("EPT basic framework - remap", 1);
> +				report(1, "EPT basic framework - remap");
>  		}
>  	}
>  	// Test EPT Misconfigurations
> @@ -1196,34 +1209,34 @@ static void ept_common(void)
>  	vmcall();
>  	*((u32 *)data_page1) = MAGIC_VAL_1;
>  	if (vmx_get_test_stage() != 2) {
> -		report("EPT misconfigurations", 0);
> +		report(0, "EPT misconfigurations");
>  		goto t1;
>  	}
>  	vmx_set_test_stage(2);
>  	vmcall();
>  	*((u32 *)data_page1) = MAGIC_VAL_1;
> -	report("EPT misconfigurations", vmx_get_test_stage() == 3);
> +	report(vmx_get_test_stage() == 3, "EPT misconfigurations");
>  t1:
>  	// Test EPT violation
>  	vmx_set_test_stage(3);
>  	vmcall();
>  	*((u32 *)data_page1) = MAGIC_VAL_1;
> -	report("EPT violation - page permission", vmx_get_test_stage() == 4);
> +	report(vmx_get_test_stage() == 4, "EPT violation - page permission");
>  	// Violation caused by EPT paging structure
>  	vmx_set_test_stage(4);
>  	vmcall();
>  	*((u32 *)data_page1) = MAGIC_VAL_2;
> -	report("EPT violation - paging structure", vmx_get_test_stage() == 5);
> +	report(vmx_get_test_stage() == 5, "EPT violation - paging structure");
>  
>  	// MMIO Read/Write
>  	vmx_set_test_stage(5);
>  	vmcall();
>  
>  	*(u32 volatile *)pci_physaddr;
> -	report("MMIO EPT violation - read", vmx_get_test_stage() == 6);
> +	report(vmx_get_test_stage() == 6, "MMIO EPT violation - read");
>  
>  	*(u32 volatile *)pci_physaddr = MAGIC_VAL_1;
> -	report("MMIO EPT violation - write", vmx_get_test_stage() == 7);
> +	report(vmx_get_test_stage() == 7, "MMIO EPT violation - write");
>  }
>  
>  static void ept_main(void)
> @@ -1232,11 +1245,11 @@ static void ept_main(void)
>  
>  	// Test EPT access to L1 MMIO
>  	vmx_set_test_stage(7);
> -	report("EPT - MMIO access", *((u32 *)0xfee00030UL) == apic_version);
> +	report(*((u32 *)0xfee00030UL) == apic_version, "EPT - MMIO access");
>  
>  	// Test invalid operand for INVEPT
>  	vmcall();
> -	report("EPT - unsupported INVEPT", vmx_get_test_stage() == 8);
> +	report(vmx_get_test_stage() == 8, "EPT - unsupported INVEPT");
>  }
>  
>  static bool invept_test(int type, u64 eptp)
> @@ -1285,7 +1298,7 @@ static int pml_exit_handler(void)
>  			clear_ept_ad(pml4, guest_cr3, (unsigned long)data_page2);
>  			break;
>  		default:
> -			report("unexpected stage, %d.", false,
> +			report(false, "unexpected stage, %d.",
>  			       vmx_get_test_stage());
>  			print_vmexit_info();
>  			return VMX_TEST_VMEXIT;
> @@ -1297,7 +1310,7 @@ static int pml_exit_handler(void)
>  		vmcs_write(GUEST_PML_INDEX, PML_INDEX - 1);
>  		return VMX_TEST_RESUME;
>  	default:
> -		report("Unknown exit reason, %ld", false, reason);
> +		report(false, "Unknown exit reason, %ld", reason);
>  		print_vmexit_info();
>  	}
>  	return VMX_TEST_VMEXIT;
> @@ -1340,7 +1353,7 @@ static int ept_exit_handler_common(bool have_ad)
>  						(unsigned long)data_page2,
>  						EPT_RA | EPT_WA | EPT_EA);
>  			} else
> -				report("EPT basic framework - write", 0);
> +				report(0, "EPT basic framework - write");
>  			break;
>  		case 1:
>  			install_ept(pml4, (unsigned long)data_page1,
> @@ -1383,7 +1396,7 @@ static int ept_exit_handler_common(bool have_ad)
>  			break;
>  		// Should not reach here
>  		default:
> -			report("ERROR - unexpected stage, %d.", false,
> +			report(false, "ERROR - unexpected stage, %d.",
>  			       vmx_get_test_stage());
>  			print_vmexit_info();
>  			return VMX_TEST_VMEXIT;
> @@ -1402,7 +1415,7 @@ static int ept_exit_handler_common(bool have_ad)
>  			break;
>  		// Should not reach here
>  		default:
> -			report("ERROR - unexpected stage, %d.", false,
> +			report(false, "ERROR - unexpected stage, %d.",
>  			       vmx_get_test_stage());
>  			print_vmexit_info();
>  			return VMX_TEST_VMEXIT;
> @@ -1451,14 +1464,14 @@ static int ept_exit_handler_common(bool have_ad)
>  			break;
>  		default:
>  			// Should not reach here
> -			report("ERROR : unexpected stage, %d", false,
> +			report(false, "ERROR : unexpected stage, %d",
>  			       vmx_get_test_stage());
>  			print_vmexit_info();
>  			return VMX_TEST_VMEXIT;
>  		}
>  		return VMX_TEST_RESUME;
>  	default:
> -		report("Unknown exit reason, %ld", false, reason);
> +		report(false, "Unknown exit reason, %ld", reason);
>  		print_vmexit_info();
>  	}
>  	return VMX_TEST_VMEXIT;
> @@ -1515,7 +1528,7 @@ static void pml_main(void)
>  	vmx_set_test_stage(0);
>  	*((u32 *)data_page2) = 0x1;
>  	vmcall();
> -	report("PML - Dirty GPA Logging", vmx_get_test_stage() == 1);
> +	report(vmx_get_test_stage() == 1, "PML - Dirty GPA Logging");
>  
>  	while (vmx_get_test_stage() == 1) {
>  		vmcall();
> @@ -1523,7 +1536,7 @@ static void pml_main(void)
>  		if (count++ > PML_INDEX)
>  			break;
>  	}
> -	report("PML Full Event", vmx_get_test_stage() == 2);
> +	report(vmx_get_test_stage() == 2, "PML Full Event");
>  }
>  
>  static void eptad_main(void)
> @@ -1575,13 +1588,13 @@ static void vpid_main(void)
>  {
>  	vmx_set_test_stage(0);
>  	vmcall();
> -	report("INVVPID SINGLE ADDRESS", vmx_get_test_stage() == 1);
> +	report(vmx_get_test_stage() == 1, "INVVPID SINGLE ADDRESS");
>  	vmx_set_test_stage(2);
>  	vmcall();
> -	report("INVVPID SINGLE", vmx_get_test_stage() == 3);
> +	report(vmx_get_test_stage() == 3, "INVVPID SINGLE");
>  	vmx_set_test_stage(4);
>  	vmcall();
> -	report("INVVPID ALL", vmx_get_test_stage() == 5);
> +	report(vmx_get_test_stage() == 5, "INVVPID ALL");
>  }
>  
>  static int vpid_exit_handler(void)
> @@ -1610,7 +1623,7 @@ static int vpid_exit_handler(void)
>  				vmx_inc_test_stage();
>  			break;
>  		default:
> -			report("ERROR: unexpected stage, %d", false,
> +			report(false, "ERROR: unexpected stage, %d",
>  					vmx_get_test_stage());
>  			print_vmexit_info();
>  			return VMX_TEST_VMEXIT;
> @@ -1618,7 +1631,7 @@ static int vpid_exit_handler(void)
>  		vmcs_write(GUEST_RIP, guest_rip + insn_len);
>  		return VMX_TEST_RESUME;
>  	default:
> -		report("Unknown exit reason, %ld", false, reason);
> +		report(false, "Unknown exit reason, %ld", reason);
>  		print_vmexit_info();
>  	}
>  	return VMX_TEST_VMEXIT;
> @@ -1654,7 +1667,7 @@ static void interrupt_main(void)
>  	apic_write(APIC_TMICT, 1);
>  	for (loops = 0; loops < 10000000 && !timer_fired; loops++)
>  		asm volatile ("nop");
> -	report("direct interrupt while running guest", timer_fired);
> +	report(timer_fired, "direct interrupt while running guest");
>  
>  	apic_write(APIC_TMICT, 0);
>  	irq_disable();
> @@ -1663,7 +1676,7 @@ static void interrupt_main(void)
>  	apic_write(APIC_TMICT, 1);
>  	for (loops = 0; loops < 10000000 && !timer_fired; loops++)
>  		asm volatile ("nop");
> -	report("intercepted interrupt while running guest", timer_fired);
> +	report(timer_fired, "intercepted interrupt while running guest");
>  
>  	irq_enable();
>  	apic_write(APIC_TMICT, 0);
> @@ -1675,8 +1688,8 @@ static void interrupt_main(void)
>  
>  	asm volatile ("sti; hlt");
>  
> -	report("direct interrupt + hlt",
> -	       rdtsc() - start > 1000000 && timer_fired);
> +	report(rdtsc() - start > 1000000 && timer_fired,
> +	       "direct interrupt + hlt");
>  
>  	apic_write(APIC_TMICT, 0);
>  	irq_disable();
> @@ -1687,8 +1700,8 @@ static void interrupt_main(void)
>  
>  	asm volatile ("sti; hlt");
>  
> -	report("intercepted interrupt + hlt",
> -	       rdtsc() - start > 10000 && timer_fired);
> +	report(rdtsc() - start > 10000 && timer_fired,
> +	       "intercepted interrupt + hlt");
>  
>  	apic_write(APIC_TMICT, 0);
>  	irq_disable();
> @@ -1701,8 +1714,8 @@ static void interrupt_main(void)
>  	asm volatile ("nop");
>  	vmcall();
>  
> -	report("direct interrupt + activity state hlt",
> -	       rdtsc() - start > 10000 && timer_fired);
> +	report(rdtsc() - start > 10000 && timer_fired,
> +	       "direct interrupt + activity state hlt");
>  
>  	apic_write(APIC_TMICT, 0);
>  	irq_disable();
> @@ -1715,8 +1728,8 @@ static void interrupt_main(void)
>  	asm volatile ("nop");
>  	vmcall();
>  
> -	report("intercepted interrupt + activity state hlt",
> -	       rdtsc() - start > 10000 && timer_fired);
> +	report(rdtsc() - start > 10000 && timer_fired,
> +	       "intercepted interrupt + activity state hlt");
>  
>  	apic_write(APIC_TMICT, 0);
>  	irq_disable();
> @@ -1726,13 +1739,14 @@ static void interrupt_main(void)
>  	apic_write(APIC_TMICT, 1);
>  	for (loops = 0; loops < 10000000 && !timer_fired; loops++)
>  		asm volatile ("nop");
> -	report("running a guest with interrupt acknowledgement set", timer_fired);
> +	report(timer_fired,
> +	       "running a guest with interrupt acknowledgement set");
>  
>  	apic_write(APIC_TMICT, 0);
>  	irq_enable();
>  	timer_fired = false;
>  	vmcall();
> -	report("Inject an event to a halted guest", timer_fired);
> +	report(timer_fired, "Inject an event to a halted guest");
>  }
>  
>  static int interrupt_exit_handler(void)
> @@ -1789,7 +1803,7 @@ static int interrupt_exit_handler(void)
>  			vmcs_write(GUEST_ACTV_STATE, ACTV_ACTIVE);
>  		return VMX_TEST_RESUME;
>  	default:
> -		report("Unknown exit reason, %ld", false, reason);
> +		report(false, "Unknown exit reason, %ld", reason);
>  		print_vmexit_info();
>  	}
>  
> @@ -1826,7 +1840,7 @@ static void dbgctls_main(void)
>  	debugctl = rdmsr(MSR_IA32_DEBUGCTLMSR);
>  	/* Commented out: KVM does not support DEBUGCTL so far */
>  	(void)debugctl;
> -	report("Load debug controls", dr7 == 0x404 /* && debugctl == 0x2 */);
> +	report(dr7 == 0x404, "Load debug controls" /* && debugctl == 0x2 */);
>  
>  	dr7 = 0x408;
>  	asm volatile("mov %0,%%dr7" : : "r" (dr7));
> @@ -1834,7 +1848,7 @@ static void dbgctls_main(void)
>  
>  	vmx_set_test_stage(0);
>  	vmcall();
> -	report("Save debug controls", vmx_get_test_stage() == 1);
> +	report(vmx_get_test_stage() == 1, "Save debug controls");
>  
>  	if (ctrl_enter_rev.set & ENT_LOAD_DBGCTLS ||
>  	    ctrl_exit_rev.set & EXI_SAVE_DBGCTLS) {
> @@ -1848,7 +1862,8 @@ static void dbgctls_main(void)
>  	debugctl = rdmsr(MSR_IA32_DEBUGCTLMSR);
>  	/* Commented out: KVM does not support DEBUGCTL so far */
>  	(void)debugctl;
> -	report("Guest=host debug controls", dr7 == 0x402 /* && debugctl == 0x1 */);
> +	report(dr7 == 0x402,
> +	       "Guest=host debug controls" /* && debugctl == 0x1 */);
>  
>  	dr7 = 0x408;
>  	asm volatile("mov %0,%%dr7" : : "r" (dr7));
> @@ -1856,7 +1871,7 @@ static void dbgctls_main(void)
>  
>  	vmx_set_test_stage(3);
>  	vmcall();
> -	report("Don't save debug controls", vmx_get_test_stage() == 4);
> +	report(vmx_get_test_stage() == 4, "Don't save debug controls");
>  }
>  
>  static int dbgctls_exit_handler(void)
> @@ -1902,7 +1917,7 @@ static int dbgctls_exit_handler(void)
>  		vmcs_write(GUEST_RIP, guest_rip + insn_len);
>  		return VMX_TEST_RESUME;
>  	default:
> -		report("Unknown exit reason, %d", false, reason);
> +		report(false, "Unknown exit reason, %d", reason);
>  		print_vmexit_info();
>  	}
>  	return VMX_TEST_VMEXIT;
> @@ -1939,8 +1954,8 @@ static int msr_switch_init(struct vmcs *vmcs)
>  static void msr_switch_main(void)
>  {
>  	if (vmx_get_test_stage() == 1) {
> -		report("VM entry MSR load",
> -			rdmsr(MSR_KERNEL_GS_BASE) == MSR_MAGIC);
> +		report(rdmsr(MSR_KERNEL_GS_BASE) == MSR_MAGIC,
> +		       "VM entry MSR load");
>  		vmx_set_test_stage(2);
>  		wrmsr(MSR_KERNEL_GS_BASE, MSR_MAGIC + 1);
>  		exit_msr_store[0].index = MSR_KERNEL_GS_BASE;
> @@ -1956,10 +1971,10 @@ static int msr_switch_exit_handler(void)
>  
>  	reason = vmcs_read(EXI_REASON);
>  	if (reason == VMX_VMCALL && vmx_get_test_stage() == 2) {
> -		report("VM exit MSR store",
> -			exit_msr_store[0].value == MSR_MAGIC + 1);
> -		report("VM exit MSR load",
> -			rdmsr(MSR_KERNEL_GS_BASE) == MSR_MAGIC + 2);
> +		report(exit_msr_store[0].value == MSR_MAGIC + 1,
> +		       "VM exit MSR store");
> +		report(rdmsr(MSR_KERNEL_GS_BASE) == MSR_MAGIC + 2,
> +		       "VM exit MSR load");
>  		vmx_set_test_stage(3);
>  		entry_msr_load[0].index = MSR_FS_BASE;
>  		return VMX_TEST_RESUME;
> @@ -1981,8 +1996,8 @@ static int msr_switch_entry_failure(struct vmentry_failure *failure)
>  	reason = vmcs_read(EXI_REASON);
>  	if (reason == (VMX_ENTRY_FAILURE | VMX_FAIL_MSR) &&
>  	    vmx_get_test_stage() == 3) {
> -		report("VM entry MSR load: try to load FS_BASE",
> -			vmcs_read(EXI_QUALIFICATION) == 1);
> +		report(vmcs_read(EXI_QUALIFICATION) == 1,
> +		       "VM entry MSR load: try to load FS_BASE");
>  		return VMX_TEST_VMEXIT;
>  	}
>  	printf("ERROR %s: unexpected stage=%u or reason=%lu\n",
> @@ -2003,7 +2018,7 @@ static void vmmcall_main(void)
>  		"vmmcall\n\t"
>  		::: "rax");
>  
> -	report("VMMCALL", 0);
> +	report(0, "VMMCALL");
>  }
>  
>  static int vmmcall_exit_handler(void)
> @@ -2014,14 +2029,14 @@ static int vmmcall_exit_handler(void)
>  	switch (reason) {
>  	case VMX_VMCALL:
>  		printf("here\n");
> -		report("VMMCALL triggers #UD", 0);
> +		report(0, "VMMCALL triggers #UD");
>  		break;
>  	case VMX_EXC_NMI:
> -		report("VMMCALL triggers #UD",
> -		       (vmcs_read(EXI_INTR_INFO) & 0xff) == UD_VECTOR);
> +		report((vmcs_read(EXI_INTR_INFO) & 0xff) == UD_VECTOR,
> +		       "VMMCALL triggers #UD");
>  		break;
>  	default:
> -		report("Unknown exit reason, %ld", false, reason);
> +		report(false, "Unknown exit reason, %ld", reason);
>  		print_vmexit_info();
>  	}
>  
> @@ -2045,12 +2060,12 @@ static void disable_rdtscp_ud_handler(struct ex_regs *regs)
>  {
>  	switch (vmx_get_test_stage()) {
>  	case 0:
> -		report("RDTSCP triggers #UD", true);
> +		report(true, "RDTSCP triggers #UD");
>  		vmx_inc_test_stage();
>  		regs->rip += 3;
>  		break;
>  	case 2:
> -		report("RDPID triggers #UD", true);
> +		report(true, "RDPID triggers #UD");
>  		vmx_inc_test_stage();
>  		regs->rip += 4;
>  		break;
> @@ -2081,7 +2096,7 @@ static int disable_rdtscp_exit_handler(void)
>  	case VMX_VMCALL:
>  		switch (vmx_get_test_stage()) {
>  		case 0:
> -			report("RDTSCP triggers #UD", false);
> +			report(false, "RDTSCP triggers #UD");
>  			vmx_inc_test_stage();
>  			/* fallthrough */
>  		case 1:
> @@ -2089,13 +2104,13 @@ static int disable_rdtscp_exit_handler(void)
>  			vmcs_write(GUEST_RIP, vmcs_read(GUEST_RIP) + 3);
>  			return VMX_TEST_RESUME;
>  		case 2:
> -			report("RDPID triggers #UD", false);
> +			report(false, "RDPID triggers #UD");
>  			break;
>  		}
>  		break;
>  
>  	default:
> -		report("Unknown exit reason, %d", false, reason);
> +		report(false, "Unknown exit reason, %d", reason);
>  		print_vmexit_info();
>  	}
>  	return VMX_TEST_VMEXIT;
> @@ -2117,11 +2132,11 @@ static int int3_exit_handler(void)
>  	u32 reason = vmcs_read(EXI_REASON);
>  	u32 intr_info = vmcs_read(EXI_INTR_INFO);
>  
> -	report("L1 intercepts #BP", reason == VMX_EXC_NMI &&
> -	       (intr_info & INTR_INFO_VALID_MASK) &&
> +	report(reason == VMX_EXC_NMI && (intr_info & INTR_INFO_VALID_MASK) &&
>  	       (intr_info & INTR_INFO_VECTOR_MASK) == BP_VECTOR &&
>  	       ((intr_info & INTR_INFO_INTR_TYPE_MASK) >>
> -		INTR_INFO_INTR_TYPE_SHIFT) == VMX_INTR_TYPE_SOFT_EXCEPTION);
> +	        INTR_INFO_INTR_TYPE_SHIFT) == VMX_INTR_TYPE_SOFT_EXCEPTION,
> +	       "L1 intercepts #BP");
>  
>  	return VMX_TEST_VMEXIT;
>  }
> @@ -2166,11 +2181,11 @@ static int into_exit_handler(void)
>  	u32 reason = vmcs_read(EXI_REASON);
>  	u32 intr_info = vmcs_read(EXI_INTR_INFO);
>  
> -	report("L1 intercepts #OF", reason == VMX_EXC_NMI &&
> -	       (intr_info & INTR_INFO_VALID_MASK) &&
> +	report(reason == VMX_EXC_NMI && (intr_info & INTR_INFO_VALID_MASK) &&
>  	       (intr_info & INTR_INFO_VECTOR_MASK) == OF_VECTOR &&
>  	       ((intr_info & INTR_INFO_INTR_TYPE_MASK) >>
> -		INTR_INFO_INTR_TYPE_SHIFT) == VMX_INTR_TYPE_SOFT_EXCEPTION);
> +	        INTR_INFO_INTR_TYPE_SHIFT) == VMX_INTR_TYPE_SOFT_EXCEPTION,
> +	       "L1 intercepts #OF");
>  
>  	return VMX_TEST_VMEXIT;
>  }
> @@ -2183,7 +2198,7 @@ static void exit_monitor_from_l2_main(void)
>  
>  static int exit_monitor_from_l2_handler(void)
>  {
> -	report("The guest should have killed the VMM", false);
> +	report(false, "The guest should have killed the VMM");
>  	return VMX_TEST_EXIT;
>  }
>  
> @@ -2217,7 +2232,7 @@ static void v2_null_test(void)
>  {
>  	test_set_guest(v2_null_test_guest);
>  	enter_guest();
> -	report(__func__, 1);
> +	report(1, __func__);
>  }
>  
>  static void v2_multiple_entries_test_guest(void)
> @@ -2235,7 +2250,7 @@ static void v2_multiple_entries_test(void)
>  	skip_exit_vmcall();
>  	enter_guest();
>  	TEST_ASSERT_EQ(vmx_get_test_stage(), 2);
> -	report(__func__, 1);
> +	report(1, __func__);
>  }
>  
>  static int fixture_test_data = 1;
> @@ -2266,7 +2281,7 @@ static void fixture_test_case1(void)
>  	TEST_ASSERT_EQ(2, fixture_test_data);
>  	enter_guest();
>  	TEST_ASSERT_EQ(3, fixture_test_data);
> -	report(__func__, 1);
> +	report(1, __func__);
>  }
>  
>  static void fixture_test_case2(void)
> @@ -2275,7 +2290,7 @@ static void fixture_test_case2(void)
>  	TEST_ASSERT_EQ(2, fixture_test_data);
>  	enter_guest();
>  	TEST_ASSERT_EQ(3, fixture_test_data);
> -	report(__func__, 1);
> +	report(1, __func__);
>  }
>  
>  enum ept_access_op {
> @@ -3151,11 +3166,11 @@ static void try_invvpid(u64 type, u64 vpid, u64 gla)
>  	 */
>  	vmcs_read(~0);
>  	rc = invvpid(type, vpid, gla);
> -	report("INVVPID type %ld VPID %lx GLA %lx %s",
> -	       !rc == valid, type, vpid, gla,
> +	report(!rc == valid, "INVVPID type %ld VPID %lx GLA %lx %s", type,
> +	       vpid, gla,
>  	       valid ? "passes" : "fails");
> -	report("After %s INVVPID, VMX_INST_ERR is %ld (actual %ld)",
> -	       vmcs_read(VMX_INST_ERROR) == expected,
> +	report(vmcs_read(VMX_INST_ERROR) == expected,
> +	       "After %s INVVPID, VMX_INST_ERR is %ld (actual %ld)",
>  	       rc ? "failed" : "successful",
>  	       expected, vmcs_read(VMX_INST_ERROR));
>  }
> @@ -3194,7 +3209,7 @@ static void invvpid_test_gp(void)
>  
>  	fault = test_for_exception(GP_VECTOR, &ds_invvpid,
>  				   (void *)NONCANONICAL);
> -	report("INVVPID with non-canonical DS operand raises #GP", fault);
> +	report(fault, "INVVPID with non-canonical DS operand raises #GP");
>  }
>  
>  static void invvpid_test_ss(void)
> @@ -3203,7 +3218,7 @@ static void invvpid_test_ss(void)
>  
>  	fault = test_for_exception(SS_VECTOR, &ss_invvpid,
>  				   (void *)NONCANONICAL);
> -	report("INVVPID with non-canonical SS operand raises #SS", fault);
> +	report(fault, "INVVPID with non-canonical SS operand raises #SS");
>  }
>  
>  static void invvpid_test_pf(void)
> @@ -3212,7 +3227,7 @@ static void invvpid_test_pf(void)
>  	bool fault;
>  
>  	fault = test_for_exception(PF_VECTOR, &ds_invvpid, vpage);
> -	report("INVVPID with unmapped operand raises #PF", fault);
> +	report(fault, "INVVPID with unmapped operand raises #PF");
>  }
>  
>  static void try_compat_invvpid(void *unused)
> @@ -3242,7 +3257,7 @@ static void invvpid_test_compatibility_mode(void)
>  	bool fault;
>  
>  	fault = test_for_exception(UD_VECTOR, &try_compat_invvpid, NULL);
> -	report("Compatibility mode INVVPID raises #UD", fault);
> +	report(fault, "Compatibility mode INVVPID raises #UD");
>  }
>  
>  static void invvpid_test_not_in_vmx_operation(void)
> @@ -3251,7 +3266,7 @@ static void invvpid_test_not_in_vmx_operation(void)
>  
>  	TEST_ASSERT(!vmx_off());
>  	fault = test_for_exception(UD_VECTOR, &ds_invvpid, NULL);
> -	report("INVVPID outside of VMX operation raises #UD", fault);
> +	report(fault, "INVVPID outside of VMX operation raises #UD");
>  	TEST_ASSERT(!vmx_on());
>  }
>  
> @@ -3357,12 +3372,13 @@ static void test_vmx_vmlaunch(u32 xerror, bool xfail)
>  	bool success = vmlaunch_succeeds();
>  	u32 vmx_inst_err;
>  
> -	report_xfail("vmlaunch %s", xfail, success == !xerror,
> +	report_xfail(xfail, success == !xerror, "vmlaunch %s",
>  		     !xerror ? "succeeds" : "fails");
>  	if (!success && xerror) {
>  		vmx_inst_err = vmcs_read(VMX_INST_ERROR);
> -		report("VMX inst error is %d (actual %d)",
> -		       vmx_inst_err == xerror, xerror, vmx_inst_err);
> +		report(vmx_inst_err == xerror,
> +		       "VMX inst error is %d (actual %d)", xerror,
> +		       vmx_inst_err);
>  	}
>  }
>  
> @@ -3499,8 +3515,8 @@ static void test_secondary_processor_based_ctls(void)
>  	 */
>  	vmcs_write(CPU_EXEC_CTRL0, primary & ~CPU_SECONDARY);
>  	vmcs_write(CPU_EXEC_CTRL1, ~0);
> -	report("Secondary processor-based controls ignored",
> -	       vmlaunch_succeeds());
> +	report(vmlaunch_succeeds(),
> +	       "Secondary processor-based controls ignored");
>  	vmcs_write(CPU_EXEC_CTRL1, secondary);
>  	vmcs_write(CPU_EXEC_CTRL0, primary);
>  }
> @@ -5045,7 +5061,7 @@ static void report_guest_state_test(const char *test, u32 xreason,
>  {
>  	u32 reason = vmcs_read(EXI_REASON);
>  
> -	report("%s, %s %lx", reason == xreason, test, field_name, field);
> +	report(reason == xreason, "%s, %s %lx", test, field_name, field);
>  	advance_guest_state_test();
>  }
>  
> @@ -5494,8 +5510,8 @@ static void apic_reg_virt_guest(void)
>  				u32 want = virt_fn(val);
>  				u32 got = virt_fn(ret);
>  
> -				report("read 0x%x, expected 0x%x.",
> -				       got == want, got, want);
> +				report(got == want,
> +				       "read 0x%x, expected 0x%x.", got, want);
>  			}
>  		} else if (op == APIC_OP_XAPIC_WR) {
>  			vmx_xapic_write(apic_access_address, reg, val);
> @@ -5548,14 +5564,15 @@ static void test_xapic_rd(
>  		u32 apic_page_offset = vmcs_read(EXI_QUALIFICATION) & 0xfff;
>  
>  		assert_exit_reason(exit_reason_want);
> -		report("got APIC access exit @ page offset 0x%03x, want 0x%03x",
> -		       apic_page_offset == reg, apic_page_offset, reg);
> +		report(apic_page_offset == reg,
> +		       "got APIC access exit @ page offset 0x%03x, want 0x%03x",
> +		       apic_page_offset, reg);
>  		skip_exit_insn();
>  
>  		/* Reenter guest so it can consume/check rcx and exit again. */
>  		enter_guest();
>  	} else if (exit_reason_want != VMX_VMCALL) {
> -		report("Oops, bad exit expectation: %u.", false,
> +		report(false, "Oops, bad exit expectation: %u.",
>  		       exit_reason_want);
>  	}
>  
> @@ -5601,16 +5618,17 @@ static void test_xapic_wr(
>  		u32 apic_page_offset = vmcs_read(EXI_QUALIFICATION) & 0xfff;
>  
>  		assert_exit_reason(exit_reason_want);
> -		report("got APIC access exit @ page offset 0x%03x, want 0x%03x",
> -		       apic_page_offset == reg, apic_page_offset, reg);
> +		report(apic_page_offset == reg,
> +		       "got APIC access exit @ page offset 0x%03x, want 0x%03x",
> +		       apic_page_offset, reg);
>  		skip_exit_insn();
>  
>  		/* Reenter guest so it can consume/check rcx and exit again. */
>  		enter_guest();
>  	} else if (exit_reason_want == VMX_APIC_WRITE) {
>  		assert_exit_reason(exit_reason_want);
> -		report("got APIC write exit @ page offset 0x%03x; val is 0x%x, want 0x%x",
> -		       virtual_apic_page[apic_reg_index(reg)] == val,
> +		report(virtual_apic_page[apic_reg_index(reg)] == val,
> +		       "got APIC write exit @ page offset 0x%03x; val is 0x%x, want 0x%x",
>  		       apic_reg_index(reg),
>  		       virtual_apic_page[apic_reg_index(reg)], val);
>  		checked = true;
> @@ -5618,7 +5636,7 @@ static void test_xapic_wr(
>  		/* Reenter guest so it can consume/check rcx and exit again. */
>  		enter_guest();
>  	} else if (exit_reason_want != VMX_VMCALL) {
> -		report("Oops, bad exit expectation: %u.", false,
> +		report(false, "Oops, bad exit expectation: %u.",
>  		       exit_reason_want);
>  	}
>  
> @@ -5628,15 +5646,17 @@ static void test_xapic_wr(
>  		u32 got = virtual_apic_page[apic_reg_index(reg)];
>  		got = expectation->virt_fn(got);
>  
> -		report("exitless write; val is 0x%x, want 0x%x",
> -		       got == want, got, want);
> +		report(got == want, "exitless write; val is 0x%x, want 0x%x",
> +		       got, want);
>  	} else if (!expectation->virtualize_apic_accesses && !checked) {
>  		u32 got = apic_access_address[apic_reg_index(reg)];
>  
> -		report("non-virtualized write; val is 0x%x, want 0x%x",
> -		       got == val, got, val);
> +		report(got == val,
> +		       "non-virtualized write; val is 0x%x, want 0x%x", got,
> +		       val);
>  	} else if (!expectation->virtualize_apic_accesses && checked) {
> -		report("Non-virtualized write was prematurely checked!", false);
> +		report(false,
> +		       "Non-virtualized write was prematurely checked!");
>  	}
>  
>  	skip_exit_vmcall();
> @@ -5795,7 +5815,7 @@ static void apic_reg_virt_test(void)
>  			ok = apic_reg_virt_exit_expectation(
>  				reg, apic_reg_virt_config, &expectation);
>  			if (!ok) {
> -				report("Malformed test.", false);
> +				report(false, "Malformed test.");
>  				break;
>  			}
>  
> @@ -6304,16 +6324,17 @@ static void virt_x2apic_mode_guest(void)
>  				u64 want = virt_fn(val);
>  				u64 got = virt_fn(ret);
>  
> -				report("APIC read; got 0x%lx, want 0x%lx.",
> -				       got == want, got, want);
> +				report(got == want,
> +				       "APIC read; got 0x%lx, want 0x%lx.",
> +				       got, want);
>  			}
>  		} else if (op == X2APIC_OP_WR) {
>  			vmx_x2apic_write(reg, val);
>  		}
>  
>  		if (should_gp) {
> -			report("x2APIC op triggered GP.",
> -			       handle_x2apic_gp_ran);
> +			report(handle_x2apic_gp_ran,
> +			       "x2APIC op triggered GP.");
>  			teardown_x2apic_gp_handler(old_handler);
>  		}
>  
> @@ -6351,7 +6372,7 @@ static void test_x2apic_rd(
>  	enter_guest();
>  
>  	if (exit_reason_want != VMX_VMCALL) {
> -		report("Oops, bad exit expectation: %u.", false,
> +		report(false, "Oops, bad exit expectation: %u.",
>  		       exit_reason_want);
>  	}
>  
> @@ -6408,21 +6429,21 @@ static void test_x2apic_wr(
>  		irq_enable();
>  		asm volatile ("nop");
>  		irq_disable();
> -		report("Got pending interrupt after IRQ enabled.",
> -		       handle_x2apic_ipi_ran);
> +		report(handle_x2apic_ipi_ran,
> +		       "Got pending interrupt after IRQ enabled.");
>  
>  		enter_guest();
>  	} else if (exit_reason_want == VMX_APIC_WRITE) {
>  		assert_exit_reason(exit_reason_want);
> -		report("got APIC write exit @ page offset 0x%03x; val is 0x%x, want 0x%lx",
> -		       virtual_apic_page[apic_reg_index(reg)] == val,
> +		report(virtual_apic_page[apic_reg_index(reg)] == val,
> +		       "got APIC write exit @ page offset 0x%03x; val is 0x%x, want 0x%lx",
>  		       apic_reg_index(reg),
>  		       virtual_apic_page[apic_reg_index(reg)], val);
>  
>  		/* Reenter guest so it can consume/check rcx and exit again. */
>  		enter_guest();
>  	} else if (exit_reason_want != VMX_VMCALL) {
> -		report("Oops, bad exit expectation: %u.", false,
> +		report(false, "Oops, bad exit expectation: %u.",
>  		       exit_reason_want);
>  	}
>  
> @@ -6431,8 +6452,8 @@ static void test_x2apic_wr(
>  		u64 want = val;
>  		u32 got = virtual_apic_page[apic_reg_index(reg)];
>  
> -		report("x2APIC write; got 0x%x, want 0x%lx",
> -		       got == want, got, want);
> +		report(got == want, "x2APIC write; got 0x%x, want 0x%lx", got,
> +		       want);
>  	} else if (expectation->wr_behavior == X2APIC_ACCESS_PASSED_THROUGH) {
>  		if (!expectation->wr_only) {
>  			u32 got = apic_read(reg);
> @@ -6461,11 +6482,12 @@ static void test_x2apic_wr(
>  			}
>  
>  			ok = got == val;
> -			report("non-virtualized write; val is 0x%x, want 0x%lx",
> -			       ok, got, val);
> +			report(ok,
> +			       "non-virtualized write; val is 0x%x, want 0x%lx",
> +			       got, val);
>  			apic_write(reg, restore_val);
>  		} else {
> -			report("non-virtualized and write-only OK", true);
> +			report(true, "non-virtualized and write-only OK");
>  		}
>  	}
>  	skip_exit_insn();
> @@ -6734,10 +6756,12 @@ static void test_efer_vmlaunch(u32 fld, bool ok)
>  	} else {
>  		if (ok) {
>  			enter_guest();
> -			report("vmlaunch succeeds", vmcs_read(EXI_REASON) == VMX_VMCALL);
> +			report(vmcs_read(EXI_REASON) == VMX_VMCALL,
> +			       "vmlaunch succeeds");
>  		} else {
>  			enter_guest_with_invalid_guest_state();
> -			report("vmlaunch fails", vmcs_read(EXI_REASON) == (VMX_ENTRY_FAILURE | VMX_FAIL_STATE));
> +			report(vmcs_read(EXI_REASON) == (VMX_ENTRY_FAILURE | VMX_FAIL_STATE),
> +			       "vmlaunch fails");
>  		}
>  		advance_guest_state_test();
>  	}
> @@ -7337,12 +7361,12 @@ static void try_vmentry_in_movss_shadow(void)
>  			      : "rdx", "cc", "memory");
>  	vm_inst_err = vmcs_read(VMX_INST_ERROR);
>  
> -	report("Early VM-entry failure", early_failure);
> -	report("RFLAGS[8:0] is %x (actual %x)", flags == expected_flags,
> +	report(early_failure, "Early VM-entry failure");
> +	report(flags == expected_flags, "RFLAGS[8:0] is %x (actual %x)",
>  	       expected_flags, flags);
>  	if (valid_vmcs)
> -		report("VM-instruction error is %d (actual %d)",
> -		       vm_inst_err == VMXERR_ENTRY_EVENTS_BLOCKED_BY_MOV_SS,
> +		report(vm_inst_err == VMXERR_ENTRY_EVENTS_BLOCKED_BY_MOV_SS,
> +		       "VM-instruction error is %d (actual %d)",
>  		       VMXERR_ENTRY_EVENTS_BLOCKED_BY_MOV_SS, vm_inst_err);
>  }
>  
> @@ -7444,7 +7468,7 @@ static void check_nm_exit(const char *test)
>  	const u32 expected = INTR_INFO_VALID_MASK | INTR_TYPE_HARD_EXCEPTION |
>  		NM_VECTOR;
>  
> -	report("%s", reason == VMX_EXC_NMI && intr_info == expected, test);
> +	report(reason == VMX_EXC_NMI && intr_info == expected, "%s", test);
>  }
>  
>  /*
> @@ -7535,21 +7559,21 @@ static void vmx_pending_event_test_core(bool guest_hlt)
>  	enter_guest();
>  
>  	assert_exit_reason(VMX_EXTINT);
> -	report("Guest did not run before host received IPI",
> -		   !vmx_pending_event_guest_run);
> +	report(!vmx_pending_event_guest_run,
> +	       "Guest did not run before host received IPI");
>  
>  	irq_enable();
>  	asm volatile ("nop");
>  	irq_disable();
> -	report("Got pending interrupt after IRQ enabled",
> -		   vmx_pending_event_ipi_fired);
> +	report(vmx_pending_event_ipi_fired,
> +	       "Got pending interrupt after IRQ enabled");
>  
>  	if (guest_hlt)
>  		vmcs_write(GUEST_ACTV_STATE, ACTV_ACTIVE);
>  
>  	enter_guest();
> -	report("Guest finished running when no interrupt",
> -		   vmx_pending_event_guest_run);
> +	report(vmx_pending_event_guest_run,
> +	       "Guest finished running when no interrupt");
>  }
>  
>  static void vmx_pending_event_test(void)
> @@ -7583,9 +7607,9 @@ static void verify_nmi_window_exit(u64 rip)
>  {
>  	u32 exit_reason = vmcs_read(EXI_REASON);
>  
> -	report("Exit reason (%d) is 'NMI window'",
> -	       exit_reason == VMX_NMI_WINDOW, exit_reason);
> -	report("RIP (%#lx) is %#lx", vmcs_read(GUEST_RIP) == rip,
> +	report(exit_reason == VMX_NMI_WINDOW,
> +	       "Exit reason (%d) is 'NMI window'", exit_reason);
> +	report(vmcs_read(GUEST_RIP) == rip, "RIP (%#lx) is %#lx",
>  	       vmcs_read(GUEST_RIP), rip);
>  	vmcs_write(GUEST_ACTV_STATE, ACTV_ACTIVE);
>  }
> @@ -7656,8 +7680,8 @@ static void vmx_nmi_window_test(void)
>  	vmcs_write(GUEST_INTR_STATE, GUEST_INTR_STATE_NMI);
>  	enter_guest();
>  	verify_nmi_window_exit(nop_addr + 1);
> -	report("#DB handler executed once (actual %d times)",
> -	       vmx_window_test_db_count == 1,
> +	report(vmx_window_test_db_count == 1,
> +	       "#DB handler executed once (actual %d times)",
>  	       vmx_window_test_db_count);
>  	report_prefix_pop();
>  
> @@ -7717,9 +7741,9 @@ static void verify_intr_window_exit(u64 rip)
>  {
>  	u32 exit_reason = vmcs_read(EXI_REASON);
>  
> -	report("Exit reason (%d) is 'interrupt window'",
> -	       exit_reason == VMX_INTR_WINDOW, exit_reason);
> -	report("RIP (%#lx) is %#lx", vmcs_read(GUEST_RIP) == rip,
> +	report(exit_reason == VMX_INTR_WINDOW,
> +	       "Exit reason (%d) is 'interrupt window'", exit_reason);
> +	report(vmcs_read(GUEST_RIP) == rip, "RIP (%#lx) is %#lx",
>  	       vmcs_read(GUEST_RIP), rip);
>  	vmcs_write(GUEST_ACTV_STATE, ACTV_ACTIVE);
>  }
> @@ -7899,12 +7923,12 @@ static void vmx_store_tsc_test(void)
>  	enter_guest();
>  	high = rdtsc();
>  
> -	report("RDTSC value in the guest (%lu) is in range [%lu, %lu]",
> -	       low + GUEST_TSC_OFFSET <= guest_tsc &&
> +	report(low + GUEST_TSC_OFFSET <= guest_tsc &&
>  	       guest_tsc <= high + GUEST_TSC_OFFSET,
> +	       "RDTSC value in the guest (%lu) is in range [%lu, %lu]",
>  	       guest_tsc, low + GUEST_TSC_OFFSET, high + GUEST_TSC_OFFSET);
> -	report("IA32_TSC value saved in the VM-exit MSR-store list (%lu) is in range [%lu, %lu]",
> -	       low <= msr_entry.value && msr_entry.value <= high,
> +	report(low <= msr_entry.value && msr_entry.value <= high,
> +	       "IA32_TSC value saved in the VM-exit MSR-store list (%lu) is in range [%lu, %lu]",
>  	       msr_entry.value, low, high);
>  }
>  
> @@ -7973,17 +7997,18 @@ static void check_db_exit(bool xfail_qual, bool xfail_dr6, bool xfail_pdbg,
>  	const u32 expected_intr_info = INTR_INFO_VALID_MASK |
>  		INTR_TYPE_HARD_EXCEPTION | DB_VECTOR;
>  
> -	report("Expected #DB VM-exit",
> -	       reason == VMX_EXC_NMI && intr_info == expected_intr_info);
> -	report("Expected RIP %p (actual %lx)", (u64)expected_rip == guest_rip,
> +	report(reason == VMX_EXC_NMI && intr_info == expected_intr_info,
> +	       "Expected #DB VM-exit");
> +	report((u64)expected_rip == guest_rip, "Expected RIP %p (actual %lx)",
>  	       expected_rip, guest_rip);
> -	report_xfail("Expected pending debug exceptions 0 (actual %lx)",
> -		     xfail_pdbg, 0 == guest_pending_dbg, guest_pending_dbg);
> -	report_xfail("Expected exit qualification %lx (actual %lx)", xfail_qual,
> -		     expected_exit_qual == exit_qual,
> +	report_xfail(xfail_pdbg, 0 == guest_pending_dbg,
> +		     "Expected pending debug exceptions 0 (actual %lx)",
> +		     guest_pending_dbg);
> +	report_xfail(xfail_qual, expected_exit_qual == exit_qual,
> +		     "Expected exit qualification %lx (actual %lx)",
>  		     expected_exit_qual, exit_qual);
> -	report_xfail("Expected DR6 %lx (actual %lx)", xfail_dr6,
> -		     expected_dr6 == dr6, expected_dr6, dr6);
> +	report_xfail(xfail_dr6, expected_dr6 == dr6,
> +		     "Expected DR6 %lx (actual %lx)", expected_dr6, dr6);
>  	dismiss_db();
>  }
>  
> @@ -8202,7 +8227,7 @@ static void vmx_eoi_bitmap_ioapic_scan_test(void)
>  
>  	/* Let L2 finish */
>  	enter_guest();
> -	report(__func__, 1);
> +	report(1, __func__);
>  }
>  
>  #define HLT_WITH_RVI_VECTOR		(0xf1)
> @@ -8243,7 +8268,7 @@ static void vmx_hlt_with_rvi_test(void)
>  	vmcs_write(GUEST_INT_STATUS, HLT_WITH_RVI_VECTOR);
>  	enter_guest();
>  
> -	report("Interrupt raised in guest", vmx_hlt_with_rvi_guest_isr_fired);
> +	report(vmx_hlt_with_rvi_guest_isr_fired, "Interrupt raised in guest");
>  }
>  
>  static void set_irq_line_thread(void *data)
> @@ -8330,7 +8355,7 @@ static void vmx_apic_passthrough(bool set_irq_line_from_thread)
>  
>  	/* Let L2 finish */
>  	enter_guest();
> -	report(__func__, 1);
> +	report(1, __func__);
>  }
>  
>  static void vmx_apic_passthrough_test(void)
> @@ -8438,8 +8463,8 @@ static void vmx_init_signal_test(void)
>  	 * VMX operation
>  	 */
>  	delay(INIT_SIGNAL_TEST_DELAY);
> -	report("INIT signal blocked when CPU in VMX operation",
> -		   vmx_get_test_stage() == 3);
> +	report(vmx_get_test_stage() == 3,
> +	       "INIT signal blocked when CPU in VMX operation");
>  	/* No point to continue if we failed at this point */
>  	if (vmx_get_test_stage() != 3)
>  		return;
> @@ -8453,11 +8478,11 @@ static void vmx_init_signal_test(void)
>  	 */
>  	delay(INIT_SIGNAL_TEST_DELAY);
>  	if (vmx_get_test_stage() != 5) {
> -		report("Pending INIT signal didn't result in VMX exit", false);
> +		report(false, "Pending INIT signal didn't result in VMX exit");
>  		return;
>  	}
> -	report("INIT signal during VMX non-root mode result in exit-reason %s (%lu)",
> -			init_signal_test_exit_reason == VMX_INIT,
> +	report(init_signal_test_exit_reason == VMX_INIT,
> +			"INIT signal during VMX non-root mode result in exit-reason %s (%lu)",
>  			exit_reason_description(init_signal_test_exit_reason),
>  			init_signal_test_exit_reason);
>  
> @@ -8474,8 +8499,8 @@ static void vmx_init_signal_test(void)
>  	 * to run after INIT signal was processed
>  	 */
>  	delay(INIT_SIGNAL_TEST_DELAY);
> -	report("INIT signal processed after exit VMX operation",
> -		   !init_signal_test_thread_continued);
> +	report(!init_signal_test_thread_continued,
> +	       "INIT signal processed after exit VMX operation");
>  
>  	/*
>  	 * TODO: Send SIPI to other CPU to sipi_entry (See x86/cstart64.S)
> @@ -8618,9 +8643,9 @@ static void vmcs_shadow_test_field(u8 *bitmap[2], u64 field)
>  		set_bit(field, bitmap[ACCESS_VMWRITE]);
>  	}
>  	vmcs_shadow_test_access(bitmap, ACCESS_VMWRITE);
> -	report("not shadowed for VMWRITE", c->reason == VMX_VMWRITE);
> +	report(c->reason == VMX_VMWRITE, "not shadowed for VMWRITE");
>  	vmcs_shadow_test_access(bitmap, ACCESS_VMREAD);
> -	report("not shadowed for VMREAD", c->reason == VMX_VMREAD);
> +	report(c->reason == VMX_VMREAD, "not shadowed for VMREAD");
>  	report_prefix_pop();
>  
>  	if (field >> VMCS_FIELD_RESERVED_SHIFT)
> @@ -8633,20 +8658,21 @@ static void vmcs_shadow_test_field(u8 *bitmap[2], u64 field)
>  	if (good_shadow)
>  		value = vmwrite_to_shadow(field, MAGIC_VAL_1 + field);
>  	vmcs_shadow_test_access(bitmap, ACCESS_VMWRITE);
> -	report("not shadowed for VMWRITE", c->reason == VMX_VMWRITE);
> +	report(c->reason == VMX_VMWRITE, "not shadowed for VMWRITE");
>  	vmcs_shadow_test_access(bitmap, ACCESS_VMREAD);
>  	vmx_inst_error = vmcs_read(VMX_INST_ERROR);
> -	report("shadowed for VMREAD (in %ld cycles)", c->reason == VMX_VMCALL,
> +	report(c->reason == VMX_VMCALL, "shadowed for VMREAD (in %ld cycles)",
>  	       c->time);
> -	report("ALU flags after VMREAD (%lx) are as expected (%lx)",
> -	       c->flags == flags[ACCESS_VMREAD],
> +	report(c->flags == flags[ACCESS_VMREAD],
> +	       "ALU flags after VMREAD (%lx) are as expected (%lx)",
>  	       c->flags, flags[ACCESS_VMREAD]);
>  	if (good_shadow)
> -		report("value read from shadow (%lx) is as expected (%lx)",
> -		       c->value == value, c->value, value);
> +		report(c->value == value,
> +		       "value read from shadow (%lx) is as expected (%lx)",
> +		       c->value, value);
>  	else if (shadow != (struct vmcs *)-1ull && flags[ACCESS_VMREAD])
> -		report("VMX_INST_ERROR (%d) is as expected (%d)",
> -		       vmx_inst_error == VMXERR_UNSUPPORTED_VMCS_COMPONENT,
> +		report(vmx_inst_error == VMXERR_UNSUPPORTED_VMCS_COMPONENT,
> +		       "VMX_INST_ERROR (%d) is as expected (%d)",
>  		       vmx_inst_error, VMXERR_UNSUPPORTED_VMCS_COMPONENT);
>  	report_prefix_pop();
>  
> @@ -8658,22 +8684,24 @@ static void vmcs_shadow_test_field(u8 *bitmap[2], u64 field)
>  		vmwrite_to_shadow(field, MAGIC_VAL_1 + field);
>  	vmcs_shadow_test_access(bitmap, ACCESS_VMWRITE);
>  	vmx_inst_error = vmcs_read(VMX_INST_ERROR);
> -	report("shadowed for VMWRITE (in %ld cycles)", c->reason == VMX_VMCALL,
> +	report(c->reason == VMX_VMCALL,
> +		"shadowed for VMWRITE (in %ld cycles)",
>  		c->time);
> -	report("ALU flags after VMWRITE (%lx) are as expected (%lx)",
> -	       c->flags == flags[ACCESS_VMREAD],
> +	report(c->flags == flags[ACCESS_VMREAD],
> +	       "ALU flags after VMWRITE (%lx) are as expected (%lx)",
>  	       c->flags, flags[ACCESS_VMREAD]);
>  	if (good_shadow) {
>  		value = vmread_from_shadow(field);
> -		report("shadow VMCS value (%lx) is as expected (%lx)",
> -		       value == 0, value, 0ul);
> +		report(value == 0,
> +		       "shadow VMCS value (%lx) is as expected (%lx)", value,
> +		       0ul);
>  	} else if (shadow != (struct vmcs *)-1ull && flags[ACCESS_VMWRITE]) {
> -		report("VMX_INST_ERROR (%d) is as expected (%d)",
> -		       vmx_inst_error == VMXERR_UNSUPPORTED_VMCS_COMPONENT,
> +		report(vmx_inst_error == VMXERR_UNSUPPORTED_VMCS_COMPONENT,
> +		       "VMX_INST_ERROR (%d) is as expected (%d)",
>  		       vmx_inst_error, VMXERR_UNSUPPORTED_VMCS_COMPONENT);
>  	}
>  	vmcs_shadow_test_access(bitmap, ACCESS_VMREAD);
> -	report("not shadowed for VMREAD", c->reason == VMX_VMREAD);
> +	report(c->reason == VMX_VMREAD, "not shadowed for VMREAD");
>  	report_prefix_pop();
>  
>  	/* Permit shadowed VMREAD and VMWRITE. */
> @@ -8684,33 +8712,36 @@ static void vmcs_shadow_test_field(u8 *bitmap[2], u64 field)
>  		vmwrite_to_shadow(field, MAGIC_VAL_1 + field);
>  	vmcs_shadow_test_access(bitmap, ACCESS_VMWRITE);
>  	vmx_inst_error = vmcs_read(VMX_INST_ERROR);
> -	report("shadowed for VMWRITE (in %ld cycles)", c->reason == VMX_VMCALL,
> +	report(c->reason == VMX_VMCALL,
> +		"shadowed for VMWRITE (in %ld cycles)",
>  		c->time);
> -	report("ALU flags after VMWRITE (%lx) are as expected (%lx)",
> -	       c->flags == flags[ACCESS_VMREAD],
> +	report(c->flags == flags[ACCESS_VMREAD],
> +	       "ALU flags after VMWRITE (%lx) are as expected (%lx)",
>  	       c->flags, flags[ACCESS_VMREAD]);
>  	if (good_shadow) {
>  		value = vmread_from_shadow(field);
> -		report("shadow VMCS value (%lx) is as expected (%lx)",
> -		       value == 0, value, 0ul);
> +		report(value == 0,
> +		       "shadow VMCS value (%lx) is as expected (%lx)", value,
> +		       0ul);
>  	} else if (shadow != (struct vmcs *)-1ull && flags[ACCESS_VMWRITE]) {
> -		report("VMX_INST_ERROR (%d) is as expected (%d)",
> -		       vmx_inst_error == VMXERR_UNSUPPORTED_VMCS_COMPONENT,
> +		report(vmx_inst_error == VMXERR_UNSUPPORTED_VMCS_COMPONENT,
> +		       "VMX_INST_ERROR (%d) is as expected (%d)",
>  		       vmx_inst_error, VMXERR_UNSUPPORTED_VMCS_COMPONENT);
>  	}
>  	vmcs_shadow_test_access(bitmap, ACCESS_VMREAD);
>  	vmx_inst_error = vmcs_read(VMX_INST_ERROR);
> -	report("shadowed for VMREAD (in %ld cycles)", c->reason == VMX_VMCALL,
> +	report(c->reason == VMX_VMCALL, "shadowed for VMREAD (in %ld cycles)",
>  	       c->time);
> -	report("ALU flags after VMREAD (%lx) are as expected (%lx)",
> -	       c->flags == flags[ACCESS_VMREAD],
> +	report(c->flags == flags[ACCESS_VMREAD],
> +	       "ALU flags after VMREAD (%lx) are as expected (%lx)",
>  	       c->flags, flags[ACCESS_VMREAD]);
>  	if (good_shadow)
> -		report("value read from shadow (%lx) is as expected (%lx)",
> -		       c->value == 0, c->value, 0ul);
> +		report(c->value == 0,
> +		       "value read from shadow (%lx) is as expected (%lx)",
> +		       c->value, 0ul);
>  	else if (shadow != (struct vmcs *)-1ull && flags[ACCESS_VMREAD])
> -		report("VMX_INST_ERROR (%d) is as expected (%d)",
> -		       vmx_inst_error == VMXERR_UNSUPPORTED_VMCS_COMPONENT,
> +		report(vmx_inst_error == VMXERR_UNSUPPORTED_VMCS_COMPONENT,
> +		       "VMX_INST_ERROR (%d) is as expected (%d)",
>  		       vmx_inst_error, VMXERR_UNSUPPORTED_VMCS_COMPONENT);
>  	report_prefix_pop();
>  
> @@ -8817,12 +8848,12 @@ static int invalid_msr_init(struct vmcs *vmcs)
>  
>  static void invalid_msr_main(void)
>  {
> -	report("Invalid MSR load", 0);
> +	report(0, "Invalid MSR load");
>  }
>  
>  static int invalid_msr_exit_handler(void)
>  {
> -	report("Invalid MSR load", 0);
> +	report(0, "Invalid MSR load");
>  	print_vmexit_info();
>  	return VMX_TEST_EXIT;
>  }
> @@ -8832,7 +8863,7 @@ static int invalid_msr_entry_failure(struct vmentry_failure *failure)
>  	ulong reason;
>  
>  	reason = vmcs_read(EXI_REASON);
> -	report("Invalid MSR load", reason == (0x80000000u | VMX_FAIL_MSR));
> +	report(reason == (0x80000000u | VMX_FAIL_MSR), "Invalid MSR load");
>  	return VMX_TEST_VMEXIT;
>  }
>  
> @@ -8933,12 +8964,12 @@ static void atomic_switch_msrs_test(int count)
>  
>  		exit_reason = vmcs_read(EXI_REASON);
>  		exit_reason_want = VMX_FAIL_MSR | VMX_ENTRY_FAILURE;
> -		report("exit_reason, %u, is %u.",
> -		       exit_reason == exit_reason_want, exit_reason,
> +		report(exit_reason == exit_reason_want,
> +		       "exit_reason, %u, is %u.", exit_reason,
>  		       exit_reason_want);
>  
>  		exit_qual = vmcs_read(EXI_QUALIFICATION);
> -		report("exit_qual, %u, is %u.", exit_qual == max_allowed + 1,
> +		report(exit_qual == max_allowed + 1, "exit_qual, %u, is %u.",
>  		       exit_qual, max_allowed + 1);
>  	}
>  
> diff --git a/x86/xsave.c b/x86/xsave.c
> index f243c80..93ba769 100644
> --- a/x86/xsave.c
> +++ b/x86/xsave.c
> @@ -63,69 +63,69 @@ static void test_xsave(void)
>      printf("Supported XCR0 bits: %#lx\n", supported_xcr0);
>  
>      test_bits = XSTATE_FP | XSTATE_SSE;
> -    report("Check minimal XSAVE required bits",
> -		    (supported_xcr0 & test_bits) == test_bits);
> +    report((supported_xcr0 & test_bits) == test_bits,
> +           "Check minimal XSAVE required bits");
>  
>      cr4 = read_cr4();
> -    report("Set CR4 OSXSAVE", write_cr4_checking(cr4 | X86_CR4_OSXSAVE) == 0);
> -    report("Check CPUID.1.ECX.OSXSAVE - expect 1",
> -		    this_cpu_has(X86_FEATURE_OSXSAVE));
> +    report(write_cr4_checking(cr4 | X86_CR4_OSXSAVE) == 0, "Set CR4 OSXSAVE");
> +    report(this_cpu_has(X86_FEATURE_OSXSAVE),
> +           "Check CPUID.1.ECX.OSXSAVE - expect 1");
>  
>      printf("\tLegal tests\n");
>      test_bits = XSTATE_FP;
> -    report("\t\txsetbv(XCR_XFEATURE_ENABLED_MASK, XSTATE_FP)",
> -	xsetbv_checking(XCR_XFEATURE_ENABLED_MASK, test_bits) == 0);
> +    report(xsetbv_checking(XCR_XFEATURE_ENABLED_MASK, test_bits) == 0,
> +           "\t\txsetbv(XCR_XFEATURE_ENABLED_MASK, XSTATE_FP)");
>  
>      test_bits = XSTATE_FP | XSTATE_SSE;
> -    report("\t\txsetbv(XCR_XFEATURE_ENABLED_MASK, XSTATE_FP | XSTATE_SSE)",
> -	xsetbv_checking(XCR_XFEATURE_ENABLED_MASK, test_bits) == 0);
> -    report("        xgetbv(XCR_XFEATURE_ENABLED_MASK)",
> -	xgetbv_checking(XCR_XFEATURE_ENABLED_MASK, &xcr0) == 0);
> +    report(xsetbv_checking(XCR_XFEATURE_ENABLED_MASK, test_bits) == 0,
> +           "\t\txsetbv(XCR_XFEATURE_ENABLED_MASK, XSTATE_FP | XSTATE_SSE)");
> +    report(xgetbv_checking(XCR_XFEATURE_ENABLED_MASK, &xcr0) == 0,
> +           "        xgetbv(XCR_XFEATURE_ENABLED_MASK)");
>  
>      printf("\tIllegal tests\n");
>      test_bits = 0;
> -    report("\t\txsetbv(XCR_XFEATURE_ENABLED_MASK, 0) - expect #GP",
> -	xsetbv_checking(XCR_XFEATURE_ENABLED_MASK, test_bits) == GP_VECTOR);
> +    report(xsetbv_checking(XCR_XFEATURE_ENABLED_MASK, test_bits) == GP_VECTOR,
> +           "\t\txsetbv(XCR_XFEATURE_ENABLED_MASK, 0) - expect #GP");
>  
>      test_bits = XSTATE_SSE;
> -    report("\t\txsetbv(XCR_XFEATURE_ENABLED_MASK, XSTATE_SSE) - expect #GP",
> -	xsetbv_checking(XCR_XFEATURE_ENABLED_MASK, test_bits) == GP_VECTOR);
> +    report(xsetbv_checking(XCR_XFEATURE_ENABLED_MASK, test_bits) == GP_VECTOR,
> +           "\t\txsetbv(XCR_XFEATURE_ENABLED_MASK, XSTATE_SSE) - expect #GP");
>  
>      if (supported_xcr0 & XSTATE_YMM) {
>          test_bits = XSTATE_YMM;
> -        report("\t\txsetbv(XCR_XFEATURE_ENABLED_MASK, XSTATE_YMM) - expect #GP",
> -		xsetbv_checking(XCR_XFEATURE_ENABLED_MASK, test_bits) == GP_VECTOR);
> +        report(xsetbv_checking(XCR_XFEATURE_ENABLED_MASK, test_bits) == GP_VECTOR,
> +               "\t\txsetbv(XCR_XFEATURE_ENABLED_MASK, XSTATE_YMM) - expect #GP");
>  
>          test_bits = XSTATE_FP | XSTATE_YMM;
> -        report("\t\txsetbv(XCR_XFEATURE_ENABLED_MASK, XSTATE_FP | XSTATE_YMM) - expect #GP",
> -		xsetbv_checking(XCR_XFEATURE_ENABLED_MASK, test_bits) == GP_VECTOR);
> +        report(xsetbv_checking(XCR_XFEATURE_ENABLED_MASK, test_bits) == GP_VECTOR,
> +               "\t\txsetbv(XCR_XFEATURE_ENABLED_MASK, XSTATE_FP | XSTATE_YMM) - expect #GP");
>      }
>  
>      test_bits = XSTATE_SSE;
> -    report("\t\txsetbv(XCR_XFEATURE_ILLEGAL_MASK, XSTATE_FP) - expect #GP",
> -	xsetbv_checking(XCR_XFEATURE_ILLEGAL_MASK, test_bits) == GP_VECTOR);
> +    report(xsetbv_checking(XCR_XFEATURE_ILLEGAL_MASK, test_bits) == GP_VECTOR,
> +           "\t\txsetbv(XCR_XFEATURE_ILLEGAL_MASK, XSTATE_FP) - expect #GP");
>  
>      test_bits = XSTATE_SSE;
> -    report("\t\txgetbv(XCR_XFEATURE_ILLEGAL_MASK, XSTATE_FP) - expect #GP",
> -	xsetbv_checking(XCR_XFEATURE_ILLEGAL_MASK, test_bits) == GP_VECTOR);
> +    report(xsetbv_checking(XCR_XFEATURE_ILLEGAL_MASK, test_bits) == GP_VECTOR,
> +           "\t\txgetbv(XCR_XFEATURE_ILLEGAL_MASK, XSTATE_FP) - expect #GP");
>  
>      cr4 &= ~X86_CR4_OSXSAVE;
> -    report("Unset CR4 OSXSAVE", write_cr4_checking(cr4) == 0);
> -    report("Check CPUID.1.ECX.OSXSAVE - expect 0",
> -	this_cpu_has(X86_FEATURE_OSXSAVE) == 0);
> +    report(write_cr4_checking(cr4) == 0, "Unset CR4 OSXSAVE");
> +    report(this_cpu_has(X86_FEATURE_OSXSAVE) == 0,
> +           "Check CPUID.1.ECX.OSXSAVE - expect 0");
>  
>      printf("\tIllegal tests:\n");
>      test_bits = XSTATE_FP;
> -    report("\t\txsetbv(XCR_XFEATURE_ENABLED_MASK, XSTATE_FP) - expect #UD",
> -	xsetbv_checking(XCR_XFEATURE_ENABLED_MASK, test_bits) == UD_VECTOR);
> +    report(xsetbv_checking(XCR_XFEATURE_ENABLED_MASK, test_bits) == UD_VECTOR,
> +           "\t\txsetbv(XCR_XFEATURE_ENABLED_MASK, XSTATE_FP) - expect #UD");
>  
>      test_bits = XSTATE_FP | XSTATE_SSE;
> -    report("\t\txsetbv(XCR_XFEATURE_ENABLED_MASK, XSTATE_FP | XSTATE_SSE) - expect #UD",
> -	xsetbv_checking(XCR_XFEATURE_ENABLED_MASK, test_bits) == UD_VECTOR);
> +    report(xsetbv_checking(XCR_XFEATURE_ENABLED_MASK, test_bits) == UD_VECTOR,
> +           "\t\txsetbv(XCR_XFEATURE_ENABLED_MASK, XSTATE_FP | XSTATE_SSE) - expect #UD");
>  
>      printf("\tIllegal tests:\n");
> -    report("\txgetbv(XCR_XFEATURE_ENABLED_MASK) - expect #UD",
> -	xgetbv_checking(XCR_XFEATURE_ENABLED_MASK, &xcr0) == UD_VECTOR);
> +    report(xgetbv_checking(XCR_XFEATURE_ENABLED_MASK, &xcr0) == UD_VECTOR,
> +           "\txgetbv(XCR_XFEATURE_ENABLED_MASK) - expect #UD");
>  }
>  
>  static void test_no_xsave(void)
> @@ -133,20 +133,20 @@ static void test_no_xsave(void)
>      unsigned long cr4;
>      u64 xcr0;
>  
> -    report("Check CPUID.1.ECX.OSXSAVE - expect 0",
> -	this_cpu_has(X86_FEATURE_OSXSAVE) == 0);
> +    report(this_cpu_has(X86_FEATURE_OSXSAVE) == 0,
> +           "Check CPUID.1.ECX.OSXSAVE - expect 0");
>  
>      printf("Illegal instruction testing:\n");
>  
>      cr4 = read_cr4();
> -    report("Set OSXSAVE in CR4 - expect #GP",
> -	write_cr4_checking(cr4 | X86_CR4_OSXSAVE) == GP_VECTOR);
> +    report(write_cr4_checking(cr4 | X86_CR4_OSXSAVE) == GP_VECTOR,
> +           "Set OSXSAVE in CR4 - expect #GP");
>  
> -    report("Execute xgetbv - expect #UD",
> -	xgetbv_checking(XCR_XFEATURE_ENABLED_MASK, &xcr0) == UD_VECTOR);
> +    report(xgetbv_checking(XCR_XFEATURE_ENABLED_MASK, &xcr0) == UD_VECTOR,
> +           "Execute xgetbv - expect #UD");
>  
> -    report("Execute xsetbv - expect #UD",
> -	xsetbv_checking(XCR_XFEATURE_ENABLED_MASK, 0x3) == UD_VECTOR);
> +    report(xsetbv_checking(XCR_XFEATURE_ENABLED_MASK, 0x3) == UD_VECTOR,
> +           "Execute xsetbv - expect #UD");
>  }
>  
>  int main(void)
> -- 
> 2.18.1
> 
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
