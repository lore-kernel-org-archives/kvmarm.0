From: zichao <zhichao.huang@linaro.org>
Subject: Re: [PATCH v2 09/11] KVM: arm: disable debug mode if we don't actually
 need it.
Date: Sun, 07 Jun 2015 22:08:38 +0800
Message-ID: <55745066.7070807@linaro.org>
References: <1433046432-1824-1-git-send-email-zhichao.huang@linaro.org>
 <1433046432-1824-10-git-send-email-zhichao.huang@linaro.org>
 <20150601101636.GF1641@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A6F1E53AD7
 for <kvmarm@lists.cs.columbia.edu>; Sun,  7 Jun 2015 09:58:41 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id A2Baqks4izMK for <kvmarm@lists.cs.columbia.edu>;
 Sun,  7 Jun 2015 09:58:40 -0400 (EDT)
Received: from mail-pd0-f171.google.com (mail-pd0-f171.google.com
 [209.85.192.171])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 9644C53952
 for <kvmarm@lists.cs.columbia.edu>; Sun,  7 Jun 2015 09:58:39 -0400 (EDT)
Received: by pdjn11 with SMTP id n11so45886423pdj.0
 for <kvmarm@lists.cs.columbia.edu>; Sun, 07 Jun 2015 07:08:51 -0700 (PDT)
In-Reply-To: <20150601101636.GF1641@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Will Deacon <will.deacon@arm.com>
Cc: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, Marc Zyngier <Marc.Zyngier@arm.com>, "huangzhichao@huawei.com" <huangzhichao@huawei.com>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>
List-Id: kvmarm@lists.cs.columbia.edu

Hi, Will,

On 2015/6/1 18:16, Will Deacon wrote:
> On Sun, May 31, 2015 at 05:27:10AM +0100, Zhichao Huang wrote:
>> Until now we enable debug mode all the time even if we don't
>> actually need it.
>>
>> Inspired by the implementation in arm64, disable debug mode if
>> we don't need it. And then we are able to reduce unnecessary
>> registers saving/restoring when the debug mode is disabled.
> 
> I'm terrified about this patch. Enabling monitor mode has proven to be
> *extremely* fragile in practice on 32-bit ARM SoCs, so trying to do this
> morei often makes me very nervous.
> 
>> Signed-off-by: Zhichao Huang <zhichao.huang@linaro.org>
>> ---
>>  arch/arm/kernel/hw_breakpoint.c | 55 ++++++++++++++++++++++++++++++++++-------
>>  1 file changed, 46 insertions(+), 9 deletions(-)
>>
>> diff --git a/arch/arm/kernel/hw_breakpoint.c b/arch/arm/kernel/hw_breakpoint.c
>> index dc7d0a9..1d27563 100644
>> --- a/arch/arm/kernel/hw_breakpoint.c
>> +++ b/arch/arm/kernel/hw_breakpoint.c
>> @@ -266,8 +266,7 @@ static int enable_monitor_mode(void)
>>  	}
>>  
>>  	/* Check that the write made it through. */
>> -	ARM_DBG_READ(c0, c1, 0, dscr);
>> -	if (!(dscr & ARM_DSCR_MDBGEN)) {
>> +	if (!monitor_mode_enabled()) {
>>  		pr_warn_once("Failed to enable monitor mode on CPU %d.\n",
>>  				smp_processor_id());
>>  		return -EPERM;
> 
> Ok, this hunk is harmless :)
> 
>> @@ -277,6 +276,43 @@ out:
>>  	return 0;
>>  }
>>  
>> +static int disable_monitor_mode(void)
>> +{
>> +	u32 dscr;
>> +
>> +	ARM_DBG_READ(c0, c1, 0, dscr);
>> +
>> +	/* If monitor mode is already disabled, just return. */
>> +	if (!(dscr & ARM_DSCR_MDBGEN))
>> +		goto out;
>> +
>> +	/* Write to the corresponding DSCR. */
>> +	switch (get_debug_arch()) {
>> +	case ARM_DEBUG_ARCH_V6:
>> +	case ARM_DEBUG_ARCH_V6_1:
>> +		ARM_DBG_WRITE(c0, c1, 0, (dscr & ~ARM_DSCR_MDBGEN));
>> +		break;
>> +	case ARM_DEBUG_ARCH_V7_ECP14:
>> +	case ARM_DEBUG_ARCH_V7_1:
>> +	case ARM_DEBUG_ARCH_V8:
>> +		ARM_DBG_WRITE(c0, c2, 2, (dscr & ~ARM_DSCR_MDBGEN));
>> +		isb();
>> +		break;
>> +	default:
>> +		return -ENODEV;
>> +	}
>> +
>> +	/* Check that the write made it through. */
>> +	if (monitor_mode_enabled()) {
>> +		pr_warn_once("Failed to disable monitor mode on CPU %d.\n",
>> +				smp_processor_id());
>> +		return -EPERM;
>> +	}
>> +
>> +out:
>> +	return 0;
>> +}
> 
> I'm not comfortable with this. enable_monitor_mode has precisly one caller
> [reset_ctrl_regs] which goes to some lengths to get the system into a
> well-defined state. On top of that, the whole thing is run with an undef
> hook registered because there isn't an architected way to discover whether
> or not DBGSWENABLE is driven low.
> 
> Why exactly do you need this? Can you not trap guest debug accesses some
> other way?

OK, I shall look for some other ways to reduce the overhead of world switch.

And another problem might be that, when we start an ARMv7 vm (specify CPU to
be Cortex-A57) on the ARMv8 platform, debug registers will always be saving/loading
because it is always detected that the debug mode is enabled even though we
didn't acutally use it.

> 
>>  int hw_breakpoint_slots(int type)
>>  {
>>  	if (!debug_arch_supported())
>> @@ -338,6 +374,8 @@ int arch_install_hw_breakpoint(struct perf_event *bp)
>>  	int i, max_slots, ctrl_base, val_base;
>>  	u32 addr, ctrl;
>>  
>> +	enable_monitor_mode();
>> +
>>  	addr = info->address;
>>  	ctrl = encode_ctrl_reg(info->ctrl) | 0x1;
>>  
>> @@ -430,6 +468,8 @@ void arch_uninstall_hw_breakpoint(struct perf_event *bp)
>>  
>>  	/* Reset the control register. */
>>  	write_wb_reg(base + i, 0);
>> +
>> +	disable_monitor_mode();
> 
> My previous concerns notwithstanding, shouldn't this be refcounted?

Maybe shouldn't in my opinion, because we install/uninstall breakpoints only when
we does context switch, and then we always install/uninstall all the breakpoints.

> 
> Will
> 
