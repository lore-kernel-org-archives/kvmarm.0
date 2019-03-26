From: Steven Price <steven.price@arm.com>
Subject: Re: [RFC] arm/cpu: fix soft lockup panic after resuming from stop
Date: Tue, 26 Mar 2019 17:12:01 +0000
Message-ID: <0e1f903a-d445-6bef-3dfd-6d9f7f6a5f98@arm.com>
References: <1552370960-2061-1-git-send-email-guoheyi@huawei.com>
 <CAFEAcA-29Q-sTg2wLre0GJJCr2gfu89rg0vuTOf7cW5drE4d7Q@mail.gmail.com>
 <136f773f-9b08-a39b-3ecb-2c00ff290b49@arm.com>
 <22f57e8a-bdb0-ffeb-ab78-3e9e41cac66b@arm.com>
 <20190315085948.GB10950@e113682-lin.lund.arm.com>
 <ff1db661-13c2-50ff-940e-4a1d71bd0309@huawei.com>
 <101c5f17-9811-e2d0-ff3c-a0e64beee921@arm.com>
 <662367df-e702-dd0a-da83-f1b448c5f203@huawei.com>
 <1a315d48-1657-e50b-97ec-ead9c6c459c2@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3CEB04A2BE
 for <kvmarm@lists.cs.columbia.edu>; Tue, 26 Mar 2019 13:12:06 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id gtzLLpvtsX96 for <kvmarm@lists.cs.columbia.edu>;
 Tue, 26 Mar 2019 13:12:04 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DDDE04A2B6
 for <kvmarm@lists.cs.columbia.edu>; Tue, 26 Mar 2019 13:12:04 -0400 (EDT)
In-Reply-To: <1a315d48-1657-e50b-97ec-ead9c6c459c2@huawei.com>
Content-Language: en-GB
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Heyi Guo <guoheyi@huawei.com>, Christoffer Dall <christoffer.dall@arm.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>, qemu-arm <qemu-arm@nongnu.org>, QEMU Developers <qemu-devel@nongnu.org>, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

Hi Heyi,

On 26/03/2019 13:53, Heyi Guo wrote:
> I also tested save/restore operations, and observed that clock in guest
> would not jump after restoring either. If we consider guest clock not
> being synchronized with real wall clock as an issue, does it mean
> save/restore function has the same issue?

Basically at the moment when the guest isn't running you have a choice
of two behaviours:

 1. Stop (i.e. save/restore) CNTVCT - this means that the guest sees no
time occur. If the guest needs to have a concept of wall-clock time
(e.g. it communicates with other systems over a network) then this can
cause problems (e.g. timeouts might be wrong, certificates might start
appearing to be in the future etc).

 2. Leave CNTVCT running - the guest sees the time pass but interprets
the vCPUs as effectively having locked up. Linux will trigger the soft
lockup warning.

There are two ways of solving this, which match the two behaviours above:

 1. Provide the guest with a view of wall-clock time. The obvious way of
doing this is with a pvclock implementation like MSR_KVM_WALL_CLOCK_NEW
for x86.

 2. Inform the guest to ignore the apparent "soft-lockup". There's
already an ioctl for x86 for this: KVM_KVMCLOCK_CTRL

My preference is for option 1 - as this gives the guest a good view of
both the time that it is actually executing (useful for internal
watchdog timers like the soft-lockup one in Linux) and maintains a view
of wall-clock time (useful when communicating with other external
services - e.g. the a server on the internet). Your patch to QEMU
provides the first step of that, but as you mention there's much more to do.

One thing I haven't investigated in great detail is how KVM handles the
timer during various forms of suspend. In particular for suspend types
like full hibernation the host's physical counter will jump (quite
possibly backwards) - I haven't looked in detail how KVM presents this
to the guest. Hopefully not by making it go backwards!

I'm not sure how much time I'm going to have to look at this in the near
future, but please keep me in the loop if you decide to tackle any of this.

Thanks,

Steve
