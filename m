Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4257A265287
	for <kvmarm@lists.linux.dev>; Mon, 16 Jun 2025 14:20:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750083609; cv=none; b=ZEkfi9FYhGNDBGZFRbBUuA91GsCJVQzfdpIt2jlUx9n2KJbeb2CrHq/wm6Jixyenbb2lcNWNCf9x/XQt+ekSsV+Z21TOG7xayrtga1RfIPtu0FI6cnSlX+dpxGmsafvvmNg2Z6rZvnG756/oLNbBNgkLzvFZbgUdzuFcKTN+bbo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750083609; c=relaxed/simple;
	bh=9LCvD/Ybo04nJpjZnfhMa4oJJsQuLeEGhzkb3RybMis=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=DNCue4GWvqbyFbNLUW2vY2JhzjrMYu3+O6P1jWH/ZJJEUCOUcolEx6nPqGiMtX2LVsiUUt/SthiB7JZlLTi9sOK6ZwKL1kkASc7m75LcKcYeRHMGv0sxXYvCiuvcpEP+1Dv5oBFJ0YhR8Eiy1201SHvnxbvsfSVsYEeP2DFCr8g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=F5+6APed; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="F5+6APed"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1750083607;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=56Tpqkk75kYKzuIVAtIE+REJgb5AnQU2Z8HbyKbkuTk=;
	b=F5+6APedx0RBtpOQzWG/rOjVUkNSHgRxQ1M/TT2C+32qa6laoFfXxB+WA/15xlUgrJqiMs
	9zbQ+TAW1JMEVvK6pKPAqqoRH/J3QmFI7PiD+UimFMsxUjhUpHpuADw/LCnEhhh3lP8WRn
	KCdz9dsTNl8acNFirGUl4niwJ1bYJcU=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-651-PnAJL9-XPIOQf7kYo-8ZEg-1; Mon, 16 Jun 2025 10:20:06 -0400
X-MC-Unique: PnAJL9-XPIOQf7kYo-8ZEg-1
X-Mimecast-MFC-AGG-ID: PnAJL9-XPIOQf7kYo-8ZEg_1750083605
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-3a578958000so587202f8f.3
        for <kvmarm@lists.linux.dev>; Mon, 16 Jun 2025 07:20:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750083605; x=1750688405;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=56Tpqkk75kYKzuIVAtIE+REJgb5AnQU2Z8HbyKbkuTk=;
        b=ELbVixXyab84zwIELzAxc2/LMk4/felZYBpn8r+jil543kkRmdDQsNm13ihwbHKmjL
         9M6vI6Tlw9L8tfEorjp8WONoFcF3spLKnzkfyR4L+06USvtpVoWq84TyanrXBL732Gjx
         PL0b7MW1D1sa0hpjZrFEXTrqErfd1In8ArTNLS7m//vZLEBMnkrnG7wbNfn0t0FNGmYB
         h/Db/xfk6SuztWAPd50EtXD9ICq068IHx9B7kzF+s1im7bp5dt3mQWEq4m7d3nsVhz0c
         UzR8JKtgyyQ/J0tfYb6SnR0Dz2dkdfxrOOIunvuAEx13CUJGISHkhQMEf+QmQ+hCOGfz
         WzgA==
X-Forwarded-Encrypted: i=1; AJvYcCUfktTaNgvF7S0nj8cqUX5/p4gUb9l2Xqonm7X5IBv0g1DQUrz3mQF7rl5o61CNsYLlTCZEi+A=@lists.linux.dev
X-Gm-Message-State: AOJu0YwgCoglMU9U83HfQwpEXv31YAwsUHJSUzHCK1+RwT9b4xzzTwNh
	u1nqTqSMscBW8QurJEZiw+qtgyYPrEqPKvHgXS+3U3o2NHfVaOESqZO7XA3mtPEUVB5pbejjSfG
	RdGZflB3oLzj3pkGBh0Y3wf0ywV40Du2MwGtzSK7P6HhH0Cw0E/7K9WxFIA==
X-Gm-Gg: ASbGncs53m2/UQK8AzOjdGI2q4UKXWbu0/VuTyscHIgB69wdgxifkJWrzDjhpmoC5xZ
	SDkez0T8ev5ItA0uB4D+v98dARg8ssa9I5s8kxSviSEM960LZ0KnmNFysmLSt1Idck68h8n6oTa
	vn5rrNK2mjQVRSHVUHXKOq6JxrboHgF2VTrfHmnnHYom0Z1zbkp0FsWgxEYqonkKPN5CvMUWFi9
	XHolOcuHLOvlezmlNMG+PzqWBYmLWrCC3s3sQWtSL2dCHmyE4/uBQjYUq4KKsHWPH1XjEbj0oVm
	XJWC6sq4OZte2JVdWHgSw8KVt8hpJXDooT/fzdA9EhM8mlrzSdd5QSgzjD/X2ganeOuYmK5ligI
	gfsjwHj/MSAj73UfxFWWLD/cb/nonDHicw6p05rAXEXkLvAA=
