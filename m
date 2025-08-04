Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A6F731CF96
	for <kvmarm@lists.linux.dev>; Mon,  4 Aug 2025 14:45:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754318759; cv=none; b=UwRsmzQie1xfAa/ynVl6v02OebBhhNJ/wrgArVhy+v4dNyKUbB4SiNbUe3rKDbsGvWs7Uw0Dr0za8+ZyIzmByBQYEIyRz2kODiimVDhryOMc0LKmZ1OPklsjSq/wTcuQcYl/ohkAP3IVOeSBs/RJSpRULi9gsiV0NehpAMjl6wI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754318759; c=relaxed/simple;
	bh=EQ4Dy7WaXAGw103x8zOvCFCZnxAhm/wONRFGUEzl5kQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VooI5QpPoshCEuipSbfC8Edx4f6zZYuJb/oovY1utPTC1LyIYLrpG2c5qSpd9bOBhIt8uK2lbovykZOdoDtukQQ4alM8AtJiEpSfi1DKl58SlWcCRIXEMXXnrmTW7cC1lATXMQFPr5DZe+e34KcgCKeXpES4z94aPjSAvHul+pI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 0163A150C;
	Mon,  4 Aug 2025 07:45:48 -0700 (PDT)
Received: from raptor (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 059813F738;
	Mon,  4 Aug 2025 07:45:54 -0700 (PDT)
Date: Mon, 4 Aug 2025 15:45:52 +0100
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: Andre Przywara <andre.przywara@arm.com>
Cc: Will Deacon <will@kernel.org>,
	Julien Thierry <julien.thierry.kdev@gmail.com>,
	Marc Zyngier <maz@kernel.org>, kvm@vger.kernel.org,
	kvmarm@lists.linux.dev
Subject: Re: [PATCH kvmtool v3 5/6] arm64: add FEAT_E2H0 support
Message-ID: <aJDHoHIeZ5ADqah3@raptor>
References: <20250729095745.3148294-1-andre.przywara@arm.com>
 <20250729095745.3148294-6-andre.przywara@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250729095745.3148294-6-andre.przywara@arm.com>

Hi,

According to the Arm ARM, FEAT_E2H0 can co-exist with FEAT_VHE; KVM implements
it differently and disables FEAT_VHE when KVM_ARM_VCPU_HAS_EL2_E2H0. Maybe the
subject should be "arm64: Add KVM_ARM_VCPU_HAS_EL2_E2H0 support"?

Also, 'add' should be capitalized.

On Tue, Jul 29, 2025 at 10:57:44AM +0100, Andre Przywara wrote:
> From: Marc Zyngier <maz@kernel.org>
> 
> The --nested option allows a guest to boot at EL2 without FEAT_E2H0
> (i.e. mandating VHE support). While this is great for "modern" operating
> systems and hypervisors, a few legacy guests are stuck in a distant past.
> 
> To support those, add the --e2h0 command line option, that exposes
> FEAT_E2H0 to the guest, at the expense of a number of other features, such
> as FEAT_NV2. This is conditioned on the host itself supporting FEAT_E2H0.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> Signed-off-by: Andre Przywara <andre.przywara@arm.com>
> ---
>  arm64/include/kvm/kvm-config-arch.h | 5 ++++-
>  arm64/kvm-cpu.c                     | 5 +++++
>  2 files changed, 9 insertions(+), 1 deletion(-)
> 
> diff --git a/arm64/include/kvm/kvm-config-arch.h b/arm64/include/kvm/kvm-config-arch.h
> index 44c43367b..73bf4211a 100644
> --- a/arm64/include/kvm/kvm-config-arch.h
> +++ b/arm64/include/kvm/kvm-config-arch.h
> @@ -11,6 +11,7 @@ struct kvm_config_arch {
>  	bool		has_pmuv3;
>  	bool		mte_disabled;
>  	bool		nested_virt;
> +	bool		e2h0;
>  	u64		kaslr_seed;
>  	enum irqchip_type irqchip;
>  	u64		fw_addr;
> @@ -63,6 +64,8 @@ int sve_vl_parser(const struct option *opt, const char *arg, int unset);
>  	OPT_U64('\0', "counter-offset", &(cfg)->counter_offset,			\
>  		"Specify the counter offset, defaulting to 0"),			\
>  	OPT_BOOLEAN('\0', "nested", &(cfg)->nested_virt,			\
> -		    "Start VCPUs in EL2 (for nested virt)"),
> +		    "Start VCPUs in EL2 (for nested virt)"),			\
> +	OPT_BOOLEAN('\0', "e2h0", &(cfg)->e2h0,					\
> +		    "Create guest without VHE support"),
>  
>  #endif /* ARM_COMMON__KVM_CONFIG_ARCH_H */
> diff --git a/arm64/kvm-cpu.c b/arm64/kvm-cpu.c
> index 42dc11dad..5e4f3a7dd 100644
> --- a/arm64/kvm-cpu.c
> +++ b/arm64/kvm-cpu.c
> @@ -76,6 +76,11 @@ static void kvm_cpu__select_features(struct kvm *kvm, struct kvm_vcpu_init *init
>  		if (!kvm__supports_extension(kvm, KVM_CAP_ARM_EL2))
>  			die("EL2 (nested virt) is not supported");
>  		init->features[0] |= 1UL << KVM_ARM_VCPU_HAS_EL2;
> +		if (kvm->cfg.arch.e2h0) {
> +			if (!kvm__supports_extension(kvm, KVM_CAP_ARM_EL2_E2H0))
> +				die("FEAT_E2H0 is not supported");
> +			init->features[0] |= 1UL << KVM_ARM_VCPU_HAS_EL2_E2H0;
> +		}

From the v6.16 documentation (emphasis added by me):

	- KVM_ARM_VCPU_HAS_EL2_E2H0: Restrict Nested Virtualisation
	  support to HCR_EL2.E2H being RES0 (non-VHE).
	  Depends on KVM_CAP_ARM_EL2_E2H0.
	  **KVM_ARM_VCPU_HAS_EL2 must also be set**.

But I am able to run a VM with E2H0 set and EL2 unset:

# ./lkvm-static run -c2 -m1024 -k Image-v6.16-rc4-upstream --nodefaults -p "earlycon root=/dev/vda" --e2h0
  Info: # lkvm run -k Image-v6.16-rc4-upstream -m 1024 -c 2 --name guest-165
[    0.000000] Booting Linux on physical CPU 0x0000000000 [0x410fd0f0]
..
[    0.390199] kvm [1]: HYP mode not available

If the documentation is correct, I would suggest that you also add a check for
nested virtualization being enabled in kvm__arch_validate_cfg().

Thanks,
Alex
