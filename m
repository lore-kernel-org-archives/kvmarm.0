Return-Path: <SRS0=UAPk=OT=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B9F3DC433F5
	for <kvmarm@archiver.kernel.org>; Wed, 29 Sep 2021 07:12:49 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 603C36137E
	for <kvmarm@archiver.kernel.org>; Wed, 29 Sep 2021 07:12:49 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 603C36137E
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0B7614B0E6;
	Wed, 29 Sep 2021 03:12:49 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id edqaYqaRlFpU; Wed, 29 Sep 2021 03:12:47 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D5EC74B15B;
	Wed, 29 Sep 2021 03:12:41 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3B1884048A
 for <kvmarm@lists.cs.columbia.edu>; Tue, 28 Sep 2021 18:04:54 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id GKXMx5dC+Me7 for <kvmarm@lists.cs.columbia.edu>;
 Tue, 28 Sep 2021 18:04:53 -0400 (EDT)
Received: from mail-pj1-f50.google.com (mail-pj1-f50.google.com
 [209.85.216.50])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 2001740191
 for <kvmarm@lists.cs.columbia.edu>; Tue, 28 Sep 2021 18:04:53 -0400 (EDT)
Received: by mail-pj1-f50.google.com with SMTP id
 il14-20020a17090b164e00b0019c7a7c362dso2727953pjb.0
 for <kvmarm@lists.cs.columbia.edu>; Tue, 28 Sep 2021 15:04:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=s8TgaTkuAOfttq5Ji23XuWmZEPg/t1pbW45rjrv+GjY=;
 b=LOKBGSSThTGJmZr52wMlTVIXy7gN0kcixsV7n11azJM+wFcpy4hdoZIRhH6FjCUukF
 R3ek08fGm45mGkuiA0+Kxm49I86GkQOabdwCzh/L7J8ZtTUESfVtBd1ViQEJJ5vZmB0j
 gVM3+sKMqY01a6pRSxMH/JV7N2k8jZaoTStvXT/CW+6ekMegbYoSEeVNZm/knJC1H2Iz
 JpHolIs35AjaAocSgJu4Q8l0875P6gOMqZFX8yYi8BLrJDNQk0tBeB5SUgTVoQJk7Bxc
 TaQ1FhIIJDiukqtBzIRTPyLdyC5LfChFTqz2xnOAHZ/G/Ty6/PTiLDypDINxMIzqkG+p
 MNEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=s8TgaTkuAOfttq5Ji23XuWmZEPg/t1pbW45rjrv+GjY=;
 b=umTTzRRBfUeZ3eIW6Ql7y4VFvL227kwCCt2D/GrnrZiFsM/vrvfGlZEAKwxBKwwKTW
 Oj03//HPKapYsews8QWYvu5yGRoey6xVTh6bJLguzCZ2y1Ei4VWqylhqJmvMvAvr0NNn
 oV3gleqiOYE+IYyTdXbaTyDY1aMBqh/wmHu24Z0RUYP+nFiqUSMiaJYJLm7DM0XWcNFP
 njOiB+Iq0r3pmCO2YYHcNCf/X2OSIub4l5519Zq3fJoqa8yspJrYMXjsXs1mOcY589Ja
 Iw7fEIg2XCCDMzqLzDGKqH1y66rHCS8Mvjkf8X627BV8+AZBF4lrIpmKKJZXYGAf4xwI
 f3YQ==
X-Gm-Message-State: AOAM531n9V3B01YJ5BMuc1CibaXWrMk2XeUPOLPqjVmVf0Wys9s7Emik
 XWPAlse16xOwP5S2mVaIAYFCvg==
X-Google-Smtp-Source: ABdhPJyZYZhKpQUljc7RVXwKUERY34mYmQfs2NuJ723fR6n2a6r5wthdOfaTSfpkU7ajTH5d6X1x0g==
X-Received: by 2002:a17:90a:c982:: with SMTP id
 w2mr2466336pjt.30.1632866692006; 
 Tue, 28 Sep 2021 15:04:52 -0700 (PDT)
Received: from google.com (254.80.82.34.bc.googleusercontent.com.
 [34.82.80.254])
 by smtp.gmail.com with ESMTPSA id v26sm124276pfm.175.2021.09.28.15.04.51
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Tue, 28 Sep 2021 15:04:51 -0700 (PDT)
Date: Tue, 28 Sep 2021 22:04:47 +0000
From: David Matlack <dmatlack@google.com>
To: Sean Christopherson <seanjc@google.com>
Subject: Re: [PATCH 11/14] KVM: stats: Add stat to detect if vcpu is
 currently blocking
