Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E20EF8F66
	for <kvmarm@lists.linux.dev>; Tue, 20 Dec 2022 20:09:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 951ABC433D2;
	Tue, 20 Dec 2022 20:09:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1671566971;
	bh=vE/hvEPaEAJb0j8KpsZSnoLCuvka9VSEHpuoo8I5z6g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TlJ7R+1f0o9VPMmdC8dWRi0B0EulVG6oEJQeztTQccayl0++Yb6o+bwDofxvNzS79
	 roUMlS6354v+FHRNB9+mdnJr7hmOxr35h0jiZHVNLGflvOggVzshtiZd+VVh5hJhjJ
	 huyaOewPHVhp4ZbTuRLCzhC9kXrKXbeBeV3WpzcwB4X7xn0B4cOHaHpN9KWiKNn8KF
	 /UXeIheLzRe0U8AMt09SdWnXRglAI4ooEDpiCLshQb4xl5bfc45Vbc1cukrflqB8P2
	 7lxYOn+9bXuANyVcVw91w8frkMrivauu4fO4ZG5tc04MJo9u0WpYi3zBJBq2FWBI3m
	 Vs4RVAHdV8+GQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1p7ivZ-00Dzct-IW;
	Tue, 20 Dec 2022 20:09:29 +0000
From: Marc Zyngier <maz@kernel.org>
To: <kvmarm@lists.cs.columbia.edu>,
	<kvmarm@lists.linux.dev>,
	kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
Cc: James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Ard Biesheuvel <ardb@kernel.org>,
	Will Deacon <will@kernel.org>,
	Quentin Perret <qperret@google.com>,
	stable@vger.kernel.org
Subject: [PATCH 1/3] KVM: arm64: Fix S1PTW handling on RO memslots
Date: Tue, 20 Dec 2022 20:09:21 +0000
Message-ID: <20221220200923.1532710-2-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221220200923.1532710-1-maz@kernel.org>
References: <20221220200923.1532710-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.cs.columbia.edu, kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, james.morse@arm.com, suzuki.poulose@arm.com, alexandru.elisei@arm.com, oliver.upton@linux.dev, ardb@kernel.org, will@kernel.org, qperret@google.com, stable@vger.kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Message-ID: <20221220200921.RI5J2QSmpls6-qyy1rdNAiLMRaVwX-tYTpEafQsZ_zA@z>

A recent development on the EFI front has resulted in guests having
their page tables baked in the firmware binary, and mapped into
the IPA space as part as a read-only memslot.

Not only this is legitimate, but it also results in added security,
so thumbs up. However, this clashes mildly with our handling of a S1PTW
as a write to correctly handle AF/DB updates to the S1 PTs, and results
in the guest taking an abort it won't recover from (the PTs mapping the
vectors will suffer freom the same problem...).

So clearly our handling is... wrong.

Instead, switch to a two-pronged approach:

- On S1PTW translation fault, handle the fault as a read

- On S1PTW permission fault, handle the fault as a write

This is of no consequence to SW that *writes* to its PTs (the write
will trigger a non-S1PTW fault), and SW that uses RO PTs will not
use AF/DB anyway, as that'd be wrong.

Only in the case described in c4ad98e4b72c ("KVM: arm64: Assume write
fault on S1PTW permission fault on instruction fetch") do we end-up
with two back-to-back faults (page being evicted and faulted back).
I don't think this is a case worth optimising for.

Fixes: c4ad98e4b72c ("KVM: arm64: Assume write fault on S1PTW permission fault on instruction fetch")
Signed-off-by: Marc Zyngier <maz@kernel.org>
Cc: stable@vger.kernel.org
---
 arch/arm64/include/asm/kvm_emulate.h | 22 ++++++++++++++++++++--
 1 file changed, 20 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
index 9bdba47f7e14..fd6ad8b21f85 100644
--- a/arch/arm64/include/asm/kvm_emulate.h
+++ b/arch/arm64/include/asm/kvm_emulate.h
@@ -373,8 +373,26 @@ static __always_inline int kvm_vcpu_sys_get_rt(struct kvm_vcpu *vcpu)
 
 static inline bool kvm_is_write_fault(struct kvm_vcpu *vcpu)
 {
-	if (kvm_vcpu_abt_iss1tw(vcpu))
-		return true;
+	if (kvm_vcpu_abt_iss1tw(vcpu)) {
+		/*
+		 * Only a permission fault on a S1PTW should be
+		 * considered as a write. Otherwise, page tables baked
+		 * in a read-only memslot will result in an exception
+		 * being delivered in the guest.
+		 *
+		 * The drawback is that we end-up fauling twice if the
+		 * guest is using any of HW AF/DB: a translation fault
+		 * to map the page containing the PT (read only at
+		 * first), then a permission fault to allow the flags
+		 * to be set.
+		 */
+		switch (kvm_vcpu_trap_get_fault_type(vcpu)) {
+		case ESR_ELx_FSC_PERM:
+			return true;
+		default:
+			return false;
+		}
+	}
 
 	if (kvm_vcpu_trap_is_iabt(vcpu))
 		return false;
-- 
2.34.1

