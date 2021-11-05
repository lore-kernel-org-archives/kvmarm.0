Return-Path: <SRS0=hs0s=PY=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 62CCFC433EF
	for <kvmarm@archiver.kernel.org>; Fri,  5 Nov 2021 20:04:05 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id CBC6861183
	for <kvmarm@archiver.kernel.org>; Fri,  5 Nov 2021 20:04:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org CBC6861183
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3C8BE4A1B0;
	Fri,  5 Nov 2021 16:04:04 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 0zMf8mq3u4WV; Fri,  5 Nov 2021 16:04:03 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 028E54B163;
	Fri,  5 Nov 2021 16:04:03 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 780F84A1B0
 for <kvmarm@lists.cs.columbia.edu>; Fri,  5 Nov 2021 16:04:01 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id BEwcVliflLRX for <kvmarm@lists.cs.columbia.edu>;
 Fri,  5 Nov 2021 16:03:59 -0400 (EDT)
Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com
 [209.85.210.171])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 916094B160
 for <kvmarm@lists.cs.columbia.edu>; Fri,  5 Nov 2021 16:03:59 -0400 (EDT)
Received: by mail-pf1-f171.google.com with SMTP id g11so9808080pfv.7
 for <kvmarm@lists.cs.columbia.edu>; Fri, 05 Nov 2021 13:03:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=PN/lxoi+e5tCVO5pPjxKDOBewixY35Ifh+V+MQmKh2Y=;
 b=f5rhbj9pb5GgTT0825+tujieonyli7SwThgHMXaD3NP3Mog1A094HPsqZZlkGOJ/Q+
 r3ZJnNzRBB3NhkN8VE/G5vrgRKhdENk2u9DuDgAERoqocOOeFGdBNvbmuevHRGuv/PzT
 2oM9e8uLyVHxjP0SBflIjCbS2YVvFiGTQPV4FXb1yFhkAV2Dwb/b8vz1V1fKzExBfVLb
 Xj15HqIIyyCqzeQTYv54iKEeMFkAbdprvcVA6NgVuqrrvC5EFRz5/vl/ehO9cRPXvPHn
 fwuRS81bHhHxNVlMCQCaLVr17+7bYqD4G5MIyYU1T+K/ui2sRBFDHO8DZRxHvFM9pN8W
 0Kfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=PN/lxoi+e5tCVO5pPjxKDOBewixY35Ifh+V+MQmKh2Y=;
 b=rvs0mepdsaATwE+No4Po1f2buxzEt+Iu2my29n+tLuxj8pxjB3UBOHuA3ahHVM2KAc
 rukbX1RiH7VKaAKU63MB+fud8MZSl+1h1C19NphJM3TOqs/U3eFa+UxIabv00u/FpZ0O
 3lsuN1a0gv3J+TYKfujyYN7Jgg+LiJ8MkXKEmB49v/Q9X06Rhzfo3AvlxYIpEj4gClQ5
 jIvQkm2yW2PsQM5bjBGRhFCOks3S1f2lp/LNg461vJLStVtKKFbjMglTX8bGKWX185GJ
 oDetUhTFFNgZ/ry1mgJJiHzjORC6VLa0WvQG5OFOWvKitY3LGjhg+7jE5TIjE+wD9Trs
 wveQ==
X-Gm-Message-State: AOAM5319809vuntMKaIFgoaDWkA2TNJ/TpOBVFA7pXzhEXdNv/PdYtfG
 DLohxusRNmgDUFqP1wfrEv16IQ==
X-Google-Smtp-Source: ABdhPJyd4QYc+InpdUIun9J0aiQkUM13aDBr60E6YJVxeHTQZZxRXWXSmp46OuKH+1B6vf2ZVsVbyQ==
X-Received: by 2002:a05:6a00:22d1:b0:494:72c5:803b with SMTP id
 f17-20020a056a0022d100b0049472c5803bmr10239284pfj.84.1636142638330; 
 Fri, 05 Nov 2021 13:03:58 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com.
 [35.185.214.157])
 by smtp.gmail.com with ESMTPSA id c198sm6639870pga.6.2021.11.05.13.03.57
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Fri, 05 Nov 2021 13:03:57 -0700 (PDT)
Date: Fri, 5 Nov 2021 20:03:53 +0000
From: Sean Christopherson <seanjc@google.com>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH 4/5] KVM: x86: Use kvm_get_vcpu() instead of open-coded
 access
