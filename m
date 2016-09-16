From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH v3 0/2] KVM: ARM: Enable vtimers with user space gic
Date: Fri, 16 Sep 2016 14:31:42 +0200
Message-ID: <da8191ca-6fb1-f960-872c-d6bc27172db8@redhat.com>
References: <1474007187-18673-1-git-send-email-agraf@suse.de>
 <57DBC782.7080305@arm.com> <7beb406b-6194-8451-2d92-9a4394ef91dd@redhat.com>
 <20160916123039.GB14140@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 29F7841390
 for <kvmarm@lists.cs.columbia.edu>; Fri, 16 Sep 2016 08:23:02 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id HfVYtkhvaxB5 for <kvmarm@lists.cs.columbia.edu>;
 Fri, 16 Sep 2016 08:23:00 -0400 (EDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D9243412C2
 for <kvmarm@lists.cs.columbia.edu>; Fri, 16 Sep 2016 08:23:00 -0400 (EDT)
In-Reply-To: <20160916123039.GB14140@cbox>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Christoffer Dall <christoffer.dall@linaro.org>
Cc: Marc Zyngier <marc.zyngier@arm.com>, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu



On 16/09/2016 14:30, Christoffer Dall wrote:
> > > > This patch set allows user space to receive vtimer events as well as mask
> > > > them, so that we can handle all vtimer related interrupt injection from user
> > > > space, enabling us to use architected timer with user space gic emulation.
> > >
> > > I have already voiced my concerns in the past, including face to face,
> > > and I'm going to repeat it: I not keen at all on adding a new userspace
> > > interface that is going to bitrot extremely quickly.
> > 
> > You don't have automated tests set up?  It's not going to bitrot if you
> > test it, either with kvm-unit-tests or just by smoke-testing Linux.
> > It's _for_ the raspi, but it's not limited to it.
> 
> Our automated testing situation is not great, no.  Something we're
> looking at, but have resource problems with.

But it's not a good reason to hold back a feature...

Paolo
