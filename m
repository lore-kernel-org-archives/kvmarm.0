Received: from mail-ej1-f46.google.com (mail-ej1-f46.google.com [209.85.218.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A69B41FB20
	for <kvmarm@lists.linux.dev>; Wed, 19 Jul 2023 17:22:08 +0000 (UTC)
Received: by mail-ej1-f46.google.com with SMTP id a640c23a62f3a-991ef0b464cso230299366b.0
        for <kvmarm@lists.linux.dev>; Wed, 19 Jul 2023 10:22:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1689787326; x=1692379326;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=muf27eIntjXr3Sa3gdcQLPN4y9AYfVWt2TffDnLSMcw=;
        b=yA9Vox816zD+aJ/FVd+gHS1eUUrpLebV0UPRWoTOQXRhwbDjiEzKfZKLt7ZPO+mtvH
         SaibLGPqQv8DRVnknibkmwFWbPPfcXmr6c+ujgDGBFuCW/F/BitDoK4IVXsvCkVTbM2a
         UUXFrIHyb9EtmF0G0jSo223YyW0H9eb4QyBBeSzBXy3UqItMc2tyGgaUGUFrdupt+8A5
         dLZgmELLzzoUW2SKSL+4MBdgHsq0BaZC4v7p3QuLBtrY+JwzHEa0w4RaSfJgn6bTpTvs
         oKq8cg7sWg40yA0HzTTcfPzlRvV46kkywbP49vwd3eHSPLgVvqkoTlu6Tp2eaYz6GzrZ
         sQlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689787326; x=1692379326;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=muf27eIntjXr3Sa3gdcQLPN4y9AYfVWt2TffDnLSMcw=;
        b=dGaaSQAXw4CtF2Fi6sMx1r2FfLJ2N0Y5FeV7yzkQgytB82V+avNebxC/54V9tATRnA
         FCkQoksTSQiYNifKxBkcoT95gt+MNXGpx8onFi8pyqTo1QynrzbsOQx2T75rsF/nTlZM
         1aM4h+8/Ji5V6eSpbCR87SiHmuHT41k4y7tJwJfDNjBHjuc8rZFHSEe9zCPD1BtgJxnp
         hIuVARbCSBf7DGf2FcjXi1ZlW1+/0QYi6GCIiLhECUsP/I3bH9YLUy7mrhS+r0A4Gh5c
         MPvcH2eFLOn6iBY19dkS12ddvLt3r8hUx4/UDnU5oNh9XfmKQzVPMMQPCIVoynfYwOGl
         fEug==
X-Gm-Message-State: ABy/qLbQc1xXUI1wYqTU93HYLG4KndJjwMjYYlrjjd1D5NaFAOMusa6H
	VUfFxscs/oOPEDrgk2BjUV22Xm3hFySz3eG6E1UsxQ==
X-Google-Smtp-Source: APBJJlHLONYvTW7m5Fbx16RlTb/fOqinzIvyTzihLXJQXLhrTmtvBuSogp90ZclD7PbARqJZdKXYR/WVY9tuMb+Y5tE=
X-Received: by 2002:a17:906:292:b0:97e:17cc:cc95 with SMTP id
 18-20020a170906029200b0097e17cccc95mr3045374ejf.36.1689787326540; Wed, 19 Jul
 2023 10:22:06 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230718234512.1690985-1-seanjc@google.com> <20230718234512.1690985-13-seanjc@google.com>
In-Reply-To: <20230718234512.1690985-13-seanjc@google.com>
From: Vishal Annapurve <vannapurve@google.com>
Date: Wed, 19 Jul 2023 10:21:55 -0700
Message-ID: <CAGtprH9a2jX-hdww9GPuMrO9noNeXkoqE8oejtVn2vD0AZa3zA@mail.gmail.com>
Subject: Re: [RFC PATCH v11 12/29] KVM: Add KVM_CREATE_GUEST_MEMFD ioctl() for
 guest-specific backing memory
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Huacai Chen <chenhuacai@kernel.org>, 
	Michael Ellerman <mpe@ellerman.id.au>, Anup Patel <anup@brainfault.org>, 
	Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Albert Ou <aou@eecs.berkeley.edu>, "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Paul Moore <paul@paul-moore.com>, 
	James Morris <jmorris@namei.org>, "Serge E. Hallyn" <serge@hallyn.com>, kvm@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-mips@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, 
	kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org, 
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, 
	linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Chao Peng <chao.p.peng@linux.intel.com>, Fuad Tabba <tabba@google.com>, 
	Jarkko Sakkinen <jarkko@kernel.org>, Yu Zhang <yu.c.zhang@linux.intel.com>, 
	Ackerley Tng <ackerleytng@google.com>, Maciej Szmigiero <mail@maciej.szmigiero.name>, 
	Vlastimil Babka <vbabka@suse.cz>, David Hildenbrand <david@redhat.com>, Quentin Perret <qperret@google.com>, 
	Michael Roth <michael.roth@amd.com>, Wang <wei.w.wang@intel.com>, 
	Liam Merwick <liam.merwick@oracle.com>, Isaku Yamahata <isaku.yamahata@gmail.com>, 
	"Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Jul 18, 2023 at 4:49=E2=80=AFPM Sean Christopherson <seanjc@google.=
com> wrote:
> ...
> +static int kvm_gmem_error_page(struct address_space *mapping, struct pag=
e *page)
> +{
> +       struct list_head *gmem_list =3D &mapping->private_list;
> +       struct kvm_memory_slot *slot;
> +       struct kvm_gmem *gmem;
> +       unsigned long index;
> +       pgoff_t start, end;
> +       gfn_t gfn;
> +
> +       filemap_invalidate_lock_shared(mapping);
> +
> +       start =3D page->index;
> +       end =3D start + thp_nr_pages(page);
> +
> +       list_for_each_entry(gmem, gmem_list, entry) {
> +               xa_for_each_range(&gmem->bindings, index, slot, start, en=
d - 1) {
> +                       for (gfn =3D start; gfn < end; gfn++) {
> +                               if (WARN_ON_ONCE(gfn < slot->base_gfn ||
> +                                               gfn >=3D slot->base_gfn +=
 slot->npages))
> +                                       continue;
> +
> +                               /*
> +                                * FIXME: Tell userspace that the *privat=
e*
> +                                * memory encountered an error.
> +                                */
> +                               send_sig_mceerr(BUS_MCEERR_AR,
> +                                               (void __user *)gfn_to_hva=
_memslot(slot, gfn),
> +                                               PAGE_SHIFT, current);

Does it make sense to replicate what happens with MCE handling on
tmpfs backed guest memory:
1) Unmap gpa from guest
2) On the next guest EPT fault, exit to userspace to handle/log the
mce error for the gpa.

IIUC, such MCEs could be asynchronous and "current" might not always
be the intended recipient of this signal.

> +                       }
> +               }
> +       }
> +
> +       filemap_invalidate_unlock_shared(mapping);
> +
> +       return 0;
> +}
> +
