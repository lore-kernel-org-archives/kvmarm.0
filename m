Received: from out-189.mta0.migadu.com (out-189.mta0.migadu.com [91.218.175.189])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 891CE55787
	for <kvmarm@lists.linux.dev>; Tue, 21 Nov 2023 23:28:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="QNToNuD3"
Date: Tue, 21 Nov 2023 23:27:57 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1700609282;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=2q8dv0rjx9h4tXKNgzb9NkEHz5STcz1Q2TUBr0ldfo4=;
	b=QNToNuD3IJTeznaC1U1UP7DbremOVuzOPkTGwIxq0AZdTlFw7LwG5SnJ0M5sR1RLjwMunW
	O9OBsByGxaevknXCrP+K9B699B12hJl02KZesXFexMMe+SaQkkN+M9MDwzCXPsi1rLakFG
	AYFMXf19GhkuwnqMLwaCzJJjGvD7zC0=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Ryan Roberts <ryan.roberts@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	James Morse <james.morse@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>, Ard Biesheuvel <ardb@kernel.org>,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev
Subject: Re: [PATCH v5 11/12] KVM: selftests: arm64: Determine max ipa size
 per-page size
Message-ID: <ZV08_eU9vV1SUmmd@linux.dev>
References: <20231116142931.1675485-1-ryan.roberts@arm.com>
 <20231116142931.1675485-12-ryan.roberts@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231116142931.1675485-12-ryan.roberts@arm.com>
X-Migadu-Flow: FLOW_OUT

