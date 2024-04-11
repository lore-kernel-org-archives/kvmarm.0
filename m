Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 539B413DBAA
	for <kvmarm@lists.linux.dev>; Thu, 11 Apr 2024 07:03:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712819008; cv=none; b=OJ4ujEw4hPimpq+N/VehCI1++0vJ+apAl7a+eY+ZMe+YS0JdTnvQPMCkl1F8SgUmYPnLo+AgQIkbnQaw6T6XVg/j56cwkFnER0TNd9JfaEzOlMrONegS+uNp/nMYXN3UC5o/pXTewd+oGPe1p0LfAhNNI/5ZiYMTNC0TlHfObIw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712819008; c=relaxed/simple;
	bh=AubONOFaA+RUpGeBw5HQNnZdsscRirVIaGi7Lfko5X8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=crCmma7WWm9FAGerJuWxll37IlUlEdIuNFXkjU7GtZmd5sZvrmYcS67dpOL7KjMkILw4HXPAsW+eVmUkG8bSZsqAVfB/pBbraDLI9jpBrPNSjeQJLhjJce+DHo2xoO1N/h2Ue0z1qdRcR02I3iStFUBGECktuWhnMMy0bFtVFPU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=SKW1dsna; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="SKW1dsna"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1712819004;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=QtHuNib59Is1i1vCWC4Y3CGuwoHokuKi4jrm90ujf+8=;
	b=SKW1dsnaKQOTzeSc7bt7LyZGxp9/sfXUih2yLf/N8NkF88s5/tIjVQndGTDwTs60BBFRxp
	r56d39M0Ki8yuNP/w8BJlvT+338sE5/JZtCnsqUqSL4J+SgK2RoVofvxGvX/Sw0prYfQAc
	qZ2U4trtixMR7Gr8mSKyL2qZ6AnHj7Q=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-6-HT3HhxYcOqqSTuH75JaA-Q-1; Thu, 11 Apr 2024 03:03:10 -0400
X-MC-Unique: HT3HhxYcOqqSTuH75JaA-Q-1
Received: by mail-qk1-f197.google.com with SMTP id af79cd13be357-7885dd31632so895619885a.0
        for <kvmarm@lists.linux.dev>; Thu, 11 Apr 2024 00:03:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712818989; x=1713423789;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=QtHuNib59Is1i1vCWC4Y3CGuwoHokuKi4jrm90ujf+8=;
        b=Wlv+s0vWIHWVIDN15fGZvSfkBjD79+YcVIpC28P9+2oGYIKdvHDdbAMgvlMKbCgj+V
         J9FgqvdHaqR4tZkaCumT8NL+E41Tyn1GG/MbWCTc+U3VELxaHJJcZpKIwXGBlgaWxlnK
         NzmXJ2YRgDf8NIK3XyxlW/ljE/1uxdHkmqNpgOGnKubWh0RQSdnoN9KhxSd9cHv3zDeJ
         SSVk8xU7EtTiPbT0aetHQkyoKlQ9Eicl8TNCZgi+2ymZ2RkQEau6x8fdMQDkhFZ7EQDG
         wDfLcNoVpVS0LyBxDtO4NMwAM7WgfJbO6QmcT3RSJlqRsRIrtt+97rz/aX1Ara6uN9OK
         MtBQ==
X-Forwarded-Encrypted: i=1; AJvYcCXfFUFHT6JNd1ca/Lpn7DiWevm/zpP0OVHU9XHG/IJe40y7hb9YRA0q6B7+ywcX+MXcxyJ/ajg54HP8rnrwNBov+b/0b2HN
X-Gm-Message-State: AOJu0YwV9+FNEl+qNb7+cbX1BpCdR4nyWHYUtswsiHy7oJZlFDao62oE
	gnzQC9XEYUF2Rr9j5+OvjnI7eF4lLnuYegCFgCugkl5KkNRt2I2iZeWC8FaxX7bLcz6VUoskj+E
	/1GEGIWGZyDpaBugufuTZkYfmEZtmTQlxa7lvvlPtQwPcguoYq1RoRw==
