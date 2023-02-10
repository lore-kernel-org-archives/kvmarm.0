Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A36A9624
	for <kvmarm@lists.linux.dev>; Fri, 10 Feb 2023 01:28:04 +0000 (UTC)
Received: by mail-pl1-f176.google.com with SMTP id u9so4951120plf.3
        for <kvmarm@lists.linux.dev>; Thu, 09 Feb 2023 17:28:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Mnobgm7/BRwA5boztD22jzgEkU3wNnOY9D1aetlEf20=;
        b=csIO68IIOhsu6e+pdejTTT2+w48D/sWWLOeOIyNJYGX8uv7NM4VXMJmzIiRrpc2byB
         oNF30v46MfMUr/zM1Y9pIBSYlUDIVF+op3/R/inHFDRjbUPyvEWGmS8g+4aYPNOLXmI1
         k4gFifjP8fAfy+Pj0D/2S3/yl0kgg472XcQ7oejDQhBv7j6e61xvYtTNJxFhtCLHkUR0
         vwFGPM0W1k1+6VAy/nE3sRCRvI1WK//Zg5F92Z7EstjU8c++zH/a/c8dOrVkEQhduubT
         CTG0B3v3Gj7juI3iy68AbH4UWi8S6xjEzA/lWDNstS1PF9tuSuPj4tgHC/qRIAxoM46N
         zJcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Mnobgm7/BRwA5boztD22jzgEkU3wNnOY9D1aetlEf20=;
        b=jsmGfwxz57sLvv0lBf9+pUs6aLXOaz2cxiBKxIHddCzU6xjIumttn5/RHCH3ua/rCd
         QBpy1i0x9ZYsHayy0mrYd25z1D7txcV5vhSSXhm9kHpZGGaM4M6JGRv0eyadAWP5f4Jm
         R5cmuixES4Wckd+ZRCn/OJEw0gvWj0MgRrkDo8lCfYTvE9Zr3NGvSbeBbwmFcI8BnCa4
         HeejCpYhyPiNdMtL2hsNFB09tVC0s49KGB1+RrHv2JntSNY9QZQCJXxxBXbw5pLd5I7Q
         sW4lkY1Ky+Q+BGpJHvEYk6gzhAfu9hvNKXKeZveGl25JevFqXKuyvtVom1FxJjxvo3Y4
         4DzA==
X-Gm-Message-State: AO0yUKV06c3IP72tzkKW1ZY2k/vGo5YHpoA+ocqik8RcFsYLmSsEalL9
	5ms6hwev3ylgrJhB+aV/Yf1bvw==
X-Google-Smtp-Source: AK7set9Obj4DfpjGpxNp3bHnBxnNHSIelzzZM7dkpr8wS73Skb7zUOHunDsTlPiKfqLt2v8la2CkZg==
X-Received: by 2002:a17:903:264c:b0:198:af4f:de0c with SMTP id je12-20020a170903264c00b00198af4fde0cmr103011plb.12.1675992483947;
        Thu, 09 Feb 2023 17:28:03 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id jk11-20020a170903330b00b00198da1ce519sm2143807plb.111.2023.02.09.17.28.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Feb 2023 17:28:02 -0800 (PST)
Date: Fri, 10 Feb 2023 01:27:59 +0000
From: Sean Christopherson <seanjc@google.com>
To: Marc Zyngier <maz@kernel.org>
Cc: David Matlack <dmatlack@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Huacai Chen <chenhuacai@kernel.org>,
	Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
	Anup Patel <anup@brainfault.org>,
	Atish Patra <atishp@atishpatra.org>,
	Paul Walmsley <paul.walmsley@sifive.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	kvmarm@lists.cs.columbia.edu, linux-mips@vger.kernel.org,
	kvm@vger.kernel.org, kvm-riscv@lists.infradead.org,
	linux-riscv@lists.infradead.org,
	Raghavendra Rao Ananta <rananta@google.com>
Subject: Re: [PATCH v2 2/7] KVM: arm64: Use kvm_arch_flush_remote_tlbs()
Message-ID: <Y+Wdn+mYVYhwut5l@google.com>
References: <20230126184025.2294823-1-dmatlack@google.com>
 <20230126184025.2294823-3-dmatlack@google.com>
 <86o7q4zdcp.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86o7q4zdcp.wl-maz@kernel.org>

On Wed, Feb 08, 2023, Marc Zyngier wrote:
> On Thu, 26 Jan 2023 18:40:20 +0000, David Matlack <dmatlack@google.com> wrote:
> > @@ -368,7 +367,6 @@ void kvm_flush_remote_tlbs(struct kvm *kvm)
> >  		++kvm->stat.generic.remote_tlb_flush;
> >  }
> 
> For context, we currently have this:
> 
> 	if (!kvm_arch_flush_remote_tlb(kvm)
> 	    || kvm_make_all_cpus_request(kvm, KVM_REQ_TLB_FLUSH))
> 		++kvm->stat.generic.remote_tlb_flush;
> 
> Is there any reason why we shouldn't move the KVM_REQ_TLB_FLUSH call
> into the arch-specific helpers? This is architecture specific, even if
> the majority of the supported architecture cannot do broadcast
> invalidation like arm64 does.

s390 and PPC don't implement kvm_arch_flush_remote_tlb() at all, forcing them to
implement the function just to implement what everyone except ARM does doesn't
seem like the right trade off.

As usual, x86 is the real oddball.  All other architectures either use the purely
generic KVM_REQ_TLB_FLUSH or they don't.  x86 is the only one that sometimes wants
to fallback.  I can't see a clean way around that though, especially since MIPS
apparently needs a notification _and_ a generic flush.

Can the ARM hook be inlined?  That would eliminate the extra call and should allow
the compiler to optimize out the conditional and the request.
