Return-Path: <SRS0=evlJ=6L=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.3 required=3.0 tests=DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 39367C5519B
	for <kvmarm@archiver.kernel.org>; Mon, 27 Apr 2020 09:40:09 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id E650A206A5
	for <kvmarm@archiver.kernel.org>; Mon, 27 Apr 2020 09:40:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RKVWEZ2i"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E650A206A5
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A09A64B086;
	Mon, 27 Apr 2020 05:40:08 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@gmail.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 9qoL6OixM41h; Mon, 27 Apr 2020 05:40:07 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 135624B1CA;
	Mon, 27 Apr 2020 05:39:57 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 660FB4B174
 for <kvmarm@lists.cs.columbia.edu>; Sun, 26 Apr 2020 23:44:26 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id M5v2K93Wa2aQ for <kvmarm@lists.cs.columbia.edu>;
 Sun, 26 Apr 2020 23:44:24 -0400 (EDT)
Received: from mail-io1-f68.google.com (mail-io1-f68.google.com
 [209.85.166.68])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id E59724B09D
 for <kvmarm@lists.cs.columbia.edu>; Sun, 26 Apr 2020 23:44:24 -0400 (EDT)
Received: by mail-io1-f68.google.com with SMTP id i3so17301067ioo.13
 for <kvmarm@lists.cs.columbia.edu>; Sun, 26 Apr 2020 20:44:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20161025;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=aQq0CUnQfujiDDnJvRHgF4LcjSyfQt3UEj7L50b98/A=;
 b=RKVWEZ2ioRL+cte2OumCaEGfBNi/Ob4AKIpk4K5KD00rj0JDK1PZIS7gzPvJXBAwXD
 wEDKZYPg+Iwxfg3u6Qu2tHISBcIuoeMiAheln22UZOiycsdQ0HMoswEn0IMGDShJmzQk
 1SCN3h1Ol/griaEytviyKiCcTm+lE555t9lIv5tWcUb5za9Ic35WNIaCEsYbLHrTQ1Fu
 0l4ku6FDE+jmz7sQl3r2fP1tZYb2z9gLkiQqPBHbXGY2DfDYDrYJr2pLEETcwtCZxioW
 tTPAGa9UZBCCSkNrIf8UWpHNoocAvTroQLIVShq/A0Z5rdQcfaDZA8EIjVuRUWnEivXS
 UDcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=aQq0CUnQfujiDDnJvRHgF4LcjSyfQt3UEj7L50b98/A=;
 b=dFBgLr52nZhGdvPec0wmgilFtnseo3KEhgpWI0ruX4Il47L51k39rOzv5xwZlDHj2F
 CgDWOvbrV0VH22AEvlzsOaxE5HpoY5faid3y4rTnsYIog2vNvtc8UrlosUMxLNEHCKAr
 gWGMziFKqepiyC0IsLLRJjc1DZYpU/m92YjEf7NLIZpN+g9QbvAhdK+g8WAtIUkX/XLp
 IKcUUPVHlRP1p/Js8JjGoDW7UXCYsd2Q3hrFi0wwHDwMrAAWHldaSpEJav1s/C+AjnCt
 pMqUzJ7SbXH9BTMe1YgBjw5LQZbojNXs4x0Qn0LWOl35b1JiVrMtt41BREturt29ugPO
 RYxA==
X-Gm-Message-State: AGi0PuYK4p6naVIY9mEB/Ckb/ISxVkLKsmV7smLjBuyVD8aYmluBwERB
 QudINB3qHEvi+Y7gTREcZdOIXaENW309CxAStRk=
X-Google-Smtp-Source: APiQypLX3afqSM1QWAKv61iq3HlPwMPQmqlnAsESamTCfsmhHfuQWhrkAz+NtraNDJj1UyhtF31EjwCvfUn58THeneA=
X-Received: by 2002:a6b:7317:: with SMTP id e23mr19071605ioh.72.1587959064357; 
 Sun, 26 Apr 2020 20:44:24 -0700 (PDT)
MIME-Version: 1.0
References: <20200426123905.8336-1-tianjia.zhang@linux.alibaba.com>
 <20200426123905.8336-8-tianjia.zhang@linux.alibaba.com>
In-Reply-To: <20200426123905.8336-8-tianjia.zhang@linux.alibaba.com>
From: Huacai Chen <chenhuacai@gmail.com>
Date: Mon, 27 Apr 2020 11:51:51 +0800
Message-ID: <CAAhV-H7tSPFSU143ZfmgitEY1BY7MrBzwvJHve49i+ABQ9quCg@mail.gmail.com>
Subject: Re: [PATCH v3 7/7] KVM: MIPS: clean up redundant kvm_run parameters
 in assembly
