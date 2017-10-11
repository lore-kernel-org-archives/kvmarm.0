From: Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [PATCH v3 15/28] arm64: cpufeature: Move sys_caps_initialised
 declarations
Date: Wed, 11 Oct 2017 17:50:37 +0100
Message-ID: <20171011165036.n4gl4k753zafgpbx@armageddon.cambridge.arm.com>
References: <1507660725-7986-1-git-send-email-Dave.Martin@arm.com>
 <1507660725-7986-16-git-send-email-Dave.Martin@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-arch-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1507660725-7986-16-git-send-email-Dave.Martin@arm.com>
Sender: linux-arch-owner@vger.kernel.org
To: Dave Martin <Dave.Martin@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-arch@vger.kernel.org, Okamoto Takayuki <tokamoto@jp.fujitsu.com>, libc-alpha@sourceware.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Szabolcs Nagy <szabolcs.nagy@arm.com>, Will Deacon <will.deacon@arm.com>, Richard Sandiford <richard.sandiford@arm.com>, Alex =?iso-8859-1?Q?Benn=E9e?= <alex.bennee@linaro.org>, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On Tue, Oct 10, 2017 at 07:38:32PM +0100, Dave P Martin wrote:
> update_cpu_features() currently cannot tell whether it is being
> called during early or late secondary boot.  This doesn't
> desperately matter for anything it currently does.
> 
> However, SVE will need to know here whether the set of available
> vector lengths is fixed of still to be determined when booting a
> CPU so that it can be updated appropriately.
> 
> This patch simply moves the sys_caps_initialised stuff to the top
> of the file so that it can be more widely.  There doesn't seem to
> be a more obvious place to put it.
> 
> Signed-off-by: Dave Martin <Dave.Martin@arm.com>
> Reviewed-by: Alex Bennée <alex.bennee@linaro.org>
> Reviewed-by: Suzuki K Poulose <suzuki.poulose@arm.com>

Acked-by: Catalin Marinas <catalin.marinas@arm.com>
