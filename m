Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CFA81FC7DF
	for <kvmarm@lists.linux.dev>; Thu, 13 Mar 2025 07:50:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741852225; cv=none; b=I1CWTqRZoweFBcSGDWR+HRPFk/SCDAGa5CEKSx0u6eNxev6RfAvOoLfbEPWlUz1saBbRpqDEjU1v4uuwamTBPGKlB5kzb77/xjBtZIIROVeLH2LGtl2HmfhI+vnBaQI24KoZ039gFUf8wuMHadDfyTZjEqqTRZUgrhTmjpG/+0k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741852225; c=relaxed/simple;
	bh=DE9V5qFXirrrDlZ2J0gaGeV+rEDW1f1V+Rz06kgDHxI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=GbuBAlZyn/0jxFPiPVpT0E9h4iGgBvRTqHlJHa5M0CTjO3t6rUVS7dlNrNd/EfI9lsz2nsxcUH2S1Py77fTHPiWzD2aSt2/eEmQ9PdLTJUhucVs9BR1GLOmRMpRtelnBQZ4ZLaLmIUbNw46aLCB5TejXAub050MTuVgyREwupY0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=iP4ZO2xl; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="iP4ZO2xl"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1741852222;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=MK8zU8BVCYnjzSS/b6+zVESpZfkVHFlkYo1MXlvFt+w=;
	b=iP4ZO2xlpzm5TFSus4KnfrxYw8z8Wg4a5CKw+wpuZFqfVL327bK8hGwxGaasPLLHvbDvdD
	sokxVBcHrhctHTRGOFM4XgOeLNA6FyehzzV2Zt6EEOf7i3XejfFA4GMs+CEXv/HY+vBTqQ
	yxL6bSBhREQgemrKDl/F3uBHTmhhd/g=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-326-I1m4BJpyMm25TMnMTe9G4A-1; Thu, 13 Mar 2025 03:50:18 -0400
X-MC-Unique: I1m4BJpyMm25TMnMTe9G4A-1
X-Mimecast-MFC-AGG-ID: I1m4BJpyMm25TMnMTe9G4A_1741852217
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-43d025a52c2so3047485e9.0
        for <kvmarm@lists.linux.dev>; Thu, 13 Mar 2025 00:50:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741852217; x=1742457017;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=MK8zU8BVCYnjzSS/b6+zVESpZfkVHFlkYo1MXlvFt+w=;
        b=lxUrvvRB8kbn91qI1qCUEjJX+HMRqEPVjwumR/A9Nhwen25Goe3iB4Grn+wDV8v6rN
         K5fVZmfUVfie5XyFql9GOCTrVlytP7K5D3vxu4fVrd601d2rWeGbgYjF3h1qz+tUsCBa
         WKb4m+GG14JYNJ2Tmk7tMo+H4Wt+oa10OrYSHrm/B6xc0MNKpFq1/50KqYL64Dr5+uxb
         oTo/SO2t5/6BQlrFkobvKveRB9QjDGoaSezZ0KCfLFdovZ1/AEXXyBsNlvUZql+GzHc2
         F0hez7jT8lczQZcnOENcl7RJdRpEaIonGC2n/l2xwlgph2K8hZOCyA7JMz3dqKRjyZGf
         BKPA==
X-Forwarded-Encrypted: i=1; AJvYcCWuPG9t960giV0i+Mf3AiMD9TV45iPStVXcrL461QLET+SrBY8Cb4Q9qD6MBRAgFHj2XdZ0QF8=@lists.linux.dev
X-Gm-Message-State: AOJu0YyubtK8iMEAwFYQ6YTuS5H30pdRw2oU3N5yrQ/GgeomB9veavYV
	sksl452HEWyGhxGdHGKqZU+C8t2KyWDIgzWPjEZClJKpWgchjkjU+K+CzmSNUhfB8zGV0sK1dh/
	pBX3tsvdgdCUJruhjJ+EIr4Yivkc3Tr0z9MbtIWGPHrpbH+pyUA5EnQ==
X-Gm-Gg: ASbGncvHkZosVNvypGg3an1Mcnlfh7vHZW9DtYKSUOCkgIjJL0cr1oLYTBdcSpHmnVn
	zMfRCRMGG6N+rLjWD8BEgCAbe7W0oHZ+YMVB7FFGpUUCZkq3Hqh/mb9zVMWKfoJGdb3l7Guqs+g
	/RMDEf4JKcpAl4bL/fUXeCdiaVHflW4AQo0PM599BG9cqPhnp0Ccf6BVifQU/ob0K7JFwFuT8kW
	EwlE3iwZ6fb8SvU4+tneKv61hCn6ACUtM06nmcgnPe9tAzd9A7XHub8pn6JkZeJf6HyhwWJSYEN
	jWJjUiNPL8cOHsbOqixUhodGdB6pTeaDsNuAG4YSnN5tl8I=
