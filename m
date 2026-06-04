Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97D7B33E35C
	for <kvmarm@lists.linux.dev>; Thu,  4 Jun 2026 15:12:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780585979; cv=none; b=Iih8TzxWvPxcVZJfjAbWhlVntQqS1JB9q8HF24YKzggJf01PK0LUInOGlsSE9JcPPbN1ECgOsKSxZRJFjTQ4/K6VnhYo9ZrrUspkgTup2P+aFVjdPDWC8iWVoL9Q/BSBLZ5537dBtYsigua13uBA8zFx+kJg5O6jNIPflRqa5Qs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780585979; c=relaxed/simple;
	bh=yaNhbo36n56sft12Ju/NGDPc1JQmr+tc7CqfPwD7F7s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JjUghqGEHxTof+eswJHTcwt0G8WBGDii8HqTgZ3mFTf7/VbDIsI94+SIpPs3e85zbWOljTutYZAbdSbVu0Ug9bUcOTWkiqiFHPXsqsnkk37puKOVrzkxIuDcEJNcuyZ9el/uCsPf5RRlrZ1EfhG60kfBkfDR/JvIioKYAy3Jw0Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=QqaJgTGb; arc=none smtp.client-ip=209.85.214.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QqaJgTGb"
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-2c0c20f0c0aso6180265ad.0
        for <kvmarm@lists.linux.dev>; Thu, 04 Jun 2026 08:12:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780585978; x=1781190778; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jx8Q3lCGNmWi6X5YDYYuwkPijRSSNnRUooDmPqenZLY=;
        b=QqaJgTGbV9Sl86mBWaJDLG9dAqI3GxtE5Okxd+uAHtE+cUcPyoPRqSElBXFqbU2JFf
         EDZdlPFWwgRsLmwi38kU4gixZwmSRkKotUA/zytlFY3GkbcG/G0ZNJGnOah7PWbC/q6Q
         NBaxhdoP9Y5iMJMeIMgJE0fuS0ZhM1ym3q6pFLm6WgRnOatvUfNxjRpEyhLKUI8JEkqq
         aEFcW5UyBNAQ+mYX8f9ZbVIXi7JKiC6cYjm+oEy2k2M/Dne1+1G83C0Xi+G+h2XMrKzz
         59vUszXbkBC5dN1VcG+W2X4aKsNh7WlBG49VMLaVBG0ILLtgXmOrin76fJvF0zYAuM9E
         9fDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780585978; x=1781190778;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=jx8Q3lCGNmWi6X5YDYYuwkPijRSSNnRUooDmPqenZLY=;
        b=FIKPikGXzhYGk5dUOFy2V+WCgCM1cB1a+Vcx84dEe6mRZqBLefxWcQX74VDEHG0/rI
         9k18sX0orDoVXGILGExGOtxwAtAim1zBznElZHAInSKdvPhBJySKdo8ldcCehTYahm3i
         +1nSnOaKIdkRjA1okE7OoMkGiWWz15V44gyQ+l7TeLRZVmR3U7lwuPIRlRMun8UMKjW8
         ezu6lZGkKr+wj/d6EbkilOEugUw5bYkgj9Bl3UxIFr5utTkYInkZXbtJW64aMj1NztNT
         mtwHohRw4xLG083m09XjhkHj3u+mzf3mpYjRwUQ0C6EO068iRZwCwmt+MaK05p8HRHbJ
         ZmlQ==
X-Forwarded-Encrypted: i=1; AFNElJ+xSoKZI8a72hgDl26pe31iEymoX4eJpW8zKpA5upw/W/9N04kBuyaaCc8e+udDEA6ZObyTsAY=@lists.linux.dev
X-Gm-Message-State: AOJu0YyR+NRyeHqGJnoqtKWojy3WRZLxW+Ef44L+htJl5lt5iP6NynhL
	p18yKisgtY/In4bR4C75FwX1s+k85g0gVTry9FL4V0ViB059QmAQ/SUx
