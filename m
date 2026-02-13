Received: from mail-ej1-f73.google.com (mail-ej1-f73.google.com [209.85.218.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 700ED361DD6
	for <kvmarm@lists.linux.dev>; Fri, 13 Feb 2026 14:38:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770993501; cv=none; b=KpjRwliFbnaONIRbYbM1dF+/tfFFXztfDaYWMjYTVRUykOBQQ8ThFJ5qsaOJ/84kIwSEXgLQwSDZVeUQWgIJVGyj9+fVkgckPUUd+6xVwTtKjEEp+zhdwzd8lWac/LTZepn4thA8RJPg5trBO6kICZ4oxrO97rklC04O9M5579k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770993501; c=relaxed/simple;
	bh=nTibB9VvAnMArBkmdQHWooCRiGNpPUf8nLZ7D5ImAVw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Pd16byTkz3Ay1BK4hueZlNA+IudYD8WK1tJ8aA5yUfsp2YZjoTGNQvefoIpwyXYoBz9IA6TWus23MAvpZ/yEv7QvXvWo2frcybXB0lEFcdfepLnA6fZFF/WFHi5uWaHSjZcUZu56P7ve5h2vxowwuy7pJtwQMZd6M9vNVyYoxZo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=jMOu4oXf; arc=none smtp.client-ip=209.85.218.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="jMOu4oXf"
Received: by mail-ej1-f73.google.com with SMTP id a640c23a62f3a-b8f9599feb8so21047266b.0
        for <kvmarm@lists.linux.dev>; Fri, 13 Feb 2026 06:38:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1770993499; x=1771598299; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=iwg8k07MnblHsBD301KLHziw381Y4vRMO8Vvy4eyPOQ=;
        b=jMOu4oXftLZ70Sq8ZB2OojDKBt5A6t9Hu4nl3mbqoI2m3aVQX4YEAinjTdPRHs72Z0
         EO5nG77cX6mcmV9M7QoMFdocvnGkUxzuk0xYDx06aW62GhMULLzqRupafb/bA7U7X+C1
         w+f8xrShBVIMXiuBOIdGHOx6roCt7f166zuVIfk+B2obzxGKdWwn8idxdg1kg/wnjbRp
         Vviu4oMP24GG8wojDuUnQvXbm54madR+7QqmPntlthiJu43HfIlr9ksY0l6jP5MsNN71
         gmcVzBhx6P96RizkCT/fJTIM3h+Owozfqa+qb7W/UigxGh4R5IHYxFQE/wEs/VSZXg90
         FE2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770993499; x=1771598299;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=iwg8k07MnblHsBD301KLHziw381Y4vRMO8Vvy4eyPOQ=;
        b=jyQes4cR4avICtqLoyTZNOFyr9SQFo7TlDIoXCjrqdOGryIdfXISrSACNrMwive6bM
         rQbBWgjfdAmaG68uTgXIXxCm2wgg4W/UR1QW1fRV1bcKnX6cisINwKbetBtuE9YsyVOH
         spy3rGE7Hm6niOxfyTST28bNEinjQgxssDhbCsJHFaNr9KXbuk+sQCvLutwOb6sAnHdA
         FsQA3IoR+BTlMXBzBv2u9IsKpX6fu1l8rfPjgKjEKhGxuSmB88FuQkVeYqlbmS4yx+FL
         f5d6oyhm7h4nEMuyraT2H0+bpIf/pZCM3sUPYAUYHeH+peAwz4uFdkNcyF6xZrri0ejZ
         jyxA==
X-Forwarded-Encrypted: i=1; AJvYcCXyYlcUV4vhwJ2lJIadYKzUyZ1FIIYiZ7VFgVS4mvPCEayRg9cSZheXhTUk+lo2adPp1xAM51U=@lists.linux.dev
X-Gm-Message-State: AOJu0YzmSQyz3zhEVMpLnPbW6clUtO5ct6XuHKgAjFeglGEkHpDxHHBL
	ij3RbZTGcpI48CSrcse+GFc5Mf4eZfonECTP7KHmxWEfnBf29+eXjTDTjdPvu/TgkzjW+sqEqtR
	pmg==
X-Received: from ejdbe22.prod.google.com ([2002:a17:906:f416:b0:b8f:7a4f:842f])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a17:906:c104:b0:b8f:7014:48fb
 with SMTP id a640c23a62f3a-b8fb41ddfdamr117462566b.16.1770993498644; Fri, 13
 Feb 2026 06:38:18 -0800 (PST)
Date: Fri, 13 Feb 2026 14:38:13 +0000
In-Reply-To: <20260213143815.1732675-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260213143815.1732675-1-tabba@google.com>
X-Mailer: git-send-email 2.53.0.273.g2a3d683680-goog
Message-ID: <20260213143815.1732675-3-tabba@google.com>
Subject: [PATCH v2 2/4] KVM: arm64: Optimise away S1POE handling when not
 supported by host
From: Fuad Tabba <tabba@google.com>
To: kvm@vger.kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org
Cc: maz@kernel.org, oliver.upton@linux.dev, joey.gouly@arm.com, 
	suzuki.poulose@arm.com, yuzenghui@huawei.com, catalin.marinas@arm.com, 
	will@kernel.org, tabba@google.com, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Although ID register sanitisation prevents guests from seeing the
feature, adding this check to the helper allows the compiler to entirely
eliminate S1POE-specific code paths (such as context switching POR_EL1)
when the host kernel is compiled without support (CONFIG_ARM64_POE is
disabled).

This aligns with the pattern used for other optional features like SVE
(kvm_has_sve()) and FPMR (kvm_has_fpmr()), ensuring no POE logic if the
host lacks support, regardless of the guest configuration state.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/include/asm/kvm_host.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index ac7f970c7883..7af72ca749a6 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -1592,7 +1592,8 @@ void kvm_set_vm_id_reg(struct kvm *kvm, u32 reg, u64 val);
 	(kvm_has_feat((k), ID_AA64MMFR3_EL1, S1PIE, IMP))
 
 #define kvm_has_s1poe(k)				\
-	(kvm_has_feat((k), ID_AA64MMFR3_EL1, S1POE, IMP))
+	(system_supports_poe() &&			\
+	 kvm_has_feat((k), ID_AA64MMFR3_EL1, S1POE, IMP))
 
 #define kvm_has_ras(k)					\
 	(kvm_has_feat((k), ID_AA64PFR0_EL1, RAS, IMP))
-- 
2.53.0.273.g2a3d683680-goog

