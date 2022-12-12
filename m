Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 215B923BD
	for <kvmarm@lists.linux.dev>; Mon, 12 Dec 2022 10:38:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1670841535;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=0geoJp5y5vah58rc3h1onQRI09PobQgX5h6nKaS34UM=;
	b=jJoxYQlScOh2WvgOPA3fGIDz0S6JEQOTgxPRNgjJU2O9UBlEUB+uAvONGncmjuTsDKmtRO
	SMa6Fr3uT6f+vK/Gis/gYGN+GDSP1hjxw9lc+3nnYAR0xFiyoHjF7szAH6lwrXTFU+lZk+
	2V2npXTQnG6sj2Ng/YR/gq0HO9sMeLE=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-387-x-_APtkvO7eDZ63dTGNr_g-1; Mon, 12 Dec 2022 05:38:50 -0500
X-MC-Unique: x-_APtkvO7eDZ63dTGNr_g-1
Received: by mail-wr1-f71.google.com with SMTP id x1-20020adfbb41000000b002426b33b618so2122782wrg.7
        for <kvmarm@lists.linux.dev>; Mon, 12 Dec 2022 02:38:49 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=0geoJp5y5vah58rc3h1onQRI09PobQgX5h6nKaS34UM=;
        b=bfmuGXnzFBQcJ22g/5IMWJN6VzFDkG04C9AqGLIhdyZNDlwXHtRA9oKoM2sf30rP/X
         SOF9CNEQ4pWLmDdPgTr4nq16tBxJQFPdF4PJ6uXoZhgNX9kiGPzrTcnPvLgD6Y6POuRH
         jfWuWreggBWC47c/OCu+fzQ7TGd4tizYKPc6oJCigMDptrvI4uDN3qq02nbOZA04MfOf
         +CTjO9wJKZXIDpVXY5e9JpIYpZc8FxRuVuabH6BTOefE98j3/wKTb+IKVSvvW47B+LGn
         Wir5yuKAhJqjfft+Dn7E8kBM2HOgl2edBOfJ2crilpYMtGxRoVbH4Lw/DMEvx8inbWxW
         qNEQ==
X-Gm-Message-State: ANoB5pke5tRDKkBV44I67XjjtZgXdaIIugXD5RsqGqUiaJOM8s66ncQx
	XsXnbh06IjNuac8wMShuG91zqkPOgW9Irl4rCWLcEIIMDANutrXSzA1qWzhlNKH7FD4/XbSfONW
	X44UiMSwUTSaQ4+8K
X-Received: by 2002:a05:600c:5398:b0:3cf:d0b1:8aa1 with SMTP id hg24-20020a05600c539800b003cfd0b18aa1mr12355042wmb.0.1670841528986;
        Mon, 12 Dec 2022 02:38:48 -0800 (PST)
X-Google-Smtp-Source: AA0mqf43hHD3Xh/hVMzgx7AUun3dPtnLezNxJe71/MuBv74YiGy1tG1gohvB+wRobXA4W5SAS5QTYw==
X-Received: by 2002:a05:600c:5398:b0:3cf:d0b1:8aa1 with SMTP id hg24-20020a05600c539800b003cfd0b18aa1mr12355032wmb.0.1670841528795;
        Mon, 12 Dec 2022 02:38:48 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:9af8:e5f5:7516:fa89? ([2001:b07:6468:f312:9af8:e5f5:7516:fa89])
        by smtp.googlemail.com with ESMTPSA id iw3-20020a05600c54c300b003d220ef3232sm5442368wmb.34.2022.12.12.02.38.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 12 Dec 2022 02:38:48 -0800 (PST)
Message-ID: <2ce6eab8-6156-1282-bf29-87fd74e4587a@redhat.com>
Date: Mon, 12 Dec 2022 11:38:47 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH v2 7/7] KVM: selftests: Avoid infinite loop if
 ucall_alloc() fails
To: Sean Christopherson <seanjc@google.com>,
 Oliver Upton <oliver.upton@linux.dev>
