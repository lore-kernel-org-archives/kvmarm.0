Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA67C86250
	for <kvmarm@lists.linux.dev>; Tue, 16 Apr 2024 09:57:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713261449; cv=none; b=jn9TGI9nb5G5cyHA0+1k50Cp9MUsPLBvtZbkcLjSc8OgBQ1lF8JpLJELH8TaDm4zxIcduUzMCh96Dfcck0sEfvm6uE+sfgswVDsYk41uumLj2J/ziWZAbV3jcjmGpYgh6Yhq4b7+MVhItxit2lIcyeQYwd8e/1VDy+1LHlZIQGM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713261449; c=relaxed/simple;
	bh=j50rLHgjdMEnIajR8+OSYFK7aoakY4zvaprE1AMUj9c=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=cVfn2K0ZMQNNb9yYA59GYE9SSCV4aJV/7rElsomD/lexrifyxNHN2wb7cFkg7Ddr1jeHa7suYLDlNZgoPL6zLkOZq/D3pWV6tXVdRIwi9frgkZriYxZYpuLS0TmBemwQ7hLSuzqtaYU0ke0qAX62Ljzo8wQ0FhmKBySAJVTtCBg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=e56km+oT; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="e56km+oT"
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-61ab19438a3so40627257b3.1
        for <kvmarm@lists.linux.dev>; Tue, 16 Apr 2024 02:57:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1713261447; x=1713866247; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=2sEhxrpwtMQ+Swx/1fiQES3pVUiESJbSzVhdEQNB/hs=;
        b=e56km+oTm3tt9DGwi9O0YHosCghgsQX043NtacY2gNC7+D1HOmBBvDv+zhhUTsk3PZ
         lA89vBeVdfTd14Yc7qiRZSA6TNtSvkBKDk3g0KBjKkqa8k/d0lgUhqGYwsSSEJFnYwMb
         FDPxa8w5rHzIAk0X4MqbYh8SFdsTcRBP7bP4LniF1pFMV2/n9mLJTrSVUzRKXyF6Oyf4
         f5HxnhznOpxmtvRz8EGb/hhm8w/RRGnwULefy/5iywcH7YZOLXNf8NC12Iv0UcKelXBd
         f95kH1MfF6zWhwHUcXH/MJK28tqMQzYT4gjifLkjPHcV1vl98yl1A48GcdffUGKlRxSt
         mGUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713261447; x=1713866247;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=2sEhxrpwtMQ+Swx/1fiQES3pVUiESJbSzVhdEQNB/hs=;
        b=sM3ocevk/e5eT71Z/pltdfer+crzWUXAPB14TpaAwEDmAvGmfOKfwIY97+PBSji8PP
         Bd05JVkgjDkvRMPou1qTLBp7j2srKDJgrgvwy3NnPGHrQE6zIVrNeuVzVwJHjbU7RfDO
         p1MgQroDBsZZbbkkqxa57M8cidf77b4g8YpTsrGJKaVEY+uUHTFUwSuZl0b1X8QTEDW/
         MOeNJDE7Ztj3GLTCZivJyKEw1+F5GBKa0WX+MHP7yyMiiPtUtf8Sr0m27wOZpSKA1+79
         6NxbqRmdHIQbfLnZKdKLasy/LSitTtnYONvQ4bAXgq+Nb4t39VBz8lACRgXA5KapWr3s
         FiuA==
X-Gm-Message-State: AOJu0YzaTMs5CVXg2kq4cKKNs4MLnAAuOEbfzppXt6IaCHXSrMRvmIOl
	drYhEY0ECdtjjtC2ZfYpgbXvCg0etqkDDobqKspHgbyTBW0T5Lgb0TaKSElMT9vHOQksExuCz6L
	LwFQPORzl0uKR4AADhb0gFnoMBXbcWp3XiF/N+G+tJQogxBhOQOV4KfmSyg/1K1ymAlp1LKSnux
	4xdeNlm3djINupc0vw7aEgJ2PVfWI=
X-Google-Smtp-Source: AGHT+IFlvwbfTUKTQ5pefn3+YGMFeSkTVaN0Py19ZVb+MZ/DtOFFACAoS0ekipW1/i302TDIPQ68nv2upA==
X-Received: from fuad.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1613])
 (user=tabba job=sendgmr) by 2002:a81:5253:0:b0:61a:c438:6bc4 with SMTP id
 g80-20020a815253000000b0061ac4386bc4mr1341751ywb.3.1713261446741; Tue, 16 Apr
 2024 02:57:26 -0700 (PDT)
