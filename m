Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 36CB5C433EF
	for <kvmarm@archiver.kernel.org>; Tue, 15 Mar 2022 17:35:58 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A7E3C49E2B;
	Tue, 15 Mar 2022 13:35:57 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id CWL5yugs1D8e; Tue, 15 Mar 2022 13:35:53 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B38FF49ECC;
	Tue, 15 Mar 2022 13:35:53 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D1F2E49EB2
 for <kvmarm@lists.cs.columbia.edu>; Tue, 15 Mar 2022 13:35:52 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id GOWPKquor+G8 for <kvmarm@lists.cs.columbia.edu>;
 Tue, 15 Mar 2022 13:35:48 -0400 (EDT)
Received: from mail-il1-f172.google.com (mail-il1-f172.google.com
 [209.85.166.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id EF3EA49E2B
 for <kvmarm@lists.cs.columbia.edu>; Tue, 15 Mar 2022 13:35:47 -0400 (EDT)
Received: by mail-il1-f172.google.com with SMTP id h21so5899422ila.7
 for <kvmarm@lists.cs.columbia.edu>; Tue, 15 Mar 2022 10:35:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=xB07ic4vDEAKEcGbENjMpvSU5bZev7EeZpcMe0SL1Sk=;
 b=Q2mKJ54VdYT6PKF7Kd3MohhT/81mfTqd4J7TMBaooLNsVo0jqQwGZFPhF8RqLSKXo0
 TNWcggKLIsYTc5/va5vz9giH4ldO6Q5o3HQaSUmUnZqzOlldxvtYE2ghIwJlPhcs1Chx
 0q3sOfEyPL/JwgI6wRCT0JDujBHYzyKuVEnW3YyxOw37xGyhdBeS5BcFeNXwO340Yt3/
 Ja8vFIkl/NmuB1J91yOpQOzmt0AseowGy7bu1PTomEHrDe+pjFlHCTroIZDAtIeUclwz
 zowr7r4PM/QxV5ePZL6XtWlcCIUUd/TGYnFyELqC8YPvsXBq1MKke1gLNIdbIjaAz4RY
 ibyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=xB07ic4vDEAKEcGbENjMpvSU5bZev7EeZpcMe0SL1Sk=;
 b=A38N+++4k3eQ6VLdw9r1izOPM8IAabPxzpi/hjme9Al+eRSBhb3oRKxl7ebkEmAIXk
 NbyWH9aILUWlszTVcN7EU9yiQmEwtLm8RBg7IcE23kD9WOKp75BRIlNN5DuNxE4RLcZ6
 F1JoJCddbbP3FPClZI5hR6r1cRPCAzGvg+bFCFzS85P4dYkUaPl8F2Er4MxiFYjYN+1i
 tm/ERXhjXRnPngruM+7FPBo+f09z/CalnOFGiNeHS/yPkpX/cbVAEm2wz2lyO2Gbtk7T
 fW9TvX7RZKWYx2NFdX0jMWIyc5u6eNgdYQ+Bq0gx0SdZDJ0IkT9S1AtRJCHvk7+EnZoA
 YhFA==
X-Gm-Message-State: AOAM533y6YUz/HgA3x9Alvf5ewrNVjY4M0SgyZXeWl4hIhcZQ3hD5Jzp
 uQGlyU44YkjG3GkGKfX592kcpg==
X-Google-Smtp-Source: ABdhPJy4FslpKdd7Rvtr7sUC8GERMFuvONRw0Uih85qVWf2Mo8FrrV58on66V6E5rtt4qoWtdn1J/g==
X-Received: by 2002:a05:6e02:1a25:b0:2c6:5c9b:3951 with SMTP id
 g5-20020a056e021a2500b002c65c9b3951mr22025335ile.81.1647365746829; 
 Tue, 15 Mar 2022 10:35:46 -0700 (PDT)
Received: from google.com (194.225.68.34.bc.googleusercontent.com.
 [34.68.225.194]) by smtp.gmail.com with ESMTPSA id
 e15-20020a92194f000000b002c25e778042sm10820871ilm.73.2022.03.15.10.35.45
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Tue, 15 Mar 2022 10:35:46 -0700 (PDT)
Date: Tue, 15 Mar 2022 17:35:43 +0000
From: Oliver Upton <oupton@google.com>
To: Raghavendra Rao Ananta <rananta@google.com>
Subject: Re: [PATCH v4 05/13] KVM: arm64: Setup a framework for hypercall
 bitmap firmware registers
Message-ID: <YjDOb7R9ClibFMjQ@google.com>
References: <20220224172559.4170192-1-rananta@google.com>
 <20220224172559.4170192-6-rananta@google.com>
 <Yi+aTs4ufnxHXg4r@google.com>
 <CAJHc60yuSfd9YUXmXQjoS+K5u562nAArriB_tVP=mvuLuDeKFQ@mail.gmail.com>
 <YjA/TmAeXt2l19HP@google.com>
 <CAJHc60wz5WsZWTn66i41+G4-dsjCFuFkthXU_Vf6QeXHkgzrZg@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAJHc60wz5WsZWTn66i41+G4-dsjCFuFkthXU_Vf6QeXHkgzrZg@mail.gmail.com>
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

On Tue, Mar 15, 2022 at 09:59:35AM -0700, Raghavendra Rao Ananta wrote:
> On Tue, Mar 15, 2022 at 12:25 AM Oliver Upton <oupton@google.com> wrote:
> >
> > On Mon, Mar 14, 2022 at 05:22:31PM -0700, Raghavendra Rao Ananta wrote:
> > > Hi Oliver,
> > >
> > > On Mon, Mar 14, 2022 at 12:41 PM Oliver Upton <oupton@google.com> wrote:
> > > >
> > > > On Thu, Feb 24, 2022 at 05:25:51PM +0000, Raghavendra Rao Ananta wrote:
> > > > > KVM regularly introduces new hypercall services to the guests without
> > > > > any consent from the userspace. This means, the guests can observe
> > > > > hypercall services in and out as they migrate across various host
> > > > > kernel versions. This could be a major problem if the guest
> > > > > discovered a hypercall, started using it, and after getting migrated
> > > > > to an older kernel realizes that it's no longer available. Depending
> > > > > on how the guest handles the change, there's a potential chance that
> > > > > the guest would just panic.
> > > > >
> > > > > As a result, there's a need for the userspace to elect the services
> > > > > that it wishes the guest to discover. It can elect these services
> > > > > based on the kernels spread across its (migration) fleet. To remedy
> > > > > this, extend the existing firmware psuedo-registers, such as
> > > > > KVM_REG_ARM_PSCI_VERSION, for all the hypercall services available.
> > > > >
> > > > > These firmware registers are categorized based on the service call
> > > > > owners, and unlike the existing firmware psuedo-registers, they hold
> > > > > the features supported in the form of a bitmap.
> > > > >
> > > > > During the VM initialization, the registers holds an upper-limit of
> > > > > the features supported by the corresponding registers. It's expected
> > > > > that the VMMs discover the features provided by each register via
> > > > > GET_ONE_REG, and writeback the desired values using SET_ONE_REG.
> > > > > KVM allows this modification only until the VM has started.
> > > > >
> > > > > Older userspace code can simply ignore the capability and the
> > > > > hypercall services will be exposed unconditionally to the guests, thus
> > > > > ensuring backward compatibility.
> > > > >
> > > > > In this patch, the framework adds the register only for ARM's standard
> > > > > secure services (owner value 4). Currently, this includes support only
> > > > > for ARM True Random Number Generator (TRNG) service, with bit-0 of the
> > > > > register representing mandatory features of v1.0. The register is also
> > > > > added to the kvm_arm_vm_scope_fw_regs[] list as it maintains its state
> > > > > per-VM. Other services are momentarily added in the upcoming patches.
> > > > >
> > > > > Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
> > > > > ---
> > > > >  arch/arm64/include/asm/kvm_host.h | 12 +++++
> > > > >  arch/arm64/include/uapi/asm/kvm.h |  8 ++++
> > > > >  arch/arm64/kvm/arm.c              |  8 ++++
> > > > >  arch/arm64/kvm/guest.c            |  1 +
> > > > >  arch/arm64/kvm/hypercalls.c       | 78 +++++++++++++++++++++++++++++++
> > > > >  include/kvm/arm_hypercalls.h      |  4 ++
> > > > >  6 files changed, 111 insertions(+)
> > > > >
> > > > > diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> > > > > index e823571e50cc..1909ced3208f 100644
> > > > > --- a/arch/arm64/include/asm/kvm_host.h
> > > > > +++ b/arch/arm64/include/asm/kvm_host.h
> > > > > @@ -101,6 +101,15 @@ struct kvm_s2_mmu {
> > > > >  struct kvm_arch_memory_slot {
> > > > >  };
> > > > >
> > > > > +/**
> > > > > + * struct kvm_hvc_desc: KVM ARM64 hypercall descriptor
> > > > > + *
> > > > > + * @hvc_std_bmap: Bitmap of standard secure service calls
> > > > > + */
> > > > > +struct kvm_hvc_desc {
> > > >
> > > > nit: maybe call this structure kvm_hypercall_features? When nested comes
> > > > along guests will need to use the SVC conduit as HVC traps are always
> > > > taken to EL2. Same will need to be true for virtual EL2.
> > > >
> > > Sure, I can rename it to be more generic.
> > >
> > > > > +     u64 hvc_std_bmap;
> > > > > +};
> > > > > +
> > > > >  struct kvm_arch {
> > > > >       struct kvm_s2_mmu mmu;
> > > > >
> > > > > @@ -142,6 +151,9 @@ struct kvm_arch {
> > > > >
> > > > >       /* Capture first run of the VM */
> > > > >       bool has_run_once;
> > > > > +
> > > > > +     /* Hypercall firmware register' descriptor */
> > > > > +     struct kvm_hvc_desc hvc_desc;
> > > > >  };
> > > > >
> > > > >  struct kvm_vcpu_fault_info {
> > > > > diff --git a/arch/arm64/include/uapi/asm/kvm.h b/arch/arm64/include/uapi/asm/kvm.h
> > > > > index c35447cc0e0c..2decc30d6b84 100644
> > > > > --- a/arch/arm64/include/uapi/asm/kvm.h
> > > > > +++ b/arch/arm64/include/uapi/asm/kvm.h
> > > > > @@ -287,6 +287,14 @@ struct kvm_arm_copy_mte_tags {
> > > > >  #define KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2_NOT_REQUIRED     3
> > > > >  #define KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2_ENABLED          (1U << 4)
> > > > >
> > > > > +/* Bitmap firmware registers, extension to the existing psuedo-register space */
> > > > > +#define KVM_REG_ARM_FW_BMAP                  KVM_REG_ARM_FW_REG(0xff00)
> > > >
> > > > What is the motivation for moving the bitmap register indices so far
> > > > away from the rest of the firmware regs?
> > > >
> > > The original motivation to create a sub-space came from Reiji's
> > > comment on v3 [1] so that user-space can distinguish between bitmapped
> > > and regular fw registers.
> > > As with the spacing, I thought a 50/50 split would do a good job of
> > > avoiding collisions. Do you have any recommendations here?
> > >
> >
> > I see. This is for the sake of ABI stability with future expansion,
> > right? A new register could be added in the future that controls more
> > SMCCC features, and we expect userspace to zero them if it cares about
> > ABI stability.
> >
> > If that is all true, we probably need some strong supporting
> > documentation. Additionally, using a new COPROC value for the register
> > range might be better than partitioning the existing FW reg range.
> >
> I assumed the 50/50 split could be fine even for future expansion, but
> I can go for a new COPROC value. However, wouldn't the same problem
> exist even with that? We could never have enough space :)

Of course, but I think the UAPI is consistent if you use a new COPROC
value for the bitmaps. That way, you can add documentation that covers
the entire COPROC value you've selected, and doesn't require any further
twiddling with an existing register range. It seems that we have plenty
of COPROC values that are available as well.

> > > > > +#define KVM_REG_ARM_FW_BMAP_REG(r)           (KVM_REG_ARM_FW_BMAP | (r))
> > > >
> > > > If you are still going to use the index offset, just pass 'r' through to
> > > > the other macro:
> > > >
> > > >   #define KVM_REG_ARM_FW_BMAP_REG(r)            KVM_REG_ARM_FW_REG(0xff00 + r)
> > > >
> > > I'm sorry, what's the advantage of doing this?
> > >

Just a style nit :)

--
Thanks,
Oliver
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
