Received: from out-178.mta0.migadu.com (out-178.mta0.migadu.com [91.218.175.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CB8B3FB1E
	for <kvmarm@lists.linux.dev>; Wed, 21 Feb 2024 09:28:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708507701; cv=none; b=PhQYTB/JYtsQN+K/2U7X6D6qPRAJ9eyo5W3ANFDI1a/szQHw6QpAPKj6p5defCVZbRbNWujR3chkQX3O3VFquqT7HK+4iSfj5O/it0gxMEhUMgvJL7Uyh3HwwInkDZ7FgOqqQaEM1tCBldNPnfPQd/qSmtEnBwPI20s6TegGavk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708507701; c=relaxed/simple;
	bh=935UE9RRQPAk+v5xnkQMIm3Y9P2dDvTzl1yq6IZrHLk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rkTjNmKCtCTWtJZYU4Vjvs9PY5SOL9NeMpAHpIsoj/sGWgAklp0HgcH/Vopg0vrmJHpqk3voGYH0TCBeKu1No0reBTgw9LbmnJ7dre0g5C6oDDxsH9E+TnIkgw3F0aXg2+QrhTgDFvmDHQ/iQmHctyRYdpE8Mpvth1tezFLg9RQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=lrSoqt2H; arc=none smtp.client-ip=91.218.175.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="lrSoqt2H"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1708507697;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=zV8bEDJTXHyIL6fI4X8SBddai4O+c/chOvr06kqgmv4=;
	b=lrSoqt2HeVZFmOlPrYGEEOGEZrKCIjqgNLIxsr1xYMJQE9dgFMqq2Fhqh98q/klhQrpvZ7
	U7RAUC1NI/b8xeW/os2tIyVrvBA+fIXubkWNuSChD8knBLr4FLq7Q3dpC/kUDJegOPFRZR
	KrxUEPTp+7aEY/FCZKZsvFOlPlTrw8M=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	stable@vger.kernel.org
Subject: [PATCH 2/2] KVM: arm64: vgic-its: Test for valid IRQ in MOVALL handler
Date: Wed, 21 Feb 2024 09:27:32 +0000
Message-ID: <20240221092732.4126848-3-oliver.upton@linux.dev>
In-Reply-To: <20240221092732.4126848-1-oliver.upton@linux.dev>
References: <20240221092732.4126848-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

It is possible that an LPI mapped in a different ITS gets unmapped while
handling the MOVALL command. If that is the case, there is no state that
can be migrated to the destination. Silently ignore it and continue
migrating other LPIs.

Cc: stable@vger.kernel.org
Fixes: ff9c114394aa ("KVM: arm/arm64: GICv4: Handle MOVALL applied to a vPE")
Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/kvm/vgic/vgic-its.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm64/kvm/vgic/vgic-its.c b/arch/arm64/kvm/vgic/vgic-its.c
index 082448de27ed..28a93074eca1 100644
--- a/arch/arm64/kvm/vgic/vgic-its.c
+++ b/arch/arm64/kvm/vgic/vgic-its.c
@@ -1435,6 +1435,8 @@ static int vgic_its_cmd_handle_movall(struct kvm *kvm, struct vgic_its *its,
 
 	for (i = 0; i < irq_count; i++) {
 		irq = vgic_get_irq(kvm, NULL, intids[i]);
+		if (!irq)
+			continue;
 
 		update_affinity(irq, vcpu2);
 
-- 
2.44.0.rc0.258.g7320e95886-goog

