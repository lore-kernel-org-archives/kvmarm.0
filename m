From: Matthias Brugger <mbrugger@suse.com>
Subject: [PATCH 4/4] arm64: hibernate: Check for broadcast TLBI support
Date: Thu,  4 Aug 2016 11:15:17 +0200
Message-ID: <1470302117-32296-5-git-send-email-mbrugger@suse.com>
References: <1470302117-32296-1-git-send-email-mbrugger@suse.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1470302117-32296-1-git-send-email-mbrugger@suse.com>
Sender: linux-kernel-owner@vger.kernel.org
To: pbonzini@redhat.com, rkrcmar@redhat.com, christoffer.dall@linaro.org, marc.zyngier@arm.com, linux@armlinux.org.uk, catalin.marinas@arm.com, will.deacon@arm.com
Cc: suzuki.poulose@arm.com, james.morse@arm.com, david.daney@cavium.com, rrichter@cavium.com, agraf@suse.de, mbrugger@suse.com, mark.rutland@arm.com, lorenzo.pieralisi@arm.com, dave.long@linaro.org, ard.biesheuvel@linaro.org, zlim.lnx@gmail.com, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, linux-kernel@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

Hibernation makes use of broadcast TLBI. Error out
early when this is not supported by the hardware.

Signed-off-by: Matthias Brugger <mbrugger@suse.com>
---
 arch/arm64/kernel/hibernate.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/arm64/kernel/hibernate.c b/arch/arm64/kernel/hibernate.c
index 21ab5df..7269642 100644
--- a/arch/arm64/kernel/hibernate.c
+++ b/arch/arm64/kernel/hibernate.c
@@ -481,6 +481,11 @@ static int check_boot_cpu_online_pm_callback(struct notifier_block *nb,
 
 static int __init check_boot_cpu_online_init(void)
 {
+	if (cpus_have_cap(ARM64_HAS_NO_BCAST_TLBI)) {
+		pr_err("Can't hibernate: missing broadcast TLBI support.\n");
+		return -EINVAL;
+	}
+
 	/*
 	 * Set this pm_notifier callback with a lower priority than
 	 * cpu_hotplug_pm_callback, so that cpu_hotplug_pm_callback will be
-- 
2.6.6
