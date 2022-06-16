Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 321D7C43334
	for <kvmarm@archiver.kernel.org>; Thu, 16 Jun 2022 17:46:59 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9D73540AEA;
	Thu, 16 Jun 2022 13:46:58 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 7fjM5P4T6TlO; Thu, 16 Jun 2022 13:46:57 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9B81B40B75;
	Thu, 16 Jun 2022 13:46:57 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 34C3540B75
 for <kvmarm@lists.cs.columbia.edu>; Thu, 16 Jun 2022 13:46:56 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id TdLq1pNP6+4T for <kvmarm@lists.cs.columbia.edu>;
 Thu, 16 Jun 2022 13:46:54 -0400 (EDT)
Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com
 [209.85.214.175])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id BC62140AEA
 for <kvmarm@lists.cs.columbia.edu>; Thu, 16 Jun 2022 13:46:54 -0400 (EDT)
Received: by mail-pl1-f175.google.com with SMTP id y6so1861636plg.0
 for <kvmarm@lists.cs.columbia.edu>; Thu, 16 Jun 2022 10:46:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=fT8Qe/1se5MIxsDXsCMXOWyhFjF0PUaqi+lyXewdZ9U=;
 b=Z2vqJyIHx4VUaVInZKwpIa4SqqMfsBYINdz0K5crvLskB3jvCQMsftiUhh9qnfoffs
 6o1rcJOJhdAquPI4nGX7clzaZSlvhBUdq1CyE7Au+9ytyzOx88LQ8iYTIvjQE7HXDfmy
 n3dYiQdVZanlP4SwVmlNDrPVhmIPcE3jpjcJx1/2N55A9GPNmoGoMnvCaEbwrAO92UAO
 RuacUOI63j78Ntx83bU6kk7nVUrM3vic021Mqkvho2xvc21iLaKXFYE7Ts9eKwOI6cRl
 vSr36O+75YgPXHxGHGgS0DxO1DUuCFY7ToS3IbZn1GzrOEwb+0yxBlpzq2vMZLJLy2N3
 gzOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=fT8Qe/1se5MIxsDXsCMXOWyhFjF0PUaqi+lyXewdZ9U=;
 b=2v711qQQiqvF5tHLoC9VFia/kUltcXarGBOcZbG6eWQkkTpuqKbwdvo//IcadhVq7k
 V7MEzWNNYV0YKDGqpq2qiNlyX0rp4kosBTEPwy9XN+od97PF+iJPirOvl5lxUP6+9kIE
 aABWvPVBwTkU+BGvhuRcSoRbZL+Z+MVZ9FqxQlkLV36cecB8KCSrM9P8DCm690SrnB4i
 mCGVQm/ZhOtSh6w/DFE+rSkHWqm0TmTJSf4WchGZSi0PS/qcrB3ZXUgtYSouQm0GWyIw
 0sgykSIN8JXazkzFTWAAYF662uW7oNUc4udmQyNpqhvo3q/pWGVQuCAcWwd0p7t+z7Oi
 63Jw==
X-Gm-Message-State: AJIora/5iNiPe/FdkByfu+NrY/+agti1LB6+MlrlumpoZqxIupinH/cf
 xnInis0YaraMnPNBv8ILqLCrZw==
X-Google-Smtp-Source: AGRyM1vJW90dKvuKmbfTG/3yItlYqn9Y3J9LlaKlq2PbhgfpZ3NISFzo2PT2a0SbOGiOYl5Kt5Ifmw==
X-Received: by 2002:a17:902:f687:b0:167:58bb:c43f with SMTP id
 l7-20020a170902f68700b0016758bbc43fmr5456701plg.136.1655401613425; 
 Thu, 16 Jun 2022 10:46:53 -0700 (PDT)
Received: from google.com (123.65.230.35.bc.googleusercontent.com.
 [35.230.65.123]) by smtp.gmail.com with ESMTPSA id
 201-20020a6217d2000000b0050e006279bfsm2177587pfx.137.2022.06.16.10.46.52
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Thu, 16 Jun 2022 10:46:52 -0700 (PDT)
Date: Thu, 16 Jun 2022 17:46:48 +0000
From: Sean Christopherson <seanjc@google.com>
To: Oliver Upton <oupton@google.com>
Subject: Re: [PATCH v2 1/5] KVM: Shove vm stats_id init into kvm_create_vm()
Message-ID: <YqtsiGOOHSxzbdir@google.com>
References: <20220518175811.2758661-1-oupton@google.com>
 <20220518175811.2758661-2-oupton@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20220518175811.2758661-2-oupton@google.com>
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
> Initialize the field alongside the other struct kvm fields. No

Restate "stats_id" instead of "the field", it's literally fewer characters and
having to go read subject/shortlog to grok the change is annoying.  IMO, changelogs
should be 100% coherent without the shortlog.

Explaining why would also be helpful.  AFAICT there's no actual "need" for this
in this series, rather that this is futureproofing KVM since there's no reason
not to fill kvm->stats_id from time zero.

> functional change intended.
> 
> Signed-off-by: Oliver Upton <oupton@google.com>
> ---
>  virt/kvm/kvm_main.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 6d971fb1b08d..36dc9271d039 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -1101,6 +1101,9 @@ static struct kvm *kvm_create_vm(unsigned long type)
>  	 */
>  	kvm->debugfs_dentry = ERR_PTR(-ENOENT);
>  
> +	snprintf(kvm->stats_id, sizeof(kvm->stats_id),
> +			"kvm-%d", task_pid_nr(current));
> +
>  	if (init_srcu_struct(&kvm->srcu))
>  		goto out_err_no_srcu;
>  	if (init_srcu_struct(&kvm->irq_srcu))
> @@ -4787,9 +4790,6 @@ static int kvm_dev_ioctl_create_vm(unsigned long type)
>  	if (r < 0)
>  		goto put_kvm;
>  
> -	snprintf(kvm->stats_id, sizeof(kvm->stats_id),
> -			"kvm-%d", task_pid_nr(current));
> -
>  	file = anon_inode_getfile("kvm-vm", &kvm_vm_fops, kvm, O_RDWR);
>  	if (IS_ERR(file)) {
>  		put_unused_fd(r);
> -- 
> 2.36.1.124.g0e6072fb45-goog
> 
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
