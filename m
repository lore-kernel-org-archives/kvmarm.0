Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E20BEC433FE
	for <kvmarm@archiver.kernel.org>; Tue, 11 Jan 2022 19:43:03 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3CD304B277;
	Tue, 11 Jan 2022 14:43:03 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id cECHzPMGFs54; Tue, 11 Jan 2022 14:43:02 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 205864B278;
	Tue, 11 Jan 2022 14:43:02 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 263C44B276
 for <kvmarm@lists.cs.columbia.edu>; Tue, 11 Jan 2022 14:43:01 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id BfsTJy-XwRIk for <kvmarm@lists.cs.columbia.edu>;
 Tue, 11 Jan 2022 14:43:00 -0500 (EST)
Received: from mail-pj1-f45.google.com (mail-pj1-f45.google.com
 [209.85.216.45])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id F24324B272
 for <kvmarm@lists.cs.columbia.edu>; Tue, 11 Jan 2022 14:42:59 -0500 (EST)
Received: by mail-pj1-f45.google.com with SMTP id pf13so829573pjb.0
 for <kvmarm@lists.cs.columbia.edu>; Tue, 11 Jan 2022 11:42:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=/FgK5IAnk6FTMgJ52e8i7lV+7gxkfwjZm7Vn+Nisr9w=;
 b=cyRc7pebHjcqfec09Gg909vXcbxF1ItyjKOkz4RPd7uTitdC93xRVMXxRaWVXPW1F/
 6+OynK/dadT9Zax5twqvJQGuHy6WfhiYET1qpIPZFHwkBaAoDRPWPyuwxgCU9C0yNGTC
 uX+wSWZHEuAIO5uT1RYqxdJaFnWbjJBYk7yJ5oH9WMnpW2vkBrXhZtk5RkS3N2FenERI
 +MrPTpfmORE3846hdHowtS/7RNHWsZWbod3Dd+60iCXf4XlW3FL5DRxnaFPanygmO0U/
 d97tE0NvDBnWT+ZGoDV4nd0Le9apc6wyAXt1WGWNJqHk00pHWioCOvfKnxxsax/EqhZ0
 eLOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=/FgK5IAnk6FTMgJ52e8i7lV+7gxkfwjZm7Vn+Nisr9w=;
 b=h0Sap+CE+dWBysG0oQ/lq+BV88e+S1QUqkMzMmCP5GA6ijVF/x5gYsHl2J6hJjKUoz
 8CisWG/xcS3SSLMJG2rkYAORZnYchQod7ULAOBOVWO6fvUmCGbF/YADuQjsGq7KoEobn
 A1OeYhmDM/sQhoplAjzFnq+5LtJARBL3QEXpJm6mDqrLFrbs0//9SSS4K9v0/EV8UAW/
 DdGKKXx/QS9F7I6iNsqHPmWOUosxvnbm7YFUv5QQGLlUxUv+w84mszTPIUULD2jlfzAG
 GBfZnYo8y72UIwpd0pG12ROzHCUKM1g34pKwUsvMF/zUkDg4sAZ6j/RrQkaK9k3LZV/Q
 gOwA==
X-Gm-Message-State: AOAM532oN0r5UUlY81CBhiGj6bXvY5yC1Oi2pTFS4sVvBvXek1m6x706
 2nQKQ36/DDFyDcaDtSD5VMw0Dg==
X-Google-Smtp-Source: ABdhPJzaDuTd4GVMQuDQLn3fOUD2ETpVmwUGMlFIET+66unTNa39QrLyGOYIClARpmqJlRGFyDu8zA==
X-Received: by 2002:a17:902:a70b:b0:149:75ae:4d63 with SMTP id
 w11-20020a170902a70b00b0014975ae4d63mr6305902plq.50.1641930178932; 
 Tue, 11 Jan 2022 11:42:58 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com.
 [35.185.214.157])
 by smtp.gmail.com with ESMTPSA id o11sm145586pgk.36.2022.01.11.11.42.58
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Tue, 11 Jan 2022 11:42:58 -0800 (PST)
Date: Tue, 11 Jan 2022 19:42:54 +0000
From: Sean Christopherson <seanjc@google.com>
To: Ricardo Koller <ricarkol@google.com>
Subject: Re: [kvm-unit-tests PATCH] arm64: debug: mark test_[bp, wp, ss] as
 noinline
Message-ID: <Yd3dvorNkP7eercw@google.com>
References: <20220111041103.2199594-1-ricarkol@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20220111041103.2199594-1-ricarkol@google.com>
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

On Mon, Jan 10, 2022, Ricardo Koller wrote:
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
> index 54f059d..6c5b683 100644
> --- a/arm/debug.c
> +++ b/arm/debug.c
> @@ -264,7 +264,7 @@ static void do_migrate(void)
>  	report_info("Migration complete");
>  }
>  
> -static void test_hw_bp(bool migrate)
> +static __attribute__((noinline)) void test_hw_bp(bool migrate)

Use "noinline", which was added by commit 16431a7 ("lib: define the "noinline" macro").
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
