Received: from mail-wr1-f73.google.com (mail-wr1-f73.google.com [209.85.221.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA73A85929
	for <kvmarm@lists.linux.dev>; Tue, 16 Apr 2024 09:57:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713261445; cv=none; b=LBaHe961L0NBAMsZGAZ/m5QZ6lbbxrP3j76uXGv3PngU4B7jWAT5suIP/XasEtGKzHKoKbES8th1i1FAdbjLlS59GtmhLYNxNCWw83xuTv6RyB9G71g+eSIcKoBhtxzaKyOkgzAJgfKNtLrM1M1tIhzqpRDXljVeaezCqJuVRmc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713261445; c=relaxed/simple;
	bh=uPgLgTaapD55PWuOwaKx5YVUzvZyzy0+mesSP7AZhRM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=lC53AwbXTW2wgDQCGIzBnCC+i/4u6zlWgEI7ckb7DFJWxHe7n+bazXIxNW7X3hELNIEfvRx8os9Hmk0Y5ZujdIdH26qp4U2yKNb8MBeMIqkHpQCXHMeARj1bSIp/R2expS8TLzvuGDFrxyQw5GKoLLXdgC/Ypl+nZ9emIc4YuL4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=qL1Xb396; arc=none smtp.client-ip=209.85.221.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="qL1Xb396"
Received: by mail-wr1-f73.google.com with SMTP id ffacd0b85a97d-343bb240f70so2707843f8f.1
        for <kvmarm@lists.linux.dev>; Tue, 16 Apr 2024 02:57:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1713261442; x=1713866242; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=ROgE0JlT/QyHUtEJW/bJmZakeWq4h9AMaqCBZS7Aw1Y=;
        b=qL1Xb3969MCyNsvPjDEMXMhVm/z4ikPECfOSVdWhxBBYfnwuMQf99SSMNzz/ANIIIv
         zs50ThUNUIITQuNhmUVD+D+EovGFsNzxUgSIkkPO2FM8CD8VgwRaniR5kue0kKzm4XXu
         Q7yphUSkJYa4j1UKCBeAyj7ul4m0D4wLSEGfuTL7kxdYsjaPei9nkCpT8obdSW9h4Ax1
         sSvwzLGobm8h6FDpdVorN2YcIA3lV1x4lc6fyHleIcX28BBd97V+71oH12d5EmvqHlO3
         EMpo/oFLMTGgId+epCX2RDoQzIBCyp6v3O2Zqa09hriEOzoP35JW8feO8AFEbP4XiV5Q
         jK+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713261442; x=1713866242;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ROgE0JlT/QyHUtEJW/bJmZakeWq4h9AMaqCBZS7Aw1Y=;
        b=k2SE+TeZKBazfsyO580yxkWv4OkjOZiELIlEh2+ns2wt/lnOANInhu24NFc5I1yfzV
         jYgnagPNL6G9PJJbzmZPIOgSpTL+pfAy2dF2+UPJoPAcffbmZht0DNQtobLPu+l3dd3W
         u7Y4ozbsSXhAne7CjyEbFiFD44q2HROKbtCFYmX/VywVeFfRwcYQzgIFbeVCuc4NSmCl
         X3Spg2r9A4g3/+R1QGLszSc31zbBGEHt74MQVcGICu21abIVrrYDbnBNuZoL5MR/3dnT
         GmL1A7ZOmUOP95GU/gLcF/BabHvs9+Q29E/7MdJL5frXK/umBDcDeWpFQr6+GPyxwYIL
         n6yA==
X-Gm-Message-State: AOJu0Yy7HlwzFghNn/pmANP2xheRipM+DTielDKlu6vo7a6rk1uK/tnM
	SJy3v3blLXQD30RCW5ZnE2hxxY3qkOyAKseHmIA9iisO6wAOt9C6ThvK8M4VaRI8XUbaGc8RYP+
	FOIAteyZnM2sernkITVWpHDYtNgaaFYwhetxFhM6XpuKKF83lYYVvTscl+0p63H6pA4yOvwfCmT
	C8KQ6cJJddwNpHjHfCOKqvNaabCd4=
X-Google-Smtp-Source: AGHT+IFhZVttPDd8/sCXkVW/WnFZ0oWAhzML69PFNQDJRdUir7aQ5rLEM7PfW/81BwiBq4L/bHi52Ff+7Q==
X-Received: from fuad.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1613])
 (user=tabba job=sendgmr) by 2002:adf:ce0c:0:b0:345:ef05:39d8 with SMTP id
 p12-20020adfce0c000000b00345ef0539d8mr4701wrn.2.1713261441869; Tue, 16 Apr
 2024 02:57:21 -0700 (PDT)
Date: Tue, 16 Apr 2024 10:56:09 +0100
In-Reply-To: <20240416095638.3620345-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240416095638.3620345-1-tabba@google.com>
X-Mailer: git-send-email 2.44.0.683.g7961c838ac-goog
Message-ID: <20240416095638.3620345-19-tabba@google.com>
Subject: [PATCH v2 18/47] KVM: arm64: Do not map the host fpsimd state to hyp
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
state.  Therefore, no need to map and share the host's view with
it.

Signed-off-by: Fuad Tabba <tabba@google.com>
Reviewed-by: Mark Brown <broonie@kernel.org>
---
 arch/arm64/include/asm/kvm_host.h |  2 --
 arch/arm64/kvm/fpsimd.c           | 31 ++++---------------------------
 arch/arm64/kvm/reset.c            |  1 -
 3 files changed, 4 insertions(+), 30 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 39025b8af6de..9c4bed737d35 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -664,7 +664,6 @@ struct kvm_vcpu_arch {
 	struct kvm_guest_debug_arch vcpu_debug_state;
 	struct kvm_guest_debug_arch external_debug_state;
 
-	struct task_struct *parent_task;
 
 	/* VGIC state */
 	struct vgic_cpu vgic_cpu;
@@ -1253,7 +1252,6 @@ void kvm_arch_vcpu_load_fp(struct kvm_vcpu *vcpu);
 void kvm_arch_vcpu_ctxflush_fp(struct kvm_vcpu *vcpu);
 void kvm_arch_vcpu_ctxsync_fp(struct kvm_vcpu *vcpu);
 void kvm_arch_vcpu_put_fp(struct kvm_vcpu *vcpu);
-void kvm_vcpu_unshare_task_fp(struct kvm_vcpu *vcpu);
 
 static inline bool kvm_pmu_counter_deferred(struct perf_event_attr *attr)
 {
diff --git a/arch/arm64/kvm/fpsimd.c b/arch/arm64/kvm/fpsimd.c
index b78b87a120c5..51a1b18858b3 100644
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
2.44.0.683.g7961c838ac-goog