X-Received: by 2002:a05:620a:2725:b0:78d:6791:34d1 with SMTP id b37-20020a05620a272500b0078d679134d1mr6228748qkp.9.1712818989594;
        Thu, 11 Apr 2024 00:03:09 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGau4WYtOsSPLHVhfKvR0HvdfS+y2KoW25hx7BRdsuJh5si8R2fP0b6I2mR4Dl5Kta6TgQKjg==
X-Received: by 2002:a05:620a:2725:b0:78d:6791:34d1 with SMTP id b37-20020a05620a272500b0078d679134d1mr6228725qkp.9.1712818989317;
        Thu, 11 Apr 2024 00:03:09 -0700 (PDT)
Received: from [192.168.0.9] (ip-109-43-179-142.web.vodafone.de. [109.43.179.142])
        by smtp.gmail.com with ESMTPSA id i22-20020a05620a145600b0078d68b23254sm628581qkl.107.2024.04.11.00.03.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 11 Apr 2024 00:03:09 -0700 (PDT)
Message-ID: <27ba7613-1344-40b8-bc4d-9a9903ebdcfa@redhat.com>
Date: Thu, 11 Apr 2024 09:03:04 +0200
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC kvm-unit-tests PATCH v2 01/14] Add initial shellcheck
 checking
To: Nicholas Piggin <npiggin@gmail.com>, Andrew Jones <andrew.jones@linux.dev>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
 Alexandru Elisei <alexandru.elisei@arm.com>,
 Eric Auger <eric.auger@redhat.com>, Janosch Frank <frankja@linux.ibm.com>,
 Claudio Imbrenda <imbrenda@linux.ibm.com>, =?UTF-8?Q?Nico_B=C3=B6hr?=
 <nrb@linux.ibm.com>, David Hildenbrand <david@redhat.com>,
 Shaoqin Huang <shahuang@redhat.com>,
 Nikos Nikoleris <nikos.nikoleris@arm.com>,
 David Woodhouse <dwmw@amazon.co.uk>, Ricardo Koller <ricarkol@google.com>,
 rminmin <renmm6@chinaunicom.cn>, Gavin Shan <gshan@redhat.com>,
 Nina Schoetterl-Glausch <nsg@linux.ibm.com>,
 Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org,
 kvmarm@lists.linux.dev, kvm-riscv@lists.infradead.org,
 linux-s390@vger.kernel.org
References: <20240406123833.406488-1-npiggin@gmail.com>
 <20240406123833.406488-2-npiggin@gmail.com>
From: Thomas Huth <thuth@redhat.com>
Autocrypt: addr=thuth@redhat.com; keydata=
 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
In-Reply-To: <20240406123833.406488-2-npiggin@gmail.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 06/04/2024 14.38, Nicholas Piggin wrote:
> This adds a basic shellcheck sytle file, some directives to help

s/sytle/style/

> find scripts, and a make shellcheck target.
> 
> When changes settle down this could be made part of the standard
> build / CI flow.
> 
> Suggested-by: Andrew Jones <andrew.jones@linux.dev>
> Reviewed-by: Andrew Jones <andrew.jones@linux.dev>
> Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
> ---
...
> diff --git a/README.md b/README.md
> index 6e82dc225..03ff5994e 100644
> --- a/README.md
> +++ b/README.md
> @@ -193,3 +193,6 @@ with `git config diff.orderFile scripts/git.difforder` enables it.
>   
>   We strive to follow the Linux kernels coding style so it's recommended
>   to run the kernel's ./scripts/checkpatch.pl on new patches.
> +
> +Also run make shellcheck before submitting a patch which touches bash

I'd maybe put "make shellcheck" in quotes to make the sentence more readable?

> +scripts.
> diff --git a/scripts/common.bash b/scripts/common.bash
> index ee1dd8659..3aa557c8c 100644
> --- a/scripts/common.bash
> +++ b/scripts/common.bash
> @@ -82,8 +82,11 @@ function arch_cmd()
>   }
>   
>   # The current file has to be the only file sourcing the arch helper
> -# file
> +# file. Shellcheck can't follow this so help it out. There doesn't appear to be a
> +# way to specify multiple alternatives, so we will have to rethink this if things
> +# get more complicated.
>   ARCH_FUNC=scripts/${ARCH}/func.bash
>   if [ -f "${ARCH_FUNC}" ]; then
> +# shellcheck source=scripts/s390x/func.bash
>   	source "${ARCH_FUNC}"
>   fi

  Thomas

