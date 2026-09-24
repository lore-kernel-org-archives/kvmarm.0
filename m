Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CE72486436
	for <kvmarm@lists.linux.dev>; Thu, 24 Sep 2026 16:57:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790269041; cv=none; b=fgq4B639cKLjwSjxb0nYsL5iyrtnyVgrtmPc+GF75Do684lAidLax41T8+1LPTVteN+dLdyKOz2ujPWMqZwKwfMtIucNPQNmd90Cxz/+GJj82mHRcqe1JTa7byZtTBU+eW00lGtlB7fHhWnr7MUvEFRmCMN0O6rcFMLbe41//yg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790269041; c=relaxed/simple;
	bh=Hzsp1UFzoC59Md1gxeOIU+2qNTd46IkSWC0K1qbvf6w=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=s9oEORD/uI2exqxe35eRqbwHlsDzg3OPAy2OVrPdPUKYmqJ/kfIkQp0F3TH3p67+UxoF1HsjZIZkuu+dLFq5DJq3SBjwQFwISk0BAfDoSG68BsGDAQARJ8TcvSK8ELYroOiGuGFzuWLkfary7+VcSxlmcYNVXny3z8egOrRN+R8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=pMi043bE; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=hztw/1vB; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="pMi043bE";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="hztw/1vB"
Received: from pps.filterd (m0279863.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68OFfX1d2757850
	for <kvmarm@lists.linux.dev>; Thu, 24 Sep 2026 16:57:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	M8tOw3w9WOlBwac6L5boAJMWocybycmH2cMyGQykxKE=; b=pMi043bE6QGr1lII
	pZb0IyUUMlzTpHxw6zL3pxwMkGK8zJVP5wf0pJMCdoiBDmqx+axCDSvvbSt23IG+
	BXfrMC1Wk6A8fjtC5jzeO6bz4MdM8/VtpzpX5o5gQfB8x/IaQ8q666ePw+XLT9jY
	hN4i54agbS8Ri8oQRajPAwr8WtpfK2LI6h4DcFh427uEJSvVII/M1WCRWYDpOEF/
	B+o+xUmeg8peBe8ZjmHPFWGCZMUcUluWBmV5cZiAO5OaeKNYVATURT3c9sJwbHjx
	sxtv395HGmucKB5F44AWHi/W2FjQSSkoJZWovi/F9mNyWsryNblI5zIHqqEqpQPI
	dx6LCw==
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com [209.85.216.72])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4gvx8ajtcc-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <kvmarm@lists.linux.dev>; Thu, 24 Sep 2026 16:57:19 +0000 (GMT)
Received: by mail-pj1-f72.google.com with SMTP id 98e67ed59e1d1-398dcfabbf8so212627a91.0
        for <kvmarm@lists.linux.dev>; Thu, 24 Sep 2026 09:57:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1790269039; x=1790873839; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:mime-version:organization
         :references:in-reply-to:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=M8tOw3w9WOlBwac6L5boAJMWocybycmH2cMyGQykxKE=;
        b=hztw/1vBwptyZnSbua3Shv2776tZJUO+AvWCLIcPAPcvI4NxP/oVCpszezgrJn7I4h
         3algw9LzOMOU2Iy0XAlHYIo80kDe+WIWJi0kEpSLNYNNsTe9XXdptCoaMv8RzW5ynob9
         olygTG98uPIRyMIp1yqpW7u5dXJ5QKqVEIHa01bRLfxbk5dQswoBDbrspNCBvkTxRMeS
         M0lmuYk7YkZfVXsk5lECol5k20Hu480MZIvjMK+OmvpZ/taPmwKMJVnHj210bkGV2sSj
         aBnuzZU7aRuAhCw4EB4MppM7Ka4y66CVUyDZ6kjo3BqUWiKAdEmO/zmBDJIDfEgsWOu3
         J7Ag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790269039; x=1790873839;
        h=content-transfer-encoding:content-type:mime-version:organization
         :references:in-reply-to:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=M8tOw3w9WOlBwac6L5boAJMWocybycmH2cMyGQykxKE=;
        b=VsyLlb8lIhvO9YS54b6BmRZVaZDTeGY+QGYgFccloSpXlXmYSwm4gJ/5N5MIHGenZD
         TzCNUXDBoGnm+XP8/bkIyQKHPgWddW/d5wzrHdPDEpUCHoK9mT5N6O1H2E4pKfyGQ6ho
         E6+SX99sxaFpQfTtwTtPpgmsXb4lRhg3lT9/GjM0dGTlVPRnb8lqr47vHwDZqzEMlXwj
         2r2LPiWcEmATnQZookcHdnVvi5lCPTF47g63moVKQo9uzMj/GoSx9hWvjxHurWQNio6e
         35dj8ExawSypgOHV5TtzzgmMOLAJlpDuhQDONutu/yO2uL9fJu/LiwAt0pXCBLnJRDWc
         Br4g==
