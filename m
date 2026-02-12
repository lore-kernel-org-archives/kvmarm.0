Received: from mail-ed1-f74.google.com (mail-ed1-f74.google.com [209.85.208.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 124502C08DB
	for <kvmarm@lists.linux.dev>; Thu, 12 Feb 2026 09:02:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770886977; cv=none; b=MsiCfiIHbeYdMVRa2lWMJ5cr4KGqXqW3QfgbifCDBR6shnC63iFoPPU2IRrCyas847JFgOqamLK7l9THyfoqdlTgavwDhoBz9n22ReTrc0TqGYfOEVtsT8Zs5fZCQhCLEDCI7r/PRjb2PmTNNFulvN5avr8Sl+5TUHEIaAdNVEE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770886977; c=relaxed/simple;
	bh=7pCt9xCI7qPEiR77wf/ej5qv5bbTMY2AsJNfNSMCbTk=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=m6h1E9e9CtlKFM2rDNzoUlCJ0ubHqhGdPi/zhds/+NGY+wQYhcnUidIwV9WBmlRdqOydtclLnQ0XYmB7aNzuACWSTDaUBGMExFvAS497uzf4FcR1KKbHobD+tN+PuX9OT6MkzTlvhtKPgeSneKx8lEwaamQa7Fwx2YoyTIMpwh8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=UqEHsCbh; arc=none smtp.client-ip=209.85.208.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="UqEHsCbh"
Received: by mail-ed1-f74.google.com with SMTP id 4fb4d7f45d1cf-65b9db0c150so511810a12.1
        for <kvmarm@lists.linux.dev>; Thu, 12 Feb 2026 01:02:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1770886974; x=1771491774; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=hohgtHRfz1v94OB8xvfSs3emKAePAKag+PCIiCzGg6U=;
        b=UqEHsCbhfzjZx+YBDRDRhkGSYxMHM5OkHYjtIHACRukl+7U7xgx3+Tu1R7kret8c+Z
         o6Kdo5NRlHD0Nei95hhbf7wsBlC1pnuByZB/vpuZpj3sKOt8R6xL+34xjDGcCX8EhEVX
         ODqov6ztV7240D4JJQmE69XIJ7ISD/qGsjIfc9/vnlrDfocwcDZ2CqMccec/j8Y29YRX
         Ghs7KmY2Us6mtvsQBkrKahz7Loy8bF1woCBEQ6uWtWvVOAIugcjUj/I/VfRVQlgkarON
         iOY+XRfYvsDWwqwJy1x30n5sbGBxX4YeIklcdJVRZdrr1yOCsSDr+FHQyHOguixlZSpE
         20FQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770886974; x=1771491774;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=hohgtHRfz1v94OB8xvfSs3emKAePAKag+PCIiCzGg6U=;
        b=Rd9bAtN5Xe4PN4280Q6K22Bof5ZagL65ksOD22dktACLvHK9zmc0E8iyMr+0zE4Kc1
         TQ/x6PXwvu1sVUEUXm++SPt67GW1F2RzNeV01mKZlGe8YMdfca++02m5L2JEQBl2yarA
         Jvg9JvucoVduSfbgvb9Dylspgsp93SdjrrsI66yiOgv+KVJZ6aXFkNsXUJ00LT6hhi9U
         WlBpSYPVsoyPx7FeAvzedyCkBXV3QKuvua41Oo80tWHRjK0k58TaK4pRRJ9TtjzNTeRI
         hT5dpJuvpIxcODc7SCFBpYwwyORDAENxu3UxHzdhvO0G64QEfgdExcll0A+IqKAKEpE5
         lm3Q==
X-Forwarded-Encrypted: i=1; AJvYcCXk+Q9TvZS5WbCol5Nc5hRESTk0hOaedfmXTAp1aXJUSGfHw/5hLz0PqIj8YrHAJZc6BO1lgx4=@lists.linux.dev
X-Gm-Message-State: AOJu0Yx2SlEs6DO1mjXiYXHkYelc9V4NO3WU02J/8IDCm26v3ejhanXp
	AYa5lc1PbYD+/LZBvrzaCKkZ6akVa/MmkSmMF11h32bsjuyyFGQEkckEUdnq8lKUYSMgBdvOSC3
	1KQ==
X-Received: from edpj17.prod.google.com ([2002:aa7:c0d1:0:b0:65b:a58f:6579])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6402:2681:b0:659:3671:137
 with SMTP id 4fb4d7f45d1cf-65b9dabcd34mr606478a12.1.1770886974387; Thu, 12
 Feb 2026 01:02:54 -0800 (PST)
Date: Thu, 12 Feb 2026 09:02:50 +0000
In-Reply-To: <20260212090252.158689-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260212090252.158689-1-tabba@google.com>
X-Mailer: git-send-email 2.53.0.239.g8d8fc8a987-goog
Message-ID: <20260212090252.158689-2-tabba@google.com>
Subject: [PATCH v1 1/3] KVM: arm64: Hide S1POE from guests when not supported
 by the host
From: Fuad Tabba <tabba@google.com>
To: kvm@vger.kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org
Cc: maz@kernel.org, oliver.upton@linux.dev, joey.gouly@arm.com, 
	suzuki.poulose@arm.com, yuzenghui@huawei.com, catalin.marinas@arm.com, 
	will@kernel.org, tabba@google.com, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

When CONFIG_ARM64_POE is disabled, KVM does not save/restore POR_EL1.
However, ID_AA64MMFR3_EL1 sanitisation currently exposes the feature to
guests whenever the hardware supports it, ignoring the host kernel
configuration.

If a guest detects this feature and attempts to use it, the host will
fail to context-switch POR_EL1, potentially leading to state corruption.

Fix this by masking ID_AA64MMFR3_EL1.S1POE and preventing KVM from
advertising the feature when the host does not support it, i.e.,
system_supports_poe() is false.

Fixes: 70ed7238297f ("KVM: arm64: Sanitise ID_AA64MMFR3_EL1")
Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/include/asm/kvm_host.h | 3 ++-
 arch/arm64/kvm/sys_regs.c         | 3 +++
 2 files changed, 5 insertions(+), 1 deletion(-)

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
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 88a57ca36d96..237e8bd1cf29 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -1816,6 +1816,9 @@ static u64 __kvm_read_sanitised_id_reg(const struct kvm_vcpu *vcpu,
 		       ID_AA64MMFR3_EL1_SCTLRX |
 		       ID_AA64MMFR3_EL1_S1POE |
 		       ID_AA64MMFR3_EL1_S1PIE;
+
+		if (!system_supports_poe())
+			val &= ~ID_AA64MMFR3_EL1_S1POE;
 		break;
 	case SYS_ID_MMFR4_EL1:
 		val &= ~ID_MMFR4_EL1_CCIDX;
-- 
2.53.0.239.g8d8fc8a987-goog

