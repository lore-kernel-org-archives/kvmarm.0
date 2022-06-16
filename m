Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E8325C433EF
	for <kvmarm@archiver.kernel.org>; Thu, 16 Jun 2022 12:46:17 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 75D9949EB4;
	Thu, 16 Jun 2022 08:46:17 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id zonCUuvFoDrP; Thu, 16 Jun 2022 08:46:16 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5940549EE3;
	Thu, 16 Jun 2022 08:46:16 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6D9E749EB4
 for <kvmarm@lists.cs.columbia.edu>; Thu, 16 Jun 2022 08:46:15 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id AMMyM11NxYwP for <kvmarm@lists.cs.columbia.edu>;
 Thu, 16 Jun 2022 08:46:14 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.129.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5CA6140719
 for <kvmarm@lists.cs.columbia.edu>; Thu, 16 Jun 2022 08:46:14 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1655383574;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=gLgx7hmsWQsQo30sh+kzZRE6xJ8y056KBCH3mRvUzv8=;
 b=EtQX6ObX9ufAqtmDpEd3Nf8rv1s6v5xiyjsq89lGUAzzg1TaQhUlYVobgiVA2blH7Kkbrm
 aabPxSY+ciQxv/ijsA1YH1YFEVmCMwnI2m3pzGzWFsOg0JVa6gCFFI5SzOuf8UMDPHQkS8
 sB3RtTyqbbBW19k+/mei59mo1ugNakw=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-427-9fuEYuRnObmFaQz25fF0Mw-1; Thu, 16 Jun 2022 08:46:12 -0400
X-MC-Unique: 9fuEYuRnObmFaQz25fF0Mw-1
Received: by mail-ed1-f72.google.com with SMTP id
 w22-20020a05640234d600b0043559f4c95aso85413edc.18
 for <kvmarm@lists.cs.columbia.edu>; Thu, 16 Jun 2022 05:46:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=gLgx7hmsWQsQo30sh+kzZRE6xJ8y056KBCH3mRvUzv8=;
 b=MFDKPrcTTgH/qr5TzJ8BWoUN0EaZIkhXq9F6LWZH464LbHJJjxZ0woYPy+tB1iMAN2
 J4dN33Bx2V1s4mPFWX6+ZQkmt0muj5/cSDj9Wv3/q4gIpAAYpWvipF0iLH5KPfEAYiJg
 12bhDwxkPgv4AMHX0iwFDFCnMKQ9fH2tC73aTnn7mVMOqU0ofauP+N8uX8fAnVnKaaf5
 fOMOMytUUrwse3TdCYDbh9zOdRMDdrh7TKLZpEN3mg7/F24uV1OWkNStnObPvRz9mfuA
 e0zQhzaV31VVS3SZnnvTnnh+z/tQqU+/ojVlJ6aPmwhjRpK8gapNAIMaUKcb8G6fIh6T
 aaxg==
X-Gm-Message-State: AJIora/17RJeLapaByMGShBnbJJXXg2CahlHemyBni6dQoj3tY0qe07s
 yh7mgqpJJA+lZkeMWV+Ge7b5Vi5jZRTPW3wW46gVMdhu+YMHpwrogDAWmAecrSVy2H6hiL0zikQ
 5BRxvtpNqL8yUIlipQ05LkQnT
X-Received: by 2002:a05:6402:3807:b0:435:20fb:318d with SMTP id
 es7-20020a056402380700b0043520fb318dmr6324738edb.272.1655383571818; 
 Thu, 16 Jun 2022 05:46:11 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1v3lxgSx+whO8T5GvlDJx/RuoG4NSeOFL5I9qG6AmpHIWH5MdvIkc6+sxrw5L52/Yz1p/cM8A==
X-Received: by 2002:a05:6402:3807:b0:435:20fb:318d with SMTP id
 es7-20020a056402380700b0043520fb318dmr6324718edb.272.1655383571670; 
 Thu, 16 Jun 2022 05:46:11 -0700 (PDT)
Received: from gator (cst2-173-67.cust.vodafone.cz. [31.30.173.67])
 by smtp.gmail.com with ESMTPSA id
 d13-20020a170906304d00b00704757b1debsm754009ejd.9.2022.06.16.05.46.10
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Thu, 16 Jun 2022 05:46:11 -0700 (PDT)
Date: Thu, 16 Jun 2022 14:46:09 +0200
From: Andrew Jones <drjones@redhat.com>
To: Colton Lewis <coltonlewis@google.com>
Subject: Re: [PATCH 3/4] KVM: selftests: Write REPORT_GUEST_ASSERT macros to
 pair with GUEST_ASSERT
