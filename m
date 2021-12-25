Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 97745C4332F
	for <kvmarm@archiver.kernel.org>; Sat, 25 Dec 2021 09:11:53 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E96C441021;
	Sat, 25 Dec 2021 04:11:52 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id GOAZfp8s8QtL; Sat, 25 Dec 2021 04:11:51 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6C80240E3D;
	Sat, 25 Dec 2021 04:11:51 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D240F40E0A
 for <kvmarm@lists.cs.columbia.edu>; Sat, 25 Dec 2021 04:11:50 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id iVq5-6uhX9lv for <kvmarm@lists.cs.columbia.edu>;
 Sat, 25 Dec 2021 04:11:49 -0500 (EST)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.129.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E86C940D34
 for <kvmarm@lists.cs.columbia.edu>; Sat, 25 Dec 2021 04:11:48 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1640423508;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=zldxMj+mOa4xEISADiWr6dy8ahQABwEEuVquONVwlSU=;
 b=dHRaPVDDTdKn/Z28wgdsHNReryDweiMjJmQYnPkR8WG+jnAkmER0aGBl3ZurDrwxnkK6lQ
 9Rthp/v8W4zmYRi3IrRQD5KzwaHaGXz6j9/ioPZ8j6S9kDyKopOo/V3V82GvRMFT9lWdT4
 8WuqE06OKGVtfNtoyYJTUa8HlXhNni8=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-235-qquLvVE2O4GNlKyvqqJOjw-1; Sat, 25 Dec 2021 04:11:47 -0500
X-MC-Unique: qquLvVE2O4GNlKyvqqJOjw-1
Received: by mail-ed1-f72.google.com with SMTP id
 dm10-20020a05640222ca00b003f808b5aa18so7944026edb.4
 for <kvmarm@lists.cs.columbia.edu>; Sat, 25 Dec 2021 01:11:46 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=zldxMj+mOa4xEISADiWr6dy8ahQABwEEuVquONVwlSU=;
 b=Ige9BKxv/S4EQWF07+pBH0FPUlX45mpw53JARs4WSzKbcHk+Ky2GR7ohb7tQ4LXVYE
 CPf+FSdiESnCOi53Ib421J8VcrATgmYqk10RNfEl5c0AJY/FOrsLg8arBi9PAtZ1o0AC
 NtduId2172/x3pFw1A3YHDRHl8OJkRyz5PQIRVPTDybFHPwDa7HjcKqEtbX1VInEDGWE
 6MBCBBMjOco7j3OYhwHNokmJsRDfq0ug9kXXQKVn5ob459R0cCabsl+yS2gb/bZT9wOr
 9Tp6+X7knBO6cRD9jIZ4jOQBy3XJNZNs2ij/p56CgBrnxPiGXH+qmSeJ5EuD/R7ppk7n
 mDJQ==
X-Gm-Message-State: AOAM531cS1Go2npVSl3IDRDkwDOdyUTxugGOpD408lAt4OO4sChzVO8r
 FDB7iRTdSvUJlLQMiV9l4b4AafLCr1OKgNn5Zg8LZJUokXEdrELSizPp7QQ2dEoX1Gf/T1HKW7R
 BGzRIHKIIOjALIyUTA6zIRWPV
X-Received: by 2002:a17:907:9717:: with SMTP id
 jg23mr8342951ejc.593.1640423505855; 
 Sat, 25 Dec 2021 01:11:45 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxYG9NlF9xuaeOATknk+JawNqx6o5eHic3XVZf5gR+23IdJV86It317VASJSiDbLfIH+6i+wA==
X-Received: by 2002:a17:907:9717:: with SMTP id
 jg23mr8342924ejc.593.1640423505581; 
 Sat, 25 Dec 2021 01:11:45 -0800 (PST)
Received: from gator.home (cst2-173-70.cust.vodafone.cz. [31.30.173.70])
 by smtp.gmail.com with ESMTPSA id y17sm3923961edd.31.2021.12.25.01.11.43
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Sat, 25 Dec 2021 01:11:44 -0800 (PST)
Date: Sat, 25 Dec 2021 10:11:42 +0100
From: Andrew Jones <drjones@redhat.com>
To: Michael Roth <michael.roth@amd.com>
Subject: Re: [PATCH RFC 02/10] kvm: selftests: move ucall declarations into
 ucall_common.h
Message-ID: <20211225091142.k6szpew4uatrvaus@gator.home>
References: <20211210164620.11636-1-michael.roth@amd.com>
 <20211210164620.11636-3-michael.roth@amd.com>
