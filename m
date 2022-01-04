Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2C278C433F5
	for <kvmarm@archiver.kernel.org>; Tue,  4 Jan 2022 16:45:02 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8F53749E21;
	Tue,  4 Jan 2022 11:45:02 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@intel.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Ekz+Op8EXhOE; Tue,  4 Jan 2022 11:45:01 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0039849F14;
	Tue,  4 Jan 2022 11:45:01 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 763A349E18
 for <kvmarm@lists.cs.columbia.edu>; Tue,  4 Jan 2022 10:19:37 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id jKkTL4Cd99gs for <kvmarm@lists.cs.columbia.edu>;
 Tue,  4 Jan 2022 10:19:35 -0500 (EST)
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 95BA640EE7
 for <kvmarm@lists.cs.columbia.edu>; Tue,  4 Jan 2022 10:19:35 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
 d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
 t=1641309575; x=1672845575;
 h=from:to:cc:subject:date:message-id:mime-version:
 content-transfer-encoding;
 bh=3VPnlsuCUvPLaUETzLQLxoEOT+xx0yEw/SG76Pt1U58=;
 b=iOlfuMOq86LN9nkVfxakLrwVK1gK7dSmVQKc9hXrj/oqAmZb/M25VFcN
 fgHbLT6xXSu5OOPGVRzI+Kosb6Mb9EtCN+cnJaMKt+ptTQ+6QoF1taWpZ
 XjGe/q+mMXP54l7O2x2IxvZ+eBw/DDMI1NY5YxDqxhXFw2ug2vGCh2jW9
 AqaD75BO2TCteR3HKLL7TjlsTuLcu2COS8t1KsiC+X21rihVAzZP/JF6x
 WRzo3MIi7VFzRjxNUJ+756LojEEVbqjrTpI+LJvx1CWlQKIJ3groRi620
 IT12flxrBCrvfs0IlNcEmQaotoUPlgMU8G4uznt93hxxBxDnsJq6d3HCV Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10216"; a="229058144"
X-IronPort-AV: E=Sophos;i="5.88,261,1635231600"; d="scan'208";a="229058144"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
 by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384;
 04 Jan 2022 07:19:34 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,261,1635231600"; d="scan'208";a="526081114"
Received: from black.fi.intel.com ([10.237.72.28])
 by orsmga008.jf.intel.com with ESMTP; 04 Jan 2022 07:19:32 -0800
Received: by black.fi.intel.com (Postfix, from userid 1003)
 id 84D64120; Tue,  4 Jan 2022 17:19:42 +0200 (EET)
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Marc Zyngier <maz@kernel.org>, linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.cs.columbia.edu, linux-kernel@vger.kernel.org
Subject: [PATCH v2 1/1] KVM: arm64: vgic: Replace kernel.h with the necessary
 inclusions
Date: Tue,  4 Jan 2022 17:19:40 +0200
Message-Id: <20220104151940.55399-1-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
X-Mailman-Approved-At: Tue, 04 Jan 2022 11:45:00 -0500
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
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

The arm_vgic.h does not require all the stuff the kernel.h provides.
Replace kernel.h inclusion with the list of what is really being used.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
v2: updated commit message by dropping unrelated paragraph (Marc)
 include/kvm/arm_vgic.h | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
index e602d848fc1a..bb30a6803d9f 100644
--- a/include/kvm/arm_vgic.h
+++ b/include/kvm/arm_vgic.h
@@ -5,9 +5,11 @@
 #ifndef __KVM_ARM_VGIC_H
 #define __KVM_ARM_VGIC_H
 
-#include <linux/kernel.h>
+#include <linux/bits.h>
 #include <linux/kvm.h>
 #include <linux/irqreturn.h>
+#include <linux/kref.h>
+#include <linux/mutex.h>
 #include <linux/spinlock.h>
 #include <linux/static_key.h>
 #include <linux/types.h>
-- 
2.34.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
