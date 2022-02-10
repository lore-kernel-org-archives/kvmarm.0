Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9759EC433EF
	for <kvmarm@archiver.kernel.org>; Thu, 10 Feb 2022 05:32:11 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 07EAD49F22;
	Thu, 10 Feb 2022 00:32:11 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id WGkl78SZgPxk; Thu, 10 Feb 2022 00:32:09 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 39C4249F0E;
	Thu, 10 Feb 2022 00:32:09 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 576CD49EF6
 for <kvmarm@lists.cs.columbia.edu>; Thu, 10 Feb 2022 00:32:08 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id d2e8F4R9-8kO for <kvmarm@lists.cs.columbia.edu>;
 Thu, 10 Feb 2022 00:32:06 -0500 (EST)
Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com
 [209.85.210.173])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id C79B249ED8
 for <kvmarm@lists.cs.columbia.edu>; Thu, 10 Feb 2022 00:32:06 -0500 (EST)
Received: by mail-pf1-f173.google.com with SMTP id i186so8392072pfe.0
 for <kvmarm@lists.cs.columbia.edu>; Wed, 09 Feb 2022 21:32:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=dZU6aXT6WOCOFQgPGsHOstXdVDds/C1lctEDu/mBT3w=;
 b=h3mRlMtBGU5u0GoeO7EcpZ/06kyk/u4OLHB5BYOgTLh8a/TFlrf5DX/Ck9MvNq6jPW
 7Hp450MRg3aNwkbQ/p0L2zaAYcpLTRIfeCtTH9FXEhF5bM9yp1LWTHD72PeKBeApIj5J
 skuUef7Ts/UDtAZgvwGJ/5rloPeAVBuIVXqOnOgPLaPOiFNTQYxXJJ0Y8AyVE4UuPIyE
 ob66wKHEuGxx4YC1Eut0ybfs4vDKxKYShO8euaicMgtygNpugtRxfIn4UnTl/F16a8Ux
 dFjYjt+VlQV4qKBwPOs157mOLAXYB1VHx3Y+Hwb4LKGGscqw1KfUkOIp7xOlwPCbgc4D
 Jhwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=dZU6aXT6WOCOFQgPGsHOstXdVDds/C1lctEDu/mBT3w=;
 b=71GwvVgslXdOZMhG81/vD70ToDrSP8Aw+4zYnAr0Pz7YApP9psXaC/6OuTXQxI+12O
 B5YzJNoNTzTKzb2rZciIH9mgzUIkzxxEP1WNImmGzpCjPGwCrrjl1ukOky9L97iRT7Ny
 ydUeWN/uA+c2PmEMISVPo8BzWZ/BxSz3m/aClDJwTW7nJEBKQCG/FkrIcRSgSG5cyPT8
 PPBVulBoCJffylxcmaELP+uTnAXyBHEF8MObMh/KUjkca4nv98DNmbDgGUoFag2ED7Lf
 wlZeTqYNIv61AzPLejuketxmQewZOUINpl5roNls5968ZhgL+HFS7RXIc4RgekjlA+HP
 WfPw==
X-Gm-Message-State: AOAM5320qOU6/MgXKZGkFWpMFNyo2gSHS0BxGt9der531dsMXDPSS7f5
 ZzRu/RX+1bA4oDqiQfBfQJ8nkIQ1Nejla4q6U1Hcgw==
X-Google-Smtp-Source: ABdhPJyNKBSpkqzfE+GzX+y0f2tzGqnCaxEZw7x45ANtyzSNuRAMJN0rP7ubqIwc9bc8pEuUOGyhEgg/IDb/eyb/JDI=
X-Received: by 2002:a62:17cd:: with SMTP id 196mr5950083pfx.39.1644471125318; 
 Wed, 09 Feb 2022 21:32:05 -0800 (PST)
