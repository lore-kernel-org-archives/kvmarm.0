Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05726423A72;
	Tue, 28 Apr 2026 12:49:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777380594; cv=none; b=c1ZI7Nuzro6wOS12HmFb86Za7zvVbSTrTVAeYeA+1rmCzNctOMxXDzYl3GJnLp1Fh4iOAojzCm+WRrCHNFa4xpiF8mEYNuLvXdw66841xHjLe6e+Q0YvHNXjm+GP6vSucNszhJW2VtSwe/cHZqfFVJ0pN5wRz2+/HUY6m8TJ0AI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777380594; c=relaxed/simple;
	bh=o7apMA543mS4j2c7xTwm80XPqaSxCYia4GzAfiaaIDA=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=JC9gj5fmnCqLOdcmBOO3uPVRyAYGdJwB/h7m1iGd0RHsVit3v6ZDbpfA4QUswC8ZpPeAPdAl9scZ/F/ODO0lA6w/4aOa0bnynoEXD9MVbmCefTOARuHclKx/2c0SrW1WFby/NwkUAlwwLLWAU5OfLV9rixvvNHmgSamVVgIpjk0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=soNw+168; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="soNw+168"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7BE29C2BCAF;
	Tue, 28 Apr 2026 12:49:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777380593;
	bh=o7apMA543mS4j2c7xTwm80XPqaSxCYia4GzAfiaaIDA=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=soNw+168P1lCpTJ9zvnP0BSl27Tbf38zx3xdZfograCXhbpeQvOk3yADUyxf0laWS
	 RM7NGFaG4UmGgqda9Kx/ArhJ2yXSw5WVnEJsukzECSE7yur5nwT2tVL1lsztPbLDqS
	 +daHrRzNHUMti1HAlV/9UxCtZxhrrlJV59qh6TDzIEUJ5CLuh/NfrcBUdBA+Wj+j2l
	 T14/hkulvQUcRokqyZmKhpYWYf6JX8xv77uEVtDIqo5WXQ9PbHI05Eit/fzCoK5x24
	 RiMurBRpHCdU6udcnNSXpg93M6h4mvpvDd5gprIZw4XulQfNHKisp/WjzeMgvvIx3O
	 pDNniIr468mdg==
X-Mailer: emacs 30.2 (via feedmail 11-beta-1 I)
From: Aneesh Kumar K.V <aneesh.kumar@kernel.org>
To: Marc Zyngier <maz@kernel.org>
Cc: linux-kernel@vger.kernel.org, iommu@lists.linux.dev,
	linux-coco@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	Catalin Marinas <catalin.marinas@arm.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Steven Price <steven.price@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Will Deacon <will@kernel.org>
Subject: Re: [PATCH v4 3/3] coco: guest: arm64: Query host IPA-change
 alignment via RHI
In-Reply-To: <86y0i8zo9f.wl-maz@kernel.org>
References: <20260427063108.909019-1-aneesh.kumar@kernel.org>
 <20260427063108.909019-4-aneesh.kumar@kernel.org>
 <86y0i8zo9f.wl-maz@kernel.org>
Date: Tue, 28 Apr 2026 18:19:46 +0530
Message-ID: <yq5a4ikv1c7p.fsf@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Marc Zyngier <maz@kernel.org> writes:

> On Mon, 27 Apr 2026 07:31:08 +0100,
> "Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org> wrote:
>>=20
>> Add the Realm Host Interface support needed to query host configuration
>> from a Realm guest. Define the RHI hostconf SMCs, add rsi_host_call(), a=
nd
>> use them during Realm initialization to retrieve the host IPA-change
>> alignment size.
>
> I don't understand what "IPA-change" means. What you are after is the
> host's sharing granule size.
>

