Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E11313BADD
	for <kvmarm@lists.linux.dev>; Tue, 23 Apr 2024 15:06:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713884796; cv=none; b=t5ga/uvlg9OhL91rsp44oFfpBAJBRrktazYqzKDRLgxipOPWb2xRoNgBHAcJqy8WYVArBX6RQ/HMG0a4nL1XdnpatQI10rxJ5I25xn4ah3rWyFhcY/xesw4+JIu9MuEefP5YGihqUnBhKJInJJMXDPYpdkd6tVzyeGC6WX2nK6s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713884796; c=relaxed/simple;
	bh=H120HCXBI3/guyh6tfue56/bfmVkmtQxzhaIWdicHvk=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Hd0nuHE9sEMW3FLHozACWYgRtbsyoQwVGtF2yot9RKj5g11UpILySuwtHfDOywuMMk07ola6SLCBEpuaHhd7lEeAdpPbgqnlzXQ9c5dcAo3/n7PkJ8YRBWixbcVV5wghMSDNnylTcA+CvWpGklFw3Lsetz2jyyOmX7KRjURvbCw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=AM/N3Qik; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="AM/N3Qik"
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-416ac21981dso28150065e9.1
        for <kvmarm@lists.linux.dev>; Tue, 23 Apr 2024 08:06:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1713884793; x=1714489593; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=WAASiQj8ySouqSnzFWGUNnXYH4XrZldkqK8o7Htn7bk=;
        b=AM/N3QikF9b829S7IzjjHHoEkXVGWoVJrZc0c7ScF/Nw7aSuQ/8xf5qcDvY5X7fSTU
         NtkYD3TuBn66SxPCgJw2R6AuyJdPGpA2Sb6mwDTtuf0PXQDS5KCuLkz8v7yDprmAUkJe
         0yzTFLFormzbi7X+vWciXMsH6JmuOq+5jMTO+ixLARxHXqDBf6GKUOvIKjmMm0jbP/Sm
         /6cviSFxi4iXpHnfIFzRrjPIm7tJS3uOd9Njwy1D++Nfl4f2acP4rjLWAIzJaoATgkBa
         KRtZ5wufiT1TtHYJFEXAc5QyEqVn2KvITBNf5kBG5uFWtGVbPGFTmk21Jl61PM/iDYVS
         5Zxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713884793; x=1714489593;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=WAASiQj8ySouqSnzFWGUNnXYH4XrZldkqK8o7Htn7bk=;
        b=SkpYnQAVjUzNRpe7RuRtwPJzP+GUsUa2hTuaeeco0RnZIc/POkLQ7qnXUrdfCDzjTE
         MECEyqKIfQpXFH86q14a/yAyllQhJ6XWU1NN++gOzVcxZZCzgVWTFFIOvfrECJVEWhkQ
         /F6RD849/f8P0sOdDzuBbZMkBfrB3RK1EDXOGj02a94LKO6SMRo4/9SAhmen+scZlQjF
         2k81PyOQakdjMez4SHyDvhUcIkyMoy6cra4/NPhjRN5INzwLQu+6RrvOm46AkGBuhQ4N
         5jYxXrrmphUfI/EQ4e5R6BFOaNKPsydC8Oy4sopfrwDX9DUSg0way8WE0qLiL7gI4jiJ
         vjnA==
X-Gm-Message-State: AOJu0Ywvqsn715ie5bMxgIp8PbkXOuELM78sZ+R4eaSDXV8buUZr9xjG
	2EjGFKNoDpwjiVakmnykc4P2FtmXW0aco8O6+rhReV3ewtySY/Vg3iF0TE7vaeQCLt6ppLqMQ5O
	B8iAXX4uaNLLgOd8FIi2JmdL+IHi3eMyARV18sFGSr8xclOmle/aDq0eXqRqvFz0OrJBrx54KFN
	OvnfxQnKS0qgFF2udcxSSKjuz/7jE=
X-Google-Smtp-Source: AGHT+IFueBCmr1mDA+FOyY0da133iqCu9Ntv9F/8EwpNhXh6yjKgdHb8dyDHEDsQGfSPiMpZg/x/Q2jYJA==
X-Received: from fuad.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1613])
 (user=tabba job=sendgmr) by 2002:a05:600c:78a:b0:418:4e4a:fec5 with SMTP id
 z10-20020a05600c078a00b004184e4afec5mr25988wmo.3.1713884793628; Tue, 23 Apr
 2024 08:06:33 -0700 (PDT)
Date: Tue, 23 Apr 2024 16:05:31 +0100
In-Reply-To: <20240423150538.2103045-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240423150538.2103045-1-tabba@google.com>
X-Mailer: git-send-email 2.44.0.769.g3c40516874-goog
Message-ID: <20240423150538.2103045-24-tabba@google.com>
Subject: [PATCH v4 23/30] KVM: arm64: Refactor reset_mpidr() to extract its computation
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
2.44.0.769.g3c40516874-goog

