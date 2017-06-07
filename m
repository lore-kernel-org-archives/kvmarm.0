From: Christoffer Dall <cdall@linaro.org>
Subject: Re: [PATCH 2/3] arm64: KVM: Allow unaligned accesses at EL2
Date: Wed, 7 Jun 2017 11:56:46 +0200
Message-ID: <20170607095646.GD24481@cbox>
References: <20170606180835.14421-1-marc.zyngier@arm.com>
 <20170606180835.14421-3-marc.zyngier@arm.com>
 <20170606200912.GQ9464@cbox>
 <73f039f7-7597-fd34-367c-1cc6fdda3673@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9C0E640A74
 for <kvmarm@lists.cs.columbia.edu>; Wed,  7 Jun 2017 05:52:53 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 0smH595-+r14 for <kvmarm@lists.cs.columbia.edu>;
 Wed,  7 Jun 2017 05:52:52 -0400 (EDT)
Received: from mail-wm0-f46.google.com (mail-wm0-f46.google.com [74.125.82.46])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 97A5840905
 for <kvmarm@lists.cs.columbia.edu>; Wed,  7 Jun 2017 05:52:52 -0400 (EDT)
Received: by mail-wm0-f46.google.com with SMTP id d73so7378801wma.0
 for <kvmarm@lists.cs.columbia.edu>; Wed, 07 Jun 2017 02:56:59 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <73f039f7-7597-fd34-367c-1cc6fdda3673@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: kvm@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Wed, Jun 07, 2017 at 10:16:29AM +0100, Marc Zyngier wrote:
> On 06/06/17 21:09, Christoffer Dall wrote:
> > On Tue, Jun 06, 2017 at 07:08:34PM +0100, Marc Zyngier wrote:
> >> We currently have the SCTLR_EL2.A bit set, trapping unaligned accesses
> >> at EL2, but we're not really prepared to deal with it. So far, this
> >> has been unnoticed, until GCC 7 started emitting those (in particular
> >> 64bit writes on a 32bit boundary).
> >>
> >> Since the rest of the kernel is pretty happy about that, let's follow
> >> its example and set SCTLR_EL2.A to zero. Modern CPUs don't really
> >> care.
> > 
> > Why do we set the A flag via SCTLR_ELx_FLAGS in the first place, only to
> > drop that flag later on for both EL1 and EL2 ?
> 
> That flag is always cleared at EL1, never set. Actually, only EL2 uses
> that macro to *set* flags. An alternative would be to do away with the
> macro and use the individual flags, like the 32bit side does.
> 
> What do you think?
> 
I don't understand why the A bit is part of SCTLR_ELx_FLAGS then?  Is it
used as a mask, is that why?

In terms of these patches, I think we should apply these, because they
solve the problem and do the same thing.

Thanks,
-Christoffer
