Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D3414C433F5
	for <kvmarm@archiver.kernel.org>; Thu, 23 Dec 2021 16:17:20 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2FBA140BD6;
	Thu, 23 Dec 2021 11:17:20 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id YOAtKklf+WAl; Thu, 23 Dec 2021 11:17:18 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C5AD840C9C;
	Thu, 23 Dec 2021 11:17:18 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CE36040C31
 for <kvmarm@lists.cs.columbia.edu>; Thu, 23 Dec 2021 11:17:16 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id v2+t4Evraqxa for <kvmarm@lists.cs.columbia.edu>;
 Thu, 23 Dec 2021 11:17:15 -0500 (EST)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BE38740BD6
 for <kvmarm@lists.cs.columbia.edu>; Thu, 23 Dec 2021 11:17:15 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1640276235;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=LGHYzwJFpl5d7o2k8SxIMF3wKZE8+ynpp2p5jw8mxzU=;
 b=O4b4dCmIMTNXiUxWoPDNjsuex629hvKC1flRrlCV5ctxhbZF5woxqTVknzdzW1iIiQ20Jm
 kor22FltuxQ4iLrN4qxf6+rVUjANW12pWRLbV+seMA6FBuEp7taEhikskbEQktWumVHsYL
 F1UrtCTGA8GrQbY4PvpfdFVCJTqNL5M=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-92-99W2B0T2PAC7_I7KtG50ow-1; Thu, 23 Dec 2021 11:17:14 -0500
X-MC-Unique: 99W2B0T2PAC7_I7KtG50ow-1
Received: by mail-ed1-f69.google.com with SMTP id
 dm10-20020a05640222ca00b003f808b5aa18so4869671edb.4
 for <kvmarm@lists.cs.columbia.edu>; Thu, 23 Dec 2021 08:17:13 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=LGHYzwJFpl5d7o2k8SxIMF3wKZE8+ynpp2p5jw8mxzU=;
 b=nCy1l3qG0RYnUQ4q2kl427DXV7Bao3lBQK177I91vGdOJLKhDaByGjNehq8ib0cCOb
 OWMttYqAAvzwQHYZsrpQydKToC1xYUOU2LZ4DwyozmdrgxwvMMTEqSbrJhxC67bbs++u
 6d31CGDY9kx0gp3rDAm8PG4rCSJ91lHHstCh/ypSUvwd6NR/Me8B80kXsy5Srlaui9Bo
 EfII68DC3wEnhIdPhU3uGmsUYaiCYlQ6J64O+k5zAkhLHSRVmaU+dcnAxIY1XW6DU3ZV
 5TS8HjE0bumJTG5RAiblsdV0ztUT64aQ0NbZx1k8aiSdRW2w+RtV0usrGR5xHsr4UTvl
 cU0Q==
X-Gm-Message-State: AOAM531lc5KcY8hKyKAHrqmx7hZ+mZc4/86+8SR0UVROPEQqlgUHxWou
 L7C+w+l0sgL9zEDioSBPNmaQKSHWiWlOW4NvvPtem2QdTQ3iG1ttNVAUdQTaDOnf5QCwxpyxnCr
 gonxekXFIVB6cvZAdUATs7KXj
X-Received: by 2002:aa7:dd56:: with SMTP id o22mr2624455edw.73.1640276232960; 
 Thu, 23 Dec 2021 08:17:12 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwUPkJLnb1EUhOx+myvWcZIfjsLXUKVU1wzS4aV5TfG8x7KaiLf7iSrMJIF8BKFGDQyt6lFAw==
X-Received: by 2002:aa7:dd56:: with SMTP id o22mr2624436edw.73.1640276232745; 
 Thu, 23 Dec 2021 08:17:12 -0800 (PST)
Received: from gator.home (cst2-173-70.cust.vodafone.cz. [31.30.173.70])
 by smtp.gmail.com with ESMTPSA id eg12sm2118704edb.25.2021.12.23.08.17.11
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Thu, 23 Dec 2021 08:17:12 -0800 (PST)
Date: Thu, 23 Dec 2021 17:17:10 +0100
From: Andrew Jones <drjones@redhat.com>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH 3/5] KVM: selftests: arm64: Introduce a variable default
 IPA size
Message-ID: <20211223161710.ka3f2vjbmfuxp2op@gator.home>
References: <20211216123135.754114-1-maz@kernel.org>
 <20211216123135.754114-4-maz@kernel.org>
