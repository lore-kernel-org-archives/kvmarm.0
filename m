Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2032066B5E;
	Mon, 15 Apr 2024 12:41:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713184894; cv=none; b=cUPJVBJssqbsQ/H0GZHpRpTBUjrnDk+qIGUePN0RUywhtJd6l8vufNp6iOUFm/+jCbbEodpqmaQjd9jLN93lRzM1YWdMFKdBlpcPzB+nh+ojF0nwC688rbjEDyI4oYSZko431FE2v4CtmP+hLX47dCfzNPCZnMNSeVvlVvL9wl8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713184894; c=relaxed/simple;
	bh=buAY7ZM4gi8QlZw7BB+ZLWn0qIOR2VL9zrGMzz5ULv8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=jc1Rjsuj7FW3LDjtS7JCC5+TjhYA386UW3to1EloVJGhsrgNjuLKSWihTIBH+Hp9H2dCDO2F5QHd5DIBc9AyNuyrq86tPE4n4txw0MVTV2r1kDhAZIefDRTooyhsQJsS5EVxRbZvQfM1fsLmNizv9phvVuUYn1szGHKBqjXIFOA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=uDywlo3e; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="uDywlo3e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0B83C2BD10;
	Mon, 15 Apr 2024 12:41:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713184893;
	bh=buAY7ZM4gi8QlZw7BB+ZLWn0qIOR2VL9zrGMzz5ULv8=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=uDywlo3eLI2tVc1D9CLx4LZ4G8hIE1itB9HMDkq8SUPhmlWl7eTsyIlAr51cwEUuj
	 72kruoK9chaoKZr+Ceou+11cFcVuvCH4sCN0L4Cxiiue3nRoks8ECZru6SgXyyfAfP
	 AuVxg8QRJkX6dLUFZfoDFxVr1B5j3KRVoZ1LF0/6q28eoNBOu2gPTLA56BrVX/ww7h
	 aKGdM5DYmXTtTiUqCJYRuItPDOjMAmscGJ7QKBfSC5MpJ2GjRX6b6pjiNxP8PJla0J
	 T6ITv29i8sM4fzvSX2YavCWCaz8NhQUI3ludzV9NdP7Xcl2BQsEWSPAg8BAFWR0sfW
	 6qK/Xv6hfIhSA==
Received: by mail-oa1-f50.google.com with SMTP id 586e51a60fabf-22ec8db3803so286857fac.1;
        Mon, 15 Apr 2024 05:41:33 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCXOss4PuELbA8YOh6bE2Ztp66yL5UINycHmjayoVilXfU6rq4ANOnNqNI8enhtElq1BYlRxOWEIe9vA3bn/QDlFHA2fKvCJCErcu8uimi021K6yyg0N6uRFq8/DuQCDqDTZ
X-Gm-Message-State: AOJu0YwV3YBUECMWpJKPmkP4LhLamjCceJpzwHl6k3WWe7OV+7Oxp03J
	Zp/MVycQwDVKmwIjJfq14YrJ8r0yzkJ3QK4+QOZtBnJuNjVB6v/PEjt/zpRnhh+i33Ub/EXqWto
	0aeEaLnuhJ+6oXGN81HAGiFU1F/M=
X-Google-Smtp-Source: AGHT+IGeLFnWYufDDzC52dqknuhGF/TW0Y9hUl6ur7WUgRi7s5K8EfbyxZxEYIwgG4SCZs1V9WtWTJDSEmXLaJiBNig=
X-Received: by 2002:a05:6870:32d3:b0:22e:cfdd:b32c with SMTP id
 r19-20020a05687032d300b0022ecfddb32cmr11239716oac.2.1713184893232; Mon, 15
 Apr 2024 05:41:33 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240412143719.11398-1-Jonathan.Cameron@huawei.com>
 <20240412143719.11398-4-Jonathan.Cameron@huawei.com> <CAJZ5v0gNvy2e=hOGQQ2kLpnrDr8=QGBax-E5odEJ=7BA8qW-9A@mail.gmail.com>
 <ZhmWkE+fCEG/WFoi@shell.armlinux.org.uk> <87bk6ez4hj.ffs@tglx>
 <ZhmtO6zBExkQGZLk@shell.armlinux.org.uk> <878r1iyxkr.ffs@tglx>
 <20240415094552.000008d7@Huawei.com> <CAJZ5v0ireu4pOedLjMjK2NrLkq_2vySpdgEgGccQEiFC5=otWQ@mail.gmail.com>
 <20240415125649.00001354@huawei.com> <CAJZ5v0iNSmV6EsBOc5oYWSTR9UvFOeg8_mj8Ofhum4Tonb3kNQ@mail.gmail.com>
 <8d4ce570374b47819aef51cabab766d8@huawei.com>
In-Reply-To: <8d4ce570374b47819aef51cabab766d8@huawei.com>
From: "Rafael J. Wysocki" <rafael@kernel.org>
Date: Mon, 15 Apr 2024 14:41:17 +0200
X-Gmail-Original-Message-ID: <CAJZ5v0iqWv+XKpPL=kteV6_+=B_1j32QgPhab81i5=xsZ_YXnA@mail.gmail.com>
Message-ID: <CAJZ5v0iqWv+XKpPL=kteV6_+=B_1j32QgPhab81i5=xsZ_YXnA@mail.gmail.com>
Subject: Re: [PATCH v5 03/18] ACPI: processor: Register deferred CPUs from acpi_processor_get_info()
To: Salil Mehta <salil.mehta@huawei.com>
Cc: "Rafael J. Wysocki" <rafael@kernel.org>, Jonathan Cameron <jonathan.cameron@huawei.com>, 
	Thomas Gleixner <tglx@linutronix.de>, "Russell King (Oracle)" <linux@armlinux.org.uk>, 
	"linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>, 
	"loongarch@lists.linux.dev" <loongarch@lists.linux.dev>, 
	"linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>, 
	"linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, 
	"linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, 
	"kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>, "x86@kernel.org" <x86@kernel.org>, 
	Miguel Luis <miguel.luis@oracle.com>, James Morse <james.morse@arm.com>, 
	Jean-Philippe Brucker <jean-philippe@linaro.org>, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>, Linuxarm <linuxarm@huawei.com>, 
	"justin.he@arm.com" <justin.he@arm.com>, "jianyong.wu@arm.com" <jianyong.wu@arm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Apr 15, 2024 at 2:37=E2=80=AFPM Salil Mehta <salil.mehta@huawei.com=
> wrote:
>
> Hi Rafael,
>
> >  From: Rafael J. Wysocki <rafael@kernel.org>
> >  Sent: Monday, April 15, 2024 1:04 PM
> >

[cut]

> >
> >  I need to do some investigation which will take some time I suppose.
>
>
> You might find below cover letter and links to the presentations useful:
>
> 1. https://lore.kernel.org/qemu-devel/20230926100436.28284-1-salil.mehta@=
huawei.com/
> 2. https://kvm-forum.qemu.org/2023/KVM-forum-cpu-hotplug_7OJ1YyJ.pdf
> 3. https://kvm-forum.qemu.org/2023/Challenges_Revisited_in_Supporting_Vir=
t_CPU_Hotplug_-__ii0iNb3.pdf
> 4. https://sched.co/eE4m

Thanks, I'll go through this, but I kind of doubt if it helps me with
finding out what to do with the hotadd_init flag.
