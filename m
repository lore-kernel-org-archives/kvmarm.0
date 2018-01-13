From: Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>
Subject: Re: [PATCH v6 11/16] firmware: arm_sdei: Add support for CPU and
 system power states
Date: Sat, 13 Jan 2018 12:00:31 +0000
Message-ID: <20180113120031.5m6eykwzqnioyb33@armageddon.cambridge.arm.com>
References: <20180108153818.22743-1-james.morse@arm.com>
 <20180108153818.22743-12-james.morse@arm.com>
 <20180108172226.GC2530@red-moon>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20180108172226.GC2530@red-moon>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Lorenzo Pieralisi <lorenzo.pieralisi-5wv7dgnIgG8@public.gmane.org>
Cc: James Morse <james.morse-5wv7dgnIgG8@public.gmane.org>, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Marc Zyngier <marc.zyngier-5wv7dgnIgG8@public.gmane.org>, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, Rob Herring <robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Christoffer Dall <christoffer.dall-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Heyi Guo <guoheyi-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, kvmarm-FPEHb7Xf0XXUo1n7N8X6UoWGPAHP3yOg@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, Loc Ho <lho-qTEPVZfXA3Y@public.gmane.org>
List-Id: kvmarm@lists.cs.columbia.edu

On Mon, Jan 08, 2018 at 05:22:26PM +0000, Lorenzo Pieralisi wrote:
> On Mon, Jan 08, 2018 at 03:38:13PM +0000, James Morse wrote:
> 
> [...]
> 
> > +/* When entering idle, mask/unmask events for this cpu */
> 
> Just mentioning (since I know you know), this notifier is called also
> through syscore_ops so it is not just idle (CPUidle or Suspend-to-idle).
> 
> > +static int sdei_pm_notifier(struct notifier_block *nb, unsigned long action,
> > +			    void *data)
> > +{
> > +	int rv;
> > +
> > +	switch (action) {
> > +	case CPU_PM_ENTER:
> > +		rv = sdei_mask_local_cpu();
> > +		break;
> > +	case CPU_PM_EXIT:
> > +		rv = sdei_unmask_local_cpu();
> 
> You should handle CPU_PM_ENTER_FAILED here for correctness,
> in case the notifier chain fails.

So, just to confirm, the CPU_PM_ENTER_FAILED case goes together with
CPU_PM_EXIT so that we unmask the SDE again for the CPU.

-- 
Catalin
--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
