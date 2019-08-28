Return-Path: <SRS0=VgM6=WY=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 27BB1C3A5A1
	for <kvmarm@archiver.kernel.org>; Wed, 28 Aug 2019 14:45:32 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id A79B22077B
	for <kvmarm@archiver.kernel.org>; Wed, 28 Aug 2019 14:45:31 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A79B22077B
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 16C204A58D;
	Wed, 28 Aug 2019 10:45:31 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id x8ByNys2IUD9; Wed, 28 Aug 2019 10:45:29 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E9F094A533;
	Wed, 28 Aug 2019 10:45:29 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6AB0D4A4DF
 for <kvmarm@lists.cs.columbia.edu>; Wed, 28 Aug 2019 10:45:28 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 3IOlxRWtxDlo for <kvmarm@lists.cs.columbia.edu>;
 Wed, 28 Aug 2019 10:45:27 -0400 (EDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 36F654A4C1
 for <kvmarm@lists.cs.columbia.edu>; Wed, 28 Aug 2019 10:45:27 -0400 (EDT)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com
 [10.5.11.14])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mx1.redhat.com (Postfix) with ESMTPS id 5C3C6881342;
 Wed, 28 Aug 2019 14:45:26 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.43.2.160])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 808645D9E2;
 Wed, 28 Aug 2019 14:45:24 +0000 (UTC)
Date: Wed, 28 Aug 2019 16:45:22 +0200
From: Andrew Jones <drjones@redhat.com>
To: Alexandru Elisei <alexandru.elisei@arm.com>
Subject: Re: [kvm-unit-tests RFC PATCH 02/16] arm/arm64: psci: Don't run C
 code without stack or vectors
Message-ID: <20190828144522.qkmckjcmrdayfq7r@kamzik.brq.redhat.com>
References: <1566999511-24916-1-git-send-email-alexandru.elisei@arm.com>
 <1566999511-24916-3-git-send-email-alexandru.elisei@arm.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1566999511-24916-3-git-send-email-alexandru.elisei@arm.com>
User-Agent: NeoMutt/20180716
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.6.2
 (mx1.redhat.com [10.5.110.69]); Wed, 28 Aug 2019 14:45:26 +0000 (UTC)
Cc: kvm@vger.kernel.org, maz@kernel.org, andre.przywara@arm.com,
 pbonzini@redhat.com, kvmarm@lists.cs.columbia.edu
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

On Wed, Aug 28, 2019 at 02:38:17PM +0100, Alexandru Elisei wrote:
> The psci test performs a series of CPU_ON/CPU_OFF cycles for CPU 1. This is
> done by setting the entry point for the CPU_ON call to the physical address
> of the C function cpu_psci_cpu_die.
> 
> The compiler is well within its rights to use the stack when generating
> code for cpu_psci_cpu_die.  However, because no stack initialization has
> been done, the stack pointer is zero, as set by KVM when creating the VCPU.
> This causes a data abort without a change in exception level. The VBAR_EL1
> register is also zero (the KVM reset value for VBAR_EL1), the MMU is off,
> and we end up trying to fetch instructions from address 0x200.
> 
> At this point, a stage 2 instruction abort is generated which is taken to
> KVM. KVM interprets this as an instruction fetch from an I/O region, and
> injects a prefetch abort into the guest. Prefetch abort is a synchronous
> exception, and on guest return the VCPU PC will be set to VBAR_EL1 + 0x200,
> which is...  0x200. The VCPU ends up in an infinite loop causing a prefetch
> abort while fetching the instruction to service the said abort.
> 
> cpu_psci_cpu_die is basically a wrapper over the HVC instruction, so
> provide an assembly implementation for the function which will serve as the
> entry point for CPU_ON.
> 
> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
> ---
>  arm/cstart.S   | 7 +++++++
>  arm/cstart64.S | 7 +++++++
>  arm/psci.c     | 5 +++--
>  3 files changed, 17 insertions(+), 2 deletions(-)
> 
> diff --git a/arm/cstart.S b/arm/cstart.S
> index 114726feab82..5d4fe4b1570b 100644
> --- a/arm/cstart.S
> +++ b/arm/cstart.S
> @@ -7,6 +7,7 @@
>   */
>  #define __ASSEMBLY__
>  #include <auxinfo.h>
> +#include <linux/psci.h>
>  #include <asm/thread_info.h>
>  #include <asm/asm-offsets.h>
>  #include <asm/ptrace.h>
> @@ -138,6 +139,12 @@ secondary_entry:
>  	blx	r0
>  	b	do_idle
>  
> +.global asm_cpu_psci_cpu_die
> +asm_cpu_psci_cpu_die:
> +	ldr	r0, =PSCI_0_2_FN_CPU_OFF
> +	hvc	#0
> +	b	halt

