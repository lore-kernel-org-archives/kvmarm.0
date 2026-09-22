Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C88CE4DBD63
	for <kvmarm@lists.linux.dev>; Tue, 22 Sep 2026 22:12:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790115152; cv=none; b=tENQuBzQ7cXxFzVL4WfDDdBKGVlAp36p6uFdhJEAOerPv4g/yYl43AzhXHGWV3cUiV5n7MHFHoONH2GeS+aCQsHARZVDVxRGw467VNMwX6/zHIhIJq/OqSchgXmHYINjxdCGn6AmYHPS623d76Lzz2ETDZ5EhWxeZ+Dqp8bnJ5Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790115152; c=relaxed/simple;
	bh=ilYK4JBuirT8HWj9lb7kNesQ7ONo66yaGSx6NVf2VE0=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=nmGucagotO4g/ZtjOnLOg17Y5c60KlK+uRy7/MNgxY/FjjgaGD3CqQXmQ0Pvm/skq6AZSkYbcO1cxRYrxwvLYox/kbnhPVbrHqfSyjVgDK5UOReWqfmtpCMR8ai8xhpEthqv6NkbqGJ0EpG20w4yCcmV1uT2kXXMB1ToFRsn12E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=Xi5iBYok; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=D49kdVBZ; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="Xi5iBYok";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="D49kdVBZ"
