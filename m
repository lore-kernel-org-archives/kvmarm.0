From: Dave Martin <Dave.Martin@arm.com>
Subject: Re: [PATCH v2 1/4] arm64: introduce sysreg_clear_set()
Date: Fri, 15 Jun 2018 17:43:13 +0100
Message-ID: <20180615164313.GQ22983@e103592.cambridge.arm.com>
References: <1529077646-2848-1-git-send-email-Dave.Martin@arm.com>
 <1529077646-2848-2-git-send-email-Dave.Martin@arm.com>
 <20180615162124.jz5655podkezdcu3@armageddon.cambridge.arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
Content-Disposition: inline
In-Reply-To: <20180615162124.jz5655podkezdcu3@armageddon.cambridge.arm.com>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Mark Rutland <mark.rutland@arm.com>, Christoffer Dall <cdall@kernel.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>, Will Deacon <will.deacon@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Fri, Jun 15, 2018 at 05:21:25PM +0100, Catalin Marinas wrote:
> On Fri, Jun 15, 2018 at 04:47:23PM +0100, Dave P Martin wrote:
> > From: Mark Rutland <mark.rutland@arm.com>
> > 
> > Currently we have a couple of helpers to manipulate bits in particular
> > sysregs:
> > 
> >  * config_sctlr_el1(u32 clear, u32 set)
> > 
> >  * change_cpacr(u64 val, u64 mask)
> > 
> > The parameters of these differ in naming convention, order, and size,
> > which is unfortunate. They also differ slightly in behaviour, as
> > change_cpacr() skips the sysreg write if the bits are unchanged, which
> > is a useful optimization when sysreg writes are expensive.
> > 
> > Before we gain more yet another sysreg manipulation function, let's
> > unify these with a common helper, providing a consistent order for
> > clear/set operands, and the write skipping behaviour from
> > change_cpacr(). Code will be migrated to the new helper in subsequent
> > patches.
> > 
> > Signed-off-by: Mark Rutland <mark.rutland@arm.com>
> > Reviewed-by: Dave Martin <dave.martin@arm.com>
> > Cc: Catalin Marinas <catalin.marinas@arm.com>
> > Cc: Marc Zyngier <marc.zyngier@arm.com>
> 
> Since you are submitting this patch, it should have your signed-off-by
> as well. Other than that:
> 
> Acked-by: Catalin Marinas <catalin.marinas@arm.com>

Oops, added locally.

I had considered this optional if the patch was unmodified from the
original author, but I guess I at least applied it on a different base.
In any case, I can see why it would be considered mandatory.

Cheers
---Dave
