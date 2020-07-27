Return-Path: <SRS0=4Xsg=BG=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 28010C433E4
	for <kvmarm@archiver.kernel.org>; Mon, 27 Jul 2020 17:56:06 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id AEA792070B
	for <kvmarm@archiver.kernel.org>; Mon, 27 Jul 2020 17:56:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="Z5m7WFP3"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org AEA792070B
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 69D9E4B85E;
	Mon, 27 Jul 2020 13:56:05 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id M8iLXlhP8jF8; Mon, 27 Jul 2020 13:56:04 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4157D4B7C1;
	Mon, 27 Jul 2020 13:56:04 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CF78E4B74E
 for <kvmarm@lists.cs.columbia.edu>; Mon, 27 Jul 2020 13:56:02 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Sk0SihTVX9Se for <kvmarm@lists.cs.columbia.edu>;
 Mon, 27 Jul 2020 13:56:01 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D6C0D4B740
 for <kvmarm@lists.cs.columbia.edu>; Mon, 27 Jul 2020 13:56:01 -0400 (EDT)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id B73CA2070B;
 Mon, 27 Jul 2020 17:56:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1595872560;
 bh=v11Epheq5tSy5AvwBVwRwdX6oVjInFx2eoLMFquy0RA=;
 h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
 b=Z5m7WFP3q6x8fuIeCZan7fGpFiqVVVda9qmiiAI480Y3aJrd5O2sETTQ8j4lZP2Mv
 RLvYMAkbp1wGuYjzlOl1AqEtB46wXHjYIus9aFIbkoKue3mdFmQSz5XmoIIrjt60vF
 lYkwjPj3976MbdOAdFWD/88b9UB6vyj4vIfuvIh8=
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
 by disco-boy.misterjones.org with esmtpsa
 (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128) (Exim 4.92)
 (envelope-from <maz@kernel.org>)
 id 1k07Lz-00FO0M-Bc; Mon, 27 Jul 2020 18:55:59 +0100
MIME-Version: 1.0
Date: Mon, 27 Jul 2020 18:55:59 +0100
From: Marc Zyngier <maz@kernel.org>
To: Andrew Jones <drjones@redhat.com>
Subject: Re: [PATCH 4/5] KVM: Documentation minor fixups
In-Reply-To: <20200711100434.46660-5-drjones@redhat.com>
References: <20200711100434.46660-1-drjones@redhat.com>
 <20200711100434.46660-5-drjones@redhat.com>
User-Agent: Roundcube Webmail/1.4.5
Message-ID: <7f940c35be5e4c11dc3e7a6188539091@kernel.org>
X-Sender: maz@kernel.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: drjones@redhat.com, kvm@vger.kernel.org,
 kvmarm@lists.cs.columbia.edu, pbonzini@redhat.com, steven.price@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: pbonzini@redhat.com, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
 steven.price@arm.com
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

On 2020-07-11 11:04, Andrew Jones wrote:
> Reviewed-by: Steven Price <steven.price@arm.com>
> Signed-off-by: Andrew Jones <drjones@redhat.com>

It'd be good to have an actual commit message.

> ---
>  Documentation/virt/kvm/api.rst | 9 +++++----
>  1 file changed, 5 insertions(+), 4 deletions(-)
> 
> diff --git a/Documentation/virt/kvm/api.rst 
> b/Documentation/virt/kvm/api.rst
> index 320788f81a05..3bd96c1a3962 100644
> --- a/Documentation/virt/kvm/api.rst
> +++ b/Documentation/virt/kvm/api.rst
> @@ -6122,7 +6122,7 @@ HvCallSendSyntheticClusterIpi,
> HvCallSendSyntheticClusterIpiEx.
>  8.21 KVM_CAP_HYPERV_DIRECT_TLBFLUSH
>  -----------------------------------
> 
> -:Architecture: x86
> +:Architectures: x86
> 
>  This capability indicates that KVM running on top of Hyper-V 
> hypervisor
>  enables Direct TLB flush for its guests meaning that TLB flush
> @@ -6135,16 +6135,17 @@ in CPUID and only exposes Hyper-V
> identification. In this case, guest
>  thinks it's running on Hyper-V and only use Hyper-V hypercalls.
> 
>  8.22 KVM_CAP_S390_VCPU_RESETS
> +-----------------------------
> 
> -Architectures: s390
> +:Architectures: s390
> 
>  This capability indicates that the KVM_S390_NORMAL_RESET and
>  KVM_S390_CLEAR_RESET ioctls are available.
> 
>  8.23 KVM_CAP_S390_PROTECTED
> +---------------------------
> 
> -Architecture: s390
> -
> +:Architectures: s390
> 
>  This capability indicates that the Ultravisor has been initialized and
>  KVM can therefore start protected VMs.

But this seems to be an otherwise unrelated patch.
I'm happy to take it, but it seems odd here.

Thanks,

         M.
-- 
Jazz is not dead. It just smells funny...
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
