Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com [209.85.128.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8598E54B1DA
	for <kvmarm@lists.linux.dev>; Tue, 22 Sep 2026 13:13:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790082798; cv=none; b=P3HeE0OoTUae48FGh0sy18sorHbOBcYw7DcPTnmhWL7ulSD3g+u1ySM8Z4yZGbM8Bh0wsNRiR9FcJigJD6TTT8O1Qs4EKciyM6M3tURaY8oXeALcCY5+2YlCbTd2vgye3hq3hoQ4GLOhi48vKolXR//i+gvkHqSMy+C30E6wRl8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790082798; c=relaxed/simple;
	bh=qTLWLGQbIRcfgnEXNW0MOl1wFesZy4OYnqx+TTEz3Fo=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=BERtplYePID2nE9IWpjXgkpJXUAzssdpt/Pwg2XLAmqrfF54kUap9L2GTD2Lw55tQ6cP7do7H7JbfISicUZKX/IFsDHSI9mCMnnCNVceqGXkHE/Rp9MnpBiau23OB1KPgOzxTrzQVTWyOX9iuCRj1r+8am2r7WLc0TShatsLjS8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--smostafa.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=kse1xHa1; arc=none smtp.client-ip=209.85.128.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--smostafa.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="kse1xHa1"
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-490a767c7dcso31188285e9.2
        for <kvmarm@lists.linux.dev>; Tue, 22 Sep 2026 06:13:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1790082793; x=1790687593; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Q7lwUocssBorXppr+cuEfwSHFlo2ooUh5GMt4e7kXAU=;
        b=kse1xHa15/+eSBmNcarBa2/vhJSPlS568HrUjHW4aJBZss4YDN91T2VK9fE/tXBo8p
         Y7zYuN+jfR0pnvt0NpQ8j+XXn55pYHT9fjCJCe/YuduMb6PeqinuqMNlYJVW32hwDU3U
         5ignkrEJWMlzm9ByEyAHmD1GavhRioG2qf4O9OOIu3nL63WbjtPKtCI2ujvOKUjezbyo
         5Cz5jywIA3KilHvMAwF2qFfHp0wKaDJN+c/nisElQrVFEYV/zGtU5vCVpR4Bn8VGWxrk
         zueQ/EeyJLppocP2U+ba+6+eq9SBoRRTgZYvPgBothg/AKy97B0oPU9Fxm/67Zl428ei
         RMDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790082793; x=1790687593;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Q7lwUocssBorXppr+cuEfwSHFlo2ooUh5GMt4e7kXAU=;
        b=uFD0nkNV5a/9+gDIljd4KMzVlSSZiHGUwHGY8cRKUpN4Gn0Ew6NrQ212o0+0BkQ1aZ
         p2iy4vTHo8gixWgTPpZi2a/CFwsAAnFjjQ6fdqk3xlm2dE2VZwK8GCHPkH7WW54lKK0I
         /zDTzEBkptdWDrt0XGc2VaIQCEKFR+9HS6QygPbsX6y6TDW/Uzh0wKBk7XEaNdKeNWhu
         bAdGepbOowYFUk2hI7fGGTm02PyjqEecupj7oez/5/uQcZQ3QvXp5RcBOgeNMu9x+wqP
         orZJIfuSPSTTHAAcBHSDdT4RJQ6pyX7xodmyc/dwT+Mg3St/9F57JHcw9/p39Hl0HO7S
         h9gQ==
X-Forwarded-Encrypted: i=1; AKwUvBwDXxyy0JCffJUBXKwaPXsX8KDkok09D/c4DS0q6gBuHmU+rx5H1VedCHDgCd2H344O1+oVO80=@lists.linux.dev
X-Gm-Message-State: AFuF++kzJH5lJSHrOZKCld6poLKsIS1IiXTourq6RDY6IXq6SFByFu7i
	AL5zRbCCKlzsBtJio9BvXClvjkQFa5+wVhfxOEa70lgeSadkWo3JheAD0Qd8d+/TX+NpUz/sJb5
	PytJQcrHeA+dcbA==
X-Received: from wmco6.prod.google.com ([2002:a05:600c:a306:b0:49d:3263:b3be])
 (user=smostafa job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:1989:b0:49c:e42b:a4ac with SMTP id 5b1f17b1804b1-49fc5714d14mr205647445e9.11.1790082793037;
 Tue, 22 Sep 2026 06:13:13 -0700 (PDT)
Date: Tue, 22 Sep 2026 13:12:42 +0000
In-Reply-To: <20260922131259.2975334-1-smostafa@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260922131259.2975334-1-smostafa@google.com>
X-Mailer: git-send-email 2.55.0.1082.g2b9226bbc0-goog
Message-ID: <20260922131259.2975334-10-smostafa@google.com>
Subject: [PATCH v8 09/25] KVM: arm64: iommu: Support DABT for IOMMU
From: Mostafa Saleh <smostafa@google.com>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	kvmarm@lists.linux.dev, iommu@lists.linux.dev
Cc: catalin.marinas@arm.com, will@kernel.org, maz@kernel.org, 
	oliver.upton@linux.dev, joey.gouly@arm.com, suzuki.poulose@arm.com, 
	yuzenghui@huawei.com, joro@8bytes.org, jgg@ziepe.ca, mark.rutland@arm.com, 
	qperret@google.com, tabba@google.com, vdonnefort@google.com, 
	sebastianene@google.com, keirf@google.com, 
	Mostafa Saleh <smostafa@google.com>
Content-Type: text/plain; charset="UTF-8"

The pKVM SMMUv3 driver needs to trap and emulate access to the MMIO
space of the SMMUv3 to provide emulation for the kernel driver.

Add a handler for DABTs for IOMMU drivers to be able to do so.
In case the host causes a data abort, check if it's part of IOMMU
emulation first.

Signed-off-by: Mostafa Saleh <smostafa@google.com>
---
 arch/arm64/kvm/hyp/include/nvhe/iommu.h |  2 ++
 arch/arm64/kvm/hyp/nvhe/iommu.c         | 14 ++++++++++++++
 arch/arm64/kvm/hyp/nvhe/mem_protect.c   | 15 +++++++++++++++
 3 files changed, 31 insertions(+)

diff --git a/arch/arm64/kvm/hyp/include/nvhe/iommu.h b/arch/arm64/kvm/hyp/include/nvhe/iommu.h
index 1fa728ab47d4..3f16879b5fa7 100644
--- a/arch/arm64/kvm/hyp/include/nvhe/iommu.h
+++ b/arch/arm64/kvm/hyp/include/nvhe/iommu.h
@@ -7,6 +7,7 @@
 struct pkvm_iommu_ops {
 	int (*init)(void);
 	int (*host_stage2_idmap)(phys_addr_t start, phys_addr_t end, int prot);
+	bool (*dabt_handler)(struct user_pt_regs *regs, u64 esr, u64 addr);
 };
 
 int pkvm_iommu_init(void *pool_base, unsigned int nr_pages);
@@ -18,5 +19,6 @@ int pkvm_iommu_host_stage2_idmap(phys_addr_t start, phys_addr_t end,
 void *pkvm_iommu_alloc_pages(u8 order);
 /* Free pages from pkvm_iommu_alloc_pages(). */
 void pkvm_iommu_free_pages(void *ptr);
+bool pkvm_iommu_host_dabt_handler(struct user_pt_regs *regs, u64 esr, u64 addr);
 
 #endif /* __ARM64_KVM_NVHE_IOMMU_H__ */
diff --git a/arch/arm64/kvm/hyp/nvhe/iommu.c b/arch/arm64/kvm/hyp/nvhe/iommu.c
index cacab0dc462a..b7b11f6616cd 100644
--- a/arch/arm64/kvm/hyp/nvhe/iommu.c
+++ b/arch/arm64/kvm/hyp/nvhe/iommu.c
@@ -5,8 +5,11 @@
  * Copyright (C) 2022 Linaro Ltd.
  */
 #include <linux/iommu.h>
+#include <asm/kvm_hyp.h>
 #include <asm/kvm_pkvm.h>
 
+#include <hyp/adjust_pc.h>
+
 #include <nvhe/iommu.h>
 #include <nvhe/mem_protect.h>
 #include <nvhe/spinlock.h>
@@ -158,3 +161,14 @@ void pkvm_iommu_free_pages(void *ptr)
 {
 	hyp_put_page(&iommu_pages_pool, ptr);
 }
+
+bool pkvm_iommu_host_dabt_handler(struct user_pt_regs *regs, u64 esr, u64 addr)
+{
+	if (pkvm_iommu_ops && pkvm_iommu_ops->dabt_handler &&
+	    pkvm_iommu_ops->dabt_handler(regs, esr, addr)) {
+		/* DABT handled by the driver, skip to next instruction. */
+		kvm_skip_host_instr();
+		return true;
+	}
+	return false;
+}
diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
index da5014e4e96b..863c571e47e4 100644
--- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
+++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
@@ -758,6 +758,12 @@ static void host_inject_mem_abort(struct kvm_cpu_context *host_ctxt)
 	inject_host_exception(esr);
 }
 
+static bool is_dabt_with_isv(u64 esr)
+{
+	return (ESR_ELx_EC(esr) == ESR_ELx_EC_DABT_LOW) &&
+		(esr & ESR_ELx_ISV);
+}
+
 void handle_host_mem_abort(struct kvm_cpu_context *host_ctxt)
 {
 	struct kvm_vcpu_fault_info fault;
@@ -780,6 +786,15 @@ void handle_host_mem_abort(struct kvm_cpu_context *host_ctxt)
 	BUG_ON(!(fault.hpfar_el2 & HPFAR_EL2_NS));
 	addr = FIELD_GET(HPFAR_EL2_FIPA, fault.hpfar_el2) << 12;
 
+	/*
+	 * Emulate data aborts for IOMMU drivers, other access will be denied
+	 * by host_stage2_adjust_range()
+	 */
+	if (is_dabt_with_isv(esr) && !addr_is_memory(addr) &&
+	    pkvm_iommu_host_dabt_handler(&host_ctxt->regs,
+					 esr, addr | FAR_TO_FIPA_OFFSET(fault.far_el2)))
+		return;
+
 	switch (host_stage2_idmap(addr)) {
 	case -EPERM:
 		host_inject_mem_abort(host_ctxt);
-- 
2.55.0.1082.g2b9226bbc0-goog

