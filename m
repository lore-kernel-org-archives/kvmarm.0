Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82ADF4963BB;
	Thu, 10 Sep 2026 14:05:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789049120; cv=none; b=GBqZf2NHZGe2Ahsgr58orNZOBSaCpG7Es69szmZPeoqlp9L2s+zISg5XzZNTGFxwQm29/r0h9AxkdWqSb7KF1mIJ7l7bZY9C2nd2Nzu/N6T9M8ocJsYP3ioRkBjorGvT0QQdLBGRFKDEGkQK5huPn8h93Qx+9A88sY9pQe74Eug=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789049120; c=relaxed/simple;
	bh=zMV+qyA/nD7/k7XNzwyL+15jHutScUr0r4Xmr3HVn/M=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=KKccO9ee43h+L8K/ba2VIthq3NqPQJl+Ckq/cLO39hQoKh0NuHEdQ8BPCumgW4HVZjBH4/HJYjkQr+UNB5YjldncXeP+RAWCXhBPPHzIKr3t+2yO589tYllmXAG4Ajl+kuMnvqCPRFmkLI1LXzcyggi9JF9so+OZxMQHeNyC5T4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TDfF6pb2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TDfF6pb2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE5771F000FF;
	Thu, 10 Sep 2026 14:05:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789049119;
	bh=jQdUjWIHK+A1yjvk1aL2MsPIRhofTuFYBLfM+UnkHho=;
	h=From:To:Cc:Subject:Date;
	b=TDfF6pb2+sJVIQr5mEovOo6DcmyF/sUL8zSsTk01dzrXxtZrBRnrM/8r+MDw/+L3H
	 53Ez4zxuTcsZUdK6i6rq0Ih4CfwCB2DiflFBSilsOm2w1MqO9GeWJDQI2hWzxM6bWe
	 MEodZ39FQlqr0O7BEkDaxkOga3bgI4eB+IMpIBuYPBIJZP2+macukfHvcTbr8IlMTf
	 5d6WrMxvs9vuv7p0tlZn5WLbQ1coUc0nSd4lT4inSdI247sc5Czf9lK/07Yb5d5X0T
	 /o3AwcaNLGkU2HMD0NtflRyfm4KkCJORncMiF4GksS8yv3biLXekuk9ObVhbGNsfYc
	 2M5qKnRV/OoTQ==
From: "Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org>
To: linux-coco@lists.linux.dev,
	kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Cc: "Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org>,
	Alexey Kardashevskiy <aik@amd.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Jonathan Cameron <jic23@kernel.org>,
	Marc Zyngier <maz@kernel.org>,
	Samuel Ortiz <sameo@rivosinc.com>,
	Steven Price <steven.price@arm.com>,
	Suzuki K Poulose <Suzuki.Poulose@arm.com>,
	Will Deacon <will@kernel.org>,
	Xu Yilun <yilun.xu@linux.intel.com>
Subject: [PATCH v5 00/15] coco/TSM: Host-side Arm CCA IDE setup via connect/disconnect callbacks
Date: Thu, 10 Sep 2026 19:34:53 +0530
Message-ID: <20260910140509.868402-1-aneesh.kumar@kernel.org>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit


This patch series implements the TSM ->connect() and ->disconnect() callbacks
required for the Arm CCA IDE setup as per the RMM 2.0bet3 specification [1].

This patchset includes the host-side flow needed by connect/disconnect,
including:
- DA feature detection helpers
- host TSM callback wiring and IDE stream allocation support
- creation/registration of RMM pdev descriptors
- RMM pdev communication helpers
- pdev stop and teardown helpers for disconnect
- pdev instantiation from the connect path
- public key registration with RMM

To support public-key handling from the device certificate chain, the series
also includes the required X.509 parser updates.

Testing / Usage

To initiate the IDE setup:
	echo tsm0 > /sys/bus/pci/devices/$DEVICE/tsm/connect

To disconnect:
	echo tsm0 > /sys/bus/pci/devices/$DEVICE/tsm/disconnect

The series is based on:
  - https://lore.kernel.org/all/20260904095000.1184861-1-aneesh.kumar@kernel.org
  - https://lore.kernel.org/all/20260907095942.1140734-1-suzuki.poulose@arm.com

Changes from v4:
https://lore.kernel.org/all/20260427065121.916615-1-aneesh.kumar@kernel.org
* Update rmi_set_pub_key() based on the latest specification.
* Rename structure members to match the specification.
* Rebase on top of the latest dependent series.

Changes from v3:
https://lore.kernel.org/all/20260312080129.3483585-1-aneesh.kumar@kernel.org
* updated the patches to follow the RMM 2.0bet1 specification
* reworked the host-side pdev lifecycle to better match the RMM 2.0bet1 flow,
  including common pdev state, root-port pdev support, and non-coherent stream
  setup and teardown
