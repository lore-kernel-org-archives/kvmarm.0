Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 326D121C17D
	for <kvmarm@lists.linux.dev>; Mon, 17 Mar 2025 08:19:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742199556; cv=none; b=eqg1d4dDdh3bjNg/eBA/OIEfpgjLjl2nW6+WN+7bd+J2lZTOIM7Dn3H314pnBZ40+N8NVSAccqHB2yKJpXaKUYQmySlYrcqLUvWT+qps43Q7zQ3RcnYbmD++Eu59t/zJOOf28CPk/EmW4WNthI3W/qINg7cxKEdwm+rfqgxh9LA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742199556; c=relaxed/simple;
	bh=qxYH/w/AG28+kJrAB1ECYDC3YrKaGk2Z29z95bv0URc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=W3M4Vg7XVt0oTy3w6/dg+oNAyFV3Ibcf5LIUazKGdRur+C+iuLFln3TfM3Jfc2XXcshW187JfyFSr/rRvzSapWIAx3Qsq+q74omimgbXQfKGbhC38RaCgv7FJXk8/mXYb7DSA54Rkhf4t2LNI5ct0PmAq0TqGvs2MRcTbfMTHN8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=JwyVRTCX; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="JwyVRTCX"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1742199554;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=0nejHxLLnivIrRTuFTd2M1TZx73UJZS8r5WGx9tsowI=;
	b=JwyVRTCXAgF44QJlxxCqSEdykoTOOVceRarNhUr21+spVD6rzNDUs+LSmZ/tH1ZrpTyk37
	B3RBKl3OJnuXcPUZ5Dzf3pDVkfeGKdYW6i8iT27MXSU7OeYc8UvkSBDyq/GB/+iuADfrwW
	Zsb/vywtd+BTgcBNG0d6fY29idhbTzo=
