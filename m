From: Suzuki K Poulose <Suzuki.Poulose@arm.com>
Subject: Re: [PATCH 2/2] arm64/kvm: survive unknown traps from guests
Date: Mon, 20 Feb 2017 13:48:32 +0000
Message-ID: <1b9e40b9-a6f8-97d3-eacc-15a4f664d4a7@arm.com>
References: <1487593812-9174-1-git-send-email-mark.rutland@arm.com>
 <1487593812-9174-3-git-send-email-mark.rutland@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BD76240CE0
 for <kvmarm@lists.cs.columbia.edu>; Mon, 20 Feb 2017 08:47:42 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id nZLgT-TG4sEC for <kvmarm@lists.cs.columbia.edu>;
 Mon, 20 Feb 2017 08:47:41 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8D34640C27
 for <kvmarm@lists.cs.columbia.edu>; Mon, 20 Feb 2017 08:47:41 -0500 (EST)
In-Reply-To: <1487593812-9174-3-git-send-email-mark.rutland@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Mark Rutland <mark.rutland@arm.com>, kvmarm@lists.cs.columbia.edu
Cc: marc.zyngier@arm.com, linux-arm-kernel@lists.infradead.org, dave.martin@arm.com
List-Id: kvmarm@lists.cs.columbia.edu

On 20/02/17 12:30, Mark Rutland wrote:
> Currently we BUG() if we see an ESR_EL2.EC value we don't recognise. As
> configurable disables/enables are added to the architecture (controlled
> by RES1/RES0 bits respectively), with associated synchronous exceptions,
> it may be possible for a guest to trigger exceptions with classes that
> we don't recognise.
>
> While we can't service these exceptions in a manner useful to the guest,
> we can avoid bringing down the host. Per ARM DDI 0487A.k_iss10775, page
> D7-1937, EC values within the range 0x00 - 0x2c are reserved for future
> use with synchronous exceptions, and EC values within the range 0x2d -
> 0x3f may be used for either synchronous or asynchronous exceptions.
>
> The patch makes KVM handle any unknown EC by injecting an UNDEFINED
> exception into the guest, with a corresponding (ratelimited) warning in
> the host dmesg. We could later improve on this with with a new (opt-in)
> exit to the host userspace.

If the unknown EC happens to be an asynchronous exception (allocated from the second range),
we are not sure if that was triggered by this guest, or a different guest or even
the hypervisor if we cannot really isolate the exception(with/without the RAS
extensions, i.e ESB). And I accept there may not be a perfect solution to the problem
either. May be we could explicitly mention about "unsure" exceptions, so that
it might help, people who may not really have the deep knowledge about the
exception code schemes.

Suzuki
