From: Mark Rutland <mark.rutland@arm.com>
Subject: Re: [PATCH 00/12] arm64: Paravirtualized time support
Date: Mon, 10 Dec 2018 11:40:47 +0000
Message-ID: <20181210114047.tifwh6ilwzphsbqy@lakrids.cambridge.arm.com>
References: <20181128144527.44710-1-steven.price@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5AE754A334
 for <kvmarm@lists.cs.columbia.edu>; Mon, 10 Dec 2018 06:40:53 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id IdBOXaie4gb9 for <kvmarm@lists.cs.columbia.edu>;
 Mon, 10 Dec 2018 06:40:52 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 11E3F4A2E9
 for <kvmarm@lists.cs.columbia.edu>; Mon, 10 Dec 2018 06:40:52 -0500 (EST)
Content-Disposition: inline
In-Reply-To: <20181128144527.44710-1-steven.price@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Steven Price <steven.price@arm.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Wed, Nov 28, 2018 at 02:45:15PM +0000, Steven Price wrote:
> This series add support for paravirtualized time for Arm64 guests and
> KVM hosts following the specification in Arm's document DEN 0057A:
> 
> https://developer.arm.com/docs/den0057/a
> 
> It implements support for Live Physical Time (LPT) which provides the
> guest with a method to derive a stable counter of time during which the
> guest is executing even when the guest is being migrated between hosts
> with different physical counter frequencies.
> 
> It also implements support for stolen time, allowing the guest to
> identify time when it is forcibly not executing.

I know that stolen time reporting is important, and I think that we
definitely want to pick up that part of the spec (once it is published
in some non-draft form).

However, I am very concerned with the pv-freq part of LPT, and I'd like
to avoid that if at all possible. I say that because:

* By design, it breaks architectural guarantees from the PoV of SW in
  the guest.

  A VM may host multiple SW agents serially (e.g. when booting, or
  across kexec), or concurrently (e.g. Linux w/ EFI runtime services),
  and the host has no way to tell whether all software in the guest will
  function correctly. Due to this, it's not possible to have a guest
  opt-in to the architecturally-broken timekeeping.

  Existing guests will not work correctly once pv-freq is in use, and if
  configured without pv-freq (or if the guest fails to discover pv-freq
  for any reason), the administrator may encounter anything between
  subtle breakage or fatally incorrect timekeeping.

  There's plenty of SW agents other than Linux which runs in a guest,
  which would need to be updated to handle pv-freq, e.g. GRUB, *BSD,
  iPXE.

  Given this, I think that this is going to lead to subtle breakage in
  real-world scenarios. 

* It is (necessarily) invasive to the low-level arch timer code. This is
  unfortunate, and I strongly suspect this is going to be an area with
  long-term subtle breakage.

* It's not clear to me how strongly people need this. My understanding
  is that datacenters would run largely homogeneous platforms. I suspect
  large datacenters which would use migration are in a position to
  mandate a standard timer frequency from their OEMs or SiPs.

  I strongly believe that an architectural fix (e.g. in-hw scaling)
  would be the better solution.

I understand that LPT is supposed to account for time lost during the
migration. Can we account for this without pv-freq? e.g. is it possible
to account for this in the same way as stolen time?

Thanks,
Mark.
