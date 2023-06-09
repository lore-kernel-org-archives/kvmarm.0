Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 789B1408F8
	for <kvmarm@lists.linux.dev>; Fri,  9 Jun 2023 22:58:57 +0000 (UTC)
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-3f7359a3b78so23815e9.0
        for <kvmarm@lists.linux.dev>; Fri, 09 Jun 2023 15:58:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1686351535; x=1688943535;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zhSuAAYkjO4mSfTM7j2Zrn+Ge99zKCVDXuALbQ64GlM=;
        b=aWAYDSz9kYHjivc5EPQCAcnNIQ7EsxbZzXWVqRidl3AzqgBVql3teVbl5ctpRNVQBR
         ZwBStvD1xYwTCB6hcgdnP7Qh+kVAAj/vhRhdH6KOE7mVRHzIsC5jWQxqmQ06LdBhp5Mo
         wDECzvNZeUvBgN3BgXU2RiU3qpl85v5XshXPq7sSEZAFXH+7ToDeQJ/3kwIYzE1UeIq1
         uB4TAPqNKbW3e09X+80Nfq6HWYvhGp5+mcD92iwq0TUepbI425D+SlrIhSBJv64+0gBw
         U3UpYfN+g5pDsGTtgWaWmCTkXoqCdaWFc6IgRzHUbsPDr7ZwmcRy9SU96i5ZC6VdO6+v
         B8yA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686351535; x=1688943535;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=zhSuAAYkjO4mSfTM7j2Zrn+Ge99zKCVDXuALbQ64GlM=;
        b=E56Mx5i9zZY9+nPKeNB1+znROi4IHHqBNmSknOpSNx6SSG2aqABFJW+5/ZzIdyPX76
         fbtxNZRVpxGTij2IaY63vJ+L7a/lgiyJPpQEVUQ78/IgyZg/V2emLhBbP1dPKe9QMKW/
         h6ZNtEL0HW8C0peI49YzqEcOFxWMofgjXki55InSzj4BMF4srq31G5fkCV1N5xuv34Nq
         xVwAZz/7xjckPpnPHWxOYUqHdXjeT3b0UnS2g8oe0KrdmP4KxSyBytDXkZuuYf/CIJ16
         NLfqk42pvG5NyeSBB/D9eF7SVXEw9JfUTk7wGGmU0AqyIhvjVWP0oq1mkGBDqGF6ccOT
         DYMQ==
X-Gm-Message-State: AC+VfDyQa8xynxvbifj+sCQuFVZptKc1wsukgGnZcnF5sNlYqCa34MP+
	XfIesLV7bV8EnaqwixHAFZJJ1y7wv+OPfsW5cs6n9w==
X-Google-Smtp-Source: ACHHUZ6tFSQ3jSKz6Gn6QifMsxKaOHFdz2lMG9AU9FIAwd4NiFOYvnPz9hTFf3gOv0EaPRSzfnvu1VJ8Vby/ABDofdg=
X-Received: by 2002:a05:600c:46c6:b0:3f7:e59f:2183 with SMTP id
 q6-20020a05600c46c600b003f7e59f2183mr26384wmo.5.1686351535398; Fri, 09 Jun
 2023 15:58:55 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230608220558.39094-1-ctshao@google.com> <20230608220558.39094-4-ctshao@google.com>
 <878rctnkqg.wl-maz@kernel.org>
In-Reply-To: <878rctnkqg.wl-maz@kernel.org>
From: Chun-Tse Shao <ctshao@google.com>
Date: Fri, 9 Jun 2023 15:58:44 -0700
Message-ID: <CAJpZYjVcDAU94Abx7BUV-nZeTJ88ggYs=n8gBUyRUGQ=iQWPvw@mail.gmail.com>
Subject: Re: [PATCH v1 3/3] KVM: arm64: Using rcu_read_lock() for kvm_pgtable_stage2_mkyoung()
To: Marc Zyngier <maz@kernel.org>
Cc: linux-kernel@vger.kernel.org, yuzhao@google.com, oliver.upton@linux.dev, 
	James Morse <james.morse@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>, Ben Gardon <bgardon@google.com>, Gavin Shan <gshan@redhat.com>, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Jun 9, 2023 at 12:44=E2=80=AFAM Marc Zyngier <maz@kernel.org> wrote=
:
>
> On Thu, 08 Jun 2023 23:05:41 +0100,
> Chun-Tse Shao <ctshao@google.com> wrote:
> >
> > Access bit is RCU safe and can be set without taking kvm->mmu_lock().
>
> Please explain why. What happens when the page tables are *not* RCU
> controlled, such as in the pKVM case?
>
> > Replacing existing kvm->mmu_lock() with rcu_read_lock() for better
> > performance.
>
> Please define "better performance", quote workloads, figures, HW setup
> and point to a reproducer. Please add a cover letter to your patch
> series explaining the context this happens in.

Thanks for the suggestion, we are currently working on the performance
test in parallel and will update after gathering more data.

>
> Also, I'm getting increasingly annoyed by the lack of coordination
> between seamingly overlapping patch series (this, Yu's, Anish's and
> Vipin's), all from a single company.
>
> Surely you can talk to each other and devise a coordinated approach?

Sure, I will start internal meeting as needed.

>
> Thanks,
>
>         M.
>
> --
> Without deviation from the norm, progress is not possible.

Thanks,
CT
