Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E916257458
	for <kvmarm@lists.linux.dev>; Mon, 16 Jun 2025 11:55:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750074959; cv=none; b=XkSgJZZUpMKKBDXpcfu3+94FTaCe058dkL5NAe0y4GWRLUGtdxiAIMEEmsiYOp72MM7jti1x/mvu9iWatYDYp2Od6p6tEOlkjaVqUt7jpcYi0Q30oPz/2sUy/nTqrK7zUOfWoVwkGb6xpL5xrcrwzoYA6yRck9aRthSoVq7rRIE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750074959; c=relaxed/simple;
	bh=BIFd+6oh6dlqpYkuI/bWibgQdDxXaDLAnSklZ6vF2yA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=uJQlGd+bB1Xmz3C/X13KTJGXethlErg9oXXkrsAg+xUU7VGEI0eVbHvf/QeaCdSMbuZ60m1me5aWMX3rrtyumtJrCxifniMMD1FW6bpvIkaBp9rQUcHipa7WRJ3/SYzHAkcf2nf651QW3EbjHJvvzvQbB8yGs+PzsjdsLsnic7c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=VtVAO2ZP; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="VtVAO2ZP"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1750074956;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Q/bdXjwJJqnT59AvXGlfQuOEaPnWXD3kQ9bjbSA1eBM=;
	b=VtVAO2ZPcXVcY5M2eTZMCZJ7qBiDQI7pXSlVzfv8RmkXQCPakP8QkylDBeMdGP9Ax5VrBW
	goC8Ygn7ddWFCmNovFl0N1+XDGjp/j5tjFQCxdDzQsmjBskT44g6DRJn9uU9TlhXIAY4wt
	js3rXeJ/VbCrihElR9zH6b2xIlMWYDw=
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com
 [209.85.216.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-619-jPAO7CGGMu-WZdAOgMUlvA-1; Mon, 16 Jun 2025 07:55:55 -0400
X-MC-Unique: jPAO7CGGMu-WZdAOgMUlvA-1
X-Mimecast-MFC-AGG-ID: jPAO7CGGMu-WZdAOgMUlvA_1750074954
Received: by mail-pj1-f69.google.com with SMTP id 98e67ed59e1d1-311e98ee3fcso4635564a91.0
        for <kvmarm@lists.linux.dev>; Mon, 16 Jun 2025 04:55:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750074954; x=1750679754;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Q/bdXjwJJqnT59AvXGlfQuOEaPnWXD3kQ9bjbSA1eBM=;
        b=YFDvAriCQD5oKAAOGHcISiS3gqJugv2Cwqj/njugvv5JFGZZFu34jPzMaiO30q31gQ
         l61bc9UUxPhp8jmitkMR6z/vHuTK754m5bwmqVhzPSLO/PjXAXaK8E4JAAAriJBWtHlh
         JDZ0eDLelu/44e31riBVDXnqdqM4Wz4S60L8pwM8no2HiSF71t+FOYh4KUxeR2RlaACx
         0ixLCpDFxg8sjY4X/JmKabCQdMV7sxF+siQmiL78fLeNY6r7WuzgsyC5QhkW99TD4C6o
         4UuS8/jgTGVXuWu3/hBNZqmsfp0/7yrKsj2MrwOar/YgKcr4tVGXN/pFihRDhewyOs4T
         bdmg==
X-Forwarded-Encrypted: i=1; AJvYcCVrDsz9a+wjc23Sb8v5FgjQ73loU3dflqI2QajfoxyOCxt/zTcs4NEGECsKeYd5kr791ENlVP4=@lists.linux.dev
X-Gm-Message-State: AOJu0Yx4BlecZFoGbOljDz4a0MEHP7kpcm9MzLawvKeMtFxW5kDOwUZI
	o/t5AwpeF+IFCYZ9q+6tEhsXwwCBA0VhuzsV9tiIEvLdduwbkuOwSxk60Nf/a+CUeltklgToG0b
	oWded9K+WJrQaU2pkUaagI/QmRtCCswNLbvd1UxHpeL+Mdly3x+dkMwODcA==
X-Gm-Gg: ASbGncscNBwR8KHtoxN/6CzPsWLTJiR+rrzjxFp6VQNhdXma0x/fSK9XcRw3ryNWW9W
	OtG4uybVHjXM1elsX+ufv2Cwbi84fRv/bzEdhxvszGvrNzRtQP5yGqYX8Cp3UPrwgxwtCLjU5MX
	4s31MtxE09TZvcnOYjf0ioKGwnxv106A8Ca3ElAWI0Q5oi01IlYxXgfwSfZE+qsnKp0M+msoRVT
	4kzcCeqlL5t2GzLiiQfXrxz9uoQVFtFUiI0vCpDLX/UGZlEPtFNhQzkZTvfmgV6uZq/0DfWajm5
	B5kCGjrmRrpsXvzIsxyQ9oEs9jqzQDANr0TvqRfiTd8UK4ebyo4MZEgy0dCoiA==
X-Received: by 2002:a17:90b:3c02:b0:311:ab20:1591 with SMTP id 98e67ed59e1d1-313f1cd69f3mr13757040a91.15.1750074954265;
        Mon, 16 Jun 2025 04:55:54 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGuchxuxj8O5MpDvVakFeHHtf7J6zJLUbqb0Q+xynaID1xSy0YUrglk2QzDK6/NsQI8aZeFug==
X-Received: by 2002:a17:90b:3c02:b0:311:ab20:1591 with SMTP id 98e67ed59e1d1-313f1cd69f3mr13757005a91.15.1750074953812;
        Mon, 16 Jun 2025 04:55:53 -0700 (PDT)
Received: from [192.168.68.51] (n175-34-62-5.mrk21.qld.optusnet.com.au. [175.34.62.5])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-313c1c6c978sm8460898a91.49.2025.06.16.04.55.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 16 Jun 2025 04:55:52 -0700 (PDT)
Message-ID: <e75dfc47-5b74-4898-91c0-fed9880f9727@redhat.com>
Date: Mon, 16 Jun 2025 21:55:42 +1000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v9 20/43] arm64: RME: Runtime faulting of memory
To: Steven Price <steven.price@arm.com>, kvm@vger.kernel.org,
 kvmarm@lists.linux.dev
