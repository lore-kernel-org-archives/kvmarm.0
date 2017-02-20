From: Mark Rutland <mark.rutland@arm.com>
Subject: Re: [PATCH 2/2] arm64/kvm: survive unknown traps from guests
Date: Mon, 20 Feb 2017 14:01:06 +0000
Message-ID: <20170220140106.GA9583@leverpostej>
References: <1487593812-9174-1-git-send-email-mark.rutland@arm.com>
 <1487593812-9174-3-git-send-email-mark.rutland@arm.com>
 <1b9e40b9-a6f8-97d3-eacc-15a4f664d4a7@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4FEA540D16
 for <kvmarm@lists.cs.columbia.edu>; Mon, 20 Feb 2017 09:00:23 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id zHeC8SONatDN for <kvmarm@lists.cs.columbia.edu>;
 Mon, 20 Feb 2017 09:00:22 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6A94940C72
 for <kvmarm@lists.cs.columbia.edu>; Mon, 20 Feb 2017 09:00:22 -0500 (EST)
Content-Disposition: inline
In-Reply-To: <1b9e40b9-a6f8-97d3-eacc-15a4f664d4a7@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Suzuki K Poulose <Suzuki.Poulose@arm.com>
Cc: marc.zyngier@arm.com, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, dave.martin@arm.com
List-Id: kvmarm@lists.cs.columbia.edu

On Mon, Feb 20, 2017 at 01:48:32PM +0000, Suzuki K Poulose wrote:
> On 20/02/17 12:30, Mark Rutland wrote:

> >The patch makes KVM handle any unknown EC by injecting an UNDEFINED
> >exception into the guest, with a corresponding (ratelimited) warning in
> >the host dmesg. We could later improve on this with with a new (opt-in)
> >exit to the host userspace.
> 
> If the unknown EC happens to be an asynchronous exception (allocated
> from the second range), we are not sure if that was triggered by this
> guest, or a different guest or even the hypervisor if we cannot really
> isolate the exception(with/without the RAS extensions, i.e ESB).

Sure; that is certainly a worry. 

> And I accept there may not be a perfect solution to the problem
> either. May be we could explicitly mention about "unsure" exceptions,
> so that it might help, people who may not really have the deep
> knowledge about the exception code schemes.

I guess we could, though I'm not sure how this is going to be helpful
for those without an understanding of the EC values. We can only say it
*may* be an asynchronous exception, so to understand the issue you need
to understand the EC value.

Thanks,
Mark.
