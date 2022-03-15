Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1F6E7C433F5
	for <kvmarm@archiver.kernel.org>; Tue, 15 Mar 2022 17:54:15 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 59BC049F0F;
	Tue, 15 Mar 2022 13:54:15 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id qVjQkyHQIvpV; Tue, 15 Mar 2022 13:54:13 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C7F5D49EB5;
	Tue, 15 Mar 2022 13:54:13 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id EAE2749EB5
 for <kvmarm@lists.cs.columbia.edu>; Tue, 15 Mar 2022 13:54:11 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id EO8q5maWZV1N for <kvmarm@lists.cs.columbia.edu>;
 Tue, 15 Mar 2022 13:54:10 -0400 (EDT)
Received: from mail-yb1-f180.google.com (mail-yb1-f180.google.com
 [209.85.219.180])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 85DE649EB3
 for <kvmarm@lists.cs.columbia.edu>; Tue, 15 Mar 2022 13:54:10 -0400 (EDT)
Received: by mail-yb1-f180.google.com with SMTP id z8so14689ybh.7
 for <kvmarm@lists.cs.columbia.edu>; Tue, 15 Mar 2022 10:54:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=/gCZYXA1pFPtDLMS/KV6Ow2JMvpV89INylwyV10OD1Q=;
 b=o8EjxOygDbe80v1/WABejnL1Pnq2uPy2+1seK8c4qpLhT7Tvg6tysQsseyBW42n2Nm
 DecA+jHN9K8mORqxXFOt2hQcNu16K8S7CiRpGbANNDtPWG9LE0R4INvJrBK/SSw/iGHK
 igHPhlAOlERy+Py3Naz9mrwa2uTojC1pjW2TiJFoffo905jVV0jUhmoko1UWFsJFFvZJ
 co3JQohnNSRP5sWZolye/BxIjelGc6eOy7h1HmL+TOwZAYp6cwi0G/e8o7R8/dkJYmnO
 FkS1lFtSA1q77Icd4gMoCqv9j8jSU+QJETSbQUfK6o5t6xnyIJZMUfqvYRhc1qvdULmh
 +9rg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=/gCZYXA1pFPtDLMS/KV6Ow2JMvpV89INylwyV10OD1Q=;
 b=WbmdQ0kSbDXU1ww2b+y1qb0P/hJIKszJU1tU2JozMEhnGzha2XrmyCd7xvheyDuWFF
 Tg+zTVyVcuPOyk4LBZ1jypjeJoa55xXUmMO6M3DCpOASG8OewhF4ahNlTNUZ1dVfIe0W
 zL35HlWfwRA7VCDqB3dJyNY9brV0kQw+tMt9vDpDhUjd8Xb7TwY7ICTsBz8rYk2/D6oF
 509rlzJmir3/gJrVQ8aE/2CIOQi4T/GqfvB94x2L/hzyKUI7wemrTdt16B37dT8LbRdM
 B9hXdwthkLRkHj2zcUWeS8dg8C14WUQ+V+a7LuJOVXbBJwHm9UK50D9ZlHut4GNh8H/k
 XJMA==
X-Gm-Message-State: AOAM530zwS/J8gt4qJwYntuJZmbiJ03JgXgNd+sapvY1jytMmtNZ9Fod
 7mvRownGrG454s+8J93JVtQCLdabq1vLr0UWfBrGxg==
X-Google-Smtp-Source: ABdhPJzkMkMFsSfpPECWFU81L0xIQ9AJddFEVrI1qVKVg8/lSilFXpI08p1bc3RJ3P5DqyGs+pqrafqyjiuzinH5tHs=
X-Received: by 2002:a5b:d46:0:b0:628:aafa:1e54 with SMTP id
 f6-20020a5b0d46000000b00628aafa1e54mr23369223ybr.509.1647366849726; Tue, 15
 Mar 2022 10:54:09 -0700 (PDT)
MIME-Version: 1.0
References: <20220224172559.4170192-1-rananta@google.com>
 <20220224172559.4170192-8-rananta@google.com>
 <Yi+eoHWYgt6A5z+1@google.com>
 <CAJHc60z7wZmABs3Z0LVP9SJnu9T7tU-VK5=F0=tSjy9ScEdqOQ@mail.gmail.com>
 <YjA1AzZPlPV20kMj@google.com>
