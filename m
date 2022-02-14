Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0654C433FE
	for <kvmarm@archiver.kernel.org>; Mon, 14 Feb 2022 16:58:31 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 68A7449E3F;
	Mon, 14 Feb 2022 11:58:31 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id y7YYUYPgEAUf; Mon, 14 Feb 2022 11:58:30 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0EFCB49F23;
	Mon, 14 Feb 2022 11:58:30 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A062F49E27
 for <kvmarm@lists.cs.columbia.edu>; Mon, 14 Feb 2022 11:58:27 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id nx97ZQjSaRZe for <kvmarm@lists.cs.columbia.edu>;
 Mon, 14 Feb 2022 11:58:26 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 66B0549ECB
 for <kvmarm@lists.cs.columbia.edu>; Mon, 14 Feb 2022 11:58:26 -0500 (EST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id E6CCF13D5;
 Mon, 14 Feb 2022 08:58:25 -0800 (PST)
Received: from monolith.localdoman (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 6809D3F70D;
 Mon, 14 Feb 2022 08:58:24 -0800 (PST)
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: will@kernel.org, julien.thierry.kdev@gmail.com, kvm@vger.kernel.org,
 kvmarm@lists.cs.columbia.edu, andre.przywara@arm.com,
 pierre.gondois@arm.com
Subject: [PATCH kvmtool 2/3] arm: Use pr_debug() to print memory layout when
 loading a firmware image
Date: Mon, 14 Feb 2022 16:58:29 +0000
Message-Id: <20220214165830.69207-3-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220214165830.69207-1-alexandru.elisei@arm.com>
References: <20220214165830.69207-1-alexandru.elisei@arm.com>
MIME-Version: 1.0
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

When loading a kernel image, kvmtool is nice enough to print a message
informing the user where the file was loaded in guest memory, which is very
useful for debugging. Do the same for the firmware image.

Commit e1c7c62afc7b ("arm: turn pr_info() into pr_debug() messages")
changed various pr_info() into pr_debug() messages to stop kvmtool from
cluttering stdout. Do the same when printing where the FDT has been copied
when loading a firmware image.

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 arm/kvm.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/arm/kvm.c b/arm/kvm.c
index 5aea18fedc3e..80d233f13d0b 100644
--- a/arm/kvm.c
+++ b/arm/kvm.c
@@ -218,6 +218,8 @@ bool kvm__load_firmware(struct kvm *kvm, const char *firmware_filename)
 
 	/* Kernel isn't loaded by kvm, point start address to firmware */
 	kvm->arch.kern_guest_start = fw_addr;
+	pr_debug("Loaded firmware to 0x%llx (%zd bytes)",
+		 kvm->arch.kern_guest_start, fw_sz);
 
 	/* Load dtb just after the firmware image*/
 	host_pos += fw_sz;
@@ -226,9 +228,9 @@ bool kvm__load_firmware(struct kvm *kvm, const char *firmware_filename)
 
 	kvm->arch.dtb_guest_start = ALIGN(host_to_guest_flat(kvm, host_pos),
 					  FDT_ALIGN);
-	pr_info("Placing fdt at 0x%llx - 0x%llx",
-		kvm->arch.dtb_guest_start,
-		kvm->arch.dtb_guest_start + FDT_MAX_SIZE);
+	pr_debug("Placing fdt at 0x%llx - 0x%llx",
+		 kvm->arch.dtb_guest_start,
+		 kvm->arch.dtb_guest_start + FDT_MAX_SIZE);
 
 	return true;
 }
-- 
2.31.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
