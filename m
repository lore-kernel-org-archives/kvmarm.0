Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 668B427B4E0
	for <kvmarm@lists.linux.dev>; Fri, 11 Jul 2025 09:37:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752226628; cv=none; b=itv7F2L9JlcnMJUutWoWSSOnmsJjUERBqHsojsZzjtRLe8ShQFn512mhVld/2EWRuS4yrTmKDddr4Rx2tYVDIBA3pbPrR0yCUwN7BqwoxbpJzD9aSlehhja6tiwgV/fF/wU9/eEukNEexE9tmhUAFDSzBRAS2dX4E9sicI+9maE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752226628; c=relaxed/simple;
	bh=9suKWsS0rHymfk9TQGmbQKs5zALFUrp1fPpFra/s9UI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=MLEwApr9V82Ku0qi+V2s/jetmeBTCgL4i0RjxslAQ3tzdC28UEg4+c93ZezoIhFcD15Y269x6EbvCS56dep7r8kZaCrPue0LzxUgseNO0JFYhG3kRBAAv1GmjfzturBvzb/arTPVBZ21FtCec7jynbW1D2T0cAmRKySwhGiNXQA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=R21RF0C+; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="R21RF0C+"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1752226625;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=xA0OBovI0qiiKgM2RE7S4aciFKin8qkBM8MTFs6V5aA=;
	b=R21RF0C+kzYDb4YiNOhidHggvBAv40Li7uHIRrs7bf0u9kcfNzuYbd61TLmz47RmpYaR9Z
	F88BwLt4yv7ztxE4uKoFk/G6UxDwnIa5ZgCjmjKUzzYj5Wt6yI52VQUPpE+IPBfMVZUaPt
	xtkdCrZiVW4II1+1glXUjxia47U/PaQ=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-332-EQYdc3qjMxu6zWe0gkI0Ag-1; Fri, 11 Jul 2025 05:37:02 -0400
X-MC-Unique: EQYdc3qjMxu6zWe0gkI0Ag-1
X-Mimecast-MFC-AGG-ID: EQYdc3qjMxu6zWe0gkI0Ag_1752226621
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-4532ff43376so16733545e9.3
        for <kvmarm@lists.linux.dev>; Fri, 11 Jul 2025 02:37:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752226620; x=1752831420;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=xA0OBovI0qiiKgM2RE7S4aciFKin8qkBM8MTFs6V5aA=;
        b=XPR3nwNZqFBHXzOVSDceMzYorWuIMhbWJuCH9WS6jI9eH34FrzVnebLzXkp0k5tC91
         PTj14ff0NctZ2DJIZ+unEZdVqeveKkfEDPGVFP8TXSjNgbFMoQWh3oReDw0RWM5uVCxx
         Z9nHGRg8vmx2/b0w64i1uqweL9tgw3QPin+Zx5C7mDM9DoVqc22CeF1QP26Idagq8wa4
         Kd33JGa4q3wG6YvIugdCGgVNspLRMfv+Q/6qUBecFFA+f9bdfvReHXKvgU+VjI1Xgw5f
         9OzWbE/WyGBl8Mau+yMIp0ocbhGogsAl98lF22LyOxRO1c39IEj2xdHjTRcCPLrmWPhS
         yyIw==
X-Forwarded-Encrypted: i=1; AJvYcCUdzXWCeg27pE2dqUyDi86eirZLCvK2dBFMpcpRpHwPF2ogv5n+a/9qdn+ikRCnCf9LCK4tUzM=@lists.linux.dev
X-Gm-Message-State: AOJu0Yz0CppGzzDGERf9H14JJgBYUY1h+bUGlNIpTRgYgo7+ZMDe2rdB
	3CicHtE4jXUb4KeaLtBRCBKhJaP+AyhU2c6zj6zHNnX3vnxB1aKM7wTOHJMlVVKT5VmpdUXOkQe
	AOqR+FyjawUGJy5ry6UqGAd0QOqvrVJYG9qHsQkuEX8IqbmBvUvc6mjnpAg==
X-Gm-Gg: ASbGncuLoiSC8FdjpLPd96YbptpCzguOBnF3qq6ITbXqtyfn8faO3lz8DYfDzyRXQ6A
	TnXbnFC/NqKnGlUiYVAXoP98k4uIyhiFqUWnm5mIO32pMHA9rcjNy2rlHr3tecRtuaC4Uy3Oxg5
	DEYl/e0cpuBN93MZeTOWEQMr9vsG3qKd2IFdccYsLBIn3fu/E5n0IEUhtMxry8ox7kJnx+quNgx
	wsx4ZobqUVZBnnVimdZ0clfEMJArZDXW4FAuEdPgQ6U3c7b5pnc9Lx3oxtoWkIAnvsNGRhMcXWt
	EyljOOy+ZBpgJSBKGXomTHTKr0+WV5aGFHzfvVFyW6rgrLnhTGEssnsFa/1+TvynzWvEvgdsBse
	4fHWMDP/9/wAaoX0ZcstSGnV33bcw1KP32PiBOMKNtlRzhvLAgNb792x22LlWbb2za/4=
