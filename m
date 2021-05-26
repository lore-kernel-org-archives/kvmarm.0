Return-Path: <SRS0=AgFV=KV=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.6 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1AF54C47089
	for <kvmarm@archiver.kernel.org>; Wed, 26 May 2021 17:37:47 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 8B40A613D2
	for <kvmarm@archiver.kernel.org>; Wed, 26 May 2021 17:37:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8B40A613D2
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0D27A4080B;
	Wed, 26 May 2021 13:37:46 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id RBkL1mg6TGWW; Wed, 26 May 2021 13:37:44 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 79FF84A418;
	Wed, 26 May 2021 13:37:44 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id EB5354A319
 for <kvmarm@lists.cs.columbia.edu>; Wed, 26 May 2021 13:37:42 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id EU-As1YlXYlO for <kvmarm@lists.cs.columbia.edu>;
 Wed, 26 May 2021 13:37:41 -0400 (EDT)
Received: from mail-pj1-f53.google.com (mail-pj1-f53.google.com
 [209.85.216.53])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 8999A49E5F
 for <kvmarm@lists.cs.columbia.edu>; Wed, 26 May 2021 13:37:41 -0400 (EDT)
Received: by mail-pj1-f53.google.com with SMTP id
 lx17-20020a17090b4b11b029015f3b32b8dbso799865pjb.0
 for <kvmarm@lists.cs.columbia.edu>; Wed, 26 May 2021 10:37:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=SESdVm3oX+A4kC0oEUyMsztkMQLrpiyjzEyQQYXemBw=;
 b=nA0SQfpDHGk6BkaEU5djTkNS/28EB/PhyNRJzwVyIJO4sTikyT1iORkKCrR3eA1LRW
 Ly2AouG002UsgvK5QBli8jxPPB/n0eHvcqI/WUYzQUhSNJVY5YVv0SWIgr/RNlv2QBuV
 qYYkRNwdgfLnmBREX/LDGui++0UF5rny5ABGb/8Bct+axGaRoZOImL4Z22GvjaF+6caO
 3ZNBcU2gNOB+VQyfm8yzfID1my9f4ur0/ryzuYxDyiuR9CXMFsMyTv/zUyyFrBCEp9YQ
 qyy7eDc6saihjmmuFBd8Xkcv3SNfWCVTxQqPM2gMIa43UBiOJAEjrHNxIivjwB2ok9Vm
 zlKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=SESdVm3oX+A4kC0oEUyMsztkMQLrpiyjzEyQQYXemBw=;
 b=r8Q+nZr8MhdJrR5L1sWWB/BBPv+BpCSH/r6ctwPI+voT7t2YlmIUKC9PNL7/i4WoN0
 Cvb2bvciBmCcM0DJjVoRVB4ymBpHj4Mo/6aTgeaQgEwgH2xNeUZOohPpwd3fvNTuCKXm
 pDBx6IvIsnawys3oW7o2E21fLL61IAUQtQNQRVjCyfW8245CqCNDBnyClWEEyhSlJNBi
 nxaaCL5+LWGWknmurpUEGndzIk7ZLY9RZ/KbbzjatfLyb7oOEWS7JZzKp9prGYf/hbW2
 scV90buIe0rIp5CyyASyQbsZDPKWUIrWZX2R9wIZ5I/2i2khp8KzBVzD3R5OjGsB6BM3
 aTRA==
X-Gm-Message-State: AOAM531c7HYJefzZNyCaw1g18Cs0qGoT5UKRLtvNtV6csrcSE2CAhoiC
 uFw2+Apqti0p9zif56hq2O7Egg==
X-Google-Smtp-Source: ABdhPJyuX27D1fPX33QiFUgyzimWAd5POtLHKJnYPYNJl79SkmSt9R7lH2x5Xf2qwaVJQrJsGYjLPw==
X-Received: by 2002:a17:90a:d793:: with SMTP id
 z19mr37167613pju.91.1622050660065; 
 Wed, 26 May 2021 10:37:40 -0700 (PDT)
Received: from google.com (150.12.83.34.bc.googleusercontent.com.
 [34.83.12.150])
 by smtp.gmail.com with ESMTPSA id s12sm2853pji.5.2021.05.26.10.37.39
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Wed, 26 May 2021 10:37:39 -0700 (PDT)
Date: Wed, 26 May 2021 10:37:35 -0700
From: Ricardo Koller <ricarkol@google.com>
To: Andrew Jones <drjones@redhat.com>
Subject: Re: [PATCH v2 5/5] KVM: arm64: selftests: get-reg-list: Split base
 and pmu registers
