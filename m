Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.70
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792677733;
	b=KUGNEjeSZYs0E8dhgIQ6BJFUBxWnbmoCx25WlWyMDZarRWSDdxOKoMAbFuriflni/cWQ
	 ktAYwJPx/oqung1VWA2lI9XLi41hu2y5A91+P889ROR8l1WIuTvgcQItv/hZszFHcwhnA
	 7HFw6J6Ocj0lIrIUbTIQj+Ix/bnVQR1VgeIRoZJEft4n9SK/Q+oFVvOAUNJI1s2w9r5aI
	 BRequADj673UNDbrZNa1t915h5oHEbIO6aSou0lqS4MkjpYNvOJQFWVIic+A+DtRFloRu
	 7SIBj8AEyhizUuXls1cSuX2PFQOSmoi2NK0VjHcjfnh0Vb6qSA6Znw72xh+NWy4X3AQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792677733;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Received:Date:In-Reply-To:
	 Mime-Version:References:X-Mailer:Message-ID:Subject:From:To:Cc:
	 Content-Type;
	bh=DDcj+XA234WUvgr54FY6eq3G8Ym1mfS+MXix3z476cY=;
	b=I7yQZ349mzgU/+IY7BQ6HKF/tnlWJZgB3Sy9f+BTXABOdhZec+M0Ak0/8iwC1Fq2QlbM
	 zIBPq3EELyTvjFpO7fcmN00bHin95xIOGmZ587YrS0QSrrwpU638iTg6pLAcJq/NGyhO4
	 29qpznPcF88EbQon0KA+4BpCvxo4BlDnMexZjX8YUpMxxzNLBQ9or9BXAJNx7o+OO4pWe
	 fjzZ8ocP6Wkue8qQC3oyTeNUJPheMl4FH3m6kCXzpyuiR21/eP+/jh0nblki46D9OwrZd
	 OAttDnxYjM7wPodZP8oWH5ZXmHgH1FFgnYgkBHEsQrx7ao/p58xWRrxl9QLV66zBZbA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b=n2KEZy0S;
	arc=none smtp.remote-ip=209.85.128.70
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com [209.85.128.70])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 239E5606A319
	for <kvmarm@lists.linux.dev>; Thu, 22 Oct 2026 14:02:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 239E5606A319
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b=n2KEZy0S
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-4a2001e85c8so11435235e9.1
        for <kvmarm@lists.linux.dev>; Thu, 22 Oct 2026 07:02:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1792677731; x=1793282531; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=DDcj+XA234WUvgr54FY6eq3G8Ym1mfS+MXix3z476cY=;
        b=n2KEZy0Sp6zszNdxUNNwUYoqNPKXIqasfIWoxICRvgHsiDFAMEeE+L1LK2eUNkgMv4
         mEX+ZMRCkM2Ri9MS2NMz7tnfbssvnQSuor4J6H8EyhS/MaCFHiz/Xf1lUjTECGEXHnUW
         3P4GH9xmzClerCPziplZaI07/tiiLva1ENSzbNEXbfCzmeaMr8IKbYhn4R3J98SRsj/K
         vYaKdBbe/dkGZkr6kC2sAjqSu1C+N/YV/YXNuq9/Nl/B2/hNcBnPLy4qujDJtx+bcBMR
         idT27SyaXkTRlmMP1E685UwnQp+KWVE7B5xuLB0hyLnOSRXbEfGuUxKN6w/Q2F1fKqRf
         nwHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792677731; x=1793282531;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=DDcj+XA234WUvgr54FY6eq3G8Ym1mfS+MXix3z476cY=;
        b=dov4PXUwDTWLt++f+4xIwEHr0R/XhXw5yWsoYnbWXpIa1X6Mqjbvkc4fqFHuXRw41c
         VXp0ituZT1IuKKvZbgbomWKgKdBgMa/wwVJWkBH9ywNWfceVk2Bxlhya930TtgrmqizF
         h2YmJlnTDSYWBCjq6ttnCWi8KvdSU1bGt7I4qSUGf99G/Y7td8Y67AexSxPg0JXP3/5X
         mrE2wl7H0sHp34BhTwXe9qxsFyCucEtGGsdGFu4PQX8EJdxFuGvqQ/NUUXZqIv+3vGXT
         kVBFWRFhdW2S2jUP0Cnhq32ZybHJ4xevozcaQRRc/TuzjYmXdmMkTsozzdQ9eqbVRt+l
         8cDQ==
X-Forwarded-Encrypted: i=1; AKwUvBzXh5J8m+X0rsTDuGCfRoxPmwdlMkj6v+VmJ/LIAciSPpy6OriJz/DsuPcbH0icx60KTTnomxs=@lists.linux.dev
X-Gm-Message-State: AFq9FYJlgLahEl7vf5wAmL0TFuicS19CA6dGFAxT3ccUXogF/078wr10
	0m41//JHrbn7oTizpslJdMpaYsfZ6CDLeyd18ef22TM1tqafLD++AnCU/IZnugECJZ0eNtIfs5G
	knklWRqs8/KFC7BIbnv8XFg==
X-Received: from wmbf2.prod.google.com ([2002:a05:600c:5942:b0:4a1:a7f8:c12f])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:6309:b0:4a0:1f90:594b with SMTP id 5b1f17b1804b1-4a1fdd293d6mr93006725e9.22.1792677731088;
 Thu, 22 Oct 2026 07:02:11 -0700 (PDT)
Date: Thu, 22 Oct 2026 15:00:45 +0100
In-Reply-To: <20261022140048.2522787-1-vdonnefort@google.com>
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
Mime-Version: 1.0
References: <20261022140048.2522787-1-vdonnefort@google.com>
X-Mailer: git-send-email 2.56.0.257.gf7497c7d27-goog
Message-ID: <20261022140048.2522787-2-vdonnefort@google.com>
Subject: [PATCH v2 1/4] KVM: arm64: Make __vgic_v3_init_lrs HVC always available
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

