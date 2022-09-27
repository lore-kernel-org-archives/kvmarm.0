Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 76E10C32771
	for <kvmarm@archiver.kernel.org>; Tue, 27 Sep 2022 00:58:22 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 13F174B628;
	Mon, 26 Sep 2022 20:58:22 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id w1g3cfnxPysE; Mon, 26 Sep 2022 20:58:20 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D30B24B63E;
	Mon, 26 Sep 2022 20:58:20 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6235E4B628
 for <kvmarm@lists.cs.columbia.edu>; Mon, 26 Sep 2022 20:58:19 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id AAc5HTxgXWva for <kvmarm@lists.cs.columbia.edu>;
 Mon, 26 Sep 2022 20:58:18 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.129.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0C5AE4B20F
 for <kvmarm@lists.cs.columbia.edu>; Mon, 26 Sep 2022 20:58:17 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1664240297;
 h=from:from:reply-to:reply-to:subject:subject:date:date:
 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
 content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=Z0La6MdpiJe9Y2YZ/VyHkbJLNIQ7X1sn+a09BVwMZ8w=;
 b=ic/zJMnY6Mvl2FzZfRJMyABKSqpDWFZvID6iUqzxA8EOoPf395H+3pcKEwdhNLGQX00SyP
 woIJ2mcLiEOgfuqTfYtJx0hLVqhuTDnwn65cT2YULAm9F1YsTngYcY4c0M39hp20Xf33AK
 D4beHHH/P9DdWdlhdnhWLHLlPXDZfKY=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-371-lBxFEC4iPrixxpDr28VnzQ-1; Mon, 26 Sep 2022 20:58:16 -0400
X-MC-Unique: lBxFEC4iPrixxpDr28VnzQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
 [10.11.54.7])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A917F185A794;
 Tue, 27 Sep 2022 00:58:15 +0000 (UTC)
Received: from [10.64.54.143] (vpn2-54-143.bne.redhat.com [10.64.54.143])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 2C468140EBF4;
 Tue, 27 Sep 2022 00:58:09 +0000 (UTC)
Subject: Re: [PATCH v2 0/6] KVM: Fix dirty-ring ordering on weakly ordered
 architectures
To: Marc Zyngier <maz@kernel.org>, kvmarm@lists.cs.columbia.edu,
 kvm@vger.kernel.org
References: <20220926145120.27974-1-maz@kernel.org>
From: Gavin Shan <gshan@redhat.com>
Message-ID: <30b5f5e0-1b27-e218-c01f-ca3177d14998@redhat.com>
Date: Tue, 27 Sep 2022 10:58:07 +1000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <20220926145120.27974-1-maz@kernel.org>
Content-Language: en-US
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
Cc: will@kernel.org, catalin.marinas@arm.com, andrew.jones@linux.dev,
 shan.gavin@gmail.com, bgardon@google.com, dmatlack@google.com,
 pbonzini@redhat.com, zhenyzha@redhat.com, shuah@kernel.org
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
Reply-To: Gavin Shan <gshan@redhat.com>
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

On 9/27/22 12:51 AM, Marc Zyngier wrote:
> [Same distribution list as Gavin's dirty-ring on arm64 series]
> 
> This is an update on the initial series posted as [0].
> 
> As Gavin started posting patches enabling the dirty-ring infrastructure
> on arm64 [1], it quickly became apparent that the API was never intended
> to work on relaxed memory ordering architectures (owing to its x86
> origins).
> 
> This series tries to retrofit some ordering into the existing API by:
> 
> - relying on acquire/release semantics which are the default on x86,
>    but need to be explicit on arm64
> 
> - adding a new capability that indicate which flavor is supported, either
>    with explicit ordering (arm64) or both implicit and explicit (x86),
>    as suggested by Paolo at KVM Forum
> 
> - documenting the requirements for this new capability on weakly ordered
>    architectures
> 
> - updating the selftests to do the right thing
> 
> Ideally, this series should be a prefix of Gavin's, plus a small change
> to his series:
> 
> diff --git a/arch/arm64/kvm/Kconfig b/arch/arm64/kvm/Kconfig
> index 0309b2d0f2da..7785379c5048 100644
> --- a/arch/arm64/kvm/Kconfig
> +++ b/arch/arm64/kvm/Kconfig
> @@ -32,7 +32,7 @@ menuconfig KVM
>   	select KVM_VFIO
>   	select HAVE_KVM_EVENTFD
>   	select HAVE_KVM_IRQFD
> -	select HAVE_KVM_DIRTY_RING
> +	select HAVE_KVM_DIRTY_RING_ACQ_REL
>   	select HAVE_KVM_MSI
>   	select HAVE_KVM_IRQCHIP
>   	select HAVE_KVM_IRQ_ROUTING
> 
> This has been very lightly tested on an arm64 box with Gavin's v3 [2] series.
> 
> * From v1:
>    - Repainted the config symbols and new capability so that their
>      naming is more acceptable and causes less churn
>    - Fixed a couple of blunders as pointed out by Peter and Paolo
>    - Updated the documentation
> 
> [0] https://lore.kernel.org/r/20220922170133.2617189-1-maz@kernel.org
> [1] https://lore.kernel.org/lkml/YyiV%2Fl7O23aw5aaO@xz-m1.local/T/
> [2] https://lore.kernel.org/r/20220922003214.276736-1-gshan@redhat.com
> 
> Marc Zyngier (6):
>    KVM: Use acquire/release semantics when accessing dirty ring GFN state
>    KVM: Add KVM_CAP_DIRTY_LOG_RING_ACQ_REL capability and config option
>    KVM: x86: Select CONFIG_HAVE_KVM_DIRTY_RING_ACQ_REL
>    KVM: Document weakly ordered architecture requirements for dirty ring
>    KVM: selftests: dirty-log: Upgrade flag accesses to acquire/release
>      semantics
>    KVM: selftests: dirty-log: Use KVM_CAP_DIRTY_LOG_RING_ACQ_REL if
>      available
> 
>   Documentation/virt/kvm/api.rst               | 17 +++++++++++++++--
>   arch/x86/kvm/Kconfig                         |  3 ++-
>   include/uapi/linux/kvm.h                     |  1 +
>   tools/testing/selftests/kvm/dirty_log_test.c |  8 +++++---
>   tools/testing/selftests/kvm/lib/kvm_util.c   |  5 ++++-
>   virt/kvm/Kconfig                             | 14 ++++++++++++++
>   virt/kvm/dirty_ring.c                        |  4 ++--
>   virt/kvm/kvm_main.c                          |  9 ++++++++-
>   8 files changed, 51 insertions(+), 10 deletions(-)
> 

This series looks good to me.

Reviewed-by: Gavin Shan <gshan@redhat.com>

Thanks,
Gavin

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
