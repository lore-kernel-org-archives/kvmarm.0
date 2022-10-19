Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 98977C433FE
	for <kvmarm@archiver.kernel.org>; Wed, 19 Oct 2022 23:39:54 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 280E64B912;
	Wed, 19 Oct 2022 19:39:54 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id ow2e1MhWkoko; Wed, 19 Oct 2022 19:39:53 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 14ECF4B922;
	Wed, 19 Oct 2022 19:39:53 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0AD1A4B908
 for <kvmarm@lists.cs.columbia.edu>; Wed, 19 Oct 2022 19:39:52 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id WB+llwgIZm6J for <kvmarm@lists.cs.columbia.edu>;
 Wed, 19 Oct 2022 19:39:51 -0400 (EDT)
Received: from mail-pj1-f49.google.com (mail-pj1-f49.google.com
 [209.85.216.49])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 0411F4B8F2
 for <kvmarm@lists.cs.columbia.edu>; Wed, 19 Oct 2022 19:39:50 -0400 (EDT)
Received: by mail-pj1-f49.google.com with SMTP id
 t10-20020a17090a4e4a00b0020af4bcae10so1410713pjl.3
 for <kvmarm@lists.cs.columbia.edu>; Wed, 19 Oct 2022 16:39:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
 bh=fKKXbcN44vw0WPAOU5aHRyCNZKKb/gCi94CUSavyllY=;
 b=d5G7DdsLHR5XVPJ76xOc7/0TVfc4rsd1X9piRJFDiUHpDjROsaC2cDHsBrZNYxf4zR
 MWVcWIUbvnn16py2n1dQJvnUrb0rYHLUUW9Ey88iuMspBbHoHDZAxUvN0UFjLWuxd70i
 sU9roJ0KNUnMMKWUCEr5p8o8yCtQvSUpkJicKKkQZmEPQgx40D/EkKkQF32OfcFvBvgx
 MmK7gHn3JKpE0ncXBFGRsAohrBXjIXuFNN4C7P+UWQAt0iwiPOP7u6zBxGGB1/nyqPSE
 08CEJ9BMzmFxFYS2ch08m3vm4ss9cF0UjhyVRTmS3OWQXuusk8PFpPBWzsDv5bJDArbI
 GxUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
 :message-id:reply-to;
 bh=fKKXbcN44vw0WPAOU5aHRyCNZKKb/gCi94CUSavyllY=;
 b=YuDoZlpd+NwNbtKKMTKS4pWcMAyNLAE9+jiNloLPxBCMvwwAyePgdwpoz8FKvVLy38
 Ge0Ldt4skdqbk7/a9aSmexFZPEIw3ovRKV7HoRMQa9BmNddxT1mQbXghzHp84kOohOSF
 qnBuxi91bC34ouQpYTRXicK2dBuhpn1uncecnNYxzeQv0nWGlLNPxuY4dpSAO+tamkB1
 EJm71YrJyWA6ztfqCB2Iq/ucYBCemqAqOuDYQ+gtPdOH+vxQuAqWdsEiTwMg4ORof70X
 EWHJjF19kegLQoHUfn+jIXb0YAeH8yDQQ96Z6rJjYhhkMNRLdAJ617XTZlWe6v7iFYeI
 CVfw==
X-Gm-Message-State: ACrzQf2KtGzByHS/+ufDDT6TEot4/OfDqjObqt9iXwBGUfk6MKv365rQ
 TVcumEzq8tile7vo+NoeSP8hUg==
X-Google-Smtp-Source: AMsMyM7gO/J7gWZdM++yB65z2vAHOxzDBDvyVdpN8uwu29BRqNmfxxvKTYGZoe397p9alXgi23L8Aw==
X-Received: by 2002:a17:902:ced1:b0:185:4ca4:263f with SMTP id
 d17-20020a170902ced100b001854ca4263fmr10720122plg.148.1666222789764; 
 Wed, 19 Oct 2022 16:39:49 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com.
 [34.168.104.7]) by smtp.gmail.com with ESMTPSA id
 n6-20020a17090a2c8600b0020ad46d277bsm454567pjd.42.2022.10.19.16.39.48
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Wed, 19 Oct 2022 16:39:48 -0700 (PDT)
Date: Wed, 19 Oct 2022 23:39:45 +0000
From: Sean Christopherson <seanjc@google.com>
To: Ricardo Koller <ricarkol@google.com>
Subject: Re: [PATCH v10 01/14] KVM: selftests: Add a userfaultfd library
Message-ID: <Y1CKwZG3jBz7mOvj@google.com>
References: <20221017195834.2295901-1-ricarkol@google.com>
 <20221017195834.2295901-2-ricarkol@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20221017195834.2295901-2-ricarkol@google.com>
Cc: kvm@vger.kernel.org, maz@kernel.org, bgardon@google.com,
 andrew.jones@linux.dev, kvmarm@lists.linux.dev, pbonzini@redhat.com,
 axelrasmussen@google.com, kvmarm@lists.cs.columbia.edu, dmatlack@google.com
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

On Mon, Oct 17, 2022, Ricardo Koller wrote:
> diff --git a/tools/testing/selftests/kvm/demand_paging_test.c b/tools/testing/selftests/kvm/demand_paging_test.c
> index 779ae54f89c4..8e1fe4ffcccd 100644
> --- a/tools/testing/selftests/kvm/demand_paging_test.c
> +++ b/tools/testing/selftests/kvm/demand_paging_test.c
> @@ -22,23 +22,13 @@
>  #include "test_util.h"
>  #include "perf_test_util.h"
>  #include "guest_modes.h"
> +#include "userfaultfd_util.h"
>  
>  #ifdef __NR_userfaultfd
>  
> -#ifdef PRINT_PER_PAGE_UPDATES
> -#define PER_PAGE_DEBUG(...) printf(__VA_ARGS__)
> -#else
> -#define PER_PAGE_DEBUG(...) _no_printf(__VA_ARGS__)
> -#endif
> -
> -#ifdef PRINT_PER_VCPU_UPDATES
> -#define PER_VCPU_DEBUG(...) printf(__VA_ARGS__)
> -#else
> -#define PER_VCPU_DEBUG(...) _no_printf(__VA_ARGS__)
> -#endif
> -
>  static int nr_vcpus = 1;
>  static uint64_t guest_percpu_mem_size = DEFAULT_PER_VCPU_MEM_SIZE;
> +
>  static size_t demand_paging_size;
>  static char *guest_data_prototype;
>  
> @@ -67,9 +57,11 @@ static void vcpu_worker(struct perf_test_vcpu_args *vcpu_args)
>  		       ts_diff.tv_sec, ts_diff.tv_nsec);
>  }
>  
> -static int handle_uffd_page_request(int uffd_mode, int uffd, uint64_t addr)
> +static int handle_uffd_page_request(int uffd_mode, int uffd,
> +		struct uffd_msg *msg)

Heh, one last alignment goof.
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