MIME-Version: 1.0
References: <20220118041923.3384602-1-reijiw@google.com>
 <87a6f15skj.wl-maz@kernel.org>
 <CAAeT=FwjcgTM0hKSERfVMYDvYWqdC+Deqd=x2xT=-Zymb6SLtA@mail.gmail.com>
 <875ypo5jqi.wl-maz@kernel.org>
In-Reply-To: <875ypo5jqi.wl-maz@kernel.org>
From: Reiji Watanabe <reijiw@google.com>
Date: Wed, 9 Feb 2022 21:31:49 -0800
Message-ID: <CAAeT=FwF=agQH-2u0fzGL4eUzz5-=6M=zwXiaxyucPf+n_ihxQ@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] KVM: arm64: mixed-width check should be skipped
 for uninitialized vCPUs
To: Marc Zyngier <maz@kernel.org>
Cc: kvm@vger.kernel.org, Will Deacon <will@kernel.org>,
 Peter Shier <pshier@google.com>, Paolo Bonzini <pbonzini@redhat.com>,
 kvmarm@lists.cs.columbia.edu, Linux ARM <linux-arm-kernel@lists.infradead.org>
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

On Wed, Feb 9, 2022 at 4:04 AM Marc Zyngier <maz@kernel.org> wrote:
>
> Hi Reiji,
>
> On Wed, 09 Feb 2022 05:32:36 +0000,
> Reiji Watanabe <reijiw@google.com> wrote:
> >
> > Hi Marc,
> >
> > On Tue, Feb 8, 2022 at 6:41 AM Marc Zyngier <maz@kernel.org> wrote:
> > >
> > > In [1], I suggested another approach that didn't require extra state,
> > > and moved the existing checks under the kvm lock. What was wrong with
> > > that approach?
> >
> > With that approach, even for a vcpu that has a broken set of features,
> > which leads kvm_reset_vcpu() to fail for the vcpu, the vcpu->arch.features
> > are checked by other vCPUs' vcpu_allowed_register_width() until the
> > vcpu->arch.target is set to -1.
> > Due to this, I would think some or possibly all vCPUs' kvm_reset_vcpu()
> > may or may not fail (e.g. if userspace tries to configure vCPU#0 with
> > 32bit EL1, and vCPU#1 and #2 with 64 bit EL1, KVM_ARM_VCPU_INIT
> > for either vCPU#0, or both vCPU#1 and #2 should fail.  But, with that
> > approach, it doesn't always work that way.  Instead, KVM_ARM_VCPU_INIT
> > for all vCPUs could fail or KVM_ARM_VCPU_INIT for vCPU#0 and #1 could
> > fail while the one for CPU#2 works).
> > Also, even after the first KVM_RUN for vCPUs are already done,
> > (the first) KVM_ARM_VCPU_INIT for another vCPU could cause the
> > kvm_reset_vcpu() for those vCPUs to fail.
> >
> > I would think those behaviors are odd, and I wanted to avoid them.
>
> OK, fair enough. But then you need to remove most of the uses of
> KVM_ARM_VCPU_EL1_32BIT so that it is only used as a userspace
> interface and

Yes, I will.

> maybe not carried as part of the vcpu feature flag anymore.

At the first call of kvm_reset_vcpu() for the guest, the new kvm
flag is not set yet. So, KVM_ARM_VCPU_EL1_32BIT will be needed
by the function (unless we pass the flag as an argument for the
function or by any other way).

> Also, we really should turn all these various bits in the kvm struct
> into a set of flags. I have a patch posted there[1] for this, feel
> free to pick it up.

Thank you for the suggestion. But, kvm->arch.el1_reg_width is not
a binary because it needs to indicate an uninitialized state.  So, it
won't fit perfectly with kvm->arch.flags, which is introduced by [1]
as it is. Of course it's feasible by using 2 bits of the flags though...

Thanks,
Reiji

>
> Thanks,
>
>         M.
>
> [1] https://lore.kernel.org/r/20211004174849.2831548-2-maz@kernel.org
>
> --
> Without deviation from the norm, progress is not possible.
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
