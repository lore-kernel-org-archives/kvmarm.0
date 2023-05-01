Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C77D20F8
	for <kvmarm@lists.linux.dev>; Mon,  1 May 2023 13:00:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1682946057;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=DrRzX6M8f5Q1D4e3/DNWMqR/82OR/fzVqNrYR5M4KjI=;
	b=Zgb8f1WIe0LkgML+YnPaSBSU0V9ZMLlFn5EtbvUYpJCQ1984tNNsl15/QjvRZkUDlzKVMs
	YAzOi/L0OPQHCk7ml6sUFtgT3YYTuDpvlJmQ66HdhmkSFCxW8JGexsYaFynGCuYpQj8saX
	BgS5bTrLI4bjGU21o2yefO6F6YnpUNQ=
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com
 [209.85.214.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-659-HTOJbAvoM4WD7nngG2Rv1w-1; Mon, 01 May 2023 09:00:55 -0400
X-MC-Unique: HTOJbAvoM4WD7nngG2Rv1w-1
Received: by mail-pl1-f198.google.com with SMTP id d9443c01a7336-1a68ba51ce9so1251325ad.1
        for <kvmarm@lists.linux.dev>; Mon, 01 May 2023 06:00:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682946054; x=1685538054;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=DrRzX6M8f5Q1D4e3/DNWMqR/82OR/fzVqNrYR5M4KjI=;
        b=hKYo502eql3k7dYoZilO0yNxm5yitr9n9ko8F/XS/zUKjlDTB9rT4txoLU7LfKw3Bl
         YkrkUUThUvDWusc6JIwVYvAjaNr8zYSlVIy4vWoac4APMYgti0VFzZbdqqcZkvvutluL
         GJB/mmVPq2r93RmflraCaYuXM5ySNqGgsj/7Vxe7W9jN96fFGiPRWL/M5AkfpBX6WN7C
         dYYL7u5CxBJP0QKwORiTghj0r6Kc70SlAkE9EO5E/+xbeCOsUVQo+esTqBH1spIrnaTo
         IjyvshknQV4BZbUt+nyhR+dadV/a7i/gSYtPuJF1RphxzNEfRNSTDwRfNB8Sd2Jaheye
         XKFA==
X-Gm-Message-State: AC+VfDzRoLxJzborpk0cgHGtPahD31kK6LshuWETKsCbDVToEWHIXAaA
	WwN278Q0HMDlDUk/jWjh8pKDxWEPYULcyZ/blids4h+3CY6CCIcJ9/rYWLHbPPW/zlAXX8y1bfx
	rDP/NfZoBI4tv4I8a
X-Received: by 2002:a17:902:dac1:b0:1a6:93cc:924b with SMTP id q1-20020a170902dac100b001a693cc924bmr17134915plx.3.1682946054087;
        Mon, 01 May 2023 06:00:54 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ7sJ8XYGjYfoGsFAQAkPFhfWxXemh27korpKb7et1oT9bj+Ty6RFc50SRgi1w1XYm/lZRZEmA==
X-Received: by 2002:a17:902:dac1:b0:1a6:93cc:924b with SMTP id q1-20020a170902dac100b001a693cc924bmr17134900plx.3.1682946053798;
        Mon, 01 May 2023 06:00:53 -0700 (PDT)
Received: from [10.66.61.39] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id jl13-20020a170903134d00b001a9666376a9sm14015518plb.226.2023.05.01.06.00.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 01 May 2023 06:00:53 -0700 (PDT)
Message-ID: <6ed566b3-c27b-182c-7c67-b262414bb61e@redhat.com>
Date: Mon, 1 May 2023 21:00:50 +0800
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [kvm-unit-tests PATCH v5 28/29] lib: arm: Print test exit status
To: Nikos Nikoleris <nikos.nikoleris@arm.com>, kvm@vger.kernel.org,
 kvmarm@lists.linux.dev, andrew.jones@linux.dev
Cc: Alexandru Elisei <alexandru.elisei@arm.com>, pbonzini@redhat.com,
 ricarkol@google.com
References: <20230428120405.3770496-1-nikos.nikoleris@arm.com>
 <20230428120405.3770496-29-nikos.nikoleris@arm.com>
From: Shaoqin Huang <shahuang@redhat.com>
In-Reply-To: <20230428120405.3770496-29-nikos.nikoleris@arm.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 4/28/23 20:04, Nikos Nikoleris wrote:
> From: Alexandru Elisei <alexandru.elisei@arm.com>
> 
> The arm tests can be run under kvmtool, which doesn't emulate a chr-testdev
> device. Print the test exit status to make it possible for the runner
> scripts to pick it up when they have support for it.
> 
> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
> Signed-off-by: Nikos Nikoleris <nikos.nikoleris@arm.com>
> Reviewed-by: Andrew Jones <andrew.jones@linux.dev>
Reviewed-by: Shaoqin Huang <shahuang@redhat.com>
> ---
>   lib/arm/io.c | 7 +++++++
>   1 file changed, 7 insertions(+)
> 
> diff --git a/lib/arm/io.c b/lib/arm/io.c
> index 19f93490..c15e57c4 100644
> --- a/lib/arm/io.c
> +++ b/lib/arm/io.c
> @@ -149,6 +149,13 @@ extern void halt(int code);
>   
>   void exit(int code)
>   {
> +	/*
> +	 * Print the test return code in the following format which is
> +	 * consistent with powerpc and s390x. The runner can pick it
> +	 * up when chr-testdev is not present.
> +	 */
> +	printf("\nEXIT: STATUS=%d\n", ((code) << 1) | 1);
> +
>   	chr_testdev_exit(code);
>   	psci_system_off();
>   	halt(code);

-- 
Shaoqin

