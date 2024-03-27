Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 101D614D426
	for <kvmarm@lists.linux.dev>; Wed, 27 Mar 2024 17:36:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711560973; cv=none; b=OeUHRlMowDADwAfLwlW8vo1CWNhOzvx8EbNcryTSa1oFNZaa+cQGeii3HxXcQ3j09VykgxsOOw4JWzYe3vldLEfpzEk1OZKWlZQxX5p5BppejBa4OMt0Q+IN5+wB2x2oaXOYr8sA7pjNAu4HE4DFgn4rFoul+FyVTDIZBOFaSh8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711560973; c=relaxed/simple;
	bh=/0/RoTRb+dkbTJ31W8q4sdaozsujOIWIQpqF3sHMH40=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=K1Rof+q8UrtTRUWOxnU5xQ7qLSx8JuPntxGpfSb8ukyLoJdO5iSMh6lM3FfT+V4Bveomq6cMrCEkRnUutVDH5fTlwHFsmYjXlpthCdf8RC8QE8f89hHb3gtii2ZmAXXTBJHXUMVRsvGC0zxZGTb2v6DFjtfpJqa7aIGPaHY+nZ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=PC3YV8AS; arc=none smtp.client-ip=209.85.219.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="PC3YV8AS"
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-dcd1779adbeso52372276.3
        for <kvmarm@lists.linux.dev>; Wed, 27 Mar 2024 10:36:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1711560971; x=1712165771; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=5U9+qB0TfsIP7EkKRhJeqjyegJAWVoxtczNgRiLXIZI=;
        b=PC3YV8AS324YQkrhcghGaNUd7hnDkN082NCqX0S3zfeYoGCscnQLvgaqxIqK2ESYBC
         TAIjaZWjwA2PiYwuDh1U6iXT/Hynrd5R6uOPvNdw5u7KGD23y+Rzl+Ut3ENZYA0Vd6oZ
         j3B5ID2Nu1K2uuELYTIGk+aIpI66k5y+nxR8jVSTadnwRZKbg+MKS1EeQv9mKxS1aqfu
         v8soNmGkuAVBd2+hOiyRuspWE3251yanYMRD3xhKqd21Ya9LbbKVBmT87kO/4Ci22H6y
         moXdM3eAaOI2B7D5kTCeY8y55S7MmyB3TK5z8rIVV9/3Wjewm8tTmkzD2Cp1d8IMJaH+
         Xf0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711560971; x=1712165771;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=5U9+qB0TfsIP7EkKRhJeqjyegJAWVoxtczNgRiLXIZI=;
        b=QOxrKtnjidqUueeTTwxqJVoygRYNgehe0AOxomztZ2MMAYqqHKDQBVd7oRlgLIewuD
         OWaPxK9Wzgxq6vWMbDKwKrNmFV3Birx1crqlzqc/+KQJ25T9VbAOJkwvvWPr2RQBG00l
         kwfUJ1EodatMSRGH2d5sYwWm0/BOaZjPPRMl99/aN3mkRzemz+ZDWMB+bM+GDeO2zR+T
         yEcP6uCn6RTvM29hva3u/IMC2Qx+L94Z2Nc7bIv6MwO05rl/hUjfvKV0lmp8MhPa7CEy
         CjSoWeYoTFalwvozM28bnp04nDGcve0klXvwuJoHevKuqzMZFHlZGuKdPPjaMR6PjdUn
         jztQ==
X-Gm-Message-State: AOJu0Yyxeot7vIv/1iGcDHg75AMps/2gYG/xPwnAFEyZ/D59Qouhdu0Y
	/mEaBSP1dWcXJW6tAwLhTNGDS4rrvDrZn5F8cztooSKA8cOZQ3oeE+sTDZb5gatT2R1iLCQB5Wb
	v6lrQUolKdVmcirOpaibomqsu6XfTAyuA1aEJzaAEik+lMXb7E9Ig7tmM61FEZqBx4Jim4Dtxhd
	2BdJnppwcBSYnaKbMxQHZ0nqj9rck=
X-Google-Smtp-Source: AGHT+IGLDsG4L68F9j0n9RG93bJPZyIks8jv18dkgSFRv2jv2JRSYXr1wZY8PMWb0HItfMMejOGeNM8kGg==
X-Received: from fuad.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1613])
 (user=tabba job=sendgmr) by 2002:a05:6902:1009:b0:dc6:ff2b:7e1b with SMTP id
 w9-20020a056902100900b00dc6ff2b7e1bmr158255ybt.4.1711560970993; Wed, 27 Mar
 2024 10:36:10 -0700 (PDT)
Date: Wed, 27 Mar 2024 17:35:03 +0000
In-Reply-To: <20240327173531.1379685-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240327173531.1379685-1-tabba@google.com>
X-Mailer: git-send-email 2.44.0.478.gd926399ef9-goog
Message-ID: <20240327173531.1379685-17-tabba@google.com>
Subject: [PATCH v1 16/44] KVM: arm64: Do not map the host fpsimd state to hyp
 in pKVM