Shouldn't we load PSCI_POWER_STATE_TYPE_POWER_DOWN into r1 and
zero out r2 and r3, as cpu_psci_cpu_die() does? And maybe we
should just do a 'b .' here instead of 'b halt' in order to
avoid confusion as to how we ended up in halt(), if the psci
invocation were to ever fail.

> +
>  .globl halt
>  halt:
>  1:	wfi
> diff --git a/arm/cstart64.S b/arm/cstart64.S
> index b0e8baa1a23a..20f832fd57f7 100644
> --- a/arm/cstart64.S
> +++ b/arm/cstart64.S
> @@ -7,6 +7,7 @@
>   */
>  #define __ASSEMBLY__
>  #include <auxinfo.h>
> +#include <linux/psci.h>
>  #include <asm/asm-offsets.h>
>  #include <asm/ptrace.h>
>  #include <asm/processor.h>
> @@ -128,6 +129,12 @@ secondary_entry:
>  	blr	x0
>  	b	do_idle
>  
> +.globl asm_cpu_psci_cpu_die
> +asm_cpu_psci_cpu_die:
> +	ldr	x0, =PSCI_0_2_FN_CPU_OFF
> +	hvc	#0
> +	b	halt

Same as above

> +
>  .globl halt
>  halt:
>  1:	wfi
> diff --git a/arm/psci.c b/arm/psci.c
> index 5cb4d5c7c233..0440c4cdbc59 100644
> --- a/arm/psci.c
> +++ b/arm/psci.c
> @@ -72,6 +72,7 @@ static int cpu_on_ret[NR_CPUS];
>  static cpumask_t cpu_on_ready, cpu_on_done;
>  static volatile int cpu_on_start;
>  
> +extern void asm_cpu_psci_cpu_die(void);
>  static void cpu_on_secondary_entry(void)
>  {
>  	int cpu = smp_processor_id();
> @@ -79,7 +80,7 @@ static void cpu_on_secondary_entry(void)
>  	cpumask_set_cpu(cpu, &cpu_on_ready);
>  	while (!cpu_on_start)
>  		cpu_relax();
> -	cpu_on_ret[cpu] = psci_cpu_on(cpus[1], __pa(cpu_psci_cpu_die));
> +	cpu_on_ret[cpu] = psci_cpu_on(cpus[1], __pa(asm_cpu_psci_cpu_die));
>  	cpumask_set_cpu(cpu, &cpu_on_done);
>  }
>  
> @@ -104,7 +105,7 @@ static bool psci_cpu_on_test(void)
>  	cpu_on_start = 1;
>  	smp_mb();
>  
> -	cpu_on_ret[0] = psci_cpu_on(cpus[1], __pa(cpu_psci_cpu_die));
> +	cpu_on_ret[0] = psci_cpu_on(cpus[1], __pa(asm_cpu_psci_cpu_die));
>  	cpumask_set_cpu(0, &cpu_on_done);
>  
>  	while (!cpumask_full(&cpu_on_done))
> -- 
> 2.7.4
>

Thanks,
drew 
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
