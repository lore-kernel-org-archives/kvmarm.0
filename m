Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com [209.85.218.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 626EC4A5EB2
	for <kvmarm@lists.linux.dev>; Mon, 19 Oct 2026 09:43:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.71
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792402995; cv=none; b=A2HnQQv0wlWiAbhzadFY9+emNSO/hpZlp6YXbuMUARVmwuCuWXFuYpwApluI3VUdeUR+BVqUUZ9wXiQS1xsSmGzM/ffinMd3ljnA3VVPH4YfVtQLhkF69mtel82B6mdZgEB7h47iJz4CrlrT47i4fPkRDiogVAzuM5bJKvW6Ae0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792402995; c=relaxed/simple;
	bh=PzKyarukTq2x7YqBXd2V2qCF1q/hwrkICvezmqY+DFg=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=WFzXWPDJxPrAsn9dpIfcSG6atREn557ZnPkmUZLti+aYUa1GYrsf+cdALi9HRmFzl4bO9yjh5R8oDnwW/JldGmeA77nj22UrDf1X8QJwhbwngnXQz0Wvaw0o0ALCEhPw3tCGe2i58pIjlFNr/YXDExKBwOHy4BL23YFcaD8+aeo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=QUn5aMUe; arc=none smtp.client-ip=209.85.218.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="QUn5aMUe"
Received: by mail-ej1-f71.google.com with SMTP id a640c23a62f3a-c41dae9db9dso142006066b.2
        for <kvmarm@lists.linux.dev>; Mon, 19 Oct 2026 02:43:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1792402992; x=1793007792; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:mime-version:date:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=My94Drro5rrGPLIhxRFJZRgDXBcGCfTXRc2R8XZoVko=;
        b=QUn5aMUenymfxQP/X8JB83Ez5cPqCQqqAinrgXF99+fLwZ1mz0L8bZM3tgQOs9PaiJ
         DCxZjjZnZGViVo8G7nUs+KtTpxxo2lySfWcQXmRB1UV43yUEHEb8Feox0Ym2YkX8j1RR
         AtCg7BHfFCgDyyRvlIJJSJ7ISB/3aaH2kkxwUFYRuZxr2dIvKkz3mvkHWHzsG5IiCGp+
         0tDwrTMQDYuX/wp003mOHtHABNTdZ09CaNDEXC1VnuxY9jrONb8yQE2srWwJkXIfbe9d
         R4pl3hO+q+APbVO18nhfpdtV8SrHKVB/1XlYwLmK5p0LL7XKD/Q5nW7rxstYF2083Y5e
         eCQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792402992; x=1793007792;
        h=content-type:cc:to:from:subject:message-id:mime-version:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=My94Drro5rrGPLIhxRFJZRgDXBcGCfTXRc2R8XZoVko=;
        b=fyWaH8RxZd1uFIutufhDsh4uuV69o2Wel3uYpkfNyqcQVRWkFx4//vqIZYEKcWxEZk
         NURC/+7ov9sa/fGAE4FVY4L1TXJOU2pCQ0mRkCZ8v78+F4qeauR2X5jWz3ePi2sKn+FM
         Nv2uDj85ZdnZgQZfB/frcea8Y7ZpBnNwB65OrN7W4JeLOOQr90HP/VR7eFiNX7afmY38
         l8AYYMaXCH3aEAmCxM0ws1Nyqj6dzUdwxaR01t9298v628ThA2zkksd9NcaIqnYcLApd
         NBGe9+ymzJXsJuMiFt7aD2/UKU78fTGMXdYqm6yDKRIePWHFt33MVwLAjmLl5ybajg67
         gztA==
X-Forwarded-Encrypted: i=1; AKwUvBziEKbo6ea8nYJKCiUAvEK54vMbbTawAGntTCzNaxTKzgjJAAU8anHa37hzMP315mubrVmH9SE=@lists.linux.dev
X-Gm-Message-State: AFq9FYJkuwbhi0ra27wtJvfpW9AUgZiCxxjtgflZRXM0irrCxyFmC4es
	nZ87ozcq04sghO89u5d6LAHvQrIG0V7d31WnuMREPk2bwt1NqT87eWkTW8tzezCxyolhZOM18YY
	rLGyrbWkUAkN8yTf3Dw9V8Q==
X-Received: from ejbwi17.prod.google.com ([2002:a17:906:fd51:b0:c31:6800:d19e])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:907:c1e:b0:c26:19de:9126 with SMTP id a640c23a62f3a-c419f11c167mr453728566b.25.1792402992293;
 Mon, 19 Oct 2026 02:43:12 -0700 (PDT)
Date: Mon, 19 Oct 2026 10:42:58 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.56.0.176.g3575e65682-goog
Message-ID: <20261019094258.1582756-1-vdonnefort@google.com>
Subject: [PATCH v1] KVM: arm64: Move pkvm_selftests() after all CPUs have
 initialized EL2
From: Vincent Donnefort <vdonnefort@google.com>
To: maz@kernel.org, oupton@kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org
Cc: joey.gouly@arm.com, seiden@linux.ibm.com, suzuki.poulose@arm.com, 
	yuzenghui@huawei.com, catalin.marinas@arm.com, will@kernel.org, 
	kernel-team@android.com, fuad.tabba@linux.dev, 
	Vincent Donnefort <vdonnefort@google.com>
Content-Type: text/plain; charset="UTF-8"

init_subsystems() installs the hyp vector on all CPUs. By running
pkvm_selftests() in init_hyp_mode(), there's a risk for a migration to a
CPU where the hyp stub is still in place which would fail to run one of
the HVCs necessary for the selftest.

While init_subsystems() is the earliest we can call pkvm_selftests(),
move it to finalize_pkvm() to avoid having to export the selftest
function out of pkvm.c.

Fixes: bd93068340e9 ("KVM: arm64: Add selftests for the pKVM heap allocator")
Reported-by: Fuad Tabba <fuad.tabba@linux.dev>
Signed-off-by: Vincent Donnefort <vdonnefort@google.com>
---
 arch/arm64/include/asm/kvm_pkvm.h | 1 -
 arch/arm64/kvm/arm.c              | 2 --
 arch/arm64/kvm/pkvm.c             | 4 +++-
 3 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_pkvm.h b/arch/arm64/include/asm/kvm_pkvm.h
index e7562770e7cb..fd042d2b5462 100644
--- a/arch/arm64/include/asm/kvm_pkvm.h
+++ b/arch/arm64/include/asm/kvm_pkvm.h
@@ -17,7 +17,6 @@
 
 #define HYP_MEMBLOCK_REGIONS 128
 
-void pkvm_selftests(void);
 int pkvm_init_host_vm(struct kvm *kvm);
 int pkvm_create_hyp_vm(struct kvm *kvm);
 bool pkvm_hyp_vm_is_created(struct kvm *kvm);
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index d593ba928093..93eac8959865 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -3109,8 +3109,6 @@ static int __init init_hyp_mode(void)
 			kvm_err("Failed to init hyp memory protection\n");
 			goto out_err;
 		}
-
-		pkvm_selftests();
 	}
 
 	return 0;
diff --git a/arch/arm64/kvm/pkvm.c b/arch/arm64/kvm/pkvm.c
index 380dfb1db0be..016997288fd2 100644
--- a/arch/arm64/kvm/pkvm.c
+++ b/arch/arm64/kvm/pkvm.c
@@ -333,7 +333,7 @@ static int __init pkvm_drop_host_privileges(void)
 	return ret;
 }
 
-void __init pkvm_selftests(void)
+static void __init pkvm_selftests(void)
 {
 #ifdef CONFIG_NVHE_EL2_DEBUG
 	int ret = pkvm_call_hyp_req(__pkvm_hyp_alloc_selftest);
@@ -387,6 +387,8 @@ static int __init finalize_pkvm(void)
 	if (!is_protected_kvm_enabled() || !is_kvm_arm_initialised())
 		return 0;
 
+	pkvm_selftests();
+
 	/*
 	 * Exclude HYP sections from kmemleak so that they don't get peeked
 	 * at, which would end badly once inaccessible.

base-commit: dd0bc00e3e9201fd49b62ff9cc07890c89003afe
-- 
2.56.0.176.g3575e65682-goog

