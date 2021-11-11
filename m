Return-Path: <SRS0=nF4w=P6=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DC535C433FE
	for <kvmarm@archiver.kernel.org>; Thu, 11 Nov 2021 10:39:57 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 58E1E61002
	for <kvmarm@archiver.kernel.org>; Thu, 11 Nov 2021 10:39:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 58E1E61002
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id AF38F4B1F6;
	Thu, 11 Nov 2021 05:39:56 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id YcrhioQMHXhT; Thu, 11 Nov 2021 05:39:54 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 94A524B1E4;
	Thu, 11 Nov 2021 05:39:54 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6EF094B1B4
 for <kvmarm@lists.cs.columbia.edu>; Thu, 11 Nov 2021 05:39:53 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id iCa-1OIoP9R6 for <kvmarm@lists.cs.columbia.edu>;
 Thu, 11 Nov 2021 05:39:51 -0500 (EST)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.129.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E6E934B192
 for <kvmarm@lists.cs.columbia.edu>; Thu, 11 Nov 2021 05:39:51 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1636627191;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=3GsoHxG6tbN9F1JDRhurToiafQZa+kQvGVSVSX20JIs=;
 b=c80azBnlmrqZbSESRAbkz+iE26a8jd8rTR82JlScxnb7wWxdV9Lgu2huMgvvPVU0UO7FY/
 g6dsVNcUQNfnS1iC/9sjp4bN/c5jfRBoXuFyrB2FeTIc4gfvimIED0HgtP3bA9yBICHune
 c9dqUteeLTxsk9xx88ipf2LASNRZ+pI=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-361-6yQZtK-BObuqA4Rk1ho2kQ-1; Thu, 11 Nov 2021 05:39:50 -0500
X-MC-Unique: 6yQZtK-BObuqA4Rk1ho2kQ-1
Received: by mail-wm1-f69.google.com with SMTP id
 145-20020a1c0197000000b0032efc3eb9bcso4614376wmb.0
 for <kvmarm@lists.cs.columbia.edu>; Thu, 11 Nov 2021 02:39:50 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:subject:to:cc:references:from:message-id:date
 :user-agent:mime-version:in-reply-to:content-language
 :content-transfer-encoding;
 bh=3GsoHxG6tbN9F1JDRhurToiafQZa+kQvGVSVSX20JIs=;
 b=cgfRzoHDIQ5u8USGUXXhMu+k4xEQWWyzUunrbpPAq5zU+TJ67muGJ5ERA39NabltSS
 vF9LpUvxqmE7Grlnj5Cp2XMbiiJi98X9aogHd9gvKqaXRIoObG3mvGI2grUmRwjVe20R
 J2N3b1EKbk4GZy5vyB0As7JjhwVRbipYf517caD5VGCE9NVk61iV6dZJTqJ1IHJLcNAE
 BV3J6ZVdw4/xp1KIXdebCZyeX/DdhHHLCBxcgic36ecCzV7tHCwsZlWRbG9ybHr5gtU7
 tbQ77Ef8fZuDmKc0Y26MtV0MFJtyfQr9QVSSQ1b6O2jv7SvxPPl/lh7NcR3oIcEJMVyg
 a5Ww==
X-Gm-Message-State: AOAM531QfF2JxyX3tAhudYLmx+LlA69uR5plyf3tUqOQcpG2/xvjUxdp
 P5AKOcOemjByG4QmYlSy4VkxLuDqjvaNkvjrGUE6h1PhmoIk4veHcPrIhAp56vH07jKU7jn2BKJ
 4DQqS7oiZI5BaoH0WYBcduqVz
X-Received: by 2002:a05:600c:4e94:: with SMTP id
 f20mr6926072wmq.77.1636627188887; 
 Thu, 11 Nov 2021 02:39:48 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwTYMHTkSN+BIGJqDL7NN5zIg2PBR9XWifP9uLbTro4v0wXHfWDmPWNeawdlFQiQ6RIVcQ3ZQ==
X-Received: by 2002:a05:600c:4e94:: with SMTP id
 f20mr6926042wmq.77.1636627188579; 
 Thu, 11 Nov 2021 02:39:48 -0800 (PST)
Received: from ?IPv6:2a01:e0a:59e:9d80:527b:9dff:feef:3874?
 ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
 by smtp.gmail.com with ESMTPSA id u14sm2539907wrt.49.2021.11.11.02.39.47
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Thu, 11 Nov 2021 02:39:48 -0800 (PST)
Subject: Re: [PATCH v4 15/15] KVM: arm64: Add async PF document
To: Gavin Shan <gshan@redhat.com>, kvmarm@lists.cs.columbia.edu
References: <20210815005947.83699-1-gshan@redhat.com>
 <20210815005947.83699-16-gshan@redhat.com>
