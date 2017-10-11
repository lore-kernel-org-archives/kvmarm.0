From: Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [PATCH v3 05/28] arm64: fpsimd: Simplify uses of {set,
 clear}_ti_thread_flag()
Date: Wed, 11 Oct 2017 15:19:05 +0100
Message-ID: <20171011141904.n7mi6rwmmprvcg27@armageddon.cambridge.arm.com>
References: <1507660725-7986-1-git-send-email-Dave.Martin@arm.com>
 <1507660725-7986-6-git-send-email-Dave.Martin@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-arch-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1507660725-7986-6-git-send-email-Dave.Martin@arm.com>
Sender: linux-arch-owner@vger.kernel.org
To: Dave Martin <Dave.Martin@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-arch@vger.kernel.org, Okamoto Takayuki <tokamoto@jp.fujitsu.com>, libc-alpha@sourceware.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Szabolcs Nagy <szabolcs.nagy@arm.com>, Will Deacon <will.deacon@arm.com>, Richard Sandiford <richard.sandiford@arm.com>, Alex =?iso-8859-1?Q?Benn=E9e?= <alex.bennee@linaro.org>, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On Tue, Oct 10, 2017 at 07:38:22PM +0100, Dave P Martin wrote:
> The existing FPSIMD context switch code contains a couple of
> instances of {set,clear}_ti_thread(task_thread_info(task)).  Since
> there are thread flag manipulators that operate directly on
> task_struct, this verbosity isn't strictly needed.
> 
> For consistency, this patch simplifies the affected calls.  This
> should have no impact on behaviour.
> 
> Signed-off-by: Dave Martin <Dave.Martin@arm.com>
> Reviewed-by: Alex Bennée <alex.bennee@linaro.org>
> Acked-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>

Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
