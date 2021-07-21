Return-Path: <SRS0=81/H=MN=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.6 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A8C7BC636CE
	for <kvmarm@archiver.kernel.org>; Wed, 21 Jul 2021 07:38:03 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 210166120C
	for <kvmarm@archiver.kernel.org>; Wed, 21 Jul 2021 07:38:03 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 210166120C
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 899544B0ED;
	Wed, 21 Jul 2021 03:38:02 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 5-SSQMXYJNcV; Wed, 21 Jul 2021 03:38:01 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4E12E4B118;
	Wed, 21 Jul 2021 03:38:01 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CF2674B0E6
 for <kvmarm@lists.cs.columbia.edu>; Wed, 21 Jul 2021 03:37:59 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id g6s2ynAWG1Yr for <kvmarm@lists.cs.columbia.edu>;
 Wed, 21 Jul 2021 03:37:58 -0400 (EDT)
Received: from mail-ot1-f51.google.com (mail-ot1-f51.google.com
 [209.85.210.51])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 810BA4B0DD
 for <kvmarm@lists.cs.columbia.edu>; Wed, 21 Jul 2021 03:37:58 -0400 (EDT)
Received: by mail-ot1-f51.google.com with SMTP id
 t4-20020a05683014c4b02904cd671b911bso1291238otq.1
 for <kvmarm@lists.cs.columbia.edu>; Wed, 21 Jul 2021 00:37:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=sbDE9nuiwcCGzXXq+7fSJ8S51kGTOjsBAbq4AfxevII=;
 b=jGy1guoPkgxKAm1XQU1WLRIEQZY1AD4aitTaSIidCU3rRsvKa7nxuBID74o4MsS/bj
 4qXadR3io6HZi6HOnEdXWMjqn8bNkMukr9HhK5Zf9izRcFc+1b4yPdGDsHGvxaqAoLhR
 xibE1txj9oMAoU+2XyKy0BCoNvYyFfxbU3oh1bNDNJkIFiL0VxTxbMyipjkZSbIZg6fB
 Fukma3U+Q6MCJLGluVxLjsadF5PTSATyatjQ9hAZJMnzdT4ioLG+cAIEJrJ8RL1LcQ9c
 3Ka8kBButPskeIKyCsjo5hwsp1IQ9b9QPTGzOfWMqInEh4NTWwvm69W+Rj/wQHgJAl1g
 4+IQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=sbDE9nuiwcCGzXXq+7fSJ8S51kGTOjsBAbq4AfxevII=;
 b=Umrj3E7UQtrOVTOtugao1ItbMtvOihL34RBQvJpr2rdOPbZBKmrBf93lnCSYnsWfT/
 cbBxIrxIIXHD+c3abKgxI/cCZvLCzSg/ZMfD9YMEhhLnt9WT80vwYIj5yWhrBBBqF28P
 cbMS2SNMRsoD1Bp4OVCKI0MDK+mrcLf48BABhuqZm2BlFxmVQj2y+SZ//kc+ciONE5EZ
 bon6O1b9x8jA/so+3tJ6RbC55qqceUW0HnFs9ufhbxB1bqQ+AMm21x+3PG8j1ObjrYYO
 w04pQudd5IPNc8cSQ341uocII9K2M22U6aXhgLZEkNLRG0LRNvHcIJn9XTnoZ0JfxRJn
 CxUw==
X-Gm-Message-State: AOAM530J3hd46WjN4Qmjb/7kUGs+qmVCni6AgKm1H5we3nd52YngRY/x
 lI0n0aVB9Jn+UB5/tgczYIU1JLFdbUjr4OSNPqqn8g==
X-Google-Smtp-Source: ABdhPJzn9ZlAdVQ5+LOgkbShWo2nP3Ij7fKtXuiBI/ClZYD4r7erA2kfADFFHYYk/rf89JGWCw3PtbSRc5H7QH0EHpg=
X-Received: by 2002:a9d:4b02:: with SMTP id q2mr14416397otf.52.1626853077570; 
 Wed, 21 Jul 2021 00:37:57 -0700 (PDT)
MIME-Version: 1.0
References: <20210719160346.609914-1-tabba@google.com>
 <20210719160346.609914-7-tabba@google.com>
 <20210720145258.axhqog3abdvtpqhw@gator>
