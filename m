Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B400BA2C
	for <kvmarm@lists.linux.dev>; Fri,  4 Aug 2023 22:45:37 +0000 (UTC)
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-d1851c52f3dso2557600276.1
        for <kvmarm@lists.linux.dev>; Fri, 04 Aug 2023 15:45:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1691189136; x=1691793936;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=qzzGQVsyCKQuIHhNuvYJJsNQNLnIEOy51Xxy7T0276E=;
        b=vyT9iRvBkAPxrhUM4loOuXv0ZWxpARTSozCHpx4ia9Cea9tMKrN/2RonnEmIi/91Y6
         D9/kIxa3brvZlRc6QGKk01Hyt0jEboWVl3Z8oGFhLtizQUeXWjYBQlLJ3hEkbES8ojIp
         xRHERUnWaRuKMo9qbYUtw33JY4PImnq6niFxGhMqp8fDR7KFDwcJ/mK4TqIKH6HSmO9R
         Cw2H5HztJsHwRfX7RoC4cz33QJ8+8AwE8bdX3ip787drt5sStO7eeTcFQcC2vu6O5EC1
         Jrv3s4q/GFzOUfGTyRixDp4N8PQ6wNQ7wlh9jGLouPYEjbTRIjnzGQFCnlolt9BIg96Q
         MmWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691189136; x=1691793936;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=qzzGQVsyCKQuIHhNuvYJJsNQNLnIEOy51Xxy7T0276E=;
        b=bmJTSBozk3a/F0Ufg9lTCwzAkyLQoUuQiPZvB6q+MDawkRh8oXfi62IBmf9Q9Mm+Nx
         onRDCSpWpoWJNrUt6aFgn6L6InFV/NXcYZsH3q4XsLY82YpnI28mqug5YVpY1z+9hzxk
         fw2KsHe3ANGNi7xbwicr4YyDzspQTvlBXLEnpcBibrIzUk6xeg8pjaOlwZ1yRR6UTLFU
         Waj7tdLQ+7G07GYl+f5zWmufVyBBRZk1gnCXtMQ5uBBn8nZG+zrIScIuj3Z+B1mekits
         V+vrwInmsT/0dSXnNhiqtEioZ7troeb2a2KYRKkWdnze6dP20OEoexcTVqaHFSFsTsby
         ZENQ==
X-Gm-Message-State: AOJu0YxY7vs10AsDl6qQyt8fe/tzOnVUBIDQIILC2t54tJDnq0fpExDI
	8DabpLuA3boAUS4udnRTGxnS+ex/J4c=
X-Google-Smtp-Source: AGHT+IEWfwtnQQ08PS920/iWYAxu1snSlSkt7kEi/UPqLCtV3oacTE1j6eL7G0tfMsosYlmzaiDwjq+gcnQ=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:6b4a:0:b0:cb6:6c22:d0f8 with SMTP id
 o10-20020a256b4a000000b00cb66c22d0f8mr16070ybm.4.1691189136427; Fri, 04 Aug
 2023 15:45:36 -0700 (PDT)
Date: Fri, 4 Aug 2023 15:45:34 -0700
In-Reply-To: <CAD=HUj41PAKC0x+c3zWAr-aCm59K7hs2zRh1uWs9778_Mai4UA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230704075054.3344915-1-stevensd@google.com> <20230704075054.3344915-6-stevensd@google.com>
 <20230705101800.ut4c6topn6ylwczs@linux.intel.com> <CAD=HUj41PAKC0x+c3zWAr-aCm59K7hs2zRh1uWs9778_Mai4UA@mail.gmail.com>
Message-ID: <ZM1/jhJXu8OGUrkb@google.com>
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

On Thu, Jul 06, 2023, David Stevens wrote:
> On Wed, Jul 5, 2023 at 7:17=E2=80=AFPM Yu Zhang <yu.c.zhang@linux.intel.c=
om> wrote:
> >
> > On Tue, Jul 04, 2023 at 04:50:50PM +0900, David Stevens wrote:
> > > From: David Stevens <stevensd@chromium.org>
> > >
> > > Stop passing FOLL_GET to __kvm_follow_pfn. This allows the host to ma=
p
> > > memory into the guest that is backed by un-refcounted struct pages - =
for
> > > example, higher order non-compound pages allocated by the amdgpu driv=
er
> > > via ttm_pool_alloc_page.
> >
> > I guess you mean the tail pages of the higher order non-compound pages?
> > And as to the head page, it is said to be set to one coincidentally[*],
> > and shall not be considered as refcounted.  IIUC, refcount of this head
> > page will be increased and decreased soon in hva_to_pfn_remapped(), so
> > this may not be a problem(?). But treating this head page differently,
> > as a refcounted one(e.g., to set the A/D flags), is weired.
> >
> > Or maybe I missed some context, e.g., can the head page be allocted to
> > guest at all?
>=20
> Yes, this is to allow mapping the tail pages of higher order
> non-compound pages - I should have been more precise in my wording.
> The head pages can already be mapped into the guest.

Recording for posterity (or to make an incorrect statment and get corrected=
),
because I recently had a conversation about the head page not actually bein=
g
refcounted.  (I can't remember with whom I had the conversation, but I'm pr=
etty
sure it wasn't an imaginary friend).

Even though whatever allocates the page doesn't explicit refcount the head =
page,
__free_pages() will still do the right thing and (a) keep the head page aro=
und
until its last reference is put.  And my understanding is that even though =
it's
a "head" page, it's not a PG_head page, i.e. not a compound page and so is =
treated
as an order-0 page when KVM invoke put_page().

void __free_pages(struct page *page, unsigned int order)
{
	/* get PageHead before we drop reference */
	int head =3D PageHead(page);

	if (put_page_testzero(page))  <=3D=3D=3D will evaluate false if KVM holds =
a ref
		free_the_page(page, order);
	else if (!head)  <=3D=3D=3D will be false for non-compound pages
		while (order-- > 0)
			free_the_page(page + (1 << order), order);
}
EXPORT_SYMBOL(__free_pages);
