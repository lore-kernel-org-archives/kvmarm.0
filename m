Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E71B93B2FF6
	for <kvmarm@lists.linux.dev>; Wed, 23 Sep 2026 16:54:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790182494; cv=none; b=h7AbfcRmrJX/L1oTwtsWnyEjD3D+zdhkK8cNJVzKnbt4fHe9VSB3Boe0EKfS1+5r1BCvD6KoihUF4d4GEgEPLegS6cWa2CH/a59F6MkzC1PvlKaFNHjXFBZnBRPcADAh2+9+Ef3m9dRWPG/dGu0njn7/IWD1zzqGPnNfkd9GU9Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790182494; c=relaxed/simple;
	bh=VrlzXIxy8Fp+qeOGPoQZqyU4YzmW9HF543x3NzyMjfA=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=OR7c0uTFwNFdpSBkHUoVsyOYBNTNUJ9QBjdylRoDUS5qDaX6GcTlULvSMtRuNhnaF9xCeZ8aOx3lTs06JAFCoEB9zVu0Uyn7mPxiSrm0PtaBupacgxUhTEsP42ZW4bS/Pg+GI01VNtgZeqEJH4DOZCn9jsiZ32hD6Gg9kpBu+Pc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=Seum9zPq; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=dfae8/xH; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="Seum9zPq";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="dfae8/xH"
