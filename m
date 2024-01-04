Received: from mail-ed1-f46.google.com (mail-ed1-f46.google.com [209.85.208.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8E96210E8
	for <kvmarm@lists.linux.dev>; Thu,  4 Jan 2024 11:09:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="DNxQYhoP"
Received: by mail-ed1-f46.google.com with SMTP id 4fb4d7f45d1cf-556aa7fe765so452857a12.2
        for <kvmarm@lists.linux.dev>; Thu, 04 Jan 2024 03:09:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1704366577; x=1704971377; darn=lists.linux.dev;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=74N1Cq913BTRhayzvgQnIcxYARZsluZ7x3qTYNrywUw=;
        b=DNxQYhoPDkDqei18MCqgvH3MtXp+VFCVTXXKdlaBoqC1EOgHaS/FdFQB7+nN9wz8Pu
         xi0LOc+hZKqZ7yu8fGqVl1uRIfOewujiDSOCRiA2k+opefVuhqKVNA5+BG0zFgfK6XuV
         YmUCipM/B5XyXvVS4F+gEw77yh3H9/g4jfJhzL/1RCsABBKW1P0OlaPuKTMUzVe6qTIE
         zxtl672uneUu2ooHUF0zZvr6E3Bh4LQA/3VmnN6ODdUohQ+jERM4IWbHsZnrzRIF1iYC
         MG2mILqglVoU4scCV+bMC9i9qugv0F0vOvCHvMJVmJMnU9G8OQXtvAHmNsclY6+6qCcY
         0OSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1704366577; x=1704971377;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=74N1Cq913BTRhayzvgQnIcxYARZsluZ7x3qTYNrywUw=;
        b=bIQ5PQUowF4xOSZ+2QIYfAf7OJNnG5D+zB5blWSgzH0OSWKmLH6lP7zen1h1xjcd8V
         YyTVBz3eMDWGP3GRNMIu6gjohCzYEuiMqj8uHvNuLijJFp2+XxfITOjLOkp7MXchD4Qi
         /wikBCSMXs4qMSAdycbkdyZ+OXd6asntbx1Hmbr8jKezxwuXMR7xvvmt6nNTYBvMzSlv
         1Uq57vCBJjxL7D9bk57Rl+DAhrP+kuvFulNP6yvuEeSJ4UVjvQ/yydtIYa6ybvcL6KpE
         lSUleRRHmHfXq6+zDugoA6jAfDK5OBM+ZtmnNQHLSmvFY3uCJnz3fgSSolKywVipwV2e
         lXAw==
X-Gm-Message-State: AOJu0Yy+h8QGMIUH9k1uN0YzQpzJioU8SlYuDQP6Qh+5wIRZVQ9+/Eow
	p9gu7HaPcCUvVmQGMHqIX7dBZJDp1AQZMw==
X-Google-Smtp-Source: AGHT+IEQCwN9GP2QDGQCOCSlVQdGYcgmdoQnHVO1JwxIhclSNsrhshtNA82sSQCt5a2uS2CNGPMffw==
X-Received: by 2002:a05:6402:3193:b0:556:b393:7559 with SMTP id di19-20020a056402319300b00556b3937559mr231896edb.23.1704366576957;
        Thu, 04 Jan 2024 03:09:36 -0800 (PST)
Received: from localhost (2001-1ae9-1c2-4c00-20f-c6b4-1e57-7965.ip6.tmcz.cz. [2001:1ae9:1c2:4c00:20f:c6b4:1e57:7965])
        by smtp.gmail.com with ESMTPSA id 8-20020a0564021f4800b005545dffa0bdsm16441289edz.13.2024.01.04.03.09.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Jan 2024 03:09:36 -0800 (PST)
Date: Thu, 4 Jan 2024 12:09:35 +0100
From: Andrew Jones <ajones@ventanamicro.com>
To: Haibo Xu <xiaobo55x@gmail.com>
Cc: Marc Zyngier <maz@kernel.org>, Haibo Xu <haibo1.xu@intel.com>, 
	Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Albert Ou <aou@eecs.berkeley.edu>, Paolo Bonzini <pbonzini@redhat.com>, 
	Shuah Khan <shuah@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	James Morse <james.morse@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Anup Patel <anup@brainfault.org>, 
	Atish Patra <atishp@atishpatra.org>, Guo Ren <guoren@kernel.org>, 
	Mayuresh Chitale <mchitale@ventanamicro.com>, Greentime Hu <greentime.hu@sifive.com>, 
	wchen <waylingii@gmail.com>, Conor Dooley <conor.dooley@microchip.com>, 
	Heiko Stuebner <heiko@sntech.de>, Minda Chen <minda.chen@starfivetech.com>, 
	Samuel Holland <samuel@sholland.org>, Jisheng Zhang <jszhang@kernel.org>, 
	Sean Christopherson <seanjc@google.com>, Peter Xu <peterx@redhat.com>, Like Xu <likexu@tencent.com>, 
	Vipin Sharma <vipinsh@google.com>, Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>, 
	Aaron Lewis <aaronlewis@google.com>, Thomas Huth <thuth@redhat.com>, linux-kernel@vger.kernel.org, 
	linux-riscv@lists.infradead.org, kvm@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, kvm-riscv@lists.infradead.org
Subject: Re: Re: [PATCH v4 11/11] KVM: selftests: Enable tunning of
 err_margin_us in arch timer test
Message-ID: <20240104-be1acabe472432f709ee408c@orel>
References: <cover.1702371136.git.haibo1.xu@intel.com>
 <0343a9e4bfa8011fbb6bca0286cee7eab1f17d5d.1702371136.git.haibo1.xu@intel.com>
 <8734vy832j.wl-maz@kernel.org>
 <CAJve8onc0WN5g98aOVBmJx15wFBAqfBKJ+ufoLY+oqYyVL+=3A@mail.gmail.com>
 <f98879dc24f948f7a8a7b5374a32bc04@kernel.org>
 <CAJve8ona7g=LxW1YeRB_FqGodF973H=A3b2m8054gmzK=Z7_ww@mail.gmail.com>
 <87zfy5t1qt.wl-maz@kernel.org>
 <CAJve8o=nTsAwwgSib4vOLXjOWSMV2+J+BFsUZ57OdAK7eW8q8A@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAJve8o=nTsAwwgSib4vOLXjOWSMV2+J+BFsUZ57OdAK7eW8q8A@mail.gmail.com>

On Thu, Dec 21, 2023 at 10:58:40AM +0800, Haibo Xu wrote:
> On Wed, Dec 20, 2023 at 9:58 PM Marc Zyngier <maz@kernel.org> wrote:
> >
> > On Wed, 20 Dec 2023 13:51:24 +0000,
> > Haibo Xu <xiaobo55x@gmail.com> wrote:
> > >
> > > On Wed, Dec 20, 2023 at 5:00 PM Marc Zyngier <maz@kernel.org> wrote:
> > > >
> > > > On 2023-12-20 06:50, Haibo Xu wrote:
> > > > > On Wed, Dec 20, 2023 at 2:22 AM Marc Zyngier <maz@kernel.org> wrote:
> > > > >>
> > > > >> On Tue, 12 Dec 2023 09:31:20 +0000,
> > > > >> Haibo Xu <haibo1.xu@intel.com> wrote:
> > > > >> > diff --git a/tools/testing/selftests/kvm/include/timer_test.h b/tools/testing/selftests/kvm/include/timer_test.h
> > > > >> > index 968257b893a7..b1d405e7157d 100644
> > > > >> > --- a/tools/testing/selftests/kvm/include/timer_test.h
> > > > >> > +++ b/tools/testing/selftests/kvm/include/timer_test.h
> > > > >> > @@ -22,6 +22,7 @@ struct test_args {
> > > > >> >       int nr_iter;
> > > > >> >       int timer_period_ms;
> > > > >> >       int migration_freq_ms;
> > > > >> > +     int timer_err_margin_us;
> > > > >>
> > > > >> ... except that you are storing it as a signed value. Some consistency
> > > > >> wouldn't hurt, really, and would avoid issues when passing large
> > > > >> values.
> > > > >>
> > > > >
> > > > > Yes, it's more proper to use an unsigned int for the non-negative error
> > > > > margin.
> > > > > Storing as signed here is just to keep the type consistent with that
> > > > > of timer_period_ms
> > > > > since there will be '+' operation in other places.
> > > > >
> > > > >         tools/testing/selftests/kvm/aarch64/arch_timer.c
> > > > >         /* Setup a timeout for the interrupt to arrive */
> > > > >          udelay(msecs_to_usecs(test_args.timer_period_ms) +
> > > > >              test_args.timer_err_margin_us);
> > > >
> > > > But that's exactly why using a signed quantity is wrong.
> > > > What does it mean to have a huge *negative* margin?
> > > >
> > >
> > > Hi Marc,
> > >
> > > I agree that negative values are meaningless for the margin.
> > > If I understand correctly, the negative margin should be filtered by
> > > assertion in atoi_non_negative().
> >
> > No. Please.
> >
> > atoi_non_negative() returns a uint32_t, which is what it should do.
> > The bug is squarely in the use of an 'int' to store such value, and it
> > is the *storage* that turns a positive value into a negative one.
> >
> 
> Thanks for the detailed info!
> 
> May I understand that your concern is mainly for a platform with 64bit int type,
> which may trigger the positive to negative convert?
> 
> If so, I think we may need to do a clean up for the test code since
> several other
> places have the same issue.

Yes, I think we should do that cleanup. While there are probably several
offenders scattered throughout kvm selftests, we can keep the scope of
this series focused on arch_timer.c. Let's audit all uses of signed types
and convert them to unsigned as necessary with some separate patch(es)
before splitting the test, so both aarch64 and riscv get the cleanups.

Thanks,
drew
