Received: from mail-oo1-f74.google.com (mail-oo1-f74.google.com [209.85.161.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0AC4274B29
	for <kvmarm@lists.linux.dev>; Tue, 15 Jul 2025 21:16:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752614215; cv=none; b=nV7J+eOHvPVAIHvmZbLR9Lwv56q/lRjQjOGqbRD76gddpQQpdc/0hsPcm5Dn70Ojzi9EM+0q/MagLUjrO3VDFPywAiI5HH4hhrFWamr+RMmE3yxxgytxtVqam8XKFwO1M9y1hFOnI2QgPGNMBR2Wn3N0KwMLbEasH58V/sLyUKY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752614215; c=relaxed/simple;
	bh=tOQO6BDvaHzehkXLuqrv7zmehstQBhotZEf5osv7fJ8=;
	h=Date:In-Reply-To:Mime-Version:Message-ID:Subject:From:To:Cc:
	 Content-Type; b=RaY/RWnRLwyzepDQBihyZIXgVnMnWt03lsdzVpUJqyux2qVJDClSgn9MljTYCOxqoWFFKlLtQw9EDwtCa3j7ZLvXUV1CDzPYDPBW7AR4OoUhPxOMgQgsxW2Q4WYikfx49XqN9uFaklP/sxXjSWKAeVCXw1mOXrNfFG+LdCavENw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=U6wN28jf; arc=none smtp.client-ip=209.85.161.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="U6wN28jf"
Received: by mail-oo1-f74.google.com with SMTP id 006d021491bc7-6159bfd9bc1so422743eaf.3
        for <kvmarm@lists.linux.dev>; Tue, 15 Jul 2025 14:16:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1752614212; x=1753219012; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=W3m+1hLOZ8hAFq4B95DKPtg5XMn2S7HOXjCLINFrtq0=;
        b=U6wN28jf5SzJu9Kyr4pcOV+Oj08sJFEnHKy+EuG3Z6ZAVN0d4CGE56Y7j9161+jINo
         tHT42LV1anFRiV0vPqBE8cpDQoWKACxRkSzt0H/8z3vQ68naUUY5mfdqVkuP4N+HuK7d
         tex8WZZZ+4X1hGZjyIBcNAQ4VUJMkiSHpUKhhQP5QRVEe8KRAVjyRGSUOlSyQHTcx/oG
         VkveamgxY5i4Yfbz5FSXmZLVDD6nPeYIFJxgdJW5AGl920Ypda6LdX/cYsyLAyyOEYNo
         SMAwzlLL7vO10coyZ0pgOwhYUA5wB/0weqwEC9BWKcMs5k8uUIU61RLWMPotFNyuMt40
         NXKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752614212; x=1753219012;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=W3m+1hLOZ8hAFq4B95DKPtg5XMn2S7HOXjCLINFrtq0=;
        b=G1MDAQJaOv/U5SaCDOoTy5zEB+Apv0sKUUupbPT+4FrsbOci5YNn6VLvfv+Sx638l6
         xQjn0YDZob6lIpqC0Y+cXaOxJeSpwdw+pzYKLviYGrNpXoFvGUUuwqx/sTG+Hidm/J/+
         8EZxrEte4mpA+CcLDbcia8iJkvmLcb2tlXy9n1BYP/IIEF5ghp9mttKxne8j+9ajqUzf
         2dE7ZWeOqfHbWJux8vUwLQZntVIlHTuZ/nkbdZ918BVE2vcTVkO4TyLiBvTCzAvnAHTA
         O6LYOWqHBdR4JTOW9rJO85yireetyj47Z78+L6YF19h+Z3tOIRwWTceAhJG7lfkIhdZr
         1DoA==
X-Forwarded-Encrypted: i=1; AJvYcCV0g9TV4QiZVJJ+nud0ufkEyyThrUkyqCQ0cK5h7fSh9huBOGyS5Kt5VpnDcX0DwwzgJ8Trt3c=@lists.linux.dev
X-Gm-Message-State: AOJu0YzhbaYmSrwV/uobpvr27XBXX/Vg+0J9M9CdIecf2SdbvfUhcyZ6
	7XwDpz30K/uxeaaj3iN9zhGusjiWq7UTQEtCn5g8u025s1uDxgD9Mpd7AMonKMF4NaaEDP2WONU
	YZC0Ny82jk6l9Sv0kMAomRfXh+g==
X-Google-Smtp-Source: AGHT+IET2M3P36gkp3EjMv7BaUc9VYIy2qskuUCF22ILqTd3hhERB/uyQyetYE1K8s52+LEBtd/RipiSFpzH6qhMLA==
X-Received: from oobic4.prod.google.com ([2002:a05:6820:6704:b0:613:872a:7b2b])
 (user=coltonlewis job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6820:418e:b0:615:7c7f:4aa6 with SMTP id 006d021491bc7-615a1f5b472mr11828eaf.3.1752614211817;
 Tue, 15 Jul 2025 14:16:51 -0700 (PDT)
Date: Tue, 15 Jul 2025 21:16:50 +0000
In-Reply-To: <202507160129.vrvWpdVu-lkp@intel.com> (message from kernel test
 robot on Wed, 16 Jul 2025 01:26:23 +0800)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Message-ID: <gsntv7nt9mt9.fsf@coltonlewis-kvm.c.googlers.com>
Subject: Re: [PATCH v4 22/23] KVM: arm64: Add ioctl to partition the PMU when supported
From: Colton Lewis <coltonlewis@google.com>
To: kernel test robot <lkp@intel.com>
Cc: kvm@vger.kernel.org, oe-kbuild-all@lists.linux.dev, pbonzini@redhat.com, 
	corbet@lwn.net, linux@armlinux.org.uk, catalin.marinas@arm.com, 
	will@kernel.org, maz@kernel.org, oliver.upton@linux.dev, mizhang@google.com, 
	joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, 
	mark.rutland@arm.com, skhan@linuxfoundation.org, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, linux-perf-users@vger.kernel.org, 
	linux-kselftest@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes

kernel test robot <lkp@intel.com> writes:

> Hi Colton,

> kernel test robot noticed the following build errors:

> [auto build test ERROR on 79150772457f4d45e38b842d786240c36bb1f97f]

> url:     
> https://github.com/intel-lab-lkp/linux/commits/Colton-Lewis/arm64-cpufeature-Add-cpucap-for-HPMN0/20250715-070741
> base:   79150772457f4d45e38b842d786240c36bb1f97f
> patch link:     
> https://lore.kernel.org/r/20250714225917.1396543-23-coltonlewis%40google.com
> patch subject: [PATCH v4 22/23] KVM: arm64: Add ioctl to partition the  
> PMU when supported
> config: arm64-randconfig-003-20250715  
> (https://download.01.org/0day-ci/archive/20250716/202507160129.vrvWpdVu-lkp@intel.com/config)
> compiler: aarch64-linux-gcc (GCC) 8.5.0
> reproduce (this is a W=1 build):  
> (https://download.01.org/0day-ci/archive/20250716/202507160129.vrvWpdVu-lkp@intel.com/reproduce)

> If you fix the issue in a separate patch/commit (i.e. not just a new  
> version of
> the same patch/commit), kindly add following tags
> | Reported-by: kernel test robot <lkp@intel.com>
> | Closes:  
> https://lore.kernel.org/oe-kbuild-all/202507160129.vrvWpdVu-lkp@intel.com/

> All errors (new ones prefixed by >>):

>     In file included from arch/arm64/include/asm/kvm_host.h:31,
>                      from include/linux/kvm_host.h:45,
>                      from arch/arm64/kernel/asm-offsets.c:15:
>     arch/arm64/include/asm/kvm_pmu.h: In function 'kvm_pmu_is_partitioned':
>>> arch/arm64/include/asm/kvm_pmu.h:301:43: error: parameter name omitted
>      static inline bool kvm_pmu_is_partitioned(void *)
>                                                ^~~~~~
>     arch/arm64/include/asm/kvm_pmu.h: In  
> function 'kvm_pmu_host_counter_mask':
>     arch/arm64/include/asm/kvm_pmu.h:306:45: error: parameter name omitted
>      static inline u64 kvm_pmu_host_counter_mask(void *)
>                                                  ^~~~~~
>     arch/arm64/include/asm/kvm_pmu.h: In  
> function 'kvm_pmu_guest_counter_mask':
>     arch/arm64/include/asm/kvm_pmu.h:311:46: error: parameter name omitted
>      static inline u64 kvm_pmu_guest_counter_mask(void *)
>                                                   ^~~~~~
>     make[3]: *** [scripts/Makefile.build:182:  
> arch/arm64/kernel/asm-offsets.s] Error 1 shuffle=21662191

Same spot/declarations that triggered a build error on v2 and fixed in
v3 but moved to void * in v4 rather than defining an empty arm_pmu
struct due to v3 feedback.

Notably I remembered to build this branch before sending this time but
these definitions do not trigger an error or warning on gcc-14 with this
.config and W=1. So I'm not sure how I could have reasonably caught this
myself before sending.

Anyway, I'll fix. It's nothing to give the parameters a name.

>     make[3]: Target 'prepare' not remade because of errors.
>     make[2]: *** [Makefile:1274: prepare0] Error 2 shuffle=21662191
>     make[2]: Target 'prepare' not remade because of errors.
>     make[1]: *** [Makefile:248: __sub-make] Error 2 shuffle=21662191
>     make[1]: Target 'prepare' not remade because of errors.
>     make: *** [Makefile:248: __sub-make] Error 2 shuffle=21662191
>     make: Target 'prepare' not remade because of errors.


> vim +301 arch/arm64/include/asm/kvm_pmu.h

>     300
>   > 301	static inline bool kvm_pmu_is_partitioned(void *)
>     302	{
>     303		return false;
>     304	}
>     305

> --
> 0-DAY CI Kernel Test Service
> https://github.com/intel/lkp-tests/wiki
