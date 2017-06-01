From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH v4 11/11] KVM: arm/arm64: timer: remove request-less vcpu
 kick
Date: Thu, 1 Jun 2017 14:37:52 +0200
Message-ID: <076a66da-7d55-bcdb-8466-ce2abed7fcf8@redhat.com>
References: <20170516022035.7674-1-drjones@redhat.com>
 <20170516022035.7674-12-drjones@redhat.com> <20170601103454.GA20919@cbox>
 <20170601110900.bwxffuh2nyp3jsx2@kamzik.brq.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 31E2840C4B
 for <kvmarm@lists.cs.columbia.edu>; Thu,  1 Jun 2017 08:34:03 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id YI8zcPtFGKsi for <kvmarm@lists.cs.columbia.edu>;
 Thu,  1 Jun 2017 08:34:02 -0400 (EDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id F0BD640190
 for <kvmarm@lists.cs.columbia.edu>; Thu,  1 Jun 2017 08:34:01 -0400 (EDT)
In-Reply-To: <20170601110900.bwxffuh2nyp3jsx2@kamzik.brq.redhat.com>
Content-Language: en-US
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Andrew Jones <drjones@redhat.com>, Christoffer Dall <cdall@linaro.org>
Cc: marc.zyngier@arm.com, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu



On 01/06/2017 13:09, Andrew Jones wrote:
>>> -	kvm_vcpu_kick(vcpu);
>>> +	swake_up(kvm_arch_vcpu_wq(vcpu));
>> We have kvm_vcpu_wake_up().  Why not use that?
> The are two differences between swake_up(kvm_arch_vcpu_wq(vcpu)) and
> kvm_vcpu_wake_up(vcpu)
>  1. kvm_vcpu_wake_up() has a return value: true on wake up, else false
>  2. kvm_vcpu_wake_up() increments the halt_wakeup stat when the vcpu
>     is awaken
> 
> (1) doesn't really matter, but (2) might. Hmm, I think we do want to
> increment that stat in this case though, so I should change this.

Yep.

> Also, we have another use of swake_up(kvm_arch_vcpu_wq(vcpu)), in
> kvm_arm_resume_guest(), but there I don't think we want to increment
> the halt stat, so that one is probably OK.

I would define a __kvm_vcpu_wake_up if you don't want the stat.

Paolo
