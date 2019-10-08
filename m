Return-Path: <SRS0=tYEe=YB=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=DKIM_ADSP_ALL,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F1D3DC4360C
	for <kvmarm@archiver.kernel.org>; Tue,  8 Oct 2019 12:03:25 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 70F3E2070B
	for <kvmarm@archiver.kernel.org>; Tue,  8 Oct 2019 12:03:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b="IEG2Ifp/"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 70F3E2070B
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BAC5E4A8C0;
	Tue,  8 Oct 2019 08:03:24 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@amazon.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 7cDk7oJf9xpl; Tue,  8 Oct 2019 08:03:23 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 548C64A8FC;
	Tue,  8 Oct 2019 08:03:23 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6B1894A8FB
 for <kvmarm@lists.cs.columbia.edu>; Tue,  8 Oct 2019 08:03:22 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id kKsNlcTxZzNv for <kvmarm@lists.cs.columbia.edu>;
 Tue,  8 Oct 2019 08:03:21 -0400 (EDT)
Received: from smtp-fw-4101.amazon.com (smtp-fw-4101.amazon.com [72.21.198.25])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 18DD74A8FA
 for <kvmarm@lists.cs.columbia.edu>; Tue,  8 Oct 2019 08:03:21 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
 t=1570536201; x=1602072201;
 h=subject:to:cc:references:from:message-id:date:
 mime-version:in-reply-to:content-transfer-encoding;
 bh=JQETfEn0m1dUGm0SaHQuznDQjERlffX5pdltVZpQyYA=;
 b=IEG2Ifp/wq9lGYO9NTb3vKbWuENCp+eqgeS376ORcANHID4h9XZY1wJF
 4lsqrcQ1VyJ9WWKVnTv5IZAJ7m/xFTJOeEVKxLd9dyt3Y/nyiHOwNRNrm
 3fz7tQQPL/eJ33vsae7voc7nuausiwmTBAeKQ+fITTBxtNBlEajoOWZzJ M=;
X-IronPort-AV: E=Sophos;i="5.67,270,1566864000"; d="scan'208";a="790658491"
Received: from iad6-co-svc-p1-lb1-vlan3.amazon.com (HELO
 email-inbound-relay-1d-5dd976cd.us-east-1.amazon.com) ([10.124.125.6])
 by smtp-border-fw-out-4101.iad4.amazon.com with ESMTP;
 08 Oct 2019 12:03:18 +0000
Received: from EX13MTAUWC001.ant.amazon.com
 (iad55-ws-svc-p15-lb9-vlan3.iad.amazon.com [10.40.159.166])
 by email-inbound-relay-1d-5dd976cd.us-east-1.amazon.com (Postfix) with ESMTPS
 id 7FFD8A24D4; Tue,  8 Oct 2019 12:03:15 +0000 (UTC)
Received: from EX13D20UWC001.ant.amazon.com (10.43.162.244) by
 EX13MTAUWC001.ant.amazon.com (10.43.162.135) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Tue, 8 Oct 2019 12:03:14 +0000
Received: from 38f9d3867b82.ant.amazon.com (10.43.162.30) by
 EX13D20UWC001.ant.amazon.com (10.43.162.244) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Tue, 8 Oct 2019 12:03:10 +0000
Subject: Re: [PATCH v2 2/2] KVM: arm/arm64: Allow user injection of external
 data aborts
To: Christoffer Dall <christoffer.dall@arm.com>, <kvmarm@lists.cs.columbia.edu>
References: <20191008093640.26519-1-christoffer.dall@arm.com>
 <20191008093640.26519-3-christoffer.dall@arm.com>
From: Alexander Graf <graf@amazon.com>
Message-ID: <2719f1b2-9e8e-3d70-f5f6-6de3228fa04b@amazon.com>
Date: Tue, 8 Oct 2019 14:03:07 +0200
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191008093640.26519-3-christoffer.dall@arm.com>
Content-Language: en-US
X-Originating-IP: [10.43.162.30]
X-ClientProxiedBy: EX13D21UWA003.ant.amazon.com (10.43.160.184) To
 EX13D20UWC001.ant.amazon.com (10.43.162.244)
