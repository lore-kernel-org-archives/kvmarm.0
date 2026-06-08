Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FCFE3D0BFB
	for <kvmarm@lists.linux.dev>; Mon,  8 Jun 2026 14:22:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780928550; cv=none; b=QZh0SS5tyZ6LynjIEJl3hwpTF5hmF+kj2POOE2d4IFGD+bJZ+ulQhlANbsbgL66Ypjv1L8T3drMK++nLI2XWHa1sENRS/SsZ4nZqjuNVzkksqIXJ2fDpTcAasDxVNJEk9i9t/Mg1e6PvfaDSi6d5FMOtdnwprALdAICF51FTJ2c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780928550; c=relaxed/simple;
	bh=Rlbk9tEGqeQ9ZsVb8Vxb0S3BBhDQl+53BntceG8nbck=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mVqA4GesiMwDP30bXVMxVFK4h4OL0IHwY+c/Oh7CsGwj++RIDPTw647GFXlVSNZsr2RqJBzml7BVbLXQfmgHoN9r2gp26KYjIgwAfDE+p6n9SQbBuwKkRLxnXfbVVd0DtkPHvz8PaLKxVt1LsLPjHneflYyrUqHlZqeDJ0F5GOQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=r5AVFodt; arc=none smtp.client-ip=209.85.128.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="r5AVFodt"
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-490bd64ca95so197065e9.0
        for <kvmarm@lists.linux.dev>; Mon, 08 Jun 2026 07:22:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1780928548; x=1781533348; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=NMlTDtSQVCRaIScLdU5LnPoxCDDHCuJqXKf3DYv7eY4=;
        b=r5AVFodtv5ftAJNe76daZ8FE2VgPvg7VIaQeyotZKN/jbazwQACpSfh1GARfZ2s5C8
         f3Y9Va/BHBvg+A7LgJpvBrmdUE38Xss98l+fEkv8qw04JxdJaHBHjS1QMD8e+ZcceJ/y
         J1hkBwWfyumWYUTcZqmX81Y23rXoLEDpDeEDEiwC95YiFjcEElulTGe8rCaWU9KtEPqw
         GAJWDtaRN21GAHO/XYMo3hx5AssVSRrTAUu8o4AQ5/+W59udYhe3H5Wxoe5IfIQT/jD1
         GhQQ91iWgmh1QxksjpJXx8jcuYEzX/NuC1LAC31cw8lxSo05Y384E6oAs8Xu+oMk6ZLA
         q6eQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780928548; x=1781533348;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=NMlTDtSQVCRaIScLdU5LnPoxCDDHCuJqXKf3DYv7eY4=;
        b=TC5sLUiNXNZBYHhiiiWku6kpp5hVPniewU88wwFvtScX/tSUFApkFKoPyfgpBU/pVf
         IvsitKTiOuBH+RlQH+9sp/NUzN/WROLFskX0yN4TlNUd73zbwCNTmiAwzj2Zdouw3nIr
         vWt4saB2NM0QBmIxBQGTnf6A495igavpovRV3P/XMclIJzYbjcjqHXbTCyzlaqYEHpfI
         9U282nt02CdgQOLjLQiDLJ1mNN4sc3zHPbul9OrCrVyspt75KMW6680aAxwXZ1vfMgIE
         wyVPcSF3vWgBVVaR89QDvetlMxRrTlZ8aXr5NoKkIlPvRze/gIbDUQUcKAsIzFEBPqlY
         Voxg==
X-Forwarded-Encrypted: i=1; AFNElJ/d3Zti5wVPaPVzzMlib425SLh+b4SQvAr/YYElL8PKs16uPMfDAnNqRt8yzWw/2eL2DRA64us=@lists.linux.dev
X-Gm-Message-State: AOJu0YzVHIM/QyQ05z1gaUkziCxCoNDrjgvqxMX9fU7Js6DhmJ/RY9Tb
	p69G9f9LwkwAmHazWJyZYWm7JL7EIsdTucGRlKVrp6FuWVCoN6WEl/0XZ9HU9Tcfrw==
