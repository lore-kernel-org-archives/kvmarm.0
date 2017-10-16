From: Dave Martin <Dave.Martin@arm.com>
Subject: Re: [PATCH v3 16/28] arm64/sve: Probe SVE capabilities and usable
 vector lengths
Date: Mon, 16 Oct 2017 17:44:07 +0100
Message-ID: <20171016164407.GS19485@e103592.cambridge.arm.com>
References: <1507660725-7986-1-git-send-email-Dave.Martin@arm.com>
 <1507660725-7986-17-git-send-email-Dave.Martin@arm.com>
 <a39354fb-9f21-47ff-2ad9-b5bcb04e9990@arm.com>
 <20171016154557.GR19485@e103592.cambridge.arm.com>
 <812b6d11-2458-6d5d-c490-3421f7d3afb3@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <libc-alpha-return-85885-glibc-alpha=m.gmane.org@sourceware.org>
List-Unsubscribe: <mailto:libc-alpha-unsubscribe-glibc-alpha=m.gmane.org@sourceware.org>
List-Subscribe: <mailto:libc-alpha-subscribe@sourceware.org>
List-Archive: <http://sourceware.org/ml/libc-alpha/>
List-Post: <mailto:libc-alpha@sourceware.org>
List-Help: <mailto:libc-alpha-help@sourceware.org>, <http://sourceware.org/ml/#faqs>
Sender: libc-alpha-owner@sourceware.org
Content-Disposition: inline
In-Reply-To: <812b6d11-2458-6d5d-c490-3421f7d3afb3@arm.com>
To: Suzuki K Poulose <Suzuki.Poulose@arm.com>
Cc: linux-arch@vger.kernel.org, Okamoto Takayuki <tokamoto@jp.fujitsu.com>, libc-alpha@sourceware.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Szabolcs Nagy <szabolcs.nagy@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Richard Sandiford <richard.sandiford@arm.com>, Alex =?iso-8859-1?Q?Benn=E9e?= <alex.bennee@linaro.org>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Mon, Oct 16, 2017 at 05:27:59PM +0100, Suzuki K Poulose wrote:
> On 16/10/17 16:46, Dave Martin wrote:
> >On Thu, Oct 12, 2017 at 01:56:51PM +0100, Suzuki K Poulose wrote:
> >>On 10/10/17 19:38, Dave Martin wrote:

[...]

> >>>@@ -670,6 +689,14 @@ void update_cpu_features(int cpu,
> >>>  					info->reg_mvfr2, boot->reg_mvfr2);
> >>>  	}
> >>>+	if (id_aa64pfr0_sve(info->reg_id_aa64pfr0)) {
> >>>+		taint |= check_update_ftr_reg(SYS_ZCR_EL1, cpu,
> >>>+					info->reg_zcr, boot->reg_zcr);
> >>>+
> >>>+		if (!sys_caps_initialised)
> >>>+			sve_update_vq_map();
> >>>+	}
> >>
> >>nit: I am not sure if we should also check if the "current" sanitised value
> >>of the id_aa64pfr0 also supports sve and skip the update if it isn't. The code
> >>is as such fine without the check, its just that we can avoid computing the
> >>map. It is in the CPU boot up path and hence is not performance critical.
> >>So, either way we are fine.
> >>
> >>Reviewed-by: Suzuki K Poulose <suzuki.poulose@arm.com>
> >
> >I think I prefer to avoid adding extra code to optimise the "broken SoC
> >design" case.
> >
> 
> Sure.
> 
> >Maybe we could revisit this later if needed.
> >
> >Can you suggest some code?  Maybe the check is simpler than I think.
> 
> Something like :
> 
> if (id_aa64pfr0_sve(read_sanitised_ftr_reg(SYS_IDAA64PFR0)) &&
>     id_aa64pfr0_sve(id_aa64pfr0)) {
>     ...
> }
> 
> should be enough.
> 
> Or even we could hack it to :
> 
> if (id_aa64pfr0_sve(id_aa64pfr0 | read_sanitised_ftr_reg(SYS_IDAA64PFR0)))
> 
> As I mentioned, the code as such is fine. Its just that we try to detect
> if the SVE is already moot and skip the steps for this CPU.

How about the following, keeping the outer
if(id_aa64pfr0_sve(int->reg_id_aa64pfr0)) from my current code:

-		if (!sys_caps_initialised)
+		/* Probe vector lengths, unless we already gave up on SVE */
+		if (id_aa64pfr0_sve(read_sanitised_ftr_reg(ID_AA64PFR0_SVE)) &&
+		    !sys_caps_initialised)
			sve_update_vq_map();

Cheers
---Dave
