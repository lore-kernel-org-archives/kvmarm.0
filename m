Received: from mail-lf1-f50.google.com (mail-lf1-f50.google.com [209.85.167.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE0CD33D7
	for <kvmarm@lists.linux.dev>; Wed, 28 Jun 2023 05:58:34 +0000 (UTC)
Received: by mail-lf1-f50.google.com with SMTP id 2adb3069b0e04-4f004cc54f4so7545450e87.3
        for <kvmarm@lists.linux.dev>; Tue, 27 Jun 2023 22:58:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1687931912; x=1690523912;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=n3aJVivKTsxGgC5bZY9lBEYilnIfeNYiUvGs+4klsT4=;
        b=EyR1u0N2KUtWsReJgPfwuO7azhk6O5y7csrrwvzN5oUccT+wyVRsmCmFMN0M2eAWQn
         dbQsxpKMTLbx/085rciYtvkKO/RoltlLBYUS5nwzudg3UcWJNaAUmH3ac1jJ0GF7jK6x
         hxbNeGLpqI9imb3xmV6UsHBxP8SsmEmtil6HC0aFHJZzZfw3gbbWMJf55z/scE0i6H2s
         N0Dp7uqpMnOlgB8+XKEGGuLEsTvLjzBz1o/6GLA3UTRojiFSP87+tE1PhIyHCS9uYFds
         bFv1+4/uBLPiRnJZ5L429ryfCUqb6E7lpt4WV+YF5kvJaRePDWZM7JI91smTG6vv1m3t
         NXBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687931912; x=1690523912;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=n3aJVivKTsxGgC5bZY9lBEYilnIfeNYiUvGs+4klsT4=;
        b=ZQQlpJUV9PEPFjQ5cBLtzb6P0ql5Bfcmi5dCeZXq6QSTKn1w4pf/+oIdwJd74FIlY+
         pD9/VuJvbDFFLT8OUvZox6dboBWhDJFj/FrrSSQXosJNg3aLPyFqZiH6sk/jGHqhjxZb
         fzBS5gId+z/6Zale55syM/FdiMyQzG1yw66djngMQTeklL3Pq7+foDk6gOzX+6z54zSE
         MPeWrveaGLE2+fR89V9/o6d8NO7DIwnYq1UZ70oFWfWsrDc/SyfIM66cM/ynZmtxHQK+
         vYscM2hYJ02/BXuz/e+C9sbDYzJSQBFJU7DM4BKUUleMgypLNLueevHd5rk9HEX9JrVz
         PGIg==
X-Gm-Message-State: AC+VfDwwT2gbrG6EpsWDccWMnqleSO07KCble22id1iyyncMviCdtEXY
	jZlya/sdZ++Jo2YfvLqj/AgxWmlIzMvSGz6jFBQ=
X-Google-Smtp-Source: ACHHUZ6G3GAT9ajCN9HnEnSa14/P//f+PSHHiBNlYEdgWCk+bz3CMGjmyPuJIjqhIuitZ1/YwJeJIdz2FvIiBiB2/A0=
X-Received: by 2002:a05:6512:3d21:b0:4fb:4368:14a1 with SMTP id
 d33-20020a0565123d2100b004fb436814a1mr7873262lfv.18.1687931912362; Tue, 27
 Jun 2023 22:58:32 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <cover.1687515463.git.haibo1.xu@intel.com> <341feff384c9f8a20ed4aac6e2dda0440d6b84f2.1687515463.git.haibo1.xu@intel.com>
 <20230627-4d207186c4ef81be43c9d874@orel>
In-Reply-To: <20230627-4d207186c4ef81be43c9d874@orel>
From: Haibo Xu <xiaobo55x@gmail.com>
Date: Wed, 28 Jun 2023 13:58:21 +0800
Message-ID: <CAJve8ony9nj9LyCAJjtvthR+ABLvSPHvpeE5e5=wr_z44i20qw@mail.gmail.com>
Subject: Re: [PATCH v4 08/12] KVM: arm64: selftests: Move reject_set check
 logic to a function
To: Andrew Jones <ajones@ventanamicro.com>
Cc: Haibo Xu <haibo1.xu@intel.com>, maz@kernel.org, oliver.upton@linux.dev, 
	seanjc@google.com, Paolo Bonzini <pbonzini@redhat.com>, Jonathan Corbet <corbet@lwn.net>, 
	Anup Patel <anup@brainfault.org>, Atish Patra <atishp@atishpatra.org>, 
	Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Albert Ou <aou@eecs.berkeley.edu>, Shuah Khan <shuah@kernel.org>, 
	James Morse <james.morse@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, David Matlack <dmatlack@google.com>, 
	Ben Gardon <bgardon@google.com>, Ricardo Koller <ricarkol@google.com>, 
	Vishal Annapurve <vannapurve@google.com>, Vipin Sharma <vipinsh@google.com>, 
	Colton Lewis <coltonlewis@google.com>, kvm@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, linux-kselftest@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Jun 27, 2023 at 5:09=E2=80=AFPM Andrew Jones <ajones@ventanamicro.c=
om> wrote:
>
> On Fri, Jun 23, 2023 at 06:40:10PM +0800, Haibo Xu wrote:
> > No functional changes. Just move the reject_set check logic to a
> > function so we can check for specific errno for specific register.
> > This is a preparation for support reject_set in riscv.
> >
> > Suggested-by: Andrew Jones <ajones@ventanamicro.com>
> > Signed-off-by: Haibo Xu <haibo1.xu@intel.com>
> > ---
> >  tools/testing/selftests/kvm/aarch64/get-reg-list.c | 8 ++++++++
> >  tools/testing/selftests/kvm/get-reg-list.c         | 7 ++++++-
> >  2 files changed, 14 insertions(+), 1 deletion(-)
> >
> > diff --git a/tools/testing/selftests/kvm/aarch64/get-reg-list.c b/tools=
/testing/selftests/kvm/aarch64/get-reg-list.c
> > index aaf035c969ec..4e2e1fe833eb 100644
> > --- a/tools/testing/selftests/kvm/aarch64/get-reg-list.c
> > +++ b/tools/testing/selftests/kvm/aarch64/get-reg-list.c
> > @@ -27,6 +27,14 @@ bool filter_reg(__u64 reg)
> >       return false;
> >  }
> >
> > +bool reject_set_fail(__u64 reg)
> > +{
> > +     if (reg =3D=3D KVM_REG_ARM64_SVE_VLS)
> > +             return (errno !=3D EPERM);
> > +
> > +     return false;
> > +}
>
> I think we should pass errno in as a parameter and I prefer positive
> predicate functions, so I'd name this check_reject_set() and reverse
> the logic. Also, we don't want to check for KVM_REG_ARM64_SVE_VLS,
> because that duplicates the rejects set. I see in a later patch
> that riscv needs to check reg because different errors are used
> for different registers, but that's because KVM_REG_RISCV_TIMER_REG(state=
)
> was erroneously added to the rejects set. KVM_REG_RISCV_TIMER_REG(state)
> doesn't belong there. That register can be set, but it only supports
> certain input, otherwise, it correctly, results in EINVAL. We'll need
> the concept of a "skip set" to avoid tripping over that one.
>
> So, I think arm's function should be
>
>  bool check_reject_set(int errno)
>  {
>      return errno =3D=3D EPERM;
>  }
>
> and riscv's should be
>
>  bool check_reject_set(int errno)
>  {
>      return errno =3D=3D EOPNOTSUPP;
>  }
>

