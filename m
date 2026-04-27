Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 678453A6B6B;
	Mon, 27 Apr 2026 08:53:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777280037; cv=none; b=lPsIHGDcXRMNCyR8lj8nj+f+0mlp+UnWcTmhh+Cy9jvovus+Eb2db9HaQjN3tZ1Z3PxnBSGPGw1yGPZM+kHyq1faDG1c4WQVGbQXrdJXJO7bVQum7gT7OU/13LjXGmiYl2iF30+9k9jfjF5y9uYGqPPkLBoJ4V7Mh+a4uc5mA8g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777280037; c=relaxed/simple;
	bh=L6CIRuwpkn6LSm93SMXHwBeF+6YApe7XFCUtPrZkZuo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=Plx2BrOkmm5fO/X+84N/Ynq1xWK0SgEBKSrUsGf3u170jHLQxVP8Uf/MRluUYNTqFn1U9a7gds1B3OiUvO+z5qlwKa0dft0t+Tksl5r60l/8JQUamrXL3zxu7Q4sULnp1E/PIWRJKg8Gap9+T4/552uem7Sv2r6qMrle2okntYQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=i+EZsHgt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="i+EZsHgt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C051C19425;
	Mon, 27 Apr 2026 08:53:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777280037;
	bh=L6CIRuwpkn6LSm93SMXHwBeF+6YApe7XFCUtPrZkZuo=;
	h=From:To:Cc:Subject:Date:From;
	b=i+EZsHgt6NFSuiq0SeFxdz3lOCP6U507jBK+UEGsmhKlSdK+D36m19OUgXs/K50NI
	 bhfadgmo//a/+KeOw6ODbMyNECddyQmu6j8uEUsdH3GeZ0a4oYYcVCTPqJPJoXzZbD
	 N36tv410dRxFDUQGQzjFtIp4iv7zEqEiUU1VwQq390Y+ShVyx1b5WOOoGl4MEMHY7o
	 CzT5QfNaGiQmNauD9G0GWdv29+DtXiohFArCZaT8LqZUuOK4AbY5GbejHOoP/+cxWh
	 jCOXKJXTUKBL/CI7HQ2ztRY5xU2sKi6nt7IaLKIWmzZsyUoXJ1PMR80R6I15UGUVnC
	 bL46puPb99lSw==
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
	Joerg Roedel <joro@8bytes.org>,
	Jonathan Cameron <jic23@kernel.org>,
	Marc Zyngier <maz@kernel.org>,
	Nicolin Chen <nicolinc@nvidia.com>,
	Pranjal Shrivastava <praan@google.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Samuel Ortiz <sameo@rivosinc.com>,
	Steven Price <steven.price@arm.com>,
	Suzuki K Poulose <Suzuki.Poulose@arm.com>,
	Will Deacon <will@kernel.org>,
	Xu Yilun <yilun.xu@linux.intel.com>
Subject: [RFC PATCH v4 00/16] coco/TSM: Implement host-side support for Arm CCA TDISP setup
Date: Mon, 27 Apr 2026 14:23:28 +0530
Message-ID: <20260427085344.941627-1-aneesh.kumar@kernel.org>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit


This patch series implements the host-side changes needed for end-to-end
Arm CCA TDISP setup. It adds the RMI/RHI plumbing required to create and
manage Realm vdev objects, service device-attestation object requests, and
complete the KVM/RMM flows needed for device run-time transitions.

The series is based on the RMM 2.0bet1 specification [1] and the
RHI v1.0 BET1 specification [5].

At a high level, the series adds support for:
- host-side vdev communication and lifecycle management
- host handling of RHI DA object read/size requests
- host-side fetching and caching of interface reports and measurements
- KVM handling of vdev request/complete exits
- KVM handling of map/validation exits and teardown on granule destroy
- vdev transition to TDISP RUN state
- enabling DA in Realm create parameters

The series builds upon the TSM framework patches posted at [2] and depends on
the KVM CCA patchset [3]. A git repository containing all related changes is
available at [4]. kvmtool repo is at [6]

Previous posting:
Changes from v3:
https://lore.kernel.org/all/20260312080743.3487326-1-aneesh.kumar@kernel.org
* updated the patches to follow the RMM 2.0bet1 specification
* moved vdev request-exit handling to the last patch in the series. This is
  expected to be dropped once the corresponding spec update lands
* dropped the vdev and pdev arguments from rmi_rtt_dev_validate(). The spec
  update for that change is still pending. The validation call is now made
  from the REC enter path
* added a response field to KVM_EXIT_ARM64_TIO so the VMM can pass the ioctl
  return status back to the exit handler
* dropped vcpu_fd from arm64_vdev_device_memmap_guest_req. Once vdev request
  handling is removed from the series, the ioctl path will no longer need
  vcpu_fd