Received: from mail-il1-f200.google.com (mail-il1-f200.google.com
 [209.85.166.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-477-3umht5KcPp6FmG84mCxrqw-1; Mon, 17 Mar 2025 04:19:12 -0400
X-MC-Unique: 3umht5KcPp6FmG84mCxrqw-1
X-Mimecast-MFC-AGG-ID: 3umht5KcPp6FmG84mCxrqw_1742199551
Received: by mail-il1-f200.google.com with SMTP id e9e14a558f8ab-3d443811ed2so92316575ab.3
        for <kvmarm@lists.linux.dev>; Mon, 17 Mar 2025 01:19:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742199551; x=1742804351;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=0nejHxLLnivIrRTuFTd2M1TZx73UJZS8r5WGx9tsowI=;
        b=dEyh3u65Y9a5HiF3jePsNpWAzxnf6zAdJlL/VknRUZZrHseZDgiQ2eBlg5IJ6m5Ra/
         r42O/w26NyjPn6qzmATm0FaQocuWE7sbvcQcIZKyEWwISRzpIyMD4treusSgmhha2vZ4
         +H1Sj1crtUG+DqtQL8Q7qRSbfGwzGQylK10xvGxWHIvR2M8Jzof/tMSMwehbnuHsa23l
         AOile+MOocwZ6S0a8yaCtAiu8KwcYFXiNcZ4JMPsYmyzaKmvFywfB3w0gLB4QYRX3CpP
         puk1HWQ5A+6esGfGmHhSTk3Cjym4XkCANOUPhrpJUzPK4waGR3vWAiUub58z5NcbpU4G
         euEw==
X-Gm-Message-State: AOJu0YwbuqGNGaTPZFAeesOPMVN4V/gEDQLyRe2XCso108QoXBz4E2XJ
	Tvh7sUSuC8akAqVObiYdnz8L+SCLlgNZgTnAObPAqrJzHH7HtWXE+QkiOdK8bL1P0yDq97Z8+9Z
	ep8vScPXn9nx+hQvHf0bWfT7bTY6tXoQViFMq9Guh/jcPgdi6HX5H3g==
X-Gm-Gg: ASbGncuaq4zhgkVMWu47SI1HN9XBaVu24nhcMk+1DBAYMra6Gz1ek5V7NIXIow5lvpK
	pJRj6bSXBwI0NyEVMUujHpwr59lZOVBRapvVuoXfoEvxmiglk+N/CKjOn7s1VhsozznWEPWVWFa
	ZNfJLSjHLEyYpQmAz0wJ0pkSPvUmiuGkwQnrLBDUoifNqyh2EDZXBSvB9VQQDFYeV62lzKqiXaM
	xxzO5cfB6MLALlT7XjZNbKStDn8m14WFHM70K84SB3TYP8rvHVtyoZSe2No97XlpSxIqhQY6QdT
	SRSIiG1hNTZvoQ2x1zYXr+bFyd5A8n6jhZ8k8LvhX0RId2cTgfwXXRgRH8o2SiM=
X-Received: by 2002:a05:6e02:214d:b0:3d4:6e2f:b493 with SMTP id e9e14a558f8ab-3d483a1a038mr100733415ab.11.1742199551365;
        Mon, 17 Mar 2025 01:19:11 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGsEkTjItCn+3c/1exaejxjUCNrW349jWciioJ8unsR3OwQFSF90QFz+g/WpvO1aQ2salG17A==
X-Received: by 2002:a05:6e02:214d:b0:3d4:6e2f:b493 with SMTP id e9e14a558f8ab-3d483a1a038mr100733315ab.11.1742199551067;
        Mon, 17 Mar 2025 01:19:11 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:59e:9d80:527b:9dff:feef:3874? ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4f26372760asm2145612173.67.2025.03.17.01.19.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 17 Mar 2025 01:19:10 -0700 (PDT)
Message-ID: <1b0233dc-b303-4317-a65d-572cc3582b8a@redhat.com>
Date: Mon, 17 Mar 2025 09:19:06 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: eric.auger@redhat.com
Subject: Re: [kvm-unit-tests PATCH v2 1/5] configure: arm64: Don't display
 'aarch64' as the default architecture
To: Jean-Philippe Brucker <jean-philippe@linaro.org>, andrew.jones@linux.dev,
 alexandru.elisei@arm.com
Cc: kvmarm@lists.linux.dev, kvm@vger.kernel.org,
 kvm-riscv@lists.infradead.org, vladimir.murzin@arm.com
References: <20250314154904.3946484-2-jean-philippe@linaro.org>
 <20250314154904.3946484-3-jean-philippe@linaro.org>
From: Eric Auger <eric.auger@redhat.com>
In-Reply-To: <20250314154904.3946484-3-jean-philippe@linaro.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: U02e224tzPS80BHUXrQVCkOm6Mv7UH5J4Ji65LDXgIs_1742199551
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Jean-Philippe,


On 3/14/25 4:49 PM, Jean-Philippe Brucker wrote:
> From: Alexandru Elisei <alexandru.elisei@arm.com>
>
> --arch=aarch64, intentional or not, has been supported since the initial
> arm64 support, commit 39ac3f8494be ("arm64: initial drop"). However,
> "aarch64" does not show up in the list of supported architectures, but
> it's displayed as the default architecture if doing ./configure --help
> on an arm64 machine.
>
> Keep everything consistent and make sure that the default value for
> $arch is "arm64", but still allow --arch=aarch64, in case they are users
there
> that use this configuration for kvm-unit-tests.
>
> The help text for --arch changes from:
>
>    --arch=ARCH            architecture to compile for (aarch64). ARCH can be one of:
>                            arm, arm64, i386, ppc64, riscv32, riscv64, s390x, x86_64
>
> to:
>
>     --arch=ARCH            architecture to compile for (arm64). ARCH can be one of:
>                            arm, arm64, i386, ppc64, riscv32, riscv64, s390x, x86_64
>
> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
> ---
>  configure | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
>
> diff --git a/configure b/configure
> index 06532a89..dc3413fc 100755
> --- a/configure
> +++ b/configure
> @@ -15,8 +15,9 @@ objdump=objdump
>  readelf=readelf
>  ar=ar
>  addr2line=addr2line
> -arch=$(uname -m | sed -e 's/i.86/i386/;s/arm64/aarch64/;s/arm.*/arm/;s/ppc64.*/ppc64/')
> -host=$arch
> +host=$(uname -m | sed -e 's/i.86/i386/;s/arm64/aarch64/;s/arm.*/arm/;s/ppc64.*/ppc64/')
> +arch=$host
> +[ "$arch" = "aarch64" ] && arch="arm64"
Looks the same it done again below

arch_name=$arch
[ "$arch" = "aarch64" ] && arch="arm64"
[ "$arch_name" = "arm64" ] && arch_name="aarch64" <---
arch_libdir=$arch

maybe we could move all arch settings at the same location so that it
becomes clearer?

Thanks

Eric

>  cross_prefix=
>  endian=""
>  pretty_print_stacks=yes

