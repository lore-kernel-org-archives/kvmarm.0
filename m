Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com [209.85.128.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F8DF4B04AC
	for <kvmarm@lists.linux.dev>; Fri,  7 Aug 2026 16:43:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.71
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786121025; cv=none; b=FcAXqMfjr4PbX2FlubZoV3W0VRGXKz6NmH9xjkkvOKgiD1BPhCn2e/JTTPb91a5SbSlsv2UIrpDqpkXT8WNDGJFCiOMP3F7o4gfahAKiPTQ1fal0jO6K/OJwTFIrONWv08Ti5ugUgFife67k9LEzyqN4oLpHeU/PYo/tmhLwgSA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786121025; c=relaxed/simple;
	bh=fW4c7LYnBzLD1FiWd4akwgLLfkkoP/cLS3UvI0SBd6c=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=OyUn9HEWsylXOxuXZx28dCxrJD8d00hRBY48YlmZ11p1jN9qlqnrHnVlON6UwUMYwS1LTxPnc3MF1Wd2bxYoHtRK+qscjL2LERQswV1u9QZcQMkQCg+GyYfltrLb2HpY5eL+v1WzpAGdC2TU3Xva26OwZcBCpC/sudNC3zRHpGQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--sebastianene.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=QlDs3+QO; arc=none smtp.client-ip=209.85.128.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--sebastianene.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="QlDs3+QO"
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-4955d314945so19118405e9.0
        for <kvmarm@lists.linux.dev>; Fri, 07 Aug 2026 09:43:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1786121021; x=1786725821; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=9LMvLSIyRJoS17MqrfOagB9BtwOQBhza88CokriU1a0=;
        b=QlDs3+QO6HB449n3cQmhnCeqcb6YmrsIYJ46quUts4y/2F/4qPWAkIxEKtXphTCwy1
         U0IJc5gPM15AqDJ3JmD6h4TYqyJN+OW1gknoc7ChIYf7xndv5dlKzby6yYx6YcqrAHSM
         TANR3tqbYz/Z252Z3dIjCjqevOjqlWypOGu2dXhhchcoZPJGrFIoa7/Goy3Uc//FDk0W
         mKgVYCfJWviNDedFBHfpkvQvh3gTn0dPzyGv+VZ1hN6/+jma6skAa7viZzoa1gDXHh7F
         QtqWpkgmY51hHWzlYesMixZw5CF+F0WVHXSTZvZFIw1sVVJqtikykzmSAAvwPMNrbAFE
         8ASA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786121021; x=1786725821;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=9LMvLSIyRJoS17MqrfOagB9BtwOQBhza88CokriU1a0=;
        b=ExBGRRWqw5usf/Kibnzc1EBzhvYBikEjXCbiB0B3w33p3Zp+ZfpDoY0WPAqc7qnwxh
         61vgen0WctYmTZ3ZCgI3LP8vMPKGiqf6EBDXQELZushDKzEWv86ShcfkFBTeg9bJwMGN
         7mIH509Nzmg3VBseqWx61q5zQ+G2/xcv/c/6RNuXTDUmyIm04WhXLNrjo+Zg3qRstYrM
         KFFRJ46cQ4jcqAVxFS7V6ch293858oU9NIS2ROqg9N+nKFxD+D5ZJm5xYi9+Ac5wkUVd
         XCekXGCYxR4pFDI4sTKbLo8msIouH5ZeHqVotPwaaF4Nr77nbhul706UxWzQVV++3gkB
         AJcA==
X-Gm-Message-State: AOJu0YzwWNNV+XJ7BSqVxVbMHdWSgRma7GZslTclluYD66WtE5CcrxaY
	ysOj+Smf9yWQVadDHmXbke7t2FyJOAZIhnPLrtz9Cf6g20OPNYoilc08WzauhhVMwHi95M9Uhr4
	JRHuWX44vwQ25/aiR2aMoTv3UKIWraA==
X-Received: from wrrq16.prod.google.com ([2002:adf:f950:0:b0:47f:8ed4:b07f])
 (user=sebastianene job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:4e12:b0:499:61bb:6c78 with SMTP id 5b1f17b1804b1-49961bb71abmr15660795e9.14.1786121021370;
 Fri, 07 Aug 2026 09:43:41 -0700 (PDT)
Date: Fri,  7 Aug 2026 16:43:12 +0000
In-Reply-To: <20260807164322.2970811-2-sebastianene@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260807164322.2970811-2-sebastianene@google.com>
X-Mailer: git-send-email 2.55.0.654.g21b8a5bc05-goog
Message-ID: <20260807164322.2970811-4-sebastianene@google.com>
Subject: [PATCH v2 02/13] KVM: arm64: Track host-unmapped MMIO regions in a
 static array
From: Sebastian Ene <sebastianene@google.com>
To: catalin.marinas@arm.com, fuad.tabba@linux.dev, joey.gouly@arm.com, 
	mark.rutland@arm.com, maz@kernel.org, oupton@kernel.org, rananta@google.com, 
	Sascha.Bischoff@arm.com, suzuki.poulose@arm.com, will@kernel.org
Cc: kvmarm@lists.linux.dev, android-kvm@google.com, bgrzesik@google.com, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	nathan@kernel.org, perlarsen@google.com, sebastianene@google.com, 
	seiden@linux.ibm.com, smostafa@google.com, tglx@kernel.org, 
	vdonnefort@google.com, vladimir.murzin@arm.com, yuzenghui@huawei.com, 
	zenghui.yu@linux.dev
Content-Type: text/plain; charset="UTF-8"

Introduce a registry to track protected MMIO regions that are unmapped
from the host stage-2 page tables. These regions are stored in a
fixed-size array and their ownership is donated to the hypervisor during
initialization to ensure host-exclusion and persistent tracking.

Signed-off-by: Sebastian Ene <sebastianene@google.com>
---
 arch/arm64/include/asm/kvm_pkvm.h     | 11 +++++++++++
 arch/arm64/kvm/hyp/nvhe/mem_protect.c |  3 +++
 arch/arm64/kvm/hyp/nvhe/setup.c       | 24 ++++++++++++++++++++++++
 3 files changed, 38 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_pkvm.h b/arch/arm64/include/asm/kvm_pkvm.h
index 74fedd9c5ff0..ab26bec079d6 100644
--- a/arch/arm64/include/asm/kvm_pkvm.h
+++ b/arch/arm64/include/asm/kvm_pkvm.h
@@ -17,6 +17,17 @@
 
 #define HYP_MEMBLOCK_REGIONS 128
 
+/* The maximum number of hypervisor protected regions from the host */
+#define PKVM_PROTECTED_REGS_NUM	8
+
+struct pkvm_protected_reg {
+	u64 pfn;
+	u64 nr_pages;
+};
+
+extern struct pkvm_protected_reg kvm_nvhe_sym(pkvm_protected_regs)[];
+extern unsigned int kvm_nvhe_sym(num_protected_reg);
+
 int pkvm_init_host_vm(struct kvm *kvm, unsigned long type);
 int pkvm_create_hyp_vm(struct kvm *kvm);
 bool pkvm_hyp_vm_is_created(struct kvm *kvm);
diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
index 5cf7c4a0ed20..500c18c2fd48 100644
--- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
+++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
@@ -28,6 +28,9 @@ struct host_mmu host_mmu;
 
 static struct hyp_pool host_s2_pool;
 
+unsigned int num_protected_reg;
+struct pkvm_protected_reg pkvm_protected_regs[PKVM_PROTECTED_REGS_NUM];
+
 static DEFINE_PER_CPU(struct pkvm_hyp_vm *, __current_vm);
 #define current_vm (*this_cpu_ptr(&__current_vm))
 
diff --git a/arch/arm64/kvm/hyp/nvhe/setup.c b/arch/arm64/kvm/hyp/nvhe/setup.c
index 75b00c323310..64c0290da888 100644
--- a/arch/arm64/kvm/hyp/nvhe/setup.c
+++ b/arch/arm64/kvm/hyp/nvhe/setup.c
@@ -284,6 +284,26 @@ static int fix_hyp_pgtable_refcnt(void)
 				&walker);
 }
 
