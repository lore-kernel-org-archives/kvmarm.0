Return-Path: <SRS0=nyIz=OH=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EF23BC433FE
	for <kvmarm@archiver.kernel.org>; Fri, 17 Sep 2021 08:46:55 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 7A0EB61056
	for <kvmarm@archiver.kernel.org>; Fri, 17 Sep 2021 08:46:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 7A0EB61056
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 215DE4B0CC;
	Fri, 17 Sep 2021 04:46:55 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id yDWAZ5tEuhfY; Fri, 17 Sep 2021 04:46:54 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DA2854B0DB;
	Fri, 17 Sep 2021 04:46:52 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B7DFF49F6C
 for <kvmarm@lists.cs.columbia.edu>; Thu, 16 Sep 2021 17:41:07 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id C4zUgm8eNjyO for <kvmarm@lists.cs.columbia.edu>;
 Thu, 16 Sep 2021 17:41:06 -0400 (EDT)
Received: from mail-pj1-f53.google.com (mail-pj1-f53.google.com
 [209.85.216.53])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id A9F8949F5F
 for <kvmarm@lists.cs.columbia.edu>; Thu, 16 Sep 2021 17:41:06 -0400 (EDT)
Received: by mail-pj1-f53.google.com with SMTP id
 il14-20020a17090b164e00b0019c7a7c362dso2254530pjb.0
 for <kvmarm@lists.cs.columbia.edu>; Thu, 16 Sep 2021 14:41:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=H6MB2ODxA8ncTb3aji91NU1uUQ9q1AebxOl6ENeKyck=;
 b=MXQC+ZfLxlKAl3MhEJW1BaTu7x3eZBr25vDIOP4P1K/hKKNsBxR9bYAbQrcXeqx0IT
 UwrZDJawrFH60RbkF94BswFhIwo0cou0aN+gLacubbeU6IcTTMJrkdfHEYWn3Q3CVBfY
 FWOlqrCFMP2DA28EATBAk/sg6Cxl8pCwP9qJHgGrwzQTOnAwwW0mxDrD/8RBAtDi8Sen
 7O4AbiMouCC1KnoWzOLrohcS9Vtb2Dd0sBl4eKlMlTi8+NrzRnGujJOfnGMsmwaTYUXB
 tHZDCMU2HvcsbXJF8DOiqaPVnBEOB3kiFk+1tNf5dSr4/Tt9/mMCbKmuD1xBAf0iTv/g
 rERQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=H6MB2ODxA8ncTb3aji91NU1uUQ9q1AebxOl6ENeKyck=;
 b=CdgbqOq4tUXq32VJYc7dtgev1Ixf/7hIP+CmYTqxRmXkguYXplMKi90pDprZRtq5+5
 Qqt0U1haxOKWRV3YZyoivbQzX4DSOp5pnzV57JQP2zcPHDHoy37lRnb81QIajFs2t/4o
 RQ56iC6ACmMlKXSnevsM/PDu+SVOjsUQK6Zvr0B4FJ9gooytfAM1/v96YVWt2jWwJ6cB
 c4tZJH1W4/1Kad88NRUDmUWJdGVoDIEJNOKZTNNx5badCaRF6zFBtombta5RndVebOU4
 ehdfMs/nhcI0wJRQK1eRpteAVaL1X/rVfJPtB2rtDDqw6RuEy/KLhu4VQgaRY4YodxQ4
 AxeQ==
X-Gm-Message-State: AOAM532MHtDx+DpVqBRW8/D6u+NE3cYfR1ofB97GIP2aPpaU75S2OL+W
 ZVgK5lrrMezpF5b27nOlO/E9PA==
X-Google-Smtp-Source: ABdhPJyEB8CLbdwiUNdfZdvrZtOKbQbkduopskaqSrtZd3BkA7cXNgyeY28844ULJzTSWyVMUXnICw==
X-Received: by 2002:a17:903:244e:b0:13c:802d:92c with SMTP id
 l14-20020a170903244e00b0013c802d092cmr6486996pls.78.1631828465371; 
 Thu, 16 Sep 2021 14:41:05 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com.
 [35.185.214.157])
 by smtp.gmail.com with ESMTPSA id z11sm4163558pff.144.2021.09.16.14.41.04
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Thu, 16 Sep 2021 14:41:04 -0700 (PDT)
Date: Thu, 16 Sep 2021 21:41:01 +0000
From: Sean Christopherson <seanjc@google.com>
To: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH v2 01/13] perf: Ensure perf_guest_cbs aren't reloaded
 between !NULL check and deref
