Return-Path: <SRS0=n474=OM=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,FSL_HELO_FAKE,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87614C433EF
	for <kvmarm@archiver.kernel.org>; Wed, 22 Sep 2021 18:11:51 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id EAAB3610A1
	for <kvmarm@archiver.kernel.org>; Wed, 22 Sep 2021 18:11:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org EAAB3610A1
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 52FCA40291;
	Wed, 22 Sep 2021 14:11:50 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 9lRhsL-8yqOo; Wed, 22 Sep 2021 14:11:49 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 267524B0A0;
	Wed, 22 Sep 2021 14:11:49 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 984ED4079A
 for <kvmarm@lists.cs.columbia.edu>; Wed, 22 Sep 2021 10:44:33 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 8WK3PGiC7INT for <kvmarm@lists.cs.columbia.edu>;
 Wed, 22 Sep 2021 10:44:32 -0400 (EDT)
Received: from mail-pj1-f49.google.com (mail-pj1-f49.google.com
 [209.85.216.49])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 55F4640159
 for <kvmarm@lists.cs.columbia.edu>; Wed, 22 Sep 2021 10:44:32 -0400 (EDT)
Received: by mail-pj1-f49.google.com with SMTP id
 lb1-20020a17090b4a4100b001993f863df2so2456923pjb.5
 for <kvmarm@lists.cs.columbia.edu>; Wed, 22 Sep 2021 07:44:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=k92i1CTT4UfLIvqoj9NDLUAGbjRSVGtjE0AGo1vSZmQ=;
 b=f4lwilm8F32Il0kw2q+o2S5gn8bX330s+QqjMwYgJsMXJx2nLKL8EyWd3+MfL2K9jX
 0tGZwNvTXYGj36wKXNRWv7f2/8WtblkGM8adydd7zCEXJGRgzSafRw0/O5bJe3dDxQQ7
 U6i6z0ifislGQqzGxuWjmB4KG9fM9SillTMfXqaBzcnu4xfTxwQwb9DhTuwjk8oShc1N
 jmvJCl5gNVv2BNfFOnt3eTgLyXM+NbWeomDRALyfRFD5e79waLuLKw5bLUrghLsJW9+c
 416hVoGg/lJKH5l5wbmxWkJQPlcGZB1pD/Mw8bTjlh40CsuIN/vh+c8yxxUJ2SyTVGzx
 o6KQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=k92i1CTT4UfLIvqoj9NDLUAGbjRSVGtjE0AGo1vSZmQ=;
 b=Y0+AyY/Ar+MY2vJ1uQXXsVMa5oW7R7hhId6X5rsEr3EEzQhSxrQ7IS/e/WYjGWmsjz
 X/JorvffKuq1CgKzPUWMPKe/B8xUErzjlXHisURSfX2faLGvfClGwGAlUQUS8YD2ecIA
 3zgNB4t/hWa7aSNXphzY3lnx+EhIx1tMiDvlNSn1ZxUck8q+4/qAHA013KFZLRi5FoG/
 hGPB41pah6/6hX0qr0YhcNI7bpMhvlMgfV01AqyZZNCC6JLuSnfvS+3R4nmYS5ST5nNZ
 JlDixf54tffykULVEiwANavmGr4VPsxmwU6ghOp8Cx7iecDxmHCZ6XB/GORqd4kJ0WaH
 0BEw==
X-Gm-Message-State: AOAM531mYFDBoi0cKZfR9/DWavq0j+GszGoZ11VKUATYuua2TGwqB2Zx
 ZP78sPjdymNEeDjdqtePdMLFmw==
X-Google-Smtp-Source: ABdhPJy6Cm8J5yFpuY0b3Q26cuBfzP0jR3SXJy8Sit4o8X0PGq0Nl30V3OZC+YaU8p9jHy4oX17FmA==
X-Received: by 2002:a17:902:8606:b029:12c:2625:76cf with SMTP id
 f6-20020a1709028606b029012c262576cfmr223350plo.17.1632321871110; 
 Wed, 22 Sep 2021 07:44:31 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com.
 [35.185.214.157])
 by smtp.gmail.com with ESMTPSA id d14sm2901977pfq.61.2021.09.22.07.44.30
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Wed, 22 Sep 2021 07:44:30 -0700 (PDT)
Date: Wed, 22 Sep 2021 14:44:26 +0000
From: Sean Christopherson <seanjc@google.com>
To: Reiji Watanabe <reijiw@google.com>
Subject: Re: [PATCH v8 2/8] KVM: arm64: Separate guest/host counter offset
 values
Message-ID: <YUtBSvC97RPD4iRD@google.com>
References: <20210916181510.963449-1-oupton@google.com>
 <20210916181510.963449-3-oupton@google.com>
 <CAAeT=Fznwct=D8tk-zRg1SGTa9FqrOrXZ7Boc9yMOnrZ5NPMZw@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAAeT=Fznwct=D8tk-zRg1SGTa9FqrOrXZ7Boc9yMOnrZ5NPMZw@mail.gmail.com>
