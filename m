Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B7753FB9D
	for <kvmarm@lists.linux.dev>; Mon, 11 Mar 2024 14:03:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710165821; cv=none; b=OFndesJ58DLdqREWXje5A+9Jco9uS4R//ptXS39mi70iV0iLaVIFCDf1LFJq+FudYSdB4erNiOXVHXmSQ90cmBnSBp6D7mRADCNh1qL7/4/bb2DSVEjQsP7j798iLlReOQtMDfJ1144yJ9BNV30oiMHe+0UzG0T+AemJjlqCeRk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710165821; c=relaxed/simple;
	bh=uFwC0wKHNXk3x4j9pEfnsufSuDKMcsLEdD2GQK6haPk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=nwBA+EupwDy6f7dCAYMq446iQQ0pe2xBzj7I8NqJ+S40b6JYf6qdabxG6I1WBKe+yNvj0GCEsWhx0VzLLan3o6NxBBj8SGtIjU/qEu/neOCciJCoUaVlYPUf1N5+DToHgK0rxMxAiQOebPNOjAB9p/tvtHV80/EbLap0E3p99VI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=b+ZUl0OR; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="b+ZUl0OR"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1710165818;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=SpjvKzONwN1WvYedl5HUfn8KeqjVQbSv8SD0MqULuGo=;
	b=b+ZUl0ORKsBj/2mEqfyP3Q+bgsMEu2ojdM02iEvZInNQl/ryU9TK63XZqjoxQD9w7uco4P
	zwbexHIxLdAHa6rdfT6o5VHh9Q2BhNYOhZpP8Q5GNUlXMdzmJ2cE8dZ/ZRtkQpNZaIFwBs
	tdsK3wFEr0Xi4wj/NpzQS6WZM3xUcKA=
Received: from mail-lj1-f197.google.com (mail-lj1-f197.google.com
 [209.85.208.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-197-xU_LsGO2M2OEmZkOOeIkSA-1; Mon, 11 Mar 2024 10:03:31 -0400
X-MC-Unique: xU_LsGO2M2OEmZkOOeIkSA-1
Received: by mail-lj1-f197.google.com with SMTP id 38308e7fff4ca-2d2d59be640so34979341fa.0
        for <kvmarm@lists.linux.dev>; Mon, 11 Mar 2024 07:03:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710165808; x=1710770608;
        h=content-transfer-encoding:in-reply-to:autocrypt:from:references:cc
         :to:content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=SpjvKzONwN1WvYedl5HUfn8KeqjVQbSv8SD0MqULuGo=;
        b=SAyv5mGy2H4HZaXL21+/3B+EkLzg7kJ93BbxjHPGkCntjnpQnLR4M7sTgj8p9B6TTI
         PjsCDIRofVvNm91JSof0EubN3K9Qm9oGktreyzK4CHsfSOaUF1xOdmQXO3ViBa/2QYCI
         VHtTsNQvbYcziCD5wqj/qyH23eRYMpJ4vB7obH1embFmdKDOFQPoFEA6Y16e390gpLL5
         2snXVAGHbgKBwSCgTa6shl6ERWefpx87fyOOQIB6MvLXuMrVMbXqEdtnfzDn8cEf2Hlk
         pHpXrKkdjLL4ui6W1/tJOWA8tOW91o/eYmLb2ksrWADT0EYAMzzdRiwZsiBldaawCdJ1
         rXQQ==
X-Forwarded-Encrypted: i=1; AJvYcCWL7ioTnDveFzu/J7lkwVtUj3vG0GCY9FgdtghJBo+DjxNldyrmgLQmjHd6ieuHZUpJWbcT8ZDnXiqCVsD91G/KnJuU346O
X-Gm-Message-State: AOJu0YwPj/pK0VI5kajt8qDlOizlvdCDx3N86YMUBHZP8ddx+tyviy0E
	1QO94KQsjoy2mD2mVh1RHOy9+QQSdX9Lv+FshNWSS2jy07jVFCvXUHisRnfXRrrV30gfi8UqISK
	e7ptIFimUNC1zmsTd7+LCr2OfyEKorC5PdhnwcQPb4l1eZLg6nqulTQ==
X-Received: by 2002:a05:651c:14f:b0:2d2:abf0:1c0d with SMTP id c15-20020a05651c014f00b002d2abf01c0dmr3939181ljd.47.1710165808454;
        Mon, 11 Mar 2024 07:03:28 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFCA2GUDM9NamsljAMo439WsiCclbH+XYQaf2bCUMQ8lybA4XqUzWWAwlx0Cw9i8NHaUvaAxg==
X-Received: by 2002:a05:651c:14f:b0:2d2:abf0:1c0d with SMTP id c15-20020a05651c014f00b002d2abf01c0dmr3939164ljd.47.1710165808078;
        Mon, 11 Mar 2024 07:03:28 -0700 (PDT)
Received: from [192.168.10.81] ([151.49.77.21])
        by smtp.googlemail.com with ESMTPSA id b2-20020aa7c902000000b00564e489ce9asm3016297edt.12.2024.03.11.07.03.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 11 Mar 2024 07:03:26 -0700 (PDT)
Message-ID: <bf5b1b4a-dfa2-4cb7-9f86-f5565bda2aab@redhat.com>
Date: Mon, 11 Mar 2024 15:03:25 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [GIT PULL] KVM/arm64 updates for 6.9
To: Oliver Upton <oliver.upton@linux.dev>
Cc: ankita@nvidia.com, bhelgaas@google.com, jingzhangos@google.com,
 joey.gouly@arm.com, maz@kernel.org, rananta@google.com,
 rdunlap@infradead.org, seanjc@google.com, kvm@vger.kernel.org,
 kvmarm@lists.linux.dev
References: <ZeyQ5TK3pULYc32o@thinky-boi>
From: Paolo Bonzini <pbonzini@redhat.com>
Autocrypt: addr=pbonzini@redhat.com; keydata=
 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
In-Reply-To: <ZeyQ5TK3pULYc32o@thinky-boi>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/9/24 17:40, Oliver Upton wrote:
>    git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git tags/kvmarm-6.9

Pulled, thanks.

Paolo

