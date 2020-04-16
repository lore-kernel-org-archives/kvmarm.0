Return-Path: <SRS0=0qdQ=6A=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.0 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D89FEC2BB85
	for <kvmarm@archiver.kernel.org>; Thu, 16 Apr 2020 14:16:55 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 562B92063A
	for <kvmarm@archiver.kernel.org>; Thu, 16 Apr 2020 14:16:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="SvYdGZ3a"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 562B92063A
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BA1A54B1CC;
	Thu, 16 Apr 2020 10:16:54 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 8tE7W7ALJZw9; Thu, 16 Apr 2020 10:16:53 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 70F2A4B1D9;
	Thu, 16 Apr 2020 10:16:53 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CF5104B1CC
 for <kvmarm@lists.cs.columbia.edu>; Thu, 16 Apr 2020 10:16:52 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id WHo4fRss+akE for <kvmarm@lists.cs.columbia.edu>;
 Thu, 16 Apr 2020 10:16:51 -0400 (EDT)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A6D9A4B1C8
 for <kvmarm@lists.cs.columbia.edu>; Thu, 16 Apr 2020 10:16:51 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1587046611;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=7hnF0DDKrlu0/wsAOrUaDsyzDUw85QJZaEcoKNO3lxk=;
 b=SvYdGZ3aB2HM4vGJZC4IJZMI5Ghn/QhCJUyzgirtfYUn5edLNd94S0dQ7aJT23gG+tZb/N
 hQgrpphHu1TUJukhuqbxXYToC1nH3oYw1m/FEd2eb7wdlaf+LB+wgs4ROE0hMnt4dL/yE8
 oXFWXd0CXJxn6pIHQrrTEQXC4E23Vew=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-186-Q-Wzibc6PyWgmuPM3AaWsA-1; Thu, 16 Apr 2020 10:16:49 -0400
X-MC-Unique: Q-Wzibc6PyWgmuPM3AaWsA-1
Received: by mail-wr1-f70.google.com with SMTP id i10so1296179wrq.8
 for <kvmarm@lists.cs.columbia.edu>; Thu, 16 Apr 2020 07:16:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:subject:to:cc:references:from:message-id:date
 :user-agent:mime-version:in-reply-to:content-language
 :content-transfer-encoding;
 bh=7hnF0DDKrlu0/wsAOrUaDsyzDUw85QJZaEcoKNO3lxk=;
 b=jqkThvik2STXSyIs8JIPjgMnh/RwaAS6o4xzw/U545a57Z8GHMu50nBq6gnu98OgLB
 JbddAS78iiooi4Zti169RpuinFFLLbJbnLKUxPBrMe7m03PU7+75+vMKE5bMk0sAv/ho
 9yEMdd1NeqWYEdii2lpnDY5oDCA9oH/v3aOVWPdwZbM/b4rAPPSXtdkzqF0FyFynn8Gd
 xyCMV9pUG4xdUqsDpTKGidDx8/1kliP6M9zu8qqPNR4GpuDGuPJEo/tDS4L/Jr1pcK1m
 QaJbOHWSP0r99U22EVnNxGBqJBIFVYjpw1VFwWf4197YfNbb4StjlGyPVjwlFgqrNIap
 ghlQ==
X-Gm-Message-State: AGi0PuajH2sv19wb8WbEb9FFnIbx8p3tS1m7xDQ3bQZOC2zXZT6xZiN0
 zbwK4iF9mFGUS0lLVh8jqEE9j59Tpq+Tta7wFRrzucXgNZ/ZtiogY7C9pckgyrI9bQizgjnVNlO
 /L0N0lxEe2Wnojczy1lGTWoVO
X-Received: by 2002:a5d:6584:: with SMTP id q4mr24139445wru.403.1587046608306; 
 Thu, 16 Apr 2020 07:16:48 -0700 (PDT)
