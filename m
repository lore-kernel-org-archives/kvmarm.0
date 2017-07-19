From: Jintack Lim <jintack@cs.columbia.edu>
Subject: Re: [RFC PATCH v2 37/38] KVM: arm64: Respect the virtual HCR_EL2.NV1
 bit setting
Date: Tue, 18 Jul 2017 22:24:37 -0400
Message-ID: <CAHyh4xhj0tqMMFz8N1Xrx9Z=Ltwh4DKB_ARnsSfc=iP7=R9grQ@mail.gmail.com>
References: <1500397144-16232-1-git-send-email-jintack.lim@linaro.org>
 <1500397144-16232-38-git-send-email-jintack.lim@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0116340FB0
 for <kvmarm@lists.cs.columbia.edu>; Tue, 18 Jul 2017 22:23:53 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 8oBdEkWwNHgf for <kvmarm@lists.cs.columbia.edu>;
 Tue, 18 Jul 2017 22:23:52 -0400 (EDT)
Received: from outprodmail02.cc.columbia.edu (outprodmail02.cc.columbia.edu
 [128.59.72.51])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id E79F740FAE
 for <kvmarm@lists.cs.columbia.edu>; Tue, 18 Jul 2017 22:23:51 -0400 (EDT)
Received: from hazelnut (hazelnut.cc.columbia.edu [128.59.213.250])
 by outprodmail02.cc.columbia.edu (8.14.4/8.14.4) with ESMTP id v6J2K5np013195
 for <kvmarm@lists.cs.columbia.edu>; Tue, 18 Jul 2017 22:24:41 -0400
Received: from hazelnut (localhost.localdomain [127.0.0.1])
 by hazelnut (Postfix) with ESMTP id 11A647E
 for <kvmarm@lists.cs.columbia.edu>; Tue, 18 Jul 2017 22:24:41 -0400 (EDT)
Received: from sendprodmail03.cc.columbia.edu (sendprodmail03.cc.columbia.edu
 [128.59.72.15]) by hazelnut (Postfix) with ESMTP id D983D83
 for <kvmarm@lists.cs.columbia.edu>; Tue, 18 Jul 2017 22:24:40 -0400 (EDT)
Received: from mail-oi0-f70.google.com (mail-oi0-f70.google.com
 [209.85.218.70])
 by sendprodmail03.cc.columbia.edu (8.14.4/8.14.4) with ESMTP id v6J2OeaQ016052
 (version=TLSv1/SSLv3 cipher=AES128-GCM-SHA256 bits=128 verify=NOT)
 for <kvmarm@lists.cs.columbia.edu>; Tue, 18 Jul 2017 22:24:40 -0400
Received: by mail-oi0-f70.google.com with SMTP id v68so2649982oia.14
 for <kvmarm@lists.cs.columbia.edu>; Tue, 18 Jul 2017 19:24:40 -0700 (PDT)
