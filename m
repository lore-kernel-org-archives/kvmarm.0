Return-Path: <SRS0=TLTx=B3=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 174AEC433E1
	for <kvmarm@archiver.kernel.org>; Mon, 17 Aug 2020 11:01:45 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id A6E6520B1F
	for <kvmarm@archiver.kernel.org>; Mon, 17 Aug 2020 11:01:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="O15QjaFS"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A6E6520B1F
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1F3E54C060;
	Mon, 17 Aug 2020 07:01:44 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id PJBQifA+N+WF; Mon, 17 Aug 2020 07:01:42 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D69364C063;
	Mon, 17 Aug 2020 07:01:42 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 32A7D4C060
 for <kvmarm@lists.cs.columbia.edu>; Mon, 17 Aug 2020 07:01:42 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id yUcp-909G0zR for <kvmarm@lists.cs.columbia.edu>;
 Mon, 17 Aug 2020 07:01:41 -0400 (EDT)
Received: from us-smtp-delivery-1.mimecast.com (us-smtp-1.mimecast.com
 [205.139.110.61])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id F2D2C4BFC4
 for <kvmarm@lists.cs.columbia.edu>; Mon, 17 Aug 2020 07:01:40 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1597662100;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=3uYWEtU1v+x3owbm1uS/RKQqHqnOSb1RHyYIEV1w3Jc=;
 b=O15QjaFSkjiYOzD2Qb+nBBYs6UyhvCW+FrVsM/O1QnR8C2Ap37ySA1D9TsDtxWFDYkwBAo
 qAAwYw2+O26eNfzE7lPNAPr2wgQZKC7OlKFWBMMN88PlbxIpql/JbmvqTm+p0ZUjrW0zd4
 taUSs6jdfoXnzAdCoxr9wELUJAuJKjE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-122-bciCgXZqPvujGmvBTkaw4w-1; Mon, 17 Aug 2020 07:01:33 -0400
X-MC-Unique: bciCgXZqPvujGmvBTkaw4w-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com
 [10.5.11.16])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7408280F040;
 Mon, 17 Aug 2020 11:01:32 +0000 (UTC)
Received: from [10.64.54.130] (vpn2-54-130.bne.redhat.com [10.64.54.130])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 8F2715C63E;
 Mon, 17 Aug 2020 11:01:26 +0000 (UTC)
Subject: Re: [PATCH 00/18] Support SDEI Virtualization
From: Gavin Shan <gshan@redhat.com>
To: kvmarm@lists.cs.columbia.edu
References: <20200817100531.83045-1-gshan@redhat.com>
Message-ID: <9e80380e-16cd-2a4f-0b6a-bc904b9d0999@redhat.com>
Date: Mon, 17 Aug 2020 21:01:23 +1000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <20200817100531.83045-1-gshan@redhat.com>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=gshan@redhat.com
X-Mimecast-Spam-Score: 0.003
X-Mimecast-Originator: redhat.com
Cc: maz@kernel.org, shan.gavin@gmail.com, pbonzini@redhat.com
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
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

On 8/17/20 8:05 PM, Gavin Shan wrote:
> This series intends to support SDEI virtualization. The background is
> the feature (Asynchronous Page Fault) needs virtualized SDEI event to
> deliver page-not-present notification from host to guest. This series
> depends on the series "Refactor SDEI Client Driver", which was posted
> previously. Both series can be found from github:
> 
>     https://developer.arm.com/documentation/den0054/a/
>     https://www.spinics.net/lists/arm-kernel/msg826783.html
>     https://github.com/gwshan/linux  ("sdei_client")
>     https://github.com/gwshan/linux  ("sdei")
> 
> First of all, bits[23:20] of the SDEI event number are reserved to
> indicate the SDEI event type:
> 
>     0x0: physical SDEI event number, originated from underly firmware
>     0x1: virtual SDEI event number, passed from KVM because of physical
>          SDEI event. The corresponding SDEI events are also called as
>          passthrou SDEI events.
>     0x2: KVM private SDEI event number, originated from KVM itself.
> 
> The implementation supports passthrou and KVM private SDEI events. The
> same SDEI event can be registered and enabled on multiple VMs. So the
> registered SDEI event is represented by "struct kvm_sdei_event" and
> formed into a linked list globally. "struct kvm_sdei_kvm_event" is
> created and inserted into the radix tree in "struct kvm_sdei_event",
> which is indexed by @kvm->userspace_pid if the corresponding SDEI event
> is registered on the particular KVM. Besides, "struct kvm_sdei_vcpu_event"
> is introduced to deliver SDEI event to one particular vCPU. So the data
> structs have different scopes, summaried as below:
> 
>     struct kvm_sdei_event: global scope
>     struct kvm_sdei_kvm_event: VM scope
>     struct kvm_sdei_vcpu_event: vCPU sope
> 
> For the passthrou SDEI events, the specific handler is registered to the
> underly firmware if it's supported. The core functionality of the handler
> is to route the incoming SDEI events to the target VM and vCPU. For the
> shared SDEI event, it's duplicated to all VMs where the SDEI event was
> registered and enabled. The target vCPU is chosen basing on the setting
> of routing affinity. For private SDEI event, the event received from the
> physical CPU is duplicated and delivered to the vCPUs, which are currently
> running or suspending on the physical CPU. For KVM private event, which is
> pre-defined and represented by "struct kvm_sdei_priv", API (kvm_sdei_inject())
> is always called to deliver the event to the specified vCPU.
> 
> The series is organized as below:
> 
> PATCH[01-02] Retrieve event signaled property on registration and add API
>               (sdei_event_get_info()) to retrieve event's information from
>               underly firmware for the passthrou SDEI events.
> PATCH[03]    Introduce template for smccc_get_argx().
> PATCH[04]    Adds the needed source files, data structs.
> PATCH[05-13] Support various hypercalls defined in SDEI specification (v1.0).
> PATCH[14]    Implements the SDEI handler to route the incoming passthrou SDEI
>               events to target VMs and vCPUs.
> PATCH[15-16] Support more hypercalls like COMPLETE, COMPLETE_AND_RESUME, and
>               CONTEXT.
> PATCH[17]    Support injecting KVM private SDEI event and expose the SDEI
>               capability.
> PATCH[18]    Add self-test case for KVM private SDEI event
> 

