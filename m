Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F382531613
	for <kvmarm@lists.linux.dev>; Tue, 22 Sep 2026 22:15:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790115343; cv=none; b=SDucke2YA6V+Zm/gxyw9XWpPY4lB4BvscNQEcGH+yJG0Iz+vaftTnrJffI43BlgKFA5sZxxrPAeDFVw4ZHKiao1/VbuM88LM8NtmyCOojzFlhUxq/29cVmGaEuhkScexoQlYx9KB96HBJIyhRT/S0JOAidOG5XaH8DqF4V7B+vE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790115343; c=relaxed/simple;
	bh=2I+RK594+7yvlbEyJzoCiZ3ZLN/AQWF6AlkeQkLTv14=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=K/nxqRiwm35bni6cEeIQpiDgRkxCYjV2wHxRlaeMLNzbICl4T5fdoNCEuZSBSwxsJeHB6RbwO5V8JTOg1rQOlgHGPtOos2m/mFMb7PAqf6zVHU/dBPG8IWl2whFHaZW+2u89AbC7b0pR3P1/7+/U/e69So5QnJO39ssouzYuV3s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=LUIg3yqi; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=AOqdV0h4; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="LUIg3yqi";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="AOqdV0h4"
Received: from pps.filterd (m0279863.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68MJD9tb1166868
	for <kvmarm@lists.linux.dev>; Tue, 22 Sep 2026 22:15:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	3J+Y3qFDHro/ofj9RaFrKGahhFH3oBBHZcDF842RuqY=; b=LUIg3yqi9TH9y9gg
	F/mIr66JscemBMTu6ta06KCd3tUQmpN94F8XDNu2Egp5ULhY9mPCicRZtFxQgTPd
	HGWoa3EhlM3QVW+9XNz2U1tdp77dEZ64XmmdcwCnIPWNS8kMKkGmaS/Skqccsero
	ZInCQfVzqdZdF6ngjyH+Lsf4v/G0j7PHPaIMQIDuXKK+RYV3dTQ+QE3CsiYEa3b0
	BocityRN+JBLonLjGZKk7WPacf64e9IPfnE9NpzTgFwsb8D0R87Ii7AqmXA78xqy
	6qwoFni+9GOvuAsazk/Dr435tBhsXyyNAEHOW9B54SD34831GriuIr8E0HdmbVGo
	2zdD0w==
Received: from mail-dy1-f198.google.com (mail-dy1-f198.google.com [74.125.82.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4guymw0uuc-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <kvmarm@lists.linux.dev>; Tue, 22 Sep 2026 22:15:16 +0000 (GMT)
Received: by mail-dy1-f198.google.com with SMTP id 5a478bee46e88-3282d5302ffso282643eec.1
        for <kvmarm@lists.linux.dev>; Tue, 22 Sep 2026 15:15:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1790115316; x=1790720116; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:mime-version:organization
         :references:in-reply-to:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=3J+Y3qFDHro/ofj9RaFrKGahhFH3oBBHZcDF842RuqY=;
        b=AOqdV0h4GRT+m9Kb2I3/Vz1AFrmIVMB1jV0a13kxXz1kQ4Q1hn8PpKQr8YWuOLjWeu
         Ys4+9z0Wc/aWehBbgxUymlkx/9TAzVDnuCIaMMoMlcE8cmeR1byHuzF5r2GXyGns0DBj
         0nFQHTKAvERB3mbZqE73IRLCTvs9BrBvkoS//q+xfUDgeEJ+aopjEmS7QsBOZcRu99n/
         lNGK37OJZzVmPk7hUCL4izDrOE4zklvAjwXs18kpaG0aqFyXP6hIai0ojCsaep6WzF4p
         BcHmYGNtNLtEbX1EcbXNTwnoe4LuSC3FqqHBfL6JZSUYQnDprr2JOs8ravr8pxajQ9xc
         /Fag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790115316; x=1790720116;
        h=content-transfer-encoding:content-type:mime-version:organization
         :references:in-reply-to:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=3J+Y3qFDHro/ofj9RaFrKGahhFH3oBBHZcDF842RuqY=;
        b=2lLHTNzkLLA+LxXgpQBiGoF1g18EbqQLFSumNtBDB9shv55cMwSYRCFHfEnH1BcTkM
         Fa9/tKJY2gr2YMziy/sr5MEsqtOph3EbKkwgqu57aMEsF8cuxXdlzJZ4QlZEje06ARni
         bta3FeJHwvTu6lu3f95xOGeB2Cx1QmjGfcfjmbEMbkdJrbWXtXSuAmdEmMVoHRjjTW59
         9xgT1a0IQgUGcYx+/POUGD7shNogxyTtzCPjCDQRWUSArcb/uiCtpRmMlMmfaCTZR3zg
         8XR/Bbr52Uq0xLjXMK8kRu6+u61q7GqtzAg4oQq6HZGREi3Oduk3xOoYvjCR83LkNSYk
         2A0Q==
X-Forwarded-Encrypted: i=1; AKwUvBzMoOEKAerDGAeq73dRWWSb0tGnc0JMDswPEWHv8Yu0E8YlFPxjJSePHmsCNgQpTergL4pjA+M=@lists.linux.dev
X-Gm-Message-State: AFuF++nqa0FR1QfYmd5yxyHVVQ5POba0ByhAmAnrat51wqMxFH3fnok4
	MYFst/ABfRDb5tvpAdnaUV+kxbUQ+QiuhpOyx6rSVU6yC7OiKxrb8jaAglz9VWsSLZ1mx4zmWUB
	ehA2GGsA2eNu3/xne0rmykUzLXPZkiDT04r6uYOMJgZQuf1NWuGu5JYhGxv8=
X-Gm-Gg: AYBFou362xFdz3YxtWoNSyuVLhw7/9GSktdCJn42wTJExdpv/7bpWkDPojwtHDpMXQm
	WOllBIp08d3l54c175HGeTI1XRFcQBNYjj3s5/iCn4xgigKEEUGi7Y2OCUNMI0oEyA7BWnMzb+5
	MR4PzjBW8+F5ikSDhzliS7wTz2cV1yoTI77gRTxLhgXIv5aGL11+PlrLYpQbJV9PMu8DKo6jCtX
	w8nNtRY0+H/8/mr4apcPeXam3pC48w39vzpo7SncE/CkROqGGA0FwzQMrr6dWhBqyGqvRwwAQEQ
	Wy5DTTNefoaAbeUJjwp1hpLVhur/cmmUAXcD2+XaDJlixiF5Fpjpt3rqJynquOP4XMDwQtzc5e1
	MVWAvbiGNsmCiMXA8JL2vPX1CYugyRcPTjFFgPtSd7+2r8bsUB8Fx1Q==
X-Received: by 2002:a05:7300:e9ce:10b0:33e:6c5a:37c3 with SMTP id 5a478bee46e88-33e6c5a3aeamr850823eec.1.1790115315844;
        Tue, 22 Sep 2026 15:15:15 -0700 (PDT)
X-Received: by 2002:a05:7300:e9ce:10b0:33e:6c5a:37c3 with SMTP id 5a478bee46e88-33e6c5a3aeamr850779eec.1.1790115315280;
        Tue, 22 Sep 2026 15:15:15 -0700 (PDT)
Received: from localhost (i-global254.qualcomm.com. [199.106.103.254])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-33e9625825asm1072047eec.13.2026.09.22.15.15.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Sep 2026 15:15:14 -0700 (PDT)
Date: Tue, 22 Sep 2026 15:15:10 -0700
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
        Fuad
 Tabba <fuad.tabba@linux.dev>
Subject: Re: [PATCH v19 08/20] KVM: arm64: Reuse kvm_stage2_unmap_range in
 kvm_unmap_gfn_range
Message-ID: <20260922151510.00003c76@oss.qualcomm.com>
In-Reply-To: <20260920212845.707-9-suzuki.poulose@arm.com>
References: <20260920212845.707-1-suzuki.poulose@arm.com>
	<20260920212845.707-9-suzuki.poulose@arm.com>
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
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTIyMDMwMSBTYWx0ZWRfXxXH1aWs2JC4d
 ZO83GDExja0/8vB6rt9lpcbKTe12BRD1xnBfNgrjv1aTpNywYSlCpAKxitVzLwPnXBrrHef5ZS1
 1dzYRW44pE5DpcMXall18SMuts43IsPeuRZGm806WgYZ06nmtKxImj8D4/I5mBgBpib9jpNGX8X
 +sP9nolp4nPK5WRwsBC3JYux+fdn+aIleNRTWX8mMkHMIIMYYTNgRidkerWUHzA9uaOR5Y2vhRa
 avBV6Z44RDXaEtGqjIxoZlOarLiPZ3/VWCbMdTfLl/ucNIxVnTYmQDAscPp37D/WTCPI5rCPgpu
 c2se6DlrnDOv0FAjcrJdYwKgNuudNgqib/tt2jyymPM7MskABrgmYwKN9REls+1MXGC4mNsHjP6
 ovJCBGk2oH8h2Pxb8AzSgutmmf0F1v2kSSVJI5EAwNhcuE6FKwSywuz5Oij4u5MLzs3+7sWghZ2
 /5NEkzwIyCv41LnJG2A==
X-Authority-Analysis: v=2.4 cv=feI4WEQF c=1 sm=1 tr=0 ts=6ab2fdf4 cx=c_pps
 a=wEP8DlPgTf/vqF+yE6f9lg==:117 a=JYp8KDb2vCoCEuGobkYCKw==:17
 a=kj9zAlcOel0A:10 a=VdqzKS8jKosA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=yOCtJkima9RkubShWh1s:22
 a=7CQSdrXTAAAA:8 a=EUspDBNiAAAA:8 a=kMqVnm4xDtAkP_aMvZEA:9 a=CjuIK1q_8ugA:10
 a=bBxd6f-gb0O0v-kibOvt:22 a=a-qgeE7W1pNrGK8U0ZQC:22
X-Proofpoint-GUID: v2mEuNNezV1Wab_kLGN2wU-MALxENwgr
X-Proofpoint-ORIG-GUID: v2mEuNNezV1Wab_kLGN2wU-MALxENwgr
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTIyMDMwMSBTYWx0ZWRfXyTolASRHgBuL
 2yY57ZXle1svkJglcq0AgcxuGvjCbUZzfm/I+eQ7BT57N+592cduGYV0lxovAbLbrXWtYnwlxoT
 bwlZ3aVCZ161d7nN8KtP4OzlexKv46s=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-22_03,2026-09-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 phishscore=0 spamscore=0 suspectscore=0 lowpriorityscore=0
 clxscore=1015 impostorscore=0 malwarescore=0 priorityscore=1501 adultscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2609220301

On Sun, 20 Sep 2026 22:28:33 +0100
Suzuki K Poulose <suzuki.poulose@arm.com> wrote:

> In preparation for adding VM specific backends for stage2 operation,
> switch to kvm_stage2_unmap_range() instead of __unmap_stage2_range()
> from the kvm_unmap_gfn_range(). Drop the bail out check for protected
> VMs and defer that to the one in kvm_stage2_unmap_range(). Later we
> would replace the logic in kvm_stage2_unmap_range() with VM specific
> backends.
> 
> No functional changes intended.
> 
> Reviewed-by: Fuad Tabba <fuad.tabba@linux.dev>
> Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>

Trivial thing inline. Otherwise this is fine.

Reviewed-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>

> ---
>  arch/arm64/kvm/mmu.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index 0f4e8b71fa85d..03f2017a7404a 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@ -2436,12 +2436,12 @@ int kvm_handle_guest_abort(struct kvm_vcpu *vcpu)
>  
>  bool kvm_unmap_gfn_range(struct kvm *kvm, struct kvm_gfn_range *range)
>  {
> -	if (!kvm->arch.mmu.pgt || kvm_vm_is_protected(kvm))
> +	if (!kvm->arch.mmu.pgt)
>  		return false;
>  
> -	__unmap_stage2_range(&kvm->arch.mmu, range->start << PAGE_SHIFT,
> -			     (range->end - range->start) << PAGE_SHIFT,
> -			     range->may_block);
> +	kvm_stage2_unmap_range(&kvm->arch.mmu, range->start << PAGE_SHIFT,
> +				(range->end - range->start) << PAGE_SHIFT,

Looks like indent is 1 too many space.

> +				range->may_block);
>  
>  	kvm_nested_s2_unmap(kvm, range->may_block);
>  	return false;

