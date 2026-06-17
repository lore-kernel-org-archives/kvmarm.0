Received: from mail-ed1-f74.google.com (mail-ed1-f74.google.com [209.85.208.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C37C539F162
	for <kvmarm@lists.linux.dev>; Wed, 17 Jun 2026 09:55:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781690111; cv=none; b=nmjMc5+sp3BHbfFlm8TgXZmgo2vIPIFcpPsvUSL0SsoY/sccQoM0Ab87JDw66vvXNuWbEMvhWZJ0fcdIBz+29ZE1aI7SNiDktCQG5IfMSAW1LmAsD1zNZHr5dzF0TnAfjl5YSlHcI+1Depn8Nmy7QKcoLLWk86GkX4nbu3zpN/0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781690111; c=relaxed/simple;
	bh=B7qBebAIhdESCveJZGkHJcinvDTv8a3ksYvJ/U0He/Y=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=GM130sD7N0x3m6ilkxYMPCizHvZemn7ODIWzdoRHrSmw4f7e/xqzsGlDWEUeTjRc1cqy5Y8LbYNd/gkvqeKXhp6tlMKNqeTx5Xz2Px7yWR0LHzA5Ee9oQQMeWo2/WMDBpyMfdYrCdsXJNux3jzCHus8odLwoICUwAEsaYOypiWQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=OF1tA9bn; arc=none smtp.client-ip=209.85.208.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="OF1tA9bn"
Received: by mail-ed1-f74.google.com with SMTP id 4fb4d7f45d1cf-68f9f08cfcaso5061666a12.2
        for <kvmarm@lists.linux.dev>; Wed, 17 Jun 2026 02:55:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1781690108; x=1782294908; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=zTinsQw/nEGi1wFzOxFuLPf8UTkNQwbK0dcHdALi4gQ=;
        b=OF1tA9bncACUVnCpkYJxBg8jaIjZrlxPI4i+zITj5+xZPH2iW/kFiJMxrPpaUUjV/0
         NJaux1fTePD3EMGPyJb24hyDMOc2amB7BhIIq+jBaCMNLAFmBK3quxS03bItRqAsBxdV
         hvjmCTbwaDjJFwzMZDsmdtukSv/Dul+xPk/izLffyzsfaVONQ6RqQ3piPZ6Duf5ZBEFP
         huFg6TwqXBf1kNAmB9EujiXKWIskt4/l4R7xadWE892Y+NiseI8YOflJT93P5cvPe+zO
         eFUUz+xd1wsvZy/pvrIf1GxiF9pxHHOaK3IbeAo+fhWvrQdpJCkEwSLm8pgahCkbA75S
         1x4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781690108; x=1782294908;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=zTinsQw/nEGi1wFzOxFuLPf8UTkNQwbK0dcHdALi4gQ=;
        b=pf/JMqKNsAMmOt5Tqb1tUnNvmiB+M5gDS/uBsYZRRhAFioRWhxH4Jx42mxapYBm/if
         sjdWO6D/ajspfJfN63XKkbGXGXvIGuWPO+7GuR26+TyObvvm4Hs2jMAYl49m3+9dZ7Yw
         aItpThxBz/ex12JvW0FFWQ2c2dL04spsv9vnv62/HhZp0cAtutGkgPAIzWv+4T1bx1TV
         9D2NdCnUD9gNb5UBOU4DpCbtB/dr9eotw1KrYC4eZ/AyNfEBG1P8/1qh5gvXX2uB0CY4
         pzVRpsvpG7YEThHWxxbNi/K8Nk2TCCN84/H0xgJbjEvhSB2D2YvUrbCgZIHyP/yDyfGS
         VPLA==
X-Forwarded-Encrypted: i=1; AFNElJ85d8fKgzcDTlBqbvb106AkVX7R1OBHDkuBNW6ReXEa/7pnB00DxNHzfmK124Tt+ho7aBqSsTU=@lists.linux.dev
X-Gm-Message-State: AOJu0Yzz6S/PyFFrdjJ80xlpuTQf0blNMnSuBX/WJI3wBDLt2dG053r9
	LIWZeqVT6x8t755Emgo7/0N++kbpd+CUL0604kctFZTtqmZe5mjYOd3khYvpBrEOKEMi51UKxgl
	70bBAYC1mGprONWMWGqbtVw==
X-Received: from edr4.prod.google.com ([2002:a05:6402:44c4:b0:692:18a5:3cb8])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6402:5293:b0:693:ee1:9018 with SMTP id 4fb4d7f45d1cf-695474c4c20mr1392906a12.28.1781690107629;
 Wed, 17 Jun 2026 02:55:07 -0700 (PDT)
Date: Wed, 17 Jun 2026 10:52:38 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.54.0.1136.gdb2ca164c4-goog
Message-ID: <20260617095238.1530121-1-vdonnefort@google.com>
Subject: [PATCH] KVM: arm64: Add missing hyp_enter when trapping sysreg
From: Vincent Donnefort <vdonnefort@google.com>
To: maz@kernel.org, oliver.upton@linux.dev, joey.gouly@arm.com, 
	suzuki.poulose@arm.com, yuzenghui@huawei.com, catalin.marinas@arm.com, 
	will@kernel.org
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kernel-team@android.com, tabba@google.com, 
	Vincent Donnefort <vdonnefort@google.com>
Content-Type: text/plain; charset="UTF-8"

Add a missing hypervisor event call for hyp_enter on sysreg trapping,
causing an unbalanced hyp_enter/hyp_exit.

The enum hyp_enter_exit_reason is not ABI, so we can keep the ERET
reasons at the end for clarity.

Fixes: 696dfec22b8e ("KVM: arm64: Add hyp_enter/hyp_exit events to nVHE/pKVM hyp")
Signed-off-by: Vincent Donnefort <vdonnefort@google.com>

diff --git a/arch/arm64/include/asm/kvm_hypevents.h b/arch/arm64/include/asm/kvm_hypevents.h
index 743c49bd878f..5f6e6789d121 100644
--- a/arch/arm64/include/asm/kvm_hypevents.h
+++ b/arch/arm64/include/asm/kvm_hypevents.h
@@ -12,6 +12,7 @@
 enum hyp_enter_exit_reason {
 	HYP_REASON_SMC,
 	HYP_REASON_HVC,
+	HYP_REASON_SYS,
 	HYP_REASON_PSCI,
 	HYP_REASON_HOST_ABORT,
 	HYP_REASON_GUEST_EXIT,
diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
index 06db299c37a8..45a4abb9619d 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
@@ -913,6 +913,7 @@ void handle_trap(struct kvm_cpu_context *host_ctxt)
 		handle_host_mem_abort(host_ctxt);
 		break;
 	case ESR_ELx_EC_SYS64:
+		trace_hyp_enter(host_ctxt, HYP_REASON_SYS);
 		if (handle_host_mte(esr))
 			break;
 		fallthrough;
diff --git a/arch/arm64/kvm/hyp_trace.c b/arch/arm64/kvm/hyp_trace.c
index c4b3ee552131..c84434e2349a 100644
--- a/arch/arm64/kvm/hyp_trace.c
+++ b/arch/arm64/kvm/hyp_trace.c
@@ -398,6 +398,7 @@ static const char *__hyp_enter_exit_reason_str(u8 reason)
 	static const char strs[][12] = {
 		"smc",
 		"hvc",
+		"sys",
 		"psci",
 		"host_abort",
 		"guest_exit",

base-commit: 8cd9520d35a6c38db6567e97dd93b1f11f185dc6
-- 
2.54.0.1136.gdb2ca164c4-goog

