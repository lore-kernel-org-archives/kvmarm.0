Received: from mail-wr1-f50.google.com (mail-wr1-f50.google.com [209.85.221.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 437063090E2
	for <kvmarm@lists.linux.dev>; Mon, 29 Sep 2025 13:59:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759154381; cv=none; b=XO5qd6aytnzryr1laaVrEScKSDxpPJE3/a8kRv3NaHUjLL+A8VwgBlDWQ2D6FayndGXbrKXIqzdnm0pNZtdA4FZvUy/RbLL/t0HS8lPo98rVgJd4vHNE+b/2lRlswZ4MlxKtIZp2oo4BvffW0YmPvBy68zsEHJVLmYGOVOmDJWE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759154381; c=relaxed/simple;
	bh=7uitIzQ1GatOj3aC/wPhGEU9p9oB81Xc0jNEY+fNKWc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=RbKUMCUya+9VUXBqcbcOK6Lnb7nDHN8/Ss92IaL3YobensGi4AD1ajzFCgt33of4VPj9lIeFiuIvVrcrPnbSJYevOON06RhxSieeIyXuZCm8ejKPYwouN7hij80IS2uy8jMsww8QwIuIomTKsqvwfXeLOjQQagLUR5ITO7nZr+o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=mB66xR+u; arc=none smtp.client-ip=209.85.221.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mB66xR+u"
Received: by mail-wr1-f50.google.com with SMTP id ffacd0b85a97d-3f0ae439bc3so2417092f8f.1
        for <kvmarm@lists.linux.dev>; Mon, 29 Sep 2025 06:59:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1759154378; x=1759759178; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ipfI8eVx3bzgfWjoq31uPWRXd4Smibc+RtoSzpX+z2A=;
        b=mB66xR+uMdwzfljLN/dYVRS+N2+yWdCpk08ImLQrLFD2cmxjpY+iHO6F/Nv7ZnpZGI
         WuPuMZ3jF/iOLaLf3fYNzCL1CR33M8gOgzDwbVdErIWq2jAQRWkGDeWYX4R+E2dVFzCu
         wHTYwbOLGXlXsJtdn+YAeNohVKHMsBJQz16/gBvAtQVq82VHwWUKnzYn/WU5zY/zUtA+
         4noy8Rd5CuSUIgH/t9PDtB+7ztkEPFO+XsvN0DJScnzBCIEqJfpeIdrdQ+cQx0KVAUKe
         BSOqtigBxS0iejp784eYGNZYZUagCzQme34jAVOgWl1CX+/Ythif9tDfH+HW3HS8iIl+
         uVCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759154378; x=1759759178;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ipfI8eVx3bzgfWjoq31uPWRXd4Smibc+RtoSzpX+z2A=;
        b=cVAg82spU7+LmmZ1HS6rh92s9VTH5TNv9B2cq99hi9c/guA2r2q/OVNohkf/TSi/R6
         6CpV4SxWKMqPoMPiZ1wf2tp9kfqNY2XL/WGpXWvZrRoEA7UrA8zVoiUerrAYBVQwgpmn
         WwFjFY9NWsGPP7OJQrXLDVoXCaZCqX935dN6rFHS5wW99mb97emRNzbgA/Vqa41NriZH
         HIOhtC4jxpx9kdInhpV+oGmgmZJiMtKZXzDs7GhxGdL7exZWXs7x/xGumyNpMTDB5t/k
         YeHxSUDeftMO5ppkYiwHe3r7RTuybwrhJl4kPmzj/sAgVVb+Oc4wF9/KtcGyuZfFIN5k
         e7Qw==
X-Forwarded-Encrypted: i=1; AJvYcCXjiE+Xyaax+j/tJg83qARJUjBAd2j/VoahU4Ob7M0mwCEmrRh4dHzYkPVA9A0OttFuZUhnwmc=@lists.linux.dev
X-Gm-Message-State: AOJu0YzEIk0PZRO/Tw1Y/oLkf0U3Ynh248VR9Bj39K4s2xMaWTNE4biJ
	Mlpbk++J2Y2L/1Xp39QTHNO5CY8bWMnSWfDO8uMWD5mO0a5E38aInbng
X-Gm-Gg: ASbGncsuuQg8xqsRveLyPfbJ2stkk4yo6YPeycI0ORqrtqOTmmB1HnCbQu2Hlwjlpp1
	BdfU10/s1a7F+iTwqjU/mXr5LGRjdnkj4+pVhKTlWqi04Yox0yKLViYRq8vezuhJQQcZbGStSKg
	EdukjkX0dFhfrjilzxyMLZ+kEh5Q3brIP5CL/4UxYcwrX0Nc3sey6znzIqyb2DPSPZAfAHNEHnv
	SHq/xU7aFuOkURr86ZCT7gFn4jdezVFV28zVlEKXHov1Rjffbsxo++G020NgKtCgKKyn+5A6DQ8
	tu5sMlrx5OKcRuiWeXi+RLaZjsIUKawRwYUvSa2kdIc1d1giMGGNLaBSkaE16g/Qs8R3niJeR/U
	QEAOefZTxjdDuXspYtTV/2H5XteECa+fR7lkRJow=
X-Google-Smtp-Source: AGHT+IGmk8eIupNHH6e8ZECR90n/BecDA3d0fPOnthyKhQCMVja8jB69/O5wl6BImeD5SJG0fNGoiA==
X-Received: by 2002:a05:6000:2203:b0:3ea:63d:44ca with SMTP id ffacd0b85a97d-40e4adceb15mr13337551f8f.32.1759154377256;
        Mon, 29 Sep 2025 06:59:37 -0700 (PDT)
Received: from [10.24.66.14] ([15.248.2.234])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-40fc88b0779sm18227650f8f.58.2025.09.29.06.59.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 29 Sep 2025 06:59:37 -0700 (PDT)
Message-ID: <7d109638-3d26-443a-b24d-eb7a0059b80f@gmail.com>
Date: Mon, 29 Sep 2025 14:59:35 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/6] KVM: arm64: Add pre_fault_memory implementation
Content-Language: en-GB
To: Oliver Upton <oliver.upton@linux.dev>
Cc: maz@kernel.org, pbonzini@redhat.com, joey.gouly@arm.com,
 suzuki.poulose@arm.com, yuzenghui@huawei.com, catalin.marinas@arm.com,
 will@kernel.org, shuah@kernel.org, linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org,
 linux-kselftest@vger.kernel.org, isaku.yamahata@intel.com,
 roypat@amazon.co.uk, kalyazin@amazon.co.uk, jackabt@amazon.com
References: <20250911134648.58945-1-jackabt.amazon@gmail.com>
 <20250911134648.58945-4-jackabt.amazon@gmail.com>
 <aMMYKqWsAZ4y0WI7@linux.dev>
From: "Thomson, Jack" <jackabt.amazon@gmail.com>
In-Reply-To: <aMMYKqWsAZ4y0WI7@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi Oliver,

Thanks for reviewing!

On 11/09/2025 7:42 pm, Oliver Upton wrote:
> On Thu, Sep 11, 2025 at 02:46:45PM +0100, Jack Thomson wrote:
>> @@ -1607,7 +1611,7 @@ static int __user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>>   			    struct kvm_s2_trans *nested,
>>   			    struct kvm_memory_slot *memslot,
>>   			    long *page_size, unsigned long hva,
>> -			    bool fault_is_perm)
>> +			    bool fault_is_perm, bool pre_fault)
>>   {
>>   	int ret = 0;
>>   	bool topup_memcache;
>> @@ -1631,10 +1635,13 @@ static int __user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>>   	vm_flags_t vm_flags;
>>   	enum kvm_pgtable_walk_flags flags = KVM_PGTABLE_WALK_MEMABORT_FLAGS;
>>   
>> +	if (pre_fault)
>> +		flags |= KVM_PGTABLE_WALK_PRE_FAULT;
>> +
>>   	if (fault_is_perm)
>>   		fault_granule = kvm_vcpu_trap_get_perm_fault_granule(vcpu);
>> -	write_fault = kvm_is_write_fault(vcpu);
>> -	exec_fault = kvm_vcpu_trap_is_exec_fault(vcpu);
>> +	write_fault = !pre_fault && kvm_is_write_fault(vcpu);
>> +	exec_fault = !pre_fault && kvm_vcpu_trap_is_exec_fault(vcpu);
> 
> I'm not a fan of this. While user_mem_abort() is already a sloppy mess,
> one thing we could reliably assume is the presence of a valid fault
> context. Now we need to remember to special-case our interpretation of a
> fault on whether or not we're getting invoked for a pre-fault.
> 
> I'd rather see the pre-fault infrastructure compose a synthetic fault
> context (HPFAR_EL2, ESR_EL2, etc.). It places the complexity where it
> belongs and the rest of the abort handling code should 'just work'.
> 

Agreed, it looks much better with the synthetic abort. Is this the
approach you had in mind?

+long kvm_arch_vcpu_pre_fault_memory(struct kvm_vcpu *vcpu,
+				    struct kvm_pre_fault_memory *range)
+{
+	int ret, idx;
+	hva_t hva;
+	phys_addr_t end;
+	u64 esr, hpfar;
+	struct kvm_memory_slot *memslot;
+	struct kvm_vcpu_fault_info *fault_info;
+
+	long page_size = PAGE_SIZE;
+	phys_addr_t ipa = range->gpa;
+	gfn_t gfn = gpa_to_gfn(range->gpa);
+
+	idx = srcu_read_lock(&vcpu->kvm->srcu);
+
+	if (ipa >= kvm_phys_size(vcpu->arch.hw_mmu)) {
+		ret = -ENOENT;
+		goto out_unlock;
+	}
+
+	memslot = gfn_to_memslot(vcpu->kvm, gfn);
+	if (!memslot) {
+		ret = -ENOENT;
+		goto out_unlock;
+	}
+
+	fault_info = &vcpu->arch.fault;
+
+	esr = fault_info->esr_el2;
+	hpfar = fault_info->hpfar_el2;
+
+	fault_info->esr_el2 = ESR_ELx_FSC_ACCESS_L(KVM_PGTABLE_LAST_LEVEL);
+	fault_info->hpfar_el2 = HPFAR_EL2_NS |
+		((ipa >> (12 - HPFAR_EL2_FIPA_SHIFT)) & HPFAR_EL2_FIPA_MASK);
+
+	if (kvm_slot_has_gmem(memslot)) {
+		ret = gmem_abort(vcpu, ipa, NULL, memslot, false);
+	} else {
+		hva = gfn_to_hva_memslot_prot(memslot, gfn, NULL);
+		if (kvm_is_error_hva(hva)) {
+			ret = -EFAULT;
+			goto out;
+		}
+		ret = user_mem_abort(vcpu, ipa, NULL, memslot, &page_size, hva,
+				     false);
+	}
+
+	if (ret < 0)
+		goto out;
+
+	end = (range->gpa & ~(page_size - 1)) + page_size;
+	ret = min(range->size, end - range->gpa);
+
+out:
+	fault_info->esr_el2 = esr;
+	fault_info->hpfar_el2 = hpfar;
+out_unlock:
+	srcu_read_unlock(&vcpu->kvm->srcu, idx);
+	return ret;
+}

>> +long kvm_arch_vcpu_pre_fault_memory(struct kvm_vcpu *vcpu,
>> +				    struct kvm_pre_fault_memory *range)
>> +{
>> +	int r;
>> +	hva_t hva;
>> +	phys_addr_t end;
>> +	long page_size;
>> +	struct kvm_memory_slot *memslot;
>> +	phys_addr_t ipa = range->gpa;
>> +	gfn_t gfn = gpa_to_gfn(range->gpa);
>> +
>> +	while (true) {
>> +		page_size = PAGE_SIZE;
>> +		memslot = gfn_to_memslot(vcpu->kvm, gfn);
>> +		if (!memslot)
>> +			return -ENOENT;
>> +
>> +		if (kvm_slot_has_gmem(memslot)) {
>> +			r = __gmem_abort(vcpu, ipa, NULL, memslot, false, true);
>> +		} else {
>> +			hva = gfn_to_hva_memslot_prot(memslot, gfn, NULL);
>> +			if (kvm_is_error_hva(hva))
>> +				return -EFAULT;
>> +			r = __user_mem_abort(vcpu, ipa, NULL, memslot, &page_size, hva, false,
>> +					     true);
>> +		}
>> +
>> +		if (r != -EAGAIN)
>> +			break;
>> +
>> +		if (signal_pending(current))
>> +			return -EINTR;
>> +
>> +		if (kvm_check_request(KVM_REQ_VM_DEAD, vcpu))
>> +			return -EIO;
>> +
>> +		cond_resched();
>> +	};
> 
> Why do we need another retry loop? Looks like we've already got one in
> the arch-generic code.
>

Good point thanks, I've removed that now.

> 
> Thanks,
> Oliver

Thanks,
Jack
