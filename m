Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8545143736
	for <kvmarm@lists.linux.dev>; Thu, 12 Jun 2025 04:57:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749704223; cv=none; b=PtOnP+oIctmz265AHVNhy6yLud/2HMiyFZneVTnVj36trcyFqrvuVMykV7OdRCaIDICM0OU2uus6b1rrmYSwaMIhJCPu4PoM3PWavzwpXK4GxlydKLKZv5diiRGLr2ULBvJpfGQBO7PbFeIcPH6lLMQsrCjRvnCJCjmEmMeo5RE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749704223; c=relaxed/simple;
	bh=+Bgnjkb3c2VvMjqkkvwRWSiFw1ERPOMXEXq8Lh/tg10=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=B1JeugJ1ZDBD+fJBs2cRCoTa5NftcQn+jIzyyXzSMRelQsc2QbYZZZJDQRIc/eXOeWxhkAoKHG/RfEx69uUFUAs9hY03yQ/ZA/WoEyb+5JC4eCDNKj75TgPKYeWfCuFmD/hsBTyqpye3TkfaxmCgouIpblajtCSOPtG2eEE3lBU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=V7ViIpFG; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="V7ViIpFG"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1749704220;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=fRcG0KcLrgIKRqjpg+vBPCK7hgCWz7pFJk3ogI8plXs=;
	b=V7ViIpFGMYX+7qtQcZVT1L30yJrDdMsbo0MS/W0rG1HJgrGuQmK1Wzc7N+CACXL9b94jzB
	Ugkd9kdzw/tMbl4assG+NYAsvUp7baILbXE5iSTctJMXqh1PEsuxlev0Dcgp61J9KrMt41
	vy7QXY+dlboUIjiekVbjmF7WqlPdd8g=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-423-kmTrbTWBOwqgXRWLSmjWsw-1; Thu, 12 Jun 2025 00:56:58 -0400
X-MC-Unique: kmTrbTWBOwqgXRWLSmjWsw-1
X-Mimecast-MFC-AGG-ID: kmTrbTWBOwqgXRWLSmjWsw_1749704218
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-450d6768d4dso2289045e9.2
        for <kvmarm@lists.linux.dev>; Wed, 11 Jun 2025 21:56:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749704217; x=1750309017;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=fRcG0KcLrgIKRqjpg+vBPCK7hgCWz7pFJk3ogI8plXs=;
        b=ViRUbRLE9qerhdy/oW3hT203ysZpe+xnj8ohEfb3y+YhfLUHIV42n7GZk6/y1wL1zP
         N8jPVo/WLFNVxnVn6HD29h1NaaBvXprZd3UBhhZcoo0v19y9+mU3u+Su+7m2oGykrkDV
         iIdqtgFbNdnoC7NQXjlsEvi2xzx7UQoflB3KQGKGv6xQyL+6BBeyAF4jwmS+gG3SLaXf
         V+oUMoKzbxuYIMFarQHs4COJxWYgIKUqEG0J57+v8X08NGScUubzlrI1nwwy5y9GpRoy
         as9KwsvRvbFTGlaxsByzTqJpbTwHlAe5cZmRKEuBAs5LXRnbr93y5IFPK9mdAbmtovbm
         kf6A==
X-Forwarded-Encrypted: i=1; AJvYcCWS0ccLB1keATa9n1ebf2Vf1+aqfIP34n7gbgiPtoklteSlh39EBPglQQsi+pz7d03SwmagBHw=@lists.linux.dev
X-Gm-Message-State: AOJu0YzM+4P6Z2vbmNDOc7Am7nyl29xGE79oQARPcd7V92SYMWNdUcEY
	H5rxUizoLOdsWZGXOIGENOYtX4ch4Rj4EVkje39vKpIYwJyuI5YxywTbnRdGwQG/iIyh8hI/dCE
	eglBdOG7zSSL3Kd/xF8hGrpEE8bli1mtbvGdZ816IJaM9ph+JtAVmSU1Ozg==
X-Gm-Gg: ASbGncvcrW1K5vg6E4tSOVJAup+rCN8+lpRqrFuaudj/L8jTTQ/3nOw8DMQ2dayvu1V
	kO2CIbV8x5Ah+wm5VS8KcEYhgPq5eJGPPFl9Mdazcc3Nu9E9016zNhphMOhFgn63MXQyQAYvL+/
	sBusMGH95HanG+PE5Wvhn9VVj7sXRGzjlwwZH3mFTfSmLsgmg/+qTtjBginX2owHoj74uk9/9Ph
	Mb+af8N+yhIPfkfIq3Ks9e05F3HWUW5is3LU8/VrPhrulvEvj4hmsjB4ylBxS+6z591XHeGInAr
	nTVvtXmGpICSKx9yE43TyY61
X-Received: by 2002:a05:600c:4f55:b0:450:d07e:ee14 with SMTP id 5b1f17b1804b1-4532b915f13mr24022755e9.17.1749704217618;
        Wed, 11 Jun 2025 21:56:57 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFMnYNz9h25utVqlZtqMz+bJcwU577Begx0eWXz015Y6jivdb/FnjiEwBApKkKMSt+HJpyllg==
X-Received: by 2002:a05:600c:4f55:b0:450:d07e:ee14 with SMTP id 5b1f17b1804b1-4532b915f13mr24022465e9.17.1749704217256;
        Wed, 11 Jun 2025 21:56:57 -0700 (PDT)
Received: from [192.168.10.48] ([151.49.64.79])
        by smtp.googlemail.com with ESMTPSA id ffacd0b85a97d-3a56198a3b4sm816727f8f.21.2025.06.11.21.56.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 11 Jun 2025 21:56:56 -0700 (PDT)
Message-ID: <125bfa5b-4727-4998-a0da-fb50feec6df6@redhat.com>
Date: Thu, 12 Jun 2025 06:56:53 +0200
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/8] KVM: Remove include/kvm, standardize includes
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
 Anish Ghulati <aghulati@google.com>, Colton Lewis <coltonlewis@google.com>,
 Thomas Huth <thuth@redhat.com>
References: <20250611001042.170501-1-seanjc@google.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Autocrypt: addr=pbonzini@redhat.com; keydata=
 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
In-Reply-To: <20250611001042.170501-1-seanjc@google.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: -xyHtSdY6slIzi2icJnRLsvfUhPlC2gsEVcYP5bkjnE_1749704218
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 6/11/25 02:10, Sean Christopherson wrote:
> Kill off include/kvm (through file moves/renames), and standardize the set of
> KVM includes across all architectures.
> 
> This conflicts with Colton's partioned PMU series[1], but this should work as
> a nice prepatory cleanup for the partitioned PMU work (and hopefully can land
> sooner).
> 
> Note, these patches were originally posted as part of a much larger and more
> agressive RFC[1].  We've effectively abandoned upstreaming the multi-KVM idea,
> but I'm trying to (slowly) upstream the bits and pieces that I think/hope are
> generally beneficial.
> 
> [1] https://lore.kernel.org/all/20250602192702.2125115-1-coltonlewis@google.com
> [2] https://lore.kernel.org/all/20230916003118.2540661-1-seanjc@google.com

Marc, Oliver, I'd like to commit this to kvm/next sometime soon; I'll 
wait for your ack since most of the meat here is in arch/arm64.

Thanks,

Paolo

