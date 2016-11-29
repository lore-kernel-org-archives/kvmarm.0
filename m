From: Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [PATCH v2] arm64: head.S: Fix CNTHCTL_EL2 access on VHE system
Date: Tue, 29 Nov 2016 11:37:32 +0000
Message-ID: <20161129113732.GC13725@e104818-lin.cambridge.arm.com>
References: <1480385582-24176-1-git-send-email-jintack@cs.columbia.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 20D2B407D1
 for <kvmarm@lists.cs.columbia.edu>; Tue, 29 Nov 2016 06:36:49 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Efq7tXamyP9k for <kvmarm@lists.cs.columbia.edu>;
 Tue, 29 Nov 2016 06:36:48 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 49F38406A0
 for <kvmarm@lists.cs.columbia.edu>; Tue, 29 Nov 2016 06:36:47 -0500 (EST)
Content-Disposition: inline
In-Reply-To: <1480385582-24176-1-git-send-email-jintack@cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Jintack Lim <jintack@cs.columbia.edu>
Cc: marc.zyngier@arm.com, will.deacon@arm.com, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Mon, Nov 28, 2016 at 09:13:02PM -0500, Jintack Lim wrote:
> From: Jintack <jintack@cs.columbia.edu>
> 
> Bit positions of CNTHCTL_EL2 are changing depending on HCR_EL2.E2H bit.
> EL1PCEN and EL1PCTEN are 1st and 0th bits when E2H is not set, but they
> are 11th and 10th bits respectively when E2H is set.  Current code is
> unintentionally setting wrong bits to CNTHCTL_EL2 with E2H set.
> 
> In fact, we don't need to set those two bits, which allow EL1 and EL0 to
> access physical timer and counter respectively, if E2H and TGE are set
> for the host kernel. They will be configured later as necessary. First,
> we don't need to configure those bits for EL1, since the host kernel
> runs in EL2.  It is a hypervisor's responsibility to configure them
> before entering a VM, which runs in EL0 and EL1. Second, EL0 accesses
> are configured in the later stage of boot process.
> 
> Signed-off-by: Jintack Lim <jintack@cs.columbia.edu>
> Acked-by: Marc Zyngier <marc.zyngier@arm.com>

Queued for 4.10. Thanks.

-- 
Catalin
