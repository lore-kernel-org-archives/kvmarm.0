Received: from out-175.mta0.migadu.com (out-175.mta0.migadu.com [91.218.175.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25B9EEEBA
	for <kvmarm@lists.linux.dev>; Mon,  7 Oct 2024 23:30:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728343843; cv=none; b=r2We8HDChbQrEf2VHQjYaFhoOptsDs+ixULOVxn057XOV9eSTmE+zdP/vlHO7nq0hr+mxWJNd9MUWAYwZ0zVJhDSTM9ITUIk2afF85v8UFnG6DAaYGt3xfxWNGXYZ1U75nlkp2fBQxJtzu4Triwzso/RrVPs6nkDbceVtGdnG7s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728343843; c=relaxed/simple;
	bh=kXfKiJf80PgkK+au8SbdsU/ZSfDA2zAJ8In0scEqVfI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=TLMJIdH8kwqyaOswFXqxhM4fns4irTOqQO12wpNId1+91TGa0f/VR7DkjRVye/71v1xJrmgXlmArBTQOtWatEBt7smmgAey2uv7eoh6JENhN5BJg6u85H5ZSyU7JBEn86NPqXlatAqSx70DsLS22viZVv+b1m3onbHgod8H41qE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=nhW+8F+G; arc=none smtp.client-ip=91.218.175.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="nhW+8F+G"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1728343837;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=xE3XZ1SyfUUdqpk9+5R35FRkLsxG9nsC6cVBwvtb8MI=;
	b=nhW+8F+GsDdi/jqmWpDxgV/PnKJlGFo4+s+LQ/I8aFzK67cHPreYrZ/en5M/maK26V+r6Q
	5Y0lHnXqJiSN+YBJloFX7PU1jFYtvWf3iwyQV7W09cPzdOfMOq5jAb7OprAty/7+ZuQ+Zv
	h5HLU4AAQ01RX+e+A+e45RcRFa/rK2k=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Sean Christopherson <seanjc@google.com>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH v3 0/4] KVM: arm64: nv: Fixes for stage-2 MMU recycling
Date: Mon,  7 Oct 2024 23:30:24 +0000
Message-ID: <20241007233028.2236133-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

v2 -> v3:
  - Avoid 4 byte hole in struct kvm_s2_mmu (Marc)
  - Clarifying comments (Marc, Sean)

[*]: https://lore.kernel.org/kvmarm/20241007164256.1795250-1-oliver.upton@linux.dev/

Oliver Upton (4):
  KVM: arm64: nv: Keep reference on stage-2 MMU when scheduled out
  KVM: arm64: nv: Do not block when unmapping stage-2 if disallowed
  KVM: arm64: nv: Punt stage-2 recycling to a vCPU request
  KVM: arm64: nv: Clarify safety of allowing TLBI unmaps to reschedule

 arch/arm64/include/asm/kvm_host.h   |  7 ++++
 arch/arm64/include/asm/kvm_mmu.h    |  3 +-
 arch/arm64/include/asm/kvm_nested.h |  4 ++-
 arch/arm64/kvm/arm.c                |  2 ++
 arch/arm64/kvm/mmu.c                | 15 ++++----
 arch/arm64/kvm/nested.c             | 53 +++++++++++++++++++++++++----
 arch/arm64/kvm/sys_regs.c           | 33 ++++++++++++++++--
 7 files changed, 98 insertions(+), 19 deletions(-)


base-commit: 9852d85ec9d492ebef56dc5f229416c925758edc
-- 
2.47.0.rc0.187.ge670bccf7e-goog

