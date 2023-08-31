Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53E8B5399
	for <kvmarm@lists.linux.dev>; Thu, 31 Aug 2023 21:18:21 +0000 (UTC)
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-594e1154756so15210037b3.2
        for <kvmarm@lists.linux.dev>; Thu, 31 Aug 2023 14:18:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1693516700; x=1694121500; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=YO6r55IA8eElX5w/+X8zOZmT73jh5i8DqE52ZxJWYQc=;
        b=guXnkcDNIx1XMysszhmhJL6plHIPzL6SW7QHZxEbAQGuDfgO5T4dxQzggbuRVn3rYg
         ODxtVEaMS5SG5XuAF0I+wETnGGpKpEZVuzu2kcrCXQvcjUge/cuE2Yn431SHOmzHdt1Y
         f7EhgQf5dKTU2UbS5j3tROjjLrBvwVzePpyn6Xx5d7hPgN0bojtmhNWGrXeDXDITF78V
         U0b/609DkUAxEdUMkY9Zl6JsSqw2/hbSmE5fghb5Ly2eWuuqDLy+8Rs6QS+wARKiRcRR
         LjkmlrIED9h1F+a9ztB+CJoilu44iHWDoa5d8FCI8aET+kr8+aHipghudlkK+lXZASDX
         i67A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693516700; x=1694121500;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=YO6r55IA8eElX5w/+X8zOZmT73jh5i8DqE52ZxJWYQc=;
        b=LJyKQHnNymMsAwrD31FW9r7Oq0gwOCrdJo+ZWa0sjvVxfGmZn61jHw2fKUJybYSK4b
         RDgJQ7qVx/mu4XFzeyiZYdW+dAOn+luwhlD9+yOCK/r5+pDBDzDsL2rYsqSYF/tBoHfn
         QaUHTku9KhiF7irs3UYeCEX5nFtd5RR8Tl0OH+rHc+E5gmb8ShbSsT65DEKUQEbUxGiI
         Dj6IekvSKLFRpzRjkt51OlsYc0aYa+tFVUn0bbuegd8I4UHxOhmyiLpwWEaPKKjVfj4/
         3zSzDryq1YYwfHayBOopYMXvi7xVg4SkaWHAbUMXruTUu66CN1ltK7wRErN9u54jL3dT
         WooQ==
X-Gm-Message-State: AOJu0Yy9A/31plTTuvchdMNJZT9WcuMCuNuF8Z/CrbHwnzwrmznTvgSP
	qG3fMqHFXKmTcvYJPXzYb4q8472ohnY=
X-Google-Smtp-Source: AGHT+IEZwzQUuTI7C6FFX7BSq8V52BjhaRfu7MbpFPM/CoSsWVx5jFl7L8T8aMfs6TbWHc+jUHpp1k/u52U=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:690c:721:b0:586:5d03:67c8 with SMTP id
 bt1-20020a05690c072100b005865d0367c8mr16211ywb.3.1693516700041; Thu, 31 Aug
 2023 14:18:20 -0700 (PDT)
Date: Thu, 31 Aug 2023 14:18:18 -0700
In-Reply-To: <CAD=HUj6XYKGgRLb2VWBnYEEH9YQUMROBf2YBXaTOvWZS5ejhmg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230704075054.3344915-1-stevensd@google.com> <20230704075054.3344915-6-stevensd@google.com>
 <20230705102547.hr2zxkdkecdxp5tf@linux.intel.com> <CAD=HUj7F6CUNt_9txEu0upB=PBwJzkL5dBhNs_BVHX1cicqBgw@mail.gmail.com>
 <ZOd0IMeKSkBwGIer@google.com> <CAD=HUj6XYKGgRLb2VWBnYEEH9YQUMROBf2YBXaTOvWZS5ejhmg@mail.gmail.com>
Message-ID: <ZPEDmnloiOs/HNr+@google.com>
Subject: Re: [PATCH v7 5/8] KVM: x86/mmu: Don't pass FOLL_GET to __kvm_follow_pfn
From: Sean Christopherson <seanjc@google.com>
To: David Stevens <stevensd@chromium.org>
Cc: Yu Zhang <yu.c.zhang@linux.intel.com>, Marc Zyngier <maz@kernel.org>, 
	Michael Ellerman <mpe@ellerman.id.au>, Peter Xu <peterx@redhat.com>, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, 
	kvm@vger.kernel.org
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Aug 25, 2023, David Stevens wrote:
> On Fri, Aug 25, 2023 at 12:15=E2=80=AFAM Sean Christopherson <seanjc@goog=
le.com> wrote:
> >
> > On Thu, Aug 24, 2023, David Stevens wrote:
> > > On Wed, Jul 5, 2023 at 7:25=E2=80=AFPM Yu Zhang <yu.c.zhang@linux.int=
el.com> wrote:
> > > >
> > > > On Tue, Jul 04, 2023 at 04:50:50PM +0900, David Stevens wrote:
> > > > > @@ -4529,7 +4540,8 @@ static int kvm_tdp_mmu_page_fault(struct kv=
m_vcpu *vcpu,
> > > > >
> > > > >  out_unlock:
> > > > >       read_unlock(&vcpu->kvm->mmu_lock);
> > > > > -     kvm_release_pfn_clean(fault->pfn);
> > > >
> > > > Yet kvm_release_pfn() can still be triggered for the kvm_vcpu_maped=
 gfns.
> > > > What if guest uses a non-referenced page(e.g., as a vmcs12)? Althou=
gh I
> > > > believe this is not gonna happen in real world...
> > >
> > > kvm_vcpu_map still uses gfn_to_pfn, which eventually passes FOLL_GET
> > > to __kvm_follow_pfn. So if a guest tries to use a non-refcounted page
> > > like that, then kvm_vcpu_map will fail and the guest will probably
> > > crash. It won't trigger any bugs in the host, though.
> > >
> > > It is unfortunate that the guest will be able to use certain types of
> > > memory for some purposes but not for others. However, while it is
> > > theoretically fixable, it's an unreasonable amount of work for
> > > something that, as you say, nobody really cares about in practice [1]=
.
> > >
> > > [1] https://lore.kernel.org/all/ZBEEQtmtNPaEqU1i@google.com/
> >
> > There are use cases that care, which is why I suggested allow_unsafe_km=
ap.
> > Specifically, AWS manages their pool of guest memory in userspace and m=
aps it all
> > via /dev/mem.  Without that module param to let userspace opt-in, this =
series will
> > break such setups.  It still arguably is a breaking change since it req=
uires
> > userspace to opt-in, but allowing such behavior by default is simply no=
t a viable
> > option, and I don't have much sympathy since so much of this mess has i=
ts origins
> > in commit e45adf665a53 ("KVM: Introduce a new guest mapping API").
> >
> > The use cases that no one cares about (AFAIK) is allowing _untrusted_ u=
serspace
> > to back guest RAM with arbitrary memory.  In other words, I want KVM to=
 allow
> > (by default) mapping device memory into the guest for things like vGPUs=
, without
> > having to do the massive and invasive overhaul needed to safely allow b=
acking guest
> > RAM with completely arbitrary memory.
>=20
> Do you specifically want the allow_unsafe_kmap breaking change? v7 of
> this series should have supported everything that is currently
> supported by KVM, but you're right that the v8 version of
> hva_to_pfn_remapped doesn't support mapping
> !kvm_pfn_to_refcounted_page() pages. That could be supported
> explicitly with allow_unsafe_kmap as you suggested,

I think it needs to be explicit, i.e. needs the admin to opt-in to the unsa=
fe
behavior.
