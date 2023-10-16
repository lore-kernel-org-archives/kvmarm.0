Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03BAD30F92
	for <kvmarm@lists.linux.dev>; Mon, 16 Oct 2023 19:05:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="KeSvHsOO"
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-1c9c496c114so37625ad.0
        for <kvmarm@lists.linux.dev>; Mon, 16 Oct 2023 12:05:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1697483128; x=1698087928; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=b1VlSEnGZgno+VCZ2CMhUaRzE+QVLRzzBhFEmOew2zU=;
        b=KeSvHsOO0E1L6upX2FWy616Oygv2ilZ1fFXzqNLFhhH17J8cgwGGF/MY5rcxF7TJ2S
         BdxPktW0QTSbd+D17SsBS4zGVpEE+lyLai4DQibElHeEj7TDI4u+8scVQQrZrrfTkfgH
         sE0j2vTZ3fgyRYb13veFSVOXXP5gbJptvmA2cBctw+qT6KMjvQpde47tO8ruinwkWjUr
         0WctVjRo6M6rjwocGtfqrAFoXFnOqTPjNJdej8KPssA7AvVoofbm49kajvSeY9CS9Geq
         m+LqzUnJtKBmjPF+Dq3LbAPRElZy75f/AfQ9Wg5E4TbFDSu0vEcWjjyjwAqpdCu6V7x2
         LcAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697483128; x=1698087928;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=b1VlSEnGZgno+VCZ2CMhUaRzE+QVLRzzBhFEmOew2zU=;
        b=iospRYNbsVt3B1XwDtPt/p3THd0Hj3+zYFR91pGhS2kaci7IHDB5zdk7RskWVAohrd
         JWdRL5jAuod94x2gpN/z40qcmK2Wt2XzWSBSxrp4PQwP4p6nX1dtQueWZzbEEjl8BQLU
         SwhhpuIkZJzuKhJz8LLZTRUys/UwOlyt7IoGwDM83Xp/B9uQX9KhYn+bilTtu2/dmPHf
         vC0FA7Rdd+Uh+GxjVJK/Ynh4txWSDpKFW9snMCpy6LWW2mV+sodUj55F2rrk4aagAMfI
         M+XzrLv5aF89QyvdcUKGjRidWyORmyDgeaz/GXDx/vzOszDJ986+dP0QtTfoU9aXlk7g
         AY8A==
X-Gm-Message-State: AOJu0YywO4R4aVL9RwCo6gsBovjFR8ldDpOX4p6iE7skRMmF9FOkuSSw
	yk17LY43MF5gLEeGGpWmBO/fk3geSsxEh6q3rrSw2A==
X-Google-Smtp-Source: AGHT+IGzqX6lfM4KPQZaOFHNso4U2b11m5YXW3DWX1mnMS9JBJdU3dcZ2THIjxAivTgEAatvr6FAe6c5mnJrC2Caufk=
X-Received: by 2002:a17:903:1c1:b0:1c9:af6a:6d0d with SMTP id
 e1-20020a17090301c100b001c9af6a6d0dmr25965plh.9.1697483128045; Mon, 16 Oct
 2023 12:05:28 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20231009230858.3444834-1-rananta@google.com> <20231009230858.3444834-11-rananta@google.com>
 <44608d30-c97a-c725-e8b2-0c5a81440869@redhat.com> <65b8bbdb-2187-3c85-0e5d-24befcf01333@redhat.com>
 <CAJHc60zPc6eM+t7pOM19aKbf_9cMvj_LnPnG1EO35=EP0jG+Tg@mail.gmail.com> <ZS2HTdhFO2aywPpe@linux.dev>
In-Reply-To: <ZS2HTdhFO2aywPpe@linux.dev>
From: Raghavendra Rao Ananta <rananta@google.com>
Date: Mon, 16 Oct 2023 12:05:16 -0700
Message-ID: <CAJHc60xFwcDu6e6GTY3WYowBxnbkCWU-EgwEOVGd4Qu5F_h10A@mail.gmail.com>
Subject: Re: [PATCH v7 10/12] KVM: selftests: aarch64: Introduce
 vpmu_counter_access test
To: Oliver Upton <oliver.upton@linux.dev>
Cc: Sebastian Ott <sebott@redhat.com>, Marc Zyngier <maz@kernel.org>, 
	Alexandru Elisei <alexandru.elisei@arm.com>, James Morse <james.morse@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Shaoqin Huang <shahuang@redhat.com>, 
	Jing Zhang <jingzhangos@google.com>, Reiji Watanabe <reijiw@google.com>, 
	Colton Lewis <coltonlewis@google.com>, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Oct 16, 2023 at 11:56=E2=80=AFAM Oliver Upton <oliver.upton@linux.d=
ev> wrote:
>
> On Fri, Oct 13, 2023 at 02:05:29PM -0700, Raghavendra Rao Ananta wrote:
> > Oliver,
> >
> > Aren't the selftest patches from the 'Enable writable ID regs' series
> > [1] merged into kvmarm/next? Looking at the log, I couldn't find them
> > and the last patch that went from the series was [2]. Am I missing
> > something?
> >
> > Thank you.
> > Raghavendra
> >
> > [1]: https://lore.kernel.org/all/169644154288.3677537.15121340860793882=
283.b4-ty@linux.dev/
> > [2]: https://lore.kernel.org/all/20231003230408.3405722-11-oliver.upton=
@linux.dev/
>
> This is intentional, updating the tools headers as it was done in the
> original series broke the perftool build. I backed out the selftest
> patches, but took the rest of the kernel changes into kvmarm/next so
> they could soak while we sort out the selftests mess. Hopefully we can
> get the fix reviewed in time [*]...
>
> [*] https://lore.kernel.org/kvmarm/20231011195740.3349631-1-oliver.upton@=
linux.dev/
>
> --
Ah, I see. In that case, since it impacts this series, do you want me
to rebase my series on top of your selftests series for v8?

Thank you.
Raghavendra
> Thanks,
> Oliver