X-Gm-Gg: Acq92OG/i5b2fnhnCldG7mBPwK9Bqhkp/HneOYD4BwliEEuMIIxx+d9l2+s8w48mpKv
	HstUTpvR8Fj5tJUyhECceHRWgdUfCqz2FwbZfxUDEh0clptoGhZAdpVIdcT7eYpwrN+oIJzNkKZ
	eebIzfOywNyFiSm7/N9cNNHpDy2iI0ovF+MuQjsrRy/pkDAVLD8iGVm80iYLkOBR9ZHh0YMRGXF
	xC8r6ksyPk3lFDERD/v8TILUdrAzuWrkUHqIkP5eCP3yMjIimI/0Sk3vKhUqvcZB/OIJxanQco6
	Bfs2DCLqW91pxTDjaDzVcXBFyaK3VNHrz+QVtrYRJPPFuH0/76RqCkHh3j1PykQ33699hAgR8mD
	dIydsTrhzIICiuJh+/EDDszoYiW/TsfIks/TKZYAi1pqMBiRZtXE8QXpQZEb8viFdRU9a1yM9G9
	I5h9XeEnwO/WvrXxw7EG2KSgXJYnWsjotwnn50SooZW9QJEFLR6zhw9B8Uc7Q2fV6YexkYmjcBB
	BWqqzTb
X-Received: by 2002:a05:600c:3299:b0:490:c2b6:de6c with SMTP id 5b1f17b1804b1-490c2c96beemr2993835e9.13.1780928547315;
        Mon, 08 Jun 2026 07:22:27 -0700 (PDT)
Received: from google.com (143.11.148.146.bc.googleusercontent.com. [146.148.11.143])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4601f344541sm49486271f8f.22.2026.06.08.07.22.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Jun 2026 07:22:26 -0700 (PDT)
Date: Mon, 8 Jun 2026 14:22:22 +0000
From: Sebastian Ene <sebastianene@google.com>
To: Will Deacon <will@kernel.org>
Cc: Marc Zyngier <maz@kernel.org>, catalin.marinas@arm.com,
	oupton@kernel.org, joey.gouly@arm.com, korneld@google.com,
	kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org, android-kvm@google.com,
	mrigendra.chaubey@gmail.com, perlarsen@google.com,
	suzuki.poulose@arm.com, vdonnefort@google.com, yuzenghui@huawei.com,
	Sudeep Holla <sudeep.holla@kernel.org>
Subject: Re: [PATCH] KVM: arm64: Forward FFA_NOTIFICATION* calls to TrustZone
Message-ID: <aibQHiYimPP1ylk3@google.com>
References: <20260501114447.2389222-2-sebastianene@google.com>
 <86wlxgy00t.wl-maz@kernel.org>
 <afxuDpecPCVA56cL@google.com>
 <86se83xrwx.wl-maz@kernel.org>
 <afyd8u85L5XIl6dh@google.com>
 <86qznnxptx.wl-maz@kernel.org>
 <af3fW468-f1KXCrC@google.com>
 <ahmxiFXXTupafbXw@willie-the-truck>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ahmxiFXXTupafbXw@willie-the-truck>

On Fri, May 29, 2026 at 04:32:24PM +0100, Will Deacon wrote:
> On Fri, May 08, 2026 at 01:04:27PM +0000, Sebastian Ene wrote:
> > While at it I discovered that none of the FF-A calls in the proxy
> > currently check for these SBZ registers. Would you be ok with a diff that
> > fixes this before the patch with the notifications ?

Hi Will,

> 
> I'd probably structure it as a separate patch per call, tbh. That way,
> the commit message can talk about the specific fields that are reserved
> for a given call. See below.
> 
> > Refactor the handling logic in pKVM FF-A proxy to support checking for
> > SBZ/MBZ values. While at it, drop the do_ffa_mem_xfer macro and replace
> > it with two functions that make it clear that we re-write the
> > function-id with a 64-bit variant, to keep the same behavior as before.
> > Keep each handler in an array of structures together with a mask that
> > corresponds to the SBZ registers the spec expects.
> 
> Although I agree that we should be enforcing SBZ/MBZ paramaters (because
> we have no idea what they might do in future versions of the spec), I
> also think that doing this at the register level is too coarse.
> 
> For example, the VM ID parameter to FFA_NOTIFICATION_BITMAP_CREATE has bits
> 31:16 as MBZ. So I think we probably need to do the checking on a
> per-function basis, like Per is doing in his series:
> 
> https://lore.kernel.org/r/20260501-host-direct-messages-v6-0-3f4af727ed85@google.com
> 

For the newly added calls like FFA_NOTIFICATION_* we can do that in a
separate functions, but what about the other existing calls that have
MBZ registers ? that was the reason for the inline proposal in :
https://lore.kernel.org/all/af3fW468-f1KXCrC@google.com/
(to avoid duplicate checks).

> Will

Thanks,
Sebastian
