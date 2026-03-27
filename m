Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20792383C90;
	Fri, 27 Mar 2026 11:36:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774611387; cv=none; b=XJZHxIMzN6V/IRzqXH3R/cg6eg37MuELmBMMQXRXmC+DVD6xkYjKi66G/dWtTS7G+AqRdyztpMoeBZELCEKsQexDp6Md/Km5pEGqA0W9XjG5HaTVrZTd5Gqc94kFEgLVLJe76yrSUMbTpIUoI+Xf9DHHx14f6P5ceEssrJ0NCgI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774611387; c=relaxed/simple;
	bh=N9bhiVx5Vh1CUIB4IHblaqgBEI4KzyxLhqGgwc8mT8U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TRZGQGchy8P9pO+1jwHGO3hwzBKUbRYiPRUTgx97TtLmRKPhJFTypPKhz+IwfTCkqG6fN2p+hXskO/gueCb1vYfkFhM7j1tTqpvTDyi6TUl1S/ViCAheVnS+3P4Lq7DvO0+Vo1JyDDyO+++DTLntb61mQKiwKMOiMeCZ/O2mEso=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZXcZJB+f; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZXcZJB+f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D42BBC19423;
	Fri, 27 Mar 2026 11:36:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774611386;
	bh=N9bhiVx5Vh1CUIB4IHblaqgBEI4KzyxLhqGgwc8mT8U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZXcZJB+fmHnNctN4JagniqSKrNn0NZ+FF4d2/PMUsVXHYe5ozVi1Vs6wDCbhkMWVl
	 kbtsBMwriXE8+iqnod94kKQkkDBVidwwEVKZcZ4hI4MrVEg4e+awoETdz8J3zNhWZ4
	 jUCKaCTeno52ao89BJn2QEn75PidrxH8ZDQtZyO/KVhspUdROjDEry0V3FvSHUaM//
	 DR6stROoc8egaC8wuX45Sxu8jE+suyLZlCYKjg/jxRWbnyr/LVNDORgcwGNy4vktIs
	 MOOMECQw3PCmkSSSDiTQlcf3OcNMrRBR0GR08ZosciOpZgKGGTX2eYWtihYX+zpLG7
	 M+5v6BFhqS9Xg==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1w65UG-00000006K4a-4Adm;
	Fri, 27 Mar 2026 11:36:25 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oupton@kernel.org>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Fuad Tabba <tabba@google.com>,
	Will Deacon <will@kernel.org>,
	Quentin Perret <qperret@google.com>
Subject: [PATCH v2 12/30] KVM: arm64: Hoist MTE validation check out of MMU lock path
Date: Fri, 27 Mar 2026 11:36:00 +0000
Message-ID: <20260327113618.4051534-13-maz@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260327113618.4051534-1-maz@kernel.org>
References: <20260327113618.4051534-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oupton@kernel.org, yuzenghui@huawei.com, tabba@google.com, will@kernel.org, qperret@google.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

From: Fuad Tabba <tabba@google.com>

Simplify the non-cacheable attributes assignment by using a ternary
operator. Additionally, hoist the MTE validation check (mte_allowed) out
of kvm_s2_fault_map() and into kvm_s2_fault_compute_prot(). This allows
us to fail faster and avoid acquiring the KVM MMU lock unnecessarily
when the VMM introduces a disallowed VMA for an MTE-enabled guest.

Signed-off-by: Fuad Tabba <tabba@google.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/mmu.c | 28 ++++++++++++----------------
 1 file changed, 12 insertions(+), 16 deletions(-)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 0c71e3a9af8b0..ee2a548999b1b 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1870,18 +1870,21 @@ static int kvm_s2_fault_compute_prot(struct kvm_s2_fault *fault)
 	if (fault->exec_fault)
 		fault->prot |= KVM_PGTABLE_PROT_X;
 
-	if (fault->s2_force_noncacheable) {
-		if (fault->vm_flags & VM_ALLOW_ANY_UNCACHED)
-			fault->prot |= KVM_PGTABLE_PROT_NORMAL_NC;
-		else
-			fault->prot |= KVM_PGTABLE_PROT_DEVICE;
-	} else if (cpus_have_final_cap(ARM64_HAS_CACHE_DIC)) {
+	if (fault->s2_force_noncacheable)
+		fault->prot |= (fault->vm_flags & VM_ALLOW_ANY_UNCACHED) ?
+			       KVM_PGTABLE_PROT_NORMAL_NC : KVM_PGTABLE_PROT_DEVICE;
+	else if (cpus_have_final_cap(ARM64_HAS_CACHE_DIC))
 		fault->prot |= KVM_PGTABLE_PROT_X;
-	}
 
 	if (fault->nested)
 		adjust_nested_exec_perms(kvm, fault->nested, &fault->prot);
 
+	if (!fault->fault_is_perm && !fault->s2_force_noncacheable && kvm_has_mte(kvm)) {
+		/* Check the VMM hasn't introduced a new disallowed VMA */
+		if (!fault->mte_allowed)
+			return -EFAULT;
+	}
+
 	return 0;
 }
 
@@ -1918,15 +1921,8 @@ static int kvm_s2_fault_map(struct kvm_s2_fault *fault, void *memcache)
 		}
 	}
 
-	if (!fault->fault_is_perm && !fault->s2_force_noncacheable && kvm_has_mte(kvm)) {
-		/* Check the VMM hasn't introduced a new disallowed VMA */
-		if (fault->mte_allowed) {
-			sanitise_mte_tags(kvm, fault->pfn, fault->vma_pagesize);
-		} else {
-			ret = -EFAULT;
-			goto out_unlock;
-		}
-	}
+	if (!fault->fault_is_perm && !fault->s2_force_noncacheable && kvm_has_mte(kvm))
+		sanitise_mte_tags(kvm, fault->pfn, fault->vma_pagesize);
 
 	/*
 	 * Under the premise of getting a FSC_PERM fault, we just need to relax
-- 
2.47.3

