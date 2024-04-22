Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F4CB1401C
	for <kvmarm@lists.linux.dev>; Mon, 22 Apr 2024 22:48:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713826140; cv=none; b=Btop3Mld+P/WrXUHwD8shkw0xPkVhjcuEssoaXI/KMm/EkMl5vtIFOTiwTOEyp3PyBCGqf0HUfhgKWYWXjwUrSnp453HiRZBugpkhejx7WraMO+BAld6WMykn2qiBelkZjPG0Dq3Pf3SjD2VvtgmhP0ZAl0GyO0ykefxkj9LnMI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713826140; c=relaxed/simple;
	bh=fm2a+0xycqqxT06+SBw2+4DgyIhfefjKQ/8uOfWuuLg=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=Xzo0DOBMmOoO3MFehG9mcIKUPC3rds50pSwZTCZENelo3M0HAv96nb7oMsBAJHsfeBRaBAfRpGLz+v72mcY8nrvohiwm6Sy0R5wG+e0FlRcvqZshrKF2rwHQvQAr52mQMfJuI7WHUEhLsOXbGdtJpyHD/M2cJpjd0r1JRCXGIj4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WSUQWyv+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WSUQWyv+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76A74C113CC;
	Mon, 22 Apr 2024 22:48:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713826139;
	bh=fm2a+0xycqqxT06+SBw2+4DgyIhfefjKQ/8uOfWuuLg=;
	h=From:To:Cc:Subject:Date:From;
	b=WSUQWyv+Cu5v8pGzEk7LzEBVlG4c2pdAWwXAgfD+OEe8qB35toLs5QlAD+KGXau6F
	 NeqYcDy1q8YROd7l0SwHCKsRQNoRiwKR92/N2PbXoM1nlDvI2N3RCZ1SVYay8F5ol5
	 8eiDROQAKbmSZhrMmleQejBjJuUjJNJzWKq+67KhKxlvgNkaZXxNUecxW5M1/D0Hhd
	 owSOjGZSjpY+S9WOF9HPL40lKkkUEY+5T8RO8k/TWg27F+2e9fev6Y09FZtN4iB383
	 /3i6PSBc4ig046mTwUbMwmMFS+1+ixVAil288NqH8j/Cx0SFlJTUkOHeStrhl1ZEX0
	 pWD8y76NF9ttA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1rz2T2-006xt0-QU;
	Mon, 22 Apr 2024 23:48:56 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org
Cc: James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Mark Rutland <mark.rutland@arm.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Will Deacon <will@kernel.org>,
	Naresh Kamboju <naresh.kamboju@linaro.org>,
	Linaro Kernel Functional Testing <lkft@linaro.org>
Subject: [PATCH] KVM: arm64: nv: Work around lack of pauth support in old toolchains
Date: Mon, 22 Apr 2024 23:48:49 +0100
Message-Id: <20240422224849.2238222-1-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, arnd@arndb.de, mark.rutland@arm.com, joey.gouly@arm.com, will@kernel.org, naresh.kamboju@linaro.org, lkft@linaro.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

We still support GCC 8.x, and it appears that this toolchain
does not understand "pauth" as a valid architectural extension.
After all, it's only been 8 years since ARMv8.3 was released...

This results in the NV ERETAx code breaking the build, as it relies
on this extention to make use of the PACGA instruction.

Work around it by hand-assembling the instruction using a mind-bending
trick lifted from an old patch by Will. Magic.

Fixes: e09faab353a6 ("KVM: arm64: nv: Add emulation for ERETAx instructions")
Reported-by: Linaro Kernel Functional Testing <lkft@linaro.org>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/pauth.c | 19 +++++++++++++++++--
 1 file changed, 17 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/pauth.c b/arch/arm64/kvm/pauth.c
index a3a5c404375b..8baf2a2cbdd3 100644
--- a/arch/arm64/kvm/pauth.c
+++ b/arch/arm64/kvm/pauth.c
@@ -17,6 +17,22 @@
 #include <asm/kvm_emulate.h>
 #include <asm/pointer_auth.h>
 
+/*
+ * "// This is some of my finest work" (Will Deacon, 2019-02-12)
+ *
+ * The jury is still out on that one.
+ */
+#define REG(r)	"(0%x[" #r "] - ((0%x[" #r "] >> 4) * 6))"
+
+/* PACGA Xd, Xn, Xm */
+#define PACGA(d,n,m)						\
+	asm volatile(".inst 0x9AC03000   |"			\
+		     "(" REG(Rd) "<< 0)  |"			\
+		     "(" REG(Rn) "<< 5)  |"			\
+		     "(" REG(Rm) "<< 16)\n"			\
+		     : [Rd] "=r" ((d))				\
+		     : [Rn] "r" ((n)), [Rm] "r" ((m)))
+
 static u64 compute_pac(struct kvm_vcpu *vcpu, u64 ptr,
 		       struct ptrauth_key ikey)
 {
@@ -36,8 +52,7 @@ static u64 compute_pac(struct kvm_vcpu *vcpu, u64 ptr,
 	__ptrauth_key_install_nosync(APGA, ikey);
 	isb();
 
-	asm volatile(ARM64_ASM_PREAMBLE ".arch_extension pauth\n"
-		     "pacga %0, %1, %2" : "=r" (pac) : "r" (ptr), "r" (mod));
+	PACGA(pac, ptr, mod);
 	isb();
 
 	__ptrauth_key_install_nosync(APGA, gkey);
-- 
2.39.2

