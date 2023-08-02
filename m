Received: from mail-il1-f181.google.com (mail-il1-f181.google.com [209.85.166.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22A2317FE8
	for <kvmarm@lists.linux.dev>; Wed,  2 Aug 2023 23:30:51 +0000 (UTC)
Received: by mail-il1-f181.google.com with SMTP id e9e14a558f8ab-3490b737f9aso58245ab.0
        for <kvmarm@lists.linux.dev>; Wed, 02 Aug 2023 16:30:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1691019051; x=1691623851;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Y9p/r3/7OOEeGD98k45cJqzqj6mNEuBO34pHN8nni+M=;
        b=fFKN5nHbyv551/4W30i+xv9zwo+3QEZKGkdrHoMkNbWnp7D69/RlaUhp/eF6/2v5F3
         PY4ootJGDhDcUwe+92UvbjD4/1toXHiTlmtImD9LT/8YQiZYo1yq/3Gd4/VDg79/Fjr+
         6pmjunqIV0Ca8hZsxV+aVu04NE60qfC1zia2pWkVAMNlEmBowfsdO+ZCG2YoM1jl/JLo
         g0hFzMkrepyVv2HBAO+grYkMtS7Ff2jFJXIxiFQF080W3PmgZFJzBwbn5Io3N8oYuy6R
         Dxbqqy14GybNEz0zpdK7tsmDcO74eEg1QwBJKVXI6nZoxgpf0g/I8paf+i1lAj70Gw7g
         RYxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691019051; x=1691623851;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Y9p/r3/7OOEeGD98k45cJqzqj6mNEuBO34pHN8nni+M=;
        b=aweMTmkc/D6sVbLzw2UbFhfAV9YwXkN9A5cmetYWL7CyeFtOUpuzeZkuMBfIoIUlOW
         LdWf9mAqddFokHY2LquLEyJprXpAy7j+jHo/+9qIb8DDcyNxzRbQUYBxedcThVz7v8oL
         tOcM2LBlAE+Jfppy9v97nh/wTarYC/eAMM2dQStvOahQC8HVlECvQ4fjGKtosFGJIzhE
         FD1f1/RiNfupJHV714gjt9ycB+JyjklGlZ1vvY93XhaHpWiTGxFd3LFVEacZDc6bCbhh
         jekucw15YOLRlVhFMvzBqBLMDrRhbVbXOV27/IaFWylKRpXv21U2Uw21Hr6zNMwsKhhJ
         gOZQ==
X-Gm-Message-State: ABy/qLaivO7sG6+wmIXT2tMp9nlS+JtBNrSGpz2AD9w5UimIMEkQbRUc
	WdwlRikVZE7zVKpaINYs3FfScoWIXHvqIJSMwhmhYw==
X-Google-Smtp-Source: APBJJlELAYNKKPfecK64fKx5Ci1HyUNKE08JkQGkdOgzq5gUkMmu0eZ6vl6aaIwqTlVQfSan7JpwYd6tPF2vIZQ+LNM=
X-Received: by 2002:a92:c54a:0:b0:340:502b:1487 with SMTP id
 a10-20020a92c54a000000b00340502b1487mr1178689ilj.12.1691019050973; Wed, 02
 Aug 2023 16:30:50 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230722022251.3446223-1-rananta@google.com> <20230722022251.3446223-2-rananta@google.com>
 <87v8e5r6s6.wl-maz@kernel.org> <CAJHc60wtc2Usei3hKj1ykVRvBZFFCBOHMi9HCxnNvGK2dPFApA@mail.gmail.com>
 <ZMgqueePlmKvgUId@google.com> <CAJHc60xM+KsUKxtoqORnpzrRke4T-sob2uLJRMvBKwruipxnpw@mail.gmail.com>
 <878ratqw2l.wl-maz@kernel.org> <ZMqABp6OdrgOtsum@google.com>
In-Reply-To: <ZMqABp6OdrgOtsum@google.com>
From: Raghavendra Rao Ananta <rananta@google.com>
Date: Wed, 2 Aug 2023 16:30:39 -0700
Message-ID: <CAJHc60zvKSoPU6uTzZQCY2ZAeVj18qmu3=U-rUt5er0zGLQ33Q@mail.gmail.com>
Subject: Re: [PATCH v7 01/12] KVM: Rename kvm_arch_flush_remote_tlb() to kvm_arch_flush_remote_tlbs()
To: Sean Christopherson <seanjc@google.com>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	James Morse <james.morse@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, Huacai Chen <chenhuacai@kernel.org>, 
	Zenghui Yu <yuzenghui@huawei.com>, Anup Patel <anup@brainfault.org>, 
	Atish Patra <atishp@atishpatra.org>, Jing Zhang <jingzhangos@google.com>, 
	Reiji Watanabe <reijiw@google.com>, Colton Lewis <coltonlewis@google.com>, 
	David Matlack <dmatlack@google.com>, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, linux-mips@vger.kernel.org, 
	kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org, 
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	Gavin Shan <gshan@redhat.com>, =?UTF-8?Q?Philippe_Mathieu=2DDaud=C3=A9?= <philmd@linaro.org>, 
	Shaoqin Huang <shahuang@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Okay, so just the #define in the respective arch header with a global
declaration. I'll consider this in v8.

Thanks,
Raghavendra

On Wed, Aug 2, 2023 at 9:10=E2=80=AFAM Sean Christopherson <seanjc@google.c=
om> wrote:
>
> On Wed, Aug 02, 2023, Marc Zyngier wrote:
> > On Tue, 01 Aug 2023 01:42:54 +0100,
> > Raghavendra Rao Ananta <rananta@google.com> wrote:
> > > Thanks for the suggestions; I can go with a common declaration. Along
> > > with that, do we want to keep defining
> > > __KVM_HAVE_ARCH_FLUSH_REMOTE_TLBS in the arch code that supports it o=
r
> > > convert it into a CONFIG_?
> >
> > This isn't something that a user can select, more something that is an
> > architectural decision. Maybe in a later patch if there is a consensus
> > around that, but probably not as part of this series.
>
> +1.  I agree it's annoying that KVM uses a mix of Kconfigs and manual #de=
fines
> for the various "KVM_HAVE" knobs, but we have so many of both that one-of=
f
> conversions without a real need don't make much sense.
