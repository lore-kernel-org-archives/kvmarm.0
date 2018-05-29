From: Suzuki K Poulose <Suzuki.Poulose@arm.com>
Subject: Re: [PATCH v2 04/17] arm64: Add ARCH_WORKAROUND_2 probing
Date: Tue, 29 May 2018 14:39:04 +0100
Message-ID: <4461a4e7-e620-aec6-0f58-674080418e80@arm.com>
References: <20180529121121.24927-1-marc.zyngier@arm.com>
 <20180529121121.24927-5-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180529121121.24927-5-marc.zyngier@arm.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Marc Zyngier <marc.zyngier@arm.com>, linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Cc: Will Deacon <will.deacon@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Thomas Gleixner <tglx@linutronix.de>, Andy Lutomirski <luto@kernel.org>, Kees Cook <keescook@chromium.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Christoffer Dall <christoffer.dall@arm.com>, Randy Dunlap <rdunlap@infradead.org>, Dominik Brodowski <linux@dominikbrodowski.net>, Julien Grall <julien.grall@arm.com>, Mark Rutland <mark.rutland@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

On 29/05/18 13:11, Marc Zyngier wrote:
> As for Spectre variant-2, we rely on SMCCC 1.1 to provide the
> discovery mechanism for detecting the SSBD mitigation.
> 
> A new capability is also allocated for that purpose, and a
> config option.
> 
> Reviewed-by: Julien Grall <julien.grall@arm.com>
> Reviewed-by: Mark Rutland <mark.rutland@arm.com>
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>


Reviewed-by: Suzuki K Poulose <suzuki.poulose@arm.com>