To: Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
X-Mailman-Approved-At: Mon, 27 Apr 2020 05:39:54 -0400
Cc: wanpengli@tencent.com, kvm@vger.kernel.org, david@redhat.com,
 Benjamin Herrenschmidt <benh@kernel.crashing.org>, heiko.carstens@de.ibm.com,
 "open list:MIPS" <linux-mips@vger.kernel.org>, paulus@ozlabs.org,
 hpa@zytor.com, kvmarm@lists.cs.columbia.edu, linux-s390@vger.kernel.org,
 frankja@linux.ibm.com, Marc Zyngier <maz@kernel.org>, joro@8bytes.org,
 x86@kernel.org, borntraeger@de.ibm.com, mingo@redhat.com, thuth@redhat.com,
 gor@linux.ibm.com, kvm-ppc@vger.kernel.org, Borislav Petkov <bp@alien8.de>,
 Thomas Gleixner <tglx@linutronix.de>,
 linux-arm-kernel <linux-arm-kernel@lists.infradead.org>, jmattson@google.com,
 Thomas Bogendoerfer <tsbogend@alpha.franken.de>, cohuck@redhat.com,
 sean.j.christopherson@intel.com, LKML <linux-kernel@vger.kernel.org>,
 mpe@ellerman.id.au, Paolo Bonzini <pbonzini@redhat.com>, vkuznets@redhat.com,
 linuxppc-dev@lists.ozlabs.org
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

Hi, Tianjia,

