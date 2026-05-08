Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A39C33D511
	for <kvmarm@lists.linux.dev>; Fri,  8 May 2026 13:04:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778245477; cv=none; b=lUxEyZPLAW3BgjtRzCBLYo3bcLlcsZjejgAiAQfJAn/dyZuibifCp73FB9NxjNDkDBopkADi8Fha28xQv8VANzqY1VWUxl/xHl3SunhuymJpk2PDVJddcJQb2BZkeWIrXl23eM5Eky9vumvvC8c0H8iin78I/LoQsBMJ1Y8jrdM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778245477; c=relaxed/simple;
	bh=f9G7TRC2KDnCG4WetPKVWFBVZuAfXzkRBbcVG4yLvMI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gn1XaR4LgSp9gPtzMmauR0ki6QQ8ELE9Hq9Bs7OtqdZlu1AWhNcE5YFAw9b50jV4yya0y5M+aXsPKy4tcEHP9x7JwMYE7u3agmBZAvNyEOiVR+1RvkfmlZCVJz0iTHjOCZ5MxQFFWO5RknRR4oJla3KC+f8cGDj56OdFVs2aPUE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=QzRZtvkk; arc=none smtp.client-ip=209.85.128.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="QzRZtvkk"
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-4891ca4ce02so91415e9.1
        for <kvmarm@lists.linux.dev>; Fri, 08 May 2026 06:04:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1778245474; x=1778850274; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=RfHi7123Slj2oc7EjLwdj+vUC8W76ZS+ntDpkIRxN+U=;
        b=QzRZtvkkQLgJbhxOQDu899Onl9Qv7WgKyan/ic8hYaeAjrSmszw3OJjXWjxcMEtYTn
         s/TWLw92XjBrt2PnS3D4uzpIeIlkF5BQLNOhPzPt9by6QrtfiJPVqVBmrh7yhsKnpAXw
         Lu4RONkIDlgmkqa+md/t8QIUw/Lj3byQ2b1Hdu+Mw9dyqIMugXRSHXBCXVHogmnQpEwo
         eMmFbGB+28wJAPvcRGQa4V1hPrMuWHFiReaUG5M9Gq6/RzNLNT2PQ2CTa9PBslGdt+hV
         Y2dMyJb5IPr4ToXoEgJPNcPGUQO11Ly20IxiRXuEngiSNqd+xQq2zcB+VpeHt/QOCUP9
         5GyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778245474; x=1778850274;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=RfHi7123Slj2oc7EjLwdj+vUC8W76ZS+ntDpkIRxN+U=;
        b=hyqi7M3m7d1lGGSaBy/ZphhNl+wz39mTmNw0GfvJtgK/GnkcfuA/peiy3H2BjD7Sru
         FyISwzpZ5RPCqeou8uiZWZaWZF3WxYb+5nwLCiq7kk08V55Ws0zCRIC9xj2eepxdYrhL
         abxllZkhE1STV1D++OE+QVjrRYL72fGcs8ViRu90xp90HIs2WaFCtSvGtECHRrbwglOE
         sx4E40z4sloZ5xRhcpf3duKWjmDb8TGXa+0tNlev4tknWAgqt6B3LvcpZ7VAOCkV7maN
         Jd7bEaT5zm4fa7iNF00kNZznYkYVM+lnmaOIIphOVL0o6AFwAOOBA2Tu+wmIOGrFUICd
         A5Ag==
X-Forwarded-Encrypted: i=1; AFNElJ8x/FykiAb8t13Q03xVDGvPBJfu2mI8ukNk/mm3Pnmp9VIvB9O5n+Rgl58nBgb5CQuSjiR90qw=@lists.linux.dev
X-Gm-Message-State: AOJu0YyNbQLoEztHcQEVFcnDtSubHCM9xtw7Fpg+tcs0o7eVSKPaTlKK
	HMywcdNaVvn8tvB5jRTZpdY8lGQHMeLVqiSsGRrucAHAHqosq6jNm2XgMg3sm/50lw==
