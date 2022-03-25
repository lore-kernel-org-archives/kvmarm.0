Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 40DDCC433F5
	for <kvmarm@archiver.kernel.org>; Fri, 25 Mar 2022 07:35:23 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A32FF4B0CC;
	Fri, 25 Mar 2022 03:35:22 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id xqHRd7DutE04; Fri, 25 Mar 2022 03:35:20 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5D9D84B089;
	Fri, 25 Mar 2022 03:35:20 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7BE134B0B4
 for <kvmarm@lists.cs.columbia.edu>; Fri, 25 Mar 2022 03:35:19 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 2ZeiX3TJNVUc for <kvmarm@lists.cs.columbia.edu>;
 Fri, 25 Mar 2022 03:35:17 -0400 (EDT)
Received: from mail-io1-f45.google.com (mail-io1-f45.google.com
 [209.85.166.45])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 361444B089
 for <kvmarm@lists.cs.columbia.edu>; Fri, 25 Mar 2022 03:35:17 -0400 (EDT)
Received: by mail-io1-f45.google.com with SMTP id z6so8046375iot.0
 for <kvmarm@lists.cs.columbia.edu>; Fri, 25 Mar 2022 00:35:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=F0MrQ+7f7irVz92hhE31+GxoOTRqqf7nkLXgWrnk+AY=;
 b=QlXrQfFErm9nmqJuIwFNttHecBo8vtSI0dcbdc68Zk3dtp2UPzmZsdQftZMwROOvoW
 kkx0SI0ZXdfz4nc11dMhHmK58CPlgtXAc5a13ZRfsAyVQ6KxUbdb8lmOgNR1KY0RZS/a
 fqpSa1ocM2fByvmUMXbZLUHc/SBLhwS4/hp6Y7RtwV5/rRz7EyhoFRtwxUgJWR/Yu65e
 cuEErTtkYIA4MEyhefLzSYJ9AElQaxu/UcBUJVneMkKIQpiQ6EtY57qFecDN8TVAwzDV
 vnScHzjxBxlNFWsF4T0kJ8ivkVwvoLT/+CJqMHxpFr7RWmTxo+qQmVHflho1tlk0Uo0o
 gPlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=F0MrQ+7f7irVz92hhE31+GxoOTRqqf7nkLXgWrnk+AY=;
 b=DSnm6m7u34W/7+WfKLaV2Fe7EFA94CWEe+FPyJXo3H0x7nCYKGc/2dYDaT1YRRPBmO
 /e9coISDJUjUDt9b0y1JmtqSTGz9Ck/k9aniCBfBlG6cx9jD9vHCONyU896AfJi5NGzJ
 NUIYSf764pp0zzoD87xCC/Af1g+yKwhVaP87ZefITMKp11beIIY5We+ipAlup/Zr1v1A
 9Cyqh9G19uoOxb8jP3s5y/qsiGROzyvVrxnLRKTHIKXFAp+X8xcVyLuNmdR5zBIZai6I
 E+r1sY359jbMN015+SV2pUiPMhVvNRHqEiIFG9uPOGlY/gCAOPwhMLfNpZgkHxThBSsi
 9QGw==
X-Gm-Message-State: AOAM532fxHPy5oJg8WPSQ9cN0BOXziZ2W+jQ4cJ5vEFDi7ujVevClSTc
 k7QEj60rN6m380EZqwIOKIdm5A==
X-Google-Smtp-Source: ABdhPJyKAib7ZXAHBesSLCUBmAkLGhgEYACYuNaz1pPMRtCTnlSY/nTkv48NvdxoTzqfEXv0OWtBuQ==
X-Received: by 2002:a05:6638:1649:b0:31f:61f6:35f4 with SMTP id
 a9-20020a056638164900b0031f61f635f4mr5072950jat.205.1648193716120; 
 Fri, 25 Mar 2022 00:35:16 -0700 (PDT)
Received: from google.com (194.225.68.34.bc.googleusercontent.com.
 [34.68.225.194]) by smtp.gmail.com with ESMTPSA id
 p22-20020a5d8d16000000b006115627b87csm2600602ioj.55.2022.03.25.00.35.15
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Fri, 25 Mar 2022 00:35:15 -0700 (PDT)
Date: Fri, 25 Mar 2022 07:35:12 +0000
From: Oliver Upton <oupton@google.com>
To: Gavin Shan <gshan@redhat.com>
Subject: Re: [PATCH v5 18/22] KVM: arm64: Support SDEI ioctl commands on VM
Message-ID: <Yj1wsIy2rsVczmCJ@google.com>
References: <20220322080710.51727-1-gshan@redhat.com>
 <20220322080710.51727-19-gshan@redhat.com>
 <YjtYuk+Jx1dFPQQ9@google.com>
 <eae10132-a02d-b341-bdf5-be1b2096be4c@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <eae10132-a02d-b341-bdf5-be1b2096be4c@redhat.com>
Cc: maz@kernel.org, linux-kernel@vger.kernel.org, eauger@redhat.com,
 shan.gavin@gmail.com, Jonathan.Cameron@huawei.com, pbonzini@redhat.com,
 vkuznets@redhat.com, will@kernel.org, kvmarm@lists.cs.columbia.edu
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

On Fri, Mar 25, 2022 at 02:59:52PM +0800, Gavin Shan wrote:
> > The PSCI implementation is a great example of how KVM has grown its
> > implementation in line with a specification, all the while preserving
> > backwards compatibility.
> > 
> 
> The only information feed by VMM is the exposed events. The events
> can't be registered from guest kernel, and raised from host to guest
> kernel until it's exposed by VMM.

I would suggest assuming that all SDEI events are exposed by default in
KVM. We will not require a VMM change to enable events individually.

> Besides, the exposed events will
> be defined staticly in host/KVM as we discussed on PATCH[02/22]. We
> also discussed to eliminate those ioctl commands. So I think we needn't
> to add KVM_SDEI_CMD_SET_VERSION. Further more, the version is only a
> concern to host itself if the migration can be done through the
> firmware pseudo system registers since the migration compatibility
> is the only concern to VMM (QEMU).

This all needs to work just like the KVM_REG_ARM_PSCI_VERSION version,
I'd recommend taking a look at how we handle that register in KVM.

> Yes, Currently, 0.1/0.2/1.0 versions are supported by PSCI. 0.1 is
> picked until VMM asks for 0.2 and 1.0 explicitly. However, it seems
> QEMU isn't using 1.0 PSCI yet and maybe more patch is needed to enable
> it.

As far as how it interacts with KVM, QEMU looks fine. The name of the
KVM_ARM_VCPU_PSCI_0_2 bit is quite frustrating. It actually implies that
KVM will enable it highest supported PSCI version. If the feature bit is
cleared then you only get PSCIv0.1

However, the DT node that QEMU sets up looks a bit crusty. The
properties for conveying PSCI function IDs were only ever necessary for
PSCIv0.1. The only property of interest any more is 'method', to convey
the SMCCC conduit instruction.

--
Thanks,
Oliver
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
