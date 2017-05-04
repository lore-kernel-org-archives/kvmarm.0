From: Andrew Jones <drjones@redhat.com>
Subject: Re: [PATCH v3 08/10] KVM: arm/arm64: change exit request to sleep
 request
Date: Thu, 4 May 2017 14:07:42 +0200
Message-ID: <20170504120742.xl62mpgmtioryelp@kamzik.brq.redhat.com>
References: <20170503160635.21669-1-drjones@redhat.com>
 <20170503160635.21669-9-drjones@redhat.com>
 <a53a6dfc-b5ba-f7f1-d23d-8db96d7fc3e4@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2F3EF40BBB
 for <kvmarm@lists.cs.columbia.edu>; Thu,  4 May 2017 08:04:42 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 6shDYfwTsFjn for <kvmarm@lists.cs.columbia.edu>;
 Thu,  4 May 2017 08:04:41 -0400 (EDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 6C5BF40430
 for <kvmarm@lists.cs.columbia.edu>; Thu,  4 May 2017 08:04:41 -0400 (EDT)
Content-Disposition: inline
In-Reply-To: <a53a6dfc-b5ba-f7f1-d23d-8db96d7fc3e4@redhat.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: marc.zyngier@arm.com, cdall@linaro.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

On Thu, May 04, 2017 at 01:38:13PM +0200, Paolo Bonzini wrote:
> 
> 
> On 03/05/2017 18:06, Andrew Jones wrote:
> > -#define KVM_REQ_VCPU_EXIT \
> > +#define KVM_REQ_SLEEP \
> >  	KVM_ARCH_REQ_FLAGS(0, KVM_REQUEST_NO_WAKEUP | KVM_REQUEST_WAIT)
> 
> 
> Note that this is still like this in kvm/queue:
> 
> #define KVM_REQ_VCPU_EXIT       (8 | KVM_REQUEST_WAIT | KVM_REQUEST_NO_WAKEUP)
> 
> but I did like the KVM_ARCH_REQ_FLAGS of Radim's series (just not
> KVM_REQUEST_NO_WAKEUP_WAIT or whatever it was...).

Yeah, I forgot to mention in the cover letter that I just picked my
favorite way for Radim to resolve the KVM_REQUEST_NO_WAKEUP_WAIT thing
for my base. I figured if I picked wrong that the conflict resolution
would be trivial enough that it didn't matter anyway.

Thanks,
drew
