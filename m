Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD32B363
	for <kvmarm@lists.linux.dev>; Fri, 18 Aug 2023 00:08:54 +0000 (UTC)
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-589cc9f7506so4391377b3.2
        for <kvmarm@lists.linux.dev>; Thu, 17 Aug 2023 17:08:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1692317333; x=1692922133;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=mE3f+VMf8SgNE6cCbkcfMUP8Hiy9b4N5xYpI+7a+l+E=;
        b=2oU9BIaw0ILeiNHyHsZk7TDIJto4bfSl6FpDcbZRzJHFWDHvsw1Tpz4Q9Z++SpwVVm
         JmUyxEgAq2LjZzc+OkhyeF0ADm+bu03vFWElhLKmVcXuodsBknHK0n2IWaJQr+FjH/Z4
         ly63wavRjg8vLggYRlwWHybAT9gNxWq5j3pZ0p0w2xXzXTZlhASOY+NoRS2/AtMtjhTQ
         nTZWu9PlR/5rleTIvIDNYwbMF6iZSL/aHkUyyZqrHDOanbSxez20kKr5PC6Ct3iYGtdC
         ypG1bXEpsnYr9lf8V1DpKfNV0BYeA2in/OciIOL0bd/uD0xPHtdS27L3UXNyt2X2G1Wi
         /49g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692317333; x=1692922133;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=mE3f+VMf8SgNE6cCbkcfMUP8Hiy9b4N5xYpI+7a+l+E=;
        b=Cb6MHQ9+vt7xEkX9HvAwJzW5bAXTgjWDEBO/XVfg9ldyVSEVD2FK+7ZMXZtFsvu9EB
         x/L8su18+uqQjV3XGPvAhWb2wz1an73F5NX6U1ogd60Ov8j01ysrNdiig8AbMt/PEEZB
         evFlFb8+fG0AxgOfkRWjVME6mtFzmTFt0HFRTFs+LSqqJh0Wy+flwPIaKV46RtS9HOqG
         z6HFk7fPs/CNL+c4Xkx0rKdumfMesIBjRIHA66RN3iorZ29e+cZ07M6rtVOxOujhWEjQ
         KrBZ1qSFWvYLwamRJhkba+x+3pusleo7NX7c3+w75VEEWb1hXUVk1gY0Fll5ZshSi/CB
         brMg==
X-Gm-Message-State: AOJu0YyrJ7w2mLtGs0fkQYUlMHz1+xljoyCAc8F2St+Rzt+J5TfxqMqk
	TWJU0d/Lr/lG1V8x7lreTXZopoEGuOA=
X-Google-Smtp-Source: AGHT+IGvQyAfQmNzh/hNJU4kHU1VAazzXRBOVugeRSHej1YWD5+faOfCNQeeq5lvAq2y2Br8ZKMaZLXhQjo=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:4113:0:b0:d4b:99ce:5e51 with SMTP id
 o19-20020a254113000000b00d4b99ce5e51mr13582yba.6.1692317333678; Thu, 17 Aug
 2023 17:08:53 -0700 (PDT)
Date: Thu, 17 Aug 2023 17:08:36 -0700
In-Reply-To: <20230729004144.1054885-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230729004144.1054885-1-seanjc@google.com>
X-Mailer: git-send-email 2.42.0.rc1.204.g551eb34607-goog
Message-ID: <169229683179.1234886.15097906251075154792.b4-ty@google.com>
Subject: Re: [PATCH] KVM: Wrap kvm_{gfn,hva}_range.pte in a per-action union
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Huacai Chen <chenhuacai@kernel.org>, 
	Anup Patel <anup@brainfault.org>, Paul Walmsley <paul.walmsley@sifive.com>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-mips@vger.kernel.org, kvm@vger.kernel.org, 
	kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org, 
	linux-kernel@vger.kernel.org, Yu Zhao <yuzhao@google.com>
Content-Type: text/plain; charset="utf-8"

On Fri, 28 Jul 2023 17:41:44 -0700, Sean Christopherson wrote:
> Wrap kvm_{gfn,hva}_range.pte in a union so that future notifier events can
> pass event specific information up and down the stack without needing to
> constantly expand and churn the APIs.  Lockless aging of SPTEs will pass
> around a bitmap, and support for memory attributes will pass around the
> new attributes for the range.
> 
> Add a "KVM_NO_ARG" placeholder to simplify handling events without an
> argument (creating a dummy union variable is midly annoying).
> 
> [...]

Applied to kvm-x86 generic, with KVM_MMU_NOTIFIER_NO_ARG as suggested by Oliver.

[1/1] KVM: Wrap kvm_{gfn,hva}_range.pte in a per-action union
      https://github.com/kvm-x86/linux/commit/3e1efe2b67d3

--
https://github.com/kvm-x86/linux/tree/next
https://github.com/kvm-x86/linux/tree/fixes
