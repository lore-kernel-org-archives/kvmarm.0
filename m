From: Andrew Jones <drjones@redhat.com>
Subject: Re: [PATCH v2 1/9] KVM: add kvm_request_pending
Date: Thu, 6 Apr 2017 17:08:53 +0200
Message-ID: <20170406150853.l3emn2iq7nhbi5gq@kamzik.brq.redhat.com>
References: <20170331160658.4331-1-drjones@redhat.com>
 <20170331160658.4331-2-drjones@redhat.com>
 <20170404153014.GL11752@cbox>
 <20170404164120.xvlvyebvcqoci5cu@kamzik.brq.redhat.com>
 <20170405131049.GD6369@potion>
 <20170405173918.GA27123@cbox>
 <20170405202016.GG6369@potion>
 <20170406120211.lcd4ygkms7zk3hkw@kamzik.brq.redhat.com>
 <20170406143751.GG27123@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170406143751.GG27123@cbox>
Sender: kvm-owner@vger.kernel.org
To: Christoffer Dall <cdall@linaro.org>
Cc: Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, marc.zyngier@arm.com, pbonzini@redhat.com
List-Id: kvmarm@lists.cs.columbia.edu

On Thu, Apr 06, 2017 at 04:37:51PM +0200, Christoffer Dall wrote:
> > FWIW, I first suggested using READ_ONCE() for the freshness argument,
> 
> What is the 'freshness argument' ?

My own made-up lingo to state that each time the variable is accessed it
must be loaded anew, taken care of by the volatile use in READ_ONCE.  As
vcpu->requests can be written by other threads, then I prefer READ_ONCE
being used to read it, as it allows me to avoid spending energy convincing
myself that the compiler would have emitted a load at that point anyway.

The writes to vcpu->requests always go through bitops, so they're already
also emitting fresh loads before doing their stores.

Thanks,
drew
