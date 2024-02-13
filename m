Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11B8E8F45
	for <kvmarm@lists.linux.dev>; Tue, 13 Feb 2024 03:27:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707794826; cv=none; b=J9/zrRFkOcxlOJqH3JfEg+gVG84Gr8BKwAswsQsWeS28yxrFVANrpzghfwdVUYeFWJeM8GtJCopZAF2w6eeHJb/LY/YSlfzauifNlgxGz6bddAWX6fb3x68t7rP+s6IXoq7AC8+X8pHS/QyllxGJn2p6awfzTQcixN2aJ0Y5Uc8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707794826; c=relaxed/simple;
	bh=k2gfEby2avrtvHzBUfVvHLiP3n7nkuPha9dr1uxkNDY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=N4y2mi0J4zakt1NP6iq4KZMKO+mBu9mO4dH3PRjxr9acf4AFC31qMa58iu8F9w3Tusdgr9lJIRAFtwIND8VJSCjYtBAvcXcRNCrGOSZI1+R/Uv9gveB4tTnny7yYNrvKdHXyuEnMNbP8mcVOrQgaZPboWS+8B9mhnn5QMfQ//cA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=uAJRWKBx; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="uAJRWKBx"
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-1d992a23d76so53240925ad.1
        for <kvmarm@lists.linux.dev>; Mon, 12 Feb 2024 19:27:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1707794824; x=1708399624; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=4Ol3QEcIEiOh1BLpsgDjP1PLEFR06C0O0EZBWIwePAQ=;
        b=uAJRWKBxE4Cmi6k5K3wSEuJIYMmsmX03Ojz//WT7m3i/1Kql1zdQPCOYGRW2kAVHVh
         nKBCZgNDj1c+G2y8ihSyB4F7vQ06xBgfP3hiralC8EG85u7ZnefP7QSxsxX0xsXaO3ah
         1SIx2v1DI88hGSeHwFazCp9rzweAfCkFJTIaxOrStaGvfZL0k6crYUqrvAf2aLzGhrTy
         MvBQAk/u+OPa/082OSwFX9nkmqSKDNU/tcSN07wH2W7FYlssDFZ3fHgTKGuo572JBsEa
         1p4Ffus6IoYlrHkVz1VrcWYJLK2hpFMlHBbqnD1mTGub6Ib+1f1ED/1Cx9jdaT5i3MkX
         i2Fw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707794824; x=1708399624;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=4Ol3QEcIEiOh1BLpsgDjP1PLEFR06C0O0EZBWIwePAQ=;
        b=GPKyKUeAbw88BLEHF3diHP1bPyAU5pujiNnK9T8LD5XfI/ccnQ4apm1HhaTH47k7Zn
         PDfDvKKAQfssOtIp/jZvOyvAbSAG9g6m+nCD4J03xhg0Rnybp+dBJbQ+k/wBn8tFhkbb
         xZQK4M9ZQCTLsUaHzKc0xgfYuK8ExrNky4PtG7nlQacXQ1ywIYIygJkitmM8ulrRyxeI
         YjQ6U/VKAzszfv84WV6lChSGdrYqHTsGVZJd6Qnlldpk/YO49+W45KRqFKAZw+KWfJpV
         pJUrS/0L+qUhXBfDnPBiWb2/Qh1KlJdKckX/h+f2jeRDHV0FTtoZ9lQun5sBmguA1jRF
         QzqQ==
X-Gm-Message-State: AOJu0Ywow8H1K9iQu/n8rJndpvgpwOEXCOjtEhx6y5/mttCBN5vxDV97
	xaoJgFEUf3GmhmBGR9dFBlUnPqMOxKvVtVtMcLm+FcdrKTWjXUsWstav5rMi39nxiPKiqD7MTUX
	TpA==
X-Google-Smtp-Source: AGHT+IE2/lvtUFa4iT45UhB99RCmacSvJqZ8c+JoTQ8zKhR7XCLP/GpvbJ/Z65s2wACzXrxrb6MA3pLj5cc=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:e5c5:b0:1d9:3d47:a440 with SMTP id
 u5-20020a170902e5c500b001d93d47a440mr278839plf.9.1707794824407; Mon, 12 Feb
 2024 19:27:04 -0800 (PST)
Date: Mon, 12 Feb 2024 19:27:03 -0800
In-Reply-To: <20230911021637.1941096-3-stevensd@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230911021637.1941096-1-stevensd@google.com> <20230911021637.1941096-3-stevensd@google.com>
Message-ID: <Zcrhh1CyWjCn8eQm@google.com>
Subject: Re: [PATCH v9 2/6] KVM: mmu: Introduce __kvm_follow_pfn function
From: Sean Christopherson <seanjc@google.com>
To: David Stevens <stevensd@chromium.org>
Cc: Yu Zhang <yu.c.zhang@linux.intel.com>, Isaku Yamahata <isaku.yamahata@gmail.com>, 
	Zhi Wang <zhi.wang.linux@gmail.com>, kvmarm@lists.linux.dev, 
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Mon, Sep 11, 2023, David Stevens wrote:
> From: David Stevens <stevensd@chromium.org>
> 
> Introduce __kvm_follow_pfn, which will replace __gfn_to_pfn_memslot.

Please use parantheses when refeferencing functions, i.e. __kvm_follow_pfn(),
__gfn_to_pfn_memslot(), etc.

> __kvm_follow_pfn refactors the old API's arguments into a struct and,
> where possible, combines the boolean arguments into a single flags
> argument.

This needs a more verbose changelog, but I honestly wouldn't mind doing that myself
as a way of refreshing all of this, and to lay out out what the end state will
(hopefully) look like when all architectures are converted.
