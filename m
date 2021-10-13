Return-Path: <SRS0=5TFS=PB=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 36922C4332F
	for <kvmarm@archiver.kernel.org>; Wed, 13 Oct 2021 15:58:48 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id CE7DF611B0
	for <kvmarm@archiver.kernel.org>; Wed, 13 Oct 2021 15:58:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org CE7DF611B0
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 845CA4B128;
	Wed, 13 Oct 2021 11:58:47 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id foUsC3dNHln6; Wed, 13 Oct 2021 11:58:46 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 38B514B13E;
	Wed, 13 Oct 2021 11:58:46 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 670754B0F7
 for <kvmarm@lists.cs.columbia.edu>; Wed, 13 Oct 2021 11:58:45 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id J2S5kYhUpj-5 for <kvmarm@lists.cs.columbia.edu>;
 Wed, 13 Oct 2021 11:58:44 -0400 (EDT)
Received: from mail-wr1-f74.google.com (mail-wr1-f74.google.com
 [209.85.221.74])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 4CEAB4B0EF
 for <kvmarm@lists.cs.columbia.edu>; Wed, 13 Oct 2021 11:58:44 -0400 (EDT)
Received: by mail-wr1-f74.google.com with SMTP id
 y12-20020a056000168c00b00160da4de2c7so2365680wrd.5
 for <kvmarm@lists.cs.columbia.edu>; Wed, 13 Oct 2021 08:58:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=PKsT+7mjWWd9o2mzLnA84Fl0AOzVFe9DHpCA6EEH4ck=;
 b=K59g1PkrmD+1jJFreVZEOcaqgBIuuI69x/2EfncZknIv0Ug4ZU5q/hQgMHuN7BMY/u
 bXLS4NOjIfrihuVvivfeqdskI7kAcv0EldfrFBgzFKfb6FALdO1GhVsgV45ue4RRYo60
 zkkXEre44C5pIpEvGJ3+IaTFDDYOQdEV0ShsoRukTPcMj3Q+U+EI5BOxng8P5pjy/6Vs
 GExkIm8uvhTZGqM35NG93X/Z2/kVqzNvPwK/aeLDQSpiITTBo0JKFxjcrIrykmR/DWUo
 EUkBCUb7yNLm8+UFbj4VoE0rnH4JuyaMIw6KQXmAJyM76lxBojGFz2/xJuq+YqaBCLI9
 SL4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=PKsT+7mjWWd9o2mzLnA84Fl0AOzVFe9DHpCA6EEH4ck=;
 b=BLpnqLtxp6gsGhsvgDkkioqMzJkfSeJ8zXMYw+ic5XRsaE9h2w/V44v9ensJw7xJH7
 hncX75/n9QlWkn/voG0WW56V3agiIv4jOhA1bu1oe7TwKpN8Sv9vc0pNPopfpshHXcAg
 UzWC9GPYk4aXJG/e7Iv6XqPdGkq4oLSIvNPdE6ZiSxVUFyA4rhcTw+a6q/o9gUG5wWTh
 ajHr3zAYZshroKjpzaugSRxo1f3pj56091YFvIUtCG7yB7LTzoorN8M0rNxBx5V2jKAN
 741EaTMYc43A81he5/M2mCKsqlWRHhewyEM07/OtlQWdg53/VHfqiGinAn+DjCghj5I9
 GGIw==
X-Gm-Message-State: AOAM531CKxl9P5j6/nPQ93irRCiiF02WrPThUSmjtueObMcpvDdtHWap
 lFtaqntvv7Pjcc1k2O2Aq+PWW0mO1fXe
X-Google-Smtp-Source: ABdhPJw3f6Eb2tt9fOVR32uwn3rCbLrDxsHBoLvwAPqLBi7eN5NfRbqKMHsaNjIwI/pfQ2jQ5pyBrCx0Fr38
X-Received: from luke.lon.corp.google.com
 ([2a00:79e0:d:210:65b5:73d3:1558:b9ae])
 (user=qperret job=sendgmr) by 2002:a1c:4484:: with SMTP id
 r126mr13590383wma.150.1634140723470; Wed, 13 Oct 2021 08:58:43 -0700 (PDT)
Date: Wed, 13 Oct 2021 16:58:19 +0100
In-Reply-To: <20211013155831.943476-1-qperret@google.com>
Message-Id: <20211013155831.943476-5-qperret@google.com>
Mime-Version: 1.0
References: <20211013155831.943476-1-qperret@google.com>
X-Mailer: git-send-email 2.33.0.882.g93a45727a2-goog
Subject: [PATCH 04/16] KVM: arm64: Introduce kvm_share_hyp()
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

The create_hyp_mappings() function can currently be called at any point
in time. However, its behaviour in protected mode changes widely
depending on when it is being called. Prior to KVM init, it is used to
create the temporary page-table used to bring-up the hypervisor, and
later on it is transparently turned into a 'share' hypercall when the
kernel has lost control over the hypervisor stage-1. In order to prepare
the ground for also unsharing pages with the hypervisor during guest
teardown, introduce a kvm_share_hyp() function to make it clear in which
places a share hypercall should be expected, as we will soon need a
matching unshare hypercall in all those places.

