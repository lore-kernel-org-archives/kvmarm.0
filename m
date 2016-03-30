From: James Morse <james.morse@arm.com>
Subject: Re: [PATCH] arm64: KVM: Register CPU notifiers when the kernel runs
 at HYP
Date: Wed, 30 Mar 2016 17:46:41 +0100
Message-ID: <56FC02F1.5060804@arm.com>
References: <1459353370-589-1-git-send-email-james.morse@arm.com>
 <56FBFF12.60109@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CD72D41390
 for <kvmarm@lists.cs.columbia.edu>; Wed, 30 Mar 2016 12:47:12 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 6mGFxqholt-U for <kvmarm@lists.cs.columbia.edu>;
 Wed, 30 Mar 2016 12:47:12 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0655C412ED
 for <kvmarm@lists.cs.columbia.edu>; Wed, 30 Mar 2016 12:47:11 -0400 (EDT)
In-Reply-To: <56FBFF12.60109@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On 30/03/16 17:30, Marc Zyngier wrote:
>> diff --git a/arch/arm/kvm/arm.c b/arch/arm/kvm/arm.c
>> index 6accd66d26f0..cf0184edf4f5 100644
>> --- a/arch/arm/kvm/arm.c
>> +++ b/arch/arm/kvm/arm.c
>> @@ -1084,9 +1092,13 @@ static int hyp_init_cpu_pm_notifier(struct notifier_block *self,
>>  				    unsigned long cmd,
>>  				    void *v)
>>  {
>> -	if (cmd == CPU_PM_EXIT &&
>> -	    __hyp_get_vectors() == hyp_default_vectors) {
>> -		cpu_init_hyp_mode(NULL);
>> +	if (cmd == CPU_PM_EXIT) {
>> +		if (is_kernel_in_hyp_mode()) {
>> +			cpu_init_stage2(NULL);
>> +		} else {
>> +			if (__hyp_get_vectors() == hyp_default_vectors)
>> +				cpu_init_hyp_mode(NULL);
>> +		}
> 
> Any reason why we can't isolate that snippet in a separate function and
> use it in both locations?

I thought I did that ... bother, wrong branch.

We can argue about the name, I called it 'cpu_hyp_reinit()', which pairs up with
'cpu_hyp_reset()' in a rebased version of the kexec/hibernate hyp-shutdown code.
(cpu_ seems to be the prefix for per-cpu functions in this file)

v2 shortly,


Thanks/Sorry,

James
