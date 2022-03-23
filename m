Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA14BC433F5
	for <kvmarm@archiver.kernel.org>; Wed, 23 Mar 2022 17:11:29 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2456149EEF;
	Wed, 23 Mar 2022 13:11:29 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 46xm77AdWACQ; Wed, 23 Mar 2022 13:11:27 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DB2C649EF3;
	Wed, 23 Mar 2022 13:11:27 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6AF7349EE2
 for <kvmarm@lists.cs.columbia.edu>; Wed, 23 Mar 2022 13:11:27 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ufJMSEwjweW6 for <kvmarm@lists.cs.columbia.edu>;
 Wed, 23 Mar 2022 13:11:26 -0400 (EDT)
Received: from mail-io1-f53.google.com (mail-io1-f53.google.com
 [209.85.166.53])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 5ECDC48F9C
 for <kvmarm@lists.cs.columbia.edu>; Wed, 23 Mar 2022 13:11:26 -0400 (EDT)
Received: by mail-io1-f53.google.com with SMTP id w7so2460189ioj.5
 for <kvmarm@lists.cs.columbia.edu>; Wed, 23 Mar 2022 10:11:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=CJcX+FxfEaq/uuvyNw1S0dCzP3seuy40H9PTEBUtNog=;
 b=fXE+Kpe5mhnSbe/ssGX6libNH578T7NVZN12czfPzITa139jE0x1ySGcfvG+WKJjTi
 d3LHju2WyVXWJ2SytyErBrbsQgim8wyCLw+KogL1nV1VAceywJnBvg4MZRHblXA/Vw7A
 ZPoJNjse+tY7jHR0vXSljSWIkqiAUXs+rKI5+Ye+eiflCFhTuEdZigb1PKXsQTcqoesi
 IjGYxpfZYCThIhQ6ySoJqBXZGN8/Igu5f5soFBBe5sg3gHrk28RSHWmtQqhKnH7wNKSg
 YnEiaqEpvHzsYlk6AsBxyC/fSm3MV+McLzjUYT7jbxINXTt0Fd6SMCvjfhFaG1YKRSlU
 jmGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=CJcX+FxfEaq/uuvyNw1S0dCzP3seuy40H9PTEBUtNog=;
 b=HvgqVjujLc9JNvZucAscIy2DCz6OH/FEjpNrSLagFgoYGq2aJqAgRq9trP8eoxob1A
 UsTOpOHOQoQNfr0o+UzDjHu6k+3h9t+Pfp3WMdWzgD5smPa/rXMrLdaUCmhGS5c0iDFe
 SI0nbHgdaCd5v7c0WwM+sUmGpTytLY4XDthUONpf+U9NRasH+m0R3gMyPppQdwQfFVKV
 WBluWKKYPDJvbNF95Hl2dElAv5PysZr1sU+J0oAzjgeqPXnkUZuLDGaKvtbzyM+fkwLs
 p6TMdrQ24Gek93xhyLElGCF6+6mcsAcPpM4GZXpTyswV1GiVczSG77Sf5NBXXtB8KV2H
 7TlQ==
X-Gm-Message-State: AOAM53374XVCq7hisyrL8pFSTM3xS8Ank33i28LCPBC4z0EOhGJCIP6j
 tMKguSq+uu4AKrwbhHodN5LlDA==
X-Google-Smtp-Source: ABdhPJwZ1i6jce/UGoZtD6TdoDDyrgcMcbsRlWhHkHftWonzln3+byrRitd4L+UzDPjYxXM296EnIg==
X-Received: by 2002:a05:6638:34a3:b0:321:3908:3224 with SMTP id
 t35-20020a05663834a300b0032139083224mr472421jal.75.1648055485420; 
 Wed, 23 Mar 2022 10:11:25 -0700 (PDT)
Received: from google.com (194.225.68.34.bc.googleusercontent.com.
 [34.68.225.194]) by smtp.gmail.com with ESMTPSA id
 t11-20020a922c0b000000b002c85834eb06sm256878ile.47.2022.03.23.10.11.24
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Wed, 23 Mar 2022 10:11:24 -0700 (PDT)
Date: Wed, 23 Mar 2022 17:11:21 +0000
From: Oliver Upton <oupton@google.com>
To: Gavin Shan <gshan@redhat.com>
Subject: Re: [PATCH v5 02/22] KVM: arm64: Add SDEI virtualization
 infrastructure
