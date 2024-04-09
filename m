Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC83212F59D
	for <kvmarm@lists.linux.dev>; Tue,  9 Apr 2024 22:47:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712702827; cv=none; b=WxFvUnIdIxafAyPT2HPZ+PCIET2AUFOlsFrx0p/5arZzUCRexz/i6fpNkcpZgCo6IlHYjBYNqoL6oapKyrH+CMAWW4h5NfpYQBEtF/xWe7lorBl359odASIBuiwkyPnhrxVZPYplMylkBvKXwlIYLDqy6EwgIeJH7wE/ZQFngN0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712702827; c=relaxed/simple;
	bh=k51+5LsDbq2hvGlxfuH5BGJttTm71LkxCDDWSrA2sOY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ePdtoiFbJWV11vSAg93wEaUA+6Q6sCkEmd5Kz/mPyXk+TTxuoyeQvMOmfnYRi4M0IrmvPnVuhAyqdVAnuFvZTbgXSTQFTN09jARqGhbquqK5Z8BFd10pxZMRxeJnIsCRsCkmSMrFhFcMInL2bPBPNe+P12GaykztMynjNCSsh2Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=2vwhu9st; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="2vwhu9st"
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-610c23abd1fso114302897b3.0
        for <kvmarm@lists.linux.dev>; Tue, 09 Apr 2024 15:47:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1712702825; x=1713307625; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=AlR3wd32J7CM7haAcioPhyocAIlp+PLTQ5N+UsXAt0M=;
        b=2vwhu9stZTBr2Qdn/uitTwoCSS4P0S+StAa/1DKJ/vHYl1PXcd/k9Eowk9myLb1c9a
         P+f9Y0zHi1JVS8xVCjsWfKoy0pqkca6b5izYa48WBuAZzq6nlZ2DSuHqtdywKPyTashR
         PSdwU2yxNAdEKmNpzIKvU2sEDfer8I6Al7eI7FpLTYfqr5sCYRl0zF82ilyEKjfDLotL
         4fdxksZlmgHIXqKxTjoxB6SznFPD1zf0ZtqoL9SLmPLuCPuMDjP92N3qr7tb8YoIyRzU
         Z9DshnCfcHuIKJOwXwi4Zxp6T+aILEkiQq90/Ox/LRw/PrLtUk3dAeEHQ9k0mzGx+1/1
         URNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712702825; x=1713307625;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=AlR3wd32J7CM7haAcioPhyocAIlp+PLTQ5N+UsXAt0M=;
        b=ezPXJ1YVrN82k0Yw+JIAOA7RjGk3oJVX4+RItUrXQ/ZBppXwWbhOMhZAfcr0yGsVdd
         l1abIrt+XHYLic5JIqCaCf+H7RCcSpMdGBoe7oPXO46UbRQzz202n+fWMVpr0kENW1ny
         RbvgVpfHcfbpqt/Q3LAnZXkQVwd4YOm3dcIG5+5G0mj5eZyP0GpC+L46i/XpXTqTyRLz
         ZTpvjo1xSaAX97xTfjpwMDaSCh9WqtNFNv+ZMl/mqinfElJwmbobyZICJa8oLsWQeBxZ
         D2zac50V9MSiVk8o3C6MMTgTTutNk2qwebMWWrrkPQf/6jAbZeSu9cwwbHRjFVKW5HQi
         m7eA==
X-Forwarded-Encrypted: i=1; AJvYcCWmoEZOWSw2bbUkuTOMBnR1Fq/t8gXpLCM0PPleB+WszbLR5jDwnSS01Df6jHJ6xGwfF8aw7ZTdwiIXgj01BXtfY1j/UMQQ
X-Gm-Message-State: AOJu0YxnUlqw9s5xjjZFC2NfPqAvgfq45+u/4oYGe09k50cI53qf3uMG
	1zUvuU7URYDJ/h5wbRM9tKPKBUskAIenVlBalit0KU6CesNANeClohwP6SzVaJodMuE+snMgj+B
	IOQ==
X-Google-Smtp-Source: AGHT+IFLTy5GkVD0E7U+RH9kzxgpp0i5nxbXyjxmK+s0+O6klcL95tqJryS7wnm2k8slKkIjiYxCm6loI+Y=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:690c:680a:b0:618:28ee:ea3b with SMTP id
 id10-20020a05690c680a00b0061828eeea3bmr270722ywb.7.1712702825115; Tue, 09 Apr
 2024 15:47:05 -0700 (PDT)
Date: Tue, 9 Apr 2024 15:47:03 -0700
In-Reply-To: <20240215235405.368539-4-amoorthy@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240215235405.368539-1-amoorthy@google.com> <20240215235405.368539-4-amoorthy@google.com>
Message-ID: <ZhXFZ1CLJazF9_k_@google.com>
Subject: Re: [PATCH v7 03/14] KVM: Documentation: Make note of the
 KVM_MEM_GUEST_MEMFD memslot flag
From: Sean Christopherson <seanjc@google.com>
To: Anish Moorthy <amoorthy@google.com>
Cc: oliver.upton@linux.dev, maz@kernel.org, kvm@vger.kernel.org, 
	kvmarm@lists.linux.dev, robert.hoo.linux@gmail.com, jthoughton@google.com, 
	dmatlack@google.com, axelrasmussen@google.com, peterx@redhat.com, 
	nadav.amit@gmail.com, isaku.yamahata@gmail.com, kconsul@linux.vnet.ibm.com
Content-Type: text/plain; charset="us-ascii"

On Thu, Feb 15, 2024, Anish Moorthy wrote:
>  This ioctl allows the user to create, modify or delete a guest physical
>  memory slot.  Bits 0-15 of "slot" specify the slot id and this value
> @@ -1382,12 +1383,16 @@ It is recommended that the lower 21 bits of guest_phys_addr and userspace_addr
>  be identical.  This allows large pages in the guest to be backed by large
>  pages in the host.
>  
> -The flags field supports two flags: KVM_MEM_LOG_DIRTY_PAGES and
> -KVM_MEM_READONLY.  The former can be set to instruct KVM to keep track of
> +The flags field supports three flags
> +
> +1.  KVM_MEM_LOG_DIRTY_PAGES: can be set to instruct KVM to keep track of
>  writes to memory within the slot.  See KVM_GET_DIRTY_LOG ioctl to know how to

This formatting is funky.  I suspect you are trying to avoid touching lines that
otherwise wouldn't be modified, but the end result is hard to read.  I would also
opportunistically clean up the wording in general, e.g.

1. KVM_MEM_LOG_DIRTY_PAGES: can be set to instruct KVM to keep track of writes
   to memory within the slot.  See KVM_GET_DIRTY_LOG ioctl for details.

> -use it.  The latter can be set, if KVM_CAP_READONLY_MEM capability allows it,
> +use it.
> +2.  KVM_MEM_READONLY: can be set, if KVM_CAP_READONLY_MEM capability allows it,
>  to make a new slot read-only.  In this case, writes to this memory will be
>  posted to userspace as KVM_EXIT_MMIO exits.
> +3.  KVM_MEM_GUEST_MEMFD: see KVM_SET_USER_MEMORY_REGION2. This flag is
> +incompatible with KVM_SET_USER_MEMORY_REGION.

This is now stale, as KVM_MEM_GUEST_MEMFD is also incompatible with READONLY.
