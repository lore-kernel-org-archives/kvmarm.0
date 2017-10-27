From: Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [PATCH v4 25/28] arm64/sve: Detect SVE and activate runtime
 support
Date: Fri, 27 Oct 2017 14:05:04 +0100
Message-ID: <20171027130504.l34y2u6l2e2rxlac@armageddon.cambridge.arm.com>
References: <1509101470-7881-1-git-send-email-Dave.Martin@arm.com>
 <1509101470-7881-26-git-send-email-Dave.Martin@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-arch-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1509101470-7881-26-git-send-email-Dave.Martin@arm.com>
Sender: linux-arch-owner@vger.kernel.org
To: Dave Martin <Dave.Martin@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-arch@vger.kernel.org, Okamoto Takayuki <tokamoto@jp.fujitsu.com>, libc-alpha@sourceware.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Szabolcs Nagy <szabolcs.nagy@arm.com>, Will Deacon <will.deacon@arm.com>, Alex =?iso-8859-1?Q?Benn=E9e?= <alex.bennee@linaro.org>, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On Fri, Oct 27, 2017 at 11:51:07AM +0100, Dave P Martin wrote:
> This patch enables detection of hardware SVE support via the
> cpufeatures framework, and reports its presence to the kernel and
> userspace via the new ARM64_SVE cpucap and HWCAP_SVE hwcap
> respectively.
> 
> Userspace can also detect SVE using ID_AA64PFR0_EL1, using the
> cpufeatures MRS emulation.
> 
> When running on hardware that supports SVE, this enables runtime
> kernel support for SVE, and allows user tasks to execute SVE
> instructions and make of the of the SVE-specific user/kernel
> interface extensions implemented by this series.
> 
> Signed-off-by: Dave Martin <Dave.Martin@arm.com>
> Reviewed-by: Suzuki K Poulose <suzuki.poulose@arm.com>
> Cc: Catalin Marinas <catalin.marinas@arm.com>

Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
