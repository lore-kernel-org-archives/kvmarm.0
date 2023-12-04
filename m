Received: from mail-lf1-f41.google.com (mail-lf1-f41.google.com [209.85.167.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8713A814
	for <kvmarm@lists.linux.dev>; Mon,  4 Dec 2023 02:42:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HtcVFCW/"
Received: by mail-lf1-f41.google.com with SMTP id 2adb3069b0e04-50bf898c43cso300812e87.1
        for <kvmarm@lists.linux.dev>; Sun, 03 Dec 2023 18:42:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1701657756; x=1702262556; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SEUh6K5iutasnoMeRQbvniZJyhB8EqO9DGWeSRBdHG8=;
        b=HtcVFCW/HRUpJbhdg//j0Z0O+rlG/zwV5822S6t27Zf19eyGpc8L3jFjnHwTTcwSQY
         6UhWeJZFSSTHdvVChhuXL3lNjHPxYTJekIAS8uB6C2DgPi/xr3ybStzeuGip3/WYx/ND
         QfCUzdPAPz2msgjDRdKoSleK7pvzUJtWwB6bR0S+8kcz9WQ2srK3o5KVBTIAs86OFLR/
         /UoUEw252mOcxO9czV54PJiH5l8gdN365+oO0cw5SUX1Kq/s3a/ADuBixMCPH+OHuoiZ
         QFC3frufueJQqRF+BBVImwEd9iVSehuo7b1obnNWtVtJC6Keu/ITQ+0M4/XoLa5/NI83
         7U4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701657756; x=1702262556;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=SEUh6K5iutasnoMeRQbvniZJyhB8EqO9DGWeSRBdHG8=;
        b=vW64ori6s6pmjXDXuJwYEBLvdX/HCu/WDV0/CX4a9BhmgqxmeBfolTGG9LuWNVBgt2
         YWwz+FGPAnmqg7UWN3xNIJJAsHrNDBE8shmI6SKPOxPtQ6v1vQbDDtWWSmBCjVlw/Wdw
         cV+NIZ/6UizK0R5zK9+NDNBkkgD8g5nMZfFW32wXCIqLAIXjDQ+KMx+IwH+b6n/NR8cE
         XyhNpkeLbE3nghy/CnhB4uKE+N0Mtj4SWIv5017mDgXtAesIR3pM5SPBE6FOUXoWT5WP
         U1FuUTQf4NPdGOgbynAZbkXzJ7GMjLH8VncE0m7vPPIbecyAOK8wpR70aMkvgNL1bLaK
         phAQ==
X-Gm-Message-State: AOJu0Yx4YHMdFAR6/bIRL+l6JKnuzTLowamN0qaL8y32sa9y99IXh/H2
	j24ne2Pji0VCgK/Swr9QcqluUi/mvwnCYd8hh7o=
X-Google-Smtp-Source: AGHT+IFwUdfTpFRUP7l0fmhtGiz7fd+NP19pyuThwxbiypx7Ivz7rX5Zrc/KjwBbAY7wO0CJI2SrHgFWM/kImEvN9oM=
X-Received: by 2002:a05:6512:ea1:b0:50b:f03c:1eaa with SMTP id
 bi33-20020a0565120ea100b0050bf03c1eaamr553100lfb.95.1701657756237; Sun, 03
 Dec 2023 18:42:36 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <cover.1694421911.git.haibo1.xu@intel.com> <64e0637cd6f22dd7557ed44bd2242001e7830d1c.1694421911.git.haibo1.xu@intel.com>
 <20230914-d2e594e7d84503ad14036e2d@orel> <CAJve8onhY534T=Hyncjfi4GfdZ+0D2xM+jRSaYCAWCdaKxPUcQ@mail.gmail.com>
In-Reply-To: <CAJve8onhY534T=Hyncjfi4GfdZ+0D2xM+jRSaYCAWCdaKxPUcQ@mail.gmail.com>
From: Haibo Xu <xiaobo55x@gmail.com>
Date: Mon, 4 Dec 2023 10:42:24 +0800
Message-ID: <CAJve8omitHDpijJaLV_wHk+5LXpsBUWF8_eTD4MeWKM-807Siw@mail.gmail.com>
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

On Fri, Sep 15, 2023 at 2:21=E2=80=AFPM Haibo Xu <xiaobo55x@gmail.com> wrot=
e:
>
> On Thu, Sep 14, 2023 at 5:52=E2=80=AFPM Andrew Jones <ajones@ventanamicro=
.com> wrote:
> >
> > On Thu, Sep 14, 2023 at 09:37:03AM +0800, Haibo Xu wrote:
> > > Add a KVM selftests to validate the Sstc timer functionality.
> > > The test was ported from arm64 arch timer test.
> >
> > I just tried this test out. Running it over and over again on QEMU I se=
e
> > it works sometimes, but it frequently fails with the
> > GUEST_ASSERT_EQ(config_iter + 1, irq_iter) assert and at least once I
> > also saw the __GUEST_ASSERT(xcnt >=3D cmp) assert.
> >
>
> Good catch!
>
> I can also reproduce this issue and it is a common problem for both
> arm64 and riscv because it also happens in a arm64 Qemu VM.
>
> It seems like a synchronization issue between host and guest shared
> variables. Will double check the test code.
>
> > Thanks,
> > drew

Hi Andrew,

After several rounds of regression testing, some findings:
1. The intermittent failure also happened on ARM64 Qemu VM, and even
in the initial arch_timer commit(4959d8650e9f4).
2. it didn't happen on a ARM64 HW(but a different failure occured
during stress test)
3. The failure have a close relationship with
TIMER_TEST_ERR_MARGIN_US(default 100), and after increasing
     the macro to 300, the failure couldn't reproduced in 1000 loops
stress test in RISC-V Qemu VM

So my suggestion is we can expose the TIMER_TEST_ERR_MARGIN_US
parameter as an arch_timer test arg parameter
and tune it based on a specific test environment.

What's your opinion?

Regards,
Haibo
