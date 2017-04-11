From: Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>
Subject: Re: [PATCH v2 1/9] KVM: add kvm_request_pending
Date: Tue, 11 Apr 2017 23:06:44 +0200
Message-ID: <20170411210644.GB32380@potion>
References: <20170331160658.4331-1-drjones@redhat.com>
 <20170404164120.xvlvyebvcqoci5cu@kamzik.brq.redhat.com>
 <20170405131049.GD6369@potion> <20170405173918.GA27123@cbox>
 <20170405202016.GG6369@potion> <20170406142535.GD27123@cbox>
 <20170407131537.GE23559@potion> <20170408182314.GD29201@lvm>
 <925034633.12169627.1491679920960.JavaMail.zimbra@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4BEEA40C33
 for <kvmarm@lists.cs.columbia.edu>; Tue, 11 Apr 2017 17:04:25 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id yLIblOq0fo12 for <kvmarm@lists.cs.columbia.edu>;
 Tue, 11 Apr 2017 17:04:24 -0400 (EDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 5972D40BE3
 for <kvmarm@lists.cs.columbia.edu>; Tue, 11 Apr 2017 17:04:23 -0400 (EDT)
Content-Disposition: inline
In-Reply-To: <925034633.12169627.1491679920960.JavaMail.zimbra@redhat.com>
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
Cc: Christoffer Dall <cdall@linaro.org>, kvm@vger.kernel.org, marc zyngier <marc.zyngier@arm.com>, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

2017-04-08 15:32-0400, Paolo Bonzini:
> > > Makes sense.  My pitch at the documentation after dropping READ_ONCE():
> > 
> > I'm confused again, I thought you wanted to keep READ_ONCE().
> > 
> > > 
> > >   /*
> > >    *  The return value of kvm_request_pending() is implicitly volatile
> > 
> > why is that, actually?

"that" is the return value?
  kvm_request_pending() is 'inline static' so the compiler can prove that
  the function only returns vcpu->requests and that the surrounding code
  doesn't change it, so various optimizations are possible.

Or the implicitly volatile bit?
  We know that vcpu->requests can change at any time without action of the
  execution thread, which makes it volatile, but we don't tell that to the
  compiler, hence implicit.
  
  READ_ONCE(vcpu->requests) is
  
    *(volatile unsigned long *)&vcpu->requests
  
  and makes it explicitly volatile.

> > >    *  and must be protected from reordering by the caller.
> > >    */
> > 
> > Can we be specific about what that means?  (e.g. must be preceded by a
> > full smp_mb() - or whatever the case is).
> 
> You can play devil's advocate both ways and argue that READ_ONCE is
> better, or that it is unnecessary hence worse.  You can write good
> comments in either case.  That's how I read Radim's message.  But
> I think we all agree on keeping it in the end.

Exactly, I am in favor of READ_ONCE() as I don't like to keep the
compiler informed, just wanted to cover all options, because they are
not that different ... minute details are the hardest to decide. :)
