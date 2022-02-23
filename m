Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2A64EC433F5
	for <kvmarm@archiver.kernel.org>; Wed, 23 Feb 2022 06:37:34 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 735C64C3BF;
	Wed, 23 Feb 2022 01:37:33 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered)
	header.i=@brainfault-org.20210112.gappssmtp.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id SWdqTbkKd7dw; Wed, 23 Feb 2022 01:37:31 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BBCD64C1DB;
	Wed, 23 Feb 2022 01:37:31 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BC8684C12B
 for <kvmarm@lists.cs.columbia.edu>; Wed, 23 Feb 2022 01:37:29 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id r3kgTgvvONWI for <kvmarm@lists.cs.columbia.edu>;
 Wed, 23 Feb 2022 01:37:27 -0500 (EST)
Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com
 [209.85.221.53])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id AED6A4C094
 for <kvmarm@lists.cs.columbia.edu>; Wed, 23 Feb 2022 01:37:27 -0500 (EST)
Received: by mail-wr1-f53.google.com with SMTP id v21so2621322wrv.5
 for <kvmarm@lists.cs.columbia.edu>; Tue, 22 Feb 2022 22:37:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=brainfault-org.20210112.gappssmtp.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=dC+NRabJbEOE/6LY0GzfZ35HZRTTtu1cDQJ3h6XWVws=;
 b=UwcxHVgokN1y78HXIoukjj/WDywvL/2uWGwuPWDbQyaNYL92apBPnBflnwJEyxzGB1
 uPWtwx0PTNA7idkZooQKJlcEnqeoIJ47lsoaBz3sHVdjMI1OuKms227agxs2Mt6y8Xt1
 x87/KHKdNKDyIVa0NlXwbkfOD9YfoKYtnZyGpvQlkFpfXJ8N/GcHn8Z8DtJH1NHkG2RE
 y1GJOYsRFEx4TnXAGK5XVlydmfWcYtp5zd990YOjHN1skaUimAAbRtGR/I633uczTotA
 rOLLjvHGR5BdezgLhh6F4jUfR1jeEpT9g/a1PJbrJXRx0fpEt1sVP6OqEALqNkJ5eiZm
 s9Rg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=dC+NRabJbEOE/6LY0GzfZ35HZRTTtu1cDQJ3h6XWVws=;
 b=Ja91488mM9vma2ByvMeUKr0JQcziu3W3Hzj7Fuj8uiqy0MAZ7IZTIFkZ6AHwV9dzzO
 nfAcLPhrktcMZ2EVJloJhq6OxxzWxDiNYMuQC29zCw9VLseS01pI5XHrvLOsHB6+Tvdb
 YG5u4FNjkA9l291OSjvvcKqMBJLKd0SZcHBDbfXghJUhbHRXI9pMhCvM51ZbxK7XNVmZ
 gzQzqMxla6IjsAjenkc7uhmQwj6T1GkzXCX2B94XBHT+NYmG47WSVwZjRmnFqXaJTp6a
 w3KdRqVqqhvwPQirmZle9f+v8XdraZJIhDNtWiDxSvVzcqMoco0skHEJOk99sMTZihTn
 iHAg==
X-Gm-Message-State: AOAM5305rC8eiT84NKn6wVHIhG+b5BeZLpMICOZ8nzOOXcpSw2TAa91o
 DMrffWXDIEw6W4S8/IYv1sIzd9wBnTOognGlKq+7Gw==
X-Google-Smtp-Source: ABdhPJwKqNyKzIug73OWQJYmoCEu7Jp5fQjJlzs9qnjv5zwxFqIS5dHZi/tZ2zJuR+3fTVZYcrjfy7IDYca3QmiBaZQ=
X-Received: by 2002:adf:d1cc:0:b0:1ea:8355:88cc with SMTP id
 b12-20020adfd1cc000000b001ea835588ccmr5477832wrd.313.1645598246300; Tue, 22
 Feb 2022 22:37:26 -0800 (PST)
MIME-Version: 1.0
References: <20220223041844.3984439-1-oupton@google.com>
 <20220223041844.3984439-11-oupton@google.com>
In-Reply-To: <20220223041844.3984439-11-oupton@google.com>
From: Anup Patel <anup@brainfault.org>
Date: Wed, 23 Feb 2022 12:07:14 +0530
Message-ID: <CAAhSdy1yY+fQMUZ=2g1JSsZ=jZXFPGxTYk_sM3kURTJ+t_z3Wg@mail.gmail.com>
Subject: Re: [PATCH v3 10/19] KVM: Create helper for setting a system event
 exit
To: Oliver Upton <oupton@google.com>
Cc: Wanpeng Li <wanpengli@tencent.com>, KVM General <kvm@vger.kernel.org>,
 Marc Zyngier <maz@kernel.org>, Joerg Roedel <joro@8bytes.org>,
 Peter Shier <pshier@google.com>, kvm-riscv@lists.infradead.org,
 Atish Patra <atishp@atishpatra.org>, Paolo Bonzini <pbonzini@redhat.com>,
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

