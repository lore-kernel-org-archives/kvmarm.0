From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: Vexpress TC2 no longer booting on v4.12-rc1
Date: Mon, 5 Jun 2017 08:43:41 +0100
Message-ID: <39e524be-188a-afcb-dca2-7e2a37bfcbb6@arm.com>
References: <CANLsYkz3dcVArStN2GJguYfJbWc_4dC4vvTE1KVtYpVWipEYjg@mail.gmail.com>
 <20170602222449.GB4902@n2100.armlinux.org.uk>
 <CANLsYkxmnfnCCCqowFjFDSryRkg=TKiTyjKL=VQnJYCyNJ5SgQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CD6DB40C47
 for <kvmarm@lists.cs.columbia.edu>; Mon,  5 Jun 2017 03:39:42 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id PL6z123EWgLN for <kvmarm@lists.cs.columbia.edu>;
 Mon,  5 Jun 2017 03:39:41 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A7F9340C1D
 for <kvmarm@lists.cs.columbia.edu>; Mon,  5 Jun 2017 03:39:41 -0400 (EDT)
In-Reply-To: <CANLsYkxmnfnCCCqowFjFDSryRkg=TKiTyjKL=VQnJYCyNJ5SgQ@mail.gmail.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Mathieu Poirier <mathieu.poirier@linaro.org>, Russell King - ARM Linux <linux@armlinux.org.uk>
Cc: Christoffer Dall <cdall@linaro.org>, kvm@vger.kernel.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Catalin Marinas <catalin.marinas@arm.com>, kvmarm@lists.cs.columbia.edu, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>
List-Id: kvmarm@lists.cs.columbia.edu

Hi Mathieu,

On 05/06/17 02:47, Mathieu Poirier wrote:
> On 2 June 2017 at 16:24, Russell King - ARM Linux <linux@armlinux.org.uk> wrote:
>> On Fri, Jun 02, 2017 at 04:16:59PM -0600, Mathieu Poirier wrote:
>>> Good afternoon Russell and friends,
>>>
>>> I noticed that my vexpress-TC2 platform stopped booting when moving to
>>> kernel v4.12-rc1 (same with -rc2 and 3).  The last time things worked
>>> properly was on v4.11.  I did a bisect between v4.11 and v4.12-rc1 and
>>> ended up on [1], hence this email.
>>>
>>> Since CONFIG_ARM_VIRT_EXT is selected by  default I removed the
>>> "#ifdef CONFIG_ARM_VIRT_EXT" section in the last hunk of the patch and
>>> the system sprung up to life again.
>>
>> Hmm, this doesn't make much sense.  The code in last hunk of the patch
>> you refer to should only get run during system shutdown, not during
>> system boot, so I think something else is going on...
>>
>> Please could you test again, this time rather than removing the #ifdef,
>> add two "mov r0, r0" there?  (So replacing the two instructions that
>> removing the ifdef would have exposed.)
> 
> That works - by replacing the original code with a couple of "mov r0,
> r0" the system is able to boot again.

That's quite peculiar. It would tend to indicate that something resets 
a CPU behind our back, leading to all kind of ugly things. Grepping
around, my bet is on MCPM, which seems to do all kind of horrible 
things. Can you give the following hack a go?

diff --git a/arch/arm/common/mcpm_entry.c b/arch/arm/common/mcpm_entry.c
index cf062472e07b..d8b6b688e938 100644
--- a/arch/arm/common/mcpm_entry.c
+++ b/arch/arm/common/mcpm_entry.c
@@ -300,7 +300,7 @@ void mcpm_cpu_power_down(void)
 	 * on the CPU.
 	 */
 	phys_reset = (phys_reset_t)(unsigned long)__pa_symbol(cpu_reset);
-	phys_reset(__pa_symbol(mcpm_entry_point));
+	phys_reset(__pa_symbol(mcpm_entry_point), is_hyp_mode_available());
 
 	/* should never get here */
 	BUG();
@@ -389,7 +389,7 @@ static int __init nocache_trampoline(unsigned long _arg)
 	__mcpm_cpu_down(cpu, cluster);
 
 	phys_reset = (phys_reset_t)(unsigned long)__pa_symbol(cpu_reset);
-	phys_reset(__pa_symbol(mcpm_entry_point));
+	phys_reset(__pa_symbol(mcpm_entry_point), is_hyp_mode_available());
 	BUG();
 }
 
Can you let me know if that helps? If it does, we can then think of cleaning
up the dangerous duplication of functionality...

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
