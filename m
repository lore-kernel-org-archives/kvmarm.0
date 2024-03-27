Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 945B5F4E2
	for <kvmarm@lists.linux.dev>; Wed, 27 Mar 2024 17:35:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711560941; cv=none; b=JU+CWq7CXrNn8wYuAQnhXCmImZZNIIKNZDXlVpOy8Z/ipXU42yd+9aLI+3yVOpznfyfYd/BH2j5d+54bFIy0nv5BhFLe7EuQaEh0wjtowxmIFtFAqpsMx5dHw0TFnUBUi4oLStI1S/TGa76IrDnUbdkHzAuYJ5SgakY/V7ZkAD4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711560941; c=relaxed/simple;
	bh=Mjyl6m0ZPxQLo7f+KWqCmulgaboejtjxvawOVa5pD7w=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=n4dqUhPRkgHPaJocvFS/3F4f9ez1nY5yopXomd5gwTaPC7arX/6Bdb5DP/qPk6W2wSz/oz5ZGggO1Kk77RRCwsR/pWsCtrKAkR0i9zV9YMObDunmA9cW0vMwAPz/4/6+OkjhpEW0iKvZDOSOFwnAwtLrl5tvttb976w0baVMnkY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=xZNOIYRS; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="xZNOIYRS"
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-4140d2917e6so292565e9.0
        for <kvmarm@lists.linux.dev>; Wed, 27 Mar 2024 10:35:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1711560938; x=1712165738; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=NUzKcYrrG9GVcJ2vQ+rL1jGLyHzQALHGWx/8oAcLBPo=;
        b=xZNOIYRS9v6I3IHdH4eVH0ROh6TPdyw0dXspbFdxabFGucGjDAFSDkxu933R/WSHP5
         uOpruCYIy1OHQL92C0ZUff/UAazY6LN196JdS0S9ASfwBEKIxoLNfPgqIdy+VgtYn/Zg
         gAY/nFdvLM0BKpkyLzy9vuQzqHsoqxLCtzBm/et3VKo+m7lTWie92JIXfva0a04i7yod
         tXDQu3CBRn57aWFO3BP557L7KhZJKUIL/K1s34ECpC9VajJ1/oXWLe79qMFU/k4ySL7N
         SZlzPEGi9hkHUGyHlaH1iBGitmp0vty7cTS4w7oocZrH8zFBhSlfjU9EqIIhedWWyuk5
         hAfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711560938; x=1712165738;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=NUzKcYrrG9GVcJ2vQ+rL1jGLyHzQALHGWx/8oAcLBPo=;
        b=uHrRZoxhvWfCy/G/I7sd+M0G7tkWaiTHiAWj0L8WxDkN2LNrw4OIuosyQZTwokVFmn
         8dk+gbl6iwzPq/+iKMHXJd7n9vhMlBur9Y7WxsUMkJtDZms6txNHMf0YLAl8DxzmkC/S
         5/DBiMIZVIhfEig5VAq65fBo4FitmIJly8bGj7lu3hO1tXkQf+D/wrfMlFvVaW24xMTY
         IxcSZdUgyUBCAuBwpbLgG+2GtLlC6ljiYSVfODzFhw9lqV5mWtpp7d5029CqMZbByXg5
         /hr4mLE3DNBUSpVzbiMifHhIqOLb/jvVWfo8Oy1t95cq+61Yp5vANNBwkAQs4ZlY7Ouv
         4+iw==
X-Gm-Message-State: AOJu0Yy+Ak4IpDe6bs8fcQjIVT+Vf81Gw1inPcQ9tAF+hEot1n7c3/Zq
	JDTqZQfqZ/vp2cDSUe5OBs7XPjtoerMEenaZVILFlnFXEPgceNBL6q2wa7Wk2OdKpsJxsI5G6jq
	aChToL7ZTnxPvLXB4KR2CJPN7t6cEZlYr0IPuKyibq1QcKuTsvLIjfGMYPcYiD6KA62cj0NLJPh
	fThPVUtM6hPG/siILNw9rAxtSIBBQ=
X-Google-Smtp-Source: AGHT+IFnh+YJoXTF/ddcOJzmAC5tyPFA4uaqNRelpY/UTPu4VWuCrmQyszMHGVttJANobHzxGMzkaqGa+w==
X-Received: from fuad.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1613])
 (user=tabba job=sendgmr) by 2002:a05:600c:1d1f:b0:414:21c:fb13 with SMTP id
 l31-20020a05600c1d1f00b00414021cfb13mr109wms.2.1711560938083; Wed, 27 Mar
 2024 10:35:38 -0700 (PDT)
