Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F2FBAC433EF
	for <kvmarm@archiver.kernel.org>; Thu,  9 Jun 2022 12:03:09 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 571314B225;
	Thu,  9 Jun 2022 08:03:09 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id TX1-x8B+8MWb; Thu,  9 Jun 2022 08:03:06 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 18D7C4B280;
	Thu,  9 Jun 2022 08:03:06 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 60EF94B20A
 for <kvmarm@lists.cs.columbia.edu>; Wed,  8 Jun 2022 13:39:30 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id PO2N83nsfsI0 for <kvmarm@lists.cs.columbia.edu>;
 Wed,  8 Jun 2022 13:39:29 -0400 (EDT)
Received: from mail-vs1-f43.google.com (mail-vs1-f43.google.com
 [209.85.217.43])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 5F9124B1EC
 for <kvmarm@lists.cs.columbia.edu>; Wed,  8 Jun 2022 13:39:29 -0400 (EDT)
Received: by mail-vs1-f43.google.com with SMTP id g6so2050563vsb.2
 for <kvmarm@lists.cs.columbia.edu>; Wed, 08 Jun 2022 10:39:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=YMlVWKWFWg+nhbnd5V57+qJ+IXhci7VV/Jgt/zHgEZ0=;
 b=j3J+tWdGuDnMmzW4G3/e2Yrhr9b9g3Ixir6vg/ocyLbpDgCQnabw633VQz6gVt/Clq
 d6sT+N9Jhqbyc//8NN1Kpz7bE3GnUXthlUddzx6GVNOqAYWs2ys7dH/k52qs6ZR9Rh5N
 wYh0MQPu0tIzB1L3mrF28BVdB1JDjrnssIasa6WvL8hA5ICtUnV+hPkeFOZxF2clN1+g
 xoCjHxrkFFsG5YEHV6qSO9Jky2BqWQKskCRD1Smx6E2RuSggMQBft86f5VfN3oUdvNl+
 dA6IFRBsAkMqdTgjgyDDOAfcNA1oKJk5Gdjt1TQV9Gd5xf/yl6adfEct3gEyArl7EvAU
 PArg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=YMlVWKWFWg+nhbnd5V57+qJ+IXhci7VV/Jgt/zHgEZ0=;
 b=pleTF+KMSax7AzlqXjBgaB2+kdimEVQUeRjfiXjqBzSwQxZn1kHYB9io4mWojGnEdf
 BFrg9SQdRM/mWHkrJIwciF7a4D9pg3c6iOBWgicI0xRrusp+2mvQl/KRssmBRKl9U0lX
 nvRtQJND88tFjFxatgJzuE59gQjCaGmbGFqWLPFghk5ZCqUfuTjQ7zHwFuh7/e8Jxa92
 ukp36M/oycZD7S34B7ElcU6kSUdIWzCyhJ75Bt0ntt7APxBQNe479xTW1Yk9odseL7/S
 HinXYvsPjlGMoUm5y5lcS64Ekw5h4+zxWKAmFFIGPft+7RA6QyD7uPRSMI/tJXROICzC
 J7Kw==
X-Gm-Message-State: AOAM533TumWRG2WJ/QfyRNwCBnoBVlhZW4OaGf0tXw3i/pS81UjyXmMj
 C9pir53m6MZrVxYYtL2QNvJXV24+ytBHQQHFGaLUVw==
X-Google-Smtp-Source: ABdhPJwIIsHt0xzWM00HLFl0l6aL+x8xCN7jsifDlcALw0DFomqzVq6S0bhgX6CLu/L4ldhqPBDIwXZNDYBF05IHKrM=
X-Received: by 2002:a67:d30d:0:b0:34a:8d6c:1be6 with SMTP id
 a13-20020a67d30d000000b0034a8d6c1be6mr14582002vsj.74.1654709968634; Wed, 08
 Jun 2022 10:39:28 -0700 (PDT)
MIME-Version: 1.0
References: <20220519134204.5379-1-will@kernel.org>
 <20220519134204.5379-60-will@kernel.org>
 <CAMn1gO7Gs8YUEv9Gx8qakedGNwFVgt9i+X+rjw50uc7YGMhpEQ@mail.gmail.com>
 <CA+EHjTxa8mhiEykjTTgB0J6aFpRqDiRzLKOWOd3hFsSrL+d=5g@mail.gmail.com>
In-Reply-To: <CA+EHjTxa8mhiEykjTTgB0J6aFpRqDiRzLKOWOd3hFsSrL+d=5g@mail.gmail.com>
From: Peter Collingbourne <pcc@google.com>
Date: Wed, 8 Jun 2022 10:39:14 -0700
Message-ID: <CAMn1gO5gDiL=HE6H2AhxM2hQZ9fnJCAi8n+1NF7bhZDnS+jOyg@mail.gmail.com>
Subject: Re: [PATCH 59/89] KVM: arm64: Do not support MTE for protected VMs
To: Fuad Tabba <tabba@google.com>
X-Mailman-Approved-At: Thu, 09 Jun 2022 08:03:05 -0400
Cc: Marc Zyngier <maz@kernel.org>, kernel-team@android.com, kvm@vger.kernel.org,
 Andy Lutomirski <luto@amacapital.net>, Michael Roth <michael.roth@amd.com>,
 Catalin Marinas <catalin.marinas@arm.com>,
 Chao Peng <chao.p.peng@linux.intel.com>, Will Deacon <will@kernel.org>,
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

On Wed, Jun 8, 2022 at 12:40 AM Fuad Tabba <tabba@google.com> wrote:
>
> Hi Peter,
>
> On Tue, Jun 7, 2022 at 1:42 AM Peter Collingbourne <pcc@google.com> wrote:
> >
> > On Thu, May 19, 2022 at 7:40 AM Will Deacon <will@kernel.org> wrote:
> > >
> > > From: Fuad Tabba <tabba@google.com>
> > >
> > > Return an error (-EINVAL) if trying to enable MTE on a protected
> > > vm.
> > >
> > > Signed-off-by: Fuad Tabba <tabba@google.com>
> > > ---
> > >  arch/arm64/kvm/arm.c | 4 +++-
> > >  1 file changed, 3 insertions(+), 1 deletion(-)
> > >
> > > diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> > > index 10e036bf06e3..8a1b4ba1dfa7 100644
> > > --- a/arch/arm64/kvm/arm.c
> > > +++ b/arch/arm64/kvm/arm.c
> > > @@ -90,7 +90,9 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
> > >                 break;
> > >         case KVM_CAP_ARM_MTE:
> > >                 mutex_lock(&kvm->lock);
> > > -               if (!system_supports_mte() || kvm->created_vcpus) {
> > > +               if (!system_supports_mte() ||
> > > +                   kvm_vm_is_protected(kvm) ||
> >
> > Should this check be added to kvm_vm_ioctl_check_extension() as well?
>
> No need. kvm_vm_ioctl_check_extension() calls pkvm_check_extension()
> for protected vms, which functions as an allow list rather than a
> block list.

I see. I guess I got confused when reading the code because I saw this
in kvm_check_extension():

        case KVM_CAP_ARM_NISV_TO_USER:
                r = !kvm || !kvm_vm_is_protected(kvm);
                break;

This can probably be simplified to "r = 1;".

Peter
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
