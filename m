Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18D8737D
	for <kvmarm@lists.linux.dev>; Sat, 27 May 2023 02:27:01 +0000 (UTC)
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-1b01d912924so8133385ad.1
        for <kvmarm@lists.linux.dev>; Fri, 26 May 2023 19:27:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685154421; x=1687746421;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yGd3VhznQ2I/NQDk+4roFWXHVSOBmaxtJ+oHTP+UbGk=;
        b=n7sDEKh6jt4tjfPVQPZjuftdEuC76pajkpfPSZEdFb7ieTmVQ5SpkxQNB5yMcm06QN
         isB+1LbRGBHRIUuoBTXYa6Y702+fLmeOCqWjOutS3GZWlk7ZHJbef/Kcn2GDtcXt7Di5
         B0F10QB32YuiJwlAvNLeESVDkmplddaavJBcbyNa2aP2XC3bQ0hI5yR8F/Yxwe5RODhi
         Wb72xgb9IQXkByEhjLGwZbvv1kua9AC/H/Pkq96DLHrfA9rxhbQVjVHhbgkQ1B/bXkAB
         aHgoCQgsq+/XaBn2ddmY+9Iwi18VcA5IRBqMr6/eWKC+vitweWJ0fDlo+tr2j1vcbrHE
         eJ+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685154421; x=1687746421;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=yGd3VhznQ2I/NQDk+4roFWXHVSOBmaxtJ+oHTP+UbGk=;
        b=WWjcZeSHi8fISgXNlHxoyIhca649mulNVmsCwoLabPNG/1kA9QeOV0FZI5aBjsAjrI
         Fodycz7YpsisgfbBs5Cm5pWCwIOSQw9yLzuHqocWlaLSC9ZUs3GF2dcM7uAISeyLFyRc
         6qKjO3P8kIvpzl8fpZXHlpQ156FnFW7j/BQaBzBrSpMxoX7b9j3/UTvnaa739oAk4Cnh
         J3zNK7a4/ASAjxTE2EObJowRRKpAY0ezVRW7nz5nb77EGM+W4O5BvZmG4JkUFUTENbZQ
         103Vv0VLZtsL6WA1mSXNIQ0zWx+bISGAdFLfIeRudWVzXPWppSm5unrJSiWqlLUsIy+8
         eLeQ==
X-Gm-Message-State: AC+VfDyB6rQ9G5/bvg+JmIvJXZSn5cL09pe0WBft2kODDS6BnbwOQNe/
	JR89LgkSVGKgTpJdkYRW4eHSXOuq99J5wiK1YMw=
X-Google-Smtp-Source: ACHHUZ6aAeSR4JF6rBXm5cC75wX5zCQJnq/3rFEcZQpE51VFfD85Rkd+KHCNiQAQXbtR9I84BTrFBx+V7cy+Ct2ere0=
X-Received: by 2002:a17:903:2345:b0:1af:f4f5:6fae with SMTP id
 c5-20020a170903234500b001aff4f56faemr5778765plh.54.1685154421346; Fri, 26 May
 2023 19:27:01 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <cover.1684999824.git.haibo1.xu@intel.com> <26dea518fc5e8da51e61db279d175364bfecd009.1684999824.git.haibo1.xu@intel.com>
 <20230525-705ddcbcd43aa63e3fd356c8@orel> <CAJve8onF9MFuaVsThFnhjWr6ZomB0Lhr9WXGvMiJDt5vrjeKLg@mail.gmail.com>
 <20230526-d8d768a23cd6bdc274bc165c@orel>
