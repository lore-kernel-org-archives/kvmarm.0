Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6805122B8C8
	for <kvmarm@lists.linux.dev>; Wed, 26 Feb 2025 18:38:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740595117; cv=none; b=fxPq6ebCBVyQPyxsRoHG19TO+bM7zuFB6KKSbLpIscSUEO7H5sc/iXo5iferRMtvBwRuer5UcPyWsv/MkRCkPjwEZWw+dONsqvfJCn1RiOwCcX59Re/4WZsHfI/7QNH19Ipmhzq4PlVELjDBHKopoqQsYox40XP2hU/mk1WW578=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740595117; c=relaxed/simple;
	bh=4pE8iNhrmO71LZGB2PEKoAbu2e3X350ddkt001DYnro=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Ixd6Ud25D1IcI0KkEAb2XkgLbsgHSv7js7st7gWbxutro72+c8J9CHcuqS/jX6wWcsvOrSoAGngYK1tR//sL+ZB7cINiML84yUPMKHxek4Y6IY/gOaynuqiqiGaeR75hOysxzZUUeIWpoLl6BVUi5geuxUZzuuQaXDkTJZ4S0l4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=GosU4Ei3; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="GosU4Ei3"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1740595113;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=Po4dipnmwfGs5ho6Uar/3eIBvd8Wea1v5VEnmsiU7UA=;
	b=GosU4Ei3WXlSDR8RMr8yh+LUCsf9Ur77lNAwH3tp1ksChhTahazwmUy4HYa/r9wXjZSpCM
	+XWGkFxjGw8vlb4F6dymDJdkc5AkP0UaJ1PZpxmOg2X2g4TZNoIG9xWuURQy5RNtFGYVMI
	sAzLKE2F7FJKtm2hGr0gTD92DtRWATw=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-481-1mXPPCsbOna_bhLcbT61lw-1; Wed, 26 Feb 2025 13:38:31 -0500
X-MC-Unique: 1mXPPCsbOna_bhLcbT61lw-1
X-Mimecast-MFC-AGG-ID: 1mXPPCsbOna_bhLcbT61lw_1740595110
Received: by mail-ej1-f69.google.com with SMTP id a640c23a62f3a-abb9d1c8113so7346066b.0
        for <kvmarm@lists.linux.dev>; Wed, 26 Feb 2025 10:38:30 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740595109; x=1741199909;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Po4dipnmwfGs5ho6Uar/3eIBvd8Wea1v5VEnmsiU7UA=;
        b=rY1yJQFucTDPPP0X9wBTELMH9Acwmj/7UmkvC3mo7KwRbTtFK/gIwk3gpuApVi2xml
         aHitiXz0UEkHRokgPbxYHrCYxaWeEntP1LByzDxUNhzDDvaucaqUI4INgwvQOD/y6gmQ
         lXOl1CIIm2ZSN2L76rqYqaim9RFHALkIQNI0gJ0n2V2iIQQMC2RcHy1NGcCjdsWw3C7z
         Qh3+l81c1JpV7+AN+9qq4Tp2bp6uX9mifzFD4Sjd0LaU2fj8ozM3D7OwF7ApJAjecmZh
         V9ZI8wrsH9N5BmDHVyJHq0YOJZezmtSCAuluv5aIxtqNr6IrgjFz2JQBc+FHm2Z/TSOC
         tQ0A==
X-Forwarded-Encrypted: i=1; AJvYcCVA6eJqbauPVNGCsuLdgOFWq/23IUDLp7kX5v+7+u8xYUmpvP/FvXzxCcR2ECSsGNl8PIQMi/E=@lists.linux.dev
X-Gm-Message-State: AOJu0YyyZtHVRDJS6/bHCfR6N/E73kO9ZrDiak2T0laBf1o3FJdtKm0K
	i7sd4CfIIHHrCDhyv07acY+SKA/illKP9/zumg4Z8JCkJmXeGAQmRdQJbR6NfVFT5mPXoMOWb4E
	EGoxOV70lDNNV0C61+j1VWwZISZYv3jLNJxqEvv07QXeD3SyfhgwEYA==
