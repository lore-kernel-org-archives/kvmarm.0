Received: from out-7.mta1.migadu.com (out-7.mta1.migadu.com [95.215.58.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30761399
	for <kvmarm@lists.linux.dev>; Sun, 11 Jun 2023 02:33:19 +0000 (UTC)
Date: Sat, 10 Jun 2023 19:32:42 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1686450797;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=gYuy6+cAPETSeiC1HLB5DdgLxSlHnRHGTMIbZlrv/LM=;
	b=dL29wej5FWD5A7SWuFIiZq1Ri+AnsNP5jarB6+l48bCXsIEOm3HuoZyerwbivdXr6KAK0C
	1sksBAU0o0t7rEzlbTcjLhtGFC9lkNUWUGGlgp1pS/65k5d6JEJEPw1eVPmwt5YIzCNVvQ
	0TG8zglI48re7ps3OWIUQYGqSG3f1p0=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Reiji Watanabe <reijiw@google.com>
Cc: Marc Zyngier <maz@kernel.org>, kvmarm@lists.linux.dev,
	kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	James Morse <james.morse@arm.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Jing Zhang <jingzhangos@google.com>,
	Raghavendra Rao Anata <rananta@google.com>
Subject: Re: [PATCH 2/2] KVM: arm64: PMU: Disallow vPMU on non-uniform PMUVer
 systems
Message-ID: <ZIUx5c//d4txXbUB@linux.dev>
References: <20230610061520.3026530-1-reijiw@google.com>
 <20230610061520.3026530-3-reijiw@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230610061520.3026530-3-reijiw@google.com>
X-Migadu-Flow: FLOW_OUT

On Fri, Jun 09, 2023 at 11:15:20PM -0700, Reiji Watanabe wrote:
> Disallow userspace from configuring vPMU for guests on systems
> where the PMUVer is not uniform across all PEs.
> KVM has not been advertising PMUv3 to the guests with vPMU on
> such systems anyway, and such systems would be extremely
> uncommon and unlikely to even use KVM.

Ok... Now your changes are starting to make sense. This patch is rather
relevant context for interpreting the other PMU fix [*], so I'd
recommend you send this as a combined series going forward.

[*]  https://lore.kernel.org/kvmarm/20230610194510.4146549-1-reijiw@google.com/

> diff --git a/include/kvm/arm_pmu.h b/include/kvm/arm_pmu.h
> index eef17de966da..af1fe2b53fbb 100644
> --- a/include/kvm/arm_pmu.h
> +++ b/include/kvm/arm_pmu.h
> @@ -105,6 +105,14 @@ void kvm_vcpu_pmu_restore_host(struct kvm_vcpu *vcpu);
>  
>  u8 kvm_arm_pmu_get_pmuver_limit(void);
>  
> +static inline void kvm_arm_set_support_pmu_v3(void)
> +{
> +	u8 pmuver = kvm_arm_pmu_get_pmuver_limit();
> +
> +	if (pmu_v3_is_supported(pmuver))
> +		static_branch_enable(&kvm_arm_pmu_available);
> +}
> +
>  #else
>  struct kvm_pmu {
>  };
> @@ -114,6 +122,8 @@ static inline bool kvm_arm_support_pmu_v3(void)
>  	return false;
>  }
>  
> +static inline void kvm_arm_set_support_pmu_v3(void) {};
> +

nit: Give this thing a more generic name (e.g. kvm_pmu_init()) in case
we wind up needing more boot-time PMU initialization.

--
Thanks,
Oliver
