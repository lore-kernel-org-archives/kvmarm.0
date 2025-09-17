Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE1C42F99BC
	for <kvmarm@lists.linux.dev>; Wed, 17 Sep 2025 17:56:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758131783; cv=none; b=pvMctY4LclgXQX4GuL6LWkxPvulDbl2NZnOMBI3AcIJ/aN3nZkobZdCvurcX9P/uM1SguPbvGDUR0y4NtfpLBspvX78Gp0mNRZrd2Xu+vo23DXKyefNARlsldq4ljbiagdefaZpW1ipNgGSjML6NR11sObhTcssiSMS4JPHcig4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758131783; c=relaxed/simple;
	bh=oPkyEQThPJkZXDMJMqwLN+MXKminswUTWH1q3gWVLhE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=AwHbsu9cnn+TcOFUO3egpGSLsGvsN5bH8O6Q5cVTzqoyRkefuvj1rJfSYZoT9i9S4qTYtT0g9HNXjM6PDzjkgFsx5IOxuaEdwRbpUse01Jp1QPtR9Jd/WTvTxfbNsJZwMuEfMNdBK8adkpCV/JKlBfZSjIIzL77g7f9QCW+lIwA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ivVjtMmK; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ivVjtMmK"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1758131780;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=o97Jkb44CguUDtzud8LMwc46TxzGlvMRMvZas4PSbL0=;
	b=ivVjtMmKBaJu+7UWlAbLmdv7Tg5hLHFCXIOL/cVXoIWlcujwANUpaGeliLR8YBkTDO05Px
	f4KEUZmGYNGch5kKZvLxwkkYyzz47vhmSQX8giqFRQtQNzK1n6OTD8r4WcDGBFkTvZVcB0
	VBxvi7Kdq0pFalB1XCTCG+/ELuj0nBc=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-479-4vmk6hVWMUaYqSEYGbC-Eg-1; Wed, 17 Sep 2025 13:56:19 -0400
X-MC-Unique: 4vmk6hVWMUaYqSEYGbC-Eg-1
X-Mimecast-MFC-AGG-ID: 4vmk6hVWMUaYqSEYGbC-Eg_1758131777
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-3eb2c65e0d6so3263f8f.3
        for <kvmarm@lists.linux.dev>; Wed, 17 Sep 2025 10:56:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758131777; x=1758736577;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=o97Jkb44CguUDtzud8LMwc46TxzGlvMRMvZas4PSbL0=;
        b=kdaAPV3cfWZo0jMvXjSvCLDFz4GPRNcLRhnIQNm0xe8Qi99jnUJltAZlQnpK2aIEnf
         94Tq42M92gDBVkbjC6/K2fOQvI4+SRNJsZDmUM5zhKWtw0Xv/aQtGylis/j24UHA1mFi
         OAJ0LbOcRl5GWdkvoKY4SpTrN8O2tF777Z3zJ7FbfQ00qaWgGYhPYWSwGbaxhdEaYLCA
         FGgATd32O2kYrEwu7kOutHdZ2Q62AjqHRHysactLTkYeC3/oD2Qs8TbuJXYQgz3z3alV
         LIf5MkuBhB+Oqm7E4LkQWDAea3WQh3Ut1CNNbVQFn7dbp+yo/gT8LktpZ1eotCR77ctx
         bOUg==
X-Forwarded-Encrypted: i=1; AJvYcCUbHIwsyibU8usOhjPOaQvl0E3CxK6ChsRBEBHQkGwsRoMPGYPQe8WTIu6fPhanTosgTtcZKUY=@lists.linux.dev
X-Gm-Message-State: AOJu0Yw1BdwcdmB+glYFMd00Mil84qV2lBRCtbXe9IThsG8Nculuykk9
	GowYyYRs1QqM4iHz9+6FUKAM/MFUjZuawyAgahdNh1gXkJw+QFEpg4TLY/rg0JZMVOmq1i3Vz0b
	Z4wRaBC8R4ogcCYDLrKojkv0ZsFBIv6gZoQAurdlmAxNAk7DSjcUsGnRydg==
X-Gm-Gg: ASbGncvXCBzL2bU5WBZlN2XNlITeO067CvgB1VnWyxBQco/Aph1BRZNT8xJD10ZQFZo
	8m0K5Kxlhn4OU4xyxfrMUIw48TWZ3kDk/SXtVQ2Wc7DNFHn+5INPQA01DsNUpjzsd7IM0T7Ak7a
	uyn1bZk2IHV9LfX7biBLZJ+eT9ldm6Q8a0INY7RA82147osQZmCvAXP3WOx95/bNOOEFQ7jXtt8
	l/B7HAiUVg+0AM4SmJwYxCjwh7A0UlAP/vmZ6sYaFVdKvtQtOqi/WE9n8hKRI4wQ6PRhp5W0Vnl
	PSk66zSkPRWolHMYVD8C9sGqCJBCkLUQ6HbZDIsZwgrvYJDR/CGA4h/ujAil7dCKmr9XTeUZGNK
	Tf+VQr/eVtJC4C4fHF9kPbs+FMdDx/EI0DFIFoLnllJY=
X-Received: by 2002:a05:6000:2512:b0:3ea:d9a7:43e4 with SMTP id ffacd0b85a97d-3ecdfa3f455mr2881661f8f.53.1758131777414;
        Wed, 17 Sep 2025 10:56:17 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHtBAYP2GIwzz3bV6tNJV/6G8FSBl5qdvliPlMhUc/LxJ9XtvD0KciFkSa9CHP0G+pZLVonIQ==
X-Received: by 2002:a05:6000:2512:b0:3ea:d9a7:43e4 with SMTP id ffacd0b85a97d-3ecdfa3f455mr2881644f8f.53.1758131777016;
        Wed, 17 Sep 2025 10:56:17 -0700 (PDT)
Received: from [192.168.10.48] ([151.95.56.250])
        by smtp.googlemail.com with ESMTPSA id ffacd0b85a97d-3ee0fbf1d35sm253196f8f.55.2025.09.17.10.56.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 17 Sep 2025 10:56:16 -0700 (PDT)
Message-ID: <6e598aec-f55c-467a-abef-6d183bb9cfca@redhat.com>
Date: Wed, 17 Sep 2025 19:56:15 +0200
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [GIT PULL] KVM/arm64 changes for 6.17, round #3
To: Oliver Upton <oliver.upton@linux.dev>
Cc: Marc Zyngier <maz@kernel.org>, kvmarm@lists.linux.dev, kvm@vger.kernel.org
References: <aMHepH8Md9gSu2ix@linux.dev>
From: Paolo Bonzini <pbonzini@redhat.com>
Autocrypt: addr=pbonzini@redhat.com; keydata=
 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
In-Reply-To: <aMHepH8Md9gSu2ix@linux.dev>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: NbMVKUrp1nIrixOBAl14CIzInAgnNgbPFLHL6KOlGaA_1758131777
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/10/25 22:25, Oliver Upton wrote:
> Hi Paolo,
> 
> This is most likely the final set of KVM/arm64 fixes for 6.17.
> 
> Of note, I reverted a couple of fixes we took in 6.17 for RCU stalls when
> destroying a stage-2 page table. There appears to be some nasty refcounting /
> UAF issues lurking in those patches and the band-aid we tried to apply didn't
> hold.

Thanks for pointing this out, I will put a note about reverts in my own tag.

Paolo

