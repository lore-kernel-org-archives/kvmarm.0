Return-Path: <SRS0=oZIB=PX=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BD7D4C433EF
	for <kvmarm@archiver.kernel.org>; Thu,  4 Nov 2021 16:34:08 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 3F14461244
	for <kvmarm@archiver.kernel.org>; Thu,  4 Nov 2021 16:34:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 3F14461244
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id AD4D24B10C;
	Thu,  4 Nov 2021 12:34:07 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id NO8jYmIEBz+X; Thu,  4 Nov 2021 12:34:06 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0B89E4B10A;
	Thu,  4 Nov 2021 12:34:06 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B25C64B103
 for <kvmarm@lists.cs.columbia.edu>; Thu,  4 Nov 2021 12:34:04 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 5LLET-fEJ3g1 for <kvmarm@lists.cs.columbia.edu>;
 Thu,  4 Nov 2021 12:34:03 -0400 (EDT)
Received: from mail-il1-f170.google.com (mail-il1-f170.google.com
 [209.85.166.170])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 2B1A04B0F7
 for <kvmarm@lists.cs.columbia.edu>; Thu,  4 Nov 2021 12:34:03 -0400 (EDT)
Received: by mail-il1-f170.google.com with SMTP id i12so6745558ila.12
 for <kvmarm@lists.cs.columbia.edu>; Thu, 04 Nov 2021 09:34:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=q1yu7/PiEk97jw7ubKDogFhwFOEgMTEG87VVKJNSDwY=;
 b=EmOtiopjfneALNBRoVKWdawMl2M3KkYtZiMbYTbeoSRNPxNFamFJB15UGYz5w2SI0V
 kS6SMvi0/7oAX0/I8ZpuwQzXHak5mm+OqBWONBBZEvsbl38UD16F4Oxm6NZUOfILYPev
 D8nE6nibTuyBs+B07ZBC8kxTRG/bM+Hb4xwNQ+WfUsrK2/bYav2KZYxxd0hk9OeuTBmm
 vJffFoDaTHslbMOF0C/QKV4V64g0kvK4dIVATns44Wo6qOJ2TSDNLlNUwGRUOqlhBY/l
 yMtMsM8rami0HJCsSdD8bRWAZK2iXVxVjCivrjdV1RQPcULQViCSUIojiNUVagaYvIsA
 ++bw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=q1yu7/PiEk97jw7ubKDogFhwFOEgMTEG87VVKJNSDwY=;
 b=PoYqabDcJL9Q1Kpr1GnNR52XuXkLvTyJwM0GjzaRXjkRyFGPvPmKSawFNu4+O0/sa0
 8t0ZwfWjXcP1Iz2kgKRyUw9x68vg4QKiC5iIbqP0tvN88hXqVYjPHcYEf2IssVnklKRP
 durV52AhTyx1jkJStSQlpu3KBSCFwdw9E4qUDKxhP8eaxMEc/x4OUqkEXeDUHF6Gnq3R
 7fRgiwiQGj1+LuCSX6Fc5uHn04MJDySrgZkRpsczJgiJk9JqwBAZXQUF1eRQBqKMaScb
 5NP2Fi1OZnz+dZTKVREnZ1gcjBDV+Q5qmkvhnjr9QJkiQ1ERwwTCi322JEsWwMlVISGm
 y4LA==
X-Gm-Message-State: AOAM530kUYRpQqwduNgBwJpQ/53uZspmwzD/AP8srRWnP3gxOADLdHZ2
 RyVnbQyJrrPlSN8ZXXwy7eUi1w==
X-Google-Smtp-Source: ABdhPJw21oNXW5cMVRe+U/gVxiAeINDXbZ00FJbMCyzm7P2yY2n2xfR22DKFXu21MwzMG+ENi/zSnQ==
X-Received: by 2002:a92:c80d:: with SMTP id v13mr36807785iln.175.1636043642354; 
 Thu, 04 Nov 2021 09:34:02 -0700 (PDT)
Received: from google.com (194.225.68.34.bc.googleusercontent.com.
 [34.68.225.194])
 by smtp.gmail.com with ESMTPSA id z6sm2930080ioq.35.2021.11.04.09.34.01
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Thu, 04 Nov 2021 09:34:01 -0700 (PDT)
Date: Thu, 4 Nov 2021 16:33:58 +0000
From: Oliver Upton <oupton@google.com>
To: Reiji Watanabe <reijiw@google.com>
Subject: Re: [RFC PATCH v2 04/28] KVM: arm64: Keep consistency of ID
 registers between vCPUs
Message-ID: <YYQLdtcjiTESMFES@google.com>
References: <20211103062520.1445832-1-reijiw@google.com>
 <20211103062520.1445832-5-reijiw@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20211103062520.1445832-5-reijiw@google.com>
