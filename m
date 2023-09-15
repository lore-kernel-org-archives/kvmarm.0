Received: from mail-lf1-f50.google.com (mail-lf1-f50.google.com [209.85.167.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE1AA4437
	for <kvmarm@lists.linux.dev>; Fri, 15 Sep 2023 06:21:54 +0000 (UTC)
Received: by mail-lf1-f50.google.com with SMTP id 2adb3069b0e04-502e385e33bso2939912e87.0
        for <kvmarm@lists.linux.dev>; Thu, 14 Sep 2023 23:21:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1694758912; x=1695363712; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4CbOaBoTgdqZjkC9bgxngrjMf2gb+bcUOXRH9i9PPC4=;
        b=LXlOv100rFEmkPf8be1F2eIodoz9ipQCETtBQ42MPJ1xCK5rHYrwHQ2B+IQ44KNntd
         vEm4rRCedG5k2SUThs4SJQxH8nCqytrX0Hse7Sw2F2JzQm+LtS005+3GCcotatdM+y0w
         tz9i6gel5qdSv+e6fVoV0WCjVHB5mLxBCezJ8Y1WmaiD4XampYNSO0dWr5eWE1Qspj1z
         mzrof4MYT/LRLOvr72pThJBqO+7MuGZBAASL2+9/k77pgrFGs504vYbX5Du4vLC+UVnK
         J+N3r1obGvQWGuYulp+7J8ePx0p2ONnAu8c0ZZbkkzjRXcfOX1HWsu9yoSWj1/wCX0yI
         99Mw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694758912; x=1695363712;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4CbOaBoTgdqZjkC9bgxngrjMf2gb+bcUOXRH9i9PPC4=;
        b=GLj2oTGHYjG8WzDGtW7RXeAiC/ybv6Q6lxWrGtCJMM7CoSeg/wVPUX7VQ2X+b19K/i
         mz+AmfQ4fme3GzkTcFld8343fc+FKrpEwabvtLm5Lwg6P8DX2uvvsPK4X+WvUGTtf2y5
         OtQyNb49cVGce5g3FwninAK6IPBYQUN8f2E3eehuh+FDA+5zhZowUMorBBztEuXjPOPC
         YrrG+rgG87qmX/COaFQ2HFC44aX6AzPut8TeSlhka/eFE6lz+lEV+81GAqh2BXnj+IZ9
         JNBoqFLJJPA+PxpQmfQiwWCx6zsutvd7fovs7ebsZrUBEZE6l/N+CjdwZvk+1MEODPlD
         6kJQ==
X-Gm-Message-State: AOJu0YwKj2zrgRBM6TKLearpYXt3w0nkq4FpVgrev/lkRdzdvciS7RMb
	6mDnuq9R3Etj8z8pj3Q1IW5jgxFSu2356vgexbw=
X-Google-Smtp-Source: AGHT+IFQEpOnX9uf3gdbZsJHudImE7kbvB8OM+rS3Fi4ABBNMgv5QYCfVKA10TAI1f03ryjhcKZYalx2hAKJFWVnvIc=
X-Received: by 2002:a19:6715:0:b0:502:e2be:54b5 with SMTP id
 b21-20020a196715000000b00502e2be54b5mr569046lfc.17.1694758912398; Thu, 14 Sep
 2023 23:21:52 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <cover.1694421911.git.haibo1.xu@intel.com> <64e0637cd6f22dd7557ed44bd2242001e7830d1c.1694421911.git.haibo1.xu@intel.com>
 <20230914-d2e594e7d84503ad14036e2d@orel>
In-Reply-To: <20230914-d2e594e7d84503ad14036e2d@orel>
From: Haibo Xu <xiaobo55x@gmail.com>
Date: Fri, 15 Sep 2023 14:21:41 +0800
Message-ID: <CAJve8onhY534T=Hyncjfi4GfdZ+0D2xM+jRSaYCAWCdaKxPUcQ@mail.gmail.com>
Subject: Re: [PATCH v3 9/9] KVM: riscv: selftests: Add sstc timer test
To: Andrew Jones <ajones@ventanamicro.com>
Cc: Haibo Xu <haibo1.xu@intel.com>, Paul Walmsley <paul.walmsley@sifive.com>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Paolo Bonzini <pbonzini@redhat.com>, Shuah Khan <shuah@kernel.org>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, James Morse <james.morse@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Anup Patel <anup@brainfault.org>, Atish Patra <atishp@atishpatra.org>, 
	Sean Christopherson <seanjc@google.com>, Ricardo Koller <ricarkol@google.com>, 
	Vishal Annapurve <vannapurve@google.com>, Vitaly Kuznetsov <vkuznets@redhat.com>, 
	Vipin Sharma <vipinsh@google.com>, David Matlack <dmatlack@google.com>, 
	Colton Lewis <coltonlewis@google.com>, Aaron Lewis <aaronlewis@google.com>, 
	Thomas Huth <thuth@redhat.com>, linux-kernel@vger.kernel.org, 
	linux-riscv@lists.infradead.org, kvm@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, kvm-riscv@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Sep 14, 2023 at 5:52=E2=80=AFPM Andrew Jones <ajones@ventanamicro.c=
om> wrote:
>
> On Thu, Sep 14, 2023 at 09:37:03AM +0800, Haibo Xu wrote:
> > Add a KVM selftests to validate the Sstc timer functionality.
> > The test was ported from arm64 arch timer test.
>
> I just tried this test out. Running it over and over again on QEMU I see
> it works sometimes, but it frequently fails with the
> GUEST_ASSERT_EQ(config_iter + 1, irq_iter) assert and at least once I
> also saw the __GUEST_ASSERT(xcnt >=3D cmp) assert.
>

Good catch!

I can also reproduce this issue and it is a common problem for both
arm64 and riscv because it also happens in a arm64 Qemu VM.

It seems like a synchronization issue between host and guest shared
variables. Will double check the test code.

> Thanks,
> drew
