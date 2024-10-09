Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0E06208D0
	for <kvmarm@lists.linux.dev>; Wed,  9 Oct 2024 04:12:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728447135; cv=none; b=SMGJREiwenUx6EAo7IwVUJRKlLOk4y5FVF7DIw+dTcFWKX1DsFEqeP743Ucvy0a2VSM9nI8alU0PGXpQofnx1B/kJqAXA9qPIWq2mIGSG+PNwEoxjFvngtX/EjFvKIsUHuQnmxiKDmr4iXmsMY91YoUxpy0FpFn3P3KiJDV4ZJY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728447135; c=relaxed/simple;
	bh=2EMLfUgJUHVkpCVN1cNfXvsbJ7ebzGu1eT2Gy5FH5OA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=WnRMSMmAX0DjMlYMX3ZHV4re8rNR5zcjkrlSSlysvUaJ6rDj7yVVAeujwzmubd5LUsW5FzPa1upUjgV0Fnkdnyidz16t+uNBrAJGLBkBYc6YjnMhCWfgN+CF+ZpwFYOsOzeHAZvwRuN/5iq3ItKVcaCMoTpDR5bjCJ5h4Y7isiY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=UKIbbLW6; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="UKIbbLW6"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1728447132;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9mVrlUNC3qZXC5+gYbjc1blm2bjjKslr4GeznnATIz8=;
	b=UKIbbLW6YzGhXau4f5iMYakzGoAqFaVq496o0PNiWa6A9AdTHeHN3W2bylZXkLVGa5szUH
	5WGSXYrr7zdlb6z38WUCFmHn6JWgvyqPQ5FqPbtjQCV/Hz87MdCHspnzdU6+PfI4YnrIbf
	bzBs2nDbChI/jt82EscuCjZ3tP+MWeY=
