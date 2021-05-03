Return-Path: <SRS0=w4A1=J6=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A3D64C43461
	for <kvmarm@archiver.kernel.org>; Mon,  3 May 2021 11:31:39 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id E9B7861177
	for <kvmarm@archiver.kernel.org>; Mon,  3 May 2021 11:31:38 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E9B7861177
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 688714B431;
	Mon,  3 May 2021 07:31:38 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 4dc6VhcpDcmT; Mon,  3 May 2021 07:31:37 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 64E7E4B454;
	Mon,  3 May 2021 07:31:37 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 17A9D4B431
 for <kvmarm@lists.cs.columbia.edu>; Mon,  3 May 2021 07:31:36 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id HDGUvnSJYuwi for <kvmarm@lists.cs.columbia.edu>;
 Mon,  3 May 2021 07:31:35 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 084364B3BB
 for <kvmarm@lists.cs.columbia.edu>; Mon,  3 May 2021 07:31:35 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1620041494;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=L/bcf0nuZPJ9+05d3REB9K2mhzG8oDqknK3QX5CLyLU=;
 b=Y5Jfvk20EpHZOoWdJHnHpeY8XODJ0bEMgHQu1miYm20MNXRb7GlupmNQ35BEz942oFphPb
 tKpdsvfPVVSSGEdshe6mFAWZLjUb8TJaEwiwoYmqJTW3oT6lrIuUhuxG25JazYro9+TECg
 Eqv0sKZdHRgbHcrc5/ohKrxa8a8I/Bs=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-508-ovurxrvENyyuZj3cvkPOHQ-1; Mon, 03 May 2021 07:31:33 -0400
X-MC-Unique: ovurxrvENyyuZj3cvkPOHQ-1
Received: by mail-wm1-f72.google.com with SMTP id
 j128-20020a1c55860000b02901384b712094so2371998wmb.2
 for <kvmarm@lists.cs.columbia.edu>; Mon, 03 May 2021 04:31:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=L/bcf0nuZPJ9+05d3REB9K2mhzG8oDqknK3QX5CLyLU=;
 b=JFP1tN6FXhfoQYIVt4vl0MnAi4Zeu/JbNOd/CSf3pm/FJDGHXPpyrFSdCFgPgatAjm
 +sICHKMkOb+BhlcEAtzBKnur0c7yyGZzMO9SgtQAdBkpgxuPvAjaxs9BToKY21e2bQTF
 EIJqTI59WM6Gd30BO3tslu5jvyhOH7lBMxCbvA1lvpAsB887LO0LUXB/8bEh8KBeyYas
 NXLZ3pIeCRNjsVNlq/WHDzBit954T67X/t+N8C7KF7+F24+5WrYNMRsm3E+xzfYrlXQg
 Gx2m9alHrcF0vJA2Fm9eMUTO8T5T2xbb4EvCUE/z77iABu2PcstYCYhZebj3WwHS09xw
 JI9Q==
X-Gm-Message-State: AOAM531jsZ/evlMAK7oqM+niqAtHxyCI6Lemn29q9ZzXT92lwBbQTtdM
 mMBRqzL9dUTi2xtrUg/4dnZKrHZXjPzfnpb7rDdSwagjg2AvKuxYhDl+O7YbYjyxVeYqTP3tLfZ
 8xoyZFj+5zDj0bPEEgoOYgHSb
X-Received: by 2002:a05:600c:218d:: with SMTP id
 e13mr26761510wme.151.1620041492292; 
 Mon, 03 May 2021 04:31:32 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJy7aCxatzlutQaKTphpsuYgj38aq/ELD4z7gf0Zn/7jxG8jPXaE2yqDpFGW0ExSwWKOEqP1Ng==
X-Received: by 2002:a05:600c:218d:: with SMTP id
 e13mr26761491wme.151.1620041492085; 
 Mon, 03 May 2021 04:31:32 -0700 (PDT)
Received: from gator.home (cst2-174-132.cust.vodafone.cz. [31.30.174.132])
 by smtp.gmail.com with ESMTPSA id v20sm11411827wmj.15.2021.05.03.04.31.31
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Mon, 03 May 2021 04:31:31 -0700 (PDT)
Date: Mon, 3 May 2021 13:31:29 +0200
From: Andrew Jones <drjones@redhat.com>
To: Ricardo Koller <ricarkol@google.com>
Subject: Re: [PATCH v2 3/5] KVM: selftests: Move GUEST_ASSERT_EQ to utils
 header
Message-ID: <20210503113129.hoqjuklct3yoooii@gator.home>
References: <20210430232408.2707420-1-ricarkol@google.com>
 <20210430232408.2707420-4-ricarkol@google.com>
MIME-Version: 1.0
In-Reply-To: <20210430232408.2707420-4-ricarkol@google.com>
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=drjones@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Cc: kvm@vger.kernel.org, maz@kernel.org, pbonzini@redhat.com,
 kvmarm@lists.cs.columbia.edu
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

