Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DB4E5026D
	for <kvmarm@lists.linux.dev>; Tue,  6 Feb 2024 03:29:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707190176; cv=none; b=N+ECh4rLEp0WBUOVe4n67ZFyvFl0vZwnobqsU8cNfW/2A9dWBRC7ApwFvWGCtPULA7FNXMGHT0R0GyRQoQCN720lszFfjxSqh1i7Vap/SryI1KwWY0rM+nnPKxIffRTrSA5AUCiFM+qgnf/a9jLHSV4OdMxQxrdHqqfjW3mIPiE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707190176; c=relaxed/simple;
	bh=K47t6Qn8VX9LZd2vOHxHLV0Ys/CaGLr5+PC1CzGP2TU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=tCEHbEVQthxdgQR9x9qQTOEBv7gfai2XCiW/V6n2jjcG87WXDdtAKCcHXfhCe6xac3wDyMepnmaGN8Ej/qoQzfs+3IxshNvF4gV0MrWr34iY5OZ4O9sTd7yHHQiV4oLWB5p87LPPKkCq4pFI8ahKo8BcpIonBniPCoSxAZWL5N4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=EZ6khAF0; arc=none smtp.client-ip=209.85.219.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="EZ6khAF0"
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-dc6dbdcfd39so10076265276.2
        for <kvmarm@lists.linux.dev>; Mon, 05 Feb 2024 19:29:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1707190174; x=1707794974; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=/Tfd5OhfoKoOciQEBeRQDfj0WyGPDWpvLlZKvDtbwOk=;
        b=EZ6khAF0EVQnnCtwSWdPmzaOHRbZhi8IaqRAioOF2DN6SAjVJUuFEYT2Hld9u5Uph1
         G3gm/Iur3ymrOIThQ+55u+XIiKqHlERqgo2L8IFJRRakwTLPQH1PZJdfxxLvys7IfgGq
         4qS1YMUMNs03gNmnd6uhfy7j7YE38nm3eg4+CtL7hWYp4jyN9HafAvItjiJeG3BIoPtH
         qchCM7N3weIqIUsqrhkThJoi0/+bhfbU7o+RLyQc7PB7Z7bN1Ao5hxmI0OSRZnJ5KguT
         EGt0Vx5JgxBMZCdvhw3UD+BtmkRPzzt+ujB3FbWERxrTAW69liF0py7RUWtmAu8Mskz0
         ZiPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707190174; x=1707794974;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/Tfd5OhfoKoOciQEBeRQDfj0WyGPDWpvLlZKvDtbwOk=;
        b=CgyCCCFEU/JWXqYETJrNG9oTNMTQQ3ixGkDvbYmg9KRexSH8bCE/ez/Y6DE9c9RZjf
         fRhraeT6Iro9JKGLn0WRiAV/yWABkjbayNtpPk8uOCwGs6zDprcjgZvxswzp0ZK0nLxg
         1xbmniPlQaoAxah9/MWsqzDytalUCZFjVZaTK/wUZQsdzdIHasVINQQVrTMe2LcyS2YM
         JdDjaMfu2yKSZb6uzN3L5Mezbz9E4y5On/fuWawFsRs46A/ym2QnvPUTAxp+e1nfn/jm
         O5+/p6lvZMhPYUs04Bxi4sDcxXnnrjQ2xzxUl4DfKpYW19JyE/x8dUNC/x2JwuKWC9iH
         HuUA==
X-Gm-Message-State: AOJu0Yxcg+D8uQqbdMEiZPEZL5npOADAKAHYZgO2AkiHJ00jb32W/qja
	I9smJqLcMOjLY0Wn5wYdFNsQDeZZBYA2UIy3JSixTZbfguMtEqzsvSKtAIRE+J8a3PA0T3isSCI
	lXA==
X-Google-Smtp-Source: AGHT+IFGKs7rwk/xOH6e9m0tOkG5KkbLAalcPqOVjHui+Z6DsE6kZ01uHKZEANcR0800iNMQT8Is5W6Gv14=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:160d:b0:dc2:1f34:fac4 with SMTP id
 bw13-20020a056902160d00b00dc21f34fac4mr139109ybb.2.1707190174210; Mon, 05 Feb
 2024 19:29:34 -0800 (PST)
Date: Mon, 5 Feb 2024 19:29:32 -0800
In-Reply-To: <ZRpiXsm7X6BFAU/y@infradead.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230911021637.1941096-1-stevensd@google.com> <ZRZeaP7W5SuereMX@infradead.org>
 <ZRb2CljPvHlUErwM@google.com> <ZRpiXsm7X6BFAU/y@infradead.org>
Message-ID: <ZcGnnIJNPG-nGAND@google.com>
Subject: Re: [PATCH v9 0/6] KVM: allow mapping non-refcounted pages
From: Sean Christopherson <seanjc@google.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: David Stevens <stevensd@chromium.org>, Yu Zhang <yu.c.zhang@linux.intel.com>, 
	Isaku Yamahata <isaku.yamahata@gmail.com>, Zhi Wang <zhi.wang.linux@gmail.com>, 
	kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Sun, Oct 01, 2023, Christoph Hellwig wrote:
> On Fri, Sep 29, 2023 at 09:06:34AM -0700, Sean Christopherson wrote:
> > With the cleanups done, playing nice with non-refcounted paged instead of outright
> > rejecting them is a wash in terms of lines of code, complexity, and ongoing
> > maintenance cost.
> 
> I tend to strongly disagree with that, though.  We can't just let these
> non-refcounted pages spread everywhere and instead need to fix their
> usage.

Sorry for the horrifically slow reply.

Is there a middle ground somewhere between allowing this willy nilly, and tainting
the kernel?  I too would love to get the TTM stuff fixed up, but every time I look
at that code I am less and less confident that it will happen anytime soon.  It's
not even clear to me what all code needs to be touched.

In other words, is there a way we can unblock David and friends, while still
providing a forcing function of some kind to motivate/heckle the TTM (or whatever
is making the allocations) to change?
