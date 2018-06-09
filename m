From: Jon Masters <jcm@jonmasters.org>
Subject: Re: [PATCH v2 00/17] arm64 SSBD (aka Spectre-v4) mitigation
Date: Sat, 9 Jun 2018 09:16:03 -0400
Message-ID: <3f90aca2-d693-5f3e-4f2b-51e9509af8fe@jonmasters.org>
References: <20180529121121.24927-1-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180529121121.24927-1-marc.zyngier@arm.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Marc Zyngier <marc.zyngier@arm.com>, linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Cc: Will Deacon <will.deacon@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Thomas Gleixner <tglx@linutronix.de>, Andy Lutomirski <luto@kernel.org>, Kees Cook <keescook@chromium.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Christoffer Dall <christoffer.dall@arm.com>, Randy Dunlap <rdunlap@infradead.org>, Dominik Brodowski <linux@dominikbrodowski.net>, Julien Grall <julien.grall@arm.com>, Mark Rutland <mark.rutland@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

On 05/29/2018 08:11 AM, Marc Zyngier wrote:

> This patch series implements the Linux kernel side of the "Spectre-v4"
> (CVE-2018-3639) mitigation known as "Speculative Store Bypass Disable"
> (SSBD).

Looks good, with the exception of the naming in patch 5, and a question
about how you're handling live migration of VMs (which needs to preserve
mitigation state). Once those are answered I think it's good.

> For all released Arm Cortex-A CPUs that are affected by this issue, then
> the preferred mitigation is simply to set a chicken bit in the firmware
> during CPU initialisation and therefore no change to Linux is required.
> Other CPUs may require the chicken bit to be toggled dynamically (for
> example, when switching between user-mode and kernel-mode) and this is
> achieved by calling into EL3 via an SMC which has been published as part
> of the latest SMCCC specification:

We're asking (server) silicon vendors that can do so inexpensively to
implement both a firmware knob to control the chicken bit and the ATF
interface. This allows some users to disable the mitigation if they want
to, for example in closed lab environments doing CONFIG_BENCHMARKING
comparisons to other arches which might have mitigations disabled. Not
that I like that, but I want Arm to be on an equal footing at least ;)

Jon.