MIME-Version: 1.0
In-Reply-To: <20211216123135.754114-4-maz@kernel.org>
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=drjones@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Cc: kvm@vger.kernel.org, kernel-team@android.com,
 Paolo Bonzini <pbonzini@redhat.com>, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org
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

On Thu, Dec 16, 2021 at 12:31:33PM +0000, Marc Zyngier wrote:
> Contrary to popular belief, there is no such thing as a default
> IPA size on arm64. Anything goes, and implementations are the
> usual Wild West.
> 
> The selftest infrastructure default to 40bit IPA, which obviously
> doesn't work for some systems out there.
> 
> Turn VM_MODE_DEFAULT from a constant into a variable, and let
> guest_modes_append_default() populate it, depending on what
> the HW can do. In order to preserve the current behaviour, we
> still pick 40bits IPA as the default if it is available, and
> the largest supported IPA space otherwise.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  .../testing/selftests/kvm/include/kvm_util.h  |  4 ++-
>  tools/testing/selftests/kvm/lib/guest_modes.c | 28 +++++++++++++++++--
>  2 files changed, 29 insertions(+), 3 deletions(-)
> 
> diff --git a/tools/testing/selftests/kvm/include/kvm_util.h b/tools/testing/selftests/kvm/include/kvm_util.h
> index c74241ddf8b1..d2ba830a1faf 100644
> --- a/tools/testing/selftests/kvm/include/kvm_util.h
> +++ b/tools/testing/selftests/kvm/include/kvm_util.h
> @@ -53,7 +53,9 @@ enum vm_guest_mode {
>  
>  #if defined(__aarch64__)
>  
> -#define VM_MODE_DEFAULT			VM_MODE_P40V48_4K
> +extern enum vm_guest_mode vm_mode_default;
> +
> +#define VM_MODE_DEFAULT			vm_mode_default
>  #define MIN_PAGE_SHIFT			12U
>  #define ptes_per_page(page_size)	((page_size) / 8)
>  
> diff --git a/tools/testing/selftests/kvm/lib/guest_modes.c b/tools/testing/selftests/kvm/lib/guest_modes.c
> index c330f414ef96..fadc99bac69c 100644
> --- a/tools/testing/selftests/kvm/lib/guest_modes.c
> +++ b/tools/testing/selftests/kvm/lib/guest_modes.c
> @@ -4,22 +4,46 @@
>   */
>  #include "guest_modes.h"
>  
> +#ifdef __aarch64__
> +enum vm_guest_mode vm_mode_default;
> +#endif
> +
>  struct guest_mode guest_modes[NUM_VM_MODES];
>  
>  void guest_modes_append_default(void)
>  {
> +#ifndef __aarch64__
>  	guest_mode_append(VM_MODE_DEFAULT, true, true);
> -
> +#endif
>  #ifdef __aarch64__
> -	guest_mode_append(VM_MODE_P40V48_64K, true, true);
>  	{
>  		unsigned int limit = kvm_check_cap(KVM_CAP_ARM_VM_IPA_SIZE);
> +		int i;
> +
> +		vm_mode_default = NUM_VM_MODES;
> +
>  		if (limit >= 52)
>  			guest_mode_append(VM_MODE_P52V48_64K, true, true);
>  		if (limit >= 48) {
>  			guest_mode_append(VM_MODE_P48V48_4K, true, true);
>  			guest_mode_append(VM_MODE_P48V48_64K, true, true);
>  		}
> +		if (limit >= 40) {
> +			guest_mode_append(VM_MODE_P40V48_4K, true, true);
> +			guest_mode_append(VM_MODE_P40V48_64K, true, true);
> +			vm_mode_default = VM_MODE_P40V48_4K;
> +		}
> +
> +		/* Pick the largest supported IPA size */

The guest_modes array isn't sorted from smallest to largest PA addresses,
although it could be.

> +		for (i = 0;
> +		     vm_mode_default == NUM_VM_MODES && i < NUM_VM_MODES;
> +		     i++) {

Feel free to put this on one line.

> +			if (guest_modes[i].supported)

A bit safer would be to check both .supported and .enabled.

> +				vm_mode_default = i;
> +		}
> +
> +		TEST_ASSERT(vm_mode_default != NUM_VM_MODES,
> +			    "No supported mode!");
>  	}
>  #endif
>  #ifdef __s390x__
> -- 
> 2.30.2
>

Thanks,
drew

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
