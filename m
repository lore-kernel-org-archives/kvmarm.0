Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7459A8664B
	for <kvmarm@lists.linux.dev>; Tue, 16 Apr 2024 09:58:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713261503; cv=none; b=cLgJKr0pHQp7JwRtSKJHJSxD+JTVbWNlEQmnuu2VjBJlA8Vllo2hwQbavgD8vL110Y65Xjl9WL3LW+oLh3Xer21n86zfthswXov2yuZn4BeSuy2E1RiAByagTQS4gOucuwEozols2XhjNntnmhUrDVyNk7MWZp0LJ4b8FqCGQag=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713261503; c=relaxed/simple;
	bh=XbOwtsuAHG0HXvsOc/mNxIwujBTOr4lyy/xXHhAO9iE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Rhui3rYuHNvyWM0bERor+h0zr9UN+3OYi7fAQxXL5qbF8bJ6JV37wuQ1wJGaEywV3rcEm+hh/ES9Bi48oRGX06i4391LYsYY2v1NzZO0NCdz3q8K2ruRiwrCBSmS/dgUNS+IJmVlHugDKt55l0/C9rJ67C3AC5WM4JHGtP0sOeY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=rx6aX7nq; arc=none smtp.client-ip=209.85.219.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="rx6aX7nq"
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-dced704f17cso7122664276.1
        for <kvmarm@lists.linux.dev>; Tue, 16 Apr 2024 02:58:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1713261501; x=1713866301; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=d5WVjI35GVkkSAI7X82yBFdxJ6M9HJ12u6871QZ2KQU=;
        b=rx6aX7nqJjMAAlm/xYeHCZ1jR3RuafGySLfy4SD5ppUdTSpt23OfEQkleaH1j++x+h
         LIjY1EQmvU7MSO9RlzYNsDADcSEDRiGhlWYKY7fyfuXIgN5uJME5gr7+TmYgk4fZuN2j
         xHmXQP0Mks23SUfhrM4GUBS1g8S6y968ilKvs5ECEbWjL0w5V7KnCChTPGQY04p8Wvn7
         kZ0Zqf0gHelvmKieZPXGe+oMOV3P2OgOSMx7LViOOTJacTNCJq3OoowmNUwWQyUV3/i+
         GT7OEcwvPzXWzEvWv4DSKBF2CjW2s8OwyfP2RCeviqFhMrZWuexJn/av6p+zUzlbEKct
         EWCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713261501; x=1713866301;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=d5WVjI35GVkkSAI7X82yBFdxJ6M9HJ12u6871QZ2KQU=;
        b=r73rV4jRuxQ3g8zLj/KN4wERfRYl3pyRz6fpdiCvkz76XuUQ2YS4OaSsu/d+G+yDLF
         0zwWXN9BIngfjmE2G9KRcRkUI/ucwXjK+/cUdk7iAy+DbuAonJbFpxFaSnL6cMCHe44u
         V3/TD/ZkrSQh/yXB+GKgpmyWcUm0gcEtuub4UPbKEAhPQCCkUVaox8zMlMfrbIlKwteb
         A+KbBYXqLq+F6YRo0tqowb5CkzlcSZ2ZEmAm79lrzzBD96U0YvlvBYknRXpgH+bmFH4R
         riAF62BQmzyKRGLoFQHCI+FgSu8wBQymQEeMg5OBdJmtVKa4ZFr+KvAqJxXpxF0BSopD
         uLYA==
X-Gm-Message-State: AOJu0YwrlKzucniE/k954jN+fqzZbqEjB03NM08URH/JW9ikNcERstHd
	anK0JRE4dkJkHFOFKdX0cY7GALPsMaLfT0RPJcv1QD0tODzZWIQ6NBlXvYFMw+Qc6OEdrgS/0Bm
	lEemH/ga4gMt0jNXqj2d0eUTzMZACAdeLBQSTj/5b9/IStd7I9h00AkkydvI9BVrIM6IrF+lDAw
	zK2gr8un0DXyQNHDvrful2+qiLSM0=