In-Reply-To: <YjA1AzZPlPV20kMj@google.com>
From: Raghavendra Rao Ananta <rananta@google.com>
Date: Tue, 15 Mar 2022 10:53:58 -0700
Message-ID: <CAJHc60wv1+7Z9bG-Kioc-zig+8d8d1E8f0svtdVG4k2DcS2_dw@mail.gmail.com>
Subject: Re: [PATCH v4 07/13] KVM: arm64: Add vendor hypervisor firmware
 register
To: Oliver Upton <oupton@google.com>
Cc: kvm@vger.kernel.org, Will Deacon <will@kernel.org>,
 Marc Zyngier <maz@kernel.org>, Peter Shier <pshier@google.com>,
 linux-kernel@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>,
 Paolo Bonzini <pbonzini@redhat.com>, kvmarm@lists.cs.columbia.edu,
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

On Mon, Mar 14, 2022 at 11:41 PM Oliver Upton <oupton@google.com> wrote:
>
> On Mon, Mar 14, 2022 at 05:30:15PM -0700, Raghavendra Rao Ananta wrote:
> > On Mon, Mar 14, 2022 at 12:59 PM Oliver Upton <oupton@google.com> wrote:
> > >
> > > On Thu, Feb 24, 2022 at 05:25:53PM +0000, Raghavendra Rao Ananta wrote:
> > > > Introduce the firmware register to hold the vendor specific
> > > > hypervisor service calls (owner value 6) as a bitmap. The
> > > > bitmap represents the features that'll be enabled for the
> > > > guest, as configured by the user-space. Currently, this
> > > > includes support only for Precision Time Protocol (PTP),
> > > > represented by bit-0.
> > > >
> > > > The register is also added to the kvm_arm_vm_scope_fw_regs[]
> > > > list as it maintains its state per-VM.
> > > >
> > > > Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
> > > > ---
> > > >  arch/arm64/include/asm/kvm_host.h |  2 ++
> > > >  arch/arm64/include/uapi/asm/kvm.h |  4 ++++
> > > >  arch/arm64/kvm/guest.c            |  1 +
> > > >  arch/arm64/kvm/hypercalls.c       | 22 +++++++++++++++++++++-
> > > >  include/kvm/arm_hypercalls.h      |  3 +++
> > > >  5 files changed, 31 insertions(+), 1 deletion(-)
> > > >
> > > > diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> > > > index 318148b69279..d999456c4604 100644
> > > > --- a/arch/arm64/include/asm/kvm_host.h
> > > > +++ b/arch/arm64/include/asm/kvm_host.h
> > > > @@ -106,10 +106,12 @@ struct kvm_arch_memory_slot {
> > > >   *
> > > >   * @hvc_std_bmap: Bitmap of standard secure service calls
> > > >   * @hvc_std_hyp_bmap: Bitmap of standard hypervisor service calls
> > > > + * @hvc_vendor_hyp_bmap: Bitmap of vendor specific hypervisor service calls
> > > >   */
> > > >  struct kvm_hvc_desc {
> > > >       u64 hvc_std_bmap;
> > > >       u64 hvc_std_hyp_bmap;
> > > > +     u64 hvc_vendor_hyp_bmap;
> > > >  };
> > > >
> > > >  struct kvm_arch {
> > > > diff --git a/arch/arm64/include/uapi/asm/kvm.h b/arch/arm64/include/uapi/asm/kvm.h
> > > > index 9a2caead7359..ed470bde13d8 100644
> > > > --- a/arch/arm64/include/uapi/asm/kvm.h
> > > > +++ b/arch/arm64/include/uapi/asm/kvm.h
> > > > @@ -299,6 +299,10 @@ struct kvm_arm_copy_mte_tags {
> > > >  #define KVM_REG_ARM_STD_HYP_BIT_PV_TIME              BIT(0)
> > > >  #define KVM_REG_ARM_STD_HYP_BMAP_BIT_MAX     0       /* Last valid bit */
> > > >
> > > > +#define KVM_REG_ARM_VENDOR_HYP_BMAP          KVM_REG_ARM_FW_BMAP_REG(2)
> > > > +#define KVM_REG_ARM_VENDOR_HYP_BIT_PTP               BIT(0)
> > > > +#define KVM_REG_ARM_VENDOR_HYP_BMAP_BIT_MAX  0       /* Last valid bit */
> > > > +
> > > >  /* SVE registers */
> > > >  #define KVM_REG_ARM64_SVE            (0x15 << KVM_REG_ARM_COPROC_SHIFT)
> > > >
> > > > diff --git a/arch/arm64/kvm/guest.c b/arch/arm64/kvm/guest.c
> > > > index c42426d6137e..fc3656f91aed 100644
> > > > --- a/arch/arm64/kvm/guest.c
> > > > +++ b/arch/arm64/kvm/guest.c
> > > > @@ -67,6 +67,7 @@ static const u64 kvm_arm_vm_scope_fw_regs[] = {
> > > >       KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2,
> > > >       KVM_REG_ARM_STD_BMAP,
> > > >       KVM_REG_ARM_STD_HYP_BMAP,
> > > > +     KVM_REG_ARM_VENDOR_HYP_BMAP,
> > > >  };
> > > >
> > > >  /**
> > > > diff --git a/arch/arm64/kvm/hypercalls.c b/arch/arm64/kvm/hypercalls.c
> > > > index ebc0cc26cf2e..5c5098c8f1f9 100644
> > > > --- a/arch/arm64/kvm/hypercalls.c
> > > > +++ b/arch/arm64/kvm/hypercalls.c
> > > > @@ -79,6 +79,9 @@ static bool kvm_hvc_call_supported(struct kvm_vcpu *vcpu, u32 func_id)
> > > >       case ARM_SMCCC_HV_PV_TIME_ST:
> > > >               return kvm_arm_fw_reg_feat_enabled(hvc_desc->hvc_std_hyp_bmap,
> > > >                                       KVM_REG_ARM_STD_HYP_BIT_PV_TIME);
> > > > +     case ARM_SMCCC_VENDOR_HYP_KVM_PTP_FUNC_ID:
> > > > +             return kvm_arm_fw_reg_feat_enabled(hvc_desc->hvc_vendor_hyp_bmap,
> > > > +                                     KVM_REG_ARM_VENDOR_HYP_BIT_PTP);
> > > >       default:
> > > >               /* By default, allow the services that aren't listed here */
> > > >               return true;
> > > > @@ -162,7 +165,14 @@ int kvm_hvc_call_handler(struct kvm_vcpu *vcpu)
> > > >               break;
> > > >       case ARM_SMCCC_VENDOR_HYP_KVM_FEATURES_FUNC_ID:
> > > >               val[0] = BIT(ARM_SMCCC_KVM_FUNC_FEATURES);
> > > > -             val[0] |= BIT(ARM_SMCCC_KVM_FUNC_PTP);
> > > > +
> > > > +             /*
> > > > +              * The feature bits exposed to user-space doesn't include
> > > > +              * ARM_SMCCC_KVM_FUNC_FEATURES. However, we expose this to
> > > > +              * the guest as bit-0. Hence, left-shift the user-space
> > > > +              * exposed bitmap by 1 to accommodate this.
> > > > +              */
> > > > +             val[0] |= hvc_desc->hvc_vendor_hyp_bmap << 1;
> > >
> > > Having an off-by-one difference between the userspace and guest
> > > representations of this bitmap seems like it could be a source of bugs
> > > in the future. Its also impossible for the guest to completely hide the
> > > vendor range if it so chooses.
> > >
> > > Why not tie ARM_SMCCC_VENDOR_HYP_CALL_UID_FUNC_ID and
> > > ARM_SMCCC_VENDOR_HYP_KVM_FEATURES_FUNC_ID to BIT(0)? PTP would then
> > > become BIT(1).
> > >
> > I agree it's a little asymmetrical. But exposing a bit for the
> > func_ids that you mentioned means providing a capability to disable
> > them by the userspace. This would block the guests from even
> > discovering the space. If it's not too ugly, we can maintain certain
> > bits to always remain read-only to the user-space. On the other hand,
> > we can simply ignore what the userspace configure and simply treat it
> > as a userspace bug. What do you think?
>
> I think that assigning a bit to the aforementioned hypercalls would be
> best. If userspace decides to hide all the features enumerated in the
> subrange then there isn't much point to the guest knowing that the range
> even exists. It shouldn't amount to much for userspace, as it will
> likely just keep the default value and only worry about these registers
> when migrating.
>
Sure, I'll include a bit for these as well.

Thanks,
Raghavenadra

> Apologies if I'm being pedantic, but such a subtle implementation detail
> could be overlooked in future changes.
>
> --
> Oliver
>
> > > >               break;
> > > >       case ARM_SMCCC_VENDOR_HYP_KVM_PTP_FUNC_ID:
> > > >               kvm_ptp_get_time(vcpu, val);
> > > > @@ -188,6 +198,7 @@ static const u64 kvm_arm_fw_reg_ids[] = {
> > > >       KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2,
> > > >       KVM_REG_ARM_STD_BMAP,
> > > >       KVM_REG_ARM_STD_HYP_BMAP,
> > > > +     KVM_REG_ARM_VENDOR_HYP_BMAP,
> > > >  };
> > > >
> > > >  void kvm_arm_init_hypercalls(struct kvm *kvm)
> > > > @@ -196,6 +207,7 @@ void kvm_arm_init_hypercalls(struct kvm *kvm)
> > > >
> > > >       hvc_desc->hvc_std_bmap = ARM_SMCCC_STD_FEATURES;
> > > >       hvc_desc->hvc_std_hyp_bmap = ARM_SMCCC_STD_HYP_FEATURES;
> > > > +     hvc_desc->hvc_vendor_hyp_bmap = ARM_SMCCC_VENDOR_HYP_FEATURES;
> > > >  }
> > > >
> > > >  int kvm_arm_get_fw_num_regs(struct kvm_vcpu *vcpu)
> > > > @@ -285,6 +297,9 @@ int kvm_arm_get_fw_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
> > > >       case KVM_REG_ARM_STD_HYP_BMAP:
> > > >               val = READ_ONCE(hvc_desc->hvc_std_hyp_bmap);
> > > >               break;
> > > > +     case KVM_REG_ARM_VENDOR_HYP_BMAP:
> > > > +             val = READ_ONCE(hvc_desc->hvc_vendor_hyp_bmap);
> > > > +             break;
> > > >       default:
> > > >               return -ENOENT;
> > > >       }
> > > > @@ -311,6 +326,10 @@ static int kvm_arm_set_fw_reg_bmap(struct kvm_vcpu *vcpu, u64 reg_id, u64 val)
> > > >               fw_reg_bmap = &hvc_desc->hvc_std_hyp_bmap;
> > > >               fw_reg_features = ARM_SMCCC_STD_HYP_FEATURES;
> > > >               break;
> > > > +     case KVM_REG_ARM_VENDOR_HYP_BMAP:
> > > > +             fw_reg_bmap = &hvc_desc->hvc_vendor_hyp_bmap;
> > > > +             fw_reg_features = ARM_SMCCC_VENDOR_HYP_FEATURES;
> > > > +             break;
> > > >       default:
> > > >               return -ENOENT;
> > > >       }
> > > > @@ -416,6 +435,7 @@ int kvm_arm_set_fw_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
> > > >               return 0;
> > > >       case KVM_REG_ARM_STD_BMAP:
> > > >       case KVM_REG_ARM_STD_HYP_BMAP:
> > > > +     case KVM_REG_ARM_VENDOR_HYP_BMAP:
> > > >               return kvm_arm_set_fw_reg_bmap(vcpu, reg_id, val);
> > > >       default:
> > > >               return -ENOENT;
> > > > diff --git a/include/kvm/arm_hypercalls.h b/include/kvm/arm_hypercalls.h
> > > > index a1cb6e839c74..91be758ca58e 100644
> > > > --- a/include/kvm/arm_hypercalls.h
> > > > +++ b/include/kvm/arm_hypercalls.h
> > > > @@ -12,6 +12,9 @@
> > > >  #define ARM_SMCCC_STD_HYP_FEATURES \
> > > >       GENMASK_ULL(KVM_REG_ARM_STD_HYP_BMAP_BIT_MAX, 0)
> > > >
> > > > +#define ARM_SMCCC_VENDOR_HYP_FEATURES \
> > > > +     GENMASK_ULL(KVM_REG_ARM_VENDOR_HYP_BMAP_BIT_MAX, 0)
> > > > +
> > > >  int kvm_hvc_call_handler(struct kvm_vcpu *vcpu);
> > > >
> > > >  static inline u32 smccc_get_function(struct kvm_vcpu *vcpu)
> > > > --
> > > > 2.35.1.473.g83b2b277ed-goog
> > > >
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
