Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D4581FD8
	for <kvmarm@lists.linux.dev>; Tue, 18 Jul 2023 11:17:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1689679031;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=FMvWdQ8jDtgrg4TmzvreNToMG0I25+6piVG21WnWmLI=;
	b=GNDC88KVUTJweVOzPVxzaYyZIBlIbmRI9ilI3yaJqqQPdCT7gZryBnUaBr0inMzK0sF8zP
	Iot4QMjQbKr8BoMEr04prStR84fI8gdEsTZXPgSRaFsbuywFKa20m7XHn9Zi0/qY3zyaeq
	FD93AgAegcs1onmml9dMhf7Pqpu2VUI=
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com
 [209.85.216.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-671-h3cDq8hWO2OZEIZI8xRThA-1; Tue, 18 Jul 2023 07:17:10 -0400
X-MC-Unique: h3cDq8hWO2OZEIZI8xRThA-1
Received: by mail-pj1-f72.google.com with SMTP id 98e67ed59e1d1-262d2cae3efso643724a91.1
        for <kvmarm@lists.linux.dev>; Tue, 18 Jul 2023 04:17:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689679029; x=1690283829;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=FMvWdQ8jDtgrg4TmzvreNToMG0I25+6piVG21WnWmLI=;
        b=cVPwrby0WsDHz/+mmNgu1Jyo5Ji55TrpFrfOgaI8s5fCLm0z06d7BQvNM06MYK1GI9
         GontR8hjbHeCuRVCkc058OTRuFJUKWYyjfTeXfW9BJuFnVhnKChvjSPhmMfbYZwAO32H
         SvnlsebXXCaPJXnoNsMVUtrzJZ2HS8T86/0omiojOe6pExxkTq+pslKTsCNx3wgI6nH4
         WdFkjPsTGNF5JBuFSCItm1HGp9wscSfyhwcRXnJWGsuldtb5t548+tuw5S3HNx8DdRAB
         Ydgn9Ntv1n+xunGcxMDr/Svwu2vE1arWVvpVuW6WI1x4ZwC/1FcZEZHiAXoEn23tOgYq
         PL8w==
X-Gm-Message-State: ABy/qLbHrs20ROQqevF7zRv90PRN4a54wbwseNQVkcjUh3N1UW32hR/d
	oovuxsXdBGqNycufA+MaTW6uJxc/Pgrrs8s5Tc7K/jXgxYPhuF45vicNH+OuU4PmoSX5fkA3yI1
	hqwGLO79UCfS8hjc1
X-Received: by 2002:a17:903:230b:b0:1b8:b0c4:2e3d with SMTP id d11-20020a170903230b00b001b8b0c42e3dmr11266972plh.4.1689679028960;
        Tue, 18 Jul 2023 04:17:08 -0700 (PDT)
X-Google-Smtp-Source: APBJJlH5kvIm7BO6HgOwtAhzPPJqnxdHrdyX/BVtSHl74wvgT6sMhv7vpU6zAkVVa8mgoPsZbPZuzQ==
X-Received: by 2002:a17:903:230b:b0:1b8:b0c4:2e3d with SMTP id d11-20020a170903230b00b001b8b0c42e3dmr11266944plh.4.1689679028672;
        Tue, 18 Jul 2023 04:17:08 -0700 (PDT)
Received: from [10.72.112.40] ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id l18-20020a170902eb1200b001a80ad9c599sm1576337plb.294.2023.07.18.04.17.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 18 Jul 2023 04:17:08 -0700 (PDT)
Message-ID: <4f02d91a-acd8-afa5-03b0-fd8ec29328dd@redhat.com>
Date: Tue, 18 Jul 2023 19:17:02 +0800
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH v6 09/11] KVM: arm64: Flush only the memslot after
 write-protect
To: Raghavendra Rao Ananta <rananta@google.com>,
 Oliver Upton <oliver.upton@linux.dev>, Marc Zyngier <maz@kernel.org>,
 James Morse <james.morse@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
 Sean Christopherson <seanjc@google.com>, Huacai Chen
 <chenhuacai@kernel.org>, Zenghui Yu <yuzenghui@huawei.com>,
 Anup Patel <anup@brainfault.org>, Atish Patra <atishp@atishpatra.org>,
 Jing Zhang <jingzhangos@google.com>, Colton Lewis <coltonlewis@google.com>,
 David Matlack <dmatlack@google.com>, linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.linux.dev, linux-mips@vger.kernel.org,
 kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
 linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
 Gavin Shan <gshan@redhat.com>
References: <20230715005405.3689586-1-rananta@google.com>
 <20230715005405.3689586-10-rananta@google.com>
From: Shaoqin Huang <shahuang@redhat.com>
In-Reply-To: <20230715005405.3689586-10-rananta@google.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 7/15/23 08:54, Raghavendra Rao Ananta wrote:
> After write-protecting the region, currently KVM invalidates
> the entire TLB entries using kvm_flush_remote_tlbs(). Instead,
> scope the invalidation only to the targeted memslot. If
> supported, the architecture would use the range-based TLBI
> instructions to flush the memslot or else fallback to flushing
> all of the TLBs.
> 
> Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
> Reviewed-by: Gavin Shan <gshan@redhat.com>
Reviewed-by: Shaoqin Huang <shahuang@redhat.com>
> ---
>   arch/arm64/kvm/mmu.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index 387f2215fde7..985f605e2abc 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@ -1082,7 +1082,7 @@ static void kvm_mmu_wp_memory_region(struct kvm *kvm, int slot)
>   	write_lock(&kvm->mmu_lock);
>   	stage2_wp_range(&kvm->arch.mmu, start, end);
>   	write_unlock(&kvm->mmu_lock);
> -	kvm_flush_remote_tlbs(kvm);
> +	kvm_flush_remote_tlbs_memslot(kvm, memslot);
>   }
>   
>   /**

-- 
Shaoqin

