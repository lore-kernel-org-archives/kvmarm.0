From: Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [PATCH] arm64: Add support for new control bits CTR_EL0.IDC and
 CTR_EL0.IDC
Date: Mon, 19 Feb 2018 14:38:21 +0000
Message-ID: <20180219143820.5oxc2kendvq4bbtt@armageddon.cambridge.arm.com>
References: <1518829066-3558-1-git-send-email-shankerd@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
Content-Disposition: inline
In-Reply-To: <1518829066-3558-1-git-send-email-shankerd@codeaurora.org>
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
Cc: Philip Elcan <pelcan@codeaurora.org>, Vikram Sethi <vikrams@codeaurora.org>, Marc Zyngier <marc.zyngier@arm.com>, Will Deacon <will.deacon@arm.com>, linux-kernel <linux-kernel@vger.kernel.org>, kvmarm <kvmarm@lists.cs.columbia.edu>, linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
List-Id: kvmarm@lists.cs.columbia.edu

On Fri, Feb 16, 2018 at 06:57:46PM -0600, Shanker Donthineni wrote:
> Two point of unification cache maintenance operations 'DC CVAU' and
> 'IC IVAU' are optional for implementors as per ARMv8 specification.
> This patch parses the updated CTR_EL0 register definition and adds
> the required changes to skip POU operations if the hardware reports
> CTR_EL0.IDC and/or CTR_EL0.IDC.
> 
> CTR_EL0.DIC: Instruction cache invalidation requirements for
>  instruction to data coherence. The meaning of this bit[29].
>   0: Instruction cache invalidation to the point of unification
>      is required for instruction to data coherence.
>   1: Instruction cache cleaning to the point of unification is
>       not required for instruction to data coherence.
> 
> CTR_EL0.IDC: Data cache clean requirements for instruction to data
>  coherence. The meaning of this bit[28].
>   0: Data cache clean to the point of unification is required for
>      instruction to data coherence, unless CLIDR_EL1.LoC == 0b000
>      or (CLIDR_EL1.LoUIS == 0b000 && CLIDR_EL1.LoUU == 0b000).
>   1: Data cache clean to the point of unification is not required
>      for instruction to data coherence.

There is a difference between cache maintenance to PoU "is not required"
and the actual instructions being optional (i.e. undef when executed).
If your caches are transparent and DC CVAU/IC IVAU is not required,
these instructions should behave as NOPs. So, are you trying to improve
the performance of the cache maintenance routines in the kernel? If yes,
please show some (relative) numbers and a better description in the
commit log.

On the patch, I'd rather have an alternative framework entry for no VAU
cache maint required and some ret instruction at the beginning of the
cache maint function rather than jumping out of the loop somewhere
inside the cache maintenance code, penalising the CPUs that do require
it.

-- 
Catalin
