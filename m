From: Daniel Lezcano <daniel.lezcano@linaro.org>
Subject: Re: [PATCH v6 10/10] clocksource: arm_arch_timer: Remove
 arch_timer_get_timecounter
Date: Tue, 12 Apr 2016 07:44:47 +0200
Message-ID: <20160412054447.GC16636@linaro.org>
References: <1460388780-914-1-git-send-email-julien.grall@arm.com>
 <1460388780-914-11-git-send-email-julien.grall@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1460388780-914-11-git-send-email-julien.grall@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Julien Grall <julien.grall@arm.com>
Cc: kvmarm@lists.cs.columbia.edu, christoffer.dall@linaro.org, marc.zyngier@arm.com, fu.wei@linaro.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, wei@redhat.com, al.stone@linaro.org, gg@slimlogic.co.uk, hanjun.guo@linaro.org, Thomas Gleixner <tglx@linutronix.de>
List-Id: kvmarm@lists.cs.columbia.edu

On Mon, Apr 11, 2016 at 04:33:00PM +0100, Julien Grall wrote:
> The only call of arch_timer_get_timecounter (in KVM) has been removed.
> 
> Signed-off-by: Julien Grall <julien.grall@arm.com>
> Acked-by: Christoffer Dall <christoffer.dall@linaro.org>
> 
> ---
> Cc: Daniel Lezcano <daniel.lezcano@linaro.org>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> 
>     Changes in v4:
>         - Add Christoffer's acked-by
> 
>     Changes in v3:
>         - Patch added
> ---

Acked-by: Daniel Lezcano <daniel.lezcano@linaro.org>