On Thu, Nov 16, 2023 at 02:29:30PM +0000, Ryan Roberts wrote:
> We are about to add 52 bit PA guest modes for 4K and 16K pages when the
> system supports LPA2. In preparation beef up the logic that parses mmfr0
> to also tell us what the maximum supported PA size is for each page
> size. Max PA size = 0 implies the page size is not supported at all.
> 
> Signed-off-by: Ryan Roberts <ryan.roberts@arm.com>
> ---
>  .../selftests/kvm/include/aarch64/processor.h |  4 +-
>  .../selftests/kvm/lib/aarch64/processor.c     | 27 ++++++++++---
>  tools/testing/selftests/kvm/lib/guest_modes.c | 40 ++++++++-----------
>  3 files changed, 41 insertions(+), 30 deletions(-)
> 
> diff --git a/tools/testing/selftests/kvm/include/aarch64/processor.h b/tools/testing/selftests/kvm/include/aarch64/processor.h
> index c42d683102c7..cf20e44e86f2 100644
> --- a/tools/testing/selftests/kvm/include/aarch64/processor.h
> +++ b/tools/testing/selftests/kvm/include/aarch64/processor.h
> @@ -119,8 +119,8 @@ enum {
>  /* Access flag update enable/disable */
>  #define TCR_EL1_HA		(1ULL << 39)
>  
> -void aarch64_get_supported_page_sizes(uint32_t ipa,
> -				      bool *ps4k, bool *ps16k, bool *ps64k);
> +void aarch64_get_supported_page_sizes(uint32_t ipa, uint32_t *ipa4k,
> +					uint32_t *ipa16k, uint32_t *ipa64k);
>  
>  void vm_init_descriptor_tables(struct kvm_vm *vm);
>  void vcpu_init_descriptor_tables(struct kvm_vcpu *vcpu);
> diff --git a/tools/testing/selftests/kvm/lib/aarch64/processor.c b/tools/testing/selftests/kvm/lib/aarch64/processor.c
> index 6fe12e985ba5..917cfeddb6b4 100644
> --- a/tools/testing/selftests/kvm/lib/aarch64/processor.c
> +++ b/tools/testing/selftests/kvm/lib/aarch64/processor.c
> @@ -492,12 +492,24 @@ uint32_t guest_get_vcpuid(void)
>  	return read_sysreg(tpidr_el1);
>  }
>  
> -void aarch64_get_supported_page_sizes(uint32_t ipa,
> -				      bool *ps4k, bool *ps16k, bool *ps64k)
> +static uint32_t max_ipa_for_page_size(uint32_t vm_ipa, uint32_t gran,
> +				uint32_t not_sup_val, uint32_t ipa52_min_val)
> +{
> +	if (gran == not_sup_val)
> +		return 0;
> +	else if (gran >= ipa52_min_val && vm_ipa >= 52)
> +		return 52;
> +	else
> +		return min(vm_ipa, 48U);
> +}
> +
> +void aarch64_get_supported_page_sizes(uint32_t ipa, uint32_t *ipa4k,
> +					uint32_t *ipa16k, uint32_t *ipa64k)
>  {
>  	struct kvm_vcpu_init preferred_init;
>  	int kvm_fd, vm_fd, vcpu_fd, err;
>  	uint64_t val;
> +	uint32_t gran;
>  	struct kvm_one_reg reg = {
>  		.id	= KVM_ARM64_SYS_REG(SYS_ID_AA64MMFR0_EL1),
>  		.addr	= (uint64_t)&val,
> @@ -518,9 +530,14 @@ void aarch64_get_supported_page_sizes(uint32_t ipa,
>  	err = ioctl(vcpu_fd, KVM_GET_ONE_REG, &reg);
>  	TEST_ASSERT(err == 0, KVM_IOCTL_ERROR(KVM_GET_ONE_REG, vcpu_fd));
>  
> -	*ps4k = FIELD_GET(ARM64_FEATURE_MASK(ID_AA64MMFR0_EL1_TGRAN4), val) != 0xf;
> -	*ps64k = FIELD_GET(ARM64_FEATURE_MASK(ID_AA64MMFR0_EL1_TGRAN64), val) == 0;
> -	*ps16k = FIELD_GET(ARM64_FEATURE_MASK(ID_AA64MMFR0_EL1_TGRAN16), val) != 0;
> +	gran = FIELD_GET(ARM64_FEATURE_MASK(ID_AA64MMFR0_EL1_TGRAN4), val);
> +	*ipa4k = max_ipa_for_page_size(ipa, gran, 0xf, 1);
> +
> +	gran = FIELD_GET(ARM64_FEATURE_MASK(ID_AA64MMFR0_EL1_TGRAN64), val);
> +	*ipa64k = max_ipa_for_page_size(ipa, gran, 0xf, 0);
> +
> +	gran = FIELD_GET(ARM64_FEATURE_MASK(ID_AA64MMFR0_EL1_TGRAN16), val);
> +	*ipa16k = max_ipa_for_page_size(ipa, gran, 0, 2);
>  
>  	close(vcpu_fd);
>  	close(vm_fd);
> diff --git a/tools/testing/selftests/kvm/lib/guest_modes.c b/tools/testing/selftests/kvm/lib/guest_modes.c
> index 1df3ce4b16fd..c64c5cf49942 100644
> --- a/tools/testing/selftests/kvm/lib/guest_modes.c
> +++ b/tools/testing/selftests/kvm/lib/guest_modes.c
> @@ -18,33 +18,27 @@ void guest_modes_append_default(void)
>  #else
>  	{
>  		unsigned int limit = kvm_check_cap(KVM_CAP_ARM_VM_IPA_SIZE);
> -		bool ps4k, ps16k, ps64k;
> +		uint32_t ipa4k, ipa16k, ipa64k;
>  		int i;
>  
> -		aarch64_get_supported_page_sizes(limit, &ps4k, &ps16k, &ps64k);
> +		aarch64_get_supported_page_sizes(limit, &ipa4k, &ipa16k, &ipa64k);
>  
> -		vm_mode_default = NUM_VM_MODES;
> +		guest_mode_append(VM_MODE_P52V48_64K, ipa64k >= 52, ipa64k >= 52);

Can we just change guest_mode_append() to take a single bool argument and
initialize both ::supported and ::enabled to its value?

-- 
Thanks,
Oliver
