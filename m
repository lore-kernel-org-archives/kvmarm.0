From: Will Deacon <will.deacon@arm.com>
Subject: Re: [PATCH v2 00/17] arm64 SSBD (aka Spectre-v4) mitigation
Date: Wed, 30 May 2018 16:58:55 +0100
Message-ID: <20180530155854.GA4122@arm.com>
References: <20180529121121.24927-1-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180529121121.24927-1-marc.zyngier@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, kvmarm@lists.cs.columbia.edu, Catalin Marinas <catalin.marinas@arm.com>, Thomas Gleixner <tglx@linutronix.de>, Andy Lutomirski <luto@kernel.org>, Kees Cook <keescook@chromium.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Christoffer Dall <christoffer.dall@arm.com>, Randy Dunlap <rdunlap@infradead.org>, Dominik Brodowski <linux@dominikbrodowski.net>, Julien Grall <julien.grall@arm.com>, Mark Rutland <mark.rutland@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

Hi Marc,

On Tue, May 29, 2018 at 01:11:04PM +0100, Marc Zyngier wrote:
> This patch series implements the Linux kernel side of the "Spectre-v4"
> (CVE-2018-3639) mitigation known as "Speculative Store Bypass Disable"
> (SSBD).
> 
> More information can be found at:
> 
>   https://bugs.chromium.org/p/project-zero/issues/detail?id=1528
>   https://developer.arm.com/support/arm-security-updates/speculative-processor-vulnerability
> 
> For all released Arm Cortex-A CPUs that are affected by this issue, then
> the preferred mitigation is simply to set a chicken bit in the firmware
> during CPU initialisation and therefore no change to Linux is required.
> Other CPUs may require the chicken bit to be toggled dynamically (for
> example, when switching between user-mode and kernel-mode) and this is
> achieved by calling into EL3 via an SMC which has been published as part
> of the latest SMCCC specification:
> 
>   https://developer.arm.com/cache-speculation-vulnerability-firmware-specification
> 
> as well as an ATF update for the released ARM cores affected by SSBD:
> 
>   https://github.com/ARM-software/arm-trusted-firmware/pull/1392
> 
> These patches provide the following:
> 
>   1. Safe probing of firmware to establish which CPUs in the system
>      require calling into EL3 as part of the mitigation.
> 
>   2. For CPUs that require it, call into EL3 on exception entry/exit
>      from EL0 to apply the SSBD mitigation when running at EL1.
> 
>   3. A command-line option to force the SSBD mitigation to be always on,
>      always off, or dymamically toggled (default) for CPUs that require
>      the EL3 call.
> 
>   4. An initial implementation of a prctl() backend for arm64 that allows
>      userspace tasks to opt-in to the mitigation explicitly. This is
>      intended to match the interface provided by x86, and so we rely on
>      their core changes here. The seccomp interface is provided as an
>      extra set of patches, which I'd like *not* to see merged. The main
>      reason is that it is invasive, has ugly/unclear semantics, and could
>      probably be left to the existing prctl interface.

I agree with you here. For patches 1-10, then:

Acked-by: Will Deacon <will.deacon@arm.com>

but I'd prefer to leave the seccomp stuff alone for the moment because I
don't think the implicit enabling is necessarily the right thing to do
there and supporting it comes at a cost.

Will
