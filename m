Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.218.175.176
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795430113;
	b=SnagUT/6jnlDd1WoEbsw0rqAPFqSqopjqrG5XKuaIJCRA2poIDbvo9P6m393IYDek2KO
	 2MdGXT2DweqNNdw0H1WzuezHGU1nJWeT3eKylcfkNPNPd/BZedv9kZ/CnutN6vWJd/y/O
	 RuEUNGpjYpYkJPZvzMCwHEnpPcCnQZIJ7PzpJz5far204mtt1CV7prGPch0ok33XvlJ+Q
	 Kf2f0Vbc6TFGhMr4i+9+mUz5wuq8CX3m92x2zF4zVR3oOvHjp8Dp8k0L0F4kEnIJv3qul
	 i5eja1BWDKvV+/y6oGlm9VouGp/0KmxFp1MQeXQgTDG65RNVtC9CBfGjpflYrQQPdqQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795430113;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=JNegrRp/NUexDN4FEoZ14wbn4iQ1tVQRQNeyZoOBH0s=;
	b=fGISI47ziHKTnXqQJPAC+LQn15zLTUYAHt94EC0hqdmkhR21yJ6i4gNxCDdkbEuU2Rus
	 R6KoT5ICT9R+q3DfmAhIZ/8okQ+i2iPg+9n2muo7S2nAvKxk0nJnZk1UQgaqfXjrOQE0H
	 y3NSy900R1BWzcoubDl5YklzE7YDNcVpPKMiRxXzV+v97vAmNqnkL0y14fBB0GtbSfioz
	 nWBY35ATiCSPR2U6TDE6R4mSO6uMH/+0EDI5snpqj+wtcqXcvXiE0+4qGoI4bIFG4sUdT
	 nOfF21gCIXgRqFI0Msrc1sMm+BWk2Q3wlHNoIzyZkDYQ3SkNjkX19khQdJZnYiOQKQQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=SYrvy0AS;
	arc=none smtp.remote-ip=91.218.175.176
Received: from mta0.migadu.com (out-176.mta0.migadu.com [91.218.175.176])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66171606A31A
	for <kvmarm@lists.linux.dev>; Mon, 23 Nov 2026 10:35:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 66171606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=SYrvy0AS
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=e7GMFbIO7ODomw2VAv04MqAxjpRjG/NYtGRnw2lyuKg=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795430106; v=1; x=1796034906;
 b=SYrvy0ASAPN+lXMAw9H6wJ54CZ9CpGKQvuFNzNEBiyy94HfcboOjPeUUBGE67SRgF17ViSPq
 Lg/k6p9ZIQ+tNriw09l49gWMUDVi0buVYKbmYhsLjFEz1o/tN8/nCu6N/eaSgue8k5ZgmUBBza/
 6w2V2c6SV+Jr+4B7qflrlSdg=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id 1b19a606ff982d8d;
	Mon, 23 Nov 2026 10:35:06 +0000
X-Mizu-Trace-ID: 1b19a606ff982d8d
X-Migadu-Flow: FLOW_OUT
From: Fuad Tabba <fuad.tabba@linux.dev>
To: Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>,
	kvmarm@lists.linux.dev
Cc: Joey Gouly <joey.gouly@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Gavin Shan <gshan@redhat.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Vincent Donnefort <vdonnefort@google.com>,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	Fuad Tabba <tabba@google.com>
Subject: [PATCH 0/2] KVM: arm64: Fix stage-2 THP mapping on hosts with 2-level page tables
Date: Mon, 23 Nov 2026 10:35:03 +0000
Message-ID: <20261123103505.1006067-1-fuad.tabba@linux.dev>
X-Mailer: git-send-email 2.47.3
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi folks,

A fix for how KVM maps a THP at stage-2 on a host with 2-level page
tables (64K pages with a 42-bit VA, or 16K pages with a 36-bit VA).
There, KVM also maps the host memory that follows a THP into the guest
if the guest's first access to the THP isn't to its first page.

transparent_hugepage_adjust() is meant to round the faulting pfn down to
the start of the THP, but its mask is a no-op when the PMD level is
folded, and has been since THP support was added. Before 6f745f1bb5bf2
("KVM: arm64: Convert user_mem_abort() to generic page-table API"), KVM
mapped only the THP anyway, which is why the Fixes: tag is on that
commit. Kernels before f583a53c2b8a ("KVM: arm64: Make fault_ipa
immutable") round the IPA with PMD_MASK, so only the pfn line of the fix
applies there.

Tested on QEMU with a 64K, 42-bit VA host kernel, where the new
selftest scenario fails without the fix and passes with it.

Based on Linux 7.4-rc3 (aebb727447640).

Cheers,
/fuad

Fuad Tabba (2):
  KVM: arm64: Fix THP block mapping when the PMD level is folded
  KVM: arm64: selftests: Test a THP whose first fault is on a tail page

 arch/arm64/kvm/mmu.c                          |  4 +-
 .../kvm/arm64/stage2_block_transitions.c      | 56 ++++++++++++++++++-
 2 files changed, 55 insertions(+), 5 deletions(-)


base-commit: aebb7274476403040d582c61478df8f4a7bf9cd3
-- 
2.47.3

