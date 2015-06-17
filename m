From: Andre Przywara <andre.przywara@arm.com>
Subject: Re: [PATCH v3 07/10] limit number of VCPUs on demand
Date: Wed, 17 Jun 2015 14:14:52 +0100
Message-ID: <558172CC.3050601@arm.com>
References: <1434540121-21283-1-git-send-email-andre.przywara@arm.com>
 <1434540121-21283-8-git-send-email-andre.przywara@arm.com>
 <55816DC6.4060604@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BC7AF55DA9
 for <kvmarm@lists.cs.columbia.edu>; Wed, 17 Jun 2015 09:04:01 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 8P2+czBioh-J for <kvmarm@lists.cs.columbia.edu>;
 Wed, 17 Jun 2015 09:04:00 -0400 (EDT)
Received: from cam-admin0.cambridge.arm.com (cam-admin0.cambridge.arm.com
 [217.140.96.50])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8AC9C55DA7
 for <kvmarm@lists.cs.columbia.edu>; Wed, 17 Jun 2015 09:04:00 -0400 (EDT)
In-Reply-To: <55816DC6.4060604@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Marc Zyngier <marc.zyngier@arm.com>, Will Deacon <Will.Deacon@arm.com>
Cc: "penberg@kernel.org" <penberg@kernel.org>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>
List-Id: kvmarm@lists.cs.columbia.edu

On 06/17/2015 01:53 PM, Marc Zyngier wrote:
> On 17/06/15 12:21, Andre Przywara wrote:
>> Currently the ARM GIC checks the number of VCPUs against a fixed
>> limit, which is GICv2 specific. Don't pretend we know better than the
>> kernel and let's get rid of that explicit check.
>> Instead be more relaxed about KVM_CREATE_VCPU failing with EINVAL,
>> which is the way the kernel communicates having reached a VCPU limit.
>> If we see this and have at least brought up one VCPU already
>> successfully, then don't panic, but limit the number of VCPUs instead.
>>
>> Signed-off-by: Andre Przywara <andre.przywara@arm.com>

...

>> diff --git a/arm/kvm-cpu.c b/arm/kvm-cpu.c
>> index 7780251..c1cf51d 100644
>> --- a/arm/kvm-cpu.c
>> +++ b/arm/kvm-cpu.c
>> @@ -47,12 +47,19 @@ struct kvm_cpu *kvm_cpu__arch_init(struct kvm *kvm, unsigned long cpu_id)
>>  	};
>>  
>>  	vcpu = calloc(1, sizeof(struct kvm_cpu));
>> -	if (!vcpu)
>> +	if (!vcpu) {
>> +		errno = ENOMEM;
>>  		return NULL;
>> +	}
> 
> Isn't errno already set when calloc fails?

Ah yes, that seems to be true at least for glibc or UNIX 98, according
to the manpage. I was misguided by the fact that calloc is not a
syscall. So I can drop this hunk.

Thanks,
Andre.
