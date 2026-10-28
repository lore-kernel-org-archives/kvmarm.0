Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793205689;
	b=v2b8VRcC9FBN+3qumg+nrV3RcmSrK/Z78CBcPqebv6FMxw/J2x/uQNfN82QyR/7opsIp
	 r+NVZAnK+5y4KovN2KRj3e3qv0b+nxTUeiOOwixvQHV+x8Dxr7TPK0o/DIyDa/sqxgz2e
	 y2zrgGagZIYu3vTdPb9mB5+tnhf+6JsKnpAEeUFaS9duXa0poz4KMCJCpg6kZFYailApX
	 5L0OwtuJjKNmrCSnO5yrxrfyndC501Vu49jqCDEVW0winkee0tayXPsJSXpF14n9n/HsO
	 pe1h9y4yf7jlwERhYoVxNVynVWJ8qBW8xaWCKvHSRwlUsof1mFZm+zksya8D/efEExA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793205689;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=y73LTGnrOWdw/D1CDygVpQQVU2M42cqC8bH2Z3m1YAg=;
	b=OJXQsmVUgkT33fV+dwAMIPw3IVEYhndMTaxERNpL7Odt1FOZTNV4xp1TbtyXD9eons+D
	 GjjAscL6JV8Re199gSiRX3cAji+hPgzpK9Qi2HQ7hD4MF8LFhOBu/jHPdOgSqdI42122B
	 H0v8X11NA3aE0vnNazA68B8OrZZpKO9uK38PIK90tOKq0BWu3+YIXPRPVSe3sQgp5sqOj
	 z1z4H53cYzK+MVEj/YQyO7m8o5vUW809o5/uuNxGX70dwYoJq41qkb5Z3ngs5W3I2dKck
	 gCtp1HQR6oZDs0aIY5z+A2oMTTBZbSJcoQqCRMR8wyknNH/JMDx/Q5191LzllK6nZRQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=BfMzPkHq;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8378F606A31A;
	Wed, 28 Oct 2026 16:41:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=BfMzPkHq
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 816F91F01825;
	Wed, 28 Oct 2026 16:41:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793205689;
	bh=y73LTGnrOWdw/D1CDygVpQQVU2M42cqC8bH2Z3m1YAg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=BfMzPkHq8S1m2Nn+h6GT7XDV0G5gtZzWLdryebdlXVvELfpopCDtQUEGoHUqgebeC
	 4HuAN8gnfAJq4iKXAcA5DMVbb83sohRc0f/517z/z9jYlyhXnjrIH/PYF+n1lI4eAB
	 NF4+7Uh2vFeryG5o7rANC0DbnYNrXbDuRh+kQEaSDZhTCDpOhWKvvtJE95Nj879Wpc
	 r4YSbwU/orh3Go2tnQf42bysxDuwO1ZCtFdtcdaC/g/k/3HQGrIEIBDjGnGGAjJqlq
	 7MGsZwkCf76K3ryxiaNO/lXKNNhdLFRM1vfsN6oLmMLpsZofhQ5QZ5VNGHBAFac/Y5
	 W2xXGl+mXRDgQ==
Date: Wed, 28 Oct 2026 16:41:23 +0000
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Alexandru Elisei <alexandru.elisei@arm.com>
Cc: maz@kernel.org, oupton@kernel.org, fuad.tabba@linux.dev, 
	joey.gouly@arm.com, seiden@linux.ibm.com, suzuki.poulose@arm.com, 
	yuzenghui@huawei.com, linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	will@kernel.org, mark.rutland@arm.com, linux-perf-users@vger.kernel.org, 
	catalin.marinas@arm.com, james.clark@linaro.org
Subject: Re: [RFC PATCH v7 15/28] KVM: arm64: Use PMSVer from the assigned
 SPE instance
Message-ID: <auH8fQ28BnlZUrpE@gremlin>
References: <20260903160623.315525-1-alexandru.elisei@arm.com>
 <20260903160623.315525-16-alexandru.elisei@arm.com>
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260903160623.315525-16-alexandru.elisei@arm.com>

