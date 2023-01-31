Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64F628C04
	for <kvmarm@lists.linux.dev>; Tue, 31 Jan 2023 14:43:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1675176202;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=LAtdCvaYcBjQla+NfgEkiJO+riIsmgiBoPP1Uy0xazs=;
	b=PNppBzgKtEeV2bhcg9WjBqwpVSrH/RzBd6kgDPtP3Vv9nj09rlao0mj2YyMXNIMwPLgCXs
	1yegoP2J2dPfNRtHxolSkuUh6cpsPnRMGDA5+aNXBsieMLypzsSNY6x2hX2MYVVQlvnshC
	U+f8DwNOMlsAxeljGaxwVBNGDm6Rov0=
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com
 [209.85.160.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-625-CI7tsavAP_WNeGkR03Rmgg-1; Tue, 31 Jan 2023 09:43:20 -0500
X-MC-Unique: CI7tsavAP_WNeGkR03Rmgg-1
Received: by mail-qt1-f199.google.com with SMTP id a24-20020ac84d98000000b003b9a4958f0cso1817305qtw.3
        for <kvmarm@lists.linux.dev>; Tue, 31 Jan 2023 06:43:20 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=LAtdCvaYcBjQla+NfgEkiJO+riIsmgiBoPP1Uy0xazs=;
        b=tQ/ABasS/De0Qo99aLwPyt1PJDern4zFGOwP4+jLD/GSOWadB+YNKQKifVtVSnvH9n
         u4ifB+Ck0xOGbcVBKKW5ECEezvKyGtEtEkHDxq/UhSkDgeGKyGoyU8nYGzeuQqOs1Qsi
         q9oKbbovm6usVKjqsCED83fkBZN4F7msu6pAsG4N0CZjWiSQ718h7mZEZNd1W5xeBj5w
         v3I+QC4aEbg0wg138lFBCGXlLZ+VpoMKv2Yz8u3i5nm6c1BuYsQ6Suj6iwnEoctcHkxm
         YHOL5dUN4SKuSPi7ysRq7s8zueXzfk+2NPEQRkZAcktAYGDbFI0jxvEiqY1+K31RKNey
         rMYg==
X-Gm-Message-State: AFqh2kpZ7wBM8VC5T/o3q9gAAe6mfPTnAu+ZlFA9GRlfxf8dkdjREANZ
	4nIP3zUO9mfSZaAezC3pcr3Sylgz5VDPmU5gdL7ntVrtdaJIdv9LM4WYdFGBImdgKsctRz5fvh7
	4lMk4EwJ8+RhaUcsf
X-Received: by 2002:ac8:7ec4:0:b0:3b6:3c9c:59f0 with SMTP id x4-20020ac87ec4000000b003b63c9c59f0mr75200611qtj.15.1675176199682;
        Tue, 31 Jan 2023 06:43:19 -0800 (PST)
X-Google-Smtp-Source: AMrXdXuXH7IzWL307K632kUG5faoKR8tSdHwFt5EW1IhyhwYmM3PlJhpLhToOa2tJxLyWOWsmCmU4Q==
X-Received: by 2002:ac8:7ec4:0:b0:3b6:3c9c:59f0 with SMTP id x4-20020ac87ec4000000b003b63c9c59f0mr75200586qtj.15.1675176199464;
        Tue, 31 Jan 2023 06:43:19 -0800 (PST)
Received: from [192.168.0.2] (ip-109-43-176-155.web.vodafone.de. [109.43.176.155])
        by smtp.gmail.com with ESMTPSA id z20-20020ac84314000000b003b960aad697sm2448545qtm.9.2023.01.31.06.43.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 31 Jan 2023 06:43:18 -0800 (PST)
Message-ID: <16e95056-919a-47dc-3ed7-50c29d39b6ae@redhat.com>
Date: Tue, 31 Jan 2023 15:43:13 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.0
Subject: Re: [RFC kvm-unit-tests 01/27] lib/string: include stddef.h for
 size_t
To: Joey Gouly <joey.gouly@arm.com>, Andrew Jones <andrew.jones@linux.dev>,
 kvmarm@lists.linux.dev, kvm@vger.kernel.org
Cc: Alexandru Elisei <alexandru.elisei@arm.com>,
 Christoffer Dall <christoffer.dall@arm.com>, Fuad Tabba <tabba@google.com>,
 Jean-Philippe Brucker <jean-philippe@linaro.org>,
 Marc Zyngier <maz@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
 Oliver Upton <oliver.upton@linux.dev>, Paolo Bonzini <pbonzini@redhat.com>,
 Quentin Perret <qperret@google.com>, Steven Price <steven.price@arm.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>, Will Deacon <will@kernel.org>,
 Zenghui Yu <yuzenghui@huawei.com>, linux-coco@lists.linux.dev,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org
References: <20230127112248.136810-1-suzuki.poulose@arm.com>
 <20230127114108.10025-1-joey.gouly@arm.com>
 <20230127114108.10025-2-joey.gouly@arm.com>
From: Thomas Huth <thuth@redhat.com>
In-Reply-To: <20230127114108.10025-2-joey.gouly@arm.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 27/01/2023 12.40, Joey Gouly wrote:
> Don't implicitly rely on this header being included.
> 
> Signed-off-by: Joey Gouly <joey.gouly@arm.com>
> ---
>   lib/string.h | 2 ++
>   1 file changed, 2 insertions(+)
> 
> diff --git a/lib/string.h b/lib/string.h
> index b07763ea..758dca8a 100644
> --- a/lib/string.h
> +++ b/lib/string.h
> @@ -7,6 +7,8 @@
>   #ifndef _STRING_H_
>   #define _STRING_H_
>   
> +#include <stddef.h>  /* For size_t */
> +
>   extern size_t strlen(const char *buf);
>   extern size_t strnlen(const char *buf, size_t maxlen);
>   extern char *strcat(char *dest, const char *src);

Reviewed-by: Thomas Huth <thuth@redhat.com>

