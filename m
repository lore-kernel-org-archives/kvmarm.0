Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 009F7395ADB
	for <kvmarm@lists.linux.dev>; Thu, 30 Jul 2026 17:36:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.214.174
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785433018; cv=pass; b=g8JusZE+ySNGTJk4SMUprAFe/ChlASabQYKIN4xMsxXewts0V7GEkGl+wQ2AmTnSTvoINtM64fxbCOdY01L8SbpeGR2PhhOG+xvuSpGoy918tjvi0VVqMeZhVJFsqYsH+EMY17BKGTS3butojIhwULn6XN3erWikihM1DKNKsPE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785433018; c=relaxed/simple;
	bh=bEZVfjW3X/ZJJhJsMcL2gQZGx4De7c1nlF8QDVmWlMY=;
	h=From:In-Reply-To:References:MIME-Version:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Ph4jhesV4vw7SoHWQt04Jo6VoAzThS/2qcBbPGp46W9j2Qg2G10lVm0U9AEx4T9im3X8BuDF++8X2l5Vp4hV3xGJDGwMzctIVYk5or+HN/ZRFM7GcUPCc3p4pWw/lw76nhZf+dS/kl27LYH7eGkurGhxGNX3RA/qJKvBSltkGnM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ZfVMoYkT; arc=pass smtp.client-ip=209.85.214.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ZfVMoYkT"
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-2cc73e322dbso514425ad.1
        for <kvmarm@lists.linux.dev>; Thu, 30 Jul 2026 10:36:56 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1785433016; cv=none;
        d=google.com; s=arc-20260327;
        b=WgdJiQ+bWDvWggP7LGBdGE9xyc9Ot9ACtrQUV3uMjQH1x2hVLQCc84fsorlaP898dM
         YUiS4wqYkz5bI8Vua8XXbkahjt2a24nTXSYo55EcJvL/XOZQAQwioF8ywtuUyrYi1EA8
         ypZNe3BUi/6Uvyl2fJqfPhBzB46Piwa1cvWEJoecDu+jmg1G4L1KyTQge2CIDHCeQ1RJ
         ICCtyOrPu1444h3BT7DynA5qE4UQ2gVdMriRoy+292C//JUNI3hDf4KOwmodCZQMtl04
         ZxISCYIVcWvqfSuvHw6os/pWAyamui697O/CgweN2o8i+OkZDrp0jSk5lwfQ+zI6vMF0
         6YrA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:dkim-signature;
        bh=cF6Glwk5JHPcXFLYP8vDOSrow7Ekc+sBztL/w45l/K8=;
        fh=jx8MeykzSA+jRbRuqcRnyf1C545x1PfGp8e6TxGCpnk=;
        b=Bk3R+Ih/lE2/cz1wHouCBJ9ZlOCwe1OuyL/iP52g7pAGytmejUPV1s8WwpcBudBHgO
         CoiTZD6T2O/PevOQJOOyd/baX+hka5w/rSeY5/pWGOURY7HWm5NLUpjsFMFaU6aPLuhh
         PLlrPmZdO4wH1/jqBVERBIPlwRMus+VBI3r8SuTk+scIuX+KoJyncJd3twD43cPqdE4e
         /dxe63AUXwXKJriHFNvqkV9+YX52FXpGlV++F1tSAT2D2OPLbHCo4LIHu2YkkCkIXuJT
         h16dzBHURDKuo+EEAFdYurmrDLcYlfIE5/L4CEYxj9NS+N7/SMHY8/8lNl1RdqnraPRN
         cfeQ==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1785433016; x=1786037816; darn=lists.linux.dev;
        h=content-type:cc:to:subject:message-id:date:mime-version:references
         :in-reply-to:from:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=cF6Glwk5JHPcXFLYP8vDOSrow7Ekc+sBztL/w45l/K8=;
        b=ZfVMoYkTWSMuGXJQFpo6OtPPZz8qFrHhGThjW4xP/8t9VoYTvczCSmUTmngvZW1AAJ
         wUWYEnr40w6H+G79hxL21Ecgek4RXbf3Y+wyryDP7uTnatbUgNuOW4sX0QJmIuc8gP6f
         KjbLdDwzeBvxbOw2i+zeqhwT2BXkfR9B4N+riOXVBdH319d+PK5YCu7AxkSuBmwFUNC9
         zTlTWk3gWMWraMxwULwnB3qLgXASFo2/oT33eXwA4L02POYFxLt6ox0bFDjQhawqRW6G
         NcNyJJH6ENzPvjevbG8M9oQM3cowzK2XPonjNomDpyIU78Jl+8alFF/GWsxu4FuDLEdn
         eHlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785433016; x=1786037816;
        h=content-type:cc:to:subject:message-id:date:mime-version:references
         :in-reply-to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=cF6Glwk5JHPcXFLYP8vDOSrow7Ekc+sBztL/w45l/K8=;
        b=o2y2qJnHUyIYQ+Lza4Td21q7iOMl2Ywon/2afjjbtpIaqm81fJBec201OxAWGXNtsR
         esHWpFMErBF7XMx32gG61wUED+K14dZspbGmyZMl8bydsDBhOg2bKqytp52Tp7Ii7xpS
         gaUkporVVGfxA8slxbSuNk5y6Et3uRN1OZJfmfxPwZTIQH+U3k6goc+opUWMqq97XKXR
         yjS6G3onXD+3S1crDnL0WfEA38BrKoqXNLuOaEQEmBKfG/rN0DCv9lu6w2vKgPErmjJe
         Of7z+pgb3JHn0zMn+KZxJsUverBOxMFCtZB+4wUNGcgbWNFBSDys2EwvSM1+XZcPaUZZ
         8Mnw==
