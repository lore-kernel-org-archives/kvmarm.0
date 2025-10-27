Received: from mail-ej1-f73.google.com (mail-ej1-f73.google.com [209.85.218.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BDC92FB975
	for <kvmarm@lists.linux.dev>; Mon, 27 Oct 2025 11:39:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761565191; cv=none; b=PaLfLNVdFblU1A6NOhsGqIfRBR5HjJOqrPyWyDAvfRAdXJQdPO2Ye5blXTiashmOSBT5U5LAraRD4z8BpGJbgZyRcWM8GOGCgja28d75e3fLV12DOsiqlPijX2xbSOPSZXHf9I/gVWkCcvKQ7dyAjLnsC5W3zxn6Uvbp94kctR4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761565191; c=relaxed/simple;
	bh=QrgMpQfX0rEm+71yHpj1ZdDFSmCyUNlm47eNRQHjeTA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=eQkvsfgpWD7kYsvP9JmLPX3o/zu1QfpEWV9zHufEoM/wQ9lOIxTZ+QsUymbTNu+GrG548HHSVMlD96yqgu6/o6RhCaj6G5P5P92MXB0dU4FY/uvzhojBhktc/nUNVAYaW2f13WiyPGzIwEchhA9eJR479eM37svUbIJj9yP30tE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=O+T1ky2B; arc=none smtp.client-ip=209.85.218.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="O+T1ky2B"
Received: by mail-ej1-f73.google.com with SMTP id a640c23a62f3a-b6d7ad47b58so234606266b.1
        for <kvmarm@lists.linux.dev>; Mon, 27 Oct 2025 04:39:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1761565188; x=1762169988; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Ap94pVeJZZkbo7tUJgzqZixZK35kctleCNA5GGl6HeE=;
        b=O+T1ky2BwvPg9VDbbBWHOaRDIGMgY12GGyrEz/gUg2JTc/kOQF7XkThrf/R+3SCGgJ
         CIoYLoq5Ek6TZi1MH7FPTvZXPLppbb2UPtb394almM9d69HnRG2GSgYupTsXzcW2qf26
         t7WsNxQlSALBvmFLM61C+FvM7fHs62jFdwdZZ3NkekkjG8tY7gvhMJbu9JCEk5z++FYB
         h2bGAj6edoQ+K7cgmfNoc/2mT8MdkuEOBpxAhnqlLPBqIO29nvW2KKKrEY56TLR7IsQq
         Dwun8uw63qaGyfSq7NizPc4+kfscUhh/opaDVHZfJiNlALJ+EfAfwhnZ7FQuuH17/Dw2
         yMZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761565188; x=1762169988;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Ap94pVeJZZkbo7tUJgzqZixZK35kctleCNA5GGl6HeE=;
        b=MLGCyyuf9KAkgL6u9THGgnjZk17fOpPRXRibiHwlLPnsr48mOOKRXjI+YszlDdqe50
         9WVwEGGJcszRxgJxk+9DRKQFKtVidUzMW5g5QSwWVOaqIyTK7E+vypBZe4vDyTFEVhIu
         OOT+b+J2mGpOgzfnSlBY2EiicsB3DOL9RwnRmRaY00zh4P9QK8/xICQlf4xmqFnWwe8i
         I/ltgubPYyvjLMtZBWrZg/oK4/cqx+hgeTXDDg++d9lx4HrjSu1+46UrWyteH7HWGSgl
         60BE1sQuAckURMB0uXa0XXkmxKHFR0igqdcbM/BBmVCTL8VLlYO9v5pfXBYzLjUI6d5r
         IvwQ==
X-Gm-Message-State: AOJu0YxWOB95rfmKvl3ZUN9XDYZ1f7jD8Nmg2q/Di9A2rsElxLcmyjfA
	ckkPjfodCQVfz1P5Lzz/rLjvN3pSoGc+L4eIN6n0ts7z66DLyZPbO0dI6XJgN5yd8KEKuJPuvhp
	JzYGYghTCkAuAXOeKopydfh/bywAXbaTfIAZWiVfS6SU34bZBMdjP+WWfKYd7zVcmYAVIe/r/0r
	Rn5VyQeRmzoW9xyLnQIrzapni1cImxVxw=
X-Google-Smtp-Source: AGHT+IEScGbQWgMIwv19VMFWWRVfMiY9MCUgqr470ew7BdFYncsGhLIeFlTXYgFnqeoynaMCqmdqQeqXTA==
X-Received: from ejed21.prod.google.com ([2002:a17:906:1755:b0:b55:f065:b57a])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a17:907:6d0f:b0:b0c:b51b:81f6
 with SMTP id a640c23a62f3a-b647423c403mr4390703766b.43.1761565187382; Mon, 27
 Oct 2025 04:39:47 -0700 (PDT)
Date: Mon, 27 Oct 2025 11:39:42 +0000
In-Reply-To: <20251027113943.1282568-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20251027113943.1282568-1-tabba@google.com>
X-Mailer: git-send-email 2.51.1.838.g19442a804e-goog
Message-ID: <20251027113943.1282568-4-tabba@google.com>
Subject: [PATCH v1 3/4] KVM: arm64: Add compile-time type check to vcpu_write_sys_reg()
From: Fuad Tabba <tabba@google.com>
To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org
Cc: maz@kernel.org, oliver.upton@linux.dev, will@kernel.org, 
	joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, 
	catalin.marinas@arm.com, tabba@google.com
Content-Type: text/plain; charset="UTF-8"

The vcpu_write_sys_reg() function, like __vcpu_assign_sys_reg(),
is susceptible to parameter transposition bugs where the 'u64 val' is
accidentally passed in the 'reg' slot.

Even with the now-consistent parameter ordering, this remains a risk.

To apply the same compile-time checks, vcpu_write_sys_reg() is converted
into a macro. The original function implementation is converted into a
helper as _vcpu_write_sys_reg(). The new macro wrapper performs the same
type compatibility check as its `__vcpu_assign_sys_reg` counterpart,
preventing the 'reg' parameter from being a 'u64'.

This patch also includes related cleanups made necessary or apparent by
this change:
* The 'reg' parameters for __vcpu_read_sys_reg() and
  __vcpu_write_sys_reg() are tightened from 'int' to 'enum vcpu_sysreg'.
* The 'struct sys_reg_desc.reg' field is changed from 'int' to 'enum
  vcpu_sysreg'.

No functional change intended.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/include/asm/kvm_host.h | 8 +++++++-
 arch/arm64/kvm/hyp/exception.c    | 4 ++--
 arch/arm64/kvm/sys_regs.c         | 2 +-
 arch/arm64/kvm/sys_regs.h         | 2 +-
 4 files changed, 11 insertions(+), 5 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 2c33ea5fdb1c..2b7c8ba8802d 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -1168,7 +1168,13 @@ u64 kvm_vcpu_apply_reg_masks(const struct kvm_vcpu *, enum vcpu_sysreg, u64);
 	})
 
 u64 vcpu_read_sys_reg(const struct kvm_vcpu *, enum vcpu_sysreg);
