From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v8 02/16] arm: use new phandle allocation functions
Date: Fri, 9 Dec 2016 13:26:32 +0000
Message-ID: <f22a4d61-09d2-6562-11f9-f3232cf394b2@arm.com>
References: <20161104173203.21168-1-andre.przywara@arm.com>
 <20161104173203.21168-3-andre.przywara@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CA2BD404D5
 for <kvmarm@lists.cs.columbia.edu>; Fri,  9 Dec 2016 08:25:35 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Ip0Ih4iawQpY for <kvmarm@lists.cs.columbia.edu>;
 Fri,  9 Dec 2016 08:25:34 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 18B134044B
 for <kvmarm@lists.cs.columbia.edu>; Fri,  9 Dec 2016 08:25:33 -0500 (EST)
In-Reply-To: <20161104173203.21168-3-andre.przywara@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Andre Przywara <andre.przywara@arm.com>, Will Deacon <will.deacon@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

On 04/11/16 17:31, Andre Przywara wrote:
> To refer to the GIC FDT node, we used to pass the GIC phandle to most
> of the functions dealing with FDT nodes.
> Since we now have a global phandle reference, use that to refer to the
> GIC handle in various places and get rid of the now unneeded parameter
> passing.
> 
> Signed-off-by: Andre Przywara <andre.przywara@arm.com>

Despite the comments on the previous patch, this one is a good cleanup.

Acked-by: Marc Zyngier <marc.zyngier@arm.com>

	M.
-- 
Jazz is not dead. It just smells funny...
