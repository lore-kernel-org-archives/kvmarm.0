Received: from out-180.mta1.migadu.com (out-180.mta1.migadu.com [95.215.58.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BDB51DDA06
	for <kvmarm@lists.linux.dev>; Mon,  7 Oct 2024 17:46:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728323192; cv=none; b=PvyBGX7IEFGMXk/p1Xneuz/rbttYuQ3WeFOgrJzQxkiGOnL1+FO/zyLesMElnt2DZhvhv7YJ6ODrw+w4pNaIcUdLCo+X4occn/e8TvGzDurTBRoYMMeBuaAWjNoLq7/b6ciNx07GpYFPgpaR9xN9LlT8t2eXBEcsqX2njh3c2MQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728323192; c=relaxed/simple;
	bh=zGw+sHlQyz6Bn4t2KK/+1SaulB6s6KEuN8Yzi6B0ER8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fUfzHQV1itGPxlw5+pyaHkyTXsg7au+/snCQZOF9YzPI38HJUJ5yao8hSc4h/+E4J1AnoLOpFeJR9rnHSh77bsmio2wUZKTTXeJd52elXX8PHPqvwyE515f8Tse4tF3r+dz3hIS6P2vif93qBOg5LIpcslTugWyHFQYAEk0hxLI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=ktQIBcTY; arc=none smtp.client-ip=95.215.58.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="ktQIBcTY"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1728323189;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=6rfIdTk0IEtLG1BYVai1HeooNS/PL2MplyRJLSIesws=;
	b=ktQIBcTYYHKA/viswT17NZ0fqDiIwXHjY4/1FyC604T8vZYj4mPNYcqGWlhuERSDR+LlFw
	20QTyvxj+H6T6CiJvAF/afN4D24quIQyagtt0XOF94QFonYwqo1/CVHF1MMdbbrpxKYS58
	aKZx+k98vLHV1eYR6dXto2CrH/9mcDs=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH v3 08/17] KVM: arm64: nv: Honor MDCR_EL2.{TPM, TPMCR} in Host EL0
Date: Mon,  7 Oct 2024 17:45:50 +0000
Message-ID: <20241007174559.1830205-9-oliver.upton@linux.dev>
In-Reply-To: <20241007174559.1830205-1-oliver.upton@linux.dev>
References: <20241007174559.1830205-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

TPM and TPMCR trap bits also affect Host EL0. How fun.

Mark these two trap bits as such and take advantage of the new
infrastructure for dealing w/ EL0 traps.

Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/kvm/emulate-nested.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/emulate-nested.c b/arch/arm64/kvm/emulate-nested.c
index db3149379a4d..f9594296d69c 100644
--- a/arch/arm64/kvm/emulate-nested.c
+++ b/arch/arm64/kvm/emulate-nested.c
@@ -304,13 +304,15 @@ static const struct trap_bits coarse_trap_bits[] = {
 		.index		= MDCR_EL2,
 		.value		= MDCR_EL2_TPMCR,
 		.mask		= MDCR_EL2_TPMCR,
-		.behaviour	= BEHAVE_FORWARD_RW,
+		.behaviour	= BEHAVE_FORWARD_RW |
+				  BEHAVE_IN_HOST_EL0,
 	},
 	[CGT_MDCR_TPM] = {
 		.index		= MDCR_EL2,
 		.value		= MDCR_EL2_TPM,
 		.mask		= MDCR_EL2_TPM,
-		.behaviour	= BEHAVE_FORWARD_RW,
+		.behaviour	= BEHAVE_FORWARD_RW |
+				  BEHAVE_IN_HOST_EL0,
 	},
 	[CGT_MDCR_TDE] = {
 		.index		= MDCR_EL2,
-- 
2.47.0.rc0.187.ge670bccf7e-goog

