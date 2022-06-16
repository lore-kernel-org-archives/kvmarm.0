Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5729C433EF
	for <kvmarm@archiver.kernel.org>; Thu, 16 Jun 2022 18:03:33 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5807F4B103;
	Thu, 16 Jun 2022 14:03:33 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id PIX2FAWT1axW; Thu, 16 Jun 2022 14:03:32 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 269BA49EE9;
	Thu, 16 Jun 2022 14:03:32 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 040B743482
 for <kvmarm@lists.cs.columbia.edu>; Thu, 16 Jun 2022 14:03:31 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id K3QZejubyt+X for <kvmarm@lists.cs.columbia.edu>;
 Thu, 16 Jun 2022 14:03:29 -0400 (EDT)
Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com
 [209.85.214.177])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D104443399
 for <kvmarm@lists.cs.columbia.edu>; Thu, 16 Jun 2022 14:03:29 -0400 (EDT)
Received: by mail-pl1-f177.google.com with SMTP id o6so1876159plg.2
 for <kvmarm@lists.cs.columbia.edu>; Thu, 16 Jun 2022 11:03:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=dpwRjZkY0soBd7SZeyYmsUgUNEzUZCI9CCQptugljFw=;
 b=UksF026gnR/KU1E9qCj/FJRMQlvjtO+weLdjQnoyf2sA23bDJn2J9sOnjNEIYgiftN
 xZ69NSdeSMiOLiOrYgPMmD4h0FncrgNYSHPz/kuAD+1wz5wWvkyQYhGLS2nUjDt1Oa8V
 aCcQ2B0b9PebaGTO0F9y3Vfqd7W75tvTNVale7X9R1pdSe3aTsB/fdy+tkYNGoeqtJis
 zsqUzVFxbuTi/EyqqC5aSdi809j8M28blIr8FKh9o7aUQ3aG2+LW9NxoP5YJJsLarTHQ
 ngKCS75UZSdg2P6b3UZx5EB87eWm1RxEuZhF4dDF2ya01I7LtqaYhXuIxHvzEsVEkEzG
 qRTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=dpwRjZkY0soBd7SZeyYmsUgUNEzUZCI9CCQptugljFw=;
 b=VETAFiredEOQCP14sMAbMPx98PG6kFoPuPDFg4MdZoKWteVmXL4QKdIhOv/o+nxSDc
 DPn3wxAw++wVym1BtRvkbEf3k3Vz0Nc7Whc5PyxJ59BZgvIa0SytXm4fMH0+PUdh9al7
 fTVw1sp19B37NfVUPa1iv7+1bDmBBOFoQWUWbto9r+pVs+wnuxK/sqEy9lOcAIVhBRqg
 9elwWBNVjVeyG+rHHmzAuj3IHFMOUfj4gOWEwwdxbJY4YnC21xvont3eg6k1sFnyxuuD
 mqwBmjuUNb7WqfyK421oMdxtdGzuTswdWNBP081WCUlfti8BToMkrM1o3/akyd5AjBzS
 9FXA==
X-Gm-Message-State: AJIora+r/W7v+LkZ1ely1255gNDQ7MskzPWkHz1s3DUtbzbvoJzBiixF
 1DywVBlNTCIzz55esP0azJbeGQ==
X-Google-Smtp-Source: AGRyM1th7y9kU912egDEqaQRM2cWr2EeuEK0IxOfKI6Ig3eg9SH7wwuhIvdQ8nKB8hw7YWtZulQUZQ==
X-Received: by 2002:a17:902:7b8b:b0:168:a7d0:ddf3 with SMTP id
 w11-20020a1709027b8b00b00168a7d0ddf3mr6034931pll.118.1655402608624; 
 Thu, 16 Jun 2022 11:03:28 -0700 (PDT)