* split PF0 setup into identity collection and conditional public-key
  installation, and gate DA enablement on RMI_FEATURE_REGISTER_2_DA
* added coordinated handling for RMI_DEV_COMM_EXIT_STREAM_WAIT, along with
  stream connect/disconnect and stream key refresh/purge support during vdev
  teardown

Changes from v2:
rfc-v2 https://lore.kernel.org/all/20251027095602.1154418-1-aneesh.kumar@kernel.org
* rebase to latest kernel and core TSM changes
* Address review feedback.

v1:
rfc-v1 https://lore.kernel.org/all/20250728135216.48084-1-aneesh.kumar@kernel.org

[1] https://developer.arm.com/documentation/den0137/2-0bet3/
[2] https://lore.kernel.org/all/20260303000207.1836586-1-dan.j.williams@intel.com
[3] https://lore.kernel.org/all/20260318155413.793430-1-steven.price@arm.com
[4] https://gitlab.arm.com/linux-arm/linux-cca.git cca/topics/cca-tdisp-upstream-rfc-v4

Cc: Alexey Kardashevskiy <aik@amd.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Jonathan Cameron <jic23@kernel.org>
Cc: Marc Zyngier <maz@kernel.org>
Cc: Samuel Ortiz <sameo@rivosinc.com>
Cc: Steven Price <steven.price@arm.com>
Cc: Suzuki K Poulose <Suzuki.Poulose@arm.com>
Cc: Will Deacon <will@kernel.org>
Cc: Xu Yilun <yilun.xu@linux.intel.com>

Aneesh Kumar K.V (Arm) (12):
  coco: host: arm64: Prepare host TSM plumbing for IDE streams
  coco: host: arm64: Create RMM pdev objects for PCI endpoints
  coco: host: arm64: Add RMM pdev communication plumbing
  coco: host: arm64: Add RMM pdev stop and destroy helper
  coco: host: arm64: Register device public key with RMM
  coco: host: arm64: Initialize RMM pdev state for TDISP IDE connect
  coco: host: arm64: Coordinate peer stream waits during pdev
    communication
  coco: host: arm64: Connect RMM pdev streams for IDE devices
  coco: host: arm64: Refcount root-port pdevs used by IDE streams
  PCI/TSM: Move CMA DOE mailbox discovery out of
    pci_tsm_pf0_constructor()
  coco: host: arm64: Add NCOH_SYS stream support for RC endpoints
  coco: host: arm64: Enable PCI TSM connect callbacks

Lukas Wunner (3):
  X.509: Make certificate parser public
  X.509: Parse Subject Alternative Name in certificates
  X.509: Move certificate length retrieval into new helper

 crypto/asymmetric_keys/x509_cert_parser.c |   9 +
 crypto/asymmetric_keys/x509_loader.c      |  38 +-
 crypto/asymmetric_keys/x509_parser.h      |  42 +-
 drivers/crypto/ccp/sev-dev-tsm.c          |  13 +
 drivers/firmware/arm_rmm/rmi.c            |   4 +-
 drivers/firmware/smccc/smccc.c            |   6 +
 drivers/pci/tsm.c                         |  13 +-
 drivers/virt/coco/Kconfig                 |   2 +
 drivers/virt/coco/Makefile                |   1 +
 drivers/virt/coco/arm-cca-host/Kconfig    |  26 +
 drivers/virt/coco/arm-cca-host/Makefile   |   5 +
 drivers/virt/coco/arm-cca-host/main.c     | 461 ++++++++++++
 drivers/virt/coco/arm-cca-host/rmi-da.c   | 859 ++++++++++++++++++++++
 drivers/virt/coco/arm-cca-host/rmi-da.h   | 217 ++++++
 include/keys/asymmetric-type.h            |   2 +
 include/keys/x509-parser.h                |  57 ++
 include/linux/arm-rmi-cmds.h              |  85 +++
 include/linux/arm-smccc-rmi.h             | 161 ++++
 18 files changed, 1940 insertions(+), 61 deletions(-)
 create mode 100644 drivers/virt/coco/arm-cca-host/Kconfig
 create mode 100644 drivers/virt/coco/arm-cca-host/Makefile
 create mode 100644 drivers/virt/coco/arm-cca-host/main.c
 create mode 100644 drivers/virt/coco/arm-cca-host/rmi-da.c
 create mode 100644 drivers/virt/coco/arm-cca-host/rmi-da.h
 create mode 100644 include/keys/x509-parser.h

-- 
2.43.0

