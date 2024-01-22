Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F26704122A
	for <kvmarm@lists.linux.dev>; Mon, 22 Jan 2024 20:19:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705954742; cv=none; b=alYgUKGa2rlqAo3h0pUy7X5CpI95UdUZq9A4hUilv1nFJWGVpWk22YfUcGHgNkzJu8+QxaBdaSeWlTBAvOB/llgT7YkOLd8MHPSTyGywxhEbVIgyZUqsDOw84InvsgVeESluSnR46FkKl97UwCECzJSiA51Ga6bR4IFlZMr5G/U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705954742; c=relaxed/simple;
	bh=+YmONgMWpFOWKRTDk0MpC9YrGfrX0PQci4i+V0jsS+M=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=tDn6uGkG04xkZMR67QSaCQI+Rm/qYztrwSr5bTjfq4xpJbtYOssHSFUul5SFNmDd4n0+9CRbBJKkYf48cIHPQPOLN+SzpZ9IM85EsrUWah7cjmrHZeaurIp1jfZ/tG01+MiY4wrk2+0JQqYTZPBt0u47+5XiwnHqb2rl+EsiQuk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UGxnGGAz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UGxnGGAz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D43CBC433A6;
	Mon, 22 Jan 2024 20:19:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1705954741;
	bh=+YmONgMWpFOWKRTDk0MpC9YrGfrX0PQci4i+V0jsS+M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UGxnGGAzieA/rMILiJa/Z3xz0JIYEYB2OY4nBcqOsj4nRUYrk7yx/DkqVOGatZbcd
	 XyoZ5NZUV3Twozv2N8IqJumHxrIjM7vhIHdv7bMM4inlX7VSlUsHsF5tGU1F+37+B0
	 sw5QnfxB9b4HAYy6pvaoEQMfH+Vz/Ec2S814fcnJwqZc+AwOefhLUUERRMOq9uTspq
	 ak71IaSTgPn/Lv9gZjx5aYEDr3kXCzHkYHH96LHrEZWd7jSlzHYaKJeprMxjEm+Us6
	 sZa+gk92OWjjmPvGtWSDkl3A3glif7by8n7pn7UEYseJfszEgG8nWu3GeUk4Ds+/kA
	 FVncTAxFBEIMQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1rS0l2-00DjkQ-0u;
	Mon, 22 Jan 2024 20:19:00 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org
Cc: James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 23/25] KVM: arm64: Make AMU sysreg UNDEF if FEAT_AMU is not advertised to the guest
Date: Mon, 22 Jan 2024 20:18:50 +0000
Message-Id: <20240122201852.262057-24-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240122201852.262057-1-maz@kernel.org>
References: <20240122201852.262057-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, catalin.marinas@arm.com, will@kernel.org, joey.gouly@arm.com, broonie@kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

No AMU? No AMU! IF we see an AMU-related trap, let's turn it into
an UNDEF!

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/sys_regs.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index bcde43b81755..afe6975fcf5c 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -3994,6 +3994,10 @@ void kvm_init_sysreg(struct kvm_vcpu *vcpu)
 		kvm->arch.fgu[HFGxTR_GROUP] |= (HFGxTR_EL2_nPIRE0_EL1 |
 						HFGxTR_EL2_nPIR_EL1);
 
+	if (!kvm_has_feat(kvm, ID_AA64PFR0_EL1, AMU, IMP))
+		kvm->arch.fgu[HAFGRTR_GROUP] |= ~(HAFGRTR_EL2_RES0 |
+						  HAFGRTR_EL2_RES1);
+
 	set_bit(KVM_ARCH_FLAG_FGU_INITIALIZED, &kvm->arch.flags);
 out:
 	mutex_unlock(&kvm->arch.config_lock);
-- 
2.39.2

