Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.218.175.216
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793796296;
	b=25ime8ArEkRw33+KtYXhKRKbbWWxoDJcJt0l6AXAJzcH+uGpnAkukix7AExiQoSUcMAZ
	 QReyutsJFN0ZNRYBSeuZ+Q/PA1b6IGXa9AL1upo9cnMfWY3CHbGRIRTi4hPQjm3+SfegD
	 m7yLW4EGlGUNDMtHhG1s6JWUKI0x0WxZtdiuyzM7BoT0uNM6v4aKVCNbsWMRK/mS4b41L
	 4A7c0KcqD9kBxucnVMRrqNYF9WUiXduMWqAxubosyQI4012LTOBrdNA7ZjOE0Hl4bbBLI
	 c8CEMh9nGV+jFYpN5O09rBtaAjnGYsqJo8NfhF01pEk6woDqI63R/JpdMnsih3vmbPw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793796296;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=UcjFubjphnzFpUpHrLLrETqweYn/e3Sdi2+JtZw/B0I=;
	b=A8WUkGXPchVG0//r5YJjujKkCaMRPkcPqopR9mmz54Fuzxp5RVB2CilxwdbXcAwULm/g
	 2y3VhdV4jkY1fz5XjcfM27f9aq0dD8llW+UKs02QpgJtjT6aLxOl7Z3C5LhELQif6IODO
	 P9g0I5Z4KAiO+wH7QYrZu6QN8nu14KK7ZWOha8tHp96SUycFdDZ9sw7oCZmb/Gjbof8Dr
	 0e2KFS95JlLTStzOz3QYvMRe5NyE9PVnJdJADOGi/fXVIXIalRuIN6WfuRgI33/wYUHoP
	 OEnomOJWhjMdALR/zwwHrX6qls8mc9NCYxrfiHbliYAtPHHc4GPNd6ETsbtBlifUP2w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=V3DZfkWI;
	arc=none smtp.remote-ip=91.218.175.216
Received: from mta0.migadu.com (out-216.mta0.migadu.com [91.218.175.216])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 706BB606A31B
	for <kvmarm@lists.linux.dev>; Wed,  4 Nov 2026 12:44:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 706BB606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=V3DZfkWI
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=pL42GIo48cBII9Atlc96cBdXylzrs2P95YUPiNb6rRA=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793796292; v=1; x=1794401092;
 b=V3DZfkWIbPloGmUQ/qeDD6rSp4jbZu/KGxXnHYq7UlrPV5Q4kSA8MZgwpIxBJgOJpmBeDa4y
 X8nvMFn1i8Aq4TmsqVPbsGFEAoQps7HmWM1tssK1c3p+a+fLgUpBi8jVf4kPvtN532zQvP/1IfW
 8JSqa9IcrKA31EVmJscmC+Yo=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id d939a9b5ae201b1c;
	Wed, 04 Nov 2026 12:44:52 +0000
X-Mizu-Trace-ID: d939a9b5ae201b1c
X-Migadu-Flow: FLOW_OUT
From: Fuad Tabba <fuad.tabba@linux.dev>
To: Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>
Cc: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	Joey Gouly <joey.gouly@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Raghavendra Rao Ananta <rananta@google.com>,
	Vincent Donnefort <vdonnefort@google.com>,
	Fuad Tabba <tabba@google.com>
Subject: [PATCH v2 0/2] KVM: arm64: Stop stage-2 teardown scaling with the IPA size
Date: Wed,  4 Nov 2026 12:44:49 +0000
Message-ID: <20261104124451.2148724-1-fuad.tabba@linux.dev>
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

Changes since v1 [1]:
  - Run all teardown from stage2_destroy_range() (Oliver, Suzuki)
  - Dropped the Fixes tags (Marc)
  - Dropped the patch moving the teardown into kvm_vm_s2_ops
  - Use gfn_to_gpa() for a mapping's address. (Vincent)

Two patches that make stage-2 teardown take time proportional to what
is mapped, rather than to the size of the IPA space as it has since
4ddfab5436b6.

Under QEMU TCG ('-cpu max', 16K pages with LPA2), destroying even an
empty VM takes about 7 seconds in pKVM. Without pKVM it takes about 19
seconds if the VM requests a 52-bit IPA (crosvm requests the host's
limit). With the series, both take well under a second. I tested only
under QEMU, since I don't have hardware with LPA2.

The first has the page-table walk return where it stopped, so that the
teardown steps over an invalid entry larger than a block-sized chunk in
one go. The second has pKVM return where its next mapping starts.

pKVM gives every VM the host's IPA limit. My series honoring
KVM_VM_TYPE_ARM_IPA_SIZE in pKVM [2] doesn't change that for crosvm,
which requests the limit.

Based on Linux 7.4-rc1 (6628e7d4c6b25).

Cheers,
/fuad

[1] https://lore.kernel.org/all/20261103084742.1302597-1-fuad.tabba@linux.dev/
[2] https://lore.kernel.org/all/20260917091826.2639205-1-fuad.tabba@linux.dev/

Fuad Tabba (2):
  KVM: arm64: Resume stage-2 teardown where the walk stopped
  KVM: arm64: Resume a pKVM stage-2 teardown at the next mapping

 arch/arm64/include/asm/kvm_pgtable.h |  8 ++++++--
 arch/arm64/include/asm/kvm_pkvm.h    |  4 ++--
 arch/arm64/kvm/hyp/pgtable.c         | 15 ++++++++++++---
 arch/arm64/kvm/mmu.c                 |  4 ++--
 arch/arm64/kvm/pkvm.c                | 12 +++++++++---
 5 files changed, 31 insertions(+), 12 deletions(-)


base-commit: 6628e7d4c6b25c8d18f1345e3a20d21829aae7e4
-- 
2.47.3