-void vcpu_write_sys_reg(struct kvm_vcpu *, enum vcpu_sysreg, u64);
+void _vcpu_write_sys_reg(struct kvm_vcpu *, enum vcpu_sysreg, u64);
+
+#define vcpu_write_sys_reg(v, r, val)						\
+	do {									\
+		BUILD_BUG_ON_ZERO(__builtin_types_compatible_p(typeof(r), u64));\
+		_vcpu_write_sys_reg(v, r, val);					\
+	} while (0)
 
 struct kvm_vm_stat {
 	struct kvm_vm_stat_generic generic;
diff --git a/arch/arm64/kvm/hyp/exception.c b/arch/arm64/kvm/hyp/exception.c
index a5e5eda7aba0..6f8b1b5f2cab 100644
--- a/arch/arm64/kvm/hyp/exception.c
+++ b/arch/arm64/kvm/hyp/exception.c
@@ -20,7 +20,7 @@
 #error Hypervisor code only!
 #endif
 
-static inline u64 __vcpu_read_sys_reg(const struct kvm_vcpu *vcpu, int reg)
+static inline u64 __vcpu_read_sys_reg(const struct kvm_vcpu *vcpu, enum vcpu_sysreg reg)
 {
 	if (has_vhe())
 		return vcpu_read_sys_reg(vcpu, reg);
@@ -28,7 +28,7 @@ static inline u64 __vcpu_read_sys_reg(const struct kvm_vcpu *vcpu, int reg)
 	return __vcpu_sys_reg(vcpu, reg);
 }
 
-static inline void __vcpu_write_sys_reg(struct kvm_vcpu *vcpu, int reg, u64 val)
+static inline void __vcpu_write_sys_reg(struct kvm_vcpu *vcpu, enum vcpu_sysreg reg, u64 val)
 {
 	if (has_vhe())
 		vcpu_write_sys_reg(vcpu, reg, val);
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index d0d696d0819a..8e323353383c 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -338,7 +338,7 @@ u64 vcpu_read_sys_reg(const struct kvm_vcpu *vcpu, enum vcpu_sysreg reg)
 	return __vcpu_sys_reg(vcpu, reg);
 }
 
-void vcpu_write_sys_reg(struct kvm_vcpu *vcpu, enum vcpu_sysreg reg, u64 val)
+void _vcpu_write_sys_reg(struct kvm_vcpu *vcpu, enum vcpu_sysreg reg, u64 val)
 {
 	struct sr_loc loc = {};
 
diff --git a/arch/arm64/kvm/sys_regs.h b/arch/arm64/kvm/sys_regs.h
index b3f904472fac..a98c3aadcdbd 100644
--- a/arch/arm64/kvm/sys_regs.h
+++ b/arch/arm64/kvm/sys_regs.h
@@ -78,7 +78,7 @@ struct sys_reg_desc {
 	u64 (*reset)(struct kvm_vcpu *, const struct sys_reg_desc *);
 
 	/* Index into sys_reg[], or 0 if we don't need to save it. */
-	int reg;
+	enum vcpu_sysreg reg;
 
 	/* Value (usually reset value), or write mask for idregs */
 	u64 val;
-- 
2.51.1.838.g19442a804e-goog