Signed-off-by: Quentin Perret <qperret@google.com>
---
 arch/arm64/include/asm/kvm_mmu.h |  1 +
 arch/arm64/kvm/arm.c             |  7 +++----
 arch/arm64/kvm/fpsimd.c          |  4 ++--
 arch/arm64/kvm/mmu.c             | 19 +++++++++++++------
 4 files changed, 19 insertions(+), 12 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_mmu.h b/arch/arm64/include/asm/kvm_mmu.h
index 02d378887743..185d0f62b724 100644
--- a/arch/arm64/include/asm/kvm_mmu.h
+++ b/arch/arm64/include/asm/kvm_mmu.h
@@ -150,6 +150,7 @@ static __always_inline unsigned long __kern_hyp_va(unsigned long v)
 #include <asm/kvm_pgtable.h>
 #include <asm/stage2_pgtable.h>
 
+int kvm_share_hyp(void *from, void *to);
 int create_hyp_mappings(void *from, void *to, enum kvm_pgtable_prot prot);
 int create_hyp_io_mappings(phys_addr_t phys_addr, size_t size,
 			   void __iomem **kaddr,
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index c33d8c073820..f2e74635332b 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -146,7 +146,7 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
 	if (ret)
 		return ret;
 
-	ret = create_hyp_mappings(kvm, kvm + 1, PAGE_HYP);
+	ret = kvm_share_hyp(kvm, kvm + 1);
 	if (ret)
 		goto out_free_stage2_pgd;
 
@@ -341,7 +341,7 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
 	if (err)
 		return err;
 
-	return create_hyp_mappings(vcpu, vcpu + 1, PAGE_HYP);
+	return kvm_share_hyp(vcpu, vcpu + 1);
 }
 
 void kvm_arch_vcpu_postcreate(struct kvm_vcpu *vcpu)
@@ -623,8 +623,7 @@ static int kvm_vcpu_first_run_init(struct kvm_vcpu *vcpu)
 
 		sve_end = vcpu->arch.sve_state + vcpu_sve_state_size(vcpu);
 
-		ret = create_hyp_mappings(vcpu->arch.sve_state, sve_end,
-					  PAGE_HYP);
+		ret = kvm_share_hyp(vcpu->arch.sve_state, sve_end);
 		if (ret)
 			return ret;
 	}
diff --git a/arch/arm64/kvm/fpsimd.c b/arch/arm64/kvm/fpsimd.c
index 62c0d78da7be..2fe1128d9f3d 100644
--- a/arch/arm64/kvm/fpsimd.c
+++ b/arch/arm64/kvm/fpsimd.c
@@ -35,11 +35,11 @@ int kvm_arch_vcpu_run_map_fp(struct kvm_vcpu *vcpu)
 	 * Make sure the host task thread flags and fpsimd state are
 	 * visible to hyp:
 	 */
-	ret = create_hyp_mappings(ti, ti + 1, PAGE_HYP);
+	ret = kvm_share_hyp(ti, ti + 1);
 	if (ret)
 		goto error;
 
-	ret = create_hyp_mappings(fpsimd, fpsimd + 1, PAGE_HYP);
+	ret = kvm_share_hyp(fpsimd, fpsimd + 1);
 	if (ret)
 		goto error;
 
diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 1a94a7ca48f2..f80673e863ac 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -296,6 +296,17 @@ static int pkvm_share_hyp(phys_addr_t start, phys_addr_t end)
 	return 0;
 }
 
+int kvm_share_hyp(void *from, void *to)
+{
+	if (is_kernel_in_hyp_mode())
+		return 0;
+
+	if (kvm_host_owns_hyp_mappings())
+		return create_hyp_mappings(from, to, PAGE_HYP);
+
+	return pkvm_share_hyp(kvm_kaddr_to_phys(from), kvm_kaddr_to_phys(to));
+}
+
 /**
  * create_hyp_mappings - duplicate a kernel virtual address range in Hyp mode
  * @from:	The virtual kernel start address of the range
@@ -316,12 +327,8 @@ int create_hyp_mappings(void *from, void *to, enum kvm_pgtable_prot prot)
 	if (is_kernel_in_hyp_mode())
 		return 0;
 
-	if (!kvm_host_owns_hyp_mappings()) {
-		if (WARN_ON(prot != PAGE_HYP))
-			return -EPERM;
-		return pkvm_share_hyp(kvm_kaddr_to_phys(from),
-				      kvm_kaddr_to_phys(to));
-	}
+	if (WARN_ON(!kvm_host_owns_hyp_mappings()))
+		return -EPERM;
 
 	start = start & PAGE_MASK;
 	end = PAGE_ALIGN(end);
-- 
2.33.0.882.g93a45727a2-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
