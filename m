From: Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>
Subject: Re: [PATCH v2 2/9] KVM: Add documentation for VCPU requests
Date: Thu, 6 Apr 2017 14:29:07 +0200
Message-ID: <20170406122907.GI6369@potion>
References: <20170331160658.4331-1-drjones@redhat.com>
 <20170331160658.4331-3-drjones@redhat.com>
 <985f69f3-3a4b-3742-731e-aac3a26b1777@de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <985f69f3-3a4b-3742-731e-aac3a26b1777@de.ibm.com>
Sender: kvm-owner@vger.kernel.org
To: Christian Borntraeger <borntraeger@de.ibm.com>
Cc: Andrew Jones <drjones@redhat.com>, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, cdall@linaro.org, marc.zyngier@arm.com, pbonzini@redhat.com
List-Id: kvmarm@lists.cs.columbia.edu

2017-04-06 12:18+0200, Christian Borntraeger:
> On 03/31/2017 06:06 PM, Andrew Jones wrote:
>> Signed-off-by: Andrew Jones <drjones@redhat.com>
>> +VCPU Requests and Guest Mode
>> +============================
> 
> FWIW, s390 does not implement the guest mode. Maybe add some words that not
> all architectures implement that? Or do we expect Radims rework soon?

Yes, mention that it is an optional optimization sounds good.
I won't be adding guest->mode to s390 (at least in the beginning).
This means that kvm_arch_vcpu_should_kick() should return true.

In kvm_make_all_cpus_request(), there is

  kvm_vcpu_exiting_guest_mode(vcpu) != OUTSIDE_GUEST_MODE

that ought to be replaced with kvm_arch_vcpu_should_kick(), and it
should return true if the arch doesn't implement guest->mode.
But on s390, the condition currently always returns false ... is that
IPI-less behavior of kvm_make_all_cpus_request intended on s390?

Thanks.
