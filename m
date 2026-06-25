Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DF703E92BB;
	Thu, 25 Jun 2026 17:10:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782407455; cv=none; b=WyqEGrLJETNYaYiuc/XduB0omUO3upp63wjfWa6XuuencR/qHO0Utf9mQdbFsmYcOA9x/EtKk481jc8S6y8wMbCkfpSQZl9rP08Q9fPBaXP/WFaZtKme5+90PXIUjF3sUT0dLu/7F0VNFQUkeLAb/EYMrV5d4HlgBzxC7IRh8LE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782407455; c=relaxed/simple;
	bh=JdXWfZUJieNLZxEdytgvK1sjfYVtqrqjCbGHlQBLJQk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=KbS7VT65P1U7PHbRLV8V1kR4I7h6ycaJ8lp1OxO5MbHGDlnpFBmsl+w16uIbEsxaVjQuB93DtwLH3BJbOXSBhcax+EvEvhxPFPxy4gOFGW4QjUBdZFUmW2uebMqjdd+HM53WzFjwJNe6JMpzW+Z7edheiVFmoFwBENNOClk/I8M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nSSNj8mI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nSSNj8mI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4CF31F000E9;
	Thu, 25 Jun 2026 17:10:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782407453;
	bh=xTDge6LAEsLKw3tzPDqsO7avyKUb3oYxjRTJp/9v7gs=;
	h=From:To:Cc:Subject:Date;
	b=nSSNj8mIjFlSy2+dEzvgTOh3/kpZMldKCPxssHUC7xQW3CgsM0wvYb5VmUuvdA4Bg
	 qgP6BeNHpXIxxolcUT3NgD+hTmr5t3Qivi+8nmnOS+kyqTjNGErfWBA7TLFQ64WgkJ
	 etPQnws4VKEhlxClqTmKv8+kZvvetB/J5v17K+4zPOLhTzS1z7xMbkA5GJKYZtmB6V
	 WiTOZW1Kw+eH+CqOfz7XlZyGuU5qqUQfyvjqKEqkUP3sewy7WsVeyJXg8u4By9CIs1
	 61szoRnuCmpamJvB86cp9oGy4El2AQo6eNtS2l1t7ShyptxCJ3tx91VU7i5Dw3xPNH
	 PX2C9a0QYAf7Q==
From: Will Deacon <will@kernel.org>
To: kvm@vger.kernel.org
Cc: kvmarm@lists.linux.dev,
	Will Deacon <will@kernel.org>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Andre Przywara <andre.przywara@arm.com>,
	Fuad Tabba <fuad.tabba@linux.dev>,
	Oliver Upton <oliver.upton@linux.dev>,
	Marc Zyngier <maz@kernel.org>
Subject: [PATCH v2 kvmtool 0/4] Add support for running protected VMs on arm64
Date: Thu, 25 Jun 2026 18:10:41 +0100
Message-ID: <20260625171046.4482-1-will@kernel.org>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi folks,

This is v2 of the patches I previously posted here:

  https://lore.kernel.org/r/20260619115415.5475-1-will@kernel.org

Changes since v1 include:

  * Bail if user specifies less guest memory than the restricted DMA pool.
  * Avoid silently dropping KVM_VM_TYPE_ARM_PROTECTED on old host kernels.
  * Added R-b/T-b tags (thank you!)

The patches are also available here if you want to pull them directly:

  https://git.kernel.org/pub/scm/linux/kernel/git/will/kvmtool.git/log/?h=pkvm

Cheers,

Will

Cc: Alexandru Elisei <alexandru.elisei@arm.com>
Cc: Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: Andre Przywara <andre.przywara@arm.com>
Cc: Fuad Tabba <fuad.tabba@linux.dev>
Cc: Oliver Upton <oliver.upton@linux.dev>
Cc: Marc Zyngier <maz@kernel.org>

--->8

Will Deacon (4):
  Sync kernel UAPI headers with v7.1
  virtio: Factor out base features for modern virtio transports
  virtio: Add helper for enabling VIRTIO_F_ACCESS_PLATFORM
  arm64: Add support for protected VMs

 arm64/fdt.c                         | 37 ++++++++++++++++++--
 arm64/include/asm/kvm.h             |  1 +
 arm64/include/kvm/fdt-arch.h        | 10 +++++-
 arm64/include/kvm/kvm-arch.h        |  2 ++
 arm64/include/kvm/kvm-config-arch.h |  5 ++-
 arm64/kvm.c                         | 28 +++++++++++++--
 arm64/pci.c                         |  2 ++
 include/kvm/virtio.h                |  2 ++
 include/linux/kvm.h                 | 53 +++++++++++++++++++++++++----
 include/linux/virtio_ring.h         |  5 +--
 riscv/include/asm/kvm.h             | 11 +++---
 virtio/core.c                       | 12 +++++++
 virtio/mmio-modern.c                |  2 +-
 virtio/pci-modern.c                 |  2 +-
 x86/include/asm/kvm.h               | 21 +++++++-----
 15 files changed, 163 insertions(+), 30 deletions(-)

-- 
2.55.0.rc0.799.gd6f94ed593-goog

