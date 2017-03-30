From: Mark Rutland <mark.rutland@arm.com>
Subject: Re: KVM/ARM: sleeping function called from invalid context
Date: Thu, 30 Mar 2017 16:29:56 +0100
Message-ID: <20170330152955.GJ16211@leverpostej>
References: <20170330143112.GI16211@leverpostej>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 26BD640A7F
 for <kvmarm@lists.cs.columbia.edu>; Thu, 30 Mar 2017 11:28:13 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id XfZFie3S4WG7 for <kvmarm@lists.cs.columbia.edu>;
 Thu, 30 Mar 2017 11:28:12 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3026F40296
 for <kvmarm@lists.cs.columbia.edu>; Thu, 30 Mar 2017 11:28:11 -0400 (EDT)
Content-Disposition: inline
In-Reply-To: <20170330143112.GI16211@leverpostej>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
Cc: marc.zyngier@arm.com
List-Id: kvmarm@lists.cs.columbia.edu

On Thu, Mar 30, 2017 at 03:31:12PM +0100, Mark Rutland wrote:
> Hi,
> 
> I'm seeing the splat below when running KVM on an arm64 host with
> CONFIG_DEBUG_ATOMIC_SLEEP and CONFIG_LOCKDEP enabled.
> 
> I saw this on v4.11-rc1, and I can reproduce the problem on the current
> kvmarm master branch (563e2f5daa66fbc1).
>
> I've hacked noinlines into arch/arm/kvm/mmu.c in an attempt to get a
> better backtrace; without this, the report says the call is at
> arch/arm/kvm/mmu.c:299, which is somewhat confusing.

Looking again, that initial kernel was not a vanilla v4.11-rc1, and I am
*not* able to reproduce this issue with a vanilla v4.11-rc1.

I believe I had applied an earlier fix for the locking issue Suzuki
recently addressed, which was why my line numbers were off.

I *can* trigger this issue with the current kvmarm master, and the log I
posted is valid.

Sorry for the bogus info; I will be more careful next time.

Thanks,
Mark.
