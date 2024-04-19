Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E0D13E485
	for <kvmarm@lists.linux.dev>; Fri, 19 Apr 2024 08:00:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713513631; cv=none; b=n6bot39K9cjy3PcQN3dS8z30L0GssjHm7Q4bBijKgVsayMq0rewvRqybcXn1UQcVSM3xjiTvV6DXU+MlPOjqc4eCDYrIMbhbJhD1Y2pU3WdrghvfzJRr26tIT7pgw04AIz3Wxk2NghllgptPrNZKlMeeGGcqd9zCgercTc8YrMI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713513631; c=relaxed/simple;
	bh=fpBNfUng3ivWZ/e1rNCZE3PiicNxTH+p1yaN63flohI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=oxj9SihzpuOcqiNdYwc5gqBKhQosKarK/5GfQoUTERDJvzURc4DTDhmDVceXkGnxG9R9V79eaq6ZYExvGdJtIWo4b1wwGjgRmRQKd9qNx5FifRXl5+kgA6/uKV8qT9EqDkPlYB1MxxX4H5laJx4rO4vA3gJuFET+EwYUxpnI6Ts=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=UHHZRJat; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="UHHZRJat"
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-61afae89be3so35169547b3.0
        for <kvmarm@lists.linux.dev>; Fri, 19 Apr 2024 01:00:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1713513629; x=1714118429; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=0d8Ru5GVRSJ4WBKuASRyEck6e/9MaagweE0nrh6F3CY=;
        b=UHHZRJatMI0Wq84AfouUPnbi4Srm6BO/kbeetnzCd6LpKV3iiMFSG/5mXSNnIt4ULg
         l/3NQV9WiuSqJioT8no306uLQDrkc3y+LFLvzfaHsZCcn4ZqriuciggIRDXynOoziLTO
         5Xo7vaNRqL+prWwBPFGJ43N+oJxvLTHdptdmh6mYI/wQPchRi49/CuosB+PpeOO0GQMk
         xI7cC/T1sd2t0xabpYq0qyHP2zpGH+utfq884HKZEFM1c85Izg3TpfIkrthbG/MVHTms
         dktY3/4h3OY25JkTs7nOFAd0fXmutnVLv6VHzdgHy0/ikn3rYlWCqDDj/QmmvCRT+ON8
         z3mA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713513629; x=1714118429;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=0d8Ru5GVRSJ4WBKuASRyEck6e/9MaagweE0nrh6F3CY=;
        b=juKPEWJ2WmgGf+eYS+0Ea+DLtk+y5kwhWaRswrihHh3FeOh4HN1biRMSkv9gmgFpJD
         wzTzT+W2EEvxbaSyehOFAsWtzc0fohS1AzSi4WbVXQkEf9KAqr27IdcYgDfzAjnrugjN
         dOUufWLZ78acuHnb5PCnM5BCGAxUZd7d/cd4x88xHbrwUHpJ2dI/pWWqHKp8s9orucwb
         8Rnk8X/6nkdCCHK9idNtlfHgGx6qyC7xnnpYSdq/CEnx5PjsU/13PiHYDlwH+1m2woh9
         ZXZKGzCBo+JvxIfXNCVuJj+NxrfwOF6zQqy11ndUit+hgujqZas/x5yBz16pK/zShxMB
         ZvvA==
X-Gm-Message-State: AOJu0Yyli82eq1n2Gk4cYRCiTKdHp42pgMI2iaUBZY1HU7QWutqpTq57
	11cK6LsDVKFpfqUi7pvahPf2LTqEaz9jpUROPQIYO2wHbZDt0iW3+vg1G+z3CxKt8EP00NvQk5r
	kNckWuA6eVOUh+bvLajFLICgP1QG3jhuXFuh741FX/S6ORHq9QdKHJs6RWCBgfFWJmW1jIC5PiF
	cA/YhK2if4MGKYHhSJfw/HkQTPnaE=
