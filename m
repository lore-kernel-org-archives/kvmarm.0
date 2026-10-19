Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B94C43F8891
	for <kvmarm@lists.linux.dev>; Mon, 19 Oct 2026 13:42:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792417372; cv=none; b=PdCUzQ9N+FL6xXbeOtRPSIQpAyHL7koUtL+9XlJ3IFUpGmPQ75Sp1SCbwRqQ26yHPpX5X3TcF/NZ9BZZ6pL/mzuWvr2nCWL26sM+Cnssd6T/dVZ1YrEIqn2VYqehtMIUO65ROMW8hlS1p7q9h7T24Khl7nCPrrn6TC+2kOPap/E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792417372; c=relaxed/simple;
	bh=K7YhWkCWarL7Gtffm3d1sHgP/poIqSZiFk+2A5AwUbQ=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=OY6yfVrFTIpv3+EdTPojC7v+GsZR1xkQ693Em54Pt/IPU0XqFN8eBpPWw6fXkHr1ArpuVa3RC3IfCJJI2ElqiYELa1j1/ciu0vIaAj3oHrRp8EAn1ecDl2YUaGl8Z+S+gYdP7B34nhhv97efHCUcEshxAimvCH84TILyFmegii8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=l9Td4K/B; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="l9Td4K/B"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 124581682;
	Mon, 19 Oct 2026 06:42:47 -0700 (PDT)
Received: from e133894.cambridge.arm.com (e133894.arm.com [10.2.80.62])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id EDBEE3F871;
	Mon, 19 Oct 2026 06:42:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1792417370; bh=K7YhWkCWarL7Gtffm3d1sHgP/poIqSZiFk+2A5AwUbQ=;
	h=From:To:Cc:Subject:Date:From;
	b=l9Td4K/B09epB/osjDeXgkmUW5XdbwLQ195LGE6R8zPxfmOA++2rUDoX9Pu4O1Khz
	 1K6DeK40ZN4tYIxGSX9lBeYGqCLOSsfpevl1DHy73IYUK4mtSdmN2ywjRlBnyrODMa
	 8fM0kzLH9Pb5lkXiw+SeH5tYdYWc/QlR9ldnmqWY=
From: Sascha Bischoff <sascha.bischoff@arm.com>
To: linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	kvm@vger.kernel.org
Cc: maz@kernel.org,
	oupton@kernel.org,
	fuad.tabba@linux.dev,
	joey.gouly@arm.com,
	seiden@linux.ibm.com,
	suzuki.poulose@arm.com,
	yuzenghui@huawei.com
Subject: [PATCH v2 0/2] KVM: arm64: Reject mismatched GICv3 ITS/VGIC models
Date: Mon, 19 Oct 2026 14:42:40 +0100
Message-Id: <20261019134242.1289002-1-sascha.bischoff@arm.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On a GICv5 host with legacy GICv3 support, KVM exposes both VGIC
models to userspace. A VM can create a GICv3 ITS alongside a GICv5
VGIC, because neither creation path checks the model of the other
device. The ITS sets has_its, but a GICv5 VM cannot use a GICv3 ITS
for MSI translation. Creating the ITS before the VGIC also lets
userspace select an incompatible VGIC model later.

Record the VGIC model required by a GICv3 ITS and reject incompatible
device creation in either order. Drop has_its in favour of using the
newly added its_model instead. The second patch tests both orderings,
skipping the test if the host does not offer a GICv3 ITS.

This series is based on kvmarm/next-7.4+fixes-7.3-2.

Changes since V1:

* Worked in Marc's suggestion to drop has_its.
* Check for its_model being non-zero in vgic_has_its(), allowing us to
  drop has_its.
* Added a comment to explain what we are actually doing. Again, Marc's
  suggestion.
* Changed the type of vgic_model from u32 to enum kvm_device_type.

Thanks,
Sascha

Sascha Bischoff (2):
  KVM: arm64: vgic: Require matching VGIC model for GICv3 ITS
  KVM: selftests: Reject GICv3 ITS with a GICv5 VGIC

 arch/arm64/kvm/vgic/vgic-init.c             | 17 +++++++++++
 arch/arm64/kvm/vgic/vgic-its.c              | 15 +++++++++-
 arch/arm64/kvm/vgic/vgic-mmio-v3.c          |  5 +---
 include/kvm/arm_vgic.h                      |  5 ++--
 tools/testing/selftests/kvm/arm64/vgic_v5.c | 32 +++++++++++++++++++++
 5 files changed, 67 insertions(+), 7 deletions(-)

-- 
2.34.1

