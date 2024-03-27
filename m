Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89DD01E521
	for <kvmarm@lists.linux.dev>; Wed, 27 Mar 2024 12:48:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711543739; cv=none; b=bJV0OKGGF/ajk7CAFzSk0aLSDCsVovRM3FOqdb/U975tNozGL7X1jc31b/Y+dWXp7jlglHy1/TLWYVE1cNNKIax/dOZnelF8LzcE5fXfTbpwMli7E///Ti2OawHmE4a4RdE5fRvxYrBANeAzfKh/v6gIS2T80de7wrEoSxTc4tM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711543739; c=relaxed/simple;
	bh=fuAcbl1HUcDciZWkZFFDkTuXy9Ebs9u1HiWJgXNc2Mw=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=p3SSXvsknZA0YBJr6fiZ8uFbb74oG75pmPKOQqNeAF6GQP7xxQdN+wOpDFLOzj3GyeJMlUUOTvzvnBWyG42h+W3zuZYxMeH6FmByfDc+0pCzTyTCaURbXGM0xD7929jE2apdcBI+cjMou7BLbPuW2mf9DkWFqHCSzLSPAsnSH2w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=E36lGumE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="E36lGumE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0200C433C7;
	Wed, 27 Mar 2024 12:48:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711543739;
	bh=fuAcbl1HUcDciZWkZFFDkTuXy9Ebs9u1HiWJgXNc2Mw=;
	h=From:To:Cc:Subject:Date:From;
	b=E36lGumE0/pL970qKfZoqn/wk3TA+5a0Ze+dmjy4b5hS+GEPt04zRkwX43llnpc6U
	 qN5GaUePeJs6dRm0nnXhllrDy3zc+BLQsdVDkj7OtoJDSiAMTbNUWKINAC+8VLnT+U
	 yVqSmK0q5H99tO3rg9YO+4zMHVhAMy8Wg9Wzffz/1P06qG2yN6Wi5GB6MSBPiY8+9T
	 CEEkSXtQPnkVwn8pKGeshIuqI6J06zutHQyOKU2pR15Q7ufQGrUJmp8QMbzqEcUuNk
	 skVfOFHrPnuhErzZ9hsdEt/yM9CgWaj3IRbKxBMEKzPz9ZftDwrpbqiXtiru1DKFwu
	 nZwq43zHfL66w==
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
	Shaoqin Huang <shahuang@redhat.com>
Subject: [PATCH v2 0/4] KVM: arm64: TLBI fixes for the pgtable code
Date: Wed, 27 Mar 2024 12:48:49 +0000
Message-Id: <20240327124853.11206-1-will@kernel.org>
X-Mailer: git-send-email 2.20.1
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi again,

This is version two of the series I previously posted on Monday:

  https://lore.kernel.org/r/20240325185158.8565-1-will@kernel.org

We've got a long weekend coming up in the UK, so I wanted to get this
out before I chuck the laptop in the river.

Changes since v1 include:

  * Add Ryan's Reviewed-by on the third patch
  * Add an extra patch to ensure correct alignment of range TLBI address
    argument
  * Tweak commit messages

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

--->8

Will Deacon (4):
  KVM: arm64: Don't defer TLB invalidation when zapping table entries
  KVM: arm64: Don't pass a TLBI level hint when zapping table entries
  KVM: arm64: Use TLBI_TTL_UNKNOWN in __kvm_tlb_flush_vmid_range()
  KVM: arm64: Ensure target address is granule-aligned for range TLBI

 arch/arm64/kvm/hyp/nvhe/tlb.c |  3 ++-
 arch/arm64/kvm/hyp/pgtable.c  | 23 +++++++++++++++--------
 arch/arm64/kvm/hyp/vhe/tlb.c  |  3 ++-
 3 files changed, 19 insertions(+), 10 deletions(-)

-- 
2.44.0.396.g6e790dbe36-goog

