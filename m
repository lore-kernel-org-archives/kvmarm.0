Received: from mail-wr1-f74.google.com (mail-wr1-f74.google.com [209.85.221.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D77E917085F
	for <kvmarm@lists.linux.dev>; Tue, 28 May 2024 12:59:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716901162; cv=none; b=bnFimHNonfXCaOyVy5go3fMfgARf8HzJ2aFcoG+nzgwENww0Wy5ACk3GRDQwYn2t/Su8QD6ldTE8ih76FrIFrYBHAHe3Vd7ZKAPFMnor0nMZWa/mvR/bfNyq6WtrDiNT/dFh7JmnAXzifMC71CUrRk8jzYq2yWYzJU3Wc6C7Jjs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716901162; c=relaxed/simple;
	bh=RhSQUhyKIySS0z/ARl0aXmIXVCt0cUK/xOMgk4JSTGw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=JGP6hpzUzMuFjxYh6QplxNiaBgSgPecYm0padtJiOzwIbBWuzD9AMAJHiawedphtd9fKKuF+1TiJeSnxB69fjA1hrBhzRas5RwMeBucqOyGtZRy1UBTkOvi5F6n+0fdJFwnYn0Wbn4ROmAHB6fS5QK2jZ7ForY1EXnuyLmpjPOw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=HyLKFig+; arc=none smtp.client-ip=209.85.221.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="HyLKFig+"
Received: by mail-wr1-f74.google.com with SMTP id ffacd0b85a97d-35507e4c41dso1864915f8f.1
        for <kvmarm@lists.linux.dev>; Tue, 28 May 2024 05:59:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1716901159; x=1717505959; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=8IsZ1GELy5238TvDKHM/lAJZFBElfA3Wo5p26xdlYNc=;
        b=HyLKFig+FbQNHX3q+E1iMhQAHLDhM3U2uPQ9kPoFwH8hat5xW5Li38Gu/ULPHOM/Zp
         VI7B4KVygJbdvqzJQMt+FnRgy/j55VomBKsEhFeOmlI0wlc1YYIUpZuXJSi97z60xoob
         MAJJcA8U4HsigIVmzI5MaepNbTcUyiJnCPRUHUSMzJ7RbqZ/4oFZd8yGQX1JBOuY1TnV
         PWXGsAOD0UEQCsJyVhtNI1OmZCq1N9nkLqyvJWAXltcI5yZbXEa/VBxpMFFybRiDrKz0
         h6K7lwdzYlshbzujbSGmJ/+bs1tc7FQzqJ8ava0C8E8qL8EYu0S+JEMhuFnChBELfw+3
         eKcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716901159; x=1717505959;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=8IsZ1GELy5238TvDKHM/lAJZFBElfA3Wo5p26xdlYNc=;
        b=xTKCPCYDxh5YnVwGW0lIa1NKsl2xKyE8Co1B24Pix1ayJG0ScjWd+PbpH/w4YGl29r
         3XDsl0PL0dgRxM/esWVcZB2Ycit11o59dfrq2JUNW1YItIMyPjfO6bh9NoEq7pQneMSt
         9OJ6Cu9elOtzpuv5yzp9G2kyuxAmGS9uOfB28kyCUvi9pQ6oMoiS01qGUOnQOLrT/TLw
         R6w+7NaI8om0p/fnHgZtTYsU2V/z6JBqDs3U/B9CK3qTd/kucWzYTGny9KWCrDrQVyZa
         WtcaehdM2ttnZKroUos8+q490+dEMvurDy7nIiCYBfHYYK5/n7EKd5qL8my44oJvYloI
         DCRg==
X-Gm-Message-State: AOJu0YxDcY55MUhgXq6QU6PaqYGNoTdFwOJoIEhzLN/DzdmVuXL4TsgM
	irx5/2rEx46c71/qDxya39JKa6og+PHixdUmYiRxRE/mA1Z18Fz+WBkAWdIBRy8RB9N+FBe7ETP
	R89pmdhr58rcHrbj8rp22jFP7JRnF8z6ZPyOCdxIvEKtcFJlImEaNDnzGuJr6KbH1NjqZWd1tq5
	ftkGGDaorZpTRqvuUxyxYI0+IUOeI=
X-Google-Smtp-Source: AGHT+IH+4ivTnh3s1HTMAU8A6n7U1eTgKijj3YGTkxsUb8zkvkUHe4dYNt01Lbh6I1tXxMmZ1rcJR8HljQ==
X-Received: from fuad.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1613])
 (user=tabba job=sendgmr) by 2002:a5d:6489:0:b0:357:8a96:4eed with SMTP id
 ffacd0b85a97d-3578a964f70mr20501f8f.1.1716901159142; Tue, 28 May 2024
 05:59:19 -0700 (PDT)
Date: Tue, 28 May 2024 13:59:04 +0100
In-Reply-To: <20240528125914.277057-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240528125914.277057-1-tabba@google.com>
X-Mailer: git-send-email 2.45.1.288.g0e0cd299f1-goog
Message-ID: <20240528125914.277057-2-tabba@google.com>
Subject: [PATCH v3 01/11] KVM: arm64: Reintroduce __sve_save_state
From: Fuad Tabba <tabba@google.com>
To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org
Cc: maz@kernel.org, will@kernel.org, qperret@google.com, tabba@google.com, 
	seanjc@google.com, alexandru.elisei@arm.com, catalin.marinas@arm.com, 
	philmd@linaro.org, james.morse@arm.com, suzuki.poulose@arm.com, 
	oliver.upton@linux.dev, mark.rutland@arm.com, broonie@kernel.org, 
	joey.gouly@arm.com, rananta@google.com, yuzenghui@huawei.com
Content-Type: text/plain; charset="UTF-8"

Now that the hypervisor is handling the host sve state in
protected mode, it needs to be able to save it.

This reverts commit e66425fc9ba3 ("KVM: arm64: Remove unused
__sve_save_state").

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/include/asm/kvm_hyp.h | 1 +
 arch/arm64/kvm/hyp/fpsimd.S      | 6 ++++++
 2 files changed, 7 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_hyp.h b/arch/arm64/include/asm/kvm_hyp.h
index 3e80464f8953..2ab23589339a 100644
--- a/arch/arm64/include/asm/kvm_hyp.h
+++ b/arch/arm64/include/asm/kvm_hyp.h
@@ -111,6 +111,7 @@ void __debug_restore_host_buffers_nvhe(struct kvm_vcpu *vcpu);
 
 void __fpsimd_save_state(struct user_fpsimd_state *fp_regs);
 void __fpsimd_restore_state(struct user_fpsimd_state *fp_regs);
+void __sve_save_state(void *sve_pffr, u32 *fpsr);
 void __sve_restore_state(void *sve_pffr, u32 *fpsr);
 
 u64 __guest_enter(struct kvm_vcpu *vcpu);
diff --git a/arch/arm64/kvm/hyp/fpsimd.S b/arch/arm64/kvm/hyp/fpsimd.S
index 61e6f3ba7b7d..e950875e31ce 100644
--- a/arch/arm64/kvm/hyp/fpsimd.S
+++ b/arch/arm64/kvm/hyp/fpsimd.S
@@ -25,3 +25,9 @@ SYM_FUNC_START(__sve_restore_state)
 	sve_load 0, x1, x2, 3
 	ret
 SYM_FUNC_END(__sve_restore_state)
+
+SYM_FUNC_START(__sve_save_state)
+	mov	x2, #1
+	sve_save 0, x1, x2, 3
+	ret
+SYM_FUNC_END(__sve_save_state)
-- 
2.45.1.288.g0e0cd299f1-goog

