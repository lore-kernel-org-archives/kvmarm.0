Return-Path: <SRS0=81/H=MN=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0D48CC12002
	for <kvmarm@archiver.kernel.org>; Wed, 21 Jul 2021 15:15:11 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 83A7E61245
	for <kvmarm@archiver.kernel.org>; Wed, 21 Jul 2021 15:15:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 83A7E61245
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C53584B0DD;
	Wed, 21 Jul 2021 11:15:09 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id ykQ+rnzQPCOO; Wed, 21 Jul 2021 11:15:08 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9656E4B0E1;
	Wed, 21 Jul 2021 11:15:08 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 096DD4B0DB
 for <kvmarm@lists.cs.columbia.edu>; Wed, 21 Jul 2021 11:15:07 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id gQcRC0UeHtZ8 for <kvmarm@lists.cs.columbia.edu>;
 Wed, 21 Jul 2021 11:15:05 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id EBDFC4B0CA
 for <kvmarm@lists.cs.columbia.edu>; Wed, 21 Jul 2021 11:15:05 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1626880505;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=QaTP1Yo6qFFIt4Y2xC3JPRyG4PRe8kuKhGKAihywiRs=;
 b=Gzuac4TGVwY1idv6sM3eG7qo6UGOrsnGLnz/4ttRBze7qHrUpBSDgFTRKEaSoOw/QVLm5n
 XLmS5zOWRQXTfqI6zWoz5ffgu3yYwb0YsC+3mMWekOpToj/O+GWxEWHlImtEN0mPobC9pl
 zYqFoMP4nIxNSMhj1CIleYpd0MA2JPM=
