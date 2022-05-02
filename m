Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B85B8C433EF
	for <kvmarm@archiver.kernel.org>; Mon,  2 May 2022 03:43:46 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2807A4B17C;
	Sun,  1 May 2022 23:43:46 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 3QZetyOXwJ6h; Sun,  1 May 2022 23:43:45 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 19C374B203;
	Sun,  1 May 2022 23:43:45 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 401564B17C
 for <kvmarm@lists.cs.columbia.edu>; Sun,  1 May 2022 23:43:44 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id sE9I3cYNEtI3 for <kvmarm@lists.cs.columbia.edu>;
 Sun,  1 May 2022 23:43:43 -0400 (EDT)
Received: from mail-io1-f41.google.com (mail-io1-f41.google.com
 [209.85.166.41])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id E564449ECC
 for <kvmarm@lists.cs.columbia.edu>; Sun,  1 May 2022 23:43:42 -0400 (EDT)
Received: by mail-io1-f41.google.com with SMTP id f2so14729022ioh.7
 for <kvmarm@lists.cs.columbia.edu>; Sun, 01 May 2022 20:43:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=zGNSlKgTRg237JpuejHa3caR1s/ok4pRQOehQdiihIc=;
 b=qfhvRSmDgBFYqZeJh5P65Y39gewiqAt13BPKf45fuv+ZkByqBgrYisQIl3DNsLp4hm
 s2ndoe+XBm2Lq2ZG2VPXBgtheIkGUIjcuAtK2SdC45eGXN698c8U7/A55TOwRCqAXH01
 G4+zDgmV49Yuvxc72MZ+kJOEEaICjznuSEqSJfAEfNR0WNJgiRdEBNX+tQ7WqytKbu7S
 An74GERQexjRDr7G7zsEKX60+w7htSVkVSp39iVwpWFHUHTTfcHsPjbBQ01q1MU9Y2d9
 qVH00CDBCOtQtgstADGKs8DYJKW3tBf5TlB5152RNZr8LlBI54mIX6phm43B2P+iDmtw
 H/XQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=zGNSlKgTRg237JpuejHa3caR1s/ok4pRQOehQdiihIc=;
 b=EcIaaRIG9CyLmF1G1QCQ4Jm+pVKF6u4kWth7Q4Ld8IB4QDKgEeCD0VRdoQuPuMjtMt
 J8uGdAGf4ucfiNI0nSTxP1pQ+B3S3W7n0zqkYiej4x4CIpMgmJNVwUpuvn9Dnqdx2mQy
 dRHNswYj/axK6MDbqQ7q9pImyW4pBTpK0YcRxYoffWf8OWjxCM5z6kgpkLAQPjd1PPUt
 F8qcTa8BHn1UceHmNB06bQe+IketGagjyvIoNHQLh12afbgGHapbdeJ0RoRH7wdDw1iv
 C9rs2h8vzoA3gfGoA4gJ3HE9ny5OCnMmyZQrB6Oq7MP+eCbSmeq0wiKFUzST6yJwGUDK
 CJNw==
X-Gm-Message-State: AOAM530b9UOGiIGD4vRL6BDCh3ZOQhyHVZv65KplSLVcY1rWfQ6k0rtV
 VOVT9V+unlh+HTMfURA4xHqrjw==
X-Google-Smtp-Source: ABdhPJyh1iMXhz1PULdaFy0uw0aVZ9erXWQ5/DyD6LOz5p3XTMx6qWKWFnFwv51JdBfOyRaVFyS+1Q==
X-Received: by 2002:a02:9a14:0:b0:32b:1f9f:352a with SMTP id
 b20-20020a029a14000000b0032b1f9f352amr4152355jal.209.1651463022025; 
 Sun, 01 May 2022 20:43:42 -0700 (PDT)
Received: from google.com (194.225.68.34.bc.googleusercontent.com.
 [34.68.225.194]) by smtp.gmail.com with ESMTPSA id
 t17-20020a6b0911000000b0065a47e16f61sm1821022ioi.51.2022.05.01.20.43.41
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Sun, 01 May 2022 20:43:41 -0700 (PDT)
Date: Mon, 2 May 2022 03:43:38 +0000
From: Oliver Upton <oupton@google.com>
To: Gavin Shan <gshan@redhat.com>
Subject: Re: [PATCH v6 04/18] KVM: arm64: Support SDEI_EVENT_REGISTER hypercall
Message-ID: <Ym9TarUE6+lJ0izt@google.com>
References: <20220403153911.12332-1-gshan@redhat.com>
 <20220403153911.12332-5-gshan@redhat.com>
 <Ym1Nsaq/ERUx/ebD@google.com>
 <6e7cb20d-24c4-b357-8830-a68ff05638fe@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <6e7cb20d-24c4-b357-8830-a68ff05638fe@redhat.com>
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

On Mon, May 02, 2022 at 10:55:51AM +0800, Gavin Shan wrote:
> > > +	unsigned long route_mode = smccc_get_arg(vcpu, 4);
> > 
> > This is really 'flags'. route_mode is bit[0]. I imagine we don't want to
> > support relative mode, so bit[1] is useless for us in that case too.
> > 
> > The spec is somewhat imprecise on what happens for reserved flags. The
> > prototype in section 5.1.2 of [1] suggests that reserved bits must be
> > zero, but 5.1.2.3 'Client responsibilities' does not state that invalid
> > flags result in an error.
> > 
> > Arm TF certainly rejects unexpected flags [2].
> > 
> > [1]: DEN0054C https://developer.arm.com/documentation/den0054/latest
> > [2]: https://github.com/ARM-software/arm-trusted-firmware/blob/66c3906e4c32d675eb06bd081de8a3359f76b84c/services/std_svc/sdei/sdei_main.c#L260
> > 
> 
> Yes, This chunk of code is still stick to old specification. Lets
> improve in next respin:
> 
>    - Rename @route_mode to @flags
>    - Reject if the reserved bits are set.
>    - Reject if relative mode (bit#1) is selected.
>    - Reject if routing mode (bit#0) isn't RM_ANY (0).

Bit[0] is ignored for private events, actually. So we really just reject
if any of bit[63:1] are set.

--
Thanks,
Oliver
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
