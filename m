Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D4BAA47
	for <kvmarm@lists.linux.dev>; Fri, 11 Aug 2023 03:16:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1691723777;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=pxVuMV7NfVels7NbA1UkuP4mEMIntZymXRlB6RKGCA0=;
	b=Mv0pCHRQ9ud5yAexPks61bo17QC/gp6AhzIPOh2ykrq3l/tE7Q5H9h8VOAWezsYEDScwQv
	fBNZn+dReoip8aJ09cdIoNmpBCAnITEp1LuZrC1nYb8u4Lo7B0mvpRHOD4kzEmxJq0pmAG
	+Ax6P+UZq3LnjFs/KLQXzRKOpajH6pg=
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com
 [209.85.214.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-135-n_8a13BWPdGvoDWXNNilwQ-1; Thu, 10 Aug 2023 23:16:15 -0400
X-MC-Unique: n_8a13BWPdGvoDWXNNilwQ-1
Received: by mail-pl1-f198.google.com with SMTP id d9443c01a7336-1bdb620e631so436845ad.1
        for <kvmarm@lists.linux.dev>; Thu, 10 Aug 2023 20:16:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691723774; x=1692328574;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=pxVuMV7NfVels7NbA1UkuP4mEMIntZymXRlB6RKGCA0=;
        b=Esvr12oOwH/p1MlLF/I9Ib0nlBO8FXLJbSX3DgU+Gi6KGpm1+FCBb0wC0EiO18tYfO
         EwJ+uilICPEkQW2rHbJQlP6JVVg5Pkeeh3qe8D54Vd0VBl89zopgOqmoa1MsJxJc2gw8
         lHns15o/1Zl6pTURTiQ5I1boUmjGA1UEOcNv0OYMuvK3QkhT2EQb21Qcwlck7j+xm+ig
         NM0eoRWsI0W+xwR2+msQwXOLgKtZPjmyJ/nyR0xm6RIlhSD/qvpY+DKsGcvQUi4HaJ20
         Y7bE9cAsRkF5lGZsYdvzm41T3FD89T7yg/Fg9wrFL4bLX1qx1kHDw6LNTC6nDzVx8RrU
         DRkA==
X-Gm-Message-State: AOJu0YyUmwFQN0oWT1uOjee8cR368ysN/pcPGgovES+/nuoadkWmfkix
	OTglcXbkecDqeuvaqqQ0hGz75BZx+3gJDY+7xnAZyLiSBI4grCGXQnG7bPs3GT/FDS4u7qNydK6
	W3Zjj8cykfVIMGfX3
X-Received: by 2002:a17:902:d4ce:b0:1b1:9272:55e2 with SMTP id o14-20020a170902d4ce00b001b1927255e2mr857215plg.3.1691723774432;
        Thu, 10 Aug 2023 20:16:14 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHh/vwl3upbeZ36WYfzpIGbtQYzH/ApexffsIYFu0eUp+KR2cyRBkYjBzFNVTGEHb4hVszsqw==
X-Received: by 2002:a17:902:d4ce:b0:1b1:9272:55e2 with SMTP id o14-20020a170902d4ce00b001b1927255e2mr857201plg.3.1691723774115;
        Thu, 10 Aug 2023 20:16:14 -0700 (PDT)
Received: from [10.72.112.92] ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id s88-20020a17090a69e100b00265c742a262sm2400175pjj.4.2023.08.10.20.16.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 10 Aug 2023 20:16:13 -0700 (PDT)
Message-ID: <60a2cc0e-df09-4305-6bfc-25b3d864040a@redhat.com>
Date: Fri, 11 Aug 2023 11:16:06 +0800
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH v8 08/14] arm64: tlb: Implement __flush_s2_tlb_range_op()
To: Raghavendra Rao Ananta <rananta@google.com>,
 Oliver Upton <oliver.upton@linux.dev>, Marc Zyngier <maz@kernel.org>,
 James Morse <james.morse@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
 Sean Christopherson <seanjc@google.com>, Huacai Chen
 <chenhuacai@kernel.org>, Zenghui Yu <yuzenghui@huawei.com>,
 Anup Patel <anup@brainfault.org>, Atish Patra <atishp@atishpatra.org>,
 Jing Zhang <jingzhangos@google.com>, Reiji Watanabe <reijiw@google.com>,
 Colton Lewis <coltonlewis@google.com>, David Matlack <dmatlack@google.com>,
 Fuad Tabba <tabba@google.com>, linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.linux.dev, linux-mips@vger.kernel.org,
 kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
 linux-kernel@vger.kernel.org, kvm@vger.kernel.org
References: <20230808231330.3855936-1-rananta@google.com>
 <20230808231330.3855936-9-rananta@google.com>
From: Shaoqin Huang <shahuang@redhat.com>
In-Reply-To: <20230808231330.3855936-9-rananta@google.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 8/9/23 07:13, Raghavendra Rao Ananta wrote:
> Define __flush_s2_tlb_range_op(), as a wrapper over
> __flush_tlb_range_op(), for stage-2 specific range-based TLBI
> operations that doesn't necessarily have to deal with 'asid'
> and 'tlbi_user' arguments.
> 
> Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
Reviewed-by: Shaoqin Huang <shahuang@redhat.com>
> ---
>   arch/arm64/include/asm/tlbflush.h | 3 +++
>   1 file changed, 3 insertions(+)
> 
> diff --git a/arch/arm64/include/asm/tlbflush.h b/arch/arm64/include/asm/tlbflush.h
> index b9475a852d5be..93f4b397f9a12 100644
> --- a/arch/arm64/include/asm/tlbflush.h
> +++ b/arch/arm64/include/asm/tlbflush.h
> @@ -340,6 +340,9 @@ do {									\
>   	}								\
>   } while (0)
>   
> +#define __flush_s2_tlb_range_op(op, start, pages, stride, tlb_level) \
> +	__flush_tlb_range_op(op, start, pages, stride, 0, tlb_level, false)
> +
>   static inline void __flush_tlb_range(struct vm_area_struct *vma,
>   				     unsigned long start, unsigned long end,
>   				     unsigned long stride, bool last_level,

-- 
Shaoqin

