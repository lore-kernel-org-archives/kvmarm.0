Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 514F53A961A
	for <kvmarm@lists.linux.dev>; Thu,  5 Mar 2026 14:45:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772721958; cv=none; b=JC4hKV7/gXSDdp7wiWkiJrEOEWBsYnAJylVXasTqMGgEbc5l6QKbEcVPdZbCZBIMwbgwgL0tQZEdpFGOr5s2uE8R4rBXMlceC+ygzv9dwjrl73u2nAvIsaOUp8zsi2tSJnrA4lsIuwpXHESQFssEgP1PgjMy9ccvf+MOfHXQRN0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772721958; c=relaxed/simple;
	bh=fagA0mAkyFMmgb3Pdqf+Ss4IDrIZCBaBxCEeug4h3Tc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WLJbVnERjvYhyx9wrwGOc7GWui7HxJ7zlitiJBRA2x18hXJrnVWldQvkYhgJb+jCEkKvC6h594ZV2uD2/6yTyYds/b191xUepx6xgZPON0bBlVJvveXsbUFSAjI4+Juu8wgOvARl0GX4HPZFNPtQo6SHxK395SKq0+oLqiMQvQ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BasemH23; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BasemH23"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 543F2C2BC87;
	Thu,  5 Mar 2026 14:45:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772721958;
	bh=fagA0mAkyFMmgb3Pdqf+Ss4IDrIZCBaBxCEeug4h3Tc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BasemH233jE74r/LfEMttHk5zYCNUXvsS6Os49sEVVuEaL+eYDpc5lZaIC/PE/ejN
	 kM1IZBU4jmFakrTNesLRXuTyh//qSvAa3p383Y0K/H9P13TUKwybeI6vDL/HWcmhXH
	 Gpdy+OU40atZi8Etd1K5SfcPNv4LmpetSsyeFBlTsEbTB3AqTXBEO5a/j1tjyWj5BL
	 OJpcp6vyYP106l/pgHc2UQDlHdh7lwWcsZ28fqNLPjpxu0+FpelPtC4gyX9ajPkfwu
	 AIsAndh2eVhfiZiLLTa2/yryV87h7hMWMlmcSfD63plrpGQdNqtmXUDr7IgI57ch7R
	 rtwu2U2aPGeaQ==
From: Will Deacon <will@kernel.org>
To: kvmarm@lists.linux.dev
Cc: linux-arm-kernel@lists.infradead.org,
	Will Deacon <will@kernel.org>,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Quentin Perret <qperret@google.com>,
	Fuad Tabba <tabba@google.com>,
	Vincent Donnefort <vdonnefort@google.com>,
	Mostafa Saleh <smostafa@google.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>
Subject: [PATCH v3 31/36] KVM: arm64: Add some initial documentation for pKVM
Date: Thu,  5 Mar 2026 14:43:44 +0000
Message-ID: <20260305144351.17071-32-will@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260305144351.17071-1-will@kernel.org>
References: <20260305144351.17071-1-will@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add some initial documentation for pKVM to help people understand what
is supported, the limitations of protected VMs when compared to
non-protected VMs and also what is left to do.

Signed-off-by: Will Deacon <will@kernel.org>
---
 .../admin-guide/kernel-parameters.txt         |   4 +-
 Documentation/virt/kvm/arm/index.rst          |   1 +
 Documentation/virt/kvm/arm/pkvm.rst           | 103 ++++++++++++++++++
 3 files changed, 106 insertions(+), 2 deletions(-)
 create mode 100644 Documentation/virt/kvm/arm/pkvm.rst

diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
index cb850e5290c2..c14d80204f88 100644
--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -3246,8 +3246,8 @@ Kernel parameters
 			for the host. To force nVHE on VHE hardware, add
 			"arm64_sw.hvhe=0 id_aa64mmfr1.vh=0" to the
 			command-line.
-			"nested" is experimental and should be used with
-			extreme caution.
+			"nested" and "protected" are experimental and should be
+			used with extreme caution.
 
 	kvm-arm.vgic_v3_group0_trap=
 			[KVM,ARM,EARLY] Trap guest accesses to GICv3 group-0
diff --git a/Documentation/virt/kvm/arm/index.rst b/Documentation/virt/kvm/arm/index.rst
index ec09881de4cf..0856b4942e05 100644
--- a/Documentation/virt/kvm/arm/index.rst
+++ b/Documentation/virt/kvm/arm/index.rst
@@ -10,6 +10,7 @@ ARM
    fw-pseudo-registers
    hyp-abi
    hypercalls