Received: from pps.filterd (m0279862.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68NGUL0B3281524
	for <kvmarm@lists.linux.dev>; Wed, 23 Sep 2026 16:54:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	zlDwEtbUvjpRubwATEGCqUpsne2yYQHkp6iqY3VINLE=; b=Seum9zPqFF1bAFs9
	2SAgWuOtEzV4WMAmZskMjMP9xFgcocCq5t/P4Btc3uXm/yPP+5dFmh5MvrsC6Woe
	cL0t9T8Uk0hJD7dxIFSFHKlwoz8kF0IlCF4G+vCAYHnQ5iI/2KTdeJcGSx2awi+g
	zRh0sCoZKCovDiw8hhNMIlveeyEBS1Vj1OLdNgsBWkZcIG4Bx1Im5Y0tYnE2BZgY
	80heXHTTt8VxnPYBz3mzkSgrfEctt7TgufuAh5IddJeFRDHIZOHddDlWhucY9Wj/
	WeQF9cQwlA6a6DWFbbrnt6l8QhQDXPVALVsLhoBblQDFI7hp0SxbGW7fL6jVBLnP
	KHIFfw==
Received: from mail-pg1-f197.google.com (mail-pg1-f197.google.com [209.85.215.197])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4gv9bqjqub-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <kvmarm@lists.linux.dev>; Wed, 23 Sep 2026 16:54:52 +0000 (GMT)
Received: by mail-pg1-f197.google.com with SMTP id 41be03b00d2f7-cc4e496e5c3so685428a12.0
        for <kvmarm@lists.linux.dev>; Wed, 23 Sep 2026 09:54:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1790182489; x=1790787289; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:mime-version:organization
         :references:in-reply-to:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=zlDwEtbUvjpRubwATEGCqUpsne2yYQHkp6iqY3VINLE=;
        b=dfae8/xHEtXBlV1q+JYLbS7guFqigXImSb29vRsgk84vdb0dDif7v42J0dUTJ+1aEq
         agfzSUxuqUYVUmb3QNkeJH/12lWuzu1wH+D3YlQwicap9fJCR0i/d2vTUOCofHuJpM+b
         3g4ZNdVrfJeqJSiGLX7KwYfM9P8mhF0XX0yJbY1yhEq3sa4kJmQvyX1Pphy4gF8zB+tg
         n2+Pf9KFmyMmYdOW69etacRpmVAO3zPRwDpRtTA4B5b+q/MXKoiu3g/zdMHsmDHnNI37
         PoCWCg4CSMvYSvNVoUl7VwbDbeegeLPymfZFK0Sqe22sEwQVzxTHDbC3ZAiOnTE+pnFA
         YnTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790182489; x=1790787289;
        h=content-transfer-encoding:content-type:mime-version:organization
         :references:in-reply-to:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=zlDwEtbUvjpRubwATEGCqUpsne2yYQHkp6iqY3VINLE=;
        b=YmvDxwzqijATYg8qbozwmcLNorfvkgouQ/qklpTkjuRq+asMXzxvhYudVtp/QNv/yf
         JV0vQsG8CId2BxevEsQZbUvmCu8Xstd8AhxXhT7fElYs/cJbWPGyCJkTDLpn32nvRMsD
         eVKGcrrOvB8t6xtfRayO2S/0O2+HhL/Skb+wEhP3aSBSTdv+iYZrubVmIbXbo+XbsKyZ
         M45791YzIzjc9dNxA6FUnczu43YtXac3uM1VR50eRzg0/9mgKr+2yVStcI1aQw7E1qAJ
         J4eCEixLOz2L1fHNcoXLbKPCgY6zBiSyr0oo8SKy8Ha0cYNhd4C/tgadaO8wlmP8JIwP
         ygEg==
X-Forwarded-Encrypted: i=1; AKwUvBxjXnj/ccAryWoa89ovlmTDtSJAs4mtIiSAhUvDEm72zD733liv8Shc3aQs94k5sAe3CrI7b24=@lists.linux.dev
X-Gm-Message-State: AFuF++lR6H5Wa7yZQr4Rwzfy7DDywJgzSkjzlXvl5BCaP7aBNbpbvD7Y
	lgswgCRiehyVwoan8Ay/INU03RRVvX6WQGuVfnEdbJNZO6E4Vc99MteaOqrCsRmdPb+0JzKBSKn
	XGfwucA7Y36eiol2wXL7S72p5NUmFG1dwOiyDi2D6ZhhCsTYC83IrYJJmasM=
X-Gm-Gg: AYBFou1Szr/aGqpylAR5IvM8vX+UNQW3vhMLASPN1+mIEQa7QEJQGMU5z8nIhnPA+57
	arAOgi+2FOWKyl6zWu4cSXj9ABy1hUqZNSAA4QRJ0gT/xGZ7hp9YtQDxP7H0CxWdYRB/aLLsjMK
	MWPNYLZcjYnA/GIXhCE95Q5FISWAKza3oLOiWLPlCp25kMfik3Bjl4EjTqkiiOhd5f0q2j0XXmC
	y36+FuDLAI5OetDONjEDaYUB0Y+/s0w9T88gKqk0UEL5Ft2lOMcr/JAiFrPt7dm9Lf7LnsftTjG
	YeEJFhZnOju5De+CNoJuMUVjOQ8wEYpmB8E3ngcPXmfFTlGjiMX0f1s8bLHiEhvF77pw1jDYQKt
	eSxMjqyncoljSaao6onxa5BLm4s3Y7UBbvx0RJazVErEB43rZG/Ivp5ni1BGg4T5d+g==
X-Received: by 2002:a17:902:f549:b0:2da:eb8f:b4e4 with SMTP id d9443c01a7336-2df69d261dfmr29630295ad.7.1790182489347;
        Wed, 23 Sep 2026 09:54:49 -0700 (PDT)
X-Received: by 2002:a17:902:f549:b0:2da:eb8f:b4e4 with SMTP id d9443c01a7336-2df69d261dfmr29630075ad.7.1790182488834;
        Wed, 23 Sep 2026 09:54:48 -0700 (PDT)
Received: from localhost (i-global254.qualcomm.com. [199.106.103.254])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2df6a5f4219sm14535985ad.68.2026.09.23.09.54.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Sep 2026 09:54:48 -0700 (PDT)
Date: Wed, 23 Sep 2026 09:54:43 -0700
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
Subject: Re: [PATCH v19 09/20] KVM: arm64: Add VM specific callback for S2
 MMU operations
Message-ID: <20260923095443.0000378c@oss.qualcomm.com>
In-Reply-To: <0d5201f0-359e-4748-92da-946dedf51bcf@arm.com>
References: <20260920212845.707-1-suzuki.poulose@arm.com>
	<20260920212845.707-10-suzuki.poulose@arm.com>
	<20260922152914.00001221@oss.qualcomm.com>
	<0d5201f0-359e-4748-92da-946dedf51bcf@arm.com>
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
X-Proofpoint-GUID: ZP4hs9PVUy9QwJfyxzqtTAcIC96Yf-j6
X-Proofpoint-ORIG-GUID: ZP4hs9PVUy9QwJfyxzqtTAcIC96Yf-j6
X-Authority-Analysis: v=2.4 cv=WZuZ+EhX c=1 sm=1 tr=0 ts=6ab4045c cx=c_pps
 a=rz3CxIlbcmazkYymdCej/Q==:117 a=JYp8KDb2vCoCEuGobkYCKw==:17
 a=kj9zAlcOel0A:10 a=VdqzKS8jKosA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=_K5XuSEh1TEqbUxoQ0s3:22
 a=7CQSdrXTAAAA:8 a=EUspDBNiAAAA:8 a=OqzaOk1-375Rtnrp2FUA:9 a=CjuIK1q_8ugA:10
 a=bFCP_H2QrGi7Okbo017w:22 a=a-qgeE7W1pNrGK8U0ZQC:22
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTIzMDA2NyBTYWx0ZWRfX1Si8noV+g8aE
 h4maX+q2MNJ6uB2eM9S1HR5T1vdLCIOGTCntm/vLtI8HvQvuiNy8Ye+dyewK+CnnWUyPJ0HsVBK
 phikmoPZQRvSs/LBkV5kxidvlwvxSqo=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTIzMDA2NyBTYWx0ZWRfX3SNcxc3/zwLE
 pfcluS2rWGFFcB5L6JU+L40bmWeelAbNHtMyCCMsEtKCwTBn+DyfX7IBoZljow5H7EuXud6hu3E
 FjNkoaA7YKDt/AomlR/9w+0A0nmuXLfiI4w6c6XcIdFvMgqz5M1Xj/7eG82tsyKqmFVXCAQsltI
 zXSiwoR2ya53kPavfUFhF2TqIFhWjfguL4YkNXDxhAEy77FilAEMbtoltx5SnDQHD+/9HCK6mpN
 NIyPMKwTEXZ/7SFvQll+zPxQXQX8gbmsNdNrab/JHQAAIzKCqsVLvOf5QR2JUQXzliyMsnLgnXb
 QgwJo33wiILIkpxV8e4p64wTsPHp2DPxF2VO/qYHGet9EpgSxnKN7tYS8b4c8b1Abynx9i1mx2J
 puocN0c1zpri4O71eBW/Li0SFsodC1eHohIgWMoPEIvgrcImxE+FdWkups4keav26WlAIfKJ0Ep
 ceRIv5XrAYAG+AT4PVQ==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-23_06,2026-09-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 malwarescore=0 lowpriorityscore=0 adultscore=0 priorityscore=1501
 suspectscore=0 clxscore=1015 impostorscore=0 phishscore=0 spamscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2609230067

On Wed, 23 Sep 2026 00:21:58 +0100
Suzuki K Poulose <suzuki.poulose@arm.com> wrote:

> On 22/09/2026 23:29, Jonathan Cameron wrote:
> > On Sun, 20 Sep 2026 22:28:34 +0100
> > Suzuki K Poulose <suzuki.poulose@arm.com> wrote:
> >   
> >> Add VM type specific S2 MMU operation backends which can be initialized per
> >> VM flavor, to keep the handling cleaner.
> >>
> >> Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>  
> > 
> > A small suggestion inline that makes it explicit when there isn't
> > range operation and a full flush of tlb is needed.
> > 
> > I don't mind either way, but thought I'd mention it anyway in case
> > you hadn't already dismissed it.
> > 
> > Reviewed-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
> > 
> >   
> >> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> >> index 03f2017a7404a..d97a4a1bca23f 100644
> >> --- a/arch/arm64/kvm/mmu.c
> >> +++ b/arch/arm64/kvm/mmu.c
> >> @@ -37,6 +37,8 @@ static unsigned long __ro_after_init io_map_base;
> >>   
> >>   #define KVM_PGT_FN(fn)		(!is_protected_kvm_enabled() ? fn : p ## fn)
> >>     
> >   
> >>   /**
> >>    * kvm_arch_flush_remote_tlbs() - flush all VM TLB entries for v7/8
> >>    * @kvm:	pointer to kvm structure.
> >> @@ -174,26 +188,36 @@ static bool memslot_is_logging(struct kvm_memory_slot *memslot)
> >>    */
> >>   int kvm_arch_flush_remote_tlbs(struct kvm *kvm)
> >>   {
> >> -	if (is_protected_kvm_enabled())
> >> -		kvm_call_hyp_nvhe(__pkvm_tlb_flush_vmid, kvm->arch.pkvm.handle);
> >> -	else
> >> -		kvm_call_hyp(__kvm_tlb_flush_vmid, &kvm->arch.mmu);
> >> -	return 0;
> >> +	if (!kvm->arch.vm_s2_ops->vm_flush_remote_tlbs)
> >> +		return 1;  
> > 
> > For consistency with other cases and because it looks nicer
> > blank line here.  
> 
> Ack
> 
> >   
> >> +	return kvm->arch.vm_s2_ops->vm_flush_remote_tlbs(kvm);
> >>   }
> >>   
> >> -int kvm_arch_flush_remote_tlbs_range(struct kvm *kvm,
> >> -				      gfn_t gfn, u64 nr_pages)
> >> +static int pkvm_flush_remote_tlbs_range(struct kvm *kvm,
> >> +					gfn_t gfn, u64 nr_pages)
> >> +{
> >> +	return pkvm_flush_remote_tlbs(kvm);  
> > 
> > For the cases where there isn't a range call, perhaps you should just
> > not provide the op and have the wrapper fall back to
> > calling the 'flush all' variant if there is no range one available?  
> 
> The core KVM falls back to flushing all TLBs if the range one
> returns true anyways. So, I would leave it as it is.

That sounds like a reason to stub them to return true always rather
than call the flush all so we don't have fallbacks added at two
layers of the stack?

> 
> Cheers
> Suzuki
> 
> 
> >   
> >> +}  
> > 
> >   
> 