From: Fuad Tabba <tabba@google.com>
To: kvmarm@lists.linux.dev
Cc: maz@kernel.org, will@kernel.org, qperret@google.com, tabba@google.com, 
	seanjc@google.com, alexandru.elisei@arm.com, catalin.marinas@arm.com, 
	philmd@linaro.org, james.morse@arm.com, suzuki.poulose@arm.com, 
	oliver.upton@linux.dev, mark.rutland@arm.com, broonie@kernel.org, 
	joey.gouly@arm.com, rananta@google.com
Content-Type: text/plain; charset="UTF-8"

pKVM maintains its own state for tracking the host fpsimd state.
Therefore, no need to map and share the host's view with it.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/include/asm/kvm_host.h |  2 --
 arch/arm64/kvm/fpsimd.c           | 31 ++++---------------------------
 arch/arm64/kvm/reset.c            |  1 -
 3 files changed, 4 insertions(+), 30 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 3d12fc2aeb9e..cdbbfa3246c1 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -642,7 +642,6 @@ struct kvm_vcpu_arch {
 	struct kvm_guest_debug_arch external_debug_state;
 
 	struct user_fpsimd_state *host_fpsimd_state;	/* hyp VA */
-	struct task_struct *parent_task;
 
 	struct {
 		/* {Break,watch}point registers */
@@ -1214,7 +1213,6 @@ void kvm_arch_vcpu_load_fp(struct kvm_vcpu *vcpu);
 void kvm_arch_vcpu_ctxflush_fp(struct kvm_vcpu *vcpu);
 void kvm_arch_vcpu_ctxsync_fp(struct kvm_vcpu *vcpu);
 void kvm_arch_vcpu_put_fp(struct kvm_vcpu *vcpu);
-void kvm_vcpu_unshare_task_fp(struct kvm_vcpu *vcpu);
 
 static inline bool kvm_pmu_counter_deferred(struct perf_event_attr *attr)
 {
diff --git a/arch/arm64/kvm/fpsimd.c b/arch/arm64/kvm/fpsimd.c
index f297e89e4810..e3d9ec4ab9d0 100644
--- a/arch/arm64/kvm/fpsimd.c
+++ b/arch/arm64/kvm/fpsimd.c
@@ -14,19 +14,6 @@
 #include <asm/kvm_mmu.h>
 #include <asm/sysreg.h>
 
-void kvm_vcpu_unshare_task_fp(struct kvm_vcpu *vcpu)
-{
-	struct task_struct *p = vcpu->arch.parent_task;
-	struct user_fpsimd_state *fpsimd;
-
-	if (!is_protected_kvm_enabled() || !p)
-		return;
-
-	fpsimd = &p->thread.uw.fpsimd_state;
-	kvm_unshare_hyp(fpsimd, fpsimd + 1);
-	put_task_struct(p);
-}
-
 /*
  * Called on entry to KVM_RUN unless this vcpu previously ran at least
  * once and the most recent prior KVM_RUN for this vcpu was called from
@@ -38,11 +25,12 @@ void kvm_vcpu_unshare_task_fp(struct kvm_vcpu *vcpu)
  */
 int kvm_arch_vcpu_run_map_fp(struct kvm_vcpu *vcpu)
 {
-	int ret;
-
 	struct user_fpsimd_state *fpsimd = &current->thread.uw.fpsimd_state;
+	int ret;
 
-	kvm_vcpu_unshare_task_fp(vcpu);
+	/* pKVM has its own tracking of the host fpsimd state. */
+	if (is_protected_kvm_enabled())
+		return 0;
 
 	/* Make sure the host task fpsimd state is visible to hyp: */
 	ret = kvm_share_hyp(fpsimd, fpsimd + 1);
@@ -51,17 +39,6 @@ int kvm_arch_vcpu_run_map_fp(struct kvm_vcpu *vcpu)
 
 	vcpu->arch.host_fpsimd_state = kern_hyp_va(fpsimd);
 
-	/*
-	 * We need to keep current's task_struct pinned until its data has been
-	 * unshared with the hypervisor to make sure it is not re-used by the
-	 * kernel and donated to someone else while already shared -- see
-	 * kvm_vcpu_unshare_task_fp() for the matching put_task_struct().
-	 */
-	if (is_protected_kvm_enabled()) {
-		get_task_struct(current);
-		vcpu->arch.parent_task = current;
-	}
-
 	return 0;
 }
 
diff --git a/arch/arm64/kvm/reset.c b/arch/arm64/kvm/reset.c
index 29ae68f60bef..3d8064bf67c8 100644
--- a/arch/arm64/kvm/reset.c
+++ b/arch/arm64/kvm/reset.c
@@ -139,7 +139,6 @@ void kvm_arm_vcpu_destroy(struct kvm_vcpu *vcpu)
 {
 	void *sve_state = vcpu->arch.sve_state;
 
-	kvm_vcpu_unshare_task_fp(vcpu);
 	kvm_unshare_hyp(vcpu, vcpu + 1);
 	if (sve_state)
 		kvm_unshare_hyp(sve_state, sve_state + vcpu_sve_state_size(vcpu));
-- 
2.44.0.478.gd926399ef9-goog

