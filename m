Received: from mail-ej1-f74.google.com (mail-ej1-f74.google.com [209.85.218.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2693631283E
	for <kvmarm@lists.linux.dev>; Thu, 21 May 2026 14:36:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779374195; cv=none; b=Ap7VRt/aQjqj2T1lwZeh8zGdtmzd8LFrstV1s5v9UrKUye7zXbjHwzmOpBATPbcj/lPclp5IkxMJOrDkLj4cf/RXRNQhzKlCYxDsvvOxumsdssfIjGnBlq9vQD+ADy7rC2DgSSXA6bU3koGTeLCqblhQhjyDFBe1ORskkfA9MMc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779374195; c=relaxed/simple;
	bh=iovLLELEPGAEeqrXqUuFgbMegsS0Ply5dAqKPJI6hLY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=XU4UjH09WYyvBJjbvIFk58tYILsXkmhF4FnR0zd1sEh3qTG/4Xdg/xrIOnyzkQzOEpVcNdtacxghFs2qZpPgE63cB+qcW3m11u/aCqvrc9puSh+X3OteaTAsd1L4ropsfTzLQ74wzaBIoyozCp+9kdj4MFcYkaEoRWLhZU9uZOc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ASpQhgIy; arc=none smtp.client-ip=209.85.218.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ASpQhgIy"
Received: by mail-ej1-f74.google.com with SMTP id a640c23a62f3a-bd960997b8eso277346566b.0
        for <kvmarm@lists.linux.dev>; Thu, 21 May 2026 07:36:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1779374192; x=1779978992; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=qcxdHOKzYSh28oVM+92+Sl2qXUwj5KIsOOEhTqQ5qbU=;
        b=ASpQhgIyVatfKa9NCm7AMSW6HYk/VfNP60eo1lCRoWlPaFthLUFXZdjVFafTKtA+OR
         Llbr4tt/0AE70AGxUXcUtSUwUvXAYo3FsyrgatoxIlkTr1uUSDNqvBYPRSHf21COfxak
         PeDyWraS4ezg2Wa3qBDJ2AtHGazTsu6hHPWMWviJhT2FmAzljImprg5hQMF0i0ksyI0R
         USNWn9my+9vuslQs3poLEsxJz3vQlhYoyx1BFG58xr6TRK2Qm1bwjd7luHxye+6ftaqs
         BFabWb1eMBUEzKezyvHpm2a+IYAfaZswdL4ph69P7J/9YubKTyJ935oKW3yD//OCXwyp
         U6oA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779374192; x=1779978992;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=qcxdHOKzYSh28oVM+92+Sl2qXUwj5KIsOOEhTqQ5qbU=;
        b=ahkIZn0gFSC04cAOH5IZZ3OjOLmVBN68c8ERVMUX57ltDKP7mBz9AS/Em6eaJFf+tU
         y2bwQQInvYJBlagnrAcQrotIBghu5sZF4rtYwnKT2womks1p1oLO2lEgjHn58X2jCFAw
         m/4HiepSjRO5iWNDUFeEWwr/RtLYcazrg0EAHUD0bhpoCJpRhplpPccBcCCQ0N8y77C1
         xTnd3mUi07KVMlt3EdXyoI2Dxl55we5eK2yC3opjAksHgRbOgknVUpefk5xRi8toQvZp
         wOOd2MKxUOO0uL3y6dR2JaxjDwNbm2jC7pt02dr4oiZBGj/FRW4zKzlikweT+2jpvnlk
         OlAg==
X-Forwarded-Encrypted: i=1; AFNElJ+cYh6bBvweLoEGVqNG+qACcvUh4ZN59RqaSpmQVF6dNWxOei4pM3Xqosk00NTUMT0kHURZcYk=@lists.linux.dev
X-Gm-Message-State: AOJu0YyQaol9cm4duYOpCKvyY9f8iXIFFzdV71byJa/ALtC7fvmn/19x
	aKYeVco0bfYhy/BJc3UE1rxCrlunGkingh/hqJViPBSKIp5dQ+0G0I0J66KR2dXHR9XpUHK5ZTw
	VBVXF0Q6644A14tSIezbrpA==
X-Received: from edvr23.prod.google.com ([2002:a05:6402:197:b0:683:5306:a54f])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6402:a28b:20b0:688:24dc:9152 with SMTP id 4fb4d7f45d1cf-688367d4eddmr1089728a12.16.1779374192287;
 Thu, 21 May 2026 07:36:32 -0700 (PDT)
Date: Thu, 21 May 2026 15:36:26 +0100
In-Reply-To: <20260521143626.1005660-1-vdonnefort@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260521143626.1005660-1-vdonnefort@google.com>
X-Mailer: git-send-email 2.54.0.746.g67dd491aae-goog
Message-ID: <20260521143626.1005660-4-vdonnefort@google.com>
Subject: [RESEND v3 3/3] KVM: arm64: Add fail-safe for refcounted pages in __pkvm_hyp_donate_host
From: Vincent Donnefort <vdonnefort@google.com>
To: maz@kernel.org, oliver.upton@linux.dev, joey.gouly@arm.com, 
	suzuki.poulose@arm.com, yuzenghui@huawei.com, catalin.marinas@arm.com, 
	will@kernel.org
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kernel-team@android.com, qperret@google.com, tabba@google.com, 
	Vincent Donnefort <vdonnefort@google.com>
Content-Type: text/plain; charset="UTF-8"

A previous bug in __pkvm_init_vm error path showed that the hypervisor
could leak refcounted pages, (i.e. losing access to a page while its
refcount is still elevated). This poses a threat to the pKVM state
machine.

Address this by introducing a fail-safe in __pkvm_hyp_donate_host.
Transitions are not a hot path so added security is worth the extra
check.

Reviewed-by: Fuad Tabba <tabba@google.com>
Tested-by: Fuad Tabba <tabba@google.com>
Signed-off-by: Vincent Donnefort <vdonnefort@google.com>

diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
index 986e0ac1f2d8..fee55e49c132 100644
--- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
+++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
@@ -854,6 +854,16 @@ static int __hyp_check_page_state_range(phys_addr_t phys, u64 size, enum pkvm_pa
 	return 0;
 }
 
+static int __hyp_check_page_count_range(phys_addr_t phys, u64 size)
+{
+	for_each_hyp_page(page, phys, size) {
+		if (page->refcount)
+			return -EBUSY;
+	}
+
+	return 0;
+}
+
 static bool guest_pte_is_poisoned(kvm_pte_t pte)
 {
 	if (kvm_pte_valid(pte))
@@ -1052,7 +1062,6 @@ int __pkvm_guest_unshare_host(struct pkvm_hyp_vcpu *vcpu, u64 gfn)
 int __pkvm_host_unshare_hyp(u64 pfn)
 {
 	u64 phys = hyp_pfn_to_phys(pfn);
-	u64 virt = (u64)__hyp_va(phys);
 	u64 size = PAGE_SIZE;
 	int ret;
 
@@ -1065,10 +1074,9 @@ int __pkvm_host_unshare_hyp(u64 pfn)
 	ret = __hyp_check_page_state_range(phys, size, PKVM_PAGE_SHARED_BORROWED);
 	if (ret)
 		goto unlock;
-	if (hyp_page_count((void *)virt)) {
-		ret = -EBUSY;
+	ret = __hyp_check_page_count_range(phys, size);
+	if (ret)
 		goto unlock;
-	}
 
 	__hyp_set_page_state_range(phys, size, PKVM_NOPAGE);
 	WARN_ON(__host_set_page_state_range(phys, size, PKVM_PAGE_OWNED));
@@ -1131,6 +1139,10 @@ int __pkvm_hyp_donate_host(u64 pfn, u64 nr_pages)
 	if (ret)
 		goto unlock;
 
+	ret = __hyp_check_page_count_range(phys, size);
+	if (ret)
+		goto unlock;
+
 	__hyp_set_page_state_range(phys, size, PKVM_NOPAGE);
 	WARN_ON(kvm_pgtable_hyp_unmap(&pkvm_pgtable, virt, size) != size);
 	WARN_ON(host_stage2_set_owner_locked(phys, size, PKVM_ID_HOST));
-- 
2.54.0.746.g67dd491aae-goog

