Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DC84224CE
	for <kvmarm@lists.linux.dev>; Thu, 14 Sep 2023 08:52:17 +0000 (UTC)
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-403004a96a4so7412875e9.3
        for <kvmarm@lists.linux.dev>; Thu, 14 Sep 2023 01:52:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1694681535; x=1695286335; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=lMUcG5dET7EFobfbAHbzg2lwyOfsWQ8F2tpkEXeY8DY=;
        b=nLEPrkQjoccXdF7wUPwO57Xge8D8kGCX/8fua6mcGaQUDm/5fDSD4ZaAVa8M7PpHv5
         KxBD7CAOEB9TteLpDi2lUV7NQxoQoPWytYIqGVboUTOIS7gzcHCuoPNasI2/yQ9JlkAO
         r1aPXrvE/wf2ifzFIu7BTekOThSg7+mHr0DRZbp0yXJgEp83aBpXsNaomlxpXT2MpJEY
         IEFdd+aQfUdHKhLLKXfJ1Q2UH67xuU4JOlofXEZzlyu/JcCpYBgBUalZDR/evoQ6Zt4C
         zldqhl04vTnrb+0qBxJK5Yw73OXY6r8BgzRi5cB/uiacYS80QduVrMx60SyxrRxMcfAy
         TtnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694681535; x=1695286335;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lMUcG5dET7EFobfbAHbzg2lwyOfsWQ8F2tpkEXeY8DY=;
        b=moLXU2uwdDbJ9QzMQZ+L6k32J2Xi8Ik7OFLau0H3ILy1FQTw9EnvHa1PmY6fQ9+LgV
         KRhEN+4r+r2eMQkggQLm96k6Oz08cBhKlUILDVqhLv1DqWWSh5/R+h2x0pD4ccv/cOtM
         FEdQNGmx/0unZgyYQTiczEx3d2nZJVWa/M7HHjiKgWc5V681497KKGyhbm2IWlzoA6A2
         hPC2gpPDZvoyeUXMUO6galgKXXqEg42VngBJ+8HpujXB99ZVbzMbT9ycbMgwTdIOWe9J
         Rt0Sansv22nprAFXkcdKVgbFP6ts3GhkfZzpwT/OguV5715eUdLZEV4wudFXnUqBEjcP
         v9rQ==
X-Gm-Message-State: AOJu0YxjFOvFT1a9cj2LDG4A3KiQBy/WATzHcqnKZ6SzEyaRin0BoQvK
	ydzjwButCtB/7maG/4X23isBZg==
X-Google-Smtp-Source: AGHT+IF/71ROIOoJExJf8FEqPIRkV7f1W6lv97o8MVa7W5dAed2t55G5dPLBGqXoAtZVnyXGa4aJ8Q==
X-Received: by 2002:a5d:4f88:0:b0:319:83e4:bbbf with SMTP id d8-20020a5d4f88000000b0031983e4bbbfmr4097683wru.20.1694681535355;
        Thu, 14 Sep 2023 01:52:15 -0700 (PDT)
Received: from localhost (cst2-173-16.cust.vodafone.cz. [31.30.173.16])
        by smtp.gmail.com with ESMTPSA id r8-20020a5d4e48000000b0031ad2f9269dsm1137143wrt.40.2023.09.14.01.52.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Sep 2023 01:52:14 -0700 (PDT)
Date: Thu, 14 Sep 2023 10:52:08 +0200
From: Andrew Jones <ajones@ventanamicro.com>
To: Haibo Xu <haibo1.xu@intel.com>
Cc: xiaobo55x@gmail.com, Paul Walmsley <paul.walmsley@sifive.com>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Paolo Bonzini <pbonzini@redhat.com>, Shuah Khan <shuah@kernel.org>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, James Morse <james.morse@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Anup Patel <anup@brainfault.org>, Atish Patra <atishp@atishpatra.org>, 
	Sean Christopherson <seanjc@google.com>, Ricardo Koller <ricarkol@google.com>, 
	Vishal Annapurve <vannapurve@google.com>, Peter Xu <peterx@redhat.com>, Vipin Sharma <vipinsh@google.com>, 
	David Matlack <dmatlack@google.com>, Colton Lewis <coltonlewis@google.com>, 
	Aaron Lewis <aaronlewis@google.com>, Thomas Huth <thuth@redhat.com>, linux-kernel@vger.kernel.org, 
	linux-riscv@lists.infradead.org, kvm@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, kvm-riscv@lists.infradead.org
Subject: Re: [PATCH v3 5/9] KVM: riscv: selftests: Switch to use macro from
 csr.h
Message-ID: <20230914-18bfe93b679e290188e70307@orel>
References: <cover.1694421911.git.haibo1.xu@intel.com>
 <6cdda82518977c67004ee01a767bc67962352c13.1694421911.git.haibo1.xu@intel.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6cdda82518977c67004ee01a767bc67962352c13.1694421911.git.haibo1.xu@intel.com>

On Thu, Sep 14, 2023 at 09:36:59AM +0800, Haibo Xu wrote:
> Signed-off-by: Haibo Xu <haibo1.xu@intel.com>
> ---
>  tools/testing/selftests/kvm/include/riscv/processor.h | 8 +-------
>  1 file changed, 1 insertion(+), 7 deletions(-)
> 
> diff --git a/tools/testing/selftests/kvm/include/riscv/processor.h b/tools/testing/selftests/kvm/include/riscv/processor.h
> index 5b62a3d2aa9b..67766baed4f7 100644
> --- a/tools/testing/selftests/kvm/include/riscv/processor.h
> +++ b/tools/testing/selftests/kvm/include/riscv/processor.h
> @@ -8,6 +8,7 @@
>  #define SELFTEST_KVM_PROCESSOR_H
>  
>  #include "kvm_util.h"
> +#include <asm/csr.h>
>  #include <linux/stringify.h>

nit: Usually we try to keep the order of our includes separated into five
categories, listed below, where each category is sorted alphabetically. Of
course any dependencies the includes have on each other need to be
considered too.

<library-includes-without-a-subdir>
<library-includes-with-subdir>
<linux/...>
<asm/...>
"local-includes"

>  
>  static inline uint64_t __kvm_reg_id(uint64_t type, uint64_t idx,
> @@ -95,13 +96,6 @@ static inline uint64_t __kvm_reg_id(uint64_t type, uint64_t idx,
>  #define PGTBL_PAGE_SIZE				PGTBL_L0_BLOCK_SIZE
>  #define PGTBL_PAGE_SIZE_SHIFT			PGTBL_L0_BLOCK_SHIFT
>  
> -#define SATP_PPN				_AC(0x00000FFFFFFFFFFF, UL)
> -#define SATP_MODE_39				_AC(0x8000000000000000, UL)
> -#define SATP_MODE_48				_AC(0x9000000000000000, UL)
> -#define SATP_ASID_BITS				16
> -#define SATP_ASID_SHIFT				44
> -#define SATP_ASID_MASK				_AC(0xFFFF, UL)
> -
>  #define SBI_EXT_EXPERIMENTAL_START		0x08000000
>  #define SBI_EXT_EXPERIMENTAL_END		0x08FFFFFF
>  
> -- 
> 2.34.1
>

Assuming the CONFIG_64BIT patch will come before this, then

Reviewed-by: Andrew Jones <ajones@ventanamicro.com>

Thanks,
drew
