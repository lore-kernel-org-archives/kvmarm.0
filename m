Return-Path: <SRS0=jphx=NS=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9A96BC4320E
	for <kvmarm@archiver.kernel.org>; Fri, 27 Aug 2021 15:20:33 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 396EE60F91
	for <kvmarm@archiver.kernel.org>; Fri, 27 Aug 2021 15:20:33 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 396EE60F91
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E26EB4B12D;
	Fri, 27 Aug 2021 11:20:32 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id L7Tbs5GiIm2s; Fri, 27 Aug 2021 11:20:31 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C5E6B4B121;
	Fri, 27 Aug 2021 11:20:30 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7353A4B121
 for <kvmarm@lists.cs.columbia.edu>; Fri, 27 Aug 2021 10:58:41 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id eReEIY+WsKM4 for <kvmarm@lists.cs.columbia.edu>;
 Fri, 27 Aug 2021 10:58:40 -0400 (EDT)
Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com
 [209.85.214.176])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 71D194B120
 for <kvmarm@lists.cs.columbia.edu>; Fri, 27 Aug 2021 10:58:40 -0400 (EDT)
Received: by mail-pl1-f176.google.com with SMTP id e15so4090932plh.8
 for <kvmarm@lists.cs.columbia.edu>; Fri, 27 Aug 2021 07:58:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=uRFFUbAhELNbaSp6/gZa0c8lVubPxa9shGc4LpwPEKA=;
 b=LaTxPm5alTPx3ec48IA6+ZkyOejP1tGYjt5wY+p50UOfksJNBKAzDXOzoDDiJpQJ7C
 7ZlQ2CaQrXUZrhEVe/+L/sf91LGMM0vWjp8eP3YRAXU34kmcSmT/loEOx2KY28gVVCsl
 oNwRHnusQG6CUmxymYZ58t9NT8p9wB0iZAAe71TUcHWHnrhk4i1QLthTClskPP73rEx7
 8W5oVGVmckueDqbKs0mB5YdxIHBLQgh+JwU0k3CO0TH8YixDpwG1SB6F/loD+NPrNZ2l
 0CosQb5gLTnLJ9MX51KpbZFvZYLNN8TvF8Ol0HP7oCHqmHClmMDvOIzUAi7IGzMuFHXf
 oANw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=uRFFUbAhELNbaSp6/gZa0c8lVubPxa9shGc4LpwPEKA=;
 b=nCs/obEnA81qM9g0vCt7p4X/NtgHsjLC2sfiiP7XwMkxExItpkgtmKIA4qguarO8pD
 Byy3FHbhGQEER0/mhjLtGfVUB8SLNNWRUCttybNhRTk5RqcRH2DIVEbU+m2AD1h2xdpY
 h0dx+nvw2TK46hNsZHmpbg5gW0JYj5ukX/LL9vS/6bXO+ruC1PhjeXmKEKADTcIdaS0v
 9GHoBJBGruBmuD1ddB9X97q9fpcokUiAlwY59Cy3tXlYZ+WxTAlK21g64zA9oynbBBkF
 QJsFilH7/Vl5q6OYxsn+G4A6kVYcR8KT/jFccgKa1tPiaG/0CQhMupRZRV4Fh4eE9RWK
 D5yQ==
X-Gm-Message-State: AOAM53132zuwPkJYwLSp/7cDzaevsbmxFRY3fzxt0eDJ2zDklpi0poof
 jnDHTURBJkGlGhFguNT9WKX79g==
X-Google-Smtp-Source: ABdhPJzgh09WISpUzNhO7TIEv2MEhpi/JDC49fmE6awwyfv/L0ffcVcqSZUNcnR7TJ7/0hyFRiQ/2g==
X-Received: by 2002:a17:902:e20a:b0:134:221f:657d with SMTP id
 u10-20020a170902e20a00b00134221f657dmr9134631plb.78.1630076319283; 
 Fri, 27 Aug 2021 07:58:39 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com.
 [35.185.214.157])
 by smtp.gmail.com with ESMTPSA id e11sm6590628pfn.49.2021.08.27.07.58.38
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Fri, 27 Aug 2021 07:58:38 -0700 (PDT)
Date: Fri, 27 Aug 2021 14:58:35 +0000
From: Sean Christopherson <seanjc@google.com>
To: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH 07/15] KVM: Use dedicated flag to track if KVM is
 handling an NMI from guest
Message-ID: <YSj9mz4F2NDSKaas@google.com>
References: <20210827005718.585190-1-seanjc@google.com>
 <20210827005718.585190-8-seanjc@google.com>
 <YSiUnDbi/aZ3nunT@hirez.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <YSiUnDbi/aZ3nunT@hirez.programming.kicks-ass.net>
X-Mailman-Approved-At: Fri, 27 Aug 2021 11:20:29 -0400
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

On Fri, Aug 27, 2021, Peter Zijlstra wrote:
> On Thu, Aug 26, 2021 at 05:57:10PM -0700, Sean Christopherson wrote:
> > diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
> > index 5cedc0e8a5d5..4c5ba4128b38 100644
> > --- a/arch/x86/kvm/x86.h
> > +++ b/arch/x86/kvm/x86.h
> > @@ -395,9 +395,10 @@ static inline void kvm_unregister_perf_callbacks(void)
> >  
> >  DECLARE_PER_CPU(struct kvm_vcpu *, current_vcpu);
> >  
> > -static inline void kvm_before_interrupt(struct kvm_vcpu *vcpu)
> > +static inline void kvm_before_interrupt(struct kvm_vcpu *vcpu, bool is_nmi)
> >  {
> >  	__this_cpu_write(current_vcpu, vcpu);
> > +	WRITE_ONCE(vcpu->arch.handling_nmi_from_guest, is_nmi);
> >  
> >  	kvm_register_perf_callbacks();
> >  }
> > @@ -406,6 +407,7 @@ static inline void kvm_after_interrupt(struct kvm_vcpu *vcpu)
> >  {
> >  	kvm_unregister_perf_callbacks();
> >  
> > +	WRITE_ONCE(vcpu->arch.handling_nmi_from_guest, false);
> >  	__this_cpu_write(current_vcpu, NULL);
> >  }
> 
> Does this rely on kvm_{,un}register_perf_callback() being a function
> call and thus implying a sequence point to order the stores? 

No, I'm just terrible at remembering which macros provide what ordering guarantees,
i.e. I was thinking WRITE_ONCE provided guarantees against compiler reordering.
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
