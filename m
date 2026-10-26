Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.72
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793032794;
	b=0rJrafVajU+05Dypbab31ejI/oZA9IzeBfnj0h4DXHSuABxCOQy3IH0/fmpaWk/7OjBe
	 Mo4qSlD5W+jn3jRXsIExe8JSd9vVOhgFr94GckxMl5y09A3Q6qYyBy5QPNT0ze4kaL3Pz
	 2SDp/3HzOv/XJR7VYWRQWv/9IpnbRkvfoj6jcHsPW1vukpJ5jGsy4X06Z8AvPUjOivK1y
	 MrvIvVkWbTwnZOzoXyu6uQMhKTqcpKrTWscePD8OQdcpnntZ+F1XldsHQnWDVdudEZh4k
	 7imTgi3eNcxj9i1g7d2oNOc0SD4QP5vftUMjWGHlhuEtsP4oqxy0SDfRgXo2ojkVrKA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793032794;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Received:Date:In-Reply-To:
	 Mime-Version:References:X-Mailer:Message-ID:Subject:From:To:Cc:
	 Content-Type;
	bh=j+pgUU2lCypiF+bjpCYVvnGGlayFnQSVpYHqlC0Ubm8=;
	b=jkyszOxkIpzmK3VTaKq+UIO18ckGZpS744GrgCDNnaIRs2F46NiJ8ydGu1zwlNCuPxIH
	 xyzCqsLSxUp7bqdYNR8TmntmcxMd97Z/PD5qQ5pzUfyvUXlYpFj3CBRAr83h1WNYzaJLm
	 xoUugcPwLc7T97JGz1QKPxt4dCfrJFFTPvm5GGScRT8dYbJ38LkydC1+zlwaZPOeeNlva
	 BCTKXGTYuy968HB2VEvn04JmvEOaQi1yJaqLGjnuex9K5u0bIqG9lRJWOmWuRyFZMol6+
	 XK2ZxtJe4qLLTJnU1H8L719bCNiLDa5NSR30I9MmYFkJsq1SFSGOMoNKZRIx5J2cXHA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b=LGqrhwvi;
	arc=none smtp.remote-ip=209.85.128.72
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com [209.85.128.72])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83BE6606A32C
	for <kvmarm@lists.linux.dev>; Mon, 26 Oct 2026 16:39:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 83BE6606A32C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b=LGqrhwvi
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-4a0284121c6so28992435e9.3
        for <kvmarm@lists.linux.dev>; Mon, 26 Oct 2026 09:39:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1793032791; x=1793637591; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=j+pgUU2lCypiF+bjpCYVvnGGlayFnQSVpYHqlC0Ubm8=;
        b=LGqrhwvikctmJCn+PQfK3LKzB4WmxCVPy05NzY7xW66RWZOrZ0vGMnP3ucFcP5DYas
         GjGOdXMTAjKhB8nNrvO6go6QjM74hoQ7XTEG83yUCkuSlIHz2E1qFt86R/D0hA71VsHB
         ILxJTod5gr4zHGececwNBVjg7iU2t3qsgM5xwKOjBINTY+7/F5Kf0VeHhEMQujI1TZEB
         VI1+sgiLo2+7bVbPgBe/3B0wR72pMDaN9euebwvUpdBCCuBZ7Po82PkQ6fgKgga4N9+O
         ozChKChzmlJfPK0TfwuhivInhpytvPJ6SDeHzEDprjUzzofOOCMyEr0VZpGTRb6pAnoK
         SlPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793032791; x=1793637591;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=j+pgUU2lCypiF+bjpCYVvnGGlayFnQSVpYHqlC0Ubm8=;
        b=o01m58E1HANdKCk8jJJrj6W5AyjJ1iYo0AmtK0BG4ogvMgnPCN7CnTgaVnnI4EckZm
         l5AgC8A/8VVKYOS1IcmOV7osfNWlYqi4WorSQYrv4CcRlYg7Y02fPECn1j1zCeg2La4L
         +/UCDdCjxa1MdbTK8BmSUUQlHAp5EnTLpeax6rOb7GjmrhUCZYR7HnyVfTckHgqaKo37
         9rRu6iiyn/CZRJkKkpRQQFfZM8nGAy0PnOC98VcMPTX7Ud39EhMZV/tv4R1V6OnEtZW7
         Q1txUFvs2KXImOocMz/JkbiCHX13P410OqxFljcJ1c+RIf9dQrr/EPvKhmyaCx4KWv/m
         Pkdg==
X-Forwarded-Encrypted: i=1; AKwUvByvMP10Cj0cXpu/GdtyLultm8ZT3g/aG7Whpza3EXD3J3bhDLeO1Hg6jzEVSAwmxGvBWLEY7ZQ=@lists.linux.dev
X-Gm-Message-State: AFq9FYKg6drIrsqjaWfot3ZqNPC82iS2bJ2PYltopA2MCp3CaBiIgCbI
	BZTCMo/cggrbxWUBemiTyiJR7y7gA4fADyBfYQHj9G6+AV4XJwXSQ1zrCJC3mOFXd7ey3QbVAh+
	trO9LSo80bMJ//nPuDD6wzA==
