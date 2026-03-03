Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 231891B424F
	for <kvmarm@lists.linux.dev>; Tue,  3 Mar 2026 20:18:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772569127; cv=none; b=P/wtZ3uMW4Ber68E6ERuMmMa3E6G0qV7+Mfn2PHJ3CRNAd9fJSjIhtWZDW2Gugy6POYt8Wq4RC5H6uimwNqfA/zfRGrlhGNzVm4XIJEetdCsV03wi68gB/HSYgn4FGQTrOfxErkvad8K4U83/Z+4fI9toQTjnwRHyXkSohfGHnc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772569127; c=relaxed/simple;
	bh=XP5EL17iKgU9V9WW00QNpjGSzNhaRGr7w+/GGq/JKNQ=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=vGox6aGy/5ySSNLcC3rMZrLKpVdDfvtq58KccrA5XRsP7FR3yPmV0KHNcaUc4zmaorQx1N4S/mYi7JxpzpoHz0EACENzO67CuyFIdu+45/mTXVlWxtD0quO1RbJxf78bj1DCA4KiE38PI0xAADL3821mrGdOc1n9xOtdsC81GxM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=G9ITdesh; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=P++yBQeq; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="G9ITdesh";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="P++yBQeq"
Received: from pps.filterd (m0279872.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 623H0fdB4030582
	for <kvmarm@lists.linux.dev>; Tue, 3 Mar 2026 20:18:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=qcppdkim1; bh=OK+IIqPNLkgbz36+VPfXuCiJ
	Eyq7012HaDlxd3sHfXY=; b=G9ITdeshOZZ5t5O34VTKAFmPzigux6+UB8CdpDYB
	/dSskvXpGRAl/Ovl/kz9QRZhCw4TYkqQdTq+/JnmcRndNyb/RWcOYFeuOkUch8zU
	PFVzYKrWH2XHRaPmQe7Mliqqkb421nMTy38bmDc+GSubVukvRiU3/C4+bvi9QngO
	xcFf9bncm8K5JKMrzo9KJLaAh+78MW6TBhzMMjtp1raLIC49tRwF6oBPgmThRzeY
	LRrsGOhXLoCoivM3MU+7KS1P2yQXqtVuKYosROicOAUqZ3hak6cMpWA0gDaJayKR
	jCfvrtZgHBWeEwdJMfyy4IFQ+DNra4V6mG68p9Jr7Qhx+Q==
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com [209.85.219.72])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4cnuqu2fsd-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <kvmarm@lists.linux.dev>; Tue, 03 Mar 2026 20:18:44 +0000 (GMT)
Received: by mail-qv1-f72.google.com with SMTP id 6a1803df08f44-899f1c1e4d6so153697236d6.2
        for <kvmarm@lists.linux.dev>; Tue, 03 Mar 2026 12:18:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1772569124; x=1773173924; darn=lists.linux.dev;
        h=mime-version:user-agent:message-id:date:references:in-reply-to
         :subject:cc:to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=OK+IIqPNLkgbz36+VPfXuCiJEyq7012HaDlxd3sHfXY=;
        b=P++yBQeqfmfRvHOzZhlhIw/GR/mfVlwCRG0ERnzgtaPJ284eeqqGtSFViQZjXcAYJq
         wD0Gj6F+BNBnvOhSmv1dVYZYtr+Na54eaxeYCIgiJeAC1UwC3ZjxAgywmmWS9F9oO97U
         tFr3Awy38xJItXaAXKfxUBV83xtoKYqLHuq9JXv02pBi5hH/rNz1Gen1UNL7gXh8zfhx
         XEC4OvMQWNAwX43i6cgXTCqILRiURDl+R7TCqzvYHkQLsc3THPSBEBmdBVzimINwjhOk
         DaPB/RA5qXjLWNrDcV7zP3IfI4OLpolkcO2BDhjDrgleszBKFH6L80WVR5QjtUK1anQL
         GP+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772569124; x=1773173924;
        h=mime-version:user-agent:message-id:date:references:in-reply-to
         :subject:cc:to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=OK+IIqPNLkgbz36+VPfXuCiJEyq7012HaDlxd3sHfXY=;
        b=Tp6N/g/VAlQrOaWRV9ZwXaw0ewluo7UTOvPYYyYA0j7h9NOXhNeBV+IUN0bczt7bQV
         zNww2OmCnEmeNI7tZ5ZP4Mxm5+gd6DSO6xO80NwjhhKdV9dmsPOeHQfXaLxhiq2KlJbY
         eWGUJYoZzjIh7BuDNfYYuHs9W1LtrEBk49ZyVxzMMQ7To1ip4EhiTOeMw4IN8mZwjg7Q
         9IF1Vl5IdjaQAi0S2B2jbZLVu6SqLxVIB6DL2tjltSUm3ljMriwj3Dh0PbDAtsYlZ31L
         FDXxlGBSW8HXddib+EoJeBUmwTj29mLm2226zjQWKuy8B5vceAlbCC7bma8sQRtiZMGv
         jCRA==
