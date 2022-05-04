Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5E34BC433F5
	for <kvmarm@archiver.kernel.org>; Wed,  4 May 2022 19:58:51 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 99B9C49EDE;
	Wed,  4 May 2022 15:58:50 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 1q7P+4XL4ynB; Wed,  4 May 2022 15:58:49 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9605A4B11C;
	Wed,  4 May 2022 15:58:49 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E96684B091
 for <kvmarm@lists.cs.columbia.edu>; Wed,  4 May 2022 15:58:48 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 5lKpYHVLVfhQ for <kvmarm@lists.cs.columbia.edu>;
 Wed,  4 May 2022 15:58:48 -0400 (EDT)
Received: from mail-il1-f170.google.com (mail-il1-f170.google.com
 [209.85.166.170])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id F3B9E4B08A
 for <kvmarm@lists.cs.columbia.edu>; Wed,  4 May 2022 15:58:47 -0400 (EDT)
Received: by mail-il1-f170.google.com with SMTP id z12so1552141ilp.8
 for <kvmarm@lists.cs.columbia.edu>; Wed, 04 May 2022 12:58:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=GsfXoNKONKDKWhJHjg7OT8XgANJP2e9G7Mc1nVY0AYE=;
 b=Aq1U8sdb7NiZVJWC4vUlChWXOfRbCGaFNjbSpc0WleExMf0SKkQUNrsAlYXljTlC8V
 kIwakMFlClmc4+G6Yl7CQ/45/9xgObIBveZ7BjUWWP3+FAaW4C1aJyJALPCVD9lXJc+x
 YJ++0U3IX23F9PeoHw9+6HPC3HlHHljxhgJrbOn5aAgZau7Q6TShdWIkw27qEr4r1db0
 ySclaROjZ8pxDb8YfChQRlCjxbFar+IhUVYKk3BD08+hVk5gdraFe163Ypca8nO0QyxZ
 DsoFqtJh0sAijvTR6s7QSXKCKou0s4gdKPXNW/z/rGUII4CS32K7EojcLfa8YVJI1oAs
 x6EQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=GsfXoNKONKDKWhJHjg7OT8XgANJP2e9G7Mc1nVY0AYE=;
 b=KOFXLxtdmIh80knXwah4DuPx2w8Hi9f2M3YIbOJD/GYVjB/ICTDhjqDTR/OG82U6g8
 nZJH4BYRIWiOeITP9DgorZtJ/3J2zxgVRxNXLfWLTGRe/TMB89ojpzasEI3+xdn8q3hr
 CaBrHFVTOMqelEMmyjuB88B5KN2SFmgjZy1FC2BShrq4VXJ5MMRLmNwnVjVdkHHXZesI
 RkI6TCgwqonvdugjXJEgK/nvECT9iEWXFuQg6rNjHapQevHKCTSjQxq/FAVtHRgOG26l
 ZQAxAghCjnMgF2utubpXdHsEnBckJvDQepFsNpMhMHxLQit9z3CbzDbOn+2wmU/58CwH
 iR1Q==
X-Gm-Message-State: AOAM532e1/56o/264VmBRN32VKxIOTfWqCYcjdJ656ZwOekaCYHEkYLu
 tgENA+ooS7Aw6VXGJracrsK4YQ==
X-Google-Smtp-Source: ABdhPJy5Bzj+uvdC2D+9IucvrmZ0XZi+3AvPJbXcQc72eVCSrPti9fdcCscTtD01OvFKOzl/PHzgiQ==
X-Received: by 2002:a05:6e02:164f:b0:2cf:3244:665d with SMTP id
 v15-20020a056e02164f00b002cf3244665dmr4183126ilu.170.1651694326903; 
 Wed, 04 May 2022 12:58:46 -0700 (PDT)
Received: from google.com (194.225.68.34.bc.googleusercontent.com.
 [34.68.225.194]) by smtp.gmail.com with ESMTPSA id
 t13-20020a02ccad000000b0032b3a7817afsm4928792jap.115.2022.05.04.12.58.46
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Wed, 04 May 2022 12:58:46 -0700 (PDT)
Date: Wed, 4 May 2022 19:58:42 +0000
From: Oliver Upton <oupton@google.com>
To: Raghavendra Rao Ananta <rananta@google.com>
Subject: Re: [PATCH] selftests: KVM: aarch64: Let hypercalls use UAPI
 *_BIT_COUNT
Message-ID: <YnLa8uH55/epyjlS@google.com>
References: <20220504184415.1905224-1-rananta@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20220504184415.1905224-1-rananta@google.com>
Cc: kvm@vger.kernel.org, Will Deacon <will@kernel.org>,
 Marc Zyngier <maz@kernel.org>, Peter Shier <pshier@google.com>,
 linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
 Catalin Marinas <catalin.marinas@arm.com>, Paolo Bonzini <pbonzini@redhat.com>,
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

Hi Raghavendra,

On Wed, May 04, 2022 at 06:44:15PM +0000, Raghavendra Rao Ananta wrote:
> The hypercalls test currently defines its own *_BMAP_BIT_MAX macros to
> define the last valid feature bit for each bitmap firmware register.
> However, since these definitions are already present in the uapi header,
> kvm.h, as *_BMAP_BIT_COUNT, and would help to keep the test updated as
> features grow, use these instead.

LOL, looks like I lost that one in the end! Still, the fact that you're
patching the selftest highlights the fact that there is a nonzero chance
of userspace using this value incorrectly expecting it to hold true
across all kernels.

Since this is the route going forward can we please consider documenting
the fact that _BIT_COUNT *will* change and is not stable between kernel
versions. Bad UAPI expectations could throw a wrench into this entire
plan we've hatched for preserving hypercall ABI.

Just a warning at the end of the register documentation would suffice.

> No functional change intended.
> 
> Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>

Besides considering the above hazard:

Reviewed-by: Oliver Upton <oupton@google.com>
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