In-Reply-To: <20230526-d8d768a23cd6bdc274bc165c@orel>
From: Haibo Xu <xiaobo55x@gmail.com>
Date: Sat, 27 May 2023 10:26:51 +0800
Message-ID: <CAJve8on=5NtnzR=iAQs2D4B2Ly=KFXF-0ZDtkXFuz-SdxTGGmA@mail.gmail.com>
Subject: Re: [PATCH v2 09/11] KVM: riscv: selftests: Make check_supported arch specific
To: Andrew Jones <ajones@ventanamicro.com>
Cc: Haibo Xu <haibo1.xu@intel.com>, maz@kernel.org, oliver.upton@linux.dev, 
	seanjc@google.com, Paolo Bonzini <pbonzini@redhat.com>, Jonathan Corbet <corbet@lwn.net>, 
	Anup Patel <anup@brainfault.org>, Atish Patra <atishp@atishpatra.org>, 
	Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Albert Ou <aou@eecs.berkeley.edu>, Shuah Khan <shuah@kernel.org>, 
	James Morse <james.morse@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, David Matlack <dmatlack@google.com>, 
	Ben Gardon <bgardon@google.com>, Vipin Sharma <vipinsh@google.com>, 
	Colton Lewis <coltonlewis@google.com>, kvm@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, linux-kselftest@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, May 26, 2023 at 4:44=E2=80=AFPM Andrew Jones <ajones@ventanamicro.c=
om> wrote:
>
> On Fri, May 26, 2023 at 03:50:32PM +0800, Haibo Xu wrote:
> > On Fri, May 26, 2023 at 12:40=E2=80=AFAM Andrew Jones <ajones@ventanami=
cro.com> wrote:
> > >
> > > On Thu, May 25, 2023 at 03:38:33PM +0800, Haibo Xu wrote:
> > > > check_supported() was used to verify whether a feature/extension wa=
s
> > > > supported in a guest in the get-reg-list test. Currently this info
> > > > can be retrieved through the KVM_CAP_ARM_* API in aarch64, but in
> > > > riscv, this info was only exposed through the KVM_GET_ONE_REG on
> > > > KVM_REG_RISCV_ISA_EXT pseudo registers.
> > > >
> > > > Signed-off-by: Haibo Xu <haibo1.xu@intel.com>
> > > > ---
> > > >  tools/testing/selftests/kvm/get-reg-list.c | 32 +++++++++++-------=
----
> > > >  1 file changed, 16 insertions(+), 16 deletions(-)
> > > >
> > > > diff --git a/tools/testing/selftests/kvm/get-reg-list.c b/tools/tes=
ting/selftests/kvm/get-reg-list.c
> > > > index f6ad7991a812..f1fc113e9719 100644
> > > > --- a/tools/testing/selftests/kvm/get-reg-list.c
> > > > +++ b/tools/testing/selftests/kvm/get-reg-list.c
> > > > @@ -99,6 +99,20 @@ void __weak print_reg(const char *prefix, __u64 =
id)
> > > >  }
> > > >
> > > >  #ifdef __aarch64__
> > > > +static void check_supported(struct vcpu_reg_list *c)
> > > > +{
> > > > +     struct vcpu_reg_sublist *s;
> > > > +
> > > > +     for_each_sublist(c, s) {
> > > > +             if (!s->capability)
> > > > +                     continue;
> > >
> > > I was going to say that making this function aarch64 shouldn't be
> > > necessary, since riscv leaves capability set to zero and this functio=
n
> > > doesn't do anything, but then looking ahead I see riscv is abusing
> > > capability by putting isa extensions in it. IMO, capability should
> > > only be set to KVM_CAP_* values. Since riscv doesn't use it, then it
> > > should be left zero.
> > >
> > > If we're going to abuse something, then I'd rather abuse the 'feature=
'
> > > member, but since it's only an int (not an unsigned long), then let's
> > > just add an 'unsigned long extension' member.
> > >
> >
> > Good idea!
> >
> > For the new 'extension' member in riscv, I think its use case should be
> > identical to the 'feature' member in aarch64(KVM_RISCV_ISA_EXT_F
> > was similar to KVM_ARM_VCPU_SVE)? If so, I think we can just reuse
> > the 'feature' member since the data type was not a big deal.
>
> You're right. An int is fine for the isa extension index, which is all we
> need to represent.
>
> Thanks,
> drew

Thanks for the suggestion! I will include the change in v3 soon.
