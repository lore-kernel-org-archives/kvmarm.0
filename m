Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBDE41362
	for <kvmarm@lists.linux.dev>; Mon,  9 Jun 2025 00:29:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749428996; cv=none; b=GGWNw+Fma5TDJ2I/WzqDanVKxwCQSvv174FdAykCxM9NWkt+Wc9cEyeXSDmkHvRVEI7+4zKVsjT9ZCRX23Z2SpWOB5burn3PgyLUB2dThzqVSgaWsizayj+BGE8u6jbOlgoTZueiJbfCLdtoU+BqrqnLjXd3ej/ZEanaVtFuqUo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749428996; c=relaxed/simple;
	bh=DndXz279didVTDDBPj10bwY/XQ3srYBXtm7PwGKhlsk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=dV8PS+RijP8oQYDvxgwF3by9176sVOBLDX/pUdC40N+RVGgy/D8fNwpDrvwfr21Df/CZr3GuzoFOA2YCMmcWxPdmPZs7/zRlW3ucbAhniYMVcuxuLgYc8gH/DLtcJPxheD20wYULkuKoATVWL6ICQEBjy7XoMP2UnFboHfdQdIg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ElSWk85n; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ElSWk85n"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1749428993;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=zWLcc9JilgS7Cncp/Oc4IwhgNWLN/WG8IqO7PXvDI+0=;
	b=ElSWk85nk/FJZuR+KLJOs2QAtNLhL0/4dBWM3l8ZDoeDrBihzZQp59jacLGyT7JcoV5eWv
	VXVsqJyzQylNx2iBbdtuCKHyPgrm88ge1R5kVJkamIAcGf+TXbKy9jsJWxBE9NoxHjlOar
	1znvCUASfzQgiGfE2VT2mH6dyrhI0Zo=
