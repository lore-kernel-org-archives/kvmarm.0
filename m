Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03CD613C9CA
	for <kvmarm@lists.linux.dev>; Tue, 23 Apr 2024 15:06:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713884768; cv=none; b=aoAiMtQWm1/yVah1fgvxSS4/kcSDH2ftrMX5R+zq6tXszlvS8Xs9PDXzJyJ0HmlfzNnXrVo5ouTyVa6BDzDzJ1dC19iJltkZpPZnceiY4UDf0iwoUEKjDmlAStT+OR1NAFiC5iDRCDtLbg2N7Ad6kJ1nr0Ch9FHJOnF5iwOiFT8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713884768; c=relaxed/simple;
	bh=r5QFVs90Kg6AFbkjwW0d7rsccgSg4hc4eQ8TPEwae70=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=VNwmBTVnNwQatD7U/ziwA7pvhOVLp9p0LoWaKuLG2fTsavJ22DVLPpkmMhM4/lG5QJ3ND0kEQcPjonNY53XBFcYVZ8ubumPOlqkH+OSAHwV6QrlIHiELYGR76c0jnRSPjAwhMrpjsjoAB6MF/l/jgLVZkYc63+RbFY5YNwkdN3k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Q36D8ZFE; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Q36D8ZFE"
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-61b76ab0b46so17434417b3.1
        for <kvmarm@lists.linux.dev>; Tue, 23 Apr 2024 08:06:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1713884766; x=1714489566; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=q5ADkIAuh8U2hKXxsZi+G/6UHISa6V3Lc2BbzZ0c98k=;
        b=Q36D8ZFEYFqwRPR8Nxp0DQlcA/SUWJOVMqqQ83bW+VRQ4WKAYkvcfPlSDFdDfeOo3c
         //Klm6A7TZEC8u8RhOtyWuBA953QJ2BfmfJQMKJCK/YZvahSogfCD686qL5Eg1yDMPrf
         k4jn2ex/dKa2rioh6D4jWjpRbshaF1Fm+jhfet3gNMXFKKSUNx4fRl9WZb/tKhuMSlYM
         YUH3PVD86iWaUcOoeB2SKae66AwUyzNc0Bg8hyA7vKvpfqGT/HYPBVBvbdqrvXoQMf45
         kdFfgw4IoFvOEx4jdfk5WA3qtS3ijF96XL8BQT/G5hZp/VxuQ/TU7KdnFHki8eNne5Q9
         S8Mw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713884766; x=1714489566;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=q5ADkIAuh8U2hKXxsZi+G/6UHISa6V3Lc2BbzZ0c98k=;
        b=wOska2IGYPu3JPJHmVZKfKLZSkVnGQZ0W33OwQ7cZALPpeKn5Rb9AKNcG6IyIaES8Z
         wbCij6jAFvm8pI/THo5SSiZsGe0oGTu3csC7/b6Y6XcJeDnAn44mCvhrEbozAmb4s1hG
         yZp6IAE7UABPX8+AQm+BMITNE6T9LGTIpUkPEgYXWexAaZMNVezXVzngwmH7S0DtY7da
         TGJZt+kDnc9lJ/3zbN5z1OYniJIkmOYa0hpmnLmOcoJDIQvplnEcHrPXiAgGd35Sej2h
         vGwi+FmMOWcUVJgBHqoiGLpIQ6sqNwBstShXLdOgqUgj8SkVMASKLlmqj5aYKfnuZV6S
         S2kQ==
X-Gm-Message-State: AOJu0YxwM75yh/+1HwjR8eOtlbAX6EdtYnBn9roX/wn5RNmOJ5aD8bh3
	qqjN2ykRGGCOaIiu1eu6FR9GYXBo9/OS4P/mXS7aU1ZG4V/eRckNfLPAvrTYY08wq6ixAR6C8Ub
	frJ/Vd0+6Po3kD7bJk8+vHG3OYfNu3ikH/LUav5+9uREEOCjFUNtIsbFIrnG2b68NXij6DaCJUV
	RFpJ3q2+J5/ov7hhty76EKf3IaYC8=
