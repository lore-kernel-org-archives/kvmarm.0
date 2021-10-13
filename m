Return-Path: <SRS0=5TFS=PB=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C70A8C433EF
	for <kvmarm@archiver.kernel.org>; Wed, 13 Oct 2021 15:59:16 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 7999E61163
	for <kvmarm@archiver.kernel.org>; Wed, 13 Oct 2021 15:59:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 7999E61163
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2DFD14B162;
	Wed, 13 Oct 2021 11:59:16 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id w91P+YOm5vF4; Wed, 13 Oct 2021 11:59:15 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0C9054B161;
	Wed, 13 Oct 2021 11:59:15 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4D07A4B08A
 for <kvmarm@lists.cs.columbia.edu>; Wed, 13 Oct 2021 11:59:12 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id cVouF6e3dVOs for <kvmarm@lists.cs.columbia.edu>;
 Wed, 13 Oct 2021 11:59:11 -0400 (EDT)
Received: from mail-qk1-f201.google.com (mail-qk1-f201.google.com
 [209.85.222.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 4EA254B14D
 for <kvmarm@lists.cs.columbia.edu>; Wed, 13 Oct 2021 11:59:11 -0400 (EDT)
Received: by mail-qk1-f201.google.com with SMTP id
 q5-20020a05620a0d8500b0045edb4779dbso2269330qkl.2
 for <kvmarm@lists.cs.columbia.edu>; Wed, 13 Oct 2021 08:59:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=NDD02US5GbETqBBkcvp2ltSMD53RfkXvi4Mxnfbxyc8=;
 b=T1qbVsJ5h8QTAp1/7WrxvMrgG72eD1aSQQj1BSMPYB1Kenh6Hklh6K8yCZTmndDK42
 u4Y6NVa014WhwUgqqD9CmbygSYVNBaZkM0MN8g7UYT0kUTHH54kjhCEurh3xoN5qYwBo
 ddSTtlaIarhctUtcmQkgKfG1Z9B5fnVxEdlhSrzQjhoOayqJ5st7VQycchZ+5+1bRDiN
 kqcD6cdKLI0G2Cohd+EKqWaBlTYO6NH7oR9jYBU6u0mp5nvRhRsQqIvt2zveBAGm2gW3
 sz7jZ5lZd0cOcFiIBkGj8S5gYYRVvaB97+qO8VnlH+n3idlF4gkw+ygzF2gJ+kyVQItQ
 0ceQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=NDD02US5GbETqBBkcvp2ltSMD53RfkXvi4Mxnfbxyc8=;
 b=iEzK+gyRh14CZWDmW6eN7DvURlWQlo7kTTkWzNjhm0vBs7z+YENH97WpedfVLDy6Pr
 u0hHlB5UhmMvwaPBsJRCvOamxyeiErcX3U8Ip2ayNH7WlIlO/9gAgTHOJTCAWH5gZ+Co
 C7SQ5WQQW5v47+LHBBwE64BKX3yYp9SVPHA7OKgrJl3TGdqnU7aTmVTPa7UE67yZSIum
 lgmXIrGuHkYIU4i1806SsvKxEIKYB2lhYFaZgB/jsWOE/siiDHfOqEXmuBicYEwyjLFS
 F3FMY8xPoLgQg8qY+wgiKV5bYOMM3ImevtCcslLNuEcBsQWuKyZdi6IPxixJ/kgRnF8s
 ltwA==
X-Gm-Message-State: AOAM533488gcAyCNw9Y2ql9wM0k7MjHp+5v432BmEXrGJvajSuQjSgqW
 WzXFTq8d1KRAg7t+gYzHLqYkNiZNEYkL
X-Google-Smtp-Source: ABdhPJy+Hh/3VJIHIRnHcU5zrl6PnoHx6rKK0wdWdMKIvuGmVj2OaF9KH+F7ChEdi48qABlrMpoZp8hwR7HW
X-Received: from luke.lon.corp.google.com
 ([2a00:79e0:d:210:65b5:73d3:1558:b9ae])
 (user=qperret job=sendgmr) by 2002:a05:622a:118b:: with SMTP id
 m11mr81305qtk.67.1634140750968; Wed, 13 Oct 2021 08:59:10 -0700 (PDT)
Date: Wed, 13 Oct 2021 16:58:31 +0100
In-Reply-To: <20211013155831.943476-1-qperret@google.com>
Message-Id: <20211013155831.943476-17-qperret@google.com>
Mime-Version: 1.0
References: <20211013155831.943476-1-qperret@google.com>
X-Mailer: git-send-email 2.33.0.882.g93a45727a2-goog
Subject: [PATCH 16/16] KVM: arm64: pkvm: Unshare guest structs during teardown
From: Quentin Perret <qperret@google.com>
To: Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>, 
 Alexandru Elisei <alexandru.elisei@arm.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>, 
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Fuad Tabba <tabba@google.com>, David Brazdil <dbrazdil@google.com>
Cc: kernel-team@android.com, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
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

Make use of the newly introduced unshare hypercall during guest teardown
to unmap guest-related data structures from the hyp stage-1.

Signed-off-by: Quentin Perret <qperret@google.com>
---
 arch/arm64/include/asm/kvm_host.h |  2 ++
 arch/arm64/include/asm/kvm_mmu.h  |  1 +
 arch/arm64/kvm/arm.c              |  2 ++
 arch/arm64/kvm/fpsimd.c           | 10 ++++++++--
 arch/arm64/kvm/mmu.c              | 16 ++++++++++++++++
 arch/arm64/kvm/reset.c            | 13 ++++++++++++-
 6 files changed, 41 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index f8be56d5342b..8b61cdcd1b29 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -322,6 +322,8 @@ struct kvm_vcpu_arch {
 
 	struct thread_info *host_thread_info;	/* hyp VA */
 	struct user_fpsimd_state *host_fpsimd_state;	/* hyp VA */
+	struct thread_info *kern_thread_info;
+	struct user_fpsimd_state *kern_fpsimd_state;
 
 	struct {
 		/* {Break,watch}point registers */
diff --git a/arch/arm64/include/asm/kvm_mmu.h b/arch/arm64/include/asm/kvm_mmu.h
index 185d0f62b724..81839e9a8a24 100644
--- a/arch/arm64/include/asm/kvm_mmu.h
+++ b/arch/arm64/include/asm/kvm_mmu.h
@@ -151,6 +151,7 @@ static __always_inline unsigned long __kern_hyp_va(unsigned long v)
 #include <asm/stage2_pgtable.h>
 
 int kvm_share_hyp(void *from, void *to);
+void kvm_unshare_hyp(void *from, void *to);
 int create_hyp_mappings(void *from, void *to, enum kvm_pgtable_prot prot);
 int create_hyp_io_mappings(phys_addr_t phys_addr, size_t size,
 			   void __iomem **kaddr,
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index f2e74635332b..f11c51db6fe6 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -188,6 +188,8 @@ void kvm_arch_destroy_vm(struct kvm *kvm)
 		}
 	}
 	atomic_set(&kvm->online_vcpus, 0);
+
+	kvm_unshare_hyp(kvm, kvm + 1);
 }
 
 int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
diff --git a/arch/arm64/kvm/fpsimd.c b/arch/arm64/kvm/fpsimd.c
index 2fe1128d9f3d..67059daf4d26 100644
--- a/arch/arm64/kvm/fpsimd.c
+++ b/arch/arm64/kvm/fpsimd.c
@@ -28,23 +28,29 @@ int kvm_arch_vcpu_run_map_fp(struct kvm_vcpu *vcpu)
 {
 	int ret;
 
-	struct thread_info *ti = &current->thread_info;
-	struct user_fpsimd_state *fpsimd = &current->thread.uw.fpsimd_state;
+	struct thread_info *ti = vcpu->arch.kern_thread_info;
+	struct user_fpsimd_state *fpsimd = vcpu->arch.kern_fpsimd_state;
 
 	/*
 	 * Make sure the host task thread flags and fpsimd state are
 	 * visible to hyp:
 	 */
+	kvm_unshare_hyp(ti, ti + 1);
+	ti = &current->thread_info;
 	ret = kvm_share_hyp(ti, ti + 1);
 	if (ret)
 		goto error;
 
+	kvm_unshare_hyp(fpsimd, fpsimd + 1);
+	fpsimd = &current->thread.uw.fpsimd_state;
 	ret = kvm_share_hyp(fpsimd, fpsimd + 1);
 	if (ret)
 		goto error;
 
 	vcpu->arch.host_thread_info = kern_hyp_va(ti);
 	vcpu->arch.host_fpsimd_state = kern_hyp_va(fpsimd);
+	vcpu->arch.kern_thread_info = ti;
+	vcpu->arch.kern_fpsimd_state = fpsimd;
 error:
 	return ret;
 }
diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index bc9865a8c988..f01b0e49e262 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -300,6 +300,22 @@ int kvm_share_hyp(void *from, void *to)
 				 nr_pages);
 }
 
