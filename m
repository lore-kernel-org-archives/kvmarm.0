Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7397F22097
	for <kvmarm@lists.linux.dev>; Thu, 21 May 2026 00:22:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779322930; cv=none; b=t5j16Fv9pqzv/fGCP3gbxVEv45RMKIU3XmGVzb1TlqOutflbLaft3rOLBfQ/YWdjqy5NegHbD2jN7GCer+u2ChNZ+SGtsqzXn3hEvQxvWkJuvJrvoVJ46pw7FJrMsQIIA83yGcC+QNSiJXKWun6GH96gSe46h/XpJTYWvuQtWkU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779322930; c=relaxed/simple;
	bh=0a4CoVtwwwY0r15ut+sz9UFjuNFI6DOIraemtUxXd9M=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=mcLaIEwJNrCdqMDbhGkn3FWdU245UvlVKex7CSq4B5fdJofEXipD+JTtZtwCc7lFdLHB+RT5YTYrnKpO8GdAzns+ArPSfQFDKsxEmtGl+Zn0rFaNwiVcgb6nQg4kNy9PoZCMKsWQlypWNwg3azBARFuG2UFdO5FD7YOofH5bSzA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=D4STMcHw; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="D4STMcHw"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1779322927;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=i3i7MRKG6FjVJNfFDsY2mBV0HH5ceLNdSFuRKrXNOfM=;
	b=D4STMcHwg4MBIZPJebc59gAsAjlwjVABRnlG/b+HFxIDeLdFpnSQqLKaKag6jKrp5dJGs6
	XEJvdVcoiknh3My1iD3KkTb9F2gzCuyqD8dQ5mBvaVifNrsy3uY7g/cLSSWLqd0UQfKMIy
	Ml/gRsamTqOkJQOs9thtR5absejF20k=
