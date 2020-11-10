Return-Path: <SRS0=+U1N=EQ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DED19C55ABD
	for <kvmarm@archiver.kernel.org>; Tue, 10 Nov 2020 15:25:01 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 27F7720797
	for <kvmarm@archiver.kernel.org>; Tue, 10 Nov 2020 15:25:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="xfNstsPM"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 27F7720797
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5BAB74B909;
	Tue, 10 Nov 2020 10:25:00 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id H2il38oNNnhx; Tue, 10 Nov 2020 10:24:59 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3B0AD4B9FD;
	Tue, 10 Nov 2020 10:24:59 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2A0064B909
 for <kvmarm@lists.cs.columbia.edu>; Tue, 10 Nov 2020 10:24:57 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 9Tlz7tOB0CBJ for <kvmarm@lists.cs.columbia.edu>;
 Tue, 10 Nov 2020 10:24:56 -0500 (EST)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id ECA544B907
 for <kvmarm@lists.cs.columbia.edu>; Tue, 10 Nov 2020 10:24:55 -0500 (EST)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id ABD57207D3;
 Tue, 10 Nov 2020 15:24:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1605021894;
 bh=6grBIe9Ab1qZ3+EKmKO+hoC/BEgkpYoULIb3EV2t5yo=;
 h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
 b=xfNstsPMqn3ECov8nxjyJrLJ1+DSpZyC0Ss8RG/e28rt4BLSM8F0v7CrR9L+ZA0/S
 RSUEjAK3adrJk6vUBiDTu6vDp24Jz1wWPISq73w6uzLvPeMvrBW1AaQTEgfm7tBt24
 dVU5iImG7WCRm7bkND2kFaKfCAF6YXP3QSVDTu2w=
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
 by disco-boy.misterjones.org with esmtpsa (TLS1.2) tls
 TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256 (Exim 4.94)
 (envelope-from <maz@kernel.org>)
 id 1kcVVs-009UKZ-Jg; Tue, 10 Nov 2020 15:24:52 +0000
MIME-Version: 1.0
Date: Tue, 10 Nov 2020 15:24:52 +0000
From: Marc Zyngier <maz@kernel.org>
To: David Brazdil <dbrazdil@google.com>
Subject: Re: [PATCH v1 07/24] kvm: arm64: Create nVHE copy of cpu_logical_map
In-Reply-To: <20201109113233.9012-8-dbrazdil@google.com>
References: <20201109113233.9012-1-dbrazdil@google.com>
 <20201109113233.9012-8-dbrazdil@google.com>
User-Agent: Roundcube Webmail/1.4.9
Message-ID: <d473fd26e5314f2407b70242488f33de@kernel.org>
X-Sender: maz@kernel.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: dbrazdil@google.com, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 james.morse@arm.com, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com,
 catalin.marinas@arm.com, will@kernel.org, dennis@kernel.org, tj@kernel.org,
 cl@linux.com, mark.rutland@arm.com, lorenzo.pieralisi@arm.com,
 qperret@google.com, ascull@google.com, qwandor@google.com,
 kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: kernel-team@android.com, Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
 Andrew Walbran <qwandor@google.com>, Catalin Marinas <catalin.marinas@arm.com>,
 linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 Tejun Heo <tj@kernel.org>, Dennis Zhou <dennis@kernel.org>,
 Christoph Lameter <cl@linux.com>, Will Deacon <will@kernel.org>,
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
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

On 2020-11-09 11:32, David Brazdil wrote:
> When KVM starts validating host's PSCI requests, it will need to map
> MPIDR back to the CPU ID. To this end, copy cpu_logical_map into nVHE
> hyp memory when KVM is initialized.
> 
> Only copy the information for CPUs that are online at the point of KVM
> initialization so that KVM rejects CPUs whose features were not checked
> against the finalized capabilities.
> 
> Signed-off-by: David Brazdil <dbrazdil@google.com>
> ---
>  arch/arm64/kvm/arm.c             | 17 +++++++++++++++++
>  arch/arm64/kvm/hyp/nvhe/percpu.c | 16 ++++++++++++++++
>  2 files changed, 33 insertions(+)
> 
> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> index 9ba9db2aa7f8..b85b4294b72d 100644
> --- a/arch/arm64/kvm/arm.c
> +++ b/arch/arm64/kvm/arm.c
> @@ -1481,6 +1481,21 @@ static inline void hyp_cpu_pm_exit(void)
>  }
>  #endif
> 
> +static void init_cpu_logical_map(void)
> +{
> +	extern u64 kvm_nvhe_sym(__cpu_logical_map)[NR_CPUS];
> +	int cpu;
> +
> +	/*
> +	 * Copy the MPIDR <-> logical CPU ID mapping to hyp.
> +	 * Only copy the set of online CPUs whose features have been chacked
> +	 * against the finalized system capabilities. The hypervisor will not
> +	 * allow any other CPUs from the `possible` set to boot.
> +	 */
> +	for_each_online_cpu(cpu)
> +		CHOOSE_NVHE_SYM(__cpu_logical_map)[cpu] = cpu_logical_map(cpu);
> +}
> +
>  static int init_common_resources(void)
>  {
>  	return kvm_set_ipa_limit();
> @@ -1659,6 +1674,8 @@ static int init_hyp_mode(void)
>  		}
>  	}
> 
> +	init_cpu_logical_map();
> +
>  	return 0;
> 
>  out_err:
> diff --git a/arch/arm64/kvm/hyp/nvhe/percpu.c 
> b/arch/arm64/kvm/hyp/nvhe/percpu.c
> index 5fd0c5696907..d0b9dbc2df45 100644
> --- a/arch/arm64/kvm/hyp/nvhe/percpu.c
> +++ b/arch/arm64/kvm/hyp/nvhe/percpu.c
> @@ -8,6 +8,22 @@
>  #include <asm/kvm_hyp.h>
>  #include <asm/kvm_mmu.h>
> 
> +/*
> + * nVHE copy of data structures tracking available CPU cores.
> + * Only entries for CPUs that were online at KVM init are populated.
> + * Other CPUs should not be allowed to boot because their features 
> were
> + * not checked against the finalized system capabilities.
> + */
> +u64 __ro_after_init __cpu_logical_map[NR_CPUS] = { [0 ... NR_CPUS-1]
> = INVALID_HWID };

I'm not sure what __ro_after_init means once we get S2 isolation.

> +
> +u64 cpu_logical_map(int cpu)

nit: is there any reason why "cpu" cannot be unsigned? The thought
of a negative CPU number makes me shiver...

> +{
> +	if (cpu < 0 || cpu >= ARRAY_SIZE(__cpu_logical_map))
> +		hyp_panic();
> +
> +	return __cpu_logical_map[cpu];
> +}
> +
>  unsigned long __hyp_per_cpu_offset(unsigned int cpu)
>  {
>  	unsigned long *cpu_base_array;

Overall, this patch would make more sense closer it its use case
(in patch 19). I also don't understand why this lives in percpu.c...

Thanks,

         M.
-- 
Jazz is not dead. It just smells funny...
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
