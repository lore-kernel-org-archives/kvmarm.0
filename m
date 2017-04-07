From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH v2 1/9] KVM: add kvm_request_pending
Date: Fri, 7 Apr 2017 23:33:33 +0800
Message-ID: <1dab6862-9b0f-17c9-c6d0-542b460ec5c7@redhat.com>
References: <20170331160658.4331-1-drjones@redhat.com>
 <20170331160658.4331-2-drjones@redhat.com> <20170404153014.GL11752@cbox>
 <20170404164120.xvlvyebvcqoci5cu@kamzik.brq.redhat.com>
 <20170405131049.GD6369@potion> <20170405173918.GA27123@cbox>
 <20170405202016.GG6369@potion>
 <20170406120211.lcd4ygkms7zk3hkw@kamzik.brq.redhat.com>
 <20170406143751.GG27123@cbox>
 <20170406150853.l3emn2iq7nhbi5gq@kamzik.brq.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20170406150853.l3emn2iq7nhbi5gq@kamzik.brq.redhat.com>
Sender: kvm-owner@vger.kernel.org
To: Andrew Jones <drjones@redhat.com>, Christoffer Dall <cdall@linaro.org>
Cc: =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, marc.zyngier@arm.com
List-Id: kvmarm@lists.cs.columbia.edu



On 06/04/2017 23:08, Andrew Jones wrote:
> My own made-up lingo to state that each time the variable is accessed it
> must be loaded anew, taken care of by the volatile use in READ_ONCE.  As
> vcpu->requests can be written by other threads, then I prefer READ_ONCE
> being used to read it, as it allows me to avoid spending energy convincing
> myself that the compiler would have emitted a load at that point anyway.

Also, READ_ONCE without a barrier is really fishy unless it's

  while (READ_ONCE(x) != 2) {
      ...
  }

or similar, and WRITE_ONCE doesn't even have this exception.  So
annotating variables accessed by multiple threads with
READ_ONCE/WRITE_ONCE is generally a good idea.

Paolo
