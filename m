From: Alexander Graf <agraf@suse.de>
Subject: Re: [PATCH] KVM: arm/arm64: Handle forward time correction gracefully
Date: Wed, 6 Apr 2016 11:14:15 +0200
Message-ID: <5704D367.5040500@suse.de>
References: <1459931842-29465-1-git-send-email-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C9E1840B58
 for <kvmarm@lists.cs.columbia.edu>; Wed,  6 Apr 2016 05:12:57 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id JUC+955AQJni for <kvmarm@lists.cs.columbia.edu>;
 Wed,  6 Apr 2016 05:12:56 -0400 (EDT)
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id C3CA040402
 for <kvmarm@lists.cs.columbia.edu>; Wed,  6 Apr 2016 05:12:56 -0400 (EDT)
In-Reply-To: <1459931842-29465-1-git-send-email-marc.zyngier@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Marc Zyngier <marc.zyngier@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

On 04/06/2016 10:37 AM, Marc Zyngier wrote:
> On a host that runs NTP, corrections can have a direct impact on
> the background timer that we program on the behalf of a vcpu.
>
> In particular, NTP performing a forward correction will result in
> a timer expiring sooner than expected from a guest point of view.
> Not a big deal, we kick the vcpu anyway.
>
> But on wake-up, the vcpu thread is going to perform a check to
> find out whether or not it should block. And at that point, the
> timer check is going to say "timer has not expired yet, go back
> to sleep". This results in the timer event being lost forever.
>
> There are multiple ways to handle this. One would be record that
> the timer has expired and let kvm_cpu_has_pending_timer return
> true in that case, but that would be fairly invasive. Another is
> to check for the "short sleep" condition in the hrtimer callback,
> and restart the timer for the remaining time when the condition
> is detected.
>
> This patch implements the latter, with a bit of refactoring in
> order to avoid too much code duplication.
>
> Reported-by: Alexander Graf <agraf@suse.de>
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>

Looks good, I can give it a test run later as well, but for now

Reviewed-by: Alexander Graf <agraf@suse.de>


Alex
