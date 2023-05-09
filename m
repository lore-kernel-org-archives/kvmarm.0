Received: from mail-vs1-f43.google.com (mail-vs1-f43.google.com [209.85.217.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B81EE19902
	for <kvmarm@lists.linux.dev>; Tue,  9 May 2023 20:52:09 +0000 (UTC)
Received: by mail-vs1-f43.google.com with SMTP id ada2fe7eead31-4348416ae45so3376485137.3
        for <kvmarm@lists.linux.dev>; Tue, 09 May 2023 13:52:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1683665528; x=1686257528;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1ek4N4zhVnFp0OjD2e91cJw6qEMFFDQc5/FTgmHiGak=;
        b=rVJW9XdHV4bhVBpENigqqik2I2pCncaz794aO5r0GaFD6EOogLB5GsTpjkOXXFk1cl
         BLaajyFwcHYbDsMksrmy46rkJ8Xg5XgSiPcKIeqTk5sc4i6ByJVNSNE661bfq0lTqdr5
         15qPLPCf/jWgZf76j7FinTn4I6xu8cSDiM5g9kSu8JtTXKgSM8OwYPMKVaG7suYL8InA
         DMrcHjABRjgiApDllMJEgP/iLFCOFcqlwydZH35zZAE5dGhLWBf35Ag5dGmDJHpUzL+l
         I6D5uZx78KFyGlmPQFh+q8W5REGbWvTcrIRfpmnEKUzBt+OarAE0cEQNLkGT/+HDIP0z
         HuDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683665528; x=1686257528;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1ek4N4zhVnFp0OjD2e91cJw6qEMFFDQc5/FTgmHiGak=;
        b=f/v+WcTWIcCrzyx05y2Vp1cJV0vQsoBm6pPU6ED1+9Sb1iLnfdI5jDeQhJSrrHdZ56
         uyz3GcSCYSqWmMADwPfyIgH4Y9MujPSVq4Pu+PumoVdCIx703uS2WKrZEDk41GTeWY3m
         QJPz6fdspyb5quiSl5n9YVEfQsq56+FE3lT4DyOLYEwDQvO2D816vpWjilABiCmY7i4U
         1wdgVpgUmYH3i1zQNmbpjliRc53cvWxefbA3XtN70c3f7EaZgv2dUvVULNU/1vbAGZHh
         wR5DUGpbHfDhX4hLcsH26nltpaDS90l5dzhVXC+74fTw4dlC8nfQGxacSKBi5K7RxFg+
         ywwQ==
X-Gm-Message-State: AC+VfDxAp0N4v4r9fNrRRnE+FSH18iXGCb7k5sKqoI66riQQKQZm75LW
	J1H0R3UJXJD1YmfQnM36Gj0hgHtWry5gTdS0md3+vw==
X-Google-Smtp-Source: ACHHUZ5qUtibgquXG1CHXn5rsYEnNugGuamTPmXoGAjYsiSltyM3mefeFrXCpD+c8boXnApqrdpstv0ZlJ4ZhdJ1iOQ=
X-Received: by 2002:a67:f291:0:b0:42e:6748:13dc with SMTP id
 m17-20020a67f291000000b0042e674813dcmr5348659vsk.0.1683665528538; Tue, 09 May
 2023 13:52:08 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230306190156.434452-1-dmatlack@google.com>
In-Reply-To: <20230306190156.434452-1-dmatlack@google.com>
From: David Matlack <dmatlack@google.com>
Date: Tue, 9 May 2023 13:51:42 -0700
Message-ID: <CALzav=fZFpzw57hNmg2fqYG-0ddtvQd9+=7cw8tzuOGbZW1A1A@mail.gmail.com>
Subject: Re: [PATCH v2 0/4] KVM: Refactor KVM stats macros and enable custom
 stat names
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	James Morse <james.morse@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Huacai Chen <chenhuacai@kernel.org>, 
	Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>, Anup Patel <anup@brainfault.org>, 
	Atish Patra <atishp@atishpatra.org>, Paul Walmsley <paul.walmsley@sifive.com>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Christian Borntraeger <borntraeger@linux.ibm.com>, Janosch Frank <frankja@linux.ibm.com>, 
	Claudio Imbrenda <imbrenda@linux.ibm.com>, David Hildenbrand <david@redhat.com>, 
	Sean Christopherson <seanjc@google.com>, Michael Ellerman <mpe@ellerman.id.au>, 
	Eric Farman <farman@linux.ibm.com>, =?UTF-8?Q?Philippe_Mathieu=2DDaud=C3=A9?= <philmd@linaro.org>, 
	Sathvika Vasireddy <sv@linux.ibm.com>, Nicholas Piggin <npiggin@gmail.com>, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-mips@vger.kernel.org, kvm@vger.kernel.org, 
	linuxppc-dev@lists.ozlabs.org, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Mar 6, 2023 at 11:01=E2=80=AFAM David Matlack <dmatlack@google.com>=
 wrote:
>
> This series refactors the KVM stats macros to reduce duplication and
> adds the support for choosing custom names for stats.

Hi Paolo,

I just wanted to double-check if this series is on your radar
(probably for 6.5)?
