Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 026C03033CB
	for <kvmarm@lists.linux.dev>; Tue,  6 Oct 2026 03:02:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791255736; cv=none; b=gtXelJxB5L2BzE1n0YeIV10NshE/tQ/M1Rxi0GQ/DOcGfxUI9rmzak1Lm58F1UUsGLiJrS/mCYnPmDQTaBWUD5bofg0O8MLzX6fq5EI5iN3Mafgjy7ZdQSeS4HGN/DT+IBYYu3AxYkzFbaDainmf7n92exFrnD8o1yKgcsD3+74=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791255736; c=relaxed/simple;
	bh=GCdY9Mytk6VjiaMyjYFYbwfdFDoSlwGK8OpG5whr+QU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=aIBSLXJ1R+5f+4Dthln/HoR/8XtAabzjsrX42pd6S09OuKyAOteqmD8DzEZtHwHR/VVGc8q25mL/cmhXjFg1qdbKKakdNikUK8h2cuM/OlOv+4aWoU5TaQCZSzN/JvlwiWHpaXYNKFTYdO0XpllyO5NcyaJGmZhxstUQxNFC5FQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=i94iBIAd; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="i94iBIAd"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1791255734;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5cWiG6eJGXgBSN4c8Xoej81PdjyTj8pUWGToWroZ4W4=;
	b=i94iBIAdIBNYVuEJbFWbCmtJ7Ig9rtyVJaZiyETW5Pe/cDjEJY7TiVYabIPsFkvM47+lVL
	gNVz+eQxmdW8SUbaMV7uRciALvVxHxeKxp2cmRcjH5btk+KRopoyTwV5lsLB0aR5ODK798
	TvaBZDVHVlFFn9VWk4kjAiXNC4k+D1s=
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com
 [209.85.216.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-150-AWirEEJ5PomEP35pf-_mjw-1; Mon, 05 Oct 2026 23:02:12 -0400
X-MC-Unique: AWirEEJ5PomEP35pf-_mjw-1
X-Mimecast-MFC-AGG-ID: AWirEEJ5PomEP35pf-_mjw_1791255731
Received: by mail-pj1-f71.google.com with SMTP id 98e67ed59e1d1-3a4e36d5a77so2535033a91.1
        for <kvmarm@lists.linux.dev>; Mon, 05 Oct 2026 20:02:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791255731; x=1791860531;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=5cWiG6eJGXgBSN4c8Xoej81PdjyTj8pUWGToWroZ4W4=;
        b=YuhrAtdcJSmfxpWFVuTSoq4M1NYNCjeDDeNnrm5aP3KL3aK1o9nls/42mV5gA1q7oo
         1wGphCSZXs1YEPHKEOik/WLjypfUrlIt9T8xVGfKqHVW+pvSmsX25iGeJz2xuvBLwbdF
         wkh94PS+FUT47Nvl0UvcKmGoFY6aB1l6BfC2bZ4uim0zFY0d50QJImZgheGNrljBTmAa
         orxcpGn6fYFNt+utLReOCFTJTMek0Lj/LLj6G3H3SgVNCGAK/SUb0wlY/kMMMYeR5UzE
         4siTgnnqVO6vRI2XACKC8dRfFsDROmRxzujqWI/l6in2X8G8fqLTl8fWZm97lx5Ifjl0
         o4VQ==
X-Forwarded-Encrypted: i=1; AKwUvBywLVGsDtu52Yg4uWssqBpEK75KAcu8meIROcw11ZlI5gCF4E1aft88G0txgTsIOGvzQVbwr+g=@lists.linux.dev
X-Gm-Message-State: AFq9FYKA+BGJwJrkZacoHhqbHNIS027IvYOrudClIFbeyrTDTvrXchiy
	tqDyosvEIxIH7Y5mgmpxZOqaJ6UqfOG5VfMlvmB2yUQfWHEh3vIRQI6v3plSXH+hqyuP3Qy1V45
	7GVt/FXN7A5bC2ZJ3O9sn76Uojc/6zBNJQXKPwYGP3wVd4FDbptQxtkyAVw==
X-Gm-Gg: AYBFou1w2cx/o92/V9yfZWKTBPZbMloWaUO6uOSl0XeL6ZsF9NYyxGxnps648J/JG5j
	I5PZAM+yZe0IfMLztYqA2QO0iZkVYRnX2ENh1YbVqamyKRp+PuOQIF2kUyw3Y8wh7Q70zUDoKnE
	kUfPsbq67szLaX9Xfui2H0bOCTHVkODGRLD/ayLJENg1gRowetKzY3LL50FNTIZOxBQSMW8FRFI
	/4VAVGRVTspaUHgMAMfP/3oDrCSRIaEFPQKCFjgG/L8xeZ3rwJjVmc/1UtoQFwnc7NnXaPXgvmZ
	GAN13th+XY8edz1soOGy/KJodGfoVym9XNFG9EeiHq7GspXXP2ifJpuTQ2eRYZEggmOs2KrkBkO
	xxBVC0Czmq8fpjFrB2SAjJTQdOtyWoPpKSVC/poKdcw==
X-Received: by 2002:a17:90b:5483:b0:39e:345b:3322 with SMTP id 98e67ed59e1d1-3a873515234mr14422a91.23.1791255731424;
        Mon, 05 Oct 2026 20:02:11 -0700 (PDT)
X-Received: by 2002:a17:90b:5483:b0:39e:345b:3322 with SMTP id 98e67ed59e1d1-3a873515234mr14387a91.23.1791255730940;
        Mon, 05 Oct 2026 20:02:10 -0700 (PDT)
Received: from [192.168.68.52] (n175-34-8-244.mrk21.qld.optusnet.com.au. [175.34.8.244])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3a851630206sm2440345a91.0.2026.10.05.20.02.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 05 Oct 2026 20:02:10 -0700 (PDT)
Message-ID: <7a9f554c-f39a-4423-a84e-a4766c7223ff@redhat.com>
Date: Tue, 6 Oct 2026 13:02:00 +1000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v22 12/23] KVM: arm64: Use a local kvm pointer in
 kvm_handle_guest_abort()