X-Forwarded-Encrypted: i=1; AHgh+Rrz2jlyAQ7CfMsjrVJHFv0oHpHqb/bH97UDQnUQQd+T8+AgEK/ce7zqyrPECpEbIHXb40ffuKk=@lists.linux.dev
X-Gm-Message-State: AOJu0YzAMeN8+xaGFmarMivgtW6xLnElAvDnOI9XBIJKYKVOi6+vez1h
	5iX+vaGBOyEG8DVnsTx12WWvo/6sxBMn2qk01QQZ3Db82eI1ymVKG8S/KBVqUMa1pn404RT73yY
	8Qti52KNiDduD4Ai2GoRLHYhKzChFy0qQTLYYM5Km
X-Gm-Gg: AR+sD12cm5iKFnDjya9f9ArXjqd0qoE99GXZLFdPfqaD3qPMPZXLPKKgOZOvB2xFB+0
	onpFvwHcUCOz9nKFzIy63oluU9DJPp8WEF7SpIjYLwViQ7Bn3Rc8PGdVUKVdLCkwXd4GrmL1k3E
	BvqcruTJjCH/QD6IW3H/FEPN6Uvz5N/gvmic9rek6gMazIHACK+nriBPCmhOgS6Nekq23p8IjTK
	1Haq7fbdohY/+u9cfUGKPKTFUOHBGy5KGu9R8zo0nVHtXwFC4+UEBfWObhfjupZ6NYnXJltU+CJ
	jAMM1aDDLpuxa5nmMzVgyopxLOOvcr3yPGRYSGRvsEpThWg6qeNgjYorHkQQqUB1DbFPyrNpxxf
	7x3iNbuK02AF8Ui+bmaRwje5QE/lJNk3tVQ==
X-Received: by 2002:a05:6a20:d805:b0:3c3:8651:b302 with SMTP id
 adf61e73a8af0-3c90072a2acmr3423693637.28.1785433015659; Thu, 30 Jul 2026
 10:36:55 -0700 (PDT)
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Thu, 30 Jul 2026 10:36:54 -0700
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Thu, 30 Jul 2026 10:36:54 -0700
From: Ackerley Tng <ackerleytng@google.com>
In-Reply-To: <20260728121138.1103610-3-tarunsahu@google.com>
References: <20260728121138.1103610-1-tarunsahu@google.com> <20260728121138.1103610-3-tarunsahu@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Date: Thu, 30 Jul 2026 10:36:54 -0700
X-Gm-Features: AUfX_mwFoYwitx3VhlqJDH1-k0l0ItJ6i-x625ej1dYBsVgzkh7R-MZiFMgMH5w
Message-ID: <CAEvNRgGazT2D-G7sEem4RD5nUEj7dmcg8vx2=3bpatS_o5uE+g@mail.gmail.com>
Subject: Re: [PATCH v4 02/11] KVM: Introduce kvm_create_vm_file() helper
To: Tarun Sahu <tarunsahu@google.com>, fuad.tabba@linux.dev, 
	Andrew Morton <akpm@linux-foundation.org>, seanjc@google.com, dmatlack@google.com, 
	Shuah Khan <skhan@linuxfoundation.org>, Jonathan Corbet <corbet@lwn.net>, david@redhat.com, 
	Pasha Tatashin <pasha.tatashin@soleen.com>, Pratyush Yadav <pratyush@kernel.org>, sagis@google.com, 
	Paolo Bonzini <pbonzini@redhat.com>, Mike Rapoport <rppt@kernel.org>, Alexander Graf <graf@amazon.com>
Cc: linux-kselftest@vger.kernel.org, andre.przywara@arm.com, 
	michael.roth@amd.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	will@kernel.org, vannapurve@google.com, maz@kernel.org, fvdl@google.com, 
	kvm@vger.kernel.org, oliver.upton@linux.dev, kvmarm@lists.linux.dev, 
	alexandru.elisei@arm.com, skhawaja@google.com, aneesh.kumar@kernel.org, 
	linux-doc@vger.kernel.org, David Hildenbrand <david@kernel.org>, yan.y.zhao@intel.com, 
	kexec@lists.infradead.org, suzuki.poulose@arm.com
Content-Type: text/plain; charset="UTF-8"

Tarun Sahu <tarunsahu@google.com> writes:

> - Move ITOA_MAX_LEN to kvm_mm.h for reuse by upcoming kvm_luo code.
> - Introduce kvm_create_vm_file() to wrap kvm_create_vm() and
>   anon_inode_getfile(), providing a unified VM file creation API.
>

I think these should be 2 separate patches.

>
> [...snip...]
>
