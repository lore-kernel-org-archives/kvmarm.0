Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E91C3C54EE9
	for <kvmarm@archiver.kernel.org>; Tue, 27 Sep 2022 07:01:43 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 64E5B4B658;
	Tue, 27 Sep 2022 03:01:43 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id XeHtXdeYo4wS; Tue, 27 Sep 2022 03:01:42 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2F04E40BE7;
	Tue, 27 Sep 2022 03:01:42 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 097D4408F4
 for <kvmarm@lists.cs.columbia.edu>; Tue, 27 Sep 2022 03:01:41 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id lstJ0-3KTZj5 for <kvmarm@lists.cs.columbia.edu>;
 Tue, 27 Sep 2022 03:01:39 -0400 (EDT)
Received: from mail-oi1-f175.google.com (mail-oi1-f175.google.com
 [209.85.167.175])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id B47534089C
 for <kvmarm@lists.cs.columbia.edu>; Tue, 27 Sep 2022 03:01:39 -0400 (EDT)
Received: by mail-oi1-f175.google.com with SMTP id r125so10915397oia.8
 for <kvmarm@lists.cs.columbia.edu>; Tue, 27 Sep 2022 00:01:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=cc:to:subject:message-id:date:from:in-reply-to:references
 :mime-version:from:to:cc:subject:date;
 bh=E70VKyNLfpMrN2tn7yjuSAsildf4GsIvIX1OrG9E27A=;
 b=UlhRPDv8KPSw5JAfrPJnfDIOW8t6C5FofP5Prw+qe8oCdExQfzbSkHqYw9dhGZqdwY
 9O/IcEBXe3TKQL4qDnAsBzgM4NGT1vjK0WfFzvwwKwvrVEb73lQXEYeJB4BV8YMNHntj
 9QS96gOTmOaCEe4qBkSttmdlT2ayErfE17jzU4rCx4G7ZlDsOk0MAUmUh4yBe7qYsDUf
 ROAPNwj73sQMg1AuvDqz+IoEL3Dz1I/oraIzDUM/GIkaeWhwTTwTHCf32VZfviV32XwI
 039lsOHpsSVKQsysW5ZkkaXmw0008PIh5c3R5G3PO7tgE3ujDL3PbQQKkpaE7UkLDi11
 X5SQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=cc:to:subject:message-id:date:from:in-reply-to:references
 :mime-version:x-gm-message-state:from:to:cc:subject:date;
 bh=E70VKyNLfpMrN2tn7yjuSAsildf4GsIvIX1OrG9E27A=;
 b=oebxFC/3ZJUimiC3NKeq2hTJIKbY6S0HgeU3qKtKbEBJBc73pUQfpEAfhhRB01j9Ce
 TC9FzErxqp9XA2Wr6N0eTjH/g2mascb07FuangZzpre/MOa4REqp+Wjet7VFaSOHfni4
 m2fTBJngHMEJ1rf31sZfoBtyUudDLps0hutIEep59V9govH16eJs2HBbQzx518MA7zCF
 JYfTCcPv+5//twWw1zdsTKx8tD6dksnam9qcTs2Zj6zIIStDhUuy1h/ypxK8SsS3AcRF
 d3KokjeGDzmmgTSFO8FKhKBnNBbWklnEb1UbbkPtwLkgp70fbA6Co1E5bJpBKrhi8aYD
 mQ2Q==
X-Gm-Message-State: ACrzQf0w216rIrUKtiZP4iVNiC6aiMajfhWvkur6Tm7/jegavRoXiV0y
 TgcfdD0JAeX4AufCJO6BCK4FpDLiiZMNctZz1l3N7w==
X-Google-Smtp-Source: AMsMyM48X52ODBTPeaSHNnAoqOvvgHXVb73r8V2XWVzzxofRB/Dj3lT4BzwCNHtWbEXNso+iipBKIqOGxW4X/1wJlWo=
X-Received: by 2002:aca:4286:0:b0:350:a3fd:f6df with SMTP id
 p128-20020aca4286000000b00350a3fdf6dfmr1140069oia.61.1664262098931; Tue, 27
 Sep 2022 00:01:38 -0700 (PDT)
MIME-Version: 1.0
References: <20220927002715.2142353-1-mizhang@google.com>
In-Reply-To: <20220927002715.2142353-1-mizhang@google.com>
From: Reiji Watanabe <reijiw@google.com>
Date: Tue, 27 Sep 2022 00:01:22 -0700
Message-ID: <CAAeT=FwqWkbhFLHvr12A2rYdzZuDJWBti=jKQRargvAb6bKtaA@mail.gmail.com>
Subject: Re: [PATCH] KVM: arm64: Cleanup the __get_fault_info() to take out
 the code that validates HPFAR
