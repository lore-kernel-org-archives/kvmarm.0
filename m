Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 90266C433F5
	for <kvmarm@archiver.kernel.org>; Thu, 23 Dec 2021 16:26:39 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0D87040C67;
	Thu, 23 Dec 2021 11:26:39 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id iC1s8m7tNQAq; Thu, 23 Dec 2021 11:26:37 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C6D9240CF3;
	Thu, 23 Dec 2021 11:26:37 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 91AB840C9C
 for <kvmarm@lists.cs.columbia.edu>; Thu, 23 Dec 2021 11:26:36 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id laOhgSxWGAAL for <kvmarm@lists.cs.columbia.edu>;
 Thu, 23 Dec 2021 11:26:35 -0500 (EST)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.129.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6EBA240C31
 for <kvmarm@lists.cs.columbia.edu>; Thu, 23 Dec 2021 11:26:35 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1640276794;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=QrlHmIY4mFoUxlNzEFbDzQmln3zBPSqJJI9vwL5pPpY=;
 b=ZGt2teeglGOxJOjY2gOGhzVn89SHlHFbPuUMxVFaj3pBKtvf57stwfDh6QJiBXDEKqRZSo
 DW9/zrFkfSoGqrqYNhGvOgGBOZA0Xbl1oH1olDwrAqt93th5DxGwaJ5nWAAHcGc+U978dD
 3GyBROWZzCtBl5KtRxWCLiRxjNW4aqs=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-491-8SGo4t10MW6JoPyqRDuVTw-1; Thu, 23 Dec 2021 11:26:33 -0500
X-MC-Unique: 8SGo4t10MW6JoPyqRDuVTw-1
Received: by mail-ed1-f70.google.com with SMTP id
 w10-20020a50d78a000000b003f82342a95aso4843316edi.22
 for <kvmarm@lists.cs.columbia.edu>; Thu, 23 Dec 2021 08:26:33 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=QrlHmIY4mFoUxlNzEFbDzQmln3zBPSqJJI9vwL5pPpY=;
 b=fUDXtu9fIZpN5M+Z/oUtNrSUZd2Usz7hrs3cIKmyGrhkKFCF6bZIIVnfACdSFp7GO+
 fQK6OrLAC9vaNhepB6il5MU9m2131X1R+cNseXNWj24bWO1S1GiX2Px0WHL/PuyKApvo
 46anFtt/6ta2Z3BtF1fyp+VXmfTRu4qwmhOzTo5zd+6yWqIkdREVqKVtmGiFTM9ZVtKo
 IgyMQUCIzEYyrmyuH7vM0liiBPbHBv2YVBl9Q45WpU6VA4KOt/+ahsBMCgxMAT/1yZY5
 H1sKaWqKpoew2ezXaKODGm+HFC0ZJnjqdK/RQVmd6gYGmwrSm3khAeFtmqPeQ5MimLoK
 vMgA==
X-Gm-Message-State: AOAM531OLxhiwXz8Rl5Tae3+YyFpPBwDk3mMcJsZQVIQ+hNTIGm1iyO3
 P28275At0P9dLds6IvEKXyOeWJRDunW6GxxSx5LsdKlNe/pXFyhayRuCpvJ8fkxQapWjXVar9+6
 ON06XMdzIDwz1s8K9WNs+3/z4
X-Received: by 2002:a17:907:1c92:: with SMTP id
 nb18mr2489089ejc.249.1640276792294; 
 Thu, 23 Dec 2021 08:26:32 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwSub4/jrRZCW/Xw5IdU3TAQh4Ygh8ZQC1rVoHyx4sV8OkXGpQDqoKopfnZeSquQ1duYDmN7g==
X-Received: by 2002:a17:907:1c92:: with SMTP id
 nb18mr2488958ejc.249.1640276791776; 
 Thu, 23 Dec 2021 08:26:31 -0800 (PST)
Received: from gator.home (cst2-173-70.cust.vodafone.cz. [31.30.173.70])
 by smtp.gmail.com with ESMTPSA id k21sm2106368edo.87.2021.12.23.08.26.31
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Thu, 23 Dec 2021 08:26:31 -0800 (PST)
Date: Thu, 23 Dec 2021 17:26:29 +0100
From: Andrew Jones <drjones@redhat.com>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH 4/5] KVM: selftests: arm64: Check for supported page sizes
Message-ID: <20211223162629.cdbo5cxfmin5l4g6@gator.home>
References: <20211216123135.754114-1-maz@kernel.org>
 <20211216123135.754114-5-maz@kernel.org>
MIME-Version: 1.0
In-Reply-To: <20211216123135.754114-5-maz@kernel.org>
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

