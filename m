Return-Path: <SRS0=1TKy=LD=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A133C48BCF
	for <kvmarm@archiver.kernel.org>; Wed,  9 Jun 2021 15:23:38 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id B7FC861042
	for <kvmarm@archiver.kernel.org>; Wed,  9 Jun 2021 15:23:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B7FC861042
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 427E04079A;
	Wed,  9 Jun 2021 11:23:37 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 9LtXWeUsoQ28; Wed,  9 Jun 2021 11:23:36 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2194B407B0;
	Wed,  9 Jun 2021 11:23:36 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BBEE1407EF
 for <kvmarm@lists.cs.columbia.edu>; Wed,  9 Jun 2021 11:23:34 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id HD2q9E0Bs7R9 for <kvmarm@lists.cs.columbia.edu>;
 Wed,  9 Jun 2021 11:23:33 -0400 (EDT)
Received: from mail-ot1-f54.google.com (mail-ot1-f54.google.com
 [209.85.210.54])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 7D1B7407B0
 for <kvmarm@lists.cs.columbia.edu>; Wed,  9 Jun 2021 11:23:33 -0400 (EDT)
Received: by mail-ot1-f54.google.com with SMTP id
 66-20020a9d02c80000b02903615edf7c1aso24234622otl.13
 for <kvmarm@lists.cs.columbia.edu>; Wed, 09 Jun 2021 08:23:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=EJisOkRU2LFWrcDGE1haBYgrxVOy2iOBRr5zUUIQhb0=;
 b=svt+D/9IKeiSzXsNpeGHltXWwDsQL5BTkIoQnOwbHViP9DxgVWEe/HN93hrclIxQ3d
 kbwFBFd8jnKGMbtPLUUQvwbqr5Ic41K1zNP/tV0f0tSmt2sx8FzVP8CP44FfzOgHRe+p
 iHfhcdKgnCRURW49kWRFjeJx8N6Ns58ewEq38WmRUsYGm+rIh43E6LfJmaPk5E2bJK7P
 0J7n6Fl75BwuA3E1O0S3WuuWPzQZyKSWCGOpYzNZJEL0MFiQt4dHuNNx1z72et3Om7VU
 6eHMdlCsZ/ykxU+EM0tNKM6SMK5bifBeGa8so/FlVS+YoP7htaWfqvswwXEOLwF3QCn6
 /z8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=EJisOkRU2LFWrcDGE1haBYgrxVOy2iOBRr5zUUIQhb0=;
 b=JfX/8YEt0QMyiqR6joVz6vYtZUZuHZMLs+OV0xMRoqYSGBaeDWOxo8MZK4VErQRuny
 CR/iQEFWCNx6fyZU6pG6tZrraFCP9lmq0WQyBixDJ10yu7pR3uGwpdnp9879voyUCvFf
 ryx0iXsTf7DbrGqxuyObckPibSL74BpfoagtCOoTD/UCjCjRHU7GoDRicOli6MxP0Yto
 8pGA7XHiBhpYNLkno29UW5d0NV12yyZ31XMGb2d6q7TLlt/W/BGfAzXIr/VtrdoEEUPS
 IVxxax2O+3gW3GL0/P/cWxLR/YKGxw6zG/IeVQhPoQbfef1XPduu07d3ZGernzgcGLyy
 Ua4Q==
X-Gm-Message-State: AOAM532s6jjEWTdaofGMaFr36e5eYpPuGsbWm6cqWVEMvFU7buxqkvql
 s1w3IPNKkIhN2NTwZsyFpuZKUNtF/VFskqgzawdYLQ==
X-Google-Smtp-Source: ABdhPJxgVOCheyyILFqjegp7GUGRVogeiAUh2ROYM1Kb0N9a0fAtjrEf0c+Uw4+MPgaFmlX1GbnGk4jA3mXmYKDxKvk=
X-Received: by 2002:a05:6830:1002:: with SMTP id
 a2mr12893470otp.144.1623252212597; 
 Wed, 09 Jun 2021 08:23:32 -0700 (PDT)
MIME-Version: 1.0
References: <20210608141141.997398-1-tabba@google.com>
 <20210608150739.7ztstw52ynxh6m5p@gator>
In-Reply-To: <20210608150739.7ztstw52ynxh6m5p@gator>
From: Fuad Tabba <tabba@google.com>
Date: Wed, 9 Jun 2021 16:22:55 +0100
Message-ID: <CA+EHjTxuzSVVk-U20wpw5-JjhyXOFN1sCRv3AhAsd9yNeM8cEg@mail.gmail.com>
Subject: Re: [PATCH v1 00/13] KVM: arm64: Fixed features for protected VMs
To: Andrew Jones <drjones@redhat.com>
Cc: kernel-team@android.com, kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
 pbonzini@redhat.com, Will Deacon <will@kernel.org>,
 "open list:KERNEL VIRTUAL MACHINE FOR ARM64 \(KVM/arm64\)"
 <kvmarm@lists.cs.columbia.edu>,
 "moderated list:ARM64 PORT \(AARCH64 ARCHITECTURE\)"
 <linux-arm-kernel@lists.infradead.org>
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

