Received: from out-179.mta1.migadu.com (out-179.mta1.migadu.com [95.215.58.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E9E21B29D2
	for <kvmarm@lists.linux.dev>; Thu, 20 Jun 2024 16:47:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718902037; cv=none; b=XZw4LyKB0SaSqk9JNXUls/DUuyCDuU11GJ2j1H7/4KXOZC17o8agl6a5Wwwrf3RpaNWGKV5LuHRXdtP8Jf99oeL4gVD/V9Ixe1SENeaiaGIkR8KoLra4SFv5/8SCOWekxJhjPIDJaas+yUooQoOlar+55LDGVLNsj+gz/ntqVb8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718902037; c=relaxed/simple;
	bh=IGdiuoRGOLVZqyVbifezCELLTsi1tM/xNN8J4u4u/hU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d530Rgo4MGVDsgylU6jHVXsrvxuJrYj1bTsBZXTu04AAGUVqkU5nrnEqeQMVUbHuqNz6ZvaGJ6p3jeJKANoCXs2TF9OyTY3JmKRHESLwAln7pRi8FTUypJYP7pexHc1rFD2fBeUplZxoWO4s5qiUnw/AemFrMN0M4U2jNDATmq0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=ado6EpIT; arc=none smtp.client-ip=95.215.58.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="ado6EpIT"
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1718902032;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=gvxRT1OHplY0Ss1dvgabPecEDiEzUnsjUcQ/6TWlwjQ=;
	b=ado6EpIT/iosUGrm4uDA6ukqZAZe+WcD6VOhCwnqPYXP/dRA8ryVon7bkiAQKT/QQL6BiJ
	fcGytQXNSVh6NY4rPx8f9NaVstdmSBywxfVSfReCuq/U7oCxfi/50yWygi8IScDI+d9zSX
	nM+a7CDrP1S5tjvYvNxNqUZDnd/B5zQ=
X-Envelope-To: maz@kernel.org
X-Envelope-To: james.morse@arm.com
X-Envelope-To: suzuki.poulose@arm.com
X-Envelope-To: yuzenghui@huawei.com
X-Envelope-To: kvm@vger.kernel.org
X-Envelope-To: tabba@google.com
X-Envelope-To: oliver.upton@linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	kvm@vger.kernel.org,
	Fuad Tabba <tabba@google.com>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH v3 05/15] KVM: arm64: nv: Save guest's ZCR_EL2 when in hyp context
Date: Thu, 20 Jun 2024 16:46:42 +0000
Message-ID: <20240620164653.1130714-6-oliver.upton@linux.dev>
In-Reply-To: <20240620164653.1130714-1-oliver.upton@linux.dev>
References: <20240620164653.1130714-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

When running a guest hypervisor, ZCR_EL2 is an alias for the counterpart
EL1 state.

Reviewed-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/kvm/fpsimd.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/fpsimd.c b/arch/arm64/kvm/fpsimd.c
index 1807d3a79a8a..d948f1c684ca 100644
--- a/arch/arm64/kvm/fpsimd.c
+++ b/arch/arm64/kvm/fpsimd.c
@@ -173,7 +173,13 @@ void kvm_arch_vcpu_put_fp(struct kvm_vcpu *vcpu)
 
 	if (guest_owns_fp_regs()) {
 		if (vcpu_has_sve(vcpu)) {
-			__vcpu_sys_reg(vcpu, ZCR_EL1) = read_sysreg_el1(SYS_ZCR);
+			u64 zcr = read_sysreg_el1(SYS_ZCR);
+
+			/*
+			 * If the vCPU is in the hyp context then ZCR_EL1 is
+			 * loaded with its vEL2 counterpart.
+			 */
+			__vcpu_sys_reg(vcpu, vcpu_sve_zcr_elx(vcpu)) = zcr;
 
 			/*
 			 * Restore the VL that was saved when bound to the CPU,
-- 
2.45.2.741.gdbec12cfda-goog

