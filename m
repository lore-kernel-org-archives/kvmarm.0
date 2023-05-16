Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B99F2290ED
	for <kvmarm@lists.linux.dev>; Tue, 16 May 2023 18:55:08 +0000 (UTC)
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-1aaf702c3ccso15625ad.1
        for <kvmarm@lists.linux.dev>; Tue, 16 May 2023 11:55:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1684263308; x=1686855308;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8fHu8DghP/3luSr7ps7cBkVA14o+LEPwp4DzxgOICm0=;
        b=usz2QifQhrDsMFHeiiL1u29LHuzqrTOI0tFmKe8GfDAPSZJxTJWBt+zc1wlWKPyj9p
         n/pJumNjR2nAeqfSG+/wYqDLQMHQynaueKj5E8dNBiXX0r+qbvksVJe/b16j+viG5hwY
         k7xjeZEKvgf1ioPAhlyNOtn4rvrDR5Ws8akdUl9WpLUvVWhMefeD4qEP2R0+XntalOsb
         8TKWDFIMJKoigBAjHZH5xtMHdAh6DZuzWdEkRHOZ0uAkTiowziW5BPDCL4aigWjm3lRx
         fcjn2+snxNbj1VflUrRVz30fl0Gj1tE/M2vPQmDfgifEK6m2NjIun7OQL3UMm7OxzMel
         gn/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684263308; x=1686855308;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8fHu8DghP/3luSr7ps7cBkVA14o+LEPwp4DzxgOICm0=;
        b=hCvvr4sa+Jjz+ug/JblsSUiPuQrUu8mvcATrcEozzbX1stvCbUY3VmjPR1XXn58BW7
         Pa3dFff8EZn2/jAdVbF8fr0G5ukc+uIIOlr6obDYpEDwJ307dK8CNyopc1uzXX2VCnW2
         LZe00UxdZBiHHE+z/Wsu1UOdXfegGLA3wRm6nBf75uE6nuv/4W9XKWNcHZqWSvD5a23W
         lsqdJmJNE2cvS45rKIT8dvDC30nDDLvDO0izgWzTzr8RonR759bxANSzo+/yS5nHGpJc
         Fi7LOuY4YjSa9mdrBLZcxLaqGiCkZIAUV39dGYr6s/OztESu3/RT0C4VH6EMLylpTi72
         zTYQ==
X-Gm-Message-State: AC+VfDxTEA6oKcbxlmXzGxVeyq/7bo5e7uEb6Ul0oKjVzzZMfwus1HnR
	TcgvF2D3dBNHYStk1WcH5nRNp2FbXxgjgcBdBOf/mQ==
X-Google-Smtp-Source: ACHHUZ7tZ09F/p3tKg+e7V/wH7ylAcrEIIFRoV+uNHj0vk7rLne7WYSwiuVG8QKXQ1XXx7qqfBebFzGe81h5v2o/EMM=
X-Received: by 2002:a17:902:dac6:b0:1ac:2daf:34da with SMTP id
 q6-20020a170902dac600b001ac2daf34damr3858plx.17.1684263307150; Tue, 16 May
 2023 11:55:07 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230414172922.812640-1-rananta@google.com> <20230414172922.812640-8-rananta@google.com>
 <ZF5xLrr2tEYdLL1i@linux.dev> <CAJHc60wUu3xB4J8oJ+FCxerDad1TzZLCMgHYGFfv0K-hzC0qmw@mail.gmail.com>
 <ZGPPj1AXS0Uah2Ug@linux.dev>
In-Reply-To: <ZGPPj1AXS0Uah2Ug@linux.dev>
From: Raghavendra Rao Ananta <rananta@google.com>
Date: Tue, 16 May 2023 11:54:55 -0700
Message-ID: <CAJHc60wF19h9ixEQK5SS+oGA41xNqrFQaH9VE6sS0DXjQFCh7A@mail.gmail.com>
Subject: Re: [PATCH v3 7/7] KVM: arm64: Use TLBI range-based intructions for unmap
To: Oliver Upton <oliver.upton@linux.dev>
Cc: Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Ricardo Koller <ricarkol@google.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, Jing Zhang <jingzhangos@google.com>, 
	Colton Lewis <coltonlewis@google.com>, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, May 16, 2023 at 11:46=E2=80=AFAM Oliver Upton <oliver.upton@linux.d=
ev> wrote:
>
> On Tue, May 16, 2023 at 10:21:33AM -0700, Raghavendra Rao Ananta wrote:
> > On Fri, May 12, 2023 at 10:02=E2=80=AFAM Oliver Upton <oliver.upton@lin=
ux.dev> wrote:
> > > >  int kvm_pgtable_stage2_unmap(struct kvm_pgtable *pgt, u64 addr, u6=
4 size)
> > > >  {
> > > > +     int ret;
> > > > +     struct stage2_unmap_data unmap_data =3D {
> > > > +             .pgt =3D pgt,
> > > > +             /*
> > > > +              * If FEAT_TLBIRANGE is implemented, defer the indivi=
dial PTE
> > > > +              * TLB invalidations until the entire walk is finishe=
d, and
> > > > +              * then use the range-based TLBI instructions to do t=
he
> > > > +              * invalidations. Condition this upon S2FWB in order =
to avoid
> > > > +              * a page-table walk again to perform the CMOs after =
TLBI.
> > > > +              */
> > > > +             .skip_pte_tlbis =3D system_supports_tlb_range() &&
> > > > +                                     stage2_has_fwb(pgt),
> > >
> > > Why can't the underlying walker just call these two helpers directly?
> > > There are static keys behind these...
> > >
> > I wasn't aware of that. Although, I tried to look into the
> > definitions, but couldn't understand how static keys are at play here.
> > By any chance are you referring to the alternative_has_feature_*()
> > implementations when checking for cpu capabilities?
>
> Ah, right, these were recently changed to rely on alternative patching
> in commit 21fb26bfb01f ("arm64: alternatives: add alternative_has_feature=
_*()").
> Even still, the significance remains as the alternative patching
> completely eliminates a conditional branch on the presence of a
> particular feature.
>
> Initializing a local with the presence/absence of a feature defeats such
> an optimization.
>
Thanks for the info! Introduction of stage2_unmap_defer_tlb_flush()
(in patch-7/7) would call these functions as needed and get rid of
'skip_pte_tlbis'.

- Raghavendra
> --
> Thanks,
> Oliver
