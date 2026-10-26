Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.140.110.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793025883;
	b=02EGUmMGD4EW2Nz2uqChIXvzYroZP7WN458WtBTTQPrZKVxZX2Xb3k1YrBBqNOKIiLAS
	 EbNzvzhSrJV629IdG8/IFALmbVXXuPJqfFHX+S/w3gOXbhamgS8ANLFWgEmipFV1q9/vr
	 x3kQLFGVXAS85oHsvNVIqGA2mu8tVEnC0jhd468BBhW/SwomKDU3b6rFZpk6oGwtWgTQc
	 r9l12xyi1IUoakOernKpjLp7+4y+33KrTrXUy6ER80/JmDj1ffwELeIfemdAzUz4B2JCV
	 pmXWoMnMZ02lwkepLbBYoAuD7HaVcBgcATfvMD9DIrESupHaojsObf3hyQ3tAKxG/TQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793025883;
	h=DMARC-Filter:Received:Received:DKIM-Signature:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:MIME-Version:X-Developer-Signature:
	 X-Developer-Key:Content-Transfer-Encoding;
	bh=2bC/tKvsMyQSFyWd/4grWajRGenpXtC7/e5rOkNlwlE=;
	b=5RQXTAg5sh+HFFbPUbhQ5uq9/DOFowMQpjbw5aWgKzr3UHvr3ISI35rF5Xh0tEkBTrVr
	 aydfErw4k9GXs6CaxAtjSbujynQDOFAM3YKaVRngT14WZJcmVSOTMJuAfQ+JDUyUIFhmh
	 pclITs4m+l675bZhiGk0AdZ5k9U2WL6iW0AXHGB6j6umYGYt2GzpRSMJ3BeP3xKk+Me8t
	 xt10oHqzqElPaFYz6kjLVpxFujr5t2eOr4y2BC1Vk9aB61vU3FUN7ijDhizn7/Gsnubb9
	 Em4Wof7/Rc1gVMrex8oIp+9dRXPM7lWqN7UrJ8/lf3XNU2sYMOmoHLWiSifhvXMob0g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=arm.com;
	spf=pass smtp.mailfrom=arm.com;
	dkim=pass header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=cc641w2U;
	arc=none smtp.remote-ip=217.140.110.172
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4A7B2606A31B
	for <kvmarm@lists.linux.dev>; Mon, 26 Oct 2026 14:44:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4A7B2606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=cc641w2U
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 6D1F415A1;
	Mon, 26 Oct 2026 07:44:38 -0700 (PDT)
Received: from LeoBrasDK.cambridge.arm.com (LeoBrasDK.cambridge.arm.com [10.2.212.21])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 932E83F7B4;
	Mon, 26 Oct 2026 07:44:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1793025881; bh=cXwGQ1sgxxKZyhdDrXpdQtNttNvD0RVFexoJ9R9VXl8=;
	h=From:To:Cc:Subject:Date:From;
	b=cc641w2UwlCKZjaZ6pVm4urYV48alptH2J9aWv5cKo5Wo1XqBvDykrSj2aRAF1H9i
	 5sGR5B/F9mKusRhXjgKIwz+SfGLvQJp9Dzctg82Pwl7Yp9JDNQ3UD0zpTgP0sbOIKI
	 y/kJZBx0ZBNZF5QpiXnZvHAD6GEi0iCyS14f6D4k=
From: Leonardo Bras <leo.bras@arm.com>
To: Oliver Upton <oupton@kernel.org>,
	Marc Zyngier <maz@kernel.org>,
	Fuad Tabba <fuad.tabba@linux.dev>,
	Joey Gouly <joey.gouly@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Leonardo Bras <leo.bras@arm.com>,
	Raghavendra Rao Ananta <rananta@google.com>,
	Tian Zheng <zhengtian10@huawei.com>
Cc: linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [RFC PATCH v2 0/3] Set DBM bit on writable pages
Date: Mon, 26 Oct 2026 14:44:06 +0000
Message-ID: <20261026144413.441566-1-leo.bras@arm.com>
X-Mailer: git-send-email 2.56.0
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2136; i=leo.bras@arm.com; h=from:subject; bh=cXwGQ1sgxxKZyhdDrXpdQtNttNvD0RVFexoJ9R9VXl8=; b=owGbwMvMwCX2pizjszvTwvWMp9WSGLLupxsaJqiuV//2b+8U5p99kl2hzS61uzMNn29+8EIr9 PfZwLlhHaUsDGJcDLJiiiyyj+av4vk+JePIlR8LYOawMoEMYeDiFICJ/F7IyDDpjlbE/mvLLW3a F9sVzTFn1cmZdlVw/gepVAshs0UTFu5jZFjdof9mzTn9Loub/25bWaR+uPTkvOrnlX+bt+6J8NG de4MLAA==
X-Developer-Key: i=leo.bras@arm.com; a=openpgp; fpr=36E6C95AE0F111CC5B6F4D2E688C33F8A0C5B0C5
Content-Transfer-Encoding: 8bit

When HAFDBS is enabled (VTCR_EL2.{HA,HD}={1,1}), having a DBM bit allows 
hardware to promote a non-writable page to writable by setting (S2AP[1]=1),
without having to take a fault.

The reason for this patchset is to add the DBM bit when setting-up writable 
pages, so the code is prepared for future patches that make use of 
HDBSS/HACDBS to accelerate dirty-tracking. Write-bit detection still 
happens based only in S2AP[1], so no change in that aspect.

Having DBM set on block entries is undesired, as we benefit from the first 
fault for splitting it in PAGE_SIZE entries, which is the granularity used 
to track the dirty pages in KVM. So introduce a new walker that, on top of 
clearing S2AP[1] for every entry, also clear DBM for block entries.

Also introduce a new VCPU request to reload Stage2, as it will be needed on 
future HDBSS/HAFDBS patchsets. 

Please let me know of what do you think!

Changes since RFCv1:
- Dropped patch #5 on enabling HAFDBS on non-dirty-tracking guests, as it 
  proved to be counter-productive on wrprotect, contrary to expectations
- No more moving writable-bit to DBM. That does not seem to be the intended 
  use. It makes sense and it's easier to convert code to new DBM approach.
- No new PROT_DIRTY, so drop patch #2
- Tried adding a PROT_DBM, but does not seem necessary to fault a page as 
  writable-clean. 
- KVM_REQ_RELOAD_STAGE2 now depends on VHE, as it already reloads Stage2 on 
  guest entry otherwise. 
Link: https://lore.kernel.org/all/20260901171558.2674031-1-leo.bras@arm.com/

Thanks!
Leo

Leonardo Bras (3):
  KVM: arm64: pgtables: Set DBM attribute on writable Stage-2 PTEs
  KVM: arm64: Introduce a dedicated walker for stage2 write-protect
  KVM: arm64: Add KVM_REQ_RELOAD_STAGE2

 arch/arm64/include/asm/kvm_host.h    |  2 ++
 arch/arm64/include/asm/kvm_pgtable.h |  3 +++
 arch/arm64/kvm/arm.c                 | 10 ++++++++++
 arch/arm64/kvm/hyp/pgtable.c         | 30 ++++++++++++++++++++++------
 4 files changed, 39 insertions(+), 6 deletions(-)


base-commit: c03c1a14507dfaf8b856c2608f9ac216021fc222
-- 
2.56.0

