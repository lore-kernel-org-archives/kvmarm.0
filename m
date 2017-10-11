From: Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [PATCH v3 04/28] arm64: Port deprecated instruction emulation to
 new sysctl interface
Date: Wed, 11 Oct 2017 15:17:57 +0100
Message-ID: <20171011141757.idn45rmsvvwot7by@armageddon.cambridge.arm.com>
References: <1507660725-7986-1-git-send-email-Dave.Martin@arm.com>
 <1507660725-7986-5-git-send-email-Dave.Martin@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-arch-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1507660725-7986-5-git-send-email-Dave.Martin@arm.com>
Sender: linux-arch-owner@vger.kernel.org
To: Dave Martin <Dave.Martin@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-arch@vger.kernel.org, Okamoto Takayuki <tokamoto@jp.fujitsu.com>, libc-alpha@sourceware.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Szabolcs Nagy <szabolcs.nagy@arm.com>, Will Deacon <will.deacon@arm.com>, Richard Sandiford <richard.sandiford@arm.com>, Alex =?iso-8859-1?Q?Benn=E9e?= <alex.bennee@linaro.org>, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On Tue, Oct 10, 2017 at 07:38:21PM +0100, Dave P Martin wrote:
> Currently, armv8_deprected.c takes charge of the "abi" sysctl
> directory, which makes life difficult for other code that wants to
> register sysctls in the same directory.
> 
> There is a "new" [1] sysctl registration interface that removes the
> need to define ctl_tables for parent directories explicitly, which
> is ideal here.
> 
> This patch ports register_insn_emulation_sysctl() over to the
> register_sysctl() interface and removes the redundant ctl_table for
> "abi".
> 
> Signed-off-by: Dave Martin <Dave.Martin@arm.com>
> Reviewed-by: Alex Bennée <alex.bennee@linaro.org>
> 
> [1] fea478d4101a (sysctl: Add register_sysctl for normal sysctl
> users)
> The commit message notes an intent to port users of the
> pre-existing interfaces over to register_sysctl(), though the
> number of users of the new interface currently appears negligible.
> ---
>  arch/arm64/kernel/armv8_deprecated.c | 15 +++------------
>  1 file changed, 3 insertions(+), 12 deletions(-)

Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