On Thu, Dec 16, 2021 at 12:31:34PM +0000, Marc Zyngier wrote:
> Just as arm64 implemenations don't necessary support all IPA
> ranges, they don't  all support the same page sizes either. Fun.
> 
> Create a dummy VM to snapshot the page sizes supported by the
> host, and filter the supported modes.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  tools/testing/selftests/kvm/lib/guest_modes.c | 51 ++++++++++++++++---
>  1 file changed, 45 insertions(+), 6 deletions(-)
> 
> diff --git a/tools/testing/selftests/kvm/lib/guest_modes.c b/tools/testing/selftests/kvm/lib/guest_modes.c
> index fadc99bac69c..8db9ea2c4032 100644
> --- a/tools/testing/selftests/kvm/lib/guest_modes.c
> +++ b/tools/testing/selftests/kvm/lib/guest_modes.c
> @@ -5,7 +5,42 @@
>  #include "guest_modes.h"
>  
>  #ifdef __aarch64__
> +#include "processor.h"
>  enum vm_guest_mode vm_mode_default;
> +static void get_supported_psz(uint32_t ipa,
> +			      bool *ps4k, bool *ps16k, bool *ps64k)
> +{
> +	struct kvm_vcpu_init preferred_init;
> +	int kvm_fd, vm_fd, vcpu_fd, err;
> +	uint64_t val;
> +	struct kvm_one_reg reg = {
> +		.id	= KVM_ARM64_SYS_REG(SYS_ID_AA64MMFR0_EL1),
> +		.addr	= (uint64_t)&val,
> +	};
> +
> +	kvm_fd = open_kvm_dev_path_or_exit();
> +	vm_fd = ioctl(kvm_fd, KVM_CREATE_VM, ipa);
> +	TEST_ASSERT(vm_fd >= 0, "Can't create VM");
> +
> +	vcpu_fd = ioctl(vm_fd, KVM_CREATE_VCPU, 0);
> +	TEST_ASSERT(vcpu_fd >= 0, "Can't create vcpu");
> +
> +	err = ioctl(vm_fd, KVM_ARM_PREFERRED_TARGET, &preferred_init);
> +	TEST_ASSERT(err == 0, "Can't get target");
> +	err = ioctl(vcpu_fd, KVM_ARM_VCPU_INIT, &preferred_init);
> +	TEST_ASSERT(err == 0, "Can't get init vcpu");
> +
> +	err = ioctl(vcpu_fd, KVM_GET_ONE_REG, &reg);
> +	TEST_ASSERT(err == 0, "Can't get MMFR0");
> +
> +	*ps4k = ((val >> 28) & 0xf) != 0xf;
> +	*ps64k = ((val >> 24) & 0xf) == 0;
> +	*ps16k = ((val >> 20) & 0xf) != 0;
> +
> +	close(vcpu_fd);
> +	close(vm_fd);
> +	close(kvm_fd);
> +}

I think I'd prefer stashing this function in lib/aarch64/processor.c and
naming it aarch64_get_supported_page_sizes.

>  #endif
>  
>  struct guest_mode guest_modes[NUM_VM_MODES];
> @@ -18,20 +53,24 @@ void guest_modes_append_default(void)
>  #ifdef __aarch64__
>  	{
>  		unsigned int limit = kvm_check_cap(KVM_CAP_ARM_VM_IPA_SIZE);
> +		bool ps4k, ps16k, ps64k;
>  		int i;
>  
> +		get_supported_psz(limit, &ps4k, &ps16k, &ps64k);
> +
>  		vm_mode_default = NUM_VM_MODES;
>  
>  		if (limit >= 52)
> -			guest_mode_append(VM_MODE_P52V48_64K, true, true);
> +			guest_mode_append(VM_MODE_P52V48_64K, ps64k, ps64k);
>  		if (limit >= 48) {
> -			guest_mode_append(VM_MODE_P48V48_4K, true, true);
> -			guest_mode_append(VM_MODE_P48V48_64K, true, true);
> +			guest_mode_append(VM_MODE_P48V48_4K, ps4k, ps4k);
> +			guest_mode_append(VM_MODE_P48V48_64K, ps64k, ps64k);
>  		}
>  		if (limit >= 40) {
> -			guest_mode_append(VM_MODE_P40V48_4K, true, true);
> -			guest_mode_append(VM_MODE_P40V48_64K, true, true);
> -			vm_mode_default = VM_MODE_P40V48_4K;
> +			guest_mode_append(VM_MODE_P40V48_4K, ps4k, ps4k);
> +			guest_mode_append(VM_MODE_P40V48_64K, ps64k, ps64k);
> +			if (ps4k)
> +				vm_mode_default = VM_MODE_P40V48_4K;
>  		}
>  
>  		/* Pick the largest supported IPA size */
> -- 
> 2.30.2
>

Thanks,
drew 

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