X-Forwarded-Encrypted: i=1; AJvYcCW+3eVOHEfDN8BAtK+OBNFneL9n+BdA74fNKnM7FwK/yX1VFHtT7s2k0qYM6veemQ2BETlM8Mo=@lists.linux.dev
X-Gm-Message-State: AOJu0YzgFAaDA5+0Zi4fCKODWeLDyb2U4lxk+qdP9itqqDWcRpcQtU12
	WKJHgUoz+DlB3ruviMfp7r+nkcFE6ia8pepoDnhqwUMIO6bxNRUHX/09uqXAnB1Fv+MoeS7YIFI
	Y+eFXSgLThKX/6/Nz1BUby/Vyya2P/cIRmYoV95A7RS009rBxPrOqyfIzsvE=
X-Gm-Gg: ATEYQzyskKR3BQg/fXavBBuz6uLEtWEXk8d8/QJIE2l0UA6GVMN/9F00v1Vf0hUJAB+
	fY3oYzJsT8hOt6ZqZAm2H0/y3PSeSbLDbRQOJ59YAmHBboANd575TjgYTcbpcz6efCD70F50hkF
	n1bGXG2qkkR/MYV5e3UuEU9yYEW8pD8TXqOrZ4EzuoKDn2J9CTifcbV32ov5ciktih5ed5YEwzi
	Oyfi2VyXuNH5S4eyUnsPb+zCoYB8foi39h68ep1iiNFOl3BdViSehxuTvwYiMFFE7pQt3RzW7KE
	AQxTY88pbfTlu3yb+eQe/y7HuXbI5aybActXTNRWH7JbR3veiwIKzigQcmJ2tG5XizwJA9khszd
	BqzaCBrMXWELj2stJ+s5FrelHh0vyuxtl00wvOw==
X-Received: by 2002:a05:620a:471e:b0:8ca:4545:aeee with SMTP id af79cd13be357-8cbc8df0a40mr2322001085a.37.1772569124331;
        Tue, 03 Mar 2026 12:18:44 -0800 (PST)
X-Received: by 2002:a05:620a:471e:b0:8ca:4545:aeee with SMTP id af79cd13be357-8cbc8df0a40mr2321994585a.37.1772569123830;
        Tue, 03 Mar 2026 12:18:43 -0800 (PST)
Received: from localhost ([2a01:4b00:b703:c200:1ac0:4dff:fe39:5426])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-485133a933bsm21421905e9.14.2026.03.03.12.18.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Mar 2026 12:18:43 -0800 (PST)
From: Punit Agrawal <punit.agrawal@oss.qualcomm.com>
To: Ben Horgan <ben.horgan@arm.com>
Cc: amitsinght@marvell.com, baisheng.gao@unisoc.com,
        baolin.wang@linux.alibaba.com, carl@os.amperecomputing.com,
        dave.martin@arm.com, david@kernel.org, dfustini@baylibre.com,
        fenghuay@nvidia.com, gshan@redhat.com, james.morse@arm.com,
        jonathan.cameron@huawei.com, kobak@nvidia.com, lcherian@marvell.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        peternewman@google.com, punit.agrawal@oss.qualcomm.com,
        quic_jiles@quicinc.com, reinette.chatre@intel.com,
        rohit.mathew@arm.com, scott@os.amperecomputing.com,
        sdonthineni@nvidia.com, tan.shaopeng@fujitsu.com,
        xhao@linux.alibaba.com, catalin.marinas@arm.com, will@kernel.org,
        corbet@lwn.net, maz@kernel.org, oupton@kernel.org, joey.gouly@arm.com,
        suzuki.poulose@arm.com, kvmarm@lists.linux.dev, zengheng4@huawei.com,
        linux-doc@vger.kernel.org
Subject: Re: [PATCH v5 00/41] arm_mpam: Add KVM/arm64 and resctrl glue code
In-Reply-To: <20260224175720.2663924-1-ben.horgan@arm.com> (Ben Horgan's
	message of "Tue, 24 Feb 2026 17:56:39 +0000")
References: <20260224175720.2663924-1-ben.horgan@arm.com>
Date: Tue, 03 Mar 2026 20:18:42 +0000
Message-ID: <87y0k8r7j1.fsf@stealth>
User-Agent: Gnus/5.13 (Gnus v5.13)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain
X-Authority-Analysis: v=2.4 cv=M85A6iws c=1 sm=1 tr=0 ts=69a74224 cx=c_pps
 a=7E5Bxpl4vBhpaufnMqZlrw==:117 a=xqWC_Br6kY4A:10 a=Yq5XynenixoA:10
 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22
 a=yx91gb_oNiZeI1HMLzn7:22 a=7CQSdrXTAAAA:8 a=EUspDBNiAAAA:8
 a=kEJNvqoAXZf1GWF-TxsA:9 a=pJ04lnu7RYOZP9TFuWaZ:22 a=a-qgeE7W1pNrGK8U0ZQC:22