X-Received: from wmv5.prod.google.com ([2002:a05:600c:26c5:b0:4a2:c1:cb3f])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:c0c8:b0:4a4:de70:2ad4 with SMTP id 5b1f17b1804b1-4a4de702b8bmr87155095e9.22.1793032789761;
 Mon, 26 Oct 2026 09:39:49 -0700 (PDT)
Date: Mon, 26 Oct 2026 16:39:35 +0000
In-Reply-To: <20261026163937.963087-1-vdonnefort@google.com>
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
Mime-Version: 1.0
References: <20261026163937.963087-1-vdonnefort@google.com>
X-Mailer: git-send-email 2.56.0.257.gf7497c7d27-goog
Message-ID: <20261026163937.963087-2-vdonnefort@google.com>
Subject: [PATCH v3 1/3] KVM: arm64: Make __vgic_v3_init_lrs HVC always available
From: Vincent Donnefort <vdonnefort@google.com>
To: maz@kernel.org, oupton@kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org
Cc: joey.gouly@arm.com, seiden@linux.ibm.com, suzuki.poulose@arm.com, 
	yuzenghui@huawei.com, catalin.marinas@arm.com, will@kernel.org, 
	kernel-team@android.com, fuad.tabba@linux.dev, 
	Vincent Donnefort <vdonnefort@google.com>
Content-Type: text/plain; charset="UTF-8"

The __vgic_v3_init_lrs hypercall only resets the vGIC LRs. Those
registers are expected to be 0 when the host is running. As a
consequence, it is completely safe to make it available at all times,
even when pKVM is enabled and the host was deprivileged.

Fixes: 057bed206f70 ("KVM: arm64: Disable privileged hypercalls after pKVM finalisation")
Tested-by: Fuad Tabba <fuad.tabba@linux.dev>
Reviewed-by: Fuad Tabba <fuad.tabba@linux.dev>
Signed-off-by: Vincent Donnefort <vdonnefort@google.com>
---
 arch/arm64/include/asm/kvm_asm.h   | 2 +-
 arch/arm64/kvm/hyp/nvhe/hyp-main.c | 5 +++--
 2 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/kvm_asm.h
index e5b92ac09e69..ca7e55d8eec3 100644
--- a/arch/arm64/include/asm/kvm_asm.h
+++ b/arch/arm64/include/asm/kvm_asm.h
@@ -60,7 +60,6 @@ enum __kvm_host_smccc_func {
 	__KVM_HOST_SMCCC_FUNC___pkvm_create_private_mapping,
 	__KVM_HOST_SMCCC_FUNC___pkvm_cpu_set_vector,
 	__KVM_HOST_SMCCC_FUNC___kvm_enable_ssbs,
-	__KVM_HOST_SMCCC_FUNC___vgic_v3_init_lrs,
 	__KVM_HOST_SMCCC_FUNC___vgic_v3_get_gic_config,
 
 	MARKER(__KVM_HOST_SMCCC_FUNC_MIN_PKVM),
@@ -85,6 +84,7 @@ enum __kvm_host_smccc_func {
 	__KVM_HOST_SMCCC_FUNC___tracing_reset,
 	__KVM_HOST_SMCCC_FUNC___tracing_enable_event,
 	__KVM_HOST_SMCCC_FUNC___tracing_write_event,
+	__KVM_HOST_SMCCC_FUNC___vgic_v3_init_lrs,
 	__KVM_HOST_SMCCC_FUNC___vgic_v3_save_aprs,
 	__KVM_HOST_SMCCC_FUNC___vgic_v3_restore_vmcr_aprs,
 	__KVM_HOST_SMCCC_FUNC___vgic_v5_save_apr,
diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
index ac64a036b0a9..c1f0de3ec43f 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
@@ -627,7 +627,8 @@ static void handle___vgic_v3_get_gic_config(struct kvm_cpu_context *host_ctxt)
 
 static void handle___vgic_v3_init_lrs(struct kvm_cpu_context *host_ctxt)
 {
-	__vgic_v3_init_lrs();
+	if (hyp_gicv3_nr_lr)
+		__vgic_v3_init_lrs();
 }
 
 static void handle___vgic_v3_save_aprs(struct kvm_cpu_context *host_ctxt)
@@ -910,7 +911,6 @@ static const hcall_t host_hcall[] = {
 	HANDLE_FUNC(__pkvm_create_private_mapping),
 	HANDLE_FUNC(__pkvm_cpu_set_vector),
 	HANDLE_FUNC(__kvm_enable_ssbs),
-	HANDLE_FUNC(__vgic_v3_init_lrs),
 	HANDLE_FUNC(__vgic_v3_get_gic_config),
 	HANDLE_FUNC(__pkvm_prot_finalize),
 
@@ -931,6 +931,7 @@ static const hcall_t host_hcall[] = {
 	HANDLE_FUNC(__tracing_reset),
 	HANDLE_FUNC(__tracing_enable_event),
 	HANDLE_FUNC(__tracing_write_event),
+	HANDLE_FUNC(__vgic_v3_init_lrs),
 	HANDLE_FUNC(__vgic_v3_save_aprs),
 	HANDLE_FUNC(__vgic_v3_restore_vmcr_aprs),
 	HANDLE_FUNC(__vgic_v5_save_apr),
-- 
2.56.0.257.gf7497c7d27-goog

