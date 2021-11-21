Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2BF3EC433F5
	for <kvmarm@archiver.kernel.org>; Sun, 21 Nov 2021 21:13:41 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D95384B150;
	Sun, 21 Nov 2021 16:13:40 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@infradead.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id oZhxwe8hH4+z; Sun, 21 Nov 2021 16:13:38 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DA1A84B1D5;
	Sun, 21 Nov 2021 16:13:32 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 52E834B1B6
 for <kvmarm@lists.cs.columbia.edu>; Sun, 21 Nov 2021 07:55:50 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id lKLYQcsUEvcy for <kvmarm@lists.cs.columbia.edu>;
 Sun, 21 Nov 2021 07:55:49 -0500 (EST)
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 27B0A4B1AC
 for <kvmarm@lists.cs.columbia.edu>; Sun, 21 Nov 2021 07:55:49 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=infradead.org; s=casper.20170209; h=Sender:Content-Transfer-Encoding:
 MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
 Reply-To:Content-Type:Content-ID:Content-Description;
 bh=KJPYZZ7YbxCF8e4lw5Q63h+vhx2Z6IkGAc4ioCPd1zc=; b=cnsJ33e/M7n9LGUfChGbHmhPXq
 NvP9rAJBfMd6kiU/M2u5xxdIvzwLSE9aq8TbPSoZuYLVnNtMKwD7jKuB8uQ6uoT6bTzvQVqmUPFjz
 rY4Il0fBkQ4uEAEnqfd+eGoNE8PeqCgIclYY2YutLJdTXyupVE/MaMxMh+6WNvbExPlA8kV9UH6d6
 bhjTzq2Vajx8OnXyYvEtkYg9YIh57VKVeHAZCMVxEpPD+6S1V1WaTKY+i1QtxYykmegEwC0TZT855
 1ixN0NXtA0lfk1idhqZiDNiraCl1skk4F9vxuybALZEjNnwSzJ88QjCbgDVNuxDrpahOvmjnKpYuj
 QxIlC3Rw==;
Received: from i7.infradead.org ([2001:8b0:10b:1:21e:67ff:fecb:7a92])
 by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
 id 1momMw-00C3xx-7P; Sun, 21 Nov 2021 12:54:55 +0000
Received: from dwoodhou by i7.infradead.org with local (Exim 4.94.2 #2 (Red
 Hat Linux)) id 1momMw-0002WI-CY; Sun, 21 Nov 2021 12:54:54 +0000
From: David Woodhouse <dwmw2@infradead.org>
To: Paolo Bonzini <pbonzini@redhat.com>,
	kvm <kvm@vger.kernel.org>
Subject: [PATCH v5 06/12] KVM: powerpc: Use Makefile.kvm for common files
Date: Sun, 21 Nov 2021 12:54:45 +0000
Message-Id: <20211121125451.9489-7-dwmw2@infradead.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211121125451.9489-1-dwmw2@infradead.org>
References: <20211121125451.9489-1-dwmw2@infradead.org>
MIME-Version: 1.0
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by
 casper.infradead.org. See http://www.infradead.org/rpr.html
X-Mailman-Approved-At: Sun, 21 Nov 2021 16:13:30 -0500
Cc: Anup Patel <anup.patel@wdc.com>,
 "wanpengli @ tencent . com" <wanpengli@tencent.com>,
 Catalin Marinas <catalin.marinas@arm.com>,
 Joao Martins <joao.m.martins@oracle.com>, Will Deacon <will@kernel.org>,
 kvmarm@lists.cs.columbia.edu, linux-s390@vger.kernel.org,
 Michael Ellerman <mpe@ellerman.id.au>, "joro @ 8bytes . org" <joro@8bytes.org>,
 Huacai Chen <chenhuacai@kernel.org>,
 Christian Borntraeger <borntraeger@de.ibm.com>,
 Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>, karahmed@amazon.com,
 Benjamin Herrenschmidt <benh@kernel.crashing.org>,
 butt3rflyh4ck <butterflyhuangxx@gmail.com>,
 Boris Ostrovsky <boris.ostrovsky@oracle.com>,
 linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
 "jmattson @ google . com" <jmattson@google.com>,
 "mtosatti @ redhat . com" <mtosatti@redhat.com>, linux-mips@vger.kernel.org,
 kvm-riscv@lists.infradead.org, Marc Zyngier <maz@kernel.org>,
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

From: David Woodhouse <dwmw@amazon.co.uk>

It's all fairly baroque but in the end, I don't think there's any reason
for $(KVM)/irqchip.o to have been handled differently, as they all end
up in $(kvm-y) in the end anyway, regardless of whether they get there
via $(common-objs-y) and the CPU-specific object lists.

Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
Acked-by: Michael Ellerman <mpe@ellerman.id.au> (powerpc)
---
 arch/powerpc/kvm/Makefile | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/arch/powerpc/kvm/Makefile b/arch/powerpc/kvm/Makefile
index 583c14ef596e..245f59118413 100644
--- a/arch/powerpc/kvm/Makefile
+++ b/arch/powerpc/kvm/Makefile
@@ -4,11 +4,8 @@
 #
 
 ccflags-y := -Ivirt/kvm -Iarch/powerpc/kvm
-KVM := ../../../virt/kvm
 
-common-objs-y = $(KVM)/kvm_main.o $(KVM)/eventfd.o $(KVM)/binary_stats.o
-common-objs-$(CONFIG_KVM_VFIO) += $(KVM)/vfio.o
-common-objs-$(CONFIG_KVM_MMIO) += $(KVM)/coalesced_mmio.o
+include $(srctree)/virt/kvm/Makefile.kvm
 
 common-objs-y += powerpc.o emulate_loadstore.o
 obj-$(CONFIG_KVM_EXIT_TIMING) += timing.o
@@ -125,7 +122,6 @@ kvm-book3s_32-objs := \
 kvm-objs-$(CONFIG_KVM_BOOK3S_32) := $(kvm-book3s_32-objs)
 
 kvm-objs-$(CONFIG_KVM_MPIC) += mpic.o
-kvm-objs-$(CONFIG_HAVE_KVM_IRQ_ROUTING) += $(KVM)/irqchip.o
 
 kvm-objs := $(kvm-objs-m) $(kvm-objs-y)
 
-- 
2.31.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
