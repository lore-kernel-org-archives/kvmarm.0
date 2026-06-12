Received: from mail-oi1-f202.google.com (mail-oi1-f202.google.com [209.85.167.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC9513B841F
	for <kvmarm@lists.linux.dev>; Fri, 12 Jun 2026 19:29:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781292565; cv=none; b=pGo/CDm3KFL+kg0w+vKY2u+NNKcFxOeu5DYfRJ8VBqBQ+g3PVPXRj2R4yR250ykHkpWlXzBqflz8m4LfwDeFkr1HTUtLhgoYZlriGm/sJGCTZtvYR7bIpU6YlQi3CE8jRucamYK5Cwr9OPUVPwh9rJma6ezQSudIlJKQvdGtdjI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781292565; c=relaxed/simple;
	bh=ZG9ZKKsG5def4qAkO71pmX+aMwBP6QL7ujSsyD5d3oQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=MCz0pU7gKGUndwOYOA/PRvk09ejFazq4bXx5qyV+2ehxp2RrHW69fDLB8OgngXKdDasRI4IMz1VX4ocJZkbzkUMhH7fKYNCmgK0xgsU97CNotmzpLmBqqT3GbubmwbcgzfnM8bk4DBl/tpcCJL6B6mUGBP5nkJK1HTyyozzg54c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=OvtBcmfW; arc=none smtp.client-ip=209.85.167.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="OvtBcmfW"
Received: by mail-oi1-f202.google.com with SMTP id 5614622812f47-48638da0e05so1169362b6e.3
        for <kvmarm@lists.linux.dev>; Fri, 12 Jun 2026 12:29:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1781292559; x=1781897359; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=zUfvJDWatpVt+iiRM4HzP8H2jLIkMlFqueFXiDB4Pis=;
        b=OvtBcmfW9IKVBqsOqXy+J0YDOHKF6rtYEhGOKvfeYv1zGLhrK/POn6HuN0ZnVYISbc
         eaJ29sp2Fasao/WZnF3jd9B/NejjXLr75xeJLi9ENBrpSQa1dwnztSnnh28H+qf1eXV4
         PhWCmipWTKzcEJo/Iy6uQsNTnco/Q3jMDZLt4u1Hk6t9gYGYGJWqtCTdj8GvbsFVf4rl
         BdL/pfdJj+a/fB3nc3q6IHt6MNu/++4Zr1yUjU20e9XAgX/4B+FvlFPhMYFRzptTdzxW
         Rzc2WYsANpjVuMqsczXjLog872thxZ50AOixQNjj0Y4/2oJojUNc6N61W3HzRQF8yeTT
         0cJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781292559; x=1781897359;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=zUfvJDWatpVt+iiRM4HzP8H2jLIkMlFqueFXiDB4Pis=;
        b=KrT2cZs8xeXFoW3XW7mKhiSJY9T91nFkqH5rd8jnbiBuK1dwfYd0jDVzDTuhrA9l4S
         0WtYJYAO2+SmBIGI3zSN/71v+7TGPK7wvkN2v0e8wGlFmt5UW1vwcZOPVF9iiczoQUeq
         j6cjRBXJTMQnvsJ0T78gDl0VNnCPn1lgQPnNse5B82jfHb18OOUY6ICDbD6U/UVH7cFh
         KzQ1y92PAZFonxHmtOC60rL367ZFyXsXL06SCtguaoJw7myOCRXnQ/oOsSLiB+QUXKMy
         c2MgiOSSXoWj+Hs00KX4jlmNLnkRddZ68d5dy7usIPl+EUFTsorRy1gRRidVv88QmNBM
         k7Cw==
X-Forwarded-Encrypted: i=1; AFNElJ8tvqm8SL1xduoqMYP9HlLpierLm57V/aN7/mzE49unzOt6PKN4vND1+dUQ6IDUptQw4Lakxf8=@lists.linux.dev
X-Gm-Message-State: AOJu0Yxc/BPwpH9Fe/h2GUvNu4Cmx3512qMzluDsFS1akJqSbe8eLgXE
	LZ0vx+pLEfgp7FdlUltetl8QeocfsmcJ3UYmIHo80BJUYdHRtDatsa98OS1Yt+w9Rf3m+zhXAbf
	LQdzMZFiYqPPg19GFTsB/LXzT+Q==
X-Received: from jabjq11.prod.google.com ([2002:a05:6638:8d8b:b0:5e2:7e1d:1f79])
 (user=coltonlewis job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6808:1790:b0:47b:bd7b:10e5 with SMTP id 5614622812f47-4872f35387fmr2525333b6e.3.1781292559384;
 Fri, 12 Jun 2026 12:29:19 -0700 (PDT)
Date: Fri, 12 Jun 2026 19:28:58 +0000
In-Reply-To: <20260612192909.1153907-1-coltonlewis@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260612192909.1153907-1-coltonlewis@google.com>
X-Mailer: git-send-email 2.54.0.1136.gdb2ca164c4-goog
Message-ID: <20260612192909.1153907-11-coltonlewis@google.com>
Subject: [PATCH 10/21] KVM: arm64: Set up MDCR_EL2 to handle a Partitioned PMU
From: Colton Lewis <coltonlewis@google.com>
To: kvm@vger.kernel.org
Cc: Alexandru Elisei <alexandru.elisei@arm.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Jonathan Corbet <corbet@lwn.net>, Russell King <linux@armlinux.org.uk>, 
	Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Mingwei Zhang <mizhang@google.com>, 
	Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Mark Rutland <mark.rutland@arm.com>, 
	Shuah Khan <shuah@kernel.org>, Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>, 
	James Clark <james.clark@linaro.org>, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, linux-perf-users@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, Colton Lewis <coltonlewis@google.com>
Content-Type: text/plain; charset="UTF-8"

Set up MDCR_EL2 to handle a Partitioned PMU. If partitioned, set the
HPME, HPMD, and HCCD bits. If we have the ability to use Fine Grain
Traps (FEAT_FGT) also, unset the TPM and TPMCR bits that trap all PMU
accesses and set HPMN to the correct number of guest counters so
hardware enforces the right values.

Signed-off-by: Colton Lewis <coltonlewis@google.com>
---
 arch/arm64/kvm/debug.c | 27 ++++++++++++++++++++++++---
 arch/arm64/kvm/pmu.c   |  7 +++++++
 2 files changed, 31 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/kvm/debug.c b/arch/arm64/kvm/debug.c
index f4d7b12045e8f..c84321277d893 100644
--- a/arch/arm64/kvm/debug.c
+++ b/arch/arm64/kvm/debug.c
@@ -43,14 +43,35 @@ static void kvm_arm_setup_mdcr_el2(struct kvm_vcpu *vcpu)
 	 * This also clears MDCR_EL2_E2PB_MASK and MDCR_EL2_E2TB_MASK
 	 * to disable guest access to the profiling and trace buffers
 	 */
-	vcpu->arch.mdcr_el2 = FIELD_PREP(MDCR_EL2_HPMN,
-					 *host_data_ptr(nr_event_counters));
+
+	vcpu->arch.mdcr_el2 = FIELD_PREP(MDCR_EL2_HPMN, *host_data_ptr(nr_event_counters));
 	vcpu->arch.mdcr_el2 |= (MDCR_EL2_TPM |
 				MDCR_EL2_TPMS |
 				MDCR_EL2_TTRF |
 				MDCR_EL2_TPMCR |
 				MDCR_EL2_TDRA |
-				MDCR_EL2_TDOSA);
+				MDCR_EL2_TDOSA |
+				MDCR_EL2_HPME);
+
+	if (kvm_pmu_is_partitioned(vcpu->kvm)) {
+		u8 nr_guest_cntr = vcpu->kvm->arch.nr_pmu_counters;
+
+		vcpu->arch.mdcr_el2 |= (MDCR_EL2_HPMD | MDCR_EL2_HCCD);
+
+		/*
+		 * Take out the coarse grain traps if we are using
+		 * fine grain traps and enforce counter access with
+		 * HPMN.
+		 */
+		if (!vcpu_on_unsupported_cpu(vcpu) &&
+		    cpus_have_final_cap(ARM64_HAS_FGT) &&
+		    (cpus_have_final_cap(ARM64_HAS_HPMN0) || nr_guest_cntr > 0)) {
+			vcpu->arch.mdcr_el2 &= ~(MDCR_EL2_TPM | MDCR_EL2_TPMCR | MDCR_EL2_HPMN);
+			vcpu->arch.mdcr_el2 |= FIELD_PREP(MDCR_EL2_HPMN, nr_guest_cntr);
+		}
+
+
+	}
 
 	/* Is the VM being debugged by userspace? */
 	if (vcpu->guest_debug)
diff --git a/arch/arm64/kvm/pmu.c b/arch/arm64/kvm/pmu.c
index 9ad3520417413..55cda8021400a 100644
--- a/arch/arm64/kvm/pmu.c
+++ b/arch/arm64/kvm/pmu.c
@@ -552,6 +552,13 @@ u8 kvm_arm_pmu_get_max_counters(struct kvm *kvm)
 	if (cpus_have_final_cap(ARM64_WORKAROUND_PMUV3_IMPDEF_TRAPS))
 		return 1;
 
+	/*
+	 * If partitioned then we are limited by the max counters in
+	 * the guest partition.
+	 */
+	if (pmu_is_partitioned(arm_pmu))
+		return arm_pmu->max_guest_counters;
+
 	/*
 	 * The arm_pmu->cntr_mask considers the fixed counter(s) as well.
 	 * Ignore those and return only the general-purpose counters.
-- 
2.54.0.1136.gdb2ca164c4-goog

