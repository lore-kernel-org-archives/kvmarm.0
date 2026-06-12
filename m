Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9344E384243
	for <kvmarm@lists.linux.dev>; Fri, 12 Jun 2026 14:22:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781274177; cv=none; b=j4dg17CcakBC+IzdZCmlrczi440VHzh/bpqnnbj0Xfa611eM+06hFIVYV4EXixMPIJ5JHoH8A2DyTjXMM+R7d957cnNz+foW0nilhveOL4dQs2H/m83STnVkjmU2RJ+mq+QGNA2UKnVs6oWmy1DooUdDRJTM5wrnYwr4MVC1ad0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781274177; c=relaxed/simple;
	bh=k363TfX95lYVDtP0xZSTZbnJ6zt18yNBxzAONQSjitY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=NoqRp2oZXl0h3eG9W5up+OQPFm6/IF/i4yIFDySGnp++vXf2ayGnd5a1I6jMINIJvYET7rt/JjN7wHwMMa2Vh8tikDpva3PF/Wv+0xU6Sx3TVS95MVEYZcZ4HxG7Ty72X1uYv/LM3s1q9zKRARFbRstj6J1LS56p53y9N1hdMHc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=DCHDuWPr; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="DCHDuWPr"
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-490ace40f13so4564055e9.3
        for <kvmarm@lists.linux.dev>; Fri, 12 Jun 2026 07:22:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1781274175; x=1781878975; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=FvdJm7zpA9I9WpAA+zqvgzxPINWHDWcn46I9uP7tgtI=;
        b=DCHDuWPrjpleGDTYSAdxjKoYxQvhQjKjxv65wSx/c6wn1GR60TWFyToaBKdwXHTjCE
         9ofZoM4l6U6ziNsbVDN2mR06OlOC1H82yTc/LStFCcZHRKj4JMa42fv7W+mza+9235/v
         AUmvqvLlBsvqPLfnlW4F5ayNQZaxfiyDXZk2v7A8NSSoyF4X84/BpugGuSWonImeElme
         3utzXloqrO1TBx99j71L8PdEvVAtiRpVcBIqt3NsaKd/+iY5Lb1A4xBVxl4s+YY81avp
         eObFM2pF1jR7/c+9vydzVel5Cr+wxza1EbjmDGcdTHIvfApAWhKMnuGhOZ4Lsxou3e+B
         QoOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781274175; x=1781878975;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=FvdJm7zpA9I9WpAA+zqvgzxPINWHDWcn46I9uP7tgtI=;
        b=miufRboflXwI1aNHYf201OC2kIrefB1/I/u2S/ENWFY022M1tqbmw6VKhR4fVc5ZoP
         83QxtNBEw8YpQA5AXXZjVgucorKH4GvYr/zzpLyahxIrJh5T4i/B59pHwSfiGF7Km0HX
         AKObC+OTThHPjlf2ytNW+gOzC0txCKzbM45fjyqYKtmImKIjjt14R9LOiPfBxOeRFlI4
         g8r7OnRy71W3+z5Pf4NKQ5fjLsih35/tBDNnbm3S2rha3Dp6qeYhfvuQmZ9RDZL7ulUE
         LkA3jaejZLcGI0vPAaIX2KxJLdNBi+z9lEt3ZG+KCZCC4701JQnLe7GPWBMpOBiXZCCo
         /Ckw==
X-Forwarded-Encrypted: i=1; AFNElJ8PyGy1x5Z3wwqlhuFUjgAi2y5RV8wOnol4pZndUsrP2umM0UKho6fHpiNxEpsnywY46hkbGu0=@lists.linux.dev
X-Gm-Message-State: AOJu0YwlVQlJ/hQxl1LgReBRKwmlRw+bgbdl6pL0SiUUwLN9AGY6HsCr
	QuYajf05D+1MIqIDAESY4wCcOkpMCuodZ2RETwcS0uqSuL4pV36+h6bYcsztlJixhWqQ6q4O0Yo
	DwFoaFbVDUnLZ0OpTsd9y8A==
