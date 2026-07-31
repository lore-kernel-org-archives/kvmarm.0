Received: from mail-pj1-f42.google.com (mail-pj1-f42.google.com [209.85.216.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE6173CE0AE
	for <kvmarm@lists.linux.dev>; Fri, 31 Jul 2026 17:26:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.216.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785518803; cv=pass; b=KKjPk8Biz8/ymAUURZ4lWqzgcSB1cqsUEz4s5dKLYIazn/ScleIDCANBVZDCtt9z4K4Ltu3MoZsUD99hle/Z+Tfr/nZCcn/WxTdlFZ0q0XekcjZSdewk8N9XWSki/+KUjkHLm26H1cMQnOsrgMxJWa7CbbLrxRLb1VrC15sKBVs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785518803; c=relaxed/simple;
	bh=X4792Aigg/BOY4KD4MEeZul7W4licntW0neZsmPslxg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=XCx6viFosx1cIjcIm/Wfxu/Zhc7QlJjWcbWGQwDFVKa+krlHXldvktrhthQTKYmQ8Ts6jhsEhSvMKaEyc1MA3zOLTaiHmPo8l7gdF+ncJa/9CpSpawr0+twkmrgr6j7oDgypspkFCDxEsRuzYuEVfHRuZ5FRroOHkbgdhie4xJU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=E5oRvgT8; arc=pass smtp.client-ip=209.85.216.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="E5oRvgT8"
Received: by mail-pj1-f42.google.com with SMTP id 98e67ed59e1d1-38e7109321dso780886a91.3
        for <kvmarm@lists.linux.dev>; Fri, 31 Jul 2026 10:26:41 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1785518801; cv=none;
        d=google.com; s=arc-20260327;
        b=dRGzwhvVLcwk0JM1mWUe6tOs00OGUiwGfa98xrEd08pCG0Zp9F2SeiAb8FxXtpYF/h
         o/k7TXFkfoPAL46k+UMBfl1Co5tY2mr2L2KENpfm3yOH3V0zUdKN8QRNWgNxkQB6p/Pm
         zVrnbM8/r7tFHiP6ICkIpjLAUgbjWNEE3Nfqr0ZqyqHTqmTvEMGIEJ3GCEMjkwpW6XoX
         P8acsBYHWTlHKFCRasOFQ0ce6GdQ0T0j3IOPP/CyHDI7uiaplQY2cJvAyvB1zjV/bsNP
         ZAXYfOTmTEu9YJORSO/j4RCBosxfYR/SiZQLsmTR7DM4rj+DAHzRieAKQqDPOUQbJFLX
         WoLQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=+3rNBeKU8MTN+nzJsN5sxlgmXpPEyoDa9WMGQRUo5Cc=;
        fh=mk7aZt80hmmvjqwHG5dRhR4co1uvcPwh/yogbtoIPR8=;
        b=nwdZxNl2JYYXn3dGjXR0DAAqhDH8OVbKW7DKgS8F4urh53Bg3TgQjq8G1su+9BDQY5
         uK4i1IDs3NayF1hHlXMK1IKSJFnzVBjeSS71hvhOfdMW9UeTf07z2XvpLB3hd3dK8xoT
         xWjK5poASycJo1bOmmyOfDnWNV6YVCUmUnH8g/coUAwseQnn6TfKdK2iLc2d28mW3YGc
         lGBJjBZ9PFNOgR7fl5I6AmDIxyjRbwN6RvMbQe60+0PxF6zWNIJ5+dzZKVk5U9bfaDp/
         VXr/+uOtGK9VVuDXyToqRWPnSost9pdUWsFfawuRRkZ0W4ItAw0hKouayaLFKcfEBl2W
         h6fg==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1785518801; x=1786123601; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=+3rNBeKU8MTN+nzJsN5sxlgmXpPEyoDa9WMGQRUo5Cc=;
        b=E5oRvgT83CE4FlE7/+Ai1tvYDgnerVqMyJaCNSnesGMiuo0E6CWO8yTMRmno/GOv+/
         kUc9Sbk3L2BSifuCnu7+xa2UeCgsT4IqOTJlckVK7fzG2MUA9qyqXPG8XOWBxy4k7+iP
         KvuzY4sG/K3HA+FOlAqkRyjV/M7MGWqkHQyWJy97sTNFRDEp66fhd6QntOOAzOXDg5D9
         jpRsYzUDWuMuV8hOu2AXmneFyRHdF2Sr/3DmT2UM+fKPJZ8z4EbPZ3bs4365PVH2K+Fy
         g2rqAmBqJGmuThLIeW6sUHVk1sfpCG+/lpGV0dJRB2LCnFwM5ZAXW8DSpZfzGW1bwgny
         xDrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785518801; x=1786123601;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=+3rNBeKU8MTN+nzJsN5sxlgmXpPEyoDa9WMGQRUo5Cc=;
        b=TQ1fGKlwp+lm2pgY1B/s46BgYgVOYMQ7w4z0/wFPNHDcY1sFldjF7vKd7tNhf/fTWp
         nfT14cx7YNYIKq1QzVtvGnJ4XNWcDPxM2O2rjiNrKHmgy0CEblfsYz7/CC0xGLoV9jv+
         VPfKnMzOkxrjpFfECzNfLPgddqNL5a0Qb59jJXR3TGn8Syp7kBRWieB7ZpD9t4iIA6xY
         EKpLqs2Hv9gOySlOwXpxiknvaAOymqJrndfbY7Pg1nsB2dsrq2Hmphlx0QZgZJd7IJcu
         hF1QPo85EVRLmD16Sg2ginYm6LouH1OYLAdo/YVNjqtKPb74955fgOfcGl94wH9J7hUd
         x0uw==
X-Forwarded-Encrypted: i=1; AHgh+Roe/4RHudCYKL+69jmqESQ9uYWuubFJKk14OYYwjwHVP8L/kpcONgmiNkGNUR2oYctpz7SlIIM=@lists.linux.dev
X-Gm-Message-State: AOJu0YzU+oqUCP9bk06tQqyIsQC21AFFx7IoZAVw6VjUNeony80vVjIg
	ikvXzb2MuM2QgfK/hVwtprKbe4UGcPqbYPUdy01oxJPIsljj3xKaTc1np0BfVdM+gDcwmxSPcSA
	Di4kh6QCK8UzC6bh7BYSXmVTzuRruJvYO/pXT1NoO
X-Gm-Gg: AR+sD10naiuAnd5A2vs/poY4lpNt/sTgdvJudzp/SGO/6DtcSyKEKjlv70Ljnc9WxDj
	JBJnU4kmFXkz716dLlH7Q8/TGn6X9nxqCfPzpTB4K0PTaT65jER6+SQ4BXDAP7O/DwVfJ3ypzm9
	70RVU8o654nW69zUIInPXJOsO0K+S/NFzEuod/U2Up9H3wNpVExiuaXSHmyacCvga3g3QkCEo6S
	3V+PQpVXhD74XR3EVF47D7+w2YV6KSRl/YtfctrSkWmhI4y0P44cb9yPO7Vy3O7xIiDb//P21/2
	tsslFsi62OVMS6wtsGfUGW4PqDbQUHO2pkcC4KJ0OM+/CUUEtwziyAXSxa+jCDaNDnkLpwizcZv
	pjA==
X-Received: by 2002:a17:90b:1cce:b0:38f:5801:eaf7 with SMTP id
 98e67ed59e1d1-38fbc4d9783mr700918a91.27.1785518800414; Fri, 31 Jul 2026
 10:26:40 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260717162658.2833515-1-jingzhangos@google.com> <amh6OLH38hsO7ZWj@google.com>
In-Reply-To: <amh6OLH38hsO7ZWj@google.com>
From: Jing Zhang <jingzhangos@google.com>
Date: Fri, 31 Jul 2026 10:26:26 -0700
X-Gm-Features: AUfX_my779N_TSO9oAqhRppJLMpuwmchcAEvjMAezX5thEPKSAoF-3OwKVIGiVs
Message-ID: <CAAdAUtjrnNe1Kn2_Fqtjy6igEEca-6Zd=SSbncswZtnA5FngPA@mail.gmail.com>
Subject: Re: [RFC] KVM: Proposed uAPI for querying GSI and irqbypass status
To: Mostafa Saleh <smostafa@google.com>
Cc: KVM <kvm@vger.kernel.org>, KVMARM <kvmarm@lists.linux.dev>, 
	Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, Joey Gouly <joey.gouly@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>, 
	Mingwei Zhang <mizhang@google.com>, David Matlack <dmatlack@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Jul 28, 2026 at 2:45=E2=80=AFAM Mostafa Saleh <smostafa@google.com>=
 wrote:
>
> Hi Jing,
>
> On Fri, Jul 17, 2026 at 09:26:57AM -0700, Jing Zhang wrote:
> > This RFC proposes a new KVM uAPI to allow a VMM to programmatically
> > query the status of a GSI, with a particular focus on determining
> > the success or failure of Irqbypass.
> >
> >
> > 1. Motivation
> >
> > The primary motivation for this uAPI is to bridge the operational gap
> > between the VMM and KVM at the kernel level regarding interrupt
> > virtualization status:
> >
> > * KVM (Kernel) holds the precise, live runtime status of each GSI (such
> >   as whether Irqbypass is active, pending, or has encountered a setup
> >   error). However, it completely lacks the high-level semantic details
> >   of those GSIs=E2=80=94it does not understand which logical function o=
r
> >   physical hardware device they represent.
> >
> > * The VMM (Userspace) possesses the complete context of the guest's
> >   interrupt topology. It knows exactly which GSI belongs to which
> >   passthrough or emulated device because it orchestrated the setup.
> >   Yet, the VMM has no stable, programmatic way to query the actual
> >   runtime execution status of these GSIs once passed to the kernel.
> >
> > Currently, diagnosing when a high-performance interrupt path falls
> > back to software mediation is highly problematic:
> >
> > * While some architectures (like ARM64) expose virtual ITS states via
> >   debugfs, this implementation is highly architecture-specific and
> >   fragile.
> >
> > * debugfs is not a stable API, is prone to breaking changes across
> >   kernel versions, and is entirely unsuitable for programmatic
> >   production monitoring and fleet-wide observability.
> >
> > This is not an ARM-specific problem; it is a general, cross-architectur=
e
> > limitation within KVM's Irqbypass and interrupt routing subsystem.
> > By introducing an architecture-neutral uAPI, we allow the VMM to
> > marry its topological knowledge with KVM's live execution state.
> >
>
> I am trying to understand the benefit of introducing an new uAPI for
> this. I have been using irqbypass with arm64, and I would debug
> performance problems solely based on /proc/interrutps.
>
> On the host side you see a vector per interrupt and a new vector per
> vcpu for the doorbell interrupt in case the vcpu was not scheduled.
>
> Based on that I can tell if irqbypass was active or not, and in case
> I have /proc/interrupts from the guest, I can get a percentage of
> the fallback software path per-VM.
>
> A uAPI will not give much extra info, see my comment below.
>
> [...]
>
> >
> >
> > /* To be included in <linux/kvm.h> */
> >
> > /*
> >  * KVM_GET_GSI_STATE: Get the status of a specific GSI.
> >  *
> >  * The user passes a pointer to struct kvm_gsi_state. The kernel fills =
in
> >  * the status flags, performance counters, and the architecture-specifi=
c
> >  * union members directly.
> >  */
> >
> > /* Generic flags indicating high-level status */
> >
> > /*
> >  * The GSI's route is theoretically compatible with hardware bypass
> >  * on this host (e.g. is an MSI route and GICv4/VT-d is present).
> >  */
> > #define KVM_GSI_STATE_FLAG_BYPASSABLE      (1 << 0)
> >
> > /* An IRQFD is currently active and bound to this GSI */
> > #define KVM_GSI_STATE_FLAG_HAS_IRQFD       (1 << 1)
> >
> > /* The irqbypass path is fully enabled and active in hardware */
> > #define KVM_GSI_STATE_FLAG_BYPASS_ACTIVE   (1 << 2)
> >
> > /* Example architecture-specific failure reasons for ARM64 */
> > #define KVM_ARM_GSI_FAILURE_REASON_NONE             0
> > #define KVM_ARM_GSI_FAILURE_REASON_NO_ITS           1 /* No ITS/GICv4 s=
upport */
> > #define KVM_ARM_GSI_FAILURE_REASON_NO_MSI_ADDR      2 /* MSI address un=
set */
> > #define KVM_ARM_GSI_FAILURE_REASON_GIC_HW_REJECT    3 /* GIC rejected m=
ap */
> > #define KVM_ARM_GSI_FAILURE_REASON_INVALID_STATE    4 /* Guest state bl=
ock */
> >
> > struct kvm_gsi_state {
> >     __u32 gsi;              /* IN: The GSI to query */
> >     __u32 flags;            /* OUT: High-level status flags */
> >     __u64 counter_success;  /* OUT: Generic counter for successful bypa=
ss */
>
> I do not think that is possible on arm64, the host does not know
> about the interrupts directly injected to the guest, so it can not
> maitain such a counter.
>
> Thanks,
> Mostafa
>

Hi Mostafa,

Thank you for taking the time to review this RFC and for your valuable feed=
back.

To clarify the primary motivation here: the goal of this new uAPI is
to enable programmatic, stable, and fine-grained monitoring of
interrupt bypass status in production environments, where existing
mechanisms like debugfs are simply not viable.

Here are a few key reasons why we believe a dedicated uAPI/ioctl is
necessary rather than relying on debugfs:
1. Production Hardening and Access Restrictions: In many hardened
production or cloud environments, debugfs is completely disabled
(CONFIG_DEBUG_FS=3Dn), unmounted, or heavily restricted due to security
and performance overhead concerns. Relying on it means the Virtual
Machine Monitor (VMM) loses all visibility into interrupt performance
regressions in the very environment where monitoring matters most.
2. Lack of ABI Stability: As you know, debugfs makes no ABI stability
guarantees. Its output format can change between kernel versions
without notice. Basing production monitoring and telemetry pipelines
on scraping debugfs is fragile and prone to breaking during kernel
upgrades.
3. Programmatic Efficiency: Scraping and parsing text files from
userspace is inefficient for high-frequency or fleet-wide monitoring.
A binary ioctl interface (KVM_GET_GSI_STATE) provides a lightweight,
deterministic, and highly scalable way for the VMM to query state on
demand.
4. Marrying Topology with Live State: KVM holds the runtime status of
the bypass, but only userspace (the VMM) understands the full topology
(i.e., which GSI belongs to which passthrough device). This uAPI
allows the VMM to programmatically marry its topological knowledge
with KVM's live execution state without relying on side-band manual
debugging tools.

While interfaces in debugfs are fantastic for manual, retroactive
debugging on a developer workstation, they are not Dependable for
fleet-wide observability. This RFC aims to provide a proactive
monitoring solution that aligns KVM with production operational
requirements across architectures (both ARM and x86).

Would love to hear your thoughts on this perspective.

Thanks,
Jing
