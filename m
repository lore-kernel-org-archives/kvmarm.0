Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D34F23E16A9
	for <kvmarm@lists.linux.dev>; Tue, 22 Sep 2026 22:38:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790116724; cv=none; b=bXqBFL+U8ZYfhGK7y/WaT68Vh0+WwWHTcDIudvyA1RzE39+7aMBAkrbufGHHCwhvD8AFaMWoGyyoC33adWKEGKQ4mjxT3n6soqZCP1hzgApMdKR3BOFYkGp8R+XJvh8yyLdmzHKR5bB4lVRMUZpuj60nsmU+T4UlTsbIRxBndmE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790116724; c=relaxed/simple;
	bh=3/dkNKPPZhwKNFM+qynUyX6vwgw0I5X2dRSwnLFGk2s=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=et1rSZaNCkWCNHA9KgdcOz9+AiFyULI6L/KReoLwMbcXxH9pb+DiIb3tBh8NX0hqp7Vnnu9jFAuYmYc5jDe/Cshcobhc5ZxKsqMYBJwQJ2yAcBZxr1zhE7Gh3r7UaSlPlKq7WEdR5DvWbIhCcSUzjDHixtfJKoxh65eHaaD3mxI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=l2rd/8n+; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=G1Lhk+0O; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="l2rd/8n+";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="G1Lhk+0O"
