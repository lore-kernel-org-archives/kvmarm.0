Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00DCC40DFCC
	for <kvmarm@lists.linux.dev>; Tue, 10 Mar 2026 12:49:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773146987; cv=none; b=n/4YcLzBCKJ/ahagn/Z61ek85Haj5nE5z+ABTMmKTwLtKgt1pDbi0Al1A/wm6zWPLVcxUOGX921N3LIVaKYv+swqzuMa9ShwomrlODXaDVGxZl7xrgveFMvnN5K/jiuLPp806DnhHz7zmq0SDYjKDkgLZdiINTjrU5JXd5Lma94=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773146987; c=relaxed/simple;
	bh=24ri8I0HdHMqey03lI4dSqJ6RSKEZnF/Gr6nhwOJ9lg=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=bJ29h/bzaRRHkycs1MYcrPYS0dULKzsbsr6CCbcgssLrsO9Kj1fpVFzwAvCApq855Zs4cPfwsmwXn4fDdmk2jXbEsiFpIwc+YMiZwQjRktkFbe8ggNGY7u9ERkBrv6eLQKwgNiR1wacxMTCEp3CGj9+OwPw0k0r9KJwUPayF+BE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--sebastianene.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=y2MAbGCr; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--sebastianene.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="y2MAbGCr"
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-483786a09b1so16870975e9.3
        for <kvmarm@lists.linux.dev>; Tue, 10 Mar 2026 05:49:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1773146984; x=1773751784; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=FjEHtrJ78MYHEp21ejNh5LanY+xm4uc/Zo9pOF+NIDo=;
        b=y2MAbGCrpKqYChJ9vPWyZ3NMHQHt5U1FTyUXgDq9pvunJyOLZMPrWj6avawURseTF0
         jGx1Iehdp0F587U0egX8/IT/eKwLvF/68FYTXcUuJqVM1IZT9n+dClTyG0aNil+jVH5b
         7gQB3EnU2mZBjFMzkSMrUJuP6oZVMd68eDbj32UTjveYEUC1WLIP41osLxm1Kc7NWsiq
         Zi61ffvWrboP3RVwZHpx+uD7xGbEfBp/UndR5FpX7wyyHnngvKT/WWiyC5v7uNfLITK0
         GpW/x7f9BoR20y2Qiwegq972MH9IDaSGYzPOdyJCm75MIpd427RZiOFUcVqrtLFK6ZwG
         OYJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773146984; x=1773751784;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=FjEHtrJ78MYHEp21ejNh5LanY+xm4uc/Zo9pOF+NIDo=;
        b=PyDbIFuKDec5Thz/IC3kKD6azGLXwpjmX3G4+3rLXjxlSCSubTgAZjn+BxDZriuRzH
         culM5OT5B74NjZanDWW6uQrhDAF/aoyy/ILCweay4dm+7ktJPcRpORAy/k4d0HnTL1fW
         I7SZInH6EHnOg+AiksWaitEusqhac1pNGsfZosBGMrau+7QYpzvOutGqvlA1IfB9iAOw
         ragkdkr0BZvSBemr5wR3BdUuI2xcNpK7JowcilcLBB5s/4IwJ0f4BPa6fkrpv4+QPaLm
         SU8XtgoH9kKvJhI5RI/0RuOJbRwn2q2Ws+xpPGHXTts3PiMQgMhd7Xu4y9GqqctXyobG
         HUag==
X-Forwarded-Encrypted: i=1; AJvYcCXXeMSZxAkTlOT0Ohyi4mba3/d1VFshDCwzSJJQv8/Z7LafzbJJ1IwC7+a7JFVIu2to1Hutzhw=@lists.linux.dev
X-Gm-Message-State: AOJu0Yw8yAoY4mpHCk+U3UnckEAJtwAf7nRT0WO+r9dxOHKdU+jPhuAY
	kn+Fx504W1vlO7FP4DDmoIpTV6DXA0lwILy2kV/I4HB0XNuGcIjtKrIx9FJjC/J+UCUqhgXW45S
	/fd+GzuJkqZuCSiuogL0SILE9JT1uxw==
