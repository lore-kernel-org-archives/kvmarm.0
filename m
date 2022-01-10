Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2AF14C4332F
	for <kvmarm@archiver.kernel.org>; Mon, 10 Jan 2022 23:40:50 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8D0AB4B0A0;
	Mon, 10 Jan 2022 18:40:50 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id hJoPm+-x+3zE; Mon, 10 Jan 2022 18:40:49 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4F5834B0B9;
	Mon, 10 Jan 2022 18:40:49 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 54FB64A11C
 for <kvmarm@lists.cs.columbia.edu>; Mon, 10 Jan 2022 18:40:48 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id uj7tu45NE9pX for <kvmarm@lists.cs.columbia.edu>;
 Mon, 10 Jan 2022 18:40:47 -0500 (EST)
Received: from mail-yb1-f172.google.com (mail-yb1-f172.google.com
 [209.85.219.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 35DF449FE6
 for <kvmarm@lists.cs.columbia.edu>; Mon, 10 Jan 2022 18:40:47 -0500 (EST)
Received: by mail-yb1-f172.google.com with SMTP id g81so15285017ybg.10
 for <kvmarm@lists.cs.columbia.edu>; Mon, 10 Jan 2022 15:40:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=qDGx4rPveudwE1vRW4I5CFIMkMb5URvZDsFlXmH9o6w=;
 b=o+EU0nOsD+ZtFVMEDfBaLk5/YT0q9pC/SpmMwy14s0gakua6hifIB6k2Xj6m3iX+1S
 BMYt1+ojCSX3t0ua86Q+GxiiyhEcmq1oYBYIqDV5gKshJy2P5jgPLAvBTNk+oSgrl9ZK
 pvTsQttJJkS9nzBVld6M9FGwH27Bcjkuo4H4/+qcaOVCtGk/3z3NcxgN0Jc7TT4rUNb4
 NXo4sVOg4isK1LNnG+dwaxcNqdTCs1TA3DJrcHSfiRbf1s9GYgTJVArz/NKkC+llvCnN
 BNrCIJc4wYzG0UoC1Jp/oLXFyODb16L+QlTcyOhaYzSZRsnapZNMD/18hoziMEdmzhSY
 iOUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=qDGx4rPveudwE1vRW4I5CFIMkMb5URvZDsFlXmH9o6w=;
 b=t7M1nEDzylvnogLdn7Vq8CWPqVLxvj4SrTae0KKglJatrFWLC1p6RC0jZKDFf3XlT+
 45zp64oVVw4pPd3Sv76nB/P2lPP8xDT9ng66jKBbZl5cG7YOHjzyeR8aV5eY02cm8RiH
 Z0SnzGcUzghz2CvKBs1qBSR2HzSQk2TSXbvb9qNc9z5q0VdnUVfOSSgWXl4UAWXemG0J
 vpJwJUA0UG7rdXHgr4lFTXQIFs1jp0q6LVl1ntz1jJiy61G4+pYP9GsmrhD22FFZiPH4
 xETZJyod8UT1lXhDp7FcrUR72xyJfDikJQluQERfSjvePS/hz9aAcfbXu+Vd6WLQdZLm
 fSNA==
X-Gm-Message-State: AOAM533LpEwci+6PQfY12QMshOXFf4C808HKcotpe0t4RZyHUQlE2RFa
 nCmCte7H3mNVqODxX1kcHvVFkumcwcyD/O2UKoISDw==
X-Google-Smtp-Source: ABdhPJzIrPJFmkpkT1MmYvnvF/19vaa1rmG/3n9wA4uvNrhhiocvS0sMsPUM5NnLiqbCvThjitV3yXClYJU59u9WFNk=
X-Received: by 2002:a25:244e:: with SMTP id k75mr2749219ybk.172.1641858046407; 
 Mon, 10 Jan 2022 15:40:46 -0800 (PST)
MIME-Version: 1.0
References: <20220104194918.373612-1-rananta@google.com>
 <20220104194918.373612-4-rananta@google.com>
 <CAAeT=FxCCD+H1z8+gfyBZNeibfAUqUenZZe56Vj_3fCghJjy=Q@mail.gmail.com>
In-Reply-To: <CAAeT=FxCCD+H1z8+gfyBZNeibfAUqUenZZe56Vj_3fCghJjy=Q@mail.gmail.com>
From: Raghavendra Rao Ananta <rananta@google.com>
Date: Mon, 10 Jan 2022 15:40:35 -0800
Message-ID: <CAJHc60yY9qH5_r09Tz2fhWr+tT+i7RnKhchBuEePCKnos52kwA@mail.gmail.com>
Subject: Re: [RFC PATCH v3 03/11] KVM: Introduce KVM_CAP_ARM_HVC_FW_REG_BMAP
To: Reiji Watanabe <reijiw@google.com>
Cc: kvm@vger.kernel.org, Will Deacon <will@kernel.org>,
 Marc Zyngier <maz@kernel.org>, Peter Shier <pshier@google.com>,
 linux-kernel@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>,
 Paolo Bonzini <pbonzini@redhat.com>, kvmarm@lists.cs.columbia.edu,
 Linux ARM <linux-arm-kernel@lists.infradead.org>
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

On Fri, Jan 7, 2022 at 9:40 PM Reiji Watanabe <reijiw@google.com> wrote:
>
> Hi Raghu,
>
> On Tue, Jan 4, 2022 at 11:49 AM Raghavendra Rao Ananta
> <rananta@google.com> wrote:
> >
> > Introduce the KVM ARM64 capability, KVM_CAP_ARM_HVC_FW_REG_BMAP,
> > to indicate the support for psuedo-firmware bitmap extension.
> > Each of these registers holds a feature-set exposed to the guest
> > in the form of a bitmap. If supported, a simple 'read' of the
> > capability should return the number of psuedo-firmware registers
> > supported. User-space can utilize this to discover the registers.
> > It can further explore or modify the features using the classical
> > GET/SET_ONE_REG interface.
> >
> > Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
> > ---
> >  Documentation/virt/kvm/api.rst | 21 +++++++++++++++++++++
> >  include/uapi/linux/kvm.h       |  1 +
> >  2 files changed, 22 insertions(+)
> >
> > diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
> > index aeeb071c7688..646176537f2c 100644
> > --- a/Documentation/virt/kvm/api.rst
> > +++ b/Documentation/virt/kvm/api.rst
> > @@ -6925,6 +6925,27 @@ indicated by the fd to the VM this is called on.
> >  This is intended to support intra-host migration of VMs between userspace VMMs,
> >  upgrading the VMM process without interrupting the guest.
> >
> > +7.30 KVM_CAP_ARM_HVC_FW_REG_BMAP
>
> IMHO, instead of including its format of the register in the name,
> including its purpose/function in the name might be better.
> e.g. KVM_CAP_ARM_HVC_FEATURE_REG ?
> (Feature fields don't necessarily have to be in a bitmap format
>  if they don't fit well although I'm not sure if we have such fields.)
>
Well we do have registers, KVM_REG_ARM_PSCI_VERSION for instance,
that's not covered by this CAP. But sure, I can explicitly add
'FEATURES' to the name. I also wanted to explicitly convey that we are
covering the *bitmapped* firmware registers here. But not sure if
appending 'BMAP' might give an impression that the CAP itself is
bitmapped.
Do you think KVM_CAP_ARM_HVC_BMAP_FEAT_REG is better?

> > +
> > +:Architectures: arm64
> > +:Parameters: None
> > +:Returns: Number of psuedo-firmware registers supported
>
> Looking at patch-4, the return value of this would be the number of
> pseudo-firmware *bitmap* registers supported.
> BTW, "4.68 KVM_SET_ONE_REG" in the doc uses the word "arm64 firmware
> pseudo-registers".  It would be nicer to use the same term.
>
Nice catch. I'll fix it here in apr.rst.
> > +
> > +This capability indicates that KVM for arm64 supports the psuedo-firmware
> > +register bitmap extension. Each of these registers represent the features
> > +supported by a particular type in the form of a bitmap. By default, these
> > +registers are set with the upper limit of the features that are supported.
> > +
> > +The registers can be accessed via the standard SET_ONE_REG and KVM_GET_ONE_REG
> > +interfaces. The user-space is expected to read the number of these registers
> > +available by reading KVM_CAP_ARM_HVC_FW_REG_BMAP, read the current bitmap
> > +configuration via GET_ONE_REG for each register, and then write back the
> > +desired bitmap of features that it wishes the guest to see via SET_ONE_REG.
> > +
> > +Note that KVM doesn't allow the user-space to modify these registers after
> > +the VM (any of the vCPUs) has started running.
>
> Since even if KVM_RUN fails, and the VM hasn't started yet,
> it will get immutable. So, "after any of the vCPUs run KVM_RUN."
> might be more clear ?
>
Sure, that's probably more clear. I'll fix it.

Regards,
Raghavendra

> Thanks,
> Reiji
>
>
>
> > +
> >  8. Other capabilities.
> >  ======================
> >
> > diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> > index 1daa45268de2..209b43dbbc3c 100644
> > --- a/include/uapi/linux/kvm.h
> > +++ b/include/uapi/linux/kvm.h
> > @@ -1131,6 +1131,7 @@ struct kvm_ppc_resize_hpt {
> >  #define KVM_CAP_EXIT_ON_EMULATION_FAILURE 204
> >  #define KVM_CAP_ARM_MTE 205
> >  #define KVM_CAP_VM_MOVE_ENC_CONTEXT_FROM 206
> > +#define KVM_CAP_ARM_HVC_FW_REG_BMAP 207
> >
> >  #ifdef KVM_CAP_IRQ_ROUTING
> >
> > --
> > 2.34.1.448.ga2b2bfdf31-goog
> >
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
