Received: from out-182.mta0.migadu.com (out-182.mta0.migadu.com [91.218.175.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5446027979F
	for <kvmarm@lists.linux.dev>; Wed, 10 Sep 2025 18:09:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757527785; cv=none; b=hrsOjNujd1z40y3JmNjo3IrluSy7BXis13XTsAu5J89JAQ6E3kmQRwJt4SGN5R91OxtsEgEFhqt6A/aLleEEoxqq7x8nhqzLwdh3f8ILm32u2P1iGwrDQN28BvYDCWTPjrjI+h3UoO/pXuhIecvPTEJyQnkGK1KTG+zcyj0bJmM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757527785; c=relaxed/simple;
	bh=MwLdhjTobs1QSqPnLeJ1oE9PtKSz7k8iqhdEpY2MfCk=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=Nxy3QM3sehcQ7VuqakdcT5eby6DLcUVmrMNpUIXUez/8+CaznnrypFTJfr7YDeTTF1OIwy4i1ufSuStZrBJY81k0R1OHH68zC10Eti2FC+a5/ddsf/QGWZrFX0S4zoc8gx++fm105JNeM/sasbnYdHpwWSkWIrRBMEuBlnbf7fA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=AcyJ6euD; arc=none smtp.client-ip=91.218.175.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="AcyJ6euD"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1757527779;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=3pbTcWhfOyf6M9Hh5rdBSV4O4myLk1uHaXA9K8M5edQ=;
	b=AcyJ6euDQycAoVF8nI9+yNyiqyDvjAyCMZI+VtPq1LpTtOfVbTF0sLsjjAGvTIL7gRFra5
	vj87lL1WEdKToAQPjhNnddQ7FuPyKJOhGQuuqL00GvT0jwdoZkGAdPdec7vey7LcauGofj
	iqriPUJHhrtFjdm0If8D1xdKiAZXTtQ=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Raghavendra Rao Ananta <rananta@google.com>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH 0/2] KVM: arm64: Revert resched fixes for stage-2 destruction
Date: Wed, 10 Sep 2025 11:09:27 -0700
Message-Id: <20250910180930.3679473-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

We're getting pretty late in the cycle and things haven't settled down
yet on the resched fixes. At this point a revert seems like the best
idea so we can let an improved version bake a bit longer.

Oliver Upton (2):
  Revert "KVM: arm64: Reschedule as needed when destroying the stage-2
    page-tables"
  Revert "KVM: arm64: Split kvm_pgtable_stage2_destroy()"

 arch/arm64/include/asm/kvm_pgtable.h | 30 -----------------------
 arch/arm64/include/asm/kvm_pkvm.h    |  4 +---
 arch/arm64/kvm/hyp/pgtable.c         | 25 ++++---------------
 arch/arm64/kvm/mmu.c                 | 36 ++--------------------------
 arch/arm64/kvm/pkvm.c                | 11 ++-------
 5 files changed, 9 insertions(+), 97 deletions(-)


base-commit: b320789d6883cc00ac78ce83bccbfe7ed58afcf0
-- 
2.39.5

