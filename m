Return-Path: <SRS0=B0kT=CR=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,FSL_HELO_FAKE,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AD217C43461
	for <kvmarm@archiver.kernel.org>; Tue,  8 Sep 2020 10:53:03 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 2759A208C7
	for <kvmarm@archiver.kernel.org>; Tue,  8 Sep 2020 10:53:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=google.com header.i=@google.com header.b="nT2RetXC"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2759A208C7
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8B7454B30E;
	Tue,  8 Sep 2020 06:53:02 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id KZXdrkRqvp24; Tue,  8 Sep 2020 06:53:01 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3FC6C4B3D8;
	Tue,  8 Sep 2020 06:53:01 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5221D4B45D
 for <kvmarm@lists.cs.columbia.edu>; Tue,  8 Sep 2020 06:52:59 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 9CUXJTKbU-5S for <kvmarm@lists.cs.columbia.edu>;
 Tue,  8 Sep 2020 06:52:58 -0400 (EDT)
Received: from mail-wr1-f67.google.com (mail-wr1-f67.google.com
 [209.85.221.67])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 1EC874B3D8
 for <kvmarm@lists.cs.columbia.edu>; Tue,  8 Sep 2020 06:52:58 -0400 (EDT)
Received: by mail-wr1-f67.google.com with SMTP id w5so18600243wrp.8
 for <kvmarm@lists.cs.columbia.edu>; Tue, 08 Sep 2020 03:52:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=F9dk15GOlkPaspc7wMO0W0WDOaJSPahbZyg1od4IkXE=;
 b=nT2RetXCMCIHxCozmm0YXIPz+w4wnOIpdQ1LaHRgbtS5jRkubzkf/h1pBJYQZQC2Ed
 iLHCzacsvGAOYc13pL9GiaWJPmcit1vNIfMoaEKF/0vhWNx8TTnpB6LSoR+P1kVxW83w
 IbgvwTLcIvUF5DiUIfcPnZhtesH0DHTx0kc88ss7v0EI626y7EsaT+EM66E0ttZ5gADb
 VS37kAClXrTa1eWYfHHf5yoCihw5+ZiwZ53J/bx8/z+U1ORJMyag9ilkNstjQpOZhGRu
 zuu86z73dazgXe+o1iGUm3QU1dgv53bhYhChn6Q1w4uq7sn0GpoGpaqKdFpcNq38rf5b
 53mA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=F9dk15GOlkPaspc7wMO0W0WDOaJSPahbZyg1od4IkXE=;
 b=o4+yV5AswVqtr6zYoPWB0tEfHoFhLvcGzrJ0fyupQCyahc+wFOiLvsKH3apfJkCHnN
 FQvEBLHz6c6DRCDHyrgdoSvxZLokIduCp60oqzVGApno1nVWpqOHZWMz87ZMEitdc9FW
 H/y//awCVbyc8I3eh/xo2k7Mk/TFdCGfZ7JPJLKa6AvIhpR52b9zetZOce+4tUp99ZKn
 dSilj8diWsrpfNv0vIwuI7+LhsTkNC5xzrOtvKXWmQ4MWrR+MBtF7nK8JxPHkjb3KvMs
 7EylIFv9RV4smR6LyR3lwygvsuxRInDUTR5R1X/xQ5ApH7cs4U9whrdBoyDPqplIPN4C
 569A==
X-Gm-Message-State: AOAM531ezpqkEfL12E9EqHneFijKl8Oh5awv0742zNiFwLzOD7clSYyH
 0Bwxt+jLBhxHs3Zfd2xEm/z1nQ==
X-Google-Smtp-Source: ABdhPJzKC0xIce/ZJE7/ALHltWwu0Ivsi9UsMCddFNSDQTSB9CZWQTxkRe5v4Ji2rFyULc8qaZ0P/A==
X-Received: by 2002:a5d:568d:: with SMTP id f13mr25650988wrv.303.1599562376964; 
 Tue, 08 Sep 2020 03:52:56 -0700 (PDT)
Received: from google.com ([2a00:79e0:d:109:4a0f:cfff:fe4a:6363])
 by smtp.gmail.com with ESMTPSA id s5sm33668521wrm.33.2020.09.08.03.52.55
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Tue, 08 Sep 2020 03:52:56 -0700 (PDT)
Date: Tue, 8 Sep 2020 11:52:51 +0100
From: Andrew Scull <ascull@google.com>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH v3 08/18] KVM: arm64: Introduce hyp context
Message-ID: <20200908105251.GD3268721@google.com>
References: <20200903135307.251331-1-ascull@google.com>
 <20200903135307.251331-9-ascull@google.com>
 <87sgbtlnq0.wl-maz@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <87sgbtlnq0.wl-maz@kernel.org>
