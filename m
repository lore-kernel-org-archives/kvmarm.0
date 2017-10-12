From: Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [PATCH v3 21/28] arm64/sve: Add sysctl to set the default vector
 length for new processes
Date: Thu, 12 Oct 2017 18:11:47 +0100
Message-ID: <20171012171147.zanodz2ffhluzopz@armageddon.cambridge.arm.com>
References: <1507660725-7986-1-git-send-email-Dave.Martin@arm.com>
 <1507660725-7986-22-git-send-email-Dave.Martin@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-arch-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1507660725-7986-22-git-send-email-Dave.Martin@arm.com>
Sender: linux-arch-owner@vger.kernel.org
To: Dave Martin <Dave.Martin@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-arch@vger.kernel.org, Okamoto Takayuki <tokamoto@jp.fujitsu.com>, libc-alpha@sourceware.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Szabolcs Nagy <szabolcs.nagy@arm.com>, Will Deacon <will.deacon@arm.com>, Richard Sandiford <richard.sandiford@arm.com>, Alex =?iso-8859-1?Q?Benn=E9e?= <alex.bennee@linaro.org>, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On Tue, Oct 10, 2017 at 07:38:38PM +0100, Dave P Martin wrote:
> Because of the effect of SVE on the size of the signal frame, the
> default vector length used for new processes involves a tradeoff
> between performance of SVE-enabled software on the one hand, and
> reliability of non-SVE-aware software on the other hand.
> 
> For this reason, the best choice depends on the repertoire of
> userspace software in use and is thus best left up to distro
> maintainers, sysadmins and developers.
> 
> If CONFIG_SYSCTL is enabled, this patch exposes the default vector
> length in /proc/sys/abi/sve_default_vector_length, where boot
> scripts or the adventurous can poke it.
> 
> In common with other arm64 ABI sysctls, this control is currently
> global: setting it requires CAP_SYS_ADMIN in the root user
> namespace, but the value set is effective for subsequent execs in
> all namespaces.  The control only affects _new_ processes, however:
> changing it does not affect the vector length of any existing
> process.
> 
> The intended usage model is that if userspace is known to be fully
> SVE-tolerant (or a developer is curious to find out) then init
> scripts can crank this up during startup.
> 
> Signed-off-by: Dave Martin <Dave.Martin@arm.com>
> Reviewed-by: Alex Bennée <alex.bennee@linaro.org>

Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
