Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2EF7DC43219
	for <kvmarm@archiver.kernel.org>; Mon,  7 Nov 2022 03:05:21 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6F8CA4B8A5;
	Sun,  6 Nov 2022 22:05:20 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered)
	header.i=@brainfault-org.20210112.gappssmtp.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id fD-7m3yxQR6L; Sun,  6 Nov 2022 22:05:19 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4713C4B88A;
	Sun,  6 Nov 2022 22:05:19 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A3FC44B86D
 for <kvmarm@lists.cs.columbia.edu>; Sun,  6 Nov 2022 22:05:17 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id XH0LBlLXIMyX for <kvmarm@lists.cs.columbia.edu>;
 Sun,  6 Nov 2022 22:05:16 -0500 (EST)
Received: from mail-ej1-f49.google.com (mail-ej1-f49.google.com
 [209.85.218.49])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 3363C4B868
 for <kvmarm@lists.cs.columbia.edu>; Sun,  6 Nov 2022 22:05:16 -0500 (EST)
Received: by mail-ej1-f49.google.com with SMTP id k2so26739390ejr.2
 for <kvmarm@lists.cs.columbia.edu>; Sun, 06 Nov 2022 19:05:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=brainfault-org.20210112.gappssmtp.com; s=20210112;
 h=cc:to:subject:message-id:date:from:in-reply-to:references
 :mime-version:from:to:cc:subject:date:message-id:reply-to;
 bh=YDkpvmLdCcNS/SK5D2IL8ltTmU7MAjuwj9on9XdxjqM=;
 b=O2GdYT7cMyZAwXXzVaGGer2516sCwb8nVa+3zH1uKyisQxoW9HAvhvHCOOJeufiTbl
 F3Np7E0Q60MoiXXzv7QKKfVpPuct8EOqbYhrz0wkX1SdRI+8oB73JExLBlUhlEORndI0
 oR5Ci6Q9Zji0dGkOeDy61S11yj8qgzFtdaxDEMNt1vXTTwBDofXJXEd/zzO2opd/NDJm
 j1f/gZ4KRV3uPIBqcQXujsk4akPpTe+2a2n4m0j+UpZ//j9kycunMnHpdO3L/Ji7eqnQ
 U523Q+8cijpVSXguZZnGJMRJTHTEr5k6EgUTEZqzTJSespExVQpXPGZ+H7/pFHIEuIGk
 PlTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=cc:to:subject:message-id:date:from:in-reply-to:references
 :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
 :reply-to;
 bh=YDkpvmLdCcNS/SK5D2IL8ltTmU7MAjuwj9on9XdxjqM=;
 b=5mianHaBy8SiL8jpdi3HI1BgY3ue7zfWHVfEdbTJ5mqJio6D0B+BTLph0LEgxGo4T0
 D9y1NwRxFhPlzUjsmTTIT7wp3EsSfsO54L9LzM+vEGMNfWFWTVFxSqnRcq+jZo2ryIdm
 ZmJeBSmKgCt0890tQ22ImSRDf8b5KnFVx3qKHY4zhYvIFW5pAIYaGfQO9xU4dP1SfJc2
 PhiRDIlNdR+QQrwyc0yMwnknXf5By1lPUEIkZKEoHAGSDoP273a8PTrLsAUHGYVyNoVb
 LBXrGVKbcMpXdc5sXoNXwR3huRBy3o1ANeKhNm5mwQbrCBevd8MOIJJK/4U+BOx9nJ1d
 nYFA==
X-Gm-Message-State: ACrzQf2HWASgzN/TGICANo9fcTo+nHXO9KmptpFuyFYGAhBkBWkIoWkw
 o112OEwHZkjvlrKMYjvwJY13nWCr5LTCJOMJk+W57A==
X-Google-Smtp-Source: AMsMyM525hQagKYMIlOIdqQEy/Sx/ht089FGqr8YQw810BAnhG6hulq/sfu3BFpHCBMEkVy5m+xwSwFEwA0SvamrVJs=
X-Received: by 2002:a17:906:eec7:b0:733:189f:b07a with SMTP id
 wu7-20020a170906eec700b00733189fb07amr46182007ejb.230.1667790314965; Sun, 06
 Nov 2022 19:05:14 -0800 (PST)
MIME-Version: 1.0
References: <20221102231911.3107438-1-seanjc@google.com>
 <20221102231911.3107438-23-seanjc@google.com>
In-Reply-To: <20221102231911.3107438-23-seanjc@google.com>
From: Anup Patel <anup@brainfault.org>
Date: Mon, 7 Nov 2022 08:35:03 +0530
Message-ID: <CAAhSdy01NfFuHCsA1mrcxERL+=8F=PQbD_Nu7qvdKQOyQ_p9Tw@mail.gmail.com>
Subject: Re: [PATCH 22/44] KVM: RISC-V: Do arch init directly in
 riscv_kvm_init()
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
> Fold the guts of kvm_arch_init() into riscv_kvm_init() instead of
> bouncing through kvm_init()=>kvm_arch_init().  Functionally, this is a
> glorified nop as invoking kvm_arch_init() is the very first action
> performed by kvm_init().
>
> Moving setup to riscv_kvm_init(), which is tagged __init, will allow
> tagging more functions and data with __init and __ro_after_init.  And
> emptying kvm_arch_init() will allow dropping the hook entirely once all
> architecture implementations are nops.
>
> No functional change intended.
>
> Signed-off-by: Sean Christopherson <seanjc@google.com>

For KVM RISC-V:
Acked-by: Anup Patel <anup@brainfault.org>

Regards,
Anup

> ---
>  arch/riscv/kvm/main.c | 18 +++++++++---------
>  1 file changed, 9 insertions(+), 9 deletions(-)
>
> diff --git a/arch/riscv/kvm/main.c b/arch/riscv/kvm/main.c
> index a146fa0ce4d2..cb063b8a9a0f 100644
> --- a/arch/riscv/kvm/main.c
> +++ b/arch/riscv/kvm/main.c
> @@ -66,6 +66,15 @@ void kvm_arch_hardware_disable(void)
>  }
>
>  int kvm_arch_init(void *opaque)
> +{
> +       return 0;
> +}
> +
> +void kvm_arch_exit(void)
> +{
> +}
> +
> +static int __init riscv_kvm_init(void)
>  {
>         const char *str;
>
> @@ -110,15 +119,6 @@ int kvm_arch_init(void *opaque)
>
>         kvm_info("VMID %ld bits available\n", kvm_riscv_gstage_vmid_bits());
>
> -       return 0;
> -}
> -
> -void kvm_arch_exit(void)
> -{
> -}
> -
> -static int __init riscv_kvm_init(void)
> -{
>         return kvm_init(NULL, sizeof(struct kvm_vcpu), 0, THIS_MODULE);
>  }
>  module_init(riscv_kvm_init);
> --
> 2.38.1.431.g37b22c650d-goog
>
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
