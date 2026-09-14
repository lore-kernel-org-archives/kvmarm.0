Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61341242D88
	for <kvmarm@lists.linux.dev>; Mon, 14 Sep 2026 00:29:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789345752; cv=none; b=nGidOIy0wU/wJmJn1hU0IXdUj72jeWITc6i2pVZ/J3An3dW38C0zMgCtB1BM7cfPhMYEXSt1sYhAcQyyRneUQxCaIN1Yj4jb06yCmflP7MgqJsLmevEyoR2dgcS49lgEeFE3QGoI3EeX9g1Botk3Q5R9WNETiyBZgCwxZ2DUsOg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789345752; c=relaxed/simple;
	bh=PYSicbgUYeKMQuNVBFiYxEhTJYAQtEvgtENKUdD18YI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Mz5xgdICJIXAm4FxeP6OLjY4PrAdkbUEkOZb5f/RbUe9n6Yceh2oKWAgJWGKpwzaph6CYD7ycP2H/qhup9Q/keigw++jL8ranlz8m/kl+SZ5OWG5ywCRBCrIDwTeGSYiJuWRNLu6rxQAFjuQzwiSy/8Px1znxxRZ6j6ntSb80xU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=X9XEclJG; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="X9XEclJG"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1789345749;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=DLoVYonTK3+kXMmjv4u1exCcfmc1ArWApo6dzL9n6cI=;
	b=X9XEclJGQ1B9LFoTJG7U8soRnmprMcZB8oj6p/sHI9fN5v2leVaF2RaBah1jDPlY5SUsLq
	TukzODQ51SMVQbUr9md6oOe4H/uWIUCut7NQBGQaB6R8lg6qd7IM3m9V4pzu/im0tR+4Bu
	jTJ+GAhzWHe8ciI5ErDyqhQ6cfyOpl8=
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com
 [209.85.216.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-384-rz_dH4wxMEGXfvQMpCdWng-1; Sun, 13 Sep 2026 20:29:07 -0400
X-MC-Unique: rz_dH4wxMEGXfvQMpCdWng-1
X-Mimecast-MFC-AGG-ID: rz_dH4wxMEGXfvQMpCdWng_1789345747
Received: by mail-pj1-f71.google.com with SMTP id 98e67ed59e1d1-385d2703b64so3941907a91.1
        for <kvmarm@lists.linux.dev>; Sun, 13 Sep 2026 17:29:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789345746; x=1789950546;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=DLoVYonTK3+kXMmjv4u1exCcfmc1ArWApo6dzL9n6cI=;
        b=lBQ6IBvFFa7KlMJrEeEPiI/HPnsfTz2CmErN9s0kQYkqEiEqBwafsgund+945XUXYL
         /b4FGLDSeKl/947DxhGsGYksRbBSEfQlzAOXSVgoQ/LNgPAaRX+vlDz7p9uQsFK3eJjD
         /50DPnW1tDSs8yuBSI81HHbl26DImsfN1KxCDKqViJS/bZqviVlqC/yxJ1j2oYJPNcXm
         spOLj5zy+UK5GuHOt/8wY8AvnvKevh2SyoYnjOdfMd6mTguM1sJdmiRAZIQTUTR0PgM/
         xBwJZZrYHOqY0hdiP57OqnzZyjmxyYoK0yjSYQTLgh0955cA2dLy92k5MZ8eM26VHkfQ
         YOLA==
X-Forwarded-Encrypted: i=1; AKwUvBzCchakGrPgi7Tnu7KAkR6ci66+d6l7h/ytsvtbpQgkaOBX7qtn2fMf9ImiJZTrRx0/RYiMmrU=@lists.linux.dev
X-Gm-Message-State: AFuF++mrQH/xCrNgq8tseKR/5kD+Vm6QhoJDWpck54jDrUzLYXPCs81R
	QFB/WCDm3Ma8CW1/kklCEOIoyFAIcIgiJ5LsYG9gRK1xVGUnQHU9TGhhMDxjxqzSsbj/wXrDKqo
	8KFuNcnYO0d4vCOry5yu1ZZnY3vO40iVyWTJ0eXR4IlqsuH3lUGvKkYf6YQ==
X-Gm-Gg: AYBFou2Yi1N7avr43wjIc7/kpwWSgumC3wJCqh76jJdLIck1tBs4aDqhnEL3Yceu3o6
	aJO4PAeAVHl8joHU70BvTfAOwmL6QT2VfQ0JlKSQMgo07+DfJCR5QLj1tY55B9SIyh/sS03/son
	uajaKgpkw5avOW4xxCGJ1MCSWikSP3lurj5oub5cJFEScGj6ijdK77HZFFPhsZ6aY8IDPKRA2Za
	n83gCZx6WmwEm+ghQIzs6QtRcWzxSnZ3BCqrl6ltRT6UwAya8ciI1I8nyJ71jlrvqu0956tSXI9
	75NweTbE27LJP5kur8A7JfSq+nyJmf/NsW5jL+gykhHUiKkbRIuunZP7JrFzBLQ8El3KAzGZMva
	V42/Dntl0tHUCGqJwH3QglMj83BIIT5wL4SZqdkrFMg==
X-Received: by 2002:a17:90b:2583:b0:38e:7297:a92e with SMTP id 98e67ed59e1d1-39dec497cccmr293239a91.9.1789345746267;
        Sun, 13 Sep 2026 17:29:06 -0700 (PDT)
X-Received: by 2002:a17:90b:2583:b0:38e:7297:a92e with SMTP id 98e67ed59e1d1-39dec497cccmr293210a91.9.1789345745719;
        Sun, 13 Sep 2026 17:29:05 -0700 (PDT)
Received: from [192.168.68.52] (n175-34-8-244.mrk21.qld.optusnet.com.au. [175.34.8.244])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-39d95752809sm17491968a91.13.2026.09.13.17.28.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 13 Sep 2026 17:29:05 -0700 (PDT)
Message-ID: <00986d4c-95b7-4b38-8553-933edc7d4ce0@redhat.com>
Date: Mon, 14 Sep 2026 10:28:52 +1000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v18 1/7] firmware: arm_rmm: Add SMC definitions for
 calling the RMM
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
 <20260912083611.2513845-2-suzuki.poulose@arm.com>
