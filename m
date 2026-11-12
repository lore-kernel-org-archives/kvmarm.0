Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=207.54.90.47
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794454638;
	b=crngU9a4hP8rpicpzBuraEOVH1p1BFSKB+8Ak9fjt/WRlDAoYadm93jBAbF0Ih6n/twr
	 5TIbiwUyKUntSx16XwynCdylGHfo6saczzJ1Riu2AW315O6O9elMON3k59YYCGfv5T/x+
	 l8f8v0FlBckhExTSXkANFk47Zf2/DW3u5ZGcq7gUAZJI9CzTzXp+k0H3wi8KdR7IM8X+x
	 l4GG8B6QGZYNnuG4l2TZpNyF1PhZnIxTlk9vaO45ruplbU96HfvirFu+GIapFegB/8BtM
	 sHHsAlVg2h5blbsMOvRle4qB7kQ/i8abIlE1tmtDJdZOuhrI1dgvb5dNIPWX84cMDeQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794454638;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:X-IronPort-AV:Received:Received:Received:Received:From:
	 Subject:Date:Message-Id:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:X-B4-Tracking:X-Change-ID:To:Cc:X-Mailer;
	bh=7sClOyXc5DYkp7gT7ltCBjv+6uzNG2TAXlQo0+7BqYo=;
	b=QJ/3unYDwnW1vwGR+UQeps/wEpumC6FhduCCpI5rEe7GWu5L/QOt4+LSDIPFMdW+qW29
	 tkrwio0rdy/nHWDZjVIlmKOsFRxnsIJH1Otag1FH0gZcOkVfOVw3rgd0GfOg5iGYLiz2c
	 VWZaAzxq74/Em2OfC0hNusoT7ss+yvwCxKANzISqRy2OYX/jyyD3AFd30W30T+R5mzdsD
	 6WrRhv+oZD8rwQW/IIMw/sC1riVmP2gQKQdryOmOS7cdxz3QujjbwCuC0OFmStf2lCkVB
	 U8igufIiFSGKTJ1QoQFYn3/rfjQO+uSgsrHj0HDnJJn0Mw85sFjRBIhJjJ6tku2qwfQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=fujitsu.com;
	spf=pass smtp.mailfrom=fujitsu.com;
	dkim=pass header.d=fujitsu.com header.i=@fujitsu.com header.a=rsa-sha256 header.s=fj2 header.b=iT6+uKMA;
	arc=none smtp.remote-ip=207.54.90.47
Received: from esa1.hc1455-7.c3s2.iphmx.com (esa1.hc1455-7.c3s2.iphmx.com [207.54.90.47])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50232606A31C
	for <kvmarm@lists.linux.dev>; Thu, 12 Nov 2026 03:37:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 50232606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fujitsu.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fujitsu.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=fujitsu.com header.i=@fujitsu.com header.a=rsa-sha256 header.s=fj2 header.b=iT6+uKMA
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=fujitsu.com; i=@fujitsu.com; q=dns/txt; s=fj2;
  t=1794454645; x=1825990645;
  h=from:subject:date:message-id:mime-version:
   content-transfer-encoding:to:cc;
  bh=03RedrnDsUkMfaAlXP5THfn6nEFN+a+p8i1kpiQJYtU=;
  b=iT6+uKMAG+2wTVkIpyT5VX8Dz0/ku3cE2GyN2ZANObACZOJ3u0nlWE3w
   pyExUZW427avKoUKHeX1wjFpLd7bUPUrcA0os7/K3fOTDUoDtrsO4Nu/G
   EQxcggVorUu5IXMB0f9s9RMpJVnDkNTXqeKDPPOIi83zlX0hwNx4p03XI
   D5CpePHJ8fze94JkKWrWZDeZxxXKQCDHxUn8X7rq6p3W4154fmVCdnZcK
   obtZfH6kN0Cbfsvv/XDnahg5gKDr7wO8IrVm33wKfKgff1QeVPJaaDS+k
   JeTHVyVi1dntJXrDUWssXaz5jtnzn9ARsE/cuf3VIOCh3RDBrxprUHFtE
   Q==;
X-CSE-ConnectionGUID: ZMlXQnQRSfS3HwBSkoe9/g==
X-CSE-MsgGUID: kEGeJx9yRt20QVYWGyc0VA==
X-IronPort-AV: E=McAfee;i="6800,10657,11963"; a="261506750"
X-IronPort-AV: E=Sophos;i="6.27,208,1786978800"; 
   d="scan'208";a="261506750"
Received: from gmgwnl01.global.fujitsu.com ([52.143.17.124])
  by esa1.hc1455-7.c3s2.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Nov 2026 12:37:18 +0900
