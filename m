Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 360A54A6888
	for <kvmarm@lists.linux.dev>; Tue, 22 Sep 2026 19:40:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790106043; cv=none; b=JMJrXH05C3YYGVPOTDmiIGaPyoQIp6x96MmcE89aFB700qgAedZnZGMyzXdMpmjSij56gydWtm3JpSzZWsm/Y5LJB6F5GZ0vLsKbJ5JLF4CSaIXi7ePOBWAFmspKmyHjhqFpHDcIOVpdrYEKZebsCKTgPQQNzZrj7Teju3op7Nw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790106043; c=relaxed/simple;
	bh=VfZhuL2X1gTRZxO0OzhM4JExH2t49JX4CNGTbuUaWiA=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=DWq7zOiLAc1EYcNaysvDoG2c7X6dxrHyWTbMwSd/WswJ6iPRBEQ3KrS1WQ014TjANEiywr9z/XRfz4h9fpMzLgx6ebuO9wO0iq2alxt67afYqIoWtdhbmhu0mQW6X1VW2rPTYizMrn3tbk3Ye22LdswkS1JsYmnnJm2cKi73mJ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=MCpZrl2X; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=N50xYz4x; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="MCpZrl2X";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="N50xYz4x"
Received: from pps.filterd (m0279869.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68MI72u31348884
	for <kvmarm@lists.linux.dev>; Tue, 22 Sep 2026 19:40:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	isSEF0IU9c1OXuHxBNGq9pSATtA3AQIYhgVBzOHtvqs=; b=MCpZrl2XliLUV5m+
	AwX/zkHOD/sII1crCEGtG2U/jgpLCl9R5xl7SrsC9BMPS8yupRZaRWKjoSPcfPr1
	G+zk8nVeK5HU3gGbbimKtGhjfcB7JoInF0tNJb+6FNetlQpNQBt5qKW7rHavrjBQ
	kng7Ib17Sxzb4DCO4X0lKQv7HIR0DRlKG41W9jQGC1kpLBZfLxU36+a0/t6N+XvA
	kx3fALA9mTbiRnv0fp89c0relqYJ1KxDBP1EpWE4H4FCFMukDUHfMMSyo/UcI5jZ
	ylDWRa5BwwCWg2GQvwmoLWMtT+zUqPbUTBsfFLPwAt3NMJG1jsSw6iLmigngpwMP
	wU2fSQ==
Received: from mail-dy1-f198.google.com (mail-dy1-f198.google.com [74.125.82.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4gux860mt4-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <kvmarm@lists.linux.dev>; Tue, 22 Sep 2026 19:40:40 +0000 (GMT)
Received: by mail-dy1-f198.google.com with SMTP id 5a478bee46e88-33310847fcaso232669eec.1
        for <kvmarm@lists.linux.dev>; Tue, 22 Sep 2026 12:40:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1790106040; x=1790710840; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:mime-version:organization
         :references:in-reply-to:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=isSEF0IU9c1OXuHxBNGq9pSATtA3AQIYhgVBzOHtvqs=;
        b=N50xYz4xnFk3L64a+eWLc5MRBJPv2639FB7ZuZngCxg3ZzjxTV/f18ZvF/SYUxrPRX
         m5NtFnZ2hJWQwPdCEZu2yBDSx0RUqCMjeOVGUC5Ti9BGCsnZ6cXG2RBh0o5VY5XIG6Kn
         Han9IJgcI8aLbS7OIuY03b7i2xLKJjmhdHF32QOtGKGYrVHLxCOuh2CTyHX1z2c7a2B/
         h1zNz79++3uLancRxzc4D26Sl7orHlhRwUmuWPqaIenaPf8glWR8prnnOj1MSpiuO+Xz
         oUZGBn6r1EdmmNc6PMDQzq7DLvebW1zyMG1FnApluxUMbie2wjcuEh22UVTgLrZm2fY3
         mPDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790106040; x=1790710840;
        h=content-transfer-encoding:content-type:mime-version:organization
         :references:in-reply-to:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=isSEF0IU9c1OXuHxBNGq9pSATtA3AQIYhgVBzOHtvqs=;
        b=SPMvLvFARmD8NApjKkBH0LSXV4DwNw/jcDgwuGK01MLJWQwFPNAF2v+ry3DhkEN0Hy
         5Tqp6GUyIKtRAbD1YLIAUWazZOZaR079V1yT41OGW+1zYFxc8XNRSHbuyY9A1u6TIy99
         LrXhyBTp63N51aKc+t8YOw3ReS+fb8aCSd9F2dUNNA3rNSZvpW4923qbnOY2TBXazwpF
         9/o0zsSg3V0DpEdbjZcKWVQMtg6222CFzNbYsM7bF3LSIv7bjtesp2PZEMaSYkXZvQCr
         5TvWi6+ImtCVsD0iTHy4iHcvv9Avo9pVOdo6wqmM+UzyLrXfxyKNQsM9iYRal53cmetF
         7JcA==
X-Forwarded-Encrypted: i=1; AKwUvBy+2KoisHk+kKKpDa7ohe0rnIYt0/VMMKeVL940AzA3XNCMohPQ3ujW036VpcnTIbRp409sUGM=@lists.linux.dev
X-Gm-Message-State: AFuF++kMHUtXTHlIAN8pkYP1CnrkotBuUhqzxICRqhjxSKmmyhPybJGy
	On317X/gvnLxrYNp2/LupeQN58UBWLjor5l1MRhAKn8NDTOCe2iH+6PvZ1uJPRUl6+oYWBOmGxx
	/qGJukwlvwdttv0WJ1NoVSVjLy5L5CMSBRZAQ0AIfXtPg6506jx99ZP58NWY=
X-Gm-Gg: AYBFou1mfrm40ebxKdBAxfEUqdsO0gF4eiX6r3gyxwZ3Xa4KJpYRXloaIP6/egG0Hz1
	rVs2WryVrSIU0SBbkCWBq2fcjG/8R2N+CE0xDTVwfbFv2AU91JwlN40ULDKhBRU/IA8Xis+oeR2
	fIYp9LpCxtScvGIvMdWC2t96FYTPachRsjvxCH90MWGXn25HUmtejTSrvLVsca3+kjipirvMwyW
	YEcAkPcp1nVWAkJpiZOQefN71sqHzjVyoJ0w+b1zxtZ8ul4zKiOBkiciepwTMmSrBod3mCCNg4u
	KXvH96IOmB6hTZd0dRpZS3moZ5ZCcpZIWy1+P1w4blGd1GY/CUkA/s+En+ag/BVh0C4XahFAWM2
	4wDMdABDDKCOa1AHteqfbxkWaX2fcyLM6AG8kbBYJ4x8ZEAU08Qz4Sg==
X-Received: by 2002:a05:693c:83c3:10b0:33b:e842:c0ff with SMTP id 5a478bee46e88-33e88b2f9cemr356541eec.0.1790106039608;
        Tue, 22 Sep 2026 12:40:39 -0700 (PDT)
X-Received: by 2002:a05:693c:83c3:10b0:33b:e842:c0ff with SMTP id 5a478bee46e88-33e88b2f9cemr356508eec.0.1790106038976;
        Tue, 22 Sep 2026 12:40:38 -0700 (PDT)
Received: from localhost (i-global254.qualcomm.com. [199.106.103.254])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-33e95c7c63bsm412187eec.10.2026.09.22.12.40.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Sep 2026 12:40:38 -0700 (PDT)
Date: Tue, 22 Sep 2026 12:40:33 -0700
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
Subject: Re: [PATCH v19 05/20] KVM: arm64: Track the type of VM in kvm_arch
Message-ID: <20260922123928.0000443e@oss.qualcomm.com>
In-Reply-To: <20260920212845.707-6-suzuki.poulose@arm.com>
References: <20260920212845.707-1-suzuki.poulose@arm.com>
	<20260920212845.707-6-suzuki.poulose@arm.com>
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
X-Proofpoint-GUID: FNKCY1wMbqSTt3nqLbBhwTKNqN6O1gUH
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTIyMDI4OCBTYWx0ZWRfX1SHglEBqzX9o
 B5btnxz1lIEydbN4GGsCiiu+LPVZ11VPX/8UgsY8kyzqZ/4ufzmB75j8rLsRBb466Tmb+kIp8c+
 Jt4ShztysgKmjukA5RzmOy/875YOD5A=
X-Proofpoint-ORIG-GUID: FNKCY1wMbqSTt3nqLbBhwTKNqN6O1gUH
X-Authority-Analysis: v=2.4 cv=eIOGH3p1 c=1 sm=1 tr=0 ts=6ab2d9b8 cx=c_pps
 a=wEP8DlPgTf/vqF+yE6f9lg==:117 a=JYp8KDb2vCoCEuGobkYCKw==:17
 a=kj9zAlcOel0A:10 a=VdqzKS8jKosA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=_glEPmIy2e8OvE2BGh3C:22
 a=7CQSdrXTAAAA:8 a=VwQbUJbxAAAA:8 a=EUspDBNiAAAA:8 a=Rj_uqbnfv5dchc8eNrcA:9
 a=CjuIK1q_8ugA:10 a=bBxd6f-gb0O0v-kibOvt:22 a=a-qgeE7W1pNrGK8U0ZQC:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTIyMDI4OCBTYWx0ZWRfX8PuS2uP7lJ5F
 X650wl9wBo1UJwch2p9nMP2k0dmc6sZR4L0jD22MbS7gIdLxKeOVOYdf5eYjQzmQfFUSHGZ/eEP
 IVR1bB1G+eqlG+q0HqGB2TOxqf0zgEZyMH/tpm9oNc3v1zi3K4kE35HY6wiJVcATfafsQ7vSZNS
 zWxSfzozzUB8RsjZmuQY3GW6JkC4aMd5opGApSPOLCrHki1xRVMvvD1MIT3yA145BtbjDHE3+h1
 SGimcL65uVIf7V2zk699mY82yceRKmJ7+8hs8FoOmnit+LIaoQWnUiHNBK1gXg7LzClOFMw8VcU
 Mb2pSqcrG993KEttKL9OmTCXBgYvxVC5Z0EucZN1jbAWSVJukHmexnhHRw8EwLFJndATXiTn3QA
 M4qBHuWc6HC54juSl4PI/sTZuiXB89fwEvA48qPOc3l8gAmPLUaqJEF5gdH09ABQziT6QCcNn9P
 /x1PMLzhEWOB0ggfzLA==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-22_03,2026-09-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 bulkscore=0 malwarescore=0 spamscore=0 lowpriorityscore=0
 phishscore=0 clxscore=1015 priorityscore=1501 suspectscore=0 adultscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2609220288

On Sun, 20 Sep 2026 22:28:30 +0100
Suzuki K Poulose <suzuki.poulose@arm.com> wrote:

> KVM arm64 has different types of VMs with all the different modes in which
> the hypervisor code can be run. e.g., VHE, nVHE, pKVM etc. Then there is
> protected VM and normal VMs with pKVM. We might soon add other types,
> e.g., Arm CCA Realm.

Let's have some optimism!  


> 
> Realms support is restricted to VHE host and thus "kvm_vm_is_protected()"
> checks in the pkvm hyp specific code doesn't need to change, as the only
> protected guests it deals with is "protected pKVM" guests. To tighten this
> init_pkvm_hyp_vm() restricts the hyp copy of the vm_flavor to the ones it
> supports.
> 
> Suggested-by: Marc Zyngier <maz@kernel.org>
> Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>

Seems sensible to me.  One trivial thing inline.
Reviewed-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>

> ---
>  arch/arm64/include/asm/kvm_host.h | 22 +++++++++++++++++++---
>  arch/arm64/include/asm/kvm_pkvm.h |  4 ++--
>  arch/arm64/kvm/arm.c              | 31 ++++++++++++++++++++++++++-----
>  arch/arm64/kvm/handle_exit.c      |  2 +-
>  arch/arm64/kvm/hyp/nvhe/pkvm.c    |  6 +++++-
>  arch/arm64/kvm/mmu.c              |  2 +-
>  arch/arm64/kvm/pkvm.c             |  6 ++----
>  7 files changed, 56 insertions(+), 17 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index 286489a69dff5..9b1cf9c59e81f 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -257,7 +257,6 @@ struct kvm_protected_vm {
>  	pkvm_handle_t handle;
>  	struct kvm_hyp_memcache teardown_mc;
>  	struct kvm_hyp_memcache stage2_teardown_mc;
> -	bool is_protected;
>  	bool is_created;
>  
>  	/*
> @@ -306,9 +305,19 @@ enum fgt_group_id {
>  	__NR_FGT_GROUP_IDS__
>  };
>  
> +enum kvm_arm_vm_flavor {
> +	VM_NVHE,
> +	VM_VHE,
> +	VM_PKVM,		/* Normal guests on pKVM */
> +	MARKER(__VM_PROTECTED),
> +	VM_PROTECTED_PKVM,	/* Protected VM */
> +	VM_FLAVOR_MAX,
Trivial but given whole point is this is an end marker, drop the
trailing ,  No point in making it easy to break the ordering!

> +};
> +
