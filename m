Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2055EC4332F
	for <kvmarm@archiver.kernel.org>; Sat, 24 Dec 2022 09:12:27 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9172A4BA8A;
	Sat, 24 Dec 2022 04:12:27 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id u6IL+srXbfF4; Sat, 24 Dec 2022 04:12:26 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4AA714BA1C;
	Sat, 24 Dec 2022 04:12:26 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6F2B34BA15
 for <kvmarm@lists.cs.columbia.edu>; Sat, 24 Dec 2022 04:12:25 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id hxySLjZqJhCQ for <kvmarm@lists.cs.columbia.edu>;
 Sat, 24 Dec 2022 04:12:24 -0500 (EST)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 590004B9C0
 for <kvmarm@lists.cs.columbia.edu>; Sat, 24 Dec 2022 04:12:24 -0500 (EST)
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
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-240-9KRF6q-KMy-n4PqPmIpPsw-1; Sat, 24 Dec 2022 04:12:22 -0500
X-MC-Unique: 9KRF6q-KMy-n4PqPmIpPsw-1
Received: by mail-ej1-f72.google.com with SMTP id
 xh12-20020a170906da8c00b007413144e87fso4673703ejb.14
 for <kvmarm@lists.cs.columbia.edu>; Sat, 24 Dec 2022 01:12:21 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=content-transfer-encoding:in-reply-to:from:references:cc:to
 :content-language:subject:user-agent:mime-version:date:message-id
 :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
 bh=K/8A/i9y6rIvKCnypgiTdopbEh62sIZ4224f2Kvswms=;
 b=XnL4eFOk6xxxkvjNlBTn6KQKwRbiOGzcb6TMvyXGJKp/lrIYzyH0IdeSpcu42aclRx
 NjBBQMbrKB3QXXDjIeGo/i6X6HvUFMVmRRZxwqeteCYN9CX8a9OjqK8SDb/kHoMKktfM
 Tf/agW/AKC8jY2BO96TkI+g6jv+LZcxIhmZNadlTqIweDzDaV7enIGxtS4kP8Z/xAL8D
 RNvKh0B/iVIMaG5mPREe69gg9PCmpjFc0s8A0qETox0ZbDlT86hD2LzM5It+CYy+m5/l
 CneHH8JHFwiVy0qARC4KY6Fw9hHVBuCJ9Czx+RQRbHxmpfML+G05S8BVIT0JnhPOJSnu
 qvCg==
X-Gm-Message-State: AFqh2krts5Q8E2n/r+tSQ1xuLW7z6YLPJMorznggp4dNkK6VvJ5aHraG
 PP1QBVLmEZ9oT5OTQNfXLWohCOuO1NVP2U//mRD9NyHHQL+YDMxK8y8u5DW9GhuKYAjSpVZ1WQt
 LrniLoZoCozRKWD/7JBG3Va4n
X-Received: by 2002:a17:906:4894:b0:7c0:beee:2f06 with SMTP id
 v20-20020a170906489400b007c0beee2f06mr10450187ejq.52.1671873141001; 
 Sat, 24 Dec 2022 01:12:21 -0800 (PST)
X-Google-Smtp-Source: AMrXdXvlm/vA6G01U45Ww3rRE/hpJxyrrrVFeI3NtGzIAEN1d8PbapEpyn4qgCdB7ow6B9vpaz9eng==
X-Received: by 2002:a17:906:4894:b0:7c0:beee:2f06 with SMTP id
 v20-20020a170906489400b007c0beee2f06mr10450165ejq.52.1671873140745; 
 Sat, 24 Dec 2022 01:12:20 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:63a7:c72e:ea0e:6045?
 ([2001:b07:6468:f312:63a7:c72e:ea0e:6045])
 by smtp.googlemail.com with ESMTPSA id
 10-20020a170906218a00b0073d796a1043sm2321829eju.123.2022.12.24.01.12.18
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Sat, 24 Dec 2022 01:12:19 -0800 (PST)
Message-ID: <a03fb002-ef66-e9ea-7447-baf3d3aff1d9@redhat.com>
Date: Sat, 24 Dec 2022 10:12:09 +0100
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
References: <20221213001653.3852042-1-seanjc@google.com>
 <20221213001653.3852042-7-seanjc@google.com>
From: Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20221213001653.3852042-7-seanjc@google.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Cc: Aaron Lewis <aaronlewis@google.com>, kvm@vger.kernel.org,
 Tom Rix <trix@redhat.com>, llvm@lists.linux.dev, linux-kernel@vger.kernel.org,
 kvmarm@lists.linux.dev, linux-riscv@lists.infradead.org,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
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

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
