Return-Path: <SRS0=I0RO=MK=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.1 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5A3EAC636CA
	for <kvmarm@archiver.kernel.org>; Sun, 18 Jul 2021 20:42:54 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id C1AD361179
	for <kvmarm@archiver.kernel.org>; Sun, 18 Jul 2021 20:42:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C1AD361179
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3C3454080B;
	Sun, 18 Jul 2021 16:42:53 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id TdT8CIgMvVyu; Sun, 18 Jul 2021 16:42:51 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D22414081C;
	Sun, 18 Jul 2021 16:42:51 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C6F9F4081C
 for <kvmarm@lists.cs.columbia.edu>; Sun, 18 Jul 2021 16:42:50 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 3NkXlwuOdba2 for <kvmarm@lists.cs.columbia.edu>;
 Sun, 18 Jul 2021 16:42:48 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E08FC4080B
 for <kvmarm@lists.cs.columbia.edu>; Sun, 18 Jul 2021 16:42:48 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1626640968;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=JboBw7DmcI9h7tX28Es0G4/IDQPgJaA4/TEau72JpOM=;
 b=TFWHAV9JHnLIasDcPXOjYjMywhM87hFQoHfz19pXrAptI9wS2YPEhD8nRjl/Wc8Xv/GHeC
 /chRIlisjQwiCzbENIjtnNxNNTLsti1+d0KHa3mMfIEv6rL78noDMw/37df2ugz2eccI/U
 mIL+Os8ZdO58S8EgbArLjDzEnKq8F+Q=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-394-fg6rQK7dPwSvVUTJYpIq6Q-1; Sun, 18 Jul 2021 16:42:46 -0400
X-MC-Unique: fg6rQK7dPwSvVUTJYpIq6Q-1
Received: by mail-ed1-f71.google.com with SMTP id
 r23-20020aa7d5970000b02903ae404e7fb4so6168035edq.12
 for <kvmarm@lists.cs.columbia.edu>; Sun, 18 Jul 2021 13:42:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:subject:to:cc:references:from:message-id:date
 :user-agent:mime-version:in-reply-to:content-language
 :content-transfer-encoding;
 bh=JboBw7DmcI9h7tX28Es0G4/IDQPgJaA4/TEau72JpOM=;
 b=Dji1cRRwsHmzWCGMQ4Mcp/3oy8LDYSDhrhy3JNjzQYW7pdGKBpdHjxaAv7UFWc5y3K
 8X5ByZQPENZ47YiasGK4jyLlmEB9KPMFbqt+Mh9ST9JxFD6FEtz3hFlr70QBnwkYwaCP
 H3t5XXy8JoS8ifnk+JM/QoXm1WWzElpFLCQQZLH5quPzWh9jG9pGqe2rBO9cq7YCwYja
 qcA63ONUpzrJhe6EClOy4EWSH3oi7bZq6bXmhq5WdJ0JchVxbvr5GgOWmBt+fyVFTlds
 fCh2d6VeijFrwZTc0Tm8H5loTYf8RMiX0hX4fjoP0TEI1ftc2TXLMXMAOAVg5UnRqTM+
 LxqQ==
X-Gm-Message-State: AOAM5318ha3ciBakNkc7HhuqVodkm+QQme5IBWAGINaFs6FHmKA6C+lq
 40ONJTIRk9+m4OVrjy/sMVpt5Jw8IcXuPIN3mG54054wbEkg2iz3UrDpgmDcEBb0UY40N5Uybgh
 bAQ+SAj4UL7HlrbPqM4nMGyqb
X-Received: by 2002:a17:906:794b:: with SMTP id
 l11mr23237369ejo.343.1626640965292; 
 Sun, 18 Jul 2021 13:42:45 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwazpkz6hNS2tJXNYBKlKnGaiCSG8BqoHelHJBQ56dIywZPoNOO9T4Zr4nBRky4U8TjU6qlUA==
X-Received: by 2002:a17:906:794b:: with SMTP id
 l11mr23237346ejo.343.1626640965035; 
 Sun, 18 Jul 2021 13:42:45 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:63a7:c72e:ea0e:6045?
 ([2001:b07:6468:f312:63a7:c72e:ea0e:6045])
 by smtp.gmail.com with ESMTPSA id f1sm4837768edt.51.2021.07.18.13.42.43
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Sun, 18 Jul 2021 13:42:44 -0700 (PDT)
Subject: Re: [PATCH v2 03/12] KVM: x86: Expose TSC offset controls to userspace
To: Oliver Upton <oupton@google.com>, kvm@vger.kernel.org,
 kvmarm@lists.cs.columbia.edu
References: <20210716212629.2232756-1-oupton@google.com>
 <20210716212629.2232756-4-oupton@google.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <deb0d356-0188-9df9-73cc-e5b81b6d39ca@redhat.com>
