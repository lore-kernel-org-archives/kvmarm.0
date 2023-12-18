Received: from mail-qv1-f54.google.com (mail-qv1-f54.google.com [209.85.219.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7BE41A585
	for <kvmarm@lists.linux.dev>; Mon, 18 Dec 2023 11:18:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="t+P8RHvp"
Received: by mail-qv1-f54.google.com with SMTP id 6a1803df08f44-67f33069b79so4530766d6.0
        for <kvmarm@lists.linux.dev>; Mon, 18 Dec 2023 03:18:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1702898312; x=1703503112; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=whu72UJCpIOprJOauxB3ZhJHQSVyJbOlz8wZ+8K6ZLE=;
        b=t+P8RHvp72yHjF/7cPaQhIxWILL/LRgcOTTobOPNoeC46l7sFg+8XZ3m3iMsdlN2xe
         gwi7sAEc+upaoKJI1Y27uszCU/xF4DWDh9zHerbdyiA8XtgvXiy3xUoItml+hOs/GndC
         MzQhooVWRr0i1eGSIB0cP9qvxZCnnTmXlG08p0AFnAm1hfVnoRoKLMrhNWv3Pl7cGlx/
         L52Y1udXwMfCH/Df0S4MjoDMcIzT/bC6c09/iIdKbyZbKEusvRa0A/QIZcceRF0nVMWw
         23GKNzj1B8aVKq8m58WUvGe0KL6tULkUlG/ma4xMrjZw1Gwjn1CFf6ZELWQv5mUfb4Cd
         GLgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702898312; x=1703503112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=whu72UJCpIOprJOauxB3ZhJHQSVyJbOlz8wZ+8K6ZLE=;
        b=bSAqKSHYCHX3ezvOrZQAEaVDxjW2PIDBgYlyrXB+yMPwdDfBrCjBIDKB6PBDlq7rE3
         flDOsuPQcl7SOqW/3tBm631lpL605Vh2mpplxrV8pIJO0COUECQERm0OK2qK2+2OaD2M
         OthlogVbLxN9QPjk1LPJK+Bh2CT9xlNDCvPHjzTWneq9GCQhHEX1QbepJ+jrskAPbvnD
         s1uvg8qXTnOw+9YEwZR4Edy79XY3S0Ivp/0vPb88JrL28dv+QfUgva6TPB8zwIaglSEa
         Y9DL2aeR1xcsPRWrfDk9re1EDaoJXNP+D8oRKnkZfkXPjSlIG8J9YREpF2Q5wJ4YRDcl
         1s6A==
X-Gm-Message-State: AOJu0Yx5szzqoimlHbB+z7UAc8bJilZ5VQvZ5Vf98gkaPm2itjqLdM6D
	HZz1PZr77l/xb4CA1P43NvNIUNvcxzlAUmEnfn8kIQ==
X-Google-Smtp-Source: AGHT+IGg3anK2eM6cYIDr8L+UEQG3qiAlqaWgWrhA3PMzvz8MXC1Q20lSOYwR1KEtNbGZly6YFwGqFjfj1RWSlgUxOU=
X-Received: by 2002:ad4:4ead:0:b0:67f:2992:efc4 with SMTP id
 ed13-20020ad44ead000000b0067f2992efc4mr3394281qvb.81.1702898312349; Mon, 18
 Dec 2023 03:18:32 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20231214100158.2305400-1-tabba@google.com> <20231214100158.2305400-15-tabba@google.com>
 <86wmtbalx9.wl-maz@kernel.org> <CA+EHjTxZmc2bAaDbFLjWxx-LzCX7Jwy+EH60JgFBvWYh68U=xg@mail.gmail.com>
 <86v88vahn8.wl-maz@kernel.org>
In-Reply-To: <86v88vahn8.wl-maz@kernel.org>
From: Fuad Tabba <tabba@google.com>
Date: Mon, 18 Dec 2023 11:17:55 +0000
Message-ID: <CA+EHjTyPS-3PX+JGV32oTTMYJPk3Dijbcj3oAENg3v7sAdw7wA@mail.gmail.com>
Subject: Re: [PATCH v3 14/17] KVM: arm64: Macros for setting/clearing FGT bits
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, oliver.upton@linux.dev, broonie@kernel.org, 
	james.morse@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, 
	catalin.marinas@arm.com, will@kernel.org, eric.auger@redhat.com, 
	jingzhangos@google.com, joey.gouly@arm.com, 
	linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Marc,

On Mon, Dec 18, 2023 at 11:12=E2=80=AFAM Marc Zyngier <maz@kernel.org> wrot=
e:
...
>         if (cpu_has_amu())
>                 update_fgt_traps(vcpu, HAFGRTR_EL2);
>
> If that seems sensible to you, I'll fold it in, as I'd like to do
> without a respin if we can avoid it.

Looks good to me. Thanks Marc!
/fuad

>
> `       M.
>
> --
> Without deviation from the norm, progress is not possible.
