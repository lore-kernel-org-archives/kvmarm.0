Return-Path: <SRS0=VGwd=LQ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 833E3C48BDF
	for <kvmarm@archiver.kernel.org>; Tue, 22 Jun 2021 10:42:34 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id E9F4B613D5
	for <kvmarm@archiver.kernel.org>; Tue, 22 Jun 2021 10:42:33 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E9F4B613D5
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 748C6402C0;
	Tue, 22 Jun 2021 06:42:33 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Yi3L8URbOziQ; Tue, 22 Jun 2021 06:42:32 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4E1C5405A6;
	Tue, 22 Jun 2021 06:42:32 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id AA805402C0
 for <kvmarm@lists.cs.columbia.edu>; Tue, 22 Jun 2021 06:42:31 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id uC1qyQHM8rV5 for <kvmarm@lists.cs.columbia.edu>;
 Tue, 22 Jun 2021 06:42:30 -0400 (EDT)
Received: from mail-oi1-f175.google.com (mail-oi1-f175.google.com
 [209.85.167.175])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 87514401A2
 for <kvmarm@lists.cs.columbia.edu>; Tue, 22 Jun 2021 06:42:30 -0400 (EDT)
Received: by mail-oi1-f175.google.com with SMTP id r16so10779018oiw.3
 for <kvmarm@lists.cs.columbia.edu>; Tue, 22 Jun 2021 03:42:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=u9LsbEZiezKhlK0VsTrDDolUHa3phfsN7g8L8H/DuWQ=;
 b=jjhUmp+J5W3igAnik5/znZuCohxssSkcipc6jHqF31KBMBLHC+wv4dvXHuuLLjW6Xl
 sQZIXvfaSiEbyr+GO3TE+9gTMq2QjZLX6JYYTA6Poie3H1O/4D+oHTxYLPv/Kh5Zc6aV
 1M7HvHGPa+iOlWcT2J2KQBgaMaYlPAnsxF4ig1psY40+5VfeEAICdl2jvcZp+ZGUJYHr
 YUdEEPbRXkZ2C8RtVh/2y4vY6pLn3y9u/eB+EiT8XNkpcwnNfPC9RXu87tY6a2m5wF2A
 GjCYDRdLDzvM8nMLcc7lV6iozGs1/CXTXChXoo3M5pfHI6CQVilIH4M+bwXo5bUqZeEg
 mZzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=u9LsbEZiezKhlK0VsTrDDolUHa3phfsN7g8L8H/DuWQ=;
 b=c8110TzJjUPtX651rVXT9x6ZBZoeJNwUuNitHIpIA4mWRX6sioX+I3SgCAcQ0AFs+/
 S6mjq9F0PSxsVI6ZXxDbq3G9suc90sYu63T+E6RX6j84pCB6hhRqBKrxJ4njbvFjGm8A
 ytVZtgTu/0fL80XCezX/QAci48VmTh7FbwzqyZsh5QdVhB3JA1Ak6UnzClDcKF724Zvv
 yFCY10NuUxy/GoovqlzNmaL32r7MdEksZtvv8ttJulYfxw4Dr7G3IdFS/QwpJDZQd/WV
 MUtjfhDc+Jdx01gRzzTSgblr1py4TnCM53ECDs1RcwlerHEawwujX0IMOODjazA7Xg25
 8gBw==
X-Gm-Message-State: AOAM5333P0K6UTWToezXrQuuvUIeK79K+CaxR1zqi/dtnVx/hRYG5FsE
 Lc/QC9AfPBuxF6/t7Q8eKIR2O7AWienmqvg3tZIvHg==
X-Google-Smtp-Source: ABdhPJz8qKFU+PeULxGcMib7uCs/Wju6IcRScAGlEI/0rntsAYUmwdpgQWNQ1ylLw9nqTDP4WojBowEwZ8vhGKrXDHs=
X-Received: by 2002:aca:b38a:: with SMTP id c132mr2598605oif.90.1624358549606; 
 Tue, 22 Jun 2021 03:42:29 -0700 (PDT)
MIME-Version: 1.0
References: <20210621111716.37157-1-steven.price@arm.com>
 <20210621111716.37157-7-steven.price@arm.com>
 <CA+EHjTwww=QFq30bi8n2t2fkfr1B_0v0KSZ75dK+ZJDUU3f5xQ@mail.gmail.com>
 <874kdqchlx.wl-maz@kernel.org>
In-Reply-To: <874kdqchlx.wl-maz@kernel.org>
From: Fuad Tabba <tabba@google.com>
Date: Tue, 22 Jun 2021 11:41:53 +0100
Message-ID: <CA+EHjTw7DqZs9j-nZJKD5QfjFJHYy_uGt8LBiWxbHfkCyBTC5g@mail.gmail.com>
Subject: Re: [PATCH v17 6/6] KVM: arm64: Document MTE capability and ioctl
To: Marc Zyngier <maz@kernel.org>
Cc: Juan Quintela <quintela@redhat.com>,
 Catalin Marinas <catalin.marinas@arm.com>,
 Richard Henderson <richard.henderson@linaro.org>, qemu-devel@nongnu.org,
 "Dr. David Alan Gilbert" <dgilbert@redhat.com>, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org, Thomas Gleixner <tglx@linutronix.de>,
 Steven Price <steven.price@arm.com>, Will Deacon <will@kernel.org>,
 Dave Martin <Dave.Martin@arm.com>, linux-kernel@vger.kernel.org
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

