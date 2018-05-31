From: Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [PATCH v2 00/17] arm64 SSBD (aka Spectre-v4) mitigation
Date: Thu, 31 May 2018 17:41:34 +0100
Message-ID: <20180531164133.6z6py7nl55ty473e@armageddon.cambridge.arm.com>
References: <20180529121121.24927-1-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180529121121.24927-1-marc.zyngier@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, kvmarm@lists.cs.columbia.edu, Mark Rutland <mark.rutland@arm.com>, Kees Cook <keescook@chromium.org>, Randy Dunlap <rdunlap@infradead.org>, Will Deacon <will.deacon@arm.com>, Christoffer Dall <christoffer.dall@arm.com>, Dominik Brodowski <linux@dominikbrodowski.net>, Julien Grall <julien.grall@arm.com>, Andy Lutomirski <luto@kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Thomas Gleixner <tglx@linutronix.de>
List-Id: kvmarm@lists.cs.columbia.edu

On Tue, May 29, 2018 at 01:11:04PM +0100, Marc Zyngier wrote:
> Marc Zyngier (17):
>   arm/arm64: smccc: Add SMCCC-specific return codes
>   arm64: Call ARCH_WORKAROUND_2 on transitions between EL0 and EL1
>   arm64: Add per-cpu infrastructure to call ARCH_WORKAROUND_2
>   arm64: Add ARCH_WORKAROUND_2 probing
>   arm64: Add 'ssbd' command-line option
>   arm64: ssbd: Add global mitigation state accessor
>   arm64: ssbd: Skip apply_ssbd if not using dynamic mitigation
>   arm64: ssbd: Restore mitigation status on CPU resume
>   arm64: ssbd: Introduce thread flag to control userspace mitigation
>   arm64: ssbd: Add prctl interface for per-thread mitigation
>   arm64: KVM: Add HYP per-cpu accessors
>   arm64: KVM: Add ARCH_WORKAROUND_2 support for guests
>   arm64: KVM: Handle guest's ARCH_WORKAROUND_2 requests
>   arm64: KVM: Add ARCH_WORKAROUND_2 discovery through
>     ARCH_FEATURES_FUNC_ID

I queued the 14 patches above for 4.18.

>   arm64: Add test_and_clear_flag and set_flag atomic assembler
>     primitives
>   arm64: ssbd: Enable delayed setting of TIF_SSBD
>   arm64: ssbd: Implement arch_seccomp_spec_mitigate

Thanks.

-- 
Catalin
