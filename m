From: Andrew Jones <drjones@redhat.com>
Subject: Re: [Qemu-devel] [kvm-unit-tests PATCH v2 1/4] mark exit() and
 abort() as non-returning functions
Date: Fri, 3 Aug 2018 14:47:54 +0200
Message-ID: <20180803124754.44vp6llktrl7h2vv@kamzik.brq.redhat.com>
References: <20180720153942.26821-1-andre.przywara@arm.com>
 <20180720153942.26821-2-andre.przywara@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 970C240A52
 for <kvmarm@lists.cs.columbia.edu>; Fri,  3 Aug 2018 08:48:01 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Og8W0TYVEHN3 for <kvmarm@lists.cs.columbia.edu>;
 Fri,  3 Aug 2018 08:48:00 -0400 (EDT)
Received: from mx1.redhat.com (mx3-rdu2.redhat.com [66.187.233.73])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id B7D4240184
 for <kvmarm@lists.cs.columbia.edu>; Fri,  3 Aug 2018 08:48:00 -0400 (EDT)
Content-Disposition: inline
In-Reply-To: <20180720153942.26821-2-andre.przywara@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Andre Przywara <andre.przywara@arm.com>
Cc: kvm@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>, qemu-devel@nongnu.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On Fri, Jul 20, 2018 at 04:39:39PM +0100, Andre Przywara wrote:
> exit() and abort() are functions that never return, and (at least)
> GCC has an attribute to flag those functions accordingly. This allows
> the compiler to do further optimizations and to omit various warnings
> about uninitialized variables, for instance.
> Since the actual "play-dead" function is in (inline) assembly, the
> compiler does not recognize its fatal nature, so help it with the
> __builtin_unreachable() hint.
> Flag the prototypes of our fatal functions accordingly.
> 
> Signed-off-by: Andre Przywara <andre.przywara@arm.com>
> ---
>  lib/arm/io.c     | 1 +
>  lib/libcflat.h   | 7 ++++---
>  lib/powerpc/io.c | 1 +
>  lib/x86/io.c     | 1 +
>  4 files changed, 7 insertions(+), 3 deletions(-)
>

Reviewed-by: Andrew Jones <drjones@redhat.com>
