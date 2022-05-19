Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 39592C433F5
	for <kvmarm@archiver.kernel.org>; Thu, 19 May 2022 04:17:13 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B11CF4B2F5;
	Thu, 19 May 2022 00:17:12 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id CFo2sNI+kQTj; Thu, 19 May 2022 00:17:11 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 982784B344;
	Thu, 19 May 2022 00:17:11 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A65A94B308
 for <kvmarm@lists.cs.columbia.edu>; Thu, 19 May 2022 00:17:10 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id B3ure3LrQ60q for <kvmarm@lists.cs.columbia.edu>;
 Thu, 19 May 2022 00:17:09 -0400 (EDT)
Received: from mail-il1-f173.google.com (mail-il1-f173.google.com
 [209.85.166.173])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 8D0294B2F5
 for <kvmarm@lists.cs.columbia.edu>; Thu, 19 May 2022 00:17:09 -0400 (EDT)
Received: by mail-il1-f173.google.com with SMTP id s14so2878134ild.6
 for <kvmarm@lists.cs.columbia.edu>; Wed, 18 May 2022 21:17:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=wBpJN+B+mpCMjOyZZ37J/WxRsnBKWwY1W4P9ThvtpoI=;
 b=JGQleZJIQQ604gbY4RMXs6h6h1Tqp2YqmlqQqyuFwLEcPzlP+Ur3g4bL7mZJ+8yEBL
 kZtI4hOR95oDYmzJ9vLR5oEFT7/Xgm37DNafbIAgLlpPEySpjRfWScQqEVEK6dIwzyQ0
 ZQxnrmght+XEP8UgR9lT6NLnXPkfoWpYnysH581FOiOaevYcnTZ1lRLHgCHoe4ml+EsN
 E3Q6S26a37/3V63mTmuD/feVvqKQ3PJTP3QCQLnEkRgDDiNcPjaGBdvUBoqAauyoFz3I
 B79YeCLu7jqemdx6+sv5tlnTBZbZyQtY6s1yixQtYykgpMQOoL/Dkk50d4Z8nZFAPbeB
 rW/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=wBpJN+B+mpCMjOyZZ37J/WxRsnBKWwY1W4P9ThvtpoI=;
 b=L5YdSnIwVor9MiXTP9TIcW78EQpcIydf9jFGI7p1sZ2I6pklLLRm+aYvu5IQWKZd+H
 EqjnhHkfYwYKCZvVknvT+jqSn3h7ryREpvWRhTw7NI2WtoCd9S/pYXMPP7R9R6ZJy4wP
 FeKfovYFIEwSTu3N4ZlN+EFVRVPqmFHxW4hoiOW22hGz6ibJUO5yMWTgA0L6iR+sUk8Y
 rf0N4pNrpFMhtJbz3NQS+dREt9BhBDAdcr4QuF003KOTb6rktElucIVl5sxjwBLVuzRA
 xVOtXWbC4gbVlN7OtFTkX/niKzzPhgWDUQ+yyDT6s/ogdPoJ1xUz/6hKbCfRmd2E1DM5
 y7Mw==
X-Gm-Message-State: AOAM533B4uVUWowcrrBg1L5QhjY/mr1Egv1Z1CWtk5R8MrTTEUing7b6
 C1TFEYF73RQOVmQXulgM0/QXBQ==
X-Google-Smtp-Source: ABdhPJwVTPKAjZ6b9y2ovYPQL5OOgnFicWexrxmFnJiV64RB2zPOUbGZ/KIcwBuVx+Z5hyHliZ6g/g==
X-Received: by 2002:a92:d805:0:b0:2d0:ea4f:5dcb with SMTP id
 y5-20020a92d805000000b002d0ea4f5dcbmr1648257ilm.78.1652933828733; 
 Wed, 18 May 2022 21:17:08 -0700 (PDT)
Received: from google.com (194.225.68.34.bc.googleusercontent.com.
 [34.68.225.194]) by smtp.gmail.com with ESMTPSA id
 f23-20020a02b797000000b0032b3a7817afsm372599jam.115.2022.05.18.21.17.07
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Wed, 18 May 2022 21:17:07 -0700 (PDT)
Date: Thu, 19 May 2022 04:17:04 +0000
From: Oliver Upton <oupton@google.com>
To: Ricardo Koller <ricarkol@google.com>
Subject: Re: [PATCH v3 07/13] KVM: selftests: aarch64: Construct
 DEFAULT_MAIR_EL1 using sysreg.h macros
Message-ID: <YoXEwEaxVat7XTl1@google.com>
References: <20220408004120.1969099-1-ricarkol@google.com>
 <20220408004120.1969099-8-ricarkol@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20220408004120.1969099-8-ricarkol@google.com>
Cc: kvm@vger.kernel.org, maz@kernel.org, bgardon@google.com,
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

On Thu, Apr 07, 2022 at 05:41:14PM -0700, Ricardo Koller wrote:
> Define macros for memory type indexes and construct DEFAULT_MAIR_EL1
> with macros from asm/sysreg.h.  The index macros can then be used when
> constructing PTEs (instead of using raw numbers).
> 
> Signed-off-by: Ricardo Koller <ricarkol@google.com>
> ---
>  .../selftests/kvm/include/aarch64/processor.h | 24 ++++++++++++++-----
>  .../selftests/kvm/lib/aarch64/processor.c     |  2 +-
>  2 files changed, 19 insertions(+), 7 deletions(-)
> 
> diff --git a/tools/testing/selftests/kvm/include/aarch64/processor.h b/tools/testing/selftests/kvm/include/aarch64/processor.h
> index 3965a5ac778e..16753a1f28e3 100644
> --- a/tools/testing/selftests/kvm/include/aarch64/processor.h
> +++ b/tools/testing/selftests/kvm/include/aarch64/processor.h
> @@ -38,12 +38,24 @@
>   * NORMAL             4     1111:1111
>   * NORMAL_WT          5     1011:1011
>   */
> -#define DEFAULT_MAIR_EL1 ((0x00ul << (0 * 8)) | \
> -			  (0x04ul << (1 * 8)) | \
> -			  (0x0cul << (2 * 8)) | \
> -			  (0x44ul << (3 * 8)) | \
> -			  (0xfful << (4 * 8)) | \
> -			  (0xbbul << (5 * 8)))
> +
> +/* Linux doesn't use these memory types, so let's define them. */
> +#define MAIR_ATTR_DEVICE_GRE	UL(0x0c)
> +#define MAIR_NORMAL_WT		UL(0xbb)

nit: MAIR_ATTR_NORMAL_WT

Might be annoying if these are actually defined at a later date and
someone tries to refresh the tools/ header copy. A bit more work, but
how about adding these to the real asm/sysreg.h then catching tools/ up
in a subsequent commit?

Modulo the nit, fine with this as is:

Reviewed-by: Oliver Upton <oupton@google.com>
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
