From: Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [PATCH v3 10/28] arm64/sve: Low-level CPU setup
Date: Wed, 11 Oct 2017 15:30:42 +0100
Message-ID: <20171011143042.xt3jnbmva2gudo4w@armageddon.cambridge.arm.com>
References: <1507660725-7986-1-git-send-email-Dave.Martin@arm.com>
 <1507660725-7986-11-git-send-email-Dave.Martin@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-arch-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1507660725-7986-11-git-send-email-Dave.Martin@arm.com>
Sender: linux-arch-owner@vger.kernel.org
To: Dave Martin <Dave.Martin@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-arch@vger.kernel.org, Okamoto Takayuki <tokamoto@jp.fujitsu.com>, libc-alpha@sourceware.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Szabolcs Nagy <szabolcs.nagy@arm.com>, Will Deacon <will.deacon@arm.com>, Richard Sandiford <richard.sandiford@arm.com>, Alex =?iso-8859-1?Q?Benn=E9e?= <alex.bennee@linaro.org>, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On Tue, Oct 10, 2017 at 07:38:27PM +0100, Dave P Martin wrote:
> To enable the kernel to use SVE, SVE traps from EL1 to EL2 must be
> disabled.  To take maximum advantage of the hardware, the full
> available vector length also needs to be enabled for EL1 by
> programming ZCR_EL2.LEN.  (The kernel will program ZCR_EL1.LEN as
> required, but this cannot override the limit set by ZCR_EL2.)
> 
> Traps from EL0 to EL1 are also left enabled by virtue of setting
> the relevant CPACR bit at its default (RES0) value.
> 
> This patch makes the appropriate changes to the primary and
> secondary CPU initialisation code.
> 
> Signed-off-by: Dave Martin <Dave.Martin@arm.com>
> Cc: Catalin Marinas <catalin.marinas@arm.com>
> Cc: Alex Bennée <alex.bennee@linaro.org>

Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
