Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4606F25C711
	for <kvmarm@lists.linux.dev>; Mon, 28 Jul 2025 17:53:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753725214; cv=none; b=oXLLY+OFiM0XSTrSvpXn7FuRSRW399gYjO19LPF+vRIXbmywMe8vsEWa5+z8AyCAAC9M3NAZaXwW299h7Vnnitxfk9thvTDNCc5gSdOku6+49Rg2YyFhdVTylC70OZevVL4yKODYbhM3iurr05+Vmiw3/FhK8PXBSA/0sR3BbNE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753725214; c=relaxed/simple;
	bh=J1SjK0vWeBplkdbTTJcUjjcnej2Z63ZcY6P/gYDg268=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=lTCsUQLC6V/QKmdKU+KIIWG/ju7GA2Xc/J3v1KqdweUxoZI/OTnKpf0Dq1AWdCXz5XEm0U4E86aGkm/j6KhafF0l091jH0Vx9MXcU3OFF7fxLSgCWDRLF+8LJzvyc6lxENt4yZ3/J96d8QL21mDhznOn6+VZvO8eCiHhOa12dNA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--smostafa.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=XUdXQ9jd; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--smostafa.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="XUdXQ9jd"
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-4538f375e86so36587075e9.3
        for <kvmarm@lists.linux.dev>; Mon, 28 Jul 2025 10:53:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753725211; x=1754330011; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=ZeRx7vP/138KQFxr0SX14a6MVSvUsa68vsZQFRiGNJw=;
        b=XUdXQ9jdjgTr3NS7/crZLpUFUUwQig+gaPL+8X/h14yoDB6czlwQMz2ijka53QmDE6
         e+RnPbk8CIkuTFqMz6EgwsLjymCNxb0pbgqFijQMAYIbv0EJ5L5HBTBrv54pyChRk4GR
         0XJm5XWo/LLalf9/HjwtBhH1wf+NcplnjA6QO4RJyVtTTGfdFHPQyNce//gdvbvfYYuq
         JstjVR5Cxj+ux9Q6bf8d8CM/OU38H+KBjxLYNen1Ax6C1LlsYTflUTBeMfaPXyWKiFWB
         QQ8Y6jcwTdGUBQz1AS6Sl/DWo7DDnkZl6Sa/2dd1yutwSx9Eah/ne0ASoYiCU0q6LfpL
         JNQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753725211; x=1754330011;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ZeRx7vP/138KQFxr0SX14a6MVSvUsa68vsZQFRiGNJw=;
        b=D/Y4DVuDg1DLYTO+Uemul7Nx40M4zezwfHpJ8cFUHPtsCoeIN84FMtyMXPm8ZiyVEe
         JIR0eUnRDRPRSOn/sufk8r6ZrWAGf3DK+UWr7An7Q4eX3syxSTNZAenjA7S48CS/d/aV
         Z+nZmu9EPFgbiy1SKMIy+jbPnEi8ehxnZ5ujjMnSW7KFuWyJxmqVQ2DlLzaECxjgemdV
         MbJOdnEocywzH1yOI26U8+lLxuusPsww3/1LPrfvbtMzU5g/xD1h5HeP+Pfx/lFdqUhD
         j4mBbkFDaVlEN/WIffODMb0bRBXKJdFGjUPzEoNXmFrCH+p8GKxCJQS6Ld0csi0nlOME
         1e+g==
X-Forwarded-Encrypted: i=1; AJvYcCUOE754g28EILnl8g5JBZusBUucGBQ58Q6ylRHgSJwGNU0jUkkHY6dm21p5lakxjCcdn4TQ1Q8=@lists.linux.dev
X-Gm-Message-State: AOJu0YwGxDeOIqmV+nnfrbptMEUsks4ZhWkggIYcrs9t6LJoim6PecrC
	lrE35jv4GeiBbG7rLzAFx73AI6iq+5DkDEqk+Bt81wc7wzm/LSrNIXsNCW+4Px+f52DvidV4fBO
	Q0g9wW3uPUU97+A==