From: Eric Auger <eauger@redhat.com>
Message-ID: <8505a820-9a67-fc8e-46e2-7f261a4501a3@redhat.com>
Date: Thu, 11 Nov 2021 11:39:46 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20210815005947.83699-16-gshan@redhat.com>
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=eauger@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Cc: kvm@vger.kernel.org, maz@kernel.org, linux-kernel@vger.kernel.org,
 shan.gavin@gmail.com, Jonathan.Cameron@huawei.com, pbonzini@redhat.com,
 vkuznets@redhat.com, will@kernel.org
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

Hi Gavin,

On 8/15/21 2:59 AM, Gavin Shan wrote:
> This adds document to explain the interface for asynchronous page
> fault and how it works in general.
> 
> Signed-off-by: Gavin Shan <gshan@redhat.com>
> ---
>  Documentation/virt/kvm/arm/apf.rst   | 143 +++++++++++++++++++++++++++
>  Documentation/virt/kvm/arm/index.rst |   1 +
>  2 files changed, 144 insertions(+)
>  create mode 100644 Documentation/virt/kvm/arm/apf.rst
> 
> diff --git a/Documentation/virt/kvm/arm/apf.rst b/Documentation/virt/kvm/arm/apf.rst
> new file mode 100644
> index 000000000000..4f5c01b6699f
> --- /dev/null
> +++ b/Documentation/virt/kvm/arm/apf.rst
> @@ -0,0 +1,143 @@
> +.. SPDX-License-Identifier: GPL-2.0
> +
> +Asynchronous Page Fault Support for arm64
> +=========================================
> +
> +There are two stages of page faults when KVM module is enabled as accelerator
> +to the guest. The guest is responsible for handling the stage-1 page faults,
> +while the host handles the stage-2 page faults. During the period of handling
> +the stage-2 page faults, the guest is suspended until the requested page is
> +ready. It could take several milliseconds, even hundreds of milliseconds in
 s/It could take several milliseconds, even hundreds of milliseconds/It
could take up to hundreds of milliseconds
> +extreme situations because I/O might be required to move the requested page
> +from disk to DRAM. The guest does not do any work when it is suspended. The
> +feature (Asynchronous Page Fault) is introduced to take advantage of the
s/The feature (Asynchronous Page Fault)/ The Asynchronous Page Fault
feature allows to improve the overall performance by allowing the guest
to reschedule ... ?
> +suspending period and to improve the overall performance.
> +
> +There are two paths in order to fulfil the asynchronous page fault, called
> +as control path and data path.
The asynchronous page fault is implemented upon a control path and a
data path?
 The control path allows the VMM or guest to
> +configure the functionality, while the notifications are delivered in data
> +path. The notifications are classified into page-not-present and page-ready
> +notifications.
> +
> +Data Path
> +---------
> +
> +There are two types of notifications delivered from host to guest in the
> +data path: page-not-present and page-ready notification. They are delivered
> +through SDEI event and (PPI) interrupt separately.
s/separately/respectively
 Besides, there is a shared
> +buffer between host and guest to indicate the reason and sequential token,
s/to indicate/that indicates
Can you clarify 'reason'?
Also a sequential token is used ...
> +which is used to identify the asynchronous page fault. The reason and token
> +resident in the shared buffer is written by host, read and cleared by guest.
s/is/are
> +An asynchronous page fault is delivered and completed as below.
> +
> +(1) When an asynchronous page fault starts, a (workqueue) worker is created
> +    and queued to the vCPU's pending queue. The worker makes the requested
> +    page ready and resident to DRAM in the background. The shared buffer is
> +    updated with reason and sequential token. After that, SDEI event is sent
> +    to guest as page-not-present notification.
This gives the impression the SDEI event is sent after the worker
completes the job. I think you should rephrase.
> +
> +(2) When the SDEI event is received on guest, the current process is tagged
> +    with TIF_ASYNC_PF and associated with a wait queue. The process is ready
> +    to keep rescheduling itself on switching from kernel to user mode. After
above sentence sounds a bit cryptic to me: ~ waits for being rescheduled
later?
> +    that, a reschedule IPI is sent to current CPU and the received SDEI event
> +    is acknowledged. Note that the IPI is delivered when the acknowledgment
> +    on the SDEI event is received on host.
> +
> +(3) On the host, the worker is dequeued from the vCPU's pending queue and
> +    enqueued to its completion queue when the requested page becomes ready.
> +    In the mean while, KVM_REQ_ASYNC_PF request is sent the vCPU if the
in the meanwhile here and below
> +    worker is the first element enqueued to the completion queue.
I think you should remind what is the intent of this KVM_REQ_ASYNC_PF
request, ie. notify that the page is ready.
> +
> +(4) With pending KVM_REQ_ASYNC_PF request, the first worker in the completion
> +    queue is dequeued and destroyed. In the mean while, a (PPI) interrupt is

> +    sent to guest with updated reason and token in the shared buffer.
> +
> +(5) When the (PPI) interrupt is received on guest, the affected process is
> +    located using the token and waken up after its TIF_ASYNC_PF tag is cleared.
> +    After that, the interrupt is acknowledged through SMCCC interface. The
> +    workers in the completion queue is dequeued and destroyed if any workers
the worker
Isn't it destroyed even if no other worker exist?
> +    exist, and another (PPI) interrupt is sent to the guest.

