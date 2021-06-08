Return-Path: <SRS0=ky3n=LC=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 38C68C47082
	for <kvmarm@archiver.kernel.org>; Tue,  8 Jun 2021 22:11:19 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id A45A8613B9
	for <kvmarm@archiver.kernel.org>; Tue,  8 Jun 2021 22:11:18 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A45A8613B9
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 17EF6406AD;
	Tue,  8 Jun 2021 18:11:18 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id hh0fzaHwpund; Tue,  8 Jun 2021 18:11:16 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9E30F406D3;
	Tue,  8 Jun 2021 18:11:16 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id AABC14066E
 for <kvmarm@lists.cs.columbia.edu>; Tue,  8 Jun 2021 18:11:15 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id jPgyLR33MT26 for <kvmarm@lists.cs.columbia.edu>;
 Tue,  8 Jun 2021 18:11:14 -0400 (EDT)
Received: from mail-pg1-f180.google.com (mail-pg1-f180.google.com
 [209.85.215.180])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 3189F40212
 for <kvmarm@lists.cs.columbia.edu>; Tue,  8 Jun 2021 18:11:14 -0400 (EDT)
Received: by mail-pg1-f180.google.com with SMTP id l184so2169666pgd.8
 for <kvmarm@lists.cs.columbia.edu>; Tue, 08 Jun 2021 15:11:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=1Lg2fjUshPQSmmvGIGFnSHNInxao7jBp1HWCvsMDKQE=;
 b=bTBO5Fx3e7OMiVwWPSHvxYtEfLG7VuwfRWnauBIUSDurqKwCXdeUhVezjRkqItCUT8
 XUOJSHp3m5HzRnGcfYM7XGLrDHyB5WHgLHD6Jd9Fnmbscw355GVXYgGjZ+GdM5qfYMdG
 ZOcgaZxgT/SmHuv8kTL2FVaTa026BDl+G33QF1aSAzrhdP9tOES369UrX7de26+MnWUk
 5LcXVlz5G9GWTw9Qo2lM29gxOYzkDx93F07ckHfavxBFHzNV2V9aXmUN79lUFTICJuuz
 kXIwVb5r9HTJTEC2qcRuFAujGzpCjcbg+1dbZM8SgyuX4k7fWLYojzc2aq7Qz7otRTkZ
 hEqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=1Lg2fjUshPQSmmvGIGFnSHNInxao7jBp1HWCvsMDKQE=;
 b=GmOXn8UI8QPhc3NUwoKBh963DZgCkhAstpZakKdtMcab9uu8vsv4VJYr37qaMbkqv6
 TgG2ngPNDfSizUPWblNAHuS+ZNmpyPFKIW3l9pGkSx7NgzQuH/d8bHz6BqEA5TzeCoki
 Myppn5CnpIgBmjX1dAqx7jCOXvMimwIMuq8jDQ2/Ro02hnc89kRiBoEoJ0Nh7WVE5+MJ
 b/CiabvE1l/CRuT576Pw2lf04NaVCPyp8dkv9788PihJp5gs+fukBOILkruAz3Bi39gE
 3P3txDroybKi/AltWQvHfOqUTm3i/f7sxTmCrxXCIDiEJhsDg2TcBUaLZmEtFpUWyvCY
 Qplw==
X-Gm-Message-State: AOAM532ZbtJsow61Mow4xF053h0VpcuPiFtCUbON7TKyQpIQrCnqIjRY
 JcyVnt3GWOgS5xVemwKGfFI2rQ==
X-Google-Smtp-Source: ABdhPJzZIgYtaVJULZb5oc1c89oj2fW3j6rNfhpynJ+TrAlHgI4QEgkmjUwOlXrc6FVxmQuUvHl9tQ==
X-Received: by 2002:aa7:9af6:0:b029:2e9:dfed:6a59 with SMTP id
 y22-20020aa79af60000b02902e9dfed6a59mr2102349pfp.37.1623190272905; 
 Tue, 08 Jun 2021 15:11:12 -0700 (PDT)
Received: from google.com (150.12.83.34.bc.googleusercontent.com.
 [34.83.12.150])
 by smtp.gmail.com with ESMTPSA id e17sm11480984pfi.131.2021.06.08.15.11.12
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Tue, 08 Jun 2021 15:11:12 -0700 (PDT)
Date: Tue, 8 Jun 2021 15:11:08 -0700
From: Ricardo Koller <ricarkol@google.com>
To: Sean Christopherson <seanjc@google.com>
Subject: Re: [PATCH] KVM: selftests: Rename vm_handle_exception in evmcs test
Message-ID: <YL/q/IJ41gO6kTIF@google.com>
References: <20210604181833.1769900-1-ricarkol@google.com>
 <YLqanpE8tdiNeoaN@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <YLqanpE8tdiNeoaN@google.com>
