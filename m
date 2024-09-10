Received: from mail-pg1-f180.google.com (mail-pg1-f180.google.com [209.85.215.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 937151A00F4
	for <kvmarm@lists.linux.dev>; Tue, 10 Sep 2024 16:32:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725985960; cv=none; b=qKw+2lVOIKt4gkmStlnLf7EnV7w510ccWncYWN5gafGyBq/vuCz1eD6CR6MD4vYtDiqx2MJFSMrHWNZM7eeqdtjSlH9OxRRDTdWUIo6NqgHAkzveV40xhgRGNNGcx0tooMGK5UZe8dasMF14seSB2egF/QoR4hCz2TtEV0h8WKc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725985960; c=relaxed/simple;
	bh=4iPN/fsCe14wfGYSYCjynyR282sYt9ED2Ow9xIF9vkM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fTeyRpax5ME9soRdGcGpVbQ5jTEV3J5zf1SvM/nWmH1ExmjFYfSv5frK95ApkiIkUeIqgzv6N5TAf4kL+DFZyvCZxyvEAC3j4XTbgENiX6thfJ9hD2ajDksW1u5p+PXnTkuMJKBsjqfGhgo2dC0Yv9RfnvlPIiQlRQIO4EJhWxA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=csie.ntu.edu.tw; spf=pass smtp.mailfrom=csie.ntu.edu.tw; dkim=pass (2048-bit key) header.d=csie.ntu.edu.tw header.i=@csie.ntu.edu.tw header.b=MD5kM6E6; arc=none smtp.client-ip=209.85.215.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=csie.ntu.edu.tw
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=csie.ntu.edu.tw
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=csie.ntu.edu.tw header.i=@csie.ntu.edu.tw header.b="MD5kM6E6"
Received: by mail-pg1-f180.google.com with SMTP id 41be03b00d2f7-7c691c8f8dcso3824901a12.1
        for <kvmarm@lists.linux.dev>; Tue, 10 Sep 2024 09:32:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=csie.ntu.edu.tw; s=google; t=1725985956; x=1726590756; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=ELTwotHVw2kePUAUYWtO4H0shRoEHF3K5HxUF2BgZ5g=;
        b=MD5kM6E6PTkHdIsdnU4f0XrU51/6RHbyALxHNIT5Qv7BiINB87z9Nd+bRzNIn4eJK8
         GZIT+6W6csVL/P4bJqkoESuZvTxhYzpJPI88kJ/4PpE92fHXtoXLMCq7R/s4sGSzQhlF
         dbdMBEutqQ3X5EPEwWbiFWwZMo0HJShTFciDYLmJAWDqnwGviBH1TEGOqUFSE/GSLozL
         hiwwIJ+u6JPw/nTXL4Vc/q8C/ze9tmSqurmx8bJHg2MUuBm/T8H/1/JVTw7mBVXJlh8d
         tO6To+ycFq1dLO7/c9DVhxdTUbFweoJOfFJeApN/X6Xze/5cCR7u++QpyRm4TNOaj1TC
         MKjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725985956; x=1726590756;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ELTwotHVw2kePUAUYWtO4H0shRoEHF3K5HxUF2BgZ5g=;
        b=a87LY2rtti1dYOFRHVMSXrfXrkFLFppO/SF0eJ8E+dFHLNoGQCrrn5S9cVKRbe/grl
         igZsyDcWL3eqhkrM9mCOB3e+9flMQn8DgI3Effek8fmomNLc6yhbmFuip4k50ulG0t8t
         Lw5GhQy7GWUMxvYe7s69YzpXNQzVGLetck5iJzbmQhKyu2RKBxIzqnzllHTLmvn/PS0I
         ziZ/n7XluzMuR3h+wZsn1FpKZXKblQmpje01CRdMJwwkzWEuRoHBHiE3KCkFr0zaWUAb
         PyW60MBOZOeGY4sUnKj9KULMhwif1c00BJGBIOBxIMR2J6swEf1socZ3lrSpj0xuzD5p
         xkmg==
X-Forwarded-Encrypted: i=1; AJvYcCVAltLeFfnhKZ71XY5IB9Qr9HTWhJTkRh8uVE+wD+SbPlnd5wU4qgNLj4nVLJ7N4KHmRwtCh38=@lists.linux.dev
X-Gm-Message-State: AOJu0YywB1zG29LDIx77cEcY0TLU9cuCoXdnYRI51SMCvVLW1yKnqKTZ
	aWUlvpaqPat5aMLSxRPcYjz/kngqL6JieSLZykak6tyhMqRqq6it5G2zCi0JoSimXONbg5MTUl/
	l24TGYW0zhIa8MMMU1ExEn/kjyOXR+Ku7NM2NRL+v2ZK4wWc=
X-Google-Smtp-Source: AGHT+IGsiPCMyX4DWKfV2C1n/j0UcYNxDwTcJHn00avqUPc5NDXLo/1FuFWLrpMOciYip064UpmfsA==
X-Received: by 2002:a17:90a:ee8f:b0:2d3:c892:9607 with SMTP id 98e67ed59e1d1-2dad4ef4a6amr16294517a91.12.1725985955738;
        Tue, 10 Sep 2024 09:32:35 -0700 (PDT)
Received: from zenbook (2001-b011-3808-5e10-d66e-1c97-ed92-266b.dynamic-ip6.hinet.net. [2001:b011:3808:5e10:d66e:1c97:ed92:266b])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2db04966b6asm6636022a91.39.2024.09.10.09.32.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Sep 2024 09:32:35 -0700 (PDT)
Date: Wed, 11 Sep 2024 00:32:29 +0800
From: Wei-Lin Chang <r09922117@csie.ntu.edu.tw>
To: Snehal Koukuntla <snehalreddy@google.com>, 
	Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>
Cc: James Morse <james.morse@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
	Sudeep Holla <sudeep.holla@arm.com>, Sebastian Ene <sebastianene@google.com>, 
	Vincent Donnefort <vdonnefort@google.com>, Jean-Philippe Brucker <jean-philippe@linaro.org>, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org, 
	stable@vger.kernel.org, r09922117@csie.ntu.edu.tw
Subject: Re: [PATCH v3] KVM: arm64: Add memory length checks and remove
 inline in do_ffa_mem_xfer
Message-ID: <rm2pihr27elmdf4zcgrv5khs7qluhn77tkivkr6xkvqcybtl4m@7hesctcacm4h>
References: <20240909180154.3267939-1-snehalreddy@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240909180154.3267939-1-snehalreddy@google.com>
X-Gm-Spam: 0
X-Gm-Phishy: 0

Hi everyone,

On Mon, Sep 09, 2024 at 06:01:54PM GMT, Snehal Koukuntla wrote:
> When we share memory through FF-A and the description of the buffers
> exceeds the size of the mapped buffer, the fragmentation API is used.
> The fragmentation API allows specifying chunks of descriptors in subsequent
> FF-A fragment calls and no upper limit has been established for this.
> The entire memory region transferred is identified by a handle which can be
> used to reclaim the transferred memory.
> To be able to reclaim the memory, the description of the buffers has to fit
> in the ffa_desc_buf.
> Add a bounds check on the FF-A sharing path to prevent the memory reclaim
> from failing.
> 
> Also do_ffa_mem_xfer() does not need __always_inline
> 
> Fixes: 634d90cf0ac65 ("KVM: arm64: Handle FFA_MEM_LEND calls from the host")
> Cc: stable@vger.kernel.org
> Reviewed-by: Sebastian Ene <sebastianene@google.com>
> Signed-off-by: Snehal Koukuntla <snehalreddy@google.com>
> ---
>  arch/arm64/kvm/hyp/nvhe/ffa.c | 7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/arm64/kvm/hyp/nvhe/ffa.c b/arch/arm64/kvm/hyp/nvhe/ffa.c
> index e715c157c2c4..637425f63fd1 100644
> --- a/arch/arm64/kvm/hyp/nvhe/ffa.c
> +++ b/arch/arm64/kvm/hyp/nvhe/ffa.c
> @@ -426,7 +426,7 @@ static void do_ffa_mem_frag_tx(struct arm_smccc_res *res,
>  	return;
>  }
>  
> -static __always_inline void do_ffa_mem_xfer(const u64 func_id,
> +static void do_ffa_mem_xfer(const u64 func_id,

I am seeing a compilation error because of this.

----- LOG START -----
$ clang --version 
clang version 18.1.8
Target: x86_64-pc-linux-gnu
Thread model: posix
InstalledDir: /usr/bin
$ make LLVM=1 ARCH=arm64 defconfig
$ make LLVM=1 ARCH=arm64 Image
...
arch/arm64/kvm/hyp/nvhe/ffa.c:443:2: error: call to '__compiletime_assert_776' declared with 'error' attribute: BUILD_BUG_ON failed: func_id != FFA_FN64_MEM_SHARE && func_id != FFA_FN64_MEM_LEND
  443 |         BUILD_BUG_ON(func_id != FFA_FN64_MEM_SHARE &&
      |         ^
./include/linux/build_bug.h:50:2: note: expanded from macro 'BUILD_BUG_ON'
   50 |         BUILD_BUG_ON_MSG(condition, "BUILD_BUG_ON failed: " #condition)
      |         ^
./include/linux/build_bug.h:39:37: note: expanded from macro 'BUILD_BUG_ON_MSG'
   39 | #define BUILD_BUG_ON_MSG(cond, msg) compiletime_assert(!(cond), msg)
      |                                     ^
././include/linux/compiler_types.h:510:2: note: expanded from macro 'compiletime_assert'
  510 |         _compiletime_assert(condition, msg, __compiletime_assert_, __COUNTER__)
      |         ^
././include/linux/compiler_types.h:498:2: note: expanded from macro '_compiletime_assert'
  498 |         __compiletime_assert(condition, msg, prefix, suffix)
      |         ^
././include/linux/compiler_types.h:491:4: note: expanded from macro '__compiletime_assert'
  491 |                         prefix ## suffix();                             \
      |                         ^
<scratch space>:66:1: note: expanded from here
   66 | __compiletime_assert_776
      | ^
1 error generated.
make[6]: *** [arch/arm64/kvm/hyp/nvhe/Makefile:46: arch/arm64/kvm/hyp/nvhe/ffa.nvhe.o] Error 1
make[5]: *** [scripts/Makefile.build:485: arch/arm64/kvm/hyp/nvhe] Error 2
make[4]: *** [scripts/Makefile.build:485: arch/arm64/kvm/hyp] Error 2
make[3]: *** [scripts/Makefile.build:485: arch/arm64/kvm] Error 2
make[3]: *** Waiting for unfinished jobs....
----- LOG END -----

Is this expected? Because when I add back the __always_inline, or change the
BUILD_BUG_ON to BUG_ON, it compiles successfully.

Thanks,
Wei-Lin Chang

>  					    struct arm_smccc_res *res,
>  					    struct kvm_cpu_context *ctxt)
>  {
> @@ -461,6 +461,11 @@ static __always_inline void do_ffa_mem_xfer(const u64 func_id,
>  		goto out_unlock;
>  	}
>  
> +	if (len > ffa_desc_buf.len) {
> +		ret = FFA_RET_NO_MEMORY;
> +		goto out_unlock;
> +	}
> +
>  	buf = hyp_buffers.tx;
>  	memcpy(buf, host_buffers.tx, fraglen);
>  
> -- 
> 2.46.0.598.g6f2099f65c-goog
> 
