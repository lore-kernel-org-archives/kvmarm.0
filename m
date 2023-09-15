Received: from mail-oi1-f171.google.com (mail-oi1-f171.google.com [209.85.167.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9CA663A5;
	Fri, 15 Sep 2023 10:21:20 +0000 (UTC)
Received: by mail-oi1-f171.google.com with SMTP id 5614622812f47-3ab8e324725so381260b6e.0;
        Fri, 15 Sep 2023 03:21:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694773280; x=1695378080;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=T2EQISS+TI6FymgehjVGYiebl+s7fB1qqSBohFwF18Y=;
        b=NZugN1bBxSNzhtnSCxByPgDNX546xui31JpRyLoJmlpxBxm0rjaGAIBqQUHhYZkzcW
         /430pQ/s4JkkX5s8HAxexk7sEx6wB2zDy3KMdL5qKVUDNBm2XXGZqMXGsQWPX2iZIvoJ
         5JUQFOfmnO1FOXisjnpcOvYTxhdhUF/0lER8tSoelYHtydPwESsa8zv+6JgWsvwDxS0e
         vtv7zSXyZHRz8FzUkFitm86Pj27Z1C/unjBbI6pnPAKmiqtgOnUC12O2kKUT/5FSAV4o
         R+KBpGcWlhwn2d6EArsPL1uhZ22c+ySx1/z7nkCsyBQ4FEDNLezmdgkXXEqp04fM/DHA
         0WXQ==
X-Gm-Message-State: AOJu0YwSymf3tHZjNYJwJZE+VFJWmzhs+TDIJRfNV7yD1Nkx2A7ZUYy1
	z8EJmTj0Nuq9UwpJFy9tDQpVuR0PsTvkGbMNWLo=
X-Google-Smtp-Source: AGHT+IE91hPOK8y/kVeJFKJe8XyQhu0n/Q+0x2/bog6c455z4TN1+FSBkfJT1sJVgSvtor6J5rMGJgfx0mnsyytHqT0=
X-Received: by 2002:a4a:de83:0:b0:56e:94ed:c098 with SMTP id
 v3-20020a4ade83000000b0056e94edc098mr1206706oou.0.1694773279760; Fri, 15 Sep
 2023 03:21:19 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230913163823.7880-1-james.morse@arm.com> <20230913163823.7880-28-james.morse@arm.com>
 <CAMj1kXHRAt7ecB9p_dm3MjDL5wZkAsVh30hMY2SV_XUe=bm6Vg@mail.gmail.com>
 <20230914155459.00002dba@Huawei.com> <CAMj1kXFquiLGCMow3iujHUU4GBZx2t9KfKy1R9iqjBFjY+acaA@mail.gmail.com>
 <f5d9beea95e149ab89364dcdb0f8bf69@huawei.com> <ZQQDJT6MOaIOPmq5@shell.armlinux.org.uk>
 <CAJZ5v0jUQ+4G5ArYAtu1gvYF4356CK_QVTO4oWn0ukwdOiZaHA@mail.gmail.com> <80e36ff513504a0382a1cbce83e42295@huawei.com>
In-Reply-To: <80e36ff513504a0382a1cbce83e42295@huawei.com>
From: "Rafael J. Wysocki" <rafael@kernel.org>
Date: Fri, 15 Sep 2023 12:21:08 +0200
Message-ID: <CAJZ5v0gou9Pdj_CPC=vLJ-6S-hz+0VY+GMgXcRJk=6t9mL1ykw@mail.gmail.com>
Subject: Re: [RFC PATCH v2 27/35] ACPICA: Add new MADT GICC flags fields [code first?]
To: Salil Mehta <salil.mehta@huawei.com>
Cc: "Rafael J. Wysocki" <rafael@kernel.org>, "Russell King (Oracle)" <linux@armlinux.org.uk>, 
	Ard Biesheuvel <ardb@kernel.org>, Jonathan Cameron <jonathan.cameron@huawei.com>, 
	James Morse <james.morse@arm.com>, "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>, 
	"loongarch@lists.linux.dev" <loongarch@lists.linux.dev>, 
	"linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>, 
	"linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, 
	"linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, 
	"linux-riscv@lists.infradead.org" <linux-riscv@lists.infradead.org>, 
	"kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>, "x86@kernel.org" <x86@kernel.org>, 
	Jean-Philippe Brucker <jean-philippe@linaro.org>, "jianyong.wu@arm.com" <jianyong.wu@arm.com>, 
	"justin.he@arm.com" <justin.he@arm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Sep 15, 2023 at 11:34=E2=80=AFAM Salil Mehta <salil.mehta@huawei.co=
m> wrote:
>
>
> > From: Rafael J. Wysocki <rafael@kernel.org>
> > Sent: Friday, September 15, 2023 9:45 AM
> > To: Russell King (Oracle) <linux@armlinux.org.uk>
> > Cc: Salil Mehta <salil.mehta@huawei.com>; Ard Biesheuvel <ardb@kernel.o=
rg>;
> > Jonathan Cameron <jonathan.cameron@huawei.com>; James Morse
> > <james.morse@arm.com>; linux-pm@vger.kernel.org; loongarch@lists.linux.=
dev;
> > linux-acpi@vger.kernel.org; linux-arch@vger.kernel.org; linux-
> > kernel@vger.kernel.org; linux-arm-kernel@lists.infradead.org; linux-
> > riscv@lists.infradead.org; kvmarm@lists.linux.dev; x86@kernel.org; Jean=
-
> > Philippe Brucker <jean-philippe@linaro.org>; jianyong.wu@arm.com;
> > justin.he@arm.com
> > Subject: Re: [RFC PATCH v2 27/35] ACPICA: Add new MADT GICC flags field=
s
> > [code first?]
> >
> > On Fri, Sep 15, 2023 at 9:09=E2=80=AFAM Russell King (Oracle)
> > <linux@armlinux.org.uk> wrote:
> > >
> > > On Fri, Sep 15, 2023 at 02:29:13AM +0000, Salil Mehta wrote:
> > > > On x86, during init, if the MADT entry for LAPIC is found to be
> > > > online-capable and is enabled as well then possible and present
> > >
> > > Note that the ACPI spec says enabled + online-capable isn't defined.
> > >
> > > "The information conveyed by this bit depends on the value of the
> > > Enabled bit. If the Enabled bit is set, this bit is reserved and
> > > must be zero."
> > >
> > > So, if x86 is doing something with the enabled && online-capable
> > > state (other than ignoring the online-capable) then technically it
> > > is doing something that the spec doesn't define
> >
> > And so it is wrong.
>
>
> Or maybe, specification has not been updated yet. code-first?

Well, if you are aware of any change requests related to this and
posted as code-first, please let me know.
