Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FD24503BF3
	for <kvmarm@lists.linux.dev>; Mon, 21 Sep 2026 21:34:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790026449; cv=none; b=OC0A8bRd/OlR5myaLxKuGQmpzKXp7SuHt3JyxC4eKNXNMK2NANG7JNHm07mxZBrWIhN6CEw2/Nw4SjKa6tuMUPXBALheWSO2lwBrLsuxdaNBPJaa1NIrSSG0P/4tTDgztwqudjx9aBGIrLJbpelV5M7jusXpOjb+TVNmi2s0O1I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790026449; c=relaxed/simple;
	bh=R1peGfGCRuDkyOnmHdifYGmM605I2Y0NPAuHhiZzP+w=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=pJbXP1QyKakQMRe5ZPTc0sMRFGO7c/RLid1hQXVbSVmWj9CxeWxj2VHECHK/Y1N+t7/HUfjAxsLV3LC3TXTP0K0J6nSKljl1T6cOIPKYK1HBxIsnwXxHLqXD6O3W/BQumXoENA9aqKwvyFqRO6LXTeQBn/S2qeNIis9SQbqyfX0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=bIzBAr5/; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=fiCT7Bea; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="bIzBAr5/";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="fiCT7Bea"
Received: from pps.filterd (m0279862.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68LKfiw11751653
	for <kvmarm@lists.linux.dev>; Mon, 21 Sep 2026 21:34:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	z80fGZcv6BPIL4REfzCrI6RcJShWmT49WjhJXMKxxOU=; b=bIzBAr5/YZDrBmax
	l1lrKwqt/AXF2k3S8USImZugoEgOGjaM7BeHLt/wgHvoz7eSgHPGcmF/GnQ7hKWw
	AVXxXIpaoMMm7xQex8VmfUTelZ8DLkpTOYg07K1uuNJziWJ5/B850e9jvzpkX9M2
	pwTdNHrRtkT9vJ2oGhKQdHlAxZe9b1cEb1kjnGj1JfQ5Yum1e018V7QG3SzMurdZ
	qYBpZL7EjftEzedXWYubyG0HHB/uHSMgmSZraBPpTFk28q2fzcvYi1lEM+EtWJJu
	jyBC0lCVWmE6/ZqI2+sGqlJRoDpTc9G/FJJoJO3kliDc8dcpTXxBoBtNX0fRuwuM
	x0giwg==
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com [209.85.216.72])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4gu8xerwkw-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <kvmarm@lists.linux.dev>; Mon, 21 Sep 2026 21:34:06 +0000 (GMT)
Received: by mail-pj1-f72.google.com with SMTP id 98e67ed59e1d1-38e7ff7b375so3973487a91.1
        for <kvmarm@lists.linux.dev>; Mon, 21 Sep 2026 14:34:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1790026446; x=1790631246; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:mime-version:organization
         :references:in-reply-to:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=z80fGZcv6BPIL4REfzCrI6RcJShWmT49WjhJXMKxxOU=;
        b=fiCT7BeaDTQrlRZh4DZqvgJoqytmWqiCtUbXpJUWhucUMxnXFK2alUmw1waLYrsg9m
         KexHtXuqwUcJLuOId6UB21NkAfEuHjZNpcNvnfCyHqMbk0RzfkM7z4DI5/+mRy98UENs
         p+XLzvoCOgAT0OkN1rv8jyYc/NffHcOlwQeA6B8fQMHWhxo7FZcY8CIwGmJ+JITUropa
         ZZz3+KzJAlhuXpX2Q1u9/jjyTdIRZyOGEfMjpVYPKtOWneKoPTHIS+mBkzqE95s53GwX
         CxVix3Z/UdYK5o0GdQx4yHjXWia89VlVvt7DV8i1hqhZ6dDbpotSThGJnRPzw5QJd3zm
         +xOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790026446; x=1790631246;
        h=content-transfer-encoding:content-type:mime-version:organization
         :references:in-reply-to:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=z80fGZcv6BPIL4REfzCrI6RcJShWmT49WjhJXMKxxOU=;
        b=UN9Wk4U5vYwW4t1zhSuhEuO3tCc9+CthQL36TOGlGSfrBYwbVygFnYlNv+a0tSWnG6
         i0GER72O6mnChx5NQ/raVvqQqAbUhyvv+y8swImoubf2W2wH61RHVgG2XwBLINMw6jIy
         wBMrh6+kcLZe2hfb0nyYPNRXF9raJRf3eHvF7PKY5Ay+MDdCOwoR0vjM6N775wQHfGg+
         cyxydbdHOorWFmXFItFaiPnXame4h9DHUFvNqlAtTQfWx8vUZtrQhK76z8Q5CsQsuhE9
         74qTTG82iOG7a3OhGNEMCHsh27dpfNM+ZpgmVy2YnoWVaegC/Lzqh3z3tBxrtkjQ30Zv
         3KCg==
