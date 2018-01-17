From: Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [PATCH] arm64: mm: Add additional parameter to
 uaccess_ttbr0_disable
Date: Wed, 17 Jan 2018 11:52:11 +0000
Message-ID: <20180117115211.itijfrz6o6xibf7n@armageddon.cambridge.arm.com>
References: <20180117113850.21949-1-christoffer.dall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 795A049E2D
 for <kvmarm@lists.cs.columbia.edu>; Wed, 17 Jan 2018 06:47:13 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ulDx+vafDSNQ for <kvmarm@lists.cs.columbia.edu>;
 Wed, 17 Jan 2018 06:47:12 -0500 (EST)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 531DE49E12
 for <kvmarm@lists.cs.columbia.edu>; Wed, 17 Jan 2018 06:47:12 -0500 (EST)
Content-Disposition: inline
In-Reply-To: <20180117113850.21949-1-christoffer.dall@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Christoffer Dall <christoffer.dall@linaro.org>
Cc: Marc Zyngier <marc.zyngier@arm.com>, Will Deacon <will.deacon@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

On Wed, Jan 17, 2018 at 12:38:50PM +0100, Christoffer Dall wrote:
> Add an extra temporary register parameter to uaccess_ttbr0_disable which
> is about to be required for arm64 PAN support.
> 
> This patch doesn't introduce any functional change but ensures that the
> kernel compiles once the KVM/ARM tree is merged with the arm64 tree by
> ensuring a trivially mergable conflict with commit
> 6b88a32c7af68895134872cdec3b6bfdb532d94e
> ("arm64: kpti: Fix the interaction between ASID switching and software PAN").
> 
> Cc: Will Deacon <will.deacon@arm.com>
> Cc: Catalin Marinas <catalin.marinas@arm.com>
> Cc: Marc Zyngier <marc.zyngier@arm.com>
> Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>

Acked-by: Catalin Marinas <catalin.marinas@arm.com>
