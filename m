Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B066E2ECD3A;
	Fri, 19 Jun 2026 11:54:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781870063; cv=none; b=N1YFjNw3GmYs9Cq/MQgPkL4VE/nXsYPltSPKhhQ/7jX1YTHzjqIY438neMiogc1g+E2GFJd3tf/Z8j+Q6pBQ4UijsQTdZVtaCPai7N5f5C2JVyEn/DBoZrMeiBQ6jh6PBXeIi0su750YJAgKJRj1O6kBe2LKCj9ONPovb+FBwac=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781870063; c=relaxed/simple;
	bh=TaB7IU+SAUU6AE8uI1s8uVsVWEYfaVAzHlfJgRR53KU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=LnUUXHP7kqQ6LJreK5xoMkLVLwHakGfdRlcM+eNPyQgmjAfQ2ocP7YmXBtjQMI1tkQ8/UoHs4DY22C/LLvUbkIPv2nbo41Cl4/f5m5nnHLfm41jS4diZVVCUzPuKtcLUETREuIu+qkidnPjLGGmEoKc+kamhdAonUqtpyc4CUe8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JYMMgS9P; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JYMMgS9P"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 975051F000E9;
	Fri, 19 Jun 2026 11:54:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781870062;
	bh=wI5lCzdD24y1tUAHodBMjAu7KCLaZmpSn7n1+PwTRdE=;
	h=From:To:Cc:Subject:Date;
	b=JYMMgS9P2aOxGn1hzP7N5OOlJZovaspLj4Dfa/3juDCRC5eOd54lAHE/Xm4+gYXkq
	 flzWYz0JF2NUYDL+x8FmvSHLugAeDTH25jhzXOtmioes2cjhJ5k8cmzouzpC8aYXbJ
	 o7ljmSzKzo7l7CnzY3+MLPq+b9QQV+KvqnvmpLvllrsK7fLB1XZrfzcmgVHI024sR9
	 0CtfIxyLdjMgFLwl6TMeqzikW+Y+upJQZBmDLslQuIf+Ne9aaGH6RUeFsLeBvFptzb
	 cERIUxQJcMjL4RcDNz1ySlxfx4vNtWJS1QL7lWe89/SqnaBD+H7mvSEVoD/e7nqaF/
	 2viezYTD2ypQg==
From: Will Deacon <will@kernel.org>
To: kvm@vger.kernel.org
Cc: kvmarm@lists.linux.dev,
	Will Deacon <will@kernel.org>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Andre Przywara <andre.przywara@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Marc Zyngier <maz@kernel.org>
Subject: [PATCH kvmtool 0/4] Add support for running protected VMs on arm64
Date: Fri, 19 Jun 2026 12:54:10 +0100
Message-ID: <20260619115415.5475-1-will@kernel.org>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi folks,

With a v7.1 host kernel, it is now possible to run protected VMs on
arm64 with pKVM enabled (kvm-arm.mode=protected). Although the pKVM
support is not yet feature complete, having kvmtool support is handy
for development and testing. So here it is.

The patches are also available here if you want to pull them directly:

  https://git.kernel.org/pub/scm/linux/kernel/git/will/kvmtool.git/log/?h=pkvm

Cheers,

Will

Cc: Alexandru Elisei <alexandru.elisei@arm.com>
Cc: Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: Andre Przywara <andre.przywara@arm.com>
Cc: Oliver Upton <oliver.upton@linux.dev>
Cc: Marc Zyngier <maz@kernel.org>

--->8

 arm64/fdt.c                         | 37 ++++++++++++++++++--
 arm64/include/asm/kvm.h             |  1 +
 arm64/include/kvm/fdt-arch.h        | 10 +++++-
 arm64/include/kvm/kvm-arch.h        |  2 ++
 arm64/include/kvm/kvm-config-arch.h |  5 ++-
 arm64/kvm.c                         | 20 ++++++++++-
 arm64/pci.c                         |  2 ++
 include/kvm/virtio.h                |  2 ++
 include/linux/kvm.h                 | 53 +++++++++++++++++++++++++----
 include/linux/virtio_ring.h         |  5 +--
 riscv/include/asm/kvm.h             | 11 +++---
 virtio/core.c                       | 12 +++++++
 virtio/mmio-modern.c                |  2 +-
 virtio/pci-modern.c                 |  2 +-
 x86/include/asm/kvm.h               | 21 +++++++-----
 15 files changed, 156 insertions(+), 29 deletions(-)

-- 
2.55.0.rc0.738.g0c8ab3ebcc-goog

