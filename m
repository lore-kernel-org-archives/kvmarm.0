Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 66873C433F5
	for <kvmarm@archiver.kernel.org>; Wed,  1 Dec 2021 17:04:47 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1EAA34B264;
	Wed,  1 Dec 2021 12:04:47 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 0YVFcPAgPPWk; Wed,  1 Dec 2021 12:04:45 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E24C74B204;
	Wed,  1 Dec 2021 12:04:45 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5D47D4B21E
 for <kvmarm@lists.cs.columbia.edu>; Wed,  1 Dec 2021 12:04:44 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Egu6z6gxtDQW for <kvmarm@lists.cs.columbia.edu>;
 Wed,  1 Dec 2021 12:04:43 -0500 (EST)
Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com
 [209.85.128.74])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 641BE4B204
 for <kvmarm@lists.cs.columbia.edu>; Wed,  1 Dec 2021 12:04:42 -0500 (EST)
Received: by mail-wm1-f74.google.com with SMTP id
 l4-20020a05600c1d0400b00332f47a0fa3so1192883wms.8
 for <kvmarm@lists.cs.columbia.edu>; Wed, 01 Dec 2021 09:04:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=NJuegLyFty4h+k4BvUryfHfsyVJ26LHh21kFNoYVPms=;
 b=pjEZYfEFH2f9DZZLkJPc+DJKonqmGOFU+/IndvDwaAD0Mc38KaGhN+e2+ThY9Xkoie
 LyXXIL01+VTsQKZGzSG7BqPQx8sGPd7M0yPwve2btEpLEMaXtEoXnnm461+DFbQ1JuSF
 hVKeslduzUKxJvDgBe+SxkbHjOmG/IPTUQcWOBwoZm9RXnnQTefZq8EKI/qpAGZte/ig
 lFFXkNlytDGtJUhJPWkYUsGKCHLOFSLpEsdcuwsG6GsTNDLC1cXDgdJHgOrcZKjbIFVC
 5UvpJAycHv+RaqfhaI2HTgGTD/ahlaWvkRYDC9DdisOszJzGcDRE3EN9f/dfRsXCxmde
 DbRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=NJuegLyFty4h+k4BvUryfHfsyVJ26LHh21kFNoYVPms=;
 b=TzdbNmdXscU9eQaxX49hHT6TS0KbHj8O3BpvCwZG+7K5iUEZa+NZIHdNGR4XPGeeW/
 lM6iMw6Nb3Ksr86wSy9DP3HxsIEiVBl5OHnzup1GOmmCJJq1ecbrA5TCmEGALakacJPV
 YIPMpH/a2qgKK9N5Of12z6aDdiWN3MrXKJnF1UaReDy+wRaFNon4DhhAGFIrEnJ5T94z
 DRfI2QL/dg5LDYdq+CVFyckU1kE2e8THkNJJb9jjlZ5uyCH5ExPJdBFkOVpATfe3C+EW
 Qhd7+x+lAVvo3KZOX7zjXrbGHWgqjzGsiqZHqFdfaFeUfxF0GGfcJDzRjVxaJ+EJhOsZ
 nCpg==
X-Gm-Message-State: AOAM532KUX38vwGq1msRFLPw7nLO4Fn+GayJLE9ydKJERxeZqSWWoSkO
 No8IcjjIdhc7d+/mf9yzTRoUiZHo59zv
X-Google-Smtp-Source: ABdhPJxCJlvPNxfX1Vbthcz7eOfsb4kNC+DIdOG4XHH/CTzEgT2hYZqSk1komsbwuqasr1MGCR4/qh/O+mWH
X-Received: from luke.lon.corp.google.com
 ([2a00:79e0:d:210:1cab:1a20:2ef1:ddde])
 (user=qperret job=sendgmr) by 2002:a1c:a592:: with SMTP id
 o140mr8609740wme.10.1638378281534; Wed, 01 Dec 2021 09:04:41 -0800 (PST)
