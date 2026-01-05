Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 481DF32C926
	for <kvmarm@lists.linux.dev>; Mon,  5 Jan 2026 15:51:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767628274; cv=none; b=VXcE+GhKfwtRJxGxorl9ckbEZtl+kA+OShUIdm254H0/dQkY82fKO4KjZDa+3+9pJ5BhtobG2VfX49/JgcXHyKASZrufs23qMkEl8tSn57pWf0whf6T5TQfJj7ORyEY1yFE7Tq7DIWLVlDSSx1xiDNerkOeINe3qqhc8tFxyNI4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767628274; c=relaxed/simple;
	bh=z+ECzJROyQdWWU7EpyeiCPFMZT/79bbG51bzW+4nrIY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V9SML8bQ9dTGWHblaDbRZAJ1gHFVkwD6E3JOPEh6lo994HGjpwP8BgQrH249cOPpFB+PkhuEjwLwjyMpoqkOLeJ4mYO4SCN/OCd96diB8PVrsbPJne6kCcJMEenV9e4tqsC9LbdmXjtadLSfYRs4hzbznQ46RGzoCQr/Fr3cUlg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RKZ6ExlM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RKZ6ExlM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6548DC19422;
	Mon,  5 Jan 2026 15:51:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767628274;
	bh=z+ECzJROyQdWWU7EpyeiCPFMZT/79bbG51bzW+4nrIY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RKZ6ExlMtj2i5gtBpyNGEVPoyvAQFmA502jSn1cYYu3f8bDRUaiybGO+HKre2RPmY
	 fCMI+4+jGeAIkUqGFsNKl7eyU6cPyGMRN6fM0Ei53tULseptEbKEwoQSdKtWXySbuY
	 dk4TBEthW7liY/bS4EFIYfS1Z4qY55AvmeYwJW0I8CHUhs+caHJZc2FNAPTh7t2RrV
	 5TajTshsmE+bWzRoZGQ/a5REkJQejY/fsEZrVWMPd2qnxv+A3PCSmnor0LdczZRrAC
	 lL3QPqS9x7H7NE8Mh+f8NW/sW60x5SRRlCPHsUYJw48SVJuxEavkfdMf3C7yMT/Xga
	 awBQlHKOaHEMA==
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
	Mostafa Saleh <smostafa@google.com>
Subject: [PATCH 27/30] KVM: arm64: Add some initial documentation for pKVM
Date: Mon,  5 Jan 2026 15:49:35 +0000
Message-ID: <20260105154939.11041-28-will@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260105154939.11041-1-will@kernel.org>
References: <20260105154939.11041-1-will@kernel.org>
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
 Documentation/virt/kvm/arm/pkvm.rst           | 101 ++++++++++++++++++
 3 files changed, 104 insertions(+), 2 deletions(-)
 create mode 100644 Documentation/virt/kvm/arm/pkvm.rst

diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
index a8d0afde7f85..9939dc5654d2 100644
--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -3141,8 +3141,8 @@ Kernel parameters
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
index 000000000000..1882bde8cc0b
--- /dev/null
+++ b/Documentation/virt/kvm/arm/pkvm.rst
@@ -0,0 +1,101 @@
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
2.52.0.351.gbe84eed79e-goog

