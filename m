Received: from mail-ed1-f54.google.com (mail-ed1-f54.google.com [209.85.208.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2CB6435ED8
	for <kvmarm@lists.linux.dev>; Fri, 10 Jul 2026 16:01:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783699279; cv=none; b=Ct2low+AB3MC3y7YGLBtRdlXardzVwS2GRYEHL27J28uQrTBd29GdzUzvnM1OcjHBAOYsdkmDsj5UKbYlU5FUpwD5h4zQ001MbCpvdUrQen8sdHr/uSGjziPLcmV8IjjYBOeEXLXlummW+siOEGkK/Ae6kcfeJo2jf1sl4/AA6Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783699279; c=relaxed/simple;
	bh=LHFgDgTvBl/DfAaQ85qu2sTbr3g+uQhv77+URO8Mtbg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Hv3h/2SsUcoBk8D+eEsH+4TTQXtAa6Bo7AOr4H869i42MLmqyLcDQprqToiL+TUU6VO+69S0VaKXC5/iUAlsuOo2PYgWGwoTVaFaNK73kDhCFWzgoPgUnRiB/Mp33t33ygW1de3bNL2h9csu54jDmAPGAPwAQ4OS3tqLHKg06is=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=jY1zDlON; arc=none smtp.client-ip=209.85.208.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="jY1zDlON"
Received: by mail-ed1-f54.google.com with SMTP id 4fb4d7f45d1cf-697cee2eb6dso1139170a12.0
        for <kvmarm@lists.linux.dev>; Fri, 10 Jul 2026 09:01:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1783699273; x=1784304073; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=C1SvbCR97Zwgn4Jhcjeyc5rNgHzndad6U6YnbYiEVE4=;
        b=jY1zDlONrPGgGz08OlS9lr3rtiyhUCHNi8FiRALYxDu/D2l4t8MvwRSGKR1xj9IsUz
         RzNsZCJRTwt5mcE+CNc/uhQ5G2Qr61uLZ6MYzZ0jYfikW4iq4Oe39lF5zYKgCSRgCd8g
         Ccc2wG5BmYCMKXyFDcnFHfpivvqxgl4k1vMD8BIT44QPUtkt3KTwb7Hzr8cAzX8ZxtPU
         d4eADaP7RuijQ593nzX9Kh1ZGaE32q3LmOR/S17ZxIHjc0Wm+FL3vkIrPillg1VT+2/w
         kaMG5i8jJ8Ds10UWN5BJtbQDZPavqHtp/tJ0lMmrg4zdc/dxZ2TKgCrvntObCaoPJfOT
         aSmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783699273; x=1784304073;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=C1SvbCR97Zwgn4Jhcjeyc5rNgHzndad6U6YnbYiEVE4=;
        b=d6xZU5fI9pTfnme0NKkX9r7alljKyCeQ4lzJ4bx054r0cLmqa3npQ6XOoC4Cz+fVoo
         h17h4XwVp3HYMC12MiZxGyZG0xtcThZqm29q53KmnwNXFUGD+byx9par95wUorWXnSOS
         +7mhbS8goDI9UUEMAFB1PXN8CpdCMRY61CWfMlTVxCBpku+6F5YhTrEZZcbPfy0dXsoA
         BYzEhGef4TVmJMNP7ewqAV5G7VDHHhqX4QPYAMlsMJP5N2btqe9OOgjvtDOWF+H0Xoat
         pdcOgdvckC1xmKhLGLr53SN4bSzmeXRhH8KvlABdq8i5F7fRB9+rBZGxQ55YmkrAJA0h
         fNYQ==
X-Forwarded-Encrypted: i=1; AHgh+RoD3P5R74JmoRI8CsoBu0lfpCP4WMPT1vN9T7gcAUt1sRD5+7KOt0GXcF/aIPVMtfBfhRWpLuo=@lists.linux.dev
X-Gm-Message-State: AOJu0Yy1vgibe4jtwNq/joM75b5WXoGSAfTOPSPS/erLdrUUnQ7uQab6
	i9EufEiGrOb5Ml6qFPE5VvxcxwrvT4gZopScYMvjVEHQCOBdS84Zn20vWxBQPTUfDA==
X-Gm-Gg: AfdE7cm/z9wMqdSXw7WGWIQcXe2uTff4x2jP4z4AQCGRBMd8YDPPK9eNdatpSC0viIx
	xOSXeeSv/6gE6jqdvK2pIz8r1vJVYeO/mbvZUWM92epv2RFzx54i7G41ygRc0K214TARSeOg8+7
	Esqw/zNBm4KVAKlrRr7ap1AAJHOr/LD2cf6WKmXbiak4scdDrNqG3bHf5NFxFfOEGxrAAkFwz0A
	3hj9LkWcPYDvbWqFlr0eV4TV5mkDMNXSAtZ4M0fa3FcL0JhrT5JS6J4FCiD72GCroz6ra+AvYaT
	nKTtx2KdrO+spRHt3El4muQRPi2afV62+9XMVSBWUyVV0YTkgIsJgLGEWJjemwMBSBXoPfVIGIP
	2OKU8eiBmoc4jhTP5m56MYTV5AVOPK73nAaexpNHayLGGdjGB7mS6j+QUrs3uTCLCeE7UE8jpci
	bZqUNkN/nPt7G+AAgY4H66XhVtcc2eMX3mNdaQ2oVEkIzGk3DPnAc=
X-Received: by 2002:a05:6402:4288:b0:698:9be1:4a48 with SMTP id 4fb4d7f45d1cf-69ab44aafe2mr5035845a12.33.1783699272374;
        Fri, 10 Jul 2026 09:01:12 -0700 (PDT)
Received: from google.com (137.69.77.34.bc.googleusercontent.com. [34.77.69.137])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-69a19cd87d6sm11239809a12.6.2026.07.10.09.01.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Jul 2026 09:01:11 -0700 (PDT)
Date: Fri, 10 Jul 2026 17:01:07 +0100
From: Vincent Donnefort <vdonnefort@google.com>
To: Mostafa Saleh <smostafa@google.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	kvmarm@lists.linux.dev, iommu@lists.linux.dev,
	catalin.marinas@arm.com, will@kernel.org, maz@kernel.org,
	oliver.upton@linux.dev, joey.gouly@arm.com, suzuki.poulose@arm.com,
	yuzenghui@huawei.com, joro@8bytes.org, jean-philippe@linaro.org,
	jgg@ziepe.ca, mark.rutland@arm.com, qperret@google.com,
	tabba@google.com, sebastianene@google.com, keirf@google.com
Subject: Re: [PATCH v6 16/25] iommu/arm-smmu-v3-kvm: Add CMDQ functions
Message-ID: <alEXQ2X_0XQylvw-@google.com>
References: <20260501111928.259252-1-smostafa@google.com>
 <20260501111928.259252-17-smostafa@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260501111928.259252-17-smostafa@google.com>

On Fri, May 01, 2026 at 11:19:18AM +0000, Mostafa Saleh wrote:
> Add functions to access the command queue, there are 2 main usage:
> - Hypervisor's own commands, as TLB invalidation, would use functions
>   as smmu_send_cmd(), which creates and sends a command.
> - Add host commands to the shadow command queue, after being filtered,
>   these will be added with smmu_add_cmd_raw.
> 
> Signed-off-by: Mostafa Saleh <smostafa@google.com>
> ---
>  drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h   |  14 ++-
>  .../iommu/arm/arm-smmu-v3/pkvm/arm-smmu-v3.c  | 107 ++++++++++++++++++
>  2 files changed, 115 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
> index f904f4d19609..3fc499608d76 100644
> --- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
> +++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
> @@ -1156,19 +1156,21 @@ u32 smmu_idr5_to_oas(u32 reg);
>  unsigned long smmu_idr5_to_pgsize(u32 reg);
>  
>  /* Queue functions shared between kernel and hyp. */
> -static inline bool queue_has_space(struct arm_smmu_ll_queue *q, u32 n)
> +static inline u32 queue_space(struct arm_smmu_ll_queue *q)
>  {
> -	u32 space, prod, cons;
> +	u32 prod, cons;
>  
>  	prod = Q_IDX(q, q->prod);
>  	cons = Q_IDX(q, q->cons);
>  
>  	if (Q_WRP(q, q->prod) == Q_WRP(q, q->cons))
> -		space = (1 << q->max_n_shift) - (prod - cons);
> -	else
> -		space = cons - prod;
> +		return (1 << q->max_n_shift) - (prod - cons);
> +	return cons - prod;
> +}
>  
> -	return space >= n;
> +static inline bool queue_has_space(struct arm_smmu_ll_queue *q, u32 n)
> +{
> +	return queue_space(q) >= n;
>  }
>  
>  static inline bool queue_full(struct arm_smmu_ll_queue *q)
> diff --git a/drivers/iommu/arm/arm-smmu-v3/pkvm/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/pkvm/arm-smmu-v3.c
> index 3b77796dafc7..aac455599728 100644
> --- a/drivers/iommu/arm/arm-smmu-v3/pkvm/arm-smmu-v3.c
> +++ b/drivers/iommu/arm/arm-smmu-v3/pkvm/arm-smmu-v3.c
> @@ -6,6 +6,7 @@
>   */
>  #include <asm/kvm_hyp.h>
>  
> +#include <nvhe/clock.h>
>  #include <nvhe/iommu.h>
>  #include <nvhe/mem_protect.h>
>  #include <nvhe/trap_handler.h>
> @@ -22,6 +23,31 @@ struct hyp_arm_smmu_v3_device *kvm_hyp_arm_smmu_v3_smmus;
>  
>  #define cmdq_size(cmdq)	((1 << ((cmdq)->llq.max_n_shift)) * CMDQ_ENT_DWORDS * 8)

I only looked at that smmu_wait() as this is the hyp_clock_ns() caller.

>  
> +/*
> + * Wait until @cond is true.
> + * Return 0 on success, or -ETIMEDOUT

nit: Would be nice to explain use_wfe. 

> + */
> +#define smmu_wait(use_wfe, _cond)					\

nit:, (__use_wfe, __cond), or (use_fw, cond)

> +({									\
> +	int __ret = 0;							\
> +	u64 delay = hyp_clock_ns() + ARM_SMMU_POLL_TIMEOUT_US * 1000;	\

Does it help to lower the risk for the 128-bits fallback if we keep the
resolution to _us?

Also, ARM_SMMU_POLL_TIMEOUT_US seems to be 1s. Blocking that long at EL2 is
really terrible. Any chance to lower that? 

> +									\
> +	while (!(_cond)) {						\
> +		if (use_wfe) {						\
> +			wfe();						\
> +			if ((_cond))					\

nit: I believe there's no need for the double () here is there?

> +				break;					\
> +		} else {						\
> +			cpu_relax();					\
> +		}							\
> +		if (hyp_clock_ns() >= delay) {				\
> +			__ret = -ETIMEDOUT;				\
> +			break;						\
> +		}							\
> +	}								\
> +	__ret;								\
> +})
> +

[...]
