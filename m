Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA5B21D524
	for <kvmarm@lists.linux.dev>; Thu, 14 Sep 2023 10:15:54 +0000 (UTC)
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-401c90ed2ecso8626045e9.0
        for <kvmarm@lists.linux.dev>; Thu, 14 Sep 2023 03:15:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1694686553; x=1695291353; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=VyIjI/I6fiuQb5fro76kkYxOSc4xq/0TuIo+mtjDBWI=;
        b=mE45ncYLRKHPTLIByuZaGmDpt75RBLlXYzbV70tVQ1gd81Dux5iPdBUod1biDASQzD
         uM99vNgCFm5Zz3YyDsVRwvpWWZckEjfNhUJBLgCWKJ96c94CC+btIxkJnRAqF9AIcvWn
         l3YzmEywMXRQRhiKMcmoZi04ndsClJ+cBKR4vYrOfXBRquwKwwQJazE1ODp8VyNJ0DGi
         axIFyLYq2/FhPMZjz5sgn1gIynd/z6/VQPo3FOGG8OQIOPYBUVIgJEf3jbu9SQjPcAfE
         gUXez2yth4w5aanLKWJJpiot4l7qwjtYVDqLWk5qNb5Qe/eNLTl5VrN/2C71B5cBDE+a
         qE/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694686553; x=1695291353;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VyIjI/I6fiuQb5fro76kkYxOSc4xq/0TuIo+mtjDBWI=;
        b=voLYsq12P1rXSM98jD5SSmerR10MShccmf3EoRF//RFGUJv/10q9dfd4gKuMtYD9vd
         KRk28HwyNaQOteoPV0ZA4C2y6amSg81eIySzcajXVbqvBZmX639zyhU2Wl9bGJvlNzbv
         eNxfQTszNmBtjAt37bPSuZVW+pUPA+6XEnh8+NyAg0SX2UdZp3tVw5natV7MVFvSyYH1
         hgBBfCuK0MJlEBlSj4gF4Rj2zkdISxapNJMon4AMrhdSuU0Mhbr5AN5UtS70KNjpuSUi
         LACqpzn890ZQJfpOr+1+EyiDvNnIKfQqTBCxcovEdXD0gH/CATtSLXQvIFou+vwM+SAv
         Dmsg==
X-Gm-Message-State: AOJu0Yyz3DXN8pvfpnOfnoybNY8CGwxSGkbYL2D7p4SNdDoiy/IK58jt
	EZ1xMeRpsVyyv42zuNgFZlKfgg==
X-Google-Smtp-Source: AGHT+IH7ZT746JOyiS+eOvZlolhRQEl4EX2Lm6S0kGQOnu5nvVuWeFGDXcIG88aW5kDFIAcnKh6/BQ==
X-Received: by 2002:adf:d0c3:0:b0:31a:d2f9:7372 with SMTP id z3-20020adfd0c3000000b0031ad2f97372mr4347143wrh.29.1694686552802;
        Thu, 14 Sep 2023 03:15:52 -0700 (PDT)
Received: from localhost (cst2-173-16.cust.vodafone.cz. [31.30.173.16])
        by smtp.gmail.com with ESMTPSA id k8-20020a5d5248000000b0031fc4c31d77sm1340310wrc.88.2023.09.14.03.15.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Sep 2023 03:15:51 -0700 (PDT)
Date: Thu, 14 Sep 2023 12:15:50 +0200
From: Andrew Jones <ajones@ventanamicro.com>
To: Conor Dooley <conor.dooley@microchip.com>
Cc: Haibo Xu <haibo1.xu@intel.com>, xiaobo55x@gmail.com, 
	Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Albert Ou <aou@eecs.berkeley.edu>, Paolo Bonzini <pbonzini@redhat.com>, 
	Shuah Khan <shuah@kernel.org>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, James Morse <james.morse@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Anup Patel <anup@brainfault.org>, Atish Patra <atishp@atishpatra.org>, 
	Sean Christopherson <seanjc@google.com>, Ricardo Koller <ricarkol@google.com>, 
	Vishal Annapurve <vannapurve@google.com>, Vitaly Kuznetsov <vkuznets@redhat.com>, 
	Vipin Sharma <vipinsh@google.com>, David Matlack <dmatlack@google.com>, 
	Colton Lewis <coltonlewis@google.com>, Aaron Lewis <aaronlewis@google.com>, 
	Thomas Huth <thuth@redhat.com>, linux-kernel@vger.kernel.org, linux-riscv@lists.infradead.org, 
	kvm@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, kvm-riscv@lists.infradead.org
Subject: Re: [PATCH v3 9/9] KVM: riscv: selftests: Add sstc timer test
Message-ID: <20230914-2232dea1c6d03fb5985755e6@orel>
References: <cover.1694421911.git.haibo1.xu@intel.com>
 <64e0637cd6f22dd7557ed44bd2242001e7830d1c.1694421911.git.haibo1.xu@intel.com>
 <20230914-ee133dd5e804282ce28833d6@orel>
 <20230914-reflector-preshow-786425ad7ae2@wendy>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230914-reflector-preshow-786425ad7ae2@wendy>

On Thu, Sep 14, 2023 at 10:52:15AM +0100, Conor Dooley wrote:
> On Thu, Sep 14, 2023 at 11:36:01AM +0200, Andrew Jones wrote:
> > > +static inline void cpu_relax(void)
> > > +{
> > > +#ifdef __riscv_zihintpause
> > > +	asm volatile("pause" ::: "memory");
> > > +#else
> > > +	/* Encoding of the pause instruction */
> > > +	asm volatile(".4byte 0x100000F" ::: "memory");
> > > +#endif
> > > +}
> > 
> > cpu_relax() should go to include/riscv/processor.h
> 
> Can the one from asm/vdso/processor.h be reused, or are there special
> considerations preventing that?

We'd need to copy it into tools/arch/riscv/include/asm, but it could be
done. Hmm, now that I look at it, I see we're missing the barrier() call
in this kvm selftests version.

Thanks,
drew
