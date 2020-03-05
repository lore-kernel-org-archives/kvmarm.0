Return-Path: <SRS0=Em7b=4W=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 24253C3F2CD
	for <kvmarm@archiver.kernel.org>; Thu,  5 Mar 2020 09:50:39 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id A19532073D
	for <kvmarm@archiver.kernel.org>; Thu,  5 Mar 2020 09:50:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="M/i29GaB"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A19532073D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D3BC04A95D;
	Thu,  5 Mar 2020 04:50:37 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id fj18d5LTYSWW; Thu,  5 Mar 2020 04:50:36 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 795F64AEB2;
	Thu,  5 Mar 2020 04:50:36 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 12CE84A95D
 for <kvmarm@lists.cs.columbia.edu>; Thu,  5 Mar 2020 04:50:35 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id v9PAFMYFRAo5 for <kvmarm@lists.cs.columbia.edu>;
 Thu,  5 Mar 2020 04:50:33 -0500 (EST)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id EB7B84A588
 for <kvmarm@lists.cs.columbia.edu>; Thu,  5 Mar 2020 04:50:33 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1583401833;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=oYO4NseVO/EVN3mPo7FvqNiB3QzjJhFFu6a7Wy0sKRo=;
 b=M/i29GaBx1ghxobQLJv7f0SFMnP8qgERlSiCiyHQb6GhtSJosgzcwggvyS2Us6c1ph00hd
 nPyEJxy7aXczQJwloT/8z4YvgD9/5rc8JEyufLhLtiEYtpzEEd0mm4XfPi8o9mwFad4Kpv
 1ohz6gGvzeitq3Db9ULamZTTOULFY3Y=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-295-fB3wazV-O-mdGsF9xJpr8g-1; Thu, 05 Mar 2020 04:50:30 -0500
X-MC-Unique: fB3wazV-O-mdGsF9xJpr8g-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com
 [10.5.11.13])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7140B800D50;
 Thu,  5 Mar 2020 09:50:28 +0000 (UTC)
Received: from kamzik.brq.redhat.com (ovpn-204-110.brq.redhat.com
 [10.40.204.110])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 6DBE790538;
 Thu,  5 Mar 2020 09:50:22 +0000 (UTC)
Date: Thu, 5 Mar 2020 10:50:19 +0100
From: Andrew Jones <drjones@redhat.com>
To: Eric Auger <eric.auger@redhat.com>
Subject: Re: [kvm-unit-tests PATCH v2 7/9] arm: pmu: test 32-bit <-> 64-bit
 transitions
Message-ID: <20200305095019.tw2bfwdmihcpuphc@kamzik.brq.redhat.com>
References: <20200130112510.15154-1-eric.auger@redhat.com>
 <20200130112510.15154-8-eric.auger@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20200130112510.15154-8-eric.auger@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Cc: kvm@vger.kernel.org, maz@kernel.org, qemu-devel@nongnu.org,
 qemu-arm@nongnu.org, andre.przywara@arm.com, andrew.murray@arm.com,
 kvmarm@lists.cs.columbia.edu, eric.auger.pro@gmail.com
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

