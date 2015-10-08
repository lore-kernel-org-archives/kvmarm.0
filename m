From: Pavel Fedin <p.fedin@samsung.com>
Subject: RE: [PATCH v3 00/16] KVM: arm64: GICv3 ITS emulation
Date: Thu, 08 Oct 2015 11:41:49 +0300
Message-ID: <005301d101a5$35700360$a0500a20$@samsung.com>
References: <1444229726-31559-1-git-send-email-andre.przywara@arm.com>
 <029601d1011a$026e1000$074a3000$@samsung.com> <561546AF.90903@arm.com>
 <02c301d1012b$42cb8270$c8628750$@samsung.com>
 <20151007204810.66e2b1d6@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 714BB419A9
 for <kvmarm@lists.cs.columbia.edu>; Thu,  8 Oct 2015 04:40:14 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id HrDKh8UFAKNZ for <kvmarm@lists.cs.columbia.edu>;
 Thu,  8 Oct 2015 04:40:12 -0400 (EDT)
Received: from mailout2.w1.samsung.com (mailout2.w1.samsung.com
 [210.118.77.12])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id E34D541338
 for <kvmarm@lists.cs.columbia.edu>; Thu,  8 Oct 2015 04:40:08 -0400 (EDT)
Received: from eucpsbgm1.samsung.com (unknown [203.254.199.244])
 by mailout2.w1.samsung.com
 (Oracle Communications Messaging Server 7.0.5.31.0 64bit (built May 5 2014))
 with ESMTP id <0NVW00J95865R060@mailout2.w1.samsung.com> for
 kvmarm@lists.cs.columbia.edu; Thu, 08 Oct 2015 09:42:05 +0100 (BST)
In-reply-to: <20151007204810.66e2b1d6@arm.com>
Content-language: ru
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: 'Marc Zyngier' <marc.zyngier@arm.com>
Cc: kvm@vger.kernel.org, 'Andre Przywara' <andre.przywara@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

 Hello!

 Sorry for taking up your time, and thank you very much for the explanation.

> I'd appreciate if you could try to read and understand the architecture
> spec instead of randomly googling and quoting various bits of
> irrelevant information.

 I give my apologizes for not having time to read the whole specs from beginning to the end. Can
only add that it's quite weird to have these important things in "Terminology" section. I would
expect them to be in 6.1, for example. That was the part i read, but failed to find the exact
answer:
--- cut ---
LPIs do not have an active state, and transition to the inactive state on being acknowledged by a PE
--- cut ---

Kind regards,
Pavel Fedin
Expert Engineer
Samsung Electronics Research center Russia
