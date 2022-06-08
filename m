Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 24231C43334
	for <kvmarm@archiver.kernel.org>; Wed,  8 Jun 2022 07:40:54 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 90FBF49EB2;
	Wed,  8 Jun 2022 03:40:54 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id xLrbB6rEUz28; Wed,  8 Jun 2022 03:40:53 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 659E44B093;
	Wed,  8 Jun 2022 03:40:53 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7475449ED9
 for <kvmarm@lists.cs.columbia.edu>; Wed,  8 Jun 2022 03:40:52 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id v1axuh9JTd8h for <kvmarm@lists.cs.columbia.edu>;
 Wed,  8 Jun 2022 03:40:51 -0400 (EDT)
Received: from mail-oa1-f53.google.com (mail-oa1-f53.google.com
 [209.85.160.53])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 7ACDE49EB2
 for <kvmarm@lists.cs.columbia.edu>; Wed,  8 Jun 2022 03:40:51 -0400 (EDT)
Received: by mail-oa1-f53.google.com with SMTP id
 586e51a60fabf-f2cbceefb8so26186461fac.11
 for <kvmarm@lists.cs.columbia.edu>; Wed, 08 Jun 2022 00:40:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=4C+HR3kdGNMQU0VniOy6D2TLr5OZWg8RJ6oE98/dwoc=;
 b=lniF6SLwf2sUXG4L0oxq7Wvjkomm8JSVVcdy9UzJDPuqG9mEJpDr1yJXXD8UEn8ubM
 DP7YyQB0975e/YbQSSGUijeh7xrN31/yqUtCCrcEaxk6ysdAfEnEG42VefCFXo/ua0BH
 CjN+8JiKVCb0pxnVxMjrz4HvhAu28Lujp3EqMXIp+bS6ugnqNVvRhLBpwUrL4M4P4od0
 mow1rtEcXV2IdS5nu9EyuXgjt7u/n2/BqItaCrd9FbYugktvOlRupZv7BJw7MHAv02aS
 dfsm6fuod9FPKaaXXLOjjoPcHvKi1Pft/nRpXH2+T0MqaqVEoMMoHdcT9vSNZn3+FX4D
 SvGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=4C+HR3kdGNMQU0VniOy6D2TLr5OZWg8RJ6oE98/dwoc=;
 b=1ZPSo6BL5Y8JPdOgmUHIP2oO/ipHR1Nc5nSIgCbtwaPTlmtswi14TzaRjsbF9xreOr
 eqRc5BDyQF6il+c3Er+YcgjYrMUGkeHxSLHMpuYvSrQ54kbBlxrVEU30F3ztJGjINXPl
 wD3Y/k0hJzCamwiq7SA28VXZ2/GtHR+iBfUxxP/NA5qMY5x1ziLJ/DunSlEC4iMuH1rY
 EvfKhVKK/zdmAdU8wiL2ppJIrgY0dE92NcmxV4RB2J4SPsdcRUq/fP3rvHr6pv8nq9sl
 udNmb/6aHf1p1S+dzcQRlngWR+AHIXy9CaXpp8lf8jCev8yntmilFNNULLTfx3Z2tmhh
 Rb2w==
X-Gm-Message-State: AOAM533CTCi46O6zXLGu3CyR6rmOBTTOimcZLQP/sICaC0yhP/Ov5IY2
 SLH+ulgEycMXRnKFJ8Z8Ejs1lOUHELDBuYdz3xsVJA==
X-Google-Smtp-Source: ABdhPJxJU2tr9O9BGDzNE7cjJh/nBawaDlGq2ZFiX9T3Jx1K4j1sILs6YF386g05D+iAgS/6fcxJ3SXP4KDchr+cHKE=
X-Received: by 2002:a05:6870:961b:b0:e2:ffb9:f526 with SMTP id
 d27-20020a056870961b00b000e2ffb9f526mr1662882oaq.146.1654674050672; Wed, 08
 Jun 2022 00:40:50 -0700 (PDT)
MIME-Version: 1.0
References: <20220519134204.5379-1-will@kernel.org>
 <20220519134204.5379-60-will@kernel.org>
 <CAMn1gO7Gs8YUEv9Gx8qakedGNwFVgt9i+X+rjw50uc7YGMhpEQ@mail.gmail.com>
In-Reply-To: <CAMn1gO7Gs8YUEv9Gx8qakedGNwFVgt9i+X+rjw50uc7YGMhpEQ@mail.gmail.com>
From: Fuad Tabba <tabba@google.com>
Date: Wed, 8 Jun 2022 08:40:14 +0100
Message-ID: <CA+EHjTxa8mhiEykjTTgB0J6aFpRqDiRzLKOWOd3hFsSrL+d=5g@mail.gmail.com>
Subject: Re: [PATCH 59/89] KVM: arm64: Do not support MTE for protected VMs
To: Peter Collingbourne <pcc@google.com>
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

Hi Peter,

On Tue, Jun 7, 2022 at 1:42 AM Peter Collingbourne <pcc@google.com> wrote:
>
> On Thu, May 19, 2022 at 7:40 AM Will Deacon <will@kernel.org> wrote:
> >
> > From: Fuad Tabba <tabba@google.com>
> >
> > Return an error (-EINVAL) if trying to enable MTE on a protected
> > vm.
> >
> > Signed-off-by: Fuad Tabba <tabba@google.com>
> > ---
> >  arch/arm64/kvm/arm.c | 4 +++-
> >  1 file changed, 3 insertions(+), 1 deletion(-)
> >
> > diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> > index 10e036bf06e3..8a1b4ba1dfa7 100644
> > --- a/arch/arm64/kvm/arm.c
> > +++ b/arch/arm64/kvm/arm.c
> > @@ -90,7 +90,9 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
> >                 break;
> >         case KVM_CAP_ARM_MTE:
> >                 mutex_lock(&kvm->lock);
> > -               if (!system_supports_mte() || kvm->created_vcpus) {
> > +               if (!system_supports_mte() ||
> > +                   kvm_vm_is_protected(kvm) ||
>
> Should this check be added to kvm_vm_ioctl_check_extension() as well?

No need. kvm_vm_ioctl_check_extension() calls pkvm_check_extension()
for protected vms, which functions as an allow list rather than a
block list.

Cheers,
/fuad


> Peter
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
