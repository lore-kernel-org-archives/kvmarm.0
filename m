Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56B0F3A8D8
	for <kvmarm@lists.linux.dev>; Thu,  2 May 2024 08:27:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714638440; cv=none; b=Rd7pZZqEFIMbP27oei/AbXov4uUvYdJC2MUF6Xe/c3hzJnO4Bh9NviwkXWO6YzzcsgiIdi3mCsFtwJaDUsNVRoP0LfSyDiEBYmLaOMcojjUeP40eae9/l0wHGqLCGX3XKgtd+E3pVYNA35+SZXzQyDue/8IJevPXKtyxMOiE2sE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714638440; c=relaxed/simple;
	bh=FNXL0Woy+SYHpnjVTDLsJudP5ULn+c2OFLWpMeinOBA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=SDy5XfCL1d7iS/NJaHYuZH0Uz4TGxj9MbjlVM8TGW7wPvSb3imhxcyVyftqd0n2QFujfesRotwmy+Pl5LwlQZj72R+8KME1UrGtdRb6hy9LpAueC1NyF6Tpq1e8g6rsPXsYL6NjpxGeQl/hX2uHV6BN+321vEiMNOhNRbTDDbag=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=crU5AZWN; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="crU5AZWN"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1714638438;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=p7ndgmJ4Q5mTTz6lBU7yUmLHmngiXphC0GSqdbIKWyA=;
	b=crU5AZWNLHhVAAXcfYljRpMsv/SGnMGDbJDY8b/xY237AGYWOzqnA3D8OxF7JXM79i4588
	R411twwDWZPf1eWElL0PD83elJe7JZ61Ud1zWi0PsD7QcAdqyiiBsqxCaDHZfpgX314KAX
	KyVNYyZYN8wC5btvZjxSw/OWoQHy/Is=
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com
 [209.85.160.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-217-VfNRvmQEPmaCOfd9JM4uUw-1; Thu, 02 May 2024 04:27:14 -0400
X-MC-Unique: VfNRvmQEPmaCOfd9JM4uUw-1
Received: by mail-qt1-f199.google.com with SMTP id d75a77b69052e-43b0a5616ebso40473001cf.3
        for <kvmarm@lists.linux.dev>; Thu, 02 May 2024 01:27:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714638434; x=1715243234;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=p7ndgmJ4Q5mTTz6lBU7yUmLHmngiXphC0GSqdbIKWyA=;
        b=RNfje9MP0VGTrPs3hEW8Z8gmXJKsD4+CdYOXz/bttJQicLTI/QLeJJRkCqEd2OnAQM
         nFwdWpT4LmjXUxMLsFztW8f8xsgBo5s+1Q2hsl/k04ekpdNvFNRNVhbq08qsbET6cTVb
         I1pvVaLgfErHWuh6+U6NUSoEOK2KD3mz3rUGlgej0NY21DZ1abeVH8dC72OOxMA/bwdZ
         GeAHFSdLOWhIv9cMQZQCIk+gi9OgRf903eudn14pb9lRl0+w/ZjA/p4NLzKHYI3mpdP7
         XBG7LD320HzHlXg1UXIbimclC1Cy7AoqQ6KVcRqkIPSBVJJ5dUdm1CPuIkh9UTQFj1k1
         T2fg==
X-Forwarded-Encrypted: i=1; AJvYcCWuvifyaqA5gg58LLbVsMb13XELbH/7QcWQTf/H/yXQ+/odS/WA81NtnzO0wGLnftEiPVkzKv02aqDe0Ye/715j5maxTW7X
X-Gm-Message-State: AOJu0YxYLLdnhxUCh+kv21+QpgDi3IsyiSLgB0PcaKTHlZvFDLK1ymdP
	73TI7sQV+Wd8gapBxkvyaDGvplkTryxJwHJeGKMIVNeSLLt2ZlKxoFRIoWbgbwavMT8dck82qmF
	NCGrycCmjaCLikxLlqwGI0BVlmLFSOvDnXfzrf7D9X7ueXcXNDc3djQ==
X-Received: by 2002:a05:622a:13cd:b0:43b:8bd:6a7a with SMTP id p13-20020a05622a13cd00b0043b08bd6a7amr5098265qtk.2.1714638434278;
        Thu, 02 May 2024 01:27:14 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHaKNE4eUpMSVylcHqjThnkOpY7zsQJCBrbK4j5VlAKy3wezcr+k4NxglNLjqlgTgYpou2oxg==
X-Received: by 2002:a05:622a:13cd:b0:43b:8bd:6a7a with SMTP id p13-20020a05622a13cd00b0043b08bd6a7amr5098246qtk.2.1714638433763;
        Thu, 02 May 2024 01:27:13 -0700 (PDT)
Received: from [192.168.0.9] (ip-109-43-179-34.web.vodafone.de. [109.43.179.34])
        by smtp.gmail.com with ESMTPSA id bn4-20020a05622a1dc400b004378ec294f9sm261050qtb.72.2024.05.02.01.27.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 02 May 2024 01:27:13 -0700 (PDT)
Message-ID: <bc766ea7-22de-4fc5-9790-1b2d67e39974@redhat.com>
Date: Thu, 2 May 2024 10:27:09 +0200
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [kvm-unit-tests PATCH] runtime: Adjust probe_maxsmp for older
 QEMU
To: Andrew Jones <andrew.jones@linux.dev>, kvm@vger.kernel.org,
 kvmarm@lists.linux.dev
Cc: alexandru.elisei@arm.com, eric.auger@redhat.com, pbonzini@redhat.com
References: <20240502080934.277507-2-andrew.jones@linux.dev>
From: Thomas Huth <thuth@redhat.com>
Autocrypt: addr=thuth@redhat.com; keydata=
 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
In-Reply-To: <20240502080934.277507-2-andrew.jones@linux.dev>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 02/05/2024 10.09, Andrew Jones wrote:
> probe_maxsmp is really just for Arm and for older QEMU which doesn't
> default to gicv3. So, even though later QEMU has a new error message
> format, we want to be able to parse the old error message format in
> order to use --probe-maxsmp when necessary. Adjust the parsing so it
> can handle both the old and new formats.
> 
> Fixes: 5dd20ec76ea6 ("runtime: Update MAX_SMP probe")
> Signed-off-by: Andrew Jones <andrew.jones@linux.dev>
> ---
>   scripts/runtime.bash | 4 +++-
>   1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/scripts/runtime.bash b/scripts/runtime.bash
> index e7af9bda953a..fd16fd4cfa25 100644
> --- a/scripts/runtime.bash
> +++ b/scripts/runtime.bash
> @@ -204,8 +204,10 @@ function probe_maxsmp()
>   {
>   	local smp
>   
> -	if smp=$($RUNTIME_arch_run _NO_FILE_4Uhere_ -smp $MAX_SMP |& grep 'Invalid SMP CPUs'); then
> +	if smp=$($RUNTIME_arch_run _NO_FILE_4Uhere_ -smp $MAX_SMP |& grep 'SMP CPUs'); then
>   		smp=${smp##* }
> +		smp=${smp/\(}
> +		smp=${smp/\)}
>   		echo "Restricting MAX_SMP from ($MAX_SMP) to the max supported ($smp)" >&2
>   		MAX_SMP=$smp
>   	fi

Reviewed-by: Thomas Huth <thuth@redhat.com>

