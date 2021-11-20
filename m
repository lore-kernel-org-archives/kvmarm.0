Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3ADF0C433FE
	for <kvmarm@archiver.kernel.org>; Sat, 20 Nov 2021 10:36:13 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D7A074B091;
	Sat, 20 Nov 2021 05:36:12 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@infradead.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id IPBCIzCxN0PD; Sat, 20 Nov 2021 05:36:11 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 458154B1A2;
	Sat, 20 Nov 2021 05:36:07 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 42D614B134
 for <kvmarm@lists.cs.columbia.edu>; Sat, 20 Nov 2021 05:29:13 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Q+gpWqAS4gld for <kvmarm@lists.cs.columbia.edu>;
 Sat, 20 Nov 2021 05:29:12 -0500 (EST)
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 026F04B12E
 for <kvmarm@lists.cs.columbia.edu>; Sat, 20 Nov 2021 05:29:12 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=infradead.org; s=casper.20170209; h=Sender:Content-Transfer-Encoding:
 MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
 Reply-To:Content-Type:Content-ID:Content-Description;
 bh=6h0xVL2esfqq+zqj5xeWRwsV4t0vspg87ggVyWnX0Og=; b=cnPlXioA9dOko+9aiQD3x3xvz8
 k4+xYsWzsD+ah6Jz3arFGWF9tXP9LVx29wiQhpNzu8FT0WAjWgIAbyrve93Wv3ByA46tlnlktQC/J
 /j0SvGXdshI9YgfSh7MEhSGN9l4KxA2wAlbGvPbbtQxP7eChrHB4NIFpsQuQ82qlAYJweVpmS7p0l
 q6irWDKqkFis4nkfSaPGhoGoaJy7JbDhOSMyqNk29FlkwtNXPnn2VlngD2C31hLXvte7kXaYKzqhR
 kGX0N1vLwNcF8GdDzMKPXxpXhLNaD350UD4fCIJqXQXPmZ6wLJodtiPAF5A8nMjEnzZdd9vIvjURP
 RqFyTDcw==;
Received: from i7.infradead.org ([2001:8b0:10b:1:21e:67ff:fecb:7a92])
 by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
 id 1moNbQ-00AUNK-W3; Sat, 20 Nov 2021 10:28:13 +0000
Received: from dwoodhou by i7.infradead.org with local (Exim 4.94.2 #2 (Red
 Hat Linux)) id 1moNbQ-0002KB-Ce; Sat, 20 Nov 2021 10:28:12 +0000
From: David Woodhouse <dwmw2@infradead.org>
To: Paolo Bonzini <pbonzini@redhat.com>,
	kvm <kvm@vger.kernel.org>
Subject: [PATCH v4 03/11] KVM: s390: Use Makefile.kvm for common files
Date: Sat, 20 Nov 2021 10:28:02 +0000
Message-Id: <20211120102810.8858-4-dwmw2@infradead.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211120102810.8858-1-dwmw2@infradead.org>
References: <20211120102810.8858-1-dwmw2@infradead.org>
MIME-Version: 1.0
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by
 casper.infradead.org. See http://www.infradead.org/rpr.html
X-Mailman-Approved-At: Sat, 20 Nov 2021 05:36:05 -0500
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

Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
Reviewed-by: Christian Borntraeger <borntraeger@de.ibm.com>
---
 arch/s390/kvm/Makefile | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/arch/s390/kvm/Makefile b/arch/s390/kvm/Makefile
index b3aaadc60ead..e4f50453cf7f 100644
--- a/arch/s390/kvm/Makefile
+++ b/arch/s390/kvm/Makefile
@@ -3,13 +3,11 @@
 #
 # Copyright IBM Corp. 2008
 
-KVM := ../../../virt/kvm
-common-objs = $(KVM)/kvm_main.o $(KVM)/eventfd.o  $(KVM)/async_pf.o \
-	      $(KVM)/irqchip.o $(KVM)/vfio.o $(KVM)/binary_stats.o
+include $(srctree)/virt/kvm/Makefile.kvm
 
 ccflags-y := -Ivirt/kvm -Iarch/s390/kvm
 
-kvm-objs := $(common-objs) kvm-s390.o intercept.o interrupt.o priv.o sigp.o
+kvm-objs := kvm-s390.o intercept.o interrupt.o priv.o sigp.o
 kvm-objs += diag.o gaccess.o guestdbg.o vsie.o pv.o
 
 obj-$(CONFIG_KVM) += kvm.o
-- 
2.31.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
