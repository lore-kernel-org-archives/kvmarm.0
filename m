Return-Path: <SRS0=DlSC=3K=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 89268C2D0CE
	for <kvmarm@archiver.kernel.org>; Tue, 21 Jan 2020 13:28:27 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 10B4B206A2
	for <kvmarm@archiver.kernel.org>; Tue, 21 Jan 2020 13:28:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="IInYcauy"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 10B4B206A2
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id ABE644B006;
	Tue, 21 Jan 2020 08:28:26 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id lS0SF2OkinoB; Tue, 21 Jan 2020 08:28:25 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8825E4B00E;
	Tue, 21 Jan 2020 08:28:25 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8CB174B006
 for <kvmarm@lists.cs.columbia.edu>; Tue, 21 Jan 2020 08:28:24 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id P08jhtSpz5t6 for <kvmarm@lists.cs.columbia.edu>;
 Tue, 21 Jan 2020 08:28:22 -0500 (EST)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 65D284B003
 for <kvmarm@lists.cs.columbia.edu>; Tue, 21 Jan 2020 08:28:22 -0500 (EST)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 39B96217F4;
 Tue, 21 Jan 2020 13:28:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1579613301;
 bh=AhGovkny9mHiU777mnAi1nRCVFAloKS1CBQv7wXSVtM=;
 h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
 b=IInYcauyTt9wju7JL4lCa/vspqY6NFY9xa5WW/qZ90BQJZM/NznIulTRH2VWAP4DX
 Pv0aD+x2TcpNKMpbHOkfKr40d2YCUO25Gy9HHfGy/+FEOlHW/oEFtHQ2RXz9xYvXxG
 Yu5xmsOUSl+ckvGYq1XOKTWoOBXToivnhGcj7Vhg=
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
 by disco-boy.misterjones.org with esmtpsa
 (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128) (Exim 4.92)
 (envelope-from <maz@kernel.org>)
 id 1ittZr-000VZH-Fu; Tue, 21 Jan 2020 13:28:19 +0000
MIME-Version: 1.0
Date: Tue, 21 Jan 2020 13:28:19 +0000
From: Marc Zyngier <maz@kernel.org>
To: Gavin Shan <gshan@redhat.com>
Subject: Re: [PATCH] KVM: arm/arm64: Fix young bit from mmu notifier
In-Reply-To: <20200121055659.19560-1-gshan@redhat.com>
References: <20200121055659.19560-1-gshan@redhat.com>
Message-ID: <55ae5a0f91f2e675a4e71d83bef9d911@kernel.org>
X-Sender: maz@kernel.org
User-Agent: Roundcube Webmail/1.3.8
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: gshan@redhat.com, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org, drjones@redhat.com,
 eric.auger@redhat.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
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

On 2020-01-21 05:56, Gavin Shan wrote:
> kvm_test_age_hva() is called upon mmu_notifier_test_young(), but wrong
> address range has been passed to handle_hva_to_gpa(). With the wrong
> address range, no young bits will be checked in handle_hva_to_gpa().
> It means zero is always returned from mmu_notifier_test_young().
> 
> This fixes the issue by passing correct address range to the underly
> function handle_hva_to_gpa(), so that the hardware young (access) bit
> will be visited.
> 
> Cc: stable@vger.kernel.org # v4.1+
> Fixes: 35307b9a5f7e ("arm/arm64: KVM: Implement Stage-2 page aging")
> Signed-off-by: Gavin Shan <gshan@redhat.com>
> ---
>  virt/kvm/arm/mmu.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/virt/kvm/arm/mmu.c b/virt/kvm/arm/mmu.c
> index 0b32a904a1bb..a2777efb558e 100644
> --- a/virt/kvm/arm/mmu.c
> +++ b/virt/kvm/arm/mmu.c
> @@ -2147,7 +2147,8 @@ int kvm_test_age_hva(struct kvm *kvm, unsigned 
> long hva)
>  	if (!kvm->arch.pgd)
>  		return 0;
>  	trace_kvm_test_age_hva(hva);
> -	return handle_hva_to_gpa(kvm, hva, hva, kvm_test_age_hva_handler, 
> NULL);
> +	return handle_hva_to_gpa(kvm, hva, hva + PAGE_SIZE,
> +				 kvm_test_age_hva_handler, NULL);
>  }
> 
>  void kvm_mmu_free_memory_caches(struct kvm_vcpu *vcpu)

I knew this start/end thing (instead of start/size) would bite us
one of these days. Terribly embarrassing. On the other hand, who
really wants to swap things out? ;-)

Out of curiosity, how did you find this one?

Thanks,

         M.
-- 
Jazz is not dead. It just smells funny...
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
