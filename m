From: Andre Przywara <andre.przywara@arm.com>
Subject: Re: [PATCH v4 07/10] limit number of VCPUs on demand
Date: Tue, 30 Jun 2015 17:27:26 +0100
Message-ID: <5592C36E.1070209@arm.com>
References: <1435324578-21832-1-git-send-email-andre.przywara@arm.com>
 <1435324578-21832-8-git-send-email-andre.przywara@arm.com>
 <20150630160949.GR27725@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id ED11E56B53
 for <kvmarm@lists.cs.columbia.edu>; Tue, 30 Jun 2015 12:15:58 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id IgfRmNvqHflP for <kvmarm@lists.cs.columbia.edu>;
 Tue, 30 Jun 2015 12:15:57 -0400 (EDT)
Received: from cam-admin0.cambridge.arm.com (cam-admin0.cambridge.arm.com
 [217.140.96.50])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8ADB156B5A
 for <kvmarm@lists.cs.columbia.edu>; Tue, 30 Jun 2015 12:15:57 -0400 (EDT)
In-Reply-To: <20150630160949.GR27725@arm.com>
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
Cc: Marc Zyngier <Marc.Zyngier@arm.com>, "penberg@kernel.org" <penberg@kernel.org>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>
List-Id: kvmarm@lists.cs.columbia.edu

Hi,

On 30/06/15 17:09, Will Deacon wrote:
> On Fri, Jun 26, 2015 at 02:16:15PM +0100, Andre Przywara wrote:
>> Currently the ARM GIC checks the number of VCPUs against a fixed
>> limit, which is GICv2 specific. Don't pretend we know better than the
>> kernel and let's get rid of that explicit check.
>> Instead be more relaxed about KVM_CREATE_VCPU failing with EINVAL,
>> which is the way the kernel communicates having reached a VCPU limit.
>> If we see this and have at least brought up one VCPU already
>> successfully, then don't panic, but limit the number of VCPUs instead.
>>
>> Signed-off-by: Andre Przywara <andre.przywara@arm.com>
>> ---
>>  arm/gic.c     | 6 ------
>>  arm/kvm-cpu.c | 7 ++++++-
>>  kvm-cpu.c     | 7 +++++++
>>  3 files changed, 13 insertions(+), 7 deletions(-)
>>
>> diff --git a/arm/gic.c b/arm/gic.c
>> index 99f0d2b..05f85a2 100644
>> --- a/arm/gic.c
>> +++ b/arm/gic.c
>> @@ -84,12 +84,6 @@ int gic__create(struct kvm *kvm)
>>  {
>>  	int err;
>>  
>> -	if (kvm->nrcpus > GIC_MAX_CPUS) {
>> -		pr_warning("%d CPUS greater than maximum of %d -- truncating\n",
>> -				kvm->nrcpus, GIC_MAX_CPUS);
>> -		kvm->nrcpus = GIC_MAX_CPUS;
>> -	}
>> -
>>  	/* Try the new way first, and fallback on legacy method otherwise */
>>  	err = gic__create_device(kvm);
>>  	if (err)
>> diff --git a/arm/kvm-cpu.c b/arm/kvm-cpu.c
>> index 7780251..b2fd6ed 100644
>> --- a/arm/kvm-cpu.c
>> +++ b/arm/kvm-cpu.c
>> @@ -51,8 +51,13 @@ struct kvm_cpu *kvm_cpu__arch_init(struct kvm *kvm, unsigned long cpu_id)
>>  		return NULL;
>>  
>>  	vcpu->vcpu_fd = ioctl(kvm->vm_fd, KVM_CREATE_VCPU, cpu_id);
>> -	if (vcpu->vcpu_fd < 0)
>> +	if (vcpu->vcpu_fd < 0) {
>> +		if (errno == EINVAL) {
>> +			free(vcpu);
>> +			return NULL;
>> +		}
> 
> Hmm, but EINVAL can mean all sorts of other failures too, surely?

Not for ARM, at least not at the moment. I went through all the cases -
I think up to 8 levels deep - and exceeding the number of VCPUs is the
only case where we return EINVAL for KVM_CREATE_VCPU.

> I'm
> not against removing the nrcpus check, but I think we should die if ioctls
> start failing rather than silently ignore them.

I see your point, but at least we don't fail silently: if we exit the
loop prematurely, we print the warning about limiting the number of VCPUs.
I agree that the proper solution would be to just explicitly ask the
kernel about the number of VCPUs, but on ARM this is not reliable at the
moment due to kernel behaviour, and any fix there would still not affect
older kernels.

Cheers,
Andre.
