Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8430616A94F;
	Wed, 21 Aug 2024 23:36:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724283381; cv=none; b=X7leYKLR3T8S863DE9o+uuDFIpQe5I3085fjvtJ9m5Ydjuzb/Nb29DELZX9k2JbF6yzL9lpv2e2C85f21DsfiXAsfdE8Q1rVLIOpTrol9aazIBaJ5ODxp6WuUqpSHCJbgaG8iZouWBlj0T+cYG09RvWKlgKclUVPvjWB0LRvt80=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724283381; c=relaxed/simple;
	bh=TnLcZV5j0h1vfwLf7V+sLcnJs4449D1TH0HuTBuSxFY=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=fKt20TFOzJmBKty8IX92j09zXVi3enXIeKR6GpBO2pBdAX+BO3zzYr8m1RhhhZOokauvu7NFlQoScZrbb4w6UBTc9U+CeGQz+Y6Z5Gj1Oqn7/wLn+0EvAB58WHr+bf4D5AGAl8DYyHSULOc1wf5LsQt+ut9sQ+YNz7U/DddJbuI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UVJODIBk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UVJODIBk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DBC0C32782;
	Wed, 21 Aug 2024 23:36:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724283381;
	bh=TnLcZV5j0h1vfwLf7V+sLcnJs4449D1TH0HuTBuSxFY=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=UVJODIBkPa2yzzOUczJ87OFjHeeEH3ykt9CBt7yjiV4HZYE5kvEx26ie2f9J75OUg
	 ThXNgMfoHS7mdPzOmzkZGPY8Lo/VAEQdAIBMan1I9NcdtDPdC4hxtg5F14hJL47pJC
	 BrBWMwsjc2wGJNt5+IF/MKpI/hBRJq0FApyf49L8mn0SbIBElWTgyKdX6Vqhe4n+rt
	 gsNQFRQVBMTYTR2RyslAaCrlQBNmuGQrsw5AxH0O6p5iZeCnQ7ZxTlPNccy5aC6erg
	 ZgEL6Pr28BareoygcSb0dZnI/LkeXtCAlqw5X+2oqdsYQo78sInWDMbRoZRi6dSXCe
	 X11aUKnWCkePA==
From: Mark Brown <broonie@kernel.org>
Date: Thu, 22 Aug 2024 00:35:36 +0100
Subject: [PATCH v2 1/3] KVM: arm64: Define helper for EL2 registers with
 custom visibility
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20240822-kvm-arm64-hide-pie-regs-v2-1-376624fa829c@kernel.org>
References: <20240822-kvm-arm64-hide-pie-regs-v2-0-376624fa829c@kernel.org>
In-Reply-To: <20240822-kvm-arm64-hide-pie-regs-v2-0-376624fa829c@kernel.org>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
 James Morse <james.morse@arm.com>, 
 Suzuki K Poulose <suzuki.poulose@arm.com>, 
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
 Joey Gouly <joey.gouly@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
 linux-kernel@vger.kernel.org, Mark Brown <broonie@kernel.org>, 
 20240813144738.2048302-1-maz@kernel.org
X-Mailer: b4 0.15-dev-37811
X-Developer-Signature: v=1; a=openpgp-sha256; l=1399; i=broonie@kernel.org;
 h=from:subject:message-id; bh=TnLcZV5j0h1vfwLf7V+sLcnJs4449D1TH0HuTBuSxFY=;
 b=owEBbQGS/pANAwAKASTWi3JdVIfQAcsmYgBmxnnp/eE7jfejNCJhPTNlB8GBsgUEO1dh38EUFkDi
 7nBBSjSJATMEAAEKAB0WIQSt5miqZ1cYtZ/in+ok1otyXVSH0AUCZsZ56QAKCRAk1otyXVSH0DiTB/
 9XkFXBeTHJFPIz0WRf13WK1WV5XrzrlUYRwxzkALiU6IEwF6/lfutvjFO6yGScRYuAsjHcXbTNdrDW
 3iSSUULIKNAAmnzc8CMe8cGCDJCexf0uuXVKeiijGCpBI+y+u0L9SUckx7e0iE6oU03cBoqYSWQDst
 VUM/WL4ChuK4zB3cR7uZnHY/GYZGd30WxU4aeo82V6S78S5UJqZ9UppAlJDJ3eADeFTojthIOTzMWq
 4y1ibnm+17XUpCSVsZolSJB9cK/AdQkTEDt1iOKWHuoBKKCK+A4SU7RNcWXGgVqk8HfXEjwtCKHlWm
 fmedslXbWsubOhmpAac9L+gDeYD4wz
X-Developer-Key: i=broonie@kernel.org; a=openpgp;
 fpr=3F2568AAC26998F9E813A1C5C3F436CA30F5D8EB

In preparation for adding more visibility filtering for EL2 registers add
a helper macro like EL2_REG() which allows specification of a custom
visibility operation.

Signed-off-by: Mark Brown <broonie@kernel.org>
---
 arch/arm64/kvm/sys_regs.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index d0b4509e59cb..1af15140e067 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -2136,6 +2136,15 @@ static bool bad_redir_trap(struct kvm_vcpu *vcpu,
 	.val = v,				\
 }
 
+#define EL2_REG_FILTERED(name, acc, rst, v, filter) {	\
+	SYS_DESC(SYS_##name),			\
+	.access = acc,				\
+	.reset = rst,				\
+	.reg = name,				\
+	.visibility = filter,			\
+	.val = v,				\
+}
+
 #define EL2_REG_VNCR(name, rst, v)	EL2_REG(name, bad_vncr_trap, rst, v)
 #define EL2_REG_REDIR(name, rst, v)	EL2_REG(name, bad_redir_trap, rst, v)
 
@@ -2803,8 +2812,8 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 	EL2_REG_VNCR(HFGITR_EL2, reset_val, 0),
 	EL2_REG_VNCR(HACR_EL2, reset_val, 0),
 
-	{ SYS_DESC(SYS_ZCR_EL2), .access = access_zcr_el2, .reset = reset_val,
-	  .visibility = sve_el2_visibility, .reg = ZCR_EL2 },
+	EL2_REG_FILTERED(ZCR_EL2, access_zcr_el2, reset_val, 0,
+			 sve_el2_visibility),
 
 	EL2_REG_VNCR(HCRX_EL2, reset_val, 0),
 

-- 
2.39.2