MIME-Version: 1.0
In-Reply-To: <20211210164620.11636-3-michael.roth@amd.com>
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=drjones@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Cc: Brijesh Singh <brijesh.singh@amd.com>, kvm@vger.kernel.org,
 David Hildenbrand <david@redhat.com>, Marc Orr <marcorr@google.com>,
 linux-kselftest@vger.kernel.org, "H . Peter Anvin" <hpa@zytor.com>,
 Claudio Imbrenda <imbrenda@linux.ibm.com>, Shuah Khan <shuah@kernel.org>,
 kvmarm@lists.cs.columbia.edu, Nathan Tempelman <natet@google.com>,
 Janosch Frank <frankja@linux.ibm.com>, Marc Zyngier <maz@kernel.org>,
 Joerg Roedel <joro@8bytes.org>, x86@kernel.org, Ingo Molnar <mingo@redhat.com>,
 Mingwei Zhang <mizhang@google.com>,
 Christian Borntraeger <borntraeger@linux.ibm.com>,
 Tom Lendacky <thomas.lendacky@amd.com>, Borislav Petkov <bp@alien8.de>,
 Thomas Gleixner <tglx@linutronix.de>, Varad Gautam <varad.gautam@suse.com>,
 Jim Mattson <jmattson@google.com>, Steve Rutherford <srutherford@google.com>,
 linux-kernel@vger.kernel.org, Vitaly Kuznetsov <vkuznets@redhat.com>,
 David Woodhouse <dwmw@amazon.co.uk>
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

On Fri, Dec 10, 2021 at 10:46:12AM -0600, Michael Roth wrote:
> Now that core kvm_util declarations have special home in
> kvm_util_base.h, move ucall-related declarations out into a separate
> header.
> 
> Signed-off-by: Michael Roth <michael.roth@amd.com>
> ---
>  .../testing/selftests/kvm/include/kvm_util.h  |  1 +
>  .../selftests/kvm/include/kvm_util_base.h     | 49 ---------------
>  .../selftests/kvm/include/ucall_common.h      | 59 +++++++++++++++++++
>  3 files changed, 60 insertions(+), 49 deletions(-)
>  create mode 100644 tools/testing/selftests/kvm/include/ucall_common.h
> 
> diff --git a/tools/testing/selftests/kvm/include/kvm_util.h b/tools/testing/selftests/kvm/include/kvm_util.h
> index c860ced3888d..c9286811a4cb 100644
> --- a/tools/testing/selftests/kvm/include/kvm_util.h
> +++ b/tools/testing/selftests/kvm/include/kvm_util.h
> @@ -8,5 +8,6 @@
>  #define SELFTEST_KVM_UTIL_H
>  
>  #include "kvm_util_base.h"
> +#include "ucall_common.h"
>  
>  #endif /* SELFTEST_KVM_UTIL_H */

Now that kvm_util.h is looking like a "libkvm.h", then we can do some more
header cleanups to make that official. After this series is merged I'll
send a series that

 - removes unnecessary includes from kvm_util_common.h and other headers
 - renames kvm_util.h to libkvm.h
 - also includes guest_modes.h and test_util.h from libkvm.h
 - simplify the includes of all unit tests since they'll be including
   libkvm.h
 - probably move include/sparsebit.h to lib, since no unit test needs it

Thanks,
drew

