Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D70867F
	for <kvmarm@lists.linux.dev>; Mon,  1 Apr 2024 02:57:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711940261; cv=none; b=SnuQPKZeBXpTqyaWwzwQzOZp/hb7KaFoHjFhTOb7aTNCiOWAu6qX6GrSO++Lqnk2CQT9FphR4BPz1q7sOsXvcVuxwLUpdnkZ+DK+MKVAndIWvMQIa2lR7I7sTY9Q46livql014Swa3BKYkxYTmkdEZ4TC91WjJ7x6tEUwHtTJf4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711940261; c=relaxed/simple;
	bh=PNMpCPHpcNVFc8b1OMUV+gC+F7IdrcOZrrRT6V9mqqU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=nyKVs9dZbOy9y/uLul0Ef9SicM9aQZ7dwsJ4ByjRybDNVFE0E3Yo96jUrINMIQILkhy6tjaJhPf+w06haiBg8DAWXAZ4wltQCgjo/Tks8jwsUq56QIiW8kDELIwTyrKdjExYFFGTZqHacIX39KaYUn9waM1/7iWCEWat9PzXBmI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=QWZ7GBJo; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="QWZ7GBJo"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1711940258;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=fplxvg7N6UFj4xleZwjFgcDp/v13uGAUfKYdf7ZN9Kg=;
	b=QWZ7GBJoRr8ukTtNMKtW2wJ6SiNJ/K4RIWJfxM0tITherzGmx3sEAOzmzSWl/yDDVVjnbU
	wPbCkVtw+BhEG9z0lztxMLyTfxIsm05nt8GngB5SiHMW4A+kocLJ9l3e98WsBdKPDyplu1
	4DB9+Kt0GUlJRV+BXAGbuu3VTq+Nym4=
