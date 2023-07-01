Received: from mail-ed1-f41.google.com (mail-ed1-f41.google.com [209.85.208.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 002EB4415
	for <kvmarm@lists.linux.dev>; Sat,  1 Jul 2023 14:53:50 +0000 (UTC)
Received: by mail-ed1-f41.google.com with SMTP id 4fb4d7f45d1cf-5149aafef44so3062046a12.0
        for <kvmarm@lists.linux.dev>; Sat, 01 Jul 2023 07:53:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1688223229; x=1690815229;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=4z5avgOZM94E55xJX5yHh1jEBdl/Nv8eTHj3o1PmFnI=;
        b=IqkaY/63sYcOG0vwtmF02wpU+mNr/gP2fHYz9of1UNY2Q45RQUGKnr0nycE74z3Vq+
         vRH+iq/bEWHzZQJFNk5D1eABcSm/7HMxFYJiaIg+wuXbW55cwpQiwwq7ZbxPO2QlnkIj
         9iVfVrEWAevgKZSOtWpo/0swSzpiq3/5R0+5tvpX1ycDHSi/sX9HFmLv96haLzn08jMc
         DY4baiQluiuE8NdVxL1tqe/WSUZ5z1uxB9P1GEc7MeQjDLyJWrhwO9i9VTqG5iE4w+Nj
         cKCOO9fcg9SfxcuWGrOsZkI7RcxYFElB3npOI1snh4RreMoNrKyv6N+PeDCQ9R1qg56C
         GLsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1688223229; x=1690815229;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4z5avgOZM94E55xJX5yHh1jEBdl/Nv8eTHj3o1PmFnI=;
        b=l8lrtUwUtqzN6ijC5Ybdl3vJmPoXP4Hhz8CnN3ewSgClr2o2NRPjJGrvTlzqzvPpdZ
         IpCSkQn1Avvqz0vxT+nK9sXtdDxZD4cGXdzlVnJomQEplAt5FaOULywZovkp0wU4NaNf
         9J/kgtBHFVq362VcMMZE+fxq3Nzkpb6Wf65jWifl32cpv1oMotsrSgy4kxuOSkL4RvSM
         RVS64y2KWZVbW/HZCPEPwqN74douTNcAyj1K+rF0lsGw+rwB9xhnKMmZYMAj/qm7nf5X
         KO1foPDUZxhL9nRjXaTHsvK6qpdotFvoikToOlMaPabe+34GV+joK0Y63Rgd8zR+UlJu
         M75A==
X-Gm-Message-State: AC+VfDxhaYQwyLi6MJlSKPLJQUrWAKJXox831FCdJHlnnQaMpnFxYALT
	Jog3cA1Mh+55DdhCh4s4w1BDEQ==
X-Google-Smtp-Source: APBJJlFbTncNQknWuK6Y34dd/Vq9wobBPzkzq5+JVS2JfwhQSw4EsBA/mzFykhnRWmdndPeE2HFOZQ==
X-Received: by 2002:a17:906:4093:b0:992:a85d:278b with SMTP id u19-20020a170906409300b00992a85d278bmr3179852ejj.59.1688223228877;
        Sat, 01 Jul 2023 07:53:48 -0700 (PDT)
Received: from localhost (cst2-173-16.cust.vodafone.cz. [31.30.173.16])
        by smtp.gmail.com with ESMTPSA id lf1-20020a170907174100b0098d2261d189sm1025110ejc.19.2023.07.01.07.53.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 01 Jul 2023 07:53:48 -0700 (PDT)
Date: Sat, 1 Jul 2023 16:53:47 +0200
From: Andrew Jones <ajones@ventanamicro.com>
To: Haibo Xu <haibo1.xu@intel.com>
Cc: xiaobo55x@gmail.com, maz@kernel.org, oliver.upton@linux.dev, 
	seanjc@google.com, Paolo Bonzini <pbonzini@redhat.com>, 
	Jonathan Corbet <corbet@lwn.net>, Anup Patel <anup@brainfault.org>, 
	Atish Patra <atishp@atishpatra.org>, Paul Walmsley <paul.walmsley@sifive.com>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, Shuah Khan <shuah@kernel.org>, 
	James Morse <james.morse@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Ricardo Koller <ricarkol@google.com>, 
	Vishal Annapurve <vannapurve@google.com>, Vipin Sharma <vipinsh@google.com>, 
	David Matlack <dmatlack@google.com>, Colton Lewis <coltonlewis@google.com>, kvm@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, linux-kselftest@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev
Subject: Re: [PATCH v5 00/13] RISCV: Add KVM_GET_REG_LIST API
Message-ID: <20230701-e1bff47a0ed38ec3ab6ca252@orel>
References: <cover.1688010022.git.haibo1.xu@intel.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1688010022.git.haibo1.xu@intel.com>

On Sat, Jul 01, 2023 at 09:42:48PM +0800, Haibo Xu wrote:
> KVM_GET_REG_LIST will dump all register IDs that are available to
> KVM_GET/SET_ONE_REG and It's very useful to identify some platform
> regression issue during VM migration.
> 
> Patch 1-7 re-structured the get-reg-list test in aarch64 to make some
> of the code as common test framework that can be shared by riscv.
> 
> Patch 8 move reject_set check logic to a function so as to check for
> different errno for different registers.
> Patch 9 move finalize_vcpu back to run_test so that riscv can implement
> its specific operation.
> Patch 10 change to do the get/set operation only on present-blessed list.
> Patch 11 add the skip_set facilities so that riscv can skip set operation
> on some registers.
> Patch 12 enabled the KVM_GET_REG_LIST API in riscv.
> patch 13 added the corresponding kselftest for checking possible
> register regressions.
> 
> The get-reg-list kvm selftest was ported from aarch64 and tested with
> Linux v6.4 on a Qemu riscv64 virt machine.

Hi Haibo,

This series needs a rebase on top of these recent patches

 commit ee053e03b08e ("KVM: selftests: get-reg-list: support ID register features")
 commit 5f0419a0083b ("KVM: selftests: get-reg-list: add Permission Indirection registers")

The conflicts will be in my patches, which do the splitting of the test.
I'll do the rebase and push it to a branch for you to pick up.

Thanks,
drew
