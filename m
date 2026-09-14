Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BC3B1DED42
	for <kvmarm@lists.linux.dev>; Mon, 14 Sep 2026 05:04:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789362289; cv=none; b=JSXB0nzeqWTTeztG1VZ1ZjBKQYPS0wfsBfxStzKfph8p1k1YShilpzFgPcy6IR5NhSINawfeNMQn+4OlMoS0YXX7OkGGm3OEomF44jDQfgF5SsoeNn74Mk5M0Xg+hRQJz3ve190XTjY19696biPhFjxam9RXCaWCsvXWBFfG2uc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789362289; c=relaxed/simple;
	bh=7Wd8C82/bhAs2CHKbnDTtWdPNEMaHTwzr41dyGKcoqU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Mcbg7Tts1xekwzfRoKx84n6urCZz5Mt4dp2mh7yCQDwMf7H/V0eaKlGDY1KrzL9cicr7zYfIILjQKLT8c4yeyidVoxJQLyvemqj0Z2rcVr5/lTxYtYWsJq5s8uXJECfSwAvSl4ylshoQPdmOh+BgVO10tg+8Q7M7aoPZZwCBgL0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Qk0WXnWp; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Qk0WXnWp"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1789362285;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=AWwEUFlTEYNpvkW4cSP2i+cjuWN9ZXqixSIf7m+ihb4=;
	b=Qk0WXnWpl0h7ZhbTlJ6uuQ4V8LTTWEJRdUNkJt4S/K8w2FdAqgCBGpbsr5rG0ysbMEG/fz
	CI1KaEp0SjyrdiK97+Rm+ueKwegKEFNB0NOL1L4Dx6S1obkNsN11foQpEUh0jHMSZbbor3
	9ss+gsU91K421zwd+TlCTNoQJAxdFEo=
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com
 [209.85.216.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-459-WrygDKMUN0KYWIMRYyzdLA-1; Mon, 14 Sep 2026 01:04:43 -0400
X-MC-Unique: WrygDKMUN0KYWIMRYyzdLA-1
X-Mimecast-MFC-AGG-ID: WrygDKMUN0KYWIMRYyzdLA_1789362283
Received: by mail-pj1-f69.google.com with SMTP id 98e67ed59e1d1-38e8e864ef0so4990266a91.0
        for <kvmarm@lists.linux.dev>; Sun, 13 Sep 2026 22:04:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789362283; x=1789967083;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=AWwEUFlTEYNpvkW4cSP2i+cjuWN9ZXqixSIf7m+ihb4=;
        b=aO8e5gxM7aWNlPQ7jAJJNv/3+/nsH/iTGfbQkAjQaJSTjlqdsxswrSgf83oSz85/OH
         /9H0M7+doRYFCHv+siCXD4V7iobND4dJXMB32iYYKW1czzxYFtb4eqwCl5K6BlhiSxSw
         DmOeDR21WOe9S3alLkuv+CaesSo43NUiaM7qbZ2+pdGImDwVq5uyzfSdl1oIFYmaOR7n
         PqO2jBpcNFpKotV8sjq4SqLz9mkclecJUAJ9izhtCBfZKyAlGrf4r9aI+o3LPCsWbiNw
         n1jzJGmMK7GhJMVaoxXNhuBEwajt4Fgc8vP0aTgujQdKE95zaSHoxKgXfXqOJH42vyEv
         x6Tg==
X-Forwarded-Encrypted: i=1; AKwUvBzzdSagXJ/y20PmYPtsrCKcGruMYnHE83qVP8651YSlbkJLzqXkuV6mt8mGsXqBvFi2HERiNgc=@lists.linux.dev
X-Gm-Message-State: AFuF++l+nuwxmeoE7nutwag8ITVK7AAPOt0xkagNxUJ2dsnlYYEAFNo7
	uyJ4uujthhzes8Ojtqyhle55pUY4GbemB2j9S/5usYi0ZnO4CVzXCi7Q/gS2CUFTbqrKWHesi8s
	ghROLz5cU7ImBWt3ouj26ARNDmYzMeo+TTODTTaf/NJQVChqxltLOirHutg==
X-Gm-Gg: AYBFou0uoOPr3mIMqC9BXAmy8xjbCvrPmLcraccD+8r3oIbazFi5f+eS32OKf8UF/Ez
	lC130myp265ztWYP7yL5ykMiNuB25rGScn0FoqBsoDh+0QP6Ietn5DBJmFNH2+RaKk2o7bsY45c
	Z05RetXqOmaUKdwzPTGhINkXbHtI785PLwBwVLH5mQyy7Abs6TfMy/IV9/c71frz1r41pTxjZ1T
	9eSgJUoA+10FhuCu92dCXrloW9t30nisssYmF6/7DUsSHheXSm4hl8x/b5RQWypwzOm2ElrZScr
	YPlWIT/15r3gVxWyeQcdsVvE5MMKOl2JJNOY6pqYEi5NjDUdIBA7uBZMjFPi2d8J+NidqKKAzBX
	WvZBdP9qXe4SoNBlS6VtFBcfatC+ltC9H3Ey9juWghw==
X-Received: by 2002:a17:90b:4a0f:b0:381:6c5:3f63 with SMTP id 98e67ed59e1d1-39debf7613bmr1872342a91.6.1789362282367;
        Sun, 13 Sep 2026 22:04:42 -0700 (PDT)
X-Received: by 2002:a17:90b:4a0f:b0:381:6c5:3f63 with SMTP id 98e67ed59e1d1-39debf7613bmr1872265a91.6.1789362281693;
        Sun, 13 Sep 2026 22:04:41 -0700 (PDT)
Received: from [192.168.68.52] (n175-34-8-244.mrk21.qld.optusnet.com.au. [175.34.8.244])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-39d950913a6sm18923357a91.6.2026.09.13.22.04.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 13 Sep 2026 22:04:41 -0700 (PDT)
Message-ID: <f00d01d1-8df0-4865-8e52-c85171cf4ca5@redhat.com>
Date: Mon, 14 Sep 2026 15:04:28 +1000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v18 4/7] firmware: arm_rmm: Add support for SRO
To: Suzuki K Poulose <suzuki.poulose@arm.com>, kvm@vger.kernel.org,
 kvmarm@lists.linux.dev
