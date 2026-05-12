Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B47073A83A8;
	Tue, 12 May 2026 14:08:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778594884; cv=none; b=B9Dqd7M4boE/ql6whrYmRDe+xlnPRlL2VM1w2Lt90P2ekJwmG4mzc8AM6r+vzCH93jn3yLCTmbU6XVfrqA6HKE6EC58dWLjcNWZVpBy2CWr87hh5rcwhzWOKrFjbIPcWEUYnRu7aUIgIDslzapJdH9HNie6QimgSM7z6OjC6gT0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778594884; c=relaxed/simple;
	bh=e4PfbEx8jOhpSA8r+WhznHgdIOWa2m/L358uEzzJ8tA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SEfo25HAc2pzc95vDfSzaP2p+89238RbvnSEUtj3y64yzzd5q2cOMsZps+YXKTWloIPkSuHyqWN2E91/lImMYrdBYZ5YSMU5WcwwO/B01x8dJygaM0PGCdUdA6l0lBT7tOyIqYmMIG+Rzx+ttdJ/7+XhyCChGRqHTRAQoAVyvCo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HoRUSFBU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HoRUSFBU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E50AC2BCF5;
	Tue, 12 May 2026 14:08:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778594884;
	bh=e4PfbEx8jOhpSA8r+WhznHgdIOWa2m/L358uEzzJ8tA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HoRUSFBUtJ49xk/SlHh6YvAELuufx8PqujoTufwIGwdAAAgX1BDIlk5oKXkQMrJeT
	 VoaEqMx3Efv2/9hPIi3wNQhVJKmUVZdkKcBRFC1JnEw7G0p7DO2bXsWlHOa5dwLPGb
	 wPj4N2x8uwFLq4ZbWCAHwrgucTIw6IsqLs6ebUc60laebpZH+vmevaPI6Yewl5KALV
	 E6DCEEhi8WkfkfhjDwV4VCXZtcdT2KvzNF2vWBGK/yncJ3/FMay1ihYLAn6VANImVi
	 JQYjByPrLZEf7OcmKbHTGYOLWvAjQ4Uxt279v64k/ARt6KnEOKWawi+BzN6ZZfwOz9
	 prT/hoO1HAjiA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1wMnmE-00000001Zsc-2qlf;
	Tue, 12 May 2026 14:08:02 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Cc: Steffen Eiden <seiden@linux.ibm.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oupton@kernel.org>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Will Deacon <will@kernel.org>,
	Fuad Tabba <tabba@google.com>
Subject: [PATCH 2/2] KVM: arm64: nv: Don't save/restore FP register during a nested ERET or exception
Date: Tue, 12 May 2026 15:07:55 +0100
Message-ID: <20260512140755.3676306-3-maz@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260512140755.3676306-1-maz@kernel.org>
References: <20260512140755.3676306-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, seiden@linux.ibm.com, joey.gouly@arm.com, suzuki.poulose@arm.com, oupton@kernel.org, yuzenghui@huawei.com, mark.rutland@arm.com, will@kernel.org, tabba@google.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

When switching between L1 and L2, we diligently use a non-preemptible
put/load sequence in order to make sure that the old state is saved,
while the new state is brought in. Crucially, this includes the FP
registers.

However, this is a bit silly. The FP registers are completely shared
between the various ELs (just like the GPRs, really), and eagerly
save/restoring those in a non-preemptible section is just overhead.
Not to mention that the next access will end-up trapping, something
that becomes exponentially expensive as we nest deeper.

The temptation is therefore to completely drop this save/restore thing.
Why is it valid to do so? By analogy, the hypervisor doesn't try to
poloce things between EL1 and EL0, or between EL2 and EL0. Why should
it do so between EL2 and EL1 (or EL2 and L2 EL0)?

Once you admit that the FP (and by extension SVE) registers are EL-agnostic,
the things that matter are:

- the trap controls: the effective values are recomputed on each entry
  into the guest to take the EL into account and merge the L0 and L1
  configuration if in a nested context, or directly use the L0 configuration
  in non-nested context (see __activate_traps()).

- the VL settings: the effective values are are also recomputed on each
  entry into the guest (see fpsimd_lazy_switch_to_guest()).

Since we appear to cover all bases, use the vcpu flags indicating the
handling of a nested ERET or exception delivery to avoid the whole FP
save/restore shenanigans.

For an EL1 L3 guest where L1 and L2 have this optimisation, this
results in at least a 10% wall clock reduction when running an I/O
heavy workload, generating a high rate of nested exceptions.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/fpsimd.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/arch/arm64/kvm/fpsimd.c b/arch/arm64/kvm/fpsimd.c
index 15e17aca1dec0..73eda0f46b127 100644
--- a/arch/arm64/kvm/fpsimd.c
+++ b/arch/arm64/kvm/fpsimd.c
@@ -28,6 +28,10 @@ void kvm_arch_vcpu_load_fp(struct kvm_vcpu *vcpu)
 	if (!system_supports_fpsimd())
 		return;
 
+	if (vcpu_get_flag(vcpu, IN_NESTED_ERET) ||
+	    vcpu_get_flag(vcpu, IN_NESTED_EXCEPTION))
+		return;
+
 	/*
 	 * Ensure that any host FPSIMD/SVE/SME state is saved and unbound such
 	 * that the host kernel is responsible for restoring this state upon
@@ -102,6 +106,10 @@ void kvm_arch_vcpu_put_fp(struct kvm_vcpu *vcpu)
 {
 	unsigned long flags;
 
+	if (vcpu_get_flag(vcpu, IN_NESTED_ERET) ||
+	    vcpu_get_flag(vcpu, IN_NESTED_EXCEPTION))
+		return;
+
 	local_irq_save(flags);
 
 	if (guest_owns_fp_regs()) {
-- 
2.47.3

