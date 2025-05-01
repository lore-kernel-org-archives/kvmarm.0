Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAD8F1EB1A9
	for <kvmarm@lists.linux.dev>; Thu,  1 May 2025 03:50:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746071425; cv=none; b=hMOASvIieZrV4n/l5UNmVmTYEY2PG4OaGXqEwEbs1hGxPDEHzH7yEPRshH6yKRnPaI9rpVBNJ4aaCsSWBYTkEDW0TzWePZ1QBb37ch2QF69pXSxFrLOmLT9UgaX9FTJ/UDe/F70opG8Ya26HV9URRSl4461aYgycXhYAVFDbEj4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746071425; c=relaxed/simple;
	bh=PO+3BQsPIF+4e0+asMRXeh+QLcIUVpdmgRa7WCUfcr8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Nlaxz6EqifEkYCt2pYEmiq44qugPwzlufBaYbMmabypbYa79USZ+kI+ioAL9GaxMww6T3zIGdNqwJP1QTlr5kv5H//+nN7s92vXZagSr8NIBR/bJuhBadXZaPcs9hlWNlK1FrCfaeuM2xBfxKGpvy7aIpY4U6CZjpcfT/Ytu52E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=VvtVvuRn; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="VvtVvuRn"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1746071422;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=eCg3VHmOtxCvew5eYi3QzhfJ1vb1uNXc4Xa6k7JPpko=;
	b=VvtVvuRnXUp04++ObLq/ENJatsQKtnlZsf/uo3WSQWZINGiYKUCRfKCGriOFtztSDo/Dfw
	QED4ZIDmRM4RRJ8nNoI3P73z1hUmjfC5TAPIXnimrxXVipznwMuXeeQxKMfAQMasxG2cj7
	tRzelyQ/5M+X095A+kBIwCEUJCnj904=
