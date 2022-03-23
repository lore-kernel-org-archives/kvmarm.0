Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C16D3C433F5
	for <kvmarm@archiver.kernel.org>; Wed, 23 Mar 2022 17:28:35 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2780F40815;
	Wed, 23 Mar 2022 13:28:35 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id z7Vz0t5aEjss; Wed, 23 Mar 2022 13:28:34 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 230D040B03;
	Wed, 23 Mar 2022 13:28:34 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9607740815
 for <kvmarm@lists.cs.columbia.edu>; Wed, 23 Mar 2022 13:28:32 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 0GWG98cpkdEw for <kvmarm@lists.cs.columbia.edu>;
 Wed, 23 Mar 2022 13:28:31 -0400 (EDT)
Received: from mail-io1-f50.google.com (mail-io1-f50.google.com
 [209.85.166.50])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 835B7405C6
 for <kvmarm@lists.cs.columbia.edu>; Wed, 23 Mar 2022 13:28:31 -0400 (EDT)
Received: by mail-io1-f50.google.com with SMTP id q11so2519540iod.6
 for <kvmarm@lists.cs.columbia.edu>; Wed, 23 Mar 2022 10:28:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=LgnCvv2qE3S8Tqpp1/2DjvugQlyU9lcrJrUpyIMNMrQ=;
 b=mKDa/ZqD7NDxSaY4l0S6G4lgzGXJEl0gZCEPTE3GSbJDv+2fymW7CaflBSG4NfuYVL
 5yzCBy2AHpAi4Yz9IdAQ3eMXzAD/dp4HpWQmfcXnKB1AJvl1TJjD3XtYW+KScmGilk4w
 Owui8dsixk6DehiN5Rhz8QHjhgTabDXHgcQa9zsoHGJ8sBzEsWo8bebXMSSJSyDSGC01
 j27nkvOJPtRJrqHgK+rVIEqlgC8WWH5xXMI6/ZYx8ibZ2Jhu6oX2b6ARuv2mxIAS9CGW
 Dq7k5xKW9mspQEA4w4Dl9bnJzvkBlO8CgtMBHhvm3Sm9R3lEp38tG9w8KHof7FChyJkO
 V2ug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=LgnCvv2qE3S8Tqpp1/2DjvugQlyU9lcrJrUpyIMNMrQ=;
 b=bJ2aT8LT2RjG3URE8Jf4Allh5cZ0y/PBax5EPlIMPDd6qQp+EfezQ9KVyuMEXHG2wc
 +mVG0Kn3EM5TCw7aaiwtYzUNU6fGERZFmU2npCgzE0LbZkmnz3OSDIU/35nl+XSI6j4Y
 gTxSQwkypHbxePrkDFZfGuhDfVwFANkyOdqOFiUGjXYObbCplnqorxxB65S07SfRl7Ci
 ZZOYRLz9j+S8nrMoX2hVengMV+8fy2svQu3IeHPRKyAxGqViv2d25ZZ+hc9zjNIZCbrV
 zeLRNKbc/hgiuj4laU8/7PPswGcc9o4osQ0hCOtJC5PtWcLOWnygr8ChKhf0jKZEBGnm
 ydyQ==
X-Gm-Message-State: AOAM5322Syoq4F7GYznl523A0J7uvzOUoNJNBWgpVz2zy5bzz4QbIv71
 jvGDoqRHmm09sYCqLRsWbVT/GQ==
X-Google-Smtp-Source: ABdhPJyVvqHOYCIQvifvBP9cL1EAw3WnyYigwv1RusgVyObFlI+lYgfM14RmXBUdX5i9PZ5jUnLlmg==
X-Received: by 2002:a05:6602:2d49:b0:645:dcf0:3151 with SMTP id
 d9-20020a0566022d4900b00645dcf03151mr618760iow.61.1648056510629; 
 Wed, 23 Mar 2022 10:28:30 -0700 (PDT)
Received: from google.com (194.225.68.34.bc.googleusercontent.com.
 [34.68.225.194]) by smtp.gmail.com with ESMTPSA id
 w8-20020a056e0213e800b002c8279fb9dfsm278120ilj.57.2022.03.23.10.28.29
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Wed, 23 Mar 2022 10:28:29 -0700 (PDT)
Date: Wed, 23 Mar 2022 17:28:26 +0000
From: Oliver Upton <oupton@google.com>
To: Gavin Shan <gshan@redhat.com>
Subject: Re: [PATCH v5 18/22] KVM: arm64: Support SDEI ioctl commands on VM
Message-ID: <YjtYuk+Jx1dFPQQ9@google.com>
References: <20220322080710.51727-1-gshan@redhat.com>
 <20220322080710.51727-19-gshan@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20220322080710.51727-19-gshan@redhat.com>
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

On Tue, Mar 22, 2022 at 04:07:06PM +0800, Gavin Shan wrote:
> This supports ioctl commands on VM to manage the various objects.
> It's primarily used by VMM to accomplish migration. The ioctl
> commands introduced by this are highlighted as below:
> 
>    * KVM_SDEI_CMD_GET_VERSION
>      Retrieve the version of current implementation. It's different
>      from the version of the followed SDEI specification. This version
>      is used to indicates what functionalities documented in the SDEI
>      specification have been supported or not supported.

Don't we need a way to set the version as well? KVM is very much
responsible for upholding ABI of older specs. So, if a VMM and guest
expect SDEI v1.1, we can't just forcibly raise it to something else
during a migration.

The PSCI implementation is a great example of how KVM has grown its
implementation in line with a specification, all the while preserving
backwards compatibility.

>    * KVM_SDEI_CMD_GET_EXPOSED_EVENT_COUNT
>      Return the total count of exposed events.
> 
>    * KVM_SDEI_CMD_GET_EXPOSED_EVENT
>    * KVM_SDEI_CMD_SET_EXPOSED_EVENT
>      Get or set exposed event
> 
>    * KVM_SDEI_CMD_GET_REGISTERED_EVENT_COUNT
>      Return the total count of registered events.
> 
>    * KVM_SDEI_CMD_GET_REGISTERED_EVENT
>    * KVM_SDEI_CMD_SET_REGISTERED_EVENT
>      Get or set registered event.

Any new UAPI needs to be documented in Documentation/virt/kvm/api.rst

Additionally, we desperately need a better, generic way to save/restore
VM scoped state. IMO, we should only be adding ioctls if we are
affording userspace a meaningful interface. Every save/restore pair of
ioctls winds up wasting precious ioctl numbers and requires userspace
take a change to read/write an otherwise opaque value.

Marc had made some suggestions in this area already that Raghavendra
experimented with [1], and I think its time to meaningfully consider
our options. Basically, KVM_GET_REG_LIST needs to convey whether a
particular register is VM or vCPU state. We only need to save/restore a
VM state register once. That way, userspace doesn't have to care about
the underlying data and the next piece of VM state that comes along
doesn't require an ioctl nr nor VMM participation.

[1]: http://lore.kernel.org/r/20220224172559.4170192-3-rananta@google.com

--
Thanks,
Oliver
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
