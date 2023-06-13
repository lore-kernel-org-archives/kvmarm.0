Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C02AB567E
	for <kvmarm@lists.linux.dev>; Tue, 13 Jun 2023 08:25:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1686644724;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=P1syNaBAKkffiLL0bv/EmGcINY+iq9kUOB1DQ8J5+wk=;
	b=TG478KWL4BwhakhIVcoM88wUPpWoMnYHp4D2y7K3bdMVZWqJc3zI7iXuZKZRlJJvw4SgCb
	UVoOc/ZmhPJXyfTzVYXX4XTu0dLjBhI23UtEXquNVVD1Efd2669AYC55dTUybBTU32uDnN
	teuBMueW30Fxu2Q93IOE2iX+2idN+rE=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-74-5WPgH2OtPJ6BkS0nx6dXhw-1; Tue, 13 Jun 2023 04:25:22 -0400
X-MC-Unique: 5WPgH2OtPJ6BkS0nx6dXhw-1
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-30fb7b82e15so469919f8f.0
        for <kvmarm@lists.linux.dev>; Tue, 13 Jun 2023 01:25:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686644721; x=1689236721;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=P1syNaBAKkffiLL0bv/EmGcINY+iq9kUOB1DQ8J5+wk=;
        b=eHnmAET/Ahd4EBqGE0A1baYY7DGmlZz2Hc0LDffLQbpp8eGCYFttKS7ozHkGKDT0SC
         4KpfRhhSG12+g3zKaCfcdlV4e7Z2MJAnNyinhRQ8VZ9h/8KGlp44PNdYPF0SaAQEJDPc
         XG7jSZ/VBr4QHM2WBGCpSNZVfbCzfSPogStSWQKeRd/oVChSWs6uknaOyPT0QZNgyIdW
         xlv1d5jgurtKSququMWSK3QEoqSQuonEUG15G45BfGKpXD+/WGKZwghx5sxtIt+UoeJN
         gVck1kq4iCSzNpnyfh+/rVsp37qwaFSRLwgwdLgVIg1KaNuCW/ehcjbXD0zaOGjAe4VA
         +dgA==
X-Gm-Message-State: AC+VfDwmEw3cIKr6kfMk2llbKbyuiJDU9LSObptpRLCPafoHRaPmcKR+
	z7T/wABnu5W09DImjGXz8WPma46KGosxEK1xUHScDj26GHGlRqaUxZSqH+SRhw0cG5vtrCqAJ6X
	5gV4qYE9OpHZjW1sa
X-Received: by 2002:a5d:630b:0:b0:30f:c0a8:973c with SMTP id i11-20020a5d630b000000b0030fc0a8973cmr4182802wru.7.1686644721766;
        Tue, 13 Jun 2023 01:25:21 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ54+a0ZNqCyRceTdBNOPN8n0EMFWs7KGngnKpklEwP2qo3zBges6I9cDMRiOnw/znCcScLd0Q==
X-Received: by 2002:a5d:630b:0:b0:30f:c0a8:973c with SMTP id i11-20020a5d630b000000b0030fc0a8973cmr4182787wru.7.1686644721492;
        Tue, 13 Jun 2023 01:25:21 -0700 (PDT)
Received: from [10.66.61.39] ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id h14-20020a5d6e0e000000b003078354f774sm14594095wrz.36.2023.06.13.01.25.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 13 Jun 2023 01:25:21 -0700 (PDT)
Message-ID: <02f40638-0230-ab06-6ccd-6bdbab814000@redhat.com>
Date: Tue, 13 Jun 2023 16:25:13 +0800
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH v3 02/17] arm64: Prevent the use of
 is_kernel_in_hyp_mode() in hypervisor code
To: Marc Zyngier <maz@kernel.org>, kvmarm@lists.linux.dev,
 kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: James Morse <james.morse@arm.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>,
 Oliver Upton <oliver.upton@linux.dev>, Zenghui Yu <yuzenghui@huawei.com>,
 Quentin Perret <qperret@google.com>, Will Deacon <will@kernel.org>,
 Fuad Tabba <tabba@google.com>
References: <20230609162200.2024064-1-maz@kernel.org>
 <20230609162200.2024064-3-maz@kernel.org>
From: Shaoqin Huang <shahuang@redhat.com>
In-Reply-To: <20230609162200.2024064-3-maz@kernel.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 6/10/23 00:21, Marc Zyngier wrote:
> Using is_kernel_in_hyp_mode() in hypervisor code is a pretty bad
> mistake. This helper only checks for CurrentEL being EL2, which
> is always true.
> 
> Make the compilation fail if using the helper in hypervisor context
> Whilst we're at it, flag the helper as __always_inline, which it
> really should be.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>
Reviewed-by: Shaoqin Huang <shahuang@redhat.com>
> ---
>   arch/arm64/include/asm/virt.h | 4 +++-
>   1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/arm64/include/asm/virt.h b/arch/arm64/include/asm/virt.h
> index 4eb601e7de50..21e94068804d 100644
> --- a/arch/arm64/include/asm/virt.h
> +++ b/arch/arm64/include/asm/virt.h
> @@ -110,8 +110,10 @@ static inline bool is_hyp_mode_mismatched(void)
>   	return __boot_cpu_mode[0] != __boot_cpu_mode[1];
>   }
>   
> -static inline bool is_kernel_in_hyp_mode(void)
> +static __always_inline bool is_kernel_in_hyp_mode(void)
>   {
> +	BUILD_BUG_ON(__is_defined(__KVM_NVHE_HYPERVISOR__) ||
> +		     __is_defined(__KVM_VHE_HYPERVISOR__));
>   	return read_sysreg(CurrentEL) == CurrentEL_EL2;
>   }
>   

-- 
Shaoqin