X-Received: by 2002:a05:6000:4025:b0:3a4:f8e9:cef2 with SMTP id ffacd0b85a97d-3b5f2e1b641mr1754231f8f.36.1752226620341;
        Fri, 11 Jul 2025 02:37:00 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IF+hICpGbhlJGiLJG3KWJjiX9CPM0fHoBscZr6YOelTdPL05gMC9v1YCtA5hYWnCGxZHpNopg==
X-Received: by 2002:a05:6000:4025:b0:3a4:f8e9:cef2 with SMTP id ffacd0b85a97d-3b5f2e1b641mr1754206f8f.36.1752226619794;
        Fri, 11 Jul 2025 02:36:59 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f3c:3a00:5662:26b3:3e5d:438e? (p200300d82f3c3a00566226b33e5d438e.dip0.t-ipconnect.de. [2003:d8:2f3c:3a00:5662:26b3:3e5d:438e])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3b5e8bd18ffsm3915762f8f.9.2025.07.11.02.36.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 11 Jul 2025 02:36:59 -0700 (PDT)
Message-ID: <455fc70a-23e4-4c01-b502-37834473d195@redhat.com>
Date: Fri, 11 Jul 2025 11:36:56 +0200
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v13 10/20] KVM: x86/mmu: Generalize
 private_max_mapping_level x86 op to max_mapping_level
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
 michael.roth@amd.com, wei.w.wang@intel.com, liam.merwick@oracle.com,
 isaku.yamahata@gmail.com, kirill.shutemov@linux.intel.com,
 suzuki.poulose@arm.com, steven.price@arm.com, quic_eberman@quicinc.com,
 quic_mnalajal@quicinc.com, quic_tsoni@quicinc.com,
 quic_svaddagi@quicinc.com, quic_cvanscha@quicinc.com,
 quic_pderrin@quicinc.com, quic_pheragu@quicinc.com, catalin.marinas@arm.com,
 james.morse@arm.com, yuzenghui@huawei.com, oliver.upton@linux.dev,
 maz@kernel.org, will@kernel.org, qperret@google.com, keirf@google.com,
 roypat@amazon.co.uk, shuah@kernel.org, hch@infradead.org, jgg@nvidia.com,
 rientjes@google.com, jhubbard@nvidia.com, fvdl@google.com, hughd@google.com,
 jthoughton@google.com, peterx@redhat.com, pankaj.gupta@amd.com,
 ira.weiny@intel.com
References: <20250709105946.4009897-1-tabba@google.com>
 <20250709105946.4009897-11-tabba@google.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 WNyWQQ==
Organization: Red Hat
In-Reply-To: <20250709105946.4009897-11-tabba@google.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: TNA_tLDHtz8RBUJqFQ58mb_BBNc5Czn84wlomt3nSu8_1752226621
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 09.07.25 12:59, Fuad Tabba wrote:
> From: Ackerley Tng <ackerleytng@google.com>
> 
> Generalize the private_max_mapping_level x86 operation to
> max_mapping_level.
> 
> The private_max_mapping_level operation allows platform-specific code to
> limit mapping levels (e.g., forcing 4K pages for certain memory types).
> While it was previously used exclusively for private memory, guest_memfd
> can now back both private and non-private memory. Platforms may have
> specific mapping level restrictions that apply to guest_memfd memory
> regardless of its privacy attribute. Therefore, generalize this
> operation.
> 
> Rename the operation: Removes the "private" prefix to reflect its
> broader applicability to any guest_memfd-backed memory.
> 
> Pass kvm_page_fault information: The operation is updated to receive a
> struct kvm_page_fault object instead of just the pfn. This provides
> platform-specific implementations (e.g., for TDX or SEV) with additional
> context about the fault, such as whether it is private or shared,
> allowing them to apply different mapping level rules as needed.
> 
> Enforce "private-only" behavior (for now): Since the current consumers
> of this hook (TDX and SEV) still primarily use it to enforce private
> memory constraints, platform-specific implementations are made to return
> 0 for non-private pages. A return value of 0 signals to callers that
> platform-specific input should be ignored for that particular fault,
> indicating no specific platform-imposed mapping level limits for
> non-private pages. This allows the core MMU to continue determining the
> mapping level based on generic rules for such cases.
> 
> Suggested-by: Sean Christoperson <seanjc@google.com>
> Signed-off-by: Ackerley Tng <ackerleytng@google.com>
> Signed-off-by: Fuad Tabba <tabba@google.com>
> ---

Acked-by: David Hildenbrand <david@redhat.com>

-- 
Cheers,

David / dhildenb

