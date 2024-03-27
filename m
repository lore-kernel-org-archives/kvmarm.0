Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 187AB14C5A7
	for <kvmarm@lists.linux.dev>; Wed, 27 Mar 2024 17:36:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711560966; cv=none; b=ITHO+KqU1UxJNrYdIEKYn3QhKCDDD8dMX8Q6NwEjZkLT/PV7P0ATTC/YbE9D29Sxeh2QmWDI/4JwbtypqFcPc2HOLoQYaqM7K4VTzSfwRY970s93WCrc3jvPDUL5UGcN4iuyvHh01dGSBcPdaGqwyKTotnMUz6G9ePuGB7f7lsw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711560966; c=relaxed/simple;
	bh=m7adz0tGx02CM1+Ido48XknOdAPpf4PCc0UXmdpPJ0A=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ZK120xTiT+i0cTasPRVF9K8T2v6W3v0g0XyLKSToavRxwJcX9dfbBdVkIMpaWPIWzLh69RBAOTxFtDoAZYX4lxYgRLj28J/xx0jcvifcLPUKo9qGLDojxcJ3o+Vd+H+8lAjUwWSDRYftQS67X0ZhRCAL71YfVOVhh/RyihclbcQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=gkWiavLU; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="gkWiavLU"
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-60a54004e9fso1367207b3.3
        for <kvmarm@lists.linux.dev>; Wed, 27 Mar 2024 10:36:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1711560964; x=1712165764; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=1U/FRkylkjRhrD9oLKLCbvzCg8O8tRttNKOLHC8VHGo=;
        b=gkWiavLUOHLtyKixw8obT6ckbAmfC6cJf0dHxUMFnM6H4oMFO2q6X1xZApUS0DrkXj
         oUBOvc+jo0OEWf8Cai3NRk6aBNsrrBxJJ2k/xs8bzLD+ZZWDxCVkk+rTwzVLBZVz9SSf
         BCI0fKoae0vs1fDKneK12wZfXnyuo6i1MtSL+Xbo49y5fSUAHjulx+zKZGncWt6HV9TI
         amgleoI5LPBVmQbEvkN6Nbu/mJBAoAweXGe8/HzGRFPGyRqhrUBhxzFGxHOs2K9wgKw1
         QbvUGvijraf+WAmWaZGh8j9IIZIovnoj1rzxae2pwApCv8n1bijld9y0M6jjCm69aJfg
         42Dg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711560964; x=1712165764;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=1U/FRkylkjRhrD9oLKLCbvzCg8O8tRttNKOLHC8VHGo=;
        b=WmOyIIKEESCHchc31wTs7kUYf12gKiijH7xQ4xktHdRmhLNG0Z4l35dR0tshtSsLGJ
         ae/4DMJmKGXYebHTfIDWu8uER8xJql8bJjlFczRMHXzlLGL92fSzWhZwdB5e3L6X3SsR
         Xt4QcR5Dyc2g7KpZ5UbTxYzNV3miPbobqdIAsUp4ZqFXsvMidLJLNYdRRgGBSwxswpAv
         Uc6jVJvzLxUkSb3+oHNGvtKMXzjZgcaqXfGqdNCF/b+QhE0Jn+/RpaEBfyqlPHKxUYeD
         +Qfvt01HEm08mYe7uRH26ODWqkWYf36T5eWEEYrXQxQ1q2+o1EfN8bGBmHwtjvVyq3Ji
         8MQw==
X-Gm-Message-State: AOJu0YzRuUDVcNVY4UPeRURI3P7lmxS7IKyGA2R4McftRbJuL/z9YN3X
	jyyDRa9o2r0PkhWzE594jrchp69yMFavDuhyszRv3ASRLy49nYiDy/BjW69+HtsobNa4fJQ7uNC
	UOaEG6BAU6Yw4NVs8Q0jggnwN1ip7VfYXIPjDK0i6JtxTwrAWjYBbL80pBCUwVNW7YMCnnEQWxS
	TVjb9BHnY8UAAvfFynSerWMG7HliM=
X-Google-Smtp-Source: AGHT+IGrlKACSc0jmHLnbEJqsPwEVmFu7xQ+fv41bRkyK3DHho9Y67x2aJb1z76GOUM9vWDNDIlvEHurfw==
X-Received: from fuad.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1613])
 (user=tabba job=sendgmr) by 2002:a05:6902:2407:b0:dcb:b9d7:2760 with SMTP id
 dr7-20020a056902240700b00dcbb9d72760mr152465ybb.13.1711560964092; Wed, 27 Mar
 2024 10:36:04 -0700 (PDT)
Date: Wed, 27 Mar 2024 17:35:00 +0000
In-Reply-To: <20240327173531.1379685-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240327173531.1379685-1-tabba@google.com>
X-Mailer: git-send-email 2.44.0.478.gd926399ef9-goog
Message-ID: <20240327173531.1379685-14-tabba@google.com>
Subject: [PATCH v1 13/44] KVM: arm64: Clarify rationale for ZCR_EL1 value
 restored on guest exit
From: Fuad Tabba <tabba@google.com>
To: kvmarm@lists.linux.dev
Cc: maz@kernel.org, will@kernel.org, qperret@google.com, tabba@google.com, 
	seanjc@google.com, alexandru.elisei@arm.com, catalin.marinas@arm.com, 
	philmd@linaro.org, james.morse@arm.com, suzuki.poulose@arm.com, 
	oliver.upton@linux.dev, mark.rutland@arm.com, broonie@kernel.org, 
	joey.gouly@arm.com, rananta@google.com
Content-Type: text/plain; charset="UTF-8"

Expand comment clarifying why the host value representing SVE
vector length being restored for ZCR_EL1 on guest exit isn't the
same as it was on guest entry.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/kvm/fpsimd.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/fpsimd.c b/arch/arm64/kvm/fpsimd.c
index 826307e19e3a..f297e89e4810 100644
--- a/arch/arm64/kvm/fpsimd.c
+++ b/arch/arm64/kvm/fpsimd.c
@@ -200,7 +200,18 @@ void kvm_arch_vcpu_put_fp(struct kvm_vcpu *vcpu)
 		if (vcpu_has_sve(vcpu)) {
 			__vcpu_sys_reg(vcpu, ZCR_EL1) = read_sysreg_el1(SYS_ZCR);
 
-			/* Restore the VL that was saved when bound to the CPU */
+			/*
+			 * Restore the VL that was saved when bound to the CPU,
+			 * which is the maximum VL for the guest. Because
+			 * the layout of the data when saving the sve state
+			 * depends on the VL, we need to use a consistent VL.
+			 * Note that this means that at guest exit ZCR_EL1 is
+			 * not necessarily the same as on guest entry.
+			 *
+			 * Flushing the cpu state sets the TIF_FOREIGN_FPSTATE
+			 * bit for the context, which lets the kernel restore
+			 * the sve state, including ZCR_EL1 later.
+			 */
 			if (!has_vhe())
 				sve_cond_update_zcr_vq(vcpu_sve_max_vq(vcpu) - 1,
 						       SYS_ZCR_EL1);
-- 
2.44.0.478.gd926399ef9-goog