From: Gavin Shan <gshan@redhat.com>
In-Reply-To: <20260912083611.2513845-2-suzuki.poulose@arm.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: LVMfjr2nPcjKhuP0ivcRsCwyO0ZNPBmM16YNMB4YJfo_1789345747
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/12/26 6:36 PM, Suzuki K Poulose wrote:
> From: Steven Price <steven.price@arm.com>
> 
> The RMM (Realm Management Monitor) provides functionality that can be
> accessed by SMC calls from the host.
> 
> The SMC definitions are based on DEN0137[1] version 2.0-bet3
> 
> [1] https://developer.arm.com/documentation/den0137/2-0bet3/
> 
> Signed-off-by: Steven Price <steven.price@arm.com>
> Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
> ---
>   Changes since v17:
>    * Use GENMASK()/BIT() for masks consistently
>    * Rename RMI_{ADDR_RANGE, DONATE}_SIZE => RMI_{*}_BLOCK_SIZE
>    * Reorder the definitions for MSB to LSB
>    * Add definions for RMI_OP_MEM_*CONTIG and RMI_OP_CAN*_CANCEL
>   Changes since v16:
>    * Updated definitions to RMM specification v2.0-bet3.
>   Changes since v15:
>    * Dropped unused symbols REC_MAX_GIC_NUM_LRS and RMI_PERMITTED_GICV3_HCR_BITS.
>    * Output is now (partially) generated from the spec source.
>   Changes since v14:
>    * Updated to RMM spec v2.0-bet2 but without the changes to move
>      metadata out of individual address range descriptors as this is
>      expected to be reverted in a future spec release.
>   Changes since v13:
>    * Updated to RMM spec v2.0-bet1
>   Changes since v12:
>    * Updated to RMM spec v2.0-bet0
>   Changes since v9:
>    * Corrected size of 'ripas_value' in struct rec_exit. The spec states
>      this is an 8-bit type with padding afterwards (rather than a u64).
>   Changes since v8:
>    * Added RMI_PERMITTED_GICV3_HCR_BITS to define which bits the RMM
>      permits to be modified.
>   Changes since v6:
>    * Renamed REC_ENTER_xxx defines to include 'FLAG' to make it obvious
>      these are flag values.
>   Changes since v5:
>    * Sorted the SMC #defines by value.
>    * Renamed SMI_RxI_CALL to SMI_RMI_CALL since the macro is only used for
>      RMI calls.
>    * Renamed REC_GIC_NUM_LRS to REC_MAX_GIC_NUM_LRS since the actual
>      number of available list registers could be lower.
>    * Provided a define for the reserved fields of FeatureRegister0.
>    * Fix inconsistent names for padding fields.
>   Changes since v4:
>    * Update to point to final released RMM spec.
>    * Minor rearrangements.
>   Changes since v3:
>    * Update to match RMM spec v1.0-rel0-rc1.
>   Changes since v2:
>    * Fix specification link.
>    * Rename rec_entry->rec_enter to match spec.
>    * Fix size of pmu_ovf_status to match spec.
> ---
>   include/linux/arm-smccc-rmi.h | 497 ++++++++++++++++++++++++++++++++++
>   1 file changed, 497 insertions(+)
>   create mode 100644 include/linux/arm-smccc-rmi.h
> 

Two nitpicks below, with them addressed:

Reviewed-by: Gavin Shan <gshan@redhat.com>