Received: from mail-io1-f70.google.com (mail-io1-f70.google.com
 [209.85.166.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-104-LL3wPNTVOt2njgWuyLBVvw-1; Wed, 21 Jul 2021 11:15:02 -0400
X-MC-Unique: LL3wPNTVOt2njgWuyLBVvw-1
Received: by mail-io1-f70.google.com with SMTP id
 l15-20020a5e820f0000b02904bd1794d00eso1801654iom.7
 for <kvmarm@lists.cs.columbia.edu>; Wed, 21 Jul 2021 08:15:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=QaTP1Yo6qFFIt4Y2xC3JPRyG4PRe8kuKhGKAihywiRs=;
 b=UdEbfN7/fjPKCvAM7kjPXqBK8ogNV9tlWcuSfa3KUbdIOZ0o6P6Se/JFDQPqgAsLwF
 MIcNpTrkquo7BX9bLukHdSQGrCjSQjhqa1XSzm2V50xAo0KA4KdZg6oo7kNj+1l5itIm
 2Gk2ueyyqf/47Q27QhKgMDyFZ65t1z4RdOV09C6KGh4J9vtYMayJ1XdrSFLW4XxD0UHI
 3B61nHRbFT+Pqz4dyO8k7a4gtrXOal6fBIJPPg4vUXSR+00esNnLxY3XVDWIrCOhD6pv
 I1h1MKj4WyUNvjDv4MAKAaM728zjW9RZdesuIu4IHwt/eh0Ak606jSBVSD4wx4Cyk65o
 +kcw==
X-Gm-Message-State: AOAM533X/b8H6YFa/FxxejVYnrcicgNhUwdGSYGP5c56C8cWuWxYESj2
 ZkXM65n+GR6eOkG57SKLFTlSd0QfjjhBPpwRpNwdjOKf3FD6m/xxNxp6AwDDGZ9r/HLtA6KPKXC
 bALJswp8Ai3kbjRFfrX3FcmFd
X-Received: by 2002:a92:cb52:: with SMTP id f18mr24584240ilq.97.1626880501559; 
 Wed, 21 Jul 2021 08:15:01 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzd/FbgpVsG1uAQQs/xRFLiKXf0pWWdYmq3RBA6j5gX0EFKv9+U0ZQHs17k7En54hjmVGaIUw==
X-Received: by 2002:a92:cb52:: with SMTP id f18mr24584222ilq.97.1626880501393; 
 Wed, 21 Jul 2021 08:15:01 -0700 (PDT)
Received: from gator ([140.82.166.162])
 by smtp.gmail.com with ESMTPSA id p18sm13090910ile.25.2021.07.21.08.15.00
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Wed, 21 Jul 2021 08:15:00 -0700 (PDT)
Date: Wed, 21 Jul 2021 17:14:58 +0200
From: Andrew Jones <drjones@redhat.com>
To: Oliver Upton <oupton@google.com>
Subject: Re: [PATCH v2 06/12] selftests: KVM: Add helpers for vCPU device
 attributes
Message-ID: <20210721151458.bsfbjtk7rmlupfve@gator>
References: <20210716212629.2232756-1-oupton@google.com>
 <20210716212629.2232756-7-oupton@google.com>
MIME-Version: 1.0
In-Reply-To: <20210716212629.2232756-7-oupton@google.com>
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=drjones@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Cc: kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
 Raghavendra Rao Anata <rananta@google.com>, Peter Shier <pshier@google.com>,
 Sean Christopherson <seanjc@google.com>, David Matlack <dmatlack@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org, Jim Mattson <jmattson@google.com>
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

On Fri, Jul 16, 2021 at 09:26:23PM +0000, Oliver Upton wrote:
> vCPU file descriptors are abstracted away from test code in KVM
> selftests, meaning that tests cannot directly access a vCPU's device
> attributes. Add helpers that tests can use to get at vCPU device
> attributes.
> 
> Signed-off-by: Oliver Upton <oupton@google.com>
> ---
>  .../testing/selftests/kvm/include/kvm_util.h  |  9 +++++
>  tools/testing/selftests/kvm/lib/kvm_util.c    | 38 +++++++++++++++++++
>  2 files changed, 47 insertions(+)
> 
> diff --git a/tools/testing/selftests/kvm/include/kvm_util.h b/tools/testing/selftests/kvm/include/kvm_util.h
> index a8ac5d52e17b..1b3ef5757819 100644
> --- a/tools/testing/selftests/kvm/include/kvm_util.h
> +++ b/tools/testing/selftests/kvm/include/kvm_util.h
> @@ -240,6 +240,15 @@ int _kvm_device_access(int dev_fd, uint32_t group, uint64_t attr,
>  int kvm_device_access(int dev_fd, uint32_t group, uint64_t attr,
>  		      void *val, bool write);
>  
> +int _vcpu_has_device_attr(struct kvm_vm *vm, uint32_t vcpuid, uint32_t group,
> +			  uint64_t attr);
> +int vcpu_has_device_attr(struct kvm_vm *vm, uint32_t vcpuid, uint32_t group,
> +			 uint64_t attr);
> +int _vcpu_access_device_attr(struct kvm_vm *vm, uint32_t vcpuid, uint32_t group,
> +			  uint64_t attr, void *val, bool write);
> +int vcpu_access_device_attr(struct kvm_vm *vm, uint32_t vcpuid, uint32_t group,
> +			 uint64_t attr, void *val, bool write);
> +
>  const char *exit_reason_str(unsigned int exit_reason);
>  
>  void virt_pgd_alloc(struct kvm_vm *vm);
> diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
> index 10a8ed691c66..b595e7dc3fc5 100644
> --- a/tools/testing/selftests/kvm/lib/kvm_util.c
> +++ b/tools/testing/selftests/kvm/lib/kvm_util.c
> @@ -2040,6 +2040,44 @@ int kvm_device_access(int dev_fd, uint32_t group, uint64_t attr,
>  	return ret;
>  }
>  
> +int _vcpu_has_device_attr(struct kvm_vm *vm, uint32_t vcpuid, uint32_t group,
> +			  uint64_t attr)
> +{
> +	struct vcpu *vcpu = vcpu_find(vm, vcpuid);
> +
> +	TEST_ASSERT(vcpu, "nonexistent vcpu id: %d", vcpuid);
> +
> +	return _kvm_device_check_attr(vcpu->fd, group, attr);
> +}
> +
> +int vcpu_has_device_attr(struct kvm_vm *vm, uint32_t vcpuid, uint32_t group,
> +				 uint64_t attr)
> +{
> +	int ret = _vcpu_has_device_attr(vm, vcpuid, group, attr);
> +
> +	TEST_ASSERT(!ret, "KVM_HAS_DEVICE_ATTR IOCTL failed, rc: %i errno: %i", ret, errno);
> +	return ret;
> +}
> +
> +int _vcpu_access_device_attr(struct kvm_vm *vm, uint32_t vcpuid, uint32_t group,
> +			     uint64_t attr, void *val, bool write)
> +{
> +	struct vcpu *vcpu = vcpu_find(vm, vcpuid);
> +
> +	TEST_ASSERT(vcpu, "nonexistent vcpu id: %d", vcpuid);
> +
> +	return _kvm_device_access(vcpu->fd, group, attr, val, write);
> +}
> +
> +int vcpu_access_device_attr(struct kvm_vm *vm, uint32_t vcpuid, uint32_t group,
> +			    uint64_t attr, void *val, bool write)
> +{
> +	int ret = _vcpu_access_device_attr(vm, vcpuid, group, attr, val, write);
> +
> +	TEST_ASSERT(!ret, "KVM_SET|GET_DEVICE_ATTR IOCTL failed, rc: %i errno: %i", ret, errno);
> +	return ret;
> +}


Reviewed-by: Andrew Jones <drjones@redhat.com>


The 'assert !ret's are correct here. I see they are not correct in 

 kvm_device_check_attr
 kvm_create_device
 kvm_device_access

though, as they are 'assert ret >= 0', but the documentation says 0 on
success. It'd be nice to get that fixed before we build more API on top
of it.

Thanks,
drew


> +
>  /*
>   * VM Dump
>   *
> -- 
> 2.32.0.402.g57bb445576-goog
> 
> _______________________________________________
> kvmarm mailing list
> kvmarm@lists.cs.columbia.edu
> https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
> 

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