Sure, will add a new 'skips_set' member to 'struct vcpu_reg_sublist' and
move KVM_REG_RISCV_TIMER_REG(state) reg to it.

> > +
> >  #define REG_MASK (KVM_REG_ARCH_MASK | KVM_REG_SIZE_MASK | KVM_REG_ARM_=
COPROC_MASK)
> >
> >  #define CORE_REGS_XX_NR_WORDS        2
> > diff --git a/tools/testing/selftests/kvm/get-reg-list.c b/tools/testing=
/selftests/kvm/get-reg-list.c
> > index f6ad7991a812..b956ee410996 100644
> > --- a/tools/testing/selftests/kvm/get-reg-list.c
> > +++ b/tools/testing/selftests/kvm/get-reg-list.c
> > @@ -98,6 +98,11 @@ void __weak print_reg(const char *prefix, __u64 id)
> >       printf("\t0x%llx,\n", id);
> >  }
> >
> > +bool __weak reject_set_fail(__u64 reg)
> > +{
> > +     return false;
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
> > +                             if (ret !=3D -1 || reject_set_fail(reg.id=
)) {
> >                                       printf("%s: Failed to reject (ret=
=3D%d, errno=3D%d) ", config_name(c), ret, errno);
> >                                       print_reg(config_name(c), reg.id)=
;
> >                                       putchar('\n');
> > --
> > 2.34.1
> >
>
> Thanks,
> drew
