Received: from mta1.migadu.com (out-134.mta1.migadu.com [95.215.58.134])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 531733C0607
	for <kvmarm@lists.linux.dev>; Sun, 11 Oct 2026 14:36:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.134
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791729415; cv=none; b=nZ5LztT1As7ATtSB7fgTolfPIM7N+a8Om7GxapKUyRu60j1eUOLeE40YqkGQca52z0iUVaGO8S/4QFR0XYmjKpC432yHiWpDjQ2cx0z3iUxjsK7IftGuq1icEy3FhU5nS8ECyzR4LrT0RETNcuE2aNm73zIxhxv84H6E/FrKAHc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791729415; c=relaxed/simple;
	bh=CRdHQKf2EEAmNtXTa5VZLbwsCxrmJ7LgKsNYjdP6aes=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=s/Bqfio6cnh81QrE5DFnkkW9rgiVA+zDmLueKUoF+EqDc+L5brLgo+G5AzqPwaUK9T3kXsDI2ehZwhhPeULdlncqdOAEZeeeO/96ePGb4Iy/mhOuuDSPb4N/MnSpLdf0L/AYudVC/VAOqmXTecAgSWcqRMV99EXroYE7YoZgyCo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=qRT8XHQO; arc=none smtp.client-ip=95.215.58.134
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="qRT8XHQO"
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=CRdHQKf2EEAmNtXTa5VZLbwsCxrmJ7LgKsNYjdP6aes=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1791729409; v=1; x=1792334209;
 b=qRT8XHQOUegM6wfihbr59xqpKbc8boLbuogT+WVuKsm/YCkzRjLMVjcgegqifVyU6mxLkvtR
 YcJ8VxXbRoz52lRud5754Y8brYqEgF+FXM/OFObTBlWPHhk6UHsP8X4m0WUo1LaF2Ze2iJPJ0J1
 S6G8ZLyyh81oFLq5gi+zMwWY=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id a357e2b5f7edf0ea;
	Sun, 11 Oct 2026 14:36:49 +0000
X-Mizu-Trace-ID: a357e2b5f7edf0ea
X-Migadu-Flow: FLOW_OUT
From: Fuad Tabba <fuad.tabba@linux.dev>
To: maz@kernel.org,
	oupton@kernel.org,
	kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Cc: catalin.marinas@arm.com,
	will@kernel.org,
	joey.gouly@arm.com,
	seiden@linux.ibm.com,
	suzuki.poulose@arm.com,
	yuzenghui@huawei.com,
	mark.rutland@arm.com,
	vdonnefort@google.com,
	qperret@google.com,
	Sascha.Bischoff@arm.com,
	steven.price@arm.com,
	tabba@google.com
Subject: [PATCH v2 0/5] KVM: arm64: pKVM host hypercall and GICv5 CPU interface fixes
Date: Sun, 11 Oct 2026 15:36:43 +0100
Message-Id: <20261011143648.211337-1-fuad.tabba@linux.dev>
X-Mailer: git-send-email 2.39.5
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi folks,

Changes since v1 [1]:
  - Dropped the two __kvm_adjust_pc() fixes (v1's patches 4 and 5),
    which went into kvmarm/next with the pKVM core series [2].
  - Minor wording fixes to a comment and the commit messages. (Joey)

Patches 1 and 2 move the GICv5 CPU interface save/restore and the
stage-2 flushes into the band the dispatcher rejects once pKVM has
finalised, since the host has no use for them in protected mode.
Patch 3 validates the vgic model EL2 copies from the host. Patch 4
stops nVHE from accessing the GICv5 CPU interface from EL1, and patch
5 fixes two stale comments.

The GICv5 residency and VDPEND hypercalls in kvmarm/next still check
for pKVM in each handler. I'll move them into the same band once this
lands.

Based on Linux 7.3-rc3 (fd73f4a665989). On kvmarm/next, patches 1 and
2 have a minor conflict: new hypercall IDs sit next to the ones they
move.

Cheers,
/fuad

[1] https://lore.kernel.org/all/20260915123846.2317931-1-fuad.tabba@linux.dev/
[2] https://lore.kernel.org/all/20261001135711.1640520-1-fuad.tabba@linux.dev/

Fuad Tabba (5):
  KVM: arm64: Reject the GICv5 CPU interface hypercalls under pKVM
  KVM: arm64: Reject the stage-2 flush hypercalls under pKVM
  KVM: arm64: Validate the host-provided vgic model in pKVM
  KVM: arm64: vgic: Do not access the GICv5 CPU interface from EL1
  KVM: arm64: Fix stale VGICv3 comments in the nVHE world switch

 arch/arm64/include/asm/kvm_asm.h   | 16 ++++++++--------
 arch/arm64/kvm/hyp/nvhe/hyp-main.c | 15 ++++++++-------
 arch/arm64/kvm/hyp/nvhe/pkvm.c     | 10 ++++++++--
 arch/arm64/kvm/hyp/nvhe/switch.c   |  4 ++--
 arch/arm64/kvm/vgic/vgic.c         | 12 ++++++++----
 5 files changed, 34 insertions(+), 23 deletions(-)


base-commit: fd73f4a6659897191fa0d40695fe370925dd3780
-- 
2.39.5