X-Proofpoint-GUID: xucZVGDXO6xQq9NIzWU_YiBsZn0zGONw
X-Proofpoint-ORIG-GUID: xucZVGDXO6xQq9NIzWU_YiBsZn0zGONw
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzAzMDE2NSBTYWx0ZWRfX316pWvAq3W8T
 YrwkZ+T/mt++SRdBONjkaCXoxZmAocWOP94k2q06/pL7ER8W7L/Ywc2kN7KJu7xLZVDVwy1qkeX
 zEVPsKzWXeqEBI02k9tb6kzPCmGF5jwlOacDc2RBdSO/xnJc3fE4QAnjJ/9icF+SCUw857TJcgc
 mOUOk8cqHMG0WEpcsAS6a+j6Eq2t3QhCdgqS9n9Dk73p0XJhsGQQUbEvr/HP7DbMmyQSscQWziJ
 X2PP8sJt8e8qYhTmRFnUjLmGtYarBVZnLZTIOEeNJQKRbG4iHccLk0Br2Wfn8CsbN39S+bV1Jzm
 JqqmsDRRrl83Z5bZS3yKmQ5cWioMKJe3L5f1UQgEcYO6COnuyL7Is3whKs1h3pxNaJgB0f/TlVu
 y4r4a3Zl2k1H2900zDAmxPi35qZ/TEWDQjaAZ4l91UPeiwxL4pvay5lwGpPsYfkpbvN7PHa4qZh
 vXyY58/XXTeHh/nWtqA==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-03_03,2026-03-03_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 suspectscore=0 spamscore=0 malwarescore=0 adultscore=0
 priorityscore=1501 impostorscore=0 bulkscore=0 lowpriorityscore=0
 clxscore=1011 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2602130000
 definitions=main-2603030165

Hi Ben,

Ben Horgan <ben.horgan@arm.com> writes:

> The main change in this version of the mpam missing pieces series is to
> update the cdp emulation to match the resctrl interface. L2 and L3
> resources can now enable cdp separately. Cdp can't be hidden correctly for
> memory bandwidth allocation, as max per partid can't be emulated with more
> partids, and so we hide this completely when cdp is enabled. There is a little
> restructuring and a few smaller changes.
>
> Changelogs in patches
>
> It would be great to get this series merged this cycle. For that we'll need
> more testing and reviewing. Thanks!
>
> From James' cover letter:
>
> This is the missing piece to make MPAM usable resctrl in user-space. This has
> shed its debugfs code and the read/write 'event configuration' for the monitors
> to make the series smaller.
>
> This adds the arch code and KVM support first. I anticipate the whole thing
> going via arm64, but if goes via tip instead, the an immutable branch with those
> patches should be easy to do.
>
> Generally the resctrl glue code works by picking what MPAM features it can expose
> from the MPAM drive, then configuring the structs that back the resctrl helpers.
> If your platform is sufficiently Xeon shaped, you should be able to get L2/L3 CPOR
> bitmaps exposed via resctrl. CSU counters work if they are on/after the L3. MBWU
> counters are considerably more hairy, and depend on hueristics around the topology,
> and a bunch of stuff trying to emulate ABMC.
> If it didn't pick what you wanted it to, please share the debug messages produced
> when enabling dynamic debug and booting with:
> | dyndbg="file mpam_resctrl.c +pl"
>
> I've not found a platform that can test all the behaviours around the monitors,
> so this is where I'd expect the most bugs.
>
> The MPAM spec that describes all the system and MMIO registers can be found here:
> https://developer.arm.com/documentation/ddi0598/db/?lang=en
> (Ignored the 'RETIRED' warning - that is just arm moving the documentation around.
>  This document has the best overview)
>
>
> Based on v7.0-rc1
>
> The series can be retrieved from:
> https://gitlab.arm.com/linux-arm/linux-bh.git mpam_resctrl_glue_v5

I booted with the series applied on an MPAM capable platform. The driver
is able to probe the L2 attached MSCs.

In terms of features, bit-mapped based cache portion partitioning works
as expected. The platform also supports additional controls (cache
capacity and priority partitioning) and monitors (memory bandwidth and
cache storage). The ones supported in MPAM driver probe OK but don't
seem to be exposed. E.g.,

    mpam:mpam_resctrl_pick_counters: class 2 is a cache but not the L3
    

It looks like some of it is due to an impedance mismatch with resctrl
expectations but hopefully we can get to it with the basics in-place.

Feel free to add

Tested-by: Punit Agrawal <punit.agrawal@oss.qualcomm.com>

Thanks,
Punit