Date: Sun, 18 Jul 2021 22:42:43 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210716212629.2232756-4-oupton@google.com>
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=pbonzini@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Cc: Sean Christopherson <seanjc@google.com>,
 Raghavendra Rao Anata <rananta@google.com>, Peter Shier <pshier@google.com>,
 Marc Zyngier <maz@kernel.org>, David Matlack <dmatlack@google.com>,
 Oliver Upton <oupton@gooogle.com>, linux-arm-kernel@lists.infradead.org,
 Jim Mattson <jmattson@google.com>
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
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

On 16/07/21 23:26, Oliver Upton wrote:
> To date, VMM-directed TSC synchronization and migration has been a bit
> messy. KVM has some baked-in heuristics around TSC writes to infer if
> the VMM is attempting to synchronize. This is problematic, as it depends
> on host userspace writing to the guest's TSC within 1 second of the last
> write.
> 
> A much cleaner approach to configuring the guest's views of the TSC is to
> simply migrate the TSC offset for every vCPU. Offsets are idempotent,
> and thus not subject to change depending on when the VMM actually
> reads/writes values from/to KVM. The VMM can then read the TSC once with
> KVM_GET_CLOCK to capture a (realtime, host_tsc) pair at the instant when
> the guest is paused.
> 
> Cc: David Matlack <dmatlack@google.com>
> Signed-off-by: Oliver Upton <oupton@gooogle.com>
> ---
>   arch/x86/include/asm/kvm_host.h |   1 +
>   arch/x86/include/uapi/asm/kvm.h |   4 +
>   arch/x86/kvm/x86.c              | 166 ++++++++++++++++++++++++++++++++
>   3 files changed, 171 insertions(+)

This is missing documentation.  The documentation should also include 
the algorithm in https://www.spinics.net/lists/kvm-arm/msg47383.html 
(modulo the fact that KVM_GET/SET_CLOCK return or pass realtime_ns 
rather than kvmclock_ns - relatime_ns; which is fine of course).

Paolo

> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index e527d7259415..45134b7b14d6 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1070,6 +1070,7 @@ struct kvm_arch {
>   	u64 last_tsc_nsec;
>   	u64 last_tsc_write;
>   	u32 last_tsc_khz;
> +	u64 last_tsc_offset;
>   	u64 cur_tsc_nsec;
>   	u64 cur_tsc_write;
>   	u64 cur_tsc_offset;
> diff --git a/arch/x86/include/uapi/asm/kvm.h b/arch/x86/include/uapi/asm/kvm.h
> index a6c327f8ad9e..0b22e1e84e78 100644
> --- a/arch/x86/include/uapi/asm/kvm.h
> +++ b/arch/x86/include/uapi/asm/kvm.h
> @@ -503,4 +503,8 @@ struct kvm_pmu_event_filter {
>   #define KVM_PMU_EVENT_ALLOW 0
>   #define KVM_PMU_EVENT_DENY 1
>   
> +/* for KVM_{GET,SET,HAS}_DEVICE_ATTR */
> +#define KVM_VCPU_TSC_CTRL 0 /* control group for the timestamp counter (TSC) */
> +#define   KVM_VCPU_TSC_OFFSET 0 /* attribute for the TSC offset */
> +
>   #endif /* _ASM_X86_KVM_H */
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index e1b7c8b67428..d22de0a1988a 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -2411,6 +2411,11 @@ static void kvm_vcpu_write_tsc_offset(struct kvm_vcpu *vcpu, u64 l1_offset)
>   	static_call(kvm_x86_write_tsc_offset)(vcpu, vcpu->arch.tsc_offset);
>   }
>   
> +static u64 kvm_vcpu_read_tsc_offset(struct kvm_vcpu *vcpu)
> +{
> +	return vcpu->arch.l1_tsc_offset;
> +}
> +
>   static void kvm_vcpu_write_tsc_multiplier(struct kvm_vcpu *vcpu, u64 l1_multiplier)
>   {
>   	vcpu->arch.l1_tsc_scaling_ratio = l1_multiplier;
> @@ -2467,6 +2472,7 @@ static void __kvm_synchronize_tsc(struct kvm_vcpu *vcpu, u64 offset, u64 tsc,
>   	kvm->arch.last_tsc_nsec = ns;
>   	kvm->arch.last_tsc_write = tsc;
>   	kvm->arch.last_tsc_khz = vcpu->arch.virtual_tsc_khz;
> +	kvm->arch.last_tsc_offset = offset;
>   
>   	vcpu->arch.last_guest_tsc = tsc;
>   
> @@ -4914,6 +4920,136 @@ static int kvm_set_guest_paused(struct kvm_vcpu *vcpu)
>   	return 0;
>   }
>   
> +static int kvm_arch_tsc_has_attr(struct kvm_vcpu *vcpu,
> +				 struct kvm_device_attr *attr)
> +{
> +	int r;
> +
> +	switch (attr->attr) {
> +	case KVM_VCPU_TSC_OFFSET:
> +		r = 0;
> +		break;
> +	default:
> +		r = -ENXIO;
> +	}
> +
> +	return r;
> +}
> +
> +static int kvm_arch_tsc_get_attr(struct kvm_vcpu *vcpu,
> +				 struct kvm_device_attr *attr)
> +{
> +	void __user *uaddr = (void __user *)attr->addr;
> +	int r;
> +
> +	switch (attr->attr) {
> +	case KVM_VCPU_TSC_OFFSET: {
> +		u64 offset;
> +
> +		offset = kvm_vcpu_read_tsc_offset(vcpu);
> +		r = -EFAULT;
> +		if (copy_to_user(uaddr, &offset, sizeof(offset)))
> +			break;
> +
> +		r = 0;
> +	}
> +	default:
> +		r = -ENXIO;
> +	}
> +
> +	return r;
> +}
> +
> +static int kvm_arch_tsc_set_attr(struct kvm_vcpu *vcpu,
> +				 struct kvm_device_attr *attr)
> +{
> +	void __user *uaddr = (void __user *)attr->addr;
> +	struct kvm *kvm = vcpu->kvm;
> +	int r;
> +
> +	switch (attr->attr) {
> +	case KVM_VCPU_TSC_OFFSET: {
> +		u64 offset, tsc, ns;
> +		unsigned long flags;
> +		bool matched;
> +
> +		r = -EFAULT;
> +		if (copy_from_user(&offset, uaddr, sizeof(offset)))
> +			break;
> +
> +		raw_spin_lock_irqsave(&kvm->arch.tsc_write_lock, flags);
> +
> +		matched = (vcpu->arch.virtual_tsc_khz &&
> +			   kvm->arch.last_tsc_khz == vcpu->arch.virtual_tsc_khz &&
> +			   kvm->arch.last_tsc_offset == offset);
> +
> +		tsc = kvm_scale_tsc(vcpu, rdtsc(), vcpu->arch.l1_tsc_scaling_ratio) + offset;
> +		ns = get_kvmclock_base_ns();
> +
> +		__kvm_synchronize_tsc(vcpu, offset, tsc, ns, matched);
> +		raw_spin_unlock_irqrestore(&kvm->arch.tsc_write_lock, flags);
> +
> +		r = 0;
> +		break;
> +	}
> +	default:
> +		r = -ENXIO;
> +	}
> +
> +	return r;
> +}
> +
> +static int kvm_vcpu_ioctl_has_device_attr(struct kvm_vcpu *vcpu,
> +					  struct kvm_device_attr *attr)
> +{
> +	int r;
> +
> +	switch (attr->group) {
> +	case KVM_VCPU_TSC_CTRL:
> +		r = kvm_arch_tsc_has_attr(vcpu, attr);
> +		break;
> +	default:
> +		r = -ENXIO;
> +		break;
> +	}
> +
> +	return r;
> +}
> +
> +static int kvm_vcpu_ioctl_get_device_attr(struct kvm_vcpu *vcpu,
> +					  struct kvm_device_attr *attr)
> +{
> +	int r;
> +
> +	switch (attr->group) {
> +	case KVM_VCPU_TSC_CTRL:
> +		r = kvm_arch_tsc_get_attr(vcpu, attr);
> +		break;
> +	default:
> +		r = -ENXIO;
> +		break;
> +	}
> +
> +	return r;
> +}
> +
> +static int kvm_vcpu_ioctl_set_device_attr(struct kvm_vcpu *vcpu,
> +					  struct kvm_device_attr *attr)
> +{
> +	int r;
> +
> +	switch (attr->group) {
> +	case KVM_VCPU_TSC_CTRL:
> +		r = kvm_arch_tsc_set_attr(vcpu, attr);
> +		break;
> +	default:
> +		r = -ENXIO;
> +		break;
> +	}
> +
> +	return r;
> +}
> +
>   static int kvm_vcpu_ioctl_enable_cap(struct kvm_vcpu *vcpu,
>   				     struct kvm_enable_cap *cap)
>   {
> @@ -5368,6 +5504,36 @@ long kvm_arch_vcpu_ioctl(struct file *filp,
>   		r = __set_sregs2(vcpu, u.sregs2);
>   		break;
>   	}
> +	case KVM_HAS_DEVICE_ATTR: {
> +		struct kvm_device_attr attr;
> +
> +		r = -EFAULT;
> +		if (copy_from_user(&attr, argp, sizeof(attr)))
> +			goto out;
> +
> +		r = kvm_vcpu_ioctl_has_device_attr(vcpu, &attr);
> +		break;
> +	}
> +	case KVM_GET_DEVICE_ATTR: {
> +		struct kvm_device_attr attr;
> +
> +		r = -EFAULT;
> +		if (copy_from_user(&attr, argp, sizeof(attr)))
> +			goto out;
> +
> +		r = kvm_vcpu_ioctl_get_device_attr(vcpu, &attr);
> +		break;
> +	}
> +	case KVM_SET_DEVICE_ATTR: {
> +		struct kvm_device_attr attr;
> +
> +		r = -EFAULT;
> +		if (copy_from_user(&attr, argp, sizeof(attr)))
> +			goto out;
> +
> +		r = kvm_vcpu_ioctl_set_device_attr(vcpu, &attr);
> +		break;
> +	}
>   	default:
>   		r = -EINVAL;
>   	}
> 

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