Message-ID: <YK6HX5Z23cYhVQeK@google.com>
References: <20210519140726.892632-1-drjones@redhat.com>
 <20210519140726.892632-6-drjones@redhat.com>
 <YK1ZcqgyLFSDH14+@google.com>
 <20210526065724.3qb3fz5idwlskhpx@gator.home>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20210526065724.3qb3fz5idwlskhpx@gator.home>
Cc: kvm@vger.kernel.org, maz@kernel.org, pbonzini@redhat.com,
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

On Wed, May 26, 2021 at 08:57:24AM +0200, Andrew Jones wrote:
> On Tue, May 25, 2021 at 01:09:22PM -0700, Ricardo Koller wrote:
> > On Wed, May 19, 2021 at 04:07:26PM +0200, Andrew Jones wrote:
> > > Since KVM commit 11663111cd49 ("KVM: arm64: Hide PMU registers from
> > > userspace when not available") the get-reg-list* tests have been
> > > failing with
> > > 
> > >   ...
> > >   ... There are 74 missing registers.
> > >   The following lines are missing registers:
> > >   ...
> > > 
> > > where the 74 missing registers are all PMU registers. This isn't a
> > > bug in KVM that the selftest found, even though it's true that a
> > > KVM userspace that wasn't setting the KVM_ARM_VCPU_PMU_V3 VCPU
> > > flag, but still expecting the PMU registers to be in the reg-list,
> > > would suddenly no longer have their expectations met. In that case,
> > > the expectations were wrong, though, so that KVM userspace needs to
> > > be fixed, and so does this selftest. The fix for this selftest is to
> > > pull the PMU registers out of the base register sublist into their
> > > own sublist and then create new, pmu-enabled vcpu configs which can
> > > be tested.
> > > 
> > > Signed-off-by: Andrew Jones <drjones@redhat.com>
> > > ---
> > >  .../selftests/kvm/aarch64/get-reg-list.c      | 46 +++++++++++++++----
> > >  1 file changed, 38 insertions(+), 8 deletions(-)
> > > 
> > > diff --git a/tools/testing/selftests/kvm/aarch64/get-reg-list.c b/tools/testing/selftests/kvm/aarch64/get-reg-list.c
> > > index dc06a28bfb74..78d8949bddbd 100644
> > > --- a/tools/testing/selftests/kvm/aarch64/get-reg-list.c
> > > +++ b/tools/testing/selftests/kvm/aarch64/get-reg-list.c
> > > @@ -47,6 +47,7 @@ struct reg_sublist {
> > >  struct vcpu_config {
> > >  	const char *name;
> > >  	bool sve;
> > > +	bool pmu;
> > >  	struct reg_sublist sublists[];
> > >  };
> > 
> > I think it's possible that the number of sublists keeps increasing: it
> > would be very nice/useful if KVM allowed enabling/disabling more
> > features from userspace (besides SVE, PMU etc). In that case, it might
> > be easier if adding a new feature to get-reg-list just requires defining
> > a new config and not dealing with the internals of vcpu_config.
> 
> Yes, adding the bools is a bit ugly, but how will we easily check if a
> given feature is present in a given config? We could put a copy of the
> vcpu_init features bitmap in vcpu_config, but I'm not sure if not touching
> the vcpu_config structure is worth having to use test_bit() and friends
> everywhere.
> 

I agree, the bools are better than the bits.

My solution was to completely ignore the SVE test in print_reg (not the
best solution).

> > 
> > Do you think it's possible in general to associate a sublist to a
> > capability and a feature? It works for the PMU and SVE. If that is
> > possible, what do you think of something like this? this would be the
> > config for sve+pmu:
> > 
> > static struct vcpu_config sve_pmu_config = {
> >       "sve+pmu",
> >        .sublists = {
> >        { "base", true, 0, 0, false, base_regs, ARRAY_SIZE(base_regs), },
> >        { "sve", false, KVM_ARM_VCPU_SVE, KVM_CAP_ARM_SVE, true, sve_regs, ARRAY_SIZE(sve_regs), sve_rejects_set, ARRAY_SIZE(sve_rejects_set), },
> >        { "pmu", false, KVM_ARM_VCPU_PMU_V3, KVM_CAP_ARM_PMU_V3, false, pmu_regs, ARRAY_SIZE(pmu_regs), },
> >        {0},
> >        },
> > };
> > 
> > Appended a rough patch at the end to make this idea more concrete.
> 
> Comments below
>

Ack on all the comments.

> > diff --git a/tools/testing/selftests/kvm/aarch64/get-reg-list.c b/tools/testing/selftests/kvm/aarch64/get-reg-list.c
> > index 78d8949bddbd..33b8735bdb15 100644
> > --- a/tools/testing/selftests/kvm/aarch64/get-reg-list.c
> > +++ b/tools/testing/selftests/kvm/aarch64/get-reg-list.c
> > @@ -38,6 +38,11 @@ static struct kvm_reg_list *reg_list;
> >  static __u64 *blessed_reg, blessed_n;
> >  
> >  struct reg_sublist {
> > +       const char *name;
> > +       bool base;
> > +       int feature;
> > +       int capability;
> > +       bool finalize;
> >         __u64 *regs;
> >         __u64 regs_n;
> >         __u64 *rejects_set;
> > @@ -46,8 +51,6 @@ struct reg_sublist {
> >  
> >  struct vcpu_config {
> >         const char *name;
> > -       bool sve;
> > -       bool pmu;
> >         struct reg_sublist sublists[];
> >  };
> >  
> > @@ -257,10 +260,7 @@ static void print_reg(struct vcpu_config *c, __u64 id)
> >                 printf("\tKVM_REG_ARM_FW_REG(%lld),\n", id & 0xffff);
> >                 break;
> >         case KVM_REG_ARM64_SVE:
> > -               if (c->sve)
> > -                       printf("\t%s,\n", sve_id_to_str(c, id));
> > -               else
> > -                       TEST_FAIL("%s: KVM_REG_ARM64_SVE is an unexpected coproc type in reg id: 0x%llx", c->name, id);
> > +               printf("\t%s,\n", sve_id_to_str(c, id));
> 
> I'd rather not lose this test. What we were doing here is making sure we
> don't see registers with KVM_REG_ARM64_SVE when sve is not enabled.
> 
> >                 break;
> >         default:
> >                 TEST_FAIL("%s: Unexpected coproc type: 0x%llx in reg id: 0x%llx",
> > @@ -327,31 +327,42 @@ static void core_reg_fixup(void)
> >  
> >  static void prepare_vcpu_init(struct vcpu_config *c, struct kvm_vcpu_init *init)
> >  {
> > -       if (c->sve)
> > -               init->features[0] |= 1 << KVM_ARM_VCPU_SVE;
> > -       if (c->pmu)
> > -               init->features[0] |= 1 << KVM_ARM_VCPU_PMU_V3;
> > +       struct reg_sublist *s;
> > +
> > +       for_each_sublist(c, s) {
> > +               if (s->base)
> > +                       continue;
> > +               init->features[0] |= 1 << s->feature;
> > +       }
> 
> If we want this to be general then we should ensure s->feature is < 32,
> otherwise we need to move to the next word. Granted we only have a few
> features so far for all the years we've had Arm KVM, so we probably don't
> need to worry about this any time soon...
> 
> >  }
> >  
> >  static void finalize_vcpu(struct kvm_vm *vm, uint32_t vcpuid, struct vcpu_config *c)
> >  {
> > +       struct reg_sublist *s;
> >         int feature;
> >  
> > -       if (c->sve) {
> > -               feature = KVM_ARM_VCPU_SVE;
> > -               vcpu_ioctl(vm, vcpuid, KVM_ARM_VCPU_FINALIZE, &feature);
> > +       for_each_sublist(c, s) {
> > +               if (s->base)
> > +                       continue;
> 
> Probably don't need the if (s->base) continue, since base registers won't
> have s->finalize.
> 
> > +               if (s->finalize) {
> > +                       feature = s->feature;
> > +                       vcpu_ioctl(vm, vcpuid, KVM_ARM_VCPU_FINALIZE, &feature);
> > +               }
> >         }
> >  }
> >  
> >  static void check_supported(struct vcpu_config *c)
> >  {
> > -       if (c->sve && !kvm_check_cap(KVM_CAP_ARM_SVE)) {
> > -               fprintf(stderr, "%s: SVE not available, skipping tests\n", c->name);
> > -               exit(KSFT_SKIP);
> > -       }
> > -       if (c->pmu && !kvm_check_cap(KVM_CAP_ARM_PMU_V3)) {
> > -               fprintf(stderr, "%s: PMU not available, skipping tests\n", c->name);
> > -               exit(KSFT_SKIP);
> > +       struct reg_sublist *s;
> > +
> > +       for_each_sublist(c, s) {
> > +               if (s->base)
> > +                       continue;
> 
> Also don't need the if (s->base) continue, since base registers won't have
> capabilities.
> 
> > +               if (!kvm_check_cap(s->capability)) {
> > +                       fprintf(stderr, "%s: %s not available, skipping tests\n", c->name, s->name);
> > +                       exit(KSFT_SKIP);
> > +
> > +               }
> >         }
> >  }
> >  
> > @@ -975,34 +986,34 @@ static __u64 sve_rejects_set[] = {
> >  static struct vcpu_config vregs_config = {
> >         "vregs",
> >         .sublists = {
> > -       { base_regs,    ARRAY_SIZE(base_regs), },
> > -       { vregs,        ARRAY_SIZE(vregs), },
> > +       { "base", true, 0, 0, false, base_regs, ARRAY_SIZE(base_regs), },
> > +       { "vregs", true, 0, 0, false, vregs, ARRAY_SIZE(vregs), },
> >         {0},
> >         },
> >  };
> >  static struct vcpu_config vregs_pmu_config = {
> > -       "vregs+pmu", .pmu = true,
> > +       "vregs+pmu",
> >         .sublists = {
> > -       { base_regs,    ARRAY_SIZE(base_regs), },
> > -       { vregs,        ARRAY_SIZE(vregs), },
> > -       { pmu_regs,     ARRAY_SIZE(pmu_regs), },
> > +       { "base", true, 0, 0, false, base_regs, ARRAY_SIZE(base_regs), },
> > +       { "vregs", true, 0, 0, false, vregs, ARRAY_SIZE(vregs), },
> > +       { "pmu", false, KVM_ARM_VCPU_PMU_V3, KVM_CAP_ARM_PMU_V3, false, pmu_regs, ARRAY_SIZE(pmu_regs), },
> >         {0},
> >         },
> >  };
> >  static struct vcpu_config sve_config = {
> > -       "sve", .sve = true,
> > +       "sve",
> >         .sublists = {
> > -       { base_regs,    ARRAY_SIZE(base_regs), },
> > -       { sve_regs,     ARRAY_SIZE(sve_regs),   sve_rejects_set,        ARRAY_SIZE(sve_rejects_set), },
> > +       { "base", true, 0, 0, false, base_regs, ARRAY_SIZE(base_regs), },
> > +       { "sve", false, KVM_ARM_VCPU_SVE, KVM_CAP_ARM_SVE, true, sve_regs, ARRAY_SIZE(sve_regs), sve_rejects_set, ARRAY_SIZE(sve_rejects_set), },
> >         {0},
> >         },
> >  };
> >  static struct vcpu_config sve_pmu_config = {
> > -       "sve+pmu", .sve = true, .pmu = true,
> > +       "sve+pmu",
> >         .sublists = {
> > -       { base_regs,    ARRAY_SIZE(base_regs), },
> > -       { sve_regs,     ARRAY_SIZE(sve_regs),   sve_rejects_set,        ARRAY_SIZE(sve_rejects_set), },
> > -       { pmu_regs,     ARRAY_SIZE(pmu_regs), },
> > +       { "base", true, 0, 0, false, base_regs, ARRAY_SIZE(base_regs), },
> > +       { "sve", false, KVM_ARM_VCPU_SVE, KVM_CAP_ARM_SVE, true, sve_regs, ARRAY_SIZE(sve_regs), sve_rejects_set, ARRAY_SIZE(sve_rejects_set), },
> > +       { "pmu", false, KVM_ARM_VCPU_PMU_V3, KVM_CAP_ARM_PMU_V3, false, pmu_regs, ARRAY_SIZE(pmu_regs), },
> >         {0},
> >         },
> >  };
> > 
> 
> It looks pretty good to me. While I don't really care about needing to add
> booleans to vcpu_config, the biggest advantage I see is not needing to
> modify prepare_vcpu_init, finalize_vcpu, and check_supported, and that the
> feature bits and caps are better associated with the sublists.
> 
> These tables are getting wordy, though, so we'll probably want some
> macros.
> 
> I'll experiment with this to see if I can integrate some of your
> suggestions into a v3.

Thanks for considering the changes.

> 
> Thanks,
> drew
>

Thanks,
Ricardo
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
