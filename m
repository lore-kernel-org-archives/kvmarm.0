Return-Path: <SRS0=2Aw4=XW=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3F171C4360C
	for <kvmarm@archiver.kernel.org>; Fri, 27 Sep 2019 12:30:17 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id C246721850
	for <kvmarm@archiver.kernel.org>; Fri, 27 Sep 2019 12:30:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C246721850
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4381E4A777;
	Fri, 27 Sep 2019 08:30:16 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id skX3yDj40Z3q; Fri, 27 Sep 2019 08:30:15 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3D1314A71B;
	Fri, 27 Sep 2019 08:30:15 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BEDAC4A70D
 for <kvmarm@lists.cs.columbia.edu>; Fri, 27 Sep 2019 08:30:13 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 7mLAzLpAf6fX for <kvmarm@lists.cs.columbia.edu>;
 Fri, 27 Sep 2019 08:30:12 -0400 (EDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 9717E4A661
 for <kvmarm@lists.cs.columbia.edu>; Fri, 27 Sep 2019 08:30:12 -0400 (EDT)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com
 [10.5.11.12])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mx1.redhat.com (Postfix) with ESMTPS id A532BC05975D;
 Fri, 27 Sep 2019 12:30:11 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.43.2.160])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id B4BB760BF3;
 Fri, 27 Sep 2019 12:30:05 +0000 (UTC)
Date: Fri, 27 Sep 2019 14:30:03 +0200
From: Andrew Jones <drjones@redhat.com>
To: Andre Przywara <andre.przywara@arm.com>
Subject: Re: [kvm-unit-tests PATCH 5/6] arm: selftest: Make MPIDR output stable
Message-ID: <20190927123003.jrtcqc3ruv5z64mg@kamzik.brq.redhat.com>
References: <20190927104227.253466-1-andre.przywara@arm.com>
 <20190927104227.253466-6-andre.przywara@arm.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20190927104227.253466-6-andre.przywara@arm.com>
User-Agent: NeoMutt/20180716
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16
 (mx1.redhat.com [10.5.110.32]); Fri, 27 Sep 2019 12:30:11 +0000 (UTC)
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

On Fri, Sep 27, 2019 at 11:42:26AM +0100, Andre Przywara wrote:
> At the moment the smp selftest outputs one line for each vCPU, with the
> CPU number and its MPIDR printed in the same test result line.
> For automated test frameworks this has the problem of including variable
> output in the test name, also the number of tests varies, depending on the
> number of vCPUs.
> 
> Fix this by only generating a single line of output for the SMP test,
> which summarises the result. We use two cpumasks, to let each vCPU report
> its result and completion of the test (code stolen from the GIC test).
> 
> For informational purposes we keep the one line per CPU, but prefix it
> with an INFO: tag, so that frameworks can ignore it.
> 
> Signed-off-by: Andre Przywara <andre.przywara@arm.com>
> ---
>  arm/selftest.c | 14 ++++++++++++--
>  1 file changed, 12 insertions(+), 2 deletions(-)
> 
> diff --git a/arm/selftest.c b/arm/selftest.c
> index a0c1ab8..e9dc5c0 100644
> --- a/arm/selftest.c
> +++ b/arm/selftest.c
> @@ -17,6 +17,8 @@
>  #include <asm/smp.h>
>  #include <asm/barrier.h>
>  
> +static cpumask_t ready, valid;
> +
>  static void __user_psci_system_off(void)
>  {
>  	psci_system_off();
> @@ -341,8 +343,11 @@ static void cpu_report(void *data __unused)
>  	uint64_t mpidr = get_mpidr();
>  	int cpu = smp_processor_id();
>  
> -	report("CPU(%3d) mpidr=%010" PRIx64,
> -		mpidr_to_cpu(mpidr) == cpu, cpu, mpidr);
> +	if (mpidr_to_cpu(mpidr) == cpu)
> +		cpumask_set_cpu(smp_processor_id(), &valid);
> +	smp_wmb();		/* Paired with rmb in main(). */
> +	cpumask_set_cpu(smp_processor_id(), &ready);
> +	report_info("CPU%3d: MPIDR=%010" PRIx64, cpu, mpidr);
>  }
>  
>  int main(int argc, char **argv)
> @@ -371,6 +376,11 @@ int main(int argc, char **argv)
>  
>  		report("PSCI version", psci_check());
>  		on_cpus(cpu_report, NULL);
> +		while (!cpumask_full(&ready))
> +			cpu_relax();
> +		smp_rmb();		/* Paired with wmb in cpu_report(). */
> +		report("MPIDR test on all CPUs", cpumask_full(&valid));
> +		report_info("%d CPUs reported back", nr_cpus);
>  
>  	} else {
>  		printf("Unknown subtest\n");
> -- 
> 2.17.1
>

Reviewed-by: Andrew Jones <drjones@redhat.com>
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
