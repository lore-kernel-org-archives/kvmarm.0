Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CC8C210A
	for <kvmarm@lists.linux.dev>; Sat, 24 Dec 2022 09:12:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1671873143;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=K/8A/i9y6rIvKCnypgiTdopbEh62sIZ4224f2Kvswms=;
	b=SQEbp+wAX3Iz2zBTlRZXno/jf3xP8zgWso1HLoyFAb1mnTUQyTO7qW+V01RShqqjRok3gA
	OHuCUrpNmnO9NWrzdnV2N8kEUtezqnDnImyLk7a2GRCHsKm4lLCYaGRtHCACIWdpJlBed7
	WSCX5k54dvxRhUEH/fm4ynfSU3DA/10=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-226-etgWO2WYNm6Tqiu8ZcXIow-1; Sat, 24 Dec 2022 04:12:22 -0500
X-MC-Unique: etgWO2WYNm6Tqiu8ZcXIow-1
Received: by mail-ej1-f70.google.com with SMTP id qf33-20020a1709077f2100b007c155ab74e9so4680944ejc.18
        for <kvmarm@lists.linux.dev>; Sat, 24 Dec 2022 01:12:21 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=K/8A/i9y6rIvKCnypgiTdopbEh62sIZ4224f2Kvswms=;
        b=xiauTF0zo5XentPX+kTisqvPnMkXzdmpLa+SQEwyRXxlFrdkuPw5ls1kohFWm0+rpN
         +3RFKLyihef2jQDvhA2TSoxARoQozg2zJtBDAHW8o2XE2G5WevnfzbByXnvY5fnRa5V5
         db1CT8+tLoJYF9oDwryq038EQI5rfOR6UYfaPtZ4JXkxbAfZa8jtXjpFDiiL2u2pztMP
         awKct8sTm8cZOfPHHKMycblaPSdwi42gES7M5AuJMT4Hqk2yFs1xW/bRB4dZ9/h618HC
         +56kzmEezwlcWevUOd1+UKubu4NeNrJUQfmoRNOUtXlWVSHa5Lrmj1FtVvVSnkzhTW/n
         2UGg==
X-Gm-Message-State: AFqh2kpQ7b1eD8E/gCM3Q97iPtypoxg3xOapnP1EQa/y37fKyBjv7iaG
	/ec1NoApClGLiQECQBzeF2FIowWxpY+tSPDpjqdgQqYFadluG2EZMbR4QOHT8PT2GRVjFBQiIZj
	HNJSyDN5Tn/3X1bAs
X-Received: by 2002:a17:906:4894:b0:7c0:beee:2f06 with SMTP id v20-20020a170906489400b007c0beee2f06mr10450184ejq.52.1671873141000;
        Sat, 24 Dec 2022 01:12:21 -0800 (PST)
X-Google-Smtp-Source: AMrXdXvlm/vA6G01U45Ww3rRE/hpJxyrrrVFeI3NtGzIAEN1d8PbapEpyn4qgCdB7ow6B9vpaz9eng==
X-Received: by 2002:a17:906:4894:b0:7c0:beee:2f06 with SMTP id v20-20020a170906489400b007c0beee2f06mr10450165ejq.52.1671873140745;
        Sat, 24 Dec 2022 01:12:20 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:63a7:c72e:ea0e:6045? ([2001:b07:6468:f312:63a7:c72e:ea0e:6045])
        by smtp.googlemail.com with ESMTPSA id 10-20020a170906218a00b0073d796a1043sm2321829eju.123.2022.12.24.01.12.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 24 Dec 2022 01:12:19 -0800 (PST)
Message-ID: <a03fb002-ef66-e9ea-7447-baf3d3aff1d9@redhat.com>
Date: Sat, 24 Dec 2022 10:12:09 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Subject: Re: [PATCH 06/14] KVM: selftests: Rename UNAME_M to ARCH_DIR, fill
 explicitly for x86
To: Sean Christopherson <seanjc@google.com>, Marc Zyngier <maz@kernel.org>,
 Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt
 <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>,
 Nathan Chancellor <nathan@kernel.org>,
 Nick Desaulniers <ndesaulniers@google.com>
Cc: James Morse <james.morse@arm.com>,
 Alexandru Elisei <alexandru.elisei@arm.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>,
 Oliver Upton <oliver.upton@linux.dev>, Tom Rix <trix@redhat.com>,
 kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.linux.dev, kvmarm@lists.cs.columbia.edu,
 linux-riscv@lists.infradead.org, llvm@lists.linux.dev,
 linux-kernel@vger.kernel.org, Ricardo Koller <ricarkol@google.com>,
 Aaron Lewis <aaronlewis@google.com>,
 Raghavendra Rao Ananta <rananta@google.com>
References: <20221213001653.3852042-1-seanjc@google.com>
 <20221213001653.3852042-7-seanjc@google.com>
From: Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20221213001653.3852042-7-seanjc@google.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Message-ID: <20221224091209.w6VR4EUZDO0uJSP0iVBiTLbyQ-WmcrPQyzr6zEcmZpk@z>

On 12/13/22 01:16, Sean Christopherson wrote:
> -ifeq ($(ARCH),riscv)
> -	UNAME_M := riscv
> +ifeq ($(ARCH),x86)
> +	ARCH_DIR := x86_64
> +else ifeq ($(ARCH),arm64)
> +	ARCH_DIR := aarch64
> +else ifeq ($(ARCH),s390)
> +	ARCH_DIR := s390x
> +else ifeq ($(ARCH),riscv)
> +	ARCH_DIR := riscv
> +else
> +$(error Unknown architecture '$(ARCH)')
>   endif

$(error) would break compiling via tools/testing/selftests/Makefile, so 
I am squashing this:

diff --git a/tools/testing/selftests/kvm/Makefile 
b/tools/testing/selftests/kvm/Makefile
index d761a77c3a80..59f3eb53c932 100644
--- a/tools/testing/selftests/kvm/Makefile
+++ b/tools/testing/selftests/kvm/Makefile
@@ -13,10 +13,8 @@ else ifeq ($(ARCH),arm64)
  	ARCH_DIR := aarch64
  else ifeq ($(ARCH),s390)
  	ARCH_DIR := s390x
-else ifeq ($(ARCH),riscv)
-	ARCH_DIR := riscv
  else
-$(error Unknown architecture '$(ARCH)')
+	ARCH_DIR := $(ARCH)
  endif

  LIBKVM += lib/assert.c

Then the aarch64 and s390x directories can be renamed---x86 too, but the 
ifeq needs to stay (just changed to do x86_64->x86 instead of the other 
way round).

Paolo

