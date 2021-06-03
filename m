Return-Path: <SRS0=VfsR=K6=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ECDAEC07E94
	for <kvmarm@archiver.kernel.org>; Fri,  4 Jun 2021 08:52:03 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 7ED3F61358
	for <kvmarm@archiver.kernel.org>; Fri,  4 Jun 2021 08:52:03 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7ED3F61358
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1D4694B116;
	Fri,  4 Jun 2021 04:52:03 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Hx+OJDz8zibx; Fri,  4 Jun 2021 04:51:59 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DADF84B103;
	Fri,  4 Jun 2021 04:51:54 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6B0034B0B4
 for <kvmarm@lists.cs.columbia.edu>; Thu,  3 Jun 2021 16:16:02 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id BIK3YHWXklvR for <kvmarm@lists.cs.columbia.edu>;
 Thu,  3 Jun 2021 16:16:00 -0400 (EDT)
Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com
 [209.85.214.178])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id C5E1F4B0B3
 for <kvmarm@lists.cs.columbia.edu>; Thu,  3 Jun 2021 16:16:00 -0400 (EDT)
Received: by mail-pl1-f178.google.com with SMTP id c13so3513777plz.0
 for <kvmarm@lists.cs.columbia.edu>; Thu, 03 Jun 2021 13:16:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=KkXZ4sXSYrDtinr9db7PbN7PZh+I0TjjzE8qan53Yqw=;
 b=HQKWOL8xmBXFF1rksHD1Y+UjZvhRCkMZmRtV/GoCfbBmjfWEcnWHbaSXbHkhuslMwd
 U89kleP9JhcNhU/pss2Ye1kZjcWEUzOBr8sg1B463QDrAJrVKh591MhGmhKC6fZA4fHm
 TJuDRKhqhDAqdvXx5rNi1dkVs7VZ9ocQfgVnCeiYosOh05PBuknD5nd+7myBg4hL2xwo
 fBFM/gUoRSBeiI4ACDCpTPPRlFXFRB40hA0RvHdtkwstLdBtMcntSfHAq3PzA7fkRwXd
 /rVxS63UoOxrbsRahUsQM9KvF4y/pinSp9YkqnEIZ/T3R/hNoJi5m/qKLiOW1rBKqAqw
 D/HQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=KkXZ4sXSYrDtinr9db7PbN7PZh+I0TjjzE8qan53Yqw=;
 b=HvDkE76Za7AuQoeiH6SRPdllP/yHcKpKkJe/C340i40ZtREpkkA0DE2F4FJF4CqKPP
 HIaC/xYDQ7L0UNaksjGBrh6Iqol8KyjYFMTBIlCG99THMEoKPD0hXSUAFv/bY3YdYc8L
 HKXiHo2QO3vLb9zRrSTWLLAcS+PjLV1YLW8tFFLj2WmGQMasAcb+KVMRxGm8PnyN6Jhv
 c/7eweJTqo5cPul1TjYx0U4GTSwBWGjzxfzwRALLAB9a0uo7KM1XmSU3uQGX1/JAWKm2
 g/ziiDdjA/940YJOMC9nyEzO6sSVV0yl183dXXl/BVDMNF/82rFgUHCkYI7hyIF8vAdC
 v+AA==
X-Gm-Message-State: AOAM531ufuA+xAXnOj9/7H/zv8NH74M39jm0RtZzE48M7iIZ/LGxXvbT
 A5Kgq0ccm7QWemGN3xdnaPusWQ==
X-Google-Smtp-Source: ABdhPJzGt7UQZHAEA3b4VX3+SADBsxohwahUTfrm1TqdzFPVfW6F1Sf+M7UxVfM10t3CKtiUfIIObw==
X-Received: by 2002:a17:90a:e7c8:: with SMTP id
 kb8mr989516pjb.60.1622751359623; 
 Thu, 03 Jun 2021 13:15:59 -0700 (PDT)
Received: from google.com (240.111.247.35.bc.googleusercontent.com.
 [35.247.111.240])
 by smtp.gmail.com with ESMTPSA id d12sm2699401pfv.190.2021.06.03.13.15.58
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Thu, 03 Jun 2021 13:15:58 -0700 (PDT)
Date: Thu, 3 Jun 2021 20:15:55 +0000
From: Sean Christopherson <seanjc@google.com>
To: Will Deacon <will@kernel.org>
Subject: Re: [RFC PATCH 4/4] KVM: arm64: Introduce KVM_CAP_ARM_PROTECTED_VM
Message-ID: <YLk4e4hark3Zhi3f@google.com>
References: <20210603183347.1695-1-will@kernel.org>
 <20210603183347.1695-5-will@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20210603183347.1695-5-will@kernel.org>
X-Mailman-Approved-At: Fri, 04 Jun 2021 04:51:53 -0400
Cc: kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
 linux-arm-kernel@lists.infradead.org, Paolo Bonzini <pbonzini@redhat.com>,
 kvmarm@lists.cs.columbia.edu
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

On Thu, Jun 03, 2021, Will Deacon wrote:
> +Enabling this capability causes all memory slots of the specified VM to be
> +unmapped from the host system and put into a state where they are no longer
> +configurable.

What happens if userspace remaps the hva of the memslot?  In other words, how
will the implementation ensure the physical memory backing the guest is truly
inaccessible?

