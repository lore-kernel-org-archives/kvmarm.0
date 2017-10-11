From: Suzuki K Poulose <Suzuki.Poulose@arm.com>
Subject: Re: [PATCH v3 25/28] arm64/sve: Detect SVE and activate runtime
 support
Date: Wed, 11 Oct 2017 18:11:48 +0100
Message-ID: <54bcf388-ee66-c3f3-8eca-d6553a7f2c54@arm.com>
References: <1507660725-7986-1-git-send-email-Dave.Martin@arm.com>
 <1507660725-7986-26-git-send-email-Dave.Martin@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-arch-owner@vger.kernel.org>
In-Reply-To: <1507660725-7986-26-git-send-email-Dave.Martin@arm.com>
Content-Language: en-US
Sender: linux-arch-owner@vger.kernel.org
To: Dave Martin <Dave.Martin@arm.com>, linux-arm-kernel@lists.infradead.org
Cc: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, =?UTF-8?Q?Alex_Benn=c3=a9e?= <alex.bennee@linaro.org>, Szabolcs Nagy <szabolcs.nagy@arm.com>, Richard Sandiford <richard.sandiford@arm.com>, Okamoto Takayuki <tokamoto@jp.fujitsu.com>, kvmarm@lists.cs.columbia.edu, libc-alpha@sourceware.org, linux-arch@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

On 10/10/17 19:38, Dave Martin wrote:
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
> Cc: Suzuki K Poulose <suzuki.poulose@arm.com>

Looks good to me.

Reviewed-by: Suzuki K Poulose <suzuki.poulose@arm.com>
