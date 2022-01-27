Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CDBCAC433EF
	for <kvmarm@archiver.kernel.org>; Thu, 27 Jan 2022 07:46:25 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5D8A84A49C;
	Thu, 27 Jan 2022 02:46:25 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 6aIgJXCgzXzf; Thu, 27 Jan 2022 02:46:24 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0D92449F37;
	Thu, 27 Jan 2022 02:46:24 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E091F49F1F
 for <kvmarm@lists.cs.columbia.edu>; Thu, 27 Jan 2022 02:46:22 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id YvCPgauQftLS for <kvmarm@lists.cs.columbia.edu>;
 Thu, 27 Jan 2022 02:46:21 -0500 (EST)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.129.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B18FA49EF4
 for <kvmarm@lists.cs.columbia.edu>; Thu, 27 Jan 2022 02:46:21 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1643269581;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=wQwFTIAyd79VtHoizQt/7QTJxDg0e/CzlZ208FfbldU=;
 b=UAARByOqPIKTLVVJPFzvjP7L2BBz47D7efAKj9z1sIFTl72v3gdwozZ9aGaxXAJhQacl7P
 ZHF5R+ynU8gSFXA9dQJBYOPPb9Zy14/IcpMCGU1BZ0jbRashc/JIdT0Kfslm9wdBMovVrD
 B4ydNgK8wr+eoc1mrKKzmZC6yICt0XE=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-163-EaSL8SN_MvC_1W0-u3sSXw-1; Thu, 27 Jan 2022 02:46:19 -0500
X-MC-Unique: EaSL8SN_MvC_1W0-u3sSXw-1
Received: by mail-ed1-f71.google.com with SMTP id
 o25-20020a056402039900b0040631c2a67dso949246edv.19
 for <kvmarm@lists.cs.columbia.edu>; Wed, 26 Jan 2022 23:46:19 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=wQwFTIAyd79VtHoizQt/7QTJxDg0e/CzlZ208FfbldU=;
 b=xQmmAUfYMw0cC1FDLf031FXWI9JqO+2+rdgLEMCGU1FYl9lBAy23B1vEjZdW0+F+8c
 fPtTvyAXry3j0Yw25jfQ25OXfIIFcHw3opbPkACL2RNLMsnspLIJAXkdXYa6ZqcYUmBF
 oYHlGBElr5nsMqWyECCDP9iqvt887w1EIPNWmBmRAtoewQ8xFJZ202LQiB9iYgykEAB8
 RES+175bcfS8pjj+SewbTqXwVgWmniWLNdmYTyZJLLKgu/1exVqU7hpa7B2mnGkzLIfK
 UIZk3ciQBqT+Irg8o3t2dbXiW311qFLV/IZFqbO8WZj9U46Lswk8U+EEdFpvuS6TrTzo
 qsoQ==
X-Gm-Message-State: AOAM532Z3rsw0mumkCnkmEd+/q9RhLaKXCB/ozXMdk8k0GI7Kjk7JV/8
 Dgig3YdMM0IJ2GTEBpV2VaM7esBAc0z3gHZ2SgNHM+Uc0NB460FWyEAXx3eZyS/9x9uvEtUE2fY
 wGsdk8l9LwoVlxGggcU+Cwd9C
X-Received: by 2002:a05:6402:387:: with SMTP id
 o7mr2404986edv.253.1643269578652; 
 Wed, 26 Jan 2022 23:46:18 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyiTsNUx+1fk3/qVodbUrliRUrODZ3coLKh7ubQ0zyxCrbDSGtlHbcVOBgwZ1rTbx2jOM2Nsw==
X-Received: by 2002:a05:6402:387:: with SMTP id
 o7mr2404974edv.253.1643269578445; 
 Wed, 26 Jan 2022 23:46:18 -0800 (PST)
Received: from gator (cst2-173-70.cust.vodafone.cz. [31.30.173.70])
 by smtp.gmail.com with ESMTPSA id w24sm3493194edu.97.2022.01.26.23.46.17
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Wed, 26 Jan 2022 23:46:18 -0800 (PST)
Date: Thu, 27 Jan 2022 08:46:16 +0100
From: Andrew Jones <drjones@redhat.com>
To: Ricardo Koller <ricarkol@google.com>
Subject: Re: [PATCH v2 2/5] kvm: selftests: aarch64: pass vgic_irq guest args
 as a pointer
Message-ID: <20220127074616.vyjf2elhcrx4ptfw@gator>
References: <20220127030858.3269036-1-ricarkol@google.com>
 <20220127030858.3269036-3-ricarkol@google.com>
MIME-Version: 1.0
In-Reply-To: <20220127030858.3269036-3-ricarkol@google.com>
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=drjones@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Cc: kvm@vger.kernel.org, maz@kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
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

