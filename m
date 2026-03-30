Received: from mail-pf1-f175.google.com (mail-pf1-f175.google.com [209.85.210.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7452C39BFF1
	for <kvmarm@lists.linux.dev>; Mon, 30 Mar 2026 20:58:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774904319; cv=none; b=sFwXgpg2F80//Gb0fQwHw4DVD/2iyH0bgnAUGetD+7I8rAQv6C4/YDfkJv9Iu4Mw0rQvDuWGQVZ0nBHlIGuJLQFs1j+aBYKDOdpiFaxX5afz0owkUF+4Byy900drFGVJfjiOEhW21p2FckAPhkVx+MI4ZJIKbkicfl6MEzZCQP8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774904319; c=relaxed/simple;
	bh=CRmFwhZ9DgLfZWDSog6+tG2wzgNWOv5/Op/t2/OxVlY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qsycB56bxURakVZTw13mfU0tA2D3ewoE76EJS7cjck8VnfIuYaoIM+DcxoVUNO9iBS+I7LJaD8AC21nKs8uiGJ0sf0wqib/zlJ3SgNDv/Li1/wiKCtxJAprVyZpDcTzvA/0PeFIseJ0iVdtsJjerWaQVtwIhjcOAxX7xM23zdUU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=SGu9akNB; arc=none smtp.client-ip=209.85.210.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="SGu9akNB"
Received: by mail-pf1-f175.google.com with SMTP id d2e1a72fcca58-82cd6614a90so142855b3a.3
        for <kvmarm@lists.linux.dev>; Mon, 30 Mar 2026 13:58:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1774904317; x=1775509117; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=frztTOmTf3SkuLYaPWUosPvcRTJGFbSFXLD1W9fYAwY=;
        b=SGu9akNBAM+VsU4blXHQ1AtsY0qB9M9ZKHufZTaoNE8Ml0U6mDFvYkzH5CyMjZSHLX
         gdXSzaLg7n53jAa6o1/BpRSJcSc4FRBrhvtmHFbw8dyERPMRPzuu/KRhhiFElT9M1WOK
         v0jCGxsztRvlLjHVDYoQOy5z86eA1SnoQejQG8UdCvdlRt+3lQu4KRENjvUcINWDpw+H
         uu/lm4H7VGEKd2U7WZdRh/LrXLSVxLoiG10nCmFUm6p8+kWzBwZ/VoTUXiaTUWEQ89va
         lH++N7A6RfDIAtkIe7yMrncPEOr8o707aF6tibtwROZfqKR/ygDY4Bt2Nev6ETko5cKv
         lTgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774904317; x=1775509117;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=frztTOmTf3SkuLYaPWUosPvcRTJGFbSFXLD1W9fYAwY=;
        b=OxUj2gplST/W+VIEM5i3ctA0Cfu6UJ8uv3hD6oJzyA3M8tJ3W8Jg/WsqIQ5ILEDWO0
         hUTPYhlTud2+qqS516oEGPacDEx/RC4bzoSVPb8fcuuDUs9pNflIdSpTzwVEYkzRenH3
         Dvuk3zdhnxMUWLpSvo1aNrkkbldIKhhUeicxfUFJNOouaAPAnVaSf8DXlsm9QvhWC+BB
         Cr+RIDGgvwk2cM4/izDpVCsMregPs/rKe8rc8vi4TKYciJgjyQvnFGslMbmS8wlXsk2E
         lXDLIPa4tpIAw+HCJZ4Og9E/BmU/1lv95Q5uTzskejyZQ/UhWSsYPqpMWMg2fvU1OydM
         SB7Q==
X-Forwarded-Encrypted: i=1; AJvYcCXj98aIIFDCYj8bDxmmQF1VZ5wtCs/MHPxgvwhKQSfsfVLAN2p5PAhdvTY0rrdqeZRTUwFle9Y=@lists.linux.dev
X-Gm-Message-State: AOJu0YyzLipP4m7qaE5JBGiBRwZbLEwrlidGCBm2sC+Ka7M/FLI7tBB+
	ujuWDEcS3dbM/JFDcIoORixnWpq/fKffdQZIoc9b/GekK+T/TuHhfHeFQWM5qaUr+q8=
X-Gm-Gg: ATEYQzwj0uk1l0sOUbh4vmS+pPXCtRn4HlZ/uZiVeca2t3kvolvPl+0LLEpOuEiPG31
	+6GG3y0G9sZKjEgEyt61fxUDitkueQGEQhR7B6HuZx6mAI/kltKj9SAp3Bh7aTciRhY50C1vIhS
	dCNTc/1nzc8SoDKojWqdfNiEfjVL2GtEOEN5/1QtVfuIE6mg12qgI0edh+mNEkDPi8bjmC8Fpd3
	chnf1QJWXuo+jXcqyQvakP1B2jxVtTOZVv7jmp3ZQ/GXufhiFl5FMsTCbt9+/ZK/iPn5Rnqg+yy
	EaATDjg4aOaZl39iSJTq2wAcx7dblPFfLVEacaNjhKSAFXSMXw0hGjUBTMQy/Z7GGqJuSxpYc9O
	DmWMeUN5W30qbms4bJgT8OYgKiFJvF0vBLPaCfx18t/dKyrMR0gxrbHygzm6mrOLO8HI89zN9xn
	4OOLn1x3DPJ2aWT2T7eCv8wtPOLrQ=
X-Received: by 2002:a05:6a00:ad88:b0:82a:6d9d:3f84 with SMTP id d2e1a72fcca58-82c96002905mr13353400b3a.33.1774904316640;
        Mon, 30 Mar 2026 13:58:36 -0700 (PDT)
Received: from p14s ([2604:3d09:148c:c800:e8c9:5e1e:f42a:2b73])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-82ca85fc6c8sm7426575b3a.45.2026.03.30.13.58.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Mar 2026 13:58:36 -0700 (PDT)
Date: Mon, 30 Mar 2026 14:58:33 -0600
From: Mathieu Poirier <mathieu.poirier@linaro.org>
To: Steven Price <steven.price@arm.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev,
	Catalin Marinas <catalin.marinas@arm.com>,
	Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>,
	James Morse <james.morse@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	Joey Gouly <joey.gouly@arm.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Christoffer Dall <christoffer.dall@arm.com>,
	Fuad Tabba <tabba@google.com>, linux-coco@lists.linux.dev,
	Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
	Gavin Shan <gshan@redhat.com>,
	Shanker Donthineni <sdonthineni@nvidia.com>,
	Alper Gun <alpergun@google.com>,
	"Aneesh Kumar K . V" <aneesh.kumar@kernel.org>,
	Emi Kisanuki <fj0570is@fujitsu.com>,
	Vishal Annapurve <vannapurve@google.com>
Subject: Re: [PATCH v13 10/48] arm64: RMI: Ensure that the RMM has GPT
 entries for memory
Message-ID: <acrj-cKphy4hJsEG@p14s>
References: <20260318155413.793430-1-steven.price@arm.com>
 <20260318155413.793430-11-steven.price@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260318155413.793430-11-steven.price@arm.com>

Hi,

On Wed, Mar 18, 2026 at 03:53:34PM +0000, Steven Price wrote:
> The RMM may not be tracking all the memory of the system at boot. Create
> the necessary tracking state and GPTs within the RMM so that all boot
> memory can be delegated to the RMM as needed during runtime.
> 
> Note: support is currently missing for SROs which means that if the RMM
> needs memory donating this will fail (and render CCA unusable in Linux).
> 
> Signed-off-by: Steven Price <steven.price@arm.com>
> ---
> New patch for v13
> ---
>  arch/arm64/kvm/rmi.c | 89 ++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 89 insertions(+)
> 
> diff --git a/arch/arm64/kvm/rmi.c b/arch/arm64/kvm/rmi.c
> index 9590dff9a2c1..80aedc85e94a 100644
> --- a/arch/arm64/kvm/rmi.c
> +++ b/arch/arm64/kvm/rmi.c
> @@ -4,6 +4,7 @@
>   */
>  
>  #include <linux/kvm_host.h>
> +#include <linux/memblock.h>
>  
>  #include <asm/kvm_pgtable.h>
>  #include <asm/rmi_cmds.h>
> @@ -56,6 +57,18 @@ static int rmi_check_version(void)
>  	return 0;
>  }
>  
> +/*
> + * These are the 'default' sizes when passing 0 as the tracking_region_size.
> + * TODO: Support other granule sizes
> + */
> +#ifdef CONFIG_PAGE_SIZE_4KB
> +#define RMM_GRANULE_TRACKING_SIZE	SZ_1G
> +#elif defined(CONFIG_PAGE_SIZE_16KB)
> +#define RMM_GRANULE_TRACKING_SIZE	SZ_32M
> +#elif defined(CONFIG_PAGE_SIZE_64KB)
> +#define RMM_GRANULE_TRACKING_SIZE	SZ_512M
> +#endif
> +
>  static int rmi_configure(void)
>  {
>  	struct rmm_config *config __free(free_page) = NULL;
> @@ -95,6 +108,80 @@ static int rmi_configure(void)
>  	return 0;
>  }
>  
> +static int rmi_verify_memory_tracking(phys_addr_t start, phys_addr_t end)
> +{
> +	start = ALIGN_DOWN(start, RMM_GRANULE_TRACKING_SIZE);

This will produce an error on systems where the start of system memory is not
aligned to RMM_GRANULE_TRACKING_SIZE.  For instance, on QEMU-SBSA the system
memory starts at 0x100_4300_0000.  With the above and RMM_GRANULE_TRACKING_SIZE
set to SZ_1G, @start becomes 0x100_4000_0000, which falls outside the memory map
known to the TF-A.  I fixed it with these modifications:

LINUX:

diff --git a/arch/arm64/kvm/rmi.c b/arch/arm64/kvm/rmi.c
index 10ff1c3bddaf..21bfbbe2f047 100644
--- a/arch/arm64/kvm/rmi.c
+++ b/arch/arm64/kvm/rmi.c
@@ -424,7 +424,9 @@ static int rmi_configure(void)
 
 static int rmi_verify_memory_tracking(phys_addr_t start, phys_addr_t end)
 {
-       start = ALIGN_DOWN(start, RMM_GRANULE_TRACKING_SIZE);
+       phys_addr_t offset;
+
+       offset = start - ALIGN_DOWN(start, RMM_GRANULE_TRACKING_SIZE);
        end = ALIGN(end, RMM_GRANULE_TRACKING_SIZE);
 
        while (start < end) {
@@ -439,7 +441,13 @@ static int rmi_verify_memory_tracking(phys_addr_t start, phys_addr_t end)
                                start);
                        return -ENODEV;
                }
-               start += RMM_GRANULE_TRACKING_SIZE;
+
+               if (offset) {
+                       start += (RMM_GRANULE_TRACKING_SIZE - offset);
+                       offset = 0;
+               } else {
+                       start += RMM_GRANULE_TRACKING_SIZE;
+               }
        }
 
        return 0;

RMM:

diff --git a/runtime/rmi/granule.c b/runtime/rmi/granule.c
index cef521fc0869..60358d9ee81e 100644
--- a/runtime/rmi/granule.c
+++ b/runtime/rmi/granule.c
@@ -209,9 +209,11 @@ void smc_granule_tracking_get(unsigned long addr,
                return;
        }
 
+#if 0
        if (!ALIGNED(addr, RMM_INTERNAL_TRACKING_REGION_SIZE)) {
                return;
        }
+#endif
 
        g = find_granule(addr);
        if (g != NULL) {

This is likely not the right fix but hopefully provides some guidance.  Send me
your patches when you have an idea and I'll test them.

Thanks,
Mathieu


> +	end = ALIGN(end, RMM_GRANULE_TRACKING_SIZE);
> +
> +	while (start < end) {
> +		unsigned long ret, category, state;
> +
> +		ret = rmi_granule_tracking_get(start, &category, &state);
> +		if (ret != RMI_SUCCESS ||
> +		    state != RMI_TRACKING_FINE ||
> +		    category != RMI_MEM_CATEGORY_CONVENTIONAL) {
> +			/* TODO: Set granule tracking in this case */
> +			kvm_err("Granule tracking for region isn't fine/conventional: %llx",
> +				start);
> +			return -ENODEV;
> +		}
> +		start += RMM_GRANULE_TRACKING_SIZE;
> +	}
> +
> +	return 0;
> +}
> +
> +static unsigned long rmi_l0gpt_size(void)
> +{
> +	return 1UL << (30 + FIELD_GET(RMI_FEATURE_REGISTER_1_L0GPTSZ,
> +				      rmm_feat_reg1));
> +}
> +
> +static int rmi_create_gpts(phys_addr_t start, phys_addr_t end)
> +{
> +	unsigned long l0gpt_sz = rmi_l0gpt_size();
> +
> +	start = ALIGN_DOWN(start, l0gpt_sz);
> +	end = ALIGN(end, l0gpt_sz);
> +
> +	while (start < end) {
> +		int ret = rmi_gpt_l1_create(start);
> +
> +		if (ret && ret != RMI_ERROR_GPT) {
> +			/*
> +			 * FIXME: Handle SRO so that memory can be donated for
> +			 * the tables.
> +			 */
> +			kvm_err("GPT Level1 table missing for %llx\n", start);
> +			return -ENOMEM;
> +		}
> +		start += l0gpt_sz;
> +	}
> +
> +	return 0;
> +}
> +
> +static int rmi_init_metadata(void)
> +{
> +	phys_addr_t start, end;
> +	const struct memblock_region *r;
> +
> +	for_each_mem_region(r) {
> +		int ret;
> +
> +		start = memblock_region_memory_base_pfn(r) << PAGE_SHIFT;
> +		end = memblock_region_memory_end_pfn(r) << PAGE_SHIFT;
> +		ret = rmi_verify_memory_tracking(start, end);
> +		if (ret)
> +			return ret;
> +		ret = rmi_create_gpts(start, end);
> +		if (ret)
> +			return ret;
> +	}
> +
> +	return 0;
> +}
> +
>  static int rmm_check_features(void)
>  {
>  	if (kvm_lpa2_is_enabled() && !rmi_has_feature(RMI_FEATURE_REGISTER_0_LPA2)) {
> @@ -120,6 +207,8 @@ void kvm_init_rmi(void)
>  		return;
>  	if (rmi_configure())
>  		return;
> +	if (rmi_init_metadata())
> +		return;
>  
>  	/* Future patch will enable static branch kvm_rmi_is_available */
>  }
> -- 
> 2.43.0
> 
> 