X-Google-Smtp-Source: AGHT+IE1QKRH8xd41th/Qwnod5XKPsVgVqg7Mv68PdXhnIKZKddzbjKbt+QRa+9zTDVfDxi6tBL2YQdZsrDI2Q==
X-Received: from wmsp14.prod.google.com ([2002:a05:600c:1d8e:b0:456:c7c:3165])
 (user=smostafa job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:138c:b0:456:58e:318e with SMTP id 5b1f17b1804b1-458852534ecmr52353185e9.30.1753725211674;
 Mon, 28 Jul 2025 10:53:31 -0700 (PDT)
Date: Mon, 28 Jul 2025 17:52:48 +0000
In-Reply-To: <20250728175316.3706196-1-smostafa@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250728175316.3706196-1-smostafa@google.com>
X-Mailer: git-send-email 2.50.1.552.g942d659e1b-goog
Message-ID: <20250728175316.3706196-2-smostafa@google.com>
Subject: [PATCH v3 01/29] KVM: arm64: Add a new function to donate memory with prot
From: Mostafa Saleh <smostafa@google.com>
To: linux-kernel@vger.kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, iommu@lists.linux.dev
Cc: maz@kernel.org, oliver.upton@linux.dev, joey.gouly@arm.com, 
	suzuki.poulose@arm.com, yuzenghui@huawei.com, catalin.marinas@arm.com, 
	will@kernel.org, robin.murphy@arm.com, jean-philippe@linaro.org, 
	qperret@google.com, tabba@google.com, jgg@ziepe.ca, mark.rutland@arm.com, 
	praan@google.com, Mostafa Saleh <smostafa@google.com>
Content-Type: text/plain; charset="UTF-8"

Soon, IOMMU drivers running in the hypervisor might interact with
non-coherent devices, so it needs a mechanism to map memory as
non cacheable.
Add ___pkvm_host_donate_hyp() which accepts a new argument for prot,
so the driver can add KVM_PGTABLE_PROT_NORMAL_NC.

Signed-off-by: Mostafa Saleh <smostafa@google.com>
---
 arch/arm64/kvm/hyp/include/nvhe/mem_protect.h |  1 +
 arch/arm64/kvm/hyp/nvhe/mem_protect.c         | 11 +++++++++--
 2 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h b/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
index 5f9d56754e39..52d7ee91e18c 100644
--- a/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
+++ b/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
@@ -36,6 +36,7 @@ int __pkvm_prot_finalize(void);
 int __pkvm_host_share_hyp(u64 pfn);
 int __pkvm_host_unshare_hyp(u64 pfn);
 int __pkvm_host_donate_hyp(u64 pfn, u64 nr_pages);
+int ___pkvm_host_donate_hyp(u64 pfn, u64 nr_pages, enum kvm_pgtable_prot prot);
 int __pkvm_hyp_donate_host(u64 pfn, u64 nr_pages);
 int __pkvm_host_share_ffa(u64 pfn, u64 nr_pages);
 int __pkvm_host_unshare_ffa(u64 pfn, u64 nr_pages);
diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
index 8957734d6183..861e448183fd 100644
--- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
+++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
@@ -769,13 +769,15 @@ int __pkvm_host_unshare_hyp(u64 pfn)
 	return ret;
 }
 
-int __pkvm_host_donate_hyp(u64 pfn, u64 nr_pages)
+int ___pkvm_host_donate_hyp(u64 pfn, u64 nr_pages, enum kvm_pgtable_prot prot)
 {
 	u64 phys = hyp_pfn_to_phys(pfn);
 	u64 size = PAGE_SIZE * nr_pages;
 	void *virt = __hyp_va(phys);
 	int ret;
 
+	WARN_ON(prot & KVM_PGTABLE_PROT_X);
+
 	host_lock_component();
 	hyp_lock_component();
 
@@ -787,7 +789,7 @@ int __pkvm_host_donate_hyp(u64 pfn, u64 nr_pages)
 		goto unlock;
 
 	__hyp_set_page_state_range(phys, size, PKVM_PAGE_OWNED);
-	WARN_ON(pkvm_create_mappings_locked(virt, virt + size, PAGE_HYP));
+	WARN_ON(pkvm_create_mappings_locked(virt, virt + size, prot));
 	WARN_ON(host_stage2_set_owner_locked(phys, size, PKVM_ID_HYP));
 
 unlock:
@@ -797,6 +799,11 @@ int __pkvm_host_donate_hyp(u64 pfn, u64 nr_pages)
 	return ret;
 }
 
+int __pkvm_host_donate_hyp(u64 pfn, u64 nr_pages)
+{
+	return ___pkvm_host_donate_hyp(pfn, nr_pages, PAGE_HYP);
+}
+
 int __pkvm_hyp_donate_host(u64 pfn, u64 nr_pages)
 {
 	u64 phys = hyp_pfn_to_phys(pfn);
-- 
2.50.1.552.g942d659e1b-goog

