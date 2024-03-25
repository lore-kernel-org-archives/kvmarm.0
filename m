Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B9C4803
	for <kvmarm@lists.linux.dev>; Mon, 25 Mar 2024 18:52:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711392726; cv=none; b=Ekp97Tx824tbltujRAC3e8k8JBWXWcYN7pFcwPaD18Jz4c57xJZNm4NCQQKdTIcR5L4lYRcikXu6MDAZtMAKdSMNkB6FoGBfZhp4yJ0/ViCFUEbZkTaeEZd2rGN9Lpr6gqWjU7B8sRajk3LAh+Z13k+ZOxdrwnOHcZ87EjhPSOY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711392726; c=relaxed/simple;
	bh=g8uz/U8Njg1WxnGlsVM2zF+urx9kV1G9+8S/QPAj/UQ=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=fJtFoiri5rb7SOYhzj/k6GCfDpDw4HMmX5IPrPuNLaji0RQi6XO6SNabLiN3UOC3/H1WjxXNSVQoZPUpK41pwEGKr6KemLZ6App8fxJkMdDftJcFz7o9//r6WhuCwv+kY0KolFnHQ27Uusg8K9K98MxDOCEcQsO9dqeptjl56fg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mKAqW91S; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mKAqW91S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7AC37C433C7;
	Mon, 25 Mar 2024 18:52:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711392726;
	bh=g8uz/U8Njg1WxnGlsVM2zF+urx9kV1G9+8S/QPAj/UQ=;
	h=From:To:Cc:Subject:Date:From;
	b=mKAqW91SJoDN1UFTN1KWAL1kqmdfmln5/PCgIYh6/hWqVcYcLOfLXZnNK0Tj4PCii
	 Q01oeVZ50iyIVZpmxSKATs24jkpYQyQltl1JRU8LPisn7MakU4W8SSnmWfnUAZ7g+b
	 AZy8uEEBYwgeLrjAORJ6URoT25rFkOtNiUIptSe/q3dFmuAuTLLMw/HhmgemHytb2h
	 lWruvMZHHAk/H4xWccAkg7sTeA2y0EOYeIsMeKw4QIiLgI9wkZbT4AAi7vvUAjGrOB
	 ynTz842nOUBmrlTKNdU6aRXgbHey77fEIWWaiwo03Tg/3TAM7lPrDapzDn3Ij773Rk
	 EhhwPaimfVB3g==
From: Will Deacon <will@kernel.org>
To: kvmarm@lists.linux.dev
Cc: linux-arm-kernel@lists.infradead.org,
	Will Deacon <will@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Gavin Shan <gshan@redhat.com>,
	Marc Zyngier <maz@kernel.org>,
	Mostafa Saleh <smostafa@google.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Quentin Perret <qperret@google.com>,
	Raghavendra Rao Ananta <rananta@google.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Shaoqin Huang <shahuang@redhat.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: [PATCH 0/3] KVM: arm64: TLBI fixes for the pgtable code
Date: Mon, 25 Mar 2024 18:51:55 +0000
Message-Id: <20240325185158.8565-1-will@kernel.org>
X-Mailer: git-send-email 2.20.1
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi folks,

While debugging something else, I noticed a few TLBI oddities in KVM's
page-table code. These were found by inspection, so please have a good
look as I may be mistaken.

Patches against -rc1.

Cheers,

Will

Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Gavin Shan <gshan@redhat.com>
Cc: Marc Zyngier <maz@kernel.org>
Cc: Mostafa Saleh <smostafa@google.com>
Cc: Oliver Upton <oliver.upton@linux.dev>
Cc: Quentin Perret <qperret@google.com>
Cc: Raghavendra Rao Ananta <rananta@google.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Shaoqin Huang <shahuang@redhat.com>
Cc: Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: Zenghui Yu <yuzenghui@huawei.com>

--->8

Will Deacon (3):
  KVM: arm64: Don't defer TLB invalidation when zapping table entries
  KVM: arm64: Don't pass a TLBI level hint when zapping table entries
  KVM: arm64: Use TLBI_TTL_UNKNOWN in __kvm_tlb_flush_vmid_range()

 arch/arm64/kvm/hyp/nvhe/tlb.c |  3 ++-
 arch/arm64/kvm/hyp/pgtable.c  | 12 ++++++++----
 arch/arm64/kvm/hyp/vhe/tlb.c  |  3 ++-
 3 files changed, 12 insertions(+), 6 deletions(-)

-- 
2.44.0.396.g6e790dbe36-goog