Cc: Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>,
 Alexandru Elisei <alexandru.elisei@arm.com>, Shuah Khan <shuah@kernel.org>,
 Andrew Jones <andrew.jones@linux.dev>, Peter Gonda <pgonda@google.com>,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
 kvm@vger.kernel.org, kvmarm@lists.linux.dev,
 Ricardo Koller <ricarkol@google.com>, linux-kselftest@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20221209015307.1781352-1-oliver.upton@linux.dev>
 <20221209015307.1781352-8-oliver.upton@linux.dev>
 <Y5OisdH5ohtr6r3j@google.com>
From: Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <Y5OisdH5ohtr6r3j@google.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Message-ID: <20221212103847.PR5rwZPy_6rJd0gY3861oKcJv5nNc9B9lPvWoccb4cc@z>

On 12/9/22 22:03, Sean Christopherson wrote:
> From: Sean Christopherson<seanjc@google.com>
> Date: Fri, 9 Dec 2022 12:55:44 -0800
> Subject: [PATCH] KVM: selftests: Use magic value to signal ucall_alloc()
>   failure
> 
> Use a magic value to signal a ucall_alloc() failure instead of simply
> doing GUEST_ASSERT().  GUEST_ASSERT() relies on ucall_alloc() and so a
> failure puts the guest into an infinite loop.
> 
> Use -1 as the magic value, as a real ucall struct should never wrap.
> 
> Reported-by: Oliver Upton<oliver.upton@linux.dev>
> Signed-off-by: Sean Christopherson<seanjc@google.com>
> ---
>   tools/testing/selftests/kvm/lib/ucall_common.c | 16 ++++++++++++++--
>   1 file changed, 14 insertions(+), 2 deletions(-)
> 
> diff --git a/tools/testing/selftests/kvm/lib/ucall_common.c b/tools/testing/selftests/kvm/lib/ucall_common.c
> index 0cc0971ce60e..2f0e2ea941cc 100644
> --- a/tools/testing/selftests/kvm/lib/ucall_common.c
> +++ b/tools/testing/selftests/kvm/lib/ucall_common.c
> @@ -4,6 +4,8 @@
>   #include "linux/bitmap.h"
>   #include "linux/atomic.h"
>   
> +#define GUEST_UCALL_FAILED -1
> +
>   struct ucall_header {
>   	DECLARE_BITMAP(in_use, KVM_MAX_VCPUS);
>   	struct ucall ucalls[KVM_MAX_VCPUS];
> @@ -41,7 +43,8 @@ static struct ucall *ucall_alloc(void)
>   	struct ucall *uc;
>   	int i;
>   
> -	GUEST_ASSERT(ucall_pool);
> +	if (!ucall_pool)
> +		goto ucall_failed;
>   
>   	for (i = 0; i < KVM_MAX_VCPUS; ++i) {
>   		if (!test_and_set_bit(i, ucall_pool->in_use)) {
> @@ -51,7 +54,13 @@ static struct ucall *ucall_alloc(void)
>   		}
>   	}
>   
> -	GUEST_ASSERT(0);
> +ucall_failed:
> +	/*
> +	 * If the vCPU cannot grab a ucall structure, make a bare ucall with a
> +	 * magic value to signal to get_ucall() that things went sideways.
> +	 * GUEST_ASSERT() depends on ucall_alloc() and so cannot be used here.
> +	 */
> +	ucall_arch_do_ucall(GUEST_UCALL_FAILED);
>   	return NULL;
>   }
>   
> @@ -93,6 +102,9 @@ uint64_t get_ucall(struct kvm_vcpu *vcpu, struct ucall *uc)
>   
>   	addr = ucall_arch_get_ucall(vcpu);
>   	if (addr) {
> +		TEST_ASSERT(addr != (void *)GUEST_UCALL_FAILED,
> +			    "Guest failed to allocate ucall struct");
> +
>   		memcpy(uc, addr, sizeof(*uc));
>   		vcpu_run_complete_io(vcpu);
>   	} else {
> 
> base-commit: dc2efbe4813e0dc4368779bc36c5f0e636cb8eb2
> -- 

Queued, thanks.

Paolo

