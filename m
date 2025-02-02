Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 883FD1BFE00
	for <kvmarm@lists.linux.dev>; Sun,  2 Feb 2025 07:13:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738480384; cv=none; b=Tkfa+/qg0uBrs6unTPSWfEJul3N/ljluBZ5/FcrIm0VMw1c2NxErWP0kLJj6/CO3L0vIzKBA+ZjJKQ9DDlZupRk9VaZ6gzFTqNxsloM6Nr49sWC9UA3AZVu0rRx0+TC+H+s9xiMX0dFWlt7JbAz7MB6oIoO5X/7vzdFsi7ymW1g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738480384; c=relaxed/simple;
	bh=CXPd9+3PCf0ABtxW27kGa+FmX6LrCMM7KEngRhxn1qQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=RKus9i6AAZY2Znl2KzdVacbl7QrmTiIxaJWHMucd0JavdpKQNX22f5VL9k82eD3Q8vz0LM/j0vYHTlUvbv5viy8yXiRr5bSN6NFLA7ajxDkTNbN4Jin+IBmAlAGAYG7/dGokuw5vH12A+Slz3K75GuI7farWX27pwg16bGPy2Ow=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=iak71eLf; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="iak71eLf"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1738480381;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+Akyo3JQj2YPzoJhRHm4ECXXW4B+Mshy1bBF/6XTbeo=;
	b=iak71eLfDyT2saDd4rfe8VQXebcZSq49M9olITqfJgYOArcPRzZfAweFtwoc3TBZhSROZM
	pgG9+EiyQaVbIVggRHNbIzSz/EoMsjZ3IWqNNx0j6YDoubWX3dByUZIdKIKP8Ux2VQXeHM
	1zfAz9L8bkISHd0GAJEM2pVBzstd2WA=
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com
 [209.85.214.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-665-q_nYBr7BMo2GSHWepijdYw-1; Sun, 02 Feb 2025 02:12:58 -0500
X-MC-Unique: q_nYBr7BMo2GSHWepijdYw-1
X-Mimecast-MFC-AGG-ID: q_nYBr7BMo2GSHWepijdYw
Received: by mail-pl1-f199.google.com with SMTP id d9443c01a7336-216430a88b0so70368755ad.0
        for <kvmarm@lists.linux.dev>; Sat, 01 Feb 2025 23:12:57 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738480377; x=1739085177;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+Akyo3JQj2YPzoJhRHm4ECXXW4B+Mshy1bBF/6XTbeo=;
        b=Aq//yGcLSy3RqEMt2gNuQ3nBxuxJcJf5gvrHszxgDlHjSLsHpQrhWDCc9AE25/vx/T
         UNtoeLB0cfLu73GITiz6hspRboKxsh5Opc0pEgVU+MfXE+zvFRDC25HdXdYw0urOhH68
         dX1Vvm+zPUK/dZ9JbveC7w9AKkrvkWXCYynMzzUMsEW5RNUFdOl6tDTb9xcOU8RbimW0
         5yBKCOTtulr9Zz6nGCk8aSxy0BbWUmZJMIh2qU0vG9Tj2YT5EB2q+Im782uDSWAphhFy
         ACAwljXb8EwO9rfP/BE1YS3f8UMudOpZlRTvxMoLCRrSjSRCqsxAPASExJ7DMeJFWp+w
         QELw==
X-Forwarded-Encrypted: i=1; AJvYcCVcpvlOF6TE8b/7GuzvyKWADOb0a0kT1vKHgyjbRuSDIyKy/0oOZpUmzgt0VVX3MJKeJUzqTUI=@lists.linux.dev
X-Gm-Message-State: AOJu0YzAEInpugVfsc/gVtPnpMT992QBgLpsNBZnJUMQo32ZBJYWdiDq
	BsPld3jzE1Dp+mmFcvmosfrp8U7qsT+JP2ba7GkohJ2I7ccdyFTFjVuwty6YqvhHbTXwJu+DSq6
	3ChunkY9h1RN92uI0jgSYeyoVwl5VOGdVytdyzQ4u2dNCWgtUPdiirA==
X-Gm-Gg: ASbGncvSQlLJzMnbbjIlljwaZqV9f9+GeN9LVVb+w/SAjVP91P31GBTc2re91Bjbg5r
	8iS85A/cSy2XBhMopIEdSC2/rF+5YRhkKvUmjqhudhGYFEvkqzP5o/w1MeW1skKUoV/+WSYi48d
	yVT/Kf4xJy1fonkA0bjepjrHZ+rzQ47aYNu6jMdFrR/f4TXZkDQ+vQiXIHLlh7BBHjP1z5i3X4K
	8SiCwrl92VCqfF5TtAVNM/NhkwXyCd5QL0DdE3Z7p2od/v8rcDtcQaQ/5yOd13xTd55mUyHkJ1H
	RA+0+w==
X-Received: by 2002:a17:903:110c:b0:216:1ad2:1d5 with SMTP id d9443c01a7336-21dd7deebd1mr265357445ad.41.1738480377002;
        Sat, 01 Feb 2025 23:12:57 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEEbEpN4KQNQWRi1soSDL1v4OtYLgM2DYDPCY0eEgB/YujTFWmFABLlbkBOcGlGdKwPsn62yg==
X-Received: by 2002:a17:903:110c:b0:216:1ad2:1d5 with SMTP id d9443c01a7336-21dd7deebd1mr265357095ad.41.1738480376627;
        Sat, 01 Feb 2025 23:12:56 -0800 (PST)
Received: from [192.168.68.55] ([180.233.125.64])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-21de32ea5f1sm54843395ad.130.2025.02.01.23.12.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 01 Feb 2025 23:12:56 -0800 (PST)
Message-ID: <f339729a-00a8-40b5-af05-f0f019579e5e@redhat.com>
Date: Sun, 2 Feb 2025 17:12:48 +1000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 30/43] arm64: rme: Prevent Device mappings for Realms
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
 <alpergun@google.com>, "Aneesh Kumar K . V" <aneesh.kumar@kernel.org>
