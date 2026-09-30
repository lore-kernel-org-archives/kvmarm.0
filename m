Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D1994CDDF8;
	Wed, 30 Sep 2026 21:49:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790804950; cv=none; b=MLwJ7FnSMzPkQvrkSV0ohsnG7lwIbYa0KKbHqszLZyoQz04VZ/HVUHiLUf9KGn54YTnMtSnNkNzs0bSS5cSbVTsQT2gyArBr0B/Rl1qB/XZA0zScxJHIWd2lf1JrKNqabEMDclc1k6V2PoJ2WUbpBgmFxZVXlekxuumstquDsY8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790804950; c=relaxed/simple;
	bh=8EKdi1Ug7yuFBXk2To/23syHRc/c4ByaL1DAe9/Ky+E=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=bCZZRyjDKfrVlzTfH8A7W2twW24uzIjK8pNZymlLDX61ZG8ailhByw9DLtlyELHgVnsWIoSDt9WAqseD5PhF3Zzk5qmpKsVZUxWGd8sXlDf+FJ34Nu4y1LoQWu+Kxk/0nhCgFtwHyHMoPd8MdLoU1Q2i58o2AE9pnteeJgMLb0g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NeCMipxc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NeCMipxc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5B0D1F0089A;
	Wed, 30 Sep 2026 21:49:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790804949;
	bh=MQINmNITbwk/CNSnjNxxkSOViUDJsfxpMIuvPsY7vAk=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=NeCMipxcwj6LMsiGcZqIR0a563XhN3JS4r38Ol+Wts9EONy/7E5yQTTnueHeoba7U
	 j89ptbpxprPB2FzoL8/eZJNIEm7C2qJ8XJwYJVCqoXc6ivo1bf3Wu5o7CEfxakUB9Q
	 Qd6RNhlNnL/ORdeEs7x3CtI+8Qc8m28nsr66vSttsFe3UFOY2LoUIZqQQ4WaEB99aM
	 ZNeoqMwX2GAcpBvF5EtYECuvvu2j+1mAJzNBcNQOzz4KGmgO6yGBXzjZI0uw7a9E3A
	 hUGHSPAUIiDpdU8XtlIhXn+KmASrJSuT3XIOkseqkGpmzGMbIEdZS62OaWxiU10AJh
	 d2L6PjeGDLK2Q==
From: Mark Brown <broonie@kernel.org>
Date: Wed, 30 Sep 2026 22:48:14 +0100
Subject: [PATCH v21 04/15] KVM: arm64: Ensure GCS memory effects are
 visible
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260930-arm64-gcs-v21-4-3556644cd927@kernel.org>
References: <20260930-arm64-gcs-v21-0-3556644cd927@kernel.org>
In-Reply-To: <20260930-arm64-gcs-v21-0-3556644cd927@kernel.org>
To: Catalin Marinas <catalin.marinas@arm.com>, 
 Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>, 
 Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
 Shuah Khan <shuah@kernel.org>, Oliver Upton <oupton@kernel.org>, 
 Fuad Tabba <fuad.tabba@linux.dev>
Cc: Peter Maydell <peter.maydell@linaro.org>, 
 Leonardo Bras <leo.bras@arm.com>, Wei-Lin Chang <weilin.chang@arm.com>, 
 Yao Yuan <yaoyuan@linux.alibaba.com>, linux-arm-kernel@lists.infradead.org, 
 linux-doc@vger.kernel.org, kvmarm@lists.linux.dev, 
 linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org, 
 Mark Brown <broonie@kernel.org>, "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
X-Mailer: b4 0.17-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=1978; i=broonie@kernel.org;
 h=from:subject:message-id; bh=8EKdi1Ug7yuFBXk2To/23syHRc/c4ByaL1DAe9/Ky+E=;
 b=owEBbQGS/pANAwAKASTWi3JdVIfQAcsmYgBqvYO2lipkyHOAo94DBt+ulXEk70NYLNaxmaxSl
 7R8oCTkCCmJATMEAAEKAB0WIQSt5miqZ1cYtZ/in+ok1otyXVSH0AUCar2DtgAKCRAk1otyXVSH
 0J3fB/44lYnNfRDOffasRnt5hOdIs89T8XJhvgnEQHSoFjXZrw9IM+hhtpww/uwBZJ0i0IA1IV+
 MG4rLX+1/47Kh5xncPILkT/oiLmyAmOrYDBB6zW7c+YTMhPBKUF46VwkCO7A6duNPyQxW+o3tR/
 i3M1aqDfaOcK59K3IvKp2aOBzgQmVIwhg+k8hRez08dlaTdRSMxS+wJPyzsGPtWa827cbiXlTy6
 0Oc8pV47WgzJmQTGIOIaKLlUSnWLDACXEo06GBjvTY/BOqDaFizcSjRoSxF0KgzQgjvn8B+yjTD
 GmRHEMXpNu2Ibol12loW2NLG1ZbkD9hQ3ewAUP5zfC9k7DxX
X-Developer-Key: i=broonie@kernel.org; a=openpgp;
 fpr=3F2568AAC26998F9E813A1C5C3F436CA30F5D8EB

In order to allow efficient implementation of GCS implementations are
permitted to do GCS specific caching, with barriers implicit in stack
switch operations and GCSB DSYNC as an explicit barrier.  Since we do
not use GCS in the hypervisor or host kernel the hypervisor cannot rely
on any barriers being present in vCPU context switches other than those
it explicitly inserts.  Add explicit barriers when loading and saving
vCPU state.

Reviewed-by: Yuan Yao <yaoyuan@linux.alibaba.com>
Reviewed-by: Leonardo Bras <leo.bras@arm.com>
Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Signed-off-by: Mark Brown <broonie@kernel.org>
---
 arch/arm64/kvm/arm.c               | 7 +++++++
 arch/arm64/kvm/hyp/nvhe/hyp-main.c | 7 +++++++
 2 files changed, 14 insertions(+)

diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 8b080804bc90..52f53f682e6a 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -755,6 +755,13 @@ void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu)
 			vcpu_set_flag(vcpu, PKVM_HOST_STATE_DIRTY);
 	}
 
+	/*
+	 * Ensure any GCS memory effects from the outgoing vCPU are
+	 * visible elsewhere.
+	 */
+	if (kvm_has_gcs(vcpu->kvm))
+		gcsb_dsync();
+
 	kvm_vcpu_put_debug(vcpu);
 	kvm_arch_vcpu_put_fp(vcpu);
 	if (has_vhe())
diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
index 9a3b92e626ad..534db037c5f6 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
@@ -261,6 +261,13 @@ static void sync_hyp_vcpu(struct pkvm_hyp_vcpu *hyp_vcpu)
 	fpsimd_sve_sync(&hyp_vcpu->vcpu);
 	sync_debug_state(hyp_vcpu);
 
+	/*
+	 * Ensure any GCS memory effects from the outgoing vCPU are
+	 * visible elsewhere even if the host skips syncing.
+	 */
+	if (kvm_has_gcs(hyp_vcpu->vcpu.kvm))
+		gcsb_dsync();
+
 	if (pkvm_hyp_vcpu_is_protected(hyp_vcpu)) {
 		host_vcpu->arch.ctxt = hyp_vcpu->vcpu.arch.ctxt;
 	} else {

-- 
2.47.3

