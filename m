Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD30020EB
	for <kvmarm@lists.linux.dev>; Sat,  3 Jun 2023 19:17:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1685819828;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=M4o0k3datcaUU/TmUVbwYLxyr5WzpSezN+J1D4IJgBE=;
	b=bce4/yvECDMEm6AXW4ZejC8PcNZ5N9qH6Pf/nqAQ9GUzMce8tvUXxAC3oW3/tPBABf5B6S
	rQxCwWhTPsOjZLA12VhOEEGfmybT3rcGyBj/Uy7OpiW1s6pB6aR+v5k1YVZeQSeJB3N5D8
	2s1pfUCVul8cengnuijOG8banyuyLdY=
Received: from mail-ua1-f70.google.com (mail-ua1-f70.google.com
 [209.85.222.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-290-d8OSqQN5NUOlDUJoFuM0gg-1; Sat, 03 Jun 2023 15:16:49 -0400
X-MC-Unique: d8OSqQN5NUOlDUJoFuM0gg-1
Received: by mail-ua1-f70.google.com with SMTP id a1e0cc1a2514c-786de36b131so1033603241.1
        for <kvmarm@lists.linux.dev>; Sat, 03 Jun 2023 12:16:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685819809; x=1688411809;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=M4o0k3datcaUU/TmUVbwYLxyr5WzpSezN+J1D4IJgBE=;
        b=Cm2WnYLE93XLrLPCvHOzbj4RtszHZC9MdYtg0WfxIc5Vyo6GyvliXqge8eckG0B23a
         4V9cYzYWlIZaXd2fRghbaWV/0hNtdpP0QU4ViByCXyTgAMDEAGjjIwitaFCJ3X4ln4Kw
         RbD1YYA8MTgt6GkSUHFtzVsjL9kzocGSHGihwMPhPbxmxht3i1jQSqKtPvLKolR0EuyS
         Nl9vMoiyE61EttyNDQ28CpdiWAqv37DQxfxHwyKOkp2FyhZUZnWUrb63AzA5hXNWY44e
         echacpxfTMN00gS0TIRfmGtNhIxVgAj0uNK4ldRPhj8cq/xBRqlMIRKP6X7FwAizAcqJ
         860A==
X-Gm-Message-State: AC+VfDxBNaWPkmHbVcCZCvr5PZxXlMlH06LlJiqLtNTBaWfIgA9fAsft
	X+/3cExknEXD9Jt2HsJvkf3p3JMbn1YwQSOQdAWpDPYSXFhH/kvdZGvfDI1vK/V5NE0SqBLDK6r
	1lPkCmIbu83oTSeeVEgWpmS78/8H30eqH
X-Received: by 2002:a67:ead2:0:b0:43b:298f:ed6e with SMTP id s18-20020a67ead2000000b0043b298fed6emr1954646vso.30.1685819808757;
        Sat, 03 Jun 2023 12:16:48 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ7FcmiNdTHlNrtp/QP2ZTTg/GDP+onBpgDJrEavKZ/00QU2LrieG2uUGPDLsTfnTfpRUl42Q9tH6v0HzgnRY2I=
X-Received: by 2002:a67:ead2:0:b0:43b:298f:ed6e with SMTP id
 s18-20020a67ead2000000b0043b298fed6emr1954638vso.30.1685819808536; Sat, 03
 Jun 2023 12:16:48 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230531100305.430120-1-maz@kernel.org>
In-Reply-To: <20230531100305.430120-1-maz@kernel.org>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Sat, 3 Jun 2023 21:16:37 +0200
Message-ID: <CABgObfbb0oPO1jv4OR-4xuXNfz-cKbPs9KgFRuuER9CHnaYAxg@mail.gmail.com>
Subject: Re: [GIT PULL] KVM/arm64 fixes for 6.4, take #3
To: Marc Zyngier <maz@kernel.org>
Cc: Akihiko Odaki <akihiko.odaki@daynix.com>, Nathan Chancellor <nathan@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Yu Zhao <yuzhao@google.com>, 
	James Morse <james.morse@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, May 31, 2023 at 12:03=E2=80=AFPM Marc Zyngier <maz@kernel.org> wrot=
e:
>
> Paolo,
>
> Here's the third batch of fixes for 6.4: yet another MMU-related fix,
> an external debug bug fix and the obligatory PMU fix.
>
> Note that since you don't seem to have pulled kvmarm-fixes-6.4-2[1]
> just yet, pulling this will drag both tags.
>
> Please pull,
>
>         M.
>
> [1] https://lore.kernel.org/r/20230524125757.3631091-1-maz@kernel.org
>
> The following changes since commit a9f0e3d5a089d0844abb679a5e99f15010d53e=
25:
>
>   KVM: arm64: Reload PTE after invoking walker callback on preorder trave=
rsal (2023-05-24 13:47:12 +0100)
>
> are available in the Git repository at:
>
>   git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git tags/kv=
marm-fixes-6.4-3

Pulled, thanks (a bit more speedily than #2, fortunately).

Paolo

> for you to fetch changes up to 40e54cad454076172cc3e2bca60aa924650a3e4b:
>
>   KVM: arm64: Document default vPMU behavior on heterogeneous systems (20=
23-05-31 10:29:56 +0100)
>
> ----------------------------------------------------------------
> KVM/arm64 fixes for 6.4, take #3
>
> - Fix the reported address of a watchpoint forwarded to userspace
>
> - Fix the freeing of the root of stage-2 page tables
>
> - Stop creating spurious PMU events to perform detection of the
>   default PMU and use the existing PMU list instead.
>
> ----------------------------------------------------------------
> Akihiko Odaki (1):
>       KVM: arm64: Populate fault info for watchpoint
>
> Oliver Upton (3):
>       KVM: arm64: Drop last page ref in kvm_pgtable_stage2_free_removed()
>       KVM: arm64: Iterate arm_pmus list to probe for default PMU
>       KVM: arm64: Document default vPMU behavior on heterogeneous systems
>
>  arch/arm64/kvm/hyp/include/hyp/switch.h |  8 +++--
>  arch/arm64/kvm/hyp/nvhe/switch.c        |  2 ++
>  arch/arm64/kvm/hyp/pgtable.c            |  3 ++
>  arch/arm64/kvm/hyp/vhe/switch.c         |  1 +
>  arch/arm64/kvm/pmu-emul.c               | 58 +++++++++++++--------------=
------
>  5 files changed, 35 insertions(+), 37 deletions(-)
>