Cc: Catalin Marinas <catalin.marinas@arm.com>, Marc Zyngier <maz@kernel.org>,
 Will Deacon <will@kernel.org>, James Morse <james.morse@arm.com>,
 Oliver Upton <oliver.upton@linux.dev>,
 Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu
 <yuzenghui@huawei.com>, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org, Joey Gouly <joey.gouly@arm.com>,
 Alexandru Elisei <alexandru.elisei@arm.com>,
 Christoffer Dall <christoffer.dall@arm.com>, Fuad Tabba <tabba@google.com>,
 linux-coco@lists.linux.dev,
 Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
 Shanker Donthineni <sdonthineni@nvidia.com>, Alper Gun
 <alpergun@google.com>, "Aneesh Kumar K . V" <aneesh.kumar@kernel.org>,
 Emi Kisanuki <fj0570is@fujitsu.com>
References: <20250611104844.245235-1-steven.price@arm.com>
 <20250611104844.245235-21-steven.price@arm.com>
From: Gavin Shan <gshan@redhat.com>
In-Reply-To: <20250611104844.245235-21-steven.price@arm.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 2cHta5JoKwLpa5pJ2bz9OOsRky6F9NO8C_9lU5SdmTo_1750074954
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi Steven,

On 6/11/25 8:48 PM, Steven Price wrote:
> At runtime if the realm guest accesses memory which hasn't yet been
> mapped then KVM needs to either populate the region or fault the guest.
> 
> For memory in the lower (protected) region of IPA a fresh page is
> provided to the RMM which will zero the contents. For memory in the
> upper (shared) region of IPA, the memory from the memslot is mapped
> into the realm VM non secure.
> 
> Signed-off-by: Steven Price <steven.price@arm.com>
> ---
>   arch/arm64/include/asm/kvm_emulate.h |  10 ++
>   arch/arm64/include/asm/kvm_rme.h     |  10 ++
>   arch/arm64/kvm/mmu.c                 | 133 ++++++++++++++++++++-
>   arch/arm64/kvm/rme.c                 | 165 +++++++++++++++++++++++++++
>   4 files changed, 312 insertions(+), 6 deletions(-)
> 

[...]

