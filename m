Received: from out-175.mta1.migadu.com (out-175.mta1.migadu.com [95.215.58.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F9E2137C4B
	for <kvmarm@lists.linux.dev>; Tue, 27 Feb 2024 09:41:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709026891; cv=none; b=tNQMq9FrbrE8CFd7dfHQUcrfV+JWipQJgSm+K/TPkcKca+Mbfk0Qy5la/gKncgg1yK1aggwhixnbygMmcuMUJFJMRaVEhAkevleYi30D3DaILVKK5GutqUsk09NQ353MwENzLSxlUfgTM48h/oB71xgK1GO225/eg8T5+lztbds=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709026891; c=relaxed/simple;
	bh=5MfdbBBYrF+sXPSKJMncMlv2m0xXu8atQ8bn73l2bvA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mH0i0txeC+FgUEKmPMVN2jxzOQCaYYXm5WRD5HSTdtaQNPk4j0jp7hIXfmSXTFsncwzCgWGJOFFd58oPc9OjgHL3DPM51fF+rz/kvk5bw+9SQuskXeZehpeGsjR4+7OUC069us5m5wrkTO2geSEmfAjIBTjn6Rd16U0djRjCLpg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=U8twFEeY; arc=none smtp.client-ip=95.215.58.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="U8twFEeY"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1709026887;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=oDyjjWDhGmx1ca9lumlKjUOBS9x26uk5yyf2UVJ2ll8=;
	b=U8twFEeYiezzpQ6KHYWo2Rcz2+88SpCp1TjZI2k78+ffxpiB0WdnQbTQFM0xckfbmlGd2J
	FwYZ2zXMg4x2X28XB96xtaW6g92ugYuGZRgtv1bKpq5zYCWYkgk91zJYZjxag5opXmDeck
	Vdk8DVwowEUR+S7yQv9dRLsuigrFen8=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH 1/2] KVM: arm64: Fail the idreg iterator if idregs aren't initialized
Date: Tue, 27 Feb 2024 09:41:14 +0000
Message-ID: <20240227094115.1723330-2-oliver.upton@linux.dev>
In-Reply-To: <20240227094115.1723330-1-oliver.upton@linux.dev>
References: <20240227094115.1723330-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Return an error to userspace if the VM's ID register values haven't been
initialized in preparation for changing the debugfs file initialization
order.

Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/kvm/sys_regs.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 9a0b3a22a9d4..1ebc483c2b0c 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -3434,7 +3434,8 @@ static void *idregs_debug_start(struct seq_file *s, loff_t *pos)
 	mutex_lock(&kvm->arch.config_lock);
 
 	iter = &kvm->arch.idreg_debugfs_iter;
-	if (*iter == (u8)~0) {
+	if (test_bit(KVM_ARCH_FLAG_ID_REGS_INITIALIZED, &kvm->arch.flags) &&
+	    *iter == (u8)~0) {
 		*iter = *pos;
 		if (*iter >= KVM_ARM_ID_REG_NUM)
 			iter = NULL;
-- 
2.44.0.rc1.240.g4c46232300-goog

