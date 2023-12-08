Received: from mail-vs1-f52.google.com (mail-vs1-f52.google.com [209.85.217.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C5D81094B
	for <kvmarm@lists.linux.dev>; Fri,  8 Dec 2023 08:17:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="2WgqqUSs"
Received: by mail-vs1-f52.google.com with SMTP id ada2fe7eead31-46487cb65f4so555123137.2
        for <kvmarm@lists.linux.dev>; Fri, 08 Dec 2023 00:17:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1702023448; x=1702628248; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MI/qtl1UwA+y+ufRY+g7id3KIyxDgb3vHCVd7+XIWKE=;
        b=2WgqqUSs8gzRA0l7A8eK8myDC8ULPNV91pKzZmUwKb0ZuyZ4TRw3c3V/am2MvAFzHe
         fceCQ35Gpyt93EjHNux+CZM3fmOz3Lu+F8H4Ehs0P6lju7hjZUL9t1TiNJMzuaG94kMq
         QRI9zOrTOFcT7wsiISbl6kqyF2pYBEbbUGFMlIFJpb/FAu9PlHBGePmYIT2IqLlvV50N
         q9SIT6R02W7G5wHs1xDOh2flqa6sTW06RrnlVSyxOQqslgVPEU3p+bG/qV0kjIGSVCPz
         MDSM/bKLYpUmma9UxB5UA3jdohXnmHQfL0tOiOOMbZeV6ZB58gaw0vCt3OJZjdGfpEHM
         Uzhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702023448; x=1702628248;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=MI/qtl1UwA+y+ufRY+g7id3KIyxDgb3vHCVd7+XIWKE=;
        b=gNpgWgaypmUlJ8vULM581hCa7gCNEk5Oq+iMHoQVTEp/4aCNPMyllUUYltiZRNdLHJ
         osi0rZsmOPylskaPz6Cf6yjQ0BcmAotNPtRR7V94eZKfPG8MvCKmWS+4qjj8c+3uC9ex
         5z+i45ScGwfSC7YctJvnVhSbGy1S6F3mZ1jioc1VCdw5Ji60IjBJu4KRjNOpNaCgOie0
         o+Au0xsgmgLjKbSVgYFo3iIoijrFjMvZBJbsMoY5EUX4Q8s8ygSkjJeSzi6WIaPzxT0e
         kehWciK/caxV8JPca939gjXYry1u65BRKPvR+QEn8jP9xcTGaP+e6w+uiLOY6MOCmKoO
         3Haw==
X-Gm-Message-State: AOJu0YwGUuBu7HufYuTb4hUkcLltXILgOhgXzcSnjmUnSHQuzXNwHXGT
	Vfb36vdABG/bAGe5dBPPDFOKyfT4Kl0W3+zxPdF9fw==
X-Google-Smtp-Source: AGHT+IEq4oq6HuuWixTr2HTqww3565wd/3RYy0SDlGwr8Rrr0H/qGhwD4O9LM7HdOW/yT1iINl+9O3XZg9cs8UqSbnc=
X-Received: by 2002:a67:fc03:0:b0:464:a449:1592 with SMTP id
 o3-20020a67fc03000000b00464a4491592mr3651240vsq.24.1702023448011; Fri, 08 Dec
 2023 00:17:28 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20231206100503.564090-1-tabba@google.com> <20231206100503.564090-3-tabba@google.com>
 <13427a09-025b-414c-adad-6a13c58df54e@sirena.org.uk>
In-Reply-To: <13427a09-025b-414c-adad-6a13c58df54e@sirena.org.uk>
From: Fuad Tabba <tabba@google.com>
Date: Fri, 8 Dec 2023 08:16:51 +0000
Message-ID: <CA+EHjTy=nXeb-hWMMts6nvuSo32+bMG=FrjGhpLBsEnqKh4H0w@mail.gmail.com>
Subject: Re: [PATCH v2 02/12] KVM: arm64: Add latest HFGxTR_EL2 FGT entries to
 nested virt
To: Mark Brown <broonie@kernel.org>
Cc: kvmarm@lists.linux.dev, maz@kernel.org, oliver.upton@linux.dev, 
	james.morse@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, 
	catalin.marinas@arm.com, will@kernel.org, eric.auger@redhat.com, 
	jingzhangos@google.com, joey.gouly@arm.com, 
	linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Mark,

On Thu, Dec 7, 2023 at 5:06=E2=80=AFPM Mark Brown <broonie@kernel.org> wrot=
e:
>
> On Wed, Dec 06, 2023 at 10:04:52AM +0000, Fuad Tabba wrote:
>
> > +#define SYS_GCSCR_EL1                        sys_reg(3, 0, 2, 5, 0)
> > +#define SYS_GCSPR_EL1                        sys_reg(3, 0, 2, 5, 1)
> > +#define SYS_GCSCRE0_EL1                      sys_reg(3, 0, 2, 5, 2)
> > +
>
> > +#define SYS_GCSPR_EL0                        sys_reg(3, 3, 2, 5, 1)
> > +
>
> Unless there's some complication with representing them (mainly register
> layouts that aren't representable with the language or *very* repetitive
> blocks of registers) we should be adding any new sysregs to the sysreg
> file rather than manually encoding them.  We're trying to move things
> out of sysreg.h as much as possible.

I thought that we're still using the encoded ones if we're not using
the fields of the registers. That said, I'll move to the generated one
in the respin.

>
> For the above you can pick up the patch from my GCS series:
>
>   https://lore.kernel.org/linux-arm-kernel/20231122-arm64-gcs-v7-6-201c48=
3bd775@kernel.org/
>
> > @@ -412,6 +423,8 @@
> >  #define SYS_PMUSERENR_EL0            sys_reg(3, 3, 9, 14, 0)
> >  #define SYS_PMOVSSET_EL0             sys_reg(3, 3, 9, 14, 3)
> >
> > +#define SYS_POR_EL0                  sys_reg(3, 3, 10, 2, 4)
> > +
>
> This is in Joey's POR series:
>
>   https://lore.kernel.org/linux-arm-kernel/20231124163510.1835740-2-joey.=
gouly@arm.com/
>
> Unfortunately I'm not aware of anyone having already done the rest.

I'll pick up what you and Joey have done and add the rest.

Thanks,
/fuad
