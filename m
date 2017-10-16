From: Dave Martin <Dave.Martin@arm.com>
Subject: Re: [PATCH v3 16/28] arm64/sve: Probe SVE capabilities and usable
 vector lengths
Date: Mon, 16 Oct 2017 16:46:00 +0100
Message-ID: <20171016154557.GR19485@e103592.cambridge.arm.com>
References: <1507660725-7986-1-git-send-email-Dave.Martin@arm.com>
 <1507660725-7986-17-git-send-email-Dave.Martin@arm.com>
 <a39354fb-9f21-47ff-2ad9-b5bcb04e9990@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <libc-alpha-return-85879-glibc-alpha=m.gmane.org@sourceware.org>
List-Unsubscribe: <mailto:libc-alpha-unsubscribe-glibc-alpha=m.gmane.org@sourceware.org>
List-Subscribe: <mailto:libc-alpha-subscribe@sourceware.org>
List-Archive: <http://sourceware.org/ml/libc-alpha/>
List-Post: <mailto:libc-alpha@sourceware.org>
List-Help: <mailto:libc-alpha-help@sourceware.org>, <http://sourceware.org/ml/#faqs>
Sender: libc-alpha-owner@sourceware.org
Content-Disposition: inline
In-Reply-To: <a39354fb-9f21-47ff-2ad9-b5bcb04e9990@arm.com>
To: Suzuki K Poulose <Suzuki.Poulose@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-arch@vger.kernel.org, Okamoto Takayuki <tokamoto@jp.fujitsu.com>, libc-alpha@sourceware.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Szabolcs Nagy <szabolcs.nagy@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Richard Sandiford <richard.sandiford@arm.com>, Alex =?iso-8859-1?Q?Benn=E9e?= <alex.bennee@linaro.org>, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On Thu, Oct 12, 2017 at 01:56:51PM +0100, Suzuki K Poulose wrote:
> On 10/10/17 19:38, Dave Martin wrote:
> >This patch uses the cpufeatures framework to determine common SVE
> >capabilities and vector lengths, and configures the runtime SVE
> >support code appropriately.
> >
> >ZCR_ELx is not really a feature register, but it is convenient to
> >use it as a template for recording the maximum vector length
> >supported by a CPU, using the LEN field.  This field is similar to
> >a feature field in that it is a contiguous bitfield for which we
> >want to determine the minimum system-wide value.  This patch adds
> >ZCR as a pseudo-register in cpuinfo/cpufeatures, with appropriate
> >custom code to populate it.  Finding the minimum supported value of
> >the LEN field is left to the cpufeatures framework in the usual
> >way.
> >
> >The meaning of ID_AA64ZFR0_EL1 is not architecturally defined yet,
> >so for now we just require it to be zero.
> >
> >Note that much of this code is dormant and SVE still won't be used
> >yet, since system_supports_sve() remains hardwired to false.
> >
> >Signed-off-by: Dave Martin <Dave.Martin@arm.com>
> >Cc: Alex Bennée <alex.bennee@linaro.org>
> >Cc: Suzuki K Poulose <Suzuki.Poulose@arm.com>
> >
> >---
> >
> >Dropped Alex Bennée's Reviewed-by, since there is new logic in this
> >patch.
> >
> >Changes since v2
> >----------------
> >
> >Bug fixes:
> >
> >  * Got rid of dynamic allocation of the shadow vector length map during
> >    secondary boot.  Secondary CPU boot takes place in atomic context,
> >    and relying on GFP_ATOMIC here doesn't seem justified.
> >
> >    Instead, the needed additional bitmap is allocated statically.  Only
> >    one shadow map is needed, because CPUs don't boot concurrently.
> >
> >Requested by Alex Bennée:
> >
> >  * Reflowed untidy comment above read_zcr_features()
> >
> >  * Added comments to read_zcr_features() to explain what it's trying to do
> >    (which is otherwise not readily apparent).
> >
> >Requested by Catalin Marinas:
> >
> >  * Moved disabling of the EL1 SVE trap to the cpufeatures C code.
> >    This allows addition of new assembler in __cpu_setup to be
> >    avoided.
> >
> >Miscellaneous:
> >
> >  * Added comments explaining the intent, purpose and basic constraints
> >    for fpsimd.c helpers.
> 
> ...
> 
> >diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
> >index 92a9502..c5acf38 100644
> >--- a/arch/arm64/kernel/cpufeature.c
> >+++ b/arch/arm64/kernel/cpufeature.c
> 
> ...
> 
> >@@ -670,6 +689,14 @@ void update_cpu_features(int cpu,
> >  					info->reg_mvfr2, boot->reg_mvfr2);
> >  	}
> >+	if (id_aa64pfr0_sve(info->reg_id_aa64pfr0)) {
> >+		taint |= check_update_ftr_reg(SYS_ZCR_EL1, cpu,
> >+					info->reg_zcr, boot->reg_zcr);
> >+
> >+		if (!sys_caps_initialised)
> >+			sve_update_vq_map();
> >+	}
> 
> nit: I am not sure if we should also check if the "current" sanitised value
> of the id_aa64pfr0 also supports sve and skip the update if it isn't. The code
> is as such fine without the check, its just that we can avoid computing the
> map. It is in the CPU boot up path and hence is not performance critical.
> So, either way we are fine.
> 
> Reviewed-by: Suzuki K Poulose <suzuki.poulose@arm.com>

I think I prefer to avoid adding extra code to optimise the "broken SoC
design" case.

Maybe we could revisit this later if needed.

Can you suggest some code?  Maybe the check is simpler than I think.
