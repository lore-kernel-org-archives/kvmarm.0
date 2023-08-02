Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A570879FF
	for <kvmarm@lists.linux.dev>; Wed,  2 Aug 2023 16:10:48 +0000 (UTC)
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-d061f324d64so7183165276.1
        for <kvmarm@lists.linux.dev>; Wed, 02 Aug 2023 09:10:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1690992647; x=1691597447;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=J4aKHKt7aK1dph2vrDmFCSsCX7pNGRd0NMwM4bEJgp8=;
        b=zT0xCNei+dnr4osudv9CAX0NFIvpN9o/MM9DYDQ2quRiRk2ySEcgwiLx53XnB1e+LY
         cWfI4OmX27mBOaJ58zlzT26+ZLcNHSkLH9hi8/662YILNSSO1QkU4G145NcnSjse7Tfi
         xrBWi/aY8NG6dUaFl22owtMyugIfQwHdkO/hgFnA80wpzq4X517qJXwcuOIoXxcIvofm
         vONKX+ciK2E9BoSSjIdQ67NLAviV68y9PDQBJ3S/jrfYmNcLzOoOg269tqqWjlilRydM
         bYWsCmY8tkmpgydfPs6qY/prFitzHw68WvsqFmR4BcVKfrWapat3cp0d7IklIiRVq+z3
         Zr2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690992647; x=1691597447;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=J4aKHKt7aK1dph2vrDmFCSsCX7pNGRd0NMwM4bEJgp8=;
        b=QGMe2/QLzjbp8MBxX9H2U683ZWBNKPCQp7b5KvKU4IBYfPxf4u8fuhlrE+m32X/fcf
         Sz0fUhy4qIvKZVzqyLiutqWb8Bus1quGMZ0kpP21w21xNE1N756mqpXMV5OMinsZwyee
         e7yD2RErzkJw+yU/KnjmdBBioulFpcnJq+GzSiF7y0fb3hgDZVg0s4p83XtrsOKlK5R5
         iytZl63Mh6tbmkCG4JpqCC3wxKvNzd31/nLZ36Ydf4jMcsO14CZsALp8drvFI/EDkNtH
         yI04JZXnLDhKp9uWHsI8/b54GdGQ5KdxRLDdwzAExHfqZOqFPwDCSKwy4xWQzEj2smqe
         8adQ==
X-Gm-Message-State: ABy/qLauDZ1xrGOu6xm/Gr9MlY90ejwCauV37+0hdgXs/2GKTcE7itHk
	lIJ9KvZjv9HG7kjrv/mXk4PvimIZH8s=
X-Google-Smtp-Source: APBJJlEeZC4NdvQKtmvRvpxiJWd4xeVqmT7pbWiugvK9iOofl4skg4f0sy48sXdlWulLCE9MeEDt/9unkzk=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:ab0b:0:b0:d0e:e780:81b3 with SMTP id
 u11-20020a25ab0b000000b00d0ee78081b3mr101602ybi.2.1690992647424; Wed, 02 Aug
 2023 09:10:47 -0700 (PDT)
Date: Wed, 2 Aug 2023 09:10:46 -0700
In-Reply-To: <878ratqw2l.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230722022251.3446223-1-rananta@google.com> <20230722022251.3446223-2-rananta@google.com>
 <87v8e5r6s6.wl-maz@kernel.org> <CAJHc60wtc2Usei3hKj1ykVRvBZFFCBOHMi9HCxnNvGK2dPFApA@mail.gmail.com>
 <ZMgqueePlmKvgUId@google.com> <CAJHc60xM+KsUKxtoqORnpzrRke4T-sob2uLJRMvBKwruipxnpw@mail.gmail.com>
 <878ratqw2l.wl-maz@kernel.org>
Message-ID: <ZMqABp6OdrgOtsum@google.com>
Subject: Re: [PATCH v7 01/12] KVM: Rename kvm_arch_flush_remote_tlb() to kvm_arch_flush_remote_tlbs()
From: Sean Christopherson <seanjc@google.com>
To: Marc Zyngier <maz@kernel.org>
Cc: Raghavendra Rao Ananta <rananta@google.com>, Oliver Upton <oliver.upton@linux.dev>, 
	James Morse <james.morse@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, Huacai Chen <chenhuacai@kernel.org>, 
	Zenghui Yu <yuzenghui@huawei.com>, Anup Patel <anup@brainfault.org>, 
	Atish Patra <atishp@atishpatra.org>, Jing Zhang <jingzhangos@google.com>, 
	Reiji Watanabe <reijiw@google.com>, Colton Lewis <coltonlewis@google.com>, 
	David Matlack <dmatlack@google.com>, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, linux-mips@vger.kernel.org, 
	kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org, 
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	Gavin Shan <gshan@redhat.com>, 
	"Philippe =?utf-8?Q?Mathieu-Daud=C3=A9?=" <philmd@linaro.org>, Shaoqin Huang <shahuang@redhat.com>
Content-Type: text/plain; charset="us-ascii"

On Wed, Aug 02, 2023, Marc Zyngier wrote:
> On Tue, 01 Aug 2023 01:42:54 +0100,
> Raghavendra Rao Ananta <rananta@google.com> wrote:
> > Thanks for the suggestions; I can go with a common declaration. Along
> > with that, do we want to keep defining
> > __KVM_HAVE_ARCH_FLUSH_REMOTE_TLBS in the arch code that supports it or
> > convert it into a CONFIG_?
> 
> This isn't something that a user can select, more something that is an
> architectural decision. Maybe in a later patch if there is a consensus
> around that, but probably not as part of this series.

+1.  I agree it's annoying that KVM uses a mix of Kconfigs and manual #defines
for the various "KVM_HAVE" knobs, but we have so many of both that one-off
conversions without a real need don't make much sense.
