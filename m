From: James Morse <james.morse@arm.com>
Subject: Re: [PATCH v2] KVM: arm/arm64: Signal SIGBUS when stage2 discovers
 hwpoison memory
Date: Fri, 16 Jun 2017 12:32:13 +0100
Message-ID: <5943C1BD.9040301@arm.com>
References: <20170524163250.29281-1-james.morse@arm.com>
 <20170601222235.GN20919@cbox> <59313AEA.2060705@arm.com>
 <20170602104345.GA397@cbox> <5937CA43.7060108@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9675A40D1D
 for <kvmarm@lists.cs.columbia.edu>; Fri, 16 Jun 2017 07:28:40 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id NdSbDfIadlsj for <kvmarm@lists.cs.columbia.edu>;
 Fri, 16 Jun 2017 07:28:39 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7422640D17
 for <kvmarm@lists.cs.columbia.edu>; Fri, 16 Jun 2017 07:28:38 -0400 (EDT)
In-Reply-To: <5937CA43.7060108@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Christoffer Dall <cdall@linaro.org>
Cc: Marc Zyngier <marc.zyngier@arm.com>, Punit Agrawal <punit.agrawal@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

Hi Christoffer,

On 07/06/17 10:41, James Morse wrote:
> I evidently stopped before I got to the bottom of this, the commit message is
> based on the way I first hit this

I've worked out where I went wrong with this. memory_failure()/hwpoison has two
'modes', early and late. My testing was broken for 'early', but caused both to
happen at the same time, leading to this confusion.

The affected page was mapped and found in the rmap, it then gets unmapped by
memory_failure(), which then skipped the early notification because the flags
were wrong. Meanwhile the late notification fires at the same time on another CPU.

So, from the top:
-----%<-----
memory_failure() has two modes, early and late. Early is used by
machine-managers like Qemu to receive a notification when a memory error is
notified to the host. These can then be relayed to the guest before the affected
page is accessed. To enable this, the process must set PR_MCE_KILL_EARLY in
PR_MCE_KILL_SET using the prctl() syscall.

Once the early notification has been handled, nothing stops the machine-manager
or guest from accessing the affected page. If the machine-manager does this the
page will fail to be mapped and SIGBUS will be sent. This patch adds the
equivalent path for when the guest accesses the page, sending SIGBUS to the
machine-manager.

These two signals can be distinguished by the machine-manager using their
si_code: BUS_MCEERR_AO for 'action optional' early notifications, and
BUS_MCEERR_AR for 'action required' synchronous/late notifications.
-----%<-----

If this clears everything up I will post a v3 with the above as the commit message.


Thanks!

James
