Return-Path: <SRS0=7dZW=56=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3AEFFC2BA19
	for <kvmarm@archiver.kernel.org>; Tue, 14 Apr 2020 14:32:21 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id C3C2820787
	for <kvmarm@archiver.kernel.org>; Tue, 14 Apr 2020 14:32:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="g32HVsh7"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C3C2820787
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3FF314B206;
	Tue, 14 Apr 2020 10:32:20 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id w5q-hd9RGpFR; Tue, 14 Apr 2020 10:32:19 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 05F2F4B1F6;
	Tue, 14 Apr 2020 10:32:19 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 88C144B1C3
 for <kvmarm@lists.cs.columbia.edu>; Tue, 14 Apr 2020 10:26:10 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id CkKNNOq-aJ8q for <kvmarm@lists.cs.columbia.edu>;
 Tue, 14 Apr 2020 10:26:09 -0400 (EDT)
Received: from us-smtp-delivery-1.mimecast.com (us-smtp-2.mimecast.com
 [207.211.31.81])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9E7014B12C
 for <kvmarm@lists.cs.columbia.edu>; Tue, 14 Apr 2020 10:26:09 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1586874369;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=nQ2s1P43pMD0iJunnsFh4bxmcRIUFZr+i4fF45MPy9Q=;
 b=g32HVsh7f1jr6gP4jzSly6UWmDJ8TFJrzPemV1PAOvdjmiHOS2A7nXvqcXvnd5t8QNEdVL
 0vFFUEQciOXdGSShIjcxU1NTQ//wCHhoudjvOXc+Xi0mYLREQokErmWVfG/boapLxqLBnK
 TG0I/8n12/LZT6wBKT7Qp5wE2/NBVpM=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-219-Gmay7Yk2PVKlz3iMldr4aQ-1; Tue, 14 Apr 2020 10:26:05 -0400
X-MC-Unique: Gmay7Yk2PVKlz3iMldr4aQ-1
Received: by mail-wr1-f72.google.com with SMTP id s11so3905212wru.6
 for <kvmarm@lists.cs.columbia.edu>; Tue, 14 Apr 2020 07:26:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
 :message-id:mime-version;
 bh=uSEGx3gNn1oGf/i6GkkhJSWUv9DBqbvzJo4hv43gN+I=;
 b=GZlHhmLkqXOfSByMWTTcHjkbxsn9Jlzatts1MnEjaxdieP+4P+ncLB3jcvnL6DcjCF
 qJi9eNRQFRSfVPOZwY9KWdyMqZmr6kYcDKg3o+g1ECVjQubeMWi9hrej3VAybc7yMGRF
 MsKzUcll6vj1Jtb8QWBdmsFmQxFa9JiPv9BL3xsVz7z3OZTyJkDaV2mKRwD75W5J0mdM
 ftua4EwrqIciYFD+9HFa2KcJeJ7A5oLFd64mpiTWhYYbVbd8HT+yDOaj0DxHtX//d18w
 9cuBtPfkoH2SRqY3INcdB0xG5GkMk6LMCI2cusxLnWcyCHP4eUDWyLHy/KfWVup021Op
 PBrw==
X-Gm-Message-State: AGi0PubpHYIMmJPmkGu6E6DjOhlMiLprNTx1KabzFzFB+qJcr43O7ES4
 AdbvLJ7ar4imxj82bdeH4ikJ9a/RDOptcXdYTTep5XIzkP1I+zyHCiERGOkrR+7HVDADUtzmI9J
 1W0ZCRjRgeL+kiTUXRkQwVcl8
X-Received: by 2002:a1c:4409:: with SMTP id r9mr102737wma.165.1586874363919;
 Tue, 14 Apr 2020 07:26:03 -0700 (PDT)
X-Google-Smtp-Source: APiQypJqgbBq9xhT1LszvRzgjgWUmQyELrXGBlfZ5uFizKdfdTJlTiXTCHR6m1nvQHHbl9Aa0nzYPg==
X-Received: by 2002:a1c:4409:: with SMTP id r9mr102702wma.165.1586874363651;
 Tue, 14 Apr 2020 07:26:03 -0700 (PDT)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
 by smtp.gmail.com with ESMTPSA id v10sm7145993wrq.45.2020.04.14.07.26.02
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Tue, 14 Apr 2020 07:26:03 -0700 (PDT)
From: Vitaly Kuznetsov <vkuznets@redhat.com>
To: Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
Subject: Re: [PATCH] KVM: Optimize kvm_arch_vcpu_ioctl_run function
In-Reply-To: <20200413034523.110548-1-tianjia.zhang@linux.alibaba.com>
References: <20200413034523.110548-1-tianjia.zhang@linux.alibaba.com>
Date: Tue, 14 Apr 2020 16:26:01 +0200
Message-ID: <875ze2ywhy.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
X-Mailman-Approved-At: Tue, 14 Apr 2020 10:32:17 -0400
Cc: wanpengli@tencent.com, kvm@vger.kernel.org, tianjia.zhang@linux.alibaba.com,
 maz@kernel.org, joro@8bytes.org, x86@kernel.org, linux-kernel@vger.kernel.org,
 sean.j.christopherson@intel.com, mingo@redhat.com, bp@alien8.de, hpa@zytor.com,
 pbonzini@redhat.com, tglx@linutronix.de, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org, jmattson@google.com
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

> kvm_arch_vcpu_ioctl_run() is only called in the file kvm_main.c,
> where vcpu->run is the kvm_run parameter, so it has been replaced.
>
> Signed-off-by: Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
> ---
>  arch/x86/kvm/x86.c | 8 ++++----
>  virt/kvm/arm/arm.c | 2 +-
>  2 files changed, 5 insertions(+), 5 deletions(-)
>
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 3bf2ecafd027..70e3f4abbd4d 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -8726,18 +8726,18 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
>  		r = -EAGAIN;
>  		if (signal_pending(current)) {
>  			r = -EINTR;
> -			vcpu->run->exit_reason = KVM_EXIT_INTR;
> +			kvm_run->exit_reason = KVM_EXIT_INTR;

I have a more generic question: why do we need to pass 'kvm_run' to
kvm_arch_vcpu_ioctl_run() if it can be extracted from 'struct kvm_vcpu'?
The only call site looks like

virt/kvm/kvm_main.c:            r = kvm_arch_vcpu_ioctl_run(vcpu, vcpu->run);

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
> @@ -8767,7 +8767,7 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
>  
>  out:
>  	kvm_put_guest_fpu(vcpu);
> -	if (vcpu->run->kvm_valid_regs)
> +	if (kvm_run->kvm_valid_regs)
>  		store_regs(vcpu);
>  	post_kvm_run_save(vcpu);
>  	kvm_sigset_deactivate(vcpu);
> diff --git a/virt/kvm/arm/arm.c b/virt/kvm/arm/arm.c
> index 48d0ec44ad77..ab9d7966a4c8 100644
> --- a/virt/kvm/arm/arm.c
> +++ b/virt/kvm/arm/arm.c
> @@ -659,7 +659,7 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu, struct kvm_run *run)
>  		return ret;
>  
>  	if (run->exit_reason == KVM_EXIT_MMIO) {
> -		ret = kvm_handle_mmio_return(vcpu, vcpu->run);
> +		ret = kvm_handle_mmio_return(vcpu, run);
>  		if (ret)
>  			return ret;
>  	}

-- 
Vitaly

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