Cc: maz@kernel.org, will@kernel.org, catalin.marinas@arm.com,
 linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 steven.price@arm.com, aneesh.kumar@kernel.org, oupton@kernel.org,
 joey.gouly@arm.com, tabba@google.com, yuzenghui@huawei.com,
 linux-coco@lists.linux.dev, gankulkarni@os.amperecomputing.com,
 sdonthineni@nvidia.com, alpergun@google.com, fj0570is@fujitsu.com,
 WeiLin.Chang@arm.com, lpieralisi@kernel.org, enju.kohei@fujitsu.com
References: <20260912083611.2513845-1-suzuki.poulose@arm.com>
 <20260912083611.2513845-5-suzuki.poulose@arm.com>
From: Gavin Shan <gshan@redhat.com>
In-Reply-To: <20260912083611.2513845-5-suzuki.poulose@arm.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: ej2iLKySRFb5FbN0EGgRixJ4BnvP3mE8NEcMPz0m5d0_1789362283
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/12/26 6:36 PM, Suzuki K Poulose wrote:
> RMM v2.0 introduces the concept of "Stateful RMI Operations" (SRO). This
> means that an SMC can return with an operation still in progress. The
> host is expected to continue the operation until it reaches a conclusion
> (either success or failure). During this process the RMM can request
> additional memory ('donate') or hand memory back to the host
> ('reclaim'). The host can request an in progress operation is cancelled,
> but still continue the operation until it has completed (otherwise the
> incomplete operation may cause future RMM operations to fail).
> 
> The SRO is tracked using a struct rmi_sro_state object which keeps track
> of any memory which has been allocated but not yet consumed by the RMM
> or reclaimed from the RMM. This allows the memory to be reused in a
> future request within the same operation. It will also permit an
> operation to be done in a context where memory allocation may be
> difficult (e.g. atomic context) with the option to abort the operation
> and retry the memory allocation outside of the atomic context. The
> memory stored in the struct rmi_sro_state object can then be reused on
> the subsequent attempt.
> 
> Wrappers for SRO RMI commands are also provided here because they depend
> on the rmi_sro_execute() implementation added by this patch.
> Delegate/undelegate handles are also added here because they now use the
> SRO/stateful command infrastructure and are also used for the memory
> DONATE/RECLAIM flows.
> 
> Signed-off-by: Steven Price <steven.price@arm.com>
> Co-Developed-by: Suzuki K Poulose <suzuki.poulose@arm.com>
> Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
> ---
>   v18:
>    * Prevent overflow for donated_granules output from buggy RMM
>    * Handle corrupted addr_count in the sro
>    * Avoid spilling literal pools on stack with sro initialisation
>    * Handle buggy RMM when the out_top is not changed with RMI_SUCCESS
>      for delegat/undelegate range calls
>    * Rename free_delegated_page => rmi_free_delegated_page
>    * Rename donate_req_to_unit_size => donate_req_to_block_size
>    * Introduce rmi_addr_block_size_to_bytes() helper to convert a RmiAddrBlockSize
>      encoding used in RMI_DONATE_REQ and RMI_ADDR_RANGE Descriptors, replaces
>      donate_req_to_unit_size()
>    * Rename unit_size => block_size_fld, unit_size_bytes => block_size etc.
>    * Explicitly check for MEM_CONTIG/CAN_CANCEL fields to match the RMM spec values.
>    * Rename free_delegated_page => rmi_free_delegated_page()
>    * Drop RMI_BUSY, RMI_BLOCKED checks from rmi_*delegate_range as they are already
>      handled by the rmi_smccc_invoke() used by the SRO.
>    * Add a helper to free an address range entry, which may be partially consumed.
>    * Ensure RMI_OP_RECLAIM output is valid before consumption
>   v17:
>    * Handle buggy RMM firmware to avoid looping forever for non-cancellable SROs.
>    * Add comment (for the AI agents) to clarify that all memory donating SROs are
>      cancellable.
>   v16:
>    * Wrappers for realm guests split into a separate patch.
>    * Better support for cancellation - previously a cancelled operation
>      could be treated as successful.
>    * Consistently use a signed type for wrapper return values so that
>      Linux error codes can be returned as well as RMI return values.
>   v15:
>    * Wrappers for SRO RMI functions are provided in this patch due to
>      their dependency on the SRO infrastructure.
>    * Fold the range delegate/undelegate wrappers into this patch because
>      they depend on the stateful command infrastructure.
>    * Add cpu_relax() calls when RMI_BUSY/RMI_BLOCKED is returned.
>    * Various fixes.
>   v14:
>    * SRO support has improved although is still not fully complete. The
>      infrastructure has been moved out of KVM.
> ---
>   drivers/firmware/arm_rmm/rmi.c | 586 +++++++++++++++++++++++++++++++++
>   include/linux/arm-rmi-cmds.h   |  41 +++
>   2 files changed, 627 insertions(+)
> 
> diff --git a/drivers/firmware/arm_rmm/rmi.c b/drivers/firmware/arm_rmm/rmi.c
> index 5b0e342ce3d58..4f9898ece7547 100644
> --- a/drivers/firmware/arm_rmm/rmi.c
> +++ b/drivers/firmware/arm_rmm/rmi.c
> @@ -15,6 +15,59 @@
>   #define RMI_FEAT_REG_COUNT	2
>   static unsigned long rmi_feat_reg_cache[RMI_FEAT_REG_COUNT] __ro_after_init;
>   
> +/**
> + * rmi_granule_range_delegate() - Delegate granules
> + * @base: PA of the first granule of the range
> + * @top: PA of the first granule after the range
> + * @out_top: PA of the first granule not delegated
> + *
> + * Delegate a range of granule for use by the realm world. If the entire range
> + * was delegated then @out_top == @top, otherwise the function should be called
> + * again with @base == @out_top.
> + *
> + * Return: 0 on success, positive RMI result code or negative Linux error code
> + */
> +static inline long rmi_granule_range_delegate(unsigned long base,
> +					      unsigned long top,
> +					      unsigned long *out_top)
> +{
> +	struct arm_smccc_1_2_regs regs = {
> +		SMC_RMI_GRANULE_RANGE_DELEGATE, base, top
> +	};
> +	long ret = rmi_sro_execute(&regs);
> +
> +	if (ret == RMI_SUCCESS && out_top)
> +		*out_top = regs.a1;
> +
> +	return ret;
> +}
> +
> +/**
> + * rmi_granule_range_undelegate() - Undelegate a range of granules
> + * @base: Base PA of the target range
> + * @top: Top PA of the target range
> + * @out_top: Returns the top PA of range whose state is undelegated
> + *
> + * Undelegate a range of granules to allow use by the normal world. Will fail if
> + * the granules are in use.
> + *
> + * Return: 0 on success, positive RMI result code or negative Linux error code
> + */
> +static inline long rmi_granule_range_undelegate(unsigned long base,
> +						unsigned long top,
> +						unsigned long *out_top)
> +{
> +	struct arm_smccc_1_2_regs regs = {
> +		SMC_RMI_GRANULE_RANGE_UNDELEGATE, base, top
> +	};
> +	long ret = rmi_sro_execute(&regs);
> +
> +	if (ret == RMI_SUCCESS && out_top)
> +		*out_top = regs.a1;
> +
> +	return ret;
> +}
> +

