Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0B77B4C226B;
	Wed, 16 Sep 2026 16:17:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789575478; cv=none; b=pj0rNx3uMgHUNFePwXWbgs188h3pSgIV+HSXIHBytj/2hFRS0j+WO/6ppuZ25b7ydjAPoPepxNs+vQzB64QosxERM5SmIGqNXG0ih6kTq8CuVr3lG6DL1XfYTBcLphA68ebS2M8MYmbQohZUE3/rwPvWRK9NkjmX4bpxCNeqgXk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789575478; c=relaxed/simple;
	bh=p3tHar0dLjbf4nNwS6ekOIUqzn63ULh+WZ3W0oLTGoo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=uCD6DhCU9jDBWXIb5mmxYB4pQ9Ob0XA+4uv9UOWyFjFE0hdeRQktickcE+SuhFZ2T/uFMRk5gEY1YHkuKSd8IhSM7AB7IvvudhpciGybM6Mfx05F67+hY1zGIDW7H/BLfGXldeS3iJmeTBLAL6/Sme8fWfPFKn6eOECNxIIldYc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=cn6Vo8NC; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="cn6Vo8NC"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id BCF451516;
	Wed, 16 Sep 2026 09:17:51 -0700 (PDT)
Received: from [10.57.8.14] (unknown [10.57.8.14])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 76BF43F7B4;
	Wed, 16 Sep 2026 09:17:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1789575475; bh=p3tHar0dLjbf4nNwS6ekOIUqzn63ULh+WZ3W0oLTGoo=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=cn6Vo8NCPcegLEUNK1RPA8H5PEILXVRQTJQ0cZ22KykkzbVPmh3J4vOId9XA0Z+Rc
	 kQVHuuBeJR4G+Z4A3QZ5PHT0nng89xsb+GtY1WCGoGnODFg4yXAbRUtfTx4ZRskudM
	 CY59agMktmzbpubX7yNFseXn1IiE4HaasgegGCpc=
Message-ID: <05239c7a-bdee-4d24-9375-c5b3497a4f78@arm.com>
Date: Wed, 16 Sep 2026 17:17:51 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 9/9] arm64: realm: Expose the CCA shared granule size
 through mem_encrypt ops
Content-Language: en-GB
To: "Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org>,
 linux-coco@lists.linux.dev, kvmarm@lists.linux.dev,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 iommu@lists.linux.dev
Cc: Catalin Marinas <catalin.marinas@arm.com>, Jason Gunthorpe
 <jgg@ziepe.ca>, Marc Zyngier <maz@kernel.org>,
 Marek Szyprowski <m.szyprowski@samsung.com>,
 Robin Murphy <robin.murphy@arm.com>, Steven Price <steven.price@arm.com>,
 Thomas Gleixner <tglx@kernel.org>, Will Deacon <will@kernel.org>
References: <20260904103452.1197239-1-aneesh.kumar@kernel.org>
 <20260904103452.1197239-10-aneesh.kumar@kernel.org>
From: Suzuki K Poulose <suzuki.poulose@arm.com>
In-Reply-To: <20260904103452.1197239-10-aneesh.kumar@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 04/09/2026 11:34, Aneesh Kumar K.V (Arm) wrote:
> CCA guests must align shared/private memory transitions to the size
> reported by the host for IPA state changes. This size can be larger than
> PAGE_SIZE, so allowing a guest to convert only a PAGE_SIZE-sized subrange
> can leave the remaining part of that host-sized range in the wrong state.
> 
> Cache the RHI-reported IPA sate change alignment during Realm
> initialization and expose it through a new arm64 mem_encrypt callback. Use
> PAGE_SIZE as the default shared granule size when no backend callback is
> registered.
> 
> Validate both the address and byte size passed to set_memory_encrypted()
> and set_memory_decrypted() against mem_cc_shared_granule_size() before
> calling into the backend. This prevents callers from converting only part
> of a host-managed page.
> 
> Signed-off-by: Aneesh Kumar K.V (Arm) <aneesh.kumar@kernel.org>

Reviewed-by: Suzuki K Poulose <suzuki.poulose@arm.com>


