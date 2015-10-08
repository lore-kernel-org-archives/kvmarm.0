From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH] KVM: arm/arm64: Add VGICv3 save/restore API documentation
Date: Thu, 8 Oct 2015 10:23:02 +0200
Message-ID: <20151008082302.GE14315@cbox>
References: <1444247430-14808-1-git-send-email-christoffer.dall@linaro.org>
 <003a01d10199$58e96590$0abc30b0$@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7357B41CC5
 for <kvmarm@lists.cs.columbia.edu>; Thu,  8 Oct 2015 04:20:51 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id sTI+bZp7M1ht for <kvmarm@lists.cs.columbia.edu>;
 Thu,  8 Oct 2015 04:20:50 -0400 (EDT)
Received: from mail-lb0-f171.google.com (mail-lb0-f171.google.com
 [209.85.217.171])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 853124130B
 for <kvmarm@lists.cs.columbia.edu>; Thu,  8 Oct 2015 04:20:50 -0400 (EDT)
Received: by lbwr8 with SMTP id r8so38028724lbw.2
 for <kvmarm@lists.cs.columbia.edu>; Thu, 08 Oct 2015 01:22:48 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <003a01d10199$58e96590$0abc30b0$@samsung.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Pavel Fedin <p.fedin@samsung.com>
Cc: kvm@vger.kernel.org, 'Marc Zyngier' <marc.zyngier@arm.com>, 'Andre Przywara' <andre.przywara@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Thu, Oct 08, 2015 at 10:17:09AM +0300, Pavel Fedin wrote:
>  Hello!
> 
> > +    The mpidr encoding is based on the affinity information in the
> > +    architecture defined MPIDR, and the field is encoded as follows:
> > +      | 63 .... 56 | 55 .... 48 | 47 .... 40 | 39 .... 32 |
> > +      |    Aff3    |    Aff2    |    Aff1    |    Aff0    |
> 
>  One concern about this... Does it already have "We are Bosses, we Decided it, It's not subject to
> change, We do not care" status? 

That's a rather negative question.

We spent a fair amount of time discussing this during SFO15 and arrived
at the conclusion that this was the way to go.

If there are good arguments for why this is not sufficient or causes
problems, then of course we'll make changes as required.

> Actually, current approach with using index instead of Aff bits
> works pretty well. It works fine with qemu too, because internally qemu also maintains CPU index,
> which it uses for GICv2 accesses.
>  Keeping index allows to reuse more code, and provides better backwards compatibility. So could we
> do this?
> 

The architecture defines how to address a specific CPU, and that's using
the MPIDR, not inventing our own scheme, so that's what we should do.

For example, I don't think you had the full 32-bits available to address
a CPU in your proposal, so if nothing else, that proposal had less
expressive power than what the architecture defines.

I also don't buy the argument that this saves a lot of code.

If you have something that deals with a cpu index, surely two simple
functions can allow the same amount of code reuse:

unsigned long mpidr_to_vcpu_idx(unsigned long mpidr);
unsigned long vcpu_idx_to_mpidr(unsigned long vcpu_idx);

-Christoffer
