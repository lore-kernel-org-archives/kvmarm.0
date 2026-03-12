Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 443802D5924;
	Thu, 12 Mar 2026 08:01:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773302512; cv=none; b=TVzUf0x8izJY3CSyU8uGLg/XXS0CpY9zBYPlrvf0qO4PciTTHOLGuFG9pNtqVY/lmybggvudwyqa6wtPcIjie7r0SzgeG9fEF2mzaBfbe3UBXDx2kktwkEfk4LEPq8LA0GEXUwL5WXohqnipyjvGENoMnMzgf4w/ZAxJ357zaTU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773302512; c=relaxed/simple;
	bh=5qx9TyPQVtWhPZ9FQXNhQRM042DHMTHeDIx/YqC06yY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=GDXL7b5T1fsHTsX1/dl1NGWH+IWQv4A90d6e78BNgQjOrYxxI7JGECcRxvFLH7CWP2mIJ3aumDvC0Uj/hvWvP5Szq9PiQB8upraG6wHt9DDrmjLNq2HyE4zf9aNQ/+9h6r6mM6EJ9hmgMe4HhsD2a9FiKYZHYyZpLShPGdxkst8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=m6kRA59+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="m6kRA59+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A2ADC4CEF7;
	Thu, 12 Mar 2026 08:01:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773302511;
	bh=5qx9TyPQVtWhPZ9FQXNhQRM042DHMTHeDIx/YqC06yY=;
	h=From:To:Cc:Subject:Date:From;
	b=m6kRA59+M5dMhr5K54MjyCCaNC8/XrSZ3S1TEsKzG5djczYszxUzKiTMBvCG3uAC+
	 PxBHglgi9JfqyFKionjeOs9I5KiSmLKIyjODCFtOh6n42u9WeRHWN1/ufyNlR32oM3
	 jO3d8HH0ulYgercsDyyDppDPspG8PO9EAl/6/xCzGrgkVb+HJGZcm08hvqg3kPZ8sy
	 t7zl199rqtX7aT+20QFHVdrA9TEqSo0O81U1Pkg9WyFBJQyjBM892bugtFVn6krr/e
	 ReQrzPeUr9gjnVNtmuULNBXpjaUo0fWyQDDDgKaZ/WRzcNy/Gyfleu4BBdnPGWzNZ6
	 +Z14TlJ4yTPJQ==
From: "Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org>
To: linux-coco@lists.linux.dev,
	kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org,
	"Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org>
Subject: [RFC PATCH v3 00/10] coco/TSM: Host-side Arm CCA IDE setup via connect/disconnect callbacks
Date: Thu, 12 Mar 2026 13:31:19 +0530
Message-ID: <20260312080129.3483585-1-aneesh.kumar@kernel.org>
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
required for the Arm CCA IDE setup as per the RMM ALP17 specification [1].

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

The series builds upon the TSM framework patches posted at [2] and depends on
the KVM CCA patchset [3]. A git repository containing all the related changes is
available at [4].

Testing / Usage

To initiate the IDE setup:
	echo tsm0 > /sys/bus/pci/devices/$DEVICE/tsm/connect

To disconnect:
	echo tsm0 > /sys/bus/pci/devices/$DEVICE/tsm/disconnect

Previous posting:
rfc-v1 https://lore.kernel.org/all/20250728135216.48084-1-aneesh.kumar@kernel.org
rfc-v2 https://lore.kernel.org/all/20251027095602.1154418-1-aneesh.kumar@kernel.org

Changes from v2:
* rebase to latest kernel and core TSM changes
* Address review feedback.

[1] https://developer.arm.com/-/cdn-downloads/permalink/Architectures/Armv9/DEN0137_1.1-alp17.zip
[2] https://lore.kernel.org/all/20260303000207.1836586-1-dan.j.williams@intel.com
[3] https://lore.kernel.org/all/461fa23f-9add-40e5-a0d0-759030e7c70b@arm.com
[4] https://gitlab.arm.com/linux-arm/linux-cca.git cca/topics/cca-tdisp-upstream-rfc-v3


Aneesh Kumar K.V (Arm) (7):
  KVM: arm64: RMI: Add and export kvm_has_da_feature helper
  coco: host: arm64: Add host TSM callback and IDE stream allocation
    support
  coco: host: arm64: Build and register RMM pdev descriptors
  coco: host: arm64: Add RMM device communication helpers
  coco: host: arm64: Add helper to stop and tear down an RMM pdev
  coco: host: arm64: Instantiate RMM pdev during device connect
  coco: host: arm64: Register device public key with RMM

Lukas Wunner (3):
  X.509: Make certificate parser public
  X.509: Parse Subject Alternative Name in certificates
  X.509: Move certificate length retrieval into new helper

 arch/arm64/include/asm/kvm_rmi.h          |   1 +
 arch/arm64/include/asm/rmi_cmds.h         |  78 +++
 arch/arm64/include/asm/rmi_smc.h          | 183 ++++++-
 arch/arm64/kvm/rmi.c                      |   6 +
 crypto/asymmetric_keys/x509_cert_parser.c |   9 +
 crypto/asymmetric_keys/x509_loader.c      |  38 +-
 crypto/asymmetric_keys/x509_parser.h      |  42 +-
 drivers/firmware/smccc/rmm.c              |  12 +
 drivers/firmware/smccc/rmm.h              |   8 +
 drivers/firmware/smccc/smccc.c            |   1 +
 drivers/virt/coco/Kconfig                 |   2 +
 drivers/virt/coco/Makefile                |   1 +
 drivers/virt/coco/arm-cca-host/Kconfig    |  23 +
 drivers/virt/coco/arm-cca-host/Makefile   |   5 +
 drivers/virt/coco/arm-cca-host/arm-cca.c  | 274 ++++++++++
 drivers/virt/coco/arm-cca-host/rmi-da.c   | 639 ++++++++++++++++++++++
 drivers/virt/coco/arm-cca-host/rmi-da.h   | 122 +++++
 include/keys/asymmetric-type.h            |   2 +
 include/keys/x509-parser.h                |  57 ++
 19 files changed, 1448 insertions(+), 55 deletions(-)
 create mode 100644 drivers/virt/coco/arm-cca-host/Kconfig
 create mode 100644 drivers/virt/coco/arm-cca-host/Makefile
 create mode 100644 drivers/virt/coco/arm-cca-host/arm-cca.c
 create mode 100644 drivers/virt/coco/arm-cca-host/rmi-da.c
 create mode 100644 drivers/virt/coco/arm-cca-host/rmi-da.h
 create mode 100644 include/keys/x509-parser.h

-- 
2.43.0