X-Google-Smtp-Source: APiQypJaroci/qQpvf8qcrl+CF8Sz/BzOeyBmpL55iYWlGov5mFc7JlBFtlz5rT24UUwp7LeJ9OTfQ==
X-Received: by 2002:a5d:6584:: with SMTP id q4mr24139399wru.403.1587046607973; 
 Thu, 16 Apr 2020 07:16:47 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:399d:3ef7:647c:b12d?
 ([2001:b07:6468:f312:399d:3ef7:647c:b12d])
 by smtp.gmail.com with ESMTPSA id d133sm4118344wmc.27.2020.04.16.07.16.45
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Thu, 16 Apr 2020 07:16:47 -0700 (PDT)
Subject: Re: [PATCH v2] KVM: Optimize kvm_arch_vcpu_ioctl_run function
To: Tianjia Zhang <tianjia.zhang@linux.alibaba.com>,
 tsbogend@alpha.franken.de, paulus@ozlabs.org, mpe@ellerman.id.au,
 benh@kernel.crashing.org, borntraeger@de.ibm.com, frankja@linux.ibm.com,
 david@redhat.com, cohuck@redhat.com, heiko.carstens@de.ibm.com,
 gor@linux.ibm.com, sean.j.christopherson@intel.com, vkuznets@redhat.com,
 wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org,
 tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, x86@kernel.org,
 hpa@zytor.com, maz@kernel.org, james.morse@arm.com,
 julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com,
 christoffer.dall@arm.com, peterx@redhat.com, thuth@redhat.com
References: <20200416051057.26526-1-tianjia.zhang@linux.alibaba.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <db7b02c0-2b7b-7c93-9dd0-b0303ea5da5e@redhat.com>
Date: Thu, 16 Apr 2020 16:16:44 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200416051057.26526-1-tianjia.zhang@linux.alibaba.com>
Content-Language: en-US
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Cc: linux-s390@vger.kernel.org, kvm@vger.kernel.org, linux-mips@vger.kernel.org,
 kvm-ppc@vger.kernel.org, linux-kernel@vger.kernel.org,
 linuxppc-dev@lists.ozlabs.org, kvmarm@lists.cs.columbia.edu,
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

