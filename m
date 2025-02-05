Received: from mail-wr1-f73.google.com (mail-wr1-f73.google.com [209.85.221.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F2201519AB
	for <kvmarm@lists.linux.dev>; Wed,  5 Feb 2025 16:46:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738773996; cv=none; b=g14/2WsnSfwFx3IPWDGBFl7Q+TY/r4G41MljEPnMGu2yfOwIwF52v+U9pZ1WjCsTK6OhHuJNcLFJ9pWzWFcClQHWVAhe/j3xUzADjG7+PvUoxg8MWmKzJVIoZdJa0hYMRiqCepWx3IBQ7D4z7nFJZtmjfotQp7hky2LXLpYgLCM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738773996; c=relaxed/simple;
	bh=ikcA1SQv5W0MEjFwKT/iG6QApecvMYdMbdefLvLWInc=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=Cv2LtGuadSuzaVxQfeOyrUWJ7cK+hnGKJFVhu6wCOcHTfOyPFNv/EVNh0d6W7/uiI2UeKIodFSgAvJovjQHqp6rvYAuv0v4039ViR3tuEMXcyax02Hqg7AhpTWoOP2Pa+mDU90gM4HGIco/LFBON5IlsjBao/YQ7uy48zEmGdXk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=sqp6Q/0u; arc=none smtp.client-ip=209.85.221.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="sqp6Q/0u"
Received: by mail-wr1-f73.google.com with SMTP id ffacd0b85a97d-38dae3db3bcso1221200f8f.1
        for <kvmarm@lists.linux.dev>; Wed, 05 Feb 2025 08:46:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1738773993; x=1739378793; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=SkFMuq0Fr6PdMrmkcZFlVP8qanxuPq/Z9cTQ0NPTc80=;
        b=sqp6Q/0uyZKIMfqfcfBF+U2DW1qwcJL7Z0DtOMvMGw7lCFano2oiz94w29WaV4Omiu
         2QitaNzapCa/3/dM3oswCQ32I6qww1fPWkbD0hlpBbN006Ir+T69FCzUPdbOZF/RbxxV
         n43vW1ScHM3Q1xVELCBYrI1TujvEjhfj2kqsAQcEIxFSS23t/IHTi2Pndqbr5Wlmj37D
         U+kk6xfmVmPdx9zyW7HFxSAEw0OYSdvTX3+Gs/wI+J6hNaiyPJyVUffwn6vlGj7MC4UG
         nAn9skH3DVfH3SrUjbJaOH8SojODjF95/l0BqJxNI5AwfzLoQqDPt6PF8np5laNfeugy
         ktYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738773993; x=1739378793;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=SkFMuq0Fr6PdMrmkcZFlVP8qanxuPq/Z9cTQ0NPTc80=;
        b=rR4SL8HqvsA6kehCV0lT/76OqS/G+iA92mFZJYeBIHr8DG/GOuHp7a4NZbuv+AZivW
         92j9SRqr/P9vyWDkRUtyTOtNJtzUxsKa/hNcrgBh3qEM0MypWIrJeiHqeQgqT0bdNdVs
         dfyuKPKRMilPugQZ9OO3/5zJtm49XjUMAyIybCCsCDy8S6PjRd/lCWsBoKD4cNt74fPL
         NBWbbOthhY5W15gPrFHSLcW7qP/Y6fAfmu46QnFZrhfs04xLskZJPlieWGXPYo48mKYf
         EPcwHbrda0mTl/jwGdDmhwxZ2TqUKJPZjAK+YAwokOmgY25An29vzcWrRU9e1Aha4Jl1
         WBHQ==
X-Gm-Message-State: AOJu0YxC0WQHKhrjpuUzmY5W6qeJ4UlDui8zq7wGyJuffs1EAOO/It0I
	IgF9znertV3ARJsUmklwY5OzuTJN5lj/3X1e2IHPNXFBUus8l6d3yHh4T1fJ28GSB6OFCAe2iuX
	SHetEvu0SOuWxSsxvWn9lRhA9RxsycayVLkOcQKDZXKb6uJ1XREWJps7g2NQ92qcSG/Oea23wW1
	8a/YtejId+eqTwhCuFt65p/LOJUSI=
X-Google-Smtp-Source: AGHT+IHEm2DfODCzmjlMO/PunGzGeoD6QqXGJK0Y0QV6MCGhx0LewDD3vAI9/iXhxv3Xm7vgzyjrFKmltA==
X-Received: from wroz3.prod.google.com ([2002:adf:f1c3:0:b0:386:2cd7:597c])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6000:156b:b0:385:d7a7:ad60
 with SMTP id ffacd0b85a97d-38db48a9b3amr2844611f8f.3.1738773992773; Wed, 05
 Feb 2025 08:46:32 -0800 (PST)
Date: Wed,  5 Feb 2025 16:46:27 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.48.1.362.g079036d154-goog
Message-ID: <20250205164630.1706058-1-tabba@google.com>
Subject: [PATCH v1] arm64: head.S: Do not trap access to MPAMSM_EL1
From: Fuad Tabba <tabba@google.com>
To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org
Cc: maz@kernel.org, oliver.upton@linux.dev, will@kernel.org, 
	joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, 
	catalin.marinas@arm.com, james.morse@arm.com, jingzhangos@google.com, 
	anshuman.khandual@arm.com, shameerali.kolothum.thodi@huawei.com, 
	gshan@redhat.com, tabba@google.com
Content-Type: text/plain; charset="UTF-8"

Bit 50 of MPAM2_EL2, EnMPAMSM, traps access to MPAMSM_EL1 when 0,
as per ARM ARM DDI DDI0487L.a, section D24.12.3. Therefore,
ensure it is set to 1 for the host to disable the traps.

Fixes: 31ff96c38ea3 ("KVM: arm64: Fix missing traps of guest accesses to the MPAM registers")
Fixes: 23b33d1e168c ("arm64: head.S: Initialise MPAM EL2 registers and disable traps")
Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/include/asm/el2_setup.h      | 4 +++-
 arch/arm64/include/asm/kvm_arm.h        | 3 +++
 arch/arm64/kvm/hyp/include/hyp/switch.h | 2 +-
 3 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/include/asm/el2_setup.h b/arch/arm64/include/asm/el2_setup.h
index 25e162651750..fb4da155d994 100644
--- a/arch/arm64/include/asm/el2_setup.h
+++ b/arch/arm64/include/asm/el2_setup.h
@@ -254,8 +254,10 @@
 	mrs	x1, id_aa64pfr0_el1
 	ubfx	x0, x1, #ID_AA64PFR0_EL1_MPAM_SHIFT, #4
 	cbz	x0, .Lskip_mpam_\@		// skip if no MPAM
-	msr_s	SYS_MPAM2_EL2, xzr		// use the default partition
+	mov_q	x0, MPAM2_HOST_FLAGS
+	msr_s	SYS_MPAM2_EL2, x0		// use the default partition
 						// and disable lower traps
+						// don't trap access to MPAMSM_EL1
 	mrs_s	x0, SYS_MPAMIDR_EL1
 	tbz	x0, #MPAMIDR_EL1_HAS_HCR_SHIFT, .Lskip_mpam_\@	// skip if no MPAMHCR reg
 	msr_s	SYS_MPAMHCR_EL2, xzr		// clear TRAP_MPAMIDR_EL1 -> EL2
diff --git a/arch/arm64/include/asm/kvm_arm.h b/arch/arm64/include/asm/kvm_arm.h
index 8d94a6c0ed5c..78d46d52b3da 100644
--- a/arch/arm64/include/asm/kvm_arm.h
+++ b/arch/arm64/include/asm/kvm_arm.h
@@ -147,6 +147,9 @@
 
 #define VTCR_EL2_T0SZ(x)	TCR_T0SZ(x)
 
+/* MPAM2_EL2 for the host to ensure not to trap access to MPAMSM_EL1. */
+#define MPAM2_HOST_FLAGS	MPAM2_EL2_EnMPAMSM
+
 /*
  * We configure the Stage-2 page tables to always restrict the IPA space to be
  * 40 bits wide (T0SZ = 24).  Systems with a PARange smaller than 40 bits are
diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h b/arch/arm64/kvm/hyp/include/hyp/switch.h
index f838a45665f2..44b4995258e8 100644
--- a/arch/arm64/kvm/hyp/include/hyp/switch.h
+++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
@@ -227,7 +227,7 @@ static inline void __deactivate_traps_mpam(void)
 	if (!system_supports_mpam())
 		return;
 
-	write_sysreg_s(0, SYS_MPAM2_EL2);
+	write_sysreg_s(MPAM2_HOST_FLAGS, SYS_MPAM2_EL2);
 
 	if (system_supports_mpam_hcr())
 		write_sysreg_s(MPAMHCR_HOST_FLAGS, SYS_MPAMHCR_EL2);

base-commit: 2014c95afecee3e76ca4a56956a936e23283f05b
-- 
2.48.1.362.g079036d154-goog

