Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D9C1C433EF
	for <kvmarm@archiver.kernel.org>; Mon,  4 Apr 2022 17:33:39 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E713B4B2AB;
	Mon,  4 Apr 2022 13:33:38 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id o+lRIBJDdsjA; Mon,  4 Apr 2022 13:33:37 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B462D4B23F;
	Mon,  4 Apr 2022 13:33:37 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8635A49F4C
 for <kvmarm@lists.cs.columbia.edu>; Mon,  4 Apr 2022 13:33:36 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 1Lq9DIgBcNJZ for <kvmarm@lists.cs.columbia.edu>;
 Mon,  4 Apr 2022 13:33:35 -0400 (EDT)
Received: from mail-pj1-f42.google.com (mail-pj1-f42.google.com
 [209.85.216.42])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 5B3E449F29
 for <kvmarm@lists.cs.columbia.edu>; Mon,  4 Apr 2022 13:33:35 -0400 (EDT)
Received: by mail-pj1-f42.google.com with SMTP id
 j20-20020a17090ae61400b001ca9553d073so3649905pjy.5
 for <kvmarm@lists.cs.columbia.edu>; Mon, 04 Apr 2022 10:33:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=3eEb1Fbi03Tqfrd9+V/qD2RzIsPJ4iRE2QaaWt7eods=;
 b=l/xcKvP+X/QNDFo8xztJ73QES2Bgc0urPyjP8JRiWoVOq7xTRLys6nwW8ykl/7cTKd
 QoKEoYcj9dyoHPKku12UZfF5UyXIUp+ZVpz+cxWV9sWRVB1ae0+hkVGKeUFMsK9jUu2F
 lwCfZWPoxX8GfuuLJ8ecimBfibmEtZxJq1kwvqzoaWxoEQbrgOeTLOZgV6c3wRJEEeQx
 rCtwRHS1vfYQZwpsM3vnxgWTVgBZ66YUQIfmChct9n8ArkKRUgBO2Rt49Uxq2WUSblwM
 WQUlsfWFVlj/hPdKjyWf1QFXQntETu4xbL4dJOTqNP0N7lFCJZOAfmvDeVZEy4+yfyoX
 HXUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=3eEb1Fbi03Tqfrd9+V/qD2RzIsPJ4iRE2QaaWt7eods=;
 b=2+8jTxdsC0m9cNypmXFhVyfFU/bOGSMTroDcfPr4azCQKYFG8qhw/aEIb5ZoTfWKCM
 yBtCjSSwNa57xuypUbXKpcKbXbBwGf5jvd2/mxlCwtO9/B8dTDH5ixlqW5osf39QBJtG
 upTho5NrwlGe1vIc/hdjv0XMBYLbZfpb0dM+BbMjYdiiRtzUBfVcdA+arE8W9glDK1s2
 fvwaiFGs6Q2sGCO7BJn3CBH+Rn5bhB788SuPLff6T8haHLGIqa92W8zQFRiibpl9csRP
 DHPb0q3h5lSSexXWRzWFRqGx9h+Le30ncQs8iRzib5Ev5neFr6DTB6V1VM1il23HnCOS
 mJNw==
X-Gm-Message-State: AOAM5336Lu13md9bzL1syJm6yc7R6OicijTACo4viZcyXDZN2NDb/Yl5
 O0E/qf7V2R1cXRowvTY6Qsr8HA==
X-Google-Smtp-Source: ABdhPJxYv9sp2wZAlY2XXftWgMKjZXUHM83ydJOkHJkf644kZkqhPJr0fwd+bpDuyqb2kqscBTDZJw==
X-Received: by 2002:a17:903:22c9:b0:156:9c66:5cf4 with SMTP id
 y9-20020a17090322c900b001569c665cf4mr768264plg.22.1649093613751; 
 Mon, 04 Apr 2022 10:33:33 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com.
 [35.185.214.157]) by smtp.gmail.com with ESMTPSA id
 x67-20020a623146000000b004fdf02851e5sm6463233pfx.220.2022.04.04.10.33.32
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Mon, 04 Apr 2022 10:33:32 -0700 (PDT)
Date: Mon, 4 Apr 2022 17:33:29 +0000
From: Sean Christopherson <seanjc@google.com>
To: Oliver Upton <oupton@google.com>
Subject: Re: [PATCH 2/4] KVM: Only log about debugfs directory collision once
Message-ID: <Yksr6etwnN0iW8ZH@google.com>
References: <20220402174044.2263418-1-oupton@google.com>
 <20220402174044.2263418-3-oupton@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20220402174044.2263418-3-oupton@google.com>
Cc: kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
 Peter Shier <pshier@google.com>, stable@kernel.org,
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

On Sat, Apr 02, 2022, Oliver Upton wrote:
> In all likelihood, a debugfs directory name collision is the result of a
> userspace bug. If userspace closes the VM fd without releasing all
> references to said VM then the debugfs directory is never cleaned.
> 
> Even a ratelimited print statement can fill up dmesg, making it
> particularly annoying for the person debugging what exactly went wrong.
> Furthermore, a userspace that wants to be a nuisance could clog up the
> logs by deliberately holding a VM reference after closing the VM fd.
> 
> Dial back logging to print at most once, given that userspace is most
> likely to blame. Leave the statement in place for the small chance that
> KVM actually got it wrong.
> 
> Cc: stable@kernel.org
> Fixes: 85cd39af14f4 ("KVM: Do not leak memory for duplicate debugfs directories")

I don't think this warrants Cc: stable@, the whole point of ratelimiting printk is
to guard against this sort of thing.  If a ratelimited printk can bring down the
kernel and/or logging infrastructure, then the kernel is misconfigured for the
environment.

> Signed-off-by: Oliver Upton <oupton@google.com>
> ---
>  virt/kvm/kvm_main.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 69c318fdff61..38b30bd60f34 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -959,7 +959,7 @@ static int kvm_create_vm_debugfs(struct kvm *kvm, int fd)
>  	mutex_lock(&kvm_debugfs_lock);
>  	dent = debugfs_lookup(dir_name, kvm_debugfs_dir);
>  	if (dent) {
> -		pr_warn_ratelimited("KVM: debugfs: duplicate directory %s\n", dir_name);
> +		pr_warn_once("KVM: debugfs: duplicate directory %s\n", dir_name);

I don't see how printing once is going to be usefull for a human debugger.  If we
want to get rid of the ratelimited print, why not purge it entirely?
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
