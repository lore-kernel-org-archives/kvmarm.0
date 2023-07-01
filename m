Received: from mail-lj1-f180.google.com (mail-lj1-f180.google.com [209.85.208.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBE9BC2C0
	for <kvmarm@lists.linux.dev>; Sat,  1 Jul 2023 14:35:31 +0000 (UTC)
Received: by mail-lj1-f180.google.com with SMTP id 38308e7fff4ca-2b63e5f94f1so36546231fa.1
        for <kvmarm@lists.linux.dev>; Sat, 01 Jul 2023 07:35:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1688222129; x=1690814129;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=aaPOwVOZ+bU3bEOtc3/yyhO3B/rb/2pd2qqDwVfkQLw=;
        b=bhB2OGE3RRzpSj2bI4oYunKjg/pWMxy2hDqeZcwVXDNS4JNlGKZPPR6dsIg2RiBPaA
         XddtT0C/oUJWh/8EsaXkI/6pfYvsrCxu082OUeX+terV56QkZKpqPGpW16Pwpdel1a4B
         QLgeTPgxvU5mpR9X5lQZBuXzd/9ZwtRO9eInZ8Pu2b/C/kRiX9/LM63bOsMdYXt8yeTj
         wrl5s14QrUCKPGIfVbFCHpn9d5LMtSMTCighhe2NY7+r7tE63wj1Rv7Lzp0TBEGhq2wH
         5Smnaj5wB8izhBCVnFjIwmCDjnlMbrwYFlev5c1JICwV1yapgQH01YvLa1jBGhCE+mXp
         VNpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1688222129; x=1690814129;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=aaPOwVOZ+bU3bEOtc3/yyhO3B/rb/2pd2qqDwVfkQLw=;
        b=EtXNYsBI+oQHVss8DTgf7uKBGTZF0dI8uilkLy7rT+LNPD5RZUn/Bo2mPsR9fnX7uC
         2ufD5AwNJ6b5d8i+rKpmgYIyzjaVcWjES0hGZQiHeDE5/ujn0+DNbuah5vJB9LOO1LyG
         x2/hz7d+6ga9ixGiit+jpHyIP2Uiq+9PgK5kQFKJe82WuwKxfyfqFMNtmfVcjMW23tIt
         r6P1IKqQd3iuW/RytLQnqGYJym6wmgZqx/5vL251B/KOhffLNHe3Jc9TlFPxIVrjN2vm
         GWCO7yk/dTABLOR+SXVAzZ3ALSY+mEceSJVdgiDM+zTN1AvLK861Q50w4C7qDxCAOO9I
         ax+A==
X-Gm-Message-State: ABy/qLbKPPtaPGDdLfx+M/YrG8wLH1r6XIrzhlf1dadV8P3uO0fethke
	ixwdZSMn9Mqx75aXImDfTnq8NxbphYmM8y2sRcs=
X-Google-Smtp-Source: APBJJlFNU/x2ikcVqhPAS0JO3x9ydTrnk8SegR8Iy91lyWQNTL7iKMsejrXFyvnMu8IDP8g6AskN8ncwltMBvpm7vv4=
X-Received: by 2002:a2e:a4c4:0:b0:2b6:da7a:3859 with SMTP id
 p4-20020a2ea4c4000000b002b6da7a3859mr675759ljm.15.1688222129294; Sat, 01 Jul
 2023 07:35:29 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <cover.1688010022.git.haibo1.xu@intel.com> <f5ef26e862260efdf1c809d0eee46ee1c8b457f2.1688010022.git.haibo1.xu@intel.com>
 <20230701-0255de0b29b22f180bb3bbbf@orel>
In-Reply-To: <20230701-0255de0b29b22f180bb3bbbf@orel>
From: Haibo Xu <xiaobo55x@gmail.com>
Date: Sat, 1 Jul 2023 22:35:18 +0800
Message-ID: <CAJve8okE3Sa0j4+u+L9UHO9aSbzXU8pXvDNqKe9omoX=fx6XXw@mail.gmail.com>
Subject: Re: [PATCH v5 08/13] KVM: arm64: selftests: Move reject_set check
 logic to a function
To: Andrew Jones <ajones@ventanamicro.com>
Cc: Haibo Xu <haibo1.xu@intel.com>, maz@kernel.org, oliver.upton@linux.dev, 
	seanjc@google.com, Paolo Bonzini <pbonzini@redhat.com>, Jonathan Corbet <corbet@lwn.net>, 
	Anup Patel <anup@brainfault.org>, Atish Patra <atishp@atishpatra.org>, 
	Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Albert Ou <aou@eecs.berkeley.edu>, Shuah Khan <shuah@kernel.org>, 
	James Morse <james.morse@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Ricardo Koller <ricarkol@google.com>, 
	Vishal Annapurve <vannapurve@google.com>, David Matlack <dmatlack@google.com>, 
	Vipin Sharma <vipinsh@google.com>, Colton Lewis <coltonlewis@google.com>, kvm@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org, 
	linux-kselftest@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Jul 1, 2023 at 10:21=E2=80=AFPM Andrew Jones <ajones@ventanamicro.c=
om> wrote:
>
> On Sat, Jul 01, 2023 at 09:42:56PM +0800, Haibo Xu wrote:
> > No functional changes. Just move the reject_set check logic to a
> > function so we can check for specific errno for specific register.
>
> 'for specific register' part isn't true anymore.
>
> > This is a preparation for support reject_set in riscv.
> >
> > Suggested-by: Andrew Jones <ajones@ventanamicro.com>
> > Signed-off-by: Haibo Xu <haibo1.xu@intel.com>
> > ---
> >  tools/testing/selftests/kvm/aarch64/get-reg-list.c | 5 +++++
> >  tools/testing/selftests/kvm/get-reg-list.c         | 7 ++++++-
> >  2 files changed, 11 insertions(+), 1 deletion(-)
> >
> > diff --git a/tools/testing/selftests/kvm/aarch64/get-reg-list.c b/tools=
/testing/selftests/kvm/aarch64/get-reg-list.c
> > index aaf035c969ec..4aa58f1aebe3 100644
> > --- a/tools/testing/selftests/kvm/aarch64/get-reg-list.c
> > +++ b/tools/testing/selftests/kvm/aarch64/get-reg-list.c
> > @@ -27,6 +27,11 @@ bool filter_reg(__u64 reg)
> >       return false;
> >  }
> >
> > +bool check_reject_set(int err)
> > +{
> > +     return err =3D=3D EPERM;
> > +}
> > +
> >  #define REG_MASK (KVM_REG_ARCH_MASK | KVM_REG_SIZE_MASK | KVM_REG_ARM_=
COPROC_MASK)
> >
> >  #define CORE_REGS_XX_NR_WORDS        2
> > diff --git a/tools/testing/selftests/kvm/get-reg-list.c b/tools/testing=
/selftests/kvm/get-reg-list.c
> > index f6ad7991a812..79e198968860 100644
> > --- a/tools/testing/selftests/kvm/get-reg-list.c
> > +++ b/tools/testing/selftests/kvm/get-reg-list.c
> > @@ -98,6 +98,11 @@ void __weak print_reg(const char *prefix, __u64 id)
> >       printf("\t0x%llx,\n", id);
> >  }
> >
> > +bool __weak check_reject_set(int err)
> > +{
> > +     return true;
> > +}
> > +
> >  #ifdef __aarch64__
> >  static void prepare_vcpu_init(struct vcpu_reg_list *c, struct kvm_vcpu=
_init *init)
> >  {
> > @@ -216,7 +221,7 @@ static void run_test(struct vcpu_reg_list *c)
> >                       if (s->rejects_set && find_reg(s->rejects_set, s-=
>rejects_set_n, reg.id)) {
> >                               reject_reg =3D true;
> >                               ret =3D __vcpu_ioctl(vcpu, KVM_SET_ONE_RE=
G, &reg);
> > -                             if (ret !=3D -1 || errno !=3D EPERM) {
> > +                             if (ret !=3D -1 || !check_reject_set(errn=
o)) {
> >                                       printf("%s: Failed to reject (ret=
=3D%d, errno=3D%d) ", config_name(c), ret, errno);
> >                                       print_reg(config_name(c), reg.id)=
;
> >                                       putchar('\n');
> > --
> > 2.34.1
> >
>
> Otherwise,
>
> Reviewed-by: Andrew Jones <ajones@ventanamicro.com>

Thanks for the review! Will fix it in the next version.