X-Forwarded-Encrypted: i=1; AKwUvBzJqOTkkchl3/mh9JAjbv7ZTCeuXo5dkK4RB8jw8iRL25Bn4pJYRjr2/agsZP9eLtMqiVmOLz8=@lists.linux.dev
X-Gm-Message-State: AFuF++lxmrfA/hP+6vrA+DcHkHxssWZsioDmbsyLlCUP45AnRELY/D0u
	B77hME800tTmABEhZU1FMvncTpVH6iG69db/Zt6703PUICihN9+oG7fP7k08sxZcw2Y9tZ9hOYt
	1LNnGPm2JAIzmDnkeWQmIPQjxXz5AUxCqsWYe8Ut7ObhXTsKQUWFDq/ZhRz8=
X-Gm-Gg: AYBFou2/0tCIxnVOYDEMQSnz951cTpbm+mplT08Hs1n8B9KeNKWMRfD5ZFxYyZ4ofwM
	ebY0PO2e3MVGLTcHXLYOnYKSMw/vYrqMmXchRahA+WuvffpUmDGlKqJpfmSDGoNI5wib+hUAH+0
	aCTicpYOl8PYpiPkssfeygk7gUMgy4XWhshGp0J05YRlLXJi1/CXOnb6fdltJbAY1ZO3SVbRfVK
	IQyRZ8GLOLgySeSnvL1Y6eLH5MXIWW3AaM761jtDA2IjkPw81p0lgD9kJCz2Touw91dyDyL78Mr
	qZaRJoho3L7lT/8T2slLmoSZClJAn3TQkJDWStNpXub4eC3+wqVLNKmaEyXvjqu7q/4B0KtdpmH
	I6ohDDI2ha+3eYW+FuqI0WJUebA==
X-Received: by 2002:a17:90b:5187:b0:39e:6c6a:2095 with SMTP id 98e67ed59e1d1-39e6c6a22ecmr10542586a91.54.1790026445969;
        Mon, 21 Sep 2026 14:34:05 -0700 (PDT)
X-Received: by 2002:a17:90b:5187:b0:39e:6c6a:2095 with SMTP id 98e67ed59e1d1-39e6c6a22ecmr10542536a91.54.1790026445395;
        Mon, 21 Sep 2026 14:34:05 -0700 (PDT)
Received: from localhost ([50.35.44.179])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3a02625615dsm5648638a91.2.2026.09.21.14.34.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Sep 2026 14:34:04 -0700 (PDT)
Date: Mon, 21 Sep 2026 14:33:52 -0700
From: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
To: Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev, maz@kernel.org,
        will@kernel.org, catalin.marinas@arm.com, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, steven.price@arm.com,
        aneesh.kumar@kernel.org, oupton@kernel.org, gshan@redhat.com,
        joey.gouly@arm.com, tabba@google.com, yuzenghui@huawei.com,
        linux-coco@lists.linux.dev, gankulkarni@os.amperecomputing.com,
        sdonthineni@nvidia.com, alpergun@google.com, fj0570is@fujitsu.com,
        WeiLin.Chang@arm.com, lpieralisi@kernel.org, enju.kohei@fujitsu.com
Subject: Re: [PATCH v18 1/7] firmware: arm_rmm: Add SMC definitions for
 calling the RMM
Message-ID: <20260921143352.0000014a@oss.qualcomm.com>
In-Reply-To: <d7ccaf22-5bde-4344-8bf0-a5a17dcac0f3@arm.com>
References: <20260912083611.2513845-1-suzuki.poulose@arm.com>
	<20260912083611.2513845-2-suzuki.poulose@arm.com>
	<178978126540.2352296.16845657485139032765.b4-review@b4>
	<d7ccaf22-5bde-4344-8bf0-a5a17dcac0f3@arm.com>
Organization: Qualcomm
X-Mailer: Claws Mail 4.4.0 (GTK 3.24.51; x86_64-w64-mingw32)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Proofpoint-ORIG-GUID: XbdqR3MEIDVHw_gegqqhjYIu1xtnNUkR
X-Authority-Analysis: v=2.4 cv=PZhqFShd c=1 sm=1 tr=0 ts=6ab1a2ce cx=c_pps
 a=RP+M6JBNLl+fLTcSJhASfg==:117 a=aNnz9XPx1a4JIXSYt2cE/A==:17
 a=kj9zAlcOel0A:10 a=VdqzKS8jKosA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=_K5XuSEh1TEqbUxoQ0s3:22
 a=7CQSdrXTAAAA:8 a=PlCZfVOHbWhc7nwO5CYA:9 a=CjuIK1q_8ugA:10
 a=iS9zxrgQBfv6-_F4QbHw:22 a=a-qgeE7W1pNrGK8U0ZQC:22
