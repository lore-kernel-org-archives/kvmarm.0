Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 92013C433EF
	for <kvmarm@archiver.kernel.org>; Thu, 16 Jun 2022 17:55:07 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 122D643399;
	Thu, 16 Jun 2022 13:55:07 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id hRjG+T+dHzt8; Thu, 16 Jun 2022 13:55:06 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0F8AE49EAE;
	Thu, 16 Jun 2022 13:55:06 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B3D6A40DE6
 for <kvmarm@lists.cs.columbia.edu>; Thu, 16 Jun 2022 13:55:05 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id tsxaYFnN1Ayn for <kvmarm@lists.cs.columbia.edu>;
 Thu, 16 Jun 2022 13:55:04 -0400 (EDT)
Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com
 [209.85.214.175])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id B26DF40C23
 for <kvmarm@lists.cs.columbia.edu>; Thu, 16 Jun 2022 13:55:04 -0400 (EDT)
Received: by mail-pl1-f175.google.com with SMTP id k7so1849841plg.7
 for <kvmarm@lists.cs.columbia.edu>; Thu, 16 Jun 2022 10:55:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=znTRAobDR4k3IwStvUThGro3jde2RH7vgiXC22e3Wpo=;
 b=JtJ0/KXAoeyH22qk8xgaNmm6N6OhoBLl4osAVR1/dR3KcoInEdblt2EaO6bvp+9uKJ
 hXYKg6ygtQKIT4Iwn1DnlF3ejZO06HofaQGdM6Tun6+BhWMwzBvUDbYLJnjXxN6Vj0nQ
 XC7PQcMmL3vgm7FlCA37iYaJH6uuRmP7sSWrss56xUCUB6xWMzo7mlD7ajqkHtbrdQuW
 ZGPfWQtIhLwVwOPKyD8C1LtXYh0v4cOUGuAz2VDBaPkd9XKjl8STYU+oMlsHbScFSObb
 6s+65VdLGf1SzAnVV76C0iKDWDSe8Mj1FChNlu0FpbMY+jZ/0bpc8KClkBsN5dJ5X1Aj
 pCHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=znTRAobDR4k3IwStvUThGro3jde2RH7vgiXC22e3Wpo=;
 b=ijZmmGDdEKK0kBQhGbu2jmjP2N20+07A3N1/lC/PG2GF7g9DXG2FjyS2IwCXyCvhMG
 89PJOX09VFfx5q28TEGy1rtcBkhZIvsgjGHDvYXlx1Z03AV4t5dWJ0Ag7bzTYx8gIFEA
 RORC9j/xbwzPqkiupHQ1lLDbLlMC77PLzmgbhp/m5OvvG3F9rT5jDfQKkhzyJeX2d5eT
 rjpVSov5sJBI4K5qvLfaoFd7npwihYDgbwmQaO+f5o8eQn9Lj0EQ9Bgm7hkiKR+Un6u8
 tjesi/dagDTCC7KRH7Z/tEWTpmNBlb1cTVhn3MfAPxdIokDEHefaRl7KCTdWJaiYC1We
 4kNw==
X-Gm-Message-State: AJIora8tHZZTNABkav18VkIL1av2+fVbWJVMhVrUPOjRPm2NL4J6Y6AV
 jdQANVZFiiD1w0FNAsU6b6+GMA==
X-Google-Smtp-Source: AGRyM1uhOKQUCAIvFL30Ds5lZ2ml2mbY1gKVVmgrKzfeoo20zsOX1T8ZhrFZWmE+OtQW3iTaoeA/Cg==
X-Received: by 2002:a17:903:41cd:b0:169:9b8:36a4 with SMTP id
 u13-20020a17090341cd00b0016909b836a4mr2988391ple.49.1655402103568; 
 Thu, 16 Jun 2022 10:55:03 -0700 (PDT)
Received: from google.com (123.65.230.35.bc.googleusercontent.com.
 [35.230.65.123]) by smtp.gmail.com with ESMTPSA id
 72-20020a17090a0fce00b001e310303275sm1827652pjz.54.2022.06.16.10.55.02
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Thu, 16 Jun 2022 10:55:03 -0700 (PDT)
Date: Thu, 16 Jun 2022 17:54:59 +0000
From: Sean Christopherson <seanjc@google.com>
To: Oliver Upton <oupton@google.com>
Subject: Re: [PATCH v2 3/5] KVM: Get an fd before creating the VM
Message-ID: <YqtuczDtxhWp4R3/@google.com>
References: <20220518175811.2758661-1-oupton@google.com>
 <20220518175811.2758661-4-oupton@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20220518175811.2758661-4-oupton@google.com>
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
> Hoist fd init to the very beginning of kvm_create_vm() so we can make

"init" is a bit ambiguous, e.g. from a "can I use the fd" perspective the fd is
still very much not initialized.  Also, it's at the beginning of
kvm_dev_ioctl_create_vm(), _before_ kvm_create_vm().

  Allocate a VM's fd at the very beginning of kvm_dev_ioctl_create_vm()
  so that KVM can use the fd value to generate strings, e.g. for debugfs,
  when creating and initializing the VM.

> use of it in other init routines.
> 
> Signed-off-by: Oliver Upton <oupton@google.com>
> ---
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
