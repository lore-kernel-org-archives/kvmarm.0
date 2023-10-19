Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F72C14F90
	for <kvmarm@lists.linux.dev>; Thu, 19 Oct 2023 18:05:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="igBtlNjr"
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-1c9d4f08d7cso20565ad.0
        for <kvmarm@lists.linux.dev>; Thu, 19 Oct 2023 11:05:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1697738729; x=1698343529; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=X79WPuk0kI/Em6qMbs24oISDzyvT6ZbjodD9ilXj+Jg=;
        b=igBtlNjrL+KbZ7Nba3tWO1KNZdWe/CcEC4xWoJj7e8OZV0XmZDwNMYYm1iMiTpNcuR
         bEuDrou82POPEjPiYHmtXrBS9AFL4iUQRkpjVI1n8b5QwKauWQg8mm3/raGZZCg/XRR3
         V6756AQRwonmC34YYSvdzXpMTeP6m8QQd/m635d1jKemnN9J+R/E7uNsBtwvtO8bXcv9
         kNEq0i1K/D992uSB6HGsv6/j20qoaBo1/9CwEb9A9707xkhiLAg4JXrUWkZTw7MHg2Ci
         Z4mddsDWvo14FlZeCrInFcP6FHXXqi6vWJtlmqBTBKZOCkpdaqHGyBzVWzc2/hCmoHjv
         vf6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697738729; x=1698343529;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=X79WPuk0kI/Em6qMbs24oISDzyvT6ZbjodD9ilXj+Jg=;
        b=OTkKdjDXN4ii5JdrASybsQeXiEKAk/4NC8JzFVEyByjrc57ADT5oyJvrfCj3g2Ior+
         TlVOOIPC+jvGhQSb7yqDxFIJAAJaCRFzky+L/GgRgZQxTVD/YwQSCv9NRzAIvnHOolHJ
         XFbhXP8kBKAKFJZVE7YdiZPPQazjrzexerPlopyyVWbPglWUC+VxrJ3aWpWtGDTFeuA/
         XBd5CxtUECxkNAIRZuGfnJxeowUkCIA5t+kzpQc1JlREuihIw8Xl7ZrJ26zz24gQQzuL
         HKZh/8S2Ox42Ca5/UFMFhk1g3OUcJA7uVnuGk5G+UZsQ5pRdWfmP1tfzTFE6TI8eWxfL
         IAgg==
X-Gm-Message-State: AOJu0Yx7NSrVwE7QXFs1d+27xwgwJmHHQHpTHktZz9jnwNTG67U0r8PA
	LdIv5eecnrBO/M+O5NcLUtBKlnVYn9z87GOHp3ohAQ==
X-Google-Smtp-Source: AGHT+IGPFLME4RoxjHjo1Pf3PTYmSxKaORuw3AAyosh0yvejALLkHkk75EQDfaXWAFN6tu+Lh+D7VkjaPKVDnv/kJOo=
X-Received: by 2002:a17:902:ebc4:b0:1c4:1392:e4b5 with SMTP id
 p4-20020a170902ebc400b001c41392e4b5mr5130plg.21.1697738729250; Thu, 19 Oct
 2023 11:05:29 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20231009230858.3444834-1-rananta@google.com> <20231009230858.3444834-9-rananta@google.com>
 <5d35c9f3-455e-6aa9-fd6a-4433cf70803a@redhat.com> <CAJHc60z7U1-irTy-6URb_V0PTW+TYS4qodf2akSg33_7CJgjyw@mail.gmail.com>
 <f7cd9b3d-c817-7082-d60a-a529e1c82f1e@redhat.com>
In-Reply-To: <f7cd9b3d-c817-7082-d60a-a529e1c82f1e@redhat.com>
From: Raghavendra Rao Ananta <rananta@google.com>
Date: Thu, 19 Oct 2023 11:05:17 -0700
Message-ID: <CAJHc60xJs+NzjfG_ESvQuyYdV0bDSwAetuam7yO35FOZBBJ9fQ@mail.gmail.com>
Subject: Re: [PATCH v7 08/12] KVM: arm64: PMU: Allow userspace to limit
 PMCR_EL0.N for the guest
To: Sebastian Ott <sebott@redhat.com>
Cc: Oliver Upton <oliver.upton@linux.dev>, Marc Zyngier <maz@kernel.org>, 
	Alexandru Elisei <alexandru.elisei@arm.com>, James Morse <james.morse@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Shaoqin Huang <shahuang@redhat.com>, 
	Jing Zhang <jingzhangos@google.com>, Reiji Watanabe <reijiw@google.com>, 
	Colton Lewis <coltonlewis@google.com>, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Oct 19, 2023 at 3:45=E2=80=AFAM Sebastian Ott <sebott@redhat.com> w=
rote:
>
> On Tue, 17 Oct 2023, Raghavendra Rao Ananta wrote:
> > On Tue, Oct 17, 2023 at 8:52=E2=80=AFAM Sebastian Ott <sebott@redhat.co=
m> wrote:
> >>
> >> On Mon, 9 Oct 2023, Raghavendra Rao Ananta wrote:
> >>> +static int set_pmcr(struct kvm_vcpu *vcpu, const struct sys_reg_desc=
 *r,
> >>> +                 u64 val)
> >>> +{
> >>> +     struct kvm *kvm =3D vcpu->kvm;
> >>> +     u64 new_n, mutable_mask;
> >>> +
> >>> +     mutex_lock(&kvm->arch.config_lock);
> >>> +
> >>> +     /*
> >>> +      * Make PMCR immutable once the VM has started running, but do
> >>> +      * not return an error (-EBUSY) to meet the existing expectatio=
ns.
> >>> +      */
> >>
> >> Why should we mention which error we're _not_ returning?
> >>
> > Oh, it's not to break the existing userspace expectations. Before this
> > series, any 'write' from userspace was possible. Returning -EBUSY all
> > of a sudden might tamper with this expectation.
>
> Yes I get that part. What I've meant is why specifically mention -EBUSY?
> You're also not returning -EFAULT nor -EINVAL.
>
> /*
>   * Make PMCR immutable once the VM has started running, but do
>   * not return an error to meet the existing expectations.
>   */
> IMHO provides the same info to the reader and is less confusing
>
Sounds good. I'll apply this.

Thank you.
Raghavendra
> Sebastian