X-Proofpoint-GUID: XbdqR3MEIDVHw_gegqqhjYIu1xtnNUkR
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTIxMDMxNSBTYWx0ZWRfXx5DTteomLplP
 mFa9sAQOYsSCkTjs9SkeFqeDElh/Fy0sLrRpbxI1+npICti1JhNAX10ppw6pV98BbNTvjwJ4yS8
 6gn/bF3poVQBG+9roZBE+jl2K76U9q+zBczcDlH04QseWBgLpOoZ5imlnakc46JTejvJZRGtgsB
 HOF0j3OovW6r7sQ24SnwHFvaC/UomPUbE6/RBMm7AsgDMytJ567HVsTmhsyd8+CIu2IlXFRheFy
 XtUmzqRahpwBe0sQwBqTfAunfkSmYO4uuK6ccz1Zl3IAb17M9LBPkCxOsTKZnkVC1YVVhvK1GYl
 XNLY/tFLkfA85p1NXdmMrzcXU5EO88YEDcQSAGl5bLGePZCucn8eJZp84F4gHLloZTS1eKEiPWr
 RxuZQChYAahWiRQR4HGP2GtT9bxxWqBSZ6jZx4EKswKhdfIMtZMxkixwIX0Ocmq3T5NjqW1PKuh
 aLaKKcIc00WXpTIZ2eg==
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTIxMDMxNSBTYWx0ZWRfX2Bzx5avmmFvc
 JJYvFIUfLlAUfX7X/L7lGY0kzid03Qq2w6uG0+ByOws9HQIwlZpRE9iNBDKQ4QxOaubuDvUJKks
 ShQcHAcAZf1GYSKkFXOA6TJCOQgpkYs=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-21_06,2026-09-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 malwarescore=0 spamscore=0 impostorscore=0 priorityscore=1501
 lowpriorityscore=0 suspectscore=0 bulkscore=0 phishscore=0 adultscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2609210315

On Mon, 21 Sep 2026 10:27:46 +0100
Suzuki K Poulose <suzuki.poulose@arm.com> wrote:

> On 19/09/2026 02:27, Jonathan Cameron wrote:
> >> The RMM (Realm Management Monitor) provides functionality that can be
> >> accessed by SMC calls from the host.
> >>
> >> The SMC definitions are based on DEN0137[1] version 2.0-bet3
> >>
> >> [1] https://developer.arm.com/documentation/den0137/2-0bet3/
> >>
> >> Signed-off-by: Steven Price <steven.price@arm.com>
> >> Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>  
> > 
> > With Gavin's nitpicks and the GENMASK_ULL() from sashiko, just a few
> > comments inline.  Mostly on subtle inconsistencies that really don't
> > matter that much.
> >   
> >>   include/linux/arm-smccc-rmi.h | 497 ++++++++++++++++++++++++++++++++++
> >>   1 file changed, 497 insertions(+)
> >>   create mode 100644 include/linux/arm-smccc-rmi.h
> >>
> >> diff --git a/include/linux/arm-smccc-rmi.h b/include/linux/arm-smccc-rmi.h
> >> new file mode 100644
> >> index 000000000000..214d6228dfc2
> >> --- /dev/null
> >> +++ b/include/linux/arm-smccc-rmi.h
> >> @@ -0,0 +1,497 @@
> >> +/* SPDX-License-Identifier: GPL-2.0 */
> >> +/*
> >> + * Copyright (C) 2023-2026 ARM Ltd.
> >> + *
> >> + * The values and structures in this file are from the Realm Management Monitor
> >> + * specification (DEN0137) version 2.0-bet3:
> >> + * https://developer.arm.com/documentation/den0137/2-0bet3/
> >> + */
> >> +
> >> +#ifndef __LINUX_ARM_SMCCC_RMI_H_
> >> +#define __LINUX_ARM_SMCCC_RMI_H_
> >> +
> >> +#include <linux/arm-smccc.h>
> >> +#include <linux/bitfield.h>
> >> +#include <linux/bits.h>
> >> +#include <linux/build_bug.h>
> >> +#include <linux/sizes.h>
> >> +
> >> +#include <asm/page.h>
> >> +
> >> +#define SMC_RMI_CALL(func)				\
> >> +	ARM_SMCCC_CALL_VAL(ARM_SMCCC_FAST_CALL,		\
> >> +			   ARM_SMCCC_SMC_64,		\
> >> +			   ARM_SMCCC_OWNER_STANDARD,	\
> >> +			   (func))  
> > 
> > Obviously it is v18 so probably a future thing but nothing about this
> > is RMI specific.  Could be used for ARM_SMCCC_TRNG_RND64 for instance.
> > I'm not entirely sure what we'd call such a macro
> > 
> > ARM_SMCCC_CALL_VAL64_STD() maybe?  
> 
> ARM_SMCCC_STD_CALL64_VAL() ?
> 
> But, I would leave it as a wider cleanup in the tree as a separate
> series.