Received: from google.com (123.65.230.35.bc.googleusercontent.com.
 [35.230.65.123]) by smtp.gmail.com with ESMTPSA id
 f62-20020a623841000000b0050dc762814asm2070595pfa.36.2022.06.16.11.03.27
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Thu, 16 Jun 2022 11:03:27 -0700 (PDT)
Date: Thu, 16 Jun 2022 18:03:23 +0000
From: Sean Christopherson <seanjc@google.com>
To: Oliver Upton <oupton@google.com>
Subject: Re: [PATCH v2 4/5] KVM: Actually create debugfs in kvm_create_vm()
Message-ID: <Yqtwa03IWVNP4LLA@google.com>
References: <20220518175811.2758661-1-oupton@google.com>
 <20220518175811.2758661-5-oupton@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20220518175811.2758661-5-oupton@google.com>
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
> Doing debugfs creation after vm creation leaves things in a
> quasi-initialized state for a while. This is further complicated by the
> fact that we tear down debugfs from kvm_destroy_vm(). Align debugfs and
> stats init/destroy with the vm init/destroy pattern to avoid any
> headaches. Pass around the fd number as a string, as poking at the fd in
> any other way is nonsensical.

"any other way before it is installed", otherwise it sounds like the fd is this
magic black box that KVM can't touch.

And the changes to pass @fdname instead of @fd should be a separate patch, both to
reduce churn and because it's not a risk free change, e.g. if this is the improper
size then bisection should point at the fdname patch, not at this combined patch.

	char fdname[ITOA_MAX_LEN + 1];

> Note the fix for a benign mistake in error handling for calls to
> kvm_arch_create_vm_debugfs() rolled in. Since all implementations of
> the function return 0 unconditionally it isn't actually a bug at
> the moment.
> 
> Lastly, tear down debugfs/stats data in the kvm_create_vm_debugfs()
> error path. Previously it was safe to assume that kvm_destroy_vm() would
> take out the garbage, that is no longer the case.
> 
> Signed-off-by: Oliver Upton <oupton@google.com>
> ---

...

> @@ -4774,6 +4781,7 @@ EXPORT_SYMBOL_GPL(file_is_kvm);
>  
>  static int kvm_dev_ioctl_create_vm(unsigned long type)
>  {
> +	char fdname[ITOA_MAX_LEN + 1];
>  	int r, fd;
>  	struct kvm *kvm;
>  	struct file *file;
> @@ -4782,7 +4790,8 @@ static int kvm_dev_ioctl_create_vm(unsigned long type)
>  	if (fd < 0)
>  		return fd;
>  
> -	kvm = kvm_create_vm(type);
> +	snprintf(fdname, sizeof(fdname), "%d", fd);

Nit, I'd prefer a blank line here so that it's easier to see the call to
kvm_create_vm().

> +	kvm = kvm_create_vm(type, fdname);
>  	if (IS_ERR(kvm)) {
>  		r = PTR_ERR(kvm);
>  		goto put_fd;
> @@ -4799,17 +4808,6 @@ static int kvm_dev_ioctl_create_vm(unsigned long type)
>  		goto put_kvm;
>  	}
>  
> -	/*
> -	 * Don't call kvm_put_kvm anymore at this point; file->f_op is
> -	 * already set, with ->release() being kvm_vm_release().  In error
> -	 * cases it will be called by the final fput(file) and will take
> -	 * care of doing kvm_put_kvm(kvm).
> -	 */

I think we should keep the comment to warn future developers.  I'm tempted to say
it could be reworded to say something like "if you're adding a call that can fail
at this point, you're doing it wrong".  But for this patch, I'd say just leave the
comment intact.

> -	if (kvm_create_vm_debugfs(kvm, r) < 0) {
> -		fput(file);
> -		r = -ENOMEM;
> -		goto put_fd;
> -	}
>  	kvm_uevent_notify_change(KVM_EVENT_CREATE_VM, kvm);
>  
>  	fd_install(fd, file);
> -- 
> 2.36.1.124.g0e6072fb45-goog
> 
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