[+James/Mark/Eric]

The series was supposed to have been cc'ed to more folks, but the
"git send-email" didn't do it properly for me. I assume I needn't
resend it until I'm going to be asked for that explicitly.

Thanks,
Gavin

> Gavin Shan (18):
>    drivers/firmware/sdei: Retrieve event signaled property on
>      registration
>    drivers/firmware/sdei: Add sdei_event_get_info()
>    arm/smccc: Introduce template for inline functions
>    arm64/kvm: Add SDEI virtualization infrastructure
>    arm64/kvm: Support SDEI_1_0_FN_SDEI_VERSION hypercall
>    arm64/kvm: Support SDEI_1_0_FN_SDEI_EVENT_REGISTER
>    arm64/kvm: Support SDEI_1_0_FN_SDEI_EVENT_{ENABLE, DISABLE} hypercall
>    arm64/kvm: Support SDEI_1_0_FN_SDEI_EVENT_UNREGISTER hypercall
>    arm64/kvm: Support SDEI_1_0_FN_SDEI_EVENT_STATUS hypercall
>    arm64/kvm: Support SDEI_1_0_FN_SDEI_EVENT_GET_INFO hypercall
>    arm64/kvm: Support SDEI_1_0_FN_SDEI_EVENT_ROUTING_SET hypercall
>    arm64/kvm: Support SDEI_1_0_FN_SDEI_PE_{MASK, UNMASK} hypercall
>    arm64/kvm: Support SDEI_1_0_FN_SDEI_{PRIVATE,SHARED}_RESET hypercall
>    arm64/kvm: Implement event handler
>    arm64/kvm: Support SDEI_1_0_FN_SDEI_EVENT_{COMPLETE,
>      COMPLETE_AND_RESUME} hypercall
>    arm64/kvm: Support SDEI_1_0_FN_SDEI_EVENT_CONTEXT hypercall
>    arm64/kvm: Expose SDEI capability
>    kvm/selftests: Add SDEI test case
> 
>   arch/arm64/include/asm/kvm_emulate.h       |    2 +
>   arch/arm64/include/asm/kvm_host.h          |   10 +
>   arch/arm64/include/asm/kvm_sdei.h          |  117 ++
>   arch/arm64/kvm/Makefile                    |    2 +-
>   arch/arm64/kvm/aarch32.c                   |    8 +
>   arch/arm64/kvm/arm.c                       |   19 +
>   arch/arm64/kvm/hypercalls.c                |   19 +
>   arch/arm64/kvm/inject_fault.c              |   30 +
>   arch/arm64/kvm/reset.c                     |    3 +
>   arch/arm64/kvm/sdei.c                      | 1322 ++++++++++++++++++++
>   drivers/firmware/arm_sdei.c                |   38 +
>   include/kvm/arm_hypercalls.h               |   34 +-
>   include/linux/arm_sdei.h                   |    7 +
>   include/uapi/linux/kvm.h                   |    4 +
>   tools/testing/selftests/kvm/Makefile       |    1 +
>   tools/testing/selftests/kvm/aarch64/sdei.c |  170 +++
>   16 files changed, 1766 insertions(+), 20 deletions(-)
>   create mode 100644 arch/arm64/include/asm/kvm_sdei.h
>   create mode 100644 arch/arm64/kvm/sdei.c
>   create mode 100644 tools/testing/selftests/kvm/aarch64/sdei.c
> 

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