Precedence: Bulk
Cc: =?UTF-8?Q?Daniel_P=2e_Berrang=c3=a9?= <berrange@redhat.com>,
 Marc Zyngier <maz@kernel.org>, Stefan Hajnoczi <stefanha@redhat.com>, Heinrich
 Schuchardt <xypron.glpk@gmx.de>, linux-arm-kernel@lists.infradead.org
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
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



On 08.10.19 11:36, Christoffer Dall wrote:
> In some scenarios, such as buggy guest or incorrect configuration of the
> VMM and firmware description data, userspace will detect a memory access
> to a portion of the IPA, which is not mapped to any MMIO region.
> 
> For this purpose, the appropriate action is to inject an external abort
> to the guest.  The kernel already has functionality to inject an
> external abort, but we need to wire up a signal from user space that
> lets user space tell the kernel to do this.
> 
> It turns out, we already have the set event functionality which we can
> perfectly reuse for this.
> 
> Signed-off-by: Christoffer Dall <christoffer.dall@arm.com>
> ---
>   Documentation/virt/kvm/api.txt    | 18 +++++++++++++++++-
>   arch/arm/include/uapi/asm/kvm.h   |  3 ++-
>   arch/arm/kvm/guest.c              |  3 +++
>   arch/arm64/include/uapi/asm/kvm.h |  3 ++-
>   arch/arm64/kvm/guest.c            |  3 +++
>   arch/arm64/kvm/inject_fault.c     |  4 ++--
>   include/uapi/linux/kvm.h          |  1 +
>   virt/kvm/arm/arm.c                |  1 +
>   8 files changed, 31 insertions(+), 5 deletions(-)
> 
> diff --git a/Documentation/virt/kvm/api.txt b/Documentation/virt/kvm/api.txt
> index 7403f15657c2..10ebe8cfda29 100644
> --- a/Documentation/virt/kvm/api.txt
> +++ b/Documentation/virt/kvm/api.txt
> @@ -968,6 +968,8 @@ The following bits are defined in the flags field:
>   
>   ARM/ARM64:
>   
> +User space may need to inject several types of events to the guest.
> +
>   If the guest accesses a device that is being emulated by the host kernel in
>   such a way that a real device would generate a physical SError, KVM may make
>   a virtual SError pending for that VCPU. This system error interrupt remains
> @@ -1002,12 +1004,26 @@ Specifying exception.has_esr on a system that does not support it will return
>   -EINVAL. Setting anything other than the lower 24bits of exception.serror_esr
>   will return -EINVAL.
>   
> +If the guest performed an access to I/O memory which could not be handled by
> +userspace, for example because of missing instruction syndrome decode
> +information or because there is no device mapped at the accessed IPA, then
> +userspace can ask the kernel to inject an external abort using the address
> +from the exiting fault on the VCPU. It is a programming error to set
> +ext_dabt_pending at the same time as any of the serror fields, or to set
> +ext_dabt_pending after an exit which was not either KVM_EXIT_MMIO or
> +KVM_EXIT_ARM_NISV. This feature is only available if the system supports
> +KVM_CAP_ARM_INJECT_EXT_DABT. This is a helper which provides commonality in
> +how userspace reports accesses for the above cases to guests, across different
> +userspace implementations. Nevertheless, userspace can still emulate all Arm
> +exceptions by manipulating individual registers using the KVM_SET_ONE_REG API.
> +
>   struct kvm_vcpu_events {
>   	struct {
>   		__u8 serror_pending;
>   		__u8 serror_has_esr;
> +		__u8 ext_dabt_pending;
>   		/* Align it to 8 bytes */
> -		__u8 pad[6];
> +		__u8 pad[5];
>   		__u64 serror_esr;
>   	} exception;
>   	__u32 reserved[12];
> diff --git a/arch/arm/include/uapi/asm/kvm.h b/arch/arm/include/uapi/asm/kvm.h
> index 2769360f195c..03cd7c19a683 100644
> --- a/arch/arm/include/uapi/asm/kvm.h
> +++ b/arch/arm/include/uapi/asm/kvm.h
> @@ -131,8 +131,9 @@ struct kvm_vcpu_events {
>   	struct {
>   		__u8 serror_pending;
>   		__u8 serror_has_esr;
> +		__u8 ext_dabt_pending;
>   		/* Align it to 8 bytes */
> -		__u8 pad[6];
> +		__u8 pad[5];
>   		__u64 serror_esr;
>   	} exception;
>   	__u32 reserved[12];
> diff --git a/arch/arm/kvm/guest.c b/arch/arm/kvm/guest.c
> index 684cf64b4033..4154c5589501 100644
> --- a/arch/arm/kvm/guest.c
> +++ b/arch/arm/kvm/guest.c
> @@ -263,11 +263,14 @@ int __kvm_arm_vcpu_set_events(struct kvm_vcpu *vcpu,
>   {
>   	bool serror_pending = events->exception.serror_pending;
>   	bool has_esr = events->exception.serror_has_esr;
> +	bool has_ext_dabt_pending = events->exception.ext_dabt_pending;
>   
>   	if (serror_pending && has_esr)
>   		return -EINVAL;
>   	else if (serror_pending)
>   		kvm_inject_vabt(vcpu);
> +	else if (has_ext_dabt_pending)
> +		kvm_inject_dabt(vcpu, kvm_vcpu_get_hfar(vcpu));
>   
>   	return 0;
>   }
> diff --git a/arch/arm64/include/uapi/asm/kvm.h b/arch/arm64/include/uapi/asm/kvm.h
> index 67c21f9bdbad..d49c17a80491 100644
> --- a/arch/arm64/include/uapi/asm/kvm.h
> +++ b/arch/arm64/include/uapi/asm/kvm.h
> @@ -164,8 +164,9 @@ struct kvm_vcpu_events {
>   	struct {
>   		__u8 serror_pending;
>   		__u8 serror_has_esr;
> +		__u8 ext_dabt_pending;
>   		/* Align it to 8 bytes */
> -		__u8 pad[6];
> +		__u8 pad[5];
>   		__u64 serror_esr;
>   	} exception;
>   	__u32 reserved[12];
> diff --git a/arch/arm64/kvm/guest.c b/arch/arm64/kvm/guest.c
> index dfd626447482..10e6e2144dca 100644
> --- a/arch/arm64/kvm/guest.c
> +++ b/arch/arm64/kvm/guest.c
> @@ -720,6 +720,7 @@ int __kvm_arm_vcpu_set_events(struct kvm_vcpu *vcpu,
>   {
>   	bool serror_pending = events->exception.serror_pending;
>   	bool has_esr = events->exception.serror_has_esr;
> +	bool has_ext_dabt_pending = events->exception.ext_dabt_pending;

The has_ is inconsistent here (and below in the copies of this function).

What I'm really curious on is why it's written the way it is though. Why 
not just make "exception" be a named struct and refer to a pointer of 
that here?

   struct kvm_arm_exception *e = &events->exception;

   if (e->serror_pending && e->serror_has_esr) {
     ...
   } else if (e->ext_dabt_pending) {
     ...
   }

Copying the values into their own local bools looks a bit convoluted to 
me. In fact, why do we copy u8s into bools in the first place?

>   
>   	if (serror_pending && has_esr) {
>   		if (!cpus_have_const_cap(ARM64_HAS_RAS_EXTN))
> @@ -731,6 +732,8 @@ int __kvm_arm_vcpu_set_events(struct kvm_vcpu *vcpu,
>   			return -EINVAL;
>   	} else if (serror_pending) {
>   		kvm_inject_vabt(vcpu);
> +	} else if (has_ext_dabt_pending) {
> +		kvm_inject_dabt(vcpu, kvm_vcpu_get_hfar(vcpu));

I'm a bit confused on the else if here. I understand that we probably 
don't want to inject an serror at the same time as a dabt, but shouldn't 
the API express that dependency?

Do we have guarantees on the value of "serror_pending"? Can we assume 
it's always either 0 or 1 today given all known user space? Maybe we can 
create a union and make this an "exception_pending" enum instead which 
indicates which exception we want to inject?


Alex




Amazon Development Center Germany GmbH
Krausenstr. 38
10117 Berlin
Geschaeftsfuehrung: Christian Schlaeger, Ralf Herbrich
Eingetragen am Amtsgericht Charlottenburg unter HRB 149173 B
Sitz: Berlin
Ust-ID: DE 289 237 879


_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