+void kvm_unshare_hyp(void *from, void *to)
+{
+	phys_addr_t start, end;
+	u64 nr_pages;
+
+	if (is_kernel_in_hyp_mode() || kvm_host_owns_hyp_mappings() || !from)
+		return;
+
+	start = ALIGN_DOWN(kvm_kaddr_to_phys(from), PAGE_SIZE);
+	end = PAGE_ALIGN(kvm_kaddr_to_phys(to));
+	nr_pages = (end - start) >> PAGE_SHIFT;
+
+	WARN_ON(kvm_call_hyp_nvhe(__pkvm_host_unshare_hyp, __phys_to_pfn(start),
+				  nr_pages));
+}
+
 /**
  * create_hyp_mappings - duplicate a kernel virtual address range in Hyp mode
  * @from:	The virtual kernel start address of the range
diff --git a/arch/arm64/kvm/reset.c b/arch/arm64/kvm/reset.c
index 5ce36b0a3343..e3e9c9e1f1c8 100644
--- a/arch/arm64/kvm/reset.c
+++ b/arch/arm64/kvm/reset.c
@@ -141,7 +141,18 @@ bool kvm_arm_vcpu_is_finalized(struct kvm_vcpu *vcpu)
 
 void kvm_arm_vcpu_destroy(struct kvm_vcpu *vcpu)
 {
-	kfree(vcpu->arch.sve_state);
+	struct user_fpsimd_state *fpsimd = vcpu->arch.kern_fpsimd_state;
+	struct thread_info *ti = vcpu->arch.kern_thread_info;
+	void *sve_state = vcpu->arch.sve_state;
+
+	kvm_unshare_hyp(vcpu, vcpu + 1);
+	if (ti)
+		kvm_unshare_hyp(ti, ti + 1);
+	if (fpsimd)
+		kvm_unshare_hyp(fpsimd, fpsimd + 1);
+	if (sve_state && vcpu->arch.has_run_once)
+		kvm_unshare_hyp(sve_state, sve_state + vcpu_sve_state_size(vcpu));
+	kfree(sve_state);
 }
 
 static void kvm_vcpu_reset_sve(struct kvm_vcpu *vcpu)
-- 
2.33.0.882.g93a45727a2-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
