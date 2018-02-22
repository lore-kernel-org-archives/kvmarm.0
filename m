From: Mark Rutland <mark.rutland@arm.com>
Subject: Re: [PATCH v4] arm64: Add support for new control bits CTR_EL0.DIC
 and CTR_EL0.IDC
Date: Thu, 22 Feb 2018 15:22:44 +0000
Message-ID: <20180222152244.zozx2tlptgnnfu6b@lakrids.cambridge.arm.com>
References: <1519311090-19998-1-git-send-email-shankerd@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
Content-Disposition: inline
In-Reply-To: <1519311090-19998-1-git-send-email-shankerd@codeaurora.org>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: Shanker Donthineni <shankerd@codeaurora.org>
Cc: Philip Elcan <pelcan@codeaurora.org>, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, linux-kernel <linux-kernel@vger.kernel.org>, kvmarm <kvmarm@lists.cs.columbia.edu>, linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
List-Id: kvmarm@lists.cs.columbia.edu

On Thu, Feb 22, 2018 at 08:51:30AM -0600, Shanker Donthineni wrote:
> +#define CTR_B31_SHIFT		31

Since this is just a RES1 bit, I think we don't need a mnemonic for it,
but I'll defer to Will and Catalin on that.

>  ENTRY(invalidate_icache_range)
> +#ifdef CONFIG_ARM64_SKIP_CACHE_POU
> +alternative_if ARM64_HAS_CACHE_DIC
> +	mov	x0, xzr
> +	dsb	ishst
> +	isb
> +	ret
> +alternative_else_nop_endif
> +#endif

As commented on v3, I don't believe you need the DSB here. If prior
stores haven't been completed at this point, the existing implementation
would not work correctly here.

Otherwise, this looks ok to me.

Thanks,
Mark.
