From: Joe Perches <joe@perches.com>
Subject: Re: [PATCH] KVM: Replaces 'unsigned' with 'unsigned int' in the
 codebase
Date: Tue, 27 Jun 2017 05:21:30 -0700
Message-ID: <1498566090.24295.59.camel@perches.com>
References: <20170627095401.GA19864@home>
 <9b50ee4b-d27a-8872-0cd3-cad8f5f0e0f8@redhat.com>
 <20170627120626.GA21666@home>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BFCDA40D8B
 for <kvmarm@lists.cs.columbia.edu>; Tue, 27 Jun 2017 08:21:28 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id zm8+tOX1KCFt for <kvmarm@lists.cs.columbia.edu>;
 Tue, 27 Jun 2017 08:21:28 -0400 (EDT)
Received: from smtprelay.hostedemail.com (smtprelay0241.hostedemail.com
 [216.40.44.241])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 0D9D940D88
 for <kvmarm@lists.cs.columbia.edu>; Tue, 27 Jun 2017 08:21:27 -0400 (EDT)
In-Reply-To: <20170627120626.GA21666@home>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: 'Roman Storozhenko <romeusmeister@gmail.com>, '@home, kvm@vger.kernel.org
Cc: marc.zyngier@arm.com, linux-kernel@vger.kernel.org, pbonzini@redhat.com, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Tue, 2017-06-27 at 15:06 +0300, Roman Storozhenko wrote:
> On Tue, Jun 27, 2017 at 12:01:25PM +0200, Paolo Bonzini wrote:
> > On 27/06/2017 11:54, Roman Storozhenko wrote:
> > > Signed-off-by: Roman Storozhenko <romeusmeister@gmail.com>
> > > ---
> > >  virt/kvm/arm/arm.c        |  2 +-
> > >  virt/kvm/coalesced_mmio.c |  2 +-
> > >  virt/kvm/eventfd.c        | 10 ++++++----
> > >  virt/kvm/irqchip.c        |  7 ++++---
> > >  virt/kvm/kvm_main.c       | 16 ++++++++--------
> > >  5 files changed, 20 insertions(+), 17 deletions(-)
> > 
> > This change is pointless.  Contributors to KVM should know what
> > "unsigned" means.
> 
> Paolo, thanks that you mentioned this. But I have a question - is this just
> useless or this is an error?

(Not Paulo and my 2c) Neither really.

> I saw many places in the codebase where 'unsigned int' is used. That why I
> decided to make the codebase more standartized from the style point of
> view.

In virt/kvm, there are 16 lines with unsigned, 160 with unsigned int

<shrug>, Both statements are correct, yes, it's kinda pointless,
and, yes, it does standardize the declarations.

It's entirely up the the maintainers (Paulo and Radim) to apply
or reject this style-only trivial patch.  The compiler doesn't care.
