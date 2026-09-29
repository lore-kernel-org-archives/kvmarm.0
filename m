Received: from mta1.migadu.com (out-221.mta1.migadu.com [95.215.58.221])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6554B1A38F9
	for <kvmarm@lists.linux.dev>; Tue, 29 Sep 2026 19:05:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.221
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790708706; cv=none; b=G/49KPWrC/jj1dVCh2QYmo4T4OxKXyLFF55RPzjJ7+Xm0eR7O6kYvTQ/eLgGKP8Otxq9lV/PK5TuCFYpdInepBPAzEDgbCcB4HcD7S+t8fNPPhjId+65zjn6+1YUf2otyl+/pPrlRlSurjk+gBvjbkEttUzw9aqDW4VroVnJT1U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790708706; c=relaxed/simple;
	bh=r2D4QA2iJ+2gmHZXKSJFqPqM3IjZ2G/s/0P8pwHEYtw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=HcfxNnf/a/g9UBvtNh8895/vHwsMyspEUqmYHvbXDAKkmPfDoCr2/y9GwK83HsWdDVXmMDyp+GRkuXHN8tMK8Monx855X9dnuIhN93RG4DYeWeTWBP0rNsGsm7d6C6j9RYNvU6ad4qCPPMNTQ7y8SHI6UoHFjSXRKPSzEuwfRYQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Z1fhVUzb; arc=none smtp.client-ip=95.215.58.221
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Z1fhVUzb"
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=r2D4QA2iJ+2gmHZXKSJFqPqM3IjZ2G/s/0P8pwHEYtw=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790708701; v=1; x=1791313501;
 b=Z1fhVUzb3YFVA6UNwERSUICkxSFzKh1m/ghK6RlHn7OJvSSkqWUd5J4hq2ckdYtBNzlCKUK7
 hMO8k5JrgTw+sd6A1eeiyAIVEae6GiCkjEH6J/mJP8w2e0GvmIiEX3q2ZYknUidGmPKNRhkNdMY
 BBJlnnNpLG+I5KuYxs/uSoI8=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id c0bb7df4154168e6;
	Tue, 29 Sep 2026 19:05:01 +0000
X-Mizu-Trace-ID: c0bb7df4154168e6
X-Migadu-Flow: FLOW_OUT
From: Fuad Tabba <fuad.tabba@linux.dev>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	Steffen Eiden <seiden@linux.ibm.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oupton@kernel.org>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Yuchao Zhang <ndaugoing@gmail.com>,
	Fuad Tabba <tabba@google.com>
Subject: [PATCH v1 1/2] KVM: arm64: selftests: Add a MOVALL command to the ITS library
Date: Tue, 29 Sep 2026 20:04:51 +0100
Message-Id: <fcf20fcb0455a9360e5dc0487ddef25357087c25.1790708299.git.fuad.tabba@linux.dev>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <cover.1790708299.git.fuad.tabba@linux.dev>
References: <20260929093548.3598547-1-maz@kernel.org> <cover.1790708299.git.fuad.tabba@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add its_send_movall_cmd() for a MOVALL test. Both redistributors are
encoded as processor numbers, as its_send_mapc_cmd() does.

Assisted-by: LLM
Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>
---
 .../selftests/kvm/include/arm64/gic_v3_its.h     |  1 +
 .../testing/selftests/kvm/lib/arm64/gic_v3_its.c | 16 ++++++++++++++++
 2 files changed, 17 insertions(+)

diff --git a/tools/testing/selftests/kvm/include/arm64/gic_v3_its.h b/tools/testing/selftests/kvm/include/arm64/gic_v3_its.h
index a43a407e2d5c1..6a410c89c6445 100644
--- a/tools/testing/selftests/kvm/include/arm64/gic_v3_its.h
+++ b/tools/testing/selftests/kvm/include/arm64/gic_v3_its.h
@@ -14,6 +14,7 @@ void its_send_mapc_cmd(void *cmdq_base, u32 vcpu_id, u32 collection_id, bool val
 void its_send_mapti_cmd(void *cmdq_base, u32 device_id, u32 event_id,
 			u32 collection_id, u32 intid);
 void its_send_invall_cmd(void *cmdq_base, u32 collection_id);
+void its_send_movall_cmd(void *cmdq_base, u32 from_vcpu, u32 to_vcpu);
 void its_send_sync_cmd(void *cmdq_base, u32 vcpu_id);
 
 #endif // __SELFTESTS_GIC_V3_ITS_H__
diff --git a/tools/testing/selftests/kvm/lib/arm64/gic_v3_its.c b/tools/testing/selftests/kvm/lib/arm64/gic_v3_its.c
index 1188b578121dd..9237401a94fe8 100644
--- a/tools/testing/selftests/kvm/lib/arm64/gic_v3_its.c
+++ b/tools/testing/selftests/kvm/lib/arm64/gic_v3_its.c
@@ -159,6 +159,11 @@ static void its_encode_target(struct its_cmd_block *cmd, u64 target_addr)
 	its_mask_encode(&cmd->raw_cmd[2], target_addr >> 16, 51, 16);
 }
 
+static void its_encode_target2(struct its_cmd_block *cmd, u64 target_addr)
+{
+	its_mask_encode(&cmd->raw_cmd[3], target_addr >> 16, 51, 16);
+}
+
 static void its_encode_collection(struct its_cmd_block *cmd, u16 col)
 {
 	its_mask_encode(&cmd->raw_cmd[2], col, 15, 0);
@@ -253,6 +258,17 @@ void its_send_invall_cmd(void *cmdq_base, u32 collection_id)
 	its_send_cmd(cmdq_base, &cmd);
 }
 
+void its_send_movall_cmd(void *cmdq_base, u32 from_vcpu, u32 to_vcpu)
+{
+	struct its_cmd_block cmd = {};
+
+	its_encode_cmd(&cmd, GITS_CMD_MOVALL);
+	its_encode_target(&cmd, procnum_to_rdbase(from_vcpu));
+	its_encode_target2(&cmd, procnum_to_rdbase(to_vcpu));
+
+	its_send_cmd(cmdq_base, &cmd);
+}
+
 void its_send_sync_cmd(void *cmdq_base, u32 vcpu_id)
 {
 	struct its_cmd_block cmd = {};
-- 
2.39.5

