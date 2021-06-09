Return-Path: <SRS0=1TKy=LD=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.1 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B4D0DC48BCF
	for <kvmarm@archiver.kernel.org>; Wed,  9 Jun 2021 14:46:28 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 4F396613BC
	for <kvmarm@archiver.kernel.org>; Wed,  9 Jun 2021 14:46:28 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4F396613BC
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id F16E140821;
	Wed,  9 Jun 2021 10:46:27 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id hxLlP4ASftD5; Wed,  9 Jun 2021 10:46:27 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 08F6C4086A;
	Wed,  9 Jun 2021 10:46:27 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BECEF40821
 for <kvmarm@lists.cs.columbia.edu>; Wed,  9 Jun 2021 10:46:25 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id yJBytrxw9cTg for <kvmarm@lists.cs.columbia.edu>;
 Wed,  9 Jun 2021 10:46:24 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D540440629
 for <kvmarm@lists.cs.columbia.edu>; Wed,  9 Jun 2021 10:46:24 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1623249984;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=YIqvjSEU4FgOL3T+Qh1WRtqKFo8pGZcLfL/2xIjJVgQ=;
 b=BiZqoVIZv9Irp+NfjLECWO2vAPXp5VzS/VrZ/at1DStyP3PZ95BdL1OTnCyG8rj2JOdQOy
 4DwG1JK8SSSYKNqnV6N4ya9r2RjK95oAYJOl613AQPPKu0oRX9HF+JvXhwW71nEulvXMel
 Cwzqlz6O4nLPoGdN6qRsG1mXsYlGrYE=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-320-M6XWRhjoNTGq-Jb5r0rZsw-1; Wed, 09 Jun 2021 10:46:23 -0400
X-MC-Unique: M6XWRhjoNTGq-Jb5r0rZsw-1
Received: by mail-wm1-f69.google.com with SMTP id
 m33-20020a05600c3b21b02901a44b1d2d87so2022705wms.3
 for <kvmarm@lists.cs.columbia.edu>; Wed, 09 Jun 2021 07:46:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:subject:to:cc:references:from:organization
 :message-id:date:user-agent:mime-version:in-reply-to
 :content-language:content-transfer-encoding;
 bh=YIqvjSEU4FgOL3T+Qh1WRtqKFo8pGZcLfL/2xIjJVgQ=;
 b=VHPNFZz5Ne3Azx0Te7gMZKKGLK5+EYv3WadNf3gIoRfHuYTKHOKHmf2/HcVJ35nG/e
 KBOJjWYY6nzcp9M9kecHvMi/Jq6dnNth5OdX1v4wL/q6tbA32m/GeNPh79pGRzG02a/4
 3GKJrdPBxxq1wbxdPStDFw/o0fE9ZkuLYYHDz9pieYOoQBwQl2LxsQ9r8lSQXYLzQvj+
 YDMTPGlFDVf8hy3w74OiUw9Qc4AlXUzRGhtUIMSlx9lgbCiZ5jy0X0Uv2SqMcm1noMV0
 oF4D8gFsohEbHRnHmd7+jDOqb0ccV/YtpXGHiMr8w6BHY0VIUMRCnPCi10I3EWaJB4VO
 Ty/w==
X-Gm-Message-State: AOAM531Qd2cQNyOJOqX8KyICzHGlY7QdpqC1DrQk2ZsqhPGW6yEgsT4T
 qlQ3Txna5nUm8olXp96JvXEE2lXs2kgwXH89O6UwEUC5t33nXbVEsqdu52nT9/+FMH4r0tkiciT
 7a0jkMTVItXkmEOhIPbhLuKqL
X-Received: by 2002:a05:6000:1c1:: with SMTP id
 t1mr188258wrx.282.1623249982378; 
 Wed, 09 Jun 2021 07:46:22 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwYGAMXz2ChPOq3Q/uYsovwSNcvm3wQtqcAcXSOMYfajhjXyyWekzuMWA5VoJWHNrDFPXvJrw==
X-Received: by 2002:a05:6000:1c1:: with SMTP id
 t1mr188234wrx.282.1623249982170; 
 Wed, 09 Jun 2021 07:46:22 -0700 (PDT)
Received: from [192.168.3.132] (p5b0c611d.dip0.t-ipconnect.de. [91.12.97.29])
 by smtp.gmail.com with ESMTPSA id
 u20sm10489wmq.24.2021.06.09.07.46.21
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Wed, 09 Jun 2021 07:46:21 -0700 (PDT)
Subject: Re: [kvm-unit-tests PATCH v2 3/7] asm-generic: unify header guards
To: Cornelia Huck <cohuck@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>,
 Thomas Huth <thuth@redhat.com>, Andrew Jones <drjones@redhat.com>
