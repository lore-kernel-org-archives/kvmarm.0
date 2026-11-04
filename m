Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793820088;
	b=bEBOWMUSNr3vs4hml+ykKIjAiDcoy4htI8t/s8UG7VOHdLL/ZPGj6CTMlkJOIDGzR6Sx
	 CFRDSkvNsHbom/0QjocLXtO6w6CqlLcoMBXBPrsLtXVT6z5XclrAcktsasTMOIDYvsnBv
	 e2zUwhpdhTAK62DqeXQaYwAE0Op0fTZmPYSGzuBg54AGf7F07YADf6BQU0M1yd30HETnQ
	 yxIQOi6WKvxDOVN/DW0hCMGlQg1H94cA7G5+kAeBpFA+tfXQjUgOW2s9FnEnC6sm9Ch5v
	 KwgOSAGW4yupNFc3j5Wsxa4koFy45lVY3fYRPizDj0mkaboJPnf9LgRyVQGjf5Mw5Vg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793820088;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=Aov1mH5ZweYjLRKlTFegOjFhQQ4TyRA4Xy8OWGjaupM=;
	b=MgirCYJmPJSzgkgaNuOfIASFHn/+mQIcMJ5uNNuXDh7lksuQZa2HM3IGJvH0cvv94A41
	 GIoDiqPDN9Oo453IE+TggFOtPy5w2osR/OQzUH02QSuku6aoZW4DMiPEBjIx6vdcDCL+i
	 LIwkmJf6Jf9SIre1jtsFTn+T6OHtL1CIm00CMLNSvAb6nZsVHL+KQGN2UnaN/jncj4tgx
	 AFOumEtIWyJyZHrpfchP7OPPJ751CGScotAnhidh5u6GWp3T3vZs9ZoG2Gwktr1GWqwRE
	 qPANEXkl/11F6dt00wK/yd9o4Q2RjGQDLT1lu5ZiBzAFy67sJ1hVXDehMFoOcxeecFA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Esb97uYN;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA20D606AB34
	for <kvmarm@lists.linux.dev>; Wed,  4 Nov 2026 19:21:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Esb97uYN
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CFA71F00A02;
	Wed,  4 Nov 2026 19:21:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793820087;
	bh=Aov1mH5ZweYjLRKlTFegOjFhQQ4TyRA4Xy8OWGjaupM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Esb97uYNIei8OA8OYGczbw5/ZNkVAEuNuwzHIMyOUt0xh4ccA2ejcwlajATX61dEU
	 6ESL9TF9W3j/ho7BoKt0dF2K4jDOh5eBKQ2AdB/HWlgOLzDNveh3Usv9zGDQiqnTfY
	 b2Jgsd4lq9LEkz0Tc+4IWJQXh+MJNHsNHm8Pd4eqonuM8j0GGaiQ6gUxRL96rXe0Ow
	 v6RN9UV+MYW2Y7JV2t0231isyL+/4igz5lEA0Aq0/L3lTAZlDhNIqtumAr6WAflH4v
	 bgHk6E4PzqszySZCrC0mMrpT56fwyp4/PakGtINiEkB8ixt0mibl+yCGwpRuThN7pN
	 CMcI2j1r43yAQ==
From: Oliver Upton <oupton@kernel.org>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Wei-Lin Chang <weilin.chang@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Fuad Tabba <fuad.tabba@linux.dev>,
	Oliver Upton <oupton@kernel.org>
Subject: [PATCH 4/8] KVM: arm64: nv: Treat the VNCR GICv3 registers as hidden from user
Date: Wed,  4 Nov 2026 11:21:20 -0800
Message-ID: <20261104192124.3932743-5-oupton@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261104192124.3932743-1-oupton@kernel.org>
References: <20261104192124.3932743-1-oupton@kernel.org>
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

KVM's emulation of sysreg traps will soon need to evaluate the
visibility of a sysreg prior to the effects of the L1 hypervisor's traps
to cope with instructions that intersect with a CGT but lack a
corresponding FGU bit (I know, not enough TLAs).

The VNCR GICv3 registers are marked as hidden from both user/guest on
the basis that KVM never handles these traps locally and unconditinally
relies on VNCR redirection. But an L1 hypervisor could trap these.

Remap the visibility as being specific to user accesses, giving the
indication that guest accesses to the sysreg are legal at least from an
architecture POV. Note that the guest side of the visibility was a bit
belt-and-braces as the bad_vncr_trap() accessor will act as a backstop
against any unexpected local trap handling.

Signed-off-by: Oliver Upton <oupton@kernel.org>
---
 arch/arm64/kvm/sys_regs.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 870dcb25d0d7..0b21b454242c 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -1020,10 +1020,10 @@ static u64 reset_mpidr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r)
 	return mpidr;
 }
 
-static unsigned int hidden_visibility(const struct kvm_vcpu *vcpu,
-				      const struct sys_reg_desc *r)
+static unsigned int hidden_user_visibility(const struct kvm_vcpu *vcpu,
+					   const struct sys_reg_desc *r)
 {
-	return REG_HIDDEN;
+	return REG_USER_HIDDEN;
 }
 
 static unsigned int pmu_visibility(const struct kvm_vcpu *vcpu,
@@ -2757,7 +2757,7 @@ static bool bad_redir_trap(struct kvm_vcpu *vcpu,
 #define EL2_REG_VNCR_FILT(name, vis)			\
 	EL2_REG_FILTERED(name, bad_vncr_trap, reset_val, 0, vis)
 #define EL2_REG_VNCR_GICv3(name)			\
-	EL2_REG_VNCR_FILT(name, hidden_visibility)
+	EL2_REG_VNCR_FILT(name, hidden_user_visibility)
 #define EL2_REG_REDIR(name, rst, v)	EL2_REG(name, bad_redir_trap, rst, v)
 
 #define TIMER_REG(name, vis)					   \
-- 
2.47.3