X-Received: from wmqn19.prod.google.com ([2002:a05:600c:4f93:b0:483:a1ee:5eb8])
 (user=sebastianene job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:4fc5:b0:485:3b34:2f62 with SMTP id 5b1f17b1804b1-4853b343050mr131705485e9.14.1773146984437;
 Tue, 10 Mar 2026 05:49:44 -0700 (PDT)
Date: Tue, 10 Mar 2026 12:49:21 +0000
In-Reply-To: <20260310124933.830025-1-sebastianene@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260310124933.830025-1-sebastianene@google.com>
X-Mailer: git-send-email 2.53.0.473.g4a7958ca14-goog
Message-ID: <20260310124933.830025-3-sebastianene@google.com>
Subject: [PATCH 02/14] KVM: arm64: Track host-unmapped MMIO regions in a
 static array
From: Sebastian Ene <sebastianene@google.com>
To: alexandru.elisei@arm.com, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	android-kvm@google.com
Cc: catalin.marinas@arm.com, dbrazdil@google.com, joey.gouly@arm.com, 
	kees@kernel.org, mark.rutland@arm.com, maz@kernel.org, oupton@kernel.org, 
	perlarsen@google.com, qperret@google.com, rananta@google.com, 
	sebastianene@google.com, smostafa@google.com, suzuki.poulose@arm.com, 
	tabba@google.com, tglx@kernel.org, vdonnefort@google.com, bgrzesik@google.com, 
	will@kernel.org, yuzenghui@huawei.com
Content-Type: text/plain; charset="UTF-8"

Introduce a registry to track protected MMIO regions that are unmapped
from the host stage-2 page tables. These regions are stored in a
fixed-size array and their ownership is donated to the hypervisor during
initialization to ensure host-exclusion and persistent tracking.

Signed-off-by: Sebastian Ene <sebastianene@google.com>
---
 arch/arm64/include/asm/kvm_pkvm.h     | 10 ++++++++++
 arch/arm64/kvm/hyp/nvhe/mem_protect.c |  3 +++
 arch/arm64/kvm/hyp/nvhe/setup.c       | 25 +++++++++++++++++++++++++
 3 files changed, 38 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_pkvm.h b/arch/arm64/include/asm/kvm_pkvm.h
index 757076ad4ec9..48ec7d519399 100644
--- a/arch/arm64/include/asm/kvm_pkvm.h
+++ b/arch/arm64/include/asm/kvm_pkvm.h
@@ -17,6 +17,16 @@
 
 #define HYP_MEMBLOCK_REGIONS 128
 
+#define PKVM_PROTECTED_REGS_NUM	8
+
+struct pkvm_protected_reg {
+	u64 start_pfn;
+	size_t num_pages;
+};
+
+extern struct pkvm_protected_reg kvm_nvhe_sym(pkvm_protected_regs)[];
+extern unsigned int kvm_nvhe_sym(num_protected_reg);
+
 int pkvm_init_host_vm(struct kvm *kvm);
 int pkvm_create_hyp_vm(struct kvm *kvm);
 bool pkvm_hyp_vm_is_created(struct kvm *kvm);
diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
index 0808367c52e5..7c125836b533 100644
--- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
+++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
@@ -23,6 +23,9 @@
 
 struct host_mmu host_mmu;
 
+struct pkvm_protected_reg pkvm_protected_regs[PKVM_PROTECTED_REGS_NUM];
+unsigned int num_protected_reg;
+
 static struct hyp_pool host_s2_pool;
 
 static DEFINE_PER_CPU(struct pkvm_hyp_vm *, __current_vm);
diff --git a/arch/arm64/kvm/hyp/nvhe/setup.c b/arch/arm64/kvm/hyp/nvhe/setup.c
index 90bd014e952f..ad5b96085e1b 100644
--- a/arch/arm64/kvm/hyp/nvhe/setup.c
+++ b/arch/arm64/kvm/hyp/nvhe/setup.c
@@ -284,6 +284,27 @@ static int fix_hyp_pgtable_refcnt(void)
 				&walker);
 }
 
+static int unmap_protected_regions(void)
+{
+	struct pkvm_protected_reg *reg;
+	int i, ret, j = 0;
+
+	for (i = 0; i < num_protected_reg; i++) {
+		reg = &pkvm_protected_regs[i];
+		for (j = 0; j < reg->num_pages; j++) {
+			ret = __pkvm_host_donate_hyp_mmio(reg->start_pfn + j);
+			if (ret)
+				goto err_setup;
+		}
+	}
+
+	return 0;
+err_setup:
+	for (j = j - 1; j >= 0; j--)
+		__pkvm_hyp_donate_host_mmio(reg->start_pfn + j);
+	return ret;
+}
+
 void __noreturn __pkvm_init_finalise(void)
 {
 	struct kvm_cpu_context *host_ctxt = host_data_ptr(host_ctxt);
@@ -324,6 +345,10 @@ void __noreturn __pkvm_init_finalise(void)
 	if (ret)
 		goto out;
 
+	ret = unmap_protected_regions();
+	if (ret)
+		goto out;
+
 	ret = hyp_ffa_init(ffa_proxy_pages);
 	if (ret)
 		goto out;
-- 
2.53.0.473.g4a7958ca14-goog

