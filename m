Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83E6C381E72
	for <kvmarm@lists.linux.dev>; Thu, 30 Oct 2025 20:10:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761855028; cv=none; b=OQSOmA8y/qQS51wvFEBXH1iKUmh2ADEC2OV1aMvnFxy3Dhin3zhtWRZ+ECLAwJjpWPkc8v99WwRXtcETBKgxEvTAp1Y7sJd5zrqJuOX7ZG+8r34pMBnFXiy2mAhVWcz7LLhW8NZaq8OssiLpOWjzU82ABx3DYdOQOYUTX1tKX60=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761855028; c=relaxed/simple;
	bh=iID6fKfqxMHNYPgMBI64j92pxR6SB3hzw7FaAoHtwr4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=oetuamvnzh16A66lC1oyZ5a3N+I+FZtkmASN8Ag+CtQoKwGH5RjbCORl/t8qthNRdePWX/KboGZJSC8cM7FKKaRXvpSKbYaQm4qzQfz4Or7d6GFCAT1K7KSq906c0aRQtgI8lRRENz3uwiLN5nPv/BLO1vulY8YvZiJfaLMiXw4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=qah7c32S; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="qah7c32S"
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-34082c48b2bso423025a91.1
        for <kvmarm@lists.linux.dev>; Thu, 30 Oct 2025 13:10:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1761855026; x=1762459826; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=8nIvTvBCdsBevoBG1DvySQLnzbDN6yPR9QB+VA8aXbA=;
        b=qah7c32S7KJTnMtREJIqz5x2mThiqzObq+pATtPgW3dW7/JZzcb7OksMf55L0yfCr/
         JZ/EIs/1qmyzTy3o/+evmMCPjxyxpmf0RRuMJNjQkUxMVJ2yjrT1t2gkPPmOQ3XM+HB5
         4EBiZ8QJgHKH49WMLawXAuvRrtjQcjrIqa0RFZLrKQ3TZ8St74ArFjWqIGS5uUsuHiBM
         I8OUdFie+lQa+gcCYa5kdJqHFZNcGIM7BkGK6LdXF5/cV4RlXnMeuRCaofsv/K7nOBP+
         Ndke2SgNc/MwrJz85drC9cnqrqbAjLnLR2aqGOlY9qAGC5nVBCukiY0YpmyHIF3SNnKl
         c7Qw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761855026; x=1762459826;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=8nIvTvBCdsBevoBG1DvySQLnzbDN6yPR9QB+VA8aXbA=;
        b=ojkySv5LA4EySnSVtMXNGKP3EJurpfocl7X8mtvhfuTmvVkaEJVVOwEJtK5ivgQEoL
         f9qnHO7zTo2sLyoYop9SIAZLduOYLISLJ0A2NacAGTxwMdMpOPMplWD0BdPKeoG57qSa
         BKip1sLzpjwuvzmwbkTRBkjioL0ILbvUFwVLb0UKDefnHwvWcBAjfhiSFtwp9cxju2L4
         0iokA/7hpnkcgVlCcrqsRj5LQWMzvUJm/FAMLeW7MKVYqarT8DuFs6LdIAurREIXO1iF
         TNFoXnZ+1X5Wc7XLs888yLiummnUz/VAGfiIlXgam3d0lxSVU+0RTFbl4aBK4vbNZM80
         wHag==
X-Forwarded-Encrypted: i=1; AJvYcCXvpRF8dgrYNltPosxGIvdyu0XqXk9+6G4ZtR0LPeleyBUkkmqA0LffeVaZCEN+NWJ+6CXJaD4=@lists.linux.dev
X-Gm-Message-State: AOJu0YxDlrMZbo4wrxX0XKFAM9HRLPCaRK0bDx8208WaTLUP8EqBFsjH
	PVa3X3V3CuKLjLgonaaxs/KpF0PjzUPbjqR+O+/0io+wXtDWXMHyIT0spUC5xogPEgKwW9ZasQD
	s0p7wOg==
X-Google-Smtp-Source: AGHT+IEhw8LtT9p+iuh4rLr+K1Dp7djyQDWKY2Obpi49t8AGu0qQZAphBfIqivSEmnTrnJBooynMyMjyxqM=
X-Received: from pjbcf6.prod.google.com ([2002:a17:90a:ebc6:b0:33f:e888:4aad])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:4c8b:b0:32e:3552:8c79
 with SMTP id 98e67ed59e1d1-34083088fb8mr1238454a91.29.1761855025815; Thu, 30
 Oct 2025 13:10:25 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 30 Oct 2025 13:09:34 -0700
In-Reply-To: <20251030200951.3402865-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20251030200951.3402865-1-seanjc@google.com>
X-Mailer: git-send-email 2.51.1.930.gacf6e81ea2-goog
Message-ID: <20251030200951.3402865-12-seanjc@google.com>
Subject: [PATCH v4 11/28] KVM: x86/mmu: Drop the return code from kvm_x86_ops.remove_external_spte()
From: Sean Christopherson <seanjc@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Tianrui Zhao <zhaotianrui@loongson.cn>, Bibo Mao <maobibo@loongson.cn>, 
	Huacai Chen <chenhuacai@kernel.org>, Madhavan Srinivasan <maddy@linux.ibm.com>, 
	Anup Patel <anup@brainfault.org>, Paul Walmsley <pjw@kernel.org>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Christian Borntraeger <borntraeger@linux.ibm.com>, Janosch Frank <frankja@linux.ibm.com>, 
	Claudio Imbrenda <imbrenda@linux.ibm.com>, Sean Christopherson <seanjc@google.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, "Kirill A. Shutemov" <kas@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kvm@vger.kernel.org, loongarch@lists.linux.dev, linux-mips@vger.kernel.org, 
	linuxppc-dev@lists.ozlabs.org, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, x86@kernel.org, linux-coco@lists.linux.dev, 
	linux-kernel@vger.kernel.org, Ira Weiny <ira.weiny@intel.com>, 
	Kai Huang <kai.huang@intel.com>, Binbin Wu <binbin.wu@linux.intel.com>, 
	Michael Roth <michael.roth@amd.com>, Yan Zhao <yan.y.zhao@intel.com>, 
	Vishal Annapurve <vannapurve@google.com>, Rick Edgecombe <rick.p.edgecombe@intel.com>, 
	Ackerley Tng <ackerleytng@google.com>
