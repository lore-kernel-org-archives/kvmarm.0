From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH 07/13] arm64: KVM: VHE: Patch out use of HVC
Date: Wed, 8 Jul 2015 19:14:50 +0200
Message-ID: <559D5A8A.4030901@redhat.com>
References: <1436372356-30410-1-git-send-email-marc.zyngier@arm.com>
 <1436372356-30410-8-git-send-email-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <1436372356-30410-8-git-send-email-marc.zyngier@arm.com>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>
Cc: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu



On 08/07/2015 18:19, Marc Zyngier wrote:
> +/* Hack to allow stringification of macros... */
> +#define __S__(a,args...)	__stringify(a, ##args)
> +#define _S_(a,args...)		__S__(a, args)
> +
> +.macro ifnvhe nonvhe vhe
> +	alternative_insn	"\nonvhe", "\vhe", ARM64_HAS_VIRT_HOST_EXTN
> +.endm

Why not use this in patch 6 too?

Paolo
