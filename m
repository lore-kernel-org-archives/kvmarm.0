Return-Path: <SRS0=4KxT=LZ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 68BEFC11F6B
	for <kvmarm@archiver.kernel.org>; Thu,  1 Jul 2021 15:41:14 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id DCD076141D
	for <kvmarm@archiver.kernel.org>; Thu,  1 Jul 2021 15:41:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org DCD076141D
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5DF0C4ACC9;
	Thu,  1 Jul 2021 11:41:13 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@suse.com
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@suse.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id YlC9V51uDvIG; Thu,  1 Jul 2021 11:41:12 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5E9844B080;
	Thu,  1 Jul 2021 11:41:12 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 36C984A95C
 for <kvmarm@lists.cs.columbia.edu>; Thu,  1 Jul 2021 11:41:11 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id vV9+PEYuq0Iw for <kvmarm@lists.cs.columbia.edu>;
 Thu,  1 Jul 2021 11:41:10 -0400 (EDT)
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 16D304A7FD
 for <kvmarm@lists.cs.columbia.edu>; Thu,  1 Jul 2021 11:41:10 -0400 (EDT)
Received: from imap.suse.de (imap-alt.suse-dmz.suse.de [192.168.254.47])
 (using TLSv1.2 with cipher ECDHE-ECDSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by smtp-out1.suse.de (Postfix) with ESMTPS id A491022891;
 Thu,  1 Jul 2021 15:41:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
 t=1625154068; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
 mime-version:mime-version: content-transfer-encoding:content-transfer-encoding;
 bh=upovNwSZjv8f/iecsKALo/k8SCqL9R0LoxKlal4MHxw=;
 b=b4fYRKsHielTGsj+p0iJjnZfPn8+LTBhqB6ZyhTEUT9lDbF2wSVPpn6+4aTMKANIhTHdkw
 VgRt3j0/5duL08x9ABYMvZv+/vYaznkIaqmekSXYgQUAC+25fSOuVe1nsIuJwvXQ4zTv5z
 8mX/m1WcA9MsMHqfBDrh25S2ifLzPi8=
Received: from imap3-int (imap-alt.suse-dmz.suse.de [192.168.254.47])
 by imap.suse.de (Postfix) with ESMTP id 1D66011CD5;
 Thu,  1 Jul 2021 15:41:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
 t=1625154068; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
 mime-version:mime-version: content-transfer-encoding:content-transfer-encoding;
 bh=upovNwSZjv8f/iecsKALo/k8SCqL9R0LoxKlal4MHxw=;
 b=b4fYRKsHielTGsj+p0iJjnZfPn8+LTBhqB6ZyhTEUT9lDbF2wSVPpn6+4aTMKANIhTHdkw
 VgRt3j0/5duL08x9ABYMvZv+/vYaznkIaqmekSXYgQUAC+25fSOuVe1nsIuJwvXQ4zTv5z
 8mX/m1WcA9MsMHqfBDrh25S2ifLzPi8=
Received: from director2.suse.de ([192.168.254.72]) by imap3-int with ESMTPSA
 id lUxpBRTi3WAOFwAALh3uQQ
 (envelope-from <jgross@suse.com>); Thu, 01 Jul 2021 15:41:08 +0000
From: Juergen Gross <jgross@suse.com>
To: linux-kernel@vger.kernel.org, x86@kernel.org, kvm@vger.kernel.org,
 linux-doc@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH 0/6] x86/kvm: add boot parameters for max vcpu configs
Date: Thu,  1 Jul 2021 17:40:59 +0200
Message-Id: <20210701154105.23215-1-jgross@suse.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Cc: Juergen Gross <jgross@suse.com>, Marc Zyngier <maz@kernel.org>,
 Wanpeng Li <wanpengli@tencent.com>, Will Deacon <will@kernel.org>,
 Jonathan Corbet <corbet@lwn.net>, Sean Christopherson <seanjc@google.com>,
 Joerg Roedel <joro@8bytes.org>, kvmarm@lists.cs.columbia.edu,
 Catalin Marinas <catalin.marinas@arm.com>, Ingo Molnar <mingo@redhat.com>,
 Borislav Petkov <bp@alien8.de>, "H. Peter Anvin" <hpa@zytor.com>,
 Paolo Bonzini <pbonzini@redhat.com>, Vitaly Kuznetsov <vkuznets@redhat.com>,
 Thomas Gleixner <tglx@linutronix.de>, Jim Mattson <jmattson@google.com>
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

In order to be able to have a single kernel for supporting even huge
numbers of vcpus per guest some arrays should be sized dynamically.

The easiest way to do that is to add boot parameters for the maximum
number of vcpus and the highest supported vcpu-id overwriting the
normal default.

This patch series is doing that for x86. The same scheme can be easily
adapted to other architectures, but I don't want to do that in the
first iteration.

In the long term I'd suggest to have a per-guest setting of the two
parameters allowing to spare some memory for smaller guests. OTOH this
would require new ioctl()s and respective qemu modifications, so I let
those away for now.

I've tested the series not to break normal guest operation and the new
parameters to be effective on x86. For Arm64 I did a compile test only.

Juergen Gross (6):
  x86/kvm: fix vcpu-id indexed array sizes
  x86/kvm: remove non-x86 stuff from arch/x86/kvm/ioapic.h
  x86/kvm: add boot parameter for maximum vcpu-id
  x86/kvm: introduce per cpu vcpu masks
  kvm: allocate vcpu pointer array separately
  x86/kvm: add boot parameter for setting max number of vcpus per guest

 .../admin-guide/kernel-parameters.txt         | 18 +++++++
 arch/arm64/kvm/arm.c                          | 28 +++++++++--
 arch/x86/include/asm/kvm_host.h               | 22 ++++++---
 arch/x86/kvm/hyperv.c                         | 25 +++++++---
 arch/x86/kvm/ioapic.c                         | 14 +++++-
 arch/x86/kvm/ioapic.h                         |  8 +--
 arch/x86/kvm/irq_comm.c                       |  9 +++-
 arch/x86/kvm/x86.c                            | 49 ++++++++++++++++++-
 include/linux/kvm_host.h                      | 17 ++++++-
 9 files changed, 160 insertions(+), 30 deletions(-)

-- 
2.26.2

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