Received: from mail-pf1-f199.google.com (mail-pf1-f199.google.com
 [209.85.210.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-365-JAAjYOBXPpmbQpWsvq7pXQ-1; Wed, 09 Oct 2024 00:12:10 -0400
X-MC-Unique: JAAjYOBXPpmbQpWsvq7pXQ-1
Received: by mail-pf1-f199.google.com with SMTP id d2e1a72fcca58-71dff575924so3947539b3a.1
        for <kvmarm@lists.linux.dev>; Tue, 08 Oct 2024 21:12:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728447130; x=1729051930;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=9mVrlUNC3qZXC5+gYbjc1blm2bjjKslr4GeznnATIz8=;
        b=kcAAMPeEyV0xJwntwzj2icdDa+FE14qLaW+RGoDwYnQD5C5rjT6TzyguZUAroZ86x/
         qvO0DGHP57bJF98bk8K8hdEI2AisjPrnDqO9GP2XZb6hIOmPRVUvNs1damjnju2MFJ7V
         lMQDQXZ3wKsyM9foXBkg1afuc3n8KdR1euu1CDi5nviEyyQoZtNC/tj+TdXHb3e9gL1Z
         +RIP/E1UKAsT1WMEHJFobeRquvSAXy4/nGHS94neI4yiajF8Bwo/hrn4TgousEoEiVT0
         5oTmlQpsSHJANoreLPuS0P/SW+vxaVmrb9eTtu0VJODryn7yzm8iA2/iQeDTboWg3mtP
         BEGg==
X-Forwarded-Encrypted: i=1; AJvYcCXKkg4gdNi+SNUhI0O1xY2Oa+rN2i53zam8Q1N99FhaqdfhLe0fUEFOfMPvmOIgLhxnDY5mJAg=@lists.linux.dev
X-Gm-Message-State: AOJu0YzqT1SC93uOPLy6m8Pmvyid+s7chBXmzRtLYzIMC4Z3iLoKLDoG
	G1nPt7x70dYnbo6VhlhsucXmCmqYkD+0oaznv1qcHb2ebCnuKs545MT5jfHqUIrTlVlcYW7sMtf
	sYL24uWbrG9O5XvnbtJofOcFY2LqgHBTX/zfr2kMIoawwugYnH6iJDw==
X-Received: by 2002:a05:6a21:394a:b0:1d6:d2cb:1998 with SMTP id adf61e73a8af0-1d8a3c20781mr1878294637.22.1728447129690;
        Tue, 08 Oct 2024 21:12:09 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGwN+fTlwoHHbhn40dcTUiTDemBzl2n0N+Z4SeZmeh2YhQva4x/MfDPtJ7gb8mD4oNZt5veow==
X-Received: by 2002:a05:6a21:394a:b0:1d6:d2cb:1998 with SMTP id adf61e73a8af0-1d8a3c20781mr1878175637.22.1728447127940;
        Tue, 08 Oct 2024 21:12:07 -0700 (PDT)
Received: from [192.168.68.54] ([43.252.112.159])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-7e9f6c4a1a8sm7522130a12.93.2024.10.08.21.12.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Oct 2024 21:12:07 -0700 (PDT)
Message-ID: <f2ddc184-fdf8-4281-b8a2-c2ea5a35b447@redhat.com>
Date: Wed, 9 Oct 2024 14:12:00 +1000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 2/7] arm64/sysreg: Convert existing MPAM sysregs and
 add the remaining entries
To: Joey Gouly <joey.gouly@arm.com>, linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.linux.dev
Cc: anshuman.khandual@arm.com, james.morse@arm.com,
 Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>,
 Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu
 <yuzenghui@huawei.com>, Jing Zhang <jingzhangos@google.com>,
 Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>
References: <20241004110714.2051604-1-joey.gouly@arm.com>
 <20241004110714.2051604-3-joey.gouly@arm.com>
From: Gavin Shan <gshan@redhat.com>
In-Reply-To: <20241004110714.2051604-3-joey.gouly@arm.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/4/24 9:07 PM, Joey Gouly wrote:
> From: James Morse <james.morse@arm.com>
> 
> Move the existing MPAM system register defines from sysreg.h to
> tools/sysreg and add the remaining system registers.
> 
> Signed-off-by: James Morse <james.morse@arm.com>
> Signed-off-by: Joey Gouly <joey.gouly@arm.com>
> ---
>   arch/arm64/include/asm/sysreg.h |  12 ---
>   arch/arm64/tools/sysreg         | 166 ++++++++++++++++++++++++++++++++
>   2 files changed, 166 insertions(+), 12 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sysreg.h
> index 9ea97dddefc4..345e81e0d2b3 100644
> --- a/arch/arm64/include/asm/sysreg.h
> +++ b/arch/arm64/include/asm/sysreg.h
> @@ -542,18 +542,6 @@
>   
>   #define SYS_MAIR_EL2			sys_reg(3, 4, 10, 2, 0)
>   #define SYS_AMAIR_EL2			sys_reg(3, 4, 10, 3, 0)
> -#define SYS_MPAMHCR_EL2			sys_reg(3, 4, 10, 4, 0)
> -#define SYS_MPAMVPMV_EL2		sys_reg(3, 4, 10, 4, 1)
> -#define SYS_MPAM2_EL2			sys_reg(3, 4, 10, 5, 0)
> -#define __SYS__MPAMVPMx_EL2(x)		sys_reg(3, 4, 10, 6, x)
> -#define SYS_MPAMVPM0_EL2		__SYS__MPAMVPMx_EL2(0)
> -#define SYS_MPAMVPM1_EL2		__SYS__MPAMVPMx_EL2(1)
> -#define SYS_MPAMVPM2_EL2		__SYS__MPAMVPMx_EL2(2)
> -#define SYS_MPAMVPM3_EL2		__SYS__MPAMVPMx_EL2(3)
> -#define SYS_MPAMVPM4_EL2		__SYS__MPAMVPMx_EL2(4)
> -#define SYS_MPAMVPM5_EL2		__SYS__MPAMVPMx_EL2(5)
> -#define SYS_MPAMVPM6_EL2		__SYS__MPAMVPMx_EL2(6)
> -#define SYS_MPAMVPM7_EL2		__SYS__MPAMVPMx_EL2(7)
>   
>   #define SYS_VBAR_EL2			sys_reg(3, 4, 12, 0, 0)
>   #define SYS_RVBAR_EL2			sys_reg(3, 4, 12, 0, 1)
> diff --git a/arch/arm64/tools/sysreg b/arch/arm64/tools/sysreg
> index 8d637ac4b7c6..73243cfca2d2 100644
> --- a/arch/arm64/tools/sysreg
> +++ b/arch/arm64/tools/sysreg
> @@ -2737,6 +2737,126 @@ Field	1	E2SPE
>   Field	0	E0HSPE
>   EndSysreg
>   
> +Sysreg	MPAMHCR_EL2	3	4	10	4	0
> +Res0	63:32
> +Field	31	TRAP_MPAMIDR_EL1
> +Res0	30:9
> +Field	8	GSTAPP_PLK
> +Res0	7:2
> +Field	1	EL1_VPMEN
> +Field	0	EL0_VPMEN
> +EndSysreg
> +
> +Sysreg	MPAMVPMV_EL2	3	4	10	4	1
> +Res0	63:32
> +Field	31	VPM_V31
> +Field	30	VPM_V30
> +Field	29	VPM_V29
> +Field	28	VPM_V28
> +Field	27	VPM_V27
> +Field	26	VPM_V26
> +Field	25	VPM_V25
> +Field	24	VPM_V24
> +Field	23	VPM_V23
> +Field	22	VPM_V22
> +Field	21	VPM_V21
> +Field	20	VPM_V20
> +Field	19	VPM_V19
> +Field	18	VPM_V18
> +Field	17	VPM_V17
> +Field	16	VPM_V16
> +Field	15	VPM_V15
> +Field	14	VPM_V14
> +Field	13	VPM_V13
> +Field	12	VPM_V12
> +Field	11	VPM_V11
> +Field	10	VPM_V10
> +Field	9	VPM_V9
> +Field	8	VPM_V8
> +Field	7	VPM_V7
> +Field	6	VPM_V6
> +Field	5	VPM_V5
> +Field	4	VPM_V4
> +Field	3	VPM_V3
> +Field	2	VPM_V2
> +Field	1	VPM_V1
> +Field	0	VPM_V0
> +EndSysreg
> +
> +Sysreg	MPAM2_EL2	3	4	10	5	0
> +Field	63	MPAMEN
> +Res0	62:59
> +Field	58	TIDR
> +Res0	57
> +Field	56	ALTSP_HFC
> +Field	55	ALTSP_EL2
> +Field	54	ALTSP_FRCD
> +Res0	53:51
> +Field	50	EnMPAMSM
> +Field	49	TRAPMPAM0EL1
> +Field	48	TRAPMPAM1EL1
> +Field	47:40	PMG_D
> +Field	39:32	PMG_I
> +Field	31:16	PARTID_D
> +Field	15:0	PARTID_I
> +EndSysreg
> +
> +Sysreg	MPAMVPM0_EL2	3	4	10	6	0
> +Field	63:48	PhyPARTID3
> +Field	47:32	PhyPARTID2
> +Field	31:16	PhyPARTID1
> +Field	15:0	PhyPARTID0
> +EndSysreg
> +
> +Sysreg	MPAMVPM1_EL2	3	4	10	6	1
> +Field	63:48	PhyPARTID7
> +Field	47:32	PhyPARTID6
> +Field	31:16	PhyPARTID5
> +Field	15:0	PhyPARTID4
> +EndSysreg
> +
> +Sysreg	MPAMVPM2_EL2	3	4	10	6	2
> +Field	63:48	PhyPARTID11
> +Field	47:32	PhyPARTID10
> +Field	31:16	PhyPARTID9
> +Field	15:0	PhyPARTID8
> +EndSysreg
> +
> +Sysreg	MPAMVPM3_EL2	3	4	10	6	3
> +Field	63:48	PhyPARTID15
> +Field	47:32	PhyPARTID14
> +Field	31:16	PhyPARTID13
> +Field	15:0	PhyPARTID12
> +EndSysreg
> +
> +Sysreg	MPAMVPM4_EL2	3	4	10	6	4
> +Field	63:48	PhyPARTID19
> +Field	47:32	PhyPARTID18
> +Field	31:16	PhyPARTID17
> +Field	15:0	PhyPARTID16
> +EndSysreg
> +
> +Sysreg	MPAMVPM5_EL2	3	4	10	6	5
> +Field	63:48	PhyPARTID23
> +Field	47:32	PhyPARTID22
> +Field	31:16	PhyPARTID21
> +Field	15:0	PhyPARTID20
> +EndSysreg
> +
> +Sysreg	MPAMVPM6_EL2	3	4	10	6	6
> +Field	63:48	PhyPARTID27
> +Field	47:32	PhyPARTID26
> +Field	31:16	PhyPARTID25
> +Field	15:0	PhyPARTID24
> +EndSysreg
> +
> +Sysreg	MPAMVPM7_EL2	3	4	10	6	7
> +Field	63:48	PhyPARTID31
> +Field	47:32	PhyPARTID30
> +Field	31:16	PhyPARTID29
> +Field	15:0	PhyPARTID28
> +EndSysreg
> +
>   Sysreg	CONTEXTIDR_EL2	3	4	13	0	1
>   Fields	CONTEXTIDR_ELx
>   EndSysreg
> @@ -2769,6 +2889,10 @@ Sysreg	FAR_EL12	3	5	6	0	0
>   Field	63:0	ADDR
>   EndSysreg
>   
> +Sysreg	MPAM1_EL12	3	5	10	5	0
> +Fields	MPAM1_ELx
> +EndSysreg
> +
>   Sysreg	CONTEXTIDR_EL12	3	5	13	0	1
>   Fields	CONTEXTIDR_ELx
>   EndSysreg
> @@ -2941,6 +3065,22 @@ Res0	1
>   Field	0	EN
>   EndSysreg
>   
> +Sysreg	MPAMIDR_EL1	3	0	10	4	4
> +Res0	63:62
> +Field	61	HAS_SDEFLT
> +Field	60	HAS_FORCE_NS
> +Field	59	SP4
> +Field	58	HAS_TIDR
> +Field	57	HAS_ALTSP
> +Res0	56:40
> +Field	39:32	PMG_MAX
> +Res0	31:21
> +Field	20:18	VPMR_MAX
> +Field	17	HAS_HCR
> +Res0	16
> +Field	15:0	PARTID_MAX
> +EndSysreg
> +
>   Sysreg	LORID_EL1	3	0	10	4	7
>   Res0	63:24
>   Field	23:16	LD
> @@ -2948,6 +3088,32 @@ Res0	15:8
>   Field	7:0	LR
>   EndSysreg
>   
> +Sysreg	MPAM1_EL1	3	0	10	5	0
> +Field	63	MPAMEN
> +Res0	62:59
> +Field	58	TIDR
> +Res0	57
> +Field	56	ALTSP_HFC
> +Field	55	ALTSP_EL2
> +Field	54	ALTSP_FRCD
> +Res0	53:51
> +Field	50	EnMPAMSM
> +Field	49	TRAPMPAM0EL1
> +Field	48	TRAPMPAM1EL1
> +Field	47:40	PMG_D
> +Field	39:32	PMG_I
> +Field	31:16	PARTID_D
> +Field	15:0	PARTID_I
> +EndSysreg
> +

The layout of SYS_MPAM1_EL1 is exactly same to that of SYS_MPAM2_EL2, is it
intentional or a mistake, even SYS_MPAM1_EL1 is the alias to SYS_MPAM2_EL2
when HCR_EL2.E2H is set?

> +Sysreg	MPAM0_EL1	3	0	10	5	1
> +Res0	63:48
> +Field	47:40	PMG_D
> +Field	39:32	PMG_I
> +Field	31:16	PARTID_D
> +Field	15:0	PARTID_I
> +EndSysreg
> +

Shall we add the definition for SYS_MPAMSM_EL1, which is visible in section
D23.12 of "ARM DDI 0487K.a"?

>   Sysreg	ISR_EL1	3	0	12	1	0
>   Res0	63:11
>   Field	10	IS

Thanks,
Gavin

