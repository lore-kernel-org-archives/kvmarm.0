Received: from mail-lj1-f174.google.com (mail-lj1-f174.google.com [209.85.208.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A33639C
	for <kvmarm@lists.linux.dev>; Tue,  4 Jul 2023 01:10:10 +0000 (UTC)
Received: by mail-lj1-f174.google.com with SMTP id 38308e7fff4ca-2b5c231c23aso81026871fa.0
        for <kvmarm@lists.linux.dev>; Mon, 03 Jul 2023 18:10:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1688433008; x=1691025008;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NanNEKu00OV4dGi7G0zvqpvZhV9czNdIron8MRqRfZI=;
        b=eLCXFaLroQ5MoaLRSPbNjWaACX61zx1cLYCRkq3boGYpFlVmf8gtDCfzTAw2qdS3Ub
         ozu8Ff4DqPjlyqIbk/MtR7tq1BYGzsWtkTT7gFrBQ/S+rBGY+a5FqO86Mh7S7Lodvd6/
         d1t56l5wcCUN7lU4sIr+FBq3VcR4xcxN7uYojfMdTGTlyJ69Zii2bollYU8snTcP4v5v
         4cgFMeQ5R1c+5ogbAsMLV0DvNXruXSAscfFxZWXXWHfnDBfbMFoC8hs8bE5gg71RY0Pw
         Bx2+ahtaEvxVOLWc9DPAFQW5JJo+ZC/2wKRECxa8Pk7mRMnXLM7Rwa5WD3Nx+dT3Uyxw
         geSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1688433008; x=1691025008;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=NanNEKu00OV4dGi7G0zvqpvZhV9czNdIron8MRqRfZI=;
        b=WpII9HSL0ygUJv1nrczybDl00e6aHcvy/U8a2yk+3T3M9elHuHgB2VIwFHCT63/euU
         wlJiJavufbBPKPelNsBCMSbC1QR8bLPsgqG5Anu+j7fRz6BY5Q69TijPHc3xJbaSf8Dy
         MSo5ZFqQafXgqqNtXTrCC815KlQNemJX6kSBlfGfVgbRMu3cb+skZnyiVfRlWJK5T7Ta
         uQ9fNdirrZ2/XF83Odi1PR/XZMv77IcAf51D6h7+4oVJpNuqKDZ1jdFBgsSA3kolQ0vJ
         wRyMAm5Ep0O5ogRuEqWQVPckTNFNDh6ijkFxIWfDlNP9rMlkYkuCRp95U45RnvBLEkr6
         CcAQ==
X-Gm-Message-State: ABy/qLZYuCyoj4E8OmMb8pask8pFYOog7DvZRFtPje6yCU5ER2MSadrp
	2scHHOtKm6KGr1ihLirVw12Yt426n85NsI9jf14=
X-Google-Smtp-Source: APBJJlGiNQwrknvCAy76rNcAE/MkDTPW2U3FZfJqSOgzlNETgHG1hunCNunvnDb4FfPWDhNrPhJSZ0ADPdMbvQoO9hw=
X-Received: by 2002:a2e:918e:0:b0:2b6:e96c:5414 with SMTP id
 f14-20020a2e918e000000b002b6e96c5414mr2899927ljg.52.1688433007852; Mon, 03
 Jul 2023 18:10:07 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <cover.1688010022.git.haibo1.xu@intel.com> <f44c3aa46971d524319c6340f9ce1b00c0182fd2.1688010022.git.haibo1.xu@intel.com>
 <20230702-49c5545eb1ae2d0cf11c7b95@orel>
In-Reply-To: <20230702-49c5545eb1ae2d0cf11c7b95@orel>
From: Haibo Xu <xiaobo55x@gmail.com>
Date: Tue, 4 Jul 2023 09:09:56 +0800
Message-ID: <CAJve8om-r67p7WojymsfP0T3MdZWchhujCZMzGyQ8de2AbykBQ@mail.gmail.com>
Subject: Re: [PATCH v5 10/13] KVM: selftests: Only do get/set tests on present
 blessed list
To: Andrew Jones <ajones@ventanamicro.com>
Cc: Haibo Xu <haibo1.xu@intel.com>, maz@kernel.org, oliver.upton@linux.dev, 
	seanjc@google.com, Paolo Bonzini <pbonzini@redhat.com>, Jonathan Corbet <corbet@lwn.net>, 
	Anup Patel <anup@brainfault.org>, Atish Patra <atishp@atishpatra.org>, 
	Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Albert Ou <aou@eecs.berkeley.edu>, Shuah Khan <shuah@kernel.org>, 
	James Morse <james.morse@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Ricardo Koller <ricarkol@google.com>, 
	Vishal Annapurve <vannapurve@google.com>, Vipin Sharma <vipinsh@google.com>, 
	David Matlack <dmatlack@google.com>, Colton Lewis <coltonlewis@google.com>, kvm@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org, 
	linux-kselftest@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Jul 3, 2023 at 4:18=E2=80=AFPM Andrew Jones <ajones@ventanamicro.co=
m> wrote:
>
> On Sat, Jul 01, 2023 at 09:42:58PM +0800, Haibo Xu wrote:
> > Only do the get/set tests on present and blessed registers
> > since we don't know the capabilities of any new ones.
> >
> > Suggested-by: Andrew Jones <ajones@ventanamicro.com>
> > Signed-off-by: Haibo Xu <haibo1.xu@intel.com>
> > Reviewed-by: Andrew Jones <ajones@ventanamicro.com>
> > ---
> >  tools/testing/selftests/kvm/get-reg-list.c | 29 ++++++++++++++--------
> >  1 file changed, 18 insertions(+), 11 deletions(-)
> >
> > diff --git a/tools/testing/selftests/kvm/get-reg-list.c b/tools/testing=
/selftests/kvm/get-reg-list.c
> > index c61090806007..74fb6f6fdd09 100644
> > --- a/tools/testing/selftests/kvm/get-reg-list.c
> > +++ b/tools/testing/selftests/kvm/get-reg-list.c
> > @@ -49,6 +49,10 @@ extern int vcpu_configs_n;
> >       for_each_reg_filtered(i)                                         =
       \
> >               if (!find_reg(blessed_reg, blessed_n, reg_list->reg[i]))
> >
> > +#define for_each_present_blessed_reg(i)                      \
> > +     for ((i) =3D 0; (i) < blessed_n; ++(i))           \
> > +             if (find_reg(reg_list->reg, reg_list->n, blessed_reg[i]))
>
> I just realized this is backwards. We need 'i' to index reg_list->reg in
> the body of the loop. That means we need to write this as
>
> #define for_each_present_blessed_reg(i)                                  =
       \
>         for_each_reg(i)                                                  =
       \
>                 if (find_reg(blessed_reg, blessed_n, reg_list->reg[i]))
>
> (Which, in hindsight, makes sense since we're replacing a for_each_reg()
> loop.)
>

Sure, I will update it in v6.

Thanks!

> Thanks,
> drew