> @@ -1078,6 +1091,9 @@ void kvm_free_stage2_pgd(struct kvm_s2_mmu *mmu)
>   	if (kvm_is_realm(kvm) &&
>   	    (kvm_realm_state(kvm) != REALM_STATE_DEAD &&
>   	     kvm_realm_state(kvm) != REALM_STATE_NONE)) {
> +		struct realm *realm = &kvm->arch.realm;
> +
> +		kvm_stage2_unmap_range(mmu, 0, BIT(realm->ia_bits - 1), false);
>   		write_unlock(&kvm->mmu_lock);
>   		kvm_realm_destroy_rtts(kvm, pgt->ia_bits);
>   

I'm giving it a try before taking time to review, @may_block needs to be true.
I don't see there is anything why not to do so :)

   kvm_stage2_unmap_range(mmu, 0, BIT(realm->ia_bits - 1), true);

Otherwise, there is RCU stall when the VM is destroyed.

[12730.399825] rcu: INFO: rcu_preempt self-detected stall on CPU
[12730.401922] rcu:     5-....: (5165 ticks this GP) idle=3544/1/0x4000000000000000 softirq=41673/46605 fqs=2625
[12730.404598] rcu:     (t=5251 jiffies g=61757 q=36 ncpus=8)
[12730.406771] CPU: 5 UID: 0 PID: 170 Comm: qemu-system-aar Not tainted 6.16.0-rc1-gavin-gfbc56042a9cf #36 PREEMPT
[12730.407918] Hardware name: QEMU QEMU Virtual Machine, BIOS unknown 02/02/2022
[12730.408796] pstate: 61402009 (nZCv daif +PAN -UAO -TCO +DIT -SSBS BTYPE=--)
[12730.409515] pc : realm_unmap_private_range+0x1b4/0x310
[12730.410825] lr : realm_unmap_private_range+0x98/0x310
[12730.411377] sp : ffff8000808f3920
[12730.411777] x29: ffff8000808f3920 x28: 0000000104d29000 x27: 000000004229b000
[12730.413410] x26: 0000000000000000 x25: ffffb8c82d23f000 x24: 00007fffffffffff
[12730.414292] x23: 000000004229c000 x22: 0001000000000000 x21: ffff80008019deb8
[12730.415229] x20: 0000000101b3f000 x19: 000000004229b000 x18: ffff8000808f3bd0
[12730.416119] x17: 0000000000000001 x16: ffffffffffffffff x15: 0000ffff91cc5000
[12730.417004] x14: ffffb8c82cfccb48 x13: 0000ffff4b1fffff x12: 0000000000000000
[12730.417876] x11: 0000000038e38e39 x10: 0000000000000004 x9 : ffffb8c82c39a030
[12730.418863] x8 : ffff80008019deb8 x7 : 0000010000000000 x6 : 0000000000000000
[12730.419738] x5 : 0000000038e38e39 x4 : ffff0000c0d80000 x3 : 0000000000000000
[12730.420609] x2 : 000000004229c000 x1 : 0000000104d2a000 x0 : 0000000000000000
[12730.421602] Call trace:
[12730.422209]  realm_unmap_private_range+0x1b4/0x310 (P)
[12730.423096]  kvm_realm_unmap_range+0xbc/0xe0
[12730.423657]  __unmap_stage2_range+0x74/0xa8
[12730.424198]  kvm_free_stage2_pgd+0xc8/0x120
[12730.424746]  kvm_uninit_stage2_mmu+0x24/0x48
[12730.425284]  kvm_arch_flush_shadow_all+0x74/0x98
[12730.425849]  kvm_mmu_notifier_release+0x38/0xa0
[12730.426409]  __mmu_notifier_release+0x80/0x1f0
[12730.427031]  exit_mmap+0x3d8/0x438
[12730.427526]  __mmput+0x38/0x160
[12730.428000]  mmput+0x58/0x78
[12730.428463]  do_exit+0x210/0x9d8
[12730.428945]  do_group_exit+0x3c/0xa0
[12730.429458]  get_signal+0x8d4/0x9c0
[12730.429954]  do_signal+0x98/0x400
[12730.430455]  do_notify_resume+0xec/0x1a0
[12730.431030]  el0_svc+0xe8/0x130
[12730.431536]  el0t_64_sync_handler+0x10c/0x138
[12730.432085]  el0t_64_sync+0x1ac/0x1b0

Thanks,
Gavin