+static int donate_protected_mmio_regions(void)
+{
+	int ret;
+	int i;
+
+	for (i = 0; i < num_protected_reg; i++) {
+		ret = __pkvm_host_donate_hyp_mmio(hyp_pfn_to_phys(pkvm_protected_regs[i].pfn),
+						  pkvm_protected_regs[i].nr_pages << PAGE_SHIFT);
+		if (ret)
+			goto err_setup;
+	}
+
+	return 0;
+err_setup:
+	while (--i >= 0)
+		__pkvm_hyp_donate_host_mmio(hyp_pfn_to_phys(pkvm_protected_regs[i].pfn),
+					    pkvm_protected_regs[i].nr_pages << PAGE_SHIFT);
+	return ret;
+}
+
 void __noreturn __pkvm_init_finalise(void)
 {
 	struct kvm_cpu_context *host_ctxt = host_data_ptr(host_ctxt);
@@ -324,6 +344,10 @@ void __noreturn __pkvm_init_finalise(void)
 	if (ret)
 		goto out;
 
+	ret = donate_protected_mmio_regions();
+	if (ret)
+		goto out;
+
 	ret = hyp_ffa_init(ffa_proxy_pages);
 	if (ret)
 		goto out;
-- 
2.55.0.654.g21b8a5bc05-goog

