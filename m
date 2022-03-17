Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC712C433F5
	for <kvmarm@archiver.kernel.org>; Thu, 17 Mar 2022 05:37:41 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2190049F10;
	Thu, 17 Mar 2022 01:37:41 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id DRzkXoWYPcUU; Thu, 17 Mar 2022 01:37:39 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E7E5049F05;
	Thu, 17 Mar 2022 01:37:39 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3828449F07
 for <kvmarm@lists.cs.columbia.edu>; Thu, 17 Mar 2022 01:37:39 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ZOe8jdoklMw7 for <kvmarm@lists.cs.columbia.edu>;
 Thu, 17 Mar 2022 01:37:38 -0400 (EDT)
Received: from mail-il1-f176.google.com (mail-il1-f176.google.com
 [209.85.166.176])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 2684549EF6
 for <kvmarm@lists.cs.columbia.edu>; Thu, 17 Mar 2022 01:37:38 -0400 (EDT)
Received: by mail-il1-f176.google.com with SMTP id i2so1973629ila.2
 for <kvmarm@lists.cs.columbia.edu>; Wed, 16 Mar 2022 22:37:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=eOhA5o/rv2hDIRWbKN8H2klxdoKowJwEzyK4YFjI0Ok=;
 b=eeGjN5mJoNpfj5kKLs04Hxp8X5XHrjfeLPZrK1GmJPCRupkJZf477uJa/kOmtzy0ah
 YpIQBOMEEmnBPa2QqUCDk2hxy905PuK7tGHlm1nA8Diqbj8GpX8QcZehpprTbs1pc8zy
 gJ1O4s1tdr7D6LqnHE/pWm8PcUef5DhVZRSRXlk+gFupMitoIzsVDFACkBPdNGwXgbtT
 RaAmW2zB98eSXT7Mdyna2gbwqUpFp/Y1Hmehe7Zel/0BoWXMFW80r2wjeAxZeohqY2SR
 Ie5vR9drsGClueifPs5p0dbl+q8ZPjbwfHuvP2SwJIZhjdFQuXamj1plYXStripntCBf
 /WFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=eOhA5o/rv2hDIRWbKN8H2klxdoKowJwEzyK4YFjI0Ok=;
 b=ewdT/hhrY2/ICPwAF0A01SLrhHO6SOdWHj3tBiTaa7TPwBaljVdNHaf1TDaYQbvOe1
 bAkVlhqQyk2g05yZLLLI6HrF8aKViEbymuN+EPtDbIS7W0IncDgtdz7f70i27/S7MDT+
 JnXvRH9nCqcTANQZPlE32UnfcYzKZ9nBAwXQMTcTmzyiCnAZ748jNiG7uV49ZeRxixee
 BlvT3v39QqIlB+ng5wzEh3UVVjshmO+8gEDHZBNPepUcVx2ponM/CsWKJBdHIdohPgoB
 mpTvaPr+nXszTujvLAFQHJWl6CU3M4BUDFY76U4W0bwY6kftLBigyFl/iFiy5XzOMh4N
 aDtw==
X-Gm-Message-State: AOAM531jwAmPgaT/QM+KP2Kz7tX1EvgF0igWh6xAs0K7AapvdbWAOkKU
 jnl5rB7FGp21Fcg5hFhlts/bgA==
X-Google-Smtp-Source: ABdhPJy6LallOZSL7cqSmQyF4OC2oFoWT6AOIFXJUadLeyXNHu1TKa02/s52DyymredH2yAh2eCM5g==
X-Received: by 2002:a05:6e02:1aa6:b0:2c7:769e:8403 with SMTP id
 l6-20020a056e021aa600b002c7769e8403mr1226693ilv.49.1647495457228; 
 Wed, 16 Mar 2022 22:37:37 -0700 (PDT)
Received: from google.com (194.225.68.34.bc.googleusercontent.com.
 [34.68.225.194]) by smtp.gmail.com with ESMTPSA id
 i3-20020a056602134300b0064620a85b6dsm2177542iov.12.2022.03.16.22.37.35
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Wed, 16 Mar 2022 22:37:36 -0700 (PDT)
Date: Thu, 17 Mar 2022 05:37:32 +0000
From: Oliver Upton <oupton@google.com>
To: Jing Zhang <jingzhangos@google.com>
Subject: Re: [PATCH v1 2/2] KVM: arm64: Add debug tracepoint for vcpu exits
Message-ID: <YjLJHDV58GRMxF2P@google.com>
References: <20220317005630.3666572-1-jingzhangos@google.com>
 <20220317005630.3666572-3-jingzhangos@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20220317005630.3666572-3-jingzhangos@google.com>
