Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0584C433FE
	for <kvmarm@archiver.kernel.org>; Mon,  7 Nov 2022 03:10:32 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2CF284B889;
	Sun,  6 Nov 2022 22:10:32 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered)
	header.i=@brainfault-org.20210112.gappssmtp.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id YpHgA5tkFi7s; Sun,  6 Nov 2022 22:10:30 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E94674B89D;
	Sun,  6 Nov 2022 22:10:30 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E15A64B889
 for <kvmarm@lists.cs.columbia.edu>; Sun,  6 Nov 2022 22:10:28 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 0n4bi8EFudq4 for <kvmarm@lists.cs.columbia.edu>;
 Sun,  6 Nov 2022 22:10:27 -0500 (EST)
Received: from mail-ej1-f47.google.com (mail-ej1-f47.google.com
 [209.85.218.47])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 9282D4B86D
 for <kvmarm@lists.cs.columbia.edu>; Sun,  6 Nov 2022 22:10:27 -0500 (EST)
Received: by mail-ej1-f47.google.com with SMTP id k2so26757310ejr.2
 for <kvmarm@lists.cs.columbia.edu>; Sun, 06 Nov 2022 19:10:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=brainfault-org.20210112.gappssmtp.com; s=20210112;
 h=cc:to:subject:message-id:date:from:in-reply-to:references
 :mime-version:from:to:cc:subject:date:message-id:reply-to;
 bh=H1pcoCub6KdV/gUz+piTr4fdj2mnlqaFRmHq36k4mN4=;
 b=gQpUBAHaNtCtn8GOZM6K3nOKU9i/513DHG6kPmdKabejoExXLL0yKmZoHWD5IqrYnl
 BaH7/MlZuQ3cd3geild3XN0vIjfsuogd3DRyazx76rKFD1GxN2z2p5a1MMzxdPc3wvTw
 RxZD99Kfh6hz1mjWaldEvMgnh1z6ZDZqqXsSWsYVIgeKGUPakiXDa4BTKTMvzBMhceI0
 p+2o9fYelNd1OGlcY0c89OLh4mpaR3Ph8Z8pNTcesJ5e6yXb/WhpmYapUPDUZmdETGBa
 YNDaSceGSYjG/bGEYOqsAJz81Hj8vvE+0OhEFfMoxQFcd4iiMCUDxLdOXI4/qhCe4BWK
 wETA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=cc:to:subject:message-id:date:from:in-reply-to:references
 :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
 :reply-to;
 bh=H1pcoCub6KdV/gUz+piTr4fdj2mnlqaFRmHq36k4mN4=;
 b=cI13xPM+yKCPWYHnU5u7VUTyp6lLXlMVJY1fLlT4Hgl20tJxOY5ZuQpc9Sb8FLtW2q
 3b/x/e4A6E9koqXnhavjQNmigwrneOAvdlF55/x4FaEt+aO5MpNV3MVLIB3EP9NYFhth
 wjnu8tvNPlh7preFA91R6N9hj5HecSH9RilGjtC47j0Z7E08XoEQORqNw0mdMLPazTg5
 NdT+GUM+O5lp9logmZOzYer/H3/YguEu8n1v2tVrFUN8D1S5DkDhGLyDpvpteFribp6O
 OKM1BppWMpOnOGPn8f0VXN9dYzlAVgO5d1xjdtYQl7XpVUd0vJ4AvWnlnM5d7Xz49Mkm
 +CUg==
X-Gm-Message-State: ACrzQf3AG255BZ7NfVlwBRaC9tRRpRJLSbiXchP+6cR99GBvtqNluivP
 hLCiBmDYqrQgkRnsN73VCs6aogWe1Vsj02ju3oBFQQ==