Message-ID: <YYWOKTYHhJywwCRk@google.com>
References: <20211105192101.3862492-1-maz@kernel.org>
 <20211105192101.3862492-5-maz@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20211105192101.3862492-5-maz@kernel.org>
Cc: Juergen Gross <jgross@suse.com>, Anup Patel <anup.patel@wdc.com>,
 Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org,
 Christian Borntraeger <borntraeger@de.ibm.com>,
 Michael Ellerman <mpe@ellerman.id.au>, Huacai Chen <chenhuacai@kernel.org>,
 David Hildenbrand <david@redhat.com>, linux-mips@vger.kernel.org,
 Nicholas Piggin <npiggin@gmail.com>, Atish Patra <atish.patra@wdc.com>,
 Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
 Paul Mackerras <paulus@samba.org>, Paolo Bonzini <pbonzini@redhat.com>,
 kernel-team@android.com, Claudio Imbrenda <imbrenda@linux.ibm.com>,
 linuxppc-dev@lists.ozlabs.org, kvmarm@lists.cs.columbia.edu
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

On Fri, Nov 05, 2021, Marc Zyngier wrote:
> As we are about to change the way vcpus are allocated, mandate
> the use of kvm_get_vcpu() instead of open-coding the access.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/x86/kvm/vmx/posted_intr.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/vmx/posted_intr.c b/arch/x86/kvm/vmx/posted_intr.c
> index 5f81ef092bd4..82a49720727d 100644
> --- a/arch/x86/kvm/vmx/posted_intr.c
> +++ b/arch/x86/kvm/vmx/posted_intr.c
> @@ -272,7 +272,7 @@ int pi_update_irte(struct kvm *kvm, unsigned int host_irq, uint32_t guest_irq,
>  
>  	if (!kvm_arch_has_assigned_device(kvm) ||
>  	    !irq_remapping_cap(IRQ_POSTING_CAP) ||
> -	    !kvm_vcpu_apicv_active(kvm->vcpus[0]))
> +	    !kvm_vcpu_apicv_active(kvm_get_vcpu(kvm, 0)))

Huh.  The existing code is decidedly odd.  I think it might even be broken, as
it's not obvious that vCPU0 _must_ be created when e.g. kvm_arch_irq_bypass_add_producer()
is called.

An equivalent, safe check would be:

diff --git a/arch/x86/kvm/vmx/posted_intr.c b/arch/x86/kvm/vmx/posted_intr.c
index 5f81ef092bd4..a3100591a9ca 100644
--- a/arch/x86/kvm/vmx/posted_intr.c
+++ b/arch/x86/kvm/vmx/posted_intr.c
@@ -272,7 +272,7 @@ int pi_update_irte(struct kvm *kvm, unsigned int host_irq, uint32_t guest_irq,

        if (!kvm_arch_has_assigned_device(kvm) ||
            !irq_remapping_cap(IRQ_POSTING_CAP) ||
-           !kvm_vcpu_apicv_active(kvm->vcpus[0]))
+           !kvm_apicv_activated(kvm))
                return 0;

        idx = srcu_read_lock(&kvm->irq_srcu);


But I think even that is flawed, as APICv can be dynamically deactivated and
re-activated while the VM is running, and I don't see a path that re-updates
the IRTE when APICv is re-activated.  So I think a more conservative check is
needed, e.g.

diff --git a/arch/x86/kvm/vmx/posted_intr.c b/arch/x86/kvm/vmx/posted_intr.c
index 5f81ef092bd4..6cf5b2e86118 100644
--- a/arch/x86/kvm/vmx/posted_intr.c
+++ b/arch/x86/kvm/vmx/posted_intr.c
@@ -272,7 +272,7 @@ int pi_update_irte(struct kvm *kvm, unsigned int host_irq, uint32_t guest_irq,

        if (!kvm_arch_has_assigned_device(kvm) ||
            !irq_remapping_cap(IRQ_POSTING_CAP) ||
-           !kvm_vcpu_apicv_active(kvm->vcpus[0]))
+           !irqchip_in_kernel(kvm) || !enable_apicv)
                return 0;

        idx = srcu_read_lock(&kvm->irq_srcu);


Paolo, am I missing something?
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
