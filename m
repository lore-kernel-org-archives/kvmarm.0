Return-Path: <SRS0=jshR=CN=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8DD7EC43461
	for <kvmarm@archiver.kernel.org>; Fri,  4 Sep 2020 10:46:12 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 3C05920770
	for <kvmarm@archiver.kernel.org>; Fri,  4 Sep 2020 10:46:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="i8LsGKUG"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3C05920770
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E95644B39C;
	Fri,  4 Sep 2020 06:46:11 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Ikos-LfxwsUI; Fri,  4 Sep 2020 06:46:10 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id F15F94B399;
	Fri,  4 Sep 2020 06:46:06 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 53DCA4B386
 for <kvmarm@lists.cs.columbia.edu>; Fri,  4 Sep 2020 06:46:06 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 7pzELzegk9hU for <kvmarm@lists.cs.columbia.edu>;
 Fri,  4 Sep 2020 06:46:05 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 464844B284
 for <kvmarm@lists.cs.columbia.edu>; Fri,  4 Sep 2020 06:46:05 -0400 (EDT)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 68DFE208CA;
 Fri,  4 Sep 2020 10:46:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1599216364;
 bh=AZ+f7Dz4/WEN5Qfhq+/6+UbL+tyK0SNg961whhqXNhk=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=i8LsGKUGUnG2Y3ssHBL0sYw9TosbAeu0cVqqNEtkFLltwy+YLk70aAZnItg619DN+
 YuC1qhq0fGmKfT9upkB1PZcBbRwR8A2/vdQgSdJYixEi9WZoLmnjV8GLqr6ftR06aE
 ybabGOBwuu1RYdjOOah2bJoNNAfWQCYNwAGVqBmQ=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78]
 helo=why.lan) by disco-boy.misterjones.org with esmtpsa
 (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256) (Exim 4.92)
 (envelope-from <maz@kernel.org>)
 id 1kE9EI-0098oH-Tq; Fri, 04 Sep 2020 11:46:03 +0100
From: Marc Zyngier <maz@kernel.org>
To: Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 5/9] KVM: Documentation: Minor fixups
Date: Fri,  4 Sep 2020 11:45:26 +0100
Message-Id: <20200904104530.1082676-6-maz@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200904104530.1082676-1-maz@kernel.org>
References: <20200904104530.1082676-1-maz@kernel.org>
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: pbonzini@redhat.com, alexandru.elisei@arm.com,
 drjones@redhat.com, eric.auger@redhat.com, gshan@redhat.com,
 steven.price@arm.com, kernel-team@android.com,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
 kvm@vger.kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: kvm@vger.kernel.org, kernel-team@android.com,
 Steven Price <steven.price@arm.com>, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org
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

From: Andrew Jones <drjones@redhat.com>

In preparation for documenting a new capability let's fix up the
formatting of the current ones.

Signed-off-by: Andrew Jones <drjones@redhat.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Reviewed-by: Steven Price <steven.price@arm.com>
Link: https://lore.kernel.org/r/20200804170604.42662-6-drjones@redhat.com
---
 Documentation/virt/kvm/api.rst | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index eb3a1316f03e..49af23d2b462 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -6130,7 +6130,7 @@ HvCallSendSyntheticClusterIpi, HvCallSendSyntheticClusterIpiEx.
 8.21 KVM_CAP_HYPERV_DIRECT_TLBFLUSH
 -----------------------------------
 
-:Architecture: x86
+:Architectures: x86
 
 This capability indicates that KVM running on top of Hyper-V hypervisor
 enables Direct TLB flush for its guests meaning that TLB flush
@@ -6143,16 +6143,17 @@ in CPUID and only exposes Hyper-V identification. In this case, guest
 thinks it's running on Hyper-V and only use Hyper-V hypercalls.
 
 8.22 KVM_CAP_S390_VCPU_RESETS
+-----------------------------
 
-Architectures: s390
+:Architectures: s390
 
 This capability indicates that the KVM_S390_NORMAL_RESET and
 KVM_S390_CLEAR_RESET ioctls are available.
 
 8.23 KVM_CAP_S390_PROTECTED
+---------------------------
 
-Architecture: s390
-
+:Architectures: s390
 
 This capability indicates that the Ultravisor has been initialized and
 KVM can therefore start protected VMs.
-- 
2.27.0

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
