Received: from out-172.mta0.migadu.com (out-172.mta0.migadu.com [91.218.175.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD6211E47A3
	for <kvmarm@lists.linux.dev>; Tue,  8 Jul 2025 23:06:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752016008; cv=none; b=drzd1F1c5RyezVLMicv98YWcS5vQ8wg8IXl9WN5z0QHOSAAcbuazWwrU6Yle4PWqklq7a2BTqF2IXICn9UDtTEmw2bDtzNOF25H/CmpesWhGEwmZMUv01diYyj9gemLVPpVLO8/NT3ZiNXvIiC/TlPmspXHnJstQ6xAMvqirmFc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752016008; c=relaxed/simple;
	bh=iXCdU78zIrX140yDsXXAv9ZASMSlnkeUkrXTKTgS6v4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=KRdiqPS3DyDxQjISK+0GVt8HXwaNK5hR98eFGIxhdx8aRQVI4AsJGxUfEJPzkUElschQL8VyEjobwf4lvSpwBh8lIbkuWX/dVrJAWky3xXjTUuIwM+Q54d9oiF1Osoqu9PDXS/RxsRJnJoW0aXUvP/jvA4S8VOnGWkmUkFOVQrI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=T1GZCFJl; arc=none smtp.client-ip=91.218.175.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="T1GZCFJl"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1752016003;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=hBF+/2SsdC+OaIRXK0+HqFrv3WzrAel87NavjewIOAA=;
	b=T1GZCFJlEHjnz22XWb8XiNEFZY6EdcC/pLPS0Gs3Up8I25u4VeMJIagGwkAF4vWv145LK6
	owhnROkdHjQ1Wx2Gv5khX1qOEIzMhhLrnZInUaLmGlfWcDxpeWoMoX6wgxx1j73sihCyTg
	d30sZwNvyeCgfrA+5gmqbRr0vJdfj18=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH 1/2] KVM: arm64: Populate ESR_ELx.EC for emulated SError injection
Date: Tue,  8 Jul 2025 16:06:31 -0700
Message-Id: <20250708230632.1954240-2-oliver.upton@linux.dev>
In-Reply-To: <20250708230632.1954240-1-oliver.upton@linux.dev>
References: <20250708230632.1954240-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

The hardware vSError injection mechanism populates ESR_ELx.EC as part of
ESR propagation and the contents of VSESR_EL2 populate the ISS field. Of
course, this means our emulated injection needs to set up the EC
correctly for an SError too.

Fixes: ce66109cec86 ("KVM: arm64: nv: Take "masked" aborts to EL2 when HCRX_EL2.TMEA is set")
Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/kvm/inject_fault.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/arm64/kvm/inject_fault.c b/arch/arm64/kvm/inject_fault.c
index 37f45461e32c..6745f38b64f9 100644
--- a/arch/arm64/kvm/inject_fault.c
+++ b/arch/arm64/kvm/inject_fault.c
@@ -322,9 +322,13 @@ int kvm_inject_serror_esr(struct kvm_vcpu *vcpu, u64 esr)
 	 * the vCPU is in a nested context w/ vSErrors enabled then we've already
 	 * delegated he hardware vSError context (i.e. HCR_EL2.VSE, VSESR_EL2,
 	 * VDISR_EL2) to the guest hypervisor.
+	 *
+	 * As we're emulating the SError injection we need to explicitly populate
+	 * ESR_ELx.EC because hardware will not do it on our behalf.
 	 */
 	if (!serror_is_masked(vcpu)) {
 		pend_serror_exception(vcpu);
+		esr |= FIELD_PREP(ESR_ELx_EC_MASK, ESR_ELx_EC_SERROR);
 		vcpu_write_sys_reg(vcpu, esr, exception_esr_elx(vcpu));
 		return 1;
 	}
-- 
2.39.5