Message-ID: <20220616124609.fforgaccsp3rwbxi@gator>
References: <20220615193116.806312-1-coltonlewis@google.com>
 <20220615193116.806312-4-coltonlewis@google.com>
MIME-Version: 1.0
In-Reply-To: <20220615193116.806312-4-coltonlewis@google.com>
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=drjones@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Cc: thuth@redhat.com, kvm@vger.kernel.org, maz@kernel.org, pbonzini@redhat.com,
 vkuznets@redhat.com, kvmarm@lists.cs.columbia.edu
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

On Wed, Jun 15, 2022 at 07:31:15PM +0000, Colton Lewis wrote:
> Write REPORT_GUEST_ASSERT macros to pair with GUEST_ASSERT to abstract
> and make consistent all guest assertion reporting. Every report
> includes an explanatory string, a filename, and a line number.
> 
> Signed-off-by: Colton Lewis <coltonlewis@google.com>
> ---
>  .../selftests/kvm/include/ucall_common.h      | 42 +++++++++++++++++++
>  1 file changed, 42 insertions(+)
> 
> diff --git a/tools/testing/selftests/kvm/include/ucall_common.h b/tools/testing/selftests/kvm/include/ucall_common.h
> index 568c562f14cd..e8af3b4fef6d 100644
> --- a/tools/testing/selftests/kvm/include/ucall_common.h
> +++ b/tools/testing/selftests/kvm/include/ucall_common.h
> @@ -6,6 +6,7 @@
>   */
>  #ifndef SELFTEST_KVM_UCALL_COMMON_H
>  #define SELFTEST_KVM_UCALL_COMMON_H
> +#include "test_util.h"
>  
>  /* Common ucalls */
>  enum {
> @@ -64,4 +65,45 @@ enum guest_assert_builtin_args {
>  
>  #define GUEST_ASSERT_EQ(a, b) __GUEST_ASSERT((a) == (b), #a " == " #b, 2, a, b)
>  
> +#define __REPORT_GUEST_ASSERT(_ucall, fmt, _args...)			\
> +	TEST_FAIL("%s at %s:%ld\n" fmt,					\
> +		  (const char *)(_ucall).args[GUEST_ERROR_STRING],	\
> +		  (const char *)(_ucall).args[GUEST_FILE],		\
> +		  (_ucall).args[GUEST_LINE],				\
> +		  ##_args)
> +
> +#define GUEST_ASSERT_ARG(ucall, i) ((ucall).args[GUEST_ASSERT_BUILTIN_NARGS + i])
> +
> +#define REPORT_GUEST_ASSERT(ucall)		\
> +	__REPORT_GUEST_ASSERT((ucall), "")
> +
> +#define REPORT_GUEST_ASSERT_1(ucall, fmt)			\
> +	__REPORT_GUEST_ASSERT((ucall),				\
> +			      fmt,				\
> +			      GUEST_ASSERT_ARG((ucall), 0))
> +
> +#define REPORT_GUEST_ASSERT_2(ucall, fmt)			\
> +	__REPORT_GUEST_ASSERT((ucall),				\
> +			      fmt,				\
> +			      GUEST_ASSERT_ARG((ucall), 0),	\
> +			      GUEST_ASSERT_ARG((ucall), 1))
> +
> +#define REPORT_GUEST_ASSERT_3(ucall, fmt)			\
> +	__REPORT_GUEST_ASSERT((ucall),				\
> +			      fmt,				\
> +			      GUEST_ASSERT_ARG((ucall), 0),	\
> +			      GUEST_ASSERT_ARG((ucall), 1),	\
> +			      GUEST_ASSERT_ARG((ucall), 2))
> +
> +#define REPORT_GUEST_ASSERT_4(ucall, fmt)			\
> +	__REPORT_GUEST_ASSERT((ucall),				\
> +			      fmt,				\
> +			      GUEST_ASSERT_ARG((ucall), 0),	\
> +			      GUEST_ASSERT_ARG((ucall), 1),	\
> +			      GUEST_ASSERT_ARG((ucall), 2),	\
> +			      GUEST_ASSERT_ARG((ucall), 3))
> +
> +#define REPORT_GUEST_ASSERT_N(ucall, fmt, args...)	\
> +	__REPORT_GUEST_ASSERT((ucall), fmt, ##args)
> +
>  #endif /* SELFTEST_KVM_UCALL_COMMON_H */
> -- 
> 2.36.1.476.g0c4daa206d-goog
>

nit: All the ()'s around ucall when it's between ( and , are unnecessary.

Otherwise,

Reviewed-by: Andrew Jones <drjones@redhat.com>

Thanks,
drew

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
