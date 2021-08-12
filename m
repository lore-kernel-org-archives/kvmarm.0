Return-Path: <SRS0=D5oV=NG=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 90476C4338F
	for <kvmarm@archiver.kernel.org>; Sun, 15 Aug 2021 17:01:10 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 0692C61221
	for <kvmarm@archiver.kernel.org>; Sun, 15 Aug 2021 17:01:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 0692C61221
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6DBE44B0EF;
	Sun, 15 Aug 2021 13:01:09 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id qBut1v9JvB0T; Sun, 15 Aug 2021 13:01:05 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 40D934B104;
	Sun, 15 Aug 2021 13:01:05 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 36B9D40878
 for <kvmarm@lists.cs.columbia.edu>; Thu, 12 Aug 2021 00:02:34 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id gAZ3vIbTCbO7 for <kvmarm@lists.cs.columbia.edu>;
 Thu, 12 Aug 2021 00:02:30 -0400 (EDT)
Received: from out30-44.freemail.mail.aliyun.com
 (out30-44.freemail.mail.aliyun.com [115.124.30.44])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 4A664407EF
 for <kvmarm@lists.cs.columbia.edu>; Thu, 12 Aug 2021 00:02:28 -0400 (EDT)
X-Alimail-AntiSpam: AC=PASS; BC=-1|-1; BR=01201311R101e4; CH=green; DM=||false|;
 DS=||; FP=0|-1|-1|-1|0|-1|-1|-1; HT=e01e01424;
 MF=houwenlong93@linux.alibaba.com; NM=1; PH=DS; RN=38; SR=0;
 TI=SMTPD_---0UikIOfn_1628740941; 
Received: from localhost(mailfrom:houwenlong93@linux.alibaba.com
 fp:SMTPD_---0UikIOfn_1628740941) by smtp.aliyun-inc.com(127.0.0.1);
 Thu, 12 Aug 2021 12:02:21 +0800
From: Hou Wenlong <houwenlong93@linux.alibaba.com>
To: kvm@vger.kernel.org
Subject: [PATCH v2 1/2] KVM: Refactor kvm_arch_vcpu_fault() to return a struct
 page pointer
Date: Thu, 12 Aug 2021 12:02:19 +0800
Message-Id: <1c510b24fc1d7cbae8aa4b69c0799ebd32e65b82.1628739116.git.houwenlong93@linux.alibaba.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <YRQcZqCWwVH8bCGc@google.com>
References: <YRQcZqCWwVH8bCGc@google.com>
MIME-Version: 1.0
X-Mailman-Approved-At: Sun, 15 Aug 2021 13:01:04 -0400
Cc: x86@kernel.org, Wanpeng Li <wanpengli@tencent.com>,
 David Hildenbrand <david@redhat.com>,
 Benjamin Herrenschmidt <benh@kernel.crashing.org>, linux-mips@vger.kernel.org,
 Paul Mackerras <paulus@ozlabs.org>, "H. Peter Anvin" <hpa@zytor.com>,
 Claudio Imbrenda <imbrenda@linux.ibm.com>, Will Deacon <will@kernel.org>,
 kvmarm@lists.cs.columbia.edu, linux-s390@vger.kernel.org,
 Janosch Frank <frankja@linux.ibm.com>, Marc Zyngier <maz@kernel.org>,
 Joerg Roedel <joro@8bytes.org>, Huacai Chen <chenhuacai@kernel.org>,
 Christian Borntraeger <borntraeger@de.ibm.com>,
 Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
 Ingo Molnar <mingo@redhat.com>, Catalin Marinas <catalin.marinas@arm.com>,
 Vasily Gorbik <gor@linux.ibm.com>, Heiko Carstens <hca@linux.ibm.com>,
 kvm-ppc@vger.kernel.org, Borislav Petkov <bp@alien8.de>,
 Thomas Gleixner <tglx@linutronix.de>, linux-arm-kernel@lists.infradead.org,
 Jim Mattson <jmattson@google.com>,
 Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
 Sean Christopherson <seanjc@google.com>, Cornelia Huck <cohuck@redhat.com>,
 linux-kernel@vger.kernel.org, Michael Ellerman <mpe@ellerman.id.au>,
 Paolo Bonzini <pbonzini@redhat.com>, Vitaly Kuznetsov <vkuznets@redhat.com>,
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

From: Sean Christopherson <seanjc@google.com>

Refactor kvm_arch_vcpu_fault() to return 'struct page *' instead of
'vm_fault_t' to simplify architecture specific implementations that do
more than return SIGBUS.  Currently this only applies to s390, but a
future patch will move x86's pio_data handling into x86 where it belongs.

No functional changed intended.

Cc: Hou Wenlong <houwenlong93@linux.alibaba.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Hou Wenlong <houwenlong93@linux.alibaba.com>
---
 arch/arm64/kvm/arm.c       |  4 ++--
 arch/mips/kvm/mips.c       |  4 ++--
 arch/powerpc/kvm/powerpc.c |  4 ++--
 arch/s390/kvm/kvm-s390.c   | 12 ++++--------
 arch/x86/kvm/x86.c         |  4 ++--
 include/linux/kvm_host.h   |  2 +-
 virt/kvm/kvm_main.c        |  5 ++++-
 7 files changed, 17 insertions(+), 18 deletions(-)

diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index e9a2b8f27792..83f4ffe3e4f2 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -161,9 +161,9 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
 	return ret;
 }
 
-vm_fault_t kvm_arch_vcpu_fault(struct kvm_vcpu *vcpu, struct vm_fault *vmf)
+struct page *kvm_arch_vcpu_fault(struct kvm_vcpu *vcpu, struct vm_fault *vmf)
 {
-	return VM_FAULT_SIGBUS;
+	return NULL;
 }
 
 
diff --git a/arch/mips/kvm/mips.c b/arch/mips/kvm/mips.c
index af9dd029a4e1..ae79874e6fd2 100644
--- a/arch/mips/kvm/mips.c
+++ b/arch/mips/kvm/mips.c
@@ -1053,9 +1053,9 @@ int kvm_arch_vcpu_ioctl_set_fpu(struct kvm_vcpu *vcpu, struct kvm_fpu *fpu)
 	return -ENOIOCTLCMD;
 }
 
-vm_fault_t kvm_arch_vcpu_fault(struct kvm_vcpu *vcpu, struct vm_fault *vmf)
+struct page *kvm_arch_vcpu_fault(struct kvm_vcpu *vcpu, struct vm_fault *vmf)
 {
-	return VM_FAULT_SIGBUS;
+	return NULL;
 }
 
 int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
diff --git a/arch/powerpc/kvm/powerpc.c b/arch/powerpc/kvm/powerpc.c
index be33b5321a76..b9c21f9ab784 100644
--- a/arch/powerpc/kvm/powerpc.c
+++ b/arch/powerpc/kvm/powerpc.c
@@ -2090,9 +2090,9 @@ long kvm_arch_vcpu_ioctl(struct file *filp,
 	return r;
 }
 
-vm_fault_t kvm_arch_vcpu_fault(struct kvm_vcpu *vcpu, struct vm_fault *vmf)
+struct page *kvm_arch_vcpu_fault(struct kvm_vcpu *vcpu, struct vm_fault *vmf)
 {
-	return VM_FAULT_SIGBUS;
+	return NULL;
 }
 
 static int kvm_vm_ioctl_get_pvinfo(struct kvm_ppc_pvinfo *pvinfo)
diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index 02574d7b3612..e1b69833e228 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -4979,17 +4979,13 @@ long kvm_arch_vcpu_ioctl(struct file *filp,
 	return r;
 }
 
-vm_fault_t kvm_arch_vcpu_fault(struct kvm_vcpu *vcpu, struct vm_fault *vmf)
+struct page *kvm_arch_vcpu_fault(struct kvm_vcpu *vcpu, struct vm_fault *vmf)
 {
 #ifdef CONFIG_KVM_S390_UCONTROL
-	if ((vmf->pgoff == KVM_S390_SIE_PAGE_OFFSET)
-		 && (kvm_is_ucontrol(vcpu->kvm))) {
-		vmf->page = virt_to_page(vcpu->arch.sie_block);
-		get_page(vmf->page);
-		return 0;
-	}
+	if (vmf->pgoff == KVM_S390_SIE_PAGE_OFFSET && kvm_is_ucontrol(vcpu->kvm))
+		return virt_to_page(vcpu->arch.sie_block);
 #endif
-	return VM_FAULT_SIGBUS;
+	return NULL;
 }
 
 /* Section: memory related */
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 3cedc7cc132a..1e3bbe5cd33a 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -5347,9 +5347,9 @@ long kvm_arch_vcpu_ioctl(struct file *filp,
 	return r;
 }
 
-vm_fault_t kvm_arch_vcpu_fault(struct kvm_vcpu *vcpu, struct vm_fault *vmf)
+struct page *kvm_arch_vcpu_fault(struct kvm_vcpu *vcpu, struct vm_fault *vmf)
 {
-	return VM_FAULT_SIGBUS;
+	return NULL;
 }
 
 static int kvm_vm_ioctl_set_tss_addr(struct kvm *kvm, unsigned long addr)
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 492d183dd7d0..a949de534722 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -995,7 +995,7 @@ long kvm_arch_dev_ioctl(struct file *filp,
 			unsigned int ioctl, unsigned long arg);
 long kvm_arch_vcpu_ioctl(struct file *filp,
 			 unsigned int ioctl, unsigned long arg);
-vm_fault_t kvm_arch_vcpu_fault(struct kvm_vcpu *vcpu, struct vm_fault *vmf);
+struct page *kvm_arch_vcpu_fault(struct kvm_vcpu *vcpu, struct vm_fault *vmf);
 
 int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext);
 
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 30d322519253..f7d21418971b 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -3448,7 +3448,10 @@ static vm_fault_t kvm_vcpu_fault(struct vm_fault *vmf)
 		    &vcpu->dirty_ring,
 		    vmf->pgoff - KVM_DIRTY_LOG_PAGE_OFFSET);
 	else
-		return kvm_arch_vcpu_fault(vcpu, vmf);
+		page = kvm_arch_vcpu_fault(vcpu, vmf);
+	if (!page)
+		return VM_FAULT_SIGBUS;
+
 	get_page(page);
 	vmf->page = page;
 	return 0;
-- 
2.31.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
