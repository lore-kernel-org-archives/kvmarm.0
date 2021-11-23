Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C34CCC4332F
	for <kvmarm@archiver.kernel.org>; Tue, 23 Nov 2021 09:12:39 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0303A4B11B;
	Tue, 23 Nov 2021 04:12:39 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered)
	header.i=@brainfault-org.20210112.gappssmtp.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id AKgY8K01uBlI; Tue, 23 Nov 2021 04:12:37 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 82C244B129;
	Tue, 23 Nov 2021 04:12:37 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 40D2C4B11B
 for <kvmarm@lists.cs.columbia.edu>; Tue, 23 Nov 2021 04:12:36 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id liXmH7Z0oTkk for <kvmarm@lists.cs.columbia.edu>;
 Tue, 23 Nov 2021 04:12:34 -0500 (EST)
Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com
 [209.85.221.42])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id C5AA64B0F7
 for <kvmarm@lists.cs.columbia.edu>; Tue, 23 Nov 2021 04:12:34 -0500 (EST)
Received: by mail-wr1-f42.google.com with SMTP id c4so37659274wrd.9
 for <kvmarm@lists.cs.columbia.edu>; Tue, 23 Nov 2021 01:12:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=brainfault-org.20210112.gappssmtp.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=HYs1wzwF6+J9dSOANXB9y6loDw9qWfCXBI2HZhWySNA=;
 b=wltUiAygiHWsBEmc25AjNkPWeRE3z9px4T/cVrqarPBht3N5GOBcMj472TjSJxLh+F
 0GPEkZ82ElidOxCepsH3qkVpZpghdJFzn6w8QY0bBYX7GfBGAa5PebvvpwYx1AMsWy+/
 Hy0tXtM5hguM8ULFAxaSFY9L9pHflRmc5oBmZlGzdmDGxSVWLmJgoXyeLvirR3+EDdYc
 x6uL63V8O6CZSV6meLPQPSVnuq81aNx6LBTQbWdIxp70MyirIsOfKBJ+3yy5wRokBv7P
 ZHDdSS5XrKlSNk/fVqI4v77GmiM6rni3n8Pmp1gAXvY2q32B2g9mUwyOWVLBU2DWazev
 nV6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=HYs1wzwF6+J9dSOANXB9y6loDw9qWfCXBI2HZhWySNA=;
 b=JHRUBVRM6rutsodwM1Hf6txr3XjqmNgzx+iaYwgrnRLrVeC5OyXwXdHcrjJuCBWJzZ
 lQguWG/Hp3tvC0N9IX/72QAHGbe5cJ+u8tgCXM7JCc7Ei2HjCh2rmkofy0OslN4kvBFU
 dcNmjXzyaClXw//dxao/WtWxEg/6P8vBOR/0wK9X3QpyVufqCXEtLUEk/qK8EtZ0RteN
 rOXGOrnm49FK8kaJTzfl9lGAPW3RrKZaeyStmQ5M7a0HZFDzYil0FZebUd/udtScW3bs
 gVH8vKpIqkAxevGhV0iWrRT3twvDM8laOeNOBki49VPzkfGmeuS+hWi2WjIcN8tDHVKz
 E2IQ==
X-Gm-Message-State: AOAM533HvVfi/462L37tYjbzJJYLcp/jeS3SJnC3VgKaa0GgoTJloRSc
 BiE+vfQPKvxGC8WRjx+cULjwbKcpk6ZRqmnVQFwfWw==
X-Google-Smtp-Source: ABdhPJw3107qjhtYHlg0VKfoxcrKNwhATIgpuvcrTNAjZTbcT3w/UYNbeW1BEW91PyajE9x5O252/D9Dk01cQ3/AShU=
X-Received: by 2002:a05:6000:1a45:: with SMTP id
 t5mr5400365wry.306.1637658753498; 
 Tue, 23 Nov 2021 01:12:33 -0800 (PST)
MIME-Version: 1.0
References: <20211121125451.9489-1-dwmw2@infradead.org>
 <20211121125451.9489-6-dwmw2@infradead.org>
In-Reply-To: <20211121125451.9489-6-dwmw2@infradead.org>
From: Anup Patel <anup@brainfault.org>
Date: Tue, 23 Nov 2021 14:42:21 +0530
Message-ID: <CAAhSdy307DqNuQEFCu2ze2jXJ7taDE6y6SwY9nHGA8yNPfggiQ@mail.gmail.com>
Subject: Re: [PATCH v5 05/12] KVM: RISC-V: Use Makefile.kvm for common files
To: David Woodhouse <dwmw2@infradead.org>
Cc: Anup Patel <anup.patel@wdc.com>,
 "wanpengli @ tencent . com" <wanpengli@tencent.com>, kvm <kvm@vger.kernel.org>,
 Benjamin Herrenschmidt <benh@kernel.crashing.org>,
 Joao Martins <joao.m.martins@oracle.com>, Will Deacon <will@kernel.org>,
 kvmarm@lists.cs.columbia.edu, linux-s390@vger.kernel.org,
 Michael Ellerman <mpe@ellerman.id.au>, "joro @ 8bytes . org" <joro@8bytes.org>,
 Huacai Chen <chenhuacai@kernel.org>,
 Christian Borntraeger <borntraeger@de.ibm.com>,
 Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>, karahmed@amazon.com,
 Catalin Marinas <catalin.marinas@arm.com>,
 butt3rflyh4ck <butterflyhuangxx@gmail.com>,
 Boris Ostrovsky <boris.ostrovsky@oracle.com>,
 linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
 "jmattson @ google . com" <jmattson@google.com>,
 "mtosatti @ redhat . com" <mtosatti@redhat.com>, linux-mips@vger.kernel.org,
 kvm-riscv@lists.infradead.org, Marc Zyngier <maz@kernel.org>,
 Paolo Bonzini <pbonzini@redhat.com>,
 "vkuznets @ redhat . com" <vkuznets@redhat.com>, linuxppc-dev@lists.ozlabs.org
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

On Sun, Nov 21, 2021 at 6:25 PM David Woodhouse <dwmw2@infradead.org> wrote:
>
> From: David Woodhouse <dwmw@amazon.co.uk>
>
> Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>

Looks good to me.

For KVM RISC-V,
Acked-by: Anup Patel <anup.patel@wdc.com>
Reviewed-by: Anup Patel <anup.patel@wdc.com>

Thanks,
Anup

> ---
>  arch/riscv/kvm/Makefile | 6 +-----
>  1 file changed, 1 insertion(+), 5 deletions(-)
>
> diff --git a/arch/riscv/kvm/Makefile b/arch/riscv/kvm/Makefile
> index 30cdd1df0098..300590225348 100644
> --- a/arch/riscv/kvm/Makefile
> +++ b/arch/riscv/kvm/Makefile
> @@ -5,14 +5,10 @@
>
>  ccflags-y += -I $(srctree)/$(src)
>
> -KVM := ../../../virt/kvm
> +include $(srctree)/virt/kvm/Makefile.kvm
>
>  obj-$(CONFIG_KVM) += kvm.o
>
> -kvm-y += $(KVM)/kvm_main.o
> -kvm-y += $(KVM)/coalesced_mmio.o
> -kvm-y += $(KVM)/binary_stats.o
> -kvm-y += $(KVM)/eventfd.o
>  kvm-y += main.o
>  kvm-y += vm.o
>  kvm-y += vmid.o
> --
> 2.31.1
>
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
