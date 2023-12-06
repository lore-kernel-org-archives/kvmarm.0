Received: from mail-qv1-f49.google.com (mail-qv1-f49.google.com [209.85.219.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23A5E28DA2
	for <kvmarm@lists.linux.dev>; Wed,  6 Dec 2023 10:19:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="LxAAneHn"
Received: by mail-qv1-f49.google.com with SMTP id 6a1803df08f44-67aa00ea853so34294616d6.2
        for <kvmarm@lists.linux.dev>; Wed, 06 Dec 2023 02:19:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1701857998; x=1702462798; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SZTcpMnu2J2zl6SHOGrYYwBFiibLNla9ee76Z+T+gvs=;
        b=LxAAneHnD0x0kgTTlujEAhOkBGQKgMfzrUH7WDpu7yDMg/Ao5leY/sH7qs1z8OPp8M
         AcKIpMp/W6np6ONXSGIWhArUJHcdxywsYe3jWTxEGcRIIohjnwS3jBFd3XlHmWITk4uF
         HAjs04l9wCWO4FFxShSxgiQ9+mEytfx3utwdAhqC9wf6qmrmtRUhBTtX7F1OkHBcA7x1
         9Xmu0UT7ms6hHvkOoao7Rck0LGXweyfqXEW0F8m+eqpAviDa9Zp7vfFnVky73ji7sdO/
         j8nkdDT4ibwVWZz8c4UOUtSBEHRj/RrvSaEG7zvVvbDVu1LYt6GFNugwM/KAdRm49F7o
         wPgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701857998; x=1702462798;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=SZTcpMnu2J2zl6SHOGrYYwBFiibLNla9ee76Z+T+gvs=;
        b=P464n46QjKlLg1/IBXu2JdOl+aTuZhhQap+H+EYS47EnklKJO+qDKGqf+BvgY6T+FO
         l92sBhszKm7xBoFFJlT15DF55QtxI8RHivTs2h3xzscg2Q8tD58lsy+tG+irqVaSJxJJ
         kX2JbVdOuKnTL0duxETnniHjP1bv3JPjT6Q6gEFbGtDrOXuKwfro8pVzxOpmgqW8dxC6
         Gmlz2Ai2WDPvxWMf4xSPbvxYojo+cdUucFdcEEx6gdPatYrqePZtSVMAGhnxIdVpSvEG
         2PQi244dx7OusLMnzJZIc3ilgm2Smw7AEX4iEBDsiSFquMeG8JgjtN7VnhdEKNZ+vQ3j
         dk/g==
X-Gm-Message-State: AOJu0YzgqA7t++uiNHKy+r3OaV8zXZzrLvX3kgJIu8tAGp/tyPueyDtJ
	iMEGXuUHJ1fbDoby9QkTzYIoVhprjOddrMIAibWEoWFp2YX2V3jAqjBro353
X-Google-Smtp-Source: AGHT+IHxpetyH0eWuOfUs6BiZKWZ4hjI33ynop2x837Ce7vdQRCmgxCgMD2ckuDD7B67Wmy7Y62dDiawGB+5wjVVi8A=
X-Received: by 2002:ad4:4f86:0:b0:67a:b7b8:b139 with SMTP id
 em6-20020ad44f86000000b0067ab7b8b139mr571346qvb.111.1701857997797; Wed, 06
 Dec 2023 02:19:57 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20231206100503.564090-1-tabba@google.com> <20231206100503.564090-10-tabba@google.com>
In-Reply-To: <20231206100503.564090-10-tabba@google.com>
From: Fuad Tabba <tabba@google.com>
Date: Wed, 6 Dec 2023 10:19:21 +0000
Message-ID: <CA+EHjTyBXnS-EUpEeYWg9L3jRDLsHY9vxPVm7yMZYKe-hs3DeQ@mail.gmail.com>
Subject: Re: [PATCH v2 09/12] KVM: arm64: Generate the HFGWTR-only RES0 bits
To: kvmarm@lists.linux.dev
Cc: maz@kernel.org, oliver.upton@linux.dev, james.morse@arm.com, 
	suzuki.poulose@arm.com, yuzenghui@huawei.com, catalin.marinas@arm.com, 
	will@kernel.org, eric.auger@redhat.com, jingzhangos@google.com, 
	joey.gouly@arm.com, linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi,

On Wed, Dec 6, 2023 at 10:05=E2=80=AFAM Fuad Tabba <tabba@google.com> wrote=
:
>
> Generate the HFGWTR-only RES0 bits in sysreg. This is done to
> consolidate all the bit definitions in one place.

I should have marked this as an RFC. I'm not sure if this approach is
better than the previous patch, or if I should just bite the bullet
and fully define HFGWTR's fields.

Cheers,
/fuad

>
> No functional change intended.
>
> Signed-off-by: Fuad Tabba <tabba@google.com>
> ---
>  arch/arm64/include/asm/kvm_arm.h | 13 +++----------
>  arch/arm64/tools/sysreg          | 26 ++++++++++++++++++++++++++
>  2 files changed, 29 insertions(+), 10 deletions(-)
>
> diff --git a/arch/arm64/include/asm/kvm_arm.h b/arch/arm64/include/asm/kv=
m_arm.h
> index 5b634e909d1c..02442bc90717 100644
> --- a/arch/arm64/include/asm/kvm_arm.h
> +++ b/arch/arm64/include/asm/kvm_arm.h
> @@ -348,16 +348,9 @@
>  #define __HFGRTR_EL2_MASK      GENMASK(49, 0)
>  #define __HFGRTR_EL2_nMASK     (GENMASK(63, 52) | BIT(50))
>
> -/*
> - * The HFGWTR bits are a subset of HFGRTR bits. To ensure we don't miss =
any
> - * future additions, define __HFGWTR* macros relative to __HFGRTR* ones.
> - */
> -#define __HFGxTR_READ_ONLY_MASK        (BIT(46) | BIT(42) | BIT(40) | BI=
T(28) | \
> -                                GENMASK(26, 25) | BIT(21) | BIT(18) | \
> -                                GENMASK(15, 14) | GENMASK(10, 9) | BIT(2=
))
> -#define __HFGWTR_EL2_RES0      (__HFGRTR_EL2_RES0 | __HFGxTR_READ_ONLY_M=
ASK)
> -#define __HFGWTR_EL2_MASK      (__HFGRTR_EL2_MASK & ~__HFGxTR_READ_ONLY_=
MASK)
> -#define __HFGWTR_EL2_nMASK     (__HFGRTR_EL2_nMASK & ~__HFGxTR_READ_ONLY=
_MASK)
> +#define __HFGWTR_EL2_RES0      (__HFGRTR_EL2_RES0 | HFGWTR_ONLY_EL2_RES0=
)
> +#define __HFGWTR_EL2_MASK      (__HFGRTR_EL2_MASK & ~HFGWTR_ONLY_EL2_RES=
0)
> +#define __HFGWTR_EL2_nMASK     (__HFGRTR_EL2_nMASK & ~HFGWTR_ONLY_EL2_RE=
S0)
>
>  #define __HFGITR_EL2_RES0      HFGITR_EL2_RES0
>  #define __HFGITR_EL2_MASK      (BIT(62) | BIT(60) | GENMASK(54, 0))
> diff --git a/arch/arm64/tools/sysreg b/arch/arm64/tools/sysreg
> index e5631f4e62f4..85f8b385fed2 100644
> --- a/arch/arm64/tools/sysreg
> +++ b/arch/arm64/tools/sysreg
> @@ -2093,6 +2093,32 @@ Field    1       AFSR1_EL1
>  Field  0       AFSR0_EL1
>  EndSysregFields
>
> +# HFGWTR_EL2 bits are a subset of those for HFGRTR_EL2.
> +# Define RES0 only present in HFGWTR_EL2.
> +SysregFields   HFGWTR_ONLY_EL2
> +Unkn   63:47
> +Res0   46
> +Unkn   45:43
> +Res0   42
> +Unkn   41
> +Res0   40
> +Unkn   39:29
> +Res0   28
> +Unkn   27
> +Res0   26:25
> +Unkn   24:22
> +Res0   21
> +Unkn   20:19
> +Res0   18
> +Unkn   17:16
> +Res0   15:14
> +Unkn   13:11
> +Res0   10:9
> +Unkn   8:3
> +Res0   2
> +Unkn   1:0
> +EndSysregFields
> +
>  Sysreg HFGRTR_EL2      3       4       1       1       4
>  Fields HFGxTR_EL2
>  EndSysreg
> --
> 2.43.0.rc2.451.g8631bc7472-goog
>
