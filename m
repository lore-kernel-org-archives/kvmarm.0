Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4E8B0C433EF
	for <kvmarm@archiver.kernel.org>; Sat,  2 Apr 2022 22:39:44 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BD57F4B105;
	Sat,  2 Apr 2022 18:39:43 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Qz2+2kr1CVlw; Sat,  2 Apr 2022 18:39:42 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A85094B250;
	Sat,  2 Apr 2022 18:39:42 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E4C734B106
 for <kvmarm@lists.cs.columbia.edu>; Sat,  2 Apr 2022 18:39:41 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id NYQ8RuFWp4ec for <kvmarm@lists.cs.columbia.edu>;
 Sat,  2 Apr 2022 18:39:40 -0400 (EDT)
Received: from mail-il1-f182.google.com (mail-il1-f182.google.com
 [209.85.166.182])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D79C64B105
 for <kvmarm@lists.cs.columbia.edu>; Sat,  2 Apr 2022 18:39:40 -0400 (EDT)
Received: by mail-il1-f182.google.com with SMTP id t15so4343743ilq.12
 for <kvmarm@lists.cs.columbia.edu>; Sat, 02 Apr 2022 15:39:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=qLNzO18ajat1m0fs1W8NtMq/BQbLXFrYLsmtTPYjHJ8=;
 b=fcII4z0VLNKpeNeV5LH4dIsf92I/nz7pTv6mXarO0z2A11z7ck/GMqJi+mc9XrUnxE
 7ky3roY//u2Cwlvh1KM0wmujjr5BS+CZNvL3i0q0IUGBgQlGPDqkUlsdz9Qv1m66ZKzd
 HUOzOXtq18Kbx0+9BgZG3O3uS/BXrP9TCj3i5us0XTuANYrokrPw2idLLomuPfpJv8MV
 MqesIUQFeoKbaIKGe8DYFJGZ3X9qr7HNrbkmzuUn75LQH0PREvjnh8TLoylFd+uLK0Z/
 ZxPIuqa4F4XSGj5MeJFtlf3eE0d0OJLE0rGeVLUdGNRN2V7z4fMMqSDJhJVSalF7jDPT
 j4Rw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=qLNzO18ajat1m0fs1W8NtMq/BQbLXFrYLsmtTPYjHJ8=;
 b=tj5nUb/DRnSSF671eqrCqJPZgNiwWRLa/PLSR/KGIrcAOvDkebdK+s1lY3hcZUFL9X
 hgbJRGFCfbKaMkYVNjTT5G/t4fN255TVhaMmjsd0+HfG+h9XyO3nkf7GM6Iej/ZxOKp/
 8PsGIa04Ou1ncEOgFMjAi8WOt+xu+G92fHPeg3YYsEX6tpOCSTCPMutGbcPBCbSSCmtV
 CoSbEvBR0A/aHDJ3MC5OKpKPip68VQejBpu2kuL9/p19cMZWy0zrNpyURQIJep/mtGPo
 tuNvlPvBCHEmy8V5AmegXLs9mmFw3sxxiJ+sGBZhkms18SLFY3ROVcmpXC6PiiyCd4Tw
 xPRg==
X-Gm-Message-State: AOAM5335crYKnIPEjhisRiAuUgvqTvH1wjEs2C0pAq9nD6Bt8cEK7h1/
 URSc74pCwESUiSeVElXSyHij4pn8OqAuUg==
X-Google-Smtp-Source: ABdhPJzkTWYehe59rde3kRAtZPzzbA6tHyxqruaUsn3Kn0DRZ6Wh/jC8BaavKN0yp+ne9/VWwnP0fw==
X-Received: by 2002:a92:6a01:0:b0:2b6:87b7:180b with SMTP id
 f1-20020a926a01000000b002b687b7180bmr2725039ilc.82.1648939179643; 
 Sat, 02 Apr 2022 15:39:39 -0700 (PDT)
Received: from google.com (194.225.68.34.bc.googleusercontent.com.
 [34.68.225.194]) by smtp.gmail.com with ESMTPSA id
 r9-20020a6bd909000000b00649276ea9fesm3648152ioc.7.2022.04.02.15.39.37
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Sat, 02 Apr 2022 15:39:37 -0700 (PDT)
Date: Sat, 2 Apr 2022 22:39:34 +0000
From: Oliver Upton <oupton@google.com>
To: kvmarm@lists.cs.columbia.edu
Subject: Re: [PATCH 1/4] KVM: arm64: vgic: Don't assume the VM debugfs
 directory exists
Message-ID: <YkjQpoS4Y+3+dwjp@google.com>
References: <20220402174044.2263418-1-oupton@google.com>
 <20220402174044.2263418-2-oupton@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20220402174044.2263418-2-oupton@google.com>
Cc: kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
 Peter Shier <pshier@google.com>, Paolo Bonzini <pbonzini@redhat.com>,
 stable@kernel.org, linux-arm-kernel@lists.infradead.org
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

On Sat, Apr 02, 2022 at 05:40:41PM +0000, Oliver Upton wrote:
> Unfortunately, there is no guarantee that KVM was able to instantiate a
> debugfs directory for a particular VM. To that end, KVM shouldn't even
> attempt to create new debugfs files in this case. If the specified
> parent dentry is NULL, debugfs_create_file() will instantiate files at
> the root of debugfs.
> 
> Since it is possible to create the vgic-state file outside of a VM
> directory, the file is not cleaned up when a VM is destroyed.
> Nonetheless, the corresponding struct kvm is freed when the VM is
> destroyed.
> 
> Plug the use-after-free by plainly refusing to create vgic-state when
> KVM fails to create a VM debugfs dir.
> 
> Cc: stable@kernel.org
> Fixes: 929f45e32499 ("kvm: no need to check return value of debugfs_create functions")
> Signed-off-by: Oliver Upton <oupton@google.com>

Thinking about this a bit more...

The game of whack-a-mole for other files that possibly have the same bug
could probably be avoided if kvm->debugfs_dentry is initialized to
PTR_ERR(-ENOENT) by default. That way there's no special error handling
that needs to be done in KVM as any attempt to create a new file will
bail.

Going to test and send out a v2 most likely, just want to make sure no
other use of debugfs in KVM will flip out from the change.

--
Thanks,
Oliver
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