Cc: KVM <kvm@vger.kernel.org>, Marc Zyngier <maz@kernel.org>,
 David Matlack <dmatlack@google.com>, Paolo Bonzini <pbonzini@redhat.com>,
 Will Deacon <will@kernel.org>, KVMARM <kvmarm@lists.cs.columbia.edu>
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

Hi Jing,

On Thu, Mar 17, 2022 at 12:56:30AM +0000, Jing Zhang wrote:
> This tracepoint only provides a hook for poking vcpu exits information,
> not exported to tracefs.
> A timestamp is added for the last vcpu exit, which would be useful for
> analysis for vcpu exits.
> 
> Signed-off-by: Jing Zhang <jingzhangos@google.com>
> ---
>  arch/arm64/include/asm/kvm_host.h | 3 +++
>  arch/arm64/kvm/arm.c              | 2 ++
>  arch/arm64/kvm/trace_arm.h        | 8 ++++++++
>  3 files changed, 13 insertions(+)
> 
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index daa68b053bdc..576f2c18d008 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -415,6 +415,9 @@ struct kvm_vcpu_arch {
>  
>  	/* Arch specific exit reason */
>  	enum arm_exit_reason exit_reason;
> +
> +	/* Timestamp for the last vcpu exit */
> +	u64 last_exit_time;
>  };
>  
>  /* Pointer to the vcpu's SVE FFR for sve_{save,load}_state() */
> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> index f49ebdd9c990..98631f79c182 100644
> --- a/arch/arm64/kvm/arm.c
> +++ b/arch/arm64/kvm/arm.c
> @@ -783,6 +783,7 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
>  	ret = 1;
>  	run->exit_reason = KVM_EXIT_UNKNOWN;
>  	while (ret > 0) {
> +		trace_kvm_vcpu_exits(vcpu);
>  		/*
>  		 * Check conditions before entering the guest
>  		 */
> @@ -898,6 +899,7 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
>  		local_irq_enable();
>  
>  		trace_kvm_exit(ret, kvm_vcpu_trap_get_class(vcpu), *vcpu_pc(vcpu));
> +		vcpu->arch.last_exit_time = ktime_to_ns(ktime_get());
>  
>  		/* Exit types that need handling before we can be preempted */
>  		handle_exit_early(vcpu, ret);
> diff --git a/arch/arm64/kvm/trace_arm.h b/arch/arm64/kvm/trace_arm.h
> index 33e4e7dd2719..3e7dfd640e23 100644
> --- a/arch/arm64/kvm/trace_arm.h
> +++ b/arch/arm64/kvm/trace_arm.h
> @@ -301,6 +301,14 @@ TRACE_EVENT(kvm_timer_emulate,
>  		  __entry->timer_idx, __entry->should_fire)
>  );
>  
> +/*
> + * Following tracepoints are not exported in tracefs and provide hooking
> + * mechanisms only for testing and debugging purposes.
> + */
> +DECLARE_TRACE(kvm_vcpu_exits,
> +	TP_PROTO(struct kvm_vcpu *vcpu),
> +	TP_ARGS(vcpu));
> +

When we were discussing this earlier, I wasn't aware of the kvm_exit
tracepoint which I think encapsulates what you're looking for.
ESR_EL2.EC is the critical piece to determine what caused the exit.

It is probably also important to call out that this trace point only
will fire for a 'full' KVM exit (i.e. out of hyp and back to the
kernel). There are several instances where the exit is handled in hyp
and we immediately resume the guest.

Now -- I am bordering on clueless with tracepoints, but it isn't
immediately obvious how the attached program can determine the vCPU that
triggered the TP. If we are going to propose modularizing certain KVM
metrics with tracepoints then that would be a rather critical piece of
information.

Apologies for any confusion I added to the whole situation, but
hopefully we can still engage in a broader conversation regarding
how to package up optional KVM metrics.

--
Thanks,
Oliver
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