Received: from pps.filterd (m0279866.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68MI7EKq179890
	for <kvmarm@lists.linux.dev>; Tue, 22 Sep 2026 22:12:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	uALtqlrWboMDydUPTyFJwMEQxzN3BoTDOpL4FS6bPkg=; b=Xi5iBYokt2Ym60y1
	vpsVpXo8tMWGOaetwjaQuZwvfcEM0uLpPU1gEgyshw/wom2fcML7yMokSyv/bN67
	aPzoeG3QveP9rSjDgKD6X7DEI+TDD2KRztD8yWHPGJC4Dv1hHaR34TrBwrqxAKgH
	xit/WxV4HJQg6GhWjom3Kks0KUcjV/MNt60Re4x1Z3XuDYRpTWIuKd7pxK5+4bN9
	6ylLrW5+P47ZKjuSE1vH9XSMXXmCeiaiUP/ZjdPsoGm3xsT/0g8XYPSBYqSK5dhQ
	oghfRPror1+lpoUXwjMxNR9csqCnxWGFBdinqWCmNv1vmhasJO9sOcaeQvliyR+i
	F6C7Kg==
Received: from mail-dy1-f198.google.com (mail-dy1-f198.google.com [74.125.82.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4guuec2bdh-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <kvmarm@lists.linux.dev>; Tue, 22 Sep 2026 22:12:15 +0000 (GMT)
Received: by mail-dy1-f198.google.com with SMTP id 5a478bee46e88-30bcb065bfdso353430eec.0
        for <kvmarm@lists.linux.dev>; Tue, 22 Sep 2026 15:12:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1790115135; x=1790719935; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:mime-version:organization
         :references:in-reply-to:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=uALtqlrWboMDydUPTyFJwMEQxzN3BoTDOpL4FS6bPkg=;
        b=D49kdVBZn4vHDJD32l09YWNIfO9taaY/Ehckx0uTWuDx9kn3Gc7lQp66MYV8BP+Ac0
         Pa2jNIqOd4VbwSzehQ1G7/p7dC7k3HMkQMcH13YfPBwv4tvAZKZ73C3NmPDRCxcNim7H
         u/a2KrJbMYiR5wtOzLfuZLLjh2bi2P4Q16bfVvEU3jZuuAV+/NREnhEXRhr7EWDoLhdE
         tNudt7jK7M9ueBfYFosn8a3MzCYcHoD7eJIniC6h0SdlgSA9VhT+1P7VwaGHNrsFt64q
         rY/dylhfLobL5ujViEsBm333YzyUqUVYla76IlX2SHPqj6EUk3OwKsKMZ3gIfKqWAfIy
         qQiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790115135; x=1790719935;
        h=content-transfer-encoding:content-type:mime-version:organization
         :references:in-reply-to:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=uALtqlrWboMDydUPTyFJwMEQxzN3BoTDOpL4FS6bPkg=;
        b=2Na8fdLqzPzKWnuXI3yuSCH7qrAbv/2GpuYHU+99nxPRavTue0GkVtnoYq6j6+Btvt
         11sJadsUqt01Z0ArpQU3DMIuIAYuR9vai003NN1t7OGBVQysfULOEGVR0PCnkOsBmCcI
         8YumWz+VrzaZjDc/ds0rSx1OTfMidZJ+uwVTMw15wQ4KHNu9b0tZoXH0CYZVZlI/++7N
         NRbHIw3tQW3O0+CqJ/7uPLBIJg82ou8H6zCIO5Dv0tudA7kduE9LOmR4Xga9p45N8gme
         e26cAe2Kyl13JpFAVRP90cQdnMsnpx3bKa0VyUqqLSr7DI8qkm2mDIiJhKO+bJbdAnjg
         blqg==
X-Forwarded-Encrypted: i=1; AKwUvByPsMXF9CXqDyiLqkVaSz5WZCV5GHdzeyWifzRiK4pZAZpQKraAuOq1q741EEdZVlLHw78cn/Y=@lists.linux.dev
X-Gm-Message-State: AFuF++kHyIHgeJz124AuVAU40UAvJL0TZ587T8KPQBIf2Agl5lbeeCyC
	ql54BEG67G/QIiLE52FGJICSQdlYQPsajT/aIZbJA7zNYTMn8NB8Uvf2EpQHqiDqXVGoEuTcNxO
	fZyUhU0UHJlx6UjfhrTAtP3MDfVctFT+Ybb7WBwdiPIqMo/UdZwE9dyL5j2s=
X-Gm-Gg: AYBFou0D1ucnUcn7oMQAF5XqTOwsH6nsjA95aRg9wwOT5T1ZQeCsTOc9IvORggoit1t
	PPN9Rqs8jMuY2z/DFegeThKPynpmh2fka2TAkgKoaKspllrpqbY3PDLjIV40DRJ3bmbcSshVk2k
	8BAnIgP8YW4EP/3ZRiq0eIM5xjx+MaE1gh54fM+7u0Fks/EIIFLCHL0iBZ914UhNBuxPUl8faOg
	DWcexjrq+CvugvRoStTmGWb30i76eGHxbsrq/VoBCofJik92lHifY6Sqw5ou3dVui7Gn6rBdYcS
	eDaRhKQjo0FsfNtvvDemxcnopiw58eJogSS3sRBX3+my+JBwLULwzyfgcVqzqDzaTVaIH/l7Wz0
	KYxC+2kJo8T1pVTrvfXlXx8xVYkc8wEFakDtgmo4Bi930QOh19SWCWPw=
X-Received: by 2002:a05:693c:8948:10b0:33b:de3b:8b09 with SMTP id 5a478bee46e88-33e8e1b4b4cmr574498eec.40.1790115134467;
        Tue, 22 Sep 2026 15:12:14 -0700 (PDT)
X-Received: by 2002:a05:693c:8948:10b0:33b:de3b:8b09 with SMTP id 5a478bee46e88-33e8e1b4b4cmr574460eec.40.1790115133819;
        Tue, 22 Sep 2026 15:12:13 -0700 (PDT)
Received: from localhost (i-global254.qualcomm.com. [199.106.103.254])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-33e95c7d003sm1032300eec.9.2026.09.22.15.12.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Sep 2026 15:12:13 -0700 (PDT)
Date: Tue, 22 Sep 2026 15:12:02 -0700
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
Subject: Re: [PATCH v19 07/20] KVM: arm64: Add vcpu load/put call backs for
 flavors
Message-ID: <20260922151202.0000549c@oss.qualcomm.com>
In-Reply-To: <20260920212845.707-8-suzuki.poulose@arm.com>
References: <20260920212845.707-1-suzuki.poulose@arm.com>
	<20260920212845.707-8-suzuki.poulose@arm.com>
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
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTIyMDMwMSBTYWx0ZWRfXzDgIDzcYsWp0
 dM52F4y7YWs+Kmn6B4cmdX2gKzvADhObIL7mJMmaDRJ8DyzL0bnHQgRtbaop1XQtLaMjNVhzKyV
 sde3W6QmK1P5SWeZtMlGaHlzu6Kx9JqL0tw+f0cbTwkAz4z5w2p2t4Yrg41LAbS26QOVRh1XL7C
 vIBM+SqwVvFLkSFEaDtmEqEWQkUj7dUCcQCSRAD2L1kyRs4R+u2sL5HCF+zK2OXXuGfrSgStxIg
 96TfKYOoWE4wjkYGaEpUCeYH7KP6ImdnsMKsoEB1/sEx34OOOoytci2D7CiOU+ZZU0ZxCbrcWpX
 VBQrx/pMcL4CJOEaLNgR3XKksyZ1jgYpUUZOLy4Q8E1BMkD5jQH6l4jI+bimhsb6uhdbMiIyTKe
 CMG9kQ19i3uPCUaIfs/8J6l+wqld9iwEjUvKpUzQVTxQRMl2Vv/5iy1t0VzC89FPByjGZYM6mIv
 IJgCxdOeZ0Fk/tmW9lg==
X-Authority-Analysis: v=2.4 cv=VKdIDNPX c=1 sm=1 tr=0 ts=6ab2fd3f cx=c_pps
 a=wEP8DlPgTf/vqF+yE6f9lg==:117 a=JYp8KDb2vCoCEuGobkYCKw==:17
 a=kj9zAlcOel0A:10 a=VdqzKS8jKosA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=YMgV9FUhrdKAYTUUvYB2:22
 a=7CQSdrXTAAAA:8 a=VwQbUJbxAAAA:8 a=eF-YeP4ItYG6qj9G5aAA:9 a=CjuIK1q_8ugA:10
 a=bBxd6f-gb0O0v-kibOvt:22 a=a-qgeE7W1pNrGK8U0ZQC:22
X-Proofpoint-GUID: E_B2Z1gg47YYHo_1KYO8is7XD1K8zw4f
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTIyMDMwMSBTYWx0ZWRfX1C61TTmfoRj7
 rAl3NtoxffyvHsW9HQjT4CCR3NgSH2Q6/oRQJzmT6co4Y2web6S7FRzCNUlr5ajD2ofmz1Fl0cd
 y++pOIchHu7rSzHPPjIp1S14diBzw9E=
X-Proofpoint-ORIG-GUID: E_B2Z1gg47YYHo_1KYO8is7XD1K8zw4f
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-22_03,2026-09-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 impostorscore=0 phishscore=0 spamscore=0 malwarescore=0
 suspectscore=0 bulkscore=0 clxscore=1015 adultscore=0 lowpriorityscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2609220301

On Sun, 20 Sep 2026 22:28:32 +0100
Suzuki K Poulose <suzuki.poulose@arm.com> wrote:

> Add VM flavor specific handlers for VCPU load/put, in an effort to make it
> easier to follow the code. pauth traps were removed from VMs running PKVM
> as it is a no-op for them.
> 
> Based on a patch by Marc Zyngier
> 
> Suggested-by: Marc Zyngier <maz@kernel.org>
> Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
 
A couple of comments on this one.

> ---
> Changes since v17:
>  - Use macro to initialize the per-flavor ops
>  - Add a wrapper to initialise ops in the vcpu structure.
>  - Add BUILD_BUG_ON for the array size
>  - Remove irrelevant comment about the order of timer loading for !VHE
>  - Use the explicti kvm_call_hyp_nvhe for nVHE flavor
>  - Don't call nvhe_vcpu_put from pkvm_vcpu_put, open code them
>  - Drop cpu argument for vcpu_load() callback. We set the cpu
>    before the callbacks are invoked


> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> index c74706ed9a531..9b977dc734220 100644
> --- a/arch/arm64/kvm/arm.c
> +++ b/arch/arm64/kvm/arm.c

> +static void nvhe_vcpu_load(struct kvm_vcpu *vcpu)
> +{
> +	vcpu_prepare_mmu(vcpu);
> +	kvm_timer_vcpu_load(vcpu);
> +	kvm_vgic_load(vcpu);
> +	kvm_vcpu_load_debug(vcpu);
> +	kvm_vcpu_load_fgt(vcpu);
> +	kvm_arch_vcpu_load_fp(vcpu);
> +	kvm_vcpu_pmu_restore_guest(vcpu);
> +
> +	vcpu_load_pvtime(vcpu);
> +	vcpu_set_wfx_traps(vcpu);
> +	vcpu_set_pauth_traps(vcpu);

Now it isn't called from the pkvm path can you remove the defenses
in there on !is_protected_kvm_enabled()?

> +}
> +

> +
> +static void pkvm_vcpu_put(struct kvm_vcpu *vcpu)
> +{
> +	kvm_call_hyp_nvhe(__vgic_v3_save_aprs, &vcpu->arch.vgic_cpu.vgic_v3);
> +	kvm_call_hyp_nvhe(__pkvm_vcpu_put);
> +
> +	/* __pkvm_vcpu_put implies a sync of the state */
> +	if (kvm_vm_is_unprotected_pkvm(vcpu->kvm))
> +		vcpu_set_flag(vcpu, PKVM_HOST_STATE_DIRTY);
> +
> +	kvm_vcpu_put_debug(vcpu);
> +	kvm_arch_vcpu_put_fp(vcpu);
> +	kvm_timer_vcpu_put(vcpu);
> +	kvm_vgic_put(vcpu);
> +	kvm_vcpu_pmu_restore_host(vcpu);

May have been incorrect or pointless but wasn't kvm_arm_vmid_clear_active()
previously called in this path?  Would be nice to tweak that to be under
an appropriate gate in a precursor patch with explanation of why.

> +}
> +
> +void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu)
> +{
> +	vcpu->arch.vcpu_ops->vcpu_put(vcpu);
>  	vcpu_clear_on_unsupported_cpu(vcpu);
>  	vcpu->cpu = -1;
>  }
> @@ -2136,6 +2187,37 @@ int kvm_arch_vm_ioctl(struct file *filp, unsigned int ioctl, unsigned long arg)
>  	}
>  }

