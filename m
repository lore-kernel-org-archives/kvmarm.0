Received: from mail-qv1-f47.google.com (mail-qv1-f47.google.com [209.85.219.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EE924C92
	for <kvmarm@lists.linux.dev>; Thu, 26 Jan 2023 18:48:22 +0000 (UTC)
Received: by mail-qv1-f47.google.com with SMTP id w15so2091566qvs.11
        for <kvmarm@lists.linux.dev>; Thu, 26 Jan 2023 10:48:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=fLH9ZOdoHg45jBV1eKjgkwHfBSZHq3Fv8D656dUUk8U=;
        b=BNszFWlK8L8U+KvFYgcxSUMvY6w1qZtFEo3oCwBYKvUNMRnJNJA981K6Z2FoNYgCf7
         vo1fS3JSO0BjUlJuJP0fTLwRsYP4LME7XbEC5XOI6lF8gPrbppM9EgPt3koVxA8ue+au
         tNZznReFTuKLXlwvivRi9HFmrs0DHaQUCHnJqhFzqcUfREHzjIbJYcX8ecfmLSsyXmau
         VnoguBqR2bdoCMHu+uuI6xornb7KADYdeSKarCBX6xWPbkt838cuspB8vA1NRtmFe5Ep
         QvL1ar1LmnoTYnU4QE6guuwVtbEfJz/NncEAOoyDFH+iAiFUCv7IV/qT57Qg1Y63hb4s
         z08Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=fLH9ZOdoHg45jBV1eKjgkwHfBSZHq3Fv8D656dUUk8U=;
        b=ddx1j/SzaGaD3EjRQp3MOy5hwEUG9e8GtLGV6Vmo9F64zzOiP2DSfAhq95ODc/kAGI
         oas44/wbd5iRXxXSMRDXB2DfYd8nURWZ74wn/e+hTCEQWLehkp0T75mF4GA7pOrF3ZK9
         5LpmmxenqJuthcyEF7eySFdSzN/1TPtiN2iAMQarBXL7yjLx0AKYVclExdUO+sfEd8q+
         zZnL7sLhBK/X/FceYIbGuUc/dREU7OnRFRusC4zl57Kk0pKSiOpawYD4fnZ9gXO0GK/4
         T3BI4ncrtWVr2cu+SZxlq3b/wI1VvO+0hnrFEm3X7Qd+2ND8cEYKaRMXid4FYanlFBiz
         0lXQ==
X-Gm-Message-State: AFqh2ko9shTejjrRGYriyKe5f39APoW6esf7val3h+pbD4HugwU0kSwV
	Tw0bRSwPvyEY3GmQ+LVYnJvFxOO8YSXrdxvw7F9KFA==
X-Google-Smtp-Source: AMrXdXt20RB4jLbYdrJWSTj9ty03RzsBeJcJ+4p613qpaI+wgC//hYtkxEVQJ0kZvKw6hAfWJQ5k8Nm46g1E9S80vW4=
X-Received: by 2002:a05:6214:3381:b0:4c7:4573:563 with SMTP id
 mv1-20020a056214338100b004c745730563mr2241875qvb.1.1674758901064; Thu, 26 Jan
 2023 10:48:21 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230113035000.480021-1-ricarkol@google.com> <20230113035000.480021-2-ricarkol@google.com>
 <CANgfPd9gMoR=F3uKhDtjsUV0efuoNvCLV0o0WoJKm9zx_PaKsQ@mail.gmail.com>
 <Y88sq1cQUzVj9B4D@google.com> <Y9AIMtJEgEjoVWQA@google.com> <CANgfPd94DiuhuU7FhAWgPYDcR_YgJC91ORiTtZY2LEuB8Wno7g@mail.gmail.com>
In-Reply-To: <CANgfPd94DiuhuU7FhAWgPYDcR_YgJC91ORiTtZY2LEuB8Wno7g@mail.gmail.com>
From: Ricardo Koller <ricarkol@google.com>
Date: Thu, 26 Jan 2023 10:48:10 -0800
Message-ID: <CAOHnOry+HpotsEbp35L3XhU=pZtZoO3JtbZRvTJAhFWhXqHUwg@mail.gmail.com>
Subject: Re: [PATCH 1/9] KVM: arm64: Add KVM_PGTABLE_WALK_REMOVED into ctx->flags
To: Ben Gardon <bgardon@google.com>
Cc: Oliver Upton <oliver.upton@linux.dev>, pbonzini@redhat.com, maz@kernel.org, 
	yuzenghui@huawei.com, dmatlack@google.com, kvm@vger.kernel.org, 
	kvmarm@lists.linux.dev, qperret@google.com, catalin.marinas@arm.com, 
	andrew.jones@linux.dev, seanjc@google.com, alexandru.elisei@arm.com, 
	suzuki.poulose@arm.com, eric.auger@redhat.com, gshan@redhat.com, 
	reijiw@google.com, rananta@google.com, ricarkol@gmail.com
Content-Type: text/plain; charset="UTF-8"

On Tue, Jan 24, 2023 at 10:00 AM Ben Gardon <bgardon@google.com> wrote:
>
> On Tue, Jan 24, 2023 at 8:32 AM Ricardo Koller <ricarkol@google.com> wrote:
> >
> > On Tue, Jan 24, 2023 at 12:56:11AM +0000, Oliver Upton wrote:
> > > On Mon, Jan 23, 2023 at 04:51:16PM -0800, Ben Gardon wrote:
> > > > On Thu, Jan 12, 2023 at 7:50 PM Ricardo Koller <ricarkol@google.com> wrote:
> > > > >
> > > > > Add a flag to kvm_pgtable_visit_ctx, KVM_PGTABLE_WALK_REMOVED, to
> > > > > indicate that the walk is on a removed table not accesible to the HW
> > > > > page-table walker. Then use it to avoid doing break-before-make or
> > > > > performing CMOs (Cache Maintenance Operations) when mapping a removed
> > > >
> > > > Nit: Should this say unmapping? Or are we actually going to use this
> > > > to map memory ?
> > >
> > > I think the *_REMOVED term feels weird as it relates to constructing a
> > > page table. It'd be better if we instead added flags to describe the
> > > operations we intend to elide (i.e. CMOs and TLBIs).
> >
> > What about KVM_PGTABLE_WALK_ELIDE_BBM and KVM_PGTABLE_WALK_ELIDE_CMO?
>
> I like this, but please don't use elide in the code. I'm all for
> vocabulary, but that's not a common enough word to expect everyone to
> know. Perhaps just SKIP?

No problem, SKIP should be fine.

>
> >
> > > That way the
> > > implementation is generic enough that we can repurpose it for other use
> > > cases.
> >
> > Aha, good point. I actually have a use case for it (FEAT_BBM).
> >
> > >
> > > --
> > > Thanks,
> > > Oliver