Date: Tue, 16 Apr 2024 10:56:11 +0100
In-Reply-To: <20240416095638.3620345-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240416095638.3620345-1-tabba@google.com>
X-Mailer: git-send-email 2.44.0.683.g7961c838ac-goog
Message-ID: <20240416095638.3620345-21-tabba@google.com>
Subject: [PATCH v2 20/47] KVM: arm64: Refactor reset_mpidr() to extract its computation
From: Fuad Tabba <tabba@google.com>
To: kvmarm@lists.linux.dev
Cc: maz@kernel.org, will@kernel.org, qperret@google.com, tabba@google.com, 
	seanjc@google.com, alexandru.elisei@arm.com, catalin.marinas@arm.com, 
	philmd@linaro.org, james.morse@arm.com, suzuki.poulose@arm.com, 
	oliver.upton@linux.dev, mark.rutland@arm.com, broonie@kernel.org, 
	joey.gouly@arm.com, rananta@google.com, smostafa@google.com
Content-Type: text/plain; charset="UTF-8"

Move the computation of the mpidr to its own function in a shared
header, as the computation will be used by hyp in protected mode.

No functional change intended.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/kvm/sys_regs.c | 14 +-------------
 arch/arm64/kvm/sys_regs.h | 19 +++++++++++++++++++
 2 files changed, 20 insertions(+), 13 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 33efa441e21d..c6da7dd891bd 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -816,21 +816,9 @@ static u64 reset_actlr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r)
 
 static u64 reset_mpidr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r)
 {
-	u64 mpidr;
+	u64 mpidr = calculate_mpidr(vcpu);
 
-	/*
-	 * Map the vcpu_id into the first three affinity level fields of
-	 * the MPIDR. We limit the number of VCPUs in level 0 due to a
-	 * limitation to 16 CPUs in that level in the ICC_SGIxR registers
-	 * of the GICv3 to be able to address each CPU directly when
-	 * sending IPIs.
-	 */
-	mpidr = (vcpu->vcpu_id & 0x0f) << MPIDR_LEVEL_SHIFT(0);
-	mpidr |= ((vcpu->vcpu_id >> 4) & 0xff) << MPIDR_LEVEL_SHIFT(1);
-	mpidr |= ((vcpu->vcpu_id >> 12) & 0xff) << MPIDR_LEVEL_SHIFT(2);
-	mpidr |= (1ULL << 31);
 	vcpu_write_sys_reg(vcpu, mpidr, MPIDR_EL1);
-
 	return mpidr;
 }
 
diff --git a/arch/arm64/kvm/sys_regs.h b/arch/arm64/kvm/sys_regs.h
index 997eea21ba2a..1dfd2380a1ae 100644
--- a/arch/arm64/kvm/sys_regs.h
+++ b/arch/arm64/kvm/sys_regs.h
@@ -222,6 +222,25 @@ find_reg(const struct sys_reg_params *params, const struct sys_reg_desc table[],
 	return __inline_bsearch((void *)pval, table, num, sizeof(table[0]), match_sys_reg);
 }
 
+static inline u64 calculate_mpidr(const struct kvm_vcpu *vcpu)
+{
+	u64 mpidr;
+
+	/*
+	 * Map the vcpu_id into the first three affinity level fields of
+	 * the MPIDR. We limit the number of VCPUs in level 0 due to a
+	 * limitation to 16 CPUs in that level in the ICC_SGIxR registers
+	 * of the GICv3 to be able to address each CPU directly when
+	 * sending IPIs.
+	 */
+	mpidr = (vcpu->vcpu_id & 0x0f) << MPIDR_LEVEL_SHIFT(0);
+	mpidr |= ((vcpu->vcpu_id >> 4) & 0xff) << MPIDR_LEVEL_SHIFT(1);
+	mpidr |= ((vcpu->vcpu_id >> 12) & 0xff) << MPIDR_LEVEL_SHIFT(2);
+	mpidr |= (1ULL << 31);
+
+	return mpidr;
+}
+
 const struct sys_reg_desc *get_reg_by_id(u64 id,
 					 const struct sys_reg_desc table[],
 					 unsigned int num);
-- 
2.44.0.683.g7961c838ac-goog

