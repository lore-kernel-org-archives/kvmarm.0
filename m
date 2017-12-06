From: Will Deacon <will.deacon@arm.com>
Subject: Re: [PATCH] arm64: kvm: Prevent restoring stale PMSCR_EL1 for vcpu
Date: Wed, 6 Dec 2017 17:25:51 +0000
Message-ID: <20171206172551.GD25408@arm.com>
References: <1512580189-5921-1-git-send-email-julien.thierry@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id AD80E49D4F
 for <kvmarm@lists.cs.columbia.edu>; Wed,  6 Dec 2017 12:22:34 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id OZ8l38vHHOZR for <kvmarm@lists.cs.columbia.edu>;
 Wed,  6 Dec 2017 12:22:33 -0500 (EST)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7C76A49D28
 for <kvmarm@lists.cs.columbia.edu>; Wed,  6 Dec 2017 12:22:33 -0500 (EST)
Content-Disposition: inline
In-Reply-To: <1512580189-5921-1-git-send-email-julien.thierry@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Julien Thierry <julien.thierry@arm.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, stable@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On Wed, Dec 06, 2017 at 05:09:49PM +0000, Julien Thierry wrote:
> When VHE is not present, KVM needs to save and restores PMSCR_EL1 when
> possible. If SPE is used by the host, value of PMSCR_EL1 cannot be saved
> for the guest.
> If the host starts using SPE between two save+restore on the same vcpu,
> restore will write the value of PMSCR_EL1 read during the first save.
> 
> Make sure __debug_save_spe_nvhe clears the value of the saved PMSCR_EL1
> when the guest cannot use SPE.

Ok, so the problem is that we have a stale (non-zero) saved pmscr_el1,
and therefore the restore code unconditionally restores that even though
SPE is no longer in use by the host. Well spotted!

> Signed-off-by: Julien Thierry <julien.thierry@arm.com>
> Cc: Christoffer Dall <christoffer.dall@linaro.org>
> Cc: Marc Zyngier <marc.zyngier@arm.com>
> Cc: Catalin Marinas <catalin.marinas@arm.com>
> Cc: Will Deacon <will.deacon@arm.com>
> Cc: <stable@vger.kernel.org>
> ---
>  arch/arm64/kvm/hyp/debug-sr.c | 3 +++
>  1 file changed, 3 insertions(+)

Reviewed-by: Will Deacon <will.deacon@arm.com>

Will
