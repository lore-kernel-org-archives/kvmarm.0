From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH 09/14] arm64: ssbd: Introduce thread flag to control
 userspace mitigation
Date: Thu, 24 May 2018 13:16:38 +0100
Message-ID: <833776ac-2b8c-b0f7-dcff-9c55afd67c65@arm.com>
References: <20180522150648.28297-1-marc.zyngier@arm.com>
 <20180522150648.28297-10-marc.zyngier@arm.com>
 <20180524120121.pjdw7qaybcsbf4fl@lakrids.cambridge.arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180524120121.pjdw7qaybcsbf4fl@lakrids.cambridge.arm.com>
Content-Language: en-GB
Sender: linux-kernel-owner@vger.kernel.org
To: Mark Rutland <mark.rutland@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, kvmarm@lists.cs.columbia.edu, Kees Cook <keescook@chromium.org>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Andy Lutomirski <luto@kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Thomas Gleixner <tglx@linutronix.de>
List-Id: kvmarm@lists.cs.columbia.edu

On 24/05/18 13:01, Mark Rutland wrote:
> On Tue, May 22, 2018 at 04:06:43PM +0100, Marc Zyngier wrote:
>> In order to allow userspace to be mitigated on demand, let's
>> introduce a new thread flag that prevents the mitigation from
>> being turned off when exiting to userspace, and doesn't turn
>> it on on entry into the kernel (with the assumtion that the
> 
> Nit: s/assumtion/assumption/
> 
>> mitigation is always enabled in the kernel itself).
>>
>> This will be used by a prctl interface introduced in a later
>> patch.
>>
>> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
> 
> On the assumption that this flag cannot be flipped while a task is in
> userspace:

Well, that's the case unless you get into the seccomp thing, which does
change TIF_SSBD on all threads of the task, without taking it to the
kernel first. That nicely breaks the state machine, and you end-up
running non-mitigated in the kernel. Oops.

I have a couple of patches fixing that, using a second flag
(TIF_SSBD_PENDING) that gets turned into the real thing on exit to
userspace. It's pretty ugly though.

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
