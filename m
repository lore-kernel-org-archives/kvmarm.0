Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 46FEFC433EF
	for <kvmarm@archiver.kernel.org>; Thu, 24 Feb 2022 06:32:34 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BE6094BC4C;
	Thu, 24 Feb 2022 01:32:33 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id d7ky6S0mvbKy; Thu, 24 Feb 2022 01:32:32 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A29E94BCF0;
	Thu, 24 Feb 2022 01:32:32 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D60AA4BC4C
 for <kvmarm@lists.cs.columbia.edu>; Thu, 24 Feb 2022 01:32:30 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id cQZoYZp0MHjQ for <kvmarm@lists.cs.columbia.edu>;
 Thu, 24 Feb 2022 01:32:29 -0500 (EST)
Received: from mail-pf1-f169.google.com (mail-pf1-f169.google.com
 [209.85.210.169])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id AF35F4BC3D
 for <kvmarm@lists.cs.columbia.edu>; Thu, 24 Feb 2022 01:32:29 -0500 (EST)
Received: by mail-pf1-f169.google.com with SMTP id x18so1016760pfh.5
 for <kvmarm@lists.cs.columbia.edu>; Wed, 23 Feb 2022 22:32:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=sYr99btjNTWEFNut0mb3PVrtN8rcpoOwvOaTLkgqYy0=;
 b=a+LOwzF5lzDECLaXU5NlyXjxhd9hdgKj2SifQ0n7qYgDOD7cFelQDqpDYtFdD5zfbW
 IYE947PfF0pfkSvU76f+Lj+ma0++tfZikaMvkdCGFqwbzl3zkIChzoLw8rjOh42aA4tQ
 T0gnZm9RzWVb/GYbfQzvRaLVS1PtEeLX0mBeO3TNG48Uw04BvCeFi9LgPI5DXe1wLwll
 VkrUWWyruEmVPyw+nYXE2QwX4NMSjsMlyGVbntjMaxDwcUW+xOohnLnhykdvAL60+Ajp
 xVZiLmSk2QKvbbivZsZ8Ily264mJUkNZgP+NbEBz1KheVCvAD8ghONd8Fj3YDQEwyVR5
 OtQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=sYr99btjNTWEFNut0mb3PVrtN8rcpoOwvOaTLkgqYy0=;
 b=TkiEI8+NCEp2Spq4/wVCmFMJydb80B8qN2y6dTBnDaDpeVdlrZn5DV/peYNXlUPNjw
 Opkh8hnJDoqUmJ7Kpmao76BFu7PnCxuiw6ClF/bUeH+wyTRDIR+Xa7IwK7xA3fb+/8C9
 GlzJhgSvFwI+eujPqmSHFeIcoQcq7MKZKRvJApwQE4e6ft8KpHASkP0gdtohPUnzcKO0
 zUe6oAlnaQyuTf5R2tA1Gxve0dDDqYCc8xmjvtNTKULfWM0GcKZcP8HzI8mBY2JhuoNS
 H3HPXH8Y4MHK8Ro+vfjt7QwSGLbgZuOB/q8xULWxPCA7wxrUDqjuKA8fxAndTNikZFE8
 I3gQ==
X-Gm-Message-State: AOAM530JadU2x3L1moVA4Pj1bCOlsJZceYd6w82Y9LQoBLX5ojxaVBQl
 gqmDKOBE2r1nmo7pRBaOwFWLa3zdJen8mwKuD7XZvQ==
X-Google-Smtp-Source: ABdhPJxy+hQPYHL1gH+M5yt+rbHWMaKEV2iXUpDUODPI6GqUNWYbbv55cDAcFy2+qDfAFoy2YtBDJhMVr8Qy3viTVEk=
X-Received: by 2002:a63:5525:0:b0:372:c376:74f1 with SMTP id
 j37-20020a635525000000b00372c37674f1mr1158862pgb.433.1645684348485; Wed, 23
 Feb 2022 22:32:28 -0800 (PST)
MIME-Version: 1.0
References: <20220223041844.3984439-1-oupton@google.com>
 <20220223041844.3984439-3-oupton@google.com>
