Return-Path: <SRS0=WQmE=TD=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 24588C04AAA
	for <kvmarm@archiver.kernel.org>; Fri,  3 May 2019 12:47:58 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id AA5CF2081C
	for <kvmarm@archiver.kernel.org>; Fri,  3 May 2019 12:47:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org AA5CF2081C
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 52E774A53D;
	Fri,  3 May 2019 08:47:57 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id G-Wt-QQxfPOj; Fri,  3 May 2019 08:47:55 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id ED65D4A563;
	Fri,  3 May 2019 08:47:55 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 88E234A500
 for <kvmarm@lists.cs.columbia.edu>; Fri,  3 May 2019 08:47:54 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 2rbtKzyOSquM for <kvmarm@lists.cs.columbia.edu>;
 Fri,  3 May 2019 08:47:53 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 892664A5BD
 for <kvmarm@lists.cs.columbia.edu>; Fri,  3 May 2019 08:47:52 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.72.51.249])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 3B2781684;
 Fri,  3 May 2019 05:47:52 -0700 (PDT)
Received: from filthy-habits.cambridge.arm.com
 (filthy-habits.cambridge.arm.com [10.1.197.61])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 03E6C3F220;
 Fri,  3 May 2019 05:47:48 -0700 (PDT)
From: Marc Zyngier <marc.zyngier@arm.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
 =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Subject: [PATCH 54/56] arm64: docs: Document perf event attributes
Date: Fri,  3 May 2019 13:44:25 +0100
Message-Id: <20190503124427.190206-55-marc.zyngier@arm.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190503124427.190206-1-marc.zyngier@arm.com>
References: <20190503124427.190206-1-marc.zyngier@arm.com>
MIME-Version: 1.0
Cc: kvm@vger.kernel.org, Will Deacon <will.deacon@arm.com>,
 Kristina Martsenko <kristina.martsenko@arm.com>,
 "zhang . lei" <zhang.lei@jp.fujitsu.com>, Julien Grall <julien.grall@arm.com>,
 kvmarm@lists.cs.columbia.edu, Amit Daniel Kachhap <amit.kachhap@arm.com>,
 Dave Martin <Dave.Martin@arm.com>, linux-arm-kernel@lists.infradead.org
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

From: Andrew Murray <andrew.murray@arm.com>

The interaction between the exclude_{host,guest} flags,
exclude_{user,kernel,hv} flags and presence of VHE can result in
different exception levels being filtered by the ARMv8 PMU. As this
can be confusing let's document how they work on arm64.

Signed-off-by: Andrew Murray <andrew.murray@arm.com>
Reviewed-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Acked-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 Documentation/arm64/perf.txt | 85 ++++++++++++++++++++++++++++++++++++
 1 file changed, 85 insertions(+)
 create mode 100644 Documentation/arm64/perf.txt

diff --git a/Documentation/arm64/perf.txt b/Documentation/arm64/perf.txt
new file mode 100644
index 000000000000..0d6a7d87d49e
--- /dev/null
+++ b/Documentation/arm64/perf.txt
@@ -0,0 +1,85 @@
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
+For the host this attribute will exclude EL1 and additionally EL2 on a VHE
+system.
+
+For the guest this attribute will exclude EL1. Please note that EL2 is
+never counted within a guest.
+
+
+exclude_hv
+----------
+
+This attribute excludes the hypervisor.
+
+For a VHE host this attribute is ignored as we consider the host kernel to
+be the hypervisor.
+
+For a non-VHE host this attribute will exclude EL2 as we consider the
+hypervisor to be any code that runs at EL2 which is predominantly used for
+guest/host transitions.
+
+For the guest this attribute has no effect. Please note that EL2 is
+never counted within a guest.
+
+
+exclude_host / exclude_guest
+----------------------------
+
+These attributes exclude the KVM host and guest, respectively.
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
+The statements above also apply when these attributes are used within a
+non-VHE guest however please note that EL2 is never counted within a guest.
+
+
+Accuracy
+--------
+
+On non-VHE hosts we enable/disable counters on the entry/exit of host/guest
+transition at EL2 - however there is a period of time between
+enabling/disabling the counters and entering/exiting the guest. We are
+able to eliminate counters counting host events on the boundaries of guest
+entry/exit when counting guest events by filtering out EL2 for
+exclude_host. However when using !exclude_hv there is a small blackout
+window at the guest entry/exit where host events are not captured.
+
+On VHE systems there are no blackout windows.
-- 
2.20.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
