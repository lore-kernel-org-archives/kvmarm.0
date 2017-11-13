From: Alex =?utf-8?Q?Benn=C3=A9e?= <alex.bennee@linaro.org>
Subject: Re: [PATCH v2 3/3] kvm: arm64: handle single-step of userspace mmio instructions
Date: Mon, 13 Nov 2017 14:39:11 +0000
Message-ID: <87fu9itf8w.fsf@linaro.org>
References: <20171109170021.2984-1-alex.bennee@linaro.org> <20171109170021.2984-4-alex.bennee@linaro.org> <b3f76167-50e4-5f25-9ec2-16f07de0fd32@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-reply-to: <b3f76167-50e4-5f25-9ec2-16f07de0fd32@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Julien Thierry <julien.thierry@arm.com>
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, christoffer.dall@linaro.org, marc.zyngier@arm.com, open list <linux-kernel@vger.kernel.org>
List-Id: kvmarm@lists.cs.columbia.edu


Julien Thierry <julien.thierry@arm.com> writes:

> Hi Alex,
>
> On 09/11/17 17:00, Alex Benn=C3=A9e wrote:
>> The system state of KVM when using userspace emulation is not complete
>> until we return into KVM_RUN. To handle mmio related updates we wait
>> until they have been committed and then schedule our KVM_EXIT_DEBUG.
>>
>> The kvm_arm_handle_step_debug() helper tells us if we need to return
>> and sets up the exit_reason for us.
>>
>> Signed-off-by: Alex Benn=C3=A9e <alex.bennee@linaro.org>
>>
>> ---
>> v2
>>    - call helper directly from kvm_arch_vcpu_ioctl_run
>> ---
>>   virt/kvm/arm/arm.c | 3 +++
>>   1 file changed, 3 insertions(+)
>>
>> diff --git a/virt/kvm/arm/arm.c b/virt/kvm/arm/arm.c
>> index 95cba0799828..2991adfaca9d 100644
>> --- a/virt/kvm/arm/arm.c
>> +++ b/virt/kvm/arm/arm.c
>> @@ -625,6 +625,9 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu, s=
truct kvm_run *run)
>>   		ret =3D kvm_handle_mmio_return(vcpu, vcpu->run);
>>   		if (ret)
>>   			return ret;
>> +		if (kvm_arm_handle_step_debug(vcpu, vcpu->run))
>> +			return 1;
>> +
>
> In the previous patch, kvm_arch_vcpu_ioctl_run return 0 when telling
> userspace about a debug exception. Shouldn't this branch return 0
> instead of 1?

Probably - although in practice it makes no difference. In QEMU for
example the test is if (run_ret < 0) to handle errors. Otherwise success
is assumed.

> Returning on non-zero for kvm_handle_mmio_return is done because it
> means there was an error. This is not the case for
> kvm_arm_handle_step_debug.
>
> The description in the comment of kvm_arch_vcpu_ioctl_run is not very
> clear whether non-zero result should be used for errors or if only the
> negative values are treated as such, and positive values seems to be
> generally used to keep the vcpu going. So, I thought it might make
> sense to always return the same value upon debug exceptions.

There is a subtle mis-match between what gets passed back to the ioctl
and what terminates the while() loop later on. As far as the ioctl is
concerned it's 0 success and - error. Once you get to the while loop
you'll only ever exit once ret is no longer > 0.

Anyway for consistency we should certainly return 0, I'll fix it on the
next iteration.

>
> Cheers,


--
Alex Benn=C3=A9e
