Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83C21A925
	for <kvmarm@lists.linux.dev>; Mon, 14 Aug 2023 23:16:56 +0000 (UTC)
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-589e3ac6d76so32207507b3.1
        for <kvmarm@lists.linux.dev>; Mon, 14 Aug 2023 16:16:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1692055015; x=1692659815;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=XJ2VqA/vSflBac203Z0ZgYzciS8CSN/YrZrCQZvgAqE=;
        b=OxYYoyUAQaeaCm0MRnDlT6YpDWZ0eDciFaHbssoRAoYyzjd2o0WDI1UOBCOxL+kMJc
         5YD0NK8r1uDf6e0Jatvt+d6P+BWzIhvUYoQQhLjByYnja3UBlbXrGoFe9hBNCSmd3Por
         77GbZptlqN3qID9Yi7OuuYNKro+YD6l9Q6jj3+sUYzoK08H9wS69cXzUBziAMKx3xld/
         w96wxOhnL73JzIXq2lGp1mV73XNcE7Ps2NUvuAohRziILKeBly43Y5qUc7dLaviqameq
         hE+kTcQyTkgYI/ntVGdkCqeR0EWDhGYDk0kgtw+nvGshr7JSpUCtOXj/qFAa5uoFZbVm
         YkSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692055015; x=1692659815;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=XJ2VqA/vSflBac203Z0ZgYzciS8CSN/YrZrCQZvgAqE=;
        b=A5OJu82rpWoFO3C0i/YfCbZFzZoHplEumZQTMhGSUkYv1uUHdyqpuCbfRSD7lMgbOd
         8dvn/Jy6qK9q+2BUIVrI3czutLl5vhvh9I+lsd87JOuyvFHJ6RGwA+xMczbTNteB7GqM
         Vdx5nrtRZkGaU13dqvBAPMCis6tkPeXP9DLeYkkkF9lF61SkZc07AABbD9x3aoy7/diq
         q7PmwshFSlmHeWJj53HiLDF1jImuXIlN+kXyqtg+8BCeexPIBVPjBYUwfoMNx2I2QTe9
         MBH6gihVAuR04sKjA7ZSFegIb8L+5iF0jWccO8GZy6VlYKMY95aUZBCqZM+T95UMdp60
         RP9g==
X-Gm-Message-State: AOJu0YzTud7jW7y++XLCgvpxJ1enmiOcVsojdMTpt1XTe3YxVurw0M64
	lKIWPRpRel9MfaTk3UoFRW4i/nj8I8k=
X-Google-Smtp-Source: AGHT+IGO0AL45xRymm0BjDJln3deMA/9LFqjImi7JInSUnl69k7Qer+RG4sudzofLCbCQa+Rdgz1TuaGB1A=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:690c:709:b0:57a:118a:f31 with SMTP id
 bs9-20020a05690c070900b0057a118a0f31mr180335ywb.7.1692055015309; Mon, 14 Aug
 2023 16:16:55 -0700 (PDT)
Date: Mon, 14 Aug 2023 16:16:53 -0700
In-Reply-To: <20230811045127.3308641-1-rananta@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230811045127.3308641-1-rananta@google.com>
Message-ID: <ZNq15SZ+53umvOfx@google.com>
Subject: Re: [PATCH v9 00/14] KVM: arm64: Add support for FEAT_TLBIRANGE
From: Sean Christopherson <seanjc@google.com>
To: Raghavendra Rao Ananta <rananta@google.com>
Cc: Oliver Upton <oliver.upton@linux.dev>, Marc Zyngier <maz@kernel.org>, 
	James Morse <james.morse@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, Huacai Chen <chenhuacai@kernel.org>, 
	Zenghui Yu <yuzenghui@huawei.com>, Anup Patel <anup@brainfault.org>, 
	Atish Patra <atishp@atishpatra.org>, Jing Zhang <jingzhangos@google.com>, 
	Reiji Watanabe <reijiw@google.com>, Colton Lewis <coltonlewis@google.com>, 
	David Matlack <dmatlack@google.com>, Fuad Tabba <tabba@google.com>, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-mips@vger.kernel.org, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, 
	kvm@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Fri, Aug 11, 2023, Raghavendra Rao Ananta wrote:
> The series is based off of upstream v6.5-rc1.

Lies!  :-)

This is based off one of the kvmarm.git topic branches (I didn't bother to figure
out which one), not v6.5-rc1.

Please try to incorporate git format-patch's "--base" option into your workflow,
e.g. I do "git format-patch --base=HEAD~$nr" where $nr is the number of patches
I am posting.

It's not foolproof, e.g. my approach doesn't help if I have a local patch that
I'm not posting, but 99% of the time it Just Works and eliminates any ambuitity.

You can also do "--base=auto", but that only does the right thing if your series
has its upstream branch set to the base/tree that you want your patches applied
to (I use the upstream branch for a completely different purpose for my dev branches).
