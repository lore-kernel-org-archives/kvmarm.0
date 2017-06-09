From: Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [PATCH 08/31] arm64: Add a facility to turn an ESR syndrome into
 a sysreg encoding
Date: Fri, 9 Jun 2017 11:38:00 +0100
Message-ID: <20170609103800.GG2186@e104818-lin.cambridge.arm.com>
References: <20170503104606.19342-1-marc.zyngier@arm.com>
 <20170503104606.19342-9-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3189840BC5
 for <kvmarm@lists.cs.columbia.edu>; Fri,  9 Jun 2017 06:33:56 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id rgUr5IReKYBN for <kvmarm@lists.cs.columbia.edu>;
 Fri,  9 Jun 2017 06:33:54 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4499E40905
 for <kvmarm@lists.cs.columbia.edu>; Fri,  9 Jun 2017 06:33:53 -0400 (EDT)
Content-Disposition: inline
In-Reply-To: <20170503104606.19342-9-marc.zyngier@arm.com>
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
Cc: kvm@vger.kernel.org, David Daney <david.daney@cavium.com>, Robert Richter <rrichter@cavium.com>, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On Wed, May 03, 2017 at 11:45:43AM +0100, Marc Zyngier wrote:
> It is often useful to compare an ESR syndrome reporting the trapping
> of a system register with a value matching that system register.
> 
> Since encoding both the sysreg and the ESR version seem to be a bit
> overkill, let's add a set of macros that convert an ESR value into
> the corresponding sysreg encoding.
> 
> We handle both AArch32 and AArch64, taking advantage of identical
> encodings between system registers and CP15 accessors.
> 
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>

Acked-by: Catalin Marinas <catalin.marinas@arm.com>
