Received: from out-180.mta0.migadu.com (out-180.mta0.migadu.com [91.218.175.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED84E3AFB13
	for <kvmarm@lists.linux.dev>; Mon,  6 Jul 2026 10:31:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783333899; cv=none; b=XKvKKRyO/2jdLuzh1gFOvIfBJvQs5uZjZB1UphzZKziZP+S4Gs0OkmVoGpatFEVTv7ONINyIBM4b8Gr7LtXUKIBEYvj4ig2xpFmGkv2EqtK4otYSyUCsCiMMyr0k3y7CDE6mSP4/rkFzxRTWeNvWmSk7uAh/1wkn+bPN571/xEE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783333899; c=relaxed/simple;
	bh=BzWmGmhDSX9H7Qwx2j4ifAMxfY7LvD8ZDgxYcBW2C8Q=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=aDTVCVA8jh41G1UqFI7/1dAm+uGJClRNUMaO4Mg+wdOa4UoLJCMyiAR4WtCIkaPQgtgi67OcC2gonPA4+a1+T5aCH/DejcvqPiBzeNoRIpUauKtFphWkTGoFFbEhrmpaTSdMIROYKk/b9L9RcKIYPsE1DZ50fr3ft5likliRpS8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=tgfxylSg; arc=none smtp.client-ip=91.218.175.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="tgfxylSg"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1783333893;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=UUV8G5l+8y4VKTIs3LKjPdf1ZbZ+/55y0GSb0c64wC0=;
	b=tgfxylSgq1mxGv3YhjrLl+pFCjKU4T+ERAUdE5N5foYO9rMA/IF+gR8jvB+botICUQdrZv
	iwDtl5MxnL7jVUaa6CclQoSkJvJREbo3SVqxklz2sp4jtssn+7fd2Tkn27kBSBySbJfZNF
	KT7LG7pBns2aH92snAv91lW9r56Z0lM=
From: Fuad Tabba <fuad.tabba@linux.dev>
To: Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>
Cc: Joey Gouly <joey.gouly@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Vincent Donnefort <vdonnefort@google.com>,
	Keir Fraser <keirf@google.com>,
	Hyunwoo Kim <imv4bel@gmail.com>,
	Fuad Tabba <tabba@google.com>,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 0/3] KVM: arm64: Tidy up is_created
Date: Mon,  6 Jul 2026 11:31:26 +0100
Message-Id: <20260706103129.706974-1-fuad.tabba@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Hi folks,

Changes since v1 [1]:
- Carried Keir's Reviewed-by. No code changes.

This small series tidies up the host-side kvm->arch.pkvm.is_created flag,
which tracks whether the hypervisor-side (EL2) VM has been instantiated.

It comes out of the ongoing pKVM (protected KVM) upstreaming work and runs
in parallel with it. The changes only remove dead or redundant code around
the flag, not any of the functional paths that work touches, so there is no
dependency in either direction and the two can be applied in any order.

is_created stays: the pKVM handle is reserved early (so host MMU-notifier
TLB invalidations have a valid handle before the first vCPU run), so a
non-zero handle no longer implies the EL2 VM exists. is_created is what
distinguishes "reserved" from "created", and the teardown path relies on it.
Only the cruft around it goes.

Cheers,
/fuad

[1] https://lore.kernel.org/all/20260618090128.3913688-1-tabba@google.com/

Fuad Tabba (3):
  KVM: arm64: Drop the unused EL2-side is_created write
  KVM: arm64: Remove unreachable early checks in pkvm_init_host_vm()
  KVM: arm64: Drop redundant READ_ONCE() in pkvm_hyp_vm_is_created()

 arch/arm64/kvm/hyp/nvhe/pkvm.c |  1 -
 arch/arm64/kvm/pkvm.c          | 13 +++++--------
 2 files changed, 5 insertions(+), 9 deletions(-)

-- 
2.39.5

