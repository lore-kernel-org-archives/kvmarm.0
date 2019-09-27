Return-Path: <SRS0=2Aw4=XW=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AAA18C4360C
	for <kvmarm@archiver.kernel.org>; Fri, 27 Sep 2019 12:25:13 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 3B92121850
	for <kvmarm@archiver.kernel.org>; Fri, 27 Sep 2019 12:25:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3B92121850
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8A39F4A775;
	Fri, 27 Sep 2019 08:25:12 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id eQkMMl6KOs+I; Fri, 27 Sep 2019 08:25:11 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5B5014A773;
	Fri, 27 Sep 2019 08:25:11 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BA8C64A771
 for <kvmarm@lists.cs.columbia.edu>; Fri, 27 Sep 2019 08:25:10 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 5+Cn4x9xOTHp for <kvmarm@lists.cs.columbia.edu>;
 Fri, 27 Sep 2019 08:25:09 -0400 (EDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 945B94A770
 for <kvmarm@lists.cs.columbia.edu>; Fri, 27 Sep 2019 08:25:09 -0400 (EDT)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com
 [10.5.11.11])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mx1.redhat.com (Postfix) with ESMTPS id DA07210DCC9D;
 Fri, 27 Sep 2019 12:25:08 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.43.2.160])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id C7B7D600C6;
 Fri, 27 Sep 2019 12:25:07 +0000 (UTC)
Date: Fri, 27 Sep 2019 14:25:05 +0200
From: Andrew Jones <drjones@redhat.com>
To: Andre Przywara <andre.przywara@arm.com>
Subject: Re: [kvm-unit-tests PATCH 2/6] arm: gic: Split variable output data
 from test name
Message-ID: <20190927122505.wij5qgzts2zfokac@kamzik.brq.redhat.com>
References: <20190927104227.253466-1-andre.przywara@arm.com>
 <20190927104227.253466-3-andre.przywara@arm.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20190927104227.253466-3-andre.przywara@arm.com>
User-Agent: NeoMutt/20180716
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.6.2
 (mx1.redhat.com [10.5.110.64]); Fri, 27 Sep 2019 12:25:09 +0000 (UTC)
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvmarm@lists.cs.columbia.edu,
 kvm@vger.kernel.org
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