Received: from mail-pf1-f199.google.com (mail-pf1-f199.google.com
 [209.85.210.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-664-UAM2WFgFMnKqhVznDB3lcw-1; Wed, 20 May 2026 20:22:05 -0400
X-MC-Unique: UAM2WFgFMnKqhVznDB3lcw-1
X-Mimecast-MFC-AGG-ID: UAM2WFgFMnKqhVznDB3lcw_1779322925
Received: by mail-pf1-f199.google.com with SMTP id d2e1a72fcca58-8353fbc7ad5so2773458b3a.3
        for <kvmarm@lists.linux.dev>; Wed, 20 May 2026 17:22:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779322925; x=1779927725;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=i3i7MRKG6FjVJNfFDsY2mBV0HH5ceLNdSFuRKrXNOfM=;
        b=E+zgt9EOTtXOWcRMM8uLD3PkbAlYgFPqfuN5oAqfQLoq+ms8hcQxJVY8RklfEkRh+7
         dgx9kwRBvPgFVWLK4aZSsF+771Z48ZkhslXFhCHyHgAJawOu++VtkIBMGkXPLaNBCFNo
         sGg6qonFy+7IeD94cHTkJ6Ld9B6316JTothtzTaXhkfUISE/OgashKvKLX/Waoq4UlgD
         6oZbTgvrDK3HCCauM2wVITvo02/7VrzYcsQRy5FriiJ8gGSjvuq7xwUrfk/DUU7YU+Ep
         MaZSLiFu6Kz3QII3t/nKmhkcbuHpUablD5vanCMyzhZbGFCp5G1Sx4AwuYKbjL5YaNnp
         MUpg==
X-Forwarded-Encrypted: i=1; AFNElJ9aqGQ/mIHlyVQ7sqMvhW4aZRwzHkv24vYPt32uGwTlRE4b75sfKGJg2YVOvL2DlIDJHfvDW1U=@lists.linux.dev
X-Gm-Message-State: AOJu0YwvEAYrdc6r7kF7A8/dm48gz4/r3ml/i2oHLCfzQQkHYFEmRAgw
	GFx8IGyMLszNNtgscC+rgjfsxG7Q2yCG8ef+n+as7szfmQsHD+JgFoB1AvtlMAAgjKWcD4T1MJd
	MBSWAJzddtEPdgJF2fij3OXF7dt2tQ3N7XR8F46etSkocNvrUcqTMPyGfEA==
X-Gm-Gg: Acq92OEr+MfhWZKy5vIJLZMzQx7Aj2nuX3piiZIufkI+cmnVMskoAwaxJ91z2cNPEym
	BTXU+gQYn0H6UPgNTO4kPud9M/ftccuYBdQoMB3Ln7asVcbnN63XG9UVqjt8apNGj0T5rOa+VSr
	K76/tnn3Q8ovUiQjQe05XPVbYGuTD0Ti3aCcJpDzGqjbbAmDfXYQsM0hy7tdLJsOtArRfWoymjD
	jlCucbZqG4wKYh7s/hYxqw+/ejXt++zxh8ThzFMggWLn+v75gmAARxPaHn3qHdxDG2dmGSs7dLF
	ITtwOBNmp6zH6rvbXojagq4pu+fMI7wwqQWutR5gsk0Yq+9F6SZXwukiUmr57Xlia3Z4cZbbvkv
	lArBu8azNhiC05/FeizeVYkGcYqewJfYPyYS8H7OSQnis7ibun/M+TtuCnhRyrDcf
X-Received: by 2002:a05:6a00:3988:b0:838:af72:fb3a with SMTP id d2e1a72fcca58-8414ac7f34amr670234b3a.7.1779322924810;
        Wed, 20 May 2026 17:22:04 -0700 (PDT)
X-Received: by 2002:a05:6a00:3988:b0:838:af72:fb3a with SMTP id d2e1a72fcca58-8414ac7f34amr670212b3a.7.1779322924310;
        Wed, 20 May 2026 17:22:04 -0700 (PDT)
Received: from [192.168.68.51] (n175-34-8-244.mrk21.qld.optusnet.com.au. [175.34.8.244])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-83f19794e6esm20725723b3a.25.2026.05.20.17.21.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 20 May 2026 17:22:03 -0700 (PDT)
Message-ID: <da87fa25-d979-4d22-99f1-3ba1d81cff23@redhat.com>
Date: Thu, 21 May 2026 10:21:51 +1000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v14 05/44] arm64: RMI: Add wrappers for RMI calls
To: Steven Price <steven.price@arm.com>, kvm@vger.kernel.org,
 kvmarm@lists.linux.dev
Cc: Catalin Marinas <catalin.marinas@arm.com>, Marc Zyngier <maz@kernel.org>,
 Will Deacon <will@kernel.org>, James Morse <james.morse@arm.com>,
 Oliver Upton <oliver.upton@linux.dev>,
 Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu
 <yuzenghui@huawei.com>, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org, Joey Gouly <joey.gouly@arm.com>,
 Alexandru Elisei <alexandru.elisei@arm.com>,
 Christoffer Dall <christoffer.dall@arm.com>, Fuad Tabba <tabba@google.com>,
 linux-coco@lists.linux.dev,
 Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
 Shanker Donthineni <sdonthineni@nvidia.com>, Alper Gun
 <alpergun@google.com>, "Aneesh Kumar K . V" <aneesh.kumar@kernel.org>,
 Emi Kisanuki <fj0570is@fujitsu.com>, Vishal Annapurve
 <vannapurve@google.com>, WeiLin.Chang@arm.com, Lorenzo.Pieralisi2@arm.com
References: <20260513131757.116630-1-steven.price@arm.com>
 <20260513131757.116630-6-steven.price@arm.com>
From: Gavin Shan <gshan@redhat.com>
In-Reply-To: <20260513131757.116630-6-steven.price@arm.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: xGF_YLWA9yMO2R--CcRlmw2r95sk8qVZps11JtcQKL8_1779322925
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi Steven,

On 5/13/26 11:17 PM, Steven Price wrote:
> The wrappers make the call sites easier to read and deal with the
> boiler plate of handling the error codes from the RMM.
> 
> Signed-off-by: Steven Price <steven.price@arm.com>
> ---
> Changes from v13:
>   * Update to RMM v2.0-bet1 spec including some SRO support (there still
>     some FIXMEs where SRO support is incomplete).
> Changes from v12:
>   * Update to RMM v2.0 specification
> Changes from v8:
>   * Switch from arm_smccc_1_2_smc() to arm_smccc_1_2_invoke() in
>     rmi_rtt_read_entry() for consistency.
> Changes from v7:
>   * Minor renaming of parameters and updated comments
> Changes from v5:
>   * Further improve comments
> Changes from v4:
>   * Improve comments
> Changes from v2:
>   * Make output arguments optional.
>   * Mask RIPAS value rmi_rtt_read_entry()
>   * Drop unused rmi_rtt_get_phys()
> ---
>   arch/arm64/include/asm/rmi_cmds.h | 661 ++++++++++++++++++++++++++++++
>   1 file changed, 661 insertions(+)
>   create mode 100644 arch/arm64/include/asm/rmi_cmds.h
> 
> diff --git a/arch/arm64/include/asm/rmi_cmds.h b/arch/arm64/include/asm/rmi_cmds.h
> new file mode 100644
> index 000000000000..04f7066894e9
> --- /dev/null
> +++ b/arch/arm64/include/asm/rmi_cmds.h
> @@ -0,0 +1,661 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +/*
> + * Copyright (C) 2023 ARM Ltd.
> + */
> +
> +#ifndef __ASM_RMI_CMDS_H
> +#define __ASM_RMI_CMDS_H
> +
> +#include <linux/arm-smccc.h>
> +

[...]

> +
> +/**
> + * rmi_rtt_destroy() - Destroy an RTT
> + * @rd: PA of the RD
> + * @ipa: Base of the IPA range described by the RTT
> + * @level: Depth of the RTT within the tree
> + * @out_rtt: Pointer to write the PA of the RTT which was destroyed
> + * @out_top: Pointer to write the top IPA of non-live RTT entries
> + *

In most cases, the parameters are well explained in RMM-v2.0-bet1 spec, I think
it's nice to keep the code and the spec synchronized. For those specific parameters
of this function, they're well explained in RMM-v2.0-bet1 spec as below.

    @rd: PA of the RD for the target realm
    @ipa: Base of the IPA range described by the RTT
    @level: RTT level
    @out_rtt: PA of the RTT which was destroyed
    @out_top: Top IPA of non-live RTT entries, from entry at which the RTT walk terminated

> + * Destroys an RTT. The RTT must be non-live, i.e. none of the entries in the
> + * table are in ASSIGNED or TABLE state.
> + *
> + * Return: RMI return code.
> + */
> +static inline int rmi_rtt_destroy(unsigned long rd,
> +				  unsigned long ipa,
> +				  long level,
> +				  unsigned long *out_rtt,
> +				  unsigned long *out_top)
> +{
> +	struct arm_smccc_res res;
> +
> +	arm_smccc_1_1_invoke(SMC_RMI_RTT_DESTROY, rd, ipa, level, &res);
> +
> +	if (out_rtt)
> +		*out_rtt = res.a1;
> +	if (out_top)
> +		*out_top = res.a2;
> +
> +	return res.a0;
> +}
> +

[...]

Thanks,
Gavin