> ---
>   arch/arm64/include/asm/mem_encrypt.h |  4 ++++
>   arch/arm64/mm/mem_encrypt.c          | 32 ++++++++++++++++++++++++----
>   drivers/firmware/arm_rmm/rsi.c       | 13 ++++++++++-
>   3 files changed, 44 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/mem_encrypt.h b/arch/arm64/include/asm/mem_encrypt.h
> index ef8b8463e52b..890faeed0eb3 100644
> --- a/arch/arm64/include/asm/mem_encrypt.h
> +++ b/arch/arm64/include/asm/mem_encrypt.h
> @@ -10,6 +10,7 @@ struct device;
>   struct arm64_mem_crypt_ops {
>   	int (*encrypt)(unsigned long addr, int numpages);
>   	int (*decrypt)(unsigned long addr, int numpages);
> +	size_t (*cc_shared_granule_size)(void);
>   };
>   
>   int arm64_mem_crypt_ops_register(const struct arm64_mem_crypt_ops *ops);
> @@ -18,6 +19,9 @@ int set_memory_encrypted(unsigned long addr, int numpages);
>   int set_memory_decrypted(unsigned long addr, int numpages);
>   int __set_memory_enc_dec(unsigned long addr, int numpages, bool encrypt);
>   
> +#define mem_cc_shared_granule_size mem_cc_shared_granule_size
> +size_t mem_cc_shared_granule_size(void);
> +
>   static inline bool force_dma_unencrypted(struct device *dev)
>   {
>   	return is_realm_world() || is_protected_kvm_guest();
> diff --git a/arch/arm64/mm/mem_encrypt.c b/arch/arm64/mm/mem_encrypt.c
> index ee3c0ab04384..69783c6a3c08 100644
> --- a/arch/arm64/mm/mem_encrypt.c
> +++ b/arch/arm64/mm/mem_encrypt.c
> @@ -17,8 +17,7 @@
>   #include <linux/compiler.h>
>   #include <linux/err.h>
>   #include <linux/mm.h>
> -
> -#include <asm/mem_encrypt.h>
> +#include <linux/mem_encrypt.h>
>   
>   static const struct arm64_mem_crypt_ops *crypt_ops;
>   
> @@ -33,18 +32,43 @@ int arm64_mem_crypt_ops_register(const struct arm64_mem_crypt_ops *ops)
>   
>   int set_memory_encrypted(unsigned long addr, int numpages)
>   {
> -	if (likely(!crypt_ops) || WARN_ON(!PAGE_ALIGNED(addr)))
> +	unsigned long size = (unsigned long)numpages << PAGE_SHIFT;
> +
> +	if (likely(!crypt_ops))
>   		return 0;
>   
> +	if (WARN_ON(!IS_ALIGNED(addr, mem_cc_shared_granule_size())))
> +		return -EINVAL;
> +
> +	if (WARN_ON(!IS_ALIGNED(size, mem_cc_shared_granule_size())))
> +		return -EINVAL;
> +
>   	return crypt_ops->encrypt(addr, numpages);
>   }
>   EXPORT_SYMBOL_GPL(set_memory_encrypted);
>   
>   int set_memory_decrypted(unsigned long addr, int numpages)
>   {
> -	if (likely(!crypt_ops) || WARN_ON(!PAGE_ALIGNED(addr)))
> +	unsigned long size = (unsigned long)numpages << PAGE_SHIFT;
> +
> +	if (likely(!crypt_ops))
>   		return 0;
>   
> +	if (WARN_ON(!IS_ALIGNED(addr, mem_cc_shared_granule_size())))
> +		return -EINVAL;
> +
> +	if (WARN_ON(!IS_ALIGNED(size, mem_cc_shared_granule_size())))
> +		return -EINVAL;
> +
>   	return crypt_ops->decrypt(addr, numpages);
>   }
>   EXPORT_SYMBOL_GPL(set_memory_decrypted);
> +
> +size_t mem_cc_shared_granule_size(void)
> +{
> +	if (likely(!crypt_ops) || !crypt_ops->cc_shared_granule_size)
> +		return PAGE_SIZE;
> +
> +	return crypt_ops->cc_shared_granule_size();
> +}
> +EXPORT_SYMBOL_GPL(mem_cc_shared_granule_size);
> diff --git a/drivers/firmware/arm_rmm/rsi.c b/drivers/firmware/arm_rmm/rsi.c
> index 2cd53f82432f..eeb797c6c2c7 100644
> --- a/drivers/firmware/arm_rmm/rsi.c
> +++ b/drivers/firmware/arm_rmm/rsi.c
> @@ -19,6 +19,7 @@
>   
>   static struct realm_config config;
>   static struct kobject *cca_kobj;
> +static unsigned long ipa_state_change_granule_size;
>   
>   unsigned long prot_ns_shared;
>   EXPORT_SYMBOL(prot_ns_shared);
> @@ -155,9 +156,17 @@ static int realm_set_memory_decrypted(unsigned long addr, int numpages)
>   	return ret;
>   }
>   
> +static size_t realm_cc_shared_granule_size(void)
> +{
> +	if (is_realm_world())
> +		return ipa_state_change_granule_size;
> +	return PAGE_SIZE;
> +}
> +
>   static const struct arm64_mem_crypt_ops realm_crypt_ops = {
>   	.encrypt = realm_set_memory_encrypted,
>   	.decrypt = realm_set_memory_decrypted,
> +	.cc_shared_granule_size = realm_cc_shared_granule_size,
>   };
>   
>   static int realm_register_memory_enc_ops(void)
> @@ -167,7 +176,7 @@ static int realm_register_memory_enc_ops(void)
>   
>   /* we need an aligned struct for rsi_host_call. slab is not yet ready */
>   static struct rsi_host_call hostconf_call __initdata;
> -static unsigned long __maybe_unused __init get_ipa_state_change_alignment(void)
> +static unsigned long __init get_ipa_state_change_alignment(void)
>   {
>   	long ret;
>   	unsigned long shared_granule_size;
> @@ -218,6 +227,8 @@ void __init arm64_rsi_init(void)
>   		return;
>   	if (WARN_ON(rsi_get_realm_config(lm_alias(&config))))
>   		return;
> +
> +	ipa_state_change_granule_size = get_ipa_state_change_alignment();
>   	prot_ns_shared = __phys_to_pte_val(BIT(config.ipa_bits - 1));
>   
>   	if (arm64_ioremap_prot_hook_register(realm_ioremap_hook))

