From: Julien Thierry <julien.thierry@arm.com>
Subject: [PATCH kvmtool 1/6] rtc: Initialize the Register D for MC146818 RTC
Date: Tue,  4 Dec 2018 11:14:28 +0000
Message-ID: <1543922073-55530-2-git-send-email-julien.thierry@arm.com>
References: <1543922073-55530-1-git-send-email-julien.thierry@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E26E54A342
 for <kvmarm@lists.cs.columbia.edu>; Tue,  4 Dec 2018 06:14:42 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ywNpuGCy6H77 for <kvmarm@lists.cs.columbia.edu>;
 Tue,  4 Dec 2018 06:14:41 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CD0B24A332
 for <kvmarm@lists.cs.columbia.edu>; Tue,  4 Dec 2018 06:14:41 -0500 (EST)
In-Reply-To: <1543922073-55530-1-git-send-email-julien.thierry@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Cc: Sami Mujawar <sami.mujawar@arm.com>, will.deacon@arm.com
List-Id: kvmarm@lists.cs.columbia.edu

From: Sami Mujawar <sami.mujawar@arm.com>

Some software drivers check the VRT bit (BIT7) of Register D before
using the MC146818 RTC. Initialized the VRT bit in rtc__init() to
indicate that the RAM and time contents are valid.

Signed-off-by: Sami Mujawar <sami.mujawar@arm.com>
Signed-off-by: Julien Thierry <julien.thierry@arm.com>
---
 hw/rtc.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/hw/rtc.c b/hw/rtc.c
index 0649b5d..c1fa72f 100644
--- a/hw/rtc.c
+++ b/hw/rtc.c
@@ -25,6 +25,11 @@
 #define RTC_REG_C			0x0C
 #define RTC_REG_D			0x0D
 
+/*
+ * Register D Bits
+ */
+#define RTC_REG_D_VRT			(1 << 7)
+
 struct rtc_device {
 	u8			cmos_idx;
 	u8			cmos_data[128];
@@ -140,6 +145,9 @@ int rtc__init(struct kvm *kvm)
 		return r;
 	}
 
+	/* Set the VRT bit in Register D to indicate valid RAM and time */
+	rtc.cmos_data[RTC_REG_D] = RTC_REG_D_VRT;
+
 	return r;
 }
 dev_init(rtc__init);
-- 
1.9.1