In-Reply-To: <20210720145258.axhqog3abdvtpqhw@gator>
From: Fuad Tabba <tabba@google.com>
Date: Wed, 21 Jul 2021 08:37:21 +0100
Message-ID: <CA+EHjTweLPu+DQ8hR9kEW0LrawtaoAoXR_+HmSEZpP-XOEm2qg@mail.gmail.com>
Subject: Re: [PATCH v3 06/15] KVM: arm64: Restore mdcr_el2 from vcpu
To: Andrew Jones <drjones@redhat.com>
Cc: kernel-team@android.com, kvm@vger.kernel.org, maz@kernel.org,
 pbonzini@redhat.com, will@kernel.org, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org
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

Hi Drew,

On Tue, Jul 20, 2021 at 3:53 PM Andrew Jones <drjones@redhat.com> wrote:
>
> On Mon, Jul 19, 2021 at 05:03:37PM +0100, Fuad Tabba wrote:
> > On deactivating traps, restore the value of mdcr_el2 from the
> > newly created and preserved host value vcpu context, rather than
> > directly reading the hardware register.
> >
> > Up until and including this patch the two values are the same,
> > i.e., the hardware register and the vcpu one. A future patch will
> > be changing the value of mdcr_el2 on activating traps, and this
> > ensures that its value will be restored.
> >
> > No functional change intended.
>
> I'm probably missing something, but I can't convince myself that the host
> will end up with the same mdcr_el2 value after deactivating traps after
> this patch as before. We clearly now restore whatever we had when
> activating traps (presumably whatever we configured at init_el2_state
> time), but is that equivalent to what we had before with the masking and
> ORing that this patch drops?

You're right. I thought that these were actually being initialized to
the same values, but having a closer look at the code the mdcr values
are not the same as pre-patch. I will fix this.

Thanks!
/fuad

