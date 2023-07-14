Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16F9D13724
	for <kvmarm@lists.linux.dev>; Fri, 14 Jul 2023 13:40:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1689342045;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=jx8jkqs101EGFpXlejbQE5dBXkq/2N4/WRaL7MIU1Ds=;
	b=UA7xowg8nELG3YzQrc/a1nxt2YrXpqzRdTl1bBzYMO61Pt2tYYr14vtLPv98IdaQOKPPDC
	/vY2fpONfmXBbjmIt/qLE64pFbATZ/XKKLCHMveMwAziLhPAT2YPPQ3ZCZF+XqWAPJv1JJ
	l6ryLS0wR3LtMB4NtZs8Q/Xw0Ryp6NY=
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com
 [209.85.219.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-617-P2F36-U6MTSU2BXfwnNGjw-1; Fri, 14 Jul 2023 09:40:44 -0400
X-MC-Unique: P2F36-U6MTSU2BXfwnNGjw-1
Received: by mail-qv1-f69.google.com with SMTP id 6a1803df08f44-63719bd2155so19190926d6.1
        for <kvmarm@lists.linux.dev>; Fri, 14 Jul 2023 06:40:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689342044; x=1689946844;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=jx8jkqs101EGFpXlejbQE5dBXkq/2N4/WRaL7MIU1Ds=;
        b=Ule/qHhP6lJi/jGY8FuurDWu2Bgpui6F1qsnZ8wITiHJgKwrZxepKmsioUXiJm+Jf9
         GBBOrf78Nc+sQZlc7zOlEu4/BazbIbGxpJmxLRYQas+3v3IxnjDgof/JOSNOl4j9b9wq
         8+gtGMlRoW88wTd6MFuypp4KCUB7yjoRxuvIR3eYEXshL/LPaVwdldd4ZQhhZDUr7rp6
         0ojXLZqampMWzrBGJ6yAFifG2MbHRfTIgGl8CCG5p7g84KWxbW4QKrvTDsq7em3QrtBE
         BuN5636Crt+iCyJaSonTDbI2JaqKLSYNTgvgkwBTNn0sXEbfb/X/6qNMIEZ8gwPPfT+o
         Y2ZA==
X-Gm-Message-State: ABy/qLaVm5YeP28qrW2InPUcEbROJiRI+klE1ZCysEo+sSQDpyq4XUbC
	RazjJQslwEcQu0xuTEQG+Oy69uv9EEL5LJiTxX3d3N7Vyal7JThb9kWr49n9cDZ9j/u07sYUeQ9
	n1sApmZlt8nlmAu7G
X-Received: by 2002:a0c:a991:0:b0:635:d5c5:15d2 with SMTP id a17-20020a0ca991000000b00635d5c515d2mr4904680qvb.18.1689342044248;
        Fri, 14 Jul 2023 06:40:44 -0700 (PDT)
X-Google-Smtp-Source: APBJJlGhP+tLwve9N9/NgqfeDmyqXyUoOqdF0eDaAe2r0yH3CZ5UJkDMtUWO0yNHTMqRxPTT0/B/CA==
X-Received: by 2002:a0c:a991:0:b0:635:d5c5:15d2 with SMTP id a17-20020a0ca991000000b00635d5c515d2mr4904671qvb.18.1689342044065;
        Fri, 14 Jul 2023 06:40:44 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:59e:9d80:527b:9dff:feef:3874? ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id j13-20020a0cf30d000000b0063013c621fasm3907943qvl.68.2023.07.14.06.40.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 14 Jul 2023 06:40:43 -0700 (PDT)
Message-ID: <c5a017d2-ed9d-2ca0-40bd-e6b424400c1c@redhat.com>
Date: Fri, 14 Jul 2023 15:40:41 +0200
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Reply-To: eric.auger@redhat.com
Subject: Re: [kvm-unit-tests PATCH] arm/arm64: MAINTAINERS: Add reviewers
To: Andrew Jones <andrew.jones@linux.dev>, kvmarm@lists.linux.dev
Cc: Alexandru Elisei <alexandru.elisei@arm.com>
References: <20230714125257.333242-2-andrew.jones@linux.dev>
From: Eric Auger <eric.auger@redhat.com>
In-Reply-To: <20230714125257.333242-2-andrew.jones@linux.dev>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Drew,

On 7/14/23 14:52, Andrew Jones wrote:
> I've recruited some review help!
>
> Signed-off-by: Andrew Jones <andrew.jones@linux.dev>
> ---
>  MAINTAINERS | 2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/MAINTAINERS b/MAINTAINERS
> index fe2c8418faf2..958735fbfd79 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -76,6 +76,8 @@ Architecture Specific Code:
>  
>  ARM
>  M: Andrew Jones <andrew.jones@linux.dev>
> +R: Alexandru Elisei <alexandru.elisei@arm.com>
> +R: Eric Auger <eric.auger@redhat.com>
Reviewed-by: Eric Auger <eric.auger@redhat.com>

Eric
>  S: Supported
>  L: kvmarm@lists.linux.dev
>  F: arm/

