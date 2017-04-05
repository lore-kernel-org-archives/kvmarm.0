From: Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>
Subject: Re: [PATCH v2 2/9] KVM: Add documentation for VCPU requests
Date: Wed, 5 Apr 2017 16:11:40 +0200
Message-ID: <20170405141139.GA13944@potion>
References: <20170331160658.4331-1-drjones@redhat.com>
 <20170331160658.4331-3-drjones@redhat.com>
 <20170404152403.GK11752@cbox>
 <20170404170600.w6snnecqoi4aqv4d@kamzik.brq.redhat.com>
 <20170404172340.GQ11752@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6365E40B8C
 for <kvmarm@lists.cs.columbia.edu>; Wed,  5 Apr 2017 10:09:32 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id H0rqXpt3KfvM for <kvmarm@lists.cs.columbia.edu>;
 Wed,  5 Apr 2017 10:09:31 -0400 (EDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 3A8EA40A63
 for <kvmarm@lists.cs.columbia.edu>; Wed,  5 Apr 2017 10:09:30 -0400 (EDT)
Content-Disposition: inline
In-Reply-To: <20170404172340.GQ11752@cbox>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Christoffer Dall <cdall@linaro.org>
Cc: marc.zyngier@arm.com, pbonzini@redhat.com, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

2017-04-04 19:23+0200, Christoffer Dall:
> On Tue, Apr 04, 2017 at 07:06:00PM +0200, Andrew Jones wrote:
>> On Tue, Apr 04, 2017 at 05:24:03PM +0200, Christoffer Dall wrote:
>> > On Fri, Mar 31, 2017 at 06:06:51PM +0200, Andrew Jones wrote:
>> > > +and will definitely see the request, or is outside guest mode, but has yet
>> > > +to do its final request check, and therefore when it does, it will see the
>> > > +request, then things will work.  However, the transition from outside to
>> > > +inside guest mode, after the last request check has been made, opens a
>> > > +window where a request could be made, but the VCPU would not see until it
>> > > +exits guest mode some time later.  See the table below.
>> > 
>> > This text, and the table below, only deals with the details of entering
>> > the guest.  Should we talk about kvm_vcpu_exiting_guest_mode() and
>> > anything related to exiting the guest?
>> 
>> I think all !IN_GUEST_MODE should behave the same, so I was avoiding
>> the use of EXITING_GUEST_MODE and OUTSIDE_GUEST_MODE, which wouldn't be
>> hard to address, but then I'd also have to address
>> READING_SHADOW_PAGE_TABLES, which may complicate the document more than
>> necessary.  I'm not sure we need to address a VCPU exiting guest mode,
>> other than making sure it's clear that a VCPU that exits must check
>> requests before it enters again.
> 
> But the problem is that kvm_make_all_cpus_request() only sends IPIs to
> CPUs where the mode was different from OUTSIDE_GUEST_MODE, so there it's
> about !OUTSIDE_GUEST_MODE rather than !IN_GUEST_MODE, so there's some
> subtlety here which I feel like it's dangerous to paper over.

Right, that needs fixing in the code.

guest_mode is just an optimization that allows us to skip sending the
IPI when the VCPU is known to handle the request as soon as possible.

  IN_GUEST_MODE: we must force VM exit or the request could never be
    handled
  EXITING_GUEST_MODE: another request already forces the VM exit and
    we're just waiting for the VCPU to notice our request
  OUTSIDE_GUEST_MODE: KVM is going to notice our request without any
    intervention
  READING_SHADOW_PAGE_TABLES: same as OUTSIDE_GUEST_MODE -- rename to
    unwieldly OUTSIDE_GUEST_MODE_READING_SHADOW_PAGE_TABLES?

The kick is needed only in IN_GUEST_MODE and a wake up is needed in case
where the guest is halted OUTSIDE_GUEST_MODE ...
Hm, maybe we should add a halt state too?
