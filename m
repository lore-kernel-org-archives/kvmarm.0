Received: from mail-ed1-f74.google.com (mail-ed1-f74.google.com [209.85.208.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BFAB20C00D
	for <kvmarm@lists.linux.dev>; Mon, 16 Dec 2024 17:58:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734371901; cv=none; b=Z3vJONv90CV62ogkgR1Gw9cMMoO72m3XZ8wli0QqGJGriUwrnc546TmrTS6MDu6lLJwu5dpqPs/tkgMyn7yVcm6NJNUiKlfx0HW1tHyLCjSjKFMIeqTwF0+aZUMrE/4zlC479Ax1qDC/coxJMmOi4mEezPm6NKqAyUhwwR6Nims=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734371901; c=relaxed/simple;
	bh=Pu9tKXL90m4hHLgJh+PJUU+2uRo8c/dROvim4hY2yzA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=d0vpymEVmva7kMv5CkvxJ91FyC52lp1xhLcZS2eW3sOPZ16f2f3AxXnjk7lidCkC6CfjB6CsK4TVsT+GJSWaag/t+NLoRvDz7tO9ZBp4ngLjcF8pVr0qVoByjJikVIcsVuzZS0ZQ2e2wcqTax4mZQtsfXyA8/418H1pEeJA+m/s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--qperret.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=MEnaNPnh; arc=none smtp.client-ip=209.85.208.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--qperret.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="MEnaNPnh"
Received: by mail-ed1-f74.google.com with SMTP id 4fb4d7f45d1cf-5d3d2cccbe4so3846335a12.3
        for <kvmarm@lists.linux.dev>; Mon, 16 Dec 2024 09:58:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1734371898; x=1734976698; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=6dFW7RUrUetXxVFNK2ULy2Fjq1gVFLFzwOzuHDurHwY=;
        b=MEnaNPnhoilc/9doiQD+DjCVtqF9/Z6vGYyZ8jE6NJBI0lIAjBgiZAlWwuzQ8cDQBh
         JOZNa/Gah6e94TZTEhcbRg57Eb+oLWvnLwxjgOC9AnjeBVMtrcZ5roUeCklseG9CyXmf
         G0uN5tKlRLCDnAM7TkrQDn+q2+IJPVE01+pP/cyg/l8tfSYHSFAshumYPgZj7+rbn6wq
         3jCLo8+xGa5IL6bBcaqazmbiDxKoX8qG442Lfr6vuA52ASOoshvBUTNeH0RDlc4kFM1i
         WP8d+GrOv+peBpHNT2ukUqeIDBLnbuHg5Gbo2MOxVj6e++emxjqdorSsldhM6H7l/7qc
         y7eQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734371898; x=1734976698;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=6dFW7RUrUetXxVFNK2ULy2Fjq1gVFLFzwOzuHDurHwY=;
        b=vFEV09/SSXdzTmnNJC7WNBBXm+oTl8wHb79mAFJWenYkCE3HG6b3x2ZQgLITzj1XKq
         O58DBod21ljT0C83bF5uTErGD3oRkfGSdKuavkUR6rRbeVQP3Ha/XvF0Q4S3Nh4PXyxC
         5fm1nyQ4xY1tBA+mU4uHxXJl+eigSr4EbT7G/sF0ABLVJwcPQv7Gmi8W11Jqhf6XjjTr
         /Hr44QuxZf8DX16wznfJBX5YWmCRodrh+ZjJ87wTOMJ9DE5Spp9stQAMNvNjVt6VnOle
         yjt2S642mDZGKxjmyyYSdMwvp8FhRCUzb+GISMp4khC5WOqCW7SaCCs4CyrVd6MZ/g+I
         MnyA==
X-Forwarded-Encrypted: i=1; AJvYcCWjRbb0p2H7Bd8tM8DE3Peqh9jTDel50twZC6gyqmMxuDHxJqWTDLRvBLsd92bqRIdxY93fM+U=@lists.linux.dev
X-Gm-Message-State: AOJu0YwQwNobADThtucofUeGxzg4orKBHdo2fI54AUx5sNmrK8dgroEt
	azbIGIuHmuVIxMEY0Ao42ZuU0W0hl81GVIcT2El3JVKLmf7Eir4WxWkEhX7KVmTakqjE1usvMWm
	TyQpMgw==
X-Google-Smtp-Source: AGHT+IGc0SKdQx4fRg/2UZZOEnFM7Ob6WE6YJF9bkeGHxvuSwv02bVDmCemOOlGDIUPuD02qJQBB9v2MqSc7
X-Received: from edxk18.prod.google.com ([2002:a05:6402:12d2:b0:5d0:2300:5be])
 (user=qperret job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6402:3551:b0:5d0:d84c:abb3
 with SMTP id 4fb4d7f45d1cf-5d63c3b1c3bmr12340959a12.26.1734371898142; Mon, 16
 Dec 2024 09:58:18 -0800 (PST)
Date: Mon, 16 Dec 2024 17:57:51 +0000
In-Reply-To: <20241216175803.2716565-1-qperret@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20241216175803.2716565-1-qperret@google.com>
X-Mailer: git-send-email 2.47.1.613.gc27f4b7a9f-goog
Message-ID: <20241216175803.2716565-7-qperret@google.com>
Subject: [PATCH v3 06/18] KVM: arm64: Pass walk flags to kvm_pgtable_stage2_relax_perms
From: Quentin Perret <qperret@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>
Cc: Fuad Tabba <tabba@google.com>, Vincent Donnefort <vdonnefort@google.com>, 
	Sebastian Ene <sebastianene@google.com>, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

kvm_pgtable_stage2_relax_perms currently assumes that it is being called
from a 'shared' walker, which will not be true once called from pKVM. To
allow for the re-use of that function, make the walk flags one of its
parameters.

Signed-off-by: Quentin Perret <qperret@google.com>
---
 arch/arm64/include/asm/kvm_pgtable.h | 4 +++-
 arch/arm64/kvm/hyp/pgtable.c         | 6 ++----
 arch/arm64/kvm/mmu.c                 | 7 +++----
 3 files changed, 8 insertions(+), 9 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/include/asm/kvm_pgtable.h
index 38b7ec1c8614..c2f4149283ef 100644
--- a/arch/arm64/include/asm/kvm_pgtable.h
+++ b/arch/arm64/include/asm/kvm_pgtable.h
@@ -707,6 +707,7 @@ bool kvm_pgtable_stage2_test_clear_young(struct kvm_pgtable *pgt, u64 addr,
  * @pgt:	Page-table structure initialised by kvm_pgtable_stage2_init*().
  * @addr:	Intermediate physical address to identify the page-table entry.
  * @prot:	Additional permissions to grant for the mapping.
+ * @flags:	Flags to control the page-table walk (ex. a shared walk)
  *
  * The offset of @addr within a page is ignored.
  *
@@ -719,7 +720,8 @@ bool kvm_pgtable_stage2_test_clear_young(struct kvm_pgtable *pgt, u64 addr,
  * Return: 0 on success, negative error code on failure.
  */
 int kvm_pgtable_stage2_relax_perms(struct kvm_pgtable *pgt, u64 addr,
-				   enum kvm_pgtable_prot prot);
+				   enum kvm_pgtable_prot prot,
+				   enum kvm_pgtable_walk_flags flags);
 
 /**
  * kvm_pgtable_stage2_flush_range() - Clean and invalidate data cache to Point
diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
index 0470aedb4bf4..b7a3b5363235 100644
--- a/arch/arm64/kvm/hyp/pgtable.c
+++ b/arch/arm64/kvm/hyp/pgtable.c
@@ -1307,7 +1307,7 @@ bool kvm_pgtable_stage2_test_clear_young(struct kvm_pgtable *pgt, u64 addr,
 }
 
 int kvm_pgtable_stage2_relax_perms(struct kvm_pgtable *pgt, u64 addr,
-				   enum kvm_pgtable_prot prot)
+				   enum kvm_pgtable_prot prot, enum kvm_pgtable_walk_flags flags)
 {
 	int ret;
 	s8 level;
@@ -1325,9 +1325,7 @@ int kvm_pgtable_stage2_relax_perms(struct kvm_pgtable *pgt, u64 addr,
 	if (prot & KVM_PGTABLE_PROT_X)
 		clr |= KVM_PTE_LEAF_ATTR_HI_S2_XN;
 
-	ret = stage2_update_leaf_attrs(pgt, addr, 1, set, clr, NULL, &level,
-				       KVM_PGTABLE_WALK_HANDLE_FAULT |
-				       KVM_PGTABLE_WALK_SHARED);
+	ret = stage2_update_leaf_attrs(pgt, addr, 1, set, clr, NULL, &level, flags);
 	if (!ret || ret == -EAGAIN)
 		kvm_call_hyp(__kvm_tlb_flush_vmid_ipa_nsh, pgt->mmu, addr, level);
 	return ret;
diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index a2339b76c826..641e4fec1659 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1452,6 +1452,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 	enum kvm_pgtable_prot prot = KVM_PGTABLE_PROT_R;
 	struct kvm_pgtable *pgt;
 	struct page *page;
+	enum kvm_pgtable_walk_flags flags = KVM_PGTABLE_WALK_HANDLE_FAULT | KVM_PGTABLE_WALK_SHARED;
 
 	if (fault_is_perm)
 		fault_granule = kvm_vcpu_trap_get_perm_fault_granule(vcpu);
@@ -1695,13 +1696,11 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 		 * PTE, which will be preserved.
 		 */
 		prot &= ~KVM_NV_GUEST_MAP_SZ;
-		ret = kvm_pgtable_stage2_relax_perms(pgt, fault_ipa, prot);
+		ret = kvm_pgtable_stage2_relax_perms(pgt, fault_ipa, prot, flags);
 	} else {
 		ret = kvm_pgtable_stage2_map(pgt, fault_ipa, vma_pagesize,
 					     __pfn_to_phys(pfn), prot,
-					     memcache,
-					     KVM_PGTABLE_WALK_HANDLE_FAULT |
-					     KVM_PGTABLE_WALK_SHARED);
+					     memcache, flags);
 	}
 
 out_unlock:
-- 
2.47.1.613.gc27f4b7a9f-goog