X-Gm-Gg: AeBDietZmsBo2odZeKSm+nuhYp1jMPtZwvJ3PZ8b7medC8TT50vaGGGos3gDEufa3Le
	t+edBUY3y/jwIB7eH47/+P19aNPngvAVRpkRgwouYrIIKGHQo2qO0zr9mI01HiNg0gIZz4BRInA
	FbWEgKQuQpFxf0NvXpW8yThKi1z/zmfDwdWKyutEfXfjE/qzECPSA4Bv09JCWLoiO0CrXFCbeIk
	3KTyZDrIzDgt1T7cyVmjumMcDD5N8JnTB53jiejXyV/mybidDZ4TF3KHH36eBuKUbovMFgjCtKA
	LNsk8Z2f+ult4L4act6TKGz9dYO9xx/SVsjO5c0wh4HIoodm0RN+lfwY+fUPM7c8oshx+mr855g
	Ki3xQzgBP9qlMY98Rt5ySQpsBTShzHXdhnKpc1auMqmr1fDtW1oc6NbYANopUoYju5b93MPVne8
	TLfaE/JTTWGCJys2PI2G+xk8KXL8k9L3tlPd/FI4VVreF//fzJG3ye6yk7Iha2ivntsL0NlkWfG
	5yGxhQI
X-Received: by 2002:a05:600c:4314:b0:489:1bbb:3356 with SMTP id 5b1f17b1804b1-48e64b05fbfmr681905e9.2.1778245473828;
        Fri, 08 May 2026 06:04:33 -0700 (PDT)
Received: from google.com (117.15.199.104.bc.googleusercontent.com. [104.199.15.117])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48e65a0fb25sm28858385e9.6.2026.05.08.06.04.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 May 2026 06:04:33 -0700 (PDT)
Date: Fri, 8 May 2026 13:04:27 +0000
From: Sebastian Ene <sebastianene@google.com>
To: Marc Zyngier <maz@kernel.org>
Cc: catalin.marinas@arm.com, oupton@kernel.org, will@kernel.org,
	joey.gouly@arm.com, korneld@google.com, kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	android-kvm@google.com, mrigendra.chaubey@gmail.com,
	perlarsen@google.com, suzuki.poulose@arm.com, vdonnefort@google.com,
	yuzenghui@huawei.com, Sudeep Holla <sudeep.holla@kernel.org>
Subject: Re: [PATCH] KVM: arm64: Forward FFA_NOTIFICATION* calls to TrustZone
Message-ID: <af3fW468-f1KXCrC@google.com>
References: <20260501114447.2389222-2-sebastianene@google.com>
 <86wlxgy00t.wl-maz@kernel.org>
 <afxuDpecPCVA56cL@google.com>
 <86se83xrwx.wl-maz@kernel.org>
 <afyd8u85L5XIl6dh@google.com>
 <86qznnxptx.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86qznnxptx.wl-maz@kernel.org>

On Thu, May 07, 2026 at 03:21:46PM +0100, Marc Zyngier wrote:
> On Thu, 07 May 2026 15:13:06 +0100,
> Sebastian Ene <sebastianene@google.com> wrote:
> > 
> > On Thu, May 07, 2026 at 02:36:46PM +0100, Marc Zyngier wrote:
> > > On Thu, 07 May 2026 11:48:46 +0100,
> > > Sebastian Ene <sebastianene@google.com> wrote:
> > > > 
> > > > On Wed, May 06, 2026 at 05:29:22PM +0100, Marc Zyngier wrote:
> > > > 
> > > > Hello Marc,
> > > > 
> > > > > [+ Sudeep]
> > > > > 
> > > > > On Fri, 01 May 2026 12:44:48 +0100,
> > > > > Sebastian Ene <sebastianene@google.com> wrote:
> > > > > > 
> > > > > > Remove the FFA_NOTIFICATION* calls from the blocklist used by the pKVM
> > > > > > FF-A proxy. This restriction was preventing the use of asynchronous
> > > > > > signaling mechanisms defined by the Arm FF-A specification to
> > > > > > communicate with the secure services.
> > > > > > While these calls are markes as optional, there is no reason why the
> > > > > > hypervisor proxy would block them because:
> > > > > > 
> > > > > > 1. Host is the Sole Non-Secure Endpoint: The Host operates as the
> > > > > >    only Non-Secure VM ID (VM ID 0) recognized by the Secure World.
> > > > > 
> > > > > Where is this enforced?
> > > > > 
> > > > 
> > > > There is no enforcement in place in the hypervisor since we don't proxy
> > > > FF-A from guest VMs, there is only one non-secure user of this which is the host.
> > > 
> > > And again: what makes that VM ID 0? Why can't the host pick VM ID 32
> > > and use that?
> > > 
> > 
> > The host discovers its id through the FFA_ID_GET and TZ returns 0 in
> 
> Does it? How do you verify this?
> 
 
