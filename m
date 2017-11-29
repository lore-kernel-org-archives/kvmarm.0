From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH v2 15/16] KVM: arm/arm64: Avoid vcpu_load for other vcpu
 ioctls than KVM_RUN
Date: Wed, 29 Nov 2017 17:34:08 +0000
Message-ID: <CAMJs5B-JWrHrCyO6zNC8z34uiMrhNk6RaQCTKRB27Mki+XhpFg@mail.gmail.com>
References: <20171129164116.16167-1-christoffer.dall@linaro.org>
 <20171129164116.16167-16-christoffer.dall@linaro.org>
 <12137903-6f11-6350-6344-30e3bc6542e3@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9C8B949D7A
 for <kvmarm@lists.cs.columbia.edu>; Wed, 29 Nov 2017 12:31:16 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id SsuUcelSXpHu for <kvmarm@lists.cs.columbia.edu>;
 Wed, 29 Nov 2017 12:31:15 -0500 (EST)
Received: from mail-pl0-f65.google.com (mail-pl0-f65.google.com
 [209.85.160.65])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 78C1749D6F
 for <kvmarm@lists.cs.columbia.edu>; Wed, 29 Nov 2017 12:31:15 -0500 (EST)
Received: by mail-pl0-f65.google.com with SMTP id s10so2491662plj.5
 for <kvmarm@lists.cs.columbia.edu>; Wed, 29 Nov 2017 09:34:10 -0800 (PST)
In-Reply-To: <12137903-6f11-6350-6344-30e3bc6542e3@redhat.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: David Hildenbrand <david@redhat.com>
Cc: linux-mips@linux-mips.org, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, Marc Zyngier <marc.zyngier@arm.com>, James Hogan <jhogan@kernel.org>, Cornelia Huck <cohuck@redhat.com>, kvm-ppc <kvm-ppc@vger.kernel.org>, Christian Borntraeger <borntraeger@de.ibm.com>, Alexander Graf <agraf@suse.com>, Paolo Bonzini <pbonzini@redhat.com>, linux-s390@vger.kernel.org, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>
List-Id: kvmarm@lists.cs.columbia.edu

On Wed, Nov 29, 2017 at 5:30 PM, David Hildenbrand <david@redhat.com> wrote:
>
>> +++ b/virt/kvm/arm/arm.c
>> @@ -381,14 +381,11 @@ static void vcpu_power_off(struct kvm_vcpu *vcpu)
>>  int kvm_arch_vcpu_ioctl_get_mpstate(struct kvm_vcpu *vcpu,
>>                                   struct kvm_mp_state *mp_state)
>>  {
>> -     vcpu_load(vcpu);
>> -
>>       if (vcpu->arch.power_off)
>>               mp_state->mp_state = KVM_MP_STATE_STOPPED;
>>       else
>>               mp_state->mp_state = KVM_MP_STATE_RUNNABLE;
>>
>> -     vcpu_put(vcpu);
>>       return 0;
>>  }
>
> Okay, this also makes sense on other architectures. The important thing
> is only that we hold the vcpu mutex.
>
Yes, but as Paolo said, it's better if architecture maintainers do
that themselves.  The risk of me messing things up is way too high
otherwise.

Thanks,
-Christoffer
