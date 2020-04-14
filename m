Return-Path: <SRS0=7dZW=56=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A7B19C2BA19
	for <kvmarm@archiver.kernel.org>; Tue, 14 Apr 2020 10:35:49 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 221162076D
	for <kvmarm@archiver.kernel.org>; Tue, 14 Apr 2020 10:35:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="GdDDuxOI"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 221162076D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BC8DC4B20D;
	Tue, 14 Apr 2020 06:35:48 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id zd2dXTLfgAdE; Tue, 14 Apr 2020 06:35:47 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 950404B1E6;
	Tue, 14 Apr 2020 06:35:47 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3C8A74B199
 for <kvmarm@lists.cs.columbia.edu>; Tue, 14 Apr 2020 06:35:46 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id n+CmAVMwB1AV for <kvmarm@lists.cs.columbia.edu>;
 Tue, 14 Apr 2020 06:35:45 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 28C394B0EB
 for <kvmarm@lists.cs.columbia.edu>; Tue, 14 Apr 2020 06:35:45 -0400 (EDT)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id CB11320644;
 Tue, 14 Apr 2020 10:35:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1586860543;
 bh=HTu//z0XJEwQHak8IhhTICmq+Sn+E6x+AwgA/JSk24U=;
 h=From:To:Cc:Subject:Date:From;
 b=GdDDuxOITRb32SG16cxJkfmqBTuSmracfzbNyUVwKew4s1O3QM+NM/R98myCM3cPx
 XTaXr0KwHIvinwf+MvYrsrRu/IweRRydVlcpKzNHYCuUZRrCw65GWADQUEzGaUhFUy
 n4Jq5dPPrVyFsFsg0UbzF/nKfLscOIXq69XcLrI4=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78]
 helo=why.lan) by disco-boy.misterjones.org with esmtpsa
 (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256) (Exim 4.92)
 (envelope-from <maz@kernel.org>)
 id 1jOIus-0036te-6Q; Tue, 14 Apr 2020 11:35:42 +0100
From: Marc Zyngier <maz@kernel.org>
To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
 kvm@vger.kernel.org
Subject: [PATCH 0/3] KVM: arm: vgic fixes for 5.7
Date: Tue, 14 Apr 2020 11:35:14 +0100
Message-Id: <20200414103517.2824071-1-maz@kernel.org>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, yuzenghui@huawei.com,
 eric.auger@redhat.com, Andre.Przywara@arm.com, julien@xen.org,
 james.morse@arm.com, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: Julien Grall <julien@xen.org>, Andre Przywara <Andre.Przywara@arm.com>
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

Here's a few fixes I've been piling on during the merge window.

The first patch improves the handling of the ACTIVE registers, which
we never synchronise on the read side (the distributor state can only
be updated when the vcpu exits). Let's fix it the same way we do it on
the write side (stop-the-world, read, restart). Yes, this is
expensive.

The last two patches deal with an issue where we consider the HW state
of an interrupt when responding to a userspace access. We should never
do this, as the guest shouldn't be running at this stage and if it is,
it is absolutely fine to return random bits to userspace. It could
also be that there is no active guest context at this stage, and you
end up with an Oops, which nobody really enjoys.

Marc Zyngier (3):
  KVM: arm: vgic: Synchronize the whole guest on GIC{D,R}_I{S,C}ACTIVER
    read
  KVM: arm: vgic: Only use the virtual state when userspace accesses
    enable bits
  KVM: arm: vgic-v2: Only use the virtual state when userspace accesses
    pending bits

 virt/kvm/arm/vgic/vgic-mmio-v2.c |  16 ++-
 virt/kvm/arm/vgic/vgic-mmio-v3.c |  20 ++--
 virt/kvm/arm/vgic/vgic-mmio.c    | 183 +++++++++++++++++++++++++------
 virt/kvm/arm/vgic/vgic-mmio.h    |  19 ++++
 4 files changed, 188 insertions(+), 50 deletions(-)

-- 
2.25.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