To: Mingwei Zhang <mizhang@google.com>
Cc: Marc Zyngier <maz@kernel.org>, linux-kernel@vger.kernel.org,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
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

Hi Mingwei,

On Mon, Sep 26, 2022 at 5:27 PM Mingwei Zhang <mizhang@google.com> wrote:
>
> Cleanup __get_fault_info() to take out the code that checks HPFAR. The
> conditions in __get_fault_info() that checks if HPFAR contains a valid IPA
> is slightly messy in that several conditions are written within one IF
> statement acrossing multiple lines and are connected with different logical
> operators. Among them, some conditions come from ARM Spec, while others
> come from CPU erratum. This makes the code hard to read and difficult to
> extend.
>
> So, cleanup the function to improve the readability. In particular,
> explicitly specify each condition separately within a newly created inline
> function.
>
> No functional changes are intended.
>
> Suggested-by: Oliver Upton <oupton@google.com>
> Signed-off-by: Mingwei Zhang <mizhang@google.com>
> ---
>  arch/arm64/kvm/hyp/include/hyp/fault.h | 36 ++++++++++++++++----------
>  1 file changed, 23 insertions(+), 13 deletions(-)
>
> diff --git a/arch/arm64/kvm/hyp/include/hyp/fault.h b/arch/arm64/kvm/hyp/include/hyp/fault.h
> index 1b8a2dcd712f..4575500d26ff 100644
> --- a/arch/arm64/kvm/hyp/include/hyp/fault.h
> +++ b/arch/arm64/kvm/hyp/include/hyp/fault.h
> @@ -41,12 +41,6 @@ static inline bool __translate_far_to_hpfar(u64 far, u64 *hpfar)
>         return true;
>  }
>
> -static inline bool __get_fault_info(u64 esr, struct kvm_vcpu_fault_info *fault)
> -{
> -       u64 hpfar, far;
> -
> -       far = read_sysreg_el2(SYS_FAR);
> -
>         /*
>          * The HPFAR can be invalid if the stage 2 fault did not
>          * happen during a stage 1 page table walk (the ESR_EL2.S1PTW
> @@ -58,14 +52,30 @@ static inline bool __get_fault_info(u64 esr, struct kvm_vcpu_fault_info *fault)
>          * permission fault or the errata workaround is enabled, we
>          * resolve the IPA using the AT instruction.
>          */
> -       if (!(esr & ESR_ELx_S1PTW) &&
> -           (cpus_have_final_cap(ARM64_WORKAROUND_834220) ||
> -            (esr & ESR_ELx_FSC_TYPE) == FSC_PERM)) {
> -               if (!__translate_far_to_hpfar(far, &hpfar))
> -                       return false;
> -       } else {
> +static inline bool __hpfar_is_valid(u64 esr)

Unlike what the name implies, this function returns true for some
cases that HPFAR is not valid (i.e. SEA).  I think the function
returns true when KVM doesn't need HPFAR, or when HPFAR is valid.
IMHO the name might be a bit misleading, although I don't have
a good name for this.  It would be nice to state that in the
comment at least.

Thank you,
Reiji


> +{
> +       if (esr & ESR_ELx_S1PTW)
> +               return true;
> +
> +       if ((esr & ESR_ELx_FSC_TYPE) == FSC_PERM)
> +               return false;
> +
> +       if (cpus_have_final_cap(ARM64_WORKAROUND_834220))
> +               return false;
> +
> +       return true;
> +}
> +
> +static inline bool __get_fault_info(u64 esr, struct kvm_vcpu_fault_info *fault)
> +{
> +       u64 hpfar, far;
> +
> +       far = read_sysreg_el2(SYS_FAR);
> +
> +       if (!__hpfar_is_valid(esr) && !__translate_far_to_hpfar(far, &hpfar))
> +               return false;
> +       else
>                 hpfar = read_sysreg(hpfar_el2);
> -       }
>
>         fault->far_el2 = far;
>         fault->hpfar_el2 = hpfar;
>
> base-commit: c59fb127583869350256656b7ed848c398bef879
> --
> 2.37.3.998.g577e59143f-goog
>
> _______________________________________________
> kvmarm mailing list
> kvmarm@lists.cs.columbia.edu
> https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
