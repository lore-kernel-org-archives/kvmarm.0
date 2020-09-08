Return-Path: <SRS0=B0kT=CR=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3F788C2BBD0
	for <kvmarm@archiver.kernel.org>; Tue,  8 Sep 2020 09:53:33 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 898F621D42
	for <kvmarm@archiver.kernel.org>; Tue,  8 Sep 2020 09:53:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="NbEhs6nO"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 898F621D42
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B613F4B21F;
	Tue,  8 Sep 2020 05:53:31 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id BrTZTGRh9Aqi; Tue,  8 Sep 2020 05:53:30 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A26DA4B2CC;
	Tue,  8 Sep 2020 05:53:30 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6E0614B21F
 for <kvmarm@lists.cs.columbia.edu>; Tue,  8 Sep 2020 05:53:29 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id at3sBjQeOj3f for <kvmarm@lists.cs.columbia.edu>;
 Tue,  8 Sep 2020 05:53:28 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [63.128.21.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 74DBB4B20A
 for <kvmarm@lists.cs.columbia.edu>; Tue,  8 Sep 2020 05:53:28 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1599558808;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=FBNH2TKloZYz+VQ8z5rDqMA5CzFUqgJN9jmog9OO4ZQ=;
 b=NbEhs6nO1P0J2iuwCGF6/C+rPwNHtcWXvrCAxAlz24hwQ8qHUfoTN8WSUOukappj96vBSd
 OOWNMaJULIVm1pXv4HOvjcpNemNHlmk/8HcAHochY7Y0vRcpOSaejyzm/7J7+EnRFqkSLR
 r21DVlMh7JYmUbBQGqWgnJv1/UGRfWU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-288--kGdKwDyOlCWDSa31-TTbw-1; Tue, 08 Sep 2020 05:53:24 -0400
X-MC-Unique: -kGdKwDyOlCWDSa31-TTbw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com
 [10.5.11.13])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A328A800469;
 Tue,  8 Sep 2020 09:53:22 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.40.192.171])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id CF272805F0;
 Tue,  8 Sep 2020 09:53:20 +0000 (UTC)
Date: Tue, 8 Sep 2020 11:53:18 +0200
From: Andrew Jones <drjones@redhat.com>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH v3 1/5] KVM: arm64: Refactor PMU attribute error handling
Message-ID: <20200908095318.nzbnadvgcmxvt3xs@kamzik.brq.redhat.com>
References: <20200908075830.1161921-1-maz@kernel.org>
 <20200908075830.1161921-2-maz@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20200908075830.1161921-2-maz@kernel.org>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Cc: kvm@vger.kernel.org, kernel-team@android.com, graf@amazon.com,
 Robin Murphy <robin.murphy@arm.com>, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org
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

Hi Marc,

On Tue, Sep 08, 2020 at 08:58:26AM +0100, Marc Zyngier wrote:
> The PMU emulation error handling is pretty messy when dealing with
> attributes. Let's refactor it so that we have less duplication,
> and that it is easy to extend later on.
> 
> A functional change is that kvm_arm_pmu_v3_init() used to return
> -ENXIO when the PMU feature wasn't set. The error is now reported
> as -ENODEV, matching the documentation.

Hmm, I didn't think we could make changes like that, since some userspace
somewhere may now depend on the buggy interface. That said, I'm not really
against the change, but maybe it should go as a separate patch.

> -ENXIO is still returned
> when the interrupt isn't properly configured.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/kvm/pmu-emul.c | 21 +++++++++------------
>  1 file changed, 9 insertions(+), 12 deletions(-)
> 
> diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
> index f0d0312c0a55..93d797df42c6 100644
> --- a/arch/arm64/kvm/pmu-emul.c
> +++ b/arch/arm64/kvm/pmu-emul.c
> @@ -735,15 +735,6 @@ int kvm_arm_pmu_v3_enable(struct kvm_vcpu *vcpu)
>  
>  static int kvm_arm_pmu_v3_init(struct kvm_vcpu *vcpu)
>  {
> -	if (!kvm_arm_support_pmu_v3())
> -		return -ENODEV;
> -
> -	if (!test_bit(KVM_ARM_VCPU_PMU_V3, vcpu->arch.features))
> -		return -ENXIO;
> -
> -	if (vcpu->arch.pmu.created)
> -		return -EBUSY;
> -
>  	if (irqchip_in_kernel(vcpu->kvm)) {
>  		int ret;
>  
> @@ -796,6 +787,15 @@ static bool pmu_irq_is_valid(struct kvm *kvm, int irq)
>  
>  int kvm_arm_pmu_v3_set_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr)
>  {
> +	if (!kvm_arm_support_pmu_v3())
> +		return -ENODEV;
> +
> +	if (!test_bit(KVM_ARM_VCPU_PMU_V3, vcpu->arch.features))
> +		return -ENODEV;

nit: could combine these two if's w/ an ||

> +
> +	if (vcpu->arch.pmu.created)
> +		return -EBUSY;
> +
>  	switch (attr->attr) {
>  	case KVM_ARM_VCPU_PMU_V3_IRQ: {
>  		int __user *uaddr = (int __user *)(long)attr->addr;
> @@ -804,9 +804,6 @@ int kvm_arm_pmu_v3_set_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr)
>  		if (!irqchip_in_kernel(vcpu->kvm))
>  			return -EINVAL;
>  
> -		if (!test_bit(KVM_ARM_VCPU_PMU_V3, vcpu->arch.features))
> -			return -ENODEV;
> -
>  		if (get_user(irq, uaddr))
>  			return -EFAULT;
>  
> -- 
> 2.28.0
> 

Thanks,
drew

> _______________________________________________
> kvmarm mailing list
> kvmarm@lists.cs.columbia.edu
> https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
> 

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