Message-ID: <YVORf599tkw3MdGZ@google.com>
References: <20210925005528.1145584-1-seanjc@google.com>
 <20210925005528.1145584-12-seanjc@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20210925005528.1145584-12-seanjc@google.com>
X-Mailman-Approved-At: Wed, 29 Sep 2021 03:12:40 -0400
Cc: Wanpeng Li <wanpengli@tencent.com>, kvm@vger.kernel.org,
 David Hildenbrand <david@redhat.com>, linux-kernel@vger.kernel.org,
 Paul Mackerras <paulus@ozlabs.org>, Claudio Imbrenda <imbrenda@linux.ibm.com>,
 kvmarm@lists.cs.columbia.edu, Janosch Frank <frankja@linux.ibm.com>,
 Marc Zyngier <maz@kernel.org>, Joerg Roedel <joro@8bytes.org>,
 Huacai Chen <chenhuacai@kernel.org>,
 Christian Borntraeger <borntraeger@de.ibm.com>,
 Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>, kvm-ppc@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, Jim Mattson <jmattson@google.com>,
 Cornelia Huck <cohuck@redhat.com>, linux-mips@vger.kernel.org,
 Paolo Bonzini <pbonzini@redhat.com>, Vitaly Kuznetsov <vkuznets@redhat.com>
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

On Fri, Sep 24, 2021 at 05:55:25PM -0700, Sean Christopherson wrote:
> From: Jing Zhang <jingzhangos@google.com>
> 
> Add a "blocking" stat that userspace can use to detect the case where a
> vCPU is not being run because of a vCPU/guest action, e.g. HLT or WFS on
> x86, WFI on arm64, etc...  Current guest/host/halt stats don't show this
> well, e.g. if a guest halts for a long period of time then the vCPU could
> appear pathologically blocked due to a host condition, when in reality the
> vCPU has been put into a not-runnable state by the guest.
> 
> Originally-by: Cannon Matthews <cannonmatthews@google.com>
> Suggested-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Jing Zhang <jingzhangos@google.com>
> [sean: renamed stat to "blocking", massaged changelog]
> Signed-off-by: Sean Christopherson <seanjc@google.com>

Reviewed-by: David Matlack <dmatlack@google.com>
> ---
>  include/linux/kvm_host.h  | 3 ++-
>  include/linux/kvm_types.h | 1 +
>  virt/kvm/kvm_main.c       | 2 ++
>  3 files changed, 5 insertions(+), 1 deletion(-)
> 
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index 655c2b24db2d..9bb1972e396a 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -1453,7 +1453,8 @@ struct _kvm_stats_desc {
>  	STATS_DESC_LOGHIST_TIME_NSEC(VCPU_GENERIC, halt_poll_fail_hist,	       \
>  			HALT_POLL_HIST_COUNT),				       \
>  	STATS_DESC_LOGHIST_TIME_NSEC(VCPU_GENERIC, halt_wait_hist,	       \
> -			HALT_POLL_HIST_COUNT)
> +			HALT_POLL_HIST_COUNT),				       \
> +	STATS_DESC_ICOUNTER(VCPU_GENERIC, blocking)
>  
>  extern struct dentry *kvm_debugfs_dir;
>  
> diff --git a/include/linux/kvm_types.h b/include/linux/kvm_types.h
> index 2237abb93ccd..c4f9257bf32d 100644
> --- a/include/linux/kvm_types.h
> +++ b/include/linux/kvm_types.h
> @@ -94,6 +94,7 @@ struct kvm_vcpu_stat_generic {
>  	u64 halt_poll_success_hist[HALT_POLL_HIST_COUNT];
>  	u64 halt_poll_fail_hist[HALT_POLL_HIST_COUNT];
>  	u64 halt_wait_hist[HALT_POLL_HIST_COUNT];
> +	u64 blocking;
>  };
>  
>  #define KVM_STATS_NAME_SIZE	48
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index fe34457530c2..2980d2b88559 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -3208,6 +3208,7 @@ bool kvm_vcpu_block(struct kvm_vcpu *vcpu)
>  {
>  	bool waited = false;
>  
> +	vcpu->stat.generic.blocking = 1;
>  	kvm_arch_vcpu_blocking(vcpu);
>  
>  	prepare_to_rcuwait(&vcpu->wait);
> @@ -3223,6 +3224,7 @@ bool kvm_vcpu_block(struct kvm_vcpu *vcpu)
>  	finish_rcuwait(&vcpu->wait);
>  
>  	kvm_arch_vcpu_unblocking(vcpu);
> +	vcpu->stat.generic.blocking = 0;
>  
>  	return waited;
>  }
> -- 
> 2.33.0.685.g46640cef36-goog
> 
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
