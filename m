Received: from mail-lf1-f51.google.com (mail-lf1-f51.google.com [209.85.167.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35D24566D
	for <kvmarm@lists.linux.dev>; Fri, 15 Sep 2023 06:08:54 +0000 (UTC)
Received: by mail-lf1-f51.google.com with SMTP id 2adb3069b0e04-502d9ce31cbso2898582e87.3
        for <kvmarm@lists.linux.dev>; Thu, 14 Sep 2023 23:08:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1694758133; x=1695362933; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KrUex7tZYzG80r+HRntdlogt24bgAFnmLNhpPfiHTo4=;
        b=Jdoa3h0DjApFfW5852oyByQtJL4tNvRlUlRDY8rV6sO3SCFRDr9sa7CXxLwJBMg16j
         rfDMpp7UefOkJVSs5ZNMIPxNldhEu7XhicdOvauDAPPANMECw4vp4RonbrHqn2k6PW/j
         kDTzPRImXjzA0mpQnvM/mBzXAGyHkgLMAeIYu4eb3uKVFRTUMDJc6cwJ86wf2SS2TiMu
         PIu2TDFU3NwAfIKsLx4WKN/AEhMuOj61nSSWPxy9crM3zshn52Zm3Gr2d8yqwOgljyrp
         O1CH6BgeryZ4MPHYn1+0Qw8XFdrc4sbrHnuMbiRiFi2zQzzbn4UE6Rr9CN+tQyFQNqMa
         T4mQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694758133; x=1695362933;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=KrUex7tZYzG80r+HRntdlogt24bgAFnmLNhpPfiHTo4=;
        b=wctvIpreHEvNtgeklgyMGKt3dTEgx1RXesGGLHEZi6b50vQdJLsIdlxmNm98YRmCvm
         pgGjsRz6XPkkLr7YCMrhyIZto3w+tX9NRhhIFI9wq2A4MrLy/bND1Eo7/gR2bpe73ZcV
         /MqosqaKDWNlPj8zXL2quKcsrzRS8QqBy1suUhirpkMF+71govaLdH/+ySn316PKBp8r
         txswxH+gcd25IUcSqewiVy0Xdtb9YRkNWQz5LiK5vZzsozldaOstFCe+jA1ntv31EE2Q
         eJ8C8dDSIeRa8WERshTXTdSbeDY/oKHRlzS0PCH7MDsjR0nIKKxhUnK0QdXZ4hqvxiSN
         CdUw==
X-Gm-Message-State: AOJu0Yzbdko8CZp/WsT6uk7HlTgss2+Ikk2+WZ052i3s3l5dj2YdhNuY
	kI3wMliNAvvueKv1SlHowcEcEh+NqOhM4C8KCzk=
X-Google-Smtp-Source: AGHT+IE/XgBcSpKnAyn9kLVpBkUHetxKd4F0nqWTi/DQv3hNtF8/i08aGRvx7cFjKU4BchcvkCmtqJALN6++fwsZ4H0=
X-Received: by 2002:a05:6512:3096:b0:500:9969:60bf with SMTP id
 z22-20020a056512309600b00500996960bfmr655736lfd.68.1694758132725; Thu, 14 Sep
 2023 23:08:52 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <cover.1694421911.git.haibo1.xu@intel.com> <119c9d06d64b7e4932c5f74a05af1e769cbe7da6.1694421911.git.haibo1.xu@intel.com>
 <20230914-90a562a03985a9a97afd953a@orel>
In-Reply-To: <20230914-90a562a03985a9a97afd953a@orel>
From: Haibo Xu <xiaobo55x@gmail.com>
Date: Fri, 15 Sep 2023 14:08:41 +0800
Message-ID: <CAJve8o=uZGovGBdtYYxiodGnXO-kE9jj=8pkc5+_Tk+dirQO1Q@mail.gmail.com>
Subject: Re: [PATCH v3 4/9] tools: riscv: Add header file csr.h
To: Andrew Jones <ajones@ventanamicro.com>
Cc: Haibo Xu <haibo1.xu@intel.com>, Paul Walmsley <paul.walmsley@sifive.com>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Paolo Bonzini <pbonzini@redhat.com>, Shuah Khan <shuah@kernel.org>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, James Morse <james.morse@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Anup Patel <anup@brainfault.org>, Atish Patra <atishp@atishpatra.org>, 
	Sean Christopherson <seanjc@google.com>, Ricardo Koller <ricarkol@google.com>, 
	Vishal Annapurve <vannapurve@google.com>, Vipin Sharma <vipinsh@google.com>, 
	David Matlack <dmatlack@google.com>, Thomas Huth <thuth@redhat.com>, 
	Aaron Lewis <aaronlewis@google.com>, Colton Lewis <coltonlewis@google.com>, 
	linux-kernel@vger.kernel.org, linux-riscv@lists.infradead.org, 
	kvm@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kvm-riscv@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Sep 14, 2023 at 4:14=E2=80=AFPM Andrew Jones <ajones@ventanamicro.c=
om> wrote:
>
> On Thu, Sep 14, 2023 at 09:36:58AM +0800, Haibo Xu wrote:
> > Borrow the csr definitions and operations from kernel's
> > arch/riscv/include/asm/csr.h to tools/ for riscv. Since
> > only 64bit was supported for RISC-V KVM selftests, add
> > CONFIG_64BIT definition in kvm/Makefile to ensure only
> > 64bit registers were available in csr.h.
> >
> > Suggested-by: Andrew Jones <ajones@ventanamicro.com>
> > Signed-off-by: Haibo Xu <haibo1.xu@intel.com>
> > Reviewed-by: Andrew Jones <ajones@ventanamicro.com>
> > ---
> >  tools/arch/riscv/include/asm/csr.h   | 521 +++++++++++++++++++++++++++
> >  tools/testing/selftests/kvm/Makefile |   3 +
> >  2 files changed, 524 insertions(+)
> >  create mode 100644 tools/arch/riscv/include/asm/csr.h
> >
> > diff --git a/tools/arch/riscv/include/asm/csr.h b/tools/arch/riscv/incl=
ude/asm/csr.h
> > new file mode 100644
> > index 000000000000..4e86c82aacbd
> > --- /dev/null
> > +++ b/tools/arch/riscv/include/asm/csr.h
> ...
> > diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selft=
ests/kvm/Makefile
> > index 0102a0297b84..89ecee2fdb73 100644
> > --- a/tools/testing/selftests/kvm/Makefile
> > +++ b/tools/testing/selftests/kvm/Makefile
> > @@ -222,6 +222,9 @@ CFLAGS +=3D -Wall -Wstrict-prototypes -Wuninitializ=
ed -O2 -g -std=3Dgnu99 \
> >  ifeq ($(ARCH),s390)
> >       CFLAGS +=3D -march=3Dz10
> >  endif
> > +ifeq ($(ARCH),riscv)
> > +     CFLAGS +=3D -DCONFIG_64BIT
> > +endif
>
> This should be a separate patch, since the "import csr.h to tools" should
> be completely separate from anything else. Also, all architectures that
> KVM selftests supports are 64-bit, so, as another completely separate
> patch, I think we should just add CONFIG_64BIT to CFLAGS for all builds,
> especially since there's a chance some of the includes the other
> architectures are using may need it. Of course we'll need sign-off and
> testing from the other arch maintainers.
>

Sure. Will fix it in V4.

Thanks,
Haibo

> Thanks,
> drew
