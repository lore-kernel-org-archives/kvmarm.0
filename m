Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 715E838389
	for <kvmarm@lists.linux.dev>; Mon,  4 Nov 2024 13:33:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730727231; cv=none; b=oWWt4qzrXWuDBClj8wXp4QJoA6SmREjlrmlG9Jjkj0esUMbDrnLn/mLdtvFLCDWaYlOfj+U7vLrmbXmbd/haQDlR4wm1+o2MBOgMzrm2NvzeWH0G1LKnNJg02yoUjgMQ4iO6MrG6W1M3XLoqx6J+7WG69LHtrcYF+MUTStGcmyU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730727231; c=relaxed/simple;
	bh=2JqWxmFMiOy9u00xv7jOCwRGCdQcfxvKUiICVSDl4Sw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=LBJm2aZAVY0GJs40/A8vdS9jGXfKacFbZWDm+Hd4TRcgpwn4RJNbGtQ3vc6xh5OhzXOGrYWBufJcObmpe8mW/JLw3T8X7i1eG/Q9wAPf8mPZmnn2vyGZDUIIyNKXHqKVaalmlck8DQCX7TMEhRgfiOvo97lFuptBH8ZQeFwU7B4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=MKPTQjs8; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="MKPTQjs8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1730727228;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=bsKR/ZbSwcHqsurNqiuF+M7XrV5jICI7Kt7LjPLlYkQ=;
	b=MKPTQjs8fm6Hb38DbWh1PV9DMWfzBNAbWDfpI+QtN5vkjm/CqMIV+HapN4xaV7tEY/mWpp
	mYsUvnEqNvbudsCDe7fVot98xrs63T+zK7a/UWuiuW+4KefXntXngj9qR1V4IQ5dscTdCM
	vXgjoNkhXlvtsR7XJEPUFFPWAAEGltM=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-141-97k7VnjjNMerpldIu3vjow-1; Mon, 04 Nov 2024 08:33:45 -0500
X-MC-Unique: 97k7VnjjNMerpldIu3vjow-1
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-37d4d51b4efso1857997f8f.3
        for <kvmarm@lists.linux.dev>; Mon, 04 Nov 2024 05:33:44 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730727224; x=1731332024;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=bsKR/ZbSwcHqsurNqiuF+M7XrV5jICI7Kt7LjPLlYkQ=;
        b=ime2iFzyr7HaIfMs3ONe2nGyOPSiMAMy6gvQ2a88qvUeVDFNHIt/sMM5hbp2aZ4eha
         1UvARXihgIwVC+lU++3CxhgP0hB9j/ghKiFoo4SibgtLamQekQLux2hXHzRcjrVMkJpe
         U693Km63CzNhfbaDuxO41996JF2omqOgQWh62mHe/Ej5MrjdWCYgIxG1f/oeg/q1jLwh
         b3zADu0SCcxadDLX08nQX49mNzYzkvOJvlmyBG2qxa0VjlOt/c6hi5wUKN6Kl473Tdvl
         Y7ZabOEcINeZY8Nf0FVkaaq/lGn1DcDGeqYCrnFAbDl3XeYr++c+c476z6prnqjIyyC9
         SoYg==
X-Forwarded-Encrypted: i=1; AJvYcCVzxUD+zGSUuqAqZukKlfHUDH664VYOf3xgxJ3HN8jnrU36FWiwAgyzUl97LBsV2qJLRke0k8U=@lists.linux.dev
X-Gm-Message-State: AOJu0Yx5n7Wl7jLj8bvFy+IAUqkkn4RnRhn4VnIHriO7PdqSllYE3m1v
	GQlzw/6EtZKibaafwGIp7+Iew2EevXPf+l1QOJwGWslx2fvajy9PU3G0ItBGg9XeWhu1KjM+ryU
	iLBEaxfYVjnamo7ubTIyZ5XGOR2J1rV/WDq1arPUQEwRAHR1cFtOtSA==