X-Gm-Gg: ASbGncso3BOwuBf9OWqqF3XhQXTQeTXkcQRKIkEvpTzI98GHJdSgPu15r21IZApR8AK
	mo44g+pp+qJRb1WQ1o/qjT4KfKzzGkokv5X0rftpyrhpGZvl6iUasohFLcULghh5/sXRT37OVjS
	fKsLLUomq6gIbwkDU5L+VblXRAUom2kUOamN3CPeMG/EDuthjmf8ZeDVAO7YEkLwqUrRvUzp2LV
	F81WinonBzQtb0Z+LjOVPGwBBS7+Z33iXYWIvxkttA0Sw6M3xcmHtzEeML7Lv1zVhTDTK5irQ2c
	+2D8dCgTffzFHIAO21lu
X-Received: by 2002:a17:906:6185:b0:ab7:c1d5:14f9 with SMTP id a640c23a62f3a-abeeecf6f63mr518735666b.10.1740595109600;
        Wed, 26 Feb 2025 10:38:29 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGCDnvlNLlcOiBeBNB6S3TtqOxMTUK/PR46JW7lLq0KgREP2FusBvOHa60dTZ6MWayPAjFhrw==
X-Received: by 2002:a17:906:6185:b0:ab7:c1d5:14f9 with SMTP id a640c23a62f3a-abeeecf6f63mr518730666b.10.1740595109199;
        Wed, 26 Feb 2025 10:38:29 -0800 (PST)
Received: from [192.168.10.81] ([176.206.102.52])
        by smtp.googlemail.com with ESMTPSA id a640c23a62f3a-abed20ac11bsm364226166b.163.2025.02.26.10.38.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 26 Feb 2025 10:38:28 -0800 (PST)
Message-ID: <be33873f-ae4e-4db9-bca4-e83e8d4b39c3@redhat.com>
Date: Wed, 26 Feb 2025 19:38:21 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/7] KVM: x86: nVMX IRQ fix and VM teardown cleanups
To: Sean Christopherson <seanjc@google.com>, Marc Zyngier <maz@kernel.org>,
 Oliver Upton <oliver.upton@linux.dev>, Tianrui Zhao
 <zhaotianrui@loongson.cn>, Bibo Mao <maobibo@loongson.cn>,
 Huacai Chen <chenhuacai@kernel.org>,
 Madhavan Srinivasan <maddy@linux.ibm.com>, Anup Patel <anup@brainfault.org>,
 Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt
 <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>,
 Christian Borntraeger <borntraeger@linux.ibm.com>,
 Janosch Frank <frankja@linux.ibm.com>,
 Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
 kvm@vger.kernel.org, loongarch@lists.linux.dev, linux-mips@vger.kernel.org,
 linuxppc-dev@lists.ozlabs.org, kvm-riscv@lists.infradead.org,
 linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
 Aaron Lewis <aaronlewis@google.com>, Jim Mattson <jmattson@google.com>,
 Yan Zhao <yan.y.zhao@intel.com>,
 Rick P Edgecombe <rick.p.edgecombe@intel.com>,
 Kai Huang <kai.huang@intel.com>, Isaku Yamahata <isaku.yamahata@intel.com>
References: <20250224235542.2562848-1-seanjc@google.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Autocrypt: addr=pbonzini@redhat.com; keydata=
 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
In-Reply-To: <20250224235542.2562848-1-seanjc@google.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: CyGdxj2mA038vbvNqq2omZLVlqXVMngKPU0YVEN6hZ8_1740595110
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/25/25 00:55, Sean Christopherson wrote:
> This was _supposed_ to be a tiny one-off patch to fix a nVMX bug where KVM
> fails to detect that, after nested VM-Exit, L1 has a pending IRQ (or NMI).
> But because x86's nested teardown flows are garbage (KVM simply forces a
> nested VM-Exit to put the vCPU back into L1), that simple fix snowballed.
> 
> The immediate issue is that checking for a pending interrupt accesses the
> legacy PIC, and x86's kvm_arch_destroy_vm() currently frees the PIC before
> destroying vCPUs, i.e. checking for IRQs during the forced nested VM-Exit
> results in a NULL pointer deref (or use-after-free if KVM didn't nullify
> the PIC pointer).  That's patch 1.
> 
> Patch 2 is the original nVMX fix.
> 
> The remaining patches attempt to bring a bit of sanity to x86's VM
> teardown code, which has accumulated a lot of cruft over the years.  E.g.
> KVM currently unloads each vCPU's MMUs in a separate operation from
> destroying vCPUs, all because when guest SMP support was added, KVM had a
> kludgy MMU teardown flow that broken when a VM had more than one 1 vCPU.
> And that oddity lived on, for 18 years...

Queued patches 1 and 2 to kvm/master, and everything to kvm/queue 
(pending a little more testing and the related TDX change).

Paolo

