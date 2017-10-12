From: Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [PATCH v3 25/28] arm64/sve: Detect SVE and activate runtime
 support
Date: Thu, 12 Oct 2017 18:14:37 +0100
Message-ID: <20171012171436.m7l5jlvjnmdndpl7@armageddon.cambridge.arm.com>
References: <1507660725-7986-1-git-send-email-Dave.Martin@arm.com>
 <1507660725-7986-26-git-send-email-Dave.Martin@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6CD4649D33
 for <kvmarm@lists.cs.columbia.edu>; Thu, 12 Oct 2017 13:13:58 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id wNLvZSEJVhXu for <kvmarm@lists.cs.columbia.edu>;
 Thu, 12 Oct 2017 13:13:57 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 576EB406BB
 for <kvmarm@lists.cs.columbia.edu>; Thu, 12 Oct 2017 13:13:57 -0400 (EDT)
Content-Disposition: inline
In-Reply-To: <1507660725-7986-26-git-send-email-Dave.Martin@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Dave Martin <Dave.Martin@arm.com>
Cc: linux-arch@vger.kernel.org, Okamoto Takayuki <tokamoto@jp.fujitsu.com>, libc-alpha@sourceware.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Szabolcs Nagy <szabolcs.nagy@arm.com>, Richard Sandiford <richard.sandiford@arm.com>, Will Deacon <will.deacon@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Tue, Oct 10, 2017 at 07:38:42PM +0100, Dave P Martin wrote:
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

Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