X-Received: by 2002:a05:600c:1d09:b0:43c:efed:732b with SMTP id 5b1f17b1804b1-43cefed78bcmr155422005e9.5.1741852217425;
        Thu, 13 Mar 2025 00:50:17 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFwegUed+fQ9ljIYT2+ReraOGwFw7qJPttYdCzfqNHOxAXgAxI15SBvV5/+7QXKHcBvWKjG5A==
X-Received: by 2002:a05:600c:1d09:b0:43c:efed:732b with SMTP id 5b1f17b1804b1-43cefed78bcmr155421735e9.5.1741852217063;
        Thu, 13 Mar 2025 00:50:17 -0700 (PDT)
Received: from [192.168.0.7] (ip-109-42-51-207.web.vodafone.de. [109.42.51.207])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-395c8e43244sm1218116f8f.60.2025.03.13.00.50.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 13 Mar 2025 00:50:16 -0700 (PDT)
Message-ID: <0019ac7e-b190-4b1d-9c8d-f5f039cd53ba@redhat.com>
Date: Thu, 13 Mar 2025 08:50:14 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [kvm-unit-tests PATCH v2] Makefile: Use CFLAGS in cc-option
To: Andrew Jones <andrew.jones@linux.dev>, kvm@vger.kernel.org,
 kvmarm@lists.linux.dev, kvm-riscv@lists.infradead.org,
 linuxppc-dev@lists.ozlabs.org, linux-s390@vger.kernel.org
Cc: pbonzini@redhat.com, alexandru.elisei@arm.com, eric.auger@redhat.com,
 lvivier@redhat.com, frankja@linux.ibm.com, imbrenda@linux.ibm.com,
 nrb@linux.ibm.com
References: <20250307091828.57933-2-andrew.jones@linux.dev>
From: Thomas Huth <thuth@redhat.com>
Autocrypt: addr=thuth@redhat.com; keydata=
 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
In-Reply-To: <20250307091828.57933-2-andrew.jones@linux.dev>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: PG0oxf7EIJ-M9yvyaZUBmk4WVXGVYwCmxeG8VBXvUOQ_1741852217
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 07/03/2025 10.18, Andrew Jones wrote:
> When cross compiling with clang we need to specify the target in
> CFLAGS and cc-option will fail to recognize target-specific options
> without it. Add CFLAGS to the CC invocation in cc-option.
> 
> The introduction of the realmode_bits variable is necessary to
> avoid make failing to build x86 due to CFLAGS referencing itself.
> 
> Signed-off-by: Andrew Jones <andrew.jones@linux.dev>
> ---
> v2:
>   - Fixed x86 builds with the realmode_bits variable
> 
>   Makefile            | 2 +-
>   x86/Makefile.common | 3 ++-
>   2 files changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/Makefile b/Makefile
> index 78352fced9d4..9dc5d2234e2a 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -21,7 +21,7 @@ DESTDIR := $(PREFIX)/share/kvm-unit-tests/
>   
>   # cc-option
>   # Usage: OP_CFLAGS+=$(call cc-option, -falign-functions=0, -malign-functions=0)
> -cc-option = $(shell if $(CC) -Werror $(1) -S -o /dev/null -xc /dev/null \
> +cc-option = $(shell if $(CC) $(CFLAGS) -Werror $(1) -S -o /dev/null -xc /dev/null \
>                 > /dev/null 2>&1; then echo "$(1)"; else echo "$(2)"; fi ;)
>   
>   libcflat := lib/libcflat.a
> diff --git a/x86/Makefile.common b/x86/Makefile.common
> index 0b7f35c8de85..e97464912e28 100644
> --- a/x86/Makefile.common
> +++ b/x86/Makefile.common
> @@ -98,6 +98,7 @@ tests-common = $(TEST_DIR)/vmexit.$(exe) $(TEST_DIR)/tsc.$(exe) \
>   ifneq ($(CONFIG_EFI),y)
>   tests-common += $(TEST_DIR)/realmode.$(exe) \
>   		$(TEST_DIR)/la57.$(exe)
> +realmode_bits := $(if $(call cc-option,-m16,""),16,32)
>   endif
>   
>   test_cases: $(tests-common) $(tests)
> @@ -108,7 +109,7 @@ $(TEST_DIR)/realmode.elf: $(TEST_DIR)/realmode.o
>   	$(LD) -m elf_i386 -nostdlib -o $@ \
>   	      -T $(SRCDIR)/$(TEST_DIR)/realmode.lds $^
>   
> -$(TEST_DIR)/realmode.o: bits = $(if $(call cc-option,-m16,""),16,32)
> +$(TEST_DIR)/realmode.o: bits = $(realmode_bits)
>   
>   $(TEST_DIR)/access_test.$(bin): $(TEST_DIR)/access.o
>   

Reviewed-by: Thomas Huth <thuth@redhat.com>

