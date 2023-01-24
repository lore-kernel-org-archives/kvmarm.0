Received: from mail-yw1-f179.google.com (mail-yw1-f179.google.com [209.85.128.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70CB18BEC
	for <kvmarm@lists.linux.dev>; Tue, 24 Jan 2023 17:28:57 +0000 (UTC)
Received: by mail-yw1-f179.google.com with SMTP id 00721157ae682-4a2f8ad29d5so228304127b3.8
        for <kvmarm@lists.linux.dev>; Tue, 24 Jan 2023 09:28:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=4sHQzscpqG9TR78740t1qks4GROeGMyOxwyGqktGwJE=;
        b=Wv/Y/FHqEIrZHr/zsNPKlIP0whUgie/P2KEuD/n0uk24KW6tZ8c5E2dlYQQksvdoXc
         MIGHEBlUyUiurRHKw8Eli/ImV02k9ot4n+oIcF3KHN0Eg97UZIY86sENWVWQU92/wEku
         tC53N+VqDQm61+7t4vsGLZJKabtV7K36r+12kp1mA/pYMQNNe9IENQSoeoOTDJhNIfIi
         pwMTsdVKm9K2Zr4mYwzujPCEe6yuR+ktXBivdEw3X1L9xQ34O0xjHOv/b0Y/qsZO4lf3
         CRYLcBg/1JEoF9JDtZGWN8+JUGWeccq8WSx3xvS9w95XtQVb/oCmR3pU9VOfVK3eaNRc
         R3JA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=4sHQzscpqG9TR78740t1qks4GROeGMyOxwyGqktGwJE=;
        b=SDVAlitp5DJaiboriEnVRJ+PS0tGgUTtMksBg01PCNKuPwH474uonb5oCdVrH+TrGe
         75s8HPFUiLcwPEGJAJagN+l1qFv/JocaMyfqJsPQ/5ksHLdaLT1Q0HnhhI3y1SErC8BL
         FbiaoGQv+CGBVS79NRD2vWZtbW2rYCZ+k2tZedPBjl2ERCOpqf86D7caqNO2lFqEBIX/
         MqIBBRulw9dZgkRbAfOL+0cdgaqaG1BxkjUroRR2JXAl4H5CdO63lufN+oue7N1GK8Bp
         F5GvPv2EMDZJ0zBaKA7wVT9eWxlRrihWVV2DmsUvEqnjW5W9iRHQmLNnR/E73Odgr5I8
         kIbA==
X-Gm-Message-State: AFqh2krPXs3Zwylh8ly6je7WkmA5w/+M3lrWJKo0/pZn/hYsRgysVcXl
	Ucynp9y153HAuGb2XnSP1cfZUYdczr1vdksAbbBRMQ==
X-Google-Smtp-Source: AMrXdXtoN51iKqcC09s8NkQ+YBm6QxH/37ZW+Hv6vzsZE0mZGYF6ccuLxsS+T0REhESD+5OAPgve9W78T1Q827MM4i4=
X-Received: by 2002:a0d:f807:0:b0:477:b56e:e1d6 with SMTP id
 i7-20020a0df807000000b00477b56ee1d6mr3560086ywf.188.1674581336255; Tue, 24
 Jan 2023 09:28:56 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230119173559.2517103-1-dmatlack@google.com> <20230119173559.2517103-3-dmatlack@google.com>
 <Y9ASmOvJutgGLVnT@google.com>
In-Reply-To: <Y9ASmOvJutgGLVnT@google.com>
From: David Matlack <dmatlack@google.com>
Date: Tue, 24 Jan 2023 09:28:29 -0800
Message-ID: <CALzav=fbzgpktnCX9Z7G_gN=yVVLuwB5Of3_pq3LHrQGySbHsg@mail.gmail.com>
Subject: Re: [PATCH 2/7] KVM: arm64: Use kvm_arch_flush_remote_tlbs()
To: Oliver Upton <oliver.upton@linux.dev>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>, 
	James Morse <james.morse@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Huacai Chen <chenhuacai@kernel.org>, 
	Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>, Anup Patel <anup@brainfault.org>, 
	Atish Patra <atishp@atishpatra.org>, Paul Walmsley <paul.walmsley@sifive.com>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Sean Christopherson <seanjc@google.com>, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, kvmarm@lists.cs.columbia.edu, 
	linux-mips@vger.kernel.org, kvm@vger.kernel.org, 
	kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org, 
	Raghavendra Rao Ananta <rananta@google.com>
Content-Type: text/plain; charset="UTF-8"

On Tue, Jan 24, 2023 at 9:17 AM Oliver Upton <oliver.upton@linux.dev> wrote:
> On Thu, Jan 19, 2023 at 09:35:54AM -0800, David Matlack wrote:
> >
> >  arch/arm64/include/asm/kvm_host.h | 3 +++
> >  arch/arm64/kvm/Kconfig            | 1 -
> >  arch/arm64/kvm/mmu.c              | 6 +++---
> >  virt/kvm/kvm_main.c               | 2 --
> >  4 files changed, 6 insertions(+), 6 deletions(-)
>
> I think you're missing the diff that actually drops the Kconfig opton
> from virt/kvm/Kconfig.

Indeed I am, thanks for catching that!
