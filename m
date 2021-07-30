Return-Path: <SRS0=HDjL=MW=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.7 required=3.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,FSL_HELO_FAKE,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 50C69C432BE
	for <kvmarm@archiver.kernel.org>; Fri, 30 Jul 2021 01:11:02 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id B5DC960F00
	for <kvmarm@archiver.kernel.org>; Fri, 30 Jul 2021 01:11:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org B5DC960F00
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2EE294A319;
	Thu, 29 Jul 2021 21:11:01 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Qo2Ov4V-C8Ca; Thu, 29 Jul 2021 21:11:00 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 20BDD4A483;
	Thu, 29 Jul 2021 21:11:00 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 840054A19E
 for <kvmarm@lists.cs.columbia.edu>; Thu, 29 Jul 2021 21:10:59 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 3sLG7yqbptgy for <kvmarm@lists.cs.columbia.edu>;
 Thu, 29 Jul 2021 21:10:58 -0400 (EDT)
Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com
 [209.85.214.176])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 4F28A4A00B
 for <kvmarm@lists.cs.columbia.edu>; Thu, 29 Jul 2021 21:10:58 -0400 (EDT)
Received: by mail-pl1-f176.google.com with SMTP id t21so9023238plr.13
 for <kvmarm@lists.cs.columbia.edu>; Thu, 29 Jul 2021 18:10:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=DsDa8w/t7/VXcjTtjhlMutUZ69+V3sKaHAYWUrxvP2w=;
 b=s5WKvm12hxduXD4KaBZVdGFu1auOXhmp85lyVaoRSW/i40OfXQUyx5b0TBXC+zeqll
 Nqfev9udZ9s3S7qMBcWcr4MMCRGeZh7r31GXm49jNsKlnzuv8dtSyh4y4mskTCDsA9S3
 QU3STRyPmpSeRi0qUf64zUJkaUCQxX49L97ZND7xLa0yvKCfzJcEn0y+z0uRBCjegntd
 3ruUl7q66HZI3OLUvqEVPYCCdO4btGXwjs9Rmh2qCQ/vw2CedidiUv8BpS9RHY0MGdMN
 tWRDfn/+oTzIOLFWjJRyiAhPh5NxaQXFiY8x/1ykirixoItlLiu0KTqzifk1So2yfQmX
 kymg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=DsDa8w/t7/VXcjTtjhlMutUZ69+V3sKaHAYWUrxvP2w=;
 b=gaLK4f459ivc75EDYYAgoGdvQRQ+3LLA3aniztbk4vEV4MAyxgkmPPhriLNP4DYCrI
 yEFUG4sTla+MHry8cjUlKFVCP/YPxem1RPoR/v4M7ChqQYYZs+B0GcQxUIcivhE6iEcr
 8dewvR6pul/M+ppU1UuBJ0yh6tWs7CJKYcboJ3GdEAmZsgMfXytjY0CttMhB40svpBcM
 PW7ZlxgAO3VCh7NB2y0js3eBm+Quf1bQ1wSWFbv2Qxw6JedefiPwe484zq7G6+CRetAc
 m2+Iv85qfOv1pK2kxwZyASMO0dS0SnXeeL/3QSm5iK+lDIjBghxjilT9M9PE02zNVNKy
 uJPQ==
X-Gm-Message-State: AOAM5314gHINs0erFRgZSER8jtWjreG5OTW/zL3TVpywdjEeUxMwg/rB
 8NV1OHIkc8KTxup4oqO6U3XVxw==
X-Google-Smtp-Source: ABdhPJykHjxFNng8e9pwGpUCl99/cU52oDpwBq5WiOXs/vFkGzZfPrkKkwfN3K7VYIuO2swkU374ZQ==
X-Received: by 2002:aa7:88d4:0:b029:329:be20:a5c with SMTP id
 k20-20020aa788d40000b0290329be200a5cmr7927892pff.61.1627607456971; 
 Thu, 29 Jul 2021 18:10:56 -0700 (PDT)