On Wed, Feb 23, 2022 at 9:49 AM Oliver Upton <oupton@google.com> wrote:
>
> Create a helper that appropriately configures kvm_run for a system event
> exit.
>
> No functional change intended.
>
> Suggested-by: Marc Zyngier <maz@kernel.org>
> Signed-off-by: Oliver Upton <oupton@google.com>

Looks good to me.

For KVM RISC-V:
Acked-by: Anup Patel <anup@brainfault.org>

Regards,
Anup

> ---
>  arch/arm64/kvm/psci.c         | 4 +---
>  arch/riscv/kvm/vcpu_sbi_v01.c | 4 +---
>  arch/x86/kvm/x86.c            | 6 ++----
>  include/linux/kvm_host.h      | 7 +++++++
>  4 files changed, 11 insertions(+), 10 deletions(-)
>
> diff --git a/arch/arm64/kvm/psci.c b/arch/arm64/kvm/psci.c
> index 41adaaf2234a..2bb8d047cde4 100644
> --- a/arch/arm64/kvm/psci.c
> +++ b/arch/arm64/kvm/psci.c
> @@ -193,9 +193,7 @@ static void kvm_prepare_system_event(struct kvm_vcpu *vcpu, u32 type)
>                 tmp->arch.mp_state = KVM_MP_STATE_STOPPED;
>         kvm_make_all_cpus_request(vcpu->kvm, KVM_REQ_SLEEP);
>
> -       memset(&vcpu->run->system_event, 0, sizeof(vcpu->run->system_event));
> -       vcpu->run->system_event.type = type;
> -       vcpu->run->exit_reason = KVM_EXIT_SYSTEM_EVENT;
> +       kvm_vcpu_set_system_event_exit(vcpu, type);
>  }
>
>  static void kvm_psci_system_off(struct kvm_vcpu *vcpu)
> diff --git a/arch/riscv/kvm/vcpu_sbi_v01.c b/arch/riscv/kvm/vcpu_sbi_v01.c
> index 07e2de14433a..7a197d5658d7 100644
> --- a/arch/riscv/kvm/vcpu_sbi_v01.c
> +++ b/arch/riscv/kvm/vcpu_sbi_v01.c
> @@ -24,9 +24,7 @@ static void kvm_sbi_system_shutdown(struct kvm_vcpu *vcpu,
>                 tmp->arch.power_off = true;
>         kvm_make_all_cpus_request(vcpu->kvm, KVM_REQ_SLEEP);
>
> -       memset(&run->system_event, 0, sizeof(run->system_event));
> -       run->system_event.type = type;
> -       run->exit_reason = KVM_EXIT_SYSTEM_EVENT;
> +       kvm_vcpu_set_system_event_exit(vcpu, type);
>  }
>
>  static int kvm_sbi_ext_v01_handler(struct kvm_vcpu *vcpu, struct kvm_run *run,
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 7131d735b1ef..109751f89ee3 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -9903,14 +9903,12 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
>                 if (kvm_check_request(KVM_REQ_APIC_PAGE_RELOAD, vcpu))
>                         kvm_vcpu_reload_apic_access_page(vcpu);
>                 if (kvm_check_request(KVM_REQ_HV_CRASH, vcpu)) {
> -                       vcpu->run->exit_reason = KVM_EXIT_SYSTEM_EVENT;
> -                       vcpu->run->system_event.type = KVM_SYSTEM_EVENT_CRASH;
> +                       kvm_vcpu_set_system_event_exit(vcpu, KVM_SYSTEM_EVENT_CRASH);
>                         r = 0;
>                         goto out;
>                 }
>                 if (kvm_check_request(KVM_REQ_HV_RESET, vcpu)) {
> -                       vcpu->run->exit_reason = KVM_EXIT_SYSTEM_EVENT;
> -                       vcpu->run->system_event.type = KVM_SYSTEM_EVENT_RESET;
> +                       kvm_vcpu_set_system_event_exit(vcpu, KVM_SYSTEM_EVENT_RESET);
>                         r = 0;
>                         goto out;
>                 }
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index f11039944c08..9085a1b1569a 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -2202,6 +2202,13 @@ static inline void kvm_handle_signal_exit(struct kvm_vcpu *vcpu)
>  }
>  #endif /* CONFIG_KVM_XFER_TO_GUEST_WORK */
>
> +static inline void kvm_vcpu_set_system_event_exit(struct kvm_vcpu *vcpu, u32 type)
> +{
> +       memset(&vcpu->run->system_event, 0, sizeof(vcpu->run->system_event));
> +       vcpu->run->system_event.type = type;
> +       vcpu->run->exit_reason = KVM_EXIT_SYSTEM_EVENT;
> +}
> +
>  /*
>   * This defines how many reserved entries we want to keep before we
>   * kick the vcpu to the userspace to avoid dirty ring full.  This
> --
> 2.35.1.473.g83b2b277ed-goog
>
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
