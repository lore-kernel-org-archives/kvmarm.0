Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13D00402454
	for <kvmarm@lists.linux.dev>; Thu,  7 May 2026 14:13:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778163194; cv=none; b=ZM451hVE82+bQyByi4JZm6SP5vVSLSIgPl9DGZdZo8vtltFn9g18mDQAavKyQNksMe7EHsuLL4t8MnyK8PJadB7Sao0igmgVQSWT6BGy/fFIfsXRzUd+EGNQ3wGYG3JUczS96/6qaQ+VFhtNI8lpCVqjSEp8VV/JlSAyieaARjo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778163194; c=relaxed/simple;
	bh=zmDfGgJt+s3h6EvQ6yFaMEo+r8tYZFeby7tQ0LYOaa4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tG/vzY8WXtrdkjJFremEPDSXvXjOxJQue92fDl9dyrhvyhFZ2sjjrdB5drbdIztX0G1iSDLHO2E/9n6DmTcLuHob7cQajdLcaXP6k9awDEKjzUF9m+/C+y0vqs/p67rX6i1SDcmxVGM2KPr7pBD5hYbBaYzFv2euE7BVfn+KrBc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=e0HH1psv; arc=none smtp.client-ip=209.85.128.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="e0HH1psv"
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-488940ccfa6so90715e9.1
        for <kvmarm@lists.linux.dev>; Thu, 07 May 2026 07:13:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1778163191; x=1778767991; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=KWZl5k59w2IiSBsefd/YiDshiTjYPFctzi/mQQeAVwQ=;
        b=e0HH1psv/NQH8yrfrntvrr0kNoBBgNhBhtv/hUQO65nEqsBzNxw4d2zrRoA8pvLBwr
         obzGFzh+apHArFcbENnYkDub/u36Xpkbhmjo4kixJAEulGoHcSBzv6Aw84HWiNyxSsQD
         2MAkE2QKcTMmmYT5DYrUq+DDWExUICXpE4FbD4Ev/BFooDpAOb2//EILqsM/Ku0nzNct
         dSnzDyEvrEvDz7esbVhwPanP98o9Q3qrNcn4a3TnYSXc6MTSR8I9jNhjx3E2gZtn2/0I
         h2Ck4ooSYjfyWugO0Qs29YWMQJOxom1vYrwfOrOWmNtbamCVneiyyILBseuMzYWJx8Gw
         N6IQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778163191; x=1778767991;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=KWZl5k59w2IiSBsefd/YiDshiTjYPFctzi/mQQeAVwQ=;
        b=PW/sGva9mcWbgTnecB9b2h0vJTNTnxbpEqzRRs98GFj43ajjGH+OY+RzapkbjI+DJY
         5EXLpT5MizKEZFTKje5cSSqn8auxMByf68qL0ZgCOMJaGczYZgwBrRMZ342a59VZ1qqx
         O7mzumblIPwt4ECmJZwkKesNthgEQ9tzuSxP9/e2eyOD0qUaIiGhFqpDdrDB6T3iFRsN
         4adjhp8nwctN37EpgslO1bnYg886zpJ3qJUwajsoYY8fiiZDTAzi3D+VIZZ5gXH1x0vU
         HhivVOEUA7fbzlDRwzTgfsx2SDJKz6i1HUd8qk9xpf3dotD7F5FYhDVCCDEOENbRKpHZ
         PWDg==
X-Forwarded-Encrypted: i=1; AFNElJ8u4loI2PRfGqn5/f2iT2SB8KAKgjF5rPIVXDgyBcgfwwB84gGhDCx+hjJC1WyqJV69xHhzWMY=@lists.linux.dev
X-Gm-Message-State: AOJu0Yz7RwSPrQ487pRHIxUXSg9RUIkBCb9tKqffjUSUN5eaDgrp38SI
	7CHKY5bVVyLLXgeVT/apgz2V/B2flf0lTl+pR/WE6A5RCh9kOwtGAGI5OIWmTlnOIg==
X-Gm-Gg: AeBDies8tC6WYDEtD/AJy1ZFbD0J/1P9nQhyOYOwxKmwrfStG8S4wXrtTw9kq7+AHTh
	dlfZ4Ysug2RHYnt/8MBGqSfjQIPUxOSM/MfGOLSYNkJM16B+A6FMKvkz9D6edTJnNrFgqAmgjGZ
	OvSBeqhbpTybEsjN78YE4R3B/mnKObRGyK2g+4Fn8U3scwpp3cYE8wD28leDwl70IDJi15zHkw3
	+Fk8+a+Ka+cex1TId5zB2TyfxDOT6KJ+hIVnqONNj3P6hQvjWy0XSB3DK91+I1dGLjHiJer2IS9
	Zeygw9VCEwl2+X+jvMZ873vfnTPOwF2JCjXrVoTvS2j+l4WgjyMiKYJEP4i3cbs+gnDNLhFaGuf
	xDVla/5n8mN6GY3rXlPGRIg6XCymNdqZ09KH6tQjjqikz6/D1Jwj9JprekbsHviS6enCMCMt+oS
	igOBDJfAvQWdQmMJLTZAsQfVgGQXISar89jMzaPF9N18pW7zPfmD0TOwU03JIfL8/WziQM7rsNN
	Sb4lu8X9JMhkT8FtVw=
X-Received: by 2002:a05:600c:a68a:b0:477:86fd:fb49 with SMTP id 5b1f17b1804b1-48e5d64bf65mr778495e9.10.1778163190850;
        Thu, 07 May 2026 07:13:10 -0700 (PDT)
