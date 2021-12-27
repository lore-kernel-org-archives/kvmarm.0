Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4DA02C433EF
	for <kvmarm@archiver.kernel.org>; Mon, 27 Dec 2021 21:17:13 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E729549EE5;
	Mon, 27 Dec 2021 16:17:12 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id skI+L0Wuya7c; Mon, 27 Dec 2021 16:17:11 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2259049EF7;
	Mon, 27 Dec 2021 16:17:11 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 34AD149EE3
 for <kvmarm@lists.cs.columbia.edu>; Mon, 27 Dec 2021 16:17:09 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id mquVFjbAboQQ for <kvmarm@lists.cs.columbia.edu>;
 Mon, 27 Dec 2021 16:17:08 -0500 (EST)
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 1B3CB49EDE
 for <kvmarm@lists.cs.columbia.edu>; Mon, 27 Dec 2021 16:17:08 -0500 (EST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ams.source.kernel.org (Postfix) with ESMTPS id 365F4B8115E;
 Mon, 27 Dec 2021 21:17:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 099C7C36AEF;
 Mon, 27 Dec 2021 21:17:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1640639826;
 bh=8jnTIlm8Zob2Jvux6Qz42yjEvf+iD+5kMVUVUXnj1ys=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=Q56PjvJIBDPFg9k+R/s7jSrr+hm/vcoXAPHyqveK2tK+tOZF4My4oU+D3fGM2JOxU
 jUyQuacheThXBYwn3eKWIod4ntDY14Wqy54ieL8EK13vzrkXe9cxeVE+3iqJ6wlF+P
 MCr6gHk23XNFjs9wBL2Dv4S3Q3SEivjB8rhtlQDulEstMsWTBCbMLP2ioAn+KVO/M2
 MYkOkzZD9ErsRWPfHGTPf8XcjoN/ogqYYUn/1x5TC0ekcNH/+6pPNrfl7X1dfCkS5o
 pDjuRmdzJpo27+OhxuYyYIFX/QTh+2+A5kVU+c+xJvX3CY8acZwo3iMSStu7WlhKgZ
 zPRSTJhcPlu0Q==
Received: from cfbb000407.r.cam.camfibre.uk ([185.219.108.64]
 helo=hot-poop.lan)
 by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.94.2)
 (envelope-from <maz@kernel.org>)
 id 1n1xMe-00Ed4b-4O; Mon, 27 Dec 2021 21:17:04 +0000
From: Marc Zyngier <maz@kernel.org>
To: qemu-devel@nongnu.org
Subject: [PATCH v3 5/5] hw/arm/virt: Disable highmem devices that don't fit in
 the PA range
Date: Mon, 27 Dec 2021 21:16:42 +0000
Message-Id: <20211227211642.994461-6-maz@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211227211642.994461-1-maz@kernel.org>
References: <20211227211642.994461-1-maz@kernel.org>
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: qemu-devel@nongnu.org, drjones@redhat.com,
 eric.auger@redhat.com, peter.maydell@linaro.org, kvmarm@lists.cs.columbia.edu,
 kvm@vger.kernel.org, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: kvm@vger.kernel.org, kernel-team@android.com, kvmarm@lists.cs.columbia.edu
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

Make sure both the highmem PCIe and GICv3 regions are disabled when
they don't fully fit in the PA range.

Reviewed-by: Andrew Jones <drjones@redhat.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 hw/arm/virt.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/hw/arm/virt.c b/hw/arm/virt.c
index 212079e7a6..18e615070f 100644
--- a/hw/arm/virt.c
+++ b/hw/arm/virt.c
@@ -1723,6 +1723,9 @@ static void virt_set_memmap(VirtMachineState *vms, int pa_bits)
     if (base <= BIT_ULL(pa_bits)) {
         vms->highest_gpa = base - 1;
     } else {
+        /* Advertise that we have disabled the highmem devices */
+        vms->highmem_ecam = false;
+        vms->highmem_redists = false;
         vms->highest_gpa = memtop - 1;
     }
 
-- 
2.30.2

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
