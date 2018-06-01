From: Mark Rutland <mark.rutland@arm.com>
Subject: Re: [PATCH] KVM: arm64: VHE: Migrate _elx sysreg accessors to
 msr_s/mrs_s
Date: Fri, 1 Jun 2018 10:42:24 +0100
Message-ID: <20180601094224.ctyvafybcnzys6f4@salmiak>
References: <1527603647-24787-1-git-send-email-Dave.Martin@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
Content-Disposition: inline
In-Reply-To: <1527603647-24787-1-git-send-email-Dave.Martin@arm.com>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: Dave Martin <Dave.Martin@arm.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Christoffer Dall <christoffer.dall@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

Hi,

On Tue, May 29, 2018 at 03:20:47PM +0100, Dave Martin wrote:
> Currently, the {read,write}_sysreg_el*() accessors for accessing
> particular ELs' sysregs in the presence of VHE rely on some local
> hacks and define their system register encodings in a way that is
> inconsistent with the core definitions in <asm/sysreg.h>.
> 
> As a result, it is necessary to add duplicate definitions for any
> system register that already needs a definition in sysreg.h for
> other reasons.
> 
> This is a bit of a maintenance headache, and the reasons for the
> _el*() accessors working the way they do is a bit historical.
> 
> This patch gets rid of the shadow sysreg definitions in
> <asm/kvm_hyp.h>, converts the _el*() accessors to use the core
> msr_s/mrs_s interface, and converts all call sites to use the
> standard sysreg #define names (i.e., upper case, with SYS_ prefix).

Nice!

[...]

>  static inline unsigned long vcpu_read_elr_el1(const struct kvm_vcpu *vcpu)
>  {
>  	if (vcpu->arch.sysregs_loaded_on_cpu)
> -		return read_sysreg_el1(elr);
> +		return read_sysreg_el1(SYS_ELR);

Could we have the macro implicitly handle the SYS_ prefix?

A further bit of cleanup that I'd like to do is make {read,write}_sysreg() use
{mrs,msr}_s, implicitly handling the SYS_ prefix, so that we can kill off
{read,write}_sysreg_s(), and always use a {read,write}_sysreg().

A minor pain point is that we'd have to convert callers to pass the sysreg name
in upper-case, but that conversion can be scripted fairly easily.

e.g. for the above, read_sysreg() would take ELR_EL1, and read_sysreg_el1()
would take ELR.

Thanks,
Mark.
