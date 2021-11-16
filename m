Return-Path: <SRS0=+NXu=QD=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C702BC433F5
	for <kvmarm@archiver.kernel.org>; Tue, 16 Nov 2021 18:13:30 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 6C4B06323D
	for <kvmarm@archiver.kernel.org>; Tue, 16 Nov 2021 18:13:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 6C4B06323D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BA8444B161;
	Tue, 16 Nov 2021 13:13:13 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@infradead.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 80vxSEzumcwF; Tue, 16 Nov 2021 13:13:12 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 944634B1CF;
	Tue, 16 Nov 2021 13:13:03 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 937124B0A3
 for <kvmarm@lists.cs.columbia.edu>; Tue, 16 Nov 2021 06:51:46 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id u3HgHZ3wg+yO for <kvmarm@lists.cs.columbia.edu>;
 Tue, 16 Nov 2021 06:51:45 -0500 (EST)
Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 693104B103
 for <kvmarm@lists.cs.columbia.edu>; Tue, 16 Nov 2021 06:51:45 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=infradead.org; s=desiato.20200630; h=Sender:Content-Transfer-Encoding:
 MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
 Reply-To:Content-Type:Content-ID:Content-Description;
 bh=yWZTSFEcMQzXm3g2QNc13LIwZBP4vIj1OJKIB2I3CoQ=; b=MtTrLPWZF8/Jdg7SAie8fPWQ3c
 7x7L1nfIc3ANGifiOZnxcp4Bj2N+h4+gCZB/4MpZCtN9cD5kgTnl9iCEOjeA/oFjmX8mgImnMlnIk
 oEfyxzI4ypvJCTj6zznTCgXIXgk60CbJTW0EYgiKsvE66U3ab4bmjvrW1DP8JNl2CoGufDNviSGFh
 kAyf2zFYkpGkmmrF4Ve02UfPNO2w0Uc5Y+LJVGt8HqeJuZ9/coIlYvFxyekL+FP9EiouH/j037rJ5
 CFWTzOBd09ZYbgUAetRPMgicg4nGdf5PQqnPmVhX2qYGOdaPkua84OyoOSySkERXPoyxAdiRn688r
 fuBQFCkw==;
Received: from i7.infradead.org ([2001:8b0:10b:1:21e:67ff:fecb:7a92])
 by desiato.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
 id 1mmwzD-00GJ7C-Qh; Tue, 16 Nov 2021 11:50:51 +0000
Received: from dwoodhou by i7.infradead.org with local (Exim 4.94.2 #2 (Red
 Hat Linux)) id 1mmwzD-000VDn-FA; Tue, 16 Nov 2021 11:50:51 +0000
From: David Woodhouse <dwmw2@infradead.org>
To: Paolo Bonzini <pbonzini@redhat.com>,
	kvm <kvm@vger.kernel.org>
Subject: [PATCH 5/7] KVM: RISC-V: Use Makefile.kvm for common files
Date: Tue, 16 Nov 2021 11:50:49 +0000
Message-Id: <20211116115051.119956-5-dwmw2@infradead.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211116115051.119956-1-dwmw2@infradead.org>
References: <5047c2591310e503491850ef683f251395247d50.camel@infradead.org>
 <20211116115051.119956-1-dwmw2@infradead.org>
MIME-Version: 1.0
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by
 desiato.infradead.org. See http://www.infradead.org/rpr.html
X-Mailman-Approved-At: Tue, 16 Nov 2021 13:13:01 -0500
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
---
 arch/riscv/kvm/Makefile | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/arch/riscv/kvm/Makefile b/arch/riscv/kvm/Makefile
index 30cdd1df0098..300590225348 100644
--- a/arch/riscv/kvm/Makefile
+++ b/arch/riscv/kvm/Makefile
@@ -5,14 +5,10 @@
 
 ccflags-y += -I $(srctree)/$(src)
 
-KVM := ../../../virt/kvm
+include $(srctree)/virt/kvm/Makefile.kvm
 
 obj-$(CONFIG_KVM) += kvm.o
 
-kvm-y += $(KVM)/kvm_main.o
-kvm-y += $(KVM)/coalesced_mmio.o
-kvm-y += $(KVM)/binary_stats.o
-kvm-y += $(KVM)/eventfd.o
 kvm-y += main.o
 kvm-y += vm.o
 kvm-y += vmid.o
-- 
2.31.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