X-Mailman-Approved-At: Wed, 22 Sep 2021 14:11:48 -0400
Cc: kvm@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>,
 Peter Shier <pshier@google.com>, Marc Zyngier <maz@kernel.org>,
 David Matlack <dmatlack@google.com>, Paolo Bonzini <pbonzini@redhat.com>,
 Will Deacon <will@kernel.org>, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org, Jim Mattson <jmattson@google.com>
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

On Tue, Sep 21, 2021, Reiji Watanabe wrote:
> Hi Oliver,
> 
> On Thu, Sep 16, 2021 at 11:15 AM Oliver Upton <oupton@google.com> wrote:
> > +static void timer_set_guest_offset(struct arch_timer_context *ctxt, u64 offset)
> > +{
> > +       struct kvm_vcpu *vcpu = ctxt->vcpu;
> > +
> > +       switch (arch_timer_ctx_index(ctxt)) {
> > +       case TIMER_VTIMER: {
> > +               u64 host_offset = timer_get_offset(ctxt);
> > +
> > +               host_offset += offset - __vcpu_sys_reg(vcpu, CNTVOFF_EL2);
> > +               __vcpu_sys_reg(vcpu, CNTVOFF_EL2) = offset;
> > +               timer_set_offset(ctxt, host_offset);

Really getting into nitpicking territory, but it maybe name this
timer_set_virtual_offset() (assuming v=virtual and p=physical).  Based on the
name, I expected this to set a variable literally named guest_offset, but it
reads and writes host_offset.  Maintaining the virtual vs. physical terminology
all the way down avoids having direct host vs. guest naming conflicts, i.e.
virtual and host aren't generally though of as mutually exclusive.

> > +               break;
> > +       }
> > +       default:
> > +               WARN_ONCE(offset, "timer %ld\n", arch_timer_ctx_index(ctxt));
> > +       }
> > +}
> > +
> >  u64 kvm_phys_timer_read(void)
> >  {
> >         return timecounter->cc->read(timecounter->cc);
> > @@ -749,7 +763,8 @@ int kvm_timer_vcpu_reset(struct kvm_vcpu *vcpu)
> >
> >  /* Make offset updates for all timer contexts atomic */
> >  static void update_timer_offset(struct kvm_vcpu *vcpu,
> > -                               enum kvm_arch_timers timer, u64 offset)
> > +                               enum kvm_arch_timers timer, u64 offset,
> > +                               bool guest_visible)
> 
> The name 'guest_visible' looks confusing to me because it also
> affects the type of the 'offset' that its caller needs to specify.
> (The 'offset' must be an offset from the guest's physical counter
> if 'guest_visible' == true, and an offset from the host's virtual
> counter otherwise.)
> Having said that, I don't have a good alternative name for it though...
> IMHO, 'is_host_offset' would be less confusing because it indicates
> what the caller needs to specify.

I'd say ditch the param altogether and just have two separate helpers.  Even in
the final code, the callers all pass explicit 'true' or 'false', i.e. the callers
can just as easily call a different function.

Despite the near-identical code, smushing guest and host into the same function
doesn't actually save much, just the function prototype and the local variables.

That'd also avoid having to document/comment what 'true' and 'false' means at the
call sites.

> >  {
> >         int i;
> >         struct kvm *kvm = vcpu->kvm;
> > @@ -758,13 +773,20 @@ static void update_timer_offset(struct kvm_vcpu *vcpu,
> >         lockdep_assert_held(&kvm->lock);
> >
> >         kvm_for_each_vcpu(i, tmp, kvm)

This needs braces if you keep it as is.
> > -               timer_set_offset(vcpu_get_timer(tmp, timer), offset);
> > +               if (guest_visible)
> > +                       timer_set_guest_offset(vcpu_get_timer(tmp, timer),
> > +                                              offset);

Let this poke out, 84 chars isn't the end of the world.

> > +               else
> > +                       timer_set_offset(vcpu_get_timer(tmp, timer), offset);
> >
> >         /*
> >          * When called from the vcpu create path, the CPU being created is not
> >          * included in the loop above, so we just set it here as well.
> >          */

Any reason this can't be called from kvm_arch_vcpu_postcreate()?  That'd eliminate
the need for the extra handling.  The vCPU is technically visible to userspace, but
userspace would have to very intentionally do the wrong thing to cause problems,
and I don't see any obviosu danger to the host.

> > -       timer_set_offset(vcpu_get_timer(vcpu, timer), offset);
> > +       if (guest_visible)
> > +               timer_set_guest_offset(vcpu_get_timer(vcpu, timer), offset);
> > +       else
> > +               timer_set_offset(vcpu_get_timer(vcpu, timer), offset);
> >  }
> >
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