X-Google-Smtp-Source: AMsMyM7XCgJtPlnLGfYx3eSoncGi1AE82N9qaj+trfvM6WmHPWkeWUQhOX2da2jCOnZnugZUPvknpt/SuEsv4imbUmY=
X-Received: by 2002:a17:906:eec7:b0:733:189f:b07a with SMTP id
 wu7-20020a170906eec700b00733189fb07amr46196816ejb.230.1667790626379; Sun, 06
 Nov 2022 19:10:26 -0800 (PST)
MIME-Version: 1.0
References: <20221102231911.3107438-1-seanjc@google.com>
 <20221102231911.3107438-24-seanjc@google.com>
In-Reply-To: <20221102231911.3107438-24-seanjc@google.com>
From: Anup Patel <anup@brainfault.org>
Date: Mon, 7 Nov 2022 08:40:14 +0530
Message-ID: <CAAhSdy1XSv+yNHyhPf44H3f7oaz+7Ku6COkKAQt7Zy7ahdC7jA@mail.gmail.com>
Subject: Re: [PATCH 23/44] KVM: RISC-V: Tag init functions and data with
 __init, __ro_after_init
To: Sean Christopherson <seanjc@google.com>
Cc: Matthew Rosato <mjrosato@linux.ibm.com>,
 David Hildenbrand <david@redhat.com>, Yuan Yao <yuan.yao@intel.com>,
 Paul Walmsley <paul.walmsley@sifive.com>, linux-kernel@vger.kernel.org,
 linux-riscv@lists.infradead.org, Claudio Imbrenda <imbrenda@linux.ibm.com>,
 kvmarm@lists.cs.columbia.edu, linux-s390@vger.kernel.org,
 Janosch Frank <frankja@linux.ibm.com>, Marc Zyngier <maz@kernel.org>,
 Huacai Chen <chenhuacai@kernel.org>,
 Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
 Christian Borntraeger <borntraeger@linux.ibm.com>,
 Chao Gao <chao.gao@intel.com>, Eric Farman <farman@linux.ibm.com>,
 Albert Ou <aou@eecs.berkeley.edu>, kvm@vger.kernel.org,
 Atish Patra <atishp@atishpatra.org>, kvmarm@lists.linux.dev,
 Thomas Gleixner <tglx@linutronix.de>, linux-arm-kernel@lists.infradead.org,
 Isaku Yamahata <isaku.yamahata@intel.com>,
 Fabiano Rosas <farosas@linux.ibm.com>, linux-mips@vger.kernel.org,
 Palmer Dabbelt <palmer@dabbelt.com>, kvm-riscv@lists.infradead.org,
 Michael Ellerman <mpe@ellerman.id.au>, Paolo Bonzini <pbonzini@redhat.com>,
 Vitaly Kuznetsov <vkuznets@redhat.com>, linuxppc-dev@lists.ozlabs.org
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

On Thu, Nov 3, 2022 at 4:49 AM Sean Christopherson <seanjc@google.com> wrote:
>
> Now that KVM setup is handled directly in riscv_kvm_init(), tag functions
> and data that are used/set only during init with __init/__ro_after_init.
>
> Signed-off-by: Sean Christopherson <seanjc@google.com>

For KVM RISC-V:
Acked-by: Anup Patel <anup@brainfault.org>

Thanks,
Anup

