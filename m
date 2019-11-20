Return-Path: <SRS0=7egO=ZM=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0 tests=INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14320C432C0
	for <kvmarm@archiver.kernel.org>; Wed, 20 Nov 2019 16:49:48 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id CAC722067D
	for <kvmarm@archiver.kernel.org>; Wed, 20 Nov 2019 16:49:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org CAC722067D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 848714A7FF;
	Wed, 20 Nov 2019 11:49:47 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id cyPe0hwoII-p; Wed, 20 Nov 2019 11:49:46 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 68C5F4AEC0;
	Wed, 20 Nov 2019 11:49:46 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 316574AEBA
 for <kvmarm@lists.cs.columbia.edu>; Wed, 20 Nov 2019 11:49:45 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id dMZwZEzUiv8H for <kvmarm@lists.cs.columbia.edu>;
 Wed, 20 Nov 2019 11:49:44 -0500 (EST)
Received: from inca-roads.misterjones.org (inca-roads.misterjones.org
 [213.251.177.50])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 0BD444A7FF
 for <kvmarm@lists.cs.columbia.edu>; Wed, 20 Nov 2019 11:49:44 -0500 (EST)
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78]
 helo=why.lan) by cheepnis.misterjones.org with esmtpsa
 (TLSv1.2:DHE-RSA-AES128-GCM-SHA256:128) (Exim 4.80)
 (envelope-from <maz@kernel.org>)
 id 1iXT4L-0007RI-OR; Wed, 20 Nov 2019 17:43:05 +0100
From: Marc Zyngier <maz@kernel.org>
To: Paolo Bonzini <pbonzini@redhat.com>,
 =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Subject: [PATCH 14/22] KVM: arm/arm64: Show halt poll counters in debugfs
Date: Wed, 20 Nov 2019 16:42:28 +0000
Message-Id: <20191120164236.29359-15-maz@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191120164236.29359-1-maz@kernel.org>
References: <20191120164236.29359-1-maz@kernel.org>
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: pbonzini@redhat.com, rkrcmar@redhat.com, graf@amazon.com,
 drjones@redhat.com, borntraeger@de.ibm.com, christoffer.dall@arm.com,
 eric.auger@redhat.com, xypron.glpk@gmx.de, julien.grall@arm.com,
 mark.rutland@arm.com, bigeasy@linutronix.de, steven.price@arm.com,
 tglx@linutronix.de, will@kernel.org, yuzenghui@huawei.com, james.morse@arm.com,
 julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com,
 linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org,
 kvmarm@lists.cs.columbia.edu
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on cheepnis.misterjones.org);
 SAEximRunCond expanded to false
Cc: kvm@vger.kernel.org, Heinrich Schuchardt <xypron.glpk@gmx.de>,
 Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
 Steven Price <steven.price@arm.com>,
 Christian Borntraeger <borntraeger@de.ibm.com>,
 Julien Grall <julien.grall@arm.com>, linux-arm-kernel@lists.infradead.org,
 Thomas Gleixner <tglx@linutronix.de>, Will Deacon <will@kernel.org>,
 kvmarm@lists.cs.columbia.edu
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

From: Christian Borntraeger <borntraeger@de.ibm.com>

ARM/ARM64 has counters halt_successful_poll, halt_attempted_poll,
halt_poll_invalid, and halt_wakeup but never exposed those in debugfs.

Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/1572164390-5851-1-git-send-email-borntraeger@de.ibm.com
---
 arch/arm/kvm/guest.c   | 4 ++++
 arch/arm64/kvm/guest.c | 4 ++++
 2 files changed, 8 insertions(+)

diff --git a/arch/arm/kvm/guest.c b/arch/arm/kvm/guest.c
index 684cf64b4033..66964642cd42 100644
--- a/arch/arm/kvm/guest.c
+++ b/arch/arm/kvm/guest.c
@@ -21,6 +21,10 @@
 #define VCPU_STAT(x) { #x, offsetof(struct kvm_vcpu, stat.x), KVM_STAT_VCPU }
 
 struct kvm_stats_debugfs_item debugfs_entries[] = {
+	VCPU_STAT(halt_successful_poll),
+	VCPU_STAT(halt_attempted_poll),
+	VCPU_STAT(halt_poll_invalid),
+	VCPU_STAT(halt_wakeup),
 	VCPU_STAT(hvc_exit_stat),
 	VCPU_STAT(wfe_exit_stat),
 	VCPU_STAT(wfi_exit_stat),
diff --git a/arch/arm64/kvm/guest.c b/arch/arm64/kvm/guest.c
index dfd626447482..260ea3158682 100644
--- a/arch/arm64/kvm/guest.c
+++ b/arch/arm64/kvm/guest.c
@@ -34,6 +34,10 @@
 #define VCPU_STAT(x) { #x, offsetof(struct kvm_vcpu, stat.x), KVM_STAT_VCPU }
 
 struct kvm_stats_debugfs_item debugfs_entries[] = {
+	VCPU_STAT(halt_successful_poll),
+	VCPU_STAT(halt_attempted_poll),
+	VCPU_STAT(halt_poll_invalid),
+	VCPU_STAT(halt_wakeup),
 	VCPU_STAT(hvc_exit_stat),
 	VCPU_STAT(wfe_exit_stat),
 	VCPU_STAT(wfi_exit_stat),
-- 
2.20.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
