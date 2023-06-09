Received: from mail-il1-f172.google.com (mail-il1-f172.google.com [209.85.166.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2016A44
	for <kvmarm@lists.linux.dev>; Fri,  9 Jun 2023 01:01:25 +0000 (UTC)
Received: by mail-il1-f172.google.com with SMTP id e9e14a558f8ab-33ed16b1360so59135ab.1
        for <kvmarm@lists.linux.dev>; Thu, 08 Jun 2023 18:01:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1686272485; x=1688864485;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wOlumE3ouLCIH2RP0G1dM53dguqR91oQKVL0viimj70=;
        b=0QiRzLBEfIKm2SVV80x9b/gSHafnBJNKTDt5o9p/8YxMb+AMC9QQBod2E/wzrHuceY
         ouEbiAOyTT2VNZhRW/Ddnr3fLkpDnEjgK4IX7o8er5B//o+OfqB1UfsOITa9lNtjMafb
         POzHfxb+JBYWaM9Q9Ufh+5YDTUlBacFxBJYv75ZsvmP+jho8O69/5BM7c4fJ08LSrba+
         UrPymZ+DU6ROxWa0sxtG8xgOeygPpEsqe4Tl0IyVl7eg3plBMhgdDs7FjlM9qIUxQhSA
         NwnqOQ5SI3/bpHuPo07dXtQdCuXb2Usg3ZiXaCniUcNf+AkBFv+ScKeiNCZmKKK14NoY
         C2IQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686272485; x=1688864485;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wOlumE3ouLCIH2RP0G1dM53dguqR91oQKVL0viimj70=;
        b=jVM5SdxVLIKHLNYbrNYVfV1yRGyYsUZom8D2vz3RtUaPA2t8todgmg8ExR9mlYWVK6
         HeIggUotSzhlwKOayXrbUrYgfljUu8YppuKZ/N7nlIPNSaoBh7TlAyctmHK+nzXdZuDB
         4r6PSxmFVHRKNrLXebpekuUEX14wR30PigLj+a5EcVhHdpKpIOgfJgldGQ5/EjUuIgQ8
         BOXmwJaVmumB1UJWCU9WgmnesSZUsRVq8Gvu98KkRGJfA9SeTW8KRxAYPhxEisetMMAt
         oicVhwgmDtjNBZwX69l2eNKILSKKBS4VGn9Njr7rE6rTJRWwt5cnP7fIWWiDonmS+3vU
         OtUw==
X-Gm-Message-State: AC+VfDySHT9iljznayhZjkockE1rS4PsrkqeMnbEWxlyJ9Y0YQOelD/r
	a7FXJtI6aTaP09/xjsSraq0ts6gE8QskCc0HeAjtXA==
X-Google-Smtp-Source: ACHHUZ6K7WtRN1/jwhwUmn81V7wZks+0RBM4oqsXU0y3En74mlS5GsDCmNvtd7xuOihBLkGIFFFI5IogGsWfvJXaSzU=
X-Received: by 2002:a05:6e02:1d90:b0:335:6626:9f38 with SMTP id
 h16-20020a056e021d9000b0033566269f38mr412896ila.0.1686272484663; Thu, 08 Jun
 2023 18:01:24 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230526234435.662652-1-yuzhao@google.com> <20230526234435.662652-2-yuzhao@google.com>
 <ZH7vh1GmsV+UCPwv@google.com>
In-Reply-To: <ZH7vh1GmsV+UCPwv@google.com>
From: Yu Zhao <yuzhao@google.com>
Date: Thu, 8 Jun 2023 19:00:48 -0600
Message-ID: <CAOUHufa8C-OVwKxNyjQcrGxO9r5GCge+GSbwo8JO2GFOP10TtQ@mail.gmail.com>
Subject: Re: [PATCH mm-unstable v2 01/10] mm/kvm: add mmu_notifier_ops->test_clear_young()
To: Tzung-Bi Shih <tzungbi@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Paolo Bonzini <pbonzini@redhat.com>, 
	Alistair Popple <apopple@nvidia.com>, Anup Patel <anup@brainfault.org>, 
	Ben Gardon <bgardon@google.com>, Borislav Petkov <bp@alien8.de>, 
	Catalin Marinas <catalin.marinas@arm.com>, Chao Peng <chao.p.peng@linux.intel.com>, 
	Christophe Leroy <christophe.leroy@csgroup.eu>, Dave Hansen <dave.hansen@linux.intel.com>, 
	Fabiano Rosas <farosas@linux.ibm.com>, Gaosheng Cui <cuigaosheng1@huawei.com>, 
	Gavin Shan <gshan@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>, 
	James Morse <james.morse@arm.com>, "Jason A. Donenfeld" <Jason@zx2c4.com>, Jason Gunthorpe <jgg@ziepe.ca>, 
	Jonathan Corbet <corbet@lwn.net>, Marc Zyngier <maz@kernel.org>, Masami Hiramatsu <mhiramat@kernel.org>, 
	Michael Ellerman <mpe@ellerman.id.au>, Michael Larabel <michael@michaellarabel.com>, 
	Mike Rapoport <rppt@kernel.org>, Nicholas Piggin <npiggin@gmail.com>, 
	Oliver Upton <oliver.upton@linux.dev>, Paul Mackerras <paulus@ozlabs.org>, Peter Xu <peterx@redhat.com>, 
	Sean Christopherson <seanjc@google.com>, Steven Rostedt <rostedt@goodmis.org>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Thomas Gleixner <tglx@linutronix.de>, 
	Thomas Huth <thuth@redhat.com>, Will Deacon <will@kernel.org>, Zenghui Yu <yuzenghui@huawei.com>, 
	kvmarm@lists.linux.dev, kvm@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	linuxppc-dev@lists.ozlabs.org, linux-trace-kernel@vger.kernel.org, 
	x86@kernel.org, linux-mm@google.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Jun 6, 2023 at 2:34=E2=80=AFAM Tzung-Bi Shih <tzungbi@kernel.org> w=
rote:
>
> On Fri, May 26, 2023 at 05:44:26PM -0600, Yu Zhao wrote:
> > +/*
> > + * Architectures that implement kvm_arch_test_clear_young() should ove=
rride
> > + * kvm_arch_has_test_clear_young().
> > + *
> > + * kvm_arch_has_test_clear_young() is allowed to return false positive=
, i.e., it
> > + * can return true if kvm_arch_test_clear_young() is supported but dis=
abled due
> > + * to some runtime constraint. In this case, kvm_arch_test_clear_young=
() should
>
> Is it a typo here?  s/kvm_arch_test_clear_young/kvm_arch_has_test_clear_y=
oung/.

Not a typo.