I would drop rmi_granule_range_{delegate, undelegate}() by combining their logics to
their only callers rmi_{delegate, undelegate}_range(). More details are provided for
rmi_{delegate, undelegate}_range() in the below.

>   /**
>    * rmi_features() - Read feature register
>    * @index: Feature register index
> @@ -63,6 +116,539 @@ unsigned long rmi_feat_reg(unsigned long index)
>   }
>   EXPORT_SYMBOL_GPL(rmi_feat_reg);
>   
> +int rmi_undelegate_range(phys_addr_t phys,
> +			 unsigned long size)
> +{
> +	long ret = 0;
> +	unsigned long top = phys + size;
> +	unsigned long out_top;
> +
> +	while (phys < top) {
> +		ret = rmi_granule_range_undelegate(phys, top, &out_top);
> +
> +		if (ret == RMI_SUCCESS) {
> +			/* Buggy RMM ? Let the caller leak the pages */
> +			if (WARN_ON(out_top <= phys))
> +				return -ENXIO;
> +			phys = out_top;
> +		} else {
> +			break;
> +		}
> +	}
> +
> +	return ret;
> +}
> +EXPORT_SYMBOL_GPL(rmi_undelegate_range);
> +

I would move rmi_undelegate_range() after rmi_delegate_range().

> +int rmi_delegate_range(phys_addr_t phys,
> +		       unsigned long size,
> +		       phys_addr_t *out_phys)
> +{
> +	long ret = 0;
> +	unsigned long top = phys + size;
> +	unsigned long out_top;
> +
> +	while (phys < top) {
> +		ret = rmi_granule_range_delegate(phys, top, &out_top);
> +
> +		if (ret == RMI_SUCCESS) {
> +			/* Buggy RMM ? */
> +			if (WARN_ON(out_top <= phys)) {
> +				rmi_undelegate_range(top - size, size);

[top - size, size] is incorrect because we may be delegating a sub-range of the
range of granules. It's actually the caller's responsibility to undelegate the
graunles that have been delegated.

			if (WARN_ON(out_top <= phys)) {
				ret = -ENXIO;
				break;
			}

> +				return -ENXIO;
> +			}
> +			phys = out_top;
> +		} else {
> +			break;
> +		}
> +	}
> +
> +	if (out_phys)
> +		*out_phys = phys;
> +
> +	return ret;
> +}
> +EXPORT_SYMBOL_GPL(rmi_delegate_range);
> +