> +
> +#define KVM_VCPU_OPS(flavor, ops)		\
> +	[(flavor)] = (ops)
> +
> +static const struct kvm_vcpu_ops *arm64_vcpu_ops[] = {
> +	KVM_VCPU_OPS(VM_VHE, &vhe_vcpu_ops),
> +	KVM_VCPU_OPS(VM_NVHE, &nvhe_vcpu_ops),
> +	KVM_VCPU_OPS(VM_PKVM, &pkvm_vcpu_ops),
> +	KVM_VCPU_OPS(VM_PROTECTED_PKVM, &pkvm_vcpu_ops),

I'd put these in same order as the enum. Given the construction
doesn't really matter but just feels more natural when reading
the code to check they are all there (obviously the BUILD_BUG
below also does that).

> +};
> +
> +static void kvm_init_vcpu_ops(struct kvm_vcpu *vcpu)
> +{
> +	BUILD_BUG_ON(ARRAY_SIZE(arm64_vcpu_ops) != VM_FLAVOR_MAX);
> +	vcpu->arch.vcpu_ops = arm64_vcpu_ops[vcpu->kvm->arch.vm_flavor];
> +}
> +
>  static unsigned long nvhe_percpu_size(void)
>  {
>  	return (unsigned long)CHOOSE_NVHE_SYM(__per_cpu_end) -

