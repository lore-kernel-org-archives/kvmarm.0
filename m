Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9EC91C433FE
	for <kvmarm@archiver.kernel.org>; Thu, 19 May 2022 04:25:09 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1FE45400D1;
	Thu, 19 May 2022 00:25:09 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 4AtOdgBMMd4H; Thu, 19 May 2022 00:25:07 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E24C64B344;
	Thu, 19 May 2022 00:25:07 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4630D4B340
 for <kvmarm@lists.cs.columbia.edu>; Thu, 19 May 2022 00:25:06 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Xg+5LllQ-y8n for <kvmarm@lists.cs.columbia.edu>;
 Thu, 19 May 2022 00:25:05 -0400 (EDT)
Received: from mail-il1-f170.google.com (mail-il1-f170.google.com
 [209.85.166.170])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 647DF4B2AC
 for <kvmarm@lists.cs.columbia.edu>; Thu, 19 May 2022 00:25:05 -0400 (EDT)
Received: by mail-il1-f170.google.com with SMTP id o16so2895439ilq.8
 for <kvmarm@lists.cs.columbia.edu>; Wed, 18 May 2022 21:25:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=YTrr1nUWysdYXc7WuM/wpP2cN90f/4jJY4FwZqSrNtA=;
 b=nu/Y8LdWfMl684PpqUBrKSgVOfArcxWKcEuRonl078IfuXQlcUUKHm43egxlBfQSFI
 TWfMwZw3hYahKUD2FcoCGqDTuOkwZxGVxYQzWbwz1kCIX/aHTw4A2H33rT5lss6fw7wU
 mDiDKUC5qlp+o98w6LMUcBqkwI8YUH4KdytF6hy/SYMoSPSz7zSOGgyP3t6Bj71TV52p
 gJi1bcJjkjTbpqw3WdGuZ+OGWgbmKHWFpV75D4xjz2OSIz3Vo8Q+i1+fmoPjvqBNg9Nh
 KyEjMtDB1Foo3B6tC1yuM6ZPT+z2DpVjkt1ba0HOhV/PMk7ZmFZZQ+Jg4NTOElp4an7F
 Oqpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=YTrr1nUWysdYXc7WuM/wpP2cN90f/4jJY4FwZqSrNtA=;
 b=Jgpaip4bQWTNwCOJ2V0com2GDtqrOkORsiFEq4CCIslES7aC77Ia+d5VYTT17w7rrg
 q/iSvzAxgVgv8QLVi465nRXCj1XCSUgQlZzBlr9csKpPp1rJ22mHIvL03w/6XeKJPj5L
 YIN49/UJU3QJUYUxURN38fVl+ZlZfIzUsmL92hy/Ch0sGr0wfVpUvzBpJwS9c/TpFS39
 f4QPRCJJiLr4Vv4MbBFpBQxzSHwVvGSX4aG6OORk80StVv2zihWmsYNCzGDuLQc1U9PZ
 SXPxMH1Ml0n9HHTRSzuMcUPK9Fh+dB99o+HHm8jX3ppfLuap4vujqQHb0DglzCl39xfG
 VIqw==
X-Gm-Message-State: AOAM531INLosB6rZpULoicB8GuGyZ8JXVbTNSGnfwQCBTaDcUsVF2Twf
 6WhHiSc5JUvcDQ2q4RUC0Su60w==
X-Google-Smtp-Source: ABdhPJz+VoJsRmPaKm0zNc9Js7DTy0qnRh4V0wyLMDcv+EscqirsHBjIR/337qjsTduEohB1A15/4A==
X-Received: by 2002:a92:602:0:b0:2d1:1497:7235 with SMTP id
 x2-20020a920602000000b002d114977235mr1621476ilg.242.1652934304470; 
 Wed, 18 May 2022 21:25:04 -0700 (PDT)
Received: from google.com (194.225.68.34.bc.googleusercontent.com.
 [34.68.225.194]) by smtp.gmail.com with ESMTPSA id
 y13-20020a6bd80d000000b00657b1ff6556sm455210iob.2.2022.05.18.21.25.03
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Wed, 18 May 2022 21:25:03 -0700 (PDT)
Date: Thu, 19 May 2022 04:25:00 +0000
From: Oliver Upton <oupton@google.com>
To: Ricardo Koller <ricarkol@google.com>
Subject: Re: [PATCH v3 08/13] tools: Copy bitfield.h from the kernel sources
Message-ID: <YoXGnBi3+2OS3j/u@google.com>
References: <20220408004120.1969099-1-ricarkol@google.com>
 <20220408004120.1969099-9-ricarkol@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20220408004120.1969099-9-ricarkol@google.com>
Cc: kvm@vger.kernel.org, maz@kernel.org, bgardon@google.com,
 Arnaldo Carvalho de Melo <acme@redhat.com>, Jakub Kicinski <kuba@kernel.org>,
 pbonzini@redhat.com, axelrasmussen@google.com, kvmarm@lists.cs.columbia.edu
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

On Thu, Apr 07, 2022 at 05:41:15PM -0700, Ricardo Koller wrote:
> Copy bitfield.h from include/linux/bitfield.h. It defines some
> FIELD_{GET,PREP} macros that will be needed in the next patch in the
> series. The header was copied as-is, no changes needed.

nit: this commit could be the parent of several other descendants.
Perhaps ambigiously state "A subsequent change will make use ..."

Reviewed-by: Oliver Upton <oupton@google.com>
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
