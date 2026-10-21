Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.70
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792580492;
	b=Evoz3pKyheE3xu2oLxWYS4k5cU2KTCDIbcha4mumDFFIemhayO9Cp7lqba9UxVr322Y9
	 zDT3dqhPdiA0X0P+efziEnTBmJ+30UWG4V9jAMiy+Nn0IRkS4CPPyHBy726/0Fr3rPvfs
	 W7vDd0yA2aQjVBwRpS+n8kmcdgf6R4AvxkgPbM6G+Vh7WXbqBJvb3mk2spUsAZeWqVwo+
	 BCnL75/7ULclgZ5HUObPhtGVtApyaOisZP0r0ZMcHhtb6c9mVu3AMCbU5aYg28E+ZcD0d
	 ECDBk32zLlh2ffyNXZ1FiTQqPiyK6g4wkjNHH2CYV/ODm+vbykCXRUxl9F2OdhcII5A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792580492;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Received:Date:Mime-Version:
	 X-Mailer:Message-ID:Subject:From:To:Cc:Content-Type;
	bh=HHIgomAuSYfj1cAFxx866cqVmlDtzOuB8qVUxKcbrHo=;
	b=qYpOPjUmMM8OhsB/sd8X9DXJDeVxy2ZCg7Y0NDiX7nrYu4enQ2bA9+Es5ancDZ6FyCxQ
	 2mzIbpd+mvSoR4zO0MHp2ye/+NhKlG91z1gdrsLfMPEpUySG70a3aLzQ50nvY/7EEMk08
	 C5VxpepAQhoQaHXxBmujjoDXlIihgLIZIfX1dnS1WiWuZKzhLSCK2W5QgQbxdJnaigLvm
	 zhNoGKdyKgHruvBZXha0VmLzmC7Dolgv2C4BsiAUpmEntnVMKPz9tq2ADGaC+941qfVW+
	 2xn967RbkAfw8V69K3S3pW3zFfaXzUnoZs292kfPa/JhOWMwgUhNH+lTE1xjEA1XrvA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b=eXkjDqoX;
	arc=none smtp.remote-ip=209.85.128.70
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com [209.85.128.70])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E49B606A329
	for <kvmarm@lists.linux.dev>; Wed, 21 Oct 2026 11:01:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2E49B606A329
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b=eXkjDqoX
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-4a027f2e364so4484765e9.3
        for <kvmarm@lists.linux.dev>; Wed, 21 Oct 2026 04:01:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1792580489; x=1793185289; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:mime-version:date:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=HHIgomAuSYfj1cAFxx866cqVmlDtzOuB8qVUxKcbrHo=;
        b=eXkjDqoXFu7efmCnZBvCTRTeiwM++jfyLUtL3fcwQ56Vm1KllR01dHlTzc+U+jPs6P
         jNNJCoKzMY4INGzAAAupW2meNLFBqCNixI3cG9tLHebEeqKK4Bso6FaJfEwEi0YbMxU3
         AekSFygc8aO1e7NW/nOucjd4n+zERD6nRuT0PcXqN3y9J9lKXjLzErj/xAHI3Hb9r1lg
         m5D3L91wmdKs1ga8fspu1DlwoIPjX0JWSUgxWCDzWH83TAU+MimMsKN95yWtB7p6Hco4
         iegDSkQChKX6AgkA7y0ZdY6Ss9VdJplhA6DeFbLdEkFO46DH3Pw/H9KsVahr/Gjy+F9z
         vrzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792580489; x=1793185289;
        h=content-type:cc:to:from:subject:message-id:mime-version:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=HHIgomAuSYfj1cAFxx866cqVmlDtzOuB8qVUxKcbrHo=;
        b=nCTgez7CQ/khf8IiP6PsM3Jz0XBekycF3BhIXpj1xig4oujnCDVxB4qf8y5cA/Ppdf
         Cx2lZii8/Mm48BKkX7p02QWpXI6XnNMg0RLVZ5ffBw2cTzaQnhjZoVVAsvJ5T+wZFu0h
         +FBADp/AhohcuMo+HWUUFUIgYSB1ej2vH+Ea/E3lqqkJnBGOZHqTm+EOfBgmhW3kjrqk
         A0i5FlAN6n2DYv/DUDt9cHnJ8nmdiEYzb3vlYLvokXZuqBjTPLRPFOs53+VvplofmYBR
         Dpzvp6TbSeMQha/eOARowq8opjE6hGWUlf4cTM+v/GHhV53bSvfEw+4blXGKeFbNZgDE
         szAQ==
