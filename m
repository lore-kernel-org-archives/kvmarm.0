From: Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 1/4] KVM: arm/arm64: vgic: Do not cond_resched_lock() with
 IRQs disabled
Date: Tue, 20 Nov 2018 13:25:31 +0000
Message-ID: <20181120132532.962F420851@mail.kernel.org>
References: <1542647279-46609-2-git-send-email-julien.thierry@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9E9394A2BD
 for <kvmarm@lists.cs.columbia.edu>; Tue, 20 Nov 2018 08:25:34 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 8pV9U8J9lZa7 for <kvmarm@lists.cs.columbia.edu>;
 Tue, 20 Nov 2018 08:25:34 -0500 (EST)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id E1D884A2BA
 for <kvmarm@lists.cs.columbia.edu>; Tue, 20 Nov 2018 08:25:33 -0500 (EST)
In-Reply-To: <1542647279-46609-2-git-send-email-julien.thierry@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Sasha Levin <sashal@kernel.org>, Julien Thierry <julien.thierry@arm.com>, linux-kernel@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Cc: Marc Zyngier <marc.zyngier@arm.com>, stable@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

Hi,

[This is an automated email]

This commit has been processed because it contains a -stable tag.
The stable tag indicates that it's relevant for the following trees: all

The bot has tested the following trees: v4.19.2, v4.18.19, v4.14.81, v4.9.137, v4.4.163, v3.18.125.

v4.19.2: Build OK!
v4.18.19: Build OK!
v4.14.81: Failed to apply! Possible dependencies:
    Unable to calculate

v4.9.137: Failed to apply! Possible dependencies:
    Unable to calculate

v4.4.163: Failed to apply! Possible dependencies:
    370a0ec18199 ("KVM: arm/arm64: Let vcpu thread modify its own active state")

v3.18.125: Failed to apply! Possible dependencies:
    370a0ec18199 ("KVM: arm/arm64: Let vcpu thread modify its own active state")


How should we proceed with this patch?

--
Thanks,
Sasha