X-Forwarded-Encrypted: i=1; AKwUvBzTixHydWXpxnSXo74r/dRvKMZ/zDWSpK26WVNu1Jfu6RqP+h8zd8FmszV62nfaRNBMPGU93G0=@lists.linux.dev
X-Gm-Message-State: AFuF++kmLKHSOt+2WAwntBGmckhYSGw+/XF8uA7yFbgrhVdZ1pmelm1c
	Wa2Yri9G1excBGlm3zOBXI/VhFvxYFs8h2HcGnIX9ENXB/eQj7DTkKPwcTRArCp01xabUUqOJCQ
	QmPH3Fsb0LayYitvcuiC60r4HpqUbSs2KwU1Df5Ogj3BdRGHinxRuFfoSQ+Y=
X-Gm-Gg: AYBFou0PygLalVp5x/XieCOg6R99kreeYUBTO1LGF+KetFo1df6D50SJEA39DQHvfUs
	N3ES8OmcJ3AqSC4orO936V/DjXX5PtAILYBryKv39Wyxt9tLjYLCj0CHyMPlaHb55WEy+CsmUSi
	0aW91Uigg7OYjDg9vVDBmPK3EcbOUpjYPSfNl1f+hE2KjrExpGO88vhbHVMw880MmysUqLdfzAS
	H0+0k5ZlotSIbwvi996sKZBBIafKh/CP4DDoj8BhYtM1lyf0LNF9EdO4ybcNEMKU1FJsoAoXh9p
	tDoGPZ/Yji7cwbBG1rsthEO68P6lh4gIWgkERL6r6TQkVpCo7qhwAKOz35HQBK1PS4Wv2flrs23
	cVHvrJ98E8iyfhjotegLMSvSKbaIjyGbKbpeHF85BWWb+QoPXRBNgmw==
X-Received: by 2002:a17:90b:3c0f:b0:39d:eda9:febf with SMTP id 98e67ed59e1d1-3a098da4171mr3197723a91.18.1790269038418;
        Thu, 24 Sep 2026 09:57:18 -0700 (PDT)
X-Received: by 2002:a17:90b:3c0f:b0:39d:eda9:febf with SMTP id 98e67ed59e1d1-3a098da4171mr3197707a91.18.1790269037987;
        Thu, 24 Sep 2026 09:57:17 -0700 (PDT)
Received: from localhost (i-global254.qualcomm.com. [199.106.103.254])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3a0976cacbesm5687417a91.13.2026.09.24.09.57.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Sep 2026 09:57:17 -0700 (PDT)
Date: Thu, 24 Sep 2026 09:57:12 -0700
From: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
To: Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev, maz@kernel.org,
        will@kernel.org, catalin.marinas@arm.com, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, steven.price@arm.com,
        aneesh.kumar@kernel.org, oupton@kernel.org, gshan@redhat.com,
        joey.gouly@arm.com, tabba@google.com, yuzenghui@huawei.com,
        linux-coco@lists.linux.dev, gankulkarni@os.amperecomputing.com,
        sdonthineni@nvidia.com, alpergun@google.com, fj0570is@fujitsu.com,
        WeiLin.Chang@arm.com, lpieralisi@kernel.org, enju.kohei@fujitsu.com,
        sudeep.holla@arm.com
Subject: Re: [PATCH v19 1/7] firmware: arm_rmm: Add SMC definitions for
 calling the RMM