Content-Type: text/plain; charset="UTF-8"

Drop the return code from kvm_x86_ops.remove_external_spte(), a.k.a.
tdx_sept_remove_private_spte(), as KVM simply does a KVM_BUG_ON() failure,
and that KVM_BUG_ON() is redundant since all error paths in TDX also do a
KVM_BUG_ON().

Opportunistically pass the spte instead of the pfn, as the API is clearly
about removing an spte.

Suggested-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
Reviewed-by: Binbin Wu <binbin.wu@linux.intel.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/asm/kvm_host.h |  4 ++--
 arch/x86/kvm/mmu/tdp_mmu.c      |  8 ++------
 arch/x86/kvm/vmx/tdx.c          | 17 ++++++++---------
 3 files changed, 12 insertions(+), 17 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 48598d017d6f..b5867f8fe6ce 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1855,8 +1855,8 @@ struct kvm_x86_ops {
 				 void *external_spt);
 
 	/* Update external page table from spte getting removed, and flush TLB. */
-	int (*remove_external_spte)(struct kvm *kvm, gfn_t gfn, enum pg_level level,
-				    kvm_pfn_t pfn_for_gfn);
+	void (*remove_external_spte)(struct kvm *kvm, gfn_t gfn, enum pg_level level,
+				     u64 mirror_spte);
 
 	bool (*has_wbinvd_exit)(void);
 
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index e735d2f8367b..e1a96e9ea1bb 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -362,9 +362,6 @@ static void tdp_mmu_unlink_sp(struct kvm *kvm, struct kvm_mmu_page *sp)
 static void remove_external_spte(struct kvm *kvm, gfn_t gfn, u64 old_spte,
 				 int level)
 {
-	kvm_pfn_t old_pfn = spte_to_pfn(old_spte);
-	int ret;
-
 	/*
 	 * External (TDX) SPTEs are limited to PG_LEVEL_4K, and external
 	 * PTs are removed in a special order, involving free_external_spt().
@@ -377,9 +374,8 @@ static void remove_external_spte(struct kvm *kvm, gfn_t gfn, u64 old_spte,
 
 	/* Zapping leaf spte is allowed only when write lock is held. */
 	lockdep_assert_held_write(&kvm->mmu_lock);
-	/* Because write lock is held, operation should success. */
-	ret = kvm_x86_call(remove_external_spte)(kvm, gfn, level, old_pfn);
-	KVM_BUG_ON(ret, kvm);
+
+	kvm_x86_call(remove_external_spte)(kvm, gfn, level, old_spte);
 }
 
 /**
diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index abea9b3d08cf..7ab67ad83677 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -1806,12 +1806,12 @@ static int tdx_sept_free_private_spt(struct kvm *kvm, gfn_t gfn,
 	return tdx_reclaim_page(virt_to_page(private_spt));
 }
 
-static int tdx_sept_remove_private_spte(struct kvm *kvm, gfn_t gfn,
-					enum pg_level level, kvm_pfn_t pfn)
+static void tdx_sept_remove_private_spte(struct kvm *kvm, gfn_t gfn,
+					 enum pg_level level, u64 mirror_spte)
 {
+	struct page *page = pfn_to_page(spte_to_pfn(mirror_spte));
 	int tdx_level = pg_level_to_tdx_sept_level(level);
 	struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
-	struct page *page = pfn_to_page(pfn);
 	gpa_t gpa = gfn_to_gpa(gfn);
 	u64 err, entry, level_state;
 	int ret;
@@ -1822,15 +1822,15 @@ static int tdx_sept_remove_private_spte(struct kvm *kvm, gfn_t gfn,
 	 * there can't be anything populated in the private EPT.
 	 */
 	if (KVM_BUG_ON(!is_hkid_assigned(to_kvm_tdx(kvm)), kvm))
-		return -EIO;
+		return;
 
 	/* TODO: handle large pages. */
 	if (KVM_BUG_ON(level != PG_LEVEL_4K, kvm))
-		return -EIO;
+		return;
 
 	ret = tdx_sept_zap_private_spte(kvm, gfn, level, page);
 	if (ret <= 0)
-		return ret;
+		return;
 
 	/*
 	 * TDX requires TLB tracking before dropping private page.  Do
@@ -1859,17 +1859,16 @@ static int tdx_sept_remove_private_spte(struct kvm *kvm, gfn_t gfn,
 
 	if (KVM_BUG_ON(err, kvm)) {
 		pr_tdx_error_2(TDH_MEM_PAGE_REMOVE, err, entry, level_state);
-		return -EIO;
+		return;
 	}
 
 	err = tdh_phymem_page_wbinvd_hkid((u16)kvm_tdx->hkid, page);
 	if (KVM_BUG_ON(err, kvm)) {
 		pr_tdx_error(TDH_PHYMEM_PAGE_WBINVD, err);
-		return -EIO;
+		return;
 	}
 
 	tdx_quirk_reset_page(page);
-	return 0;
 }
 
 void tdx_deliver_interrupt(struct kvm_lapic *apic, int delivery_mode,
-- 
2.51.1.930.gacf6e81ea2-goog

