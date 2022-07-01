Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 322B4C433EF
	for <kvmarm@archiver.kernel.org>; Fri,  1 Jul 2022 15:29:51 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8B9994B5F4;
	Fri,  1 Jul 2022 11:29:50 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id bcl7ZrJQvl+y; Fri,  1 Jul 2022 11:29:48 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 562334B5F5;
	Fri,  1 Jul 2022 11:29:48 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 675114B5F3
 for <kvmarm@lists.cs.columbia.edu>; Fri,  1 Jul 2022 11:29:47 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id vf7c3nMoJRh2 for <kvmarm@lists.cs.columbia.edu>;
 Fri,  1 Jul 2022 11:29:45 -0400 (EDT)
Received: from mail-wr1-f43.google.com (mail-wr1-f43.google.com
 [209.85.221.43])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 134CB4B5E1
 for <kvmarm@lists.cs.columbia.edu>; Fri,  1 Jul 2022 11:29:45 -0400 (EDT)
Received: by mail-wr1-f43.google.com with SMTP id o4so3745799wrh.3
 for <kvmarm@lists.cs.columbia.edu>; Fri, 01 Jul 2022 08:29:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=SQE/nevxcKA6J2DjkomhNRehwjJd8jzrATOHb/r4LVA=;
 b=JqPnynJnqBpqYAJ77jS6OgeELlFUlXIZzkvmDOmARSD0PYp/CAx6lOu3sEL9KY9aw/
 pckpJZmQ9VOvkJnei8UXTJgP2KouA9LdVtjUkFF7EvTzMdor9IYgDISQdmIohZnOkFlr
 CWtK6Oe0NynIynWxtWPKYdFoe1RWZFGOaNq3Yj5L4wQS2gVGXGKBcinioNlaP2/RI1ar
 /pXELCFMxsKWFi5/xELnAI1GCP5UH1wbzjDM7QLCtmV+efw86NGcPXffBvJxMDFZKvK6
 8OgoI91xxSHiBQkUfutwHVTtj0jn6Xhjo7kFrRgd8lFQl/CorjXP9OEFnhYl0GQy4lrF
 Uuig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=SQE/nevxcKA6J2DjkomhNRehwjJd8jzrATOHb/r4LVA=;
 b=3whM1G0OikKT1mNnfTe+/qOqI5SkCRhiGnL/Bf8zFDxxTBbcCr+OgHUp2A7duWPZNc
 GuqhujsrO2175LdNYDotZJ6WIzyF+cJGXK43Nokf0VDOPn49QUr3kmWc8TE8PQnQX4Nn
 x6dtlsTlIh5aAr6WBg16iEEFPjwxnP2ykUbleZnSNsSPTIWBQL2Wc+h1+kfh0HVxTj8N
 FwCHj6uKbsLZ13P5qOxrwdygMYhiUUZiSbylCM0eEHLZlyuZCbz5fctipKQQS3QM9P3y
 2OBUT22/7xdHwXxdRet3TJZwKm9FoXTNO4NUAkY97Ecs1SYKrfiPKf83qcw6rs1gqew3
 FFqQ==
X-Gm-Message-State: AJIora9LXGro8Q3ylKK80eW/uPWZs/czlUuF/UEwYuT1OmlWADQAgKqA
 N8kKJMxya7QvW21Ui52m2Bh85g==
X-Google-Smtp-Source: AGRyM1uYeem/gulVAxrbR7W86e7vWNrdVIdC3XYtaCRfHHMyY3xeBudzSKn3yofNH1u5ksyStsq29A==
X-Received: by 2002:a5d:614e:0:b0:21b:9736:736f with SMTP id
 y14-20020a5d614e000000b0021b9736736fmr13939214wrt.200.1656689383824; 
 Fri, 01 Jul 2022 08:29:43 -0700 (PDT)