Message-ID: <20260924095712.00004057@oss.qualcomm.com>
In-Reply-To: <20260924135201.850038-2-suzuki.poulose@arm.com>
References: <20260924135201.850038-1-suzuki.poulose@arm.com>
	<20260924135201.850038-2-suzuki.poulose@arm.com>
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
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTI0MDA2OSBTYWx0ZWRfX9nZxa9nw47Gd
 2IlcUhlVUYJ0W9rNpHhSOSUaDUmrK/poZoTcmfuBdOBx97By3inewnY/uyiPB7kFldHBR7pUKNs
 cvxV/NbTL2CXVuXIYsIFw4ovCbOaZeM=
X-Proofpoint-ORIG-GUID: Y3Au363DVnh9S7p0H_5bUFyBT3DnICqz
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTI0MDA2OSBTYWx0ZWRfX8J8wiVfRtPR4
 uet6hF84wvXe4T0qOgs3sb3qMAGPtDfXcODcvQRiD5txVj6/qEQTMm05rM1C5qIXROL1u4N4k1s
 Y3QZWPooB0PrB1BIGlia9lNOTX7D5ArZUiJ2lYpG2jKFb+D3I9IruB6e6cFPgeWM7t6tEDSQTsy
 l25u1EXYJ3Iffh4GA0qqMM23Kq+SSzAVp4lyvKvFObrIoqqqoLf3xyfmzyyZOxorXZ8z5Uso1J6
 gBm2R0aNy9Y52UZwXab6ZG6zsWL8O4mic2azIrm8/deYMHLzu/ct6Myje5Cd+9n7Cbd3bcyHbe0
 ulmW7k+6gm/g77k1JfL45Vy356Ef+N6k52zf4n9ai/c7+hyZ6sinjlm0rxg19QciYRMNTDAmaw+
 Ti9SikgGknNQnTs0dVMYMt26XdRrsk1kHKUBlDtf3u5dwQ+Cwe3mzip6JjF1Sl5se5lWiZ1TnaS
 ar0xmXQCTR3EjfuCGUg==
X-Authority-Analysis: v=2.4 cv=a6SlZkSF c=1 sm=1 tr=0 ts=6ab5566f cx=c_pps
 a=RP+M6JBNLl+fLTcSJhASfg==:117 a=JYp8KDb2vCoCEuGobkYCKw==:17
 a=kj9zAlcOel0A:10 a=VdqzKS8jKosA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=yOCtJkima9RkubShWh1s:22
 a=7CQSdrXTAAAA:8 a=VwQbUJbxAAAA:8 a=20KFwNOVAAAA:8 a=EUspDBNiAAAA:8
 a=SeLr52ClSpxFPvFle8UA:9 a=CjuIK1q_8ugA:10 a=iS9zxrgQBfv6-_F4QbHw:22
 a=a-qgeE7W1pNrGK8U0ZQC:22
X-Proofpoint-GUID: Y3Au363DVnh9S7p0H_5bUFyBT3DnICqz
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-24_04,2026-09-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 bulkscore=0 spamscore=0 clxscore=1015 malwarescore=0
 priorityscore=1501 impostorscore=0 phishscore=0 lowpriorityscore=0
 adultscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2609040000
 definitions=main-2609240069

On Thu, 24 Sep 2026 14:51:55 +0100
Suzuki K Poulose <suzuki.poulose@arm.com> wrote:

> From: Steven Price <steven.price@arm.com>
> 
> The RMM (Realm Management Monitor) provides functionality that can be
> accessed by SMC calls from the host.
> 
> The SMC definitions are based on DEN0137[1] version 2.0-bet3
> 
> [1] https://developer.arm.com/documentation/den0137/2-0bet3/
> 
> Reviewed-by: Gavin Shan <gshan@redhat.com>
> Signed-off-by: Steven Price <steven.price@arm.com>
> Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>

Hi Suzuki,

One small thing I didn't really care about but where I thought you
said you were going to tweak things.

Either way
Reviewed-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>

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

I thought plan was to fold into the padding above?

https://lore.kernel.org/all/d7ccaf22-5bde-4344-8bf0-a5a17dcac0f3@arm.com/

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