Message-ID: <YjtUufdsWYxqdGa+@google.com>
References: <20220322080710.51727-1-gshan@redhat.com>
 <20220322080710.51727-3-gshan@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20220322080710.51727-3-gshan@redhat.com>
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

Hi Gavin,

More comments, didn't see exactly how all of these structures are
getting used.

On Tue, Mar 22, 2022 at 04:06:50PM +0800, Gavin Shan wrote:

[...]

> diff --git a/arch/arm64/include/uapi/asm/kvm_sdei_state.h b/arch/arm64/include/uapi/asm/kvm_sdei_state.h
> new file mode 100644
> index 000000000000..b14844230117
> --- /dev/null
> +++ b/arch/arm64/include/uapi/asm/kvm_sdei_state.h
> @@ -0,0 +1,72 @@
> +/* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
> +/*
> + * Definitions of various KVM SDEI event states.
> + *
> + * Copyright (C) 2022 Red Hat, Inc.
> + *
> + * Author(s): Gavin Shan <gshan@redhat.com>
> + */
> +
> +#ifndef _UAPI__ASM_KVM_SDEI_STATE_H
> +#define _UAPI__ASM_KVM_SDEI_STATE_H
> +
> +#ifndef __ASSEMBLY__
> +#include <linux/types.h>
> +
> +/*
> + * The software signaled event is the default one, which is
> + * defined in v1.1 specification.
> + */
> +#define KVM_SDEI_INVALID_EVENT	0xFFFFFFFF

Isn't the constraint that bit 31 must be zero? (DEN 0054C 4.4 "Event
number allocation")

> +#define KVM_SDEI_DEFAULT_EVENT	0
> +
> +#define KVM_SDEI_MAX_VCPUS	512	/* Aligned to 64 */
> +#define KVM_SDEI_MAX_EVENTS	128

I would *strongly* recommend against having these limits. I find the
vCPU limit especially concerning, because we're making KVM_MAX_VCPUS
ABI, which it definitely is not. Anything that deals with a vCPU should
be accessed through a vCPU FD (and thus agnostic to the maximum number
of vCPUs) to avoid such a complication.

> +struct kvm_sdei_exposed_event_state {
> +	__u64	num;
> +
> +	__u8	type;
> +	__u8	signaled;
> +	__u8	priority;
> +	__u8	padding[5];
> +	__u64	notifier;

Wait, isn't this a kernel function pointer!?

> +};
> +
> +struct kvm_sdei_registered_event_state {

You should fold these fields together with kvm_sdei_exposed_event_state
into a single 'kvm_sdei_event' structure:

> +	__u64	num;
> +
> +	__u8	route_mode;
> +	__u8	padding[3];
> +	__u64	route_affinity;

And these shouldn't be UAPI at the VM scope. Each of these properties
could be accessed via a synthetic/'pseudo-firmware' register on a vCPU FD:

> +	__u64	ep_address[KVM_SDEI_MAX_VCPUS];
> +	__u64	ep_arg[KVM_SDEI_MAX_VCPUS];
> +	__u64	registered[KVM_SDEI_MAX_VCPUS/64];
> +	__u64	enabled[KVM_SDEI_MAX_VCPUS/64];
> +	__u64	unregister_pending[KVM_SDEI_MAX_VCPUS/64];
> +};
> +
> +struct kvm_sdei_vcpu_event_state {
> +	__u64	num;
> +
> +	__u32	event_count;
> +	__u32	padding;
> +};
> +
> +struct kvm_sdei_vcpu_regs_state {
> +	__u64	regs[18];
> +	__u64	pc;
> +	__u64	pstate;
> +};
> +
> +struct kvm_sdei_vcpu_state {

Same goes here, I strongly recommend you try to expose this through the
KVM_{GET,SET}_ONE_REG interface if at all possible since it
significantly reduces the UAPI burden, both on KVM to maintain it and
VMMs to actually use it.

--
Thanks,
Oliver
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
