Return-Path: <SRS0=4Xsg=BG=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F0B08C433E4
	for <kvmarm@archiver.kernel.org>; Mon, 27 Jul 2020 17:29:56 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 81C6B20714
	for <kvmarm@archiver.kernel.org>; Mon, 27 Jul 2020 17:29:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="D5iBwBIK"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 81C6B20714
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3BBBD4B7CD;
	Mon, 27 Jul 2020 13:29:56 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id mH25V3QZWAvX; Mon, 27 Jul 2020 13:29:55 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3A1CF4B816;
	Mon, 27 Jul 2020 13:29:55 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2E3934B815
 for <kvmarm@lists.cs.columbia.edu>; Mon, 27 Jul 2020 13:29:54 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 7tAqzsOC2dH5 for <kvmarm@lists.cs.columbia.edu>;
 Mon, 27 Jul 2020 13:29:53 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 39F3C4B7CD
 for <kvmarm@lists.cs.columbia.edu>; Mon, 27 Jul 2020 13:29:53 -0400 (EDT)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 229F920714;
 Mon, 27 Jul 2020 17:29:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1595870992;
 bh=fqWwMELSuy+/qFam4pMh5T7zeLs7KMWf9QveNurGOnU=;
 h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
 b=D5iBwBIKBnxBJrFCHIAlJZ8pGmqz7+/+B3fXLnLR5OCBI+o9EfTdIMCO93+9OJlqz
 GNQnRRmkwWUaCe3jUucrvPQ+eyHjrElHTg0V0jmUIOevFtQYZ+AYKvDMQeYQZd6av6
 6ZRwk6dLx/EEG9ml6CnCBvci3qdgYRYhRr2hY4L0=
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
 by disco-boy.misterjones.org with esmtpsa
 (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128) (Exim 4.92)
 (envelope-from <maz@kernel.org>)
 id 1k06wg-00FNfw-Nz; Mon, 27 Jul 2020 18:29:50 +0100
MIME-Version: 1.0
Date: Mon, 27 Jul 2020 18:29:50 +0100
From: Marc Zyngier <maz@kernel.org>
To: Andrew Jones <drjones@redhat.com>
Subject: Re: [PATCH 2/5] KVM: arm64: pvtime: Fix potential loss of stolen time
In-Reply-To: <20200711100434.46660-3-drjones@redhat.com>
References: <20200711100434.46660-1-drjones@redhat.com>
 <20200711100434.46660-3-drjones@redhat.com>
User-Agent: Roundcube Webmail/1.4.5
Message-ID: <9044c568f04a2f8e99c548acbb85db4a@kernel.org>
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
> We should only check current->sched_info.run_delay once when
> updating stolen time. Otherwise there's a chance there could
> be a change between checks that we miss (preemption disabling
> comes after vcpu request checks).
> 
> Signed-off-by: Andrew Jones <drjones@redhat.com>
> ---
>  arch/arm64/kvm/pvtime.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/arm64/kvm/pvtime.c b/arch/arm64/kvm/pvtime.c
> index 2b22214909be..db5ef097a166 100644
> --- a/arch/arm64/kvm/pvtime.c
> +++ b/arch/arm64/kvm/pvtime.c
> @@ -13,6 +13,7 @@
>  void kvm_update_stolen_time(struct kvm_vcpu *vcpu)
>  {
>  	struct kvm *kvm = vcpu->kvm;
> +	u64 last_steal = vcpu->arch.steal.last_steal;
>  	u64 steal;
>  	__le64 steal_le;
>  	u64 offset;
> @@ -24,8 +25,8 @@ void kvm_update_stolen_time(struct kvm_vcpu *vcpu)
> 
>  	/* Let's do the local bookkeeping */
>  	steal = vcpu->arch.steal.steal;
> -	steal += current->sched_info.run_delay - vcpu->arch.steal.last_steal;
>  	vcpu->arch.steal.last_steal = current->sched_info.run_delay;
> +	steal += vcpu->arch.steal.last_steal - last_steal;
>  	vcpu->arch.steal.steal = steal;
> 
>  	steal_le = cpu_to_le64(steal);

Unless you read current->sched_info.run_delay using READ_ONCE,
there is no guarantee that this will do what you want. The
compiler is free to rejig this anyway it wants.

Thanks,

         M.
-- 
Jazz is not dead. It just smells funny...
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
