From: Julien Grall <julien.grall@arm.com>
Subject: Re: [PATCH v3 1/9] clocksource: arm_arch_timer: Gather KVM specific
 information in a structure
Date: Wed, 9 Mar 2016 12:35:23 +0700
Message-ID: <56DFB61B.4040707@arm.com>
References: <1457436573-6180-1-git-send-email-julien.grall@arm.com>
 <1457436573-6180-2-git-send-email-julien.grall@arm.com>
 <20160309032343.GE26583@lvm>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3B8D2412ED
 for <kvmarm@lists.cs.columbia.edu>; Wed,  9 Mar 2016 00:35:30 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id PrQP+MeqcDgP for <kvmarm@lists.cs.columbia.edu>;
 Wed,  9 Mar 2016 00:35:29 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E0BB1412A2
 for <kvmarm@lists.cs.columbia.edu>; Wed,  9 Mar 2016 00:35:28 -0500 (EST)
In-Reply-To: <20160309032343.GE26583@lvm>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Christoffer Dall <christoffer.dall@linaro.org>
Cc: al.stone@linaro.org, kvm@vger.kernel.org, marc.zyngier@arm.com, Daniel Lezcano <daniel.lezcano@linaro.org>, linux-kernel@vger.kernel.org, fu.wei@linaro.org, Thomas Gleixner <tglx@linutronix.de>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

Hi Christoffer,

On 09/03/2016 10:23, Christoffer Dall wrote:
> On Tue, Mar 08, 2016 at 11:29:25AM +0000, Julien Grall wrote:
>> -static struct timecounter timecounter;
>> +static struct arch_timer_kvm_info arch_timer_kvm_info;
>> +
>> +struct arch_timer_kvm_info *arch_timer_get_kvm_info(void)
>
> borderline bikeshedding question:
>
> does it make sense that the info the arch timer code exports is labeled
> to be kvm-specific?  In other words, could we imagine another subsystem
> using this timer info some time and is there a more generic term that
> would be more appropriate?

I can't see any other usage. I would keep the function name KVM specific 
until someone really need similar information.

Cheers,

-- 
Julien Grall
