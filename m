Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BAA98BFB
	for <kvmarm@lists.linux.dev>; Fri, 29 Sep 2023 23:52:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1696031549;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=wbCRLqs67uOHonUW6wA0vdzT3otLZZXvFL4oPjvAtuM=;
	b=P4QFuMHNAyOvRqx6jp9N/GHAyHyf+zymok+J310z9eZDJmC0ERCD4QCLm0pXrRlUQqw59u
	t47YVRQ9DvG1hNjM75w74LLlpmvgI+ENlfLqbgLgSOHswQlykMf3mbND4kcA2XlubI03QJ
	b+yvEHK5rPWvCHQdhU2Eg/c96ZaVOF4=
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com
 [209.85.214.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-583-psaKAX00N7OnWbXanEhhwg-1; Fri, 29 Sep 2023 19:52:27 -0400
X-MC-Unique: psaKAX00N7OnWbXanEhhwg-1
Received: by mail-pl1-f198.google.com with SMTP id d9443c01a7336-1c72c1a1424so44623695ad.1
        for <kvmarm@lists.linux.dev>; Fri, 29 Sep 2023 16:52:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696031547; x=1696636347;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=wbCRLqs67uOHonUW6wA0vdzT3otLZZXvFL4oPjvAtuM=;
        b=Ew9Sk+7+MXEUCCBTEkqVKFpyORU7BxXYfAWnb9gV/dfQ4C+yUf2t7/tZyAK/noow1p
         t7oObHbOcmccTt9+kwL9T5GwuvDQMTGVMHPBMptUbWFjtUYfissRc3yJWBnJ3+IFAwzb
         Ie1mqAdsGi14Mv6m+dRMTPAr2BGgKT2X4W++PZ75Wjeoj7xPUXb5zLCCOUFtrZa1Tc0/
         uftvIeaFvTdQRXae7fWZCrUaIrVJLYpejJ1UNXgCS1pHba4jmJW8b1v5hpNYkY4tDEDv
         C8ji/cDY9ky7LRFfsMwgdxaEr+n5uzJvcu4J06zlVpMVtIaK1TJgs37k9p6eDL1iHDaO
         W9Ag==
X-Gm-Message-State: AOJu0Yx4/NNxXVly/GRu39yRXMq/6WfeoooUO+V6oefdxrYU2c2hPN95
	GI5bW7xxDF3N8dLJUx18c3q+vjsckvE/mmRZcI1Quqic3hmY+6bTSJ7nYOby6qBpGg7iXhEDHpD
	ltrKFg8ubcEQdNBkk
X-Received: by 2002:a17:903:1ca:b0:1c3:e5bf:a9f8 with SMTP id e10-20020a17090301ca00b001c3e5bfa9f8mr7130069plh.19.1696031546960;
        Fri, 29 Sep 2023 16:52:26 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHX2bX/x5DjYhQHQmkVbrIHvYA2ci45ExMx9DEYdHnhMM3Xv7vAE4btBHGyfHKFMwDj/drBbg==
X-Received: by 2002:a17:903:1ca:b0:1c3:e5bf:a9f8 with SMTP id e10-20020a17090301ca00b001c3e5bfa9f8mr7130049plh.19.1696031546567;
        Fri, 29 Sep 2023 16:52:26 -0700 (PDT)
Received: from ?IPV6:2001:8003:e5b0:9f00:dbbc:1945:6e65:ec5? ([2001:8003:e5b0:9f00:dbbc:1945:6e65:ec5])
        by smtp.gmail.com with ESMTPSA id g22-20020a1709029f9600b001b5656b0bf9sm11819664plq.286.2023.09.29.16.52.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 29 Sep 2023 16:52:26 -0700 (PDT)
Message-ID: <cb1dad7f-9756-f2f3-8708-7d1c57c7c1b0@redhat.com>
Date: Sat, 30 Sep 2023 09:52:21 +1000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH v2 2/2] KVM: arm64: Use folio for THP adjustment
To: Matthew Wilcox <willy@infradead.org>
Cc: Vincent Donnefort <vdonnefort@google.com>, maz@kernel.org,
 oliver.upton@linux.dev, kvmarm@lists.linux.dev,
 linux-arm-kernel@lists.infradead.org, kernel-team@android.com,
 will@kernel.org
References: <20230928173205.2826598-1-vdonnefort@google.com>
 <20230928173205.2826598-3-vdonnefort@google.com>
 <a226023e-4651-05d6-30eb-e3f3595dd98b@redhat.com>
 <ZRbMF1Ik+GOuTk7s@casper.infradead.org>
From: Gavin Shan <gshan@redhat.com>
In-Reply-To: <ZRbMF1Ik+GOuTk7s@casper.infradead.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi Matthew,

On 9/29/23 23:07, Matthew Wilcox wrote:
> On Fri, Sep 29, 2023 at 05:24:00PM +1000, Gavin Shan wrote:
>>> +		size_t sz = folio_size(pfn_folio(pfn));
>>
>> Is it possible that a tail page is returned from __gfn_to_pfn_memslot()? folio_size()
>> doesn't work for a tail page because order 0 is returned for tail pages. It seems it's
> 
> pfn_folio() can't return a tail page.  That's the point of folios; they
> aren't tail pages.  They're either a head page or an order-0 page.
> 

Indeed, page_folio() already returned the head page properly.
Thanks a lot for your confirm.

Thanks,
Gavin

