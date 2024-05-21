Received: from mail-wr1-f73.google.com (mail-wr1-f73.google.com [209.85.221.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5977B14430B
	for <kvmarm@lists.linux.dev>; Tue, 21 May 2024 16:37:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716309451; cv=none; b=rG/s+4GGDijLc/0Z8P/n/cdIPvQ24Uk1+QEw2m6SxpmgkzFwnDevcWegBRSg6JR/kNftTYHZXLTcrt+05/031RTrZRxlUMe4zZ/cAmdQ2wO0k6L3zY8maVoRsYrX1uzB35kkzg3xPyyMcTXeG/qaddaSsnhUbjG+QzKvyf7gPCY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716309451; c=relaxed/simple;
	bh=2lczWvFS7xnqALrdERphDZmIOZcfTeLs3ATpyUQhUc0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=R+zabQvlZae6zMoTFrnADEh77NN19hROIL3VGIOUYx/+KkoB8IH1iM7oZjK0nuqxCrslKld1ro2zcTt9n7WkzyIyRPzczxhcz0Y38y3DvVXyFmwqrOmV8liHJTtgCimc6D1cW9kVe+5dTOQRLY213PCSqH8uQV74fd1O1uROODw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=PFiDKJsQ; arc=none smtp.client-ip=209.85.221.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="PFiDKJsQ"
Received: by mail-wr1-f73.google.com with SMTP id ffacd0b85a97d-34f1b148725so6541603f8f.2
        for <kvmarm@lists.linux.dev>; Tue, 21 May 2024 09:37:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1716309447; x=1716914247; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=qM7MaDr9CpivvqNNyOUosWznQ5pqer0TTHUvnFjv67Y=;
        b=PFiDKJsQtgBwmuHOGwiSldzPy9kamnrnOu16BunWqdK52krXme9nOEk/Nr0bbYcHBR
         DEAF46mta549EhpN7IH4azAmn53MjzAZZVkG3Y17TYWp/1eLrKyob3ZMwgm3uR1gyDHS
         kLVa+PP0SjESQEPmkPi84zhSIbT+3Xy9jPdVhHhitEDEiMzxmgEHWuIl6poA+oyMKQpo
         1V/S4dGRAaXWzAXeBhHvjX++d/NvmarL9nRTINWrdlsETz9WUjryPuQ7HImQGVOZR6Kh
         hYEWANaDX/rGgl8cGEiUBqPKXhPQxo2oPMn7Bm0EMRN85JmxtcGibSPikyYlfYAjG9xZ
         y64A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716309447; x=1716914247;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=qM7MaDr9CpivvqNNyOUosWznQ5pqer0TTHUvnFjv67Y=;
        b=NdjROT/OPu4fg2iQ70HMm1+aBQT7R4gqysiZtB6pwwioff9DtJlAg0KosFfKSbVFN4
         lq9qN50jFYrxWWtRkQq932VjiRK9qWiV3oW8OqmFD+XfjGucneLX/Qeh3IcA0nJCYd+o
         Koihf3qWWV2N2pQBF1G2WGHEdA7/QoKZ3jgthpA5zVCck2BuvGWpUqZK6pQyDlXjXzSB
         aoc0OYGlgKHnQfoJ6vnSKra65D8/jJrVuUTBj5fl+ZjblcNXKtRaoL1MW//a3oE0LVNm
         LXqZrKmAr+oLiU4AC518rKMCZ/GgZ2QpO9XEONpLctn2lrLAX2KQ6rxTxHSTYAmjD5Hl
         jn3A==
X-Gm-Message-State: AOJu0Yza0/lXtnVaHQYHtviQIurnHXa+7ICaVCOKBRJv7aXbOjjc/4VF
	+LqectBjGInknUP3SxDCYXjNBqNVTsfxNd/WBt8UoBnQuOzJ8y/1FpcYDlRJ9YlHuy9hgOQewuq
	9gImohThMTkEE0ViqicT/7vehGmPSuNRH8d5VwdTQAhtosd8phaMqtOeXGZbDpWx/2tvTvDO6hm
	ybrpnas/W/nufvQnA+IAD2LO9fsdk=
X-Google-Smtp-Source: AGHT+IF7pTfBNI9/cdzTWRcOBKf+eLrgkRMeox2U+s+nwscYh0ETxGXw0O/27+sCSr9T/y2Pwx0FmvmGHA==
X-Received: from fuad.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1613])
 (user=tabba job=sendgmr) by 2002:a05:600c:3b0a:b0:418:37e1:3d43 with SMTP id
 5b1f17b1804b1-41fea52e813mr1929105e9.0.1716309447626; Tue, 21 May 2024
 09:37:27 -0700 (PDT)
Date: Tue, 21 May 2024 17:37:15 +0100
In-Reply-To: <20240521163720.3812851-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240521163720.3812851-1-tabba@google.com>
X-Mailer: git-send-email 2.45.0.215.g3402c0e53f-goog
Message-ID: <20240521163720.3812851-3-tabba@google.com>
Subject: [PATCH v2 2/7] KVM: arm64: Abstract set/clear of CPTR_EL2 bits behind helper
From: Fuad Tabba <tabba@google.com>
To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org
Cc: maz@kernel.org, will@kernel.org, qperret@google.com, tabba@google.com, 
	seanjc@google.com, alexandru.elisei@arm.com, catalin.marinas@arm.com, 
	philmd@linaro.org, james.morse@arm.com, suzuki.poulose@arm.com, 
	oliver.upton@linux.dev, mark.rutland@arm.com, broonie@kernel.org, 
	joey.gouly@arm.com, rananta@google.com, yuzenghui@huawei.com
