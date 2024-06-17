Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5291619581C
	for <kvmarm@lists.linux.dev>; Mon, 17 Jun 2024 12:29:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718627379; cv=none; b=khLxpgFNVYaslTOdrcOrtEz4DnXYr4iLCN5gfLfQwZvnp5YMtkP4SK3shL8LqF9q0toK2gT+4Ub636qVJutLWP5yEAEBj9EuhqWdKt5TN/2VhQkrPghpcJ/DNJTPtXiJPbCWtYBpFpA7KLIGBCK8JlEFkzoHp1hrVoa3tZ8zxpw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718627379; c=relaxed/simple;
	bh=oXXpiunHz1XPLIz1naFMTm6sFnP7b0TdXzOlcK0P/sM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=n0pNITLcOuD0bh7UVJ/7HvaTMyg5DkmbgPZ3rTVPFYb763bsHvEyr+S8X0vBlQ/zHfKlVCkBN4yKdSsApAALhbojaMdyKpX1dFLOqrmMNff49d9oYA9BdotAzlsbzrayoZoHs7NKSckAe2F4HUJx4LZdsKf31VCr3wHkBhbvkEc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=DcWoFZSz; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="DcWoFZSz"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1718627377;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=I4ssGu5P5LE/MFN4qx06ygb2gBN8nmvpUBOwBXD3IEM=;
	b=DcWoFZSzasaZNre7P6gjKmkVr/10b9YpU4oHLXk8llZzkuTYL7r8EQdssQVcksIlb1445o
	zdAeL9bRFgclKcypaaZZMsU1fCL/gYQeBdxHEdfvghxPCMVL+6JMInyGcElp7Jv2Gd4XN5
	TrO6kk5bDvFlzHUrnzKMtbfDJ3SAccw=
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com
 [209.85.216.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-16-EEInlNQwPuKLZnKDNzUzyw-1; Mon, 17 Jun 2024 08:29:35 -0400
X-MC-Unique: EEInlNQwPuKLZnKDNzUzyw-1
Received: by mail-pj1-f72.google.com with SMTP id 98e67ed59e1d1-2c5289526dfso302022a91.0
        for <kvmarm@lists.linux.dev>; Mon, 17 Jun 2024 05:29:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718627374; x=1719232174;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=I4ssGu5P5LE/MFN4qx06ygb2gBN8nmvpUBOwBXD3IEM=;
        b=dZhZLUjN0SUHKa/w1xKvQVYbDs8Fh7rENpYb2Z3di5PPpSrYEd6ONUhsfysLWiOoPP
         7exozYrs5+E+bpGxbQ7I3xyQGqKgAvq6tqySmHTUnbj6Y1a0DVeZ32uB0RF/UZY7wg2v
         TdoLgQ3OTS9pVrKxP3S9NDpB8oLN7wBJOMhiT1U+6TEO10Bd1hYg4t/LyiBlscozC6Hu
         9+whS2IY7yM8Pk49XayJC7NBy/UeEk4hY/fRfCJUBcf4WGYhHXecOhc4Ld3vRNkgmWUl
         4NVuq38NA2OPAHtDPL35GzrWcl0JX6/JKpvKxNZnq+xF6/JTVo2aUQ8Rl9HgIHu/7Vp9
         QBYw==
X-Forwarded-Encrypted: i=1; AJvYcCWwnTCzPvmeMiGzfrQDllP/6KgLd1aGov0pJncb95EPTe7wMQSwicpAoRokI7gYJKiO23uQv2O/9+oaa+cm60O2t1VFg+iD
X-Gm-Message-State: AOJu0YxfacE8mscMYbe/LmGk8gA7ALetbO+qPwIrk7Gw0buAI8D+kP1a
	rQhNZ3fufU4xkPs+nWdJ3vAVllNKTrGnJm9aiIA64JjOg/knefr9gTvpMoQpR+VTihSQ9nHLwCM
	GVTU5r73ixgPmqCCpYTaxkK/CvWsa5aLKt4pXk2ROd0NbxkMcSK6F0A==
X-Received: by 2002:a05:6a20:5aa9:b0:1b0:1be7:3708 with SMTP id adf61e73a8af0-1bae7e3d928mr8545367637.1.1718627373419;
        Mon, 17 Jun 2024 05:29:33 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFOU5fYRtot9iBJXy2SS9IX2XSkrNEwI68apkvLYUeP2Vlv30jHjv3k+GFqCmYhxr4fz+B5Wg==
X-Received: by 2002:a05:6a20:5aa9:b0:1b0:1be7:3708 with SMTP id adf61e73a8af0-1bae7e3d928mr8545338637.1.1718627372892;
        Mon, 17 Jun 2024 05:29:32 -0700 (PDT)
Received: from [10.72.112.55] ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-705cc967356sm7261218b3a.63.2024.06.17.05.29.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 17 Jun 2024 05:29:32 -0700 (PDT)
Message-ID: <9db95188-71c2-491a-a4c7-434e7cd3c407@redhat.com>
Date: Mon, 17 Jun 2024 20:29:26 +0800
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v1 0/2] KVM: arm64: Making BT Field in ID_AA64PFR1_EL1
 writable
To: Marc Zyngier <maz@kernel.org>
Cc: Oliver Upton <oliver.upton@linux.dev>, kvmarm@lists.linux.dev,
 Eric Auger <eauger@redhat.com>, Sebastian Ott <sebott@redhat.com>,
 Cornelia Huck <cohuck@redhat.com>, Catalin Marinas
 <catalin.marinas@arm.com>, James Morse <james.morse@arm.com>,
 kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
 Paolo Bonzini <pbonzini@redhat.com>, Shuah Khan <shuah@kernel.org>,
 Suzuki K Poulose <suzuki.poulose@arm.com>, Will Deacon <will@kernel.org>,
 Zenghui Yu <yuzenghui@huawei.com>
References: <20240612023553.127813-1-shahuang@redhat.com>
 <Zmkyi39Pz6Wqll-7@linux.dev> <8634pilbja.wl-maz@kernel.org>
 <7f1ca739-42f5-4e3a-a0c9-b1eac4522a97@redhat.com>
 <86zfrpjkt6.wl-maz@kernel.org>
From: Shaoqin Huang <shahuang@redhat.com>
In-Reply-To: <86zfrpjkt6.wl-maz@kernel.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi Marc,

On 6/13/24 16:42, Marc Zyngier wrote:
> On Thu, 13 Jun 2024 09:31:45 +0100,
> Shaoqin Huang <shahuang@redhat.com> wrote:
>>
>> If we don't care about the FEAT_CNTSC right now. Could I fix the
>> compile issue and respin this again without the background of enabling
>> migration between MtCollins and AmpereOne, and just keep the
>> information of the different BT field between different machine?
> 
> As I said, I think this patch is valuable. But maybe you should
> consider tackling the full register, rather than only addressing a
> single field.

Yes, it would be better to tackling the full register. I will put more 
time on other fields in the register and try to making more field to be 
writable. But currently I just respin the series with deleting the 
machine specific information and fixing the compilation issue.

Thanks,
Shaoqin

> 
> Thanks,
> 
> 	M.
> 

-- 
Shaoqin