As suggested above, I would drop rmi_granule_range_{delegate, undelegate}() by combining
their logics to their only callers rmi_{delegate, undelegate}_range().

/**
  * rmi_delegate_range - Delegate a range of granules
  * @phys: PA of the granule range
  * @size: Size of the granule range
  * @out_phys: PA of the first undelegated granule
  *
  * Delegate a range of granules for use by the realm world. If the entire range
  * is delegated, then @out_phys == (@phys + @size). Otherwise, @out_phys points
  * to the first undelegated granule.
  */
int rmi_delegate_range(phys_addr_t phys,
                        unsigned long size,
                        phys_addr_t *out_phys)
{
         unsigned long start = phys;
         unsigned long end = start + size;
         struct arm_smccc_1_2_regs args;
         long ret = 0;

         while (start < end) {
                 args.a0 = SMC_RMI_GRANULE_RANGE_DELEGATE;
                 args.a1 = start;
                 args.a2 = end;
                 ret = rmi_sro_execute(&args);
                 if (ret != RMI_SUCCESS)
                         break;

                 /* Buggy RMM ? */
                 if (WARN_ON(args.a1 <= start)) {
                         ret = -ENXIO;
                         break;
                 }

                 start = args.a1;
         }

         if (out_phys)
                 *out_phys = start;

         return ret;
}
EXPORT_SYMBOL_GPL(rmi_delegate_range);

/**
  * rmi_undelegate_range - Undelegate a range of granules
  * @phys: PA of the granule range
  * @size: Size of the granule range
  *
  * Undelegate a range of granules for use by the normal world.
  *
  * Return: 0 on success, positive RMI result code or negative Linux error code
  */
int rmi_undelegate_range(phys_addr_t phys,
                          unsigned long size)
{
         unsigned long start = phys;
         unsigned long end = start + size;
         struct arm_smccc_1_2_regs args;
         long ret = 0;

         while (start < end) {
                 args.a0 = SMC_RMI_GRANULE_RANGE_UNDELEGATE;
                 args.a1 = start;
                 args.a2 = end;
                 ret = rmi_sro_execute(&args);
                 if (ret != RMI_SUCCESS)
                         break;

                 /* Buggy RMM ? Let the caller leak the pages */
                 if (WARN_ON(args.a1 <= phys)) {
                         ret = -ENXIO;
                         break;
                 }

                 start = args.a1;
         }

         return ret;
}
EXPORT_SYMBOL_GPL(rmi_undelegate_range);

> +/*
> + * Convert the RmiAddrBlockSize to actual size. This is used in RmiDonateReq
> + * and RmiAddrRangeDesc*.
> + */
> +static unsigned long rmi_addr_block_size_to_bytes(unsigned long block_size_fld)
> +{
> +	return BIT(ARM64_HW_PGTABLE_LEVEL_SHIFT(3 - block_size_fld));
> +}
> +
> +/*
> + * free_addr_range: Free memory described by the address range entry, which may
> + *		    be partially consumed by RMM.
> + *
> + * @entry: RMI_ADDR_RANGE descriptor
> + * @consumed_size: Page aligned size consumed by the RMM from the address range.
> + *
> + * If the state of the address is DELEGATED, undelegate it back, before freeing.
> + * Leaks the memory if we cannot undelegate the range.
> + */
> +static void free_addr_range(unsigned long entry, unsigned long consumed_size)
> +{
> +	unsigned long phys = RMI_ADDR_RANGE_ADDR(entry);
> +	unsigned long block_size_fld = RMI_ADDR_RANGE_BLOCK_SIZE(entry);
> +	unsigned long count = RMI_ADDR_RANGE_COUNT(entry);
> +	unsigned long state = RMI_ADDR_RANGE_STATE(entry);
> +	unsigned long size = rmi_addr_block_size_to_bytes(block_size_fld) * count;
> +
> +	WARN_ON(!PAGE_ALIGNED(phys) || !PAGE_ALIGNED(consumed_size));
> +
> +	/* Adjust the address and size for partially consumed entry */
> +	phys += consumed_size;
> +	size -= consumed_size;
> +	/*
> +	 * Undelegate the pages back if required. If we can't
> +	 * change them back, leak the pages.
> +	 */
> +	if (state == RMI_OP_MEM_DELEGATED &&
> +	    WARN_ON(rmi_undelegate_range(phys, size)))
> +		return;
> +	free_pages_exact(phys_to_virt(phys), size);
> +}
> +
> +static void rmi_op_continue(unsigned long sro_handle, unsigned long flags,
> +			    struct arm_smccc_1_2_regs *out_regs)
> +{
> +	*out_regs = (struct arm_smccc_1_2_regs) {
> +		SMC_RMI_OP_CONTINUE, sro_handle, flags
> +	};
> +
> +	rmi_smccc_invoke(out_regs);
> +}
> +