X-Received: by 2002:a05:6000:18ad:b0:3a4:ee3f:8e1e with SMTP id ffacd0b85a97d-3a572e8c038mr7550679f8f.39.1750083604815;
        Mon, 16 Jun 2025 07:20:04 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGYosUfYZVFXTDxpCSyfqn16IAAlEa9Q8vWVbziIfVjbez9nDFIFDVNp+8lB3mlMWXzagX2LQ==
X-Received: by 2002:a05:6000:18ad:b0:3a4:ee3f:8e1e with SMTP id ffacd0b85a97d-3a572e8c038mr7550597f8f.39.1750083604274;
        Mon, 16 Jun 2025 07:20:04 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f25:bd00:949:b5a9:e02a:f265? (p200300d82f25bd000949b5a9e02af265.dip0.t-ipconnect.de. [2003:d8:2f25:bd00:949:b5a9:e02a:f265])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a568a54d2asm11139179f8f.9.2025.06.16.07.20.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 16 Jun 2025 07:20:03 -0700 (PDT)
Message-ID: <a70e971e-046e-4766-ad52-483c533e4de6@redhat.com>
Date: Mon, 16 Jun 2025 16:20:01 +0200
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v12 04/18] KVM: x86: Rename kvm->arch.has_private_mem to
 kvm->arch.supports_gmem
To: Fuad Tabba <tabba@google.com>, Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-arm-msm@vger.kernel.org, linux-mm@kvack.org,
 kvmarm@lists.linux.dev, pbonzini@redhat.com, chenhuacai@kernel.org,
 mpe@ellerman.id.au, anup@brainfault.org, paul.walmsley@sifive.com,
 palmer@dabbelt.com, aou@eecs.berkeley.edu, viro@zeniv.linux.org.uk,
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
References: <20250611133330.1514028-1-tabba@google.com>
 <20250611133330.1514028-5-tabba@google.com> <aEyLlbyMmNEBCAVj@google.com>
 <CA+EHjTz=j==9evN7n1sGfTwxi5DKSr5k0yzXhDGzvwk7UawSGA@mail.gmail.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 WNyWQQ==
Organization: Red Hat
In-Reply-To: <CA+EHjTz=j==9evN7n1sGfTwxi5DKSr5k0yzXhDGzvwk7UawSGA@mail.gmail.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 9aHB4mO8r2MtunKJYmLzuoKerZNKTSwR7s1JLnzbXl4_1750083605
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

>>> Rename it to supports_gmem to make its meaning clearer and to decouple memory
>>> being private from guest_memfd.
>>>
>>> Reviewed-by: Ira Weiny <ira.weiny@intel.com>
>>> Reviewed-by: Gavin Shan <gshan@redhat.com>
>>> Reviewed-by: Shivank Garg <shivankg@amd.com>
>>> Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
>>> Co-developed-by: David Hildenbrand <david@redhat.com>
>>> Signed-off-by: David Hildenbrand <david@redhat.com>
>>> Signed-off-by: Fuad Tabba <tabba@google.com>
>>> ---
>>>   arch/x86/include/asm/kvm_host.h | 4 ++--
>>>   arch/x86/kvm/mmu/mmu.c          | 2 +-
>>>   arch/x86/kvm/svm/svm.c          | 4 ++--
>>>   arch/x86/kvm/x86.c              | 3 +--
>>>   4 files changed, 6 insertions(+), 7 deletions(-)
>>
>> This missed the usage in TDX (it's not a staleness problem, because this series
>> was based on 6.16-rc1, which has the relevant code).
>>
>> arch/x86/kvm/vmx/tdx.c: In function ‘tdx_vm_init’:
>> arch/x86/kvm/vmx/tdx.c:627:18: error: ‘struct kvm_arch’ has no member named ‘has_private_mem’
>>    627 |         kvm->arch.has_private_mem = true;
>>        |                  ^
>> make[5]: *** [scripts/Makefile.build:287: arch/x86/kvm/vmx/tdx.o] Error 1
> 
> I did test and run this before submitting the series. Building it on
> x86 with x86_64_defconfig and with allmodconfig pass (I obviously
> missed TDX though, apologies for that). I should have grepped for
> has_private_mem. That said, if I understood your suggestion correctly,
> this problem wouldn't happen again.

It's interesting that the build bots didn't catch that earlier.

-- 
Cheers,

David / dhildenb

