Received: from mail-qt1-f175.google.com (mail-qt1-f175.google.com [209.85.160.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3E3717C8
	for <kvmarm@lists.linux.dev>; Tue, 15 Aug 2023 00:30:12 +0000 (UTC)
Received: by mail-qt1-f175.google.com with SMTP id d75a77b69052e-40a47e8e38dso75781cf.1
        for <kvmarm@lists.linux.dev>; Mon, 14 Aug 2023 17:30:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1692059411; x=1692664211;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HNJoaJWeIvUddw5R6SlhDX5IJGHqkE8DYyIqOAmI/Gc=;
        b=dTFmXzF41H/n0mK5Jfs/y8u8AIBRo6B27+rwi8uJSpQ/wDiNzZvL4lLXxVNTiAFnkY
         suX0m2QNqLhILSSE09Qp0EukFkzTu5fkVeX9h2uqxOukcSvGAGoFfI/tN7OJN6Tmf4hp
         2mQFyYwAgzeVf26n6t7iWvkYuXuBdnimEIsWJq+Q0pT1f5LSRaCImOR8BywZSjIJIdOq
         cAmcg3NOXGzR2UQrLQh9p0Dfa+ukixiNWjSnvTSaiF7HQoZ6Tumr7UhEepy6riEpq6V6
         Q96VUWIOScaDoDQ5SHJBhUhM3mvGwEwsUjr+/ALmvdKPAVvLMf2FUm7Gsdz4zcVfLTzN
         vJQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692059411; x=1692664211;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=HNJoaJWeIvUddw5R6SlhDX5IJGHqkE8DYyIqOAmI/Gc=;
        b=jUHgGclXl2eDDNMVIjsXdv2D6NHIgYWbcI4aXdLaw8oFHuVwSjEL0HZED7HCyEtV/7
         Q5jQZaS3zMBpVrW0evfSyF5JaY9gOOprwOMIqqhu7eYegNTL2MPNgqUIBmxf+gDDY05x
         wJ5QXjr11b04bh7QRgNDi+mATkZ7Zw2u1A2YMWBbClsoJ+yJiq/EuEmu0dIBX9v2ndCv
         7jxCNTBz+RduUQa87MULFv7p9HcD178dul4vAQMR62aq0ftCmeTibbYMFUA0vz/nhJjt
         r4347MPenM2AizH6mIiK46KJIFIbsUosXBATobBLj8/9rZ3h90PmPkWPZbSixhV4ijiP
         D2SQ==
X-Gm-Message-State: AOJu0Yzn7Lo0oj45W381hd2LfcxnSv/nRvEh7GuAZ/o6XHt7aa8nH6c0
	0Jp5ShO1SlH620z7jrZT46a2uo8lCjklp+WbKTVrQQ==
X-Google-Smtp-Source: AGHT+IH5y5MbCy4rjhKShz2AECkzIJQAfVMplY8s8RsyVo2A8Q6lT4pFb0RwiAA0GgJLzfktk2kf1TttUxP9ICKRKm4=
X-Received: by 2002:ac8:5b51:0:b0:40f:d3db:f328 with SMTP id
 n17-20020ac85b51000000b0040fd3dbf328mr724022qtw.2.1692059411605; Mon, 14 Aug
 2023 17:30:11 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230811045127.3308641-1-rananta@google.com> <ZNq15SZ+53umvOfx@google.com>
In-Reply-To: <ZNq15SZ+53umvOfx@google.com>
From: Raghavendra Rao Ananta <rananta@google.com>
Date: Mon, 14 Aug 2023 17:29:59 -0700
Message-ID: <CAJHc60wMueazp3Wm=b6-tnFPAyX0zeYuVQe9uPEJrpAm0azw2A@mail.gmail.com>
Subject: Re: [PATCH v9 00/14] KVM: arm64: Add support for FEAT_TLBIRANGE
To: Sean Christopherson <seanjc@google.com>
Cc: Oliver Upton <oliver.upton@linux.dev>, Marc Zyngier <maz@kernel.org>, 
	James Morse <james.morse@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, Huacai Chen <chenhuacai@kernel.org>, 
	Zenghui Yu <yuzenghui@huawei.com>, Anup Patel <anup@brainfault.org>, 
	Atish Patra <atishp@atishpatra.org>, Jing Zhang <jingzhangos@google.com>, 
	Reiji Watanabe <reijiw@google.com>, Colton Lewis <coltonlewis@google.com>, 
	David Matlack <dmatlack@google.com>, Fuad Tabba <tabba@google.com>, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-mips@vger.kernel.org, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, 
	kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Aug 14, 2023 at 4:16=E2=80=AFPM Sean Christopherson <seanjc@google.=
com> wrote:
>
> On Fri, Aug 11, 2023, Raghavendra Rao Ananta wrote:
> > The series is based off of upstream v6.5-rc1.
>
> Lies!  :-)
>
> This is based off one of the kvmarm.git topic branches (I didn't bother t=
o figure
> out which one), not v6.5-rc1.
>
Sorry, what am I missing here? My git log is as follows:

$ git log --oneline upstream_tlbi_range_v9
5025857507abe (upstream_tlbi_range_v9) KVM: arm64: Use TLBI
range-based instructions for unmap
5c0291b99a8fc KVM: arm64: Invalidate the table entries upon a range
8c46b54d4aaec KVM: arm64: Flush only the memslot after write-protect
231abaeb7ffc2 KVM: arm64: Implement kvm_arch_flush_remote_tlbs_range()
5ec291b863309 KVM: arm64: Define kvm_tlb_flush_vmid_range()
5bcd7a085c34e KVM: arm64: Implement  __kvm_tlb_flush_vmid_range()
ea08f9dff7e5b arm64: tlb: Implement __flush_s2_tlb_range_op()
b3178687947c9 arm64: tlb: Refactor the core flush algorithm of __flush_tlb_=
range
a4850fa988eef KVM: Move kvm_arch_flush_remote_tlbs_memslot() to common code
306dc4e6afd37 KVM: Allow range-based TLB invalidation from common code
d02785a0a1e01 KVM: Remove CONFIG_HAVE_KVM_ARCH_TLB_FLUSH_ALL
136fa2d254537 KVM: arm64: Use kvm_arch_flush_remote_tlbs()
e35c68a75170d KVM: Declare kvm_arch_flush_remote_tlbs() globally
5d592777b9bba KVM: Rename kvm_arch_flush_remote_tlb() to
kvm_arch_flush_remote_tlbs()
06c2afb862f9d (tag: v6.5-rc1, tag: linux/v6.5-rc1) Linux 6.5-rc1
c192ac7357683 MAINTAINERS 2: Electric Boogaloo
f71f64210d698 Merge tag 'dma-mapping-6.5-2023-07-09' of
git://git.infradead.org/users/hch/dma-mapping
...

Isn't the commit, 06c2afb862f9d (06c2afb862f9d (tag: v6.5-rc1, tag:
linux/v6.5-rc1) Linux 6.5-rc1) the 'base' commit?

Thank you.
Raghavendra

> Please try to incorporate git format-patch's "--base" option into your wo=
rkflow,
> e.g. I do "git format-patch --base=3DHEAD~$nr" where $nr is the number of=
 patches
> I am posting.
>
> It's not foolproof, e.g. my approach doesn't help if I have a local patch=
 that
> I'm not posting, but 99% of the time it Just Works and eliminates any amb=
uitity.
>
> You can also do "--base=3Dauto", but that only does the right thing if yo=
ur series
> has its upstream branch set to the base/tree that you want your patches a=
pplied
> to (I use the upstream branch for a completely different purpose for my d=
ev branches).
