Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A1E13E9584
	for <kvmarm@lists.linux.dev>; Thu,  7 May 2026 10:48:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778150938; cv=none; b=JTCMjvSfv/mZYzfatRtyNeLpCKEye9eWNAIpO5GFRK/A2vdq5fE0FVnYgiCZqtAxPCutLBUgeHXtjP4sqSXle3DAGcC3zFGkevcpIRznMiI7wduJIuHxhr/rwjXv5TpnQduFLUxmfFeXKRM8/HpdviONasfMck5AIp7ajHSbpnE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778150938; c=relaxed/simple;
	bh=PNzlkmzZAVB8U9xS0oKYg5xTf1GWvqR73uR9DaNDSFI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AzhIRDevdylH+jTcy5PfmHFuAoQZAnDZHYpEluv6sp7gTnFeILmz00jfHoWU6lpSMipvY2vOu4citunCZwLcEVOTZBilGH7qIEtMLEA+4p6iieUysVJaVoqWEW7g2rZbilUlgxXAWgfaw7jm31ysFyJ9x1HxXANujo6U3uZD8yg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=PlrTtG/9; arc=none smtp.client-ip=209.85.128.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="PlrTtG/9"
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-48d1c670255so86585e9.0
        for <kvmarm@lists.linux.dev>; Thu, 07 May 2026 03:48:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1778150933; x=1778755733; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=OJoMClM82QzX+aGWXXRpJH1kO6RtFIoJ4NC0MWGce34=;
        b=PlrTtG/94fv41Y9nHyOw0kRbuU+3cdm+SfDo5Ypa+YYpxee6zM7MhmLH8IFJa7yIAj
         WkEFxyy8Blu8yrbHZ8rMRpb8hlzouOHFlyJSNoXYMu0sKA+CDhJts2K1UMbMdkRjQ+Wq
         jcE2s8xhV/I3+qCQL1y7ssc8Ul96TQzMAOzL3k/ez8LUAhrrtvV1gxX30tvKxmUMLWpz
         6+6pPC3dzvi3KmtJ888253TBQFhBBvo64H8K5tprIz7I2JL8uuhxAcvXcf4dHrSilIWj
         CsGOeckp9+Mx2uJy1gYeATHXWwH/xT7CX2b0Gz6+UiCMQR7/awgSh3LLLi6ttEXy52Rd
         PEUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778150933; x=1778755733;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=OJoMClM82QzX+aGWXXRpJH1kO6RtFIoJ4NC0MWGce34=;
        b=qNtYp+SoPV/SsSBquCZ2JICkdDbwZcTM+EQouylEtYQLtIb+6FMMaqXIFvs/qKKcBK
         eXNldd17BAF0o1ivPGBRpkFwKkk53UjA8TjzXc+5JSL4+JsfJxuVkQX4QSrDrvzfTHxO
         g2x7kBNXuy+cWwOJyZ8ODkvuCiWBncscnwan4FU2mX/re4Nl6A8LhOxG2RzKZZPOw9e4
         YpNezEBxf4iUQkCQw1rQF6vk9UItjxJFGLzXWmCoKGsFExUGtTy81AH9qCfse+4lmnHD
         3lqXLy57Qrog/MlejmsPh8UU7MkdwuaHrcTaixXBdV5x2iZbVN/19c09Qmg53Ti8d7m8
         gQhA==
X-Forwarded-Encrypted: i=1; AFNElJ/51fMsifEQe3QnZXDBxpG5MSfbRu5ulC2Mjh9U+v80pZ/4pm/48R4zyHqG3xw8Cks8TWBJcL8=@lists.linux.dev
X-Gm-Message-State: AOJu0YznR1SuwvhOv3m0WSgQmeZGg661mctSXx278fyG7BVuScJT7orD
	NijS/HqNyslQuEoj8wi05vWNxUIhOVSKr6JZ2BgAJ/iUt2wR2oBsvwk+ZbIS43Vfug==
X-Gm-Gg: AeBDievwmURnl/UFNZ6OFwV93z0iUNbMGm29X/trjP6PbXygN0ondaSCkJE5j2QRySi
	7E9oYkk/KQ7AQa6vndyV8rLNA9DA9fZRe41GvMpwIibNnMvP81jpBzq6YtzuEzpw2zzXG9hnuJM
	z1uv5BlegLSVq8D97US0btMEKRlrWn0GIUhiwXbf4vlULjtsmg+wXCEGQ/eFUw5gtjUCXOGuag8
	W7CgSe6h/Hme4U0A0j/EDWmV2FvGeL5jXf1L6gVOduloKlGuEponGrvrz6phNSIPtjbKP3g4P94
	+pNOsZYTBerBdsAu8g7Fc3nhbzaOnsLJXBQWGzrbAVj4sErdxq0002RQv/UCH+qX+3Y7m+6bI+Y
	9b11Ou8sfAN5UIFz984YXZqkRzOM1OlzPIw54613EWYDmAA2Q/JTf0Lb6vip/SRQj60Y93rQ1oX
	txqF8shiuBAeg0EFpHKgnz+i1J2T93FeG07dJTuY8159Sxi4g1FrGD+9j/8ssPAmXWidAPhhv8L
	87hLhCE/1e7yB34rzQ=
X-Received: by 2002:a05:600c:48a1:b0:48a:5d55:c194 with SMTP id 5b1f17b1804b1-48e52ef8beemr1106625e9.7.1778150933019;
        Thu, 07 May 2026 03:48:53 -0700 (PDT)
