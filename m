Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A576AFFB
	for <kvmarm@lists.linux.dev>; Fri,  7 Apr 2023 23:30:46 +0000 (UTC)
Received: by mail-pl1-f202.google.com with SMTP id n15-20020a170902f60f00b001a273a4a685so16425487plg.15
        for <kvmarm@lists.linux.dev>; Fri, 07 Apr 2023 16:30:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1680910246;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=lFUj6O6CB3iiBV1uvi/t8sklxmHPNBdsFm6z4ma14Yo=;
        b=g5wwO/E/km9HV/J4Uo40AnPSisucwkmavL4S1Pf4Fx0jHCk1WbKxYKFrTEZxFx6XHp
         2exvb76Kc6SS9Ds8LXjXF0I1WFqClQxCNCC6sf4daSWTnp+YpnSO2121ov5N7kOpcqib
         YCLGPirwnvPcpp/S3fo5s+vT7QnEVjcGGwmgFHFlmScqbAaLkGHrQ6ia2vS3XVAARuDd
         sMCqZDZFuZewtQIjpJWpW7S/bUTL7IiTKNWpDkyOWB4W2AE70oenj4IH+Pui3ZI77/9t
         egivxNBn8aOes50PuEtPh0HjwIwXrfmgH5cXyJJ/cO29tWSweCMf9GcheLm+s0IsbY3F
         CJyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680910246;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=lFUj6O6CB3iiBV1uvi/t8sklxmHPNBdsFm6z4ma14Yo=;
        b=4ZOXZjWVYXHTjULewpHwGj4vrZa0wJ/a7hDsS6KLsv6C6loB53jY5LNEoD/ITmsmPP
         1bJ+Au9RBbPJzorAegKL1fmhp6iFPwSRpBCpZXcwLwSYZNu2dLioii8Vmf1gQAtOlMQW
         DVJqMsnucuQctJusTG4AMIpnUCQGIx3ANSdIlq7S79ekjF84edwazbQkVygVrbzMaF7b
         mqgUEqgLM9+eK+AbQdCLyBvG3Rb9g/kbBhA8vJy9WJNsicz+EQlhU1Afg/ML+zfFYFoL
         IBRMt4k7Jp8LUhsmspeLcNqzli0lR0ygieW55MJGaSjIY+j6vIaNXyV7uPdc4dZQkpEh
         wshA==
X-Gm-Message-State: AAQBX9dXWAcXtvSX4Pyy/V83zdPdcYP+MZr0zmaKCuAwXdrLDrFcv9Xy
	Nl6BeR9fbRfSm17hFG1jEG1Z8eDHY9A=
X-Google-Smtp-Source: AKy350YxihhHFMNV20FoO+AQH03z9Y8GXCy5PhVvBVZ1Rdqa7VXUgXNseSxSRo6RlhR0sxbeKagnCEmAUJY=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90a:cc01:b0:244:9909:6e60 with SMTP id
 b1-20020a17090acc0100b0024499096e60mr959943pju.3.1680910245959; Fri, 07 Apr
 2023 16:30:45 -0700 (PDT)
Date: Fri, 7 Apr 2023 16:30:44 -0700
In-Reply-To: <20230306190156.434452-1-dmatlack@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230306190156.434452-1-dmatlack@google.com>
Message-ID: <ZDCnpAd0fh2cKcpS@google.com>
Subject: Re: [PATCH v2 0/4] KVM: Refactor KVM stats macros and enable custom
 stat names
From: Sean Christopherson <seanjc@google.com>
To: David Matlack <dmatlack@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, James Morse <james.morse@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Huacai Chen <chenhuacai@kernel.org>, 
	Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>, Anup Patel <anup@brainfault.org>, 
	Atish Patra <atishp@atishpatra.org>, Paul Walmsley <paul.walmsley@sifive.com>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Christian Borntraeger <borntraeger@linux.ibm.com>, Janosch Frank <frankja@linux.ibm.com>, 
	Claudio Imbrenda <imbrenda@linux.ibm.com>, David Hildenbrand <david@redhat.com>, 
	Michael Ellerman <mpe@ellerman.id.au>, Eric Farman <farman@linux.ibm.com>, 
	"Philippe =?iso-8859-1?Q?Mathieu-Daud=E9?=" <philmd@linaro.org>, Sathvika Vasireddy <sv@linux.ibm.com>, 
	Nicholas Piggin <npiggin@gmail.com>, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, linux-mips@vger.kernel.org, kvm@vger.kernel.org, 
	linuxppc-dev@lists.ozlabs.org, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org
Content-Type: text/plain; charset="us-ascii"

On Mon, Mar 06, 2023, David Matlack wrote:
> David Matlack (4):
>   KVM: Refactor stats descriptor generation macros
>   KVM: Refactor designated initializer macros for struct _kvm_stats_desc
>   KVM: Allow custom names for KVM_STAT()
>   KVM: x86: Drop union for pages_{4k,2m,1g} stats
> 
>  arch/arm64/kvm/guest.c          |  14 +--
>  arch/mips/kvm/mips.c            |  54 ++++-----
>  arch/powerpc/kvm/book3s.c       |  62 +++++-----
>  arch/powerpc/kvm/booke.c        |  48 ++++----
>  arch/riscv/kvm/vcpu.c           |  16 +--
>  arch/s390/kvm/kvm-s390.c        | 198 ++++++++++++++++----------------
>  arch/x86/include/asm/kvm_host.h |   9 +-
>  arch/x86/kvm/x86.c              |  94 +++++++--------
>  include/linux/kvm_host.h        | 179 +++++++++++------------------
>  9 files changed, 314 insertions(+), 360 deletions(-)

For the series,

Reviewed-by: Sean Christopherson <seanjc@google.com>
