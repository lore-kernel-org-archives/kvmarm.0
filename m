Received: from mail-ed1-f48.google.com (mail-ed1-f48.google.com [209.85.208.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 101FB3C457A
	for <kvmarm@lists.linux.dev>; Tue, 28 Jul 2026 09:45:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785231937; cv=none; b=Qe4BMngo5nSLaWvNSsAxPiksuKjaVt4RbdUIf8zvUvgouYtSMihXnnZ5L/T6DWRiX4NAlSUx6HbgXXgaxB8KaZGT+9imfSXzlfej/pH7ue7P9+8aRAUlS4HV81Z1Obc6xA0jDm1PyFa+J25cgAKyudOYCmH5PJlN4Gvt0o3n7LM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785231937; c=relaxed/simple;
	bh=4ncCwLHbd0y5QmKrVWBk/lqxfcoLzBZt8Gojr8StP2M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZAwF7fQGHLmFp5xBWOSZiLFH/oHJN1fd4PBi32kE7BHHK48731figglNP7WjTRxmgcjVJDF3KZajKzajb/08mq4P/LPCby9POs5imBMfhpa/KYtR+1hBEPVkX5snimqtMo/JW4svQdBpbiO5JfDLZQ2WVdyrdD5AGZKJzY0bxmA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=nR4NU9Y+; arc=none smtp.client-ip=209.85.208.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="nR4NU9Y+"
Received: by mail-ed1-f48.google.com with SMTP id 4fb4d7f45d1cf-698b78c05b0so6686a12.1
        for <kvmarm@lists.linux.dev>; Tue, 28 Jul 2026 02:45:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1785231934; x=1785836734; darn=lists.linux.dev;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=f86kYd5ZgAbyf9BSKP0yMuigLiXeU1iriKpHpan/dmc=;
        b=nR4NU9Y+BD6YXjUhwKXxj9tEs1oQnnITK5IcyYlVx6duCF2BX497BwxXtlUEVMOYIO
         QuGxMcAA247KuU5g1Rk2PvXGiLxR5W/ZhsgnRwuQuzxaICKCNXLCB5Qz7lMvDDHEjqz8
         K7SeoWqRx1j8vaAZODUFuvu8bSJ8VDd4zBJ2f7hvVCqk1PMETQvhDt+EnvNQMvmeig+8
         +6MVB3qSFc4Klot9q+RW1q8Z2PQCEzMPNUUMiqydpMuUHqzKgrA2EzwQoK6XmJHmOQBw
         eYKDC/kVccL3L/XBUxWA7c2E/GRPpV5gFQL8kM9Un+cLRs/GLSEdGdNVpUq7L1CEsPss
         D47Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785231934; x=1785836734;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=f86kYd5ZgAbyf9BSKP0yMuigLiXeU1iriKpHpan/dmc=;
        b=CjXWQjKcX9q+AYNDO525LqmwNszTOx6GoPKnHq4gqp6m8QBEcO3oGu9Cs2/OrOszBU
         f2LXdzItZD0vmqeJE02jI5Tkr3fcfLPabY1OG11sLoGNRGdFcWHE4oAzFDIzWQFnFmWZ
         s3GMRPsfrrInErzVlXWdzOhuDymL7DBXftzsYzXwxNWlDVK3vrv+tH8XhFlDTp79c5Xv
         kfneXLqdrTwVYhgdm1MKvBFEPp44qX+BxGSKKfg4MRF1YGuCQ3qBt2Dqt678DGJUIzhd
         J0j2Bhhc9b6uxjFbcVx7I5So3bFFhvvqUBP3pDIHKQJjTYJj78Z1eZMmoNCLHelFZXlB
         7ePg==
X-Forwarded-Encrypted: i=1; AHgh+RpUgmMDQb4UBd93CjIAqlqJtlegddPfmUxFCd3NVUdp/XdZeBGJXACuWzo0eCSJc4Xxikpb1lU=@lists.linux.dev
X-Gm-Message-State: AOJu0YwqHEQfiJdgU5U8yaP0g6KORsqZbAatzjXD5qOx/OxsXUqu+g5G
	xlwMPCXBstORs7TF2IuTCb4yvJCwh3eTx2D4nSw6gennDuXn3a12v9DSiF+6/I+gEw==
X-Gm-Gg: AR+sD12L9RqDNWX3rrFme+mSUJRtUhuttulgJedzy3MJPuJZfdViAj+Ta9NU4pAY79H
	gVTsgrs/IIfhlCLd6pJ4Aq1GWq4r6DFSRMJu00XEtrnfRXVuLBryRfwcgWSJZFfnusHZhVJWbw5
	hHrO0yh+NcU/bnbzvfDmu5uh2Vo76YmfJT+v1Ld6ycTWvl6Y60N7NiTSXSj+z6xew6dKazLlD9j
	m91YeQ9xe6XsOIYcmWxG6TK+cn2QtJwgJ7IoT0d75WaUqwLHETZBOvUDm8B8XqDAfhxFrZZrvuo
	BCEWdOxcOyhiqyLZGsp7UPQZfBEbWqEYXrNDSsnNTQlUxn1WwOl6SCJLXJHIQKMvK1jERExB8cD
	L6HFCJeIP8arcOMhyvzocdbemu2QfV4xnHiYVoUCW2RbfnMZsMgnZnVvRdIfPAqxGwNCLGz0wuq
	QQCal+e5sdnvc5njPeete6ZI0eRPouV0UHn7TSWGqDPxQ=
X-Received: by 2002:a05:6402:a153:b0:69f:d4ca:3c8c with SMTP id 4fb4d7f45d1cf-69fd4ca41d5mr127144a12.6.1785231933541;
        Tue, 28 Jul 2026 02:45:33 -0700 (PDT)
Received: from google.com (250.192.189.35.bc.googleusercontent.com. [35.189.192.250])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c1c32ac7eacsm746420066b.17.2026.07.28.02.45.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Jul 2026 02:45:32 -0700 (PDT)
Date: Tue, 28 Jul 2026 09:45:28 +0000
From: Mostafa Saleh <smostafa@google.com>
To: Jing Zhang <jingzhangos@google.com>
Cc: KVM <kvm@vger.kernel.org>, KVMARM <kvmarm@lists.linux.dev>,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	Mingwei Zhang <mizhang@google.com>,
	David Matlack <dmatlack@google.com>
Subject: Re: [RFC] KVM: Proposed uAPI for querying GSI and irqbypass status
Message-ID: <amh6OLH38hsO7ZWj@google.com>
References: <20260717162658.2833515-1-jingzhangos@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260717162658.2833515-1-jingzhangos@google.com>

Hi Jing,

On Fri, Jul 17, 2026 at 09:26:57AM -0700, Jing Zhang wrote:
> This RFC proposes a new KVM uAPI to allow a VMM to programmatically
> query the status of a GSI, with a particular focus on determining
> the success or failure of Irqbypass.
> 
> 
> 1. Motivation
> 
> The primary motivation for this uAPI is to bridge the operational gap
> between the VMM and KVM at the kernel level regarding interrupt
> virtualization status:
> 
> * KVM (Kernel) holds the precise, live runtime status of each GSI (such
>   as whether Irqbypass is active, pending, or has encountered a setup
>   error). However, it completely lacks the high-level semantic details
>   of those GSIs—it does not understand which logical function or
>   physical hardware device they represent.
> 
> * The VMM (Userspace) possesses the complete context of the guest's
>   interrupt topology. It knows exactly which GSI belongs to which
>   passthrough or emulated device because it orchestrated the setup.
>   Yet, the VMM has no stable, programmatic way to query the actual
>   runtime execution status of these GSIs once passed to the kernel.
> 
> Currently, diagnosing when a high-performance interrupt path falls
> back to software mediation is highly problematic:
> 
> * While some architectures (like ARM64) expose virtual ITS states via
>   debugfs, this implementation is highly architecture-specific and
>   fragile.
> 
> * debugfs is not a stable API, is prone to breaking changes across
>   kernel versions, and is entirely unsuitable for programmatic
>   production monitoring and fleet-wide observability.
> 
> This is not an ARM-specific problem; it is a general, cross-architecture
> limitation within KVM's Irqbypass and interrupt routing subsystem.
> By introducing an architecture-neutral uAPI, we allow the VMM to
> marry its topological knowledge with KVM's live execution state.
> 

I am trying to understand the benefit of introducing an new uAPI for
this. I have been using irqbypass with arm64, and I would debug
performance problems solely based on /proc/interrutps.

On the host side you see a vector per interrupt and a new vector per
vcpu for the doorbell interrupt in case the vcpu was not scheduled.

Based on that I can tell if irqbypass was active or not, and in case
I have /proc/interrupts from the guest, I can get a percentage of
the fallback software path per-VM.

A uAPI will not give much extra info, see my comment below.

[...]

> 
> 
> /* To be included in <linux/kvm.h> */
> 
> /*
>  * KVM_GET_GSI_STATE: Get the status of a specific GSI.
>  *
>  * The user passes a pointer to struct kvm_gsi_state. The kernel fills in
>  * the status flags, performance counters, and the architecture-specific
>  * union members directly.
>  */
> 
> /* Generic flags indicating high-level status */
> 
> /*
>  * The GSI's route is theoretically compatible with hardware bypass
>  * on this host (e.g. is an MSI route and GICv4/VT-d is present).
>  */
> #define KVM_GSI_STATE_FLAG_BYPASSABLE      (1 << 0)
> 
> /* An IRQFD is currently active and bound to this GSI */
> #define KVM_GSI_STATE_FLAG_HAS_IRQFD       (1 << 1)
> 
> /* The irqbypass path is fully enabled and active in hardware */
> #define KVM_GSI_STATE_FLAG_BYPASS_ACTIVE   (1 << 2)
> 
> /* Example architecture-specific failure reasons for ARM64 */
> #define KVM_ARM_GSI_FAILURE_REASON_NONE             0
> #define KVM_ARM_GSI_FAILURE_REASON_NO_ITS           1 /* No ITS/GICv4 support */
> #define KVM_ARM_GSI_FAILURE_REASON_NO_MSI_ADDR      2 /* MSI address unset */
> #define KVM_ARM_GSI_FAILURE_REASON_GIC_HW_REJECT    3 /* GIC rejected map */
> #define KVM_ARM_GSI_FAILURE_REASON_INVALID_STATE    4 /* Guest state block */
> 
> struct kvm_gsi_state {
>     __u32 gsi;              /* IN: The GSI to query */
>     __u32 flags;            /* OUT: High-level status flags */
>     __u64 counter_success;  /* OUT: Generic counter for successful bypass */

I do not think that is possible on arm64, the host does not know
about the interrupts directly injected to the guest, so it can not
maitain such a counter.

Thanks,
Mostafa

