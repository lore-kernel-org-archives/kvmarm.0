Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25D55134B6
	for <kvmarm@lists.linux.dev>; Wed,  2 Aug 2023 23:29:04 +0000 (UTC)
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-1b52875b8d9so68055ad.0
        for <kvmarm@lists.linux.dev>; Wed, 02 Aug 2023 16:29:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1691018944; x=1691623744;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=V4Cpxp6Pku565KQX/OGtqaeqvGA0IKhVwq6ynNOZ9r0=;
        b=fFTplzOAgW5+YW0+6iv4fkiN86H6j11X1pwoSxH+UbZ6p7iYCmpU0kuNqQBfel9T5G
         TeHCwy18VTn4JwR0FocGU0dkHDSQ01w0aCShr72E11WRUJ0CH751ArFGzoZUkTYgcDou
         gpT/KoBW3YaVs/k6v5HBuDGdwQ8fJdnUpJjdrS7LEtN9Uwz7yeQN9HB4kn1GVc0KUKqc
         DmlFiExHRsSljlkGVAJKSI7bbzKb2/ECq55k51gfA8LRkuFLjGvgB4kOf7KBZm79RD0a
         40vexDUVr9QAtQr7cD7Kllq93RNs7LMjDkavplv45/IYcQbfxyQND1D7JcDZaz5TIdZ5
         l/ag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691018944; x=1691623744;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=V4Cpxp6Pku565KQX/OGtqaeqvGA0IKhVwq6ynNOZ9r0=;
        b=I8dWoQFkewzlfqLcb0+jUGD3YrgMGMMwOJMakjf58gGsw6LeJ7WVMTW5z44Of+8a22
         4PzEeI3p+vNqlsxhRwqMvniGySRNEg3XpmIwXbH5kwDrKBUTkaMqSka+5wCVba2gbQUf
         gxTV9tomfFGw8Rs9USgsHkaF7mlyzpiDWFrO+pTZ1jHuy8jtdnnL39QqopR2eB8jzS8o
         f3x08BEc4RoIZCBQf2pjQZmR9+R3P2mNK/3ZJqjnL4M/nhZOjl+iimtXXJvihkBjn+Gf
         vr/6DGB41ZWo+lsqxAJGzVNgQb0A7jkXsnNxsKNlxLQx65qVoCpabwGxh77ugOZ5YW0s
         aFCQ==
X-Gm-Message-State: ABy/qLY85be+oBBxGDXiQYAEG6ueCwmobgM3y1oFkFDxT+R2Rih7kUel
	u1h6vTqDoEbf+K5tyex9LnyJMMqzHj6vBS8wdZY9tQ==
X-Google-Smtp-Source: APBJJlG1dr/uy6dgVj2w+3yAHutiDqre/zphK0p3aHVqG2DYCooyBFbGflKhgzehlkYIwCQRRRLEXuzHej99+96ASLI=
X-Received: by 2002:a17:902:c40f:b0:1b0:53dc:1f78 with SMTP id
 k15-20020a170902c40f00b001b053dc1f78mr966525plk.28.1691018944272; Wed, 02 Aug
 2023 16:29:04 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230722022251.3446223-1-rananta@google.com> <20230722022251.3446223-3-rananta@google.com>
 <87tttpr6qy.wl-maz@kernel.org> <ZMgsjx8dwKd4xBGe@google.com> <877cqdqw12.wl-maz@kernel.org>
In-Reply-To: <877cqdqw12.wl-maz@kernel.org>
From: Raghavendra Rao Ananta <rananta@google.com>
Date: Wed, 2 Aug 2023 16:28:52 -0700
Message-ID: <CAJHc60xAUVt5fbhEkOqeC-VF8SWVOt3si=1yxVVAUW=+Hu_wNg@mail.gmail.com>
Subject: Re: [PATCH v7 02/12] KVM: arm64: Use kvm_arch_flush_remote_tlbs()
To: Marc Zyngier <maz@kernel.org>
Cc: Sean Christopherson <seanjc@google.com>, Oliver Upton <oliver.upton@linux.dev>, 
	James Morse <james.morse@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, Huacai Chen <chenhuacai@kernel.org>, 
	Zenghui Yu <yuzenghui@huawei.com>, Anup Patel <anup@brainfault.org>, 
	Atish Patra <atishp@atishpatra.org>, Jing Zhang <jingzhangos@google.com>, 
	Reiji Watanabe <reijiw@google.com>, Colton Lewis <coltonlewis@google.com>, 
	David Matlack <dmatlack@google.com>, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, linux-mips@vger.kernel.org, 
	kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org, 
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Sure, I'll change it to kvm_arch_flush_vm_tlbs() in v8.

Thanks,
Raghavendra

On Wed, Aug 2, 2023 at 8:55=E2=80=AFAM Marc Zyngier <maz@kernel.org> wrote:
>
> On Mon, 31 Jul 2023 22:50:07 +0100,
> Sean Christopherson <seanjc@google.com> wrote:
> >
> > On Thu, Jul 27, 2023, Marc Zyngier wrote:
> > > On Sat, 22 Jul 2023 03:22:41 +0100,
> > > Raghavendra Rao Ananta <rananta@google.com> wrote:
> > > >
> > > > Stop depending on CONFIG_HAVE_KVM_ARCH_TLB_FLUSH_ALL and opt to
> > > > standardize on kvm_arch_flush_remote_tlbs() since it avoids
> > > > duplicating the generic TLB stats across architectures that impleme=
nt
> > > > their own remote TLB flush.
> > > >
> > > > This adds an extra function call to the ARM64 kvm_flush_remote_tlbs=
()
> > > > path, but that is a small cost in comparison to flushing remote TLB=
s.
> > >
> > > Well, there is no such thing as a "remote TLB" anyway. We either have
> > > a non-shareable or inner-shareable invalidation. The notion of remote
> > > would imply that we track who potentially has a TLB, which we
> > > obviously don't.
> >
> > Maybe kvm_arch_flush_vm_tlbs()?  The "remote" part is misleading even o=
n x86 when
> > running on Hyper-V, as the flush may be done via a single hypercall and=
 by kicking
> > "remote" vCPUs.
>
> Yup, this would be much better.
>
> Thanks,
>
>         M.
>
> --
> Without deviation from the norm, progress is not possible.