Date: Wed, 27 Mar 2024 17:34:49 +0000
In-Reply-To: <20240327173531.1379685-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240327173531.1379685-1-tabba@google.com>
X-Mailer: git-send-email 2.44.0.478.gd926399ef9-goog
Message-ID: <20240327173531.1379685-3-tabba@google.com>
Subject: [PATCH v1 02/44] KVM: arm64: Use enum instead of helper for checking FP-state
From: Fuad Tabba <tabba@google.com>
To: kvmarm@lists.linux.dev
Cc: maz@kernel.org, will@kernel.org, qperret@google.com, tabba@google.com, 
	seanjc@google.com, alexandru.elisei@arm.com, catalin.marinas@arm.com, 
	philmd@linaro.org, james.morse@arm.com, suzuki.poulose@arm.com, 
	oliver.upton@linux.dev, mark.rutland@arm.com, broonie@kernel.org, 
	joey.gouly@arm.com, rananta@google.com
Content-Type: text/plain; charset="UTF-8"

Before the conversion of the various FP-state booleans into an
enum representing the state, this helper may have clarified
things. Since the introduction of the enum, the helper obfuscates
rather than clarifies. This also makes the code consistent with
other parts that check the FP-state.

No functional change intended.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/kvm/hyp/include/hyp/switch.h | 6 ------
 arch/arm64/kvm/hyp/nvhe/switch.c        | 2 +-
 arch/arm64/kvm/hyp/vhe/switch.c         | 2 +-
 3 files changed, 2 insertions(+), 8 deletions(-)

diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h b/arch/arm64/kvm/hyp/include/hyp/switch.h
index e3fcf8c4d5b4..1a6dfd035531 100644
--- a/arch/arm64/kvm/hyp/include/hyp/switch.h
+++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
@@ -39,12 +39,6 @@ struct kvm_exception_table_entry {
 extern struct kvm_exception_table_entry __start___kvm_ex_table;
 extern struct kvm_exception_table_entry __stop___kvm_ex_table;
 
-/* Check whether the FP regs are owned by the guest */
-static inline bool guest_owns_fp_regs(struct kvm_vcpu *vcpu)
-{
-	return vcpu->arch.fp_state == FP_STATE_GUEST_OWNED;
-}
-
 /* Save the 32-bit only FPSIMD system register state */
 static inline void __fpsimd_save_fpexc32(struct kvm_vcpu *vcpu)
 {
diff --git a/arch/arm64/kvm/hyp/nvhe/switch.c b/arch/arm64/kvm/hyp/nvhe/switch.c
index c50f8459e4fc..2a0b0d6da7c7 100644
--- a/arch/arm64/kvm/hyp/nvhe/switch.c
+++ b/arch/arm64/kvm/hyp/nvhe/switch.c
@@ -53,7 +53,7 @@ static void __activate_traps(struct kvm_vcpu *vcpu)
 			val |= CPTR_EL2_TSM;
 	}
 
-	if (!guest_owns_fp_regs(vcpu)) {
+	if (vcpu->arch.fp_state != FP_STATE_GUEST_OWNED) {
 		if (has_hvhe())
 			val &= ~(CPACR_EL1_FPEN_EL0EN | CPACR_EL1_FPEN_EL1EN |
 				 CPACR_EL1_ZEN_EL0EN | CPACR_EL1_ZEN_EL1EN);
diff --git a/arch/arm64/kvm/hyp/vhe/switch.c b/arch/arm64/kvm/hyp/vhe/switch.c
index 1581df6aec87..e9197f086137 100644
--- a/arch/arm64/kvm/hyp/vhe/switch.c
+++ b/arch/arm64/kvm/hyp/vhe/switch.c
@@ -75,7 +75,7 @@ static void __activate_traps(struct kvm_vcpu *vcpu)
 
 	val |= CPTR_EL2_TAM;
 
-	if (guest_owns_fp_regs(vcpu)) {
+	if (vcpu->arch.fp_state == FP_STATE_GUEST_OWNED) {
 		if (vcpu_has_sve(vcpu))
 			val |= CPACR_EL1_ZEN_EL0EN | CPACR_EL1_ZEN_EL1EN;
 	} else {
-- 
2.44.0.478.gd926399ef9-goog

