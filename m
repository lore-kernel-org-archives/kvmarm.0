Received: from mta1.migadu.com (out-71.mta1.migadu.com [95.215.58.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6BC1486419
	for <kvmarm@lists.linux.dev>; Thu,  1 Oct 2026 07:11:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.71
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790838679; cv=none; b=szaAnqMVHMERs0bhy6HsAIe4NGU1k4OR8GqRrp9gAcnjrY073QXC0XiYNSJLFXR2XPA0iQw9MuGe7d0yOg0P2+Tn/bdR/AlWcrbK4lMk+uI8/N0vlgQS0bIGXu9QAosO55EaxP/M1k+8OnX9B8S2dZrOT2rRjOMjDHgC6EEmaNs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790838679; c=relaxed/simple;
	bh=EejT2Q/JwSDIbSSxftpqQ/aTDCn9mVylyaJPheAAJww=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=IKYk1d3eQWEaekGAbHtClr1HgcNGvdJeNBy3e18e+jgaeApfBcsmDmtr51KxR58kFLIlF9QZHwFZXU6m5o0yDQCCM4RaeIxSCMsHNurIK5pNSamFivnkAelK2E5vO0rzbf+RcamKM7s4IYZ9w0gpxdpBaAOEMLB2Rux/0Ezo0BE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=E7EGUZ35; arc=none smtp.client-ip=95.215.58.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="E7EGUZ35"
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=EejT2Q/JwSDIbSSxftpqQ/aTDCn9mVylyaJPheAAJww=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790838670; v=1; x=1791443470;
 b=E7EGUZ353BXOR1tCMyyF7E8m7CYatVR0zTsBVPKEXaPRJF9CSsDYix8auV6FJ62WKGaHtIis
 Gv2ejT8U742XiGx9xq+d8u73TAfuxrVfkan0KnzKrGsVPmPNixvjXlx4r2utiJ9+t8H0ghMzxRH
 l4HwiAmNmyGohqQ71ln892MI=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id f3d13b3cb84fa9cc;
	Thu, 01 Oct 2026 07:11:10 +0000
X-Mizu-Trace-ID: f3d13b3cb84fa9cc
X-Migadu-Flow: FLOW_OUT
From: Fuad Tabba <fuad.tabba@linux.dev>
To: Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>
Cc: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	Will Deacon <will@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Yuchao Zhang <ndaugoing@gmail.com>,
	Fuad Tabba <tabba@google.com>
Subject: [PATCH v2 1/3] KVM: arm64: selftests: Add MOVI and MOVALL commands to the ITS library
Date: Thu,  1 Oct 2026 08:10:58 +0100
Message-Id: <20261001071100.190013-2-fuad.tabba@linux.dev>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20261001071100.190013-1-fuad.tabba@linux.dev>
References: <20261001071100.190013-1-fuad.tabba@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add its_send_movi_cmd() and its_send_movall_cmd() for a test that moves
a pending LPI. MOVALL takes both redistributors as processor numbers,
as its_send_mapc_cmd() and its_send_sync_cmd() do, and the new
its_encode_target2() puts the second one in RDbase2, in the command's
fourth doubleword.

Assisted-by: LLM
Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>
---
 .../selftests/kvm/include/arm64/gic_v3_its.h  |  2 ++
 .../selftests/kvm/lib/arm64/gic_v3_its.c      | 28 +++++++++++++++++++
 2 files changed, 30 insertions(+)

diff --git a/tools/testing/selftests/kvm/include/arm64/gic_v3_its.h b/tools/testing/selftests/kvm/include/arm64/gic_v3_its.h
index a43a407e2d5c1..e30a658fbd1c3 100644
--- a/tools/testing/selftests/kvm/include/arm64/gic_v3_its.h
+++ b/tools/testing/selftests/kvm/include/arm64/gic_v3_its.h
@@ -14,6 +14,8 @@ void its_send_mapc_cmd(void *cmdq_base, u32 vcpu_id, u32 collection_id, bool val
 void its_send_mapti_cmd(void *cmdq_base, u32 device_id, u32 event_id,
 			u32 collection_id, u32 intid);
 void its_send_invall_cmd(void *cmdq_base, u32 collection_id);
+void its_send_movi_cmd(void *cmdq_base, u32 device_id, u32 event_id, u32 collection_id);
+void its_send_movall_cmd(void *cmdq_base, u32 from_vcpu, u32 to_vcpu);
 void its_send_sync_cmd(void *cmdq_base, u32 vcpu_id);
 
 #endif // __SELFTESTS_GIC_V3_ITS_H__
diff --git a/tools/testing/selftests/kvm/lib/arm64/gic_v3_its.c b/tools/testing/selftests/kvm/lib/arm64/gic_v3_its.c
index 1188b578121dd..811d858f5def6 100644
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
@@ -253,6 +258,29 @@ void its_send_invall_cmd(void *cmdq_base, u32 collection_id)
 	its_send_cmd(cmdq_base, &cmd);
 }
 
+void its_send_movi_cmd(void *cmdq_base, u32 device_id, u32 event_id, u32 collection_id)
+{
+	struct its_cmd_block cmd = {};
+
+	its_encode_cmd(&cmd, GITS_CMD_MOVI);
+	its_encode_devid(&cmd, device_id);
+	its_encode_event_id(&cmd, event_id);
+	its_encode_collection(&cmd, collection_id);
+
+	its_send_cmd(cmdq_base, &cmd);
+}
+
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