> diff --git a/tools/testing/selftests/kvm/include/kvm_util_base.h b/tools/testing/selftests/kvm/include/kvm_util_base.h
> index 8fb6aeff5469..4e2946ba3ff7 100644
> --- a/tools/testing/selftests/kvm/include/kvm_util_base.h
> +++ b/tools/testing/selftests/kvm/include/kvm_util_base.h
> @@ -360,55 +360,6 @@ int vm_create_device(struct kvm_vm *vm, struct kvm_create_device *cd);
>  
>  void assert_on_unhandled_exception(struct kvm_vm *vm, uint32_t vcpuid);
>  
> -/* Common ucalls */
> -enum {
> -	UCALL_NONE,
> -	UCALL_SYNC,
> -	UCALL_ABORT,
> -	UCALL_DONE,
> -	UCALL_UNHANDLED,
> -};
> -
> -#define UCALL_MAX_ARGS 6
> -
> -struct ucall {
> -	uint64_t cmd;
> -	uint64_t args[UCALL_MAX_ARGS];
> -};
> -
> -void ucall_init(struct kvm_vm *vm, void *arg);
> -void ucall_uninit(struct kvm_vm *vm);
> -void ucall(uint64_t cmd, int nargs, ...);
> -uint64_t get_ucall(struct kvm_vm *vm, uint32_t vcpu_id, struct ucall *uc);
> -
> -#define GUEST_SYNC_ARGS(stage, arg1, arg2, arg3, arg4)	\
> -				ucall(UCALL_SYNC, 6, "hello", stage, arg1, arg2, arg3, arg4)
> -#define GUEST_SYNC(stage)	ucall(UCALL_SYNC, 2, "hello", stage)
> -#define GUEST_DONE()		ucall(UCALL_DONE, 0)
> -#define __GUEST_ASSERT(_condition, _condstr, _nargs, _args...) do {    \
> -	if (!(_condition))                                              \
> -		ucall(UCALL_ABORT, 2 + _nargs,                          \
> -			"Failed guest assert: "                         \
> -			_condstr, __LINE__, _args);                     \
> -} while (0)
> -
> -#define GUEST_ASSERT(_condition) \
> -	__GUEST_ASSERT(_condition, #_condition, 0, 0)
> -
> -#define GUEST_ASSERT_1(_condition, arg1) \
> -	__GUEST_ASSERT(_condition, #_condition, 1, (arg1))
> -
> -#define GUEST_ASSERT_2(_condition, arg1, arg2) \
> -	__GUEST_ASSERT(_condition, #_condition, 2, (arg1), (arg2))
> -
> -#define GUEST_ASSERT_3(_condition, arg1, arg2, arg3) \
> -	__GUEST_ASSERT(_condition, #_condition, 3, (arg1), (arg2), (arg3))
> -
> -#define GUEST_ASSERT_4(_condition, arg1, arg2, arg3, arg4) \
> -	__GUEST_ASSERT(_condition, #_condition, 4, (arg1), (arg2), (arg3), (arg4))
> -
> -#define GUEST_ASSERT_EQ(a, b) __GUEST_ASSERT((a) == (b), #a " == " #b, 2, a, b)
> -
>  int vm_get_stats_fd(struct kvm_vm *vm);
>  int vcpu_get_stats_fd(struct kvm_vm *vm, uint32_t vcpuid);
>  
> diff --git a/tools/testing/selftests/kvm/include/ucall_common.h b/tools/testing/selftests/kvm/include/ucall_common.h
> new file mode 100644
> index 000000000000..9eecc9d40b79
> --- /dev/null
> +++ b/tools/testing/selftests/kvm/include/ucall_common.h
> @@ -0,0 +1,59 @@
> +/* SPDX-License-Identifier: GPL-2.0-only */
> +/*
> + * tools/testing/selftests/kvm/include/kvm_util.h
> + *
> + * Copyright (C) 2018, Google LLC.
> + */
> +#ifndef SELFTEST_KVM_UCALL_COMMON_H
> +#define SELFTEST_KVM_UCALL_COMMON_H
> +
> +/* Common ucalls */
> +enum {
> +	UCALL_NONE,
> +	UCALL_SYNC,
> +	UCALL_ABORT,
> +	UCALL_DONE,
> +	UCALL_UNHANDLED,
> +};
> +
> +#define UCALL_MAX_ARGS 6
> +
> +struct ucall {
> +	uint64_t cmd;
> +	uint64_t args[UCALL_MAX_ARGS];
> +};
> +
> +void ucall_init(struct kvm_vm *vm, void *arg);
> +void ucall_uninit(struct kvm_vm *vm);
> +void ucall(uint64_t cmd, int nargs, ...);
> +uint64_t get_ucall(struct kvm_vm *vm, uint32_t vcpu_id, struct ucall *uc);
> +
> +#define GUEST_SYNC_ARGS(stage, arg1, arg2, arg3, arg4)	\
> +				ucall(UCALL_SYNC, 6, "hello", stage, arg1, arg2, arg3, arg4)
> +#define GUEST_SYNC(stage)	ucall(UCALL_SYNC, 2, "hello", stage)
> +#define GUEST_DONE()		ucall(UCALL_DONE, 0)
> +#define __GUEST_ASSERT(_condition, _condstr, _nargs, _args...) do {    \
> +	if (!(_condition))                                              \
> +		ucall(UCALL_ABORT, 2 + _nargs,                          \
> +			"Failed guest assert: "                         \
> +			_condstr, __LINE__, _args);                     \
> +} while (0)
> +
> +#define GUEST_ASSERT(_condition) \
> +	__GUEST_ASSERT(_condition, #_condition, 0, 0)
> +
> +#define GUEST_ASSERT_1(_condition, arg1) \
> +	__GUEST_ASSERT(_condition, #_condition, 1, (arg1))
> +
> +#define GUEST_ASSERT_2(_condition, arg1, arg2) \
> +	__GUEST_ASSERT(_condition, #_condition, 2, (arg1), (arg2))
> +
> +#define GUEST_ASSERT_3(_condition, arg1, arg2, arg3) \
> +	__GUEST_ASSERT(_condition, #_condition, 3, (arg1), (arg2), (arg3))
> +
> +#define GUEST_ASSERT_4(_condition, arg1, arg2, arg3, arg4) \
> +	__GUEST_ASSERT(_condition, #_condition, 4, (arg1), (arg2), (arg3), (arg4))
> +
> +#define GUEST_ASSERT_EQ(a, b) __GUEST_ASSERT((a) == (b), #a " == " #b, 2, a, b)
> +
> +#endif /* SELFTEST_KVM_UCALL_COMMON_H */
> -- 
> 2.25.1
> 

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