Content-Type: text/plain; charset="UTF-8"

The same traps controlled by CPTR_EL2 or CPACR_EL1 need to be
toggled in different parts of the code, but the exact bits and
their polarity differ between these two formats and the mode
(vhe/nvhe/hvhe).

To reduce the amount of duplicated code and the chance of getting
the wrong bit/polarity or missing a field, abstract the set/clear
of CPTR_EL2 bits behind a helper.

Since (h)VHE is the way of the future, use the CPACR_EL1 format,
which is a subset of the VHE CPTR_EL2, as a reference.

No functional change intended.

Suggested-by: Oliver Upton <oliver.upton@linux.dev>
Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/include/asm/kvm_emulate.h    | 34 +++++++++++++++++++++++++
 arch/arm64/kvm/hyp/include/hyp/switch.h | 17 +++----------
 arch/arm64/kvm/hyp/nvhe/hyp-main.c      |  6 +----
 3 files changed, 39 insertions(+), 18 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
index 501e3e019c93..74837d1762e5 100644
--- a/arch/arm64/include/asm/kvm_emulate.h
+++ b/arch/arm64/include/asm/kvm_emulate.h
@@ -557,6 +557,40 @@ static __always_inline void kvm_incr_pc(struct kvm_vcpu *vcpu)
 		vcpu_set_flag((v), e);					\
 	} while (0)
 
+
+static inline void __cptr_clear_set_nvhe(u64 cpacr_clr, u64 cpacr_set)
+{
+	u64 clr = 0, set = 0;
+
+	if (cpacr_clr & CPACR_ELx_FPEN)
+		set |= CPTR_EL2_TFP;
+	if (cpacr_clr & CPACR_ELx_ZEN)
+		set |= CPTR_EL2_TZ;
+	if (cpacr_clr & CPACR_ELx_SMEN)
+		set |= CPTR_EL2_TSM;
+	if (cpacr_clr & CPACR_ELx_TTA)
+		clr |= CPTR_EL2_TTA;
+
+	if (cpacr_set & CPACR_ELx_FPEN)
+		clr |= CPTR_EL2_TFP;
+	if (cpacr_set & CPACR_ELx_ZEN)
+		clr |= CPTR_EL2_TZ;
+	if (cpacr_set & CPACR_ELx_SMEN)
+		clr |= CPTR_EL2_TSM;
+	if (cpacr_set & CPACR_ELx_TTA)
+		set |= CPTR_EL2_TTA;
+
+	sysreg_clear_set(cptr_el2, clr, set);
+}
+
+static inline void cpacr_clear_set(u64 clr, u64 set)
+{
+        if (has_vhe() || has_hvhe())
+                sysreg_clear_set(cpacr_el1, clr, set);
+        else
+                __cptr_clear_set_nvhe(clr, set);
+}
+
 static __always_inline void kvm_write_cptr_el2(u64 val)
 {
 	if (has_vhe() || has_hvhe())
diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h b/arch/arm64/kvm/hyp/include/hyp/switch.h
index a92566f36022..2ebe2fea8768 100644
--- a/arch/arm64/kvm/hyp/include/hyp/switch.h
+++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
@@ -353,19 +353,10 @@ static bool kvm_hyp_handle_fpsimd(struct kvm_vcpu *vcpu, u64 *exit_code)
 	/* Valid trap.  Switch the context: */
 
 	/* First disable enough traps to allow us to update the registers */
-	if (has_vhe() || has_hvhe()) {
-		reg = CPACR_EL1_FPEN_EL0EN | CPACR_EL1_FPEN_EL1EN;
-		if (sve_guest)
-			reg |= CPACR_EL1_ZEN_EL0EN | CPACR_EL1_ZEN_EL1EN;
-
-		sysreg_clear_set(cpacr_el1, 0, reg);
-	} else {
-		reg = CPTR_EL2_TFP;
-		if (sve_guest)
-			reg |= CPTR_EL2_TZ;
-
-		sysreg_clear_set(cptr_el2, reg, 0);
-	}
+	reg = CPACR_EL1_FPEN_EL0EN | CPACR_EL1_FPEN_EL1EN;
+	if (sve_guest)
+		reg |= CPACR_EL1_ZEN_EL0EN | CPACR_EL1_ZEN_EL1EN;
+	cpacr_clear_set(0, reg);
 	isb();
 
 	/* Write out the host state if it's in the registers */
diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
index d5c48dc98f67..b07d44484f42 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
@@ -405,11 +405,7 @@ void handle_trap(struct kvm_cpu_context *host_ctxt)
 		handle_host_smc(host_ctxt);
 		break;
 	case ESR_ELx_EC_SVE:
-		if (has_hvhe())
-			sysreg_clear_set(cpacr_el1, 0, (CPACR_EL1_ZEN_EL1EN |
-							CPACR_EL1_ZEN_EL0EN));
-		else
-			sysreg_clear_set(cptr_el2, CPTR_EL2_TZ, 0);
+		cpacr_clear_set(0, (CPACR_EL1_ZEN_EL1EN | CPACR_EL1_ZEN_EL0EN));
 		isb();
 		sve_cond_update_zcr_vq(ZCR_ELx_LEN_MASK, SYS_ZCR_EL2);
 		break;
-- 
2.45.0.215.g3402c0e53f-goog