> diff --git a/include/linux/arm-smccc-rmi.h b/include/linux/arm-smccc-rmi.h
> new file mode 100644
> index 0000000000000..214d6228dfc22
> --- /dev/null
> +++ b/include/linux/arm-smccc-rmi.h
> @@ -0,0 +1,497 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +/*
> + * Copyright (C) 2023-2026 ARM Ltd.
> + *
> + * The values and structures in this file are from the Realm Management Monitor
> + * specification (DEN0137) version 2.0-bet3:
> + * https://developer.arm.com/documentation/den0137/2-0bet3/
> + */
> +
> +#ifndef __LINUX_ARM_SMCCC_RMI_H_
> +#define __LINUX_ARM_SMCCC_RMI_H_
> +
> +#include <linux/arm-smccc.h>
> +#include <linux/bitfield.h>
> +#include <linux/bits.h>
> +#include <linux/build_bug.h>
> +#include <linux/sizes.h>
> +
> +#include <asm/page.h>
> +
> +#define SMC_RMI_CALL(func)				\
> +	ARM_SMCCC_CALL_VAL(ARM_SMCCC_FAST_CALL,		\
> +			   ARM_SMCCC_SMC_64,		\
> +			   ARM_SMCCC_OWNER_STANDARD,	\
> +			   (func))
> +
> +#define SMC_RMI_VERSION				SMC_RMI_CALL(0x0150)
> +
> +#define SMC_RMI_RTT_DATA_MAP_INIT		SMC_RMI_CALL(0x0153)
> +
> +#define SMC_RMI_REALM_ACTIVATE			SMC_RMI_CALL(0x0157)
> +#define SMC_RMI_REALM_CREATE			SMC_RMI_CALL(0x0158)
> +#define SMC_RMI_REALM_DESTROY			SMC_RMI_CALL(0x0159)
> +#define SMC_RMI_REC_CREATE			SMC_RMI_CALL(0x015a)
> +#define SMC_RMI_REC_DESTROY			SMC_RMI_CALL(0x015b)
> +#define SMC_RMI_REC_ENTER			SMC_RMI_CALL(0x015c)
> +#define SMC_RMI_RTT_CREATE			SMC_RMI_CALL(0x015d)
> +#define SMC_RMI_RTT_DESTROY			SMC_RMI_CALL(0x015e)
> +
> +#define SMC_RMI_RTT_READ_ENTRY			SMC_RMI_CALL(0x0161)
> +
> +#define SMC_RMI_RTT_DEV_VALIDATE		SMC_RMI_CALL(0x0163)
> +#define SMC_RMI_PSCI_COMPLETE			SMC_RMI_CALL(0x0164)
> +#define SMC_RMI_FEATURES			SMC_RMI_CALL(0x0165)
> +#define SMC_RMI_RTT_FOLD			SMC_RMI_CALL(0x0166)
> +
> +#define SMC_RMI_RTT_INIT_RIPAS			SMC_RMI_CALL(0x0168)
> +#define SMC_RMI_RTT_SET_RIPAS			SMC_RMI_CALL(0x0169)
> +#define SMC_RMI_VSMMU_CREATE			SMC_RMI_CALL(0x016a)
> +#define SMC_RMI_VSMMU_DESTROY			SMC_RMI_CALL(0x016b)
> +
> +#define SMC_RMI_RMM_CONFIG_SET			SMC_RMI_CALL(0x016e)
> +#define SMC_RMI_PSMMU_IRQ_NOTIFY		SMC_RMI_CALL(0x016f)
> +#define SMC_RMI_ATTEST_PLAT_TOKEN_REFRESH	SMC_RMI_CALL(0x0170)
> +
> +#define SMC_RMI_PDEV_ABORT			SMC_RMI_CALL(0x0174)
> +#define SMC_RMI_PDEV_COMMUNICATE		SMC_RMI_CALL(0x0175)
> +#define SMC_RMI_PDEV_CREATE			SMC_RMI_CALL(0x0176)
> +#define SMC_RMI_PDEV_DESTROY			SMC_RMI_CALL(0x0177)
> +#define SMC_RMI_PDEV_GET_STATE			SMC_RMI_CALL(0x0178)
> +
> +#define SMC_RMI_PDEV_STREAM_KEY_REFRESH		SMC_RMI_CALL(0x017a)
> +#define SMC_RMI_PDEV_SET_PUBKEY			SMC_RMI_CALL(0x017b)
> +#define SMC_RMI_PDEV_STOP			SMC_RMI_CALL(0x017c)
> +#define SMC_RMI_RTT_AUX_CREATE			SMC_RMI_CALL(0x017d)
> +#define SMC_RMI_RTT_AUX_DESTROY			SMC_RMI_CALL(0x017e)
> +#define SMC_RMI_RTT_AUX_FOLD			SMC_RMI_CALL(0x017f)
> +
> +#define SMC_RMI_VDEV_ABORT			SMC_RMI_CALL(0x0185)
> +#define SMC_RMI_VDEV_COMMUNICATE		SMC_RMI_CALL(0x0186)
> +#define SMC_RMI_VDEV_CREATE			SMC_RMI_CALL(0x0187)
> +#define SMC_RMI_VDEV_DESTROY			SMC_RMI_CALL(0x0188)
> +#define SMC_RMI_VDEV_GET_STATE			SMC_RMI_CALL(0x0189)
> +#define SMC_RMI_VDEV_UNLOCK			SMC_RMI_CALL(0x018a)
> +#define SMC_RMI_RTT_SET_S2AP			SMC_RMI_CALL(0x018b)
> +
> +#define SMC_RMI_VDEV_GET_INTERFACE_REPORT	SMC_RMI_CALL(0x01d0)
> +#define SMC_RMI_VDEV_GET_MEASUREMENTS		SMC_RMI_CALL(0x01d1)
> +#define SMC_RMI_VDEV_LOCK			SMC_RMI_CALL(0x01d2)
> +#define SMC_RMI_VDEV_START			SMC_RMI_CALL(0x01d3)
> +
> +#define SMC_RMI_VSMMU_EVENT_HANDLE		SMC_RMI_CALL(0x01d6)
> +#define SMC_RMI_PSMMU_ACTIVATE			SMC_RMI_CALL(0x01d7)
> +#define SMC_RMI_PSMMU_DEACTIVATE		SMC_RMI_CALL(0x01d8)
> +
> +#define SMC_RMI_PSMMU_ST_L2_CREATE		SMC_RMI_CALL(0x01db)
> +#define SMC_RMI_PSMMU_ST_L2_DESTROY		SMC_RMI_CALL(0x01dc)
> +#define SMC_RMI_DPT_L0_CREATE			SMC_RMI_CALL(0x01dd)
> +#define SMC_RMI_DPT_L0_DESTROY			SMC_RMI_CALL(0x01de)
> +#define SMC_RMI_DPT_L1_CREATE			SMC_RMI_CALL(0x01df)
> +#define SMC_RMI_DPT_L1_DESTROY			SMC_RMI_CALL(0x01e0)
> +#define SMC_RMI_GRANULE_TRACKING_GET		SMC_RMI_CALL(0x01e1)
> +
> +#define SMC_RMI_GRANULE_TRACKING_SET		SMC_RMI_CALL(0x01e3)
> +
> +#define SMC_RMI_RMM_CONFIG_GET			SMC_RMI_CALL(0x01ec)
> +
> +#define SMC_RMI_RMM_STATE_GET			SMC_RMI_CALL(0x01ee)
> +
> +#define SMC_RMI_PSMMU_EVENT_CONSUME		SMC_RMI_CALL(0x01f0)
> +#define SMC_RMI_GRANULE_RANGE_DELEGATE		SMC_RMI_CALL(0x01f1)
> +#define SMC_RMI_GRANULE_RANGE_UNDELEGATE	SMC_RMI_CALL(0x01f2)
> +#define SMC_RMI_GPT_L1_CREATE			SMC_RMI_CALL(0x01f3)
> +#define SMC_RMI_GPT_L1_DESTROY			SMC_RMI_CALL(0x01f4)
> +#define SMC_RMI_RTT_DATA_MAP			SMC_RMI_CALL(0x01f5)
> +#define SMC_RMI_RTT_DATA_UNMAP			SMC_RMI_CALL(0x01f6)
> +#define SMC_RMI_RTT_DEV_MAP			SMC_RMI_CALL(0x01f7)
> +#define SMC_RMI_RTT_DEV_UNMAP			SMC_RMI_CALL(0x01f8)
> +#define SMC_RMI_RTT_ARCH_DEV_MAP		SMC_RMI_CALL(0x01f9)
> +#define SMC_RMI_RTT_ARCH_DEV_UNMAP		SMC_RMI_CALL(0x01fa)
> +#define SMC_RMI_RTT_UNPROT_MAP			SMC_RMI_CALL(0x01fb)
> +#define SMC_RMI_RTT_UNPROT_UNMAP		SMC_RMI_CALL(0x01fc)
> +#define SMC_RMI_RTT_AUX_PROT_MAP		SMC_RMI_CALL(0x01fd)
> +#define SMC_RMI_RTT_AUX_PROT_UNMAP		SMC_RMI_CALL(0x01fe)
> +#define SMC_RMI_RTT_AUX_UNPROT_MAP		SMC_RMI_CALL(0x01ff)
> +#define SMC_RMI_RTT_AUX_UNPROT_UNMAP		SMC_RMI_CALL(0x0200)
> +#define SMC_RMI_REALM_TERMINATE			SMC_RMI_CALL(0x0201)
> +#define SMC_RMI_RMM_ACTIVATE			SMC_RMI_CALL(0x0202)
> +#define SMC_RMI_OP_CONTINUE			SMC_RMI_CALL(0x0203)
> +#define SMC_RMI_PDEV_STREAM_CONNECT		SMC_RMI_CALL(0x0204)
> +#define SMC_RMI_PDEV_STREAM_DISCONNECT		SMC_RMI_CALL(0x0205)
> +#define SMC_RMI_PDEV_STREAM_COMPLETE		SMC_RMI_CALL(0x0206)
> +#define SMC_RMI_PDEV_STREAM_KEY_PURGE		SMC_RMI_CALL(0x0207)
> +#define SMC_RMI_OP_MEM_DONATE			SMC_RMI_CALL(0x0208)
> +#define SMC_RMI_OP_MEM_RECLAIM			SMC_RMI_CALL(0x0209)
> +#define SMC_RMI_OP_CANCEL			SMC_RMI_CALL(0x020a)
> +#define SMC_RMI_VSMMU_FEATURES			SMC_RMI_CALL(0x020b)
> +#define SMC_RMI_VSMMU_CMD_GET			SMC_RMI_CALL(0x020c)
> +#define SMC_RMI_VSMMU_CMD_COMPLETE		SMC_RMI_CALL(0x020d)
> +#define SMC_RMI_PSMMU_INFO			SMC_RMI_CALL(0x020e)
> +#define SMC_RMI_RMM_DEACTIVATE			SMC_RMI_CALL(0x020f)
> +#define SMC_RMI_PDEV_STREAM_INFO		SMC_RMI_CALL(0x0210)
> +#define SMC_RMI_GPT_INFO			SMC_RMI_CALL(0x0211)
> +
> +#define RMI_ABI_MAJOR_VERSION	2
> +#define RMI_ABI_MINOR_VERSION	0
> +
> +#define RMI_ABI_VERSION_GET_MAJOR(version) ((version) >> 16)
> +#define RMI_ABI_VERSION_GET_MINOR(version) ((version) & 0xFFFF)
> +#define RMI_ABI_VERSION(major, minor)      (((major) << 16) | (minor))
> +
> +#define RMI_RETURN_STATUS_MASK		GENMASK(7, 0)
> +#define RMI_RETURN_INDEX_MASK		GENMASK(15, 8)
> +#define RMI_RETURN_MEMREQ_MASK		GENMASK(9, 8)
> +#define RMI_RETURN_CAN_CANCEL_MASK	BIT(10)
> +
> +#define RMI_RETURN_STATUS(ret)		FIELD_GET(RMI_RETURN_STATUS_MASK, ret)
> +#define RMI_RETURN_INDEX(ret)		FIELD_GET(RMI_RETURN_INDEX_MASK, ret)
> +#define RMI_RETURN_MEMREQ(ret)		FIELD_GET(RMI_RETURN_MEMREQ_MASK, ret)
> +#define RMI_RETURN_CAN_CANCEL(ret)	FIELD_GET(RMI_RETURN_CAN_CANCEL_MASK, ret)
> +
> +#define RMI_SUCCESS			0
> +#define RMI_ERROR_INPUT			1
> +#define RMI_ERROR_REALM			2
> +#define RMI_ERROR_REC			3
> +#define RMI_ERROR_RTT			4
> +#define RMI_ERROR_NOT_SUPPORTED		5
> +#define RMI_ERROR_DEVICE		6
> +#define RMI_ERROR_RTT_AUX		7
> +#define RMI_ERROR_PSMMU_ST		8
> +#define RMI_ERROR_DPT			9
> +#define RMI_BUSY			10
> +#define RMI_ERROR_GLOBAL		11
> +#define RMI_ERROR_TRACKING		12
> +#define RMI_INCOMPLETE			13
> +#define RMI_BLOCKED			14
> +#define RMI_ERROR_GPT			15
> +#define RMI_ERROR_GRANULE		16
> +
> +#define RMI_CONTINUE_KEEP_GOING		0
> +#define RMI_CONTINUE_STOP		1
> +
> +#define RMI_OP_MEM_REQ_NONE		0
> +#define RMI_OP_MEM_REQ_DONATE		1
> +#define RMI_OP_MEM_REQ_RECLAIM		2
> +
> +#define RMI_OP_CANNOT_CANCEL		0
> +#define RMI_OP_CAN_CANCEL		1
> +
> +#define RMI_DONATE_STATE_MASK		GENMASK(18, 17)
> +#define RMI_DONATE_CONTIG_MASK		BIT(16)
> +#define RMI_DONATE_COUNT_MASK		GENMASK(15, 2)
> +#define RMI_DONATE_BLOCK_SIZE_MASK	GENMASK(1, 0)
> +
> +#define RMI_DONATE_STATE(req)		FIELD_GET(RMI_DONATE_STATE_MASK, req)
> +#define RMI_DONATE_CONTIG(req)		FIELD_GET(RMI_DONATE_CONTIG_MASK, req)
> +#define RMI_DONATE_COUNT(req)		FIELD_GET(RMI_DONATE_COUNT_MASK, req)
> +#define RMI_DONATE_BLOCK_SIZE(req)	FIELD_GET(RMI_DONATE_BLOCK_SIZE_MASK, req)
> +
> +#define RMI_OP_MEM_DELEGATED		0
> +#define RMI_OP_MEM_UNDELEGATED		1
> +#define RMI_OP_MEM_CONDITIONAL		2
> +
> +#define RMI_OP_MEM_NON_CONTIG		0
> +#define RMI_OP_MEM_CONTIG		1
> +
> +#define RMI_ADDR_TYPE_NONE		0
> +#define RMI_ADDR_TYPE_SINGLE		1
> +#define RMI_ADDR_TYPE_LIST		2
> +
> +#define RMI_ADDR_RANGE_STATE_MASK	GENMASK(63, 62)
> +#define RMI_ADDR_RANGE_ADDR_MASK	GENMASK(51, PAGE_SHIFT)
> +#define RMI_ADDR_RANGE_COUNT_MASK	GENMASK(PAGE_SHIFT - 1, 2)
> +#define RMI_ADDR_RANGE_BLOCK_SIZE_MASK	GENMASK(1, 0)
> +
> +#define RMI_ADDR_RANGE_BLOCK_SIZE(r)	FIELD_GET(RMI_ADDR_RANGE_BLOCK_SIZE_MASK, (r))
> +#define RMI_ADDR_RANGE_COUNT(r)		FIELD_GET(RMI_ADDR_RANGE_COUNT_MASK, (r))
> +#define RMI_ADDR_RANGE_ADDR(r)		((r) & RMI_ADDR_RANGE_ADDR_MASK)
> +#define RMI_ADDR_RANGE_STATE(r)		FIELD_GET(RMI_ADDR_RANGE_STATE_MASK, (r))
> +

