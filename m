From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH v2 1/9] KVM: add kvm_request_pending
Date: Sat, 8 Apr 2017 11:19:51 -0700
Message-ID: <20170408181951.GC29201@lvm>
References: <20170331160658.4331-2-drjones@redhat.com>
 <20170404153014.GL11752@cbox>
 <20170404164120.xvlvyebvcqoci5cu@kamzik.brq.redhat.com>
 <20170405131049.GD6369@potion>
 <20170405173918.GA27123@cbox>
 <20170405202016.GG6369@potion>
 <20170406120211.lcd4ygkms7zk3hkw@kamzik.brq.redhat.com>
 <20170406143751.GG27123@cbox>
 <20170406150853.l3emn2iq7nhbi5gq@kamzik.brq.redhat.com>
 <1dab6862-9b0f-17c9-c6d0-542b460ec5c7@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1dab6862-9b0f-17c9-c6d0-542b460ec5c7@redhat.com>
Sender: kvm-owner@vger.kernel.org
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Andrew Jones <drjones@redhat.com>, Christoffer Dall <cdall@linaro.org>, Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, marc.zyngier@arm.com
List-Id: kvmarm@lists.cs.columbia.edu

On Fri, Apr 07, 2017 at 11:33:33PM +0800, Paolo Bonzini wrote:
> 
> 
> On 06/04/2017 23:08, Andrew Jones wrote:
> > My own made-up lingo to state that each time the variable is accessed it
> > must be loaded anew, taken care of by the volatile use in READ_ONCE.  As
> > vcpu->requests can be written by other threads, then I prefer READ_ONCE
> > being used to read it, as it allows me to avoid spending energy convincing
> > myself that the compiler would have emitted a load at that point anyway.
> 
> Also, READ_ONCE without a barrier is really fishy unless it's
> 
>   while (READ_ONCE(x) != 2) {
>       ...
>   }
> 
> or similar, and WRITE_ONCE doesn't even have this exception.  So
> annotating variables accessed by multiple threads with
> READ_ONCE/WRITE_ONCE is generally a good idea.
> 

I'm sorry, I'm confused.  You're saying that it's fishy to use
READ_ONCE() without also having a barrier, but does that imply that if
you have a barrier, you should also have READ_ONCE() ?

In any case, as I hope I've made clear, I'm perfectly fine with having
READ_ONCE(), as long as we make a best effort attempt at describing why
we added it, so even I can understand that later - in the code directly
or in the commit message.

Thanks,
-Christoffer
