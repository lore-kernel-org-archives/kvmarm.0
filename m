From: Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>
Subject: Re: [PATCH v4 10/13] firmware: arm_sdei: Add support for CPU and
 system power states
Date: Wed, 18 Oct 2017 12:11:23 +0100
Message-ID: <20171018111122.oawkbq7ncstrhhfm@armageddon.cambridge.arm.com>
References: <20171017174432.1684-1-james.morse@arm.com>
 <20171017174432.1684-11-james.morse@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20171017174432.1684-11-james.morse-5wv7dgnIgG8@public.gmane.org>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: James Morse <james.morse-5wv7dgnIgG8@public.gmane.org>
Cc: linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Lorenzo Pieralisi <lorenzo.pieralisi-5wv7dgnIgG8@public.gmane.org>, Marc Zyngier <marc.zyngier-5wv7dgnIgG8@public.gmane.org>, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, Rob Herring <robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Loc Ho <lho-qTEPVZfXA3Y@public.gmane.org>, kvmarm-FPEHb7Xf0XXUo1n7N8X6UoWGPAHP3yOg@public.gmane.org, Christoffer Dall <christoffer.dall-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: kvmarm@lists.cs.columbia.edu

On Tue, Oct 17, 2017 at 06:44:29PM +0100, James Morse wrote:
> When a CPU enters an idle lower-power state or is powering off, we
> need to mask SDE events so that no events can be delivered while we
> are messing with the MMU as the registered entry points won't be valid.
> 
> If the system reboots, we want to unregister all events and mask the CPUs.
> For kexec this allows us to hand a clean slate to the next kernel
> instead of relying on it to call sdei_{private,system}_data_reset().
> 
> For hibernate we unregister all events and re-register them on restore,
> in case we restored with the SDE code loaded at a different address.
> (e.g. KASLR).
> 
> Add all the notifiers necessary to do this. We only support shared events
> so all events are left registered and enabled over CPU hotplug.
> 
> Signed-off-by: James Morse <james.morse-5wv7dgnIgG8@public.gmane.org>

Acked-by: Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>
--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