Please reorder those 4 definitions so that their orders are same to those
for RMI_ADDR_RANGE_{STATE, ADDR, COUNT, BLOCK_SIZE}_MASK.

#define RMI_ADDR_RANGE_STATE(r)		FIELD_GET(RMI_ADDR_RANGE_STATE_MASK, (r))
#define RMI_ADDR_RANGE_ADDR(r)		((r) & RMI_ADDR_RANGE_ADDR_MASK)
#define RMI_ADDR_RANGE_COUNT(r)		FIELD_GET(RMI_ADDR_RANGE_COUNT_MASK, (r))
#define RMI_ADDR_RANGE_BLOCK_SIZE(r)	FIELD_GET(RMI_ADDR_RANGE_BLOCK_SIZE_MASK, (r))

> +enum rmi_ripas {
> +	RMI_EMPTY = 0,
> +	RMI_RAM = 1,
> +	RMI_DESTROYED = 2,
> +	RMI_DEV = 3,
> +};
> +
> +#define RMI_NO_MEASURE_CONTENT	0
> +#define RMI_MEASURE_CONTENT	1
> +
> +#define RMI_FEATURE_REGISTER_0_S2OASZ			GENMASK(40, 33)
> +#define RMI_FEATURE_REGISTER_0_L0GPT_BLOCK_DELEGATE	BIT(32)
> +#define RMI_FEATURE_REGISTER_0_PMU_NUM_CTRS		GENMASK(31, 27)
> +#define RMI_FEATURE_REGISTER_0_PMU			BIT(26)
> +#define RMI_FEATURE_REGISTER_0_NUM_WPS			GENMASK(25, 20)
> +#define RMI_FEATURE_REGISTER_0_NUM_BPS			GENMASK(19, 14)
> +#define RMI_FEATURE_REGISTER_0_SVE_VL			GENMASK(13, 10)
> +#define RMI_FEATURE_REGISTER_0_SVE			BIT(9)
> +#define RMI_FEATURE_REGISTER_0_LPA2			BIT(8)
> +#define RMI_FEATURE_REGISTER_0_S2SZ			GENMASK(7, 0)
> +
> +#define RMI_FEATURE_REGISTER_1_PPS			GENMASK(16, 14)
> +#define RMI_FEATURE_REGISTER_1_L0GPTSZ			GENMASK(13, 10)
> +#define RMI_FEATURE_REGISTER_1_MAX_RECS_ORDER		GENMASK(9, 6)
> +#define RMI_FEATURE_REGISTER_1_HASH_SHA_512		BIT(5)
> +#define RMI_FEATURE_REGISTER_1_HASH_SHA_384		BIT(4)
> +#define RMI_FEATURE_REGISTER_1_HASH_SHA_256		BIT(3)
> +#define RMI_FEATURE_REGISTER_1_RMI_GRAN_SZ_64KB		BIT(2)
> +#define RMI_FEATURE_REGISTER_1_RMI_GRAN_SZ_16KB		BIT(1)
> +#define RMI_FEATURE_REGISTER_1_RMI_GRAN_SZ_4KB		BIT(0)
> +
> +#define RMI_FEATURE_REGISTER_2_REALM_MAX_VDEVS_ORDER	GENMASK(14, 10)
> +#define RMI_FEATURE_REGISTER_2_NON_TEE_STREAM		BIT(9)
> +#define RMI_FEATURE_REGISTER_2_VDEV_KROU		BIT(8)
> +#define RMI_FEATURE_REGISTER_2_PDEV_MAX_VDEVS_ORDER	GENMASK(7, 4)
> +#define RMI_FEATURE_REGISTER_2_ATS			BIT(3)
> +#define RMI_FEATURE_REGISTER_2_VSMMU			BIT(2)
> +#define RMI_FEATURE_REGISTER_2_DA_COH			BIT(1)
> +#define RMI_FEATURE_REGISTER_2_DA			BIT(0)
> +
> +#define RMI_FEATURE_REGISTER_3_RTT_S2AP_INDIRECT	BIT(6)
> +#define RMI_FEATURE_REGISTER_3_RTT_PLANE		GENMASK(5, 4)
> +#define RMI_FEATURE_REGISTER_3_MAX_NUM_AUX_PLANES	GENMASK(3, 0)
> +
> +#define RMI_FEATURE_REGISTER_4_MEC_COUNT		GENMASK(63, 0)
> +
> +#define RMI_MEM_CATEGORY_CONVENTIONAL		0
> +#define RMI_MEM_CATEGORY_DEV_NCOH		1
> +#define RMI_MEM_CATEGORY_DEV_COH		2
> +#define RMI_MEM_CATEGORY_NONE			3
> +
> +#define RMI_TRACKING_RESERVED			0
> +#define RMI_TRACKING_NONE			1
> +#define RMI_TRACKING_FINE			2
> +#define RMI_TRACKING_COARSE			3
> +#define RMI_TRACKING_INTERMEDIATE		4
> +
> +#define RMI_GRANULE_SIZE_4KB	0
> +#define RMI_GRANULE_SIZE_16KB	1
> +#define RMI_GRANULE_SIZE_64KB	2
> +
> +#define RMI_GPT_PAR_RESERVED           0U
> +#define RMI_GPT_PAR_PLAT               1U
> +#define RMI_GPT_PAR_HOST_NOT_CREATED   2U
> +#define RMI_GPT_PAR_HOST_CREATED       3U
> +
> +/*
> + * Note many of these fields are smaller than u64 but all fields have u64
> + * alignment, so use u64 to ensure correct alignment.
> + */
> +struct rmm_config {
> +	union { /* 0x0 */
> +		struct {
> +			u64 tracking_region_size;
> +			u64 rmi_granule_size;
> +		};
> +		u8 sizer[SZ_4K];
> +	};
> +};
> +
> +static_assert(sizeof(struct rmm_config) == SZ_4K);
> +
> +#define RMI_REALM_PARAM_FLAG_SVE		BIT(1)
> +#define RMI_REALM_PARAM_FLAG_PMU		BIT(2)
> +#define RMI_REALM_PARAM_FLAG_DA			BIT(3)
> +#define RMI_REALM_PARAM_FLAG_LFA_POLICY		GENMASK(6, 5)
> +#define RMI_REALM_PARAM_FLAG_MEC_POLICY		GENMASK(8, 7)
> +
> +#define RMI_HASH_SHA_256			0
> +#define RMI_HASH_SHA_512			1
> +#define RMI_HASH_SHA_384			2
> +
> +struct realm_params {
> +	union { /* 0x0 */
> +		struct {
> +			u64 flags0;
> +			u64 s2sz;
> +			u64 sve_vl;
> +			u64 num_bps;
> +			u64 num_wps;
> +			u64 pmu_num_ctrs;
> +			u64 hash_algo;
> +			u64 num_aux_planes;
> +		};
> +		u8 padding0[0x400];
> +	};
> +	union { /* 0x400 */
> +		struct {
> +			u8 rpv[64];
> +			u64 ats_plane;
> +		};
> +		u8 padding1[0x400];
> +	};
> +	union { /* 0x800 */
> +		struct {
> +			u64 padding2;
> +			u64 rtt_base;
> +			s64 rtt_level_start;
> +			u64 rtt_num_start;
> +			u64 flags1;
> +			u64 max_num_vdevs;
> +		};
> +		u8 padding3[0x700];
> +	};
> +	union { /* 0xf00 */
> +		struct {
> +			u8 padding4[0x80];
> +			u64 aux_rtt_base[3];
> +		};
> +		u8 padding5[0x100];
> +	};
> +};
> +
> +static_assert(sizeof(struct realm_params) == SZ_4K);
> +
> +/*
> + * The number of GPRs (starting from X0) that are
> + * configured by the host when a REC is created.
> + */
> +#define REC_CREATE_NR_GPRS		8
> +

