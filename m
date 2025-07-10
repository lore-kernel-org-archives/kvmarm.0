Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A49ED8479
	for <kvmarm@lists.linux.dev>; Thu, 10 Jul 2025 00:20:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752106829; cv=none; b=Wnn+qmKnV+QvGxRF37OKkWVLhIjTpDTHzRtQgbZAtbDtZhup+zVkKyj9YIxIX21ByATxi4p6CqCOFF6alartjeNUybZPLnf6/4UJdKOosq6Xa1bzNcuKzAGAbt0Myq+O8Nz6D4dfXNEy5MqgQ6WkDmtWYNi6f20V9GoZiEQsGig=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752106829; c=relaxed/simple;
	bh=ERDmFUvZl+DHp7ZMqEbyj24/hS2CDCoVaMw2kOxKPhg=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=cmMnGV8sPiwMHm9aKfbPZ3f2rXXcCYiPvLNs1Y8vA8rT6P3iHjQnZpvX7+2k4WDOPRuCM/7IKGtRPUrXEFRWf5V6grc3y5MD0eHTkto/Js6EFndGfIdV/ohGfxeXiatr+KFxJbco2UAy/JlYxosyeQ/YHe7JfFArarAWpyAlkAQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=IesoSDVO; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="IesoSDVO"
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-31215090074so792104a91.0
        for <kvmarm@lists.linux.dev>; Wed, 09 Jul 2025 17:20:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1752106827; x=1752711627; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Dc+RqRq+W6sCtPNEa/tVWodO3UqzUt3YwAEia9IzCeQ=;
        b=IesoSDVOiwMaJZwpjBYKEt3sNAJmGKgNBvK2RHZ7+12yvXvEVpJxgvC4NgJc2if5Yk
         kfHcAk+N5kFWoASRF/DUq3L+edYCT1zbb5MjTC0D3yZhNXQNIiyDHlt7A2h9b7xVFAd7
         rxV6sFMCboJlv0W1yhR6YTG5CXTRPxxPus6dBj1keCV+rqy8K2RVNgkkn4+kNg55Myb/
         sBb0seWQbnPfD0/ZjFRDwJTUVHx1zKihtLxsJBbG3Ehu0xujEPe1HuYcu/PxSmTDv5Ni
         pEv1++WrMsc9N15Dj19S0nouwuNAxhMp1OFJ+nwydZ3DBmyN0Bj3f04cG6ruXpgLc/R6
         ULlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752106827; x=1752711627;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Dc+RqRq+W6sCtPNEa/tVWodO3UqzUt3YwAEia9IzCeQ=;
        b=K4RmQUEEsgvDmaD+kAq/ThD5QEs+HtPWbijUddZfwOyS8QFE1H6gOpS6fGnYWo6QkZ
         WWF0Suzt5scHmPS0etgRH3m9NZ23mYlONy4QoimgGcxiWaecCmROp9BLtdPPQdKaTK5/
         38B6oUF30RpaeSF/nxYy94O7GFFH2vkHYcc734mJQ8op2OqeZ9SVuME4GTvki1e0XFEO
         eakzw4HqX3ZoYbIx0/ZQG4q1jnddu8tN15T3vBcekNOWaoAscV7AzegJulBukP3doOul
         SivjqhZX9cd1hyzxBPV76n9XgiVazOoA48toY2++yG8nzbfXB9vTTfM3jG+Norp0rTaJ
         7lQA==
X-Forwarded-Encrypted: i=1; AJvYcCVaD8ZLPHLjbFQgZ8Yts3ENXSG+itZ5CYMQ3/vbowAonEcOgCc57+HChkI7Mfz0Cfp6vsE28Sg=@lists.linux.dev
X-Gm-Message-State: AOJu0Yw+xv7Ec+dG2vENJuM7E8h3JAFcFXpe3zDuZLUPNHWeNEVYhzod
	2m47Yh6aEypkBJy6+aRle6L48NYmk1A5700v9cvsS7IyFSeKJ5atEd+3aMKKD+CVWVd+jke1QGQ
	sd/yTvg==
X-Google-Smtp-Source: AGHT+IG0GxjloovxJcYgMFXWq5yLXp3npn9Ujx5nQOTSIQhv0jOvc/gWF8I+wEWsfveSljef5y7J1NorZPc=
X-Received: from pjtu13.prod.google.com ([2002:a17:90a:c88d:b0:313:2d44:397b])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:28cb:b0:312:eaea:afa1
 with SMTP id 98e67ed59e1d1-31c3f05249dmr924623a91.29.1752106827053; Wed, 09
 Jul 2025 17:20:27 -0700 (PDT)
Date: Wed, 9 Jul 2025 17:20:25 -0700
In-Reply-To: <20250606235619.1841595-2-vipinsh@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250606235619.1841595-1-vipinsh@google.com> <20250606235619.1841595-2-vipinsh@google.com>
Message-ID: <aG8HSc_yj6O69Uu1@google.com>
Subject: Re: [PATCH v2 01/15] KVM: selftest: Create KVM selftest runner
From: Sean Christopherson <seanjc@google.com>
To: Vipin Sharma <vipinsh@google.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev, kvm-riscv@lists.infradead.org, 
	linux-arm-kernel@lists.infradead.org, pbonzini@redhat.com, 
	anup@brainfault.org, borntraeger@linux.ibm.com, frankja@linux.ibm.com, 
	imbrenda@linux.ibm.com, maz@kernel.org, oliver.upton@linux.dev, 
	dmatlack@google.com
Content-Type: text/plain; charset="us-ascii"

On Fri, Jun 06, 2025, Vipin Sharma wrote:
> +    parser.add_argument("--test-files",
> +                        nargs="*",
> +                        default=[],
> +                        help="Test files to run. Provide the space separated test file paths")
> +
> +    parser.add_argument("--test-dirs",
> +                        nargs="*",
> +                        default=[],
> +                        help="Run tests in the given directory and all of its sub directories. Provide the space separated paths to add multiple directories.")

Almost forgot.  My vote would be to make these easier to reference, e.g.

 -t/--testcases
 -d/--dirs

or if folks like the --test-{files,dirs} names, just add the single char shorthand?