Hi Marc,

On Tue, Jun 22, 2021 at 11:35 AM Marc Zyngier <maz@kernel.org> wrote:
>
> On Tue, 22 Jun 2021 10:42:42 +0100,
> Fuad Tabba <tabba@google.com> wrote:
> >
> > Hi,
> >
> >
> > On Mon, Jun 21, 2021 at 12:18 PM Steven Price <steven.price@arm.com> wrote:
> > >
> > > A new capability (KVM_CAP_ARM_MTE) identifies that the kernel supports
> > > granting a guest access to the tags, and provides a mechanism for the
> > > VMM to enable it.
> > >
> > > A new ioctl (KVM_ARM_MTE_COPY_TAGS) provides a simple way for a VMM to
> > > access the tags of a guest without having to maintain a PROT_MTE mapping
> > > in userspace. The above capability gates access to the ioctl.
> > >
> > > Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
> > > Signed-off-by: Steven Price <steven.price@arm.com>
> > > ---
> > >  Documentation/virt/kvm/api.rst | 61 ++++++++++++++++++++++++++++++++++
> > >  1 file changed, 61 insertions(+)
> > >
> > > diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
> > > index 7fcb2fd38f42..97661a97943f 100644
> > > --- a/Documentation/virt/kvm/api.rst
> > > +++ b/Documentation/virt/kvm/api.rst
> > > @@ -5034,6 +5034,43 @@ see KVM_XEN_VCPU_SET_ATTR above.
> > >  The KVM_XEN_VCPU_ATTR_TYPE_RUNSTATE_ADJUST type may not be used
> > >  with the KVM_XEN_VCPU_GET_ATTR ioctl.
> > >
> > > +4.130 KVM_ARM_MTE_COPY_TAGS
> > > +---------------------------
> > > +
> > > +:Capability: KVM_CAP_ARM_MTE
> > > +:Architectures: arm64
> > > +:Type: vm ioctl
> > > +:Parameters: struct kvm_arm_copy_mte_tags
> > > +:Returns: number of bytes copied, < 0 on error (-EINVAL for incorrect
> > > +          arguments, -EFAULT if memory cannot be accessed).
> > > +
> > > +::
> > > +
> > > +  struct kvm_arm_copy_mte_tags {
> > > +       __u64 guest_ipa;
> > > +       __u64 length;
> > > +       void __user *addr;
> > > +       __u64 flags;
> > > +       __u64 reserved[2];
> > > +  };
> > > +
> > > +Copies Memory Tagging Extension (MTE) tags to/from guest tag memory. The
> > > +``guest_ipa`` and ``length`` fields must be ``PAGE_SIZE`` aligned. The ``addr``
> > > +field must point to a buffer which the tags will be copied to or from.
> > > +
> > > +``flags`` specifies the direction of copy, either ``KVM_ARM_TAGS_TO_GUEST`` or
> > > +``KVM_ARM_TAGS_FROM_GUEST``.
> > > +
> > > +The size of the buffer to store the tags is ``(length / 16)`` bytes
> > > +(granules in MTE are 16 bytes long). Each byte contains a single tag
> > > +value. This matches the format of ``PTRACE_PEEKMTETAGS`` and
> > > +``PTRACE_POKEMTETAGS``.
> > > +
> > > +If an error occurs before any data is copied then a negative error code is
> > > +returned. If some tags have been copied before an error occurs then the number
> > > +of bytes successfully copied is returned. If the call completes successfully
> > > +then ``length`` is returned.
> > > +
> > >  5. The kvm_run structure
> > >  ========================
> > >
> > > @@ -6362,6 +6399,30 @@ default.
> > >
> > >  See Documentation/x86/sgx/2.Kernel-internals.rst for more details.
> > >
> > > +7.26 KVM_CAP_ARM_MTE
> > > +--------------------
> > > +
> > > +:Architectures: arm64
> > > +:Parameters: none
> > > +
> > > +This capability indicates that KVM (and the hardware) supports exposing the
> > > +Memory Tagging Extensions (MTE) to the guest. It must also be enabled by the
> > > +VMM before creating any VCPUs to allow the guest access. Note that MTE is only
> > > +available to a guest running in AArch64 mode and enabling this capability will
> > > +cause attempts to create AArch32 VCPUs to fail.
> >
> > I was wondering if there might be an issue with AArch32 at EL0 and
> > MTE, because I think that even if AArch64 at EL1 is disallowed, the
>
> Did you mean AArch32 here?

Yes.

> > guest can still run AArch32 at EL0.
>
> I don't get your question:
>
> - If the guest is AArch32 at EL1, there is not MTE whatsoever (where
>   would you place the tag?)
>
> - If the guest is AArch64, it can have MTE enabled or not,
>   irrespective of the EL. If this guest decides to run an AArch32 EL0,
>   the architecture rules still apply, and it cannot expose MTE to its
>   own 32bit userspace. Nothing that KVM needs to do about this.
>
> What KVM enforces is that at the point where the guest is in charge,
> we have a consistent architectural behaviour.

This answers my question. I was wondering whether we should be
concerned with the case where the guest decides to run an AArch32 EL0.

Thanks,
/fuad

>
> Thanks,
>
>         M.
>
> --
> Without deviation from the norm, progress is not possible.
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