Date: Wed,  1 Dec 2021 17:04:01 +0000
In-Reply-To: <20211201170411.1561936-1-qperret@google.com>
Message-Id: <20211201170411.1561936-8-qperret@google.com>
Mime-Version: 1.0
References: <20211201170411.1561936-1-qperret@google.com>
X-Mailer: git-send-email 2.34.0.rc2.393.gf8c9666880-goog
Subject: [PATCH v3 07/15] KVM: arm64: Introduce kvm_share_hyp()
From: Quentin Perret <qperret@google.com>
To: Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>, 
 Alexandru Elisei <alexandru.elisei@arm.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>, 
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>
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
 arch/arm64/kvm/arm.c             |  4 ++--
 arch/arm64/kvm/fpsimd.c          |  2 +-
 arch/arm64/kvm/mmu.c             | 27 +++++++++++++++++++++------
 arch/arm64/kvm/reset.c           |  2 +-
 5 files changed, 26 insertions(+), 10 deletions(-)

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
index 9b745d2bc89a..c202abb448b1 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -146,7 +146,7 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
 	if (ret)
 		return ret;
 
-	ret = create_hyp_mappings(kvm, kvm + 1, PAGE_HYP);
+	ret = kvm_share_hyp(kvm, kvm + 1);
 	if (ret)
 		goto out_free_stage2_pgd;
 
@@ -342,7 +342,7 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
 	if (err)
 		return err;
 
-	return create_hyp_mappings(vcpu, vcpu + 1, PAGE_HYP);
+	return kvm_share_hyp(vcpu, vcpu + 1);
 }
 
 void kvm_arch_vcpu_postcreate(struct kvm_vcpu *vcpu)
diff --git a/arch/arm64/kvm/fpsimd.c b/arch/arm64/kvm/fpsimd.c
index 5526d79c7b47..86899d3aa9a9 100644
--- a/arch/arm64/kvm/fpsimd.c
+++ b/arch/arm64/kvm/fpsimd.c
@@ -30,7 +30,7 @@ int kvm_arch_vcpu_run_map_fp(struct kvm_vcpu *vcpu)
 	struct user_fpsimd_state *fpsimd = &current->thread.uw.fpsimd_state;
 
 	/* Make sure the host task fpsimd state is visible to hyp: */
-	ret = create_hyp_mappings(fpsimd, fpsimd + 1, PAGE_HYP);
+	ret = kvm_share_hyp(fpsimd, fpsimd + 1);
 	if (!ret)
 		vcpu->arch.host_fpsimd_state = kern_hyp_va(fpsimd);
 
diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index f8f1096a297f..fd868fb9d922 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -299,6 +299,25 @@ static int pkvm_share_hyp(phys_addr_t start, phys_addr_t end)
 	return 0;
 }
 
+int kvm_share_hyp(void *from, void *to)
+{
+	if (is_kernel_in_hyp_mode())
+		return 0;
+
+	/*
+	 * The share hcall maps things in the 'fixed-offset' region of the hyp
+	 * VA space, so we can only share physically contiguous data-structures
+	 * for now.
+	 */
+	if (is_vmalloc_addr(from) || is_vmalloc_addr(to))
+		return -EINVAL;
+
+	if (kvm_host_owns_hyp_mappings())
+		return create_hyp_mappings(from, to, PAGE_HYP);
+
+	return pkvm_share_hyp(__pa(from), __pa(to));
+}
+
 /**
  * create_hyp_mappings - duplicate a kernel virtual address range in Hyp mode
  * @from:	The virtual kernel start address of the range
@@ -319,12 +338,8 @@ int create_hyp_mappings(void *from, void *to, enum kvm_pgtable_prot prot)
 	if (is_kernel_in_hyp_mode())
 		return 0;
 
-	if (!kvm_host_owns_hyp_mappings()) {
-		if (WARN_ON(prot != PAGE_HYP))
-			return -EPERM;
-		return pkvm_share_hyp(kvm_kaddr_to_phys(from),
-				      kvm_kaddr_to_phys(to));
-	}
+	if (!kvm_host_owns_hyp_mappings())
+		return -EPERM;
 
 	start = start & PAGE_MASK;
 	end = PAGE_ALIGN(end);
diff --git a/arch/arm64/kvm/reset.c b/arch/arm64/kvm/reset.c
index c7a0249df840..e3e2a79fbd75 100644
--- a/arch/arm64/kvm/reset.c
+++ b/arch/arm64/kvm/reset.c
@@ -113,7 +113,7 @@ static int kvm_vcpu_finalize_sve(struct kvm_vcpu *vcpu)
 	if (!buf)
 		return -ENOMEM;
 
-	ret = create_hyp_mappings(buf, buf + reg_sz, PAGE_HYP);
+	ret = kvm_share_hyp(buf, buf + reg_sz);
 	if (ret) {
 		kfree(buf);
 		return ret;
-- 
2.34.0.rc2.393.gf8c9666880-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