References: <20241212155610.76522-1-steven.price@arm.com>
 <20241212155610.76522-31-steven.price@arm.com>
From: Gavin Shan <gshan@redhat.com>
In-Reply-To: <20241212155610.76522-31-steven.price@arm.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 1p-MG6lSaEsSfUtepgA6bFxcmQM8IvAjAm2ZP7B2ONM_1738480377
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12/13/24 1:55 AM, Steven Price wrote:
> Physical device assignment is not yet supported by the RMM, so it
> doesn't make much sense to allow device mappings within the realm.
> Prevent them when the guest is a realm.
> 
> Signed-off-by: Steven Price <steven.price@arm.com>
> ---
> Changes from v5:
>   * Also prevent accesses in user_mem_abort()
> ---
>   arch/arm64/kvm/mmu.c | 12 ++++++++++++
>   1 file changed, 12 insertions(+)
> 
> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index 9ede143ccef1..cef7c3dcbf99 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@ -1149,6 +1149,10 @@ int kvm_phys_addr_ioremap(struct kvm *kvm, phys_addr_t guest_ipa,
>   	if (is_protected_kvm_enabled())
>   		return -EPERM;
>   
> +	/* We don't support mapping special pages into a Realm */
> +	if (kvm_is_realm(kvm))
> +		return -EINVAL;
> +

		return -EPERM;

>   	size += offset_in_page(guest_ipa);
>   	guest_ipa &= PAGE_MASK;
>   
> @@ -1725,6 +1729,14 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>   	if (exec_fault && device)
>   		return -ENOEXEC;
>   
> +	/*
> +	 * Don't allow device accesses to protected memory as we don't (yet)
> +	 * support protected devices.
> +	 */
> +	if (device && kvm_is_realm(kvm) &&
> +	    kvm_gpa_from_fault(kvm, fault_ipa) == fault_ipa)
> +		return -EINVAL;
> +

s/kvm_is_realm/vcpu_is_rec

I don't understand the check very well. What I understood is mem_abort() is called
only when kvm_gpa_from_fault(kvm, fault_ipa) != fault_ipa, meaning only the page
faults in the shared address space is handled by mem_abort(). So I guess we perhaps
need something like below.

	if (vcpu_is_rec(vcpu) && device)
		return -EPERM;

kvm_handle_guest_abort
   kvm_slot_can_be_private
     private_memslot_fault	// page fault in the private space is handled here
   io_mem_abort			// MMIO emulation is handled here
   user_mem_abort                // page fault in the shared space is handled here

>   	/*
>   	 * Potentially reduce shadow S2 permissions to match the guest's own
>   	 * S2. For exec faults, we'd only reach this point if the guest

Thanks,
Gavin

