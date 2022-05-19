Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F2B0CC433F5
	for <kvmarm@archiver.kernel.org>; Thu, 19 May 2022 13:48:24 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A908B4B4CC;
	Thu, 19 May 2022 09:48:24 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id g19Xy6ynhsPW; Thu, 19 May 2022 09:48:23 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5F5D24B4DD;
	Thu, 19 May 2022 09:48:23 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CF07D4B4CC
 for <kvmarm@lists.cs.columbia.edu>; Thu, 19 May 2022 09:48:21 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id YQb8ltO9LfMQ for <kvmarm@lists.cs.columbia.edu>;
 Thu, 19 May 2022 09:48:20 -0400 (EDT)
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 663F44B463
 for <kvmarm@lists.cs.columbia.edu>; Thu, 19 May 2022 09:48:20 -0400 (EDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ams.source.kernel.org (Postfix) with ESMTPS id 6AC2DB824B1;
 Thu, 19 May 2022 13:48:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1902C34100;
 Thu, 19 May 2022 13:48:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1652968098;
 bh=OyFqMF74W3M0ZJLxEHZqbx0RH1+q2b7I75jA3NgE6M0=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=Sz4Qvp4rwr5g8e+HWqFvIn6o9WgbBHyu5HzK01BvWg2WbaepceHeDw2Oz4wrGY8uO
 aM7RkaxjPEp0BlTRFMv2G7K2U6Y54m/l1hoIiKuOssQGg1p4i8o4JRpOE4JkhEUjtu
 y1viTLNwKan5or5hlpGg7/3bb5GdQ2sSqlFRtVt8Kw26H188iSXMKY6TNLO9J0IR0v
 09XbcaTj4KmKVntmkWy3hOmTiJBA1MJbGs/mTlm1mDdvISFqM46gbapaqFy9TNpQsw
 e3bHaqnQUCzRzxlAq/EASYphq1ah49F36RW2faizlxHl00uW96cYtRQcQ49lHdXwm4
 jsg7IDRuYuYAg==
From: Will Deacon <will@kernel.org>
To: kvmarm@lists.cs.columbia.edu
Subject: [PATCH 89/89] Documentation: KVM: Add some documentation for
 Protected KVM on arm64
Date: Thu, 19 May 2022 14:42:04 +0100
Message-Id: <20220519134204.5379-90-will@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20220519134204.5379-1-will@kernel.org>
References: <20220519134204.5379-1-will@kernel.org>
MIME-Version: 1.0
Cc: Marc Zyngier <maz@kernel.org>, kernel-team@android.com, kvm@vger.kernel.org,
 Andy Lutomirski <luto@amacapital.net>, linux-arm-kernel@lists.infradead.org,
 Michael Roth <michael.roth@amd.com>, Catalin Marinas <catalin.marinas@arm.com>,
 Chao Peng <chao.p.peng@linux.intel.com>, Will Deacon <will@kernel.org>
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

Add some initial documentation for the Protected KVM (pKVM) feature on
arm64, describing the user ABI for creating protected VMs as well as
their limitations.

Signed-off-by: Will Deacon <will@kernel.org>
---
 .../admin-guide/kernel-parameters.txt         |  4 +-
 Documentation/virt/kvm/arm/index.rst          |  1 +
 Documentation/virt/kvm/arm/pkvm.rst           | 96 +++++++++++++++++++
 3 files changed, 100 insertions(+), 1 deletion(-)
 create mode 100644 Documentation/virt/kvm/arm/pkvm.rst

diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
index 63a764ec7fec..b8841a969f59 100644
--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -2437,7 +2437,9 @@
 			      protected guests.
 
 			protected: nVHE-based mode with support for guests whose
-				   state is kept private from the host.
+				   state is kept private from the host. See
+				   Documentation/virt/kvm/arm/pkvm.rst for more
+				   information about this mode of operation.
 
 			Defaults to VHE/nVHE based on hardware support. Setting
 			mode to "protected" will disable kexec and hibernation
diff --git a/Documentation/virt/kvm/arm/index.rst b/Documentation/virt/kvm/arm/index.rst
index b4067da3fcb6..49c388df662a 100644
--- a/Documentation/virt/kvm/arm/index.rst
+++ b/Documentation/virt/kvm/arm/index.rst
@@ -9,6 +9,7 @@ ARM
 
    hyp-abi
    hypercalls
+   pkvm
    psci
    pvtime
    ptp_kvm
diff --git a/Documentation/virt/kvm/arm/pkvm.rst b/Documentation/virt/kvm/arm/pkvm.rst
new file mode 100644
index 000000000000..64f099a5ac2e
--- /dev/null
+++ b/Documentation/virt/kvm/arm/pkvm.rst
@@ -0,0 +1,96 @@
+.. SPDX-License-Identifier: GPL-2.0
+
+Protected virtual machines (pKVM)
+=================================
+
+Introduction
+------------
+
+Protected KVM (pKVM) is a KVM/arm64 extension which uses the two-stage
+translation capability of the Armv8 MMU to isolate guest memory from the host
+system. This allows for the creation of a confidential computing environment
+without relying on whizz-bang features in hardware, but still allowing room for
+complementary technologies such as memory encryption and hardware-backed
+attestation.
+
+The major implementation change brought about by pKVM is that the hypervisor
+code running at EL2 is now largely independent of (and isolated from) the rest
+of the host kernel running at EL1 and therefore additional hypercalls are
+introduced to manage manipulation of guest stage-2 page tables, creation of VM
+data structures and reclamation of memory on teardown. An immediate consequence
+of this change is that the host itself runs with an identity mapping enabled
+at stage-2, providing the hypervisor code with a mechanism to restrict host
+access to an arbitrary physical page.
+
+Enabling pKVM
+-------------
+
+The pKVM hypervisor is enabled by booting the host kernel at EL2 with
+"``kvm-arm.mode=protected``" on the command-line. Once enabled, VMs can be spawned
+in either protected or non-protected state, although the hypervisor is still
+responsible for managing most of the VM metadata in either case.
+
+Limitations
+-----------
+
+Enabling pKVM places some significant limitations on KVM guests, regardless of
+whether they are spawned in protected state. It is therefore recommended only
+to enable pKVM if protected VMs are required, with non-protected state acting
+primarily as a debug and development aid.
+
+If you're still keen, then here is an incomplete list of caveats that apply
+to all VMs running under pKVM:
+
+- Guest memory cannot be file-backed (with the exception of shmem/memfd) and is
+  pinned as it is mapped into the guest. This prevents the host from
+  swapping-out, migrating, merging or generally doing anything useful with the
+  guest pages. It also requires that the VMM has either ``CAP_IPC_LOCK`` or
+  sufficient ``RLIMIT_MEMLOCK`` to account for this pinned memory.
+
+- GICv2 is not supported and therefore GICv3 hardware is required in order
+  to expose a virtual GICv3 to the guest.
+
+- Read-only memslots are unsupported and therefore dirty logging cannot be
+  enabled.
+
+- Memslot configuration is fixed once a VM has started running, with subsequent
+  move or deletion requests being rejected with ``-EPERM``.
+
+- There are probably many others.
+
+Since the host is unable to tear down the hypervisor when pKVM is enabled,
+hibernation (``CONFIG_HIBERNATION``) and kexec (``CONFIG_KEXEC``) will fail
+with ``-EBUSY``.
+
+If you are not happy with these limitations, then please don't enable pKVM :)
+
+VM creation
+-----------
+
+When pKVM is enabled, protected VMs can be created by specifying the
+``KVM_VM_TYPE_ARM_PROTECTED`` flag in the machine type identifier parameter
+passed to ``KVM_CREATE_VM``.
+
+Protected VMs are instantiated according to a fixed vCPU configuration
+described by the ID register definitions in
+``arch/arm64/include/asm/kvm_pkvm.h``. Only a subset of the architectural
+features that may be available to the host are exposed to the guest and the
+capabilities advertised by ``KVM_CHECK_EXTENSION`` are limited accordingly,
+with the vCPU registers being initialised to their architecturally-defined
+values.
+
+Where not defined by the architecture, the registers of a protected vCPU
+are reset to zero with the exception of the PC and X0 which can be set
+either by the ``KVM_SET_ONE_REG`` interface or by a call to PSCI ``CPU_ON``.
+
+VM runtime
+----------
+
+By default, memory pages mapped into a protected guest are inaccessible to the
+host and any attempt by the host to access such a page will result in the
+injection of an abort at EL1 by the hypervisor. For accesses originating from
+EL0, the host will then terminate the current task with a ``SIGSEGV``.
+
+pKVM exposes additional hypercalls to protected guests, primarily for the
+purpose of establishing shared-memory regions with the host for communication
+and I/O. These hypercalls are documented in hypercalls.rst.
-- 
2.36.1.124.g0e6072fb45-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