On Wed, Jan 26, 2022 at 07:08:55PM -0800, Ricardo Koller wrote:
> The guest in vgic_irq gets its arguments in a struct. This struct used
> to fit nicely in a single register so vcpu_args_set() was able to pass
> it by value by setting x0 with it.

Ouch.

> Unfortunately, this args struct grew
> after some commits and some guest args became random (specically
> kvm_supports_irqfd).
> 
> Fix this by passing the guest args as a pointer (after allocating some
> guest memory for it).
> 
> Signed-off-by: Ricardo Koller <ricarkol@google.com>
> Reported-by: Reiji Watanabe <reijiw@google.com>
> Cc: Andrew Jones <drjones@redhat.com>
> ---
>  .../testing/selftests/kvm/aarch64/vgic_irq.c  | 29 ++++++++++---------
>  1 file changed, 16 insertions(+), 13 deletions(-)
> 
> diff --git a/tools/testing/selftests/kvm/aarch64/vgic_irq.c b/tools/testing/selftests/kvm/aarch64/vgic_irq.c
> index e6c7d7f8fbd1..b701eb80128d 100644
> --- a/tools/testing/selftests/kvm/aarch64/vgic_irq.c
> +++ b/tools/testing/selftests/kvm/aarch64/vgic_irq.c
> @@ -472,10 +472,10 @@ static void test_restore_active(struct test_args *args, struct kvm_inject_desc *
>  		guest_restore_active(args, MIN_SPI, 4, f->cmd);
>  }
>  
> -static void guest_code(struct test_args args)
> +static void guest_code(struct test_args *args)
>  {
> -	uint32_t i, nr_irqs = args.nr_irqs;
> -	bool level_sensitive = args.level_sensitive;
> +	uint32_t i, nr_irqs = args->nr_irqs;
> +	bool level_sensitive = args->level_sensitive;
>  	struct kvm_inject_desc *f, *inject_fns;
>  
>  	gic_init(GIC_V3, 1, dist, redist);
> @@ -484,11 +484,11 @@ static void guest_code(struct test_args args)
>  		gic_irq_enable(i);
>  
>  	for (i = MIN_SPI; i < nr_irqs; i++)
> -		gic_irq_set_config(i, !args.level_sensitive);
> +		gic_irq_set_config(i, !level_sensitive);
>  
> -	gic_set_eoi_split(args.eoi_split);
> +	gic_set_eoi_split(args->eoi_split);
>  
> -	reset_priorities(&args);
> +	reset_priorities(args);
>  	gic_set_priority_mask(CPU_PRIO_MASK);
>  
>  	inject_fns  = level_sensitive ? inject_level_fns
> @@ -497,17 +497,17 @@ static void guest_code(struct test_args args)
>  	local_irq_enable();
>  
>  	/* Start the tests. */
> -	for_each_supported_inject_fn(&args, inject_fns, f) {
> -		test_injection(&args, f);
> -		test_preemption(&args, f);
> -		test_injection_failure(&args, f);
> +	for_each_supported_inject_fn(args, inject_fns, f) {
> +		test_injection(args, f);
> +		test_preemption(args, f);
> +		test_injection_failure(args, f);
>  	}
>  
>  	/* Restore the active state of IRQs. This would happen when live
>  	 * migrating IRQs in the middle of being handled.
>  	 */
> -	for_each_supported_activate_fn(&args, set_active_fns, f)
> -		test_restore_active(&args, f);
> +	for_each_supported_activate_fn(args, set_active_fns, f)
> +		test_restore_active(args, f);
>  
>  	GUEST_DONE();
>  }
> @@ -739,6 +739,7 @@ static void test_vgic(uint32_t nr_irqs, bool level_sensitive, bool eoi_split)
>  	int gic_fd;
>  	struct kvm_vm *vm;
>  	struct kvm_inject_args inject_args;
> +	vm_vaddr_t args_gva;
>  
>  	struct test_args args = {
>  		.nr_irqs = nr_irqs,
> @@ -757,7 +758,9 @@ static void test_vgic(uint32_t nr_irqs, bool level_sensitive, bool eoi_split)
>  	vcpu_init_descriptor_tables(vm, VCPU_ID);
>  
>  	/* Setup the guest args page (so it gets the args). */
> -	vcpu_args_set(vm, 0, 1, args);
> +	args_gva = vm_vaddr_alloc_page(vm);
> +	memcpy(addr_gva2hva(vm, args_gva), &args, sizeof(args));
> +	vcpu_args_set(vm, 0, 1, args_gva);
>  
>  	gic_fd = vgic_v3_setup(vm, 1, nr_irqs,
>  			GICD_BASE_GPA, GICR_BASE_GPA);
> -- 
> 2.35.0.rc0.227.g00780c9af4-goog
>

Reviewed-by: Andrew Jones <drjones@redhat.com>

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
