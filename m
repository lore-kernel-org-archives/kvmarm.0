From: Julien Grall <julien.grall@arm.com>
Subject: Re: [PATCH v2 1/6] KVM: arm/arm64: arch_timer: Gather KVM specific
 information in a structure
Date: Fri, 19 Feb 2016 10:53:49 +0000
Message-ID: <56C6F43D.3010503@arm.com>
References: <1455204804-31830-1-git-send-email-julien.grall@arm.com>
 <1455204804-31830-2-git-send-email-julien.grall@arm.com>
 <56C6C318.3000205@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=WINDOWS-1252; format=flowed
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <56C6C318.3000205@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Wei Huang <wei@redhat.com>, kvmarm@lists.cs.columbia.edu
Cc: christoffer.dall@linaro.org, marc.zyngier@arm.com, fu.wei@linaro.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, al.stone@linaro.org, Daniel Lezcano <daniel.lezcano@linaro.org>, Thomas Gleixner <tglx@linutronix.de>, Gleb Natapov <gleb@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>
List-Id: kvmarm@lists.cs.columbia.edu

Hello Wei,

On 19/02/16 07:24, Wei Huang wrote:
> On 02/11/2016 09:33 AM, Julien Grall wrote:

[...]

>> This is also dropping arch_timer_get_timecounter as it was only used by
>> the KVM code. Furthermore, a stub for the new helper hasn't been
>> introduced because KVM is requiring the arch timer for both ARM64 and
>> ARM32.


[...]

>> -static inline struct timecounter *arch_timer_get_timecounter(void)
>> -{
>> -    return NULL;
>> -}
>> -
>
> Most parts are OK. Regarding removing this function from the #else area,
> is there a possibility to have CONFIG_ARM_ARCH_TIMER=n and CONFIG_KVM=y.
> If so, will the compilation fails here?

This patch is removing arch_timer_get_timecounter. So it's normal to
drop the stub in the #else area.

Furthermore, as mentioned in the commit message, I didn't add a stub for
the new function because KVM mandates the arch timer for both ARM64 and
ARM32.

Regards,