Message-ID: <YUO57TlEGlUk2Q03@google.com>
References: <20210828003558.713983-1-seanjc@google.com>
 <20210828003558.713983-2-seanjc@google.com>
 <20210828194421.GB4353@worktop.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20210828194421.GB4353@worktop.programming.kicks-ass.net>
X-Mailman-Approved-At: Fri, 17 Sep 2021 04:46:52 -0400
Cc: Wanpeng Li <wanpengli@tencent.com>, kvm@vger.kernel.org,
 Alexander Shishkin <alexander.shishkin@linux.intel.com>,
 Catalin Marinas <catalin.marinas@arm.com>, Guo Ren <guoren@kernel.org>,
 "H. Peter Anvin" <hpa@zytor.com>, linux-riscv@lists.infradead.org,
 Vincent Chen <deanbo422@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
 Boris Ostrovsky <boris.ostrovsky@oracle.com>,
 Stefano Stabellini <sstabellini@kernel.org>, xen-devel@lists.xenproject.org,
 Marc Zyngier <maz@kernel.org>, Joerg Roedel <joro@8bytes.org>, x86@kernel.org,
 linux-csky@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
 Ingo Molnar <mingo@redhat.com>, Like Xu <like.xu.linux@gmail.com>,
 Albert Ou <aou@eecs.berkeley.edu>, Zhu Lingshan <lingshan.zhu@intel.com>,
 Will Deacon <will@kernel.org>, Arnaldo Carvalho de Melo <acme@kernel.org>,
 Borislav Petkov <bp@alien8.de>, Greentime Hu <green.hu@gmail.com>,
 Paul Walmsley <paul.walmsley@sifive.com>, Namhyung Kim <namhyung@kernel.org>,
 Thomas Gleixner <tglx@linutronix.de>,
 Artem Kashkanov <artem.kashkanov@intel.com>,
 linux-arm-kernel@lists.infradead.org, Jim Mattson <jmattson@google.com>,
 Juergen Gross <jgross@suse.com>, Nick Hu <nickhu@andestech.com>,
 linux-kernel@vger.kernel.org, linux-perf-users@vger.kernel.org,
 Palmer Dabbelt <palmer@dabbelt.com>, Paolo Bonzini <pbonzini@redhat.com>,
 Vitaly Kuznetsov <vkuznets@redhat.com>
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

On Sat, Aug 28, 2021, Peter Zijlstra wrote:
> On Fri, Aug 27, 2021 at 05:35:46PM -0700, Sean Christopherson wrote:
> > diff --git a/kernel/events/core.c b/kernel/events/core.c
> > index 464917096e73..2126f6327321 100644
> > --- a/kernel/events/core.c
> > +++ b/kernel/events/core.c
> > @@ -6491,14 +6491,19 @@ struct perf_guest_info_callbacks *perf_guest_cbs;
> >  
> >  int perf_register_guest_info_callbacks(struct perf_guest_info_callbacks *cbs)
> >  {
> > -	perf_guest_cbs = cbs;
> > +	if (WARN_ON_ONCE(perf_guest_cbs))
> > +		return -EBUSY;
> > +
> > +	WRITE_ONCE(perf_guest_cbs, cbs);
> > +	synchronize_rcu();
> 
> You're waiting for all NULL users to go away? :-) IOW, we can do without
> this synchronize_rcu() call.

Doh, right.  I was thinking KVM needed to wait for in-progress NMI to exit to
ensure guest PT interrupts are handled correctly, but obviously the NMI handler
needs to exit for that CPU to get into a guest...

> >  	return 0;
> >  }
> >  EXPORT_SYMBOL_GPL(perf_register_guest_info_callbacks);
> >  
> >  int perf_unregister_guest_info_callbacks(struct perf_guest_info_callbacks *cbs)
> >  {
> > -	perf_guest_cbs = NULL;
> 
> 	if (WARN_ON_ONCE(perf_guest_cbs != cbs))
> 		return -EBUSY;
> 
> ?

Works for me.  I guess I'm more optimistic about people not being morons :-)
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