On 16/04/20 07:10, Tianjia Zhang wrote:
> In earlier versions of kvm, 'kvm_run' is an independent structure
> and is not included in the vcpu structure. At present, 'kvm_run'
> is already included in the vcpu structure, so the parameter
> 'kvm_run' is redundant.
> 
> This patch simplify the function definition, removes the extra
> 'kvm_run' parameter, and extract it from the 'kvm_vcpu' structure
> if necessary.
> 
> Signed-off-by: Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
> ---
> 
> v2 change:
>   remove 'kvm_run' parameter and extract it from 'kvm_vcpu'
> 
>  arch/mips/kvm/mips.c       |  3 ++-
>  arch/powerpc/kvm/powerpc.c |  3 ++-
>  arch/s390/kvm/kvm-s390.c   |  3 ++-
>  arch/x86/kvm/x86.c         | 11 ++++++-----
>  include/linux/kvm_host.h   |  2 +-
>  virt/kvm/arm/arm.c         |  6 +++---
>  virt/kvm/kvm_main.c        |  2 +-
>  7 files changed, 17 insertions(+), 13 deletions(-)
> 
> diff --git a/arch/mips/kvm/mips.c b/arch/mips/kvm/mips.c
> index 8f05dd0a0f4e..ec24adf4857e 100644
> --- a/arch/mips/kvm/mips.c
> +++ b/arch/mips/kvm/mips.c
> @@ -439,8 +439,9 @@ int kvm_arch_vcpu_ioctl_set_guest_debug(struct kvm_vcpu *vcpu,
>  	return -ENOIOCTLCMD;
>  }
>  
> -int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu, struct kvm_run *run)
> +int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
>  {
> +	struct kvm_run *run = vcpu->run;
>  	int r = -EINTR;
>  
>  	vcpu_load(vcpu);
> diff --git a/arch/powerpc/kvm/powerpc.c b/arch/powerpc/kvm/powerpc.c
> index e15166b0a16d..7e24691e138a 100644
> --- a/arch/powerpc/kvm/powerpc.c
> +++ b/arch/powerpc/kvm/powerpc.c
> @@ -1764,8 +1764,9 @@ int kvm_vcpu_ioctl_set_one_reg(struct kvm_vcpu *vcpu, struct kvm_one_reg *reg)
>  	return r;
>  }
>  
> -int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu, struct kvm_run *run)
> +int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
>  {
> +	struct kvm_run *run = vcpu->run;
>  	int r;
>  
>  	vcpu_load(vcpu);
> diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
> index 19a81024fe16..443af3ead739 100644
> --- a/arch/s390/kvm/kvm-s390.c
> +++ b/arch/s390/kvm/kvm-s390.c
> @@ -4333,8 +4333,9 @@ static void store_regs(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
>  		store_regs_fmt2(vcpu, kvm_run);
>  }
>  
> -int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
> +int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
>  {
> +	struct kvm_run *kvm_run = vcpu->run;
>  	int rc;
>  
>  	if (kvm_run->immediate_exit)
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 3bf2ecafd027..a0338e86c90f 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -8707,8 +8707,9 @@ static void kvm_put_guest_fpu(struct kvm_vcpu *vcpu)
>  	trace_kvm_fpu(0);
>  }
>  
> -int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
> +int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
>  {
> +	struct kvm_run *kvm_run = vcpu->run;
>  	int r;
>  
>  	vcpu_load(vcpu);
> @@ -8726,18 +8727,18 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
>  		r = -EAGAIN;
>  		if (signal_pending(current)) {
>  			r = -EINTR;
> -			vcpu->run->exit_reason = KVM_EXIT_INTR;
> +			kvm_run->exit_reason = KVM_EXIT_INTR;
>  			++vcpu->stat.signal_exits;
>  		}
>  		goto out;
>  	}
>  
> -	if (vcpu->run->kvm_valid_regs & ~KVM_SYNC_X86_VALID_FIELDS) {
> +	if (kvm_run->kvm_valid_regs & ~KVM_SYNC_X86_VALID_FIELDS) {
>  		r = -EINVAL;
>  		goto out;
>  	}
>  
> -	if (vcpu->run->kvm_dirty_regs) {
> +	if (kvm_run->kvm_dirty_regs) {
>  		r = sync_regs(vcpu);
>  		if (r != 0)
>  			goto out;
> @@ -8767,7 +8768,7 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
>  
>  out:
>  	kvm_put_guest_fpu(vcpu);
> -	if (vcpu->run->kvm_valid_regs)
> +	if (kvm_run->kvm_valid_regs)
>  		store_regs(vcpu);
>  	post_kvm_run_save(vcpu);
>  	kvm_sigset_deactivate(vcpu);
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index 6d58beb65454..1e17ef719595 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -866,7 +866,7 @@ int kvm_arch_vcpu_ioctl_set_mpstate(struct kvm_vcpu *vcpu,
>  				    struct kvm_mp_state *mp_state);
>  int kvm_arch_vcpu_ioctl_set_guest_debug(struct kvm_vcpu *vcpu,
>  					struct kvm_guest_debug *dbg);
> -int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run);
> +int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu);
>  
>  int kvm_arch_init(void *opaque);
>  void kvm_arch_exit(void);
> diff --git a/virt/kvm/arm/arm.c b/virt/kvm/arm/arm.c
> index 48d0ec44ad77..f5390ac2165b 100644
> --- a/virt/kvm/arm/arm.c
> +++ b/virt/kvm/arm/arm.c
> @@ -639,7 +639,6 @@ static void check_vcpu_requests(struct kvm_vcpu *vcpu)
>  /**
>   * kvm_arch_vcpu_ioctl_run - the main VCPU run function to execute guest code
>   * @vcpu:	The VCPU pointer
> - * @run:	The kvm_run structure pointer used for userspace state exchange
>   *
>   * This function is called through the VCPU_RUN ioctl called from user space. It
>   * will execute VM code in a loop until the time slice for the process is used
> @@ -647,8 +646,9 @@ static void check_vcpu_requests(struct kvm_vcpu *vcpu)
>   * return with return value 0 and with the kvm_run structure filled in with the
>   * required data for the requested emulation.
>   */
> -int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu, struct kvm_run *run)
> +int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
>  {
> +	struct kvm_run *run = vcpu->run;
>  	int ret;
>  
>  	if (unlikely(!kvm_vcpu_initialized(vcpu)))
> @@ -659,7 +659,7 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu, struct kvm_run *run)
>  		return ret;
>  
>  	if (run->exit_reason == KVM_EXIT_MMIO) {
> -		ret = kvm_handle_mmio_return(vcpu, vcpu->run);
> +		ret = kvm_handle_mmio_return(vcpu, run);
>  		if (ret)
>  			return ret;
>  	}
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 74bdb7bf3295..e18faea89146 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -3135,7 +3135,7 @@ static long kvm_vcpu_ioctl(struct file *filp,
>  				synchronize_rcu();
>  			put_pid(oldpid);
>  		}
> -		r = kvm_arch_vcpu_ioctl_run(vcpu, vcpu->run);
> +		r = kvm_arch_vcpu_ioctl_run(vcpu);
>  		trace_kvm_userspace_exit(vcpu->run->exit_reason, r);
>  		break;
>  	}
> 

Queued, thanks.

Paolo

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
