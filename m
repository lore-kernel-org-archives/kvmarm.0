Return-Path: <SRS0=Jx+E=QE=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 79196C433F5
	for <kvmarm@archiver.kernel.org>; Wed, 17 Nov 2021 23:51:02 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id E44BF61BC1
	for <kvmarm@archiver.kernel.org>; Wed, 17 Nov 2021 23:51:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org E44BF61BC1
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=ellerman.id.au
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 40A174B13A;
	Wed, 17 Nov 2021 18:51:01 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@ellerman.id.au
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id bGvKD03LGSXx; Wed, 17 Nov 2021 18:50:59 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3C8204B174;
	Wed, 17 Nov 2021 18:50:59 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 664FD4B13A
 for <kvmarm@lists.cs.columbia.edu>; Wed, 17 Nov 2021 18:50:58 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id J5tia9ud6Wwt for <kvmarm@lists.cs.columbia.edu>;
 Wed, 17 Nov 2021 18:50:56 -0500 (EST)
Received: from gandalf.ozlabs.org (gandalf.ozlabs.org [150.107.74.76])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id F0CA24B104
 for <kvmarm@lists.cs.columbia.edu>; Wed, 17 Nov 2021 18:50:55 -0500 (EST)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest
 SHA256) (No client certificate requested)
 by mail.ozlabs.org (Postfix) with ESMTPSA id 4Hvfnf5QFsz4xdN;
 Thu, 18 Nov 2021 10:50:46 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ellerman.id.au;
 s=201909; t=1637193050;
 bh=Y6qLtvD8c83vsgFlioCTxBI91MBKkMrwNyHMmx3iNJk=;
 h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
 b=Jv/ugO0GdH1f2QhPzft9Sxm/ntmhVoKfvBJTCvlmQ6WmIVLJ2Ps9uD42n8dNSGkkg
 wfYndhQTxnNrANlIOxL6l6FdkPbh71djkG3LkipwOlTpsCGCbCaOcYQGn2Fy/ejEeW
 6kpY8zvN0vfn1DhWVYqTQ5DveIe5yaDoKLSrEg0QCzmfKLpl94IdHDQDBLvD9L4j3v
 KRtHU+3QH9SXZqUmFBx38dz1SrkWHBs5XGhAkKOmtAXIL5Wbj2db2XwIZWrAlZEIOH
 05iVEr2HKDWNdtuOaS94KFmS0qEHie53/jVZ5Zr8m5snbbknqPu11gE31EKwHUouyn
 P9oDRQBt23RFQ==
From: Michael Ellerman <mpe@ellerman.id.au>
To: David Woodhouse <dwmw2@infradead.org>, Paolo Bonzini
 <pbonzini@redhat.com>, kvm <kvm@vger.kernel.org>
Subject: Re: [PATCH v3 06/12] KVM: powerpc: Use Makefile.kvm for common files
In-Reply-To: <20211117174003.297096-7-dwmw2@infradead.org>
References: <20211117174003.297096-1-dwmw2@infradead.org>
 <20211117174003.297096-7-dwmw2@infradead.org>
Date: Thu, 18 Nov 2021 10:50:44 +1100
Message-ID: <871r3emje3.fsf@mpe.ellerman.id.au>
MIME-Version: 1.0
Cc: Anup Patel <anup.patel@wdc.com>,
 "wanpengli @ tencent . com" <wanpengli@tencent.com>,
 Catalin Marinas <catalin.marinas@arm.com>,
 Joao Martins <joao.m.martins@oracle.com>, Will Deacon <will@kernel.org>,
 kvmarm@lists.cs.columbia.edu, linux-s390@vger.kernel.org,
 Marc Zyngier <maz@kernel.org>, "joro @ 8bytes . org" <joro@8bytes.org>,
 Huacai Chen <chenhuacai@kernel.org>,
 Christian Borntraeger <borntraeger@de.ibm.com>,
 Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>, karahmed@amazon.com,
 Benjamin Herrenschmidt <benh@kernel.crashing.org>,
 Boris Ostrovsky <boris.ostrovsky@oracle.com>,
 linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
 "jmattson @ google . com" <jmattson@google.com>,
 "mtosatti @ redhat . com" <mtosatti@redhat.com>, linux-mips@vger.kernel.org,
 kvm-riscv@lists.infradead.org, "vkuznets @ redhat . com" <vkuznets@redhat.com>,
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

David Woodhouse <dwmw2@infradead.org> writes:
> From: David Woodhouse <dwmw@amazon.co.uk>
>
> It's all fairly baroque but in the end, I don't think there's any reason
> for $(KVM)/irqchip.o to have been handled differently, as they all end
> up in $(kvm-y) in the end anyway, regardless of whether they get there
> via $(common-objs-y) and the CPU-specific object lists.
>
> Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
> ---
>  arch/powerpc/kvm/Makefile | 6 +-----
>  1 file changed, 1 insertion(+), 5 deletions(-)
>
> diff --git a/arch/powerpc/kvm/Makefile b/arch/powerpc/kvm/Makefile
> index 583c14ef596e..245f59118413 100644
> --- a/arch/powerpc/kvm/Makefile
> +++ b/arch/powerpc/kvm/Makefile
> @@ -4,11 +4,8 @@
>  #
>  
>  ccflags-y := -Ivirt/kvm -Iarch/powerpc/kvm
> -KVM := ../../../virt/kvm
>  
> -common-objs-y = $(KVM)/kvm_main.o $(KVM)/eventfd.o $(KVM)/binary_stats.o
> -common-objs-$(CONFIG_KVM_VFIO) += $(KVM)/vfio.o
> -common-objs-$(CONFIG_KVM_MMIO) += $(KVM)/coalesced_mmio.o
> +include $(srctree)/virt/kvm/Makefile.kvm
>  
>  common-objs-y += powerpc.o emulate_loadstore.o
>  obj-$(CONFIG_KVM_EXIT_TIMING) += timing.o
> @@ -125,7 +122,6 @@ kvm-book3s_32-objs := \
>  kvm-objs-$(CONFIG_KVM_BOOK3S_32) := $(kvm-book3s_32-objs)
>  
>  kvm-objs-$(CONFIG_KVM_MPIC) += mpic.o
> -kvm-objs-$(CONFIG_HAVE_KVM_IRQ_ROUTING) += $(KVM)/irqchip.o
>  
>  kvm-objs := $(kvm-objs-m) $(kvm-objs-y)

Looks OK to me. The extra objects built in Makefile.kvm are all behind
CONFIG symbols we don't enable.

Acked-by: Michael Ellerman <mpe@ellerman.id.au> (powerpc)

cheers
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
