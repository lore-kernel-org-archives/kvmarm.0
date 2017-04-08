From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH v2 1/9] KVM: add kvm_request_pending
Date: Sat, 8 Apr 2017 15:32:00 -0400 (EDT)
Message-ID: <925034633.12169627.1491679920960.JavaMail.zimbra@redhat.com>
References: <20170331160658.4331-1-drjones@redhat.com> <20170404164120.xvlvyebvcqoci5cu@kamzik.brq.redhat.com> <20170405131049.GD6369@potion> <20170405173918.GA27123@cbox> <20170405202016.GG6369@potion> <20170406142535.GD27123@cbox> <20170407131537.GE23559@potion> <20170408182314.GD29201@lvm>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20170408182314.GD29201@lvm>
Sender: kvm-owner@vger.kernel.org
To: Christoffer Dall <christoffer.dall@linaro.org>
Cc: Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>, Christoffer Dall <cdall@linaro.org>, Andrew Jones <drjones@redhat.com>, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, marc zyngier <marc.zyngier@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu


> > Makes sense.  My pitch at the documentation after dropping READ_ONCE():
> 
> I'm confused again, I thought you wanted to keep READ_ONCE().
> 
> > 
> >   /*
> >    *  The return value of kvm_request_pending() is implicitly volatile
> 
> why is that, actually?
> 
> >    *  and must be protected from reordering by the caller.
> >    */
> 
> Can we be specific about what that means?  (e.g. must be preceded by a
> full smp_mb() - or whatever the case is).

You can play devil's advocate both ways and argue that READ_ONCE is
better, or that it is unnecessary hence worse.  You can write good
comments in either case.  That's how I read Radim's message.  But
I think we all agree on keeping it in the end.

> Perhaps we should just let Drew respin at this point, in case he's
> confident about the right path, and then pick up from there?

I agree.

In any case, the memory barrier is the important part, but
adding READ_ONCE is self-documenting and I prefer to have it.

Paolo
