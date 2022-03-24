Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6672DC433FE
	for <kvmarm@archiver.kernel.org>; Thu, 24 Mar 2022 17:19:43 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CBCD54B125;
	Thu, 24 Mar 2022 13:19:42 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id JZEzUs9UH1MT; Thu, 24 Mar 2022 13:19:41 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BD90B4B11A;
	Thu, 24 Mar 2022 13:19:41 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 50EB849F24
 for <kvmarm@lists.cs.columbia.edu>; Thu, 24 Mar 2022 13:19:40 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id JstE-ROjFaNU for <kvmarm@lists.cs.columbia.edu>;
 Thu, 24 Mar 2022 13:19:39 -0400 (EDT)
Received: from mail-pf1-f181.google.com (mail-pf1-f181.google.com
 [209.85.210.181])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 3ED2B49F21
 for <kvmarm@lists.cs.columbia.edu>; Thu, 24 Mar 2022 13:19:39 -0400 (EDT)
Received: by mail-pf1-f181.google.com with SMTP id p8so4471599pfh.8
 for <kvmarm@lists.cs.columbia.edu>; Thu, 24 Mar 2022 10:19:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=AlNuoUD39JW7fYG/U4MZObcSsVepwhRD404jTn/DU2Y=;
 b=lVnCH9NNR/upTexZBbXM3APxsXUf9fZwGu7lAZqyqAi89Vgkj97jjUkgM1OvdGeIso
 4CJMQYE4ODpjkhdTvrFmFiNKILN4spQUP1Iv4dnWyiaEONv70fJmt3bqR7hkG1iYEPKO
 XhriOuuwC4yjhs2KLBX36Ft6RPblHVN3dZ7SFWFGJxhHJ/2bWc4W3tdrODjC4DHrRP+6
 w6zhMFvhApz8Pb3jBJBypvqhjy7ByZTMplytBGZCw3zTkxMu39iMSUcQ3VL8UWmShUH3
 2tawQZypgjDNTWmqGJQXIAfTXiqR42hv4CU4ktKlJ5YfvqmIO9+7hAsH9DK51QrgI3bo
 3RBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=AlNuoUD39JW7fYG/U4MZObcSsVepwhRD404jTn/DU2Y=;
 b=7X3AnWFsi8XKC0h7xIa//F1VLiguA5NPIuZ0zu9W+CMeIVcXfb3aUC04642rUSK/bf
 5Npa969v+kEieRW5e00Dz8H8R9lnRP9RLGYcFLaXft28R4ZkkTptNdCKYChRTE9ywKBj
 hp4D7+MV+ulxQruldb8dFDzmRks5RYawicaNRZMzU22JGiTTQQ/uIqnTC+dAKEC26uTD
 C9lLxbwSWzDXVWXGO4+EzHyf0Ere5RjxvRH4EI8hYHf45vFWk2N+J9jua6kxCzLw1BVx
 1TOxHiQgk8MnT39DyoT4LON++AAxn9wCKxM0pxoFiMf38ZvVBoAi3lw/zKZjzHBXmhml
 zeUQ==
X-Gm-Message-State: AOAM532wdZFszOSmKQEjObI6IybrCYsZsUxoDO+zFuycFhXIXfShDdqq
 z6dLxoG90IUJjeQONjDKJ7jPzQ==
X-Google-Smtp-Source: ABdhPJyf7y92+DjD9Mv03aglLgiyiM6jKEZyl+y/I0yl5B6pCx3hFOZFHeGqGBfW870gVXWSLO3Rpg==
X-Received: by 2002:a63:dc44:0:b0:381:5720:88a5 with SMTP id
 f4-20020a63dc44000000b00381572088a5mr4883596pgj.219.1648142378049; 
 Thu, 24 Mar 2022 10:19:38 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com.
 [35.185.214.157]) by smtp.gmail.com with ESMTPSA id
 s3-20020a056a00194300b004f6da3a1a3bsm4248970pfk.8.2022.03.24.10.19.37
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Thu, 24 Mar 2022 10:19:37 -0700 (PDT)
Date: Thu, 24 Mar 2022 17:19:34 +0000
From: Sean Christopherson <seanjc@google.com>
To: Ricardo Koller <ricarkol@google.com>
Subject: Re: [PATCH v3 2/4] KVM: selftests: add is_cpu_online() utility
 function
Message-ID: <YjyoJu0/Saowtrbc@google.com>
References: <20220322172319.2943101-1-ricarkol@google.com>
 <20220322172319.2943101-3-ricarkol@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20220322172319.2943101-3-ricarkol@google.com>
Cc: maz@kernel.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
 pbonzini@redhat.com
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

On Tue, Mar 22, 2022, Ricardo Koller wrote:
> Add is_cpu_online() utility function: a wrapper for
> "/sys/devices/system/cpu/cpu%d/online".
> 
> Signed-off-by: Ricardo Koller <ricarkol@google.com>
> ---
>  tools/testing/selftests/kvm/include/test_util.h |  2 ++
>  tools/testing/selftests/kvm/lib/test_util.c     | 16 ++++++++++++++++
>  2 files changed, 18 insertions(+)
> 
> diff --git a/tools/testing/selftests/kvm/include/test_util.h b/tools/testing/selftests/kvm/include/test_util.h
> index 99e0dcdc923f..14084dc4e152 100644
> --- a/tools/testing/selftests/kvm/include/test_util.h
> +++ b/tools/testing/selftests/kvm/include/test_util.h
> @@ -143,4 +143,6 @@ static inline void *align_ptr_up(void *x, size_t size)
>  	return (void *)align_up((unsigned long)x, size);
>  }
>  
> +bool is_cpu_online(int pcpu);
> +
>  #endif /* SELFTEST_KVM_TEST_UTIL_H */
> diff --git a/tools/testing/selftests/kvm/lib/test_util.c b/tools/testing/selftests/kvm/lib/test_util.c
> index 6d23878bbfe1..81950e6b6d10 100644
> --- a/tools/testing/selftests/kvm/lib/test_util.c
> +++ b/tools/testing/selftests/kvm/lib/test_util.c
> @@ -334,3 +334,19 @@ long get_run_delay(void)
>  
>  	return val[1];
>  }
> +
> +bool is_cpu_online(int pcpu)
> +{
> +	char p[128];
> +	FILE *fp;
> +	int ret;
> +
> +	snprintf(p, sizeof(p), "/sys/devices/system/cpu/cpu%d/online", pcpu);

I don't think this is sufficient for the use in patch 03; the CPU could be online
but disallowed for use by the current task.  I think what you want instead is a
combination of get_nprocs_conf() + sched_getaffinity() + CPU_ISSET().
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
