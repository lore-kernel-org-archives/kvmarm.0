Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 31772C433EF
	for <kvmarm@archiver.kernel.org>; Wed, 12 Jan 2022 15:49:22 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 95F964B1F0;
	Wed, 12 Jan 2022 10:49:21 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id HMTaQLIxIpI3; Wed, 12 Jan 2022 10:49:20 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5166C4B1F3;
	Wed, 12 Jan 2022 10:49:20 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9549C4B1E9
 for <kvmarm@lists.cs.columbia.edu>; Wed, 12 Jan 2022 10:49:19 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id pFilIDB0BNzD for <kvmarm@lists.cs.columbia.edu>;
 Wed, 12 Jan 2022 10:49:18 -0500 (EST)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 44DE54B1DA
 for <kvmarm@lists.cs.columbia.edu>; Wed, 12 Jan 2022 10:49:18 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1642002558;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=7itWgmWnZ91DtB2i3ZIJIZlEIAIGcoEdB/2ozTQ8AS0=;
 b=e/QOMS40WM+ijqmw3GsmQyk0X0WTvehGcXM3JS9pzS9XcHS/2hLz+0lowVUgu3zfkz3rTE
 zHUyJ05MQzZGe1Nc8YN14NDf+o5LnQnNm6GFMhnq++RX9beAW0drM9CC0oPPSoMPIz/e2b
 PZOwZgrjVXcNiWwE7XrYwcElzg89hVQ=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-240-GymYTfXLOWaifmiv-PYsfQ-1; Wed, 12 Jan 2022 10:49:11 -0500
X-MC-Unique: GymYTfXLOWaifmiv-PYsfQ-1
Received: by mail-ed1-f70.google.com with SMTP id
 c8-20020a05640227c800b003fdc1684cdeso2630825ede.12
 for <kvmarm@lists.cs.columbia.edu>; Wed, 12 Jan 2022 07:49:11 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=7itWgmWnZ91DtB2i3ZIJIZlEIAIGcoEdB/2ozTQ8AS0=;
 b=StPz0mIGoPOlcXzhYTr4xUWh7JKaHgAhV7b5O8/gUb9Qq5Hj5ki8//e2tb+4nEVUyZ
 tSFqS6TNmMjdCSs42s3W0pGDKALTpYvyWOsjYc56RAuZ4++dZxBtmEL9v0278pnF866K
 XU2w1KXdX9ZrS5uTyEEOdrfD2TysenQQDnbsTrjJOuNw1Y+QBYWPAfPPb/hz/mP7Xn2N
 4cKRv70o3TpkTQattw4e313OiAGKvmBmGZO0Uh/IBveHSR2w7X1wK4oR318tveOypV4I
 ahxDKLRwpnGobMXyL5MZJOgKxQCx7jLMz/pul7mJUOPPDc7gnpJ7RmqupboCZYwcupW8
 AASQ==
X-Gm-Message-State: AOAM530yZBH7cXrjNHX7Kf1yukGWOQ0MGjbDZ7NNHA0WjGrL1O9ZB9Dr
 h4FYVfqApgysaMh4NezPDHdRfBFUvObZJEcRYOcyx0zBoYjyTpupN5gOAOe5RIq0+nZ94Ooo+9l
 1T3Q3d3OYxALoJAvCMUz8wqNf
X-Received: by 2002:a17:907:1b24:: with SMTP id
 mp36mr248065ejc.487.1642002550446; 
 Wed, 12 Jan 2022 07:49:10 -0800 (PST)
X-Google-Smtp-Source: ABdhPJw40+QE09WlkrEISryOAcx48Ytgv3S0ky6bH1FTMs6+heuN9ei+cd5PFh5muS1eK7XPLuqb+w==
X-Received: by 2002:a17:907:1b24:: with SMTP id
 mp36mr248052ejc.487.1642002550234; 
 Wed, 12 Jan 2022 07:49:10 -0800 (PST)
Received: from gator (cst2-173-70.cust.vodafone.cz. [31.30.173.70])
 by smtp.gmail.com with ESMTPSA id f13sm31284ejf.53.2022.01.12.07.49.09
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Wed, 12 Jan 2022 07:49:09 -0800 (PST)
Date: Wed, 12 Jan 2022 16:49:07 +0100
From: Andrew Jones <drjones@redhat.com>
To: Ricardo Koller <ricarkol@google.com>
Subject: Re: [kvm-unit-tests PATCH v2] arm64: debug: mark test_[bp,wp,ss] as
 noinline
Message-ID: <20220112154907.gjuhetv4db6kbqwh@gator>
References: <20220112152155.2600645-1-ricarkol@google.com>
MIME-Version: 1.0
In-Reply-To: <20220112152155.2600645-1-ricarkol@google.com>
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=drjones@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvmarm@lists.cs.columbia.edu,
 kvm@vger.kernel.org, maz@kernel.org
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
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

On Wed, Jan 12, 2022 at 07:21:55AM -0800, Ricardo Koller wrote:
> Clang inlines some functions (like test_ss) which define global labels
> in inline assembly (e.g., ss_start). This results in:
> 
>     arm/debug.c:382:15: error: invalid symbol redefinition
>             asm volatile("ss_start:\n"
>                          ^
>     <inline asm>:1:2: note: instantiated into assembly here
>             ss_start:
>             ^
>     1 error generated.
> 
> Fix these functions by marking them as "noinline".
> 
> Cc: Andrew Jones <drjones@redhat.com>
> Signed-off-by: Ricardo Koller <ricarkol@google.com>
> ---
> This applies on top of: "[kvm-unit-tests PATCH 0/3] arm64: debug: add migration tests for debug state"
> which is in https://gitlab.com/rhdrjones/kvm-unit-tests/-/commits/arm/queue.
> 
>  arm/debug.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/arm/debug.c b/arm/debug.c
> index 54f059d..e9f8056 100644
> --- a/arm/debug.c
> +++ b/arm/debug.c
> @@ -264,7 +264,7 @@ static void do_migrate(void)
>  	report_info("Migration complete");
>  }
>  
> -static void test_hw_bp(bool migrate)
> +static noinline void test_hw_bp(bool migrate)
>  {
>  	extern unsigned char hw_bp0;
>  	uint32_t bcr;
> @@ -310,7 +310,7 @@ static void test_hw_bp(bool migrate)
>  
>  static volatile char write_data[16];
>  
> -static void test_wp(bool migrate)
> +static noinline void test_wp(bool migrate)
>  {
>  	uint32_t wcr;
>  	uint32_t mdscr;
> @@ -353,7 +353,7 @@ static void test_wp(bool migrate)
>  	}
>  }
>  
> -static void test_ss(bool migrate)
> +static noinline void test_ss(bool migrate)
>  {
>  	extern unsigned char ss_start;
>  	uint32_t mdscr;
> -- 
> 2.34.1.575.g55b058a8bb-goog
>

Applied to arm/queue.

Thanks,
drew 

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
