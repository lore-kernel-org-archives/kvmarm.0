Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50EA8193060;
	Mon, 28 Oct 2024 09:40:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730108427; cv=none; b=EmGA9Tfjngyu8dMybxTAHu+owc2KAhh9iJWvgk535iRcva3zMHTS45iknCY1nkyjofR4mP6fAk6zFXDJNqcU2y+QsYLvAt1LSMx8UbpIdOanHdgR5DwnfIhWsgVhaWubIC1gdy4Gx1TcqxCehXwt7v2buBU8Yfc5wCrzN2xY1zo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730108427; c=relaxed/simple;
	bh=cJ+xOHKsd2TE6St+Y4s0cnha3ZN14d8zhSDTUgcPAJQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ls687QX1Rva06dIlgcQYpX42g0qAWL49WipH/S+3LxpQrMJkJ7hw2wW3oyw2TyixOcLJxECNNh9czzCpJm9/FMm7euQym7v3Q4T1cYIiDJ6ygN2wlnG8ZTxp2hZpxlsGqNX8mUmAmG8OWP4GAYhmm/83JvClLPBM6qiWgooUU7I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=E8Wy/uS8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="E8Wy/uS8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD5BEC4CEC3;
	Mon, 28 Oct 2024 09:40:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1730108426;
	bh=cJ+xOHKsd2TE6St+Y4s0cnha3ZN14d8zhSDTUgcPAJQ=;
	h=From:To:Cc:Subject:Date:From;
	b=E8Wy/uS8MmrVLrH6Eg66uVopyNyEs0D1w1NRIett4Jm9ho0cwd7BDvKUDI2tqtqaw
	 FNEjL4wUvmmxz76o0sDV4u3FQ7LRJU8Z5dqiXscxE9iADdm+PKlmL31hftZLyNkwds
	 fpmQ2gTPdz4S/s1bWxzzwDRc6iwzCuCkw9YVO4/1PhGsuxY296H0PYQ/YvOvcpfX5M
	 BhQ+ppSTvKZP6Ydv6dCfxOJnCyi5/Z1G7Eb9L08+oKmBhT/fpiHASxEvKtaLp2AO78
	 PIjd7hdol5g9Zzq1n1YpmJ7hZe/fLb6SdS+rvkCvFintECgOPDLReqiZWCA9QMgWj+
	 e2sz3O+aLu6zQ==
From: "Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org>
To: linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev
Cc: Suzuki K Poulose <Suzuki.Poulose@arm.com>,
	Steven Price <steven.price@arm.com>,
	Will Deacon <will@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Marc Zyngier <maz@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Joey Gouly <joey.gouly@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	"Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org>
Subject: [PATCH 0/4] Add support for NoTagAccess memory attribute
Date: Mon, 28 Oct 2024 15:10:10 +0530
Message-ID: <20241028094014.2596619-1-aneesh.kumar@kernel.org>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

A VMM allows assigning different types of memory regions to the guest and not
all memory regions support storing allocation tags. Currently, the kernel
doesn't allow enabling the MTE feature in the guest if any of the assigned
memory regions don't allow MTE. This prevents the usage of MTE in the guest even
though the guest will never use these memory regions as allocation tagged
memory.

This patch series provides a way to enable MTE in such configs. Translations
from non-MTE-allowed memory regions are installed in stage-2 with NoTagAccess
memory attributes. Guest access of allocation tags with these memory regions
will result in a VM Exit.

Note: We could use the existing KVM_EXIT_MEMORY_FAULT for this. I chose to add a
new EXIT type because this is an arm64-specific exit type and I was not sure
whether KVM_EXIT_MEMORY_FAULT needs a NoTagAccess flag.


Aneesh Kumar K.V (Arm) (4):
  arm64: Update the values to binary from hex
  arm64: cpufeature: add Allocation Tag Access Permission (MTE_PERM)
    feature
  arm64: mte: update code comments
  arm64: mte: Use stage-2 NoTagAccess memory attribute if supported

 arch/arm64/include/asm/cpufeature.h  |  5 ++++
 arch/arm64/include/asm/kvm_emulate.h |  5 ++++
 arch/arm64/include/asm/kvm_pgtable.h |  1 +
 arch/arm64/include/asm/memory.h      | 14 +++++-----
 arch/arm64/kernel/cpufeature.c       |  9 +++++++
 arch/arm64/kvm/hyp/pgtable.c         | 16 ++++++++---
 arch/arm64/kvm/mmu.c                 | 40 +++++++++++++++++++---------
 arch/arm64/tools/cpucaps             |  1 +
 include/uapi/linux/kvm.h             |  7 +++++
 9 files changed, 77 insertions(+), 21 deletions(-)


base-commit: c964ced7726294d40913f2127c3f185a92cb4a41
-- 
2.43.0

