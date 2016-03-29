From: Julien Grall <julien.grall@arm.com>
Subject: Re: [PATCH v4 9/9] clocksource: arm_arch_timer: Remove
 arch_timer_get_timecounter
Date: Tue, 29 Mar 2016 17:04:49 +0100
Message-ID: <56FAA7A1.2020507@arm.com>
References: <1458842023-31853-1-git-send-email-julien.grall@arm.com>
 <1458842023-31853-10-git-send-email-julien.grall@arm.com>
 <56FA9391.1040007@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <56FA9391.1040007@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Daniel Lezcano <daniel.lezcano@linaro.org>, kvmarm@lists.cs.columbia.edu
Cc: christoffer.dall@linaro.org, marc.zyngier@arm.com, fu.wei@linaro.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, wei@redhat.com, al.stone@linaro.org, gg@slimlogic.co.uk, Thomas Gleixner <tglx@linutronix.de>
List-Id: kvmarm@lists.cs.columbia.edu

On 29/03/16 15:39, Daniel Lezcano wrote:
> On 03/24/2016 06:53 PM, Julien Grall wrote:
>> The only call of arch_timer_get_timecounter (in KVM) has been removed.
>>
>> Signed-off-by: Julien Grall <julien.grall@arm.com>
>> Acked-by: Christoffer Dall <christoffer.dall@linaro.org>
>
> Hi Julien,

Hi Daniel,

> do you want me to take this patch through my tree ?

This patch depends on patch #7, so it's not possible to merge for now.

The plan suggested to merge the series is divided in 3 steps:

   1) Patch #1-#2 are merged via your tree
      Patch #2-#6 are merged via the irqchip-tree
   2) Patch #7-#8 are merged via the KVM tree
   3) Patch #9 (this patch) is merge via your tree

I can ping you when the steps 1 and 2 are completed.

Regards,

-- 
Julien Grall
