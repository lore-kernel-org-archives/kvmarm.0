From: Christopher Covington <cov@codeaurora.org>
Subject: [PATCHv2] arm: Fail on unknown subtest
Date: Thu,  1 Oct 2015 15:46:25 -0400
Message-ID: <1443728785-10461-1-git-send-email-cov@codeaurora.org>
References: <20150929154752.GA21067@hawk.localdomain>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20150929154752.GA21067@hawk.localdomain>
Sender: kvm-owner@vger.kernel.org
To: drjones@redhat.com, qemu-devel@nongnu.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Cc: Christopher Covington <cov@codeaurora.org>
List-Id: kvmarm@lists.cs.columbia.edu

Signed-off-by: Christopher Covington <cov@codeaurora.org>
---
 arm/selftest.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arm/selftest.c b/arm/selftest.c
index fc9ec60..f4a5030 100644
--- a/arm/selftest.c
+++ b/arm/selftest.c
@@ -376,6 +376,9 @@ int main(int argc, char **argv)
 		cpumask_set_cpu(0, &smp_reported);
 		while (!cpumask_full(&smp_reported))
 			cpu_relax();
+	} else {
+		printf("Unknown subtest\n");
+		abort();
 	}
 
 	return report_summary();
-- 
Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project