> Thanks,
> drew
>
> >
> > Signed-off-by: Fuad Tabba <tabba@google.com>
> > ---
> >  arch/arm64/include/asm/kvm_host.h       |  5 ++++-
> >  arch/arm64/include/asm/kvm_hyp.h        |  2 +-
> >  arch/arm64/kvm/hyp/include/hyp/switch.h |  6 +++++-
> >  arch/arm64/kvm/hyp/nvhe/switch.c        | 11 ++---------
> >  arch/arm64/kvm/hyp/vhe/switch.c         | 12 ++----------
> >  arch/arm64/kvm/hyp/vhe/sysreg-sr.c      |  2 +-
> >  6 files changed, 15 insertions(+), 23 deletions(-)
> >
> > diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> > index 4d2d974c1522..76462c6a91ee 100644
> > --- a/arch/arm64/include/asm/kvm_host.h
> > +++ b/arch/arm64/include/asm/kvm_host.h
> > @@ -287,10 +287,13 @@ struct kvm_vcpu_arch {
> >       /* Stage 2 paging state used by the hardware on next switch */
> >       struct kvm_s2_mmu *hw_mmu;
> >
> > -     /* HYP configuration */
> > +     /* Values of trap registers for the guest. */
> >       u64 hcr_el2;
> >       u64 mdcr_el2;
> >
> > +     /* Values of trap registers for the host before guest entry. */
> > +     u64 mdcr_el2_host;
> > +
> >       /* Exception Information */
> >       struct kvm_vcpu_fault_info fault;
> >
> > diff --git a/arch/arm64/include/asm/kvm_hyp.h b/arch/arm64/include/asm/kvm_hyp.h
> > index 9d60b3006efc..657d0c94cf82 100644
> > --- a/arch/arm64/include/asm/kvm_hyp.h
> > +++ b/arch/arm64/include/asm/kvm_hyp.h
> > @@ -95,7 +95,7 @@ void __sve_restore_state(void *sve_pffr, u32 *fpsr);
> >
> >  #ifndef __KVM_NVHE_HYPERVISOR__
> >  void activate_traps_vhe_load(struct kvm_vcpu *vcpu);
> > -void deactivate_traps_vhe_put(void);
> > +void deactivate_traps_vhe_put(struct kvm_vcpu *vcpu);
> >  #endif
> >
> >  u64 __guest_enter(struct kvm_vcpu *vcpu);
> > diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h b/arch/arm64/kvm/hyp/include/hyp/switch.h
> > index e4a2f295a394..a0e78a6027be 100644
> > --- a/arch/arm64/kvm/hyp/include/hyp/switch.h
> > +++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
> > @@ -92,11 +92,15 @@ static inline void __activate_traps_common(struct kvm_vcpu *vcpu)
> >               write_sysreg(0, pmselr_el0);
> >               write_sysreg(ARMV8_PMU_USERENR_MASK, pmuserenr_el0);
> >       }
> > +
> > +     vcpu->arch.mdcr_el2_host = read_sysreg(mdcr_el2);
> >       write_sysreg(vcpu->arch.mdcr_el2, mdcr_el2);
> >  }
> >
> > -static inline void __deactivate_traps_common(void)
> > +static inline void __deactivate_traps_common(struct kvm_vcpu *vcpu)
> >  {
> > +     write_sysreg(vcpu->arch.mdcr_el2_host, mdcr_el2);
> > +
> >       write_sysreg(0, hstr_el2);
> >       if (kvm_arm_support_pmu_v3())
> >               write_sysreg(0, pmuserenr_el0);
> > diff --git a/arch/arm64/kvm/hyp/nvhe/switch.c b/arch/arm64/kvm/hyp/nvhe/switch.c
> > index f7af9688c1f7..1778593a08a9 100644
> > --- a/arch/arm64/kvm/hyp/nvhe/switch.c
> > +++ b/arch/arm64/kvm/hyp/nvhe/switch.c
> > @@ -69,12 +69,10 @@ static void __activate_traps(struct kvm_vcpu *vcpu)
> >  static void __deactivate_traps(struct kvm_vcpu *vcpu)
> >  {
> >       extern char __kvm_hyp_host_vector[];
> > -     u64 mdcr_el2, cptr;
> > +     u64 cptr;
> >
> >       ___deactivate_traps(vcpu);
> >
> > -     mdcr_el2 = read_sysreg(mdcr_el2);
> > -
> >       if (cpus_have_final_cap(ARM64_WORKAROUND_SPECULATIVE_AT)) {
> >               u64 val;
> >
> > @@ -92,13 +90,8 @@ static void __deactivate_traps(struct kvm_vcpu *vcpu)
> >               isb();
> >       }
> >
> > -     __deactivate_traps_common();
> > -
> > -     mdcr_el2 &= MDCR_EL2_HPMN_MASK;
> > -     mdcr_el2 |= MDCR_EL2_E2PB_MASK << MDCR_EL2_E2PB_SHIFT;
> > -     mdcr_el2 |= MDCR_EL2_E2TB_MASK << MDCR_EL2_E2TB_SHIFT;
> > +     __deactivate_traps_common(vcpu);
> >
> > -     write_sysreg(mdcr_el2, mdcr_el2);
> >       write_sysreg(this_cpu_ptr(&kvm_init_params)->hcr_el2, hcr_el2);
> >
> >       cptr = CPTR_EL2_DEFAULT;
> > diff --git a/arch/arm64/kvm/hyp/vhe/switch.c b/arch/arm64/kvm/hyp/vhe/switch.c
> > index b3229924d243..0d0c9550fb08 100644
> > --- a/arch/arm64/kvm/hyp/vhe/switch.c
> > +++ b/arch/arm64/kvm/hyp/vhe/switch.c
> > @@ -91,17 +91,9 @@ void activate_traps_vhe_load(struct kvm_vcpu *vcpu)
> >       __activate_traps_common(vcpu);
> >  }
> >
> > -void deactivate_traps_vhe_put(void)
> > +void deactivate_traps_vhe_put(struct kvm_vcpu *vcpu)
> >  {
> > -     u64 mdcr_el2 = read_sysreg(mdcr_el2);
> > -
> > -     mdcr_el2 &= MDCR_EL2_HPMN_MASK |
> > -                 MDCR_EL2_E2PB_MASK << MDCR_EL2_E2PB_SHIFT |
> > -                 MDCR_EL2_TPMS;
> > -
> > -     write_sysreg(mdcr_el2, mdcr_el2);
> > -
> > -     __deactivate_traps_common();
> > +     __deactivate_traps_common(vcpu);
> >  }
> >
> >  /* Switch to the guest for VHE systems running in EL2 */
> > diff --git a/arch/arm64/kvm/hyp/vhe/sysreg-sr.c b/arch/arm64/kvm/hyp/vhe/sysreg-sr.c
> > index 2a0b8c88d74f..007a12dd4351 100644
> > --- a/arch/arm64/kvm/hyp/vhe/sysreg-sr.c
> > +++ b/arch/arm64/kvm/hyp/vhe/sysreg-sr.c
> > @@ -101,7 +101,7 @@ void kvm_vcpu_put_sysregs_vhe(struct kvm_vcpu *vcpu)
> >       struct kvm_cpu_context *host_ctxt;
> >
> >       host_ctxt = &this_cpu_ptr(&kvm_host_data)->host_ctxt;
> > -     deactivate_traps_vhe_put();
> > +     deactivate_traps_vhe_put(vcpu);
> >
> >       __sysreg_save_el1_state(guest_ctxt);
> >       __sysreg_save_user_state(guest_ctxt);
> > --
> > 2.32.0.402.g57bb445576-goog
> >
>
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
