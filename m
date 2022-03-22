Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 57956C433F5
	for <kvmarm@archiver.kernel.org>; Tue, 22 Mar 2022 23:06:13 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C473149F4E;
	Tue, 22 Mar 2022 19:06:12 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id DOAi7kKXAiFL; Tue, 22 Mar 2022 19:06:11 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9844349F07;
	Tue, 22 Mar 2022 19:06:11 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6AD8449EFC
 for <kvmarm@lists.cs.columbia.edu>; Tue, 22 Mar 2022 19:06:10 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 9oC5iSKhDMKj for <kvmarm@lists.cs.columbia.edu>;
 Tue, 22 Mar 2022 19:06:09 -0400 (EDT)
Received: from mail-io1-f44.google.com (mail-io1-f44.google.com
 [209.85.166.44])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 4A9CC49ED7
 for <kvmarm@lists.cs.columbia.edu>; Tue, 22 Mar 2022 19:06:09 -0400 (EDT)
Received: by mail-io1-f44.google.com with SMTP id c23so22015297ioi.4
 for <kvmarm@lists.cs.columbia.edu>; Tue, 22 Mar 2022 16:06:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=21fg6XWhU71tdjvtfle0AJij7OP2A2tXWl2jGQhNfvU=;
 b=WmVfjk0ZQjejqSijckp6Pw+yiFEK2WgK97TPc650R9vz61ruco/HdtN/loRXvj/fZY
 TpoYto7Qkfc1WWv0Kti0nvVS1+cIHPLHqziHvknk/NGBdxjXGOKeJWQ6fv/cimzX4qSU
 uTZtPGjqDZ2AJlTc0y0m2g0n/rlQHpTeeDGGRjAqhE/F4aWTp/km/QlYmiEUMjDGBwpt
 AOU+vDFwhqaG7US7+OvkH+hM6ITRrhBhvOWg9CqaHdcMwBAYyOWx8zN+DUL9eAFkIo/F
 smHrN1GRopkkH4wgH+6RD3BzpK6hfOMC8wSDZWFguX3hupusBLvAls19QuRtGUoaTIqK
 SUIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=21fg6XWhU71tdjvtfle0AJij7OP2A2tXWl2jGQhNfvU=;
 b=fk10Q7FhrrsW5iv/FPbHAIb0pKmTj21H7pQye1H69QM6mLn4+pA8x1BZHoSE6J+5Tb
 XV6h5u8y78c+3rwNq/UBgCrTAcUyuPLo/EusmAiCh94ng4xfOInR8Oqq3puItRO4Q9jA
 /oyvH+3vi2IFsLaS/szZC9VC8GJUTlg/c1ikQy+CT7IlaP1HLEu8SHoOM7NSIX55X4b0
 Re78czs52eMJU/6jJDxxoVJOzEDLmSo/Uo18uz0v4S/4gD1JOM8eD9Fqx2t291QavEBK
 5zTajAKIrq3wKF0Qq68mPHJ6VscbX+r63jYcJLkut4+iQUd+sTaTCKk73JDTu2C/xiTo
 Pi/Q==
X-Gm-Message-State: AOAM530NvYWc5DNxw2OVH/w8ssKL12GDDmyqlOWStsyar1jR6crvafCk
 XrSF/bEMIDthPS3YPvQLqKgiHw==
X-Google-Smtp-Source: ABdhPJzGCE6EzVZman8fSiUohf3D8+V2/3CWoBE09YGE21g6Vy6+LY5kvFh/StgAYK6rV9NtGAC5Xg==
X-Received: by 2002:a05:6638:1511:b0:319:fde7:501c with SMTP id
 b17-20020a056638151100b00319fde7501cmr14282398jat.13.1647990368349; 
 Tue, 22 Mar 2022 16:06:08 -0700 (PDT)
Received: from google.com (194.225.68.34.bc.googleusercontent.com.
 [34.68.225.194]) by smtp.gmail.com with ESMTPSA id
 y3-20020a92c983000000b002c7dce8329fsm10292511iln.72.2022.03.22.16.06.07
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Tue, 22 Mar 2022 16:06:07 -0700 (PDT)
Date: Tue, 22 Mar 2022 23:06:04 +0000
From: Oliver Upton <oupton@google.com>
To: Gavin Shan <gshan@redhat.com>
Subject: Re: [PATCH v5 15/22] KVM: arm64: Support SDEI_EVENT_SIGNAL hypercall
Message-ID: <YjpWXGIoaXUVjXQW@google.com>
References: <20220322080710.51727-1-gshan@redhat.com>
 <20220322080710.51727-16-gshan@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20220322080710.51727-16-gshan@redhat.com>
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

On Tue, Mar 22, 2022 at 04:07:03PM +0800, Gavin Shan wrote:
> This supports SDEI_EVENT_SIGNAL hypercall. It's used by the guest
> to inject SDEI event, whose number must be zero to the specified
> vCPU. As the routing mode and affinity isn't supported yet, the
> calling vCPU is assumed to be the target.
> 
> The SDEI event 0x0 is a private one, with normal priority. It's
> usually used for testing.

I don't know if that is actually the case. One real use that immediately
comes to mind is doing an NMI on a wedged CPU. KVM probably shouldn't
glean at how the guest may use a particular call, so at most we should
just point at the spec and state that event 0 is for software signaled
events.

> Signed-off-by: Gavin Shan <gshan@redhat.com>
> ---
>  arch/arm64/kvm/sdei.c | 64 ++++++++++++++++++++++++++++++++++++++++++-
>  1 file changed, 63 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/arm64/kvm/sdei.c b/arch/arm64/kvm/sdei.c
> index a24270378305..ba2ca65c871b 100644
> --- a/arch/arm64/kvm/sdei.c
> +++ b/arch/arm64/kvm/sdei.c
> @@ -726,6 +726,66 @@ static int do_inject_event(struct kvm_vcpu *vcpu,
>  	return 0;
>  }
>  
> +static unsigned long hypercall_signal(struct kvm_vcpu *vcpu)
> +{
> +	struct kvm *kvm = vcpu->kvm;
> +	struct kvm_sdei_kvm *ksdei = kvm->arch.sdei;
> +	struct kvm_sdei_vcpu *vsdei = vcpu->arch.sdei;
> +	struct kvm_sdei_exposed_event *exposed_event;
> +	struct kvm_sdei_registered_event *registered_event;
> +	unsigned long event_num = smccc_get_arg1(vcpu);
> +	int index;
> +	unsigned long ret = SDEI_SUCCESS;
> +
> +	/* @event_num must be zero */
> +	if (!kvm_sdei_is_default(event_num)) {

0 isn't KVM's default event. I'd argue KVM doesn't have a default event
to begin with. This has a precise definition coming from the spec. In
fact, 'KVM_SDEI_DEFAULT_EVENT' should probably be eliminated, and any
missing SDEI definitions should be added to include/uapi/linux/arm_sdei.h.

That goes for any values coming from the specification. KVM's
implementation details belong in a KVM header :)

--
Thanks,
Oliver
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