It is written in the spec under 13.10 FFA_ID_GET ("ID value 0 must be
returned at the Non-secure physical FF-A instance"). If this contract is
broken and TZ in not spec compliant I am afraid there is not too much
that we can do.

> > this case. However if it wants to use VM ID 32 in any other call it
> > absolutely can but what would it be the attack here, what is your
> > concern ?
> 
> Let's be clear: I don't give a damn about a potential attack vector.
> The moment you add Secure to the mix, security is gone (funny, isn't
> it?). I care about being strict about the spec, and not letting
> through things that will eventually break.
>

Understood. 

> > 
> > > > > >    Because all forwarded notifications are inherently attributed to
> > > > > >    the Host by the SPMC, there is no risk of VM ID spoofing
> > > > > >    originating from the Normal World.
> > > > > 
> > > > > I don't understand: either the host is always using VM ID 0, and we
> > > > > have ways to check and enforce this (how?), or the simple fact that
> > > > > the request comes from NS is a guarantee that the SPMC will treat the
> > > > > VM ID as 0.
> > > > > 
> > > > > Which one is it?
> > > > 
> > > > My understanding is that when the hypervisor doesn't handle the allocation of
> > > > the non-secure IDs (through FFA_ID_GET), everything that comes from non-secure
> > > > is treated as having the VM ID 0 by the SPMC.
> > > 
> > > This looks terribly fragile. I'd rather you *enforce* these things
> > > rather than allowing any random stuff from the host and relying on
> > > the EL3 firmware to get it right (odds are that it won't).
> > > 
> > 
> > I can verify the vmid is 0 for the notification calls that I enable.
> 
> Yes, please.
>

Ack.

> > 
> > > This also ties into this:
> > > 
> > > > > > diff --git a/arch/arm64/kvm/hyp/nvhe/ffa.c b/arch/arm64/kvm/hyp/nvhe/ffa.c
> > > > > > index 1af722771178..a82d0cd22a17 100644
> > > > > > --- a/arch/arm64/kvm/hyp/nvhe/ffa.c
> > > > > > +++ b/arch/arm64/kvm/hyp/nvhe/ffa.c
> > > > > > @@ -675,14 +675,6 @@ static bool ffa_call_supported(u64 func_id)
> > > > > >  	case FFA_RXTX_MAP:
> > > > > >  	case FFA_MEM_DONATE:
> > > > > >  	case FFA_MEM_RETRIEVE_REQ:
> > > > > > -       /* Optional notification interfaces added in FF-A 1.1 */
> > > > > > -	case FFA_NOTIFICATION_BITMAP_CREATE:
> > > > > > -	case FFA_NOTIFICATION_BITMAP_DESTROY:
> > > > > > -	case FFA_NOTIFICATION_BIND:
> > > > > > -	case FFA_NOTIFICATION_UNBIND:
> > > > > > -	case FFA_NOTIFICATION_SET:
> > > > > > -	case FFA_NOTIFICATION_GET:
> > > > > > -	case FFA_NOTIFICATION_INFO_GET:
> > > > > >  	/* Optional interfaces added in FF-A 1.2 */
> > > > > >  	case FFA_MSG_SEND_DIRECT_REQ2:		/* Optional per 7.5.1 */
> > > > > >  	case FFA_MSG_SEND_DIRECT_RESP2:		/* Optional per 7.5.1 */
> > > > > 
> > > > > Shouldn't these be sanitised in a way? A bunch of registers are SBZ in
> > > > > the spec, and I'd expect this to be enforced.
> > > 
> > > which still remains unanswered.
> > 
> > Missed this sorry. We can reject them in the hyp proxy if the caller
> > uses non zero values in those registers.
> 
> I think we need that indeed.


While at it I discovered that none of the FF-A calls in the proxy
currently check for these SBZ registers. Would you be ok with a diff that
fixes this before the patch with the notifications ?


Refactor the handling logic in pKVM FF-A proxy to support checking for
SBZ/MBZ values. While at it, drop the do_ffa_mem_xfer macro and replace
it with two functions that make it clear that we re-write the
function-id with a 64-bit variant, to keep the same behavior as before.
Keep each handler in an array of structures together with a mask that
corresponds to the SBZ registers the spec expects.


diff --git a/arch/arm64/kvm/hyp/nvhe/ffa.c b/arch/arm64/kvm/hyp/nvhe/ffa.c
index a82d0cd22a17..35443a894172 100644
--- a/arch/arm64/kvm/hyp/nvhe/ffa.c
+++ b/arch/arm64/kvm/hyp/nvhe/ffa.c
@@ -561,13 +561,6 @@ static void __do_ffa_mem_xfer(const u64 func_id,
 	goto out_unlock;
 }
 
-#define do_ffa_mem_xfer(fid, res, ctxt)				\
-	do {							\
-		BUILD_BUG_ON((fid) != FFA_FN64_MEM_SHARE &&	\
-			     (fid) != FFA_FN64_MEM_LEND);	\
-		__do_ffa_mem_xfer((fid), (res), (ctxt));	\
-	} while (0);
-
 static void do_ffa_mem_reclaim(struct arm_smccc_1_2_regs *res,
 			       struct kvm_cpu_context *ctxt)
 {
@@ -854,9 +847,60 @@ static void do_ffa_part_get(struct arm_smccc_1_2_regs *res,
 	hyp_spin_unlock(&host_buffers.lock);
 }
 
+static void do_ffa_mem_share(struct arm_smccc_1_2_regs *res, struct kvm_cpu_context *ctxt)
+{
+	__do_ffa_mem_xfer(FFA_FN64_MEM_SHARE, res, ctxt);
+}
+
+static void do_ffa_mem_lend(struct arm_smccc_1_2_regs *res, struct kvm_cpu_context *ctxt)
+{
+	__do_ffa_mem_xfer(FFA_FN64_MEM_LEND, res, ctxt);
+}
+
+struct ffa_handler {
+	u32 func_id;
+	void (* do_ffa_handle)(struct arm_smccc_1_2_regs *res, struct kvm_cpu_context *ctxt);
+	u32 sbz_mask;
+};
+
+#define REG_RANGE_SBZ	GENMASK
+#define FFA_HANDLER(fid, cb, sbz) {	\
+	.func_id = (fid),	\
+	.do_ffa_handle = (cb),	\
+	.sbz_mask = (sbz),	\
+}
+
+static const struct ffa_handler host_handlers[] = {
+	FFA_HANDLER(FFA_FN64_RXTX_MAP,	do_ffa_rxtx_map,	REG_RANGE_SBZ(17, 4)),
+	FFA_HANDLER(FFA_RXTX_UNMAP,	do_ffa_rxtx_unmap,	REG_RANGE_SBZ(17, 2)),
+	FFA_HANDLER(FFA_MEM_SHARE,	do_ffa_mem_share,	REG_RANGE_SBZ(17, 5)),
+	FFA_HANDLER(FFA_FN64_MEM_SHARE, do_ffa_mem_share,	REG_RANGE_SBZ(17, 5)),
+	FFA_HANDLER(FFA_MEM_RECLAIM,	do_ffa_mem_reclaim,	REG_RANGE_SBZ(17, 4)),
+	FFA_HANDLER(FFA_MEM_LEND,	do_ffa_mem_lend,	REG_RANGE_SBZ(17, 5)),
+	FFA_HANDLER(FFA_FN64_MEM_LEND,	do_ffa_mem_lend,	REG_RANGE_SBZ(17, 5)),
+	FFA_HANDLER(FFA_MEM_FRAG_TX,	do_ffa_mem_frag_tx,	REG_RANGE_SBZ(17, 5)),
+	FFA_HANDLER(FFA_VERSION,	do_ffa_version,		REG_RANGE_SBZ(17, 2)),
+	FFA_HANDLER(FFA_PARTITION_INFO_GET,	do_ffa_part_get,	REG_RANGE_SBZ(17, 6)),
+};
+
+static bool is_sbz_error(const struct ffa_handler *cb, struct kvm_cpu_context *ctxt)
+{
+	int reg_idx, reg_end = fls(cb->sbz_mask);
+
+	if (!ARM_SMCCC_IS_64(cb->func_id) && reg_end > 7)
+		reg_end = 7;
+
+	for (reg_idx = 0; reg_idx <= reg_end; reg_idx++)
+		if (((BIT(reg_idx) & cb->sbz_mask)) && cpu_reg(ctxt, reg_idx))
+			return true;
+
+	return false;
+}
+
 bool kvm_host_ffa_handler(struct kvm_cpu_context *host_ctxt, u32 func_id)
 {
 	struct arm_smccc_1_2_regs res;
+	const struct ffa_handler *cb;
 
 	/*
 	 * There's no way we can tell what a non-standard SMC call might
@@ -880,37 +924,22 @@ bool kvm_host_ffa_handler(struct kvm_cpu_context *host_ctxt, u32 func_id)
 		goto out_handled;
 	}
 
-	switch (func_id) {
-	case FFA_FEATURES:
+	if (func_id == FFA_FEATURES) {
 		if (!do_ffa_features(&res, host_ctxt))
 			return false;
 		goto out_handled;
-	/* Memory management */
-	case FFA_FN64_RXTX_MAP:
-		do_ffa_rxtx_map(&res, host_ctxt);
-		goto out_handled;
-	case FFA_RXTX_UNMAP:
-		do_ffa_rxtx_unmap(&res, host_ctxt);
-		goto out_handled;
-	case FFA_MEM_SHARE:
-	case FFA_FN64_MEM_SHARE:
-		do_ffa_mem_xfer(FFA_FN64_MEM_SHARE, &res, host_ctxt);
-		goto out_handled;
-	case FFA_MEM_RECLAIM:
-		do_ffa_mem_reclaim(&res, host_ctxt);
-		goto out_handled;
-	case FFA_MEM_LEND:
-	case FFA_FN64_MEM_LEND:
-		do_ffa_mem_xfer(FFA_FN64_MEM_LEND, &res, host_ctxt);
-		goto out_handled;
-	case FFA_MEM_FRAG_TX:
-		do_ffa_mem_frag_tx(&res, host_ctxt);
-		goto out_handled;
-	case FFA_VERSION:
-		do_ffa_version(&res, host_ctxt);
-		goto out_handled;
-	case FFA_PARTITION_INFO_GET:
-		do_ffa_part_get(&res, host_ctxt);
+	}
+
+	for (cb = host_handlers; cb < host_handlers + ARRAY_SIZE(host_handlers); cb++) {
+		if (cb->func_id != func_id)
+			continue;
+
+		if (is_sbz_error(cb, host_ctxt)) {
+			ffa_to_smccc_error(&res, FFA_RET_INVALID_PARAMETERS);
+			goto out_handled;
+		}
+
+		cb->do_ffa_handle(&res, host_ctxt);
 		goto out_handled;
 	}
 
-- 
2.54.0.563.g4f69b47b94-goog

> 
> 	M.
> 
> -- 
> Without deviation from the norm, progress is not possible.

Thanks,
Sebastian
