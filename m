Return-Path: <SRS0=eeW8=Z4=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0272C43603
	for <kvmarm@archiver.kernel.org>; Fri,  6 Dec 2019 12:12:15 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 57F2A24659
	for <kvmarm@archiver.kernel.org>; Fri,  6 Dec 2019 12:12:15 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 57F2A24659
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E35424AF35;
	Fri,  6 Dec 2019 07:12:14 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Ndtq4N0SIyta; Fri,  6 Dec 2019 07:12:13 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C32454AF40;
	Fri,  6 Dec 2019 07:12:13 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 065404AF34
 for <kvmarm@lists.cs.columbia.edu>; Fri,  6 Dec 2019 07:12:13 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id lfzD+HEIgiCW for <kvmarm@lists.cs.columbia.edu>;
 Fri,  6 Dec 2019 07:12:11 -0500 (EST)
Received: from inca-roads.misterjones.org (inca-roads.misterjones.org
 [213.251.177.50])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id DE0554AE9D
 for <kvmarm@lists.cs.columbia.edu>; Fri,  6 Dec 2019 07:12:11 -0500 (EST)
Received: from www-data by cheepnis.misterjones.org with local (Exim 4.80)
 (envelope-from <maz@kernel.org>)
 id 1idCSw-0002KP-Gd; Fri, 06 Dec 2019 13:12:10 +0100
To: Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [PATCH v2] arm64: KVM: Invoke =?UTF-8?Q?compute=5Flayout=28?=
 =?UTF-8?Q?=29=20before=20alternatives=20are=20applied?=
X-PHP-Originating-Script: 0:main.inc
MIME-Version: 1.0
Date: Fri, 06 Dec 2019 12:12:10 +0000
From: Marc Zyngier <maz@kernel.org>
In-Reply-To: <20191206115716.GC32767@arrakis.emea.arm.com>
References: <20191016165953.o6ogh4fdmsjmd2sw@linutronix.de>
 <ecfbb413-e97e-c3eb-e051-1f218b387edd@arm.com>
 <20191128195805.c2pryug4ohmcoqwd@linutronix.de>
 <20191206115716.GC32767@arrakis.emea.arm.com>
Message-ID: <41a90c16d6958e70524c1c54b63a7f50@www.loen.fr>
X-Sender: maz@kernel.org
User-Agent: Roundcube Webmail/0.7.2
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Rcpt-To: catalin.marinas@arm.com, bigeasy@linutronix.de,
 james.morse@arm.com, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org, will@kernel.org,
 julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com, tglx@linutronix.de
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on cheepnis.misterjones.org);
 SAEximRunCond expanded to false
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
 linux-arm-kernel@lists.infradead.org, Thomas Gleixner <tglx@linutronix.de>,
 Will Deacon <will@kernel.org>, kvmarm@lists.cs.columbia.edu
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

On 2019-12-06 11:57, Catalin Marinas wrote:
> On Thu, Nov 28, 2019 at 08:58:05PM +0100, Sebastian Andrzej Siewior 
> wrote:
>> @@ -408,6 +410,8 @@ static void __init hyp_mode_check(void)
>>  			   "CPU: CPUs started in inconsistent modes");
>>  	else
>>  		pr_info("CPU: All CPU(s) started at EL1\n");
>> +	if (IS_ENABLED(CONFIG_KVM_ARM_HOST))
>> +		kvm_compute_layout();
>>  }
>
> It looks like we call this unconditionally here even if the kernel 
> was
> booted at EL1.

It has always been the case. My motivation was to be able to debug
this in a guest, because doing this on the host is... painful! ;-)

Feel free to condition it on !EL1 though.

>
>>  void __init smp_cpus_done(unsigned int max_cpus)
>> diff --git a/arch/arm64/kvm/va_layout.c b/arch/arm64/kvm/va_layout.c
>> index 2cf7d4b606c38..dab1fea4752aa 100644
>> --- a/arch/arm64/kvm/va_layout.c
>> +++ b/arch/arm64/kvm/va_layout.c
>> @@ -22,7 +22,7 @@ static u8 tag_lsb;
>>  static u64 tag_val;
>>  static u64 va_mask;
>>
>> -static void compute_layout(void)
>> +__init void kvm_compute_layout(void)
>>  {
>>  	phys_addr_t idmap_addr = __pa_symbol(__hyp_idmap_text_start);
>>  	u64 hyp_va_msb;
>> @@ -110,9 +110,6 @@ void __init kvm_update_va_mask(struct alt_instr 
>> *alt,
>>
>>  	BUG_ON(nr_inst != 5);
>>
>> -	if (!has_vhe() && !va_mask)
>> -		compute_layout();
>> -
>>  	for (i = 0; i < nr_inst; i++) {
>>  		u32 rd, rn, insn, oinsn;
>>
>> @@ -156,9 +153,6 @@ void kvm_patch_vector_branch(struct alt_instr 
>> *alt,
>>  		return;
>>  	}
>>
>> -	if (!va_mask)
>> -		compute_layout();
>
> And here we had a few more checks.
>
> Maybe it's still correct but asking anyway.

It should be correct. These checks were there to ensure that we only 
computed
the layout once, and this now happens by construction (calling 
compute_layout
from a single location instead of doing it from the patch callbacks).

Thanks,

        M.
-- 
Jazz is not dead. It just smells funny...
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