Received: from google.com (117.15.199.104.bc.googleusercontent.com. [104.199.15.117])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-45054b02802sm19772180f8f.17.2026.05.07.03.48.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 May 2026 03:48:52 -0700 (PDT)
Date: Thu, 7 May 2026 10:48:46 +0000
From: Sebastian Ene <sebastianene@google.com>
To: Marc Zyngier <maz@kernel.org>
Cc: catalin.marinas@arm.com, oupton@kernel.org, will@kernel.org,
	joey.gouly@arm.com, korneld@google.com, kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	android-kvm@google.com, mrigendra.chaubey@gmail.com,
	perlarsen@google.com, suzuki.poulose@arm.com, vdonnefort@google.com,
	yuzenghui@huawei.com, Sudeep Holla <sudeep.holla@kernel.org>
Subject: Re: [PATCH] KVM: arm64: Forward FFA_NOTIFICATION* calls to TrustZone
Message-ID: <afxuDpecPCVA56cL@google.com>
References: <20260501114447.2389222-2-sebastianene@google.com>
 <86wlxgy00t.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86wlxgy00t.wl-maz@kernel.org>

On Wed, May 06, 2026 at 05:29:22PM +0100, Marc Zyngier wrote:

Hello Marc,

> [+ Sudeep]
> 
> On Fri, 01 May 2026 12:44:48 +0100,
> Sebastian Ene <sebastianene@google.com> wrote:
> > 
> > Remove the FFA_NOTIFICATION* calls from the blocklist used by the pKVM
> > FF-A proxy. This restriction was preventing the use of asynchronous
> > signaling mechanisms defined by the Arm FF-A specification to
> > communicate with the secure services.
> > While these calls are markes as optional, there is no reason why the
> > hypervisor proxy would block them because:
> > 
> > 1. Host is the Sole Non-Secure Endpoint: The Host operates as the
> >    only Non-Secure VM ID (VM ID 0) recognized by the Secure World.
> 
> Where is this enforced?
> 

There is no enforcement in place in the hypervisor since we don't proxy
FF-A from guest VMs, there is only one non-secure user of this which is the host.

> >    Because all forwarded notifications are inherently attributed to
> >    the Host by the SPMC, there is no risk of VM ID spoofing
> >    originating from the Normal World.
> 
> I don't understand: either the host is always using VM ID 0, and we
> have ways to check and enforce this (how?), or the simple fact that
> the request comes from NS is a guarantee that the SPMC will treat the
> VM ID as 0.
> 
> Which one is it?

My understanding is that when the hypervisor doesn't handle the allocation of
the non-secure IDs (through FFA_ID_GET), everything that comes from non-secure
is treated as having the VM ID 0 by the SPMC.

Thanks for having a look,
Sebastian 

> 
> > 
> > 2. No Memory Pointers or Addresses: The FFA_NOTIFICATION_* ABIs
> >    operate strictly via register-based parameters, passing only
> >    VM IDs, VCPU IDs, flags, and bitmaps. Because these calls do
> >    not contain memory addresses, offsets, or pointers, forwarding
> >    them doesn't pose a risk of memory-based confused deputy attack
> >    (e.g., tricking the SPMC into overwriting protected memory).
> >
> > While the pKVM proxy behaves as a relayer, it doesn't currently have its
> > own FF-A ID(only the host has the ID 0). The behavior of the setup
> > flow is covered by the spec in the: '10.9 Notification support without
> > a Hypervisor'.
> > 
> > Signed-off-by: Sebastian Ene <sebastianene@google.com>
> > ---
> >  arch/arm64/kvm/hyp/nvhe/ffa.c | 8 --------
> >  1 file changed, 8 deletions(-)
> > 
> > diff --git a/arch/arm64/kvm/hyp/nvhe/ffa.c b/arch/arm64/kvm/hyp/nvhe/ffa.c
> > index 1af722771178..a82d0cd22a17 100644
> > --- a/arch/arm64/kvm/hyp/nvhe/ffa.c
> > +++ b/arch/arm64/kvm/hyp/nvhe/ffa.c
> > @@ -675,14 +675,6 @@ static bool ffa_call_supported(u64 func_id)
> >  	case FFA_RXTX_MAP:
> >  	case FFA_MEM_DONATE:
> >  	case FFA_MEM_RETRIEVE_REQ:
> > -       /* Optional notification interfaces added in FF-A 1.1 */
> > -	case FFA_NOTIFICATION_BITMAP_CREATE:
> > -	case FFA_NOTIFICATION_BITMAP_DESTROY:
> > -	case FFA_NOTIFICATION_BIND:
> > -	case FFA_NOTIFICATION_UNBIND:
> > -	case FFA_NOTIFICATION_SET:
> > -	case FFA_NOTIFICATION_GET:
> > -	case FFA_NOTIFICATION_INFO_GET:
> >  	/* Optional interfaces added in FF-A 1.2 */
> >  	case FFA_MSG_SEND_DIRECT_REQ2:		/* Optional per 7.5.1 */
> >  	case FFA_MSG_SEND_DIRECT_RESP2:		/* Optional per 7.5.1 */
> 
> Shouldn't these be sanitised in a way? A bunch of registers are SBZ in
> the spec, and I'd expect this to be enforced.
> 
> Thanks,
> 
> 	M.
> 
> -- 
> Without deviation from the norm, progress is not possible.
