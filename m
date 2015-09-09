From: Tushar Jagad <tushar.jagad@linaro.org>
Subject: [PATCH RFC 2/3] arm: cross cpu: add new properties for arm cpu
Date: Wed,  9 Sep 2015 08:42:11 +0000
Message-ID: <1441788132-6286-3-git-send-email-tushar.jagad@linaro.org>
References: <1441788132-6286-1-git-send-email-tushar.jagad@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 569D341145
 for <kvmarm@lists.cs.columbia.edu>; Wed,  9 Sep 2015 04:41:57 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id QEzeqVBYIMcD for <kvmarm@lists.cs.columbia.edu>;
 Wed,  9 Sep 2015 04:41:56 -0400 (EDT)
Received: from mail-pa0-f48.google.com (mail-pa0-f48.google.com
 [209.85.220.48])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 9182C41022
 for <kvmarm@lists.cs.columbia.edu>; Wed,  9 Sep 2015 04:41:56 -0400 (EDT)
Received: by pacfv12 with SMTP id fv12so3964204pac.2
 for <kvmarm@lists.cs.columbia.edu>; Wed, 09 Sep 2015 01:42:35 -0700 (PDT)
In-Reply-To: <1441788132-6286-1-git-send-email-tushar.jagad@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: qemu-devel@nongnu.org
Cc: marc.zyngier@arm.com, patches@apm.com, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

In order to support cross cpu for arm certain properties should be defined
by the datacenter admin. This is necessary for migrating guests to different
hardware platforms. CPU properties like number of breakpoints, watchpoints
and pmu counters are implementation specific. We need to restrict the guest
kernel to a specific count considering different mix of hardware platforms
in the datacenter.

This patch adds new properties for defining hardware in terms of number of
breakpoints, watchpoints and pmu counters supported in the guest.

Signed-off-by: Tushar Jagad <tushar.jagad@linaro.org>
---
 target-arm/cpu.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/target-arm/cpu.c b/target-arm/cpu.c
index 8b4323d..a07613e 100644
--- a/target-arm/cpu.c
+++ b/target-arm/cpu.c
@@ -1349,6 +1349,8 @@ static Property arm_cpu_properties[] = {
     DEFINE_PROP_BOOL("start-powered-off", ARMCPU, start_powered_off, false),
     DEFINE_PROP_UINT32("psci-conduit", ARMCPU, psci_conduit, 0),
     DEFINE_PROP_UINT32("midr", ARMCPU, midr, 0),
+    DEFINE_PROP_UINT32("bpts", ARMCPU, bpts, 0),
+    DEFINE_PROP_UINT32("wpts", ARMCPU, wpts, 0),
     DEFINE_PROP_END_OF_LIST()
 };
 
-- 
2.4.3
