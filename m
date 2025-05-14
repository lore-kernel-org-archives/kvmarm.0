Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C248D19F130
	for <kvmarm@lists.linux.dev>; Wed, 14 May 2025 03:37:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747193836; cv=none; b=GFh8T6rRrEuOwehIWQhsfM5niZH+LZH6VJugVDKOY/E/hIj6ZBdGl+mDHdvo8rp61aZR9zCUHl1pmHJqV8lwA8Kxdz4wMhRKSgJDRmZoqMsKUYZcGTKQXnvw/kCI07lGQ+7tb9m3e7h9OcpA/hDOJEyYZxVckSWZO72dQgaojz4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747193836; c=relaxed/simple;
	bh=1V7ejfjGKrSp2ZU/3GoXfAFp+S08WBXvioRWnbZi4ck=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=psADs/xr9OluRYUBmZfSyHZs8E3n2/XvrbiLp448hGfDHIUeokaAeZXw0ilyyuf8VVatDwWcXIRYKSzH80IcAfubP5MxGFtVTkFx360Rec1TixqIEZ0B5XIeofi+hRTAgIjpsLnKeZDDcP8S1MnkZNM/5NTTPgNMUEx8WhX56PU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=EaRL+crH; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="EaRL+crH"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1747193833;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=sXnHSZ0Yk0pjB03hExnA/yD4CkvPU5te8D9VFkvGbRE=;
	b=EaRL+crHP0XCHEc9k3TzjU0Q0b4w9eQwVE+J4oDd0W6q705w1WezeQ35W6MbKnNyqFQ0bf
	pHgw5+uONhpWXSZQzo312izfUXclsuhlKt9hjWG6IADSTU999fhhh9XOn6UIgAef52hrYI
	OWjxLXBcapmg3fUrxgUFRgQkjcgKqB0=
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com
 [209.85.216.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-151-c8BBJyu5MVWeGz2LUAsBIQ-1; Tue, 13 May 2025 23:37:10 -0400
X-MC-Unique: c8BBJyu5MVWeGz2LUAsBIQ-1
X-Mimecast-MFC-AGG-ID: c8BBJyu5MVWeGz2LUAsBIQ_1747193829
Received: by mail-pj1-f72.google.com with SMTP id 98e67ed59e1d1-30ac9abbd4bso9795894a91.3
        for <kvmarm@lists.linux.dev>; Tue, 13 May 2025 20:37:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747193829; x=1747798629;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=sXnHSZ0Yk0pjB03hExnA/yD4CkvPU5te8D9VFkvGbRE=;
        b=VjRmEVTLR7KQ7iy8fmp3yRPUOM20JBIWAzpfrmK/lAHr6IljD76Nmh9AvhXnAI6p97
         C0zOaiSIssHYoq9VB2aG2qajO++XkfA6W6W4GNuoK4Ahu1jmGi6g+Yuiq6PFwzJ6vl+w
         w59lV0xLenrQxPoFCkLuBp2c47aIWnvSj2m99/4S5VWEGvI4AwznLYkBY+bh2D6iiy/9
         Rh1ucDgJjOv6ERom61eEZvhq8GQf1MqqZXpRGAkdeVY9fWkWetJg9S9qyTTNJJCRLA8L
         egjfn2YiPmfjsGnxIO/7w7FN8HCub7YTF49p1x9Iq4lTN5sOPVBgDz6bqMYN5oWoB6YR
         VoXg==
X-Forwarded-Encrypted: i=1; AJvYcCXQ0zzgRlrSH0wWonQN6f7oCwkXqRej8t0+3Jc3tFRoGmppAY2TP5h85v+xvdlnWevfixQc5hI=@lists.linux.dev
X-Gm-Message-State: AOJu0Yx4Wwv5j/XUHJ3JViHEzNyY+AMBbvsURfXvjQminKMWOW6vZQ7N
	HEKu55m0d9ATKigeRvdtdZJXBnz6GPMa0B2b/VieAaWSU14RgwpBcytyvUnbEUBqfP3dShJBpMM
	QDwSUS9CjuyBZPbPDrjbir1Q8I1zvb/kgU5uAbOjlOKDNNiW0glmjdw==
X-Gm-Gg: ASbGncuZSSC7sKOIZG1wNOzSwTo90E6J8DpxL/mFmmqp2L4osWDwOfMF7MVsyrM+M9T
	tP4/WdlqazqJ10jAVBJfUWq5ekXf0mk9LFav46+ubp3zgwZPcafn/1wRNop1FBHRlqfmoojICAH
	9fBetlW9FJAlj3MAgpAQcPzL1c2Ob8fzDhiNS1HGnNvZWlqYd0WwNbhn0wf/lVIXgi0WTCm7Xv7
	Ae5t+rkw/aL0ousMp8pzkCr7J7MJZx67ouJZA57dXfLjpvIRzwOGJcwUqVzhoTni15mIPq6JThb
	yeRemOmEK8wD+3Ct
X-Received: by 2002:a17:90b:5590:b0:2ee:f687:6acb with SMTP id 98e67ed59e1d1-30e2e5c24b0mr3049824a91.13.1747193829183;
        Tue, 13 May 2025 20:37:09 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHEMic3JZfqHUduiY6RIFo4rKxWJxbdw/r/LByh2iH/VAXRKkC+svCTuRA6EfZQjPLBCUxbkg==
X-Received: by 2002:a17:90b:5590:b0:2ee:f687:6acb with SMTP id 98e67ed59e1d1-30e2e5c24b0mr3049782a91.13.1747193828788;
        Tue, 13 May 2025 20:37:08 -0700 (PDT)
Received: from [10.72.116.125] ([209.132.188.88])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-30e334e2503sm434299a91.31.2025.05.13.20.37.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 13 May 2025 20:37:08 -0700 (PDT)
Message-ID: <1ac10d00-c21c-44fd-9973-c32fd89b4ba1@redhat.com>
Date: Wed, 14 May 2025 11:36:58 +0800
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [kvm-unit-tests PATCH v3 05/16] scripts: Document environment
 variables
To: Alexandru Elisei <alexandru.elisei@arm.com>, andrew.jones@linux.dev,
 eric.auger@redhat.com, lvivier@redhat.com, thuth@redhat.com,
 frankja@linux.ibm.com, imbrenda@linux.ibm.com, nrb@linux.ibm.com,
 david@redhat.com, pbonzini@redhat.com
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev,
 linuxppc-dev@lists.ozlabs.org, kvm-riscv@lists.infradead.org,
 linux-s390@vger.kernel.org, will@kernel.org, julien.thierry.kdev@gmail.com,
 maz@kernel.org, oliver.upton@linux.dev, suzuki.poulose@arm.com,
 yuzenghui@huawei.com, joey.gouly@arm.com, andre.przywara@arm.com,
 Andrew Jones <drjones@redhat.com>
References: <20250507151256.167769-1-alexandru.elisei@arm.com>
 <20250507151256.167769-6-alexandru.elisei@arm.com>
From: Shaoqin Huang <shahuang@redhat.com>
In-Reply-To: <20250507151256.167769-6-alexandru.elisei@arm.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: Z-r6L5t_ulWpLJg3Xtz1we3RL7rGE26HUozZKHkO2YA_1747193829
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 5/7/25 11:12 PM, Alexandru Elisei wrote:
> Document the environment variables that influence how a test is executed
> by the run_tests.sh test runner.
> 
> Suggested-by: Andrew Jones <drjones@redhat.com>
> Reviewed-by: Andrew Jones <andrew.jones@linux.dev>
> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>

Reviewed-by: Shaoqin Huang <shahuang@redhat.com>

> ---
>   docs/unittests.txt |  5 ++++-
>   run_tests.sh       | 12 +++++++++---
>   2 files changed, 13 insertions(+), 4 deletions(-)
> 
> diff --git a/docs/unittests.txt b/docs/unittests.txt
> index 6eb315618dbd..ea0da959f008 100644
> --- a/docs/unittests.txt
> +++ b/docs/unittests.txt
> @@ -102,7 +102,8 @@ timeout
>   -------
>   timeout = <duration>
>   
> -Optional timeout in seconds, after which the test will be killed and fail.
> +Optional timeout in seconds, after which the test will be killed and fail. Can
> +be overwritten with the TIMEOUT=<duration> environment variable.
>   
>   check
>   -----
> @@ -113,3 +114,5 @@ can contain multiple files to check separated by a space, but each check
>   parameter needs to be of the form <path>=<value>
>   
>   The path and value cannot contain space, =, or shell wildcard characters.
> +
> +Can be overwritten with the CHECK environment variable with the same syntax.
> diff --git a/run_tests.sh b/run_tests.sh
> index f30b6dbd131c..dd9d27377905 100755
> --- a/run_tests.sh
> +++ b/run_tests.sh
> @@ -27,9 +27,15 @@ Usage: $0 [-h] [-v] [-a] [-g group] [-j NUM-TASKS] [-t] [-l]
>       -l, --list          Only output all tests list
>           --probe-maxsmp  Update the maximum number of VCPUs supported by host
>   
> -Set the environment variable QEMU=/path/to/qemu-system-ARCH to
> -specify the appropriate qemu binary for ARCH-run.
> -
> +The following environment variables are used:
> +
> +    QEMU            Path to QEMU binary for ARCH-run
> +    ACCEL           QEMU accelerator to use, e.g. 'kvm', 'hvf' or 'tcg'
> +    ACCEL_PROPS     Extra argument(s) to ACCEL
> +    MACHINE         QEMU machine type
> +    TIMEOUT         Timeout duration for the timeout(1) command
> +    CHECK           Overwrites the 'check' unit test parameter (see
> +                    docs/unittests.txt)
>   EOF
>   }
>   

-- 
Shaoqin

