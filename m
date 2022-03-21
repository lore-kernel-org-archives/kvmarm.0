Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 80006C433F5
	for <kvmarm@archiver.kernel.org>; Mon, 21 Mar 2022 08:28:55 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id EC60140BDF;
	Mon, 21 Mar 2022 04:28:54 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 5aeRuOLC2Esg; Mon, 21 Mar 2022 04:28:49 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 45A1E49ED1;
	Mon, 21 Mar 2022 04:28:49 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8736B49EC1
 for <kvmarm@lists.cs.columbia.edu>; Mon, 21 Mar 2022 04:28:47 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 54irRP64tD66 for <kvmarm@lists.cs.columbia.edu>;
 Mon, 21 Mar 2022 04:28:42 -0400 (EDT)
Received: from mail-io1-f52.google.com (mail-io1-f52.google.com
 [209.85.166.52])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id E477840BDF
 for <kvmarm@lists.cs.columbia.edu>; Mon, 21 Mar 2022 04:28:41 -0400 (EDT)
Received: by mail-io1-f52.google.com with SMTP id r2so15876022iod.9
 for <kvmarm@lists.cs.columbia.edu>; Mon, 21 Mar 2022 01:28:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=Cfg0pudYuT/u9wGQCidgxonBzl21c0eXO7Xcpwo6DvA=;
 b=i7pv6ta+HcQyz03nNrIY/wwiH4PmYxUxoVygyzR65sr5D7TIWBtE50wN/vm7DFq3Ny
 JCFfR6YE94Ec1NI59HTf0yCMDdNbFZ566y+1EoHu741K0oYhUvMDga/syvsdgowQMYYE
 WDTQcvcf1IcdlrRaUbVn8a9UQsSurtP4PnVx/pGuf5cuNoaWg0SgNWNYfzn8rWo2VHEC
 m4QlSycQ6JKjDoY0RvAWA3tkfsbRxkO8TEO7cv73TwfFHu/ix/mTKKDHEEjKZZ13xZiK
 sun05CpBOCvf2Fg9+wwEmmK6xAsRfgpNvFaNvjXaie+Oj78pscbozGzmN/nHVby39LF6
 kSIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=Cfg0pudYuT/u9wGQCidgxonBzl21c0eXO7Xcpwo6DvA=;
 b=N0pQ5ArXk0dZKd3l+/ICbS4WLbpHTPFUjjBDMAC5NyqgVCKyFnBSF42FlKNGBLETp5
 KVJltDGbokLG9LycCBq/tqAFfG5k/jjp/0IXeu0YVRtQ8smbqJAg1QXFZs5wzdTznqnp
 AeZEHsvLehHrmrvdVAX65yBVBQGD/8hS9RWT4wkvZpHL4QBpbr8n42ytmbnb6bpU9CCW
 FMBjyHalaMwQS1G25rbAt5FQKyfkPK97qKvuAfbQkVtPTcVh82KdAxMiEFbPnbABbOx4
 O9dN6O/IGFHnXQ50wqGh1gHOixNDMXVQ/KL9aYyOJ+gWOO0wYft0NhglF60QiD8mAnIP
 h8PQ==
X-Gm-Message-State: AOAM532/MUsNBMRDqfAoGVmyEitw+DAM5AU2pFi0JcKUaZnP2f2usK0f
 N1EFQtL26AH1N+VyvRDNj5MSkg==
X-Google-Smtp-Source: ABdhPJwTWqgxMSuyUPTzaj4+SQGyUK+bH9j8AzPeOFjf5Lmv+3MyOVV6SsDOnasb4Gvf4p4Yfg6qUQ==
X-Received: by 2002:a02:b048:0:b0:311:85be:a797 with SMTP id
 q8-20020a02b048000000b0031185bea797mr9850764jah.284.1647851321010; 
 Mon, 21 Mar 2022 01:28:41 -0700 (PDT)
Received: from google.com (194.225.68.34.bc.googleusercontent.com.
 [34.68.225.194]) by smtp.gmail.com with ESMTPSA id
 x2-20020a056602160200b006463c1977f9sm8361965iow.22.2022.03.21.01.28.40
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Mon, 21 Mar 2022 01:28:40 -0700 (PDT)
Date: Mon, 21 Mar 2022 08:28:37 +0000
From: Oliver Upton <oupton@google.com>
To: Reiji Watanabe <reijiw@google.com>
Subject: Re: [PATCH v5 2/2] KVM: arm64: selftests: Introduce vcpu_width_config
Message-ID: <Yjg3Nd1KYmJX5rSG@google.com>
References: <20220321050804.2701035-1-reijiw@google.com>
 <20220321050804.2701035-3-reijiw@google.com>
 <YjgYh89k8s+w34FQ@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <YjgYh89k8s+w34FQ@google.com>
Cc: kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
 Peter Shier <pshier@google.com>, Will Deacon <will@kernel.org>,
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

On Mon, Mar 21, 2022 at 06:17:43AM +0000, Oliver Upton wrote:
> Hi Reiji,
> 
> On Sun, Mar 20, 2022 at 10:08:04PM -0700, Reiji Watanabe wrote:

[...]

> > +#define _GNU_SOURCE
> 
> In other instances where we define _GNU_SOURCE, it is said we do it for
> program_invocation_short_name. Nonetheless, I cannot find anywhere that
> the symbol is actually being used.
> 
> This looks to be some leftover crud from our internal test library
> before we upstreamed KVM selftests a few years ago.
>

Ah, it's because we're actually using program_invocation_name. This
already gets defined in lib/kvm_util.c, so except for a few oddball
tests that directly call kvm_vm_elf_load(), this is unnecessary.

--
Thanks,
Oliver
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