On Thu, Sep 03, 2026 at 05:06:10PM +0100, Alexandru Elisei wrote:
> KVM allows SPE to be virtualized on heterogeneous system, where hardware
> can implement multiple SPE instances for different CPUs, or where SPE
> might even be missing on some of the physical CPUs.
>
> KVM resets the VCPU ID registers following a KVM_ARM_VCPU_INIT ioctl.
> Using the value for ID_AA64DFR0_EL1.PMSVer on the physical CPU where the
> ioctl is executing is unreliable, since userspace might want to later
> assign a different SPE instance, with a different PMSVer value. Worse yet,
> it is be possible that the VCPU reset is being performed on a physical CPU

'it is be' -> 'it is'.

> without SPE. Be consistent and use PMSVer for the SPE instance assigned to
> the VM to initialize ID_AA64DFR0_EL1.PMSVer.
>
> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>

Note that this has to be rebased as 2ce80f624032 changed how all this works :)

> ---
>  arch/arm64/include/asm/kvm_spe.h | 10 ++++++++++
>  arch/arm64/kvm/spe.c             | 24 ++++++++++++++++++++++++
>  arch/arm64/kvm/sys_regs.c        |  8 +++++++-
>  3 files changed, 41 insertions(+), 1 deletion(-)
>
> diff --git a/arch/arm64/include/asm/kvm_spe.h b/arch/arm64/include/asm/kvm_spe.h
> index a6999709b298..4bae3e6b05c8 100644
> --- a/arch/arm64/include/asm/kvm_spe.h
> +++ b/arch/arm64/include/asm/kvm_spe.h
> @@ -29,11 +29,14 @@ bool kvm_supports_spe(void);
>  int kvm_spe_vcpu_first_run_init(struct kvm_vcpu *vcpu);
>  void kvm_spe_destroy_vm(struct kvm *kvm);
>
> +void kvm_spe_finalize_idregs(struct kvm *kvm);
> +
>  int kvm_spe_set_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr);
>  int kvm_spe_get_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr);
>  int kvm_spe_has_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr);
>
>  bool kvm_spe_pmu_set(struct kvm *kvm);
> +u8 kvm_spe_get_pmsver(struct kvm *kvm);

Hmm, the field it returns is u16?

	u16					pmsver;

>  #else
>  struct kvm_spe {
>  };
> @@ -55,6 +58,9 @@ static inline int kvm_spe_vcpu_first_run_init(struct kvm_vcpu *vcpu)
>  static inline void kvm_spe_destroy_vm(struct kvm *kvm)
>  {
>  }
> +static inline void kvm_spe_finalize_idregs(struct kvm *kvm)
> +{
> +}
>  static inline int kvm_spe_set_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr)
>  {
>  	return -ENXIO;
> @@ -71,6 +77,10 @@ static inline bool kvm_spe_pmu_set(struct kvm *kvm)
>  {
>  	return false;
>  }
> +static inline u8 kvm_spe_get_pmsver(struct kvm *kvm)
> +{
> +	return 0;
> +}
>  #endif /* CONFIG_KVM_ARM_SPE */
>
>  #endif /* __ARM64_KVM_SPE_H__ */
> diff --git a/arch/arm64/kvm/spe.c b/arch/arm64/kvm/spe.c
> index fa87d224c8af..4426d614a9e0 100644
> --- a/arch/arm64/kvm/spe.c
> +++ b/arch/arm64/kvm/spe.c
> @@ -87,6 +87,30 @@ bool kvm_spe_pmu_set(struct kvm *kvm)
>  	return !!kvm->arch.kvm_spe.spe_pmu;
>  }
>
> +void kvm_spe_finalize_idregs(struct kvm *kvm)
> +{
> +	struct arm_spe_pmu *spe_pmu = kvm->arch.kvm_spe.spe_pmu;
> +	u64 reg;
> +
> +	if (!spe_pmu)
> +		return;
> +
> +	reg = kvm_read_vm_id_reg(kvm, SYS_ID_AA64DFR0_EL1);
> +	reg &= ~ID_AA64DFR0_EL1_PMSVer_MASK;
> +	reg |= SYS_FIELD_PREP(ID_AA64DFR0_EL1, PMSVer, spe_pmu->pmsver);
> +	kvm_set_vm_id_reg(kvm, SYS_ID_AA64DFR0_EL1, reg);
> +}