+   pkvm
    pvtime
    ptp_kvm
    vcpu-features
diff --git a/Documentation/virt/kvm/arm/pkvm.rst b/Documentation/virt/kvm/arm/pkvm.rst
new file mode 100644
index 000000000000..8258c93bed6e
--- /dev/null
+++ b/Documentation/virt/kvm/arm/pkvm.rst
@@ -0,0 +1,103 @@
+.. SPDX-License-Identifier: GPL-2.0
+
+====================
+Protected KVM (pKVM)
+====================
+
+**NOTE**: pKVM is currently an experimental, development feature and
+subject to breaking changes as new isolation features are implemented.
+Please reach out to the developers at kvmarm@lists.linux.dev if you have
+any questions.
+
+Overview
+========
+
+Booting a host kernel with '``kvm-arm.mode=protected``' enables
+"Protected KVM" (pKVM). During boot, pKVM installs a stage-2 identity
+map page-table for the host and uses it to isolate the hypervisor
+running at EL2 from the rest of the host running at EL1/0.
+
+If ``CONFIG_PROTECTED_VM_UAPI=y``, pKVM permits creation of protected
+virtual machines (pVMs) by passing the ``KVM_VM_TYPE_ARM_PROTECTED``
+machine type identifier to the ``KVM_CREATE_VM`` ioctl(). The hypervisor
+isolates pVMs from the host by unmapping pages from the stage-2 identity
+map as they are accessed by a pVM. Hypercalls are provided for a pVM to
+share specific regions of its IPA space back with the host, allowing
+for communication with the VMM. See hypercalls.rst for more details.
+
+Isolation mechanisms
+====================
+
+pKVM relies on a number of mechanisms to isolate PVMs from the host:
+
+CPU memory isolation
+--------------------
+
+Status: Isolation of anonymous memory and metadata pages.
+
+Metadata pages (e.g. page-table pages and '``struct kvm_vcpu``' pages)
+are donated from the host to the hypervisor during pVM creation and
+are consequently unmapped from the stage-2 identity map until the pVM is
+destroyed.
+
+Similarly to regular KVM, pages are lazily mapped into the guest in
+response to stage-2 page faults handled by the host. However, when
+running a pVM, these pages are first pinned and then unmapped from the
+stage-2 identity map as part of the donation procedure. This gives rise
+to some user-visible differences when compared to non-protected VMs,
+largely due to the lack of MMU notifiers:
+
+* Memslots cannot be moved or deleted once the pVM has started running.
+* Read-only memslots and dirty logging are not supported.
+* With the exception of swap, file-backed pages cannot be mapped into a
+  pVM.
+* Donated pages are accounted against ``RLIMIT_MLOCK`` and so the VMM
+  must have a sufficient resource limit or be granted ``CAP_IPC_LOCK``.
+  The lack of a runtime reclaim mechanism means that memory locked for
+  a pVM will remain locked until the pVM is destroyed.
+* Changes to the VMM address space (e.g. a ``MAP_FIXED`` mmap() over a
+  mapping associated with a memslot) are not reflected in the guest and
+  may lead to loss of coherency.
+* Accessing pVM memory that has not been shared back will result in the
+  delivery of a SIGSEGV.
+* If a system call accesses pVM memory that has not been shared back
+  then it will either return ``-EFAULT`` or forcefully reclaim the
+  memory pages. Reclaimed memory is zeroed by the hypervisor and a
+  subsequent attempt to access it in the pVM will return ``-EFAULT``
+  from the ``VCPU_RUN`` ioctl().
+
+CPU state isolation
+-------------------
+
+Status: **Unimplemented.**
+
+DMA isolation using an IOMMU
+----------------------------
+
+Status: **Unimplemented.**
+
+Proxying of Trustzone services
+------------------------------
+
+Status: FF-A and PSCI calls from the host are proxied by the pKVM
+hypervisor.
+
+The FF-A proxy ensures that the host cannot share pVM or hypervisor
+memory with Trustzone as part of a "confused deputy" attack.
+
+The PSCI proxy ensures that CPUs always have the stage-2 identity map
+installed when they are executing in the host.
+
+Protected VM firmware (pvmfw)
+-----------------------------
+
+Status: **Unimplemented.**
+
+Resources
+=========
+
+Quentin Perret's KVM Forum 2022 talk entitled "Protected KVM on arm64: A
+technical deep dive" remains a good resource for learning more about
+pKVM, despite some of the details having changed in the meantime:
+
+https://www.youtube.com/watch?v=9npebeVFbFw
-- 
2.53.0.473.g4a7958ca14-goog

