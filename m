From: Mark Rutland <mark.rutland@arm.com>
Subject: Re: [PATCH 1/2] arm/kvm: survive unknown traps from guests
Date: Mon, 6 Mar 2017 17:33:30 +0000
Message-ID: <20170306173330.GH18519@leverpostej>
References: <1487593812-9174-1-git-send-email-mark.rutland@arm.com>
 <1487593812-9174-2-git-send-email-mark.rutland@arm.com>
 <20170306150803.GB1502@lvm>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A4A1140BC5
 for <kvmarm@lists.cs.columbia.edu>; Mon,  6 Mar 2017 12:32:35 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id n+jegKur5OVh for <kvmarm@lists.cs.columbia.edu>;
 Mon,  6 Mar 2017 12:32:22 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2540B40A86
 for <kvmarm@lists.cs.columbia.edu>; Mon,  6 Mar 2017 12:32:22 -0500 (EST)
Content-Disposition: inline
In-Reply-To: <20170306150803.GB1502@lvm>
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
Cc: marc.zyngier@arm.com, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, dave.martin@arm.com
List-Id: kvmarm@lists.cs.columbia.edu

On Mon, Mar 06, 2017 at 07:08:03AM -0800, Christoffer Dall wrote:
> On Mon, Feb 20, 2017 at 12:30:11PM +0000, Mark Rutland wrote:
> >  static exit_handle_fn arm_exit_handlers[] = {
> > +	[0 ... HSR_EC_MAX]	= kvm_handle_unknown_ec,
> 
> Cool stuff, didn't know you could do this in C.

Strictly speaking, it's a GCC-ism, though we use it all over the place:

[mark@leverpostej:~/src/linux]% git grep '\[.*\.\.\..*\]\s=' | wc -l
394

It may also make checkpatch a bit grumpy, though I think that's being
worked on.

> Reviewed-by: Christoffer Dall <cdall@linaro.org>

Cheers!

I assume you or Marc will pick this up?

Thanks,
Mark.
