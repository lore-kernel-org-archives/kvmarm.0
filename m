Received: from mail-lf1-f45.google.com (mail-lf1-f45.google.com [209.85.167.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77D822D05D
	for <kvmarm@lists.linux.dev>; Tue,  5 Dec 2023 07:58:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nQHzsUe0"
Received: by mail-lf1-f45.google.com with SMTP id 2adb3069b0e04-50bee606265so2841884e87.2
        for <kvmarm@lists.linux.dev>; Mon, 04 Dec 2023 23:58:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1701763094; x=1702367894; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mDaBQlGZ8UjeyvNNGC2XDs5wlZCfXV5wgyIn7Cj35I0=;
        b=nQHzsUe0NBZZMksybWTcXJR5VwZJNLbE7/AvLC54UOAJOBuzSm89E1Go9XaY6xNYSw
         fFSO98XTuZJI8toMsgeFl7CBQ/lz8R3zYNaUggBR7g/2x9oIRirFr6myrR7L4d2W5+uH
         7+ZHI53vPlVZsb+uMrDxGwIIVYo5wr5TvKo3h/FrbPhACrUkKQGJgvWqROpQ3huIkA+U
         ADuCusqxBk01EftsU1nsjBWf+3GGQ3j4SZyfIY/EEsUs7QIx5viryQLNTvOFzv5CBO+C
         6UrB+MxSn/J56nbWW5106TwVmPuHXhHTDEPDCFT0HFDNu+irFVkVtDWY8ylGpotSw2af
         XthQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701763094; x=1702367894;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=mDaBQlGZ8UjeyvNNGC2XDs5wlZCfXV5wgyIn7Cj35I0=;
        b=S4zrNnR5FK2/Yn9D68pqMoul1C7FP3V8HbFOeDStUZm5r6K3p6lL3mdAbPJD/PVcLK
         5rbXgPOvKLCQiorVKZGHU/Pt2hVqvXjB3r6NHgxUah9URi07T8ieKyEQ1LcdR4eJelAc
         7nCfJa6BdfM+9v0CYACeTBwlIILSjoDAE0/EKVt4avgTrxEHPko70fJZWpMQxaMUbAE4
         kPe27Ho4X+3KMDPysfUvt4+xBIZDCRNe8NF0y80dPVR05VbldoOM++NdJuHS0HlygNAg
         kKrE9+6HCTLEGWjxywfT5m5LiI6NWEeh8TAVfbcx6AxGwLMRMNRnrQDou7etoypM8JbW
         No2A==
X-Gm-Message-State: AOJu0Yy7eZntNZ+ch4kCup6Iqa3t50/wcvTOO3urlOnlSOZ3nJ9Zn79r
	+4fKjtJs0EypvYPpUC187ZEwCcOeoHhslbbQyHw=
X-Google-Smtp-Source: AGHT+IFB7AXgBvjJC6KXRzmHN5fiSmN/CqaafqDV8LUeWsssBRPFI6TrMLt6kXoA/HN17H0Nd9dUlNSsNYRV4on7U8I=
X-Received: by 2002:a05:6512:3b8f:b0:50b:f019:366a with SMTP id
 g15-20020a0565123b8f00b0050bf019366amr2333164lfv.109.1701763094196; Mon, 04
 Dec 2023 23:58:14 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <cover.1694421911.git.haibo1.xu@intel.com> <64e0637cd6f22dd7557ed44bd2242001e7830d1c.1694421911.git.haibo1.xu@intel.com>
 <20230914-d2e594e7d84503ad14036e2d@orel> <CAJve8onhY534T=Hyncjfi4GfdZ+0D2xM+jRSaYCAWCdaKxPUcQ@mail.gmail.com>
 <CAJve8omitHDpijJaLV_wHk+5LXpsBUWF8_eTD4MeWKM-807Siw@mail.gmail.com> <20231204-980c95cca344f718ac6a48b6@orel>
In-Reply-To: <20231204-980c95cca344f718ac6a48b6@orel>
From: Haibo Xu <xiaobo55x@gmail.com>
Date: Tue, 5 Dec 2023 15:58:02 +0800
Message-ID: <CAJve8okwyPwY3AZcA31=aoc1tyZN7hx_5AmF0KMmn-bZ1VnyHA@mail.gmail.com>
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

On Mon, Dec 4, 2023 at 7:32=E2=80=AFPM Andrew Jones <ajones@ventanamicro.co=
m> wrote:
>
> On Mon, Dec 04, 2023 at 10:42:24AM +0800, Haibo Xu wrote:
> > On Fri, Sep 15, 2023 at 2:21=E2=80=AFPM Haibo Xu <xiaobo55x@gmail.com> =
wrote:
> > >
> > > On Thu, Sep 14, 2023 at 5:52=E2=80=AFPM Andrew Jones <ajones@ventanam=
icro.com> wrote:
> > > >
> > > > On Thu, Sep 14, 2023 at 09:37:03AM +0800, Haibo Xu wrote:
> > > > > Add a KVM selftests to validate the Sstc timer functionality.
> > > > > The test was ported from arm64 arch timer test.
> > > >
> > > > I just tried this test out. Running it over and over again on QEMU =
I see
> > > > it works sometimes, but it frequently fails with the
> > > > GUEST_ASSERT_EQ(config_iter + 1, irq_iter) assert and at least once=
 I
> > > > also saw the __GUEST_ASSERT(xcnt >=3D cmp) assert.
> > > >
> > >
> > > Good catch!
> > >
> > > I can also reproduce this issue and it is a common problem for both
> > > arm64 and riscv because it also happens in a arm64 Qemu VM.
> > >
> > > It seems like a synchronization issue between host and guest shared
> > > variables. Will double check the test code.
> > >
> > > > Thanks,
> > > > drew
> >
> > Hi Andrew,
> >
> > After several rounds of regression testing, some findings:
> > 1. The intermittent failure also happened on ARM64 Qemu VM, and even
> > in the initial arch_timer commit(4959d8650e9f4).
> > 2. it didn't happen on a ARM64 HW(but a different failure occured
> > during stress test)
> > 3. The failure have a close relationship with
> > TIMER_TEST_ERR_MARGIN_US(default 100), and after increasing
> >      the macro to 300, the failure couldn't reproduced in 1000 loops
> > stress test in RISC-V Qemu VM
> >
> > So my suggestion is we can expose the TIMER_TEST_ERR_MARGIN_US
> > parameter as an arch_timer test arg parameter
> > and tune it based on a specific test environment.
> >
> > What's your opinion?
>
> The concept of "timeout for an interrupt to arrive" is always going to
> leave us exposed to random failures. Your suggestion of making the
> timeout user configurable is probably the best we can do. I would
> suggest also adding more descriptive failure text and a hint about
> trying to adjust the timeout.
>
> Or, one thing we do in kvm-unit-tests, is to reduce typical delays while
> allowing expected delays to be longer by looping over a shorter delay and
> a non-fatal check, i.e.
>
>  pass =3D false;
>  for (i =3D 0; i < 10; i++) {
>    udelay(100);
>    if (check(...)) {
>       pass =3D true;
>       break;
>    }
>  }
>  assert(pass);
>
> We could try that approach here too.
>
> Thanks,
> drew

Thanks for the feedback, I will send out patch set v4 soon!
