Received: from mail-lj1-f170.google.com (mail-lj1-f170.google.com [209.85.208.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BF08A47
	for <kvmarm@lists.linux.dev>; Thu,  6 Jul 2023 05:53:08 +0000 (UTC)
Received: by mail-lj1-f170.google.com with SMTP id 38308e7fff4ca-2b701e1c80fso3384581fa.2
        for <kvmarm@lists.linux.dev>; Wed, 05 Jul 2023 22:53:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1688622786; x=1691214786;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MbLurLZ62LRhBoyKK/a+NkMCNn75BCIX5dmoVcJnOa4=;
        b=GZRLr3+/iND4JiH/eec95IEfwzWiwvuMeewhoW9LLRb5Yu/99cTNAL1uQuRKsNRAbR
         0wkM50R3efN4vAq8LK923KkRdgxTsnCIhWVut85AV4dlUZIUz26nPcE0AmQYEOorUmjh
         k/ccFYU0ooJp8B2LxZPf8d8q1xZ3Oo6bDy+Lk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1688622786; x=1691214786;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=MbLurLZ62LRhBoyKK/a+NkMCNn75BCIX5dmoVcJnOa4=;
        b=ATsBci+nFjX6bI7Tx012wT3gpXoocIj76UC3HxWUQANl4JOAnPCvrIcSfWZvFS2n3q
         jIp2gD6zZYzZ5sYjrPGFKHAidbK0P+XRHe82AmYINoSMdr0L6axlrTkFi98D7Blir5VS
         O3MvfKoWy7mMXD/gSolIUhJKfhSAxgF5CJgy5TZYJt4GEktnoWqvzbnxucLNIy5ospUE
         uoLmWE5XB29qasdA8MZLDBfpYyOUnnddE6asf2npP3VaHK4Moj83DHR0LrNkCmJ4i9/O
         wuA++vOIoKH0DJDFHHhIqVg7Fc+7zSp+BDJv5LfX7X6k8hHkCitdoM3gR8vyfWqDU0lL
         CSJQ==
X-Gm-Message-State: ABy/qLaEDu3oOEiPxNdmsaF81Q1IDKqJskDDWSEZyWG/RdwrjB3p/6iT
	Gr45Rj4gJqOfTiRJdnyPbBdxmKs7l4Ald66kQKnk+w==
X-Google-Smtp-Source: APBJJlF24HPQiLK/1UsY/Js5Vw/5R/DCo1JszMm+dpVp9f3gL+oA7VggoMNxpxtVwaFC87wS94UcWfopl/L3i9jY5zk=
X-Received: by 2002:a2e:9015:0:b0:2b6:de41:b72f with SMTP id
 h21-20020a2e9015000000b002b6de41b72fmr578113ljg.4.1688622786051; Wed, 05 Jul
 2023 22:53:06 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230704075054.3344915-1-stevensd@google.com> <20230704075054.3344915-3-stevensd@google.com>
 <20230706013423.GA3894444@ls.amr.corp.intel.com>
In-Reply-To: <20230706013423.GA3894444@ls.amr.corp.intel.com>
From: David Stevens <stevensd@chromium.org>
Date: Thu, 6 Jul 2023 14:52:55 +0900
Message-ID: <CAD=HUj4e3G6W74CyxicGH5k8mLmXt+JUK0ju5LCC6ESQ7EYgqQ@mail.gmail.com>
Subject: Re: [PATCH v7 2/8] KVM: Introduce __kvm_follow_pfn function
To: Isaku Yamahata <isaku.yamahata@gmail.com>
Cc: Sean Christopherson <seanjc@google.com>, Marc Zyngier <maz@kernel.org>, 
	Michael Ellerman <mpe@ellerman.id.au>, Peter Xu <peterx@redhat.com>, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, 
	kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jul 6, 2023 at 10:34=E2=80=AFAM Isaku Yamahata <isaku.yamahata@gmai=
l.com> wrote:
>
> On Tue, Jul 04, 2023 at 04:50:47PM +0900,
> David Stevens <stevensd@chromium.org> wrote:
>
> > From: David Stevens <stevensd@chromium.org>
> >
> > Introduce __kvm_follow_pfn, which will replace __gfn_to_pfn_memslot.
> > __kvm_follow_pfn refactors the old API's arguments into a struct and,
> > where possible, combines the boolean arguments into a single flags
> > argument.
> >
> > Signed-off-by: David Stevens <stevensd@chromium.org>
> > ---
> >  include/linux/kvm_host.h |  16 ++++
> >  virt/kvm/kvm_main.c      | 171 ++++++++++++++++++++++-----------------
> >  virt/kvm/kvm_mm.h        |   3 +-
> >  virt/kvm/pfncache.c      |   8 +-
> >  4 files changed, 122 insertions(+), 76 deletions(-)
> >
> > diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> > index 9d3ac7720da9..ef2763c2b12e 100644
> > --- a/include/linux/kvm_host.h
> > +++ b/include/linux/kvm_host.h
> > @@ -97,6 +97,7 @@
> >  #define KVM_PFN_ERR_HWPOISON (KVM_PFN_ERR_MASK + 1)
> >  #define KVM_PFN_ERR_RO_FAULT (KVM_PFN_ERR_MASK + 2)
> >  #define KVM_PFN_ERR_SIGPENDING       (KVM_PFN_ERR_MASK + 3)
> > +#define KVM_PFN_ERR_NEEDS_IO (KVM_PFN_ERR_MASK + 4)
> >
> >  /*
> >   * error pfns indicate that the gfn is in slot but faild to
> > @@ -1156,6 +1157,21 @@ unsigned long gfn_to_hva_memslot_prot(struct kvm=
_memory_slot *slot, gfn_t gfn,
> >  void kvm_release_page_clean(struct page *page);
> >  void kvm_release_page_dirty(struct page *page);
> >
> > +struct kvm_follow_pfn {
> > +     const struct kvm_memory_slot *slot;
> > +     gfn_t gfn;
> > +     unsigned int flags;
> > +     bool atomic;
> > +     /* Allow a read fault to create a writeable mapping. */
> > +     bool allow_write_mapping;
>
> Maybe, make them const for input arguments?

Unfortunately using const isn't straightforward as long as the kernel
continues to use -Wdeclaration-after-statement. If these fields were
const, then they would need to be specified in the initializer when
declaring the variable, but that's not necessarily always possible.

-David