X-Google-Smtp-Source: AGHT+IGd/hG34haAocmx7Zu7PEP7Nm+VmJyiDc5fMb/1IZuZDWjHQBiIZlcb0fCUx4jCoMCO9jIwQSjQUw==
X-Received: from fuad.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1613])
 (user=tabba job=sendgmr) by 2002:a0d:cb57:0:b0:61a:d0d1:1813 with SMTP id
 n84-20020a0dcb57000000b0061ad0d11813mr3159969ywd.2.1713884765921; Tue, 23 Apr
 2024 08:06:05 -0700 (PDT)
Date: Tue, 23 Apr 2024 16:05:19 +0100
In-Reply-To: <20240423150538.2103045-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240423150538.2103045-1-tabba@google.com>
X-Mailer: git-send-email 2.44.0.769.g3c40516874-goog
Message-ID: <20240423150538.2103045-12-tabba@google.com>
Subject: [PATCH v4 11/30] KVM: arm64: Do not map the host fpsimd state to hyp
 in pKVM
From: Fuad Tabba <tabba@google.com>
To: kvmarm@lists.linux.dev
Cc: maz@kernel.org, will@kernel.org, qperret@google.com, tabba@google.com, 
	seanjc@google.com, alexandru.elisei@arm.com, catalin.marinas@arm.com, 
	philmd@linaro.org, james.morse@arm.com, suzuki.poulose@arm.com, 
	oliver.upton@linux.dev, mark.rutland@arm.com, broonie@kernel.org, 
	joey.gouly@arm.com, rananta@google.com, smostafa@google.com
Content-Type: text/plain; charset="UTF-8"

pKVM maintains its own state at EL2 for tracking the host fpsimd
state. Therefore, no need to map and share the host's view with
it.

Signed-off-by: Fuad Tabba <tabba@google.com>
Reviewed-by: Mark Brown <broonie@kernel.org>
---
 arch/arm64/include/asm/kvm_host.h |  3 ---
 arch/arm64/kvm/fpsimd.c           | 31 ++++---------------------------
 arch/arm64/kvm/reset.c            |  1 -
 3 files changed, 4 insertions(+), 31 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index bb831a1bf4cb..3ba2f301462a 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -663,8 +663,6 @@ struct kvm_vcpu_arch {
 	struct kvm_guest_debug_arch vcpu_debug_state;
 	struct kvm_guest_debug_arch external_debug_state;
 
-	struct task_struct *parent_task;
-
 	/* VGIC state */
 	struct vgic_cpu vgic_cpu;
 	struct arch_timer_cpu timer_cpu;
@@ -1267,7 +1265,6 @@ void kvm_arch_vcpu_load_fp(struct kvm_vcpu *vcpu);
 void kvm_arch_vcpu_ctxflush_fp(struct kvm_vcpu *vcpu);
 void kvm_arch_vcpu_ctxsync_fp(struct kvm_vcpu *vcpu);
 void kvm_arch_vcpu_put_fp(struct kvm_vcpu *vcpu);
-void kvm_vcpu_unshare_task_fp(struct kvm_vcpu *vcpu);
 
 static inline bool kvm_pmu_counter_deferred(struct perf_event_attr *attr)
 {
diff --git a/arch/arm64/kvm/fpsimd.c b/arch/arm64/kvm/fpsimd.c
index d5837d65e4a1..63a6f82934a6 100644
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
@@ -38,28 +25,18 @@ void kvm_vcpu_unshare_task_fp(struct kvm_vcpu *vcpu)
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
 	if (ret)
 		return ret;
 
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
index 68d1d05672bd..1b7b58cb121f 100644
--- a/arch/arm64/kvm/reset.c
+++ b/arch/arm64/kvm/reset.c
@@ -151,7 +151,6 @@ void kvm_arm_vcpu_destroy(struct kvm_vcpu *vcpu)
 {
 	void *sve_state = vcpu->arch.sve_state;
 
-	kvm_vcpu_unshare_task_fp(vcpu);
 	kvm_unshare_hyp(vcpu, vcpu + 1);
 	if (sve_state)
 		kvm_unshare_hyp(sve_state, sve_state + vcpu_sve_state_size(vcpu));
-- 
2.44.0.769.g3c40516874-goog

