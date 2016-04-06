From: Alexander Graf <agraf@suse.de>
Subject: Re: [PATCH] KVM: arm/arm64: Handle forward time correction gracefully
Date: Wed, 6 Apr 2016 11:14:42 +0200
Message-ID: <5704D382.7010309@suse.de>
References: <1459931842-29465-1-git-send-email-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1459931842-29465-1-git-send-email-marc.zyngier@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Marc Zyngier <marc.zyngier@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
Cc: Christoffer Dall <christoffer.dall@linaro.org>
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

Oh - before I forget. This should go out with CC stable :)


Alex

