Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D11A420F8
	for <kvmarm@lists.linux.dev>; Mon,  1 May 2023 12:41:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1682944908;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=fKMPWxsBfvIcbsbwykvKjWGLcJ2fFrJZa2HJMFlk8k8=;
	b=KTw5bniPoQbwyo5pHXHMORuv2O5Rj1vEW8MLdK4JbFIEnYOZ7TMfngLgPs4XJrQIbCL+M2
	q20qzvNeTSJlwaubgMAW8QGyblhXPFMBHNYPM/v3BvQDc93lrftSTAG6lamxydf3zjs8/h
	ipRN9wtrKR8orst3T5DHaNujv31mkcg=
Received: from mail-pl1-f197.google.com (mail-pl1-f197.google.com
 [209.85.214.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-75-z3G-aNvXM_CN0LyCVXDVSQ-1; Mon, 01 May 2023 08:41:47 -0400
X-MC-Unique: z3G-aNvXM_CN0LyCVXDVSQ-1
Received: by mail-pl1-f197.google.com with SMTP id d9443c01a7336-1a961bfed2dso1024485ad.1
        for <kvmarm@lists.linux.dev>; Mon, 01 May 2023 05:41:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682944906; x=1685536906;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=fKMPWxsBfvIcbsbwykvKjWGLcJ2fFrJZa2HJMFlk8k8=;
        b=OLYPd7sm71DpS4A0dUmCB6EGUTxwmO2uTxO2afeukNwo+kDv2lxXEIfSXa2wX9LCrv
         cY7EcDA9tSglbYl3WJRpLPwDz6UoCUul7yBXK7ObRPOgzMl7c/kImkhnCOdOkiZizlkz
         nM33rbH5dx0sjP41UDcyaHjAbZslpc0nkKLEdsFvxSwtKeaUHH1OU2HKSxN7n1y/pTlO
         Op+ZA7Y4yi0T/7TE+9MC0nIsmGdCmnX9WdqlC95AaVsCFTiR6ozj1c72J8Tyh4PYomzS
         RJuX8fp6jBHomVg/olHnoQkkZejzAwxPLoB3YdAKL1pF/MRTyWpqE3NOiZ9sDo7J/qz/
         WUNA==
X-Gm-Message-State: AC+VfDzydi4EsYE+Bnz62qS/E4Mpyz6+hcqgZDAYrCNXkaP6jSsWgj5X
	DpUTxdKbSGsj40ceCXNuNdW8Sf+xu2ngyPxAvjk5ym3ted6AOrRO6jUc4+Vqx8iOWVmAvUJcY7p
	U0wVu5VHqZsg/5DNL
X-Received: by 2002:a17:903:41c4:b0:1a7:db2f:e918 with SMTP id u4-20020a17090341c400b001a7db2fe918mr13620975ple.1.1682944906199;
        Mon, 01 May 2023 05:41:46 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ7E9kWQENcbQpSEsKYxzb7I6bzQxCoS7T+2JxMpx98zbJ2WdvOjFhF4Dq4GQRssYxUluFgPbg==
X-Received: by 2002:a17:903:41c4:b0:1a7:db2f:e918 with SMTP id u4-20020a17090341c400b001a7db2fe918mr13620956ple.1.1682944905915;
        Mon, 01 May 2023 05:41:45 -0700 (PDT)
Received: from [10.66.61.39] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id o3-20020a170902778300b001a1a07d04e6sm17783018pll.77.2023.05.01.05.41.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 01 May 2023 05:41:45 -0700 (PDT)
Message-ID: <c458cf99-d0a9-1279-8bae-ad14ccb45a06@redhat.com>
Date: Mon, 1 May 2023 20:41:42 +0800
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [kvm-unit-tests PATCH v5 02/29] x86: Move x86_64-specific EFI
 CFLAGS to x86_64 Makefile
To: Nikos Nikoleris <nikos.nikoleris@arm.com>, kvm@vger.kernel.org,
 kvmarm@lists.linux.dev, andrew.jones@linux.dev
Cc: pbonzini@redhat.com, alexandru.elisei@arm.com, ricarkol@google.com
References: <20230428120405.3770496-1-nikos.nikoleris@arm.com>
 <20230428120405.3770496-3-nikos.nikoleris@arm.com>
From: Shaoqin Huang <shahuang@redhat.com>
In-Reply-To: <20230428120405.3770496-3-nikos.nikoleris@arm.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 4/28/23 20:03, Nikos Nikoleris wrote:
> Compiler flag -macculate-outgoing-args is only needed by the x86_64
> ABI. Move it to the relevant Makefile.
> 
> Signed-off-by: Nikos Nikoleris <nikos.nikoleris@arm.com>
> Reviewed-by: Ricardo Koller <ricarkol@google.com>
Reviewed-by: Shaoqin Huang <shahuang@redhat.com>
> ---
>   Makefile            | 4 ----
>   x86/Makefile.x86_64 | 4 ++++
>   2 files changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/Makefile b/Makefile
> index 6ed5deac..307bc291 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -40,14 +40,10 @@ OBJDIRS += $(LIBFDT_objdir)
>   
>   # EFI App
>   ifeq ($(CONFIG_EFI),y)
> -EFI_ARCH = x86_64
>   EFI_CFLAGS := -DCONFIG_EFI
>   # The following CFLAGS and LDFLAGS come from:
>   #   - GNU-EFI/Makefile.defaults
>   #   - GNU-EFI/apps/Makefile
> -# Function calls must include the number of arguments passed to the functions
> -# More details: https://wiki.osdev.org/GNU-EFI
> -EFI_CFLAGS += -maccumulate-outgoing-args
>   # GCC defines wchar to be 32 bits, but EFI expects 16 bits
>   EFI_CFLAGS += -fshort-wchar
>   # EFI applications use PIC as they are loaded to dynamic addresses, not a fixed
> diff --git a/x86/Makefile.x86_64 b/x86/Makefile.x86_64
> index f483dead..2771a6fa 100644
> --- a/x86/Makefile.x86_64
> +++ b/x86/Makefile.x86_64
> @@ -2,6 +2,10 @@ cstart.o = $(TEST_DIR)/cstart64.o
>   bits = 64
>   ldarch = elf64-x86-64
>   ifeq ($(CONFIG_EFI),y)
> +# Function calls must include the number of arguments passed to the functions
> +# More details: https://wiki.osdev.org/GNU-EFI
> +CFLAGS += -maccumulate-outgoing-args
> +
>   exe = efi
>   bin = so
>   FORMAT = efi-app-x86_64

-- 
Shaoqin

