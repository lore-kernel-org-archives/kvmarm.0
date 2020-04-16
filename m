Return-Path: <SRS0=0qdQ=6A=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A7059C2BB55
	for <kvmarm@archiver.kernel.org>; Thu, 16 Apr 2020 11:10:23 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 6022D206E9
	for <kvmarm@archiver.kernel.org>; Thu, 16 Apr 2020 11:10:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="iIX1DYOW"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6022D206E9
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 17F954B259;
	Thu, 16 Apr 2020 07:10:23 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id sVq1qqiVmNTq; Thu, 16 Apr 2020 07:10:21 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5F2A64B261;
	Thu, 16 Apr 2020 07:10:17 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 77A634B226
 for <kvmarm@lists.cs.columbia.edu>; Thu, 16 Apr 2020 03:03:56 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ztKgk+CBCp47 for <kvmarm@lists.cs.columbia.edu>;
 Thu, 16 Apr 2020 03:03:54 -0400 (EDT)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A066C4B0F7
 for <kvmarm@lists.cs.columbia.edu>; Thu, 16 Apr 2020 03:03:54 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1587020634;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=ycA+oaK7HnY0LCry275m8vvLJYLlqC5gRDJoT8fOj6s=;
 b=iIX1DYOWAXPgNxk6aF8CTQV6URQVWwBfXInDhlCMm+a2vtoT13nZArvWQnlv4J+28TY9lx
 TU9ISPw5612D7pPe2D2HSJcw4wc4jjuk4Th2wIXzvMzKItyTbuWnm4bmFzOSHF1PbxIt+J
 4t9U97jEEKUJOP8p75CxM8g2Z+TcfAI=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-53-pFgjUwFbOA2Rmdn5Bh6oXQ-1; Thu, 16 Apr 2020 03:03:52 -0400
X-MC-Unique: pFgjUwFbOA2Rmdn5Bh6oXQ-1
Received: by mail-wr1-f71.google.com with SMTP id j22so1255714wrb.4
 for <kvmarm@lists.cs.columbia.edu>; Thu, 16 Apr 2020 00:03:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
 :message-id:mime-version;
 bh=u8Fe4HRBZIpxRs2mIcqmv3RiTnssjCSY9lhZeXvdF9I=;
 b=jfruO5oCj4wvBeh4BHejC2E3i+DiFboaBgaZ8wKv0hNFNTxbHw44SjBVKNjrsHSB47
 lGCGwcy7utUX/uVTQIcCqcqzM/hzCMtAU8s9DFC+ahGFYrLYeMYzYMtGdNgT7DlBKM30
 wWBt86v2dddN3sV2i/pmNaak2xSeVM+UFjSA5djhHKDp9b5UNkYCkjmcsJjX4HnmM/7R
 GvwYmIeICgTc74QdX3HF/lKBRXs3hOAt0J3bXRxeXblK5WC97go1a2Vkf+ZZBgf4flYa
 lsicGMiWdGMtKIl4bjh9K+W+Oj9mHtqvFsnwURZZBJhfTz+BxeRZO2SkozhyrBs2at6E
 fPvw==
X-Gm-Message-State: AGi0Puba9RteUAr8LqFTDUfblA8UAtTHPIRVkUMuaHTrjZLIbdkJuRIj
 6dCtlJ/bjLKVlVWBkP9cvWugYPjeeRGWgGbvWkehk3FyXXgpVjCrBJcHG96lRJDBgKdUaou2Lmd
 wghJmnj3aJQFTmYzBZfb51cDK
X-Received: by 2002:a5d:4005:: with SMTP id n5mr7830151wrp.242.1587020631114; 
 Thu, 16 Apr 2020 00:03:51 -0700 (PDT)
X-Google-Smtp-Source: APiQypKzVfRYkQQjXNmPRmmEuweWR0AsvTUy66VIOLHRJ9IcCVXdD+fbCSvkQnkvtw8EzDw2iMvttg==
X-Received: by 2002:a5d:4005:: with SMTP id n5mr7830094wrp.242.1587020630785; 
 Thu, 16 Apr 2020 00:03:50 -0700 (PDT)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
 by smtp.gmail.com with ESMTPSA id o16sm26785055wrs.44.2020.04.16.00.03.48
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Thu, 16 Apr 2020 00:03:49 -0700 (PDT)
From: Vitaly Kuznetsov <vkuznets@redhat.com>
To: Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
Subject: Re: [PATCH v2] KVM: Optimize kvm_arch_vcpu_ioctl_run function
In-Reply-To: <20200416051057.26526-1-tianjia.zhang@linux.alibaba.com>
References: <20200416051057.26526-1-tianjia.zhang@linux.alibaba.com>
Date: Thu, 16 Apr 2020 09:03:47 +0200
Message-ID: <878sivx67g.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
X-Mailman-Approved-At: Thu, 16 Apr 2020 07:10:16 -0400
Cc: wanpengli@tencent.com, kvm@vger.kernel.org, david@redhat.com,
 benh@kernel.crashing.org, heiko.carstens@de.ibm.com,
 linux-kernel@vger.kernel.org, paulus@ozlabs.org, hpa@zytor.com,
 kvmarm@lists.cs.columbia.edu, linux-s390@vger.kernel.org,
 frankja@linux.ibm.com, mpe@ellerman.id.au, joro@8bytes.org, x86@kernel.org,
 borntraeger@de.ibm.com, mingo@redhat.com, thuth@redhat.com, gor@linux.ibm.com,
 kvm-ppc@vger.kernel.org, bp@alien8.de, tglx@linutronix.de,
 linux-arm-kernel@lists.infradead.org, jmattson@google.com,
 tsbogend@alpha.franken.de, tianjia.zhang@linux.alibaba.com, cohuck@redhat.com,
 linux-mips@vger.kernel.org, sean.j.christopherson@intel.com, maz@kernel.org,
 pbonzini@redhat.com, linuxppc-dev@lists.ozlabs.org
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

Tianjia Zhang <tianjia.zhang@linux.alibaba.com> writes:

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

I don't know much about ARM but this also seems redundant,
kvm_handle_mmio_return() is also able to extruct 'struct kvm_run' from'
'struct kvm_vcpu'. This likely deserves it's own patch though.

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

Looked at non-x86 arches just briefly but there seems to be no
controversy here, so

Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>

-- 
Vitaly

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
