Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DF9A10A05
	for <kvmarm@lists.linux.dev>; Tue, 13 Feb 2024 03:44:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707795898; cv=none; b=J9RS6g+WIQ8a1jLwCFz7k6U/lTh7LqTAME75ykmESlN+scQ29FdCU6RqEiUwvyY/yWfgEx29oT0n6vchSciHrJLJaTVZPNtLi8xsoC962fGu8izQD4F/xnu8eE+V8/U6QfWMSMmg773vJ9LRW9y7sj5rrKVHc3YZrlgILEFXjSo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707795898; c=relaxed/simple;
	bh=JwAyQWe7miwq6SVX7IfW52aLND0+2gi89T9lvHbisTo=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=n2qIpUPlioCj7qFWWwVho0wrXmVSuf55xnF0lDeG0ltYTG4b3QHEzllQHuQYoQQ6uKjW27thQXs3xjkCOmzYtWF+EK/HpU36S7C/5ATYRJRxzAaNm+Hp3/Hf8QnZ49QEMAau6INOhBh2hq7cBO758MfY48hQlXSa2Jeu3oxnS1I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=H3oTRoHW; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="H3oTRoHW"
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-5dc148f91faso4857515a12.0
        for <kvmarm@lists.linux.dev>; Mon, 12 Feb 2024 19:44:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1707795896; x=1708400696; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Gp/byxLraC807sITtGRawodDTA1fNMfQwGWNUUbWF5s=;
        b=H3oTRoHWntmvMmVr/I9YGeVZn5HtYwfhfjnP1BmU18yYxewdTiGK3UtxjIZ6Ycfbp4
         odSg5TIfO9StLrRzbvxic+Oct1B6LLesat1sx0NpXwzjunro4eWTnU74ybibYqB5zlu4
         8lYmfIPTNvQhn7xhbvm/RCLz166UKJQFqQPT1ZzYICyr4hrCmzSEBzQJjljAgbnmpdWJ
         Y5OKOLAGvr5oto3hOkOFVhMf7X08DqwtHYSRmuyQRYAvW8GoeNznjWbjBobWsEJRxoq6
         nJTUIuGQIg/KK5hnzjOMqeT0tvrBcxQ5NsU2cvOI3bEOAak4enCCrNyyK/FC44U3PuSq
         eIpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707795896; x=1708400696;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Gp/byxLraC807sITtGRawodDTA1fNMfQwGWNUUbWF5s=;
        b=i5+Ae2Uuh2n1KPJR09mjrdxXClaNIHtCtBVOJAf+IwxrwPzGJRRYVLNr/xiU2RKsM8
         6uC4eODnRvbSLolkhdNwuFk6eRqtKqVYT3ifBUTulRxIz/SLhtBdM6Ssx3hsdBkY4RD8
         EGE+KaIBZuyqSCVptTjVwUzriP09gx0PAfiVLoU19a3/nHDBZbezRNRTLewRVhhsK6gI
         r8wQNn8u65sUN3f3AkcX1MFGFBIyOrWc+qH13RMORuxzD1DZVYF2CHJuQs87GZdDvx2f
         3ssHdG05Nuu50qpohPUH04eVtxL3rFvVjOVUbvmD9sdQW4ICepvLz3ERlvnIhwuSC1MU
         np0g==
X-Forwarded-Encrypted: i=1; AJvYcCXTTFMezGdnHOuJdAP2qUlrty1XyFZ19D9/tQ96+WPr7gQsOmYHwPfpyNS3F4fy0f7VYwqPj1oCCc/NParvtOvClz7uTA3S
X-Gm-Message-State: AOJu0YyWNPCKWKhi0lBGsMOeX1E1y/6cQEVO2J9Zpp3NPqJKGv4vT1zn
	xTgqjV/ixHu4AM+gYDIRf4M2PhVzzxllJQ87qaQs8vMmic2eLEM7Fb4oqRs2uqcykUnJvYRquwu
	G0Q==
X-Google-Smtp-Source: AGHT+IGGI8Fty4SnswScI0YALjv0to7a7pfcE8bH+CFvNEGLJ/DcJmrEz5SnXPWzfMn3EDSiz3p6QME0aDg=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a65:6e85:0:b0:5d8:af18:eee0 with SMTP id
 bm5-20020a656e85000000b005d8af18eee0mr107250pgb.12.1707795896559; Mon, 12 Feb
 2024 19:44:56 -0800 (PST)
Date: Mon, 12 Feb 2024 19:44:55 -0800
In-Reply-To: <20230911021637.1941096-3-stevensd@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230911021637.1941096-1-stevensd@google.com> <20230911021637.1941096-3-stevensd@google.com>
Message-ID: <Zcrlt0xHdRubEDLJ@google.com>
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

Belated question: why is there no kvm_follow_pfn()?