X-Received: by 2002:a5d:4cd0:0:b0:376:37e:2729 with SMTP id ffacd0b85a97d-3806115ae83mr21401268f8f.31.1730727223776;
        Mon, 04 Nov 2024 05:33:43 -0800 (PST)
X-Google-Smtp-Source: AGHT+IELeWTIVJZeus8w+il4ddk4jSY487U1fuv7GwRz3yTa/j/J83SY2mSwYHUBN8IDwnbvY+HJzw==
X-Received: by 2002:a5d:4cd0:0:b0:376:37e:2729 with SMTP id ffacd0b85a97d-3806115ae83mr21401234f8f.31.1730727223376;
        Mon, 04 Nov 2024 05:33:43 -0800 (PST)
Received: from ?IPV6:2a01:e0a:59e:9d80:527b:9dff:feef:3874? ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-381c10d49dfsm13267277f8f.46.2024.11.04.05.33.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 04 Nov 2024 05:33:42 -0800 (PST)
Message-ID: <f950f884-f5f7-4985-8825-ed5f2a10509b@redhat.com>
Date: Mon, 4 Nov 2024 14:33:40 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: eric.auger@redhat.com
Subject: Re: [RFC 14/21] arm/cpu: Add sysreg generation scripts
To: Marc Zyngier <maz@kernel.org>
Cc: eric.auger.pro@gmail.com, cohuck@redhat.com, qemu-devel@nongnu.org,
 qemu-arm@nongnu.org, kvmarm@lists.linux.dev, peter.maydell@linaro.org,
 richard.henderson@linaro.org, alex.bennee@linaro.org,
 oliver.upton@linux.dev, sebott@redhat.com,
 shameerali.kolothum.thodi@huawei.com, armbru@redhat.com,
 berrange@redhat.com, abologna@redhat.com, jdenemar@redhat.com,
 shahuang@redhat.com, mark.rutland@arm.com, philmd@linaro.org,
 pbonzini@redhat.com
References: <20241025101959.601048-1-eric.auger@redhat.com>
 <20241025101959.601048-15-eric.auger@redhat.com>
 <86frok2jwg.wl-maz@kernel.org>
From: Eric Auger <eric.auger@redhat.com>
In-Reply-To: <86frok2jwg.wl-maz@kernel.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Marc,
On 10/25/24 19:05, Marc Zyngier wrote:
> On Fri, 25 Oct 2024 11:17:33 +0100,
> Eric Auger <eric.auger@redhat.com> wrote:
>> Introduce scripts that automate the generation of system register
>> definitions from a given linux source tree arch/arm64/tools/sysreg.
>>
>> Invocation of
>> ./update-aarch64-sysreg-code.sh $PATH_TO_LINUX_SOURCE_TREE
>> in scripts directory do generate 2 qemu files:
>> - target/arm/cpu-sysreg-properties.c
>> - target/arm/cpu-sysregs.h
>>
>> cpu-sysregs.h creates defined for all system registers.
>> However cpu-sysreg-properties.c only cares about feature ID registers.
>>
>> update-aarch64-sysreg-code.sh calls two awk scripts.
>> gen-cpu-sysreg-properties.awk is inherited from kernel
>> arch/arm64/tools/gen-sysreg.awk. All credits to Mark Rutland
>> the original author of this script.
Sorry for the delay. I was out of the office last week.
> You really want to be careful with this. Both the script and the
> source file describing the registers are submitted to regular outburst
> of churn (I'm currently sitting on such a series). You really have to
> be prepared to see things breaking on each import.
OK thank you for the warning. It is now understood we cannot fully rely
on them and checks should be done on each run.
>
> That file has also been known to contain annoying mistakes, as it is
> all written by hand.
>
> Ideally, this would be directly generated from the ARM XML, which is a
> public set of files. However, the license attached to this package
> strictly prohibits its use in QEMU (or anywhere else). One day...
;-)

Eric
>
> Thanks,
>
> 	M.
>

