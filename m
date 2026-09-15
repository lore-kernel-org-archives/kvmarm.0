Received: from mta0.migadu.com (out-156.mta0.migadu.com [91.218.175.156])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 603DC43A812
	for <kvmarm@lists.linux.dev>; Tue, 15 Sep 2026 08:44:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.156
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789461886; cv=none; b=cFCcEJS5mHiOD3E5D+3tSyjbS4GkxxBNAeaNM6oG3/wyBe/YENKPZTnDa1q62N2s8RDxotFMRIlN014GNQS43IUWKkGShYiyQzVmvFhen19e2rJFH+XqW2tC3UQf2o8wPpiG4IlmJOYRzz1Nz4KO8UFrhIFmTZ+XzI3jjiJWvvs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789461886; c=relaxed/simple;
	bh=5VNjXBdl2JBF32g6/pFWNc4t2873DtQP3kDUrQxNzQc=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=KPl68kQjwMoHg8HY0yzbND7CkDUTS6DZYnvE4dyKwWgmKnUOMX1YdP8P22FFsWtE3oAaEvxaihURUFbEvOrCbaySpzMCTF7O1s60SfsBAXO5tmdI2EmrmRMXSKWYcjHd4folttjqIqa2c0h357Kt0XK9MbseJKvMT9l8JjDCLdc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=diFC/f5l; arc=none smtp.client-ip=91.218.175.156
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="diFC/f5l"
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=5VNjXBdl2JBF32g6/pFWNc4t2873DtQP3kDUrQxNzQc=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789461882; v=1; x=1790066682;
 b=diFC/f5lFbLNJYpoWifyzgIGcvjI9vZzJNepeCiqnWVLfh+Cn90Du9CxuGt+eXqsZzKfGZWa
 jypgTva2rJCEb3uFvn0yAusc/U8liDil5UwFczBDjxUKl9tMl+19rRlUs0ikchveX2g5lLcale0
 Xu8dY1wItei6OGfaHDyrwCA8=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id c21aa090cc761614;
	Tue, 15 Sep 2026 08:44:42 +0000
X-Mizu-Trace-ID: c21aa090cc761614
X-Migadu-Flow: FLOW_OUT
From: Fuad Tabba <fuad.tabba@linux.dev>
To: Paolo Bonzini <pbonzini@redhat.com>,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>,
	Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Sean Christopherson <seanjc@google.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Nicholas Piggin <npiggin@gmail.com>,
	Will Deacon <will@kernel.org>,
	Fuad Tabba <tabba@google.com>,
	kvm@vger.kernel.org,
	kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	linux-doc@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 0/3] KVM: Replace VCPU_RUN with KVM_RUN in comments and docs
Date: Tue, 15 Sep 2026 09:44:38 +0100
Message-Id: <20260915084441.3846947-1-fuad.tabba@linux.dev>
X-Mailer: git-send-email 2.39.5
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi folks,

This one has been bugging me for a while. Five comments and doc lines
name a VCPU_RUN ioctl (KVM_VCPU_RUN in book3s_hv.c, VCPU RUN in
kvm_host.h). The ioctl that enters the guest is KVM_RUN.

The patches are independent and split by tree, one each for generic
KVM, KVM/arm64 and Book3S HV, so each can go through its own
maintainer. Nothing else in the tree refers to the ioctl by a wrong
name.

Based on Linux 7.3-rc3 (fd73f4a665989).

Cheers,
/fuad

Fuad Tabba (3):
  KVM: Fix comments that refer to the non-existent VCPU_RUN ioctl
  KVM: arm64: Fix references to the non-existent VCPU_RUN ioctl
  KVM: PPC: Book3S HV: Fix comment naming a non-existent KVM_VCPU_RUN
    ioctl

 Documentation/virt/kvm/arm/pkvm.rst | 2 +-
 arch/arm64/kvm/arm.c                | 2 +-
 arch/powerpc/kvm/book3s_hv.c        | 2 +-
 include/linux/kvm_host.h            | 2 +-
 virt/kvm/kvm_main.c                 | 2 +-
 5 files changed, 5 insertions(+), 5 deletions(-)


base-commit: fd73f4a6659897191fa0d40695fe370925dd3780
-- 
2.39.5

