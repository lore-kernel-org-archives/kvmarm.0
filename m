Received: from mail-wr1-f50.google.com (mail-wr1-f50.google.com [209.85.221.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BD7117FC
	for <kvmarm@lists.linux.dev>; Thu, 18 May 2023 07:32:58 +0000 (UTC)
Received: by mail-wr1-f50.google.com with SMTP id ffacd0b85a97d-3078aa0b152so1112324f8f.3
        for <kvmarm@lists.linux.dev>; Thu, 18 May 2023 00:32:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1684395176; x=1686987176;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=/Nr3DCNB0Ixq72umVN8Ju8XfUzmslSWPo/26RuL/v64=;
        b=lgWrWFUqwIldB1/V3hLGpdkSWhVDPycAmU8Mb4DgAs8Kdp50VYkKtRMkBE/iO7HR6K
         YG22U7m0sQNRC4eEWVXiAuLVpZu37bDV9Stsuo+uvxVhf3HszKROh7xNWvhlcT5VzGmn
         Ltw6vxOCDiTdALmS//YmL9KOGZmOkdGpQJDxWxy5ocrzN2eZlhLShQtKcTUT/432p8qT
         MU2XTtGY1N/K2fdCulWo4u/0/4v3T37U+TdX5fvFeYpldD1wtaumhvjDzTjiSPZEZ/in
         Ac0nQnbghlggU1O6LnzFQ33nJ94VD5brGYVGvSgEpxvfBA6LvcKWlJx2fhXAWhEOlsAj
         Bu8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684395176; x=1686987176;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/Nr3DCNB0Ixq72umVN8Ju8XfUzmslSWPo/26RuL/v64=;
        b=N5FjYe5GV0bSyXS73xxYNIyBj6AmtG9gnPBDl0KXYAOSEmKjPTuwONQuSvyZ3KMj2e
         nIulRl8CFzHyjwNKLfnttuuxJdeuT71wp0YhvfzinfywMOWy/QSEn3Qr5Z2A9KtThHj7
         B8mKmNd9qbVRs+NxTjoKltyzPM8VlNuumnorjjEhDDSKGdckSi9N+wCIl7Q0Xrbo/6YJ
         xL9kEh3ybHG8rE1llJxihZFZbHFDj4VtCdnmiVjqZlS29cDJDaRxgwXRL09uSBYDrf/Q
         edIGu4X3XRozhWlZzK3JA3Ng5ogA+tCNbxxUa0gvxHwFx8EEQrhqzxNgT59MnGXYVEtL
         S7DQ==
X-Gm-Message-State: AC+VfDytyglpVLoGf7Va6112Oto9RDhwm72dOxv/ABvBZCJY81LQF4Ux
	W7/0YtnRJGv1kbvlU737nJ62Sw==
X-Google-Smtp-Source: ACHHUZ7xPFCjfZgnxJjwQ1q3sKhEpq9jWYbgE8XVf82gwX/CzK1u2s1hoM6OrcuqCwZHD2o13qE15g==
X-Received: by 2002:a5d:4fce:0:b0:307:86fb:dada with SMTP id h14-20020a5d4fce000000b0030786fbdadamr818073wrw.36.1684395176400;
        Thu, 18 May 2023 00:32:56 -0700 (PDT)
Received: from localhost (cst2-173-16.cust.vodafone.cz. [31.30.173.16])
        by smtp.gmail.com with ESMTPSA id g8-20020adfe408000000b002f9e04459desm1160629wrm.109.2023.05.18.00.32.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 May 2023 00:32:56 -0700 (PDT)
Date: Thu, 18 May 2023 09:32:55 +0200
From: Andrew Jones <ajones@ventanamicro.com>
To: Haibo Xu <xiaobo55x@gmail.com>
Cc: Haibo Xu <haibo1.xu@intel.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Jonathan Corbet <corbet@lwn.net>, Anup Patel <anup@brainfault.org>, 
	Atish Patra <atishp@atishpatra.org>, Paul Walmsley <paul.walmsley@sifive.com>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, Shuah Khan <shuah@kernel.org>, 
	kvm@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org, linux-kselftest@vger.kernel.org, 
	kvmarm@lists.linux.dev, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Sean Christopherson <seanjc@google.com>
Subject: Re: [PATCH 2/2] KVM: selftests: Add riscv get-reg-list test
Message-ID: <20230518-60da3b82641bdaccec589b8b@orel>
References: <cover.1683791148.git.haibo1.xu@intel.com>
 <751a84a9691c86df0e65cdb02abf1e073892d1ca.1683791148.git.haibo1.xu@intel.com>
 <20230511-28ec368a8168342c68ca2187@orel>
 <CAJve8okVFr-m6go6dCg7Cf=Uq3Yt9Xmxi0Z3B2vbWvahvx4GgA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJve8okVFr-m6go6dCg7Cf=Uq3Yt9Xmxi0Z3B2vbWvahvx4GgA@mail.gmail.com>

On Thu, May 18, 2023 at 12:17:18PM +0800, Haibo Xu wrote:
...
> > The idea of these *to_str functions is to dump output that can be
> > copy+pasted into a reg array (hence the trailing commas in print_reg
> > lines). So we can't just print random lines here or return '##UNKOWN##',
> > as that won't compile. Instead, the default should return
> >
> >   str_with_index("KVM_REG_RISCV_CONFIG_REG(##)", reg_off)
> >
> 
> Thanks for sharing the detailed idea, will fix it in next version!

I guess we could also return a string like,

"KVM_REG_RISCV_CONFIG_REG(##) /* UNKNOWN */"

as that would still compile and also convey the message that this
register doesn't have a name because the test doesn't know it yet.

...
> > We should share all the code above, except print_reg(), with aarch64.
> > I'll send a patch series that splits the arch-neutral code out of
> > the aarch64 test that you can base this test on.
> >
> 
> Good idea! I will rebase the patch based on your work.
>

Ok, I've pushed patches to [1]. This series introduces two things to KVM
selftests. Primarily it splits the aarch64/get-reg-list test into a
cross-arch get-reg-list test and an $ARCH_DIR/get-reg-list.o object file,
which the cross-arch test depends on. To do that, it also introduces the
concept of a "split test", a test that has a cross-arch part which depends
on an arch-specific part. Using a split test is cleaner than the
#ifdeffery we usually do for cross-arch tests.

I've added kvmarm@lists.linux.dev, Marc, Oliver, and Sean to the CC of
this message. You'll want to add them when you post v2 as well.

[1] https://github.com/jones-drew/linux/commits/arm64/kself/get-reg-list

Thanks,
drew
