From: Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>
Subject: Re: [PATCH v3 10/13] firmware: arm_sdei: Add support for CPU and
 system power states
Date: Mon, 16 Oct 2017 14:52:05 +0100
Message-ID: <20171016135204.ncz6fzw5gh3gv57c@armageddon.cambridge.arm.com>
References: <20170922182614.27885-1-james.morse@arm.com>
 <20170922182614.27885-11-james.morse@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170922182614.27885-11-james.morse-5wv7dgnIgG8@public.gmane.org>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: James Morse <james.morse-5wv7dgnIgG8@public.gmane.org>
Cc: linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Lorenzo Pieralisi <lorenzo.pieralisi-5wv7dgnIgG8@public.gmane.org>, Marc Zyngier <marc.zyngier-5wv7dgnIgG8@public.gmane.org>, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, Rob Herring <robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Loc Ho <lho-qTEPVZfXA3Y@public.gmane.org>, kvmarm-FPEHb7Xf0XXUo1n7N8X6UoWGPAHP3yOg@public.gmane.org, Christoffer Dall <christoffer.dall-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: kvmarm@lists.cs.columbia.edu

On Fri, Sep 22, 2017 at 07:26:11PM +0100, James Morse wrote:
> diff --git a/include/linux/cpuhotplug.h b/include/linux/cpuhotplug.h
> index f24bfb2b9a2d..466b949474df 100644
> --- a/include/linux/cpuhotplug.h
> +++ b/include/linux/cpuhotplug.h
> @@ -88,6 +88,7 @@ enum cpuhp_state {
>  	CPUHP_AP_PERF_XTENSA_STARTING,
>  	CPUHP_AP_PERF_METAG_STARTING,
>  	CPUHP_AP_MIPS_OP_LOONGSON3_STARTING,
> +	CPUHP_AP_SDEI_STARTING,

Nitpick: how generic is this as to apply to other architectures?
Probably not, so shall we prefix this with ARM_?

Not actually a strong preferences but similar question for the
definitions in the sdei.h files (and maybe the filenames themselves).

-- 
Catalin
--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
