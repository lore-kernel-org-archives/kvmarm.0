Received: from mail-qt1-f178.google.com (mail-qt1-f178.google.com [209.85.160.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C5DA1800B
	for <kvmarm@lists.linux.dev>; Mon, 31 Jul 2023 20:36:06 +0000 (UTC)
Received: by mail-qt1-f178.google.com with SMTP id d75a77b69052e-407db3e9669so19821cf.1
        for <kvmarm@lists.linux.dev>; Mon, 31 Jul 2023 13:36:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1690835765; x=1691440565;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8WbRt22akgzv4PmYRoTv7Z60VgxgxYtdGWVmvWN3QQU=;
        b=S48GXM2S/zOssa/4HGYWA/fi14zXxpeMV2F4C7CVir22G8F1rsCFPMpbbATKKTGtDB
         64U04V9zqc3NX/KcDqqznzevwdH+LBQzjjWkXhUJhWjREYzmjnwgZfC3FYc5IrYNUBlm
         LY/EUvpLCfaeKdgtW8bCez7DItwI3/PYoIvy7INGK7YD0YSomsBbivsNBTVfKNu4nBdo
         xivL5QLBIY+NVve5Wz1jLiXbHQ5tlLXN7oYO0s/LfS46XwncPU8xO8zWDxBIMO3Easl+
         guS7RQ3/hKev8L86c/bpFnn92PLQF1TIWg60T0w21WW/l5BAv1hI0kYaSnXEA5R3MsmC
         +C9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690835765; x=1691440565;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8WbRt22akgzv4PmYRoTv7Z60VgxgxYtdGWVmvWN3QQU=;
        b=YE7nhcNjcliFVDkAc9GMpIDB5fhpkfr+4dRC186SKOWLgZIuTBv815Ye3ky95d/Z02
         zjXKEIqnO3Iy00JgPTKJqdXSSTj3PBAkGka1dyXNWFHIA+qx9r/xXl/Npx4/DFFePRsp
         ZggjDitoULPkiu0zw2trM5pZ6Y4a4SdQDzOSJKNmq5KbZYHDIkxkjEyRmycF7P1VJcvT
         Ghy5VnFladdVeHUdGv1R9EnROPdk/C2/OlW5qhbr+dU+CMKkYQn71KstVF2WGTjnfPrs
         8e3K1HhiKE/ZvY+RR5IksPZM+RmNlVAT3HMeBat988vVylj0nzUlIre+eiHdfNxbt7eD
         aFZQ==
X-Gm-Message-State: ABy/qLbUyrqb5DNGIOzqN4+t/44RJ2ni72QJ2JIv/2sZ6JKpeSLZ0zBK
	Oh25VAlQWDMdEelUX6sT/ZlvS6rXujv+sjuvrE4/lg==
X-Google-Smtp-Source: APBJJlEmoOsErptso+JLUNi7GHGxX5qEgT6biVyV0lbNK73KMKgCiYEb0JJeNHAmZZOJJPW+PoidP5ENk119vh3duf0=
X-Received: by 2002:ac8:7f02:0:b0:407:4aa8:c5ba with SMTP id
 f2-20020ac87f02000000b004074aa8c5bamr366494qtk.14.1690835765004; Mon, 31 Jul
 2023 13:36:05 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230729004144.1054885-1-seanjc@google.com>
In-Reply-To: <20230729004144.1054885-1-seanjc@google.com>
From: Yu Zhao <yuzhao@google.com>
Date: Mon, 31 Jul 2023 14:35:29 -0600
Message-ID: <CAOUHufaK1zibYzOxUGWgYatLnts+fOG6X8fBAwtGA_S6cdDxMw@mail.gmail.com>
Subject: Re: [PATCH] KVM: Wrap kvm_{gfn,hva}_range.pte in a per-action union
To: Sean Christopherson <seanjc@google.com>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Huacai Chen <chenhuacai@kernel.org>, Anup Patel <anup@brainfault.org>, 
	Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Albert Ou <aou@eecs.berkeley.edu>, Paolo Bonzini <pbonzini@redhat.com>, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-mips@vger.kernel.org, kvm@vger.kernel.org, 
	kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Jul 28, 2023 at 6:41=E2=80=AFPM Sean Christopherson <seanjc@google.=
com> wrote:
>
> Wrap kvm_{gfn,hva}_range.pte in a union so that future notifier events ca=
n
> pass event specific information up and down the stack without needing to
> constantly expand and churn the APIs.  Lockless aging of SPTEs will pass
> around a bitmap, and support for memory attributes will pass around the
> new attributes for the range.
>
> Add a "KVM_NO_ARG" placeholder to simplify handling events without an
> argument (creating a dummy union variable is midly annoying).
>
> Opportunstically drop explicit zero-initialization of the "pte" field, as
> omitting the field (now a union) has the same effect.
>
> Cc: Yu Zhao <yuzhao@google.com>
> Link: https://lore.kernel.org/all/CAOUHufagkd2Jk3_HrVoFFptRXM=3DhX2CV8f+M=
-dka-hJU4bP8kw@mail.gmail.com
> Signed-off-by: Sean Christopherson <seanjc@google.com>

Acked-by: Yu Zhao <yuzhao@google.com>