Received: from az2nlsmgm1.o.css.fujitsu.com (unknown [10.150.26.203])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by gmgwnl01.global.fujitsu.com (Postfix) with ESMTPS id 886321C0634D
	for <kvmarm@lists.linux.dev>; Thu, 12 Nov 2026 03:37:10 +0000 (UTC)
Received: from az2nlsmom2.o.css.fujitsu.com (unknown [10.150.26.200])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by az2nlsmgm1.o.css.fujitsu.com (Postfix) with ESMTPS id 3AD2BC00FF1
	for <kvmarm@lists.linux.dev>; Thu, 12 Nov 2026 03:37:10 +0000 (UTC)
Received: from [127.0.1.1] (unknown [10.124.178.20])
	by az2nlsmom2.o.css.fujitsu.com (Postfix) with ESMTP id 2D4CF1801928;
	Thu, 12 Nov 2026 03:37:03 +0000 (UTC)
From: Kohei Enju <enju.kohei@fujitsu.com>
Subject: [PATCH RFC v2 0/2] KVM: arm64: CCA: Add MEC policy support for CCA
 Realms
Date: Thu, 12 Nov 2026 12:36:20 +0900
Message-Id: <20261112-mm-v1-mec-v2-0-0d1dd260a588@fujitsu.com>
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIADU09WoC/6tWKk4tykwtVrJSqFYqSi3LLM7MzwNyjHQUlJIzE
 vPSU3UzU4B8JSMDIzNDQ0Mj3dxc3TJD3dzUZF2LZFMDc6MUs2RjY0MloPqCotS0zAqwWdFKQW7
 OSrEQweLSpKzU5BKQKUq1tQDZmoSfcgAAAA==
X-Change-ID: 20261112-mm-v1-mec-8c5072d6c331
To: Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>, 
 Oliver Upton <oupton@kernel.org>, Fuad Tabba <fuad.tabba@linux.dev>, 
 Joey Gouly <joey.gouly@arm.com>, Steffen Eiden <seiden@linux.ibm.com>, 
 Suzuki K Poulose <suzuki.poulose@arm.com>, 
 Steven Price <steven.price@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
 Mark Rutland <mark.rutland@arm.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
 cgroups@vger.kernel.org, Kohei Enju <enju.kohei@fujitsu.com>
X-Mailer: b4 0.16.0

This series adds basic support for configuring the Memory Encryption
Context (MEC) policy for Arm CCA Realms.

Patch 1 introduces the KVM_ARM_VM_RMI_CTRL device attribute group to
allow userspace to configure Realm VM parameters before the Realm is
created using KVM_SET_DEVICE_ATTR, and uses it to let userspace select
the MEC policy before the Realm is created.

Patch 2 adds a misc cgroup resource for CCA MECIDs and charges one unit
for each Realm using the private MEC policy.

Feedback on the proposed KVM ABI and on using misc cgroup for MECID
accounting would be appreciated.

This series is based on Steven and Suzuki's CCA host series [1]. I am
sending it as an RFC while the CCA host series is not yet upstreamed,
and plan to update it as needed to track future revisions of the host
series. Once the host series is merged, I plan to post a non-RFC
version.

Since the base series is not yet upstream, some CI systems may not be
able to test this series successfully. This is expected for this RFC.

Changes
- RFC v2:
  - Use kvm_device_attr instead of a dedicated ioctl.
  - Rebase onto the CCA host series branch listed in [1].
- RFC v1: https://lore.kernel.org/all/20260724094120.166536-1-enju.kohei@fujitsu.com/

[1]
 https://gitlab.arm.com/linux-arm/linux-cca
 branch: cca-host-mm/v1/integration

Signed-off-by: Kohei Enju <enju.kohei@fujitsu.com>
---
Kohei Enju (2):
      KVM: arm64: CCA: Add support for configuring the Realm MEC policy
      cgroup/misc: Add support for Arm CCA MECIDs

 Documentation/virt/kvm/devices/vm.rst   |  25 ++++++++
 arch/arm64/include/asm/kvm_rmi.h        |   7 +++
 arch/arm64/include/uapi/asm/kvm.h       |   4 ++
 arch/arm64/kvm/arm.c                    |   4 ++
 arch/arm64/kvm/rmi.c                    | 101 +++++++++++++++++++++++++++++++-
 drivers/firmware/arm_rmm/rmi.c          |  10 ++++
 include/linux/arm-rmi-cmds.h            |   1 +
 include/linux/misc_cgroup.h             |   4 ++
 kernel/cgroup/misc.c                    |   4 ++
 tools/arch/arm64/include/uapi/asm/kvm.h |   4 ++
 10 files changed, 163 insertions(+), 1 deletion(-)
---
base-commit: a7644e0425de41ed0338cb73eebe5d14baf6be95
change-id: 20261112-mm-v1-mec-8c5072d6c331

Best regards,
--  
Kohei Enju <enju.kohei@fujitsu.com>

