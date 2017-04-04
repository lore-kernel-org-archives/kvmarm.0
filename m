From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH v2 4/9] KVM: arm/arm64: replace vcpu->arch.pause with a
 vcpu request
Date: Tue, 4 Apr 2017 16:51:40 +0200
Message-ID: <f615bc88-0a18-47a3-1122-e7e6db38bf3d@redhat.com>
References: <20170331160658.4331-1-drjones@redhat.com>
 <20170331160658.4331-5-drjones@redhat.com>
 <44739aad-ba52-4f02-8d3d-643365b7f8a7@arm.com>
 <20170404144724.epa45tewewnydnc6@kamzik.brq.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 04FA440A14
 for <kvmarm@lists.cs.columbia.edu>; Tue,  4 Apr 2017 10:49:34 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id cM6sNuZuXllC for <kvmarm@lists.cs.columbia.edu>;
 Tue,  4 Apr 2017 10:49:33 -0400 (EDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 273D440187
 for <kvmarm@lists.cs.columbia.edu>; Tue,  4 Apr 2017 10:49:32 -0400 (EDT)
In-Reply-To: <20170404144724.epa45tewewnydnc6@kamzik.brq.redhat.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Andrew Jones <drjones@redhat.com>, Marc Zyngier <marc.zyngier@arm.com>
Cc: cdall@linaro.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu



On 04/04/2017 16:47, Andrew Jones wrote:
>>> -#define KVM_REQ_VCPU_EXIT	8
>>> +#define KVM_REQ_PAUSE		8
>> Small nit: can we have a #define for this 8? KVM_REQ_ARCH_BASE, or
>> something along those lines?
> Sounds good to me.  Should I even do something like
> 
>  #define KVM_REQ_ARCH_BASE 8
> 
>  #define KVM_ARCH_REQ(bit) ({ \
>      BUILD_BUG_ON(((bit) + KVM_REQ_ARCH_BASE) >= BITS_PER_LONG); \

Please make this 32 so that we don't fail on 32-bit machines.

or even

BUILD_BUG_ON((unsigned)(bit) >= BITS_PER_LONG - KVM_REQ_ARCH_BASE);

in case someone is crazy enough to pass a negative value!

Paolo

>      ((bit) + KVM_REQ_ARCH_BASE); \
>  })
> 
>  #define KVM_REQ_PAUSE KVM_ARCH_REQ(0)
> 
> or would that be overkill?  Also, whether we switch to just the base
> define, or the macro, I guess it would be good to do for all
> architectures.