X-Gm-Gg: Acq92OEiEBIGjhIVAO2dbbcU1Lz88+pets2VJ+hDCTlyLHP0dLTvDEXWg0fnq3S4Mp1
	FsiNnRtu6cswPa9b1BjF+8z/splXtOTJ3JNu7jdfWYJ3NK+phL0ybhsoifdfcGotUfqk49pE5wl
	Cz3epq0nBsMysejtO8znHHwoi+OvMF/zjCdhygfM72riR4+zyVixZsWFunaqmPpyk2aN8kXMZw0
	xhIphCuI3LwCOBU6O2CLG9gDCiX6N/FwIcBr+ZBhtCzUSZchp83+QVtRj7M+E9Kbuf78CgBZi5c
	k1ObeubE0eP677eySYX7R8FV4QhKALmCTudUoNEruwVVTXU1W8ji0zU5n1V3MN7H3QT4qYY/Vf2
	C7Cjz5N4/OBAWYyUH9LqAKwfZtt4hooB03YGLtOkbT5GxdNfgIRWmyWlwtKrqJcbRV9Fhjh0mvI
	Z0/ZoVuQ+CSeIg6HtM7Y4ll+v6Ul1KkqciaQYG7bpttCdANH9FaKU7R4p/
X-Received: by 2002:a17:903:2a8b:b0:2c1:1685:b8f with SMTP id d9443c01a7336-2c163a10116mr112073815ad.9.1780585977829;
        Thu, 04 Jun 2026 08:12:57 -0700 (PDT)
Received: from v4bel.. ([58.123.110.97])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2c1664a67b0sm62705105ad.80.2026.06.04.08.12.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Jun 2026 08:12:57 -0700 (PDT)
From: Hyunwoo Kim <imv4bel@gmail.com>
To: tabba@google.com,
	maz@kernel.org,
	oupton@kernel.org,
	joey.gouly@arm.com,
	seiden@linux.ibm.com,
	suzuki.poulose@arm.com,
	yuzenghui@huawei.com,
	catalin.marinas@arm.com,
	will@kernel.org
Cc: linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	imv4bel@gmail.com
Subject: [PATCH v2 2/2] KVM: arm64: Bound used_lrs when flushing the pKVM hyp vCPU
Date: Fri,  5 Jun 2026 00:12:03 +0900
Message-ID: <20260604151210.1304051-3-imv4bel@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260604151210.1304051-1-imv4bel@gmail.com>
References: <20260604151210.1304051-1-imv4bel@gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

flush_hyp_vcpu() copies the host vGIC state into the hyp's private vCPU
on every run. The vGIC list register save and restore use used_lrs as
their loop bound and expect it to stay within the number of implemented
list registers. While this is generally the case, flush_hyp_vcpu()
copies vgic_v3 verbatim and does not enforce this, so a value provided
by the host is used at EL2 to index vgic_lr[] and access ICH_LR<n>_EL2
(host -> EL2).

Fix by clamping used_lrs to the number of implemented list registers
after the copy, as the trusted path already does in
vgic_flush_lr_state().

Fixes: be66e67f1750 ("KVM: arm64: Use the pKVM hyp vCPU structure in handle___kvm_vcpu_run()")
Signed-off-by: Hyunwoo Kim <imv4bel@gmail.com>
---
 arch/arm64/kvm/hyp/nvhe/hyp-main.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
index 02c5d6e5abcbf..cd807fdb11ba8 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
@@ -7,6 +7,7 @@
 #include <hyp/adjust_pc.h>
 #include <hyp/switch.h>
 
+#include <asm/arch_gicv3.h>
 #include <asm/pgtable-types.h>
 #include <asm/kvm_asm.h>
 #include <asm/kvm_emulate.h>
@@ -142,6 +143,13 @@ static void flush_hyp_vcpu(struct pkvm_hyp_vcpu *hyp_vcpu)
 
 	hyp_vcpu->vcpu.arch.vgic_cpu.vgic_v3 = host_vcpu->arch.vgic_cpu.vgic_v3;
 
+	/* Bound used_lrs by the number of implemented list registers. */
+	if (static_branch_unlikely(&kvm_vgic_global_state.gicv3_cpuif))
+		hyp_vcpu->vcpu.arch.vgic_cpu.vgic_v3.used_lrs =
+			min_t(unsigned int,
+			      hyp_vcpu->vcpu.arch.vgic_cpu.vgic_v3.used_lrs,
+			      (read_gicreg(ICH_VTR_EL2) & 0xf) + 1);
+
 	hyp_vcpu->vcpu.arch.pid = host_vcpu->arch.pid;
 }
 
-- 
2.43.0

