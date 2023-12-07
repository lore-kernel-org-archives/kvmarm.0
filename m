Received: from mail-pj1-f49.google.com (mail-pj1-f49.google.com [209.85.216.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1383D37B
	for <kvmarm@lists.linux.dev>; Thu,  7 Dec 2023 03:36:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=brainfault.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b="vqn9GCMy"
Received: by mail-pj1-f49.google.com with SMTP id 98e67ed59e1d1-286e57fde73so444372a91.1
        for <kvmarm@lists.linux.dev>; Wed, 06 Dec 2023 19:36:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20230601.gappssmtp.com; s=20230601; t=1701920191; x=1702524991; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qpmyb8tDOuDjxZZHw+pAqD3DpIEuP7kLjd1VsjqScDM=;
        b=vqn9GCMytOsPwgwjyAspoGK/db7pRZLzElAdCbgebZ0o0O99j06WJcBUnyyYf+WmCv
         yLDuH9y5tQ2YpTB60sIxMFXlfjTh1DU7PHZVp3fLO/Xno11Z+U43YX2afRzzWhM/DuF3
         tEB++SyKjcwCZIUjtAQLeBWqgQEKcXdpGNBVrUMBFy/stxuvj1mtUG/mT3rrRSI65/HK
         rxcYtik7jTbvORVAlrpjZ8Z9XHy5TwP4I+FF0NXuWlJpol2NU02wpYMTrE/lwksWo9ch
         63GwE4Wd8IwnzdiIei0QRjfYX1o1fgNCBJB0vTd78bCJ4tf/ICM0hddXNB8+IwdpSsBh
         bKQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701920191; x=1702524991;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qpmyb8tDOuDjxZZHw+pAqD3DpIEuP7kLjd1VsjqScDM=;
        b=Qy3gTHVjgl2Yvi9vVHmfN6Hh2C8c0iBZueBEUt5lWGN2IoNa2UYpdd0ZenIvJy9xWN
         BwwnbcMdLewbyQCL7ey1dfWAfXe2loUkVX8VyctHVFAXVekzdE+u0saP65vg0o/OHSol
         cDYTiv+Dkj5Ht7pdSHHoWtsgbufqVHRCJQm4FdsBzKkBCkm4pK4NIJrSakr4yBkvqImW
         v6TpmG7NNDBWUCIx8TpkdviQTqFxi+B2a5rgrt3ufdCR0WqLrO+Yz62+ufZMO366s8Ou
         9FVkR3EbdtX5iXvqFL7f+36lIEFo3h+zRpdWPHb55Z5Ww76kgI5V4/XYAyytDZ+FdWYR
         Dv/A==
X-Gm-Message-State: AOJu0YyryGvCvlMcfHZHofp5TZKkIdaxNx9SArMa4giewkINgH6Q4h5I
	g8UofC6KSqR1tbdW7L4Dxjs6qsSQJB5mtEyOafutaA==
X-Google-Smtp-Source: AGHT+IEM4PIqu4evLMzttRYz5xZTrBv9JHEOwZBZ3TDAZtsFijg+WwQhl3hMrZaWSpNq3AZG1PYrXsmc8rNBgQGb8ck=
X-Received: by 2002:a17:90b:4a11:b0:286:6cc0:b90b with SMTP id
 kk17-20020a17090b4a1100b002866cc0b90bmr1378337pjb.66.1701920191109; Wed, 06
 Dec 2023 19:36:31 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20231206170241.82801-7-ajones@ventanamicro.com> <20231206170241.82801-10-ajones@ventanamicro.com>
In-Reply-To: <20231206170241.82801-10-ajones@ventanamicro.com>
From: Anup Patel <anup@brainfault.org>
Date: Thu, 7 Dec 2023 09:06:19 +0530
Message-ID: <CAAhSdy1b8z2Vo8fig3O-kHHY0R+D=Y8g0WBDF4uagkQ7meak+Q@mail.gmail.com>
Subject: Re: [PATCH 3/5] KVM: selftests: riscv: Remove redundant newlines
To: Andrew Jones <ajones@ventanamicro.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev, kvm-riscv@lists.infradead.org, 
	seanjc@google.com, pbonzini@redhat.com, maz@kernel.org, 
	oliver.upton@linux.dev, borntraeger@linux.ibm.com, frankja@linux.ibm.com, 
	imbrenda@linux.ibm.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Dec 6, 2023 at 10:32=E2=80=AFPM Andrew Jones <ajones@ventanamicro.c=
om> wrote:
>
> TEST_* functions append their own newline. Remove newlines from
> TEST_* callsites to avoid extra newlines in output.
>
> Signed-off-by: Andrew Jones <ajones@ventanamicro.com>

For KVM RISC-V:
Acked-by: Anup Patel <anup@brainfault.org>

Regards,
Anup

> ---
>  tools/testing/selftests/kvm/lib/riscv/processor.c | 2 +-
>  tools/testing/selftests/kvm/riscv/get-reg-list.c  | 2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/tools/testing/selftests/kvm/lib/riscv/processor.c b/tools/te=
sting/selftests/kvm/lib/riscv/processor.c
> index d146ca71e0c0..b3082da05c76 100644
> --- a/tools/testing/selftests/kvm/lib/riscv/processor.c
> +++ b/tools/testing/selftests/kvm/lib/riscv/processor.c
> @@ -327,7 +327,7 @@ void vcpu_args_set(struct kvm_vcpu *vcpu, unsigned in=
t num, ...)
>         int i;
>
>         TEST_ASSERT(num >=3D 1 && num <=3D 8, "Unsupported number of args=
,\n"
> -                   "  num: %u\n", num);
> +                   "  num: %u", num);
>
>         va_start(ap, num);
>
> diff --git a/tools/testing/selftests/kvm/riscv/get-reg-list.c b/tools/tes=
ting/selftests/kvm/riscv/get-reg-list.c
> index 6bedaea95395..4355e33c0cec 100644
> --- a/tools/testing/selftests/kvm/riscv/get-reg-list.c
> +++ b/tools/testing/selftests/kvm/riscv/get-reg-list.c
> @@ -112,7 +112,7 @@ void finalize_vcpu(struct kvm_vcpu *vcpu, struct vcpu=
_reg_list *c)
>
>                 /* Double check whether the desired extension was enabled=
 */
>                 __TEST_REQUIRE(vcpu_has_ext(vcpu, s->feature),
> -                              "%s not available, skipping tests\n", s->n=
ame);
> +                              "%s not available, skipping tests", s->nam=
e);
>         }
>  }
>
> --
> 2.43.0
>