On Thu, Jan 30, 2020 at 12:25:08PM +0100, Eric Auger wrote:
> Test configurations where we transit from 32b to 64b
> counters and conversely. Also tests configuration where
> chain counters are configured but only one counter is
> enabled.
> 
> Signed-off-by: Eric Auger <eric.auger@redhat.com>
> ---
>  arm/pmu.c         | 136 ++++++++++++++++++++++++++++++++++++++++++++++
>  arm/unittests.cfg |   6 ++
>  2 files changed, 142 insertions(+)
> 
> diff --git a/arm/pmu.c b/arm/pmu.c
> index 538fbeb..fa77ab3 100644
> --- a/arm/pmu.c
> +++ b/arm/pmu.c
> @@ -115,6 +115,7 @@ static void test_basic_event_count(void) {}
>  static void test_mem_access(void) {}
>  static void test_chained_counters(void) {}
>  static void test_chained_sw_incr(void) {}
> +static void test_chain_promotion(void) {}
>  
>  #elif defined(__aarch64__)
>  #define ID_AA64DFR0_PERFMON_SHIFT 8
> @@ -580,6 +581,138 @@ static void test_chained_sw_incr(void)
>  		    read_regn(pmevcntr, 0), read_regn(pmevcntr, 1));
>  }
>  
> +static void test_chain_promotion(void)
> +{
> +	uint32_t events[] = { 0x13 /* MEM_ACCESS */, 0x1E /* CHAIN */};
> +	void *addr = malloc(PAGE_SIZE);
> +
> +	if (!satisfy_prerequisites(events, ARRAY_SIZE(events)))
> +		return;
> +
> +	/* Only enable CHAIN counter */
> +	pmu_reset();
> +	write_regn(pmevtyper, 0, events[0] | PMEVTYPER_EXCLUDE_EL0);
> +	write_regn(pmevtyper, 1, events[1] | PMEVTYPER_EXCLUDE_EL0);
> +	write_sysreg_s(0x2, PMCNTENSET_EL0);
> +	isb();
> +
> +	mem_access_loop(addr, 20, pmu.pmcr_ro | PMU_PMCR_E);
> +	report(!read_regn(pmevcntr, 0),
> +		"chain counter not counting if even counter is disabled");
> +
> +	/* Only enable even counter */
> +	pmu_reset();
> +	write_regn(pmevcntr, 0, 0xFFFFFFF0);
> +	write_sysreg_s(0x1, PMCNTENSET_EL0);
> +	isb();
> +
> +	mem_access_loop(addr, 20, pmu.pmcr_ro | PMU_PMCR_E);
> +	report(!read_regn(pmevcntr, 1) && (read_sysreg(pmovsclr_el0) == 0x1),
> +		"odd counter did not increment on overflow if disabled");
> +	report_info("MEM_ACCESS counter #0 has value %ld",
> +		    read_regn(pmevcntr, 0));
> +	report_info("CHAIN counter #1 has value %ld",
> +		    read_regn(pmevcntr, 1));
> +	report_info("overflow counter %ld", read_sysreg(pmovsclr_el0));
> +
> +	/* start at 0xFFFFFFDC, +20 with CHAIN enabled, +20 with CHAIN disabled */
> +	pmu_reset();
> +	write_sysreg_s(0x3, PMCNTENSET_EL0);
> +	write_regn(pmevcntr, 0, 0xFFFFFFDC);
> +	isb();
> +
> +	mem_access_loop(addr, 20, pmu.pmcr_ro | PMU_PMCR_E);
> +	report_info("MEM_ACCESS counter #0 has value 0x%lx",
> +		    read_regn(pmevcntr, 0));
> +
> +	/* disable the CHAIN event */
> +	write_sysreg_s(0x2, PMCNTENCLR_EL0);
> +	mem_access_loop(addr, 20, pmu.pmcr_ro | PMU_PMCR_E);
> +	report_info("MEM_ACCESS counter #0 has value 0x%lx",
> +		    read_regn(pmevcntr, 0));
> +	report(read_sysreg(pmovsclr_el0) == 0x1,
> +		"should have triggered an overflow on #0");
> +	report(!read_regn(pmevcntr, 1),
> +		"CHAIN counter #1 shouldn't have incremented");
> +
> +	/* start at 0xFFFFFFDC, +20 with CHAIN disabled, +20 with CHAIN enabled */
> +
> +	pmu_reset();
> +	write_sysreg_s(0x1, PMCNTENSET_EL0);
> +	write_regn(pmevcntr, 0, 0xFFFFFFDC);
> +	isb();
> +	report_info("counter #0 = 0x%lx, counter #1 = 0x%lx overflow=0x%lx",
> +		    read_regn(pmevcntr, 0), read_regn(pmevcntr, 1),
> +		    read_sysreg(pmovsclr_el0));
> +
> +	mem_access_loop(addr, 20, pmu.pmcr_ro | PMU_PMCR_E);
> +	report_info("MEM_ACCESS counter #0 has value 0x%lx",
> +		    read_regn(pmevcntr, 0));
> +
> +	/* enable the CHAIN event */
> +	write_sysreg_s(0x3, PMCNTENSET_EL0);
> +	isb();
> +	mem_access_loop(addr, 20, pmu.pmcr_ro | PMU_PMCR_E);
> +	report_info("MEM_ACCESS counter #0 has value 0x%lx",
> +		    read_regn(pmevcntr, 0));
> +
> +	report((read_regn(pmevcntr, 1) == 1) && !read_sysreg(pmovsclr_el0),
> +		"CHAIN counter #1 should have incremented and no overflow expected");
> +
> +	report_info("CHAIN counter #1 = 0x%lx, overflow=0x%lx",
> +		read_regn(pmevcntr, 1), read_sysreg(pmovsclr_el0));
> +
> +	/* start as MEM_ACCESS/CPU_CYCLES and move to CHAIN/MEM_ACCESS */
> +	pmu_reset();
> +	write_regn(pmevtyper, 0, 0x13 /* MEM_ACCESS */ | PMEVTYPER_EXCLUDE_EL0);
> +	write_regn(pmevtyper, 1, 0x11 /* CPU_CYCLES */ | PMEVTYPER_EXCLUDE_EL0);
> +	write_sysreg_s(0x3, PMCNTENSET_EL0);
> +	write_regn(pmevcntr, 0, 0xFFFFFFDC);
> +	isb();
> +
> +	mem_access_loop(addr, 20, pmu.pmcr_ro | PMU_PMCR_E);
> +	report_info("MEM_ACCESS counter #0 has value 0x%lx",
> +		    read_regn(pmevcntr, 0));
> +
> +	/* 0 becomes CHAINED */
> +	write_sysreg_s(0x0, PMCNTENSET_EL0);
> +	write_regn(pmevtyper, 1, 0x1E /* CHAIN */ | PMEVTYPER_EXCLUDE_EL0);
> +	write_sysreg_s(0x3, PMCNTENSET_EL0);
> +	write_regn(pmevcntr, 1, 0x0);
> +
> +	mem_access_loop(addr, 20, pmu.pmcr_ro | PMU_PMCR_E);
> +	report_info("MEM_ACCESS counter #0 has value 0x%lx",
> +		    read_regn(pmevcntr, 0));
> +
> +	report((read_regn(pmevcntr, 1) == 1) && !read_sysreg(pmovsclr_el0),
> +		"CHAIN counter #1 should have incremented and no overflow expected");
> +
> +	report_info("CHAIN counter #1 = 0x%lx, overflow=0x%lx",
> +		read_regn(pmevcntr, 1), read_sysreg(pmovsclr_el0));
> +
> +	/* start as CHAIN/MEM_ACCESS and move to MEM_ACCESS/CPU_CYCLES */
> +	pmu_reset();
> +	write_regn(pmevtyper, 0, 0x13 /* MEM_ACCESS */ | PMEVTYPER_EXCLUDE_EL0);
> +	write_regn(pmevtyper, 1, 0x1E /* CHAIN */ | PMEVTYPER_EXCLUDE_EL0);
> +	write_regn(pmevcntr, 0, 0xFFFFFFDC);
> +	write_sysreg_s(0x3, PMCNTENSET_EL0);
> +
> +	mem_access_loop(addr, 20, pmu.pmcr_ro | PMU_PMCR_E);
> +	report_info("counter #0=0x%lx, counter #1=0x%lx",
> +			read_regn(pmevcntr, 0), read_regn(pmevcntr, 1));
> +
> +	write_sysreg_s(0x0, PMCNTENSET_EL0);
> +	write_regn(pmevtyper, 1, 0x11 /* CPU_CYCLES */ | PMEVTYPER_EXCLUDE_EL0);
> +	write_sysreg_s(0x3, PMCNTENSET_EL0);
> +
> +	mem_access_loop(addr, 20, pmu.pmcr_ro | PMU_PMCR_E);
> +	report(read_sysreg(pmovsclr_el0) == 1,
> +		"overflow is expected on counter 0");
> +	report_info("counter #0=0x%lx, counter #1=0x%lx overflow=0x%lx",
> +			read_regn(pmevcntr, 0), read_regn(pmevcntr, 1),
> +			read_sysreg(pmovsclr_el0));
> +}
> +
>  #endif
>  
>  /*
> @@ -785,6 +918,9 @@ int main(int argc, char *argv[])
>  	} else if (strcmp(argv[1], "chained-sw-incr") == 0) {
>  		report_prefix_push(argv[1]);
>  		test_chained_sw_incr();
> +	} else if (strcmp(argv[1], "chain-promotion") == 0) {
> +		report_prefix_push(argv[1]);
> +		test_chain_promotion();
>  	} else {
>  		report_abort("Unknown sub-test '%s'", argv[1]);
>  	}
> diff --git a/arm/unittests.cfg b/arm/unittests.cfg
> index 1bd4319..eb6e87e 100644
> --- a/arm/unittests.cfg
> +++ b/arm/unittests.cfg
> @@ -102,6 +102,12 @@ groups = pmu
>  arch = arm64
>  extra_params = -append 'chained-sw-incr'
>  
> +[pmu-chain-promotion]
> +file = pmu.flat
> +groups = pmu
> +arch = arm64
> +extra_params = -append 'chain-promotion'
> +
>  # Test PMU support (TCG) with -icount IPC=1
>  #[pmu-tcg-icount-1]
>  #file = pmu.flat
> -- 
> 2.20.1
> 
> 

same comments as previous patches

Thanks,
drew

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