Received: from google.com (44.232.78.34.bc.googleusercontent.com.
 [34.78.232.44]) by smtp.gmail.com with ESMTPSA id
 y15-20020a5d4acf000000b0021b9c520953sm22721777wrs.64.2022.07.01.08.29.42
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Fri, 01 Jul 2022 08:29:42 -0700 (PDT)
Date: Fri, 1 Jul 2022 15:29:40 +0000
From: Sebastian Ene <sebastianene@google.com>
To: Alexandru Elisei <alexandru.elisei@arm.com>
Subject: Re: [PATCH kvmtool] arm64: pvtime: Use correct region size
Message-ID: <Yr8S5E9Pdxr9QjRD@google.com>
References: <20220629103905.24480-1-alexandru.elisei@arm.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20220629103905.24480-1-alexandru.elisei@arm.com>
Cc: pierre.gondois@arm.com, maz@kernel.org, will@kernel.org,
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
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

On Wed, Jun 29, 2022 at 11:39:05AM +0100, Alexandru Elisei wrote:
> pvtime uses ARM_PVTIME_BASE instead of ARM_PVTIME_SIZE for the size of the
> memory region given to the guest, which causes to the following error when
> creating a flash device (via the -F/--flash command line argument):
> 
>   Error: RAM (read-only) region [2000000-27fffff] would overlap RAM region [1020000-203ffff]
> 
> The read-only region represents the guest memory where the flash image is
> copied by kvmtool. The region starting at 0x102_0000 (ARM_PVTIME_BASE) is
> the pvtime region, which should be 64K in size. kvmtool erroneously creates
> the region to be ARM_PVTIME_BASE in size instead, and the last address
> becomes:
> 
> ARM_PVTIME_BASE + ARM_PVTIME_BASE - 1 = 0x102_0000 + 0x102_0000 - 1 = 0x203_ffff
> 
> which corresponds to the end of the region from the error message.
> 
> Do the right thing and make the pvtime memory region ARM_PVTIME_SIZE = 64K
> bytes, as it was intended.
> 
> Fixes: 7d4671e5d372 ("aarch64: Add stolen time support")
> Reported-by: Pierre Gondois <pierre.gondois@arm.com>
> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
> ---
>  arm/aarch64/pvtime.c | 10 +++++-----
>  1 file changed, 5 insertions(+), 5 deletions(-)
> 

Hi,

Thanks for fixing this.
Reviewed-by: Sebastian Ene <sebastianene@google.com>

> diff --git a/arm/aarch64/pvtime.c b/arm/aarch64/pvtime.c
> index a49cf3ed5478..2933ac7ca959 100644
> --- a/arm/aarch64/pvtime.c
> +++ b/arm/aarch64/pvtime.c
> @@ -14,15 +14,15 @@ static int pvtime__alloc_region(struct kvm *kvm)
>  	char *mem;
>  	int ret = 0;
>  
> -	mem = mmap(NULL, ARM_PVTIME_BASE, PROT_RW,
> +	mem = mmap(NULL, ARM_PVTIME_SIZE, PROT_RW,
>  		   MAP_ANON_NORESERVE, -1, 0);
>  	if (mem == MAP_FAILED)
>  		return -errno;
>  
>  	ret = kvm__register_ram(kvm, ARM_PVTIME_BASE,
> -				ARM_PVTIME_BASE, mem);
> +				ARM_PVTIME_SIZE, mem);
>  	if (ret) {
> -		munmap(mem, ARM_PVTIME_BASE);
> +		munmap(mem, ARM_PVTIME_SIZE);
>  		return ret;
>  	}
>  
> @@ -36,8 +36,8 @@ static int pvtime__teardown_region(struct kvm *kvm)
>  		return 0;
>  
>  	kvm__destroy_mem(kvm, ARM_PVTIME_BASE,
> -			 ARM_PVTIME_BASE, usr_mem);
> -	munmap(usr_mem, ARM_PVTIME_BASE);
> +			 ARM_PVTIME_SIZE, usr_mem);
> +	munmap(usr_mem, ARM_PVTIME_SIZE);
>  	usr_mem = NULL;
>  	return 0;
>  }
> -- 
> 2.36.1
> 
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
