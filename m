Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 057DB1F0E37
	for <kvmarm@lists.linux.dev>; Wed, 14 May 2025 03:30:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747193408; cv=none; b=e5ZV+G78VHP+vkS5bgdAan3+qc67VOSyHoFbR99oS/9HWJTvl868FaMlmMlHZDvBWZu0bbSNfdF1+29b1L6Bn/7+Wb+yZcwYBohUYtZDiY8p0VDz+grLZb0TCJUdD9MwgQaO1cBTUIhzDRNYE7N4vz8XcwuH9K3oR9gkwCtqjDI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747193408; c=relaxed/simple;
	bh=xe+r7aUNbKYL48IaCa6f/vynWducxTozNskiWKlpSl0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=EzJua6ZnwmM7ab2ziYzF/3s8opNbf6X+JaqfO7F1RgifCEHMZExrqmlXsWCw7Lu9cIsunp8/gQXO4n3KJCHl7zrEVmq7kA0DrJisrJGhCI0uQzBTPKrag3kb0rV5oaWBXAL14z7BPAwAj0sKxlRgt6YLwkI+0a8XlNfNKzxDd6E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Bj9ku/VG; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Bj9ku/VG"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1747193404;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=zPNj1R9ALDGy4ZhAvSAe9nUoPzbthadZcf4T/oJDS44=;
	b=Bj9ku/VG/PV0ScVBIuntONAi6vyHMT/DXi1xfYvw3pDI9NaJcTpbhHtDhBUeWRKPEiUySv
	+u2GOG2e1AEeeFEKjReyHgvnPyUo2vnzAY8Iw/HRQJ/WwfQcivD7nGxnE5U+warorlFjrC
	ktokYNpOglri+yjaT7I3gjOISg2AEEY=
