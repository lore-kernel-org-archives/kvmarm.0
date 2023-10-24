Received: from out-197.mta0.migadu.com (out-197.mta0.migadu.com [91.218.175.197])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 820CA15B4
	for <kvmarm@lists.linux.dev>; Tue, 24 Oct 2023 21:07:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="SgF8VpK9"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1698181672;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=fSyLTmEne5H15gCAbFAp7YdAG90zxia/5FU2XX1Ko80=;
	b=SgF8VpK96lCgNxnxzktqS5kjoR4CnoHvdxy6ggkwkdubuJa8oX2IY9Bx9xGzPbjlqKwdQi
	77iks9pC4t3xHic6WhHU6ZpJuNOS4vEODgaHJIvAPxr9frvkih/bh9j9Hz3/Gn6Cy6/Gel
	rBN+jeWaoilfjELzlfFZayzJxa0r1yY=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: kvm@vger.kernel.org,
	Marc Zyngier <maz@kernel.org>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH] KVM: arm64: Stop printing about MMIO accesses where ISV==0
Date: Tue, 24 Oct 2023 21:07:39 +0000
Message-ID: <20231024210739.1729723-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

It is a pretty well known fact that KVM does not support MMIO emulation
without valid instruction syndrome information (ESR_EL2.ISV == 0). The
dmesg is useless as it provides zero context and just winds up polluting
logs. Let's just delete it.

Any userspace that cares should just use KVM_CAP_ARM_NISV_TO_USER, which
inherently ties to a vCPU context.

Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/kvm/mmio.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/arm64/kvm/mmio.c b/arch/arm64/kvm/mmio.c
index 3dd38a151d2a..a53721be32ec 100644
--- a/arch/arm64/kvm/mmio.c
+++ b/arch/arm64/kvm/mmio.c
@@ -143,7 +143,6 @@ int io_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa)
 			return 0;
 		}
 
-		kvm_pr_unimpl("Data abort outside memslots with no valid syndrome info\n");
 		return -ENOSYS;
 	}
 

base-commit: 6465e260f48790807eef06b583b38ca9789b6072
-- 
2.42.0.758.gaed0368e0e-goog