I know sashiko raised something about this, and mostly you're right to dismiss
those, but I think one issue remains here.

Consider:

1. KVM_ARCH_VCPU_INIT

__kvm_vcpu_set_target()
  -> kvm_reset_vcpu()
    -> ...
      -> __kvm_read_sanitised_id_reg()
        -> sanitise_id_aa64dfr0_el1()
          -> kvm_spe_get_pmsver()
	    No instance assigned yet

	    SET: PMSVer = 0

2. KVM_SET_DEVICE_ATTR(KVM_ARM_VCPU_SPE_ID)

kvm_arm_vcpu_arch_set_attr()
  -> kvm_spe_set_attr()
    -> kvm_spe_set_spe_id()
       Nothing updates the register.

       SET: kvm_spe->spe_pmu = spe_pmu

3. KVM_GET_ONE_REG(ID_AA64DFR0_EL1)

get_id_reg()
  -> read_id_reg()
    -> kvm_read_vm_id_reg()

       RETURNS: PMSVer == 0

4. KVM_SET_ONE_REG(ID_AA64DFR0_EL1) with val from 3 (=0)

set_id_aa64dfr0_el1()
  -> set_id_reg()
    -> arm64_check_features()
       u64 limit = rd->reset(vcpu, rd);
         -> ...
           -> [ same sanitise hook as 1 ]
              kvm_spe->spe_pmu now assigned.

       limit = N (!!)

       Fails, because:

            if ((val & ~mask) != (limit & ~mask))
                return -E2BIG;

       PMSVer isn't in the writable mask, val from step 3 is 0, limit
       is N.

So I think the right solution is to call kvm_spe_finalize_idregs() in
kvm_spe_set_spe_id(), after setting kvm_spe->spe_pmu = spe_pmu.

That way steps 3 and 4 above work, and step 2, which sets the SPE ID,
also sets PMSVer.

> +
> +u8 kvm_spe_get_pmsver(struct kvm *kvm)
> +{
> +	struct arm_spe_pmu *spe_pmu = kvm->arch.kvm_spe.spe_pmu;

NIT: could be const?

> +
> +	if (!spe_pmu)
> +		return 0;
> +
> +	return spe_pmu->pmsver;
> +}
> +
>  static int kvm_spe_update_supported_cpus(struct kvm *kvm, cpumask_t *spe_cpus)
>  {
>  	return kvm_update_supported_cpus(kvm, NULL, spe_cpus);
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index 44aae52c473d..a6bb6884b965 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -2220,8 +2220,11 @@ static u64 sanitise_id_aa64dfr0_el1(const struct kvm_vcpu *vcpu, u64 val)
>  		val |= SYS_FIELD_PREP(ID_AA64DFR0_EL1, PMUVer,
>  				      kvm_arm_pmu_get_pmuver_limit());
>
> -	/* Hide SPE from guests */
> +	/* Only initialize the SPE version if the vCPU has the feature. */
>  	val &= ~ID_AA64DFR0_EL1_PMSVer_MASK;
> +	if (vcpu_has_spe(vcpu))
> +		val |= SYS_FIELD_PREP(ID_AA64DFR0_EL1, PMSVer,
> +				      kvm_spe_get_pmsver(vcpu->kvm));
>
>  	/* Hide BRBE from guests */
>  	val &= ~ID_AA64DFR0_EL1_BRBE_MASK;
> @@ -5928,6 +5931,9 @@ int kvm_finalize_sys_regs(struct kvm_vcpu *vcpu)
>  		kvm_vgic_finalize_idregs(kvm);
>  	}
>
> +	if (vcpu_has_spe(vcpu))
> +		kvm_spe_finalize_idregs(kvm);

kvm_spe_finalize_idregs() already exits if !spe_pmu, so this could be
invoked unconditionally?

> +
>  	return 0;
>  }
>
> --
> 2.43.0
>
>

--
Cheers, Lorenzo
