From: Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [PATCH v3 14/28] arm64/sve: Backend logic for setting the vector
 length
Date: Wed, 11 Oct 2017 17:43:50 +0100
Message-ID: <20171011164350.gogtmi5l66xpz6t5@armageddon.cambridge.arm.com>
References: <1507660725-7986-1-git-send-email-Dave.Martin@arm.com>
 <1507660725-7986-15-git-send-email-Dave.Martin@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-arch-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1507660725-7986-15-git-send-email-Dave.Martin@arm.com>
Sender: linux-arch-owner@vger.kernel.org
To: Dave Martin <Dave.Martin@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-arch@vger.kernel.org, Okamoto Takayuki <tokamoto@jp.fujitsu.com>, libc-alpha@sourceware.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Szabolcs Nagy <szabolcs.nagy@arm.com>, Will Deacon <will.deacon@arm.com>, Richard Sandiford <richard.sandiford@arm.com>, Alex =?iso-8859-1?Q?Benn=E9e?= <alex.bennee@linaro.org>, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On Tue, Oct 10, 2017 at 07:38:31PM +0100, Dave P Martin wrote:
> This patch implements the core logic for changing a task's vector
> length on request from userspace.  This will be used by the ptrace
> and prctl frontends that are implemented in later patches.
> 
> The SVE architecture permits, but does not require, implementations
> to support vector lengths that are not a power of two.  To handle
> this, logic is added to check a requested vector length against a
> possibly sparse bitmap of available vector lengths at runtime, so
> that the best supported value can be chosen.
> 
> Signed-off-by: Dave Martin <Dave.Martin@arm.com>
> Cc: Alex Bennée <alex.bennee@linaro.org>

Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