X-Received: from wmbg10.prod.google.com ([2002:a05:600c:a40a:b0:490:b555:823e])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600d:8494:20b0:48a:75b9:b0bc with SMTP id 5b1f17b1804b1-490ec51003amr29779865e9.29.1781274174882;
 Fri, 12 Jun 2026 07:22:54 -0700 (PDT)
Date: Fri, 12 Jun 2026 15:22:42 +0100
In-Reply-To: <20260612142245.1015744-1-vdonnefort@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260612142245.1015744-1-vdonnefort@google.com>
X-Mailer: git-send-email 2.54.0.1136.gdb2ca164c4-goog
Message-ID: <20260612142245.1015744-2-vdonnefort@google.com>
Subject: [PATCH v1 1/4] KVM: arm64: Allow early calls to pKVM host_share/unshare_hyp
From: Vincent Donnefort <vdonnefort@google.com>
To: maz@kernel.org, oliver.upton@linux.dev, joey.gouly@arm.com, 
	suzuki.poulose@arm.com, yuzenghui@huawei.com, catalin.marinas@arm.com, 
	will@kernel.org, rostedt@goodmis.org
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kernel-team@android.com, tabba@google.com, qerret@google.com, 
	Vincent Donnefort <vdonnefort@google.com>
Content-Type: text/plain; charset="UTF-8"

The hypervisor tracing for pKVM relies on the __pkvm_host_share_hyp and
__pkvm_host_unshare_hyp HVCs. In order to start tracing as early as
possible, allow those two HVCs before the host is deprivileged.

Signed-off-by: Vincent Donnefort <vdonnefort@google.com>

diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/kvm_asm.h
index 043495f7fc78..fb049c40d04f 100644
--- a/arch/arm64/include/asm/kvm_asm.h
+++ b/arch/arm64/include/asm/kvm_asm.h
@@ -89,12 +89,12 @@ enum __kvm_host_smccc_func {
 	__KVM_HOST_SMCCC_FUNC___vgic_v3_restore_vmcr_aprs,
 	__KVM_HOST_SMCCC_FUNC___vgic_v5_save_apr,
 	__KVM_HOST_SMCCC_FUNC___vgic_v5_restore_vmcr_apr,
+	__KVM_HOST_SMCCC_FUNC___pkvm_host_share_hyp,
+	__KVM_HOST_SMCCC_FUNC___pkvm_host_unshare_hyp,
 
 	MARKER(__KVM_HOST_SMCCC_FUNC_PKVM_ONLY),
 
 	/* Hypercalls that are available only when pKVM has finalised. */
-	__KVM_HOST_SMCCC_FUNC___pkvm_host_share_hyp,
-	__KVM_HOST_SMCCC_FUNC___pkvm_host_unshare_hyp,
 	__KVM_HOST_SMCCC_FUNC___pkvm_host_donate_guest,
 	__KVM_HOST_SMCCC_FUNC___pkvm_host_share_guest,
 	__KVM_HOST_SMCCC_FUNC___pkvm_host_unshare_guest,
diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
index 06db299c37a8..f0c52667cf52 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
@@ -721,9 +721,9 @@ static const hcall_t host_hcall[] = {
 	HANDLE_FUNC(__vgic_v3_restore_vmcr_aprs),
 	HANDLE_FUNC(__vgic_v5_save_apr),
 	HANDLE_FUNC(__vgic_v5_restore_vmcr_apr),
-
 	HANDLE_FUNC(__pkvm_host_share_hyp),
 	HANDLE_FUNC(__pkvm_host_unshare_hyp),
+
 	HANDLE_FUNC(__pkvm_host_donate_guest),
 	HANDLE_FUNC(__pkvm_host_share_guest),
 	HANDLE_FUNC(__pkvm_host_unshare_guest),
-- 
2.54.0.1136.gdb2ca164c4-goog

