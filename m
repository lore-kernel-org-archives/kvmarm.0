Received: from confino.investici.org (confino.investici.org [93.190.126.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06B5A21FF2A
	for <kvmarm@lists.linux.dev>; Wed, 24 Jun 2026 16:00:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=93.190.126.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782316856; cv=none; b=ajC+vqBerSUWI5f9hMLWA5x/03jbVrvGVaO8dywzMiKMrRFvXVBZOK0dQ6myptkbBzyyNKbTci+O9i3+KDtyQr5ytG5R297JR5BfHqTCoP4XLS7Un8n2uGyoDnQAacM/0JEDoGEWku1wkI2LUMoyfi3FW9jYriCVtCvYdWkCj44=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782316856; c=relaxed/simple;
	bh=MLAz780TLQyTEjsDsSCQW1RACoFxlCiPt56cnGIzqHg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=rkzyrPCn0F/hb9FZMc+0Acr24ULibbXY9jf72+ekC68CJlktLT0MgW2LoMmhCYI/Q1Dyu7AplwWA0W8f7FVbNmfj6wIcXElHQ0z2QsH9uYxB3/0Qyxr6Yu+ZpS+P/0lcqY1QriBwYhC2kTcrQLQRGmufNXKaWE5WMxfhr0KuT24=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=grrlz.net; spf=pass smtp.mailfrom=grrlz.net; dkim=pass (1024-bit key) header.d=grrlz.net header.i=@grrlz.net header.b=WXGfyhLO; arc=none smtp.client-ip=93.190.126.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=grrlz.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=grrlz.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=grrlz.net header.i=@grrlz.net header.b="WXGfyhLO"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=grrlz.net;
	s=stigmate; t=1782316847;
	bh=O7GEdAiyDOwyLdF7enDZh1aPgl+/ZJvbV+Kk7bU5e7Y=;
	h=From:To:Cc:Subject:Date:From;
	b=WXGfyhLOSN9iYMPngnr6gWVCGMvyhzd8+T/Kkm7C9Ioqs3REsr+2dLVS2cZgPmnmf
	 kAIgCFPDbfKj6s4biQTogPMknehIbHHP+aAMLxkNlRuvZ0cPx5SA/iX9QkUtNyzLQD
	 RqyzGIKKgu81fKG3vR7KBmapJLyUgvp03yrG2GyU=
Received: from mx1.investici.org (unknown [127.0.0.1])
	by confino.investici.org (Postfix) with ESMTP id 4glmqy72M4z10qk;
	Wed, 24 Jun 2026 16:00:46 +0000 (UTC)
Received: by mx1.investici.org (Postfix) id 4glmqx0sBTz10rF;
	Wed, 24 Jun 2026 16:00:45 +0000 (UTC)
From: Bradley Morgan <include@grrlz.net>
To: Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>
Cc: Fuad Tabba <tabba@google.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Quentin Perret <qperret@google.com>,
	Vincent Donnefort <vdonnefort@google.com>,
	Gavin Shan <gshan@redhat.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Bradley Morgan <include@grrlz.net>
Subject: [PATCH v3 0/3] KVM: arm64: fix pKVM mapping cache corner cases
Date: Wed, 24 Jun 2026 16:00:25 +0000
Message-ID: <20260624160028.15591-1-include@grrlz.net>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This is a standalone v3.

Patch 1 fixes pKVM cache maintenance for non cacheable mappings without
growing struct pkvm_mapping.

Patch 2 fixes a pKVM mapping cache topup bug on permission faults that
replace page mappings with a PMD mapping.

Patch 3 fixes the generic dirty logging case where a permission fault
can still need a page table allocation to split a block mapping.

Changes in v3:
- Send as a standalone series with a cover letter.
- Store the pKVM cacheable bit in nr_pages instead of adding a bool.
- Drop stable from patch 1.
- Add patch 3 for dirty logging permission faults.

Changes in v2:
- Add patch 2 for the pKVM permission fault mapping cache bug.

Bradley Morgan (3):
  KVM: arm64: skip pKVM cache flushes for non cacheable mappings
  KVM: arm64: top up pKVM mapping cache for permission faults
  KVM: arm64: top up stage 2 memcache for dirty logging faults

 arch/arm64/kvm/mmu.c  | 32 +++++++++++++++++++--------
 arch/arm64/kvm/pkvm.c | 51 ++++++++++++++++++++++++++++++++++---------
 2 files changed, 64 insertions(+), 19 deletions(-)

-- 
2.53.0