> I see this series takes the approach we currently have in KVM of masking
> features we don't want to expose to the guest. This approach adds yet
> another "reject list" to be maintained as hardware evolves. I'd rather see
> that we first change KVM to using an accept list, i.e. mask everything and
> then only set what we want to enable. Mimicking that new accept list in
> pKVM, where much less would be enabled, would reduce the amount of
> maintenance needed.

Good point. I agree that having an allow list is preferable to having
a block list. The way this patch series handles system register
accesses is actually an allow list. However, as it is now, features
being exposed to protected guests via the feature registers take the
block list approach. I will fix that to ensure that instead it exposes
a list of allowed features, rather than hiding restricted ones. As you
suggest, this would reduce the amount of maintenance as hardware
evolves and is better for security as well.

As for changing KVM first, I think that that's orthogonal to what this
series is trying to accomplish. Features in pKVM are not controlled or
negotiable by userspace, as it is a fixed virtual platform. When KVM
changes to use allow lists instead, it shouldn't conflict with how
this series works, especially if I fix it to use an allow list
instead.

Thanks for your feedback.

Cheers,
/fuad


> Thanks,
> drew
>
> >
> > This series is based on kvmarm/next and Will's patches for an Initial pKVM user
> > ABI [1]. You can find the applied series here [2].
> >
> > Cheers,
> > /fuad
> >
> > [1] https://lore.kernel.org/kvmarm/20210603183347.1695-1-will@kernel.org/
> >
> > For more details about pKVM, please refer to Will's talk at KVM Forum 2020:
> > https://www.youtube.com/watch?v=edqJSzsDRxk
> >
> > [2] https://android-kvm.googlesource.com/linux/+/refs/heads/tabba/el2_fixed_feature_v1
> >
> > To: kvmarm@lists.cs.columbia.edu
> > Cc: Marc Zyngier <maz@kernel.org>
> > Cc: Will Deacon <will@kernel.org>
> > Cc: James Morse <james.morse@arm.com>
> > Cc: Alexandru Elisei <alexandru.elisei@arm.com>
> > Cc: Suzuki K Poulose <suzuki.poulose@arm.com>
> > Cc: Mark Rutland <mark.rutland@arm.com>
> > Cc: Christoffer Dall <christoffer.dall@arm.com>
> > Cc: Paolo Bonzini <pbonzini@redhat.com>
> > Cc: Quentin Perret <qperret@google.com>
> > Cc: kvm@vger.kernel.org
> > Cc: linux-arm-kernel@lists.infradead.org
> > Cc: kernel-team@android.com
> >
> > Fuad Tabba (13):
> >   KVM: arm64: Remove trailing whitespace in comments
> >   KVM: arm64: MDCR_EL2 is a 64-bit register
> >   KVM: arm64: Fix name of HCR_TACR to match the spec
> >   KVM: arm64: Refactor sys_regs.h,c for nVHE reuse
> >   KVM: arm64: Restore mdcr_el2 from vcpu
> >   KVM: arm64: Add feature register flag definitions
> >   KVM: arm64: Add config register bit definitions
> >   KVM: arm64: Guest exit handlers for nVHE hyp
> >   KVM: arm64: Add trap handlers for protected VMs
> >   KVM: arm64: Move sanitized copies of CPU features
> >   KVM: arm64: Trap access to pVM restricted features
> >   KVM: arm64: Handle protected guests at 32 bits
> >   KVM: arm64: Check vcpu features at pVM creation
> >
> >  arch/arm64/include/asm/kvm_arm.h        |  34 +-
> >  arch/arm64/include/asm/kvm_asm.h        |   2 +-
> >  arch/arm64/include/asm/kvm_host.h       |   2 +-
> >  arch/arm64/include/asm/kvm_hyp.h        |   4 +
> >  arch/arm64/include/asm/sysreg.h         |   6 +
> >  arch/arm64/kvm/arm.c                    |   4 +
> >  arch/arm64/kvm/debug.c                  |   5 +-
> >  arch/arm64/kvm/hyp/include/hyp/switch.h |  42 ++
> >  arch/arm64/kvm/hyp/nvhe/Makefile        |   2 +-
> >  arch/arm64/kvm/hyp/nvhe/debug-sr.c      |   2 +-
> >  arch/arm64/kvm/hyp/nvhe/mem_protect.c   |   6 -
> >  arch/arm64/kvm/hyp/nvhe/switch.c        | 114 +++++-
> >  arch/arm64/kvm/hyp/nvhe/sys_regs.c      | 501 ++++++++++++++++++++++++
> >  arch/arm64/kvm/hyp/vhe/debug-sr.c       |   2 +-
> >  arch/arm64/kvm/pkvm.c                   |  31 ++
> >  arch/arm64/kvm/sys_regs.c               |  62 +--
> >  arch/arm64/kvm/sys_regs.h               |  35 ++
> >  17 files changed, 782 insertions(+), 72 deletions(-)
> >  create mode 100644 arch/arm64/kvm/hyp/nvhe/sys_regs.c
> >
> >
> > base-commit: 35b256a5eebe3ac715b4ea6234aa4236a10d1a88
> > --
> > 2.32.0.rc1.229.g3e70b5a671-goog
> >
> > _______________________________________________
> > kvmarm mailing list
> > kvmarm@lists.cs.columbia.edu
> > https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
> >
>
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
