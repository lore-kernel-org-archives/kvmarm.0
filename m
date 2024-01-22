Received: from mail-lf1-f45.google.com (mail-lf1-f45.google.com [209.85.167.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A1B03A8F8
	for <kvmarm@lists.linux.dev>; Mon, 22 Jan 2024 13:08:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705928912; cv=none; b=VaRGRKa0KPX3eGJx5UQQU9frOj/ttxY3zAxlEXWMqJ0akPVbYi6/8h09ntgmiJS8wcr4h/ae2dK3n2l2zUM/3BU4C7jRJjUrF5UTRnPpdNaYOH4y/oBN+ZI1Gp86euAZ3d3rvtV73HMrkGViRNPDa9JCWqwd+KvBsSY/Ezkinjs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705928912; c=relaxed/simple;
	bh=unKyj7OUQ0UO9RiD13jB29hlqPZ5XOiLoEIykUQJAqg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=YQbXuKYQMEd3MOzN9OD10cJVE0E8xkZhczC518GlAyFybF7VDntOwRKWGaYEKtBBMLdRLl7Y2BNw95Up3acjT34k5kbupnWo0GD/vVhhFEMg0Z8Gw2A1qUvDFvVmMSA9nXtzc/zE89zNpg0kgzwXf0RhaMMJtDm3wdrCp5BNpdI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=YnzBlWrC; arc=none smtp.client-ip=209.85.167.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="YnzBlWrC"
Received: by mail-lf1-f45.google.com with SMTP id 2adb3069b0e04-50edf4f478eso3990707e87.3
        for <kvmarm@lists.linux.dev>; Mon, 22 Jan 2024 05:08:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1705928908; x=1706533708; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+I4p4d7+rP24cbQOhthF3qkqodnNh9+wAcSbkAH/bzs=;
        b=YnzBlWrC2Xz0YnUJEO76aG52sZS+wU2N0uOWf9b18uY4cdnQ9klQWKzvo788iSg32X
         DgkQkJOGCfA+DlH8q6w2cN+pQj+idekcJrtm+Hf/X9LMEhKvQGYBaIctpjxaZTC3WqDO
         G33HlNaYCkMSSgoQP10aQERVmY1qNSQDH5XrjlM+QvToNPIGS004zL+4YYkB1a+WS43x
         3u3o+jJYWCmYPwa1ms1E1hTdrTX5he6F9UmBhx9wgl65bSRQHw2HX3Y47i2AzjmwqyPj
         Jyl0S0W6KyaZmkrBupVW88uDD78M+OdVIipYTlq4PXw7tEOqfaTrIUxadQpu2DKz8GXU
         bf2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1705928908; x=1706533708;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+I4p4d7+rP24cbQOhthF3qkqodnNh9+wAcSbkAH/bzs=;
        b=f9+EZMKmzkP90NwHWBUWg7Ly5FhaS2h03lk2IZC67CLQrAfaJrKUTe5ALD2sbAoUTs
         zCUJdQPtbC90nKyPDAsfM+8RiPCU18hN5Na1YSJiLkH1vMkIOi5Wm0rE6dxwS2gcfkxg
         E+jtu0ShTvFqFF/SZRIrS/PhE3PZCsFzkp1wanBAo24lpXc2O4G1AetUP0fXSwUcTADU
         x2v6JSfjAQXbn8B1acF+1nvVO/9afPhjfTma7wo77fFhWrERo92tV+Q1hZr3LkL+WqB5
         gsISNANjooKfthqy9ZIFU/EYIzhuqpmQ44cWh4j0eU65hqSH4M6Cy4r+GVgeovY2P6rH
         3xQA==
X-Gm-Message-State: AOJu0YwJmjTpINTOVIle58lCC+t0Lx3khUinm0uSdsVr9pq5bi5XcOaA
	KrHR2EacE8rtFtszxPip8sga1OxrBuByhyq/uDpYAQcIHy9phop9hIspkzEjOiD3vRHewPnL0ws
	T3nVuSBRQtnYQmt0J8bcai5jo/bk=
X-Google-Smtp-Source: AGHT+IFxMr1N5U9JEAKS7V3w8GVY3Jj+ucXTqHlbxRUbtCIR7nwq3gck9SN+dTPf/AtQUb++qPGvaIBbGYY8gF5qz9I=
X-Received: by 2002:a19:690d:0:b0:50e:abd1:bfca with SMTP id
 e13-20020a19690d000000b0050eabd1bfcamr1596377lfc.128.1705928908378; Mon, 22
 Jan 2024 05:08:28 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <cover.1705916069.git.haibo1.xu@intel.com> <173c9b64c4c43cd585f6b177a7d434dcedc905fa.1705916069.git.haibo1.xu@intel.com>
 <20240122-0ddedacdeb64808477a7911d@orel>
In-Reply-To: <20240122-0ddedacdeb64808477a7911d@orel>
From: Haibo Xu <xiaobo55x@gmail.com>
Date: Mon, 22 Jan 2024 21:08:16 +0800
Message-ID: <CAJve8om6EG7nE891UOBCHJ6t2dsbJGeKDKUfNfJeffBB1QP8NQ@mail.gmail.com>
Subject: Re: [PATCH v5 02/12] KVM: arm64: selftests: Data type cleanup for
 arch_timer test
To: Andrew Jones <ajones@ventanamicro.com>
Cc: Haibo Xu <haibo1.xu@intel.com>, Paul Walmsley <paul.walmsley@sifive.com>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Paolo Bonzini <pbonzini@redhat.com>, Shuah Khan <shuah@kernel.org>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, James Morse <james.morse@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Anup Patel <anup@brainfault.org>, Atish Patra <atishp@atishpatra.org>, Guo Ren <guoren@kernel.org>, 
	Conor Dooley <conor.dooley@microchip.com>, Mayuresh Chitale <mchitale@ventanamicro.com>, 
	wchen <waylingii@gmail.com>, Daniel Henrique Barboza <dbarboza@ventanamicro.com>, 
	Samuel Holland <samuel@sholland.org>, Jisheng Zhang <jszhang@kernel.org>, 
	Minda Chen <minda.chen@starfivetech.com>, Sean Christopherson <seanjc@google.com>, 
	Peter Xu <peterx@redhat.com>, Like Xu <likexu@tencent.com>, 
	Vipin Sharma <vipinsh@google.com>, Aaron Lewis <aaronlewis@google.com>, 
	Thomas Huth <thuth@redhat.com>, Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>, 
	linux-kernel@vger.kernel.org, linux-riscv@lists.infradead.org, 
	kvm@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kvm-riscv@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Jan 22, 2024 at 8:21=E2=80=AFPM Andrew Jones <ajones@ventanamicro.c=
om> wrote:
>
> On Mon, Jan 22, 2024 at 05:58:32PM +0800, Haibo Xu wrote:
> > Change signed type to unsigned in test_args struct which
> > only make sense for unsigned value.
> >
> > Suggested-by: Andrew Jones <ajones@ventanamicro.com>
> > Signed-off-by: Haibo Xu <haibo1.xu@intel.com>
> > ---
> >  tools/testing/selftests/kvm/aarch64/arch_timer.c | 12 ++++++------
> >  1 file changed, 6 insertions(+), 6 deletions(-)
> >
> > diff --git a/tools/testing/selftests/kvm/aarch64/arch_timer.c b/tools/t=
esting/selftests/kvm/aarch64/arch_timer.c
> > index 274b8465b42a..3260fefcc1b3 100644
> > --- a/tools/testing/selftests/kvm/aarch64/arch_timer.c
> > +++ b/tools/testing/selftests/kvm/aarch64/arch_timer.c
> > @@ -42,10 +42,10 @@
> >  #define TIMER_TEST_MIGRATION_FREQ_MS 2
> >
> >  struct test_args {
> > -     int nr_vcpus;
> > -     int nr_iter;
> > -     int timer_period_ms;
> > -     int migration_freq_ms;
> > +     uint32_t nr_vcpus;
> > +     uint32_t nr_iter;
> > +     uint32_t timer_period_ms;
> > +     uint32_t migration_freq_ms;
> >       struct kvm_arm_counter_offset offset;
> >  };
> >
> > @@ -57,7 +57,7 @@ static struct test_args test_args =3D {
> >       .offset =3D { .reserved =3D 1 },
> >  };
> >
> > -#define msecs_to_usecs(msec)         ((msec) * 1000LL)
> > +#define msecs_to_usecs(msec)         ((msec) * 1000ULL)
> >
> >  #define GICD_BASE_GPA                        0x8000000ULL
> >  #define GICR_BASE_GPA                        0x80A0000ULL
> > @@ -72,7 +72,7 @@ enum guest_stage {
> >
> >  /* Shared variables between host and guest */
> >  struct test_vcpu_shared_data {
> > -     int nr_iter;
> > +     uint32_t nr_iter;
> >       enum guest_stage guest_stage;
> >       uint64_t xcnt;
> >  };
> > --
> > 2.34.1
> >
>
> Reviewed-by: Andrew Jones <ajones@ventanamicro.com>

Thanks!
