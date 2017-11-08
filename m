From: James Morse <james.morse-5wv7dgnIgG8@public.gmane.org>
Subject: Re: [PATCH 15/13] firmware: arm_sdei: move the frozen flag under
 the spinlock
Date: Wed, 08 Nov 2017 15:11:26 +0000
Message-ID: <5A031E9E.2090809@arm.com>
References: <20171017174432.1684-1-james.morse@arm.com> <20171101155941.19432-1-james.morse@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171101155941.19432-1-james.morse-5wv7dgnIgG8@public.gmane.org>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org
Cc: devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Lorenzo Pieralisi <lorenzo.pieralisi-5wv7dgnIgG8@public.gmane.org>, Marc Zyngier <marc.zyngier-5wv7dgnIgG8@public.gmane.org>, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, Rob Herring <robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Loc Ho <lho-qTEPVZfXA3Y@public.gmane.org>, kvmarm-FPEHb7Xf0XXUo1n7N8X6UoWGPAHP3yOg@public.gmane.org, James Morse <james.morse-5wv7dgnIgG8@public.gmane.org>
List-Id: kvmarm@lists.cs.columbia.edu

On 01/11/17 15:59, James Morse wrote:
> dpm_suspend() calls the freeze/thaw callbacks for hibernate before
> disable_non_bootcpus() takes down secondaries.
> 
> This leads to a fun race where the freeze/thaw callbacks reset the
> SDEI interface (as we may be restoring a kernel with a different
> layout due to KASLR), then the cpu-hotplug callbacks come in to
> save the current state, which has already been reset.
> 
> We solve this with a 'frozen' flag that stops the hotplug callback
> from overwriting the saved values.
> 
> This patch moves the flag under the 'events' spinlock we take
> in the hotplug callbacks, to avoid depending on cpu-hotplug's
> mechanics to ensure the callback sees the correct value.

Scratch this. All this has really done is moved the race around. Will had a much
better suggestion that makes it look like all the CPUs are down. That makes
hotplug and power-management behave the same.


Thanks,

James
--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
