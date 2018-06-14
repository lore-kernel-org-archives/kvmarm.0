From: Dave Martin <Dave.Martin@arm.com>
Subject: Re: [PATCH 0/4] KVM: arm64: FPSIMD/SVE fixes for 4.17
Date: Thu, 14 Jun 2018 13:45:00 +0100
Message-ID: <20180614124457.GM22983@e103592.cambridge.arm.com>
References: <1528976039-25826-1-git-send-email-Dave.Martin@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
Content-Disposition: inline
In-Reply-To: <1528976039-25826-1-git-send-email-Dave.Martin@arm.com>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: kvmarm@lists.cs.columbia.edu
Cc: Christoffer Dall <cdall@kernel.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Thu, Jun 14, 2018 at 12:33:55PM +0100, Dave Martin wrote:
> This series contains fixes for some issues observed since the KVM arm64
> pull request for 4.17.

*ahem*, that should read 4.18.

> The first patch (from Mark Rutland) adds a straightforward helper to
> modify particular bits in a system register conditionally.  This is used
> by patch 3 (though obviously it could be coded round and patch 1
> dropped, if preferred).
> 
> See other patches for details of the individual fixes.
> 
> Dave Martin (3):
>   KVM: arm64: Don't mask softirq with IRQs disabled in vcpu_put()
>   KVM: arm64/sve: Fix SVE trap restoration for non-current tasks
>   KVM: arm64: Avoid mistaken attempts to save SVE state for vcpus
> 
> Mark Rutland (1):
>   arm64: introduce sysreg_clear_set()
> 
>  arch/arm64/include/asm/kvm_host.h |  1 +
>  arch/arm64/include/asm/sysreg.h   | 11 ++++++++++
>  arch/arm64/kvm/fpsimd.c           | 46 +++++++++++++++++++++++++++++----------
>  3 files changed, 47 insertions(+), 11 deletions(-)
> 
> -- 
> 2.1.4
> 
> 
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