References: <20210609143712.60933-1-cohuck@redhat.com>
 <20210609143712.60933-4-cohuck@redhat.com>
From: David Hildenbrand <david@redhat.com>
Organization: Red Hat
Message-ID: <3b614940-b8be-244c-5271-23dffbd02ae9@redhat.com>
Date: Wed, 9 Jun 2021 16:46:20 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20210609143712.60933-4-cohuck@redhat.com>
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=david@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Cc: Laurent Vivier <lvivier@redhat.com>, linux-s390@vger.kernel.org,
 Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org,
 kvm-ppc@vger.kernel.org, Claudio Imbrenda <imbrenda@linux.ibm.com>,
 kvmarm@lists.cs.columbia.edu
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

On 09.06.21 16:37, Cornelia Huck wrote:
> Standardize header guards to _ASM_GENERIC_HEADER_H_.
> 
> Signed-off-by: Cornelia Huck <cohuck@redhat.com>
> ---
>   lib/asm-generic/atomic.h          | 4 ++--
>   lib/asm-generic/barrier.h         | 6 +++---
>   lib/asm-generic/memory_areas.h    | 4 ++--
>   lib/asm-generic/pci-host-bridge.h | 4 ++--
>   4 files changed, 9 insertions(+), 9 deletions(-)
> 
> diff --git a/lib/asm-generic/atomic.h b/lib/asm-generic/atomic.h
> index 26b645a7cc18..b09ce95053e7 100644
> --- a/lib/asm-generic/atomic.h
> +++ b/lib/asm-generic/atomic.h
> @@ -1,5 +1,5 @@
> -#ifndef __ASM_GENERIC_ATOMIC_H__
> -#define __ASM_GENERIC_ATOMIC_H__
> +#ifndef _ASM_GENERIC_ATOMIC_H_
> +#define _ASM_GENERIC_ATOMIC_H_
>   
>   /* From QEMU include/qemu/atomic.h */
>   #define atomic_fetch_inc(ptr)  __sync_fetch_and_add(ptr, 1)
> diff --git a/lib/asm-generic/barrier.h b/lib/asm-generic/barrier.h
> index 6a990ff8d5a5..5499a5664d4d 100644
> --- a/lib/asm-generic/barrier.h
> +++ b/lib/asm-generic/barrier.h
> @@ -1,5 +1,5 @@
> -#ifndef _ASM_BARRIER_H_
> -#define _ASM_BARRIER_H_
> +#ifndef _ASM_GENERIC_BARRIER_H_
> +#define _ASM_GENERIC_BARRIER_H_
>   /*
>    * asm-generic/barrier.h
>    *
> @@ -32,4 +32,4 @@
>   #define cpu_relax()	asm volatile ("":::"memory")
>   #endif
>   
> -#endif /* _ASM_BARRIER_H_ */
> +#endif /* _ASM_GENERIC_BARRIER_H_ */
> diff --git a/lib/asm-generic/memory_areas.h b/lib/asm-generic/memory_areas.h
> index 3074afe23393..c86db255ecee 100644
> --- a/lib/asm-generic/memory_areas.h
> +++ b/lib/asm-generic/memory_areas.h
> @@ -1,5 +1,5 @@
> -#ifndef __ASM_GENERIC_MEMORY_AREAS_H__
> -#define __ASM_GENERIC_MEMORY_AREAS_H__
> +#ifndef _ASM_GENERIC_MEMORY_AREAS_H_
> +#define _ASM_GENERIC_MEMORY_AREAS_H_
>   
>   #define AREA_NORMAL_PFN 0
>   #define AREA_NORMAL_NUMBER 0
> diff --git a/lib/asm-generic/pci-host-bridge.h b/lib/asm-generic/pci-host-bridge.h
> index 9e91499b9446..174ff341dd0d 100644
> --- a/lib/asm-generic/pci-host-bridge.h
> +++ b/lib/asm-generic/pci-host-bridge.h
> @@ -1,5 +1,5 @@
> -#ifndef _ASM_PCI_HOST_BRIDGE_H_
> -#define _ASM_PCI_HOST_BRIDGE_H_
> +#ifndef _ASM_GENERIC_PCI_HOST_BRIDGE_H_
> +#define _ASM_GENERIC_PCI_HOST_BRIDGE_H_
>   /*
>    * Copyright (C) 2016, Red Hat Inc, Alexander Gordeev <agordeev@redhat.com>
>    *
> 

Reviewed-by: David Hildenbrand <david@redhat.com>

-- 
Thanks,

David / dhildenb

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