> ---
>  arch/riscv/include/asm/kvm_host.h |  6 +++---
>  arch/riscv/kvm/mmu.c              | 12 ++++++------
>  arch/riscv/kvm/vmid.c             |  4 ++--
>  3 files changed, 11 insertions(+), 11 deletions(-)
>
> diff --git a/arch/riscv/include/asm/kvm_host.h b/arch/riscv/include/asm/kvm_host.h
> index 8c771fc4f5d2..778ff0f282b7 100644
> --- a/arch/riscv/include/asm/kvm_host.h
> +++ b/arch/riscv/include/asm/kvm_host.h
> @@ -295,11 +295,11 @@ int kvm_riscv_gstage_map(struct kvm_vcpu *vcpu,
>  int kvm_riscv_gstage_alloc_pgd(struct kvm *kvm);
>  void kvm_riscv_gstage_free_pgd(struct kvm *kvm);
>  void kvm_riscv_gstage_update_hgatp(struct kvm_vcpu *vcpu);
> -void kvm_riscv_gstage_mode_detect(void);
> -unsigned long kvm_riscv_gstage_mode(void);
> +void __init kvm_riscv_gstage_mode_detect(void);
> +unsigned long __init kvm_riscv_gstage_mode(void);
>  int kvm_riscv_gstage_gpa_bits(void);
>
> -void kvm_riscv_gstage_vmid_detect(void);
> +void __init kvm_riscv_gstage_vmid_detect(void);
>  unsigned long kvm_riscv_gstage_vmid_bits(void);
>  int kvm_riscv_gstage_vmid_init(struct kvm *kvm);
>  bool kvm_riscv_gstage_vmid_ver_changed(struct kvm_vmid *vmid);
> diff --git a/arch/riscv/kvm/mmu.c b/arch/riscv/kvm/mmu.c
> index 3620ecac2fa1..f42a34c7879a 100644
> --- a/arch/riscv/kvm/mmu.c
> +++ b/arch/riscv/kvm/mmu.c
> @@ -20,12 +20,12 @@
>  #include <asm/pgtable.h>
>
>  #ifdef CONFIG_64BIT
> -static unsigned long gstage_mode = (HGATP_MODE_SV39X4 << HGATP_MODE_SHIFT);
> -static unsigned long gstage_pgd_levels = 3;
> +static unsigned long gstage_mode __ro_after_init = (HGATP_MODE_SV39X4 << HGATP_MODE_SHIFT);
> +static unsigned long gstage_pgd_levels __ro_after_init = 3;
>  #define gstage_index_bits      9
>  #else
> -static unsigned long gstage_mode = (HGATP_MODE_SV32X4 << HGATP_MODE_SHIFT);
> -static unsigned long gstage_pgd_levels = 2;
> +static unsigned long gstage_mode __ro_after_init = (HGATP_MODE_SV32X4 << HGATP_MODE_SHIFT);
> +static unsigned long gstage_pgd_levels __ro_after_init = 2;
>  #define gstage_index_bits      10
>  #endif
>
> @@ -760,7 +760,7 @@ void kvm_riscv_gstage_update_hgatp(struct kvm_vcpu *vcpu)
>                 kvm_riscv_local_hfence_gvma_all();
>  }
>
> -void kvm_riscv_gstage_mode_detect(void)
> +void __init kvm_riscv_gstage_mode_detect(void)
>  {
>  #ifdef CONFIG_64BIT
>         /* Try Sv57x4 G-stage mode */
> @@ -784,7 +784,7 @@ void kvm_riscv_gstage_mode_detect(void)
>  #endif
>  }
>
> -unsigned long kvm_riscv_gstage_mode(void)
> +unsigned long __init kvm_riscv_gstage_mode(void)
>  {
>         return gstage_mode >> HGATP_MODE_SHIFT;
>  }
> diff --git a/arch/riscv/kvm/vmid.c b/arch/riscv/kvm/vmid.c
> index 6cd93995fb65..5246da1c9167 100644
> --- a/arch/riscv/kvm/vmid.c
> +++ b/arch/riscv/kvm/vmid.c
> @@ -17,10 +17,10 @@
>
>  static unsigned long vmid_version = 1;
>  static unsigned long vmid_next;
> -static unsigned long vmid_bits;
> +static unsigned long vmid_bits __ro_after_init;
>  static DEFINE_SPINLOCK(vmid_lock);
>
> -void kvm_riscv_gstage_vmid_detect(void)
> +void __init kvm_riscv_gstage_vmid_detect(void)
>  {
>         unsigned long old;
>
> --
> 2.38.1.431.g37b22c650d-goog
>
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