* reworked the host-side vdev lifecycle to better match the RMM 2.0bet1 flow,
* updated the vdev flows to match the revised interfaces: populate MMIO BAR
  ranges in rmi_vdev_create(), rename the interface-report and measurement
  update commands, and drop vcpu_fd from the guest MMIO map request path

Changes from v1:
* rebase to latest kernel and core TSM changes
* address review feedback

rfc-v1: https://lore.kernel.org/all/20250728135216.48084-1-aneesh.kumar@kernel.org
There is no rfc-v2 posting. This series is marked rfc-v3 to stay aligned
with the rest of the CCA patchsets that are being posted as v3.

[1] https://developer.arm.com/documentation/den0137/2-0bet1/
[2] https://lore.kernel.org/all/20260303000207.1836586-1-dan.j.williams@intel.com
[3] https://lore.kernel.org/all/20260318155413.793430-1-steven.price@arm.com
[4] https://gitlab.arm.com/linux-arm/linux-cca.git cca/topics/cca-tdisp-upstream-rfc-v4
[5] https://developer.arm.com/documentation/den0148/latest/
[6] https://gitlab.arm.com/linux-arm/kvmtool-cca.git cca/topics/cca-tdisp-upstream-rfc-v4

Cc: Alexey Kardashevskiy <aik@amd.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Joerg Roedel <joro@8bytes.org>
Cc: Jonathan Cameron <jic23@kernel.org>
Cc: Marc Zyngier <maz@kernel.org>
Cc: Nicolin Chen <nicolinc@nvidia.com>
Cc: Pranjal Shrivastava <praan@google.com>
Cc: Robin Murphy <robin.murphy@arm.com>
Cc: Samuel Ortiz <sameo@rivosinc.com>
Cc: Steven Price <steven.price@arm.com>
Cc: Suzuki K Poulose <Suzuki.Poulose@arm.com>
Cc: Will Deacon <will@kernel.org>
Cc: Xu Yilun <yilun.xu@linux.intel.com>

Aneesh Kumar K.V (Arm) (16):
  iommu/arm-smmu-v3: Discover RME support and realm IRQ topology
  iommu/arm-smmu-v3: Save the programmed MSI message in msi_desc
  iommu/arm-smmu-v3: Add initial pSMMU realm viommu plumbing
  iommu/arm-smmu-v3: Track realm pSMMU users with refcount_t
  coco: host: arm64: Add support for virtual device communication
  coco: host: arm64: Add support for RMM vdev objects
  coco: host: arm64: Add pdev stream key refresh and purge helpers
  coco: host: arm64: Add helpers to unlock and destroy RMM vdev
  coco: host: arm64: Add support for da object read RHI handling
  coco: host: arm64: Add helper for cached object fetches
  coco: host: arm64: Fetch interface report via RMI
  coco: host: arm64: Fetch device measurements via RMI
  coco: host: KVM: arm64: Handle vdev validate-mapping exits
  KVM: arm64: Unmap device mappings when a private granule is destroyed
  coco: host: arm64: Transition vdevs to TDISP RUN state
  KVM: arm64: CCA: enable DA in realm create parameters

 Documentation/virt/kvm/api.rst                |  20 +
 arch/arm64/include/asm/kvm_rmi.h              |   4 +
 arch/arm64/include/asm/rmi_cmds.h             | 193 ++++++
 arch/arm64/include/asm/rmi_smc.h              |  98 ++-
 arch/arm64/include/uapi/asm/rmi-da.h          |  47 ++
 arch/arm64/kernel/rmi.c                       |  51 ++
 arch/arm64/kvm/rmi-exit.c                     |  37 ++
 arch/arm64/kvm/rmi.c                          | 279 ++++++++-
 drivers/iommu/arm/arm-smmu-v3/Makefile        |   2 +-
 .../arm/arm-smmu-v3/arm-smmu-v3-iommufd.c     |   7 +
 .../iommu/arm/arm-smmu-v3/arm-smmu-v3-realm.c | 297 +++++++++
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c   |  86 ++-
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h   |  16 +
 drivers/virt/coco/arm-cca-host/arm-cca.c      | 188 +++++-
 drivers/virt/coco/arm-cca-host/rmi-da.c       | 569 +++++++++++++++++-
 drivers/virt/coco/arm-cca-host/rmi-da.h       |  40 ++
 include/uapi/linux/iommufd.h                  |   1 +
 include/uapi/linux/kvm.h                      |  11 +
 18 files changed, 1929 insertions(+), 17 deletions(-)
 create mode 100644 arch/arm64/include/uapi/asm/rmi-da.h
 create mode 100644 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-realm.c

-- 
2.43.0