I think you should briefly remind the motivation of SDEI and PPI
mechanism for both synchros. Maybe by doing an analogy with x86
implementation?
> +
> +Control Path
> +------------
> +
> +The configurations are passed through SMCCC or ioctl interface. The SDEI
> +event and (PPI) interrupt are owned by VMM, so the SDEI event and interrupt
> +numbers are configured through ioctl command on per-vCPU basis.
The "owned" terminology looks weird here. Do you mean the SDEI event
number and the PPI ID are defined by the VMM userspace?

 Besides,
> +the functionality might be enabled and configured through ioctl interface
> +by VMM during migration:
> +
> +   * KVM_ARM_ASYNC_PF_CMD_GET_VERSION
> +
> +     Returns the current version of the feature, supported by the host. It is
> +     made up of major, minor and revision fields. Each field is one byte in
> +     length.
> +
> +   * KVM_ARM_ASYNC_PF_CMD_GET_SDEI:
> +
> +     Retrieve the SDEI event number, used for page-not-present notification,
> +     so that it can be configured on destination VM in the scenario of
> +     migration.
> +
> +   * KVM_ARM_ASYNC_PF_GET_IRQ:
> +
> +     Retrieve the IRQ (PPI) number, used for page-ready notification, so that
> +     it can be configured on destination VM in the scenario of migration.
> +
> +   * KVM_ARM_ASYNC_PF_CMD_GET_CONTROL
> +
> +     Retrieve the address of control block, so that it can be configured on
> +     destination VM in the scenario of migration.
> +
> +   * KVM_ARM_ASYNC_PF_CMD_SET_SDEI:
> +
> +     Used by VMM to configure number of SDEI event, which is used to deliver
> +     page-not-present notification by host. This is used when VM is started
> +     or migrated.
> +
> +   * KVM_ARM_ASYNC_PF_CMD_SET_IRQ
> +
> +     Used by VMM to configure number of (PPI) interrupt, which is used to
> +     deliver page-ready notification by host. This is used when VM is started
> +     or migrated.
> +
> +   * KVM_ARM_ASYNC_PF_CMD_SET_CONTROL
> +
> +     Set the control block on the destination VM in the scenario of migration.
What is the size of this control block?
> +
> +The other configurations are passed through SMCCC interface. The host exports
> +the capability through KVM vendor specific service, which is identified by
> +ARM_SMCCC_KVM_FUNC_ASYNC_PF_FUNC_ID. There are several functions defined for
> +this:
> +
> +   * ARM_SMCCC_KVM_FUNC_ASYNC_PF_VERSION
> +
> +     Returns the current version of the feature, supported by the host. It is
> +     made up of major, minor and revision fields. Each field is one byte in
> +     length.
> +
> +   * ARM_SMCCC_KVM_FUNC_ASYNC_PF_SLOTS
> +
> +     Returns the size of the hashed GFN table. It is used by guest to set up
by the guest
> +     the capacity of waiting process table.
> +
> +   * ARM_SMCCC_KVM_FUNC_ASYNC_PF_SDEI
> +   * ARM_SMCCC_KVM_FUNC_ASYNC_PF_IRQ
> +
> +     Used by the guest to retrieve the SDEI event and (PPI) interrupt number
> +     that are configured by VMM.
How does the guest recognize which SDEI event num it shall register.
Same question for PPI? What if we were to expose the guest with several
SDEIs?
> +
> +   * ARM_SMCCC_KVM_FUNC_ASYNC_PF_ENABLE
> +
> +     Used by the guest to enable or disable the feature on the specific vCPU.
> +     The argument is made up of shared buffer and flags. The shared buffer
> +     is written by host to indicate the reason about the delivered asynchronous
> +     page fault and token (sequence number) to identify that. There are two
> +     flags are supported: KVM_ASYNC_PF_ENABLED is used to enable or disable
> +     the feature. KVM_ASYNC_PF_SEND_ALWAYS allows to deliver page-not-present
> +     notification regardless of the guest's state. Otherwise, the notification
> +     is delivered only when the guest is in user mode.
> +
> +   * ARM_SMCCC_KVM_FUNC_ASYNC_PF_IRQ_ACK

How does it compare to x86? I mean there are a huger number of IOCTLs
and SMCCC calls to achieve the functionaly. Was the x86 implementation
as invasive as this implementation?

Thanks

Eric
> +
> +     Used by the guest to acknowledge the completion of page-ready notification.
> diff --git a/Documentation/virt/kvm/arm/index.rst b/Documentation/virt/kvm/arm/index.rst
> index 78a9b670aafe..f43b5fe25f61 100644
> --- a/Documentation/virt/kvm/arm/index.rst
> +++ b/Documentation/virt/kvm/arm/index.rst
> @@ -7,6 +7,7 @@ ARM
>  .. toctree::
>     :maxdepth: 2
>  
> +   apf
>     hyp-abi
>     psci
>     pvtime
> 

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
