Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 458F2C433F5
	for <kvmarm@archiver.kernel.org>; Wed, 22 Dec 2021 20:07:45 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B2B6940C9C;
	Wed, 22 Dec 2021 15:07:44 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@intel.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id owFbSRx14Dg8; Wed, 22 Dec 2021 15:07:43 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5907C40D26;
	Wed, 22 Dec 2021 15:07:43 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CCC8140BDB
 for <kvmarm@lists.cs.columbia.edu>; Wed, 22 Dec 2021 11:55:53 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id UR3OJ8WOrs3z for <kvmarm@lists.cs.columbia.edu>;
 Wed, 22 Dec 2021 11:55:52 -0500 (EST)
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 4A13840BC2
 for <kvmarm@lists.cs.columbia.edu>; Wed, 22 Dec 2021 11:55:52 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
 d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
 t=1640192152; x=1671728152;
 h=from:to:cc:subject:date:message-id:mime-version:
 content-transfer-encoding;
 bh=zn+R305IguXUmjbxhooWhM4nYIBAkbNRb9VmYzm7JcQ=;
 b=lYuHvzVzDI4X/4f8zD4Mncr8xXLQR1zfCMl4lk0Nu4XoYrjNr43cg4+D
 afxbYVJeUBKHhym1pwPNV15Mmel6rk2GJ7ZUj3GYXQo/AChbgb23xCu/P
 Tg9VIRAMdYm7TGKAnLHjZ4WNyBiJkTpkYh09WTADazsZA99gJtniSDKQd
 p4FEWdm14A/+c9gLbsMGl7KVqQnwsrEe0uccMkZh9vxRLmea/DUIXKBCq
 Wkb3jRVLOYX9gG39QcRQLOHl2lMEoQYhp/mR2w/xONJnYrQ8LIKxnkxvq
 mt+/vmsaXEWQnrCcqpsBmyOw78jx+K8BKiLtagienWGXZI5DI8yGwLe9Q Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10206"; a="326965095"
X-IronPort-AV: E=Sophos;i="5.88,227,1635231600"; d="scan'208";a="326965095"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
 by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384;
 22 Dec 2021 08:55:50 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,227,1635231600"; d="scan'208";a="685081716"
Received: from black.fi.intel.com ([10.237.72.28])
 by orsmga005.jf.intel.com with ESMTP; 22 Dec 2021 08:55:48 -0800
Received: by black.fi.intel.com (Postfix, from userid 1003)
 id 7DAC2FE; Wed, 22 Dec 2021 18:55:56 +0200 (EET)
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Marc Zyngier <maz@kernel.org>, linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.cs.columbia.edu, linux-kernel@vger.kernel.org
Subject: [PATCH v1 1/1] KVM: arm64: vgic: Replace kernel.h with the necessary
 inclusions
Date: Wed, 22 Dec 2021 18:55:52 +0200
Message-Id: <20211222165552.69288-1-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
X-Mailman-Approved-At: Wed, 22 Dec 2021 15:07:42 -0500
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

When kernel.h is used in the headers it adds a lot into dependency hell,
especially when there are circular dependencies are involved.

Replace kernel.h inclusion with the list of what is really being used.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
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