The pattern 'regs' is used in some of the 'struct arm_smccc_1_2_regs' arguments
or variables in this series, which is incosistent to the existing patterns which
is either 'args' or 'res' by searching the source files using 'git grep arm_smccc_1_2_regs'.
So I would suggest we have the fixed the pattern 'args' :-)

> +static void rmi_op_cancel(unsigned long sro_handle,
> +			  struct arm_smccc_1_2_regs *out_regs)
> +{
> +	*out_regs = (struct arm_smccc_1_2_regs) {
> +		SMC_RMI_OP_CANCEL, sro_handle
> +	};
> +
> +	rmi_smccc_invoke(out_regs);
> +}
> +
> +static void rmi_op_mem_donate(unsigned long sro_handle, unsigned long list_addr,
> +			      unsigned long list_count, unsigned long flags,
> +			      struct arm_smccc_1_2_regs *out_regs)
> +{
> +	*out_regs = (struct arm_smccc_1_2_regs) {
> +		SMC_RMI_OP_MEM_DONATE, sro_handle, list_addr, list_count, flags
> +	};
> +
> +	/*
> +	 * The output donated count (a1) is always valid, irrespective
> +	 * of the return result. i.e., 0 if there was an error
> +	 */
> +	rmi_smccc_invoke(out_regs);
> +}
> +
> +static void rmi_op_mem_reclaim(unsigned long sro_handle,
> +			       unsigned long list_addr,
> +			       unsigned long list_count,
> +			       struct arm_smccc_1_2_regs *out_regs)
> +{
> +	*out_regs = (struct arm_smccc_1_2_regs) {
> +		SMC_RMI_OP_MEM_RECLAIM, sro_handle, list_addr, list_count
> +	};
> +
> +	rmi_smccc_invoke(out_regs);
> +}
> +
> +int rmi_free_delegated_page(phys_addr_t phys)
> +{
> +	if (WARN_ON_ONCE(rmi_undelegate_page(phys))) {
> +		/* Undelegate failed: leak the page */
> +		return -EBUSY;
> +	}
> +
> +	free_page((unsigned long)phys_to_virt(phys));
> +
> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(rmi_free_delegated_page);
> +

I would move rmi_free_delegated_page() right after rmi_undelegate_range().

> +static int rmi_sro_ensure_capacity(struct rmi_sro_state *sro,
> +				   unsigned long count)
> +{
> +	if (WARN_ON_ONCE(sro->addr_count > RMI_MAX_ADDR_LIST))
> +		return -EOVERFLOW;
> +
> +	if (count > RMI_MAX_ADDR_LIST - sro->addr_count)
> +		return -ENOSPC;
> +
> +	return 0;
> +}
> +
> +static int rmi_sro_donate_contig(struct rmi_sro_state *sro,
> +				 unsigned long sro_handle,
> +				 unsigned long donatereq,
> +				 struct arm_smccc_1_2_regs *out_regs,
> +				 gfp_t gfp)
> +{
> +	unsigned long block_size_fld = RMI_DONATE_BLOCK_SIZE(donatereq);
> +	unsigned long block_size = rmi_addr_block_size_to_bytes(block_size_fld);
> +	unsigned long count = RMI_DONATE_COUNT(donatereq);
> +	unsigned long state = RMI_DONATE_STATE(donatereq);
> +	unsigned long size = block_size * count;
> +	unsigned long addr_range;
> +	unsigned long donated_granules;
> +	unsigned long donated_size;
> +	int ret;
> +	void *virt;
> +	phys_addr_t phys;
> +
> +	/*
> +	 * The RMM specification requires contiguous allocations are always a
> +	 * power of 2
> +	 */
> +	if (WARN_ON_ONCE(!is_power_of_2(size)))
> +		return -EINVAL;
> +
> +	/* Reuse the cached address range if we have one */
> +	for (int i = 0; i < sro->addr_count; i++) {
> +		unsigned long entry = sro->addr_list[i];
> +
> +		if (RMI_ADDR_RANGE_BLOCK_SIZE(entry) == block_size_fld &&
> +		    RMI_ADDR_RANGE_COUNT(entry) == count &&
> +		    RMI_ADDR_RANGE_STATE(entry) == state &&
> +		    IS_ALIGNED(RMI_ADDR_RANGE_ADDR(entry), size)) {
> +			sro->addr_count--;
> +			swap(sro->addr_list[sro->addr_count],
> +			     sro->addr_list[i]);
> +
> +			goto out;
> +		}
> +	}
> +
> +	ret = rmi_sro_ensure_capacity(sro, 1);
> +	if (ret)
> +		return ret;
> +
> +	virt = alloc_pages_exact(size, gfp);
> +	if (!virt)
> +		return -ENOMEM;
> +	phys = virt_to_phys(virt);
> +
> +	if (state == RMI_OP_MEM_DELEGATED) {
> +		phys_addr_t delegated_phys;
> +
> +		if (rmi_delegate_range(phys, size, &delegated_phys)) {
> +			if (!rmi_undelegate_range(phys, delegated_phys - phys))
> +				free_pages_exact(virt, size);
> +			return -ENXIO;
> +		}
> +	}
> +
> +	addr_range = phys & RMI_ADDR_RANGE_ADDR_MASK;
> +	FIELD_MODIFY(RMI_ADDR_RANGE_BLOCK_SIZE_MASK, &addr_range, block_size_fld);
> +	FIELD_MODIFY(RMI_ADDR_RANGE_COUNT_MASK, &addr_range, count);
> +	FIELD_MODIFY(RMI_ADDR_RANGE_STATE_MASK, &addr_range, state);
> +
> +	sro->addr_list[sro->addr_count] = addr_range;
> +
> +out:
> +	rmi_op_mem_donate(sro_handle,
> +			  virt_to_phys(&sro->addr_list[sro->addr_count]), 1,
> +			  0, out_regs);
> +	donated_granules = out_regs->a1;
> +
> +	if (WARN_ON(donated_granules > (size >> PAGE_SHIFT)))
> +		donated_granules = (size >> PAGE_SHIFT);
> +
> +	donated_size = donated_granules << PAGE_SHIFT;
> +
> +	/* All granules consumed by the RMM */
> +	if (donated_size == size)
> +		return 0;
> +	/* No granules were consumed by the RMM, cache them */
> +	if (donated_granules == 0) {
> +		sro->addr_count++;
> +		return 0;
> +	}
> +
> +	/* The granules were partially consumed, reclaim the unused ones. */
> +	free_addr_range(sro->addr_list[sro->addr_count], donated_size);
> +
> +	return 0;
> +}
> +
> +static int rmi_sro_donate_noncontig(struct rmi_sro_state *sro,
> +				    unsigned long sro_handle,
> +				    unsigned long donatereq,
> +				    struct arm_smccc_1_2_regs *out_regs,
> +				    gfp_t gfp)
> +{
> +	unsigned long block_size_fld = RMI_DONATE_BLOCK_SIZE(donatereq);
> +	unsigned long block_size = rmi_addr_block_size_to_bytes(block_size_fld);
> +	unsigned long count = RMI_DONATE_COUNT(donatereq);
> +	unsigned long state = RMI_DONATE_STATE(donatereq);
> +	unsigned long found = 0;
> +	unsigned long donated_granules;
> +	unsigned long granules_per_block = block_size >> PAGE_SHIFT;
> +	unsigned long consumed_blocks;
> +	int addr_list_start = sro->addr_count;
> +
         ^^^^^^

Unecessary blank line.

> +	int ret;
> +
> +	for (int i = 0; i < addr_list_start && found < count; i++) {
> +		unsigned long entry = sro->addr_list[i];
> +
> +		if (RMI_ADDR_RANGE_BLOCK_SIZE(entry) == block_size_fld &&
> +		    RMI_ADDR_RANGE_COUNT(entry) == 1 &&
> +		    RMI_ADDR_RANGE_STATE(entry) == state) {
> +			addr_list_start--;
> +			swap(sro->addr_list[addr_list_start],
> +			     sro->addr_list[i]);
> +			found++;
> +			i--;
> +		}
> +	}
> +
> +	ret = rmi_sro_ensure_capacity(sro, count - found);
> +	if (ret)
> +		return ret;
> +
> +	while (found < count) {
> +		unsigned long addr_range;
> +		void *virt = alloc_pages_exact(block_size, gfp);
> +		phys_addr_t phys;
> +
> +		if (!virt)
> +			return -ENOMEM;
> +
> +		phys = virt_to_phys(virt);
> +
> +		if (state == RMI_OP_MEM_DELEGATED) {
> +			phys_addr_t delegated_phys;
> +
> +			if (rmi_delegate_range(phys, block_size,
> +					       &delegated_phys)) {
> +				if (!rmi_undelegate_range(phys, delegated_phys - phys))
> +					free_pages_exact(virt, block_size);
> +				return -ENXIO;
> +			}
> +		}
> +
> +		addr_range = phys & RMI_ADDR_RANGE_ADDR_MASK;
> +		FIELD_MODIFY(RMI_ADDR_RANGE_BLOCK_SIZE_MASK, &addr_range, block_size_fld);
> +		FIELD_MODIFY(RMI_ADDR_RANGE_COUNT_MASK, &addr_range, 1);
> +		FIELD_MODIFY(RMI_ADDR_RANGE_STATE_MASK, &addr_range, state);
> +
> +		sro->addr_list[sro->addr_count++] = addr_range;
> +		found++;
> +	}
> +
> +	rmi_op_mem_donate(sro_handle,
> +			  virt_to_phys(&sro->addr_list[addr_list_start]),
> +			  count, 0, out_regs);
> +
> +	donated_granules = out_regs->a1;
> +	/*
> +	 * The RMM shouldn't report more granules than we provided, but clamp
> +	 * just in case.
> +	 */
> +	if (WARN_ON_ONCE(donated_granules > found * granules_per_block))
> +		donated_granules = count * granules_per_block;
> +
> +	/*
> +	 * The RMM reports the consumed memory in terms of granules, but we
> +	 * track in the address lists in block-sized ranges. So divide to get
> +	 * the number of (complete) consumed blocks.
> +	 */
> +	consumed_blocks = donated_granules / granules_per_block;
> +	if (donated_granules % granules_per_block) {
> +		/*
> +		 * A block has been partially consumed, the start is owned by
> +		 * the RMM, the tail is owned by the host
> +		 */
> +		unsigned long entry =
> +			sro->addr_list[addr_list_start + consumed_blocks];
> +		unsigned long donated_size =
> +			(donated_granules % granules_per_block) << PAGE_SHIFT;
> +
> +		free_addr_range(entry, donated_size);
> +		/*
> +		 * This block is now fully 'consumed' (either held by the RMM or
> +		 * freed)
> +		 */
> +		consumed_blocks++;
> +	}
> +
> +	/* Keep just the blocks the RMM didn't use in addr_list */
> +	for (int i = consumed_blocks; i < count; i++)
> +		sro->addr_list[addr_list_start + i - consumed_blocks] =
> +			sro->addr_list[addr_list_start + i];
> +
> +	sro->addr_count -= consumed_blocks;
> +
> +	return 0;
> +}
> +
> +static int rmi_sro_donate(struct rmi_sro_state *sro,
> +			  unsigned long sro_handle,
> +			  unsigned long donatereq,
> +			  struct arm_smccc_1_2_regs *regs,
> +			  gfp_t gfp)
> +{
> +	if (WARN_ON_ONCE(!RMI_DONATE_COUNT(donatereq)))
> +		return -EINVAL;
> +
> +	if (RMI_DONATE_CONTIG(donatereq) == RMI_OP_MEM_CONTIG) {
> +		return rmi_sro_donate_contig(sro, sro_handle, donatereq,
> +					     regs, gfp);
> +	} else {
> +		return rmi_sro_donate_noncontig(sro, sro_handle, donatereq,
> +						regs, gfp);
> +	}
> +}
> +
> +static int rmi_sro_reclaim(struct rmi_sro_state *sro,
> +			   unsigned long sro_handle,
> +			   struct arm_smccc_1_2_regs *out_regs)
> +{
> +	unsigned long capacity;
> +
> +	if (rmi_sro_ensure_capacity(sro, 1))
> +		rmi_sro_free(sro);
> +
> +	capacity = RMI_MAX_ADDR_LIST - sro->addr_count;
> +
> +	rmi_op_mem_reclaim(sro_handle,
> +			   virt_to_phys(&sro->addr_list[sro->addr_count]),
> +			   capacity, out_regs);
> +
> +	/*
> +	  * RMI_OP_MEM_RECLAIM always return RMI_INCOMPLETE, except when the
> +	  * input parameters were invalid.
> +	  */
> +	if (WARN_ON_ONCE(RMI_RETURN_STATUS(out_regs->a0) != RMI_INCOMPLETE))
> +		return -EINVAL;
> +	if (WARN_ON_ONCE(out_regs->a1 > capacity))
> +		out_regs->a1 = capacity;
> +
> +	sro->addr_count += out_regs->a1;
> +
> +	return 0;
> +}
> +
> +void rmi_sro_free(struct rmi_sro_state *sro)
> +{
> +	/* Handle the worse */
> +	if (WARN_ON(sro->addr_count < 0))
> +		return;
> +
> +	if (WARN_ON(sro->addr_count > RMI_MAX_ADDR_LIST))
> +		sro->addr_count = RMI_MAX_ADDR_LIST;
> +
> +	for (int i = 0; i < sro->addr_count; i++)
> +		free_addr_range(sro->addr_list[i], 0);
> +
> +	sro->addr_count = 0;
> +}
> +EXPORT_SYMBOL_GPL(rmi_sro_free);
> +
> +long rmi_sro_memxfer_execute(struct rmi_sro_state *sro, gfp_t gfp)
> +{
> +	struct arm_smccc_1_2_regs *regs = &sro->regs;
> +	bool cancelled = false;
> +	unsigned long sro_handle;
> +
> +	rmi_smccc_invoke(regs);
> +
> +	sro_handle = regs->a1;
> +	while (RMI_RETURN_STATUS(regs->a0) == RMI_INCOMPLETE) {
> +		bool can_cancel = RMI_RETURN_CAN_CANCEL(regs->a0) == RMI_OP_CAN_CANCEL;
> +		int ret = 0;
> +
> +		switch (RMI_RETURN_MEMREQ(regs->a0)) {
> +		case RMI_OP_MEM_REQ_NONE:
> +			rmi_op_continue(sro_handle, RMI_CONTINUE_KEEP_GOING,
> +					regs);
> +			break;
> +		case RMI_OP_MEM_REQ_DONATE:
> +			ret = rmi_sro_donate(sro, sro_handle, regs->a2, regs,
> +					     gfp);
> +			break;
> +		case RMI_OP_MEM_REQ_RECLAIM:
> +			ret = rmi_sro_reclaim(sro, sro_handle, regs);
> +			break;
> +		default:
> +			ret = WARN_ON_ONCE(1);
> +			break;

"ret = WARN_ON_ONCE(1)" is same to "ret = true". I guess we would return
-EINVAL here.

			WARN_ON_ONCE(1);
			ret = -EINVAL;
			break;

> +		}
> +
> +		if (ret) {
> +			/*
> +			 * All memory donating SROs must be cancellable. So a
> +			 * failure in memory allocation shouldn't be an issue.
> +			 * However, if we encounter a random failure (e.g.,
> +			 * buggy RMM), don't loop forever, just give up.
> +			 */
> +			if (WARN_ON_ONCE(!can_cancel))
> +				return ret;
> +			/*
> +			 * If we have already cancelled, and came back here due
> +			 * to an error in MEMREQ, then there is no point
> +			 * in going in loops.
> +			 */
> +			if (WARN_ON_ONCE(cancelled))
> +				break;
> +			rmi_op_cancel(sro_handle, regs);
> +			cancelled = true;
> +
> +			if (WARN_ON_ONCE(RMI_RETURN_STATUS(regs->a0) != RMI_INCOMPLETE))
> +				return ret;
> +		}
> +	}
> +
> +	if (cancelled)
> +		return -ECANCELED;
> +
> +	return regs->a0;
> +}
> +EXPORT_SYMBOL_GPL(rmi_sro_memxfer_execute);
> +
> +/* For RMI commands that are stateful but not memory-transferring */
> +long rmi_sro_execute(struct arm_smccc_1_2_regs *regs)
> +{
> +	bool cancelled = false;
> +	unsigned long sro_handle = regs->a1;
> +
> +	rmi_smccc_invoke(regs);
> +
> +	sro_handle = regs->a1;
> +	while (RMI_RETURN_STATUS(regs->a0) == RMI_INCOMPLETE) {
> +		bool can_cancel = RMI_RETURN_CAN_CANCEL(regs->a0) == RMI_OP_CAN_CANCEL;
> +
> +		switch (RMI_RETURN_MEMREQ(regs->a0)) {
> +		case RMI_OP_MEM_REQ_NONE:
> +			rmi_op_continue(sro_handle, RMI_CONTINUE_KEEP_GOING,
> +					regs);
> +			break;
> +		default:
> +			WARN_ON_ONCE(1);
> +			if (!can_cancel)
> +				return regs->a0;
> +			/* If we have already cancelled, don't retry this */
> +			if (cancelled)
> +				return -ECANCELED;
> +			rmi_op_cancel(sro_handle, regs);
> +			cancelled = true;
> +		}
> +	}
> +
> +	if (cancelled)
> +		return -ECANCELED;
> +
> +	return regs->a0;
> +}
> +EXPORT_SYMBOL_GPL(rmi_sro_execute);
> +
>   static int rmi_check_version(void)
>   {
>   	unsigned short version_major, version_minor;
> diff --git a/include/linux/arm-rmi-cmds.h b/include/linux/arm-rmi-cmds.h
> index 9792bf0e00cb9..cd6e309ddf2d8 100644
> --- a/include/linux/arm-rmi-cmds.h
> +++ b/include/linux/arm-rmi-cmds.h
> @@ -8,10 +8,20 @@
>   
>   #include <linux/arm-smccc-rmi.h>
>   #include <linux/bug.h>
> +#include <linux/gfp.h>
>   #include <linux/processor.h>
> +#include <linux/string.h>
>   #include <linux/types.h>
>   
>   
> +#define RMI_MAX_ADDR_LIST	256
> +
> +struct rmi_sro_state {
> +	struct arm_smccc_1_2_regs regs;
> +	int addr_count;
> +	unsigned long addr_list[RMI_MAX_ADDR_LIST];
> +};
> +
>   /*
>    * rmi_smccc_invoke: Invoke the RMI call and return the results in @regs_out
>    * @regs_in: Registers with the arguments filled in.
> @@ -33,4 +43,35 @@ static inline void rmi_smccc_invoke(struct arm_smccc_1_2_regs *regs)
>   
>   unsigned long rmi_feat_reg(unsigned long index);
>   
> +int rmi_delegate_range(phys_addr_t phys, unsigned long size,
> +		       phys_addr_t *out_phys);
> +int rmi_undelegate_range(phys_addr_t phys, unsigned long size);
> +int rmi_free_delegated_page(phys_addr_t phys);
> +
> +static inline int rmi_delegate_page(phys_addr_t phys)
> +{
> +	return rmi_delegate_range(phys, PAGE_SIZE, NULL);
> +}
> +
> +static inline int rmi_undelegate_page(phys_addr_t phys)
> +{
> +	return rmi_undelegate_range(phys, PAGE_SIZE);
> +}
> +
> +long rmi_sro_memxfer_execute(struct rmi_sro_state *sro, gfp_t gfp);
> +void rmi_sro_free(struct rmi_sro_state *sro);
> +long rmi_sro_execute(struct arm_smccc_1_2_regs *regs);
> +
> +/*
> + * Resetting the addr_count is sufficient to ignore the addr_list contents.
> + */
> +#define rmi_sro_memxfer_cmd(sro, gfp, ...) ({				\
> +	struct rmi_sro_state *__sro = (sro);				\
> +	__sro->addr_count = 0;						\
> +	__sro->regs = (struct arm_smccc_1_2_regs){ __VA_ARGS__ };	\
> +	long __ret = rmi_sro_memxfer_execute(__sro, gfp);		\
> +	rmi_sro_free(__sro);						\
> +	__ret;								\
> +})
> +
>   #endif

Thanks,
Gavin