Cc: kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
 Peter Shier <pshier@google.com>, Will Deacon <will@kernel.org>,
 Paolo Bonzini <pbonzini@redhat.com>, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

On Tue, Nov 02, 2021 at 11:24:56PM -0700, Reiji Watanabe wrote:
> All vCPUs that are owned by a VM must have the same values of ID
> registers.
> 
> Return an error at the very first KVM_RUN for a vCPU if the vCPU has
> different values in any ID registers from any other vCPUs that have
> already started KVM_RUN once.  Also, return an error if userspace
> tries to change a value of ID register for a vCPU that already
> started KVM_RUN once.
> 
> Changing ID register is still not allowed at present though.
> 
> Signed-off-by: Reiji Watanabe <reijiw@google.com>
> ---
>  arch/arm64/include/asm/kvm_host.h |  2 ++
>  arch/arm64/kvm/arm.c              |  4 ++++
>  arch/arm64/kvm/sys_regs.c         | 31 +++++++++++++++++++++++++++++++
>  3 files changed, 37 insertions(+)
> 
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index 0cd351099adf..69af669308b0 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -745,6 +745,8 @@ int kvm_arm_vcpu_arch_has_attr(struct kvm_vcpu *vcpu,
>  long kvm_vm_ioctl_mte_copy_tags(struct kvm *kvm,
>  				struct kvm_arm_copy_mte_tags *copy_tags);
>  
> +int kvm_id_regs_consistency_check(const struct kvm_vcpu *vcpu);
> +
>  /* Guest/host FPSIMD coordination helpers */
>  int kvm_arch_vcpu_run_map_fp(struct kvm_vcpu *vcpu);
>  void kvm_arch_vcpu_load_fp(struct kvm_vcpu *vcpu);
> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> index fe102cd2e518..83cedd74de73 100644
> --- a/arch/arm64/kvm/arm.c
> +++ b/arch/arm64/kvm/arm.c
> @@ -595,6 +595,10 @@ static int kvm_vcpu_first_run_init(struct kvm_vcpu *vcpu)
>  		return -EPERM;
>  
>  	vcpu->arch.has_run_once = true;
> +	if (kvm_id_regs_consistency_check(vcpu)) {
> +		vcpu->arch.has_run_once = false;
> +		return -EPERM;
> +	}

It might be nice to return an error to userspace synchronously (i.e. on
the register write). Of course, there is still the issue where userspace
writes to some (but not all) of the vCPU feature ID registers, which
can't be known until the first KVM_RUN.

>  
>  	kvm_arm_vcpu_init_debug(vcpu);
>  
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index 64d51aa3aee3..e34351fdc66c 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -1436,6 +1436,10 @@ static int __set_id_reg(struct kvm_vcpu *vcpu,
>  	if (val != read_id_reg(vcpu, rd, raz) && !GET_ID_REG_INFO(encoding))
>  		return -EINVAL;
>  
> +	/* Don't allow to change the reg after the first KVM_RUN. */
> +	if (vcpu->arch.has_run_once)
> +		return -EINVAL;
> +
>  	if (raz)
>  		return 0;
>  
> @@ -3004,6 +3008,33 @@ int kvm_arm_copy_sys_reg_indices(struct kvm_vcpu *vcpu, u64 __user *uindices)
>  	return write_demux_regids(uindices);
>  }
>  
> +int kvm_id_regs_consistency_check(const struct kvm_vcpu *vcpu)
> +{
> +	int i;
> +	const struct kvm_vcpu *t_vcpu;
> +
> +	/*
> +	 * Make sure vcpu->arch.has_run_once is visible for others so that
> +	 * ID regs' consistency between two vCPUs is checked by either one
> +	 * at least.
> +	 */
> +	smp_mb();
> +	WARN_ON(!vcpu->arch.has_run_once);
> +
> +	kvm_for_each_vcpu(i, t_vcpu, vcpu->kvm) {
> +		if (!t_vcpu->arch.has_run_once)
> +			/* ID regs still could be updated. */
> +			continue;
> +
> +		if (memcmp(&__vcpu_sys_reg(vcpu, ID_REG_BASE),
> +			   &__vcpu_sys_reg(t_vcpu, ID_REG_BASE),
> +			   sizeof(__vcpu_sys_reg(vcpu, ID_REG_BASE)) *
> +					KVM_ARM_ID_REG_MAX_NUM))
> +			return -EINVAL;
> +	}
> +	return 0;
> +}
> +

Couldn't we do the consistency check exactly once per VM? I had alluded
to this when reviewing Raghu's patches, but I think the same applies
here too: an abstraction for detecting the first vCPU to run in a VM.

https://lore.kernel.org/all/YYMKphExkqttn2w0@google.com/

--
Thanks
Oliver
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