X-Google-Smtp-Source: AGHT+IGxBRzYFlC9tq7G1nweAS4mZ/NVhT6UC9RT8IwibxFkd33k76M7sW48zTVm+zdOMfCozUcO+6YifQ==
X-Received: from fuad.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1613])
 (user=tabba job=sendgmr) by 2002:a0d:d913:0:b0:618:9044:4f8b with SMTP id
 b19-20020a0dd913000000b0061890444f8bmr317370ywe.7.1713513629541; Fri, 19 Apr
 2024 01:00:29 -0700 (PDT)
Date: Fri, 19 Apr 2024 08:59:30 +0100
In-Reply-To: <20240419075941.4085061-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240419075941.4085061-1-tabba@google.com>
X-Mailer: git-send-email 2.44.0.769.g3c40516874-goog
Message-ID: <20240419075941.4085061-21-tabba@google.com>
Subject: [PATCH v3 20/31] KVM: arm64: Clarify rationale for ZCR_EL1 value
 restored on guest exit
From: Fuad Tabba <tabba@google.com>
To: kvmarm@lists.linux.dev
Cc: maz@kernel.org, will@kernel.org, qperret@google.com, tabba@google.com, 
	seanjc@google.com, alexandru.elisei@arm.com, catalin.marinas@arm.com, 
	philmd@linaro.org, james.morse@arm.com, suzuki.poulose@arm.com, 
	oliver.upton@linux.dev, mark.rutland@arm.com, broonie@kernel.org, 
	joey.gouly@arm.com, rananta@google.com, smostafa@google.com
Content-Type: text/plain; charset="UTF-8"

Expand comment clarifying why the host value representing SVE
vector length being restored for ZCR_EL1 on guest exit isn't the
same as it was on guest entry.

Signed-off-by: Fuad Tabba <tabba@google.com>
Reviewed-by: Mark Brown <broonie@kernel.org>
---
 arch/arm64/kvm/fpsimd.c | 24 +++++++++++++++++++++++-
 1 file changed, 23 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/fpsimd.c b/arch/arm64/kvm/fpsimd.c
index 63a6f82934a6..1807d3a79a8a 100644
--- a/arch/arm64/kvm/fpsimd.c
+++ b/arch/arm64/kvm/fpsimd.c
@@ -175,12 +175,34 @@ void kvm_arch_vcpu_put_fp(struct kvm_vcpu *vcpu)
 		if (vcpu_has_sve(vcpu)) {
 			__vcpu_sys_reg(vcpu, ZCR_EL1) = read_sysreg_el1(SYS_ZCR);
 
-			/* Restore the VL that was saved when bound to the CPU */
+			/*
+			 * Restore the VL that was saved when bound to the CPU,
+			 * which is the maximum VL for the guest. Because the
+			 * layout of the data when saving the sve state depends
+			 * on the VL, we need to use a consistent (i.e., the
+			 * maximum) VL.
+			 * Note that this means that at guest exit ZCR_EL1 is
+			 * not necessarily the same as on guest entry.
+			 *
+			 * Restoring the VL isn't needed in VHE mode since
+			 * ZCR_EL2 (accessed via ZCR_EL1) would fulfill the same
+			 * role when doing the save from EL2.
+			 */
 			if (!has_vhe())
 				sve_cond_update_zcr_vq(vcpu_sve_max_vq(vcpu) - 1,
 						       SYS_ZCR_EL1);
 		}
 
+		/*
+		 * Flush (save and invalidate) the fpsimd/sve state so that if
+		 * the host tries to use fpsimd/sve, it's not using stale data
+		 * from the guest.
+		 *
+		 * Flushing the state sets the TIF_FOREIGN_FPSTATE bit for the
+		 * context unconditionally, in both nVHE and VHE. This allows
+		 * the kernel to restore the fpsimd/sve state, including ZCR_EL1
+		 * when needed.
+		 */
 		fpsimd_save_and_flush_cpu_state();
 	} else if (has_vhe() && system_supports_sve()) {
 		/*
-- 
2.44.0.769.g3c40516874-goog

