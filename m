Return-Path: <SRS0=uZLN=NX=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 04E71C432BE
	for <kvmarm@archiver.kernel.org>; Wed,  1 Sep 2021 23:48:25 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 6159761026
	for <kvmarm@archiver.kernel.org>; Wed,  1 Sep 2021 23:48:24 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 6159761026
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CD5244B121;
	Wed,  1 Sep 2021 19:48:23 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id RZ67Aes00N6U; Wed,  1 Sep 2021 19:48:19 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id EB3CB4B12F;
	Wed,  1 Sep 2021 19:48:19 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 18E754B12F
 for <kvmarm@lists.cs.columbia.edu>; Wed,  1 Sep 2021 19:48:18 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id GtBStdY+vgYJ for <kvmarm@lists.cs.columbia.edu>;
 Wed,  1 Sep 2021 19:48:17 -0400 (EDT)
Received: from mail-io1-f52.google.com (mail-io1-f52.google.com
 [209.85.166.52])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 0F0464B121
 for <kvmarm@lists.cs.columbia.edu>; Wed,  1 Sep 2021 19:48:17 -0400 (EDT)
Received: by mail-io1-f52.google.com with SMTP id q3so212685iot.3
 for <kvmarm@lists.cs.columbia.edu>; Wed, 01 Sep 2021 16:48:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=7QLaqmuMdndaoDUoQKfj9TVz0nnnEHxweKe5hvBPXD0=;
 b=vLoV3R33YLTSXudj2GKqaz2xUKTo/hFMiYfsqG/Fz3dT8teBjlT7VODVk8heJfB0JT
 fUNhKoXkyn3UsIiwKTRMDEWo7nEJ4NVJX7SWhXurBTzziGFf2ls9a6cn6gBuqs85JPhL
 Rp6yb0/UPwD/9pIrcSxGX8Qao0EVoBbvygNditKUMfFrRMOS/rlbZX4YK+8UgVFlPyC7
 ItJyQLXmGmJlVEtJZvW6h8rYhkecCGKg9JxHNAqiRr4ylYCbedpzjIyn1ijclBeZ8/g2
 TSIs0i6xJo5sWN0UDJfjSFrTC/sFJ9wOkdQftASbkiEMOoRPLXLrGgaw4on2KvuSb7nI
 PX0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=7QLaqmuMdndaoDUoQKfj9TVz0nnnEHxweKe5hvBPXD0=;
 b=pcgaaVvvcUrhJuCEqo3juzPffmKIyCuTlaG3fJtsIoQGqP6L/B1EyMjl7101sSLE90
 WAevG/Ow1O3hDYtRQu06My0YzETXeAJBSDo+x0QmZGQ8r8gzNuvwxdi3Z7W+cu6I+JBP
 fir/B9Pi+Ew4oa+xaP4dddWbi6NCyd+6Bjx0xcg2BpZijXxh1AbPcK3TGUsdiZ2FhJeQ
 xvWkLMTlNXZTlJN56IXMTFpTZN84WMESiv4SqQVWWZL5PZtdbZKp9HdB5aFbUTfUSuG7
 nDDEpIbKQzFGgHIF/iRSPxyq/hxYWBpiYuw8gl5xvaZVWoJzVetTlFuhlVeduLpdAW7S
 /00Q==
X-Gm-Message-State: AOAM532StPVjRAJZAIbeY31QjukZSKPB8mYJiRNu010j1sOjry7qGACV
 vndhMabrW+HghGfkUNFP9YJYEw==
X-Google-Smtp-Source: ABdhPJz6cpuNWJjH26XrDJUo+kRNx4ojf/ksC3gj1/vmgDdieL8PaiWXNPxQsuZSqgO4P3XxcpmNHA==
X-Received: by 2002:a02:cc53:: with SMTP id i19mr379146jaq.124.1630540096213; 
 Wed, 01 Sep 2021 16:48:16 -0700 (PDT)
