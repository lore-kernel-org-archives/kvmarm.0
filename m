Received: from mail-ej1-f47.google.com (mail-ej1-f47.google.com [209.85.218.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9460AD5F
	for <kvmarm@lists.linux.dev>; Mon,  4 Sep 2023 13:31:36 +0000 (UTC)
Received: by mail-ej1-f47.google.com with SMTP id a640c23a62f3a-99bcc0adab4so221843366b.2
        for <kvmarm@lists.linux.dev>; Mon, 04 Sep 2023 06:31:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1693834294; x=1694439094; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=hCYvspyPAR7BQTyfNQLsPOWKxV3J1BTko++dNnBZlmc=;
        b=MRkX1Ru8V35pbAVquoJHk/RlpoeU6nlQvme17sP0p6buOBH6oXDctvpwW543P8PW+R
         cmXgAd4ZjUEam+Izx1DQBz+u/5UmxC56u4KxwhwQUC9jmBy6IwPwwiIGW8qWI1HcffrX
         EaQs45G/ihh18RgtpExERjeqU/QlvL64h2vhOJ+6rdzx1yndo8iuyg0jiWO+Mw8HRYk0
         sKoVCQxZ4exWYW6bdKHYOrjbrX2qZYrCpavlSx/HuI5+sz8OgsGY3QbdwJHTRYRofu1U
         Vna82yi9rIeUWQXAfswkW+0yqCVZZ+EzhRhZfklSZpzt074Eh/CDNBq8bj298qR+dcNo
         UEpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693834294; x=1694439094;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hCYvspyPAR7BQTyfNQLsPOWKxV3J1BTko++dNnBZlmc=;
        b=hyjjwgaF8JO5ZkKyzf/svtFKnJRa3SjMzcmGJ6lHWWSE/X7cRiGjMG3Go1Kq4OBvuj
         m/28Agpjx+RgXJWgyheM7u+KdtxABIUZZEk0Gu+UEu1ivW4iE2uClxm8IEeIKpL/XvbK
         dyavCkzq/8++v/VZjyKP5NQ/6iLI1NfZTXdZmGiBbekoRyxL5xmhi8+O4GFylPdBy2+9
         mWNKpViIGdxx2J9yBK61rbwb8nLXh5q2YA5OAqIan4ES7VEcxeDW+8GzM1Blgxiu7nIF
         7ja5LH4a/CCv+TxazDX7JA2XxpmB4OFGFw/eHugYUC3ICTP8MZGKFRKDoBC7NeaVh3B/
         Ka+Q==
X-Gm-Message-State: AOJu0YwRsdm4W0iUpYbgObTjDsxDYse+iBqJQ1FWcTemiiyotllRVUeY
	9y/UZ8YINDaw/I3zmrcn82RS5g==
X-Google-Smtp-Source: AGHT+IGtFqpzjt6uSaukx7aodEb/54kI1XEGaEwgvvmfQYwT0ivCYh8vhE7uW3lVgPNl4aIYuhjmcA==
X-Received: by 2002:a17:907:7808:b0:9a5:d095:a8e1 with SMTP id la8-20020a170907780800b009a5d095a8e1mr6644948ejc.11.1693834294609;
        Mon, 04 Sep 2023 06:31:34 -0700 (PDT)
Received: from localhost (2001-1ae9-1c2-4c00-20f-c6b4-1e57-7965.ip6.tmcz.cz. [2001:1ae9:1c2:4c00:20f:c6b4:1e57:7965])
        by smtp.gmail.com with ESMTPSA id m21-20020a1709060d9500b0099bc2d1429csm6167078eji.72.2023.09.04.06.31.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Sep 2023 06:31:34 -0700 (PDT)
Date: Mon, 4 Sep 2023 15:31:33 +0200
From: Andrew Jones <ajones@ventanamicro.com>
To: Haibo Xu <haibo1.xu@intel.com>
Cc: xiaobo55x@gmail.com, Paul Walmsley <paul.walmsley@sifive.com>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Paolo Bonzini <pbonzini@redhat.com>, Shuah Khan <shuah@kernel.org>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, James Morse <james.morse@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Anup Patel <anup@brainfault.org>, Atish Patra <atishp@atishpatra.org>, Guo Ren <guoren@kernel.org>, 
	Conor Dooley <conor.dooley@microchip.com>, wchen <waylingii@gmail.com>, 
	Greentime Hu <greentime.hu@sifive.com>, Sean Christopherson <seanjc@google.com>, 
	Ricardo Koller <ricarkol@google.com>, Vishal Annapurve <vannapurve@google.com>, 
	Vitaly Kuznetsov <vkuznets@redhat.com>, Aaron Lewis <aaronlewis@google.com>, 
	David Matlack <dmatlack@google.com>, Mingwei Zhang <mizhang@google.com>, 
	Ackerley Tng <ackerleytng@google.com>, Jim Mattson <jmattson@google.com>, 
	Vipin Sharma <vipinsh@google.com>, Maxim Levitsky <mlevitsk@redhat.com>, 
	Peter Gonda <pgonda@google.com>, Like Xu <likexu@tencent.com>, 
	Philippe =?utf-8?Q?Mathieu-Daud=C3=A9?= <philmd@linaro.org>, Thomas Huth <thuth@redhat.com>, 
	David Woodhouse <dwmw@amazon.co.uk>, Michal Luczaj <mhal@rbox.co>, linux-kernel@vger.kernel.org, 
	linux-riscv@lists.infradead.org, kvm@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, kvm-riscv@lists.infradead.org
Subject: Re: [PATCH v2 4/8] KVM: riscv: selftests: Switch to use macro from
 csr.h
Message-ID: <20230904-d35320b23119ee97737e8a74@orel>
References: <cover.1693659382.git.haibo1.xu@intel.com>
 <ee4e518cbed9ff4210b74a22c5af21c410fab85d.1693659382.git.haibo1.xu@intel.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ee4e518cbed9ff4210b74a22c5af21c410fab85d.1693659382.git.haibo1.xu@intel.com>

On Sat, Sep 02, 2023 at 08:59:26PM +0800, Haibo Xu wrote:
> Signed-off-by: Haibo Xu <haibo1.xu@intel.com>
> ---
>  tools/testing/selftests/kvm/include/riscv/processor.h | 5 +----
>  1 file changed, 1 insertion(+), 4 deletions(-)
> 
> diff --git a/tools/testing/selftests/kvm/include/riscv/processor.h b/tools/testing/selftests/kvm/include/riscv/processor.h
> index 5b62a3d2aa9b..6810c887fadc 100644
> --- a/tools/testing/selftests/kvm/include/riscv/processor.h
> +++ b/tools/testing/selftests/kvm/include/riscv/processor.h
> @@ -8,6 +8,7 @@
>  #define SELFTEST_KVM_PROCESSOR_H
>  
>  #include "kvm_util.h"
> +#include <asm/csr.h>
>  #include <linux/stringify.h>
>  
>  static inline uint64_t __kvm_reg_id(uint64_t type, uint64_t idx,
> @@ -95,12 +96,8 @@ static inline uint64_t __kvm_reg_id(uint64_t type, uint64_t idx,
>  #define PGTBL_PAGE_SIZE				PGTBL_L0_BLOCK_SIZE
>  #define PGTBL_PAGE_SIZE_SHIFT			PGTBL_L0_BLOCK_SHIFT
>  
> -#define SATP_PPN				_AC(0x00000FFFFFFFFFFF, UL)
>  #define SATP_MODE_39				_AC(0x8000000000000000, UL)
>  #define SATP_MODE_48				_AC(0x9000000000000000, UL)

SATP_MODE_39/48 are also in csr.h

> -#define SATP_ASID_BITS				16
> -#define SATP_ASID_SHIFT				44
> -#define SATP_ASID_MASK				_AC(0xFFFF, UL)
>  
>  #define SBI_EXT_EXPERIMENTAL_START		0x08000000
>  #define SBI_EXT_EXPERIMENTAL_END		0x08FFFFFF
> -- 
> 2.34.1
>

Thanks,
drew