Cc: kernel-team@android.com, catalin.marinas@arm.com,
 linux-arm-kernel@lists.infradead.org, Sudeep Holla <sudeep.holla@arm.com>,
 will@kernel.org, kvmarm@lists.cs.columbia.edu
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

On Mon, Sep 07, 2020 at 02:29:11PM +0100, Marc Zyngier wrote:
> On Thu, 03 Sep 2020 14:52:57 +0100,
> Andrew Scull <ascull@google.com> wrote:
> > 
> > During __guest_enter, save and restore from a new hyp context rather
> > than the host context. This is preparation for separation of the hyp and
> > host context in nVHE.
> > 
> > Signed-off-by: Andrew Scull <ascull@google.com>
> > ---
> >  arch/arm64/include/asm/kvm_hyp.h        |  3 ++-
> >  arch/arm64/kernel/image-vars.h          |  1 +
> >  arch/arm64/kvm/arm.c                    | 10 ++++++++++
> >  arch/arm64/kvm/hyp/entry.S              | 10 +++++-----
> >  arch/arm64/kvm/hyp/include/hyp/switch.h |  2 +-
> >  arch/arm64/kvm/hyp/nvhe/switch.c        |  2 +-
> >  arch/arm64/kvm/hyp/vhe/switch.c         |  2 +-
> >  7 files changed, 21 insertions(+), 9 deletions(-)
> > 
> > diff --git a/arch/arm64/include/asm/kvm_hyp.h b/arch/arm64/include/asm/kvm_hyp.h
> > index 1e2491da324e..0b525e05e5bf 100644
> > --- a/arch/arm64/include/asm/kvm_hyp.h
> > +++ b/arch/arm64/include/asm/kvm_hyp.h
> > @@ -12,6 +12,7 @@
> >  #include <asm/alternative.h>
> >  #include <asm/sysreg.h>
> >  
> > +DECLARE_PER_CPU(struct kvm_cpu_context, kvm_hyp_ctxt);
> >  DECLARE_PER_CPU(unsigned long, kvm_hyp_vector);
> >  
> >  #define read_sysreg_elx(r,nvh,vh)					\
> > @@ -89,7 +90,7 @@ void activate_traps_vhe_load(struct kvm_vcpu *vcpu);
> >  void deactivate_traps_vhe_put(void);
> >  #endif
> >  
> > -u64 __guest_enter(struct kvm_vcpu *vcpu, struct kvm_cpu_context *host_ctxt);
> > +u64 __guest_enter(struct kvm_vcpu *vcpu);
> >  
> >  void __noreturn hyp_panic(void);
> >  #ifdef __KVM_NVHE_HYPERVISOR__
> > diff --git a/arch/arm64/kernel/image-vars.h b/arch/arm64/kernel/image-vars.h
> > index 54bb0eb34b0f..9f419e4fc66b 100644
> > --- a/arch/arm64/kernel/image-vars.h
> > +++ b/arch/arm64/kernel/image-vars.h
> > @@ -71,6 +71,7 @@ KVM_NVHE_ALIAS(kvm_update_va_mask);
> >  /* Global kernel state accessed by nVHE hyp code. */
> >  KVM_NVHE_ALIAS(arm64_ssbd_callback_required);
> >  KVM_NVHE_ALIAS(kvm_host_data);
> > +KVM_NVHE_ALIAS(kvm_hyp_ctxt);
> >  KVM_NVHE_ALIAS(kvm_hyp_vector);
> >  KVM_NVHE_ALIAS(kvm_vgic_global_state);
> >  
> > diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> > index b6442c6be5ad..ae4b34f91e94 100644
> > --- a/arch/arm64/kvm/arm.c
> > +++ b/arch/arm64/kvm/arm.c
> > @@ -47,6 +47,7 @@ __asm__(".arch_extension	virt");
> >  #endif
> >  
> >  DEFINE_PER_CPU(struct kvm_host_data, kvm_host_data);
> > +DEFINE_PER_CPU(struct kvm_cpu_context, kvm_hyp_ctxt);
> 
> [back to this patch after having reviewed a few of the subsequent
> ones]
> 
> Given the variety of contexts you are introducing, I wonder if the
> best course of action for most of this isn't simply to use the EL2
> stack rather than defining ad-hoc structures.
> 
> The host save/restore you are introducing in a later patch certainly
> could do without a separate data structure (hello, struct pt_regs) and
> the hyp/host churn.
> 
> What do you think?

We could define the start of the stack to be the host context (IIRC,
TF-A does something along those lines). Maybe there is some locality
benefit?

The percpu definitions become less onerous in code with David's percpu
series as the mapping to EL2 is done in bulk rather than per item.

Ptrauth switching is something that doesn't fall under pt_regs (it's no
longer in this series, but will need to be switched later on). I had
chosen to reuse the existing structs but a host-specilized context might
be preferred?
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
