Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B06A87464
	for <kvmarm@lists.linux.dev>; Thu,  8 Jun 2023 22:06:38 +0000 (UTC)
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-25b79a5cf1aso78041a91.1
        for <kvmarm@lists.linux.dev>; Thu, 08 Jun 2023 15:06:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1686261998; x=1688853998;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=RLQAgYf8iBGNcj/RlWRJvdUP+LxzH+dVMP3y494+MG8=;
        b=72g9XyvqNGl3FxCZJSPlIuUxU5j0nK1HOJfxv5zdttIag4OsGbA87NgmE6evU200aS
         4DeqlItOIFsRMQ0edVVbXcJf6DzFv2YfutUisx2LuTPTVA7nkNWNd5uyttawNDTMrcGh
         wy65xqip1IhcVJ1CnkO3owJTaAfIhnrbD/WmfkrkSvNHld5eVlw3JgQjF0dtForqQaft
         bf5ROB4NASeWT8BrFaGbfxa5tS47+fie27CsKyFSPuMmPmwHfqEU/oAUA0hQT83Mec+T
         ojDgJK5GXHFV3Wjt7xLmT9aSemT69PEeoJdWthHnRlCut4YNMpKcxaM3Zu2FsJzZT0ix
         A6Zw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686261998; x=1688853998;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=RLQAgYf8iBGNcj/RlWRJvdUP+LxzH+dVMP3y494+MG8=;
        b=Yiwg5DbKzPdDV6zkpfEqfNdw+Fk9Tgqy8Cgat0FmhYu8IDPTKIWGOfg7nxAxiCScFO
         eFurFJjdnRChBrX7rs0WUorTOFBrbugdRY1a1pYtuiDjLmoR+PBZdOx/48qssHi7hUDC
         YoiIyaJZdbe+kFCO8JkD+maArk3TbalF1gLawhbhmx3o9+1sBL5H/3+Cu/n8ooVCC31x
         Y83yX/VaXlOSodgCkKm5Jy2xqjHL+bMcOget+bR58rFTX6WJaQNCVVq2ViC+q4T/Q4FH
         /+PYSMRLouRIxtP1tU+f6DJdUBUtNn65aHOJxOrzMK60LgyOF3MPRbGT86eDKGULuMya
         2brw==
X-Gm-Message-State: AC+VfDwLeqhQoeI/fCXH4pEbdnDaRyj/9hkJeI6zt6XX4dx/m3AyrBH+
	DO1Z9eqFX1de9kv220pS2XwhGfkMyWM=
X-Google-Smtp-Source: ACHHUZ4BB7wc/3PLgyJlfh6FiXwuAOEqUsspFVK4qOkYedUMSsY2SeUi7aLElhIVZxfm8OeC1VsqR/loduM=
X-Received: from colette.c.googlers.com ([fda3:e722:ac3:cc00:24:72f4:c0a8:5cff])
 (user=ctshao job=sendgmr) by 2002:a17:90a:7886:b0:253:4800:438b with SMTP id
 x6-20020a17090a788600b002534800438bmr786194pjk.2.1686261997920; Thu, 08 Jun
 2023 15:06:37 -0700 (PDT)
Date: Thu,  8 Jun 2023 15:05:41 -0700
In-Reply-To: <20230608220558.39094-1-ctshao@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230608220558.39094-1-ctshao@google.com>
X-Mailer: git-send-email 2.41.0.162.gfafddb0af9-goog
Message-ID: <20230608220558.39094-4-ctshao@google.com>
Subject: [PATCH v1 3/3] KVM: arm64: Using rcu_read_lock() for kvm_pgtable_stage2_mkyoung()
From: Chun-Tse Shao <ctshao@google.com>
To: linux-kernel@vger.kernel.org, yuzhao@google.com, oliver.upton@linux.dev
Cc: Chun-Tse Shao <ctshao@google.com>, Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
	Ben Gardon <bgardon@google.com>, Gavin Shan <gshan@redhat.com>, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

Access bit is RCU safe and can be set without taking kvm->mmu_lock().
Replacing existing kvm->mmu_lock() with rcu_read_lock() for better
performance.

Original disussion can be found in:
https://lore.kernel.org/kvmarm/CAOUHufZrfnfcbrqSzmHkejR5MA2gmGKZ3LMRhbLHV+1427z=Tw@mail.gmail.com/

Suggested-by: Yu Zhao <yuzhao@google.com>
Signed-off-by: Chun-Tse Shao <ctshao@google.com>
---
 arch/arm64/kvm/mmu.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 3b9d4d24c361..0f7ea66fb894 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1437,10 +1437,10 @@ static void handle_access_fault(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa)
 
 	trace_kvm_access_fault(fault_ipa);
 
-	read_lock(&vcpu->kvm->mmu_lock);
+	rcu_read_lock();
 	mmu = vcpu->arch.hw_mmu;
 	pte = kvm_pgtable_stage2_mkyoung(mmu->pgt, fault_ipa);
-	read_unlock(&vcpu->kvm->mmu_lock);
+	rcu_read_unlock();
 
 	if (kvm_pte_valid(pte))
 		kvm_set_pfn_accessed(kvm_pte_to_pfn(pte));
-- 
2.41.0.162.gfafddb0af9-goog

