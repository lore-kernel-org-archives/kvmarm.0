Received: from out-192.mta0.migadu.com (out-192.mta0.migadu.com [91.218.175.192])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA5FF946E
	for <kvmarm@lists.linux.dev>; Tue, 17 Oct 2023 05:52:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="OdmnPA8A"
Date: Tue, 17 Oct 2023 05:52:24 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1697521950;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=fVj3QOXnTr/Xh7eUU3olV979cXmOJTmj7/jYZIF4yF4=;
	b=OdmnPA8A+91moypBiaGZn8ibVGmZmN0HlfkfnzmzJQJBXglPtzHGRWJlvkfP5NADESecPn
	LfHytZzAvYtJ/AuWS3MjDUzpoPd1KHYxGwXalx8C92EpY8eHM4WMityUHrBuqJvQO9N3Y6
	ePHgtv1NQGXK0zyXqDl1SenjwijfMhQ=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Raghavendra Rao Ananta <rananta@google.com>
Cc: Sebastian Ott <sebott@redhat.com>, Marc Zyngier <maz@kernel.org>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Shaoqin Huang <shahuang@redhat.com>,
	Jing Zhang <jingzhangos@google.com>,
	Reiji Watanabe <reijiw@google.com>,
	Colton Lewis <coltonlewis@google.com>,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH v7 07/12] KVM: arm64: PMU: Set PMCR_EL0.N for vCPU based
 on the associated PMU
Message-ID: <ZS4hGL5RIIuI1KOC@linux.dev>
References: <20231009230858.3444834-1-rananta@google.com>
 <20231009230858.3444834-8-rananta@google.com>
 <b4739328-5dba-a3a6-54ef-2db2d34201d8@redhat.com>
 <CAJHc60zpH8Y8h72=jUbshGoqye20FaHRcsb+TFDxkk7rhJAUxQ@mail.gmail.com>
 <ZS2L6uIlUtkltyrF@linux.dev>
 <CAJHc60wvMSHuLuRsZJOn7+r7LxZ661xEkDfqxGHed5Y+95Fxeg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJHc60wvMSHuLuRsZJOn7+r7LxZ661xEkDfqxGHed5Y+95Fxeg@mail.gmail.com>
X-Migadu-Flow: FLOW_OUT

On Mon, Oct 16, 2023 at 02:35:52PM -0700, Raghavendra Rao Ananta wrote:

[...]

> > What's the point of doing this in the first place? The implementation of
> > kvm_vcpu_read_pmcr() is populating PMCR_EL0.N using the VM-scoped value.
> >
> I guess originally the change replaced read_sysreg(pmcr_el0) with
> kvm_vcpu_read_pmcr(vcpu) to maintain consistency with others.
> But if you and Sebastian feel that it's an overkill and directly
> getting the value via vcpu->kvm->arch.pmcr_n is more readable, I'm
> happy to make the change.

No, I'd rather you delete the line where PMCR_EL0.N altogether.
reset_pmcr() tries to initialize the field, but your
kvm_vcpu_read_pmcr() winds up replacing it with pmcr_n.

> @@ -1105,8 +1109,16 @@ u8 kvm_arm_pmu_get_pmuver_limit(void)
>  /**
>   * kvm_vcpu_read_pmcr - Read PMCR_EL0 register for the vCPU
>   * @vcpu: The vcpu pointer
> + *
> + * The function returns the value of PMCR.N based on the per-VM tracked
> + * value (kvm->arch.pmcr_n). This is to ensure that the register field
> + * remains consistent for the VM, even on heterogeneous systems where
> + * the value may vary when read from different CPUs (during vCPU reset).

Since I'm looking at this again, I don't believe the comment is adding
much. KVM doesn't read pmcr_el0 directly anymore, and kvm_arch is
clearly VM-scoped context.

>   */
>  u64 kvm_vcpu_read_pmcr(struct kvm_vcpu *vcpu)
>  {
> -	return __vcpu_sys_reg(vcpu, PMCR_EL0);
> +	u64 pmcr = __vcpu_sys_reg(vcpu, PMCR_EL0) &
> +			~(ARMV8_PMU_PMCR_N_MASK << ARMV8_PMU_PMCR_N_SHIFT);
> +
> +	return pmcr | ((u64)vcpu->kvm->arch.pmcr_n << ARMV8_PMU_PMCR_N_SHIFT);
>  }


-- 
Thanks,
Oliver
