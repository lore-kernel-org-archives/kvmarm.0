From: Jon Masters <jcm@jonmasters.org>
Subject: Re: [PATCH v2 05/17] arm64: Add 'ssbd' command-line option
Date: Sat, 9 Jun 2018 08:53:08 -0400
Message-ID: <e1b89362-ba94-ead9-a930-eac0e1b3ffba@jonmasters.org>
References: <20180529121121.24927-1-marc.zyngier@arm.com>
 <20180529121121.24927-6-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <20180529121121.24927-6-marc.zyngier@arm.com>
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
Cc: Mark Rutland <mark.rutland@arm.com>, Kees Cook <keescook@chromium.org>, Catalin Marinas <catalin.marinas@arm.com>, Randy Dunlap <rdunlap@infradead.org>, Will Deacon <will.deacon@arm.com>, Christoffer Dall <christoffer.dall@arm.com>, Dominik Brodowski <linux@dominikbrodowski.net>, Julien Grall <julien.grall@arm.com>, Andy Lutomirski <luto@kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Thomas Gleixner <tglx@linutronix.de>
List-Id: kvmarm@lists.cs.columbia.edu

On 05/29/2018 08:11 AM, Marc Zyngier wrote:

> +	ssbd=		[ARM64,HW]
> +			Speculative Store Bypass Disable control
> +
> +			On CPUs that are vulnerable to the Speculative
> +			Store Bypass vulnerability and offer a
> +			firmware based mitigation, this parameter
> +			indicates how the mitigation should be used:
> +
> +			force-on:  Unconditionally enable mitigation for
> +				   for both kernel and userspace
> +			force-off: Unconditionally disable mitigation for
> +				   for both kernel and userspace
> +			kernel:    Always enable mitigation in the
> +				   kernel, and offer a prctl interface
> +				   to allow userspace to register its
> +				   interest in being mitigated too.

This should be "spec_store_bypass_disable" and it should have the same
parameters as on x86: "on", "off", "auto". Why not just add "kernel"?
(we had a "kernel" early on for x86 as well, and it might still end up
coming back anyway). If there's a /compelling/ reason to have the Arm
parameter differ, then it should still recognize the x86 parameter,
similarly to how POWER also does that for cross-arch consistency.

We'll add the x86 parameter way of doing it to RHEL anyway.

Jon.