In-Reply-To: <20220223041844.3984439-3-oupton@google.com>
From: Reiji Watanabe <reijiw@google.com>
Date: Wed, 23 Feb 2022 22:32:12 -0800
Message-ID: <CAAeT=FyfOzk6CS2BuXcJdxhRHWj9MVZgXULrHsC344WV-kUepA@mail.gmail.com>
Subject: Re: [PATCH v3 02/19] KVM: arm64: Create a helper to check if IPA is
 valid
To: Oliver Upton <oupton@google.com>
Cc: Wanpeng Li <wanpengli@tencent.com>, kvm@vger.kernel.org,
 Marc Zyngier <maz@kernel.org>, Joerg Roedel <joro@8bytes.org>,
 Atish Patra <atishp@atishpatra.org>, Peter Shier <pshier@google.com>,
 kvm-riscv@lists.infradead.org, Paolo Bonzini <pbonzini@redhat.com>,
 Vitaly Kuznetsov <vkuznets@redhat.com>, kvmarm@lists.cs.columbia.edu,
 Jim Mattson <jmattson@google.com>
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

On Tue, Feb 22, 2022 at 8:19 PM Oliver Upton <oupton@google.com> wrote:
>
> Create a helper that tests if a given IPA fits within the guest's
> address space.
>
> Signed-off-by: Oliver Upton <oupton@google.com>
> ---
>  arch/arm64/include/asm/kvm_mmu.h      | 9 +++++++++
>  arch/arm64/kvm/vgic/vgic-kvm-device.c | 2 +-
>  2 files changed, 10 insertions(+), 1 deletion(-)
>
> diff --git a/arch/arm64/include/asm/kvm_mmu.h b/arch/arm64/include/asm/kvm_mmu.h
> index 81839e9a8a24..78e8be7ea627 100644
> --- a/arch/arm64/include/asm/kvm_mmu.h
> +++ b/arch/arm64/include/asm/kvm_mmu.h
> @@ -111,6 +111,7 @@ alternative_cb_end
>  #else
>
>  #include <linux/pgtable.h>
> +#include <linux/kvm_host.h>
>  #include <asm/pgalloc.h>
>  #include <asm/cache.h>
>  #include <asm/cacheflush.h>
> @@ -147,6 +148,14 @@ static __always_inline unsigned long __kern_hyp_va(unsigned long v)
>  #define kvm_phys_size(kvm)             (_AC(1, ULL) << kvm_phys_shift(kvm))
>  #define kvm_phys_mask(kvm)             (kvm_phys_size(kvm) - _AC(1, ULL))
>
> +/*
> + * Returns true if the provided IPA exists within the VM's IPA space.
> + */
> +static inline bool kvm_ipa_valid(struct kvm *kvm, phys_addr_t guest_ipa)
> +{
> +       return !(guest_ipa & ~kvm_phys_mask(kvm));
> +}
> +
>  #include <asm/kvm_pgtable.h>
>  #include <asm/stage2_pgtable.h>
>
> diff --git a/arch/arm64/kvm/vgic/vgic-kvm-device.c b/arch/arm64/kvm/vgic/vgic-kvm-device.c
> index c6d52a1fd9c8..e3853a75cb00 100644
> --- a/arch/arm64/kvm/vgic/vgic-kvm-device.c
> +++ b/arch/arm64/kvm/vgic/vgic-kvm-device.c
> @@ -27,7 +27,7 @@ int vgic_check_iorange(struct kvm *kvm, phys_addr_t ioaddr,
>         if (addr + size < addr)
>                 return -EINVAL;
>
> -       if (addr & ~kvm_phys_mask(kvm) || addr + size > kvm_phys_size(kvm))
> +       if (!kvm_ipa_valid(kvm, addr) || addr + size > kvm_phys_size(kvm))
>                 return -E2BIG;
>
>         return 0;

Reviewed-by: Reiji Watanabe <reijiw@google.com>

It looks like we can use the helper for kvm_handle_guest_abort()
in arch/arm64/kvm/mmu.c as well though.
----------
<...>
        /* Userspace should not be able to register out-of-bounds IPAs */
        VM_BUG_ON(fault_ipa >= kvm_phys_size(vcpu->kvm));
<...>
----------

Thanks,
Reiji
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
