Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA7B11CB518
	for <kvmarm@lists.linux.dev>; Mon, 13 Jan 2025 18:35:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736793333; cv=none; b=mUeKeLk1C7dHjP9WPHr7W97KlfZpiCSJ+Ve7AKBiQJObAjffFOeXEUCB/IjA1CkI8KRs7Yh3Hko/isQpNcpgUPY1tvkfeXgkbCESZdMO97xtJRdkbV3EoAOUYrZs4j+7Ob97S+d39AuTP+EBt6vF8ocXZqS0iuLQDfhogEDKGSU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736793333; c=relaxed/simple;
	bh=iDfPCs4CoYYumxUkz5rb7H2Ak9SuzFwLEKDiaW1buB0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=sta45Mn0hTGTRW78gwNVGOgGPOiEbAqwZN7RrrHMT/Yydv8pLU9CAV3NLuvXpMy6l7P8yD+muXhr4IXOxfYV/OrSjLLhPEDNfoPZiZxqDo8SEUSjfbXsVTAD4fgGXa9nJKBnHqRCSZ6Urbz205vpQAOmtLzzdNqNM7p7daiwARA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mMrMEIQl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mMrMEIQl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96A55C4CEE8;
	Mon, 13 Jan 2025 18:35:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1736793332;
	bh=iDfPCs4CoYYumxUkz5rb7H2Ak9SuzFwLEKDiaW1buB0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mMrMEIQl5czcJh+YNOu0C5S8pHTIAuoLE22qcNphV1EBFsPIdACsKHGAKbp2JE0bM
	 zT2ixoTCeCqOp0kY6ZWt9XAxW52ZsLrR3gMA6gFdzOYucXzKegZyNYZ8bDLv43AHYT
	 tiAeyxVXldcm3oUx+Y0wLbImkhOhLertTLHrFosFztvqV5lTgaWO+dlqWDrgU6vXeL
	 Nk7GdzDIzl6IEFFJ4ecw03vWDm8gSCUA1UA+pq7fxqftkxDgD/vKY9f+kxp1cnJ9Ax
	 ziLEZ0966u9ImpjmEXwOTc2gFoNowhnlHwfEat+4FvwktJF2r4tkM5QgiZjEOFsmID
	 x9yyqpwPc6s/g==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1tXPHe-00BjrF-Sd;
	Mon, 13 Jan 2025 18:35:30 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: [RFC PATCH 4/4] KVM: arm64: Make __vcpu_sys_reg() a pure rvalue operand
Date: Mon, 13 Jan 2025 18:35:24 +0000
Message-Id: <20250113183524.1378778-5-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20250113183524.1378778-1-maz@kernel.org>
References: <20250113183524.1378778-1-maz@kernel.org>
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
index c96a0c19dd108..7f2bfc2573fbd 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -1088,13 +1088,13 @@ u64 kvm_vcpu_apply_reg_masks(const struct kvm_vcpu *, enum vcpu_sysreg, u64);
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