On Fri, Apr 30, 2021 at 04:24:05PM -0700, Ricardo Koller wrote:
> Move GUEST_ASSERT_EQ to a common header, kvm_util.h, for other
> architectures and tests to use.
> 
> Signed-off-by: Ricardo Koller <ricarkol@google.com>
> ---
>  tools/testing/selftests/kvm/include/kvm_util.h     | 9 +++++++++
>  tools/testing/selftests/kvm/x86_64/tsc_msrs_test.c | 9 ---------
>  2 files changed, 9 insertions(+), 9 deletions(-)
> 
> diff --git a/tools/testing/selftests/kvm/include/kvm_util.h b/tools/testing/selftests/kvm/include/kvm_util.h
> index 7880929ea548..bd26dd93ab56 100644
> --- a/tools/testing/selftests/kvm/include/kvm_util.h
> +++ b/tools/testing/selftests/kvm/include/kvm_util.h
> @@ -388,4 +388,13 @@ uint64_t get_ucall(struct kvm_vm *vm, uint32_t vcpu_id, struct ucall *uc);
>  #define GUEST_ASSERT_4(_condition, arg1, arg2, arg3, arg4) \
>  	__GUEST_ASSERT((_condition), 4, (arg1), (arg2), (arg3), (arg4))
>  
> +#define GUEST_ASSERT_EQ(a, b) do {				\
> +	__typeof(a) _a = (a);					\
> +	__typeof(b) _b = (b);					\
> +	if (_a != _b)						\
> +		ucall(UCALL_ABORT, 4,				\
> +			"Failed guest assert: "			\
> +			#a " == " #b, __LINE__, _a, _b);	\
> +} while(0)
> +
>  #endif /* SELFTEST_KVM_UTIL_H */
> diff --git a/tools/testing/selftests/kvm/x86_64/tsc_msrs_test.c b/tools/testing/selftests/kvm/x86_64/tsc_msrs_test.c
> index e357d8e222d4..5a6a662f2e59 100644
> --- a/tools/testing/selftests/kvm/x86_64/tsc_msrs_test.c
> +++ b/tools/testing/selftests/kvm/x86_64/tsc_msrs_test.c
> @@ -18,15 +18,6 @@
>  #define rounded_rdmsr(x)       ROUND(rdmsr(x))
>  #define rounded_host_rdmsr(x)  ROUND(vcpu_get_msr(vm, 0, x))
>  
> -#define GUEST_ASSERT_EQ(a, b) do {				\
> -	__typeof(a) _a = (a);					\
> -	__typeof(b) _b = (b);					\
> -	if (_a != _b)						\
> -                ucall(UCALL_ABORT, 4,				\
> -                        "Failed guest assert: "			\
> -                        #a " == " #b, __LINE__, _a, _b);	\
> -  } while(0)
> -
>  static void guest_code(void)
>  {
>  	u64 val = 0;
> -- 
> 2.31.1.527.g47e6f16901-goog
>

How about modify __GUEST_ASSERT so we can reuse it instead, like below?
(I also took the opportunity to remove the unnecessary () within the comma
separated statements.)

Thanks,
drew


-#define __GUEST_ASSERT(_condition, _nargs, _args...) do {      \
-       if (!(_condition))                                      \
-               ucall(UCALL_ABORT, 2 + _nargs,                  \
-                       "Failed guest assert: "                 \
-                       #_condition, __LINE__, _args);          \
+#define __GUEST_ASSERT(_condition, _condstr, _nargs, _args...) do {    \
+       if (!(_condition))                                              \
+               ucall(UCALL_ABORT, 2 + _nargs,                          \
+                       "Failed guest assert: "                         \
+                       _condstr, __LINE__, _args);                     \
 } while (0)
 
 #define GUEST_ASSERT(_condition) \
-       __GUEST_ASSERT((_condition), 0, 0)
+       __GUEST_ASSERT(_condition, #_condition, 0, 0)
 
 #define GUEST_ASSERT_1(_condition, arg1) \
-       __GUEST_ASSERT((_condition), 1, (arg1))
+       __GUEST_ASSERT(_condition, #_condition, 1, arg1)
 
 #define GUEST_ASSERT_2(_condition, arg1, arg2) \
-       __GUEST_ASSERT((_condition), 2, (arg1), (arg2))
+       __GUEST_ASSERT(_condition, #_condition, 2, arg1, arg2)
 
 #define GUEST_ASSERT_3(_condition, arg1, arg2, arg3) \
-       __GUEST_ASSERT((_condition), 3, (arg1), (arg2), (arg3))
+       __GUEST_ASSERT(_condition, #_condition, 3, arg1, arg2, arg3)
 
 #define GUEST_ASSERT_4(_condition, arg1, arg2, arg3, arg4) \
-       __GUEST_ASSERT((_condition), 4, (arg1), (arg2), (arg3), (arg4))
-
-#define GUEST_ASSERT_EQ(a, b) do {                             \
-       __typeof(a) _a = (a);                                   \
-       __typeof(b) _b = (b);                                   \
-       if (_a != _b)                                           \
-               ucall(UCALL_ABORT, 4,                           \
-                       "Failed guest assert: "                 \
-                       #a " == " #b, __LINE__, _a, _b);        \
-} while(0)
+       __GUEST_ASSERT(_condition, #_condition, 4, arg1, arg2, arg3, arg4)
+
+#define GUEST_ASSERT_EQ(a, b) __GUEST_ASSERT((a) == (b), #a " == " #b, 2, a, b)

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
