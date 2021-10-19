Return-Path: <SRS0=DvdR=PH=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4DAC1C433EF
	for <kvmarm@archiver.kernel.org>; Tue, 19 Oct 2021 12:13:28 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id F01376137D
	for <kvmarm@archiver.kernel.org>; Tue, 19 Oct 2021 12:13:27 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org F01376137D
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A1CB44B128;
	Tue, 19 Oct 2021 08:13:27 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id ktNvDlZ4yCw7; Tue, 19 Oct 2021 08:13:26 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7FABC4B1B2;
	Tue, 19 Oct 2021 08:13:26 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 33CE54B0CC
 for <kvmarm@lists.cs.columbia.edu>; Tue, 19 Oct 2021 08:13:25 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 6d0NaDIhaVWJ for <kvmarm@lists.cs.columbia.edu>;
 Tue, 19 Oct 2021 08:13:24 -0400 (EDT)
Received: from mail-wr1-f73.google.com (mail-wr1-f73.google.com
 [209.85.221.73])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 1B4E84B0DD
 for <kvmarm@lists.cs.columbia.edu>; Tue, 19 Oct 2021 08:13:24 -0400 (EDT)
Received: by mail-wr1-f73.google.com with SMTP id
 41-20020adf812c000000b00160dfbfe1a2so10117726wrm.3
 for <kvmarm@lists.cs.columbia.edu>; Tue, 19 Oct 2021 05:13:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=ty9iYiagMI0gH20pET1Xndb3iV+CDb06dji5ebe9K8w=;
 b=SpQpP/yRjdUQxoyHPN7C8cqP88mZaVeLPJ8bNLz3pg1pqcyqLiVJsbc0K2Vjc2jhuQ
 2PGXAA+SI+BFXG8WCVUEkCOMHE+olMIAfl/O7rw9/CpMKQ3ycyZbyiqIcqOGev1xjX0N
 PEgg90LPzx39+XnWldfpg31ucLbcIg1wmtCGmYpSObuVrI1qzD3SzeruVAF1hfcCy/+8
 Ij2iODxEL4liU9qZb81s8tlJZ9rIM548MRcoLUE2LPbZmNK/kzfgWJDQYll1z/vSSj11
 aZZZauk73uQCoiVzVIT69awzlL+qtPyGpzwKXNXuMBJn77bMEeYOM1FBhCrmd0l57ide
 dvEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=ty9iYiagMI0gH20pET1Xndb3iV+CDb06dji5ebe9K8w=;
 b=HF+J5REN3WmAbbEXd7uRVe4vMjNpCvMAxVFaxCAiCcYt8t470NncUt6efqV5GmLnfH
 iTZgIMwZpSUYNIOmr7VzkI1NtDuKXY9YG217+OPLcA84/raLoa8Z59y+RH8XOqjux5y2
 WoCDCsyPR1XNoUvBAh5hJlkegB6IV72Otz/fRtiuh+ZkUYJHbkEED3KDiGr1sgsbON2U
 VtoTO3bd3i7aobRjTRUKkMjUsxj8kJWnNcdJGgvJWjqpICF2hQhUx+20ID+qiDDl9k1G
 taOnmntNHJh2dGQJysKoOcQwFKzgtnOa9QYg4m3OGxakoWcMrnCSJjX9xV1hibNgJx/4
 4Ppg==
X-Gm-Message-State: AOAM533H7Eemi7erZOO/vRJUKhUlQ93hdJEm1/7HIdUAfp4qat7BTjJR
 tpIavBXrNoRJiQxOCGXlv759mCK4gktr
X-Google-Smtp-Source: ABdhPJwYQAu9x65aeAB6QkD0CZV58F2ousV/0NfyOsnnHv4pwVmmNZyY52hWDmpVRmvp0zkLy2sxMRWr0PHi
X-Received: from luke.lon.corp.google.com
 ([2a00:79e0:d:210:59ca:401f:83a8:de6d])
 (user=qperret job=sendgmr) by 2002:a7b:c442:: with SMTP id
 l2mr5662234wmi.131.1634645603276; Tue, 19 Oct 2021 05:13:23 -0700 (PDT)
Date: Tue, 19 Oct 2021 13:12:56 +0100
In-Reply-To: <20211019121304.2732332-1-qperret@google.com>
Message-Id: <20211019121304.2732332-8-qperret@google.com>
Mime-Version: 1.0
References: <20211019121304.2732332-1-qperret@google.com>
X-Mailer: git-send-email 2.33.0.1079.g6e70778dc9-goog
Subject: [PATCH v2 07/15] KVM: arm64: Introduce kvm_share_hyp()
From: Quentin Perret <qperret@google.com>
To: Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>, 
 Alexandru Elisei <alexandru.elisei@arm.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>, 
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Fuad Tabba <tabba@google.com>, 
 David Brazdil <dbrazdil@google.com>, Andrew Walbran <qwandor@google.com>
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
 arch/arm64/kvm/fpsimd.c          |  4 ++--
 arch/arm64/kvm/mmu.c             | 19 +++++++++++++------
 arch/arm64/kvm/reset.c           |  2 +-
 5 files changed, 19 insertions(+), 11 deletions(-)

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
index e1cc3f8560e7..5312d5a2ef69 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -146,7 +146,7 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
 	if (ret)
 		return ret;
 
-	ret = create_hyp_mappings(kvm, kvm + 1, PAGE_HYP);
+	ret = kvm_share_hyp(kvm, kvm + 1);
 	if (ret)
 		goto out_free_stage2_pgd;
 
@@ -343,7 +343,7 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
 	if (err)
 		return err;
 
-	return create_hyp_mappings(vcpu, vcpu + 1, PAGE_HYP);
+	return kvm_share_hyp(vcpu, vcpu + 1);
 }
 
 void kvm_arch_vcpu_postcreate(struct kvm_vcpu *vcpu)
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
index 0019b2309f70..0cc4b295e525 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -299,6 +299,17 @@ static int pkvm_share_hyp(phys_addr_t start, phys_addr_t end)
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
@@ -319,12 +330,8 @@ int create_hyp_mappings(void *from, void *to, enum kvm_pgtable_prot prot)
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
index 59e4c6e819e9..cf781ec9212a 100644
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
2.33.0.1079.g6e70778dc9-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
