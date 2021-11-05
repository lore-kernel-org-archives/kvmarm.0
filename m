Return-Path: <SRS0=hs0s=PY=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 00007C433F5
	for <kvmarm@archiver.kernel.org>; Fri,  5 Nov 2021 20:21:46 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 69873611C4
	for <kvmarm@archiver.kernel.org>; Fri,  5 Nov 2021 20:21:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 69873611C4
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id AF2094B16E;
	Fri,  5 Nov 2021 16:21:45 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Uc15bRLbyPdR; Fri,  5 Nov 2021 16:21:44 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 140554B164;
	Fri,  5 Nov 2021 16:21:44 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id AF9B74B10C
 for <kvmarm@lists.cs.columbia.edu>; Fri,  5 Nov 2021 16:21:42 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id NMannwojpHc0 for <kvmarm@lists.cs.columbia.edu>;
 Fri,  5 Nov 2021 16:21:41 -0400 (EDT)
Received: from mail-pf1-f180.google.com (mail-pf1-f180.google.com
 [209.85.210.180])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 73FE04A3BF
 for <kvmarm@lists.cs.columbia.edu>; Fri,  5 Nov 2021 16:21:41 -0400 (EDT)
Received: by mail-pf1-f180.google.com with SMTP id x131so4666036pfc.12
 for <kvmarm@lists.cs.columbia.edu>; Fri, 05 Nov 2021 13:21:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=FChUXutBpeRG92vMItY2zirb2KiX64mqNa6lRjXS4/o=;
 b=XhJq67XOVehGKyOlop0ZgXHOTZHwcQNzObFkCi6/KagxRodpEZ8yllo88wcXd9u5A4
 JyHn3eOSHm71QE0Ho4vu+PMzSC+hk/kpLn0XoWAl+sEDJCXJH8yRiSGn+WDU3uzo/0Jz
 vKuoP+xD9+dM6PIdOwrxBIcZiSTMvIRnKJ1ZTnCiCFNuTdGdR0au4APz76smsdf0FTJU
 MNMzCzzdiPQ0CIWIuM2KFOvXL49l2ImI8P3640AzVXeG075F7RRRDlC4KR+jmtTfyE56
 DSWnC2bV/xJ5K5cAgxAaKeJQrMHJdJxDe+n/OzOHw9DBQw6HJa62AhCnvmDdn0hwLrnK
 Xi4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=FChUXutBpeRG92vMItY2zirb2KiX64mqNa6lRjXS4/o=;
 b=grq7pMkSZhfZubUgYbcBghaxtXIu8VaV4B7YZ4AoF+4dtXpuOQvLCgVUN0bivm/v7R
 qe4RpNoKTdBPKmJ4p96P6DYyz+Wh25hPs6mtPvm9un9cXDN5/EDMuOZRg1kMOB6pQp3y
 yF70riaJxJYfs0PK3X/nSo6fnLyOr+W/8cnmrWmR97hc9RXhHGrrN/KiNHuPGH7X7ijJ
 MVuzEKZm/+HJwtF04CSGuP0KELYN2E2fvzWN/w+hIvFwG9W+S9rLeU3JRCoukoF7JMPO
 oZDUuSrVxjmo7i2rNrgDFNgXEeBi8hJt4L6K1gLZX0DpiMqQ4voOTFN6mhJC1Mjw1Ff4
 m54A==
X-Gm-Message-State: AOAM531jaaAG2TqYKQ+AhjZO9QbYPHx8CwHmojIrB7T91hP/HQRVO2sx
 S6rconvq4vy6MiEfg51cAScQQg==
X-Google-Smtp-Source: ABdhPJwJsyZkhGzgEWjIobCpYAvoWgic/EqtGUxZtysje8E+26IpZ1/HH08l9V0rneyI5sI9Ep2Vgg==
X-Received: by 2002:a05:6a00:c8f:b0:481:20a8:7c61 with SMTP id
 a15-20020a056a000c8f00b0048120a87c61mr32575696pfv.8.1636143700318; 
 Fri, 05 Nov 2021 13:21:40 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com.
 [35.185.214.157])
 by smtp.gmail.com with ESMTPSA id c12sm5054054pfm.50.2021.11.05.13.21.39
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Fri, 05 Nov 2021 13:21:39 -0700 (PDT)
Date: Fri, 5 Nov 2021 20:21:36 +0000
From: Sean Christopherson <seanjc@google.com>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH 5/5] KVM: Convert the kvm->vcpus array to a xarray
Message-ID: <YYWSUJ1qzhfqjQow@google.com>
References: <20211105192101.3862492-1-maz@kernel.org>
 <20211105192101.3862492-6-maz@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20211105192101.3862492-6-maz@kernel.org>
Cc: Juergen Gross <jgross@suse.com>, Anup Patel <anup.patel@wdc.com>,
 Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org,
 Christian Borntraeger <borntraeger@de.ibm.com>,
 Michael Ellerman <mpe@ellerman.id.au>, Huacai Chen <chenhuacai@kernel.org>,
 David Hildenbrand <david@redhat.com>, linux-mips@vger.kernel.org,
 Nicholas Piggin <npiggin@gmail.com>, Atish Patra <atish.patra@wdc.com>,
 Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
 Paul Mackerras <paulus@samba.org>, Paolo Bonzini <pbonzini@redhat.com>,
 kernel-team@android.com, Claudio Imbrenda <imbrenda@linux.ibm.com>,
 linuxppc-dev@lists.ozlabs.org, kvmarm@lists.cs.columbia.edu
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

On Fri, Nov 05, 2021, Marc Zyngier wrote:
> At least on arm64 and x86, the vcpus array is pretty huge (512 entries),
> and is mostly empty in most cases (running 512 vcpu VMs is not that
> common). This mean that we end-up with a 4kB block of unused memory
> in the middle of the kvm structure.

Heh, x86 is now up to 1024 entries.
 
> Instead of wasting away this memory, let's use an xarray instead,
> which gives us almost the same flexibility as a normal array, but
> with a reduced memory usage with smaller VMs.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
> @@ -693,7 +694,7 @@ static inline struct kvm_vcpu *kvm_get_vcpu(struct kvm *kvm, int i)
>  
>  	/* Pairs with smp_wmb() in kvm_vm_ioctl_create_vcpu.  */
>  	smp_rmb();
> -	return kvm->vcpus[i];
> +	return xa_load(&kvm->vcpu_array, i);
>  }

It'd be nice for this series to convert kvm_for_each_vcpu() to use xa_for_each()
as well.  Maybe as a patch on top so that potential explosions from that are
isolated from the initiali conversion?

Or maybe even use xa_for_each_range() to cap at online_vcpus?  That's technically
a functional change, but IMO it's easier to reason about iterating over a snapshot
of vCPUs as opposed to being able to iterate over vCPUs as their being added.  In
practice I doubt it matters.

#define kvm_for_each_vcpu(idx, vcpup, kvm) \
	xa_for_each_range(&kvm->vcpu_array, idx, vcpup, 0, atomic_read(&kvm->online_vcpus))
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