On Sun, Apr 26, 2020 at 8:40 PM Tianjia Zhang
<tianjia.zhang@linux.alibaba.com> wrote:
>
> In the current kvm version, 'kvm_run' has been included in the 'kvm_vcpu'
> structure. Earlier than historical reasons, many kvm-related function
> parameters retain the 'kvm_run' and 'kvm_vcpu' parameters at the same time.
> This patch does a unified cleanup of these remaining redundant parameters.
>
> Signed-off-by: Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
> ---
>  arch/mips/include/asm/kvm_host.h |  4 ++--
>  arch/mips/kvm/entry.c            | 15 +++++----------
>  arch/mips/kvm/mips.c             |  3 ++-
>  arch/mips/kvm/trap_emul.c        |  2 +-
>  arch/mips/kvm/vz.c               |  2 +-
>  5 files changed, 11 insertions(+), 15 deletions(-)
>
> diff --git a/arch/mips/include/asm/kvm_host.h b/arch/mips/include/asm/kvm_host.h
> index 971439297cea..db915c55166d 100644
> --- a/arch/mips/include/asm/kvm_host.h
> +++ b/arch/mips/include/asm/kvm_host.h
> @@ -310,7 +310,7 @@ struct kvm_mmu_memory_cache {
>  #define KVM_MIPS_GUEST_TLB_SIZE        64
>  struct kvm_vcpu_arch {
>         void *guest_ebase;
> -       int (*vcpu_run)(struct kvm_run *run, struct kvm_vcpu *vcpu);
> +       int (*vcpu_run)(struct kvm_vcpu *vcpu);
>
>         /* Host registers preserved across guest mode execution */
>         unsigned long host_stack;
> @@ -821,7 +821,7 @@ int kvm_mips_emulation_init(struct kvm_mips_callbacks **install_callbacks);
>  /* Debug: dump vcpu state */
>  int kvm_arch_vcpu_dump_regs(struct kvm_vcpu *vcpu);
>
> -extern int kvm_mips_handle_exit(struct kvm_run *run, struct kvm_vcpu *vcpu);
> +extern int kvm_mips_handle_exit(struct kvm_vcpu *vcpu);
>
>  /* Building of entry/exception code */
>  int kvm_mips_entry_setup(void);
> diff --git a/arch/mips/kvm/entry.c b/arch/mips/kvm/entry.c
> index 16e1c93b484f..e3f29af3b6cd 100644
> --- a/arch/mips/kvm/entry.c
> +++ b/arch/mips/kvm/entry.c
> @@ -204,7 +204,7 @@ static inline void build_set_exc_base(u32 **p, unsigned int reg)
>   * Assemble the start of the vcpu_run function to run a guest VCPU. The function
>   * conforms to the following prototype:
>   *
> - * int vcpu_run(struct kvm_run *run, struct kvm_vcpu *vcpu);
> + * int vcpu_run(struct kvm_vcpu *vcpu);
>   *
>   * The exit from the guest and return to the caller is handled by the code
>   * generated by kvm_mips_build_ret_to_host().
> @@ -217,8 +217,7 @@ void *kvm_mips_build_vcpu_run(void *addr)
>         unsigned int i;
>
>         /*
> -        * A0: run
> -        * A1: vcpu
> +        * A0: vcpu
>          */
>
>         /* k0/k1 not being used in host kernel context */
> @@ -237,10 +236,10 @@ void *kvm_mips_build_vcpu_run(void *addr)
>         kvm_mips_build_save_scratch(&p, V1, K1);
>
>         /* VCPU scratch register has pointer to vcpu */
> -       UASM_i_MTC0(&p, A1, scratch_vcpu[0], scratch_vcpu[1]);
> +       UASM_i_MTC0(&p, A0, scratch_vcpu[0], scratch_vcpu[1]);
>
>         /* Offset into vcpu->arch */
> -       UASM_i_ADDIU(&p, K1, A1, offsetof(struct kvm_vcpu, arch));
> +       UASM_i_ADDIU(&p, K1, A0, offsetof(struct kvm_vcpu, arch));
>
>         /*
>          * Save the host stack to VCPU, used for exception processing
> @@ -628,10 +627,7 @@ void *kvm_mips_build_exit(void *addr)
>         /* Now that context has been saved, we can use other registers */
>
>         /* Restore vcpu */
> -       UASM_i_MFC0(&p, S1, scratch_vcpu[0], scratch_vcpu[1]);
> -
> -       /* Restore run (vcpu->run) */
> -       UASM_i_LW(&p, S0, offsetof(struct kvm_vcpu, run), S1);
> +       UASM_i_MFC0(&p, S0, scratch_vcpu[0], scratch_vcpu[1]);
>
>         /*
>          * Save Host level EPC, BadVaddr and Cause to VCPU, useful to process
> @@ -793,7 +789,6 @@ void *kvm_mips_build_exit(void *addr)
>          * with this in the kernel
>          */
>         uasm_i_move(&p, A0, S0);
> -       uasm_i_move(&p, A1, S1);
>         UASM_i_LA(&p, T9, (unsigned long)kvm_mips_handle_exit);
>         uasm_i_jalr(&p, RA, T9);
>          UASM_i_ADDIU(&p, SP, SP, -CALLFRAME_SIZ);
I think uasm_i_move(&p, K1, S1) in kvm_mips_build_ret_from_exit() and
UASM_i_MTC0(&p, S1, scratch_vcpu[0], scratch_vcpu[1]) in
kvm_mips_build_ret_to_guest() should also be changed.

> diff --git a/arch/mips/kvm/mips.c b/arch/mips/kvm/mips.c
> index 9710477a9827..32850470c037 100644
> --- a/arch/mips/kvm/mips.c
> +++ b/arch/mips/kvm/mips.c
> @@ -1186,8 +1186,9 @@ static void kvm_mips_set_c0_status(void)
>  /*
>   * Return value is in the form (errcode<<2 | RESUME_FLAG_HOST | RESUME_FLAG_NV)
>   */
> -int kvm_mips_handle_exit(struct kvm_run *run, struct kvm_vcpu *vcpu)
> +int kvm_mips_handle_exit(struct kvm_vcpu *vcpu)
>  {
> +       struct kvm_run *run = vcpu->run;
>         u32 cause = vcpu->arch.host_cp0_cause;
>         u32 exccode = (cause >> CAUSEB_EXCCODE) & 0x1f;
>         u32 __user *opc = (u32 __user *) vcpu->arch.pc;
> diff --git a/arch/mips/kvm/trap_emul.c b/arch/mips/kvm/trap_emul.c
> index d822f3aee3dc..04c864cc356a 100644
> --- a/arch/mips/kvm/trap_emul.c
> +++ b/arch/mips/kvm/trap_emul.c
> @@ -1238,7 +1238,7 @@ static int kvm_trap_emul_vcpu_run(struct kvm_vcpu *vcpu)
>          */
>         kvm_mips_suspend_mm(cpu);
>
> -       r = vcpu->arch.vcpu_run(vcpu->run, vcpu);
> +       r = vcpu->arch.vcpu_run(vcpu);
>
>         /* We may have migrated while handling guest exits */
>         cpu = smp_processor_id();
> diff --git a/arch/mips/kvm/vz.c b/arch/mips/kvm/vz.c
> index 94f1d23828e3..c5878fa0636d 100644
> --- a/arch/mips/kvm/vz.c
> +++ b/arch/mips/kvm/vz.c
> @@ -3152,7 +3152,7 @@ static int kvm_vz_vcpu_run(struct kvm_vcpu *vcpu)
>         kvm_vz_vcpu_load_tlb(vcpu, cpu);
>         kvm_vz_vcpu_load_wired(vcpu);
>
> -       r = vcpu->arch.vcpu_run(vcpu->run, vcpu);
> +       r = vcpu->arch.vcpu_run(vcpu);
>
>         kvm_vz_vcpu_save_wired(vcpu);
>
> --
> 2.17.1
>

Regards,
Huacai
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
