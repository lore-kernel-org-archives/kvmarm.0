Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 098AEC433FE
	for <kvmarm@archiver.kernel.org>; Tue, 14 Dec 2021 12:09:39 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7A7314B1D0;
	Tue, 14 Dec 2021 07:09:39 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id UQZKnOVziXuz; Tue, 14 Dec 2021 07:09:37 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 98EA04B1B4;
	Tue, 14 Dec 2021 07:09:37 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9E02F4B1A4
 for <kvmarm@lists.cs.columbia.edu>; Tue, 14 Dec 2021 07:09:35 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id PmUv0+GhfZtq for <kvmarm@lists.cs.columbia.edu>;
 Tue, 14 Dec 2021 07:09:33 -0500 (EST)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D48BD4B11A
 for <kvmarm@lists.cs.columbia.edu>; Tue, 14 Dec 2021 07:09:33 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1639483773;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=Zy0wskww+aD2/4R9ZsqKne9pFIj+xfx8T5GmY2bY06U=;
 b=MYmrqmoUAa4EF7Bl55s9mOo7XvZsq8btoEtmQuLJ64+fmOBHygv1/g6/Cxj27MGblRn3yi
 AIMvLf7eC6wfztqj/hhKg1R8RhNNhCHp/weU3i0rZ9+1MUMx+h2DYPBqJ4xpQpwtp6R4im
 Aedbakr2Pwi7CjQ+lzhYCvdENCnzStY=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-16-JX_dvpjaMaGmNaNNWSCz7w-1; Tue, 14 Dec 2021 07:09:32 -0500
X-MC-Unique: JX_dvpjaMaGmNaNNWSCz7w-1
Received: by mail-ed1-f72.google.com with SMTP id
 s12-20020a50ab0c000000b003efdf5a226fso16742563edc.10
 for <kvmarm@lists.cs.columbia.edu>; Tue, 14 Dec 2021 04:09:32 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=Zy0wskww+aD2/4R9ZsqKne9pFIj+xfx8T5GmY2bY06U=;
 b=Uo3HC4674yI2AlWYpDifsqIqkRMseT3/SlNx2HztGwyVWgRj2KMDPFSuRFeqIrICs3
 4kDQrjgYfIuvBahIusCamMRs4t5PRe3aJMGI5WM4pzGeMFeYp+yuzVPHqvIwVXry9YvU
 TEIS8yS36PuTAE0F4RbQbAMxgdEl46h3IX2dkBhJ+N1sjxh8jhNlxZc9OsjuUcInY48l
 jR8fQRipUT0femTCmq7M1/X+R/rnsV7+cESpQAgmAes3S2YLy6ye76e/Icms+TS3GHkT
 k9LAmuYwBmNx9fPWitNvzYHEm+ePGs76aeXCCfWTZ2JWErOC1GL6bNr0GXFq0d1sBGfT
 eC7w==
X-Gm-Message-State: AOAM532/PGfRqbKOakgllKrcDVVSnsmi8mq4kEQJBDDMHxuoyF5F+bJd
 AJnnwp64/JGf0M2mhpGHS4xkPhdXI+dBa/5dzBv9xnzMFWyf64z64NH9OuID+SYn7nmPOBaatJg
 WrxbsVCikMlr0gst1jYeBrmni
X-Received: by 2002:a17:907:868f:: with SMTP id
 qa15mr5650123ejc.187.1639483771085; 
 Tue, 14 Dec 2021 04:09:31 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyOpILr0mhEwipv1ApcLa1BJG0zL6YJeRPArz+qAbMaMR+TRdkE01PvCCD0LCewPKyGHjjq4Q==
X-Received: by 2002:a17:907:868f:: with SMTP id
 qa15mr5650100ejc.187.1639483770836; 
 Tue, 14 Dec 2021 04:09:30 -0800 (PST)
Received: from gator.home (cst2-173-70.cust.vodafone.cz. [31.30.173.70])
 by smtp.gmail.com with ESMTPSA id hs20sm7108855ejc.26.2021.12.14.04.09.29
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Tue, 14 Dec 2021 04:09:30 -0800 (PST)
Date: Tue, 14 Dec 2021 13:09:27 +0100
From: Andrew Jones <drjones@redhat.com>
To: Alexandru Elisei <alexandru.elisei@arm.com>
Subject: Re: [kvm-unit-tests PATCH 0/4] arm: Timer fixes
Message-ID: <20211214120927.ownvywkbjqpyfbmz@gator.home>
References: <20211207154641.87740-1-alexandru.elisei@arm.com>
MIME-Version: 1.0
In-Reply-To: <20211207154641.87740-1-alexandru.elisei@arm.com>
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=drjones@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Cc: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
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

