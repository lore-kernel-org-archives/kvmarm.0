Received: from mail-pj1-f49.google.com (mail-pj1-f49.google.com [209.85.216.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 590075C87
	for <kvmarm@lists.linux.dev>; Wed, 19 Oct 2022 23:39:50 +0000 (UTC)
Received: by mail-pj1-f49.google.com with SMTP id p6-20020a17090a748600b002103d1ef63aso1421731pjk.1
        for <kvmarm@lists.linux.dev>; Wed, 19 Oct 2022 16:39:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
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
        b=lJV4tHqKY6dZP8L9/JdZACD/RiloV6svcbRWaRxwaSM18/Sf1QpLMzgDfNn6/ZVb6U
         PWKxqQIBTQnXaiS6ZDqB5SUXxXXOZPWXCEuMmYysYi6pvREevL3BYzJ6EFwGcW+U7lkP
         EVk2rxL6RQxzY8m+KviL7c/ykayA7Cs2CxJJpvNBNoo1Iv50larubP1/ovndj//2dfzh
         PH77VTm3NvmTx2SYUTdJUmwTinooJtlz/pxBzEAXsJKz6oyO+M4SZ4yVRxLtABrbgABI
         NT3ZXpw4GQGtRiRPW+TpWA5eSlNuz5e7KYOHNc52VmHUWrbAc+v7vA8D+PKj2cQmNMw/
         JfNA==
X-Gm-Message-State: ACrzQf3Z08b1rqx8SMVenoyXNrSwrnwJ/Hc0Jpt/WfW3ZV1f20dcG1nD
	eRbDtlLBueytrUboDx6UfSPeCg==
X-Google-Smtp-Source: AMsMyM7gO/J7gWZdM++yB65z2vAHOxzDBDvyVdpN8uwu29BRqNmfxxvKTYGZoe397p9alXgi23L8Aw==
X-Received: by 2002:a17:902:ced1:b0:185:4ca4:263f with SMTP id d17-20020a170902ced100b001854ca4263fmr10720122plg.148.1666222789764;
        Wed, 19 Oct 2022 16:39:49 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id n6-20020a17090a2c8600b0020ad46d277bsm454567pjd.42.2022.10.19.16.39.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Oct 2022 16:39:48 -0700 (PDT)
Date: Wed, 19 Oct 2022 23:39:45 +0000
From: Sean Christopherson <seanjc@google.com>
To: Ricardo Koller <ricarkol@google.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev,
	kvmarm@lists.cs.columbia.edu, andrew.jones@linux.dev,
	pbonzini@redhat.com, maz@kernel.org, alexandru.elisei@arm.com,
	eric.auger@redhat.com, oupton@google.com, reijiw@google.com,
	rananta@google.com, bgardon@google.com, dmatlack@google.com,
	axelrasmussen@google.com, Oliver Upton <oliver.upton@linux.dev>
Subject: Re: [PATCH v10 01/14] KVM: selftests: Add a userfaultfd library
Message-ID: <Y1CKwZG3jBz7mOvj@google.com>
References: <20221017195834.2295901-1-ricarkol@google.com>
 <20221017195834.2295901-2-ricarkol@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221017195834.2295901-2-ricarkol@google.com>
Message-ID: <20221019233945.9iXQMwnu8h863Vl7X2yfdkqkLQV7xjaHegloTr9M-pY@z>

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
