From: Andrew Murray <andrew.murray@arm.com>
Subject: [PATCH v12 8/8] arm64: docs: document perf event attributes
Date: Thu, 28 Mar 2019 10:37:31 +0000
Message-ID: <20190328103731.27264-9-andrew.murray@arm.com>
References: <20190328103731.27264-1-andrew.murray@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7E9754A424
 for <kvmarm@lists.cs.columbia.edu>; Thu, 28 Mar 2019 06:37:57 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id kCRYoNou16mt for <kvmarm@lists.cs.columbia.edu>;
 Thu, 28 Mar 2019 06:37:56 -0400 (EDT)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 06D4F4A44E
 for <kvmarm@lists.cs.columbia.edu>; Thu, 28 Mar 2019 06:37:56 -0400 (EDT)
In-Reply-To: <20190328103731.27264-1-andrew.murray@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Christoffer Dall <christoffer.dall@arm.com>, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Mark Rutland <mark.rutland@arm.com>
Cc: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

The interaction between the exclude_{host,guest} flags,
exclude_{user,kernel,hv} flags and presence of VHE can result in
different exception levels being filtered by the ARMv8 PMU. As this
can be confusing let's document how they work on arm64.

Signed-off-by: Andrew Murray <andrew.murray@arm.com>
---
 Documentation/arm64/perf.txt | 74 ++++++++++++++++++++++++++++++++++++
 1 file changed, 74 insertions(+)
 create mode 100644 Documentation/arm64/perf.txt

diff --git a/Documentation/arm64/perf.txt b/Documentation/arm64/perf.txt
new file mode 100644
index 000000000000..604446c1f720
--- /dev/null
+++ b/Documentation/arm64/perf.txt
@@ -0,0 +1,74 @@
+Perf Event Attributes
+=====================
+
+Author: Andrew Murray <andrew.murray@arm.com>
+Date: 2019-03-06
+
+exclude_user
+------------
+
+This attribute excludes userspace.
+
+Userspace always runs at EL0 and thus this attribute will exclude EL0.
+
+
+exclude_kernel
+--------------
+
+This attribute excludes the kernel.
+
+The kernel runs at EL2 with VHE and EL1 without. Guest kernels always run
+at EL1.
+
+This attribute will exclude EL1 and additionally EL2 on a VHE system.
+
+
+exclude_hv
+----------
+
+This attribute excludes the hypervisor, we ignore this flag on a VHE system
+as we consider the host kernel to be the hypervisor.
+
+On a non-VHE system we consider the hypervisor to be any code that runs at
+EL2 which is predominantly used for guest/host transitions.
+
+This attribute will exclude EL2 on a non-VHE system.
+
+
+exclude_host / exclude_guest
+----------------------------
+
+This attribute excludes the KVM host.
+
+The KVM host may run at EL0 (userspace), EL1 (non-VHE kernel) and EL2 (VHE
+kernel or non-VHE hypervisor).
+
+The KVM guest may run at EL0 (userspace) and EL1 (kernel).
+
+Due to the overlapping exception levels between host and guests we cannot
+exclusively rely on the PMU's hardware exception filtering - therefore we
+must enable/disable counting on the entry and exit to the guest. This is
+performed differently on VHE and non-VHE systems.
+
+For non-VHE systems we exclude EL2 for exclude_host - upon entering and
+exiting the guest we disable/enable the event as appropriate based on the
+exclude_host and exclude_guest attributes.
+
+For VHE systems we exclude EL1 for exclude_guest and exclude both EL0,EL2
+for exclude_host. Upon entering and exiting the guest we modify the event
+to include/exclude EL0 as appropriate based on the exclude_host and
+exclude_guest attributes.
+
+
+Accuracy
+--------
+
+On non-VHE systems we enable/disable counters on the entry/exit of
+host/guest transition at EL2 - however there is a period of time between
+enabling/disabling the counters and entering/exiting the guest. We are
+able to eliminate counters counting host events on the boundaries of guest
+entry/exit when counting guest events by filtering out EL2 for
+exclude_host. However when using !exclude_hv there is a small blackout
+window at the guest entry/exit where host events are not captured.
+
+On VHE systems there are no blackout windows.
-- 
2.21.0
