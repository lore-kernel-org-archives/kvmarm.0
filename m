Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9989212B6C
	for <kvmarm@lists.linux.dev>; Tue,  8 Aug 2023 15:07:46 +0000 (UTC)
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-564e1843717so1866519a12.0
        for <kvmarm@lists.linux.dev>; Tue, 08 Aug 2023 08:07:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1691507266; x=1692112066;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=BaiJ+rWGolW4ovI22gadBn2AFu8/7ikdaAkBdyz0qCk=;
        b=ayK3mYp5ZQm5F204c8SfuM/WFFVkRk0fgjxIN5q1r27VDVtngJ+7mGzuMl45HAdfj+
         V0WUPOd+87OJ1kHr8JYMh1jq5/tq0s1635UzLBWQvYLHswE1gAXBqE56zdYG8sjZPtDA
         7V8ZJPVauL7LNyPcAMrHkgeX4lK3nQuvXLwGO4LTA3Ld1a1174s+Z3Ro0YWwTJ0bmels
         x1gehns8QavBItnA8zjbhJEYkc9b4ERehz8TcMLkVftVKrJxnEapaV9ia5Kx4INBTTln
         mT/PFDUjApHcOuvbXA3Z6GkBBZAh+Gz0FHUPQ0QQMlY0jiz3lf4rRwDfnf637apvnFTV
         /Plg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691507266; x=1692112066;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=BaiJ+rWGolW4ovI22gadBn2AFu8/7ikdaAkBdyz0qCk=;
        b=UAxuqVcNKfhvpkFuD0nuBxqNbvPbQEMr1RZzqsNsFhpWw5dTg+VqVtfwDmFamdSOcM
         CISTKMomF7XSxVoyF3PrwCfmVsDduXj79H/LZo4lS9VLHuygDBFeZEY6NrfwYMKMT3wa
         QTdalGdqHXkLLf3twtO/Bnp7WCUlOifNjDdynIqy4GezGLDCgwIDARINBzMx6Fo/JK9U
         pyswxsykt7t6p0diRvHqczpwaUvYZkTe1/kcM54PHHGDnUSi1p0GQsak31fRB32QHyx0
         q+VT4XtkziJDTfeZ2nbdD5aAXpKbeecrG7LsbxDd/Rnuqg2zwg9LNSoJQXGau6tNH1UQ
         8h7Q==
X-Gm-Message-State: AOJu0YxOBFuFkY4OduWURtMDogR4oSVc/LPBm90pV1PdAjfTBXYZCJuS
	CEg1MlECXa08Sx35f24eMjYHJdrI0qs=
X-Google-Smtp-Source: AGHT+IG5/N2ZE1Ejorc8NLEsKzeCITxV+EG+130yb+21WD/iP5VWmZCCV6UyxFu6UTgxWYvax2jHbb68fQQ=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a63:3c11:0:b0:564:179a:d5cb with SMTP id
 j17-20020a633c11000000b00564179ad5cbmr56114pga.8.1691507265754; Tue, 08 Aug
 2023 08:07:45 -0700 (PDT)
Date: Tue, 8 Aug 2023 08:07:43 -0700
In-Reply-To: <CAJHc60zN-dc2E-fS7fuXgkrfGD9bqW6tMy2GRZxbHOeZv0ZOBw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230722022251.3446223-1-rananta@google.com> <20230722022251.3446223-3-rananta@google.com>
 <87tttpr6qy.wl-maz@kernel.org> <ZMgsjx8dwKd4xBGe@google.com>
 <877cqdqw12.wl-maz@kernel.org> <CAJHc60xAUVt5fbhEkOqeC-VF8SWVOt3si=1yxVVAUW=+Hu_wNg@mail.gmail.com>
 <CAJHc60zN-dc2E-fS7fuXgkrfGD9bqW6tMy2GRZxbHOeZv0ZOBw@mail.gmail.com>
Message-ID: <ZNJaPxTtPRCv0HOl@google.com>
Subject: Re: [PATCH v7 02/12] KVM: arm64: Use kvm_arch_flush_remote_tlbs()
From: Sean Christopherson <seanjc@google.com>
To: Raghavendra Rao Ananta <rananta@google.com>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	James Morse <james.morse@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, Huacai Chen <chenhuacai@kernel.org>, 
	Zenghui Yu <yuzenghui@huawei.com>, Anup Patel <anup@brainfault.org>, 
	Atish Patra <atishp@atishpatra.org>, Jing Zhang <jingzhangos@google.com>, 
	Reiji Watanabe <reijiw@google.com>, Colton Lewis <coltonlewis@google.com>, 
	David Matlack <dmatlack@google.com>, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, linux-mips@vger.kernel.org, 
	kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org, 
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Aug 04, 2023, Raghavendra Rao Ananta wrote:
> On Wed, Aug 2, 2023 at 4:28=E2=80=AFPM Raghavendra Rao Ananta
> <rananta@google.com> wrote:
> >
> > Sure, I'll change it to kvm_arch_flush_vm_tlbs() in v8.
> >
> While working on the renaming, I realized that since this function is
> called from kvm_main.c's kvm_flush_remote_tlbs(). Do we want to rename
> this and the other kvm_flush_*() functions that the series introduces
> to match their kvm_arch_flush_*() counterparts?

Hmm, if we're going to rename one arch hook, then yes, I think it makes sen=
se to
rename all the common APIs and arch hooks to match.

However, x86 is rife with the "remote_tlbs" nomenclature, and renaming the =
common
APIs will just push the inconsistencies into x86.  While I 100% agree that =
the
current naming is flawed, I am not willing to end up with x86 being partial=
ly
converted.

I think I'm ok renaming all of x86's many hooks?  But I'd definitely want i=
nput
from more x86 folks, and the size and scope of this series would explode.  =
Unless
Marc objects and/or has a better idea, the least awful option is probably t=
o ignore
the poor "remote_tlbs" naming and tackle it in a separate series.

Sorry for not noticiing this earlier, I didn't realize just how much x86 us=
es
remote_tlbs.

> (spiraling more into this, we also have the 'remote_tlb_flush_requests' a=
nd
> 'remote_tlb_flush' stats)

Regardless of what we decide for the APIs, definitely leave the stats alone=
.  The
names are ABI.  We could preserve the names and changes the struct fields, =
but that
would be a net negative IMO.