Received: from mail-pf1-f199.google.com (mail-pf1-f199.google.com
 [209.85.210.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-446-lfuHdFjJPmK1tDHANV-XQw-1; Sun, 08 Jun 2025 20:29:52 -0400
X-MC-Unique: lfuHdFjJPmK1tDHANV-XQw-1
X-Mimecast-MFC-AGG-ID: lfuHdFjJPmK1tDHANV-XQw_1749428991
Received: by mail-pf1-f199.google.com with SMTP id d2e1a72fcca58-742b6705a52so5881543b3a.1
        for <kvmarm@lists.linux.dev>; Sun, 08 Jun 2025 17:29:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749428991; x=1750033791;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=zWLcc9JilgS7Cncp/Oc4IwhgNWLN/WG8IqO7PXvDI+0=;
        b=uOLapnejXHKmlHKbfOo0pl8bJ7oLLyNAqAbLICNLm6bwMb9sAUC1Xp9z6WSbBU0cun
         lD+JhpYTFLL1f+8XztKyAKzv8wuMJwbQdp2tciHOSM9ftCHD9sjVl6UgzNEEB6PF81ds
         SuKVLVnp7BIGgwmZzaV6WpJcL3i3ScxShVcb2RFIlFXZwl+tehnhDiBnm6T1FW5DQoEH
         qy8ks2izu+eu4I7QLsilpG1KdenIFIXcYqRF2f661GndDpfcveKsYdNaVgYeAyMK+dHc
         v1R1b6EX3i85W0u2VTVomW08tN4SOnGtTQoYk2vHASG2dMdNx+wPOPH4DCTVVv7h8Uwq
         mjKQ==
X-Forwarded-Encrypted: i=1; AJvYcCU/YjjdEafpKVCrW/e/IuXxVWyGYwcpydFKsMbaw/im8fC8DlzwUueVEImJ+WBaO6brYkEdeHY=@lists.linux.dev
X-Gm-Message-State: AOJu0YzRuS7GHNKdOKg3WlZ+d/eAsVZtLI7TmoN/tKNxS4h4t7PpflEf
	80N/lR7PjyRv6HdayH04tvjkLFrf3HlENsNAKup/BT5RFnqU2+LhjsCDLtjYs6u7TGutYKqod9d
	s4qKwvqwUWVMBmW0JIP+vGSTraGWpAco5gO3VACJYpoTysro4qT3rEA8Zig==
X-Gm-Gg: ASbGncv5RSfwgk4DaPcH0MFA9AFRZ78NpF+PCNWeljoXgQ+cSEwVs5mKyR7LBZFrkHj
	RuXTF1A5zMI4oyydCefL2Y9l61+YFFLBDBLxQXFx9QByQYWyP9eAi2DG2lkJoBwvLUJYqS5z63j
	SFg79tvS308z6a5zDBNokavln+cIcxdQX8z+KERwjaWngrNAwflEWgrb1Vu8i+5neaWrrr74gYf
	hpi9u8esjRiHYWWXisgAvedxJd+f7GxW9PXT0/8UXT+LAd1v7b1wrcHnRmobpR9EGxiMbOZng5n
	bT0YYXUPK3J7PNheWfxA6zapVQfkN2VAr+W29WC/qQliRI88sm8Tlo2nMXfVHQ==
X-Received: by 2002:a05:6a20:1595:b0:210:4397:82a5 with SMTP id adf61e73a8af0-21ee68c8a34mr16623976637.21.1749428991496;
        Sun, 08 Jun 2025 17:29:51 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFINCLkeeM7uiQsUy2zEm0wbd522yAG1P7DJCZj34b2eGZNRzbL4+KX+dNqfXF3CZRxH1g4JA==
X-Received: by 2002:a05:6a20:1595:b0:210:4397:82a5 with SMTP id adf61e73a8af0-21ee68c8a34mr16623956637.21.1749428991023;
        Sun, 08 Jun 2025 17:29:51 -0700 (PDT)
Received: from [192.168.68.51] (n175-34-62-5.mrk21.qld.optusnet.com.au. [175.34.62.5])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7482af7ad57sm4659019b3a.65.2025.06.08.17.29.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 08 Jun 2025 17:29:50 -0700 (PDT)
Message-ID: <ea372927-08eb-4b07-b444-8985f7710894@redhat.com>
Date: Mon, 9 Jun 2025 10:29:29 +1000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v11 15/18] KVM: arm64: Enable host mapping of shared
 guest_memfd memory
To: Fuad Tabba <tabba@google.com>, kvm@vger.kernel.org,
 linux-arm-msm@vger.kernel.org, linux-mm@kvack.org, kvmarm@lists.linux.dev
Cc: pbonzini@redhat.com, chenhuacai@kernel.org, mpe@ellerman.id.au,
 anup@brainfault.org, paul.walmsley@sifive.com, palmer@dabbelt.com,
 aou@eecs.berkeley.edu, seanjc@google.com, viro@zeniv.linux.org.uk,
 brauner@kernel.org, willy@infradead.org, akpm@linux-foundation.org,
 xiaoyao.li@intel.com, yilun.xu@intel.com, chao.p.peng@linux.intel.com,
 jarkko@kernel.org, amoorthy@google.com, dmatlack@google.com,
 isaku.yamahata@intel.com, mic@digikod.net, vbabka@suse.cz,
 vannapurve@google.com, ackerleytng@google.com, mail@maciej.szmigiero.name,
 david@redhat.com, michael.roth@amd.com, wei.w.wang@intel.com,
 liam.merwick@oracle.com, isaku.yamahata@gmail.com,
 kirill.shutemov@linux.intel.com, suzuki.poulose@arm.com,
 steven.price@arm.com, quic_eberman@quicinc.com, quic_mnalajal@quicinc.com,
 quic_tsoni@quicinc.com, quic_svaddagi@quicinc.com,
 quic_cvanscha@quicinc.com, quic_pderrin@quicinc.com,
 quic_pheragu@quicinc.com, catalin.marinas@arm.com, james.morse@arm.com,
 yuzenghui@huawei.com, oliver.upton@linux.dev, maz@kernel.org,
 will@kernel.org, qperret@google.com, keirf@google.com, roypat@amazon.co.uk,
 shuah@kernel.org, hch@infradead.org, jgg@nvidia.com, rientjes@google.com,
 jhubbard@nvidia.com, fvdl@google.com, hughd@google.com,
 jthoughton@google.com, peterx@redhat.com, pankaj.gupta@amd.com,
 ira.weiny@intel.com
References: <20250605153800.557144-1-tabba@google.com>
 <20250605153800.557144-16-tabba@google.com>
From: Gavin Shan <gshan@redhat.com>
In-Reply-To: <20250605153800.557144-16-tabba@google.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 1Pqeo6ywR18FaOVA0klM4j5nQQkSnvbO3Ty7_fK7lKw_1749428991
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 6/6/25 1:37 AM, Fuad Tabba wrote:
> Enable the host mapping of guest_memfd-backed memory on arm64.
> 
> This applies to all current arm64 VM types that support guest_memfd.
> Future VM types can restrict this behavior via the
> kvm_arch_gmem_supports_shared_mem() hook if needed.
> 
> Acked-by: David Hildenbrand <david@redhat.com>
> Signed-off-by: Fuad Tabba <tabba@google.com>
> ---
>   arch/arm64/include/asm/kvm_host.h | 5 +++++
>   arch/arm64/kvm/Kconfig            | 1 +
>   arch/arm64/kvm/mmu.c              | 7 +++++++
>   3 files changed, 13 insertions(+)
> 
Reviewed-by: Gavin Shan <gshan@redhat.com>

