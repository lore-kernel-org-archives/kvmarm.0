Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEA35268C4B
	for <kvmarm@lists.linux.dev>; Tue,  3 Jun 2025 07:08:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748934524; cv=none; b=FryluIQkk9N3nVGJc5GuPJZeN1E8kER6NWdcQH6ADDmrUxbf+RHV1F+lpA/wDl1FHkiXvf7MRatexTNc1qPAXecOQm48bg+Y2fHWRLhQhFBM53kGspN0BL0wTs0T5CFIn9aEnISULWX61FnQjyfCdZgQcdB2b/ab/zq5b1g4HCg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748934524; c=relaxed/simple;
	bh=K/RtzbQ+b7dH8ZrEJdeD2NQuerIL9r6Cxc/FT5nhyEQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=MYA2Slmy1qtm9nhUgH+kEQthQYv45gMOWRwPYNSCz9xYn9fBqxCKs54gvmdWbaFZD86y5Xyn59QAZypH/Q63X41lx5f/JQlTVeKNU6KZ9LtP1wrBI4oJNzJQIk/s+OoyOYAcsruDVvhic//f8zWGAs+5mvaEDwB8LBQq0owcskk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZHeMJ/WQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZHeMJ/WQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE42FC4CEF3;
	Tue,  3 Jun 2025 07:08:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1748934523;
	bh=K/RtzbQ+b7dH8ZrEJdeD2NQuerIL9r6Cxc/FT5nhyEQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZHeMJ/WQsfvNjiBObMaqQKbveVze3OVotUDM2xxNQ605ImX/SjtN+cMCZwDmRGRpg
	 VYF3I4Q9Dby8zBTB364ppewvAWhmaXGp0BhBhRrXaQFx20ltvq+ttSdQWnbGeLlk3R
	 3hNhlAobqz+FgtxKUGTw23YQq3p5HR0rzaedOznouE3hFzCXM1H2szRF0c0d1ii4RI
	 Z+ZqhrStoNlErca/lTUr0ME1aD1JTNyMCxzmWqm8S58GZhF992PI8jKieQNC8CNE/c
	 VeaXKjtSoXDIF2BlzCbD1e6si5uGGvYW+tmhUz1dTqwyHpyIbm0tbdOGT0e/JJ9PE9
	 /l/3oRo8qP3Ow==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1uMLlJ-002isr-TL;
	Tue, 03 Jun 2025 08:08:41 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: [PATCH v2 4/4] KVM: arm64: Make __vcpu_sys_reg() a pure rvalue operand
Date: Tue,  3 Jun 2025 08:08:24 +0100
Message-Id: <20250603070824.1192795-5-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20250603070824.1192795-1-maz@kernel.org>
References: <20250603070824.1192795-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

Now that we don't have any use of __vcpu_sys_reg() as a lvalue,
remove the in-place update, and directly return the sanitised
value.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/kvm_host.h | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index c361f8aa16c90..b4ac2f515f94f 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -1129,13 +1129,13 @@ u64 kvm_vcpu_apply_reg_masks(const struct kvm_vcpu *, enum vcpu_sysreg, u64);
 	} while (0)
 
 #define __vcpu_sys_reg(v,r)						\
-	(*({								\
+	({								\
 		const struct kvm_cpu_context *ctxt = &(v)->arch.ctxt;	\
-		u64 *__r = __ctxt_sys_reg(ctxt, (r));			\
+		u64 __v = ctxt_sys_reg(ctxt, (r));			\
 		if (vcpu_has_nv((v)) && (r) >= __SANITISED_REG_START__)	\
-			*__r = kvm_vcpu_apply_reg_masks((v), (r), *__r);\
-		__r;							\
-	}))
+			__v = kvm_vcpu_apply_reg_masks((v), (r), __v);	\
+		__v;							\
+	})
 
 u64 vcpu_read_sys_reg(const struct kvm_vcpu *vcpu, int reg);
 void vcpu_write_sys_reg(struct kvm_vcpu *vcpu, u64 val, int reg);
-- 
2.39.2

