From: Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [PATCH v5 04/23] arm64: KVM: Dynamically patch the kernel/hyp VA
 mask
Date: Wed, 7 Mar 2018 18:10:59 +0000
Message-ID: <20180307181059.7nssh2amhvrvh2v7@armageddon.cambridge.arm.com>
References: <20180301155538.26860-1-marc.zyngier@arm.com>
 <20180301155538.26860-5-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A523C402D6
 for <kvmarm@lists.cs.columbia.edu>; Wed,  7 Mar 2018 13:04:24 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id TZPP1y2LaKVp for <kvmarm@lists.cs.columbia.edu>;
 Wed,  7 Mar 2018 13:04:03 -0500 (EST)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D7DA249DF7
 for <kvmarm@lists.cs.columbia.edu>; Wed,  7 Mar 2018 13:03:48 -0500 (EST)
Content-Disposition: inline
In-Reply-To: <20180301155538.26860-5-marc.zyngier@arm.com>
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
Cc: kvm@vger.kernel.org, Will Deacon <will.deacon@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Thu, Mar 01, 2018 at 03:55:19PM +0000, Marc Zyngier wrote:
> So far, we're using a complicated sequence of alternatives to
> patch the kernel/hyp VA mask on non-VHE, and NOP out the
> masking altogether when on VHE.
> 
> The newly introduced dynamic patching gives us the opportunity
> to simplify that code by patching a single instruction with
> the correct mask (instead of the mind bending cummulative masking
> we have at the moment) or even a single NOP on VHE. This also
> adds some initial code that will allow the patching callback
> to switch to a more complex patching.
> 
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>

Acked-by: Catalin Marinas <catalin.marinas@arm.com>