This is part of the RHI specification, and the call is named
RHI_HOSTCONF_GET_IPA_CHANGE_ALIGNMENT. The intent is to determine the
alignment requirements for changing IPA attributes (protected vs.
unprotected IPA

>
>>=20
>> Expose that alignment through realm_get_hyp_pagesize() and
>> mem_decrypt_granule_size() so shared-buffer allocation and
>> encryption/decryption paths can honor the ipa change page-size requireme=
nt.
>>=20
>> If the host reports an invalid alignment (when alginment value is not
>> multiple of 4K), do not enable Realm support.
>>=20
>> This provides the host alignment information required by the shared buff=
er
>> alignment changes.
>>=20
>> Signed-off-by: Aneesh Kumar K.V (Arm) <aneesh.kumar@kernel.org>
>> ---
>>  arch/arm64/include/asm/mem_encrypt.h |  3 ++
>>  arch/arm64/include/asm/rhi.h         | 24 +++++++++++++
>>  arch/arm64/include/asm/rsi.h         |  2 ++
>>  arch/arm64/include/asm/rsi_cmds.h    | 10 ++++++
>>  arch/arm64/include/asm/rsi_smc.h     |  7 ++++
>>  arch/arm64/kernel/Makefile           |  2 +-
>>  arch/arm64/kernel/rhi.c              | 54 ++++++++++++++++++++++++++++
>>  arch/arm64/kernel/rsi.c              | 13 +++++++
>>  arch/arm64/mm/mem_encrypt.c          |  8 +++++
>>  9 files changed, 122 insertions(+), 1 deletion(-)
>>  create mode 100644 arch/arm64/include/asm/rhi.h
>>  create mode 100644 arch/arm64/kernel/rhi.c
>>=20
>> diff --git a/arch/arm64/include/asm/mem_encrypt.h b/arch/arm64/include/a=
sm/mem_encrypt.h
>> index 314b2b52025f..5541911eb028 100644
>> --- a/arch/arm64/include/asm/mem_encrypt.h
>> +++ b/arch/arm64/include/asm/mem_encrypt.h
>> @@ -16,6 +16,9 @@ int arm64_mem_crypt_ops_register(const struct arm64_me=
m_crypt_ops *ops);
>>  int set_memory_encrypted(unsigned long addr, int numpages);
>>  int set_memory_decrypted(unsigned long addr, int numpages);
>>=20=20
>> +#define mem_decrypt_granule_size mem_decrypt_granule_size
>> +size_t mem_decrypt_granule_size(void);
>> +
>>  int realm_register_memory_enc_ops(void);
>>=20=20
>>  static inline bool force_dma_unencrypted(struct device *dev)
>> diff --git a/arch/arm64/include/asm/rhi.h b/arch/arm64/include/asm/rhi.h
>> new file mode 100644
>> index 000000000000..0895dd92ea1d
>> --- /dev/null
>> +++ b/arch/arm64/include/asm/rhi.h
>> @@ -0,0 +1,24 @@
>> +/* SPDX-License-Identifier: GPL-2.0-only */
>> +/*
>> + * Copyright (C) 2026 ARM Ltd.
>> + */
>> +
>> +#ifndef __ASM_RHI_H_
>> +#define __ASM_RHI_H_
>> +
>> +#include <linux/types.h>
>> +
>> +#define SMC_RHI_CALL(func)				\
>> +	ARM_SMCCC_CALL_VAL(ARM_SMCCC_FAST_CALL,		\
>> +			   ARM_SMCCC_SMC_64,		\
>> +			   ARM_SMCCC_OWNER_STANDARD_HYP,\
>> +			   (func))
>> +
>> +unsigned long rhi_get_ipa_change_alignment(void);
>> +#define RHI_HOSTCONF_VER_1_0		0x10000
>> +#define RHI_HOSTCONF_VERSION		SMC_RHI_CALL(0x004E)
>> +
>> +#define __RHI_HOSTCONF_GET_IPA_CHANGE_ALIGNMENT BIT(0)
>> +#define RHI_HOSTCONF_FEATURES		SMC_RHI_CALL(0x004F)
>> +#define RHI_HOSTCONF_GET_IPA_CHANGE_ALIGNMENT	SMC_RHI_CALL(0x0050)
>> +#endif
>> diff --git a/arch/arm64/include/asm/rsi.h b/arch/arm64/include/asm/rsi.h
>> index 88b50d660e85..ae54fb3b1429 100644
>> --- a/arch/arm64/include/asm/rsi.h
>> +++ b/arch/arm64/include/asm/rsi.h
>> @@ -67,4 +67,6 @@ static inline int rsi_set_memory_range_shared(phys_add=
r_t start,
>>  	return rsi_set_memory_range(start, end, RSI_RIPAS_EMPTY,
>>  				    RSI_CHANGE_DESTROYED);
>>  }
>> +
>> +unsigned long realm_get_hyp_pagesize(void);
>>  #endif /* __ASM_RSI_H_ */
>> diff --git a/arch/arm64/include/asm/rsi_cmds.h b/arch/arm64/include/asm/=
rsi_cmds.h
>> index 2c8763876dfb..a341ce0eeda1 100644
>> --- a/arch/arm64/include/asm/rsi_cmds.h
>> +++ b/arch/arm64/include/asm/rsi_cmds.h
>> @@ -159,4 +159,14 @@ static inline unsigned long rsi_attestation_token_c=
ontinue(phys_addr_t granule,
>>  	return res.a0;
>>  }
>>=20=20
>> +static inline unsigned long rsi_host_call(struct rsi_host_call *rhi_cal=
l)
>> +{
>> +	phys_addr_t addr =3D virt_to_phys(rhi_call);
>> +	struct arm_smccc_res res;
>> +
>> +	arm_smccc_1_1_invoke(SMC_RSI_HOST_CALL, addr, &res);
>
> Errr... What guarantees that *rhi_call is *IPA contiguous*? This is
> incredibly fragile. You should at the very least check that this isn't
> vmalloc'd.
>


I didn=E2=80=99t quite follow that. We have other RSI calls (even RMI calls)
that do similar things, and the caller understands that the address
should be IPA-contiguous. Are you suggesting that all RSI calls should
add checks for this?. or are you suggesting to update the API to

unsigned long rsi_host_call(unsigned long rhi_call_phys) ?

>> +
>> +	return res.a0;
>> +}
>> +
>>  #endif /* __ASM_RSI_CMDS_H */
>> diff --git a/arch/arm64/include/asm/rsi_smc.h b/arch/arm64/include/asm/r=
si_smc.h
>> index e19253f96c94..9ee8b5c7612e 100644
>> --- a/arch/arm64/include/asm/rsi_smc.h
>> +++ b/arch/arm64/include/asm/rsi_smc.h
>> @@ -182,6 +182,13 @@ struct realm_config {
>>   */
>>  #define SMC_RSI_IPA_STATE_GET			SMC_RSI_FID(0x198)
>>=20=20
>> +struct rsi_host_call {
>> +	union {
>> +		u16 imm;
>> +		u64 padding0;
>> +	};
>> +	u64 gprs[31];
>> +} __aligned(0x100);
>>  /*
>>   * Make a Host call.
>>   *
>> diff --git a/arch/arm64/kernel/Makefile b/arch/arm64/kernel/Makefile
>> index fe627100d199..3e72dd9584ed 100644
>> --- a/arch/arm64/kernel/Makefile
>> +++ b/arch/arm64/kernel/Makefile
>> @@ -34,7 +34,7 @@ obj-y			:=3D debug-monitors.o entry.o irq.o fpsimd.o		\
>>  			   cpufeature.o alternative.o cacheinfo.o		\
>>  			   smp.o smp_spin_table.o topology.o smccc-call.o	\
>>  			   syscall.o proton-pack.o idle.o patching.o pi/	\
>> -			   rsi.o jump_label.o
>> +			   rsi.o jump_label.o rhi.o
>>=20=20
>>  obj-$(CONFIG_COMPAT)			+=3D sys32.o signal32.o			\
>>  					   sys_compat.o
>> diff --git a/arch/arm64/kernel/rhi.c b/arch/arm64/kernel/rhi.c
>> new file mode 100644
>> index 000000000000..7cd6c5102464
>> --- /dev/null
>> +++ b/arch/arm64/kernel/rhi.c
>> @@ -0,0 +1,54 @@
>> +// SPDX-License-Identifier: GPL-2.0-only
>> +/*
>> + * Copyright (C) 2026 ARM Ltd.
>> + */
>> +
>> +#include <linux/mm.h>
>> +#include <asm/rsi.h>
>> +#include <asm/rhi.h>
>> +
>> +/* we need an aligned rhicall for rsi_host_call. slab is not yet ready =
*/
>> +static struct rsi_host_call hyp_pagesize_rhicall;
>
> Why the "hyp_" prefix? This has absolutely nothing to with the
> hypervisor.
>

Sure will update "hyp_" reference to host.=20


>> +unsigned long rhi_get_ipa_change_alignment(void)
>> +{
>> +	long ret;
>> +	unsigned long ipa_change_align;
>> +
>> +	hyp_pagesize_rhicall.imm =3D 0;
>> +	hyp_pagesize_rhicall.gprs[0] =3D RHI_HOSTCONF_VERSION;
>> +	ret =3D rsi_host_call(lm_alias(&hyp_pagesize_rhicall));
>> +	if (ret !=3D RSI_SUCCESS)
>> +		goto err_out;
>> +
>> +	if (hyp_pagesize_rhicall.gprs[0] !=3D RHI_HOSTCONF_VER_1_0)
>> +		goto err_out;
>> +
>> +	hyp_pagesize_rhicall.imm =3D 0;
>> +	hyp_pagesize_rhicall.gprs[0] =3D RHI_HOSTCONF_FEATURES;
>> +	ret =3D rsi_host_call(lm_alias(&hyp_pagesize_rhicall));
>> +	if (ret !=3D RSI_SUCCESS)
>> +		goto err_out;
>> +
>> +	if (!(hyp_pagesize_rhicall.gprs[0] & __RHI_HOSTCONF_GET_IPA_CHANGE_ALI=
GNMENT))
>> +		goto err_out;
>> +
>> +	hyp_pagesize_rhicall.imm =3D 0;
>> +	hyp_pagesize_rhicall.gprs[0] =3D RHI_HOSTCONF_GET_IPA_CHANGE_ALIGNMENT;
>> +	ret =3D rsi_host_call(lm_alias(&hyp_pagesize_rhicall));
>> +	if (ret !=3D RSI_SUCCESS)
>> +		goto err_out;
>> +
>> +	ipa_change_align =3D hyp_pagesize_rhicall.gprs[0];
>> +	/* This error needs special handling in the caller */
>> +	if (ipa_change_align & (SZ_4K - 1))
>> +		return 0;
>> +
>> +	return ipa_change_align;
>> +
>> +err_out:
>> +	/*
>> +	 * For failure condition assume host is built with 4K page size
>> +	 * and hence ipa change alignment can be guest PAGE_SIZE.
>> +	 */
>> +	return PAGE_SIZE;
>> +}
>
> Why can't this be part of rsi.c? This is an RSI call, and it should be
> part of the RSI initialisation.
>

This is an RHI call as per the specification, hence it has been added to
rhi.c.

>> diff --git a/arch/arm64/kernel/rsi.c b/arch/arm64/kernel/rsi.c
>> index 9e846ce4ef9c..ff735c04e236 100644
>> --- a/arch/arm64/kernel/rsi.c
>> +++ b/arch/arm64/kernel/rsi.c
>> @@ -14,8 +14,10 @@
>>  #include <asm/mem_encrypt.h>
>>  #include <asm/pgtable.h>
>>  #include <asm/rsi.h>
>> +#include <asm/rhi.h>
>>=20=20
>>  static struct realm_config config;
>> +static unsigned long ipa_change_alignment =3D PAGE_SIZE;
>>=20=20
>>  unsigned long prot_ns_shared;
>>  EXPORT_SYMBOL(prot_ns_shared);
>> @@ -139,6 +141,11 @@ static int realm_ioremap_hook(phys_addr_t phys, siz=
e_t size, pgprot_t *prot)
>>  	return 0;
>>  }
>>=20=20
>> +unsigned long realm_get_hyp_pagesize(void)
>> +{
>> +	return ipa_change_alignment;
>> +}
>
> Again, this has nothing to do with the hypervisor, but the host. And
> ipa_change_alignment is still a wording I can't wrap my small head
> around.
>
>> +
>>  void __init arm64_rsi_init(void)
>>  {
>>  	if (arm_smccc_1_1_get_conduit() !=3D SMCCC_CONDUIT_SMC)
>> @@ -147,6 +154,12 @@ void __init arm64_rsi_init(void)
>>  		return;
>>  	if (WARN_ON(rsi_get_realm_config(&config)))
>>  		return;
>> +
>> +	ipa_change_alignment =3D rhi_get_ipa_change_alignment();
>> +	/* If we don't get a correct alignment response, don't enable realm */
>> +	if (!ipa_change_alignment)
>> +		return;
>
> But at the same time, you override a global value with an error, and
> then paper over it in mem_decrypt_granule_size()...
>


I believe I received similar feedback on my previous version as well,
which I didn=E2=80=99t quite follow.

rhi_get_ipa_change_alignment() only returns an error when the host
returns a size that is not 4K-aligned. Otherwise, it returns the
host-determined size, or defaults to guest PAGE_SIZE if the RHI call
itself is not supported.

	ipa_change_align =3D hyp_pagesize_rhicall.gprs[0];
	/* This error needs special handling in the caller */
	if (ipa_change_align & (SZ_4K - 1))
		return 0;

	return ipa_change_align;

err_out:
	/*
	 * For failure condition assume host is built with 4K page size
	 * and hence ipa change alignment can be guest PAGE_SIZE.
	 */
	return PAGE_SIZE;

>
>> +
>>  	prot_ns_shared =3D __phys_to_pte_val(BIT(config.ipa_bits - 1));
>>=20=20
>>  	if (arm64_ioremap_prot_hook_register(realm_ioremap_hook))
>> diff --git a/arch/arm64/mm/mem_encrypt.c b/arch/arm64/mm/mem_encrypt.c
>> index 38c62c9e4e74..f5d64bc29c20 100644
>> --- a/arch/arm64/mm/mem_encrypt.c
>> +++ b/arch/arm64/mm/mem_encrypt.c
>> @@ -59,3 +59,11 @@ int set_memory_decrypted(unsigned long addr, int nump=
ages)
>>  	return crypt_ops->decrypt(addr, numpages);
>>  }
>>  EXPORT_SYMBOL_GPL(set_memory_decrypted);
>> +
>> +size_t mem_decrypt_granule_size(void)
>> +{
>> +	if (is_realm_world())
>> +		return max(PAGE_SIZE, realm_get_hyp_pagesize());
>
> If you didn't mess with ipa_change_alignment above, you shouldn't need
> this max().
>

size_t mem_decrypt_granule_size(void)
{
	if (is_realm_world())
		return max(PAGE_SIZE, realm_get_hyp_pagesize());
	return PAGE_SIZE;
}

That needs to use max(), because we should align to the guest PAGE_SIZE
if it is larger than the host-specified alignment value.

-aneesh
