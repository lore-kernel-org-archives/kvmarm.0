Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EFB9E153820
	for <kvmarm@lists.linux.dev>; Fri,  3 May 2024 13:02:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714741347; cv=none; b=pCQOPY4IoA6V1yN+/G2TnmM/VJWOhjW0lxxyalOXzQioh96YUTUI5FYNmB2mqOCQQoAhf8hpg5X8xN2HxlZl9nba1S97I9eMjJsoeYCCu7Ezn4pZ/5cQdBcVO2vuWGkKEfKI4V2tjuqp8muTY9dGqw4b+CfC5HMYX7tMnUVNkFg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714741347; c=relaxed/simple;
	bh=8zlAb2LXqzm+y9Kq+yYFjSQ26oumXjkOAFar2LNZqmY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=EqY5lgDl4/SzP0M7hab6n7WJSctCbC+rHY/mT/T+jPQkJ/qlck5VnBzRgW47wWAqAcFFXsVrnWm3TmMNLzS4K1vCxjXtA5rHQTw37q0LgZk+jFOT8TQd3h5vBK5RE3aaePDTVuXWm7luzmfULp3+24nWKq6nkuwLO6sJs/fXhxY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 9246B1682;
	Fri,  3 May 2024 06:02:50 -0700 (PDT)
Received: from e124191.cambridge.arm.com (e124191.cambridge.arm.com [10.1.197.45])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 412BC3F73F;
	Fri,  3 May 2024 06:02:22 -0700 (PDT)
From: Joey Gouly <joey.gouly@arm.com>
To: linux-arm-kernel@lists.infradead.org
Cc: akpm@linux-foundation.org,
	aneesh.kumar@kernel.org,
	aneesh.kumar@linux.ibm.com,
	bp@alien8.de,
	broonie@kernel.org,
	catalin.marinas@arm.com,
	christophe.leroy@csgroup.eu,
	dave.hansen@linux.intel.com,
	hpa@zytor.com,
	joey.gouly@arm.com,
	linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org,
	linuxppc-dev@lists.ozlabs.org,
	maz@kernel.org,
	mingo@redhat.com,
	mpe@ellerman.id.au,
	naveen.n.rao@linux.ibm.com,
	npiggin@gmail.com,
	oliver.upton@linux.dev,
	shuah@kernel.org,
	szabolcs.nagy@arm.com,
	tglx@linutronix.de,
	will@kernel.org,
	x86@kernel.org,
	kvmarm@lists.linux.dev
Subject: [PATCH v4 09/29] KVM: arm64: use `at s1e1a` for POE
Date: Fri,  3 May 2024 14:01:27 +0100
Message-Id: <20240503130147.1154804-10-joey.gouly@arm.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20240503130147.1154804-1-joey.gouly@arm.com>
References: <20240503130147.1154804-1-joey.gouly@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

FEAT_ATS1E1A introduces a new instruction: `at s1e1a`.
This is an address translation, without permission checks.

POE allows read permissions to be removed from S1 by the guest.  This means
that an `at` instruction could fail, and not get the IPA.

Switch to using `at s1e1a` so that KVM can get the IPA regardless of S1
permissions.

Signed-off-by: Joey Gouly <joey.gouly@arm.com>
Cc: Marc Zyngier <maz@kernel.org>
Cc: Oliver Upton <oliver.upton@linux.dev>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>
---
 arch/arm64/kvm/hyp/include/hyp/fault.h | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/hyp/include/hyp/fault.h b/arch/arm64/kvm/hyp/include/hyp/fault.h
index 487c06099d6f..17df94570f03 100644
--- a/arch/arm64/kvm/hyp/include/hyp/fault.h
+++ b/arch/arm64/kvm/hyp/include/hyp/fault.h
@@ -14,6 +14,7 @@
 
 static inline bool __translate_far_to_hpfar(u64 far, u64 *hpfar)
 {
+	int ret;
 	u64 par, tmp;
 
 	/*
@@ -27,7 +28,9 @@ static inline bool __translate_far_to_hpfar(u64 far, u64 *hpfar)
 	 * saved the guest context yet, and we may return early...
 	 */
 	par = read_sysreg_par();
-	if (!__kvm_at(OP_AT_S1E1R, far))
+	ret = system_supports_poe() ? __kvm_at(OP_AT_S1E1A, far) :
+	                              __kvm_at(OP_AT_S1E1R, far);
+	if (!ret)
 		tmp = read_sysreg_par();
 	else
 		tmp = SYS_PAR_EL1_F; /* back to the guest */
-- 
2.25.1

