From: Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [PATCH v3 23/28] arm64/sve: KVM: Treat guest SVE use as
 undefined instruction execution
Date: Thu, 12 Oct 2017 18:13:16 +0100
Message-ID: <20171012171315.47d3bd5sq76eoqmd@armageddon.cambridge.arm.com>
References: <1507660725-7986-1-git-send-email-Dave.Martin@arm.com>
 <1507660725-7986-24-git-send-email-Dave.Martin@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-arch-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1507660725-7986-24-git-send-email-Dave.Martin@arm.com>
Sender: linux-arch-owner@vger.kernel.org
To: Dave Martin <Dave.Martin@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-arch@vger.kernel.org, Okamoto Takayuki <tokamoto@jp.fujitsu.com>, libc-alpha@sourceware.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Szabolcs Nagy <szabolcs.nagy@arm.com>, Will Deacon <will.deacon@arm.com>, Richard Sandiford <richard.sandiford@arm.com>, Alex =?iso-8859-1?Q?Benn=E9e?= <alex.bennee@linaro.org>, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On Tue, Oct 10, 2017 at 07:38:40PM +0100, Dave P Martin wrote:
> When trapping forbidden attempts by a guest to use SVE, we want the
> guest to see a trap consistent with SVE not being implemented.
> 
> This patch injects an undefined instruction exception into the
> guest in response to such an exception.
> 
> Signed-off-by: Dave Martin <Dave.Martin@arm.com>
> Reviewed-by: Alex Bennée <alex.bennee@linaro.org>

Acked-by: Catalin Marinas <catalin.marinas@arm.com>