To: Suzuki K Poulose <suzuki.poulose@arm.com>, kvm@vger.kernel.org,
 kvmarm@lists.linux.dev
Cc: maz@kernel.org, will@kernel.org, catalin.marinas@arm.com,
 linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 steven.price@arm.com, aneesh.kumar@kernel.org, oupton@kernel.org,
 joey.gouly@arm.com, tabba@google.com, yuzenghui@huawei.com,
 linux-coco@lists.linux.dev, gankulkarni@os.amperecomputing.com,
 sdonthineni@nvidia.com, alpergun@google.com, fj0570is@fujitsu.com,
 WeiLin.Chang@arm.com, lpieralisi@kernel.org, enju.kohei@fujitsu.com,
 sudeep.holla@arm.com, jonathan.cameron@oss.qualcomm.com,
 Fuad Tabba <fuad.tabba@linux.dev>
References: <20261005090754.2140522-1-suzuki.poulose@arm.com>
 <20261005090754.2140522-13-suzuki.poulose@arm.com>
From: Gavin Shan <gshan@redhat.com>
In-Reply-To: <20261005090754.2140522-13-suzuki.poulose@arm.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: rVcg0TzmAhbl3k6NzOgHHmHNO4Qb8ZdruGaayNvh7cs_1791255731
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/5/26 7:07 PM, Suzuki K Poulose wrote:
> kvm_handle_guest_abort() repeatedly obtains the VM from vcpu->kvm.
> 
> Introduce a local kvm pointer and use it throughout the function. While
> touching the code, fix the missing whitespace in the
> kvm_is_nested_s2_mmu() call.
> 
> Suggested-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
> Reviewed-by: Fuad Tabba <fuad.tabba@linux.dev>
> Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
> ---
>   arch/arm64/kvm/mmu.c | 13 +++++++------
>   1 file changed, 7 insertions(+), 6 deletions(-)
> 

Reviewed-by: Gavin Shan <gshan@redhat.com>

