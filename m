Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793989922;
	b=c5G/J/C8CKw+EMcaoUOxMlVEUlszEFm59uj0R22xw47zpWzDbwfTH3pGKGafQxzsdeBk
	 wRX53k0yZdQewndeWQXY6BdnkFaNteLwS1Tld3iiwwJGXi8kQDjHY/ofZhXfz4384zl+J
	 DPRgqxNXgnpti7b9K4iqhNEhTyhlgulji9WTbNzlZnZbWQBd2SjkClsP31W1CVTYRAIdC
	 wI16GSMgOaNno/SeCKCmp0VZKO6skxaNNkEkupudGTFhDWfQ5tksm7IDN53Sb9DnHrdXQ
	 7qZ+KS8kyxSsOOzwHhQRv5Hsc8RfdpC3fZRoFBURgP+yMxJ5mgI9hu2VfHv2zQYLTlQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793989922;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=Aov1mH5ZweYjLRKlTFegOjFhQQ4TyRA4Xy8OWGjaupM=;
	b=DV686AXEhd8esTBKOmCNIQjcnEAw9A2bI70DVFq572dN9TAPJYAtfD/TPSPJ+3GMHpFG
	 +If9ewH45AhY8BS6ePEllfs8kdikNnJdFXDjf2aiEAXbcv24YTFHb5YsnSA3q1BazLi38
	 XpwwjS7ZNKYjYBgSnbiJjx4tX/DGu4ypn8hL8YNLA7mz226hrGhBkT4DtR3vFG246RFwA
	 D8CNmrN0qyhPewXOVqB1H6fktUK/5AO0L6DSnczBBGvkj5rwvPTzQoI5aEdEu4RhjEW6L
	 1GhY2n4MKF1DTkT29ZaGszcuz3F2mEjTJ8TKSW4d5mSzZdf8escemDJj19AGQGm0nbQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=aMdE7eB2;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58082606A333
	for <kvmarm@lists.linux.dev>; Fri,  6 Nov 2026 18:32:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=aMdE7eB2
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3C641F008A5;
	Fri,  6 Nov 2026 18:32:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793989921;
	bh=Aov1mH5ZweYjLRKlTFegOjFhQQ4TyRA4Xy8OWGjaupM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aMdE7eB2e27orZppalAfzhDs+8KEEznhyqrB17x6pBwCebMu7ZJr7NsunPukwGT2K
	 FUmFzwI5Ms8xiy5zcgOkaoeSRoQRiec20cTmKoUNRs8lxN+yPNjZkuWDcFYlPARfc4
	 WFuSFSAxNzT3h2oOVIacAEZxI4c+IIyV5EgHLsvbJwqn7lmiRNuYkpXtmVsCNXZoZv
	 iXpYW3pHg3lygZIydf3g5H5JkBp8kvoNJQbzrJJdIvmAP/jANI7PeQOYYEl2UCXhVe
	 jrv/0QW0zhAtLvtSlB4E0qPykQ639X9S26dvzhEJoInN086mFJtUwNnzd6kY4Do7Po
	 Lb1EJC7RXeFcQ==
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
Subject: [PATCH v2 4/8] KVM: arm64: nv: Treat the VNCR GICv3 registers as hidden from user
Date: Fri,  6 Nov 2026 10:31:50 -0800
Message-ID: <20261106183154.3590825-5-oupton@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261106183154.3590825-1-oupton@kernel.org>
References: <20261106183154.3590825-1-oupton@kernel.org>
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