Received: from mail-oi0-f46.google.com (mail-oi0-f46.google.com.
 [209.85.218.46])
 by smtp.gmail.com with ESMTPSA id g3sm4938547oif.21.2017.07.18.19.24.38
 for <kvmarm@lists.cs.columbia.edu>
 (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
 Tue, 18 Jul 2017 19:24:38 -0700 (PDT)
Received: by mail-oi0-f46.google.com with SMTP id p188so32760655oia.0
 for <kvmarm@lists.cs.columbia.edu>; Tue, 18 Jul 2017 19:24:38 -0700 (PDT)
In-Reply-To: <1500397144-16232-38-git-send-email-jintack.lim@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: kvmarm@lists.cs.columbia.edu, Christoffer Dall <christoffer.dall@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>
Cc: KVM General <kvm@vger.kernel.org>, david.daney@cavium.com, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, stefan@hello-penguin.com, corbet@lwn.net, daniel.lezcano@linaro.org, linux@armlinux.org.uk, arm-mail-list <linux-arm-kernel@lists.infradead.org>, andy.gross@linaro.org, cov@codeaurora.org, wcohen@redhat.com, mchehab@kernel.org, ard.biesheuvel@linaro.org, linux-doc@vger.kernel.org, lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, akpm@linux-foundation.org
List-Id: kvmarm@lists.cs.columbia.edu

On Tue, Jul 18, 2017 at 12:59 PM, Jintack Lim <jintack.lim@linaro.org> wrote:
> Forward ELR_EL1, SPSR_EL1 and VBAR_EL1 traps to the virtual EL2 if the
> virtual HCR_EL2.NV bit is set.
>
> This is for recursive nested virtualization.
>
> Signed-off-by: Jintack Lim <jintack@cs.columbia.edu>

This should be linaro e-mail address. Will fix it.

> ---
>  arch/arm64/include/asm/kvm_arm.h |  1 +
>  arch/arm64/kvm/sys_regs.c        | 18 ++++++++++++++++++
>  2 files changed, 19 insertions(+)
>
> diff --git a/arch/arm64/include/asm/kvm_arm.h b/arch/arm64/include/asm/kvm_arm.h
> index aeaac4e..a1274b7 100644
> --- a/arch/arm64/include/asm/kvm_arm.h
> +++ b/arch/arm64/include/asm/kvm_arm.h
> @@ -23,6 +23,7 @@
>  #include <asm/types.h>
>
>  /* Hyp Configuration Register (HCR) bits */
> +#define HCR_NV1                (UL(1) << 43)
>  #define HCR_NV         (UL(1) << 42)
>  #define HCR_E2H                (UL(1) << 34)
>  #define HCR_ID         (UL(1) << 33)
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index 3e4ec5e..6f67666 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -1031,6 +1031,15 @@ static bool trap_el2_regs(struct kvm_vcpu *vcpu,
>         return true;
>  }
>
> +/* This function is to support the recursive nested virtualization */
> +static bool forward_nv1_traps(struct kvm_vcpu *vcpu, struct sys_reg_params *p)
> +{
> +       if (!vcpu_mode_el2(vcpu) && (vcpu_sys_reg(vcpu, HCR_EL2) & HCR_NV1))
> +               return true;
> +
> +       return false;
> +}
> +
>  static bool access_elr(struct kvm_vcpu *vcpu,
>                 struct sys_reg_params *p,
>                 const struct sys_reg_desc *r)
> @@ -1038,6 +1047,9 @@ static bool access_elr(struct kvm_vcpu *vcpu,
>         if (el12_reg(p) && forward_nv_traps(vcpu))
>                 return kvm_inject_nested_sync(vcpu, kvm_vcpu_get_hsr(vcpu));
>
> +       if (!el12_reg(p) && forward_nv1_traps(vcpu, p))
> +               return kvm_inject_nested_sync(vcpu, kvm_vcpu_get_hsr(vcpu));
> +
>         access_rw(p, &vcpu->arch.ctxt.gp_regs.elr_el1);
>         return true;
>  }
> @@ -1049,6 +1061,9 @@ static bool access_spsr(struct kvm_vcpu *vcpu,
>         if (el12_reg(p) && forward_nv_traps(vcpu))
>                 return kvm_inject_nested_sync(vcpu, kvm_vcpu_get_hsr(vcpu));
>
> +       if (!el12_reg(p) && forward_nv1_traps(vcpu, p))
> +               return kvm_inject_nested_sync(vcpu, kvm_vcpu_get_hsr(vcpu));
> +
>         access_rw(p, &vcpu->arch.ctxt.gp_regs.spsr[KVM_SPSR_EL1]);
>         return true;
>  }
> @@ -1060,6 +1075,9 @@ static bool access_vbar(struct kvm_vcpu *vcpu,
>         if (el12_reg(p) && forward_nv_traps(vcpu))
>                 return kvm_inject_nested_sync(vcpu, kvm_vcpu_get_hsr(vcpu));
>
> +       if (!el12_reg(p) && forward_nv1_traps(vcpu, p))
> +               return kvm_inject_nested_sync(vcpu, kvm_vcpu_get_hsr(vcpu));
> +
>         access_rw(p, &vcpu_sys_reg(vcpu, r->reg));
>         return true;
>  }
> --
> 1.9.1
>
