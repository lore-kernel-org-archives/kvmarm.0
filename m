Received: from mail-qt1-f176.google.com (mail-qt1-f176.google.com [209.85.160.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17A0915EFA6
	for <kvmarm@lists.linux.dev>; Wed, 10 Jul 2024 23:49:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720655355; cv=none; b=SPd9TcSj0qUsdiyaZBNHYQkCBEsQh2ght/lWohx4djCdjlWFreM2dk3NpLfwEDJi+XQLmnxqX1qRd36NXFHs89xnI0u7Bj73BhSclzh6q5mhGuC9a5dxXcmibohFIdLZp6PsYICqc9XsrgjrXzdRkSyhAVWRHjgvfPLPOmLGSdM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720655355; c=relaxed/simple;
	bh=WpUWnTWcQ9yZbCFEuArGMs4Fxk919PYBB/xOGitk7xM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Ll6rFYWqtLgkOkA7HSKR8WH5EanONWQ/R29YdTTt/OtRZt9fyGhys5gT2FZ6e+wIZwz0h/JiJFHWIZs1Pxqe3rebHbKrWs7rV6ayMOUUKsNbVE3bC5I0yKUE2coIGuluSXySgTfDQWZ6KeKmZVELmkX7mlHZse09CdnMLDPXhu4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=22kOsA6j; arc=none smtp.client-ip=209.85.160.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="22kOsA6j"
Received: by mail-qt1-f176.google.com with SMTP id d75a77b69052e-447df43324fso64771cf.1
        for <kvmarm@lists.linux.dev>; Wed, 10 Jul 2024 16:49:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1720655353; x=1721260153; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=WpUWnTWcQ9yZbCFEuArGMs4Fxk919PYBB/xOGitk7xM=;
        b=22kOsA6j/trIusafV05VOgNrpj1TJ3WF9MZ2DRwIl4Z1HcMNaFJ8GpJGCirMmr5fn7
         xAC7r9gr10KMqJ01WX4ncf0jZ8lVitc8basVZAVTI4H2q9p3REjLw9bCwr4DbTRRFsll
         LMTgjHpsR348ZKU9TLbff81Ja7DEmi2TIA+rLVLv3Vto8xzxGO2Km05hsg7GjRZzeksE
         SsvCx7A4W2/mZTppWMEMikGHz0am6KJge502QatNLxLAhmsZfIK7NI7L+Z7DtFcc1/TB
         7QZAU8++zaFK95nRlqxF0D+/NAZBIAp0YJWK6uK37xkDvQghDvUETpGH0Y8k2TFrsoUe
         Y9LA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720655353; x=1721260153;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=WpUWnTWcQ9yZbCFEuArGMs4Fxk919PYBB/xOGitk7xM=;
        b=XmLX3KwzLswXQUC2CCWrxP7f2r/fTnp1TVmJ0n7+bf3kOjUQEhxsxiwyJts/em3W00
         H9b2qOscCYLIiZX+Bq4T4VT9Z0yN6j1ZVOFl6BLcuemUIZpRuO275v9DVJKIhyUg1ZbU
         1wB4bRENGGpGpJW10/3GH2ZkAtBcd4pYYWj8bZ0HIzp3dZ5vvub1G5BvvIyHwrOPxqc3
         SuaV0OEPcDTlzVUGb+7FWki5YjEUkPj61T5vIc74tKWPQ+xSJ/831XTLGfZ+4DPJKkjE
         S0kCZc2Aouqq79aHAhbg5VW4+0tGBazKtkSvwWIP2nOb7vBjljO6MtvF0MF8QiPiTNDp
         2p9g==
X-Forwarded-Encrypted: i=1; AJvYcCUHOyw/rTSJXullw3LBDY+JkkaNPhdO1ZUd27KXpn+kVUOBEgkYqSfp4xXQolWnYPh/cF8L5UpY9XF38zgah1gkAlRM0VhX
X-Gm-Message-State: AOJu0YypWJIR5NLpTi/iRx+BPMzRu3w4DXHBN8ox2k6uzLibJh10uzTh
	knXP6UQF8qfNxXmZBLpRODfrZ7s2rj+ZP9gNaJHMQLHMXPjNq2nYv4FP0zGND2dFAzUEfHBfUN0
	t/0w6McQAKslYXAPJOy3vGSgVh+CZmdFcMRiA04d2BlUwwBRcDA==
X-Google-Smtp-Source: AGHT+IEuslvTU7O114maCMu6s7q1QatazKYK4Au3LHFSN1TQt2fd6q24xfMVdE/dWH6oyRO5MWqPuiKjKkMbsPD4dqw=
X-Received: by 2002:ac8:7386:0:b0:447:ec33:f488 with SMTP id
 d75a77b69052e-44d0aa4788bmr1329661cf.4.1720655352838; Wed, 10 Jul 2024
 16:49:12 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240710234222.2333120-1-jthoughton@google.com>
In-Reply-To: <20240710234222.2333120-1-jthoughton@google.com>
From: James Houghton <jthoughton@google.com>
Date: Wed, 10 Jul 2024 16:48:36 -0700
Message-ID: <CADrL8HUHRMwUPhr7jLLBgD9YLFAnVHc=N-C=8er-x6GUtV97pQ@mail.gmail.com>
Subject: Re: [RFC PATCH 00/18] KVM: Post-copy live migration for guest_memfd
To: Paolo Bonzini <pbonzini@redhat.com>, Peter Xu <peterx@redhat.com>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	James Morse <james.morse@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Sean Christopherson <seanjc@google.com>, Shuah Khan <shuah@kernel.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, David Matlack <dmatlack@google.com>, kvm@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

Ah, I put the wrong email for Peter! I'm so sorry!
