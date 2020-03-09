Return-Path: <SRS0=IHVC=42=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 04D54C10F27
	for <kvmarm@archiver.kernel.org>; Mon,  9 Mar 2020 12:48:50 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 7C4B420828
	for <kvmarm@archiver.kernel.org>; Mon,  9 Mar 2020 12:48:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="DByraDkc"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7C4B420828
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 005EB4A51E;
	Mon,  9 Mar 2020 08:48:49 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id vAXus1zHkM7c; Mon,  9 Mar 2020 08:48:47 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DFC5E4A51F;
	Mon,  9 Mar 2020 08:48:47 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 699084A523
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 Mar 2020 08:48:46 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ZFEJHLen-FlP for <kvmarm@lists.cs.columbia.edu>;
 Mon,  9 Mar 2020 08:48:45 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 557354005D
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 Mar 2020 08:48:45 -0400 (EDT)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 285F620727;
 Mon,  9 Mar 2020 12:48:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1583758124;
 bh=CSS+5INePZvmhimi/unCx0TEoioRr+d/iqq75Std27I=;
 h=From:To:Cc:Subject:Date:From;
 b=DByraDkcHaWW6E85jLzUQ23KZZw8zgL/sHKV0sqqrojbjcSmdvjv4QpPh1LVwr1w9
 BPEixptW++IaqFflCSjCZ5E03AGMNGh4mgsm58VieYChgPjUQaR/JwiZuTXPIjHuJW
 scaLyKQSpvuvNdN/wB1L2tH32qEregObfh7UZf+M=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78]
 helo=why.lan) by disco-boy.misterjones.org with esmtpsa
 (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256) (Exim 4.92)
 (envelope-from <maz@kernel.org>)
 id 1jBHpq-00BHiN-C7; Mon, 09 Mar 2020 12:48:42 +0000
From: Marc Zyngier <maz@kernel.org>
To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
 kvm@vger.kernel.org
Subject: [PATCH v2 0/2] KVM: arm64: Filtering PMU events
Date: Mon,  9 Mar 2020 12:48:35 +0000
Message-Id: <20200309124837.19908-1-maz@kernel.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, james.morse@arm.com,
 julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com, robin.murphy@arm.com,
 mark.rutland@arm.com, eric.auger@redhat.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: Robin Murphy <robin.murphy@arm.com>
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

It is at times necessary to prevent a guest from being able to sample
certain events if multiple CPUs share resources such as a cache level. In
this case, it would be interesting if the VMM could simply prevent certain
events from being counted instead of hiding the PMU.

Given that most events are not architected, there is no easy way to
designate which events shouldn't be counted other than specifying the raw
event number.

Since I have no idea whether it is better to use an event whitelist or
blacklist, the proposed API takes a cue from the x86 version and allows
either allowing or denying counting of ranges of events. The event space
being pretty large (16bits on ARMv8.1), the default policy is set by the
first filter that gets installed (default deny if we first allow, default
allow if we first deny).

The filter state is global to the guest, despite the PMU being per CPU. I'm
not sure whether it would be worth it making it CPU-private.

As an example of what can be done in userspace, I have the corresponding
kvmtool hack here[1].

* From v1:
  - Cleaned up handling of the cycle counter
  - Documented restrictions on SW_INC, CHAIN and CPU_CYCLES events

[1] https://git.kernel.org/pub/scm/linux/kernel/git/maz/kvmtool.git/commit/?h=pmu-filter

Marc Zyngier (2):
  KVM: arm64: Add PMU event filtering infrastructure
  KVM: arm64: Document PMU filtering API

 Documentation/virt/kvm/devices/vcpu.rst | 40 ++++++++++++
 arch/arm64/include/asm/kvm_host.h       |  6 ++
 arch/arm64/include/uapi/asm/kvm.h       | 16 +++++
 virt/kvm/arm/arm.c                      |  2 +
 virt/kvm/arm/pmu.c                      | 84 ++++++++++++++++++++-----
 5 files changed, 132 insertions(+), 16 deletions(-)

-- 
2.20.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