Received: from mail-pg1-f199.google.com (mail-pg1-f199.google.com
 [209.85.215.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-401-yGnk7_qRMzKK8iJlH7bzUQ-1; Sun, 31 Mar 2024 22:57:36 -0400
X-MC-Unique: yGnk7_qRMzKK8iJlH7bzUQ-1
Received: by mail-pg1-f199.google.com with SMTP id 41be03b00d2f7-5ce9b15f4ccso226052a12.0
        for <kvmarm@lists.linux.dev>; Sun, 31 Mar 2024 19:57:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711940255; x=1712545055;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=fplxvg7N6UFj4xleZwjFgcDp/v13uGAUfKYdf7ZN9Kg=;
        b=XOGbWGg7Z+/aYTbF9vPnTMfrJxWTzQBqLC59zgYxEE8Lmw3LMi/oTyR+3J+cNBneUv
         LVJ+fyfb9K3YWVhqoSTY8/aFKL0HrqT1PILkEj2n6AvcPgAbNhw6CUfAPvM1DXXFVvH1
         z+Vyg0rTPtBaofb0F5LiZZxql/ZdeddGgbbx2wwqlXp0HND1cEEG9zkg6DTctnBME41y
         xeERXYUM1NyxoOSrDgi/+l5hB9qSAkvmvuL5lE3PMBz2Q7Sw43oy+xlZ47QQyvnV00qv
         1bDOlg03VYajp/GCKbjkFWiv78csf/XSGcXZV1t0a8IbkbXzuSemPKyFD79YImn2axqB
         oniQ==
X-Forwarded-Encrypted: i=1; AJvYcCWGK5Y0WTBmUlVm+bx6apLqdsCr6PiSv+dI9AtqZkQVjRrtNHvqXdtraYV58etvW+XQA+XyYfU2io1NgjC8p97rgjvDvC5N
X-Gm-Message-State: AOJu0Ywn1PBE26/HQy7/hOYt0mpB6Hn/8IiPwQTLTXHqxnuQVKu6yPUt
	LfWrqu8j5UNMD7rVyu3xb5AOoUm9I/SosCsUk7a2koHqXdBaYeFANSIbsq/mNWRpF6W0YUFHhRo
	lckyNJhB3Qz2bwTJyE86vOssvAzGy/F21z5EAV4rrG0xY6m0TyJ+tyg==
X-Received: by 2002:a05:6a20:a107:b0:1a7:c6d:5265 with SMTP id q7-20020a056a20a10700b001a70c6d5265mr6677858pzk.6.1711940255053;
        Sun, 31 Mar 2024 19:57:35 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IF4sz9GIyR5onR702ql2gG/7l94pnURClljJp6PeSjvGtvHyG2FUkOcXdGtBlcDk4qrN3G0CA==
X-Received: by 2002:a05:6a20:a107:b0:1a7:c6d:5265 with SMTP id q7-20020a056a20a10700b001a70c6d5265mr6677848pzk.6.1711940254614;
        Sun, 31 Mar 2024 19:57:34 -0700 (PDT)
Received: from [10.66.61.39] ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id x15-20020a170902820f00b001dddf29b6e8sm7598668pln.299.2024.03.31.19.57.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 31 Mar 2024 19:57:34 -0700 (PDT)
Message-ID: <f3a1417b-6407-4c1a-bbb8-e411d773a718@redhat.com>
Date: Mon, 1 Apr 2024 10:57:30 +0800
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 0/4] KVM: arm64: TLBI fixes for the pgtable code
To: Will Deacon <will@kernel.org>, kvmarm@lists.linux.dev
Cc: linux-arm-kernel@lists.infradead.org,
 Catalin Marinas <catalin.marinas@arm.com>, Gavin Shan <gshan@redhat.com>,
 Marc Zyngier <maz@kernel.org>, Mostafa Saleh <smostafa@google.com>,
 Oliver Upton <oliver.upton@linux.dev>, Quentin Perret <qperret@google.com>,
 Raghavendra Rao Ananta <rananta@google.com>,
 Ryan Roberts <ryan.roberts@arm.com>
References: <20240327124853.11206-1-will@kernel.org>
From: Shaoqin Huang <shahuang@redhat.com>
In-Reply-To: <20240327124853.11206-1-will@kernel.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 3/27/24 20:48, Will Deacon wrote:
> Hi again,
> 
> This is version two of the series I previously posted on Monday:
> 
>    https://lore.kernel.org/r/20240325185158.8565-1-will@kernel.org
> 
> We've got a long weekend coming up in the UK, so I wanted to get this
> out before I chuck the laptop in the river.
> 
> Changes since v1 include:
> 
>    * Add Ryan's Reviewed-by on the third patch
>    * Add an extra patch to ensure correct alignment of range TLBI address
>      argument
>    * Tweak commit messages
> 
> Cheers,
> 
> Will

Reviewed-by: Shaoqin Huang <shahuang@redhat.com>

> 
> Cc: Catalin Marinas <catalin.marinas@arm.com>
> Cc: Gavin Shan <gshan@redhat.com>
> Cc: Marc Zyngier <maz@kernel.org>
> Cc: Mostafa Saleh <smostafa@google.com>
> Cc: Oliver Upton <oliver.upton@linux.dev>
> Cc: Quentin Perret <qperret@google.com>
> Cc: Raghavendra Rao Ananta <rananta@google.com>
> Cc: Ryan Roberts <ryan.roberts@arm.com>
> Cc: Shaoqin Huang <shahuang@redhat.com>
> 
> --->8
> 
> Will Deacon (4):
>    KVM: arm64: Don't defer TLB invalidation when zapping table entries
>    KVM: arm64: Don't pass a TLBI level hint when zapping table entries
>    KVM: arm64: Use TLBI_TTL_UNKNOWN in __kvm_tlb_flush_vmid_range()
>    KVM: arm64: Ensure target address is granule-aligned for range TLBI
> 
>   arch/arm64/kvm/hyp/nvhe/tlb.c |  3 ++-
>   arch/arm64/kvm/hyp/pgtable.c  | 23 +++++++++++++++--------
>   arch/arm64/kvm/hyp/vhe/tlb.c  |  3 ++-
>   3 files changed, 19 insertions(+), 10 deletions(-)
> 

-- 
Shaoqin