X-Google-Smtp-Source: AGHT+IEgIg74yUdsAYRd4TB1g4+xk4we4RAm5O3hnwvqynPZPjm67XOIP5lF53V0vkY3c9IJ5ekdRnRoEQ==
X-Received: from fuad.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1613])
 (user=tabba job=sendgmr) by 2002:a25:f624:0:b0:de1:21b4:76a5 with SMTP id
 t36-20020a25f624000000b00de121b476a5mr1257109ybd.13.1713261501077; Tue, 16
 Apr 2024 02:58:21 -0700 (PDT)
Date: Tue, 16 Apr 2024 10:56:35 +0100
In-Reply-To: <20240416095638.3620345-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240416095638.3620345-1-tabba@google.com>
X-Mailer: git-send-email 2.44.0.683.g7961c838ac-goog
Message-ID: <20240416095638.3620345-45-tabba@google.com>
Subject: [PATCH v2 44/47] KVM: arm64: Remove unused vcpu parameter from guest_owns_fp_regs()
From: Fuad Tabba <tabba@google.com>
To: kvmarm@lists.linux.dev
Cc: maz@kernel.org, will@kernel.org, qperret@google.com, tabba@google.com, 
	seanjc@google.com, alexandru.elisei@arm.com, catalin.marinas@arm.com, 
	philmd@linaro.org, james.morse@arm.com, suzuki.poulose@arm.com, 
	oliver.upton@linux.dev, mark.rutland@arm.com, broonie@kernel.org, 
	joey.gouly@arm.com, rananta@google.com, smostafa@google.com
Content-Type: text/plain; charset="UTF-8"

The host state is not per-vcpu anymore, and therefore, the vcpu
parameter isn't used.

No functional change intended.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/kvm/hyp/include/hyp/switch.h | 2 +-
 arch/arm64/kvm/hyp/nvhe/switch.c        | 2 +-
 arch/arm64/kvm/hyp/vhe/switch.c         | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h b/arch/arm64/kvm/hyp/include/hyp/switch.h
index 2629420d0659..6e2ddce7f830 100644
--- a/arch/arm64/kvm/hyp/include/hyp/switch.h
+++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
@@ -40,7 +40,7 @@ extern struct kvm_exception_table_entry __start___kvm_ex_table;
 extern struct kvm_exception_table_entry __stop___kvm_ex_table;
 
 /* Check whether the FP regs are owned by the guest */
-static inline bool guest_owns_fp_regs(struct kvm_vcpu *vcpu)
+static inline bool guest_owns_fp_regs(void)
 {
 	return *host_data_ptr(fp_owner) == FP_STATE_GUEST_OWNED;
 }
diff --git a/arch/arm64/kvm/hyp/nvhe/switch.c b/arch/arm64/kvm/hyp/nvhe/switch.c
index 580297a701d8..cc29e05980ec 100644
--- a/arch/arm64/kvm/hyp/nvhe/switch.c
+++ b/arch/arm64/kvm/hyp/nvhe/switch.c
@@ -53,7 +53,7 @@ static void __activate_traps(struct kvm_vcpu *vcpu)
 			val |= CPTR_EL2_TSM;
 	}
 
-	if (!guest_owns_fp_regs(vcpu)) {
+	if (!guest_owns_fp_regs()) {
 		if (has_hvhe())
 			val &= ~(CPACR_EL1_FPEN_EL0EN | CPACR_EL1_FPEN_EL1EN |
 				 CPACR_EL1_ZEN_EL0EN | CPACR_EL1_ZEN_EL1EN);
diff --git a/arch/arm64/kvm/hyp/vhe/switch.c b/arch/arm64/kvm/hyp/vhe/switch.c
index b92f9fe2d50e..7286db75b8d6 100644
--- a/arch/arm64/kvm/hyp/vhe/switch.c
+++ b/arch/arm64/kvm/hyp/vhe/switch.c
@@ -75,7 +75,7 @@ static void __activate_traps(struct kvm_vcpu *vcpu)
 
 	val |= CPTR_EL2_TAM;
 
-	if (guest_owns_fp_regs(vcpu)) {
+	if (guest_owns_fp_regs()) {
 		if (vcpu_has_sve(vcpu))
 			val |= CPACR_EL1_ZEN_EL0EN | CPACR_EL1_ZEN_EL1EN;
 	} else {
-- 
2.44.0.683.g7961c838ac-goog

