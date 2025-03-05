Received: from out-184.mta1.migadu.com (out-184.mta1.migadu.com [95.215.58.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6AD2207E00
	for <kvmarm@lists.linux.dev>; Wed,  5 Mar 2025 23:08:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.184
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741216121; cv=none; b=u8ekgXP54wRO04rnGkx5NVOaiX5QVCP+ogLRicbiYovuEFM0oS53vOYYH3u462SZqvL4NiDfa3pnqiMbff40N3f8pjbuvv3C3ugDfzv2tKiTaj4x5T9EgnMQD302vStSFk4rFuXVbvMciN6PH6z2QmrTaPSwYK4THgvrLsnD2/I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741216121; c=relaxed/simple;
	bh=+H5TWNPj1YJmUIDHEiN4OeWazNfBBeHPvcDtzY5xLnk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Y/vgV3GmN373yfn32EIzjm5Vv7/GwwyYbyyu+NlwzkVlDP4G4zeWgjB4kdW6T5MsQbrDkolA4mgVpKUY1Nwm9VYhF5LXaJ6n/cShjMRrRzWgbXsCaay3zqClR3VGrRoywlU+Rzq6WS2g5Cfdoxz+R1VuDANZcA67M0Da2SDlm5c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=JlAhpehu; arc=none smtp.client-ip=95.215.58.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="JlAhpehu"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1741216118;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Axh8IaKoIJTHAumsbmK9+b1Ms3I4MS6OLYjPECfMNuk=;
	b=JlAhpehur+PMHt8mckv4Da2O4ti4tT1gc7oMQqojkxUeTcDk5SZCk7yBzuAxRxLC+fn2S1
	3AZONTqhWebPCjwmhLNKkuyx4SUS0nlVbWu79NNj92GIFnunfq7Eu4VYr6rYK/3wR1PhvM
	lGRrC0HkACTrVMTWKF9qWau2eKMZeTQ=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Sebastian Ott <sebott@redhat.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 2/3] KVM: arm64: Copy MIDR_EL1 into hyp VM when it is writable
Date: Wed,  5 Mar 2025 15:08:24 -0800
Message-Id: <20250305230825.484091-3-oliver.upton@linux.dev>
In-Reply-To: <20250305230825.484091-1-oliver.upton@linux.dev>
References: <20250305230825.484091-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

KVM recently added a capability that allows userspace to override the
'implementation ID' registers presented to the VM. MIDR_EL1 is a special
example, where the hypervisor can directly set the value when read from
EL1 using VPIDR_EL2.

Copy the VM-wide value for MIDR_EL1 into the hyp VM for non-protected
guests when the capability is enabled so VPIDR_EL2 gets set up
correctly.

Reported-by: Mark Brown <broonie@kernel.org>
Closes: https://lore.kernel.org/kvmarm/ac594b9c-4bbb-46c8-9391-e7a68ce4de5b@sirena.org.uk/
Fixes: 3adaee783061 ("KVM: arm64: Allow userspace to change the implementation ID registers")
Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/kvm/hyp/nvhe/pkvm.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/arm64/kvm/hyp/nvhe/pkvm.c b/arch/arm64/kvm/hyp/nvhe/pkvm.c
index 2e2975248cd3..afc1b5c403c9 100644
--- a/arch/arm64/kvm/hyp/nvhe/pkvm.c
+++ b/arch/arm64/kvm/hyp/nvhe/pkvm.c
@@ -376,6 +376,9 @@ static void init_pkvm_hyp_vm(struct kvm *host_kvm, struct pkvm_hyp_vm *hyp_vm,
 	hyp_vm->kvm.arch.flags = 0;
 	pkvm_init_features_from_host(hyp_vm, host_kvm);
 	hyp_vm->kvm.arch.ctr_el0 = host_kvm->arch.ctr_el0;
+
+	if (test_bit(KVM_ARCH_FLAG_WRITABLE_IMP_ID_REGS, &hyp_vm->kvm.arch.flags))
+		hyp_vm->kvm.arch.midr_el1 = host_kvm->arch.midr_el1;
 }
 
 static void pkvm_vcpu_init_sve(struct pkvm_hyp_vcpu *hyp_vcpu, struct kvm_vcpu *host_vcpu)
-- 
2.39.5

