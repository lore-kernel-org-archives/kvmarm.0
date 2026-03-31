Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8706C421898
	for <kvmarm@lists.linux.dev>; Tue, 31 Mar 2026 15:51:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774972289; cv=none; b=VgVhl/sWJAaeF9V5mqMhEE+K6mPbg+VEnxr7YMIjXlujURNmJG/vgwr2EfiDls5Pr0v6FBxN6W8q4oFPCZvUTKqTI3Xi+oJejs7qaVMMXXhRfJpg4Z97V7lIg6hXs9esjbATNqCqdRFarArfBpTDqaRIjGgeRvs4YibPyI1N/6M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774972289; c=relaxed/simple;
	bh=5h/uBM2muFZOCKdtTFVzBEJDVsBTI93hti/zrJ4A0Zs=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=NxAzP7Vj7UQgQVBC9QQABk2fTg5thiSCZSw3LOYjM+CD92Oa4pI8oXgiedDn+j3RQm+4Ni/6tT2hYn6hjDnL/bz06Gi3nnlLl7oxryOnwAKbqdsAd0V+WUVAvW5ldOQPvOCkQRkMLO7SuCEWBey7XpVzImx7cB35cpGCcwRcayc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=vD15Zsec; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="vD15Zsec"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD7CAC19424;
	Tue, 31 Mar 2026 15:51:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774972288;
	bh=5h/uBM2muFZOCKdtTFVzBEJDVsBTI93hti/zrJ4A0Zs=;
	h=From:To:Cc:Subject:Date:From;
	b=vD15Zsec7YKIv06fB6PSU9ZilFccjTHPkKbSw+EnLIdFOcoL9W/pj21x3l8hwKkKi
	 7dzwTzQzfr5lSsZ4P9BHAbuP6fNe0SjU0mk4/24Gl7C0RqISyau5MdwFVlzZqb2m2b
	 mMqGEXsuRaQAsds+8/L/Uft8eszCvUAo65B2kUsKDJJ63YyD8CIwAgrvP15XzPmQUh
	 2RhjLS30GvAu1F14D48MbBa9Y0b7tyPgd9IfBct7c5SZ3ksPymAVY7LZLtEaj3Sfy1
	 eAjXB9GjhXoX67AFKcZX/eNr1CSzFmuIdnKIoYgCD2lKeFUQDVCbqTixc/YTe47UNh
	 p6T2Ag6cqgDgA==
From: Will Deacon <will@kernel.org>
To: kvmarm@lists.linux.dev
Cc: linux-arm-kernel@lists.infradead.org,
	Will Deacon <will@kernel.org>,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Quentin Perret <qperret@google.com>,
	Fuad Tabba <tabba@google.com>,
	Vincent Donnefort <vdonnefort@google.com>,
	Mostafa Saleh <smostafa@google.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>
Subject: [PATCH 0/3] KVM: arm64: Fix teardown of non-protected VMs with pKVM
Date: Tue, 31 Mar 2026 16:50:52 +0100
Message-ID: <20260331155056.28220-1-will@kernel.org>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi folks,

Sashiko continues to throw rocks at me.

This time, it spotted that my fix (introduced in v5 [1] of the pKVM
series) to prevent taking a reference on a VM in the 'is_dying' state
also prevents unsharing of pages shared with a non-protected VM if that
VM is torn down by its VM fd being destroyed, rather than the usual path
via the MMU notifiers.

Rather than send a v6 of the whole series, here are three patches that
apply on top of v5 and fix the issue by (a) preventing teardown of a
referenced VM and (b) allowing some references to be taken on a dying
VM. As an added bonus, this simplifies the locking on the reclaim path
because now a VM reference is enough to stop the page-tables from going
away.

Cheers,

Will

[1] https://lore.kernel.org/kvmarm/20260330144841.26181-1-will@kernel.org

Cc: Marc Zyngier <maz@kernel.org>
Cc: Oliver Upton <oupton@kernel.org>
Cc: Joey Gouly <joey.gouly@arm.com>
Cc: Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: Zenghui Yu <yuzenghui@huawei.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Quentin Perret <qperret@google.com>
Cc: Fuad Tabba <tabba@google.com>
Cc: Vincent Donnefort <vdonnefort@google.com>
Cc: Mostafa Saleh <smostafa@google.com>
Cc: Alexandru Elisei <alexandru.elisei@arm.com>

--->8

Will Deacon (3):
  KVM: arm64: Prevent teardown finalisation of referenced 'hyp_vm'
  KVM: arm64: Allow get_pkvm_hyp_vm() to take a reference to a dying VM
  KVM: arm64: Don't hold 'vm_table_lock' across guest page reclaim

 arch/arm64/kvm/hyp/nvhe/pkvm.c | 53 +++++++++++++++++-----------------
 1 file changed, 26 insertions(+), 27 deletions(-)

-- 
2.53.0.1118.gaef5881109-goog