Received: from pps.filterd (m0279862.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68MI7DYN368062
	for <kvmarm@lists.linux.dev>; Tue, 22 Sep 2026 22:38:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	tJNsu2FLCP1qcNEgoJs+KWNxYkGyFkvDNQdnRnSNx7A=; b=l2rd/8n+B47hSsLp
	dm9rKeJBloJJpWBYD9tTfVg5N4yZY3zxA2FdiNYnkn2Pdi87lB1r2vkiI6CIntcY
	biQPC3m8sZaHuOy7q40XCHL9Eu3dJhllRZVG1gkzMxduv4bmkRXqNqxjwd7NKhys
	3Rpp23gtahCeBn43yLdo/u9zoSqDZqDiOS5Ik187wrsvc9W47NQCEh0qUiMsp55k
	3Yx+arcyLIFHBbKIOoTtiZNno87NlNTaIbJU/9rLur+mUeXT+yxNW+sZA2VdfgCH
	aXxsrFn+XMTr0DD5H6dnQsmljDDhoIQnpYM1cJfupuhReouDDrKxqnQc7Xcl3ppU
	nmvQog==
Received: from mail-dy1-f199.google.com (mail-dy1-f199.google.com [74.125.82.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4gurntbaa6-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <kvmarm@lists.linux.dev>; Tue, 22 Sep 2026 22:38:31 +0000 (GMT)
Received: by mail-dy1-f199.google.com with SMTP id 5a478bee46e88-334f782d1abso676244eec.0
        for <kvmarm@lists.linux.dev>; Tue, 22 Sep 2026 15:38:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1790116711; x=1790721511; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:mime-version:organization
         :references:in-reply-to:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=tJNsu2FLCP1qcNEgoJs+KWNxYkGyFkvDNQdnRnSNx7A=;
        b=G1Lhk+0OrBtVug0DIuvDgAkX/CgIqQdCRtBsNXR1wcVwctz6RU4atg842GYscaSUbR
         UTPaNUH/d363mDpdsOmqvt3M/Jhy8TlH2zNjFW2jh9F1CcTCytUPASu+vemNmXyikD/p
         Rt5kF4hP3UwaIhD5YvEdMCwRmNbLdEPUBp5dIux1rAmOhWp7jNIofH4n8cTPWix6CJDp
         eKuWOXh4sfB+OpJq6dHag8ztvinO/U43sFTQ57PwTH8Jq+VAJAJpLnvwHw4Ge/cht95t
         lNk4lEcxjVR20nFmqKx6EBFQiv+ep72No+9nsLgC8O2nhfhlzk8Lf901bl24Da3pKZ3o
         p73g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790116711; x=1790721511;
        h=content-transfer-encoding:content-type:mime-version:organization
         :references:in-reply-to:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=tJNsu2FLCP1qcNEgoJs+KWNxYkGyFkvDNQdnRnSNx7A=;
        b=1m9ZhiQytVcG0Qr22ejwusp97D//OgLuq+X63DGYRfGP2UKALda6U2Btq+jBa2zSEy
         GBkkQuAl8HwPnv7ZZAquR6o214aHa3hh9krfoDV3kNhrpuJ+byulsPz3ieaq2Pdwe4+4
         DgUjAtHpYn357JCOfFf0+Qsr1U8642rhcswkMIBRex1udKSnVlGGrHYNgq21f+oKP5or
         w+rt4yj2kKAKLSSYcojKhLq4Y8V1mGZvEQqH68Lmt4VFklMEKLUOeIqFRUq+153qH19i
         bB9KNEKob9tsyhKXhRlwPYlWINv6IMIXL7BOSp3PQ89ihv8Ejw+LXqZual3MCggFscWH
         +SQg==
X-Forwarded-Encrypted: i=1; AKwUvBzth468isLY2w1aszBtKnizprlUfb8/fyPdHEaD2EFFsjq4XkrLKwuLrWtTTrfIg6LDT4vDB6I=@lists.linux.dev
X-Gm-Message-State: AFuF++nbSWl49j4swfhImeFvCrFb+kVz8fZoWXJAcNRkdnxZDVjdT7YC
	j3JPx78eufPRzejuj7K9RzACz31W6K4ld2xWYvJuE+DmkZDr4z4RK1JC79Ghq3MHQqBjquRyJXa
	V5yy3OqJR/cJp6rxZOCJZesfTgTpNTJoSJW7KsZTkL9tAAoAQvmWmRjygZTY=
X-Gm-Gg: AYBFou2NgRnTRFogmLy9EiiZB0nK4dCKeYg4xKDfkgAC0YMMoTxI6HVDG8enNjpma7+
	gR3hb73ysqsQSZBBJ+KhJjluC/GBZ4Og24CKr9Hzjh6+pUM1ampecXW5fg8guOuleYKmVgJALro
	5omqyUWvctKY7gKifK4YdXzWfW5X+7DXPeXV1nWd/6DpjimU8GKUiZEaR+c0CcPrvtcLcx49IPV
	dh3fyGuRm3MNJr5f4I0iBk7ZH8f/EhdNRkp5PN5Y7dZHMbo+NyvowTrz86oyWVWWLj7prGqJTY1
	ZKLQSA5NF/Rv1M6yr3Jm0611uLR8wnlzwC23eq2kM76MUqGrxchy8KpKP7LBnctbj5XcZuS+Mi6
	pNjlHK5jF2xD3hlhCvgTG3l6Bm9+8Rk9Ilg/Gq66uGgZZdTT00wuS3w==
X-Received: by 2002:a05:693c:4187:10b0:338:5bf5:d005 with SMTP id 5a478bee46e88-33e8ddc7604mr710467eec.28.1790116711123;
        Tue, 22 Sep 2026 15:38:31 -0700 (PDT)
X-Received: by 2002:a05:693c:4187:10b0:338:5bf5:d005 with SMTP id 5a478bee46e88-33e8ddc7604mr710439eec.28.1790116710604;
        Tue, 22 Sep 2026 15:38:30 -0700 (PDT)
Received: from localhost (i-global254.qualcomm.com. [199.106.103.254])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-33e96d497e1sm1162630eec.25.2026.09.22.15.38.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Sep 2026 15:38:30 -0700 (PDT)
Date: Tue, 22 Sep 2026 15:38:26 -0700
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
Subject: Re: [PATCH v19 10/20] KVM: arm64: Abstract out memory abort
 handling
Message-ID: <20260922153826.000044fb@oss.qualcomm.com>
In-Reply-To: <20260920212845.707-11-suzuki.poulose@arm.com>
References: <20260920212845.707-1-suzuki.poulose@arm.com>
	<20260920212845.707-11-suzuki.poulose@arm.com>
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
X-Proofpoint-ORIG-GUID: wnDKYhWFUwOeEkzUiKKk0DMMR4fMVxN4
X-Authority-Analysis: v=2.4 cv=eauo7LEH c=1 sm=1 tr=0 ts=6ab30367 cx=c_pps
 a=cFYjgdjTJScbgFmBucgdfQ==:117 a=JYp8KDb2vCoCEuGobkYCKw==:17
 a=kj9zAlcOel0A:10 a=VdqzKS8jKosA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=_K5XuSEh1TEqbUxoQ0s3:22
 a=7CQSdrXTAAAA:8 a=rbqOqaJmvRITx-_xyQwA:9 a=CjuIK1q_8ugA:10
 a=scEy_gLbYbu1JhEsrz4S:22 a=a-qgeE7W1pNrGK8U0ZQC:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTIyMDMwMyBTYWx0ZWRfX+zEMHeWB2Y8V
 RxPZRZLspv0KsVYLJ9SXy48vpQ9qAtoG1Z6TPVHuhwCwuHChNu51hXdKMGOOA1/XjGfA/xotaiK
 LH6ilNeFKcftdvXI1fDUbguC+eFnFLQAaW3dSRgccCr2A9UtqFF5lnTO+ygdmQ8RTZ4NK+9DEqB
 0HChzHd73Vw1D8Y4jqbUlQBUVQ4fBFhTAQthLXNa/lzPEmw7aCQ6OOm2MWK+gDMZcu5JccNHWSE
 EcHCG7G4SqdNhp6zlYEPJCqGmpNtX0YtU6/FRErtS1zsBGENqF75btIlShYXOUJk/t+dx5y3GgM
 8H8zm+D3pxHTfLWQxCEvx0TZiVxz7utbrnPgMJ/DoyFMmaaj+4sDIELyR55nO5QeKPYYaOUzI9E
 lWb9qPrKFqeetrptuXFMF+oNICwZo/ORnhfkbiM9jjsEciJMhmsBpGEn+EWfefNN2ET+1h5kK9G
 3BIb+8SRpqaTH5dZVaQ==
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTIyMDMwMyBTYWx0ZWRfX2ejga7yVP12B
 +c4WnrIFp1lqCEcRdot2DMHXJ43bqNS0nMxBXh4CHGZZERrd5uPsXyr8C/RXXACgIc8074eC7BI
 DBASxgtQ1oL9YssQRySHIVqChQ+D8MM=
X-Proofpoint-GUID: wnDKYhWFUwOeEkzUiKKk0DMMR4fMVxN4
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-22_03,2026-09-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 phishscore=0 lowpriorityscore=0 impostorscore=0 clxscore=1015
 spamscore=0 malwarescore=0 bulkscore=0 adultscore=0 priorityscore=1501
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2609220303

On Sun, 20 Sep 2026 22:28:35 +0100
Suzuki K Poulose <suzuki.poulose@arm.com> wrote:

> Move the memory abort handling under VM specific s2 operation.
> 
> Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>

Trivial comment + request to follow through on adding the local
variable for kvm. I think the other places that can be used
survive the other changes in this patch set.

> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index d97a4a1bca23f..cf293d09e940a 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c


> +static int kvm_vm_mem_abort(const struct kvm_s2_fault_desc *s2fd)
> +{
> +	int ret;
> +	struct kvm_vcpu *vcpu = s2fd->vcpu;
> +
> +	VM_WARN_ON_ONCE(kvm_vcpu_trap_is_permission_fault(vcpu) &&
> +			!kvm_is_write_fault(vcpu) &&
> +			!kvm_vcpu_trap_is_exec_fault(vcpu));
> +
> +	if (kvm_slot_has_gmem(s2fd->memslot))
> +		ret = gmem_abort(s2fd);
> +	else
> +		ret = user_mem_abort(s2fd);
> +	return ret;

Personal preference but I'd just do
		return gmem_abort(s2fd);
	else
		return user_mem_abort(s2fd);

and save a couple of lines. I'd keep the else to make it clear it is
an either / or choice rather than an if something true one.

> +}
> +
>  /* Resolve the access fault by making the page young again. */
>  static void handle_access_fault(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa)
>  {
> @@ -2287,6 +2303,7 @@ int kvm_handle_guest_sea(struct kvm_vcpu *vcpu)
>  int kvm_handle_guest_abort(struct kvm_vcpu *vcpu)
>  {
>  	struct kvm_s2_trans nested_trans, *nested = NULL;
> +	struct kvm *kvm = vcpu->kvm;

If introducing this, also use it for the other places vcpu->kvm is used
in this function.  Separate patch though to keep down noise.
Looks like that's mostly to shorten the chain of dereferences in the
locks.


>  	unsigned long esr;
>  	phys_addr_t fault_ipa; /* The address we faulted on */
>  	phys_addr_t ipa; /* Always the IPA in the L1 guest phys space */
> @@ -2448,19 +2465,7 @@ int kvm_handle_guest_abort(struct kvm_vcpu *vcpu)
>  		.hva		= hva,
>  	};
>  
> -	if (kvm_vm_is_protected(vcpu->kvm)) {
> -		ret = pkvm_mem_abort(&s2fd);
> -	} else {
> -		VM_WARN_ON_ONCE(kvm_vcpu_trap_is_permission_fault(vcpu) &&
> -				!write_fault &&
> -				!kvm_vcpu_trap_is_exec_fault(vcpu));
> -
> -		if (kvm_slot_has_gmem(memslot))
> -			ret = gmem_abort(&s2fd);
> -		else
> -			ret = user_mem_abort(&s2fd);
> -	}
> -
> +	ret = kvm->arch.vm_s2_ops->vm_mem_abort(&s2fd);
>  	if (ret == 0)
>  		ret = 1;
>  out:


