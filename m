From: Randy Dunlap <rdunlap@infradead.org>
Subject: Re: [PATCH 05/14] arm64: Add 'ssbd' command-line option
Date: Tue, 22 May 2018 08:29:24 -0700
Message-ID: <77a402ab-d119-cc71-518c-a6d4755b7889@infradead.org>
References: <20180522150648.28297-1-marc.zyngier@arm.com>
 <20180522150648.28297-6-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <20180522150648.28297-6-marc.zyngier@arm.com>
Content-Language: en-US
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: Marc Zyngier <marc.zyngier@arm.com>, linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Cc: Kees Cook <keescook@chromium.org>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Christoffer Dall <christoffer.dall@arm.com>, Andy Lutomirski <luto@kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Thomas Gleixner <tglx@linutronix.de>
List-Id: kvmarm@lists.cs.columbia.edu

On 05/22/2018 08:06 AM, Marc Zyngier wrote:
> On a system where the firmware implements ARCH_WORKAROUND_2,
> it may be useful to either permanently enable or disable the
> workaround for cases where the user decides that they'd rather
> not get a trap overhead, and keep the mitigation permanently
> on or off instead of switching it on exception entry/exit.
> 
> In any case, default to the mitigation being enabled.
> 
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
> ---
>  Documentation/admin-guide/kernel-parameters.txt |  17 ++++
>  arch/arm64/include/asm/cpufeature.h             |   6 ++
>  arch/arm64/kernel/cpu_errata.c                  | 102 ++++++++++++++++++++----
>  3 files changed, 109 insertions(+), 16 deletions(-)
> 
> diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
> index f2040d46f095..646e112c6f63 100644
> --- a/Documentation/admin-guide/kernel-parameters.txt
> +++ b/Documentation/admin-guide/kernel-parameters.txt
> @@ -4092,6 +4092,23 @@
>  			expediting.  Set to zero to disable automatic
>  			expediting.
>  
> +	ssbd=		[ARM64,HW]
> +			Speculative Store Bypass Disable control
> +
> +			On CPUs that are vulnerable to the Speculative
> +			Store Bypass vulnerability and offer a
> +			firmware based mitigation, this parameter
> +			indicates how the mitigation should be used:
> +
> +			force-on:  Unconditionnaly enable mitigation for

			           Unconditionally

> +				   for both kernel and userspace
> +			force-off: Unconditionnaly disable mitigation for

			           Unconditionally

> +				   for both kernel and userspace
> +			kernel:    Always enable mitigation in the
> +				   kernel, and offer a prctl interface
> +				   to allow userspace to register its
> +				   interest in being mitigated too.
> +
>  	stack_guard_gap=	[MM]
>  			override the default stack gap protection. The value
>  			is in page units and it defines how many pages prior



-- 
~Randy
