From: Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [PATCH v5 19/23] arm64: KVM: Allow far branches from vector
 slots to the main vectors
Date: Thu, 8 Mar 2018 13:59:45 +0000
Message-ID: <20180308135944.oqrm5n7hmvitknxu@armageddon.cambridge.arm.com>
References: <20180301155538.26860-1-marc.zyngier@arm.com>
 <20180301155538.26860-20-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6A38E49D6C
 for <kvmarm@lists.cs.columbia.edu>; Thu,  8 Mar 2018 08:52:55 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ahc7NZbRsh7c for <kvmarm@lists.cs.columbia.edu>;
 Thu,  8 Mar 2018 08:52:34 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5118A402D6
 for <kvmarm@lists.cs.columbia.edu>; Thu,  8 Mar 2018 08:52:32 -0500 (EST)
Content-Disposition: inline
In-Reply-To: <20180301155538.26860-20-marc.zyngier@arm.com>
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

On Thu, Mar 01, 2018 at 03:55:34PM +0000, Marc Zyngier wrote:
> So far, the branch from the vector slots to the main vectors can at
> most be 4GB from the main vectors (the reach of ADRP), and this
> distance is known at compile time. If we were to remap the slots
> to an unrelated VA, things would break badly.
> 
> A way to achieve VA independence would be to load the absolute
> address of the vectors (__kvm_hyp_vector), either using a constant
> pool or a series of movs, followed by an indirect branch.
> 
> This patches implements the latter solution, using another instance
> of a patching callback.
> 
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>

Acked-by: Catalin Marinas <catalin.marinas@arm.com>
