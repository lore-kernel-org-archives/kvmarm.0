Received: from out-178.mta0.migadu.com (out-178.mta0.migadu.com [91.218.175.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7324186A
	for <kvmarm@lists.linux.dev>; Sat, 24 Aug 2024 00:14:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724458459; cv=none; b=L0Ru/ELFlrpl2JSeRO+Ln5kNv34QE77FetppzL+IDb+uO/81nHUCJoJ+vRyLJ7WypOszXhJDZKhpQQ9BgL08iZ6QNVwC46Ks6mFk+YghhIodKUvQzEsvHnsDiUkwuQc0AW6OWR4EsgkDmG+iIIpBkyKIGygH7TFOfVY25mxcWX4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724458459; c=relaxed/simple;
	bh=j7TrpWJmxiT8kl0l/12eQsczyyB8BbIqNPuCP5/dx0g=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=XBWXJVhSDS3odm6nx+2rd0YaNtwMbOGouWP2yHgS/zYjXuYSk8IANQz0Rfy+AdO3swm5p6gJ5De8ooUJtLvwkzKD6stNx1+VMbToledh6mMtVc3x0snZR4EQqBBriEmEahpLLLsNdOcVMfx1wa47xYLlwRj+xTEYqS80V9xB4Bs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=LKDMiWKA; arc=none smtp.client-ip=91.218.175.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="LKDMiWKA"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1724458454;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=yxSpvc6ZRzelzKb4uY83xmlYL3M/8jZ2CVDrwjVVeSY=;
	b=LKDMiWKAp0YkqIHxl7q1D8O1JFUqGjAE3oF6MfOPSyUP8+bWu8gT1oxPqrrtZ3ryWqdrfW
	/a/FgZcv/Du50HOMcCMnxoiGvFftIBCXOVqJ/tOJh/wp4Pi8jikvfuwjPSEwb4lw8qXo/E
	8LNVsrVFkMxOeC5xSdSG4ucPpjka+5s=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH 0/3] KVM: arm64: nv: Add EL2 PMU event filtering support
Date: Sat, 24 Aug 2024 00:13:59 +0000
Message-ID: <20240824001402.3909504-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

We allow a nested VM to be configured with a vPMU, although it isn't
entirely functional. We do not currently respect the EL2 event filter
configuration from the guest hypervisor, which really needs to be
applied to EL1 when in a hyp context.

Series to do just that. Tested on Neoverse-V2 which fortunately
implements PMUv3 and NV, unlike the fruity stuff I'm typically using...

Oliver Upton (3):
  KVM: arm64: Add helpers to determine if PMC counts at a given EL
  KVM: arm64: nv: Honor NSH filter when in hyp context
  KVM: arm64: nv: Reprogram PMU events affected by nested transition

 arch/arm64/kvm/emulate-nested.c |  4 ++
 arch/arm64/kvm/pmu-emul.c       | 77 ++++++++++++++++++++++++++++-----
 include/kvm/arm_pmu.h           |  3 ++
 3 files changed, 72 insertions(+), 12 deletions(-)


base-commit: 7c626ce4bae1ac14f60076d00eafe71af30450ba
-- 
2.46.0.295.g3b9ea8a38a-goog

