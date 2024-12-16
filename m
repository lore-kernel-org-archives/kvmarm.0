Received: from mail-ed1-f74.google.com (mail-ed1-f74.google.com [209.85.208.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72B9120B7E0
	for <kvmarm@lists.linux.dev>; Mon, 16 Dec 2024 17:58:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734371899; cv=none; b=rVRQ55nMBoakwLav7CD3pw8LppeIpx8I3fmgKciE3sEfh9gHLq4wqxiMfP5KWI4gYEMxpKT4FsCDqLuwsxMAH50Z5mUJzs9lzTg3SmVu7dzjyxBRryjADM0Zj296DtbbUYlxMAfYlVfdlamw+6xIsjPDl7ybcv9/ebwDAV6NJsU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734371899; c=relaxed/simple;
	bh=Es7cr26j70mP+64KpnhVcXIimoA87KfgbKi9ahJYCeU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=XxYSVSKF8qciICnIZdEkKZqvrvT2lvgBjovCuuncQ3O9UDSqyPdlNoMxqQdR+ZHggubb2t6QJo47/8Kt8M8HW/cc80wGtoQYwSbRH7/ALAjMLQlMPgPthJbri7qEX9ZV7orDJZPwbqG5XiHfwp8au3u67YMwXhE9s/YPSa6kzLM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--qperret.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=XP3Rtpkk; arc=none smtp.client-ip=209.85.208.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--qperret.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="XP3Rtpkk"
Received: by mail-ed1-f74.google.com with SMTP id 4fb4d7f45d1cf-5d121a79ad0so4686079a12.2
        for <kvmarm@lists.linux.dev>; Mon, 16 Dec 2024 09:58:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1734371896; x=1734976696; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=dMBJ8qv477+/KhCtyqixNk1hTPuipFTJvx4sNjSPhX0=;
        b=XP3RtpkkgUCw+Ndsa9ZacN8wRFV0cvCpD8Y2InZNloXtyWaXtldio6gDarT3ymjCuX
         GFH161iM5aeERnLFVPY/ZdPlTODZAtdPovS7p9q4INDs4nMxCIeqi0vqa9cLXFgyzUJx
         PKPHvhLO0ElxjNcYScqrU/e3zVFzTKVhHqAslQL7fvnNVCKHlEOWDkOJMJrTWEfhn6gt
         w7abCa8oUfueuDJhQm8xXR/HRpdSf2dTjngVCCOB77M6oluPbelFG2iQIZQPJpTfLq1T
         +U3OLLyLxZnyp1S197YpvFhkGTDe/f5bG7n6fsP80G4txj2cyxKCxbZnpbJGVeJ20lmW
         9ULg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734371896; x=1734976696;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=dMBJ8qv477+/KhCtyqixNk1hTPuipFTJvx4sNjSPhX0=;
        b=XQvtkDocI1vnu0sWHnsPY+P9iETv09iAZBYwZFm2Rcla9x0cJX0s1QTri61/1ouL4w
         p4rujWoDePMdLVQUy6UJQq35wN2r5sHlFkQFqpbGqWlxnRolIr2uCsApphZ7mc2Mrsmq
         psTDP/RPag1OxymF79imsfoN9urOuk7CNnZPl3CaFgjhGIX236txvNJQLokT8TUQfHCJ
         83U8scz7JGO1jdngQKmm3twZNw2cZgTwFPMcwgcoCbfkiNJVlTwKAqC1xAkYzbpXqZmF
         STYgd2j9ara3Ya9mhTGOShiRa90PJYcJV1riBYBaWRfWBpGg9XrseDrH8M9i4QAzDZS+
         38Cg==
X-Forwarded-Encrypted: i=1; AJvYcCWWImpqNCXbAcIWcMF0uNrEnxrguIbtS6KrZRxvLa1xXW/savdaKpr4BJydtgYRzU+ReKnd1rY=@lists.linux.dev
X-Gm-Message-State: AOJu0YyM5I1wRiwMXYLrPGNcgbGYDG9GVZmoe/Qt0lw0omTeeFd+2Fqz
	MwpgwTxul3rmifzZlqawqdOsQIF0LISrYEARb1i4Hz5oIMezoxF92cFXP3jo7ubzX9gjGcdB6cf
	7N6H5ww==
X-Google-Smtp-Source: AGHT+IG78GpSrIyP8EQZsymolUELoZAfYkZfqZ5uAr74kYA6Of93xC43jJPtt/eSfM7J/zSOVAI94LqFwgRU
X-Received: from edber15.prod.google.com ([2002:a05:6402:448f:b0:5d6:3c96:bb82])
 (user=qperret job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6402:2695:b0:5cf:e71c:ff88
 with SMTP id 4fb4d7f45d1cf-5d7d4053910mr586302a12.4.1734371895963; Mon, 16
 Dec 2024 09:58:15 -0800 (PST)
Date: Mon, 16 Dec 2024 17:57:50 +0000
In-Reply-To: <20241216175803.2716565-1-qperret@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20241216175803.2716565-1-qperret@google.com>
X-Mailer: git-send-email 2.47.1.613.gc27f4b7a9f-goog
Message-ID: <20241216175803.2716565-6-qperret@google.com>
Subject: [PATCH v3 05/18] KVM: arm64: Pass walk flags to kvm_pgtable_stage2_mkyoung
From: Quentin Perret <qperret@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>
Cc: Fuad Tabba <tabba@google.com>, Vincent Donnefort <vdonnefort@google.com>, 
	Sebastian Ene <sebastianene@google.com>, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

kvm_pgtable_stage2_mkyoung currently assumes that it is being called
from a 'shared' walker, which will not be true once called from pKVM.
To allow for the re-use of that function, make the walk flags one of
its parameters.

Signed-off-by: Quentin Perret <qperret@google.com>
---
 arch/arm64/include/asm/kvm_pgtable.h | 4 +++-
 arch/arm64/kvm/hyp/pgtable.c         | 7 +++----
 arch/arm64/kvm/mmu.c                 | 3 ++-
 3 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/include/asm/kvm_pgtable.h
index aab04097b505..38b7ec1c8614 100644
--- a/arch/arm64/include/asm/kvm_pgtable.h
+++ b/arch/arm64/include/asm/kvm_pgtable.h
@@ -669,13 +669,15 @@ int kvm_pgtable_stage2_wrprotect(struct kvm_pgtable *pgt, u64 addr, u64 size);
  * kvm_pgtable_stage2_mkyoung() - Set the access flag in a page-table entry.
  * @pgt:	Page-table structure initialised by kvm_pgtable_stage2_init*().
  * @addr:	Intermediate physical address to identify the page-table entry.
+ * @flags:	Flags to control the page-table walk (ex. a shared walk)
  *
  * The offset of @addr within a page is ignored.
  *
  * If there is a valid, leaf page-table entry used to translate @addr, then
  * set the access flag in that entry.
  */
-void kvm_pgtable_stage2_mkyoung(struct kvm_pgtable *pgt, u64 addr);
+void kvm_pgtable_stage2_mkyoung(struct kvm_pgtable *pgt, u64 addr,
+				enum kvm_pgtable_walk_flags flags);
 
 /**
  * kvm_pgtable_stage2_test_clear_young() - Test and optionally clear the access
diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
index 40bd55966540..0470aedb4bf4 100644
--- a/arch/arm64/kvm/hyp/pgtable.c
+++ b/arch/arm64/kvm/hyp/pgtable.c
@@ -1245,14 +1245,13 @@ int kvm_pgtable_stage2_wrprotect(struct kvm_pgtable *pgt, u64 addr, u64 size)
 					NULL, NULL, 0);
 }
 
-void kvm_pgtable_stage2_mkyoung(struct kvm_pgtable *pgt, u64 addr)
+void kvm_pgtable_stage2_mkyoung(struct kvm_pgtable *pgt, u64 addr,
+				enum kvm_pgtable_walk_flags flags)
 {
 	int ret;
 
 	ret = stage2_update_leaf_attrs(pgt, addr, 1, KVM_PTE_LEAF_ATTR_LO_S2_AF, 0,
-				       NULL, NULL,
-				       KVM_PGTABLE_WALK_HANDLE_FAULT |
-				       KVM_PGTABLE_WALK_SHARED);
+				       NULL, NULL, flags);
 	if (!ret)
 		dsb(ishst);
 }
diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index c9d46ad57e52..a2339b76c826 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1718,13 +1718,14 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 /* Resolve the access fault by making the page young again. */
 static void handle_access_fault(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa)
 {
+	enum kvm_pgtable_walk_flags flags = KVM_PGTABLE_WALK_HANDLE_FAULT | KVM_PGTABLE_WALK_SHARED;
 	struct kvm_s2_mmu *mmu;
 
 	trace_kvm_access_fault(fault_ipa);
 
 	read_lock(&vcpu->kvm->mmu_lock);
 	mmu = vcpu->arch.hw_mmu;
-	kvm_pgtable_stage2_mkyoung(mmu->pgt, fault_ipa);
+	kvm_pgtable_stage2_mkyoung(mmu->pgt, fault_ipa, flags);
 	read_unlock(&vcpu->kvm->mmu_lock);
 }
 
-- 
2.47.1.613.gc27f4b7a9f-goog