Received: from google.com (150.12.83.34.bc.googleusercontent.com.
 [34.83.12.150])
 by smtp.gmail.com with ESMTPSA id h192sm59949pfe.1.2021.07.29.18.10.56
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Thu, 29 Jul 2021 18:10:56 -0700 (PDT)
Date: Thu, 29 Jul 2021 18:10:53 -0700
From: Ricardo Koller <ricarkol@google.com>
To: Sean Christopherson <seanjc@google.com>
Subject: Re: [PATCH v4 3/6] KVM: selftests: Introduce UCALL_UNHANDLED for
 unhandled vector reporting
Message-ID: <YQNRnbuucxcYJT2F@google.com>
References: <20210611011020.3420067-1-ricarkol@google.com>
 <20210611011020.3420067-4-ricarkol@google.com>
 <YQLwP9T4hevAqa7w@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <YQLwP9T4hevAqa7w@google.com>
Cc: kvm@vger.kernel.org, maz@kernel.org, pbonzini@redhat.com,
 vkuznets@redhat.com, kvmarm@lists.cs.columbia.edu
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

On Thu, Jul 29, 2021 at 06:15:27PM +0000, Sean Christopherson wrote:
> On Thu, Jun 10, 2021, Ricardo Koller wrote:
> > diff --git a/tools/testing/selftests/kvm/include/kvm_util.h b/tools/testing/selftests/kvm/include/kvm_util.h
> > index fcd8e3855111..beb76d6deaa9 100644
> > --- a/tools/testing/selftests/kvm/include/kvm_util.h
> > +++ b/tools/testing/selftests/kvm/include/kvm_util.h
> > @@ -349,6 +349,7 @@ enum {
> >  	UCALL_SYNC,
> >  	UCALL_ABORT,
> >  	UCALL_DONE,
> > +	UCALL_UNHANDLED,
> >  };
> 
> ...
> 
> > @@ -1254,16 +1254,13 @@ void vm_install_exception_handler(struct kvm_vm *vm, int vector,
> >  
> >  void assert_on_unhandled_exception(struct kvm_vm *vm, uint32_t vcpuid)
> >  {
> > -	if (vcpu_state(vm, vcpuid)->exit_reason == KVM_EXIT_IO
> > -		&& vcpu_state(vm, vcpuid)->io.port == UNEXPECTED_VECTOR_PORT
> > -		&& vcpu_state(vm, vcpuid)->io.size == 4) {
> > -		/* Grab pointer to io data */
> > -		uint32_t *data = (void *)vcpu_state(vm, vcpuid)
> > -			+ vcpu_state(vm, vcpuid)->io.data_offset;
> > -
> > -		TEST_ASSERT(false,
> > -			    "Unexpected vectored event in guest (vector:0x%x)",
> > -			    *data);
> > +	struct ucall uc;
> > +
> > +	if (get_ucall(vm, vcpuid, &uc) == UCALL_UNHANDLED) {
> 
> UCALL_UNHANDLED is a bit of an odd name.  Without the surrounding context, I would
> have no idea that it's referring to an unhandled event, e.g. my gut reaction would
> be that it means the ucall itself was unhandled. Maybe UCALL_UNHANDLED_EVENT?

I see. I can send a new patch (this was commited as 75275d7fbe) with a
new name. The only name I can think of that's more descriptive would be
UCALL_UNHANDLED_EXCEPTION, but that's even longer.

> It's rather long, but I don't think that will be problematic for any of the code.
> 
> 
> > +		uint64_t vector = uc.args[0];
> > +
> > +		TEST_FAIL("Unexpected vectored event in guest (vector:0x%lx)",
> > +			  vector);
> >  	}
> >  }
> >  
> > -- 
> > 2.32.0.272.g935e593368-goog
> > 
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