Received: from mail-pg1-f200.google.com (mail-pg1-f200.google.com
 [209.85.215.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-375-tb8waSIINLmeMUKzCNe35A-1; Wed, 30 Apr 2025 23:50:21 -0400
X-MC-Unique: tb8waSIINLmeMUKzCNe35A-1
X-Mimecast-MFC-AGG-ID: tb8waSIINLmeMUKzCNe35A_1746071420
Received: by mail-pg1-f200.google.com with SMTP id 41be03b00d2f7-b16f5365310so357707a12.1
        for <kvmarm@lists.linux.dev>; Wed, 30 Apr 2025 20:50:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746071419; x=1746676219;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=eCg3VHmOtxCvew5eYi3QzhfJ1vb1uNXc4Xa6k7JPpko=;
        b=uH1MFdK2932ZHAdtYmxCUzZxsHQs/Tt2nz2uQHEx8+DqoyTiK1Evc4tK23hEtHNI7K
         UjBs2CzkVSrgr4xcdkw8nKQYIZ2//bs81OeAZJQRrG/ovkl3awCjLEN7zqyPJ2gM4i3H
         xXXUzGZoGvmJ7YHvZCzLfXtYdi4JuR3SAjGIZG2Q2aymi13vrhbrTJSP8OZV9Hzq7a8S
         ZOwSVnl7lxpA4KGoDg4ggYKw/GKreFU0uR1E9OSDbK3/27kofbO/nsRhqxs/dHWBlwsZ
         BG6TQAJxadw1y5CpP8o8d/ljn7VWPYAKrHAtvabwGIBWgX69HMUchIRYVrF0tUfxC0/X
         f3eA==
X-Forwarded-Encrypted: i=1; AJvYcCVHMemFgAQCRPpZCRsFjZPRGW7yq/yWuFgwBLaJWOTkWCXyvDZA1NL6E1UQwcT0FW6m+/PfEFY=@lists.linux.dev
X-Gm-Message-State: AOJu0Yzm9YRlHEE9CvrB/UFcErYiTo0CZfRU2Jai5avde30AV7ecFWT1
	YQcy1miD8E0tZOJlTG65uTjzX6K+6UDRplJ0el38iv07aXL5IUuUv6sUOXecp8JsdmwX+rxJUB4
	o6wwYTX/mmb4LIj4U1w2STI40LmrRh8GZ2hzPyd3cVvt/dIsAd6v11A==
X-Gm-Gg: ASbGncsY34DJOpcvsTHYOEBOi40KGjJ9iB/jQV8EGCMY8rgrhfU/Xk5vSHbv39QbFzN
	mWupndivo5XjNCbx7DQe3eYEpMtyXnobP1c4gWM1dF7UskwvlvjgQ44RKU1WQhw9/U+A+rL1SRY
	TyZcPBBCFGifzcThLRz+TC0rjKkvF29mW0DyeinKxcsp5tuuEHv0jimF0sLFYLdukItMsj65NFK
	IHWUJ78kZIBlyweaIjNtDcEWNUa2UgK/sqTNq6i32MlbFAjiD/GObNDYjq74Myde2zJ8xB7D+MX
	bjM7xKYphiTA
X-Received: by 2002:a17:902:ce82:b0:224:e33:889b with SMTP id d9443c01a7336-22e040bf632mr26267675ad.12.1746071419636;
        Wed, 30 Apr 2025 20:50:19 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHjGXYl1nbElt//Y7QO+1qgJyi9H/AWK7L3Z8v+0R5cqVKw1fIlymBvwS8voAmkMjppWWC63Q==
X-Received: by 2002:a17:902:ce82:b0:224:e33:889b with SMTP id d9443c01a7336-22e040bf632mr26267185ad.12.1746071419220;
        Wed, 30 Apr 2025 20:50:19 -0700 (PDT)
Received: from [192.168.68.51] ([180.233.125.65])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-22db5100c70sm130601505ad.166.2025.04.30.20.50.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 30 Apr 2025 20:50:18 -0700 (PDT)
Message-ID: <b10f429b-7009-4399-966c-430ad1e02d05@redhat.com>
Date: Thu, 1 May 2025 13:50:10 +1000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 37/43] arm64: RME: Propagate max SVE vector length from
 RMM
To: Steven Price <steven.price@arm.com>, kvm@vger.kernel.org,
 kvmarm@lists.linux.dev
Cc: Jean-Philippe Brucker <jean-philippe@linaro.org>,
 Catalin Marinas <catalin.marinas@arm.com>, Marc Zyngier <maz@kernel.org>,
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
References: <20250416134208.383984-1-steven.price@arm.com>
 <20250416134208.383984-38-steven.price@arm.com>
From: Gavin Shan <gshan@redhat.com>
In-Reply-To: <20250416134208.383984-38-steven.price@arm.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: ot20frmLTljifgA1PTZTLIb0BPCR93mAvwvLWypHUmA_1746071420
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/16/25 11:41 PM, Steven Price wrote:
> From: Jean-Philippe Brucker <jean-philippe@linaro.org>
> 
> RMM provides the maximum vector length it supports for a guest in its
> feature register. Make it visible to the rest of KVM and to userspace
> via KVM_REG_ARM64_SVE_VLS.
> 
> Signed-off-by: Jean-Philippe Brucker <jean-philippe@linaro.org>
> Signed-off-by: Steven Price <steven.price@arm.com>
> ---
>   arch/arm64/include/asm/kvm_host.h |  2 +-
>   arch/arm64/include/asm/kvm_rme.h  |  1 +
>   arch/arm64/kvm/guest.c            |  2 +-
>   arch/arm64/kvm/reset.c            | 12 ++++++++++--
>   arch/arm64/kvm/rme.c              |  6 ++++++
>   5 files changed, 19 insertions(+), 4 deletions(-)
> 

Reviewed-by: Gavin Shan <gshan@redhat.com>

