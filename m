Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 76DB7C43334
	for <kvmarm@archiver.kernel.org>; Thu, 16 Jun 2022 17:47:35 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DBD444B0CE;
	Thu, 16 Jun 2022 13:47:34 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id LGN9pGg81U4l; Thu, 16 Jun 2022 13:47:33 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CD20240B75;
	Thu, 16 Jun 2022 13:47:33 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 63DA540B75
 for <kvmarm@lists.cs.columbia.edu>; Thu, 16 Jun 2022 13:47:32 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id cKJvYjYVn5x1 for <kvmarm@lists.cs.columbia.edu>;
 Thu, 16 Jun 2022 13:47:31 -0400 (EDT)
Received: from mail-pg1-f173.google.com (mail-pg1-f173.google.com
 [209.85.215.173])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id EF1A240AEA
 for <kvmarm@lists.cs.columbia.edu>; Thu, 16 Jun 2022 13:47:30 -0400 (EDT)
Received: by mail-pg1-f173.google.com with SMTP id d129so1875380pgc.9
 for <kvmarm@lists.cs.columbia.edu>; Thu, 16 Jun 2022 10:47:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=s+xYDL6GokyuWIDSk9dqiyAkvL0R7+pughdFGhd5kfw=;
 b=hsITBdVcsSHfWzgOAcnc904OYzCtPLLSewhfgSaPiUJIKqt1eJV7UDmuoS+c22Hx8I
 uh0ThDM+Sndm88Tfs6T6FSrs7JqS6Wt6b1kKFr2/XoxjhLvekqCxnxd3qml+dnj7s+45
 v/ajUVMAL0qAFKIjhy2uALKG6EhzdsYSJu3ZhZMwem9CDr9L+T1vrqfE6TepcyMCShUg
 gwIXQ26Nsjgimv8plaCSyi9P0pAr/ngh0DclG9xz5ygKeLSIMzX92fTS1fdI1PrdtV4m
 taJzL7Jg8onoYrzCNryPvo72nd5lng7flKXyJ+ccCgYXSu3otZWpjS2Sx8JEyEtTbf9M
 n5Vw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=s+xYDL6GokyuWIDSk9dqiyAkvL0R7+pughdFGhd5kfw=;
 b=V/uJRVKfUlEbW4oOPnjQenE8HNicF3xbvyzjVAifMjtEulNq1vtpzpeYUPwloIzK8+
 mPVWXV3d1rp9z84LfDESlnRCKcVHiUwfuDGOQBWDaORRxSfNAvupiu9+qXGgyyq/jcds
 GZLJkEYscs+uQ3A2bpRi58y+bwB9zj6OcRIm+9+UtuexiQl/OmEXRwvnnNBDMONzLeej
 5TR0r4FdmJbYAveMwERIsvaC8CJfxaudFbxOxZSAw4zknG5C/czJXNcPQ6DtCsALRhCv
 q3mOFFS3RUHUhKdXpMW28lDKKDWvaLzHcGXjd/H0viDOt5RN8sAx7F1fABAZWEB8x1Pf
 2R9g==
X-Gm-Message-State: AJIora/QKkuCqZRGFto2kpQhpWQeZXhfo4pMR7XOd4UaaPkGPbVK/LZb
 Zn/iPwlybYzC1YMROhsr59oewQ==
X-Google-Smtp-Source: AGRyM1vs+GWhZhlvLQNX2HqgrFSA3tHA61UwQFSziB3v6SMT5fk1VQVq35AuocxZNgQK543DVPcy6A==
X-Received: by 2002:a63:3184:0:b0:3fc:5893:c866 with SMTP id
 x126-20020a633184000000b003fc5893c866mr5510725pgx.56.1655401649776; 
 Thu, 16 Jun 2022 10:47:29 -0700 (PDT)
Received: from google.com (123.65.230.35.bc.googleusercontent.com.
 [35.230.65.123]) by smtp.gmail.com with ESMTPSA id
 q4-20020a170902f78400b001641670d1adsm1944287pln.131.2022.06.16.10.47.28
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Thu, 16 Jun 2022 10:47:28 -0700 (PDT)
Date: Thu, 16 Jun 2022 17:47:24 +0000
From: Sean Christopherson <seanjc@google.com>
To: Oliver Upton <oupton@google.com>
Subject: Re: [PATCH v2 2/5] KVM: Shove vcpu stats_id init into kvm_vcpu_init()
Message-ID: <YqtsrEMf2poEmBcq@google.com>
References: <20220518175811.2758661-1-oupton@google.com>
 <20220518175811.2758661-3-oupton@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20220518175811.2758661-3-oupton@google.com>
Cc: pbonzini@redhat.com, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
 maz@kernel.org
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

On Wed, May 18, 2022, Oliver Upton wrote:
> Initialize the field alongside other kvm_vcpu fields. No functional
> change intended.

Same complaints as the previous changelog.

> Signed-off-by: Oliver Upton <oupton@google.com>
> ---
>  virt/kvm/kvm_main.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 36dc9271d039..778151333ac0 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -440,6 +440,10 @@ static void kvm_vcpu_init(struct kvm_vcpu *vcpu, struct kvm *kvm, unsigned id)
>  	vcpu->ready = false;
>  	preempt_notifier_init(&vcpu->preempt_notifier, &kvm_preempt_ops);
>  	vcpu->last_used_slot = NULL;
> +
> +	/* Fill the stats id string for the vcpu */
> +	snprintf(vcpu->stats_id, sizeof(vcpu->stats_id), "kvm-%d/vcpu-%d",
> +		 task_pid_nr(current), id);
>  }
>  
>  static void kvm_vcpu_destroy(struct kvm_vcpu *vcpu)
> @@ -3807,10 +3811,6 @@ static int kvm_vm_ioctl_create_vcpu(struct kvm *kvm, u32 id)
>  	if (r)
>  		goto unlock_vcpu_destroy;
>  
> -	/* Fill the stats id string for the vcpu */
> -	snprintf(vcpu->stats_id, sizeof(vcpu->stats_id), "kvm-%d/vcpu-%d",
> -		 task_pid_nr(current), id);
> -
>  	/* Now it's all set up, let userspace reach it */
>  	kvm_get_kvm(kvm);
>  	r = create_vcpu_fd(vcpu);
> -- 
> 2.36.1.124.g0e6072fb45-goog
> 
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