Received: from mail-pf1-f200.google.com (mail-pf1-f200.google.com
 [209.85.210.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-149-rdS6m0JwPx-jqQxKHgeORg-1; Tue, 13 May 2025 23:30:02 -0400
X-MC-Unique: rdS6m0JwPx-jqQxKHgeORg-1
X-Mimecast-MFC-AGG-ID: rdS6m0JwPx-jqQxKHgeORg_1747193401
Received: by mail-pf1-f200.google.com with SMTP id d2e1a72fcca58-742849f4155so464337b3a.1
        for <kvmarm@lists.linux.dev>; Tue, 13 May 2025 20:30:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747193401; x=1747798201;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=zPNj1R9ALDGy4ZhAvSAe9nUoPzbthadZcf4T/oJDS44=;
        b=Z+yOo2lK9TOWZDwKGRni2ZBpgyoNqrkJbFwhDeXBlTtamRJyi0SK5TZYRcK2PecWI2
         JtAhQ4qsfuJIdKfk1o5xIwbgYqf2orzfzlp1rQno70UXoZ1661w//RiKu9g6lTdmnedJ
         B8WtNS4f3GF0MSoQzrlVK9OxpljXQHLvO0FPmLa3VKw/2SwT7bjKu33xUuW07FGjQD2w
         VakZmSHHIr5yOMPE6x7L2MLwDrtwWVqEgLsT8NmJd5vbdmmywxON7b+m2d3hbSj+DQwl
         bLB9SymA8AHTat13ERHdgPYCYPO1/pmXVA5YNoX9YmSLhe2dEHVCu1hIbpxwqWLPwL1O
         T4ig==
X-Forwarded-Encrypted: i=1; AJvYcCVLFZHK9O1qfOV0rHPccTQiQ2TgBH0GeC1q4crM3KW230L0lErHgB/YhFnYPPea5aBFWyLDwDU=@lists.linux.dev
X-Gm-Message-State: AOJu0YyxAsne389T58G92+tddjZVAxr4TghtNZTQHwYfgCtrmjlN3qDR
	c6VRGyYMf0diGG8tzfr1OAXA36iIa8V4tXwELh87rkyL+d3FjDQNF+eI0pVSwky2LSZB9bDid0n
	OAVG5YmqtXkZyTWgvpITd0dQifZv/6WUtraHb/zaTINZWoOfS7R4yGw==
X-Gm-Gg: ASbGncsznsTvdcEBMwxE33Kl1L7xv3cvzo7TdIDhei0Xddur2Kb4OJWrQdnqhYqr8+m
	8Xzc2anIISmt5g3fHvnuG7Z3EPEmpI7AV2zsfMmYmetRmyt9hkr0HGQCDW4s+/E7LexDYQ1lRbN
	n4I3AdekMoiZYk2JWuRCMMmlCf5dJmrReKcyOqb8cmIlIefelCK6DMBN7csxFfCacsOs4Hr094e
	x7siGladPQjNy2kLLI7APU2XmzPVmsHXZ/C+7pdYkdAMLCUtCnRC+MPnGQ33pJx95d736BJZErB
	VddreJMz7EO5w6u4
X-Received: by 2002:a05:6a00:849:b0:73e:2367:c914 with SMTP id d2e1a72fcca58-7428907dbbemr2608212b3a.7.1747193401132;
        Tue, 13 May 2025 20:30:01 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IE4NfRMilmo0WhS6bonXckoq6ayKF8QYGypn6TRZn6O1csy9tmwHCGt4njEOo+8VL50NM6NRQ==
X-Received: by 2002:a05:6a00:849:b0:73e:2367:c914 with SMTP id d2e1a72fcca58-7428907dbbemr2608173b3a.7.1747193400666;
        Tue, 13 May 2025 20:30:00 -0700 (PDT)
Received: from [10.72.116.125] ([209.132.188.88])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-74237a8a3adsm8406109b3a.158.2025.05.13.20.29.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 13 May 2025 20:30:00 -0700 (PDT)
Message-ID: <54b5bb37-5304-4e73-afc8-bf2a23e6490b@redhat.com>
Date: Wed, 14 May 2025 11:29:51 +0800
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [kvm-unit-tests PATCH v3 04/16] run_tests.sh: Document
 --probe-maxsmp argument
To: Alexandru Elisei <alexandru.elisei@arm.com>, andrew.jones@linux.dev,
 eric.auger@redhat.com, lvivier@redhat.com, thuth@redhat.com,
 frankja@linux.ibm.com, imbrenda@linux.ibm.com, nrb@linux.ibm.com,
 david@redhat.com, pbonzini@redhat.com
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev,
 linuxppc-dev@lists.ozlabs.org, kvm-riscv@lists.infradead.org,
 linux-s390@vger.kernel.org, will@kernel.org, julien.thierry.kdev@gmail.com,
 maz@kernel.org, oliver.upton@linux.dev, suzuki.poulose@arm.com,
 yuzenghui@huawei.com, joey.gouly@arm.com, andre.przywara@arm.com
References: <20250507151256.167769-1-alexandru.elisei@arm.com>
 <20250507151256.167769-5-alexandru.elisei@arm.com>
From: Shaoqin Huang <shahuang@redhat.com>
In-Reply-To: <20250507151256.167769-5-alexandru.elisei@arm.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: -RNzEwfx9_jhBWq8nOfyq1YBaAyHPD9M_XgWn54qfFs_1747193401
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 5/7/25 11:12 PM, Alexandru Elisei wrote:
> Commit 5dd20ec76ea63 ("runtime: Update MAX_SMP probe") added the
> --probe-maxmp argument, but the help message for run_tests.sh wasn't
> updated. Document --probe-maxsmp.
> 
> Reviewed-by: Andrew Jones <andrew.jones@linux.dev>
> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>

Reviewed-by: Shaoqin Huang <shahuang@redhat.com>

> ---
>   run_tests.sh | 17 +++++++++--------
>   1 file changed, 9 insertions(+), 8 deletions(-)
> 
> diff --git a/run_tests.sh b/run_tests.sh
> index 152323ffc8a2..f30b6dbd131c 100755
> --- a/run_tests.sh
> +++ b/run_tests.sh
> @@ -17,14 +17,15 @@ cat <<EOF
>   
>   Usage: $0 [-h] [-v] [-a] [-g group] [-j NUM-TASKS] [-t] [-l]
>   
> -    -h, --help      Output this help text
> -    -v, --verbose   Enables verbose mode
> -    -a, --all       Run all tests, including those flagged as 'nodefault'
> -                    and those guarded by errata.
> -    -g, --group     Only execute tests in the given group
> -    -j, --parallel  Execute tests in parallel
> -    -t, --tap13     Output test results in TAP format
> -    -l, --list      Only output all tests list
> +    -h, --help          Output this help text
> +    -v, --verbose       Enables verbose mode
> +    -a, --all           Run all tests, including those flagged as 'nodefault'
> +                        and those guarded by errata.
> +    -g, --group         Only execute tests in the given group
> +    -j, --parallel      Execute tests in parallel
> +    -t, --tap13         Output test results in TAP format
> +    -l, --list          Only output all tests list
> +        --probe-maxsmp  Update the maximum number of VCPUs supported by host
>   
>   Set the environment variable QEMU=/path/to/qemu-system-ARCH to
>   specify the appropriate qemu binary for ARCH-run.

-- 
Shaoqin