Received: from google.com (117.15.199.104.bc.googleusercontent.com. [104.199.15.117])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48e538a547bsm139388055e9.5.2026.05.07.07.13.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 May 2026 07:13:10 -0700 (PDT)
Date: Thu, 7 May 2026 14:13:06 +0000
From: Sebastian Ene <sebastianene@google.com>
To: Marc Zyngier <maz@kernel.org>
Cc: catalin.marinas@arm.com, oupton@kernel.org, will@kernel.org,
	joey.gouly@arm.com, korneld@google.com, kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	android-kvm@google.com, mrigendra.chaubey@gmail.com,
	perlarsen@google.com, suzuki.poulose@arm.com, vdonnefort@google.com,
	yuzenghui@huawei.com, Sudeep Holla <sudeep.holla@kernel.org>
Subject: Re: [PATCH] KVM: arm64: Forward FFA_NOTIFICATION* calls to TrustZone
Message-ID: <afyd8u85L5XIl6dh@google.com>
References: <20260501114447.2389222-2-sebastianene@google.com>
 <86wlxgy00t.wl-maz@kernel.org>
 <afxuDpecPCVA56cL@google.com>
 <86se83xrwx.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86se83xrwx.wl-maz@kernel.org>

On Thu, May 07, 2026 at 02:36:46PM +0100, Marc Zyngier wrote:
> On Thu, 07 May 2026 11:48:46 +0100,
> Sebastian Ene <sebastianene@google.com> wrote:
> > 
> > On Wed, May 06, 2026 at 05:29:22PM +0100, Marc Zyngier wrote:
> > 
> > Hello Marc,
> > 
> > > [+ Sudeep]
> > > 
> > > On Fri, 01 May 2026 12:44:48 +0100,
> > > Sebastian Ene <sebastianene@google.com> wrote:
> > > > 
> > > > Remove the FFA_NOTIFICATION* calls from the blocklist used by the pKVM
> > > > FF-A proxy. This restriction was preventing the use of asynchronous
> > > > signaling mechanisms defined by the Arm FF-A specification to
> > > > communicate with the secure services.
> > > > While these calls are markes as optional, there is no reason why the
> > > > hypervisor proxy would block them because:
> > > > 
> > > > 1. Host is the Sole Non-Secure Endpoint: The Host operates as the
> > > >    only Non-Secure VM ID (VM ID 0) recognized by the Secure World.
> > > 
> > > Where is this enforced?
> > > 
> > 
> > There is no enforcement in place in the hypervisor since we don't proxy
> > FF-A from guest VMs, there is only one non-secure user of this which is the host.
> 
> And again: what makes that VM ID 0? Why can't the host pick VM ID 32
> and use that?
> 

The host discovers its id through the FFA_ID_GET and TZ returns 0 in
this case. However if it wants to use VM ID 32 in any other call it
absolutely can but what would it be the attack here, what is your
concern ?  

> > > >    Because all forwarded notifications are inherently attributed to
> > > >    the Host by the SPMC, there is no risk of VM ID spoofing
> > > >    originating from the Normal World.
> > > 
> > > I don't understand: either the host is always using VM ID 0, and we
> > > have ways to check and enforce this (how?), or the simple fact that
> > > the request comes from NS is a guarantee that the SPMC will treat the
> > > VM ID as 0.
> > > 
> > > Which one is it?
> > 
> > My understanding is that when the hypervisor doesn't handle the allocation of
> > the non-secure IDs (through FFA_ID_GET), everything that comes from non-secure
> > is treated as having the VM ID 0 by the SPMC.
> 
> This looks terribly fragile. I'd rather you *enforce* these things
> rather than allowing any random stuff from the host and relying on
> the EL3 firmware to get it right (odds are that it won't).
> 

I can verify the vmid is 0 for the notification calls that I enable.

> This also ties into this:
> 
> > > > diff --git a/arch/arm64/kvm/hyp/nvhe/ffa.c b/arch/arm64/kvm/hyp/nvhe/ffa.c
> > > > index 1af722771178..a82d0cd22a17 100644
> > > > --- a/arch/arm64/kvm/hyp/nvhe/ffa.c
> > > > +++ b/arch/arm64/kvm/hyp/nvhe/ffa.c
> > > > @@ -675,14 +675,6 @@ static bool ffa_call_supported(u64 func_id)
> > > >  	case FFA_RXTX_MAP:
> > > >  	case FFA_MEM_DONATE:
> > > >  	case FFA_MEM_RETRIEVE_REQ:
> > > > -       /* Optional notification interfaces added in FF-A 1.1 */
> > > > -	case FFA_NOTIFICATION_BITMAP_CREATE:
> > > > -	case FFA_NOTIFICATION_BITMAP_DESTROY:
> > > > -	case FFA_NOTIFICATION_BIND:
> > > > -	case FFA_NOTIFICATION_UNBIND:
> > > > -	case FFA_NOTIFICATION_SET:
> > > > -	case FFA_NOTIFICATION_GET:
> > > > -	case FFA_NOTIFICATION_INFO_GET:
> > > >  	/* Optional interfaces added in FF-A 1.2 */
> > > >  	case FFA_MSG_SEND_DIRECT_REQ2:		/* Optional per 7.5.1 */
> > > >  	case FFA_MSG_SEND_DIRECT_RESP2:		/* Optional per 7.5.1 */
> > > 
> > > Shouldn't these be sanitised in a way? A bunch of registers are SBZ in
> > > the spec, and I'd expect this to be enforced.
> 
> which still remains unanswered.

Missed this sorry. We can reject them in the hyp proxy if the caller
uses non zero values in those registers.

> 
> 	M.
> 
> -- 
> Without deviation from the norm, progress is not possible.

Thanks,
Sebastian
