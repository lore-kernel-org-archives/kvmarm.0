From: Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [PATCH v5 02/30] arm64: fpsimd: Correctly annotate exception
 helpers called from asm
Date: Wed, 1 Nov 2017 11:42:55 +0000
Message-ID: <20171101114254.hqeakwpri53ga7p5@armageddon.cambridge.arm.com>
References: <1509465082-30427-1-git-send-email-Dave.Martin@arm.com>
 <1509465082-30427-3-git-send-email-Dave.Martin@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-arch-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1509465082-30427-3-git-send-email-Dave.Martin@arm.com>
Sender: linux-arch-owner@vger.kernel.org
To: Dave Martin <Dave.Martin@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-arch@vger.kernel.org, Okamoto Takayuki <tokamoto@jp.fujitsu.com>, libc-alpha@sourceware.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Szabolcs Nagy <szabolcs.nagy@arm.com>, Will Deacon <will.deacon@arm.com>, Alex =?iso-8859-1?Q?Benn=E9e?= <alex.bennee@linaro.org>, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On Tue, Oct 31, 2017 at 03:50:54PM +0000, Dave P Martin wrote:
> A couple of FPSIMD exception handling functions that are called
> from entry.S are currently not annotated as such.
> 
> This is not a big deal since asmlinkage does nothing on arm/arm64,
> but fixing the annotations is more consistent and may help avoid
> future surprises.
> 
> This patch adds appropriate asmlinkage annotations for
> do_fpsimd_acc() and do_fpsimd_exc().
> 
> Signed-off-by: Dave Martin <Dave.Martin@arm.com>

Acked-by: Catalin Marinas <catalin.marinas@arm.com>
