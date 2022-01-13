Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6787C433EF
	for <kvmarm@archiver.kernel.org>; Thu, 13 Jan 2022 22:18:46 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 76FAA4B183;
	Thu, 13 Jan 2022 17:18:46 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id GEklDxa5QdpG; Thu, 13 Jan 2022 17:18:45 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 518BF4B131;
	Thu, 13 Jan 2022 17:18:45 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6FB214B17B
 for <kvmarm@lists.cs.columbia.edu>; Thu, 13 Jan 2022 17:18:44 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id q+Gr22vEBJap for <kvmarm@lists.cs.columbia.edu>;
 Thu, 13 Jan 2022 17:18:43 -0500 (EST)
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com
 [209.85.215.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 388934B106
 for <kvmarm@lists.cs.columbia.edu>; Thu, 13 Jan 2022 17:18:42 -0500 (EST)
Received: by mail-pg1-f201.google.com with SMTP id
 j37-20020a634a65000000b00349a11dc809so673380pgl.3
 for <kvmarm@lists.cs.columbia.edu>; Thu, 13 Jan 2022 14:18:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=pwLxSdkuKZYpy4IRCx6ewNb1syHurmpU9IGNHdDfbA0=;
 b=rD/769dvm1H1BTBbwgghKhX4b92nzIRCaIKmcrnh4WzVQqJEJBcWRfps+7N2g3HS+x
 Hy6ldB/NJYp0mPLSelkO9odPUHLDQ4ezsgpdKG8ybPdGy+ImlE1nHVSVm5KK6N/hkZgI
 WhAomOtbRIW3OHpMw+aTJfyEJ8cPRkCkBWSOyVG3mVbCfSc9HeIbdCWfgQRdtUuEqLOu
 Pbf+E3VJebX0n1aj2hyLkZhd3hNnhS/HnpsI1LP0SQOFNSlugXkWSTE2nxjhl+m39/lY
 eg0xg55XHbxkeHCrqbXOA7mW/d6QDD2WjXELdxPvN27vD5d4wJMjlwzJNcYSeHT5O9wL
 W4jg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=pwLxSdkuKZYpy4IRCx6ewNb1syHurmpU9IGNHdDfbA0=;
 b=IYS9wj4dOdiBbyVv/+ubuz0IqBl0Gv8pmwiBP0ITLt0fJ1Vlliz3HjKNMmnXgzGfrg
 gMPRjNonz+R4L5Y7UmMbyF5OeJbDsANJUXDRaK5jb9D6C83rXFBRkdTb/Qz3+OfuIZCK
 hPANkQvAybkljGiSvqehACcAGdxnZpqOYc1P2zYFGJ4CzUe3QMqiovZy3NNeK3ve+oNV
 yHkeVLPE7SRAXghWK1vV7elmo+oYY+zacEC+a/txIXtjT/gub3s2oUy10bWCMZ1XvXze
 P5nWaVON9gKYO/E8tjKmMr1f+t0G9iY2XoxXkZLHrU64+aDTSvhLxBjesEmkA5bSGkty
 kOzA==
X-Gm-Message-State: AOAM532bYT3Nglqa3kGBUkvTLUWtg5AjGcvqcXFT2yRtT8D0Op4nGpKG
 jrptcbYdPNJnwz7UufNhNyBhcT3vkv44yZ5SDg==
X-Google-Smtp-Source: ABdhPJwsvrCgSfYRR7e1YNmhGpuBRd1yPxOOJCRdr2s7Im0Et+POYfDI17crL/39sHPbnMnwBxTx4LLYYBN8+iJeMg==
X-Received: from jgzg.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1acf])
 (user=jingzhangos job=sendgmr) by
 2002:a17:902:c102:b0:14a:8aef:8897 with
 SMTP id 2-20020a170902c10200b0014a8aef8897mr2252771pli.155.1642112321293;
 Thu, 13 Jan 2022 14:18:41 -0800 (PST)
Date: Thu, 13 Jan 2022 22:18:28 +0000
In-Reply-To: <20220113221829.2785604-1-jingzhangos@google.com>
Message-Id: <20220113221829.2785604-3-jingzhangos@google.com>
Mime-Version: 1.0
References: <20220113221829.2785604-1-jingzhangos@google.com>
X-Mailer: git-send-email 2.34.1.703.g22d0c6ccf7-goog
Subject: [PATCH v1 2/3] KVM: arm64: Add fast path to handle permission
 relaxation during dirty logging
From: Jing Zhang <jingzhangos@google.com>
To: KVM <kvm@vger.kernel.org>, KVMARM <kvmarm@lists.cs.columbia.edu>, 
 Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>,
 Paolo Bonzini <pbonzini@redhat.com>, 
 David Matlack <dmatlack@google.com>, Oliver Upton <oupton@google.com>, 
 Reiji Watanabe <reijiw@google.com>, Ricardo Koller <ricarkol@google.com>, 
 Raghavendra Rao Ananta <rananta@google.com>
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

To reduce MMU lock contention during dirty logging, all permission
relaxation operations would be performed under read lock.

Signed-off-by: Jing Zhang <jingzhangos@google.com>
---
 arch/arm64/kvm/mmu.c | 20 ++++++++++++++++++--
 1 file changed, 18 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index cafd5813c949..15393cb61a3f 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1084,6 +1084,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 	unsigned long vma_pagesize, fault_granule;
 	enum kvm_pgtable_prot prot = KVM_PGTABLE_PROT_R;
 	struct kvm_pgtable *pgt;
+	bool use_mmu_readlock = false;
 
 	fault_granule = 1UL << ARM64_HW_PGTABLE_LEVEL_SHIFT(fault_level);
 	write_fault = kvm_is_write_fault(vcpu);
@@ -1212,7 +1213,19 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 	if (exec_fault && device)
 		return -ENOEXEC;
 
-	write_lock(&kvm->mmu_lock);
+	if (fault_status == FSC_PERM && fault_granule == PAGE_SIZE
+				     && logging_active && write_fault)
+		use_mmu_readlock = true;
+	/*
+	 * To reduce MMU contentions and enhance concurrency during dirty
+	 * logging dirty logging, only acquire read lock for permission
+	 * relaxation. This fast path would greatly reduce the performance
+	 * degradation of guest workloads.
+	 */
+	if (use_mmu_readlock)
+		read_lock(&kvm->mmu_lock);
+	else
+		write_lock(&kvm->mmu_lock);
 	pgt = vcpu->arch.hw_mmu->pgt;
 	if (mmu_notifier_retry(kvm, mmu_seq))
 		goto out_unlock;
@@ -1271,7 +1284,10 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 	}
 
 out_unlock:
-	write_unlock(&kvm->mmu_lock);
+	if (use_mmu_readlock)
+		read_unlock(&kvm->mmu_lock);
+	else
+		write_unlock(&kvm->mmu_lock);
 	kvm_set_pfn_accessed(pfn);
 	kvm_release_pfn_clean(pfn);
 	return ret != -EAGAIN ? ret : 0;
-- 
2.34.1.703.g22d0c6ccf7-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
