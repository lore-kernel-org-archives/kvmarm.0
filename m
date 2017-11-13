From: Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>
Subject: Re: [PATCH v4 15/13] firmware: arm_sdei: be more robust against
 cpu-hotplug
Date: Mon, 13 Nov 2017 11:01:10 +0000
Message-ID: <20171113110109.GB8968@arm.com>
References: <5A031E9E.2090809@arm.com>
 <20171108160624.10355-1-james.morse@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20171108160624.10355-1-james.morse-5wv7dgnIgG8@public.gmane.org>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: James Morse <james.morse-5wv7dgnIgG8@public.gmane.org>
Cc: linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, kvmarm-FPEHb7Xf0XXUo1n7N8X6UoWGPAHP3yOg@public.gmane.org, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, Rob Herring <robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Marc Zyngier <marc.zyngier-5wv7dgnIgG8@public.gmane.org>, Christoffer Dall <christoffer.dall-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Lorenzo Pieralisi <lorenzo.pieralisi-5wv7dgnIgG8@public.gmane.org>, Loc Ho <lho-qTEPVZfXA3Y@public.gmane.org>
List-Id: kvmarm@lists.cs.columbia.edu

On Wed, Nov 08, 2017 at 04:06:24PM +0000, James Morse wrote:
> dpm_suspend() calls the freeze/thaw callbacks for hibernate before
> disable_non_bootcpus() takes down secondaries.
> 
> This leads to a fun race where the freeze/thaw callbacks reset the
> SDEI interface (as we may be restoring a kernel with a different
> layout due to KASLR), then the cpu-hotplug callbacks come in to
> save the current state, which has already been reset.
> 
> I tried to solve this with a 'frozen' flag that stops the hotplug
> callback from overwriting the saved values. Instead this just
> moves the race around and makes it even harder to think about.
> 
> Instead, make it look like the secondaries have gone offline.
> Call cpuhp_remove_state() in the freeze callback, this will call the
> teardown hook on all online CPUs, then remove the state. This saves
> all private events and makes future CPU up/down events invisible.
> 
> Change sdei_event_unregister_all()/sdei_reregister_events() to
> only save/restore shared events, which are all that is left. With
> this we can remove the frozen flag. We can remove the device
> suspend/resume calls too as cpuhotplug's teardown call has masked
> the CPUs.
> 
> All that is left is the reboot notifier, (which was abusing the
> frozen flag). Call cpuhp_remove_state() to make it look like
> secondary CPUs have gone offline.
> 
> Suggested-by: Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>
> Signed-off-by: James Morse <james.morse-5wv7dgnIgG8@public.gmane.org>
> ---
>  drivers/firmware/arm_sdei.c | 60 +++++++++++++++++++++++----------------------
>  1 file changed, 31 insertions(+), 29 deletions(-)

Thanks, this appears to address my concerns. It's too late for 4.15 now,
but please resend for 4.16 and Catalin can pick this series up.

Will
--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