And how will the guest/host share memory?  E.g. what if the guest wants to set
up a new shared memory region and the host wants that to happen in a new memslot?

On a related topic, would the concept of guest-only memory be useful[*]?  The
idea is to require userspace to map guest-private memory with a dedicated VMA
flag.  That will allow the host kernel to prevent userspace (or the kernel) from
mapping guest-private memory, and will also allow KVM to verify that memory that
the guest wants to be private is indeed private.

[*] https://lkml.kernel.org/r/20210416154106.23721-14-kirill.shutemov@linux.intel.com

> The memory slot corresponding to the ID passed in args[0] is
> +populated with the guest firmware image provided by the host firmware.

Why take a slot instead of an address range?  I assume copying the host firmware
into guest memory will utilize existing APIs, i.e. the memslot lookups to resolve
the GPA->HVA will Just Work (TM).

> +The first vCPU to enter the guest is defined to be the primary vCPU. All other
> +vCPUs belonging to the VM are secondary vCPUs.
> +
> +All vCPUs belonging to a VM with this capability enabled are initialised to a
> +pre-determined reset state irrespective of any prior configuration according to
> +the KVM_ARM_VCPU_INIT ioctl, with the following exceptions for the primary
> +vCPU:
> +
> +	===========	===========
> +	Register(s)	Reset value
> +	===========	===========
> +	X0-X14:		Preserved (see KVM_SET_ONE_REG)

What's the intended use case for allowing userspace to set a pile of registers?
Giving userspace control of vCPU state is tricky because the state is untrusted.
Is the state going to be attested in any way, or is the VMM trusted while the
VM is being created and only de-privileged later on?

> +	X15:		Boot protocol version (0)
> +	X16-X30:	Reserved (0)
> +	PC:		IPA base of firmware memory slot
> +	SP:		IPA end of firmware memory slot
> +	===========	===========
> +

...

> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index c5d1f3c87dbd..e1d4a87d18e4 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@ -1349,6 +1349,9 @@ int kvm_arch_prepare_memory_region(struct kvm *kvm,
>  	bool writable = !(mem->flags & KVM_MEM_READONLY);
>  	int ret = 0;
>  
> +	if (kvm_vm_is_protected(kvm))
> +		return -EPERM;

FWIW, this will miss the benign corner case where KVM_SET_USER_MEMORY_REGION
does not actualy change anything about an existing region.

A more practical problem is that this check won't happen until KVM has marked
the existing region as invalid in the DELETE or MOVE case.  So userspace can't
completely delete a region, but it can temporarily delete a region by briefly
making it in invalid.  No idea what the ramifications of that are on arm64.

>  	if (change != KVM_MR_CREATE && change != KVM_MR_MOVE &&
>  			change != KVM_MR_FLAGS_ONLY)
>  		return 0;

...

> +static int pkvm_vm_ioctl_enable(struct kvm *kvm, u64 slotid)
> +{
> +	int ret = 0;

Deep into the nits: technically unnecessary since ret is guaranteed to be written
before being consumed.

> +	mutex_lock(&kvm->lock);
> +	if (kvm_vm_is_protected(kvm)) {
> +		ret = -EPERM;
> +		goto out_kvm_unlock;
> +	}
> +
> +	mutex_lock(&kvm->slots_lock);
> +	ret = pkvm_enable(kvm, slotid);
> +	if (ret)
> +		goto out_slots_unlock;
> +
> +	kvm->arch.pkvm.enabled = true;
> +out_slots_unlock:
> +	mutex_unlock(&kvm->slots_lock);
> +out_kvm_unlock:
> +	mutex_unlock(&kvm->lock);
> +	return ret;
> +}

...

> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> index 3fd9a7e9d90c..58ab8508be5e 100644
> --- a/include/uapi/linux/kvm.h
> +++ b/include/uapi/linux/kvm.h
> @@ -1082,6 +1082,7 @@ struct kvm_ppc_resize_hpt {
>  #define KVM_CAP_SGX_ATTRIBUTE 196
>  #define KVM_CAP_VM_COPY_ENC_CONTEXT_FROM 197
>  #define KVM_CAP_PTP_KVM 198
> +#define KVM_CAP_ARM_PROTECTED_VM 199

Rather than a dedicated (and arm-only) capability for protected VMs, what about
adding a capability to retrieve the supported VM types?  And obviously make
protected VMs a different type that must be specified at VM creation (there's
already plumbing for this).  Even if there's no current need to know at creation
time that a VM will be protected, it's also unlikely to be a burden on userspace
and could be nice to have down the road.  The late "activation" ioctl() can still
be supported, e.g. to start disallowing memslot updates.

x86 with TDX would look like:

        case KVM_CAP_VM_TYPES:
                r = BIT(KVM_X86_LEGACY_VM);
                if (kvm_x86_ops.is_vm_type_supported(KVM_X86_TDX_VM))
                        r |= BIT(KVM_X86_TDX_VM);
                break;

and arm64 would look like?

	case KVM_CAP_VM_TYPES:
		r = BIT(KVM_ARM64_LEGACY_VM);
		if (kvm_get_mode() == KVM_MODE_PROTECTED)
			r |= BIT(KVM_ARM64_PROTECTED_VM);
		break;

>  #ifdef KVM_CAP_IRQ_ROUTING
>  
> -- 
> 2.32.0.rc0.204.g9fa02ecfa5-goog
> 
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
