Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29BB8159584
	for <kvmarm@lists.linux.dev>; Thu,  1 Feb 2024 08:29:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706776187; cv=none; b=CaGORb0Iv2bd5bcYNs0m4cwWXg5YCWtqWw2T5fB8YAp6ghwRNnFf0X+RBjrfJ3udJ4OIrt/+M6QE9mmgiaDYcdCT0OUho2c6TKR0QzNjk3CuW3N9g+o52L9H2GWAPqailD6FehcpCsC/j7gVHAEgNIaLxjD0s/wRjP4LmYjRWYo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706776187; c=relaxed/simple;
	bh=v+hGC2bF3Nf5l9lcZ2uOTOpTduo3WKTrXxiRGoug7UA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=jcCvuG9Ks/wwitEDJsLqPzv4ISDdsuOofe0TxQD4MFIH7ftK9DlYVvn5HQf5DMPlGnXT0OGp9dAsi6oxkgRQa4XPFy/cEuMr0yKwLviSh+oHsw3pMLappWpW+XQeMoHUeWV7tbUJKj9z3pmEFhOouMOSVulHMLbR43AUb9uz0e0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=EIaKVx5c; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="EIaKVx5c"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1706776185;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=mvQ3t1b1ivJLmzpQbMo2uY7w94izskCRDvtsOIIftSI=;
	b=EIaKVx5cvrzzXbeX0MHlApDNXl8B8odJLkNV9tiXnKBBZEJpcwK39UCrrSv1ZWBvUd0GjZ
	TCQyPxzl45sq57O8VsyVYUAq4zEqbVtFI1kCTqScG3r93qwyrUXHKuQJ8/A/ZmyWWxV2tH
	tqEYyMLKhlvmt/xEZATT93u9P/kegRk=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-196-jepXf_KZOxaOWDDWgu21ZQ-1; Thu, 01 Feb 2024 03:29:43 -0500
X-MC-Unique: jepXf_KZOxaOWDDWgu21ZQ-1
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-40ef9dea0d1so3836495e9.1
        for <kvmarm@lists.linux.dev>; Thu, 01 Feb 2024 00:29:43 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706776182; x=1707380982;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=mvQ3t1b1ivJLmzpQbMo2uY7w94izskCRDvtsOIIftSI=;
        b=REaSWroIkGvpJy6uXr0qJIn2S/3O5At2CqxBf7C1YvdHav0ZEN/Bgk1x3E7ummyfk+
         Er7WpTaB146u+9hjf9pa5KWxkVEWia/eeJFEMoNuLrmuKkRKYWZxSBh1GJW/CapCTxny
         Vk86XPclAh1jBgam7NPC5KW765rYZf+iqvMyJzqHvZ0DouT3NWxNEoENgsji2pdhpAM8
         q6viglxE3difmc5b6he6/RNQUCKHZuS3q5CRAkDe6ezsmCWuaUWmWfoBT/2Gm25I9BRo
         JnlQ7/YuaGNhQoeIt0cw5mPVy6AZ7/HZWAKy2EAVfUnlx7aOhUeBFjvyKiNUgOMa5Vjs
         EmxA==
X-Gm-Message-State: AOJu0Yy5RnZPQfhv+6gKaWik9aDmt6M6ZoEpCgraOfJEFNjW3WNZWZkD
	ubVPghvI4A7KC1RNER5He4CKW2mnkuGFVKFOscPMk7LOqO+/4ei0ZDtJh4ACR8j51npJ14YAEj2
	TH3ZyATHegQF4kO0c4DzbDb+lJb6xmK1UArfPetY6fTwsUrEhygWh/w==
X-Received: by 2002:a05:600c:41d2:b0:40f:afdc:7477 with SMTP id t18-20020a05600c41d200b0040fafdc7477mr3822292wmh.20.1706776182359;
        Thu, 01 Feb 2024 00:29:42 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHNDQLfzYQI4T9FsqCEhRvg6ZoySIqDCeBCbmTQSfGq1e5bLw9dmeKixhTiSNBORQCcxAOWfA==
X-Received: by 2002:a05:600c:41d2:b0:40f:afdc:7477 with SMTP id t18-20020a05600c41d200b0040fafdc7477mr3822268wmh.20.1706776182023;
        Thu, 01 Feb 2024 00:29:42 -0800 (PST)