X-Forwarded-Encrypted: i=1; AKwUvBySnPkudsxy9imxprpBF8GHU0VqWy3vZxyFE572HymDYvajCmGGTbfVu9AsS7FMdHv4GiYNFLg=@lists.linux.dev
X-Gm-Message-State: AFq9FYJRp16L+7eWDvNL/1BJJS+VOBiTARChzbr70Fz9++8khodvj89k
	/VbZnsT15tGYyYOVzjSwYw4RqHiUv2nXZKoIlUUTWkF0u6RYfXcVlR6W6KuFjuI9p0GlhVc6eOS
	WoD1jmkv0XNsxWGf6+Slbxw==
X-Received: from wrnv18.prod.google.com ([2002:adf:ebd2:0:b0:48d:f214:2440])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:3507:b0:4a1:96cd:2f73 with SMTP id 5b1f17b1804b1-4a1fd8cd9e8mr34109435e9.1.1792580489307;
 Wed, 21 Oct 2026 04:01:29 -0700 (PDT)
Date: Wed, 21 Oct 2026 12:00:00 +0100
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
Mime-Version: 1.0
X-Mailer: git-send-email 2.56.0.212.g129ede20d9-goog
Message-ID: <20261021110000.508827-1-vdonnefort@google.com>
Subject: [PATCH v1] KVM: arm64: pkvm: Clear GICv3 LRs in the hypervisor
From: Vincent Donnefort <vdonnefort@google.com>
To: maz@kernel.org, oupton@kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org
Cc: joey.gouly@arm.com, seiden@linux.ibm.com, suzuki.poulose@arm.com, 
	yuzenghui@huawei.com, catalin.marinas@arm.com, will@kernel.org, 
	kernel-team@android.com, fuad.tabba@linux.dev, 
	Vincent Donnefort <vdonnefort@google.com>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

The LR registers are architecturally UNKNOWN when the CPU boots or
resumes. However, in protected mode, only the used ones are reset.
During boot the HVC __vgic_v3_init_lrs() is never called because
vgic_present is only set in init_subsystems(), after cpu_hyp_init() was
called. Also, the PM notifier isn't registered for pKVM and the HVC
becomes unavailable after the host is deprivileged.

Let the hypervisor itself clear those registers on CPU_ON, resume and
before deprivileging the host.

Cc: stable@vger.kernel.org
Fixes: fa8c3d65538a ("KVM: arm64: Keep nVHE EL2 vector installed")
Signed-off-by: Vincent Donnefort <vdonnefort@google.com>
---
 arch/arm64/kvm/hyp/nvhe/hyp-main.c   | 3 +++
 arch/arm64/kvm/hyp/nvhe/psci-relay.c | 3 +++
 2 files changed, 6 insertions(+)

diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
index ac64a036b0a9..0e0ca29b224b 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
@@ -754,6 +754,9 @@ static void handle___pkvm_create_private_mapping(struct kvm_cpu_context *host_ct
 
 static void handle___pkvm_prot_finalize(struct kvm_cpu_context *host_ctxt)
 {
+	if (hyp_gicv3_nr_lr)
+		__vgic_v3_init_lrs();
+
 	cpu_reg(host_ctxt, 1) = __pkvm_prot_finalize();
 }
 
diff --git a/arch/arm64/kvm/hyp/nvhe/psci-relay.c b/arch/arm64/kvm/hyp/nvhe/psci-relay.c
index e20db999e328..a0e17e416bb5 100644
--- a/arch/arm64/kvm/hyp/nvhe/psci-relay.c
+++ b/arch/arm64/kvm/hyp/nvhe/psci-relay.c
@@ -213,6 +213,9 @@ static void __noreturn __kvm_host_psci_cpu_entry(unsigned long pc, unsigned long
 	write_sysreg_el1(INIT_SCTLR_EL1_MMU_OFF, SYS_SCTLR);
 	write_sysreg(INIT_PSTATE_EL1, SPSR_EL2);
 
+	if (hyp_gicv3_nr_lr)
+		__vgic_v3_init_lrs();
+
 	trace_hyp_exit(host_ctxt, HYP_REASON_PSCI);
 	__host_enter(host_ctxt);
 }

base-commit: c03c1a14507dfaf8b856c2608f9ac216021fc222
-- 
2.56.0.212.g129ede20d9-goog