Received: from google.com (194.225.68.34.bc.googleusercontent.com.
 [34.68.225.194])
 by smtp.gmail.com with ESMTPSA id k21sm38569ioh.38.2021.09.01.16.48.15
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Wed, 01 Sep 2021 16:48:15 -0700 (PDT)
Date: Wed, 1 Sep 2021 23:48:12 +0000
From: Oliver Upton <oupton@google.com>
To: Raghavendra Rao Ananta <rananta@google.com>
Subject: Re: [PATCH v3 07/12] KVM: arm64: selftests: Add support to get the
 vcpuid from MPIDR_EL1
Message-ID: <YTARPBhMHXjgcPlg@google.com>
References: <20210901211412.4171835-1-rananta@google.com>
 <20210901211412.4171835-8-rananta@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20210901211412.4171835-8-rananta@google.com>
Cc: kvm@vger.kernel.org, Will Deacon <will@kernel.org>,
 Catalin Marinas <catalin.marinas@arm.com>, Peter Shier <pshier@google.com>,
 linux-kernel@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
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

On Wed, Sep 01, 2021 at 09:14:07PM +0000, Raghavendra Rao Ananta wrote:
> At times, such as when in the interrupt handler, the guest wants to
> get the vCPU-id that it's running on. As a result, introduce
> get_vcpuid() that parses the MPIDR_EL1 and returns the vcpuid to the
> requested caller.
> 
> Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
> ---
>  .../selftests/kvm/include/aarch64/processor.h | 19 +++++++++++++++++++
>  1 file changed, 19 insertions(+)
> 
> diff --git a/tools/testing/selftests/kvm/include/aarch64/processor.h b/tools/testing/selftests/kvm/include/aarch64/processor.h
> index c35bb7b8e870..8b372cd427da 100644
> --- a/tools/testing/selftests/kvm/include/aarch64/processor.h
> +++ b/tools/testing/selftests/kvm/include/aarch64/processor.h
> @@ -251,4 +251,23 @@ static inline void local_irq_disable(void)
>  	asm volatile("msr daifset, #3" : : : "memory");
>  }
>  
> +#define MPIDR_LEVEL_BITS 8
> +#define MPIDR_LEVEL_SHIFT(level) (MPIDR_LEVEL_BITS * level)
> +#define MPIDR_LEVEL_MASK ((1 << MPIDR_LEVEL_BITS) - 1)
> +#define MPIDR_AFFINITY_LEVEL(mpidr, level) \
> +	((mpidr >> MPIDR_LEVEL_SHIFT(level)) & MPIDR_LEVEL_MASK)
> +
> +static inline uint32_t get_vcpuid(void)
> +{
> +	uint32_t vcpuid = 0;
> +	uint64_t mpidr = read_sysreg(mpidr_el1);
> +
> +	/* KVM limits only 16 vCPUs at level 0 */
> +	vcpuid = mpidr & 0x0f;
> +	vcpuid |= MPIDR_AFFINITY_LEVEL(mpidr, 1) << 4;
> +	vcpuid |= MPIDR_AFFINITY_LEVEL(mpidr, 2) << 12;
> +
> +	return vcpuid;
> +}

Are we guaranteed that KVM will always compose vCPU IDs the same way? I
do not believe this is guaranteed ABI.

For the base case, you could pass the vCPU ID as an arg to the guest
function.

I do agree that finding the vCPU ID is a bit more challenging in an
interrupt context. Maybe use a ucall to ask userspace? But of course,
every test implements its own run loop, so its yet another case that
tests need to handle.

Or, you could allocate an array at runtime of length KVM_CAP_MAX_VCPUS
(use the KVM_CHECK_EXTENSION ioctl to get the value). Once all vCPUs are
instantiated, iterate over them from userspace to populate the {MPIDR,
VCPU_ID} map. You'd need to guarantee that callers initialize the vGIC
*after* adding vCPUs to the guest.

--
Thanks,
Oliver

>  #endif /* SELFTEST_KVM_PROCESSOR_H */
> -- 
> 2.33.0.153.gba50c8fa24-goog
> 
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
