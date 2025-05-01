Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 229DD1E51FA
	for <kvmarm@lists.linux.dev>; Thu,  1 May 2025 03:06:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746068778; cv=none; b=V1pziEhaQvM4oSLvggcCzP/ljFRyISl7/aJOTc/8FCL2j6ZyWmRsaQhKQyhTSNRvzlZBrOIRFOJzrOQXxkstfWm8kc8bY9ZRi0i0D2E/OMiDu45kHVVMwweH3jyCUSnMrFuamQAku/ZwYxdqmbtL+ywPyZkevNxuqCNuqsGJmfY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746068778; c=relaxed/simple;
	bh=X/XhkrFmWidZvhk9MnMyADxxQYnJ6LlWfI1v/DRQrcw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=LhBUHzNRg8xPZvZFmBVG59VBVxGuZwD6ULqMLFmbGjTCIGV9kWMHquRdc3DuQOXVMOL58Fw9/LkReUGaps2V875wABqATAudN+wmH3THk5aLw2Wa07qGxKFF6CZX5Yf5oCCpKo4ixl62VO7TUniCssOWn0pdgdVlivqb474QAGk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=h8qZTEyT; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="h8qZTEyT"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1746068775;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=zBUyB0Q8zMsFcB5UcneuetEe4xDQ4aVw4JfTOnTTULU=;
	b=h8qZTEyTzTw+YYY8eslPvuH5rrC4cuty3NrDHRkshHBZBJBjUG7jD3bCtB1m0Aliqn1rrf
	5xyqgjAbf0ueyuOSAj4RHJr2rnI2Aiinv3Zq9aUs6IWGmMzvtfbE//qbyw1AhclVMw0Zid
	ZLcvkCni2fczSvp2ee5tOjwBNGC4pOM=
Received: from mail-pf1-f198.google.com (mail-pf1-f198.google.com
 [209.85.210.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-116-Pl_oXIeSOLaZYlm29oNiNg-1; Wed, 30 Apr 2025 23:06:13 -0400
X-MC-Unique: Pl_oXIeSOLaZYlm29oNiNg-1
X-Mimecast-MFC-AGG-ID: Pl_oXIeSOLaZYlm29oNiNg_1746068772
Received: by mail-pf1-f198.google.com with SMTP id d2e1a72fcca58-736fff82264so440558b3a.1
        for <kvmarm@lists.linux.dev>; Wed, 30 Apr 2025 20:06:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746068772; x=1746673572;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=zBUyB0Q8zMsFcB5UcneuetEe4xDQ4aVw4JfTOnTTULU=;
        b=TXWSVK7OAy8Hs9fIesSykmv5UPcMYb9oWfQBK4IjgOX2+2PIEYyINFrlHu4nQE+7rQ
         G/UKhYTBc5R52KO1ywFDqWUgsrQG5/awOcNdHMfIsJKolGvfq2gKL2MYPMYj341sZfsq
         Q2l2DU6ggZnrPLwS+BL9xJHogz99M5rdPvBvoHHo2K9+PljwQhJzCyR5SEpen5J7RdB6
         PFSdoL5L22fIpZwPkN4Isn1NRr4syhh6YcyYs2ucULbuy0OPP+USmg8JzKUfN4/IZ43u
         0n218xF1o1sd5XKz53SBBJwmiquDj9SysxE8lFiDT4mQm/22dXZJgMj5s65a+BsQBrv+
         PE0A==
X-Forwarded-Encrypted: i=1; AJvYcCUmIyeJmzoDViGFfDnwAZZoSnd6DZPc3tA9UES8ssrhCGIAe6V3TsHo4BhN08qpbeDOh7kAslo=@lists.linux.dev
X-Gm-Message-State: AOJu0YwTkOnihgNGRvg908DyQFLmZ1UL3qjwAEAbs/Y0mkfwu5fyKybg
	bxivXwaZhjm+Rqet+y/vO0Meswipp/Z727K8dtx0DcFVjmaKp9r/BT7OKFkuzmgb46nc/zXWphE
	nxbDzaRD+qIDPgmThjc2QkNR8vz+OKUrrk/B4L1p4ar8pl43V0wnjEw==
X-Gm-Gg: ASbGncsp1DjILjmDHfoQf4htG6OLtFymAfrEeAfS1pAoXUelX5qTprnyg8z5sPpQ3qk
	USk/J//dLE4lQN2XTbo/39s+9aIuXBdNmfVgf1OkNsBC3TIJFpQ47hwkiF39nfIl0uurKwpueoM
	/Utg1sNnsTRewOLzZ6iM6RWg+AaYK9i0oedVaSmTrGUWMiJc5UGLxHgx/u3My6UiPC3gVKNkg3C
	wv6+y0k+KTAeXF4nB30H2AgQX9IyqyeJcpWbEo4cd6I92YDYUL/KwNFQRMv8auHktYOXtR9oTMQ
	ZFsbmmlEJQOX
X-Received: by 2002:a05:6a00:35c8:b0:736:bced:f4cf with SMTP id d2e1a72fcca58-7404927930fmr1444812b3a.0.1746068772424;
        Wed, 30 Apr 2025 20:06:12 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEqFyaQqRxd5YG/d2aF2wgTwFAOyBR0cwvIicbDZqnls7TSQ0mJMT278uEe4KH0+EWzXzgDGQ==
X-Received: by 2002:a05:6a00:35c8:b0:736:bced:f4cf with SMTP id d2e1a72fcca58-7404927930fmr1444772b3a.0.1746068772121;
        Wed, 30 Apr 2025 20:06:12 -0700 (PDT)
Received: from [192.168.68.51] ([180.233.125.65])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-74039a600a7sm2560107b3a.130.2025.04.30.20.06.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 30 Apr 2025 20:06:11 -0700 (PDT)
Message-ID: <8a21a392-5ae6-4d55-905a-0956f48853ba@redhat.com>
Date: Thu, 1 May 2025 13:06:02 +1000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 43/43] KVM: arm64: Allow activating realms
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
References: <20250416134208.383984-1-steven.price@arm.com>
 <20250416134208.383984-44-steven.price@arm.com>
From: Gavin Shan <gshan@redhat.com>
In-Reply-To: <20250416134208.383984-44-steven.price@arm.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: p77_cXhFXrc7SRelX1wX4sRSw3FOeVtLvTIaCrT_Wg0_1746068772
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/16/25 11:42 PM, Steven Price wrote:
> Add the ioctl to activate a realm and set the static branch to enable
> access to the realm functionality if the RMM is detected.
> 
> Signed-off-by: Steven Price <steven.price@arm.com>
> ---
>   arch/arm64/kvm/rme.c | 19 ++++++++++++++++++-
>   1 file changed, 18 insertions(+), 1 deletion(-)
> 

Reviewed-by: Gavin Shan <gshan@redhat.com>