Cc: kvm@vger.kernel.org, maz@kernel.org,
 kernel test robot <oliver.sang@intel.com>, pbonzini@redhat.com,
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

On Fri, Jun 04, 2021 at 09:26:54PM +0000, Sean Christopherson wrote:
> On Fri, Jun 04, 2021, Ricardo Koller wrote:
> > Kernel test robot reports this:
> > 
> > > /usr/bin/ld: tools/testing/selftests/kvm/x86_64/evmcs_test.c:157: undefined reference to `vm_handle_exception'
> > > /usr/bin/ld: tools/testing/selftests/kvm/x86_64/evmcs_test.c:158: undefined reference to `vm_handle_exception'
> > > collect2: error: ld returned 1 exit status
> > 
> > Fix it by renaming vm_handle_exception to vm_install_vector_handler in
> > evmcs_test.c.
> > 
> > Fixes: a2bad6a990a4 ("KVM: selftests: Rename vm_handle_exception")
> 
> Belated code review... Can we rename the helper to vm_install_exception_handler()?
> 
> In x86, "vector" is the number of the exception and "vectoring" is the process
> of determining the resulting vector that gets delivered to software (e.g. when
> dealing with contributory faults like #GP->#PF->#DF), but the thing that's being
> handled is an exception.
> 
> arm appears to have similar terminology.  And looking at the arm code, it's very
> confusing to have a helper vm_install_vector_handler() install into
> exception_handlers, _not_ into vector_handlers.  Calling the vector_handlers
> "default" handlers is also confusing, as "default" usually implies the thing can
> be overwritten.  But in this case, the "default" handler is just another layer
> in the routing.

FWIW, this terminology makes sense in kvm-unit-tests (KUT) because KUT
has a library function to update the default entries in vector_handlers.
I based my patch on it (with names and everything) but didn't add this
function to update the default entries, hence the confusion.

> 
> The multiple layers of routing is also confusing and a bit hard to wade through
> for the uninitiated.  The whole thing can be made more straightfoward by doing
> away with the intermediate routing, whacking ~50 lines of code in the process.
> E.g. (definitely not functional code):

This works but it would remove the ability to replace the default sync
handler with something else, like a handler that can cover all possible
ec values. In this case we would have to call
vm_install_exception_handler_ec 64 times.  On the other hand, the tests
that we are planning don't seem to need it, so I will move on with the
suggestion.

Thanks,
Ricardo

> 
> diff --git a/tools/testing/selftests/kvm/aarch64/debug-exceptions.c b/tools/testing/selftests/kvm/aarch64/debug-exceptions.c
> index 51c42ac24dca..c784e4b770cf 100644
> --- a/tools/testing/selftests/kvm/aarch64/debug-exceptions.c
> +++ b/tools/testing/selftests/kvm/aarch64/debug-exceptions.c
> @@ -212,15 +212,15 @@ int main(int argc, char *argv[])
>                 exit(KSFT_SKIP);
>         }
>  
> -       vm_install_exception_handler(vm, VECTOR_SYNC_CURRENT,
> +       vm_install_exception_handler_ec(vm, VECTOR_SYNC_CURRENT,
>                                 ESR_EC_BRK_INS, guest_sw_bp_handler);
> -       vm_install_exception_handler(vm, VECTOR_SYNC_CURRENT,
> +       vm_install_exception_handler_ec(vm, VECTOR_SYNC_CURRENT,
>                                 ESR_EC_HW_BP_CURRENT, guest_hw_bp_handler);
> -       vm_install_exception_handler(vm, VECTOR_SYNC_CURRENT,
> +       vm_install_exception_handler_ec(vm, VECTOR_SYNC_CURRENT,
>                                 ESR_EC_WP_CURRENT, guest_wp_handler);
> -       vm_install_exception_handler(vm, VECTOR_SYNC_CURRENT,
> +       vm_install_exception_handler_ec(vm, VECTOR_SYNC_CURRENT,
>                                 ESR_EC_SSTEP_CURRENT, guest_ss_handler);
> -       vm_install_exception_handler(vm, VECTOR_SYNC_CURRENT,
> +       vm_install_exception_handler_ec(vm, VECTOR_SYNC_CURRENT,
>                                 ESR_EC_SVC64, guest_svc_handler);
>  
>         for (stage = 0; stage < 7; stage++) {
> diff --git a/tools/testing/selftests/kvm/include/aarch64/processor.h b/tools/testing/selftests/kvm/include/aarch64/processor.h
> index 1a3abe1037b0..211cb684577a 100644
> --- a/tools/testing/selftests/kvm/include/aarch64/processor.h
> +++ b/tools/testing/selftests/kvm/include/aarch64/processor.h
> @@ -110,10 +110,10 @@ void vm_init_descriptor_tables(struct kvm_vm *vm);
>  void vcpu_init_descriptor_tables(struct kvm_vm *vm, uint32_t vcpuid);
>  
>  typedef void(*handler_fn)(struct ex_regs *);
> -void vm_install_exception_handler(struct kvm_vm *vm,
> -               int vector, int ec, handler_fn handler);
> -void vm_install_vector_handler(struct kvm_vm *vm,
> -               int vector, handler_fn handler);
> +void vm_install_exception_handler_ec(struct kvm_vm *vm, int vector, int ec,
> +                                    handler_fn handler);
> +void vm_install_exception_handler(struct kvm_vm *vm, int vector,
> +                                 handler_fn handler);
>  
>  #define write_sysreg(reg, val)                                           \
>  ({                                                                       \
> diff --git a/tools/testing/selftests/kvm/lib/aarch64/handlers.S b/tools/testing/selftests/kvm/lib/aarch64/handlers.S
> index 49bf8827c6ab..fee0c3155ec7 100644
> --- a/tools/testing/selftests/kvm/lib/aarch64/handlers.S
> +++ b/tools/testing/selftests/kvm/lib/aarch64/handlers.S
> @@ -93,7 +93,8 @@ handler_\label:
>  .balign 0x80
>  /* This will abort so no need to save and restore registers. */
>         mov     x0, #vector
> -       b       kvm_exit_unexpected_vector
> +       <sean doesn't know what goes here>
> +       b       kvm_exit_unexpected_exception
>  .popsection
>  
>  .set   vector, vector + 1
> diff --git a/tools/testing/selftests/kvm/lib/aarch64/processor.c b/tools/testing/selftests/kvm/lib/aarch64/processor.c
> index 03ce507d49d2..ff63e66e2c5d 100644
> --- a/tools/testing/selftests/kvm/lib/aarch64/processor.c
> +++ b/tools/testing/selftests/kvm/lib/aarch64/processor.c
> @@ -337,16 +337,9 @@ void vcpu_args_set(struct kvm_vm *vm, uint32_t vcpuid, unsigned int num, ...)
>         va_end(ap);
>  }
>  
> -void kvm_exit_unexpected_vector(int vector)
> +void kvm_exit_unexpected_exception(int vector, uint64_t ec, bool valid_ec)
>  {
> -       ucall(UCALL_UNHANDLED, 3, vector, 0, false /* !valid_ec */);
> -       while (1)
> -               ;
> -}
> -
> -static void kvm_exit_unexpected_exception(int vector, uint64_t ec)
> -{
> -       ucall(UCALL_UNHANDLED, 3, vector, ec, true /* valid_ec */);
> +       ucall(UCALL_UNHANDLED, 3, vector, ec, valid_ec);
>         while (1)
>                 ;
>  }
> @@ -369,18 +362,7 @@ void assert_on_unhandled_exception(struct kvm_vm *vm, uint32_t vcpuid)
>         }
>  }
>  
> -/*
> - * This exception handling code was heavily inspired on kvm-unit-tests. There
> - * is a set of default vector handlers stored in vector_handlers. These default
> - * vector handlers call user-installed handlers stored in exception_handlers.
> - * Synchronous handlers are indexed by (vector, ec), and irq handlers by
> - * (vector, ec=0).
> - */
> -
> -typedef void(*vector_fn)(struct ex_regs *, int vector);
> -
>  struct handlers {
> -       vector_fn vector_handlers[VECTOR_NUM];
>         handler_fn exception_handlers[VECTOR_NUM][ESR_EC_NUM];
>  };
>  
> @@ -391,80 +373,56 @@ void vcpu_init_descriptor_tables(struct kvm_vm *vm, uint32_t vcpuid)
>         set_reg(vm, vcpuid, ARM64_SYS_REG(VBAR_EL1), (uint64_t)&vectors);
>  }
>  
> -static void default_sync_handler(struct ex_regs *regs, int vector)
> -{
> -       struct handlers *handlers = (struct handlers *)exception_handlers;
> -       uint64_t esr = read_sysreg(esr_el1);
> -       uint64_t ec = (esr >> ESR_EC_SHIFT) & ESR_EC_MASK;
> -
> -       GUEST_ASSERT(VECTOR_IS_SYNC(vector));
> -
> -       if (handlers && handlers->exception_handlers[vector][ec])
> -               handlers->exception_handlers[vector][ec](regs);
> -       else
> -               kvm_exit_unexpected_exception(vector, ec);
> -}
> -
> -static void default_handler(struct ex_regs *regs, int vector)
> -{
> -       struct handlers *handlers = (struct handlers *)exception_handlers;
> -
> -       GUEST_ASSERT(!VECTOR_IS_SYNC(vector));
> -
> -       if (handlers && handlers->exception_handlers[vector][0])
> -               handlers->exception_handlers[vector][0](regs);
> -       else
> -               kvm_exit_unexpected_vector(vector);
> -}
> -
>  void route_exception(struct ex_regs *regs, int vector)
>  {
> -       struct handlers *handlers = (struct handlers *)exception_handlers;
> +       struct handler_fn *handlers = exception_handlers;
> +       bool valid_ec;
> +       int ec;
>  
> -       if (handlers && handlers->vector_handlers[vector])
> -               handlers->vector_handlers[vector](regs, vector);
> -       else
> -               kvm_exit_unexpected_vector(vector);
> +       switch (vector) {
> +       case VECTOR_SYNC_CURRENT:
> +       case VECTOR_SYNC_LOWER_64:
> +               ec = (read_sysreg(esr_el1) >> ESR_EC_SHIFT) & ESR_EC_MASK;
> +               valid_ec = true;
> +               break;
> +       case VECTOR_IRQ_CURRENT:
> +       case VECTOR_IRQ_LOWER_64:
> +       case VECTOR_FIQ_CURRENT:
> +       case VECTOR_FIQ_LOWER_64:
> +       case VECTOR_ERROR_CURRENT:
> +       case VECTOR_ERROR_LOWER_64:
> +               ec = 0;
> +               valid_ec = false;
> +               break;
> +       default:
> +               goto unexpected_exception;
> +       }
> +
> +       if (handlers && handlers[vector][ec])
> +               return handlers[vector][ec](regs);
> +
> +unexpected_exception:
> +       kvm_exit_unexpected_exception(vector, ec, valid_ec);
>  }
>  
>  void vm_init_descriptor_tables(struct kvm_vm *vm)
>  {
> -       struct handlers *handlers;
> -
> -       vm->handlers = vm_vaddr_alloc(vm, sizeof(struct handlers),
> -                       vm->page_size, 0, 0);
> -
> -       handlers = (struct handlers *)addr_gva2hva(vm, vm->handlers);
> -       handlers->vector_handlers[VECTOR_SYNC_CURRENT] = default_sync_handler;
> -       handlers->vector_handlers[VECTOR_IRQ_CURRENT] = default_handler;
> -       handlers->vector_handlers[VECTOR_FIQ_CURRENT] = default_handler;
> -       handlers->vector_handlers[VECTOR_ERROR_CURRENT] = default_handler;
> -
> -       handlers->vector_handlers[VECTOR_SYNC_LOWER_64] = default_sync_handler;
> -       handlers->vector_handlers[VECTOR_IRQ_LOWER_64] = default_handler;
> -       handlers->vector_handlers[VECTOR_FIQ_LOWER_64] = default_handler;
> -       handlers->vector_handlers[VECTOR_ERROR_LOWER_64] = default_handler;
> -
> -       *(vm_vaddr_t *)addr_gva2hva(vm, (vm_vaddr_t)(&exception_handlers)) = vm->handlers;
> +       *(vm_vaddr_t *)addr_gva2hva(vm, (vm_vaddr_t)(&exception_handlers)) = __exception_handlers;
>  }
>  
> -void vm_install_exception_handler(struct kvm_vm *vm, int vector, int ec,
> -                        void (*handler)(struct ex_regs *))
> +void vm_install_exception_handler_ec(struct kvm_vm *vm, int vector, int ec,
> +                                    void (*handler)(struct ex_regs *))
>  {
> -       struct handlers *handlers = (struct handlers *)addr_gva2hva(vm, vm->handlers);
> +       struct handlers *handlers = addr_gva2hva(vm, vm->handlers);
>  
> -       assert(VECTOR_IS_SYNC(vector));
> +       assert(!ec == !VECTOR_IS_SYNC(vector));
>         assert(vector < VECTOR_NUM);
>         assert(ec < ESR_EC_NUM);
> -       handlers->exception_handlers[vector][ec] = handler;
> +       exception_handlers[vector][ec] = handler;
>  }
>  
> -void vm_install_vector_handler(struct kvm_vm *vm, int vector,
> -                        void (*handler)(struct ex_regs *))
> +void vm_install_exception_handler(struct kvm_vm *vm, int vector,
> +                                 void (*handler)(struct ex_regs *))
>  {
> -       struct handlers *handlers = (struct handlers *)addr_gva2hva(vm, vm->handlers);
> -
> -       assert(!VECTOR_IS_SYNC(vector));
> -       assert(vector < VECTOR_NUM);
> -       handlers->exception_handlers[vector][0] = handler;
> +       vm_install_exception_handler_ec(vm, vector, 0, handler);
>  }
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
