Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58236C46467
	for <kvmarm@archiver.kernel.org>; Tue,  3 Jan 2023 09:50:47 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B099E4BB71;
	Tue,  3 Jan 2023 04:50:46 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 5de5fQP3R70f; Tue,  3 Jan 2023 04:50:46 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 53BE14BB89;
	Tue,  3 Jan 2023 04:50:45 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 35B874BB59
 for <kvmarm@lists.cs.columbia.edu>; Tue,  3 Jan 2023 04:50:44 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Ikc7mHa7cXTn for <kvmarm@lists.cs.columbia.edu>;
 Tue,  3 Jan 2023 04:50:44 -0500 (EST)
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 009BE40FBB
 for <kvmarm@lists.cs.columbia.edu>; Tue,  3 Jan 2023 04:50:43 -0500 (EST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ams.source.kernel.org (Postfix) with ESMTPS id 92183B80E70;
 Tue,  3 Jan 2023 09:50:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B188C433F0;
 Tue,  3 Jan 2023 09:50:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1672739441;
 bh=ksABWOILjZpEH8g2g2MW4ZIXOmX06sjGYHgn9lXfTFo=;
 h=From:To:Cc:Subject:Date:From;
 b=g5Jw+NnWDK6lM4inBLft9cmxDjeWejVbQgxI9tg+L9zjH/A2ju3GT3zmewDQMwA5C
 2OHIMEGvSdwMUDNI2gC+CY5H/AzwwgysbSbDOA/WCj7qlomkDH/xEwztbYMWf4qZB4
 +5chikFtIqXyNNgv8fHVb6t+iNdY6ufSM6sT7XB019cZjKFJvn3AhLZxLrQOFqC3fh
 AFnHFoUsQz+8Af5JhNts8kcktDUBEiC7tb/O1YKEWD0JHWk9bb1oJb7ry5iQzNo2Yp
 6aRt8kRsrVlcGrnnHG2o7Uba3VyafAHdM2u+KdtC6qXC8vhxIc+uaEv3Ji/TOyoxIg
 H62E2CzfWVPHg==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
 by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.95)
 (envelope-from <maz@kernel.org>) id 1pCdwN-00GTcP-3O;
 Tue, 03 Jan 2023 09:50:39 +0000
From: Marc Zyngier <maz@kernel.org>
To: <kvmarm@lists.cs.columbia.edu>,
	<kvmarm@lists.linux.dev>
Subject: [PATCH 0/3] KVM: arm64: M2 vgic maintenance interrupt rework pre-NV
Date: Tue,  3 Jan 2023 09:50:19 +0000
Message-Id: <20230103095022.3230946-1-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.cs.columbia.edu, kvmarm@lists.linux.dev,
 marcan@marcan.st, sven@svenpeter.dev, alyssa@rosenzweig.io, tglx@linutronix.de,
 will@kernel.org, catalin.marinas@arm.com, james.morse@arm.com,
 suzuki.poulose@arm.com, alexandru.elisei@arm.com, oliver.upton@linux.dev,
 asahi@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: linux-arm-kernel@lists.infradead.org, Sven Peter <sven@svenpeter.dev>,
 Catalin Marinas <catalin.marinas@arm.com>, Hector Martin <marcan@marcan.st>,
 linux-kernel@vger.kernel.org, asahi@lists.linux.dev,
 Thomas Gleixner <tglx@linutronix.de>, Will Deacon <will@kernel.org>,
 Alyssa Rosenzweig <alyssa@rosenzweig.io>
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

Hi all,

I've spent the holiday break reviving the Nested Virt KVM/arm64
implementation[1] and allowing it to work on the Apple M2 SoC. The
amusing part is that it actually works!

However, the way the vgic is implemented on this HW is still at odds
with the rest of the architecture, and requires some hacks, some of
which are independent of the actual NV code. This is what this series
is about.

The first patch places M2 on the naughty list of broken SEIS
implementations, just like the M1 before it. The second patch allows
a vgic MI to be registered, even if this MI cannot be masked (we
disable it at the source anyway). The last patch hacks the AIC driver
to actually register the vgic MI with KVM.

I plan to take the first patch as a fix for 6.2, while the rest can be
deferred to 6.3.

[1] https://git.kernel.org/pub/scm/linux/kernel/git/maz/arm-platforms.git/log/?h=kvm-arm64/nv-6.2-WIP

Marc Zyngier (3):
  KVM: arm64: vgic: Add Apple M2 cpus to the list of broken SEIS
    implementations
  KVM: arm64: vgic: Allow registration of a non-maskable maintenance
    interrupt
  irqchip/apple-aic: Register vgic maintenance interrupt with KVM

 arch/arm64/include/asm/cputype.h |  4 +++
 arch/arm64/kvm/vgic/vgic-init.c  |  2 +-
 arch/arm64/kvm/vgic/vgic-v3.c    |  3 +-
 drivers/irqchip/irq-apple-aic.c  | 55 ++++++++++++++++++++++++--------
 4 files changed, 49 insertions(+), 15 deletions(-)

-- 
2.34.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
