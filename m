From: Sudeep Holla <sudeep.holla@arm.com>
Subject: Re: [PATCH] arm64: KVM: unregister notifiers in hyp mode teardown path
Date: Mon, 4 Apr 2016 15:22:28 +0100
Message-ID: <570278A4.9060600@arm.com>
References: <1459777611-22592-1-git-send-email-sudeep.holla@arm.com>
 <5702726D.7000505@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 61929407A5
 for <kvmarm@lists.cs.columbia.edu>; Mon,  4 Apr 2016 10:21:18 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 6TGxycl8FVGg for <kvmarm@lists.cs.columbia.edu>;
 Mon,  4 Apr 2016 10:21:16 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9DA7A400E9
 for <kvmarm@lists.cs.columbia.edu>; Mon,  4 Apr 2016 10:21:15 -0400 (EDT)
In-Reply-To: <5702726D.7000505@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Marc Zyngier <marc.zyngier@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
Cc: Sudeep Holla <sudeep.holla@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu



On 04/04/16 14:55, Marc Zyngier wrote:
> Hi Sudeep,
>
> On 04/04/16 14:46, Sudeep Holla wrote:

[...]

>> @@ -1270,12 +1279,7 @@ static int init_hyp_mode(void)
>>   	free_boot_hyp_pgd();
>>   #endif
>>
>> -	cpu_notifier_register_begin();
>> -
>> -	err = __register_cpu_notifier(&hyp_init_cpu_nb);
>> -
>> -	cpu_notifier_register_done();
>> -
>> +	err = register_cpu_notifier(&hyp_init_cpu_nb);
>
> We went from something like this to the cpu_notifier_register_begin/end
> with 8146875de ("arm, kvm: Fix CPU hotplug callback registration").
>
> What makes it more acceptable now?
>

Correct, but in the initial code even init_hyp_mode was protected under
cpu_notifier_register_begin, but IIUC recent re-org eliminated the need
for that and the above code exactly resembles what register_cpu_notifier
does.

If that's not the case then we need to move cpu_notifier_register_begin
further up and retain __register_cpu_notifier

I mainly changed it to keep it consistent with unregister call.

-- 
Regards,
Sudeep