Ok.  A follow up would be fine I guess.


> >> +
> >> +#define RMI_RETURN_STATUS_MASK		GENMASK(7, 0)
> >> +#define RMI_RETURN_INDEX_MASK		GENMASK(15, 8)
> >> +#define RMI_RETURN_MEMREQ_MASK		GENMASK(9, 8)
> >> +#define RMI_RETURN_CAN_CANCEL_MASK	BIT(10)
> >> +
> >> +#define RMI_RETURN_STATUS(ret)		FIELD_GET(RMI_RETURN_STATUS_MASK, ret)
> >> +#define RMI_RETURN_INDEX(ret)		FIELD_GET(RMI_RETURN_INDEX_MASK, ret)  
> > 
> > What's this one?  I can't find anything in the spec that matches it
> > and as far as I can tell you don't use it in this series.  
> 
> This is coming from RmiResultDataLevel. See RmiResult type.
> This was renamed after we introduce the RmiResultDataIncomplete.
> It is used in the KVM code to find the "level" where a command
> failed/walked.
> 
> I could rename it to RMI_RESULT_DATA_LEVEL() ?
> Similarly RMI_RESULT_STATUS instead of RMI_RETURN_*

Yes, that would make tracking it down easier. Thanks.

> 
> >   
> >> +#define RMI_RETURN_MEMREQ(ret)		FIELD_GET(RMI_RETURN_MEMREQ_MASK, ret)
> >> +#define RMI_RETURN_CAN_CANCEL(ret)	FIELD_GET(RMI_RETURN_CAN_CANCEL_MASK, ret)  
> 
> > These are obscure enough to find in the spec I'd give a comment just
> > to save the sanity of anyone looking for them.  
> 
> As above, they are really RMI_RESULT_DATA_INCOMPLETE_*
> 
> >   
> >> +/*
> >> + * Note many of these fields are smaller than u64 but all fields have u64
> >> + * alignment, so use u64 to ensure correct alignment.  
> > 
> > Obviously this is only going to run on arm64 so it's not critical, but
> > more generally u64s aren't always 64 bit aligned.  So if you 'really'
> > care aligned_u64 is there to ensure it.  Meh, arm64 so fine.  
> 
> Agreed, I am worried about the churn in the consumer code. Also, like
> you said, this is only for ARM64. So, I would pass it.

Ok. A tiny bit ugly but x86_32 adoption of RMM 2.0 is likely to be minimal :)


> >> +
> >> +struct rec_params {
> >> +	union { /* 0x0 */
> >> +		u64 flags;
> >> +		u8 padding0[0x100];
> >> +	};
> >> +	union { /* 0x100 */
> >> +		u64 mpidr;
> >> +		u8 padding1[0x100];
> >> +	};
> >> +	union { /* 0x200 */
> >> +		u64 pc;
> >> +		u8 padding2[0x100];
> >> +	};
> >> +	union { /* 0x300 */
> >> +		u64 gprs[REC_CREATE_NR_GPRS];
> >> +		u8 padding3[0xd00];
> >> +	};
> >> +};
> >> +
> >> +static_assert(sizeof(struct rec_params) == SZ_4K);  
> > Whilst the assert works and is need to prevent oversized the
> > dos never seem to provide any indication of the final trailing
> > padding other than indirectly and I don't like maths on Fridays ;).  
> 
> Agree it is a bit obscure, but ...
> 
> > Maybe union the inner union set with a u8 [SZ_4K]?
> >   
> 
> That doesn't help if the other one runs past SZ_4K ?

You still need the assert so I guess that is already providing
the documentation indirectly so indeed little purpose in the
extra union beyond removing need to have magic padding in the
last element.  Mind you not obvious what that last pad should be
if it wasn't just 'the rest'. So, I think this is fine as is.


Thanks,

Jonathan