X-Forwarded-Encrypted: i=0; AJvYcCVwXA/biyzycIzVd+P0rzohqAvgBKY4Y1Fbs9dzml3U5OaENh6NWpA5f4yXY3YJn56B9F67BRqsCXZVxhHpmlb+8l9p3rRJtt4F4FDBEKjVpMuzlZSW2TOOljXKmKAwm/b/7BKd3k/Wx7TJAFYb2xQHveM/Hunx3JuIapKlTPLfeyOo+GWgkgN7tdMc3BOcdkGi1HfbD1NMgHYnVsrWLRS/2MbeRiqjfcUL4O2G992z8LwTKskizVmvNeZSTRx9EHcsHGz/JxRzV/0BFvdoilP1VwvqGlKHkHXCIFvCiF+wUf2x+e8joTU=
Received: from ?IPV6:2a01:e0a:59e:9d80:527b:9dff:feef:3874? ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id l12-20020a1c790c000000b0040fba120c0bsm446368wme.0.2024.02.01.00.29.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 01 Feb 2024 00:29:40 -0800 (PST)
Message-ID: <ded71dfc-0233-4f91-9c27-69845836ba44@redhat.com>
Date: Thu, 1 Feb 2024 09:29:39 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: eric.auger@redhat.com
Subject: Re: [kvm-unit-tests PATCH v2 01/24] configure: Add ARCH_LIBDIR
To: Andrew Jones <andrew.jones@linux.dev>, kvm@vger.kernel.org,
 kvm-riscv@lists.infradead.org, kvmarm@lists.linux.dev
Cc: ajones@ventanamicro.com, anup@brainfault.org, atishp@atishpatra.org,
 pbonzini@redhat.com, thuth@redhat.com, alexandru.elisei@arm.com
References: <20240126142324.66674-26-andrew.jones@linux.dev>
 <20240126142324.66674-27-andrew.jones@linux.dev>
From: Eric Auger <eric.auger@redhat.com>
In-Reply-To: <20240126142324.66674-27-andrew.jones@linux.dev>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Drew,

On 1/26/24 15:23, Andrew Jones wrote:
> Prepare for an architecture which will share the same lib/$ARCH
> directory, but be configured with different arch names for different
> bit widths, i.e. riscv32 -> lib/riscv and riscv64 -> lib/riscv.
>
> Signed-off-by: Andrew Jones <andrew.jones@linux.dev>
> Reviewed-by: Thomas Huth <thuth@redhat.com>
> Acked-by: Thomas Huth <thuth@redhat.com>
Reviewed-by: Eric Auger <eric.auger@redhat.com>

Eric
> ---
>  Makefile  | 2 +-
>  configure | 2 ++
>  2 files changed, 3 insertions(+), 1 deletion(-)
>
> diff --git a/Makefile b/Makefile
> index 602910dda11b..4f35fffc685b 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -10,7 +10,7 @@ include config.mak
>  VPATH = $(SRCDIR)
>  
>  libdirs-get = $(shell [ -d "lib/$(1)" ] && echo "lib/$(1) lib/$(1)/asm")
> -ARCH_LIBDIRS := $(call libdirs-get,$(ARCH)) $(call libdirs-get,$(TEST_DIR))
> +ARCH_LIBDIRS := $(call libdirs-get,$(ARCH_LIBDIR)) $(call libdirs-get,$(TEST_DIR))
>  OBJDIRS := $(ARCH_LIBDIRS)
>  
>  DESTDIR := $(PREFIX)/share/kvm-unit-tests/
> diff --git a/configure b/configure
> index 6ee9b27a6af2..ada6512702a1 100755
> --- a/configure
> +++ b/configure
> @@ -198,6 +198,7 @@ fi
>  arch_name=$arch
>  [ "$arch" = "aarch64" ] && arch="arm64"
>  [ "$arch_name" = "arm64" ] && arch_name="aarch64"
> +arch_libdir=$arch
>  
>  if [ -z "$target" ]; then
>      target="qemu"
> @@ -391,6 +392,7 @@ PREFIX=$prefix
>  HOST=$host
>  ARCH=$arch
>  ARCH_NAME=$arch_name
> +ARCH_LIBDIR=$arch_libdir
>  PROCESSOR=$processor
>  CC=$cross_prefix$cc
>  CFLAGS=$cflags