On Fri, Sep 27, 2019 at 11:42:23AM +0100, Andre Przywara wrote:
> For some tests we mix variable diagnostic output with the test name,
> which leads to variable test line, confusing some higher level
> frameworks.
> 
> Split the output to always use the same test name for a certain test,
> and put diagnostic output on a separate line using the INFO: tag.
> 
> Signed-off-by: Andre Przywara <andre.przywara@arm.com>
> ---
>  arm/gic.c | 45 ++++++++++++++++++++++++++-------------------
>  1 file changed, 26 insertions(+), 19 deletions(-)
> 
> diff --git a/arm/gic.c b/arm/gic.c
> index 6fd5e5e..66dcafe 100644
> --- a/arm/gic.c
> +++ b/arm/gic.c
> @@ -353,8 +353,8 @@ static void test_typer_v2(uint32_t reg)
>  {
>  	int nr_gic_cpus = ((reg >> 5) & 0x7) + 1;
>  
> -	report("all %d CPUs have interrupts", nr_cpus == nr_gic_cpus,
> -	       nr_gic_cpus);
> +	report("all CPUs have interrupts", nr_cpus == nr_gic_cpus);
> +	report_info("having %d CPUs", nr_gic_cpus);

Maybe slightly better:

 report_info("nr_cpus=%d", nr_cpus);
 report("all CPUs have interrupts", nr_cpus == nr_gic_cpus);

>  }
>  
>  #define BYTE(reg32, byte) (((reg32) >> ((byte) * 8)) & 0xff)
> @@ -370,16 +370,21 @@ static void test_typer_v2(uint32_t reg)
>  static void test_byte_access(void *base_addr, u32 pattern, u32 mask)
>  {
>  	u32 reg = readb(base_addr + 1);
> +	bool res;
>  
> -	report("byte reads successful (0x%08x => 0x%02x)",
> -	       reg == (BYTE(pattern, 1) & (mask >> 8)),
> -	       pattern & mask, reg);
> +	res = (reg == (BYTE(pattern, 1) & (mask >> 8)));
> +	report("byte reads successful", res);
> +	if (!res)
> +		report_info("byte 1 of 0x%08x => 0x%02x", pattern & mask, reg);
>  
>  	pattern = REPLACE_BYTE(pattern, 2, 0x1f);
>  	writeb(BYTE(pattern, 2), base_addr + 2);
>  	reg = readl(base_addr);
> -	report("byte writes successful (0x%02x => 0x%08x)",
> -	       reg == (pattern & mask), BYTE(pattern, 2), reg);
> +	res = (reg == (pattern & mask));
> +	report("byte writes successful", res);
> +	if (!res)
> +		report_info("writing 0x%02x into bytes 2 => 0x%08x",
> +			    BYTE(pattern, 2), reg);
>  }
>  
>  static void test_priorities(int nr_irqs, void *priptr)
> @@ -399,15 +404,16 @@ static void test_priorities(int nr_irqs, void *priptr)
>  	pri_mask = readl(first_spi);
>  
>  	reg = ~pri_mask;
> -	report("consistent priority masking (0x%08x)",
> +	report("consistent priority masking",
>  	       (((reg >> 16) == (reg & 0xffff)) &&
> -	        ((reg & 0xff) == ((reg >> 8) & 0xff))), pri_mask);
> +	        ((reg & 0xff) == ((reg >> 8) & 0xff))));
> +	report_info("priority mask is 0x%08x", pri_mask);
>  
>  	reg = reg & 0xff;
>  	for (pri_bits = 8; reg & 1; reg >>= 1, pri_bits--)
>  		;
> -	report("implements at least 4 priority bits (%d)",
> -	       pri_bits >= 4, pri_bits);
> +	report("implements at least 4 priority bits", pri_bits >= 4);
> +	report_info("%d priority bits implemented", pri_bits);
>  
>  	pattern = 0;
>  	writel(pattern, first_spi);
> @@ -452,9 +458,9 @@ static void test_targets(int nr_irqs)
>  	/* Check that bits for non implemented CPUs are RAZ/WI. */
>  	if (nr_cpus < 8) {
>  		writel(0xffffffff, targetsptr + GIC_FIRST_SPI);
> -		report("bits for %d non-existent CPUs masked",
> -		       !(readl(targetsptr + GIC_FIRST_SPI) & ~cpu_mask),
> -		       8 - nr_cpus);
> +		report("bits for non-existent CPUs masked",
> +		       !(readl(targetsptr + GIC_FIRST_SPI) & ~cpu_mask));
> +		report_info("%d non-existent CPUs", 8 - nr_cpus);
>  	} else {
>  		report_skip("CPU masking (all CPUs implemented)");
>  	}
> @@ -465,8 +471,10 @@ static void test_targets(int nr_irqs)
>  	pattern = 0x0103020f;
>  	writel(pattern, targetsptr + GIC_FIRST_SPI);
>  	reg = readl(targetsptr + GIC_FIRST_SPI);
> -	report("register content preserved (%08x => %08x)",
> -	       reg == (pattern & cpu_mask), pattern & cpu_mask, reg);
> +	report("register content preserved", reg == (pattern & cpu_mask));
> +	if (reg != (pattern & cpu_mask))
> +		report_info("writing %08x reads back as %08x",
> +			    pattern & cpu_mask, reg);
>  
>  	/* The TARGETS registers are byte accessible. */
>  	test_byte_access(targetsptr + GIC_FIRST_SPI, pattern, cpu_mask);
> @@ -505,9 +513,8 @@ static void gic_test_mmio(void)
>  	       test_readonly_32(gic_dist_base + GICD_IIDR, false));
>  
>  	reg = readl(idreg);
> -	report("ICPIDR2 is read-only (0x%08x)",
> -	       test_readonly_32(idreg, false),
> -	       reg);
> +	report("ICPIDR2 is read-only", test_readonly_32(idreg, false));
> +	report_info("value of ICPIDR2: 0x%08x", reg);
>  
>  	test_priorities(nr_irqs, gic_dist_base + GICD_IPRIORITYR);
>  
> -- 
> 2.17.1
>

Otherwise looks good to me

Thanks,
drew 
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