On Tue, Dec 07, 2021 at 03:46:37PM +0000, Alexandru Elisei wrote:
> This series intends to fix two bugs in the timer test. The first one is the
> TVAL comparison to check that the timer has expired and was found by code
> inspection.
> 
> The second one I found while playing with KVM, but it can manifest itself
> on certain hardware configuration with an unmodified version of KVM
> (details in the commit message for the last patch). Or on baremetal (not
> tested). In short, WFI can complete for a variety of reason, not just
> because an interrupt targetted at the VM was asserted. The fix I
> implemented was to do WFI in a loop until we get the interrupt or TVAL
> shows that the timer has expired.
> 
> All the patches in between are an attempt make the tests more robust and
> slightly easier to understand. If these changes are considered unnecessary,
> I would be more than happy to drop them; the main goal of the series is to
> fix the two bugs.
> 
> Tested on a rockpro64 with KVM modifed to clear HCR_EL2.TWI, which means
> that the WFI instruction is not trapped (WFI trapping is a performance
> optimization, not a correctness requirement):
> 
> diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
> index f4871e47b2d0..9af13e01ffeb 100644
> --- a/arch/arm64/include/asm/kvm_emulate.h
> +++ b/arch/arm64/include/asm/kvm_emulate.h
> @@ -96,18 +96,12 @@ static inline unsigned long *vcpu_hcr(struct kvm_vcpu *vcpu)
>  
>  static inline void vcpu_clear_wfx_traps(struct kvm_vcpu *vcpu)
>  {
> -       vcpu->arch.hcr_el2 &= ~HCR_TWE;
> -       if (atomic_read(&vcpu->arch.vgic_cpu.vgic_v3.its_vpe.vlpi_count) ||
> -           vcpu->kvm->arch.vgic.nassgireq)
> -               vcpu->arch.hcr_el2 &= ~HCR_TWI;
> -       else
> -               vcpu->arch.hcr_el2 |= HCR_TWI;
> +       vcpu->arch.hcr_el2 &= ~(HCR_TWE | HCR_TWI);
>  }
>  
>  static inline void vcpu_set_wfx_traps(struct kvm_vcpu *vcpu)
>  {
> -       vcpu->arch.hcr_el2 |= HCR_TWE;
> -       vcpu->arch.hcr_el2 |= HCR_TWI;
> +       vcpu->arch.hcr_el2 &= ~(HCR_TWE | HCR_TWI);
>  }
>  
>  static inline void vcpu_ptrauth_enable(struct kvm_vcpu *vcpu)
> 
> Log when running ./run_test.sh timer (truncated for brevity) without the
> fixes:
> 
> ...
> INFO: vtimer-busy-loop: waiting for interrupt...
> FAIL: vtimer-busy-loop: interrupt received after TVAL/WFI
> FAIL: vtimer-busy-loop: timer has expired
> INFO: vtimer-busy-loop: TVAL is 144646 ticks
> ...
> INFO: ptimer-busy-loop: waiting for interrupt...
> FAIL: ptimer-busy-loop: interrupt received after TVAL/WFI
> FAIL: ptimer-busy-loop: timer has expired
> INFO: ptimer-busy-loop: TVAL is 50384 ticks
> SUMMARY: 18 tests, 4 unexpected failures
> 
> Log when running the same command with the series applied:
> 
> ...
> INFO: vtimer-busy-loop: waiting for interrupt...
> INFO: vtimer-busy-loop: waiting for interrupt...
> INFO: vtimer-busy-loop: waiting for interrupt...
> PASS: vtimer-busy-loop: interrupt received after TVAL/WFI
> PASS: vtimer-busy-loop: timer has expired
> INFO: vtimer-busy-loop: TVAL is -56982 ticks
> ...
> INFO: ptimer-busy-loop: waiting for interrupt...
> INFO: ptimer-busy-loop: waiting for interrupt...
> PASS: ptimer-busy-loop: interrupt received after TVAL/WFI
> PASS: ptimer-busy-loop: timer has expired
> INFO: ptimer-busy-loop: TVAL is -22997 ticks
> SUMMARY: 18 tests
> 
> 
> Alexandru Elisei (4):
>   arm: timer: Fix TVAL comparison for timer condition met
>   arm: timer: Move the different tests into their own functions
>   arm: timer: Test CVAL before interrupt pending state
>   arm: timer: Take into account other wake-up events for the TVAL test
> 
>  arm/timer.c | 81 +++++++++++++++++++++++++++++++++++++++++++----------
>  1 file changed, 66 insertions(+), 15 deletions(-)
> 
> -- 
> 2.34.1
>

Pushed to https://gitlab.com/rhdrjones/kvm-unit-tests/-/commits/arm/queue

Thanks,
drew 

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
