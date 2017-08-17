From: Dave Martin <Dave.Martin@arm.com>
Subject: Re: [PATCH 24/27] arm64/sve: Detect SVE and activate runtime support
Date: Thu, 17 Aug 2017 11:00:29 +0100
Message-ID: <20170817100028.GH6321@e103592.cambridge.arm.com>
References: <1502280338-23002-1-git-send-email-Dave.Martin@arm.com>
 <1502280338-23002-25-git-send-email-Dave.Martin@arm.com>
 <3389809f-52e9-5830-304b-21ce56fbcde2@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A7F8040FB0
 for <kvmarm@lists.cs.columbia.edu>; Thu, 17 Aug 2017 05:58:48 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 28Xs+Y7Mmh6V for <kvmarm@lists.cs.columbia.edu>;
 Thu, 17 Aug 2017 05:58:47 -0400 (EDT)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4D57F40FAE
 for <kvmarm@lists.cs.columbia.edu>; Thu, 17 Aug 2017 05:58:47 -0400 (EDT)
Content-Disposition: inline
In-Reply-To: <3389809f-52e9-5830-304b-21ce56fbcde2@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Suzuki K Poulose <Suzuki.Poulose@arm.com>
Cc: linux-arch@vger.kernel.org, libc-alpha@sourceware.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Szabolcs Nagy <szabolcs.nagy@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Richard Sandiford <richard.sandiford@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Wed, Aug 16, 2017 at 06:53:07PM +0100, Suzuki K Poulose wrote:
> On 09/08/17 13:05, Dave Martin wrote:
> >[This sender failed our fraud detection checks and may not be who they appear to be. Learn about spoofing at http://aka.ms/LearnAboutSpoofing]
> >
> >This patch enables detection of hardware SVE support via the
> >cpufeatures framework, and reports its presence to the kernel and
> >userspace via the new ARM64_SVE cpucap and HWCAP_SVE hwcap
> >respectively.
> >
> >Userspace can also detect SVE using ID_AA64PFR0_EL1, using the
> >cpufeatures MRS emulation.
> >
> >When running on hardware that supports SVE, this enables runtime
> >kernel support for SVE, and allows user tasks to execute SVE
> >instructions and make of the of the SVE-specific user/kernel
> >interface extensions implemented by this series.
> >
> >Signed-off-by: Dave Martin <Dave.Martin@arm.com>
> 
> 
> >---
> > arch/arm64/include/asm/cpucaps.h    |  3 ++-
> > arch/arm64/include/asm/cpufeature.h |  3 ++-
> > arch/arm64/include/uapi/asm/hwcap.h |  1 +
> > arch/arm64/kernel/cpufeature.c      | 16 ++++++++++++++++
> > arch/arm64/kernel/cpuinfo.c         |  1 +
> > 5 files changed, 22 insertions(+), 2 deletions(-)
> >
> 
> ...
> 
> >
> >@@ -944,6 +957,9 @@ static const struct arm64_cpu_capabilities arm64_elf_hwcaps[] = {
> >        HWCAP_CAP(SYS_ID_AA64ISAR1_EL1, ID_AA64ISAR1_JSCVT_SHIFT, FTR_UNSIGNED, 1, CAP_HWCAP, HWCAP_JSCVT),
> >        HWCAP_CAP(SYS_ID_AA64ISAR1_EL1, ID_AA64ISAR1_FCMA_SHIFT, FTR_UNSIGNED, 1, CAP_HWCAP, HWCAP_FCMA),
> >        HWCAP_CAP(SYS_ID_AA64ISAR1_EL1, ID_AA64ISAR1_LRCPC_SHIFT, FTR_UNSIGNED, 1, CAP_HWCAP, HWCAP_LRCPC),
> >+#ifdef CONFIG_ARM64_SVE
> >+       HWCAP_CAP(SYS_ID_AA64PFR0_EL1, ID_AA64PFR0_SVE_SHIFT, FTR_UNSIGNED, ID_AA64PFR0_SVE, CAP_HWCAP, HWCAP_SVE),
> >+#endif
> >        {},
> > };
> >
> >diff --git a/arch/arm64/kernel/cpuinfo.c b/arch/arm64/kernel/cpuinfo.c
> >index 0e087d7..943aad0 100644
> >--- a/arch/arm64/kernel/cpuinfo.c
> >+++ b/arch/arm64/kernel/cpuinfo.c
> >@@ -69,6 +69,7 @@ static const char *const hwcap_str[] = {
> >        "jscvt",
> >        "fcma",
> >        "lrcpc",
> >+       "sve",
> >        NULL
> > };
> >
> 
> 
> Dave,
> 
> Could you please update the Documentation for the exposed CPU feature
> registers to include the SVE field ? Rest looks good to me. With that
> change,

Oops, yes, I'll update that.  Rutland's hwcaps documentation will also
need an update.

> Reviewed-by: Suzuki K Poulose <suzuki.poulose@arm.com>

Thanks for the review
---Dave