There are more space in the first line of the comments.

/*
  * The number of GPRs (starting from X0) that are configured by the host when
  * a REC is created.
  */

> +#define REC_PARAMS_FLAG_RUNNABLE	BIT(0)
> +
> +struct rec_params {
> +	union { /* 0x0 */
> +		u64 flags;
> +		u8 padding0[0x100];
> +	};
> +	union { /* 0x100 */
> +		u64 mpidr;
> +		u8 padding1[0x100];
> +	};
> +	union { /* 0x200 */
> +		u64 pc;
> +		u8 padding2[0x100];
> +	};
> +	union { /* 0x300 */
> +		u64 gprs[REC_CREATE_NR_GPRS];
> +		u8 padding3[0xd00];
> +	};
> +};
> +
> +static_assert(sizeof(struct rec_params) == SZ_4K);
> +
> +#define REC_ENTER_FLAG_EMULATED_MMIO	BIT(0)
> +#define REC_ENTER_FLAG_INJECT_SEA	BIT(1)
> +#define REC_ENTER_FLAG_TRAP_WFI		BIT(2)
> +#define REC_ENTER_FLAG_TRAP_WFE		BIT(3)
> +#define REC_ENTER_FLAG_RIPAS_RESPONSE	BIT(4)
> +#define REC_ENTER_FLAG_S2AP_RESPONSE	BIT(5)
> +#define REC_ENTER_FLAG_DEV_MEM_RESPONSE	BIT(6)
> +#define REC_ENTER_FLAG_FORCE_P0		BIT(7)
> +
> +#define REC_RUN_GPRS			31
> +
> +struct rec_enter {
> +	union { /* 0x000 */
> +		u64 flags;
> +		u8 padding0[0x200];
> +	};
> +	union { /* 0x200 */
> +		u64 gprs[REC_RUN_GPRS];
> +		u8 padding1[0x600];
> +	};
> +};
> +
> +static_assert(sizeof(struct rec_enter) == SZ_2K);
> +
> +#define RMI_EXIT_SYNC			0x00
> +#define RMI_EXIT_IRQ			0x01
> +#define RMI_EXIT_FIQ			0x02
> +#define RMI_EXIT_PSCI			0x03
> +#define RMI_EXIT_RIPAS_CHANGE		0x04
> +#define RMI_EXIT_HOST_CALL		0x05
> +#define RMI_EXIT_SERROR			0x06
> +#define RMI_EXIT_S2AP_CHANGE		0x07
> +#define RMI_EXIT_VDEV_VALIDATE_MAPPING	0x08
> +#define RMI_EXIT_VSMMU_COMMAND		0x0a
> +
> +struct rec_exit {
> +	union { /* 0x000 */
> +		u8 exit_reason;
> +		u8 padding0[0x100];
> +	};
> +	union { /* 0x100 */
> +		struct {
> +			u64 esr;
> +			u64 far;
> +			u64 hpfar;
> +			u64 rtt_tree;
> +		};
> +		u8 padding1[0x100];
> +	};
> +	union { /* 0x200 */
> +		u64 gprs[REC_RUN_GPRS];
> +		u8 padding2[0x100];
> +	};
> +	union { /* 0x300 */
> +		u8 padding3[0x100];
> +	};
> +	union { /* 0x400 */
> +		struct {
> +			u64 cntp_ctl;
> +			u64 cntp_cval;
> +			u64 cntv_ctl;
> +			u64 cntv_cval;
> +		};
> +		u8 padding4[0x100];
> +	};
> +	union { /* 0x500 */
> +		struct {
> +			u64 ripas_base;
> +			u64 ripas_top;
> +			u8 ripas_value;
> +			u8 padding5[0xf];
> +			u64 s2ap_base;
> +			u64 s2ap_top;
> +			u64 vdev_id_1;
> +			u64 vdev_id_2;
> +			u64 dev_mem_base;
> +			u64 dev_mem_top;
> +			u64 dev_mem_pa;
> +		};
> +		u8 padding6[0x100];
> +	};
> +	union { /* 0x600 */
> +		struct {
> +			u16 imm;
> +			u8 padding7[0x6];
> +			u64 plane;
> +		};
> +		u8 padding8[0x100];
> +	};
> +	union { /* 0x700 */
> +		struct {
> +			u8 pmu_ovf_status;
> +			u8 padding9[0xf];
> +			u64 vsmmu;
> +		};
> +		u8 padding10[0x100];
> +	};
> +};
> +
> +static_assert(sizeof(struct rec_exit) == SZ_2K);
> +
> +struct rec_run {
> +	struct rec_enter enter;
> +	struct rec_exit exit;
> +};
> +
> +static_assert(sizeof(struct rec_run) == SZ_4K);
> +
> +/* RMI_RTT_UNPROT_MAP_FLAGS definitions */
> +#define RMI_RTT_UNPROT_MAP_FLAGS_OADDR_TYPE	GENMASK(1, 0)
> +#define RMI_RTT_UNPROT_MAP_FLAGS_LIST_COUNT	GENMASK(15, 2)
> +#define RMI_RTT_UNPROT_MAP_FLAGS_MEMATTR	GENMASK(18, 16)
> +#define RMI_RTT_UNPROT_MAP_FLAGS_S2AP		GENMASK(22, 19)
> +
> +/* RMI_RTT_PROT_MAP_FLAGS definitions */
> +#define RMI_RTT_PROT_MAP_FLAGS_OADDR_TYPE	GENMASK(1, 0)
> +#define RMI_RTT_PROT_MAP_FLAGS_LIST_COUNT	GENMASK(15, 2)
> +
> +/* S2AP Direct Encodings, used in RMI_RTT_UNPROT_MAP_FLAGS_S2AP */
> +#define RMI_S2AP_DIRECT_WRITE			BIT(0)
> +#define RMI_S2AP_DIRECT_READ			BIT(1)
> +
> +#endif /* __LINUX_ARM_SMCCC_RMI_H_ */

Thanks,
Gavin

