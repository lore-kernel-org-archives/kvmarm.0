Received: from out-179.mta0.migadu.com (out-179.mta0.migadu.com [91.218.175.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D51C23AC0F8
	for <kvmarm@lists.linux.dev>; Wed, 29 Jul 2026 17:59:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785347951; cv=none; b=YM+RuunV755g3sqCz38aG6CGno2J8BxLJxJlL0pt2ZjqF1mMdkps9ouD/Bx122YSJhkWDkMUS8GpprbaxGtOYx0MjqrVb3bCEsSoEq5O9+LIOTZEU+aaHWnaDafxarWULPZ800t0WFK08g5awCrKv9iu94Q8DeADRaAziBDkFwE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785347951; c=relaxed/simple;
	bh=B20dbkBhewR9N5jqjB77bXHLofpTwdnRjIDZU++jZdQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=rGMua9KxLKumRAEqp1cSzItIwVaq1xTP/1TSnBShwrg5yQqtMuBzSmk07y6tNhfuehg7rl7bdSPpry2u2oi4ap/ytJM5FlhHS3Nbw/naNIXxaMeAztmcFrwIh3OehQ8woKw1jocUAsCx9TKRvaDLiW53L0zrFCVuaHxeBYnArxs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Wa0jll8t; arc=none smtp.client-ip=91.218.175.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Wa0jll8t"
X-Forwarded-Encrypted: i=1; AHgh+RpOHJVRlda30lJjpVTsDnXUQDe7dKUYnZQ+qUbm5G3BFGRk1QMVSci/EqvMhZX5SZDIOnid5XI=@lists.linux.dev
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1785347943;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=sHNGtvXmI1lmcYGaqQf2LJdsupyf9eDfU/t8/RKu5uQ=;
	b=Wa0jll8tmi0kdIXjJBpkiU/h91PdkiOgYUb9H8eeR7038oMIHpVADv/wm5ZQk6fLeVv3YM
	Vz3K+MzPtGLOCwd/3sb1UVmFuoV+8KcvTmxE9/apqVxamXe16hC8b7Uef4/foiiJ5uWyQY
	d4jq+B4osdhrSnBdtiO3yTKB6b81tn0=
X-Gm-Message-State: AOJu0YwKH9diAWKBWoELtLlSTbgkp4wF2lMDQq7HKhXG+putE9cWo+7Y
	pg90klNHRTbFxGRO7CH6W1JU80cLEmwSUL6olvzZZWnaORbRc4/oeJCGZ9pMoxVDf3w83INse/M
	X+1Tz6fT+fiqBad7w5eIZWvW58RZLosBM9mUFOg9i
X-Received: by 2002:ac8:7fc7:0:b0:4ff:c0e7:be9c with SMTP id
 d75a77b69052e-52b34cf718bmr4279531cf.0.1785347937591; Wed, 29 Jul 2026
 10:58:57 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260720-hybrid-v9-0-2b713ca1b5dc@rsg.ci.i.u-tokyo.ac.jp> <20260720-hybrid-v9-13-2b713ca1b5dc@rsg.ci.i.u-tokyo.ac.jp>
In-Reply-To: <20260720-hybrid-v9-13-2b713ca1b5dc@rsg.ci.i.u-tokyo.ac.jp>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Fuad Tabba <fuad.tabba@linux.dev>
Date: Wed, 29 Jul 2026 18:58:00 +0100
X-Gmail-Original-Message-ID: <CA+EHjTyBNtRHMGp9LvGfrEHC+WggA_B5hQq+Yf35+zNBfNxG1A@mail.gmail.com>
X-Gm-Features: AUfX_mxD75QzlQhuaQNGxQQP31Q-APsfSKiFOjN07yFBd2o-UYKBSVA4waq0SzE
Message-ID: <CA+EHjTyBNtRHMGp9LvGfrEHC+WggA_B5hQq+Yf35+zNBfNxG1A@mail.gmail.com>
Subject: Re: [PATCH v9 13/16] KVM: arm64: PMU: Pass the target CPU to kvm_pmu_probe_armpmu()
To: Akihiko Odaki <odaki@rsg.ci.i.u-tokyo.ac.jp>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, Joey Gouly <joey.gouly@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, Kees Cook <kees@kernel.org>, 
	"Gustavo A. R. Silva" <gustavoars@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, 
	Jonathan Corbet <corbet@lwn.net>, Shuah Khan <shuah@kernel.org>, 
	Shuah Khan <skhan@linuxfoundation.org>, Yury Norov <yury.norov@gmail.com>, 
	Rasmus Villemoes <linux@rasmusvillemoes.dk>, Steffen Eiden <seiden@linux.ibm.com>, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org, 
	devel@daynix.com, kvm@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-kselftest@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Migadu-Flow: FLOW_OUT

On Mon, 20 Jul 2026 at 06:39, Akihiko Odaki
<odaki@rsg.ci.i.u-tokyo.ac.jp> wrote:
>
> kvm_pmu_probe_armpmu() currently samples the current CPU internally,
> which ties the helper to default PMU selection.
>
> Move that policy to kvm_arm_set_default_pmu() by passing
> raw_smp_processor_id() from the caller, and make the helper search for
> the pPMU covering an explicit CPU. Move the helper above
> kvm_pmu_create_perf_event() so later code can reuse it when creating
> PMU events for a VCPU's current pCPU.
>
> This preserves the existing default PMU selection behavior while
> preparing fixed-counters-only mode to select a pPMU at runtime.
>
> Signed-off-by: Akihiko Odaki <odaki@rsg.ci.i.u-tokyo.ac.jp>

Reviewed-by: Fuad Tabba <fuad.tabba@linux.dev>

Cheers,
/fuad


> ---
>  arch/arm64/kvm/pmu-emul.c | 72 +++++++++++++++++++++++------------------------
>  1 file changed, 35 insertions(+), 37 deletions(-)
>
> diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
> index 27db8877f96e..78611eaecca2 100644
> --- a/arch/arm64/kvm/pmu-emul.c
> +++ b/arch/arm64/kvm/pmu-emul.c
> @@ -682,6 +682,23 @@ static int kvm_map_pmu_event(struct arm_pmu *pmu, unsigned int eventsel)
>         return eventsel;
>  }
>
> +static struct arm_pmu *kvm_pmu_probe_armpmu(int cpu)
> +{
> +       struct arm_pmu_entry *entry;
> +       struct arm_pmu *pmu;
> +
> +       guard(rcu)();
> +
> +       list_for_each_entry_rcu(entry, &arm_pmus, entry) {
> +               pmu = entry->arm_pmu;
> +
> +               if (cpumask_test_cpu(cpu, &pmu->supported_cpus))
> +                       return pmu;
> +       }
> +
> +       return NULL;
> +}
> +
>  /**
>   * kvm_pmu_create_perf_event - create a perf event for a counter
>   * @pmc: Counter context
> @@ -811,42 +828,6 @@ void kvm_host_pmu_init(struct arm_pmu *pmu)
>         list_add_tail_rcu(&entry->entry, &arm_pmus);
>  }
>
> -static struct arm_pmu *kvm_pmu_probe_armpmu(void)
> -{
> -       struct arm_pmu_entry *entry;
> -       struct arm_pmu *pmu;
> -       int cpu;
> -
> -       guard(rcu)();
> -
> -       /*
> -        * It is safe to use a stale cpu to iterate the list of PMUs so long as
> -        * the same value is used for the entirety of the loop. Given this, and
> -        * the fact that no percpu data is used for the lookup there is no need
> -        * to disable preemption.
> -        *
> -        * It is still necessary to get a valid cpu, though, to probe for the
> -        * default PMU instance as userspace is not required to specify a PMU
> -        * type. In order to uphold the preexisting behavior KVM selects the
> -        * PMU instance for the core during vcpu init. A dependent use
> -        * case would be a user with disdain of all things big.LITTLE that
> -        * affines the VMM to a particular cluster of cores.
> -        *
> -        * In any case, userspace should just do the sane thing and use the UAPI
> -        * to select a PMU type directly. But, be wary of the baggage being
> -        * carried here.
> -        */
> -       cpu = raw_smp_processor_id();
> -       list_for_each_entry_rcu(entry, &arm_pmus, entry) {
> -               pmu = entry->arm_pmu;
> -
> -               if (cpumask_test_cpu(cpu, &pmu->supported_cpus))
> -                       return pmu;
> -       }
> -
> -       return NULL;
> -}
> -
>  static u64 __compute_pmceid(struct arm_pmu *pmu, bool pmceid1)
>  {
>         u32 hi[2], lo[2];
> @@ -1072,7 +1053,24 @@ static void kvm_arm_set_pmu(struct kvm *kvm, struct arm_pmu *arm_pmu)
>   */
>  int kvm_arm_set_default_pmu(struct kvm *kvm)
>  {
> -       struct arm_pmu *arm_pmu = kvm_pmu_probe_armpmu();
> +       /*
> +        * It is safe to use a stale cpu to iterate the list of PMUs so long as
> +        * the same value is used for the entirety of the loop. Given this, and
> +        * the fact that no percpu data is used for the lookup there is no need
> +        * to disable preemption.
> +        *
> +        * It is still necessary to get a valid cpu, though, to probe for the
> +        * default PMU instance as userspace is not required to specify a PMU
> +        * type. In order to uphold the preexisting behavior KVM selects the
> +        * PMU instance for the core during vcpu init. A dependent use
> +        * case would be a user with disdain of all things big.LITTLE that
> +        * affines the VMM to a particular cluster of cores.
> +        *
> +        * In any case, userspace should just do the sane thing and use the UAPI
> +        * to select a PMU type directly. But, be wary of the baggage being
> +        * carried here.
> +        */
> +       struct arm_pmu *arm_pmu = kvm_pmu_probe_armpmu(raw_smp_processor_id());
>
>         if (!arm_pmu)
>                 return -ENODEV;
>
> --
> 2.55.0
>
>
