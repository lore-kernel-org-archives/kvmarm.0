Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C1FBEC00140
	for <kvmarm@archiver.kernel.org>; Wed, 10 Aug 2022 15:42:10 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 296424DAD0;
	Wed, 10 Aug 2022 11:42:10 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@linux.dev
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id nTTKdmMbedBv; Wed, 10 Aug 2022 11:42:08 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8FC854DACD;
	Wed, 10 Aug 2022 11:42:08 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A8DE24DACD
 for <kvmarm@lists.cs.columbia.edu>; Wed, 10 Aug 2022 11:42:06 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 2himjbY10x6j for <kvmarm@lists.cs.columbia.edu>;
 Wed, 10 Aug 2022 11:42:05 -0400 (EDT)
Received: from out2.migadu.com (out2.migadu.com [188.165.223.204])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 74A5B4DACA
 for <kvmarm@lists.cs.columbia.edu>; Wed, 10 Aug 2022 11:42:05 -0400 (EDT)
Date: Wed, 10 Aug 2022 10:41:56 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
 t=1660146124;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=K2PbOUqOvValZYHdNM1MGvDbH+NW5HMrQfpzoZhK7ZE=;
 b=htruQVkH3tRwn67M8lxwDxWJcmqoYYJ7n3o1BU4Nzi+bk/Qkn/2fU9FSTvgictSsmVFw37
 cJkohOBnSioV23R1DBb/ZPvkiWp3m9lapoivUmelydT1ZddoDT46WXqNbC/Hyiie9gHtun
 OW/GmCzkrE0nN2Wx0j9w7JuP90sAbGw=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and
 include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH 5/9] KVM: arm64: PMU: Simplify setting a counter to a
 specific value
Message-ID: <YvPRxHgriLXc5AGp@google.com>
References: <20220805135813.2102034-1-maz@kernel.org>
 <20220805135813.2102034-6-maz@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20220805135813.2102034-6-maz@kernel.org>
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: linux.dev
Cc: kvm@vger.kernel.org, kernel-team@android.com, kvmarm@lists.cs.columbia.edu,
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

On Fri, Aug 05, 2022 at 02:58:09PM +0100, Marc Zyngier wrote:
> kvm_pmu_set_counter_value() is pretty odd, as it tries to update
> the counter value while taking into account the value that is
> currently held by the running perf counter.
> 
> This is not only complicated, this is quite wrong. Nowhere in
> the architecture is it said that the counter would be offset
> by something that is pending. The counter should be updated
> with the value set by SW, and start counting from there if
> required.
> 
> Remove the odd computation and just assign the provided value
> after having released the perf event (which is then restarted).
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>

Looks much better.

Reviewed-by: Oliver Upton <oliver.upton@linux.dev>

> ---
>  arch/arm64/kvm/pmu-emul.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
> index 9be485d23416..ddd79b64b38a 100644
> --- a/arch/arm64/kvm/pmu-emul.c
> +++ b/arch/arm64/kvm/pmu-emul.c
> @@ -21,6 +21,7 @@ static LIST_HEAD(arm_pmus);
>  static DEFINE_MUTEX(arm_pmus_lock);
>  
>  static void kvm_pmu_create_perf_event(struct kvm_vcpu *vcpu, u64 select_idx);
> +static void kvm_pmu_release_perf_event(struct kvm_pmc *pmc);
>  
>  static u32 kvm_pmu_event_mask(struct kvm *kvm)
>  {
> @@ -129,8 +130,10 @@ void kvm_pmu_set_counter_value(struct kvm_vcpu *vcpu, u64 select_idx, u64 val)
>  	if (!kvm_vcpu_has_pmu(vcpu))
>  		return;
>  
> +	kvm_pmu_release_perf_event(&vcpu->arch.pmu.pmc[select_idx]);
> +

<bikeshed>

Not your code, but since we're here: it seems as though there is some
inconsistency in parameterization as some functions take an index and
others take a kvm_pmc pointer. For example,
kvm_pmu_{create,release}_perf_event() are inconsistent.

It might be nice to pick a scheme and apply consistently throughout.

</bikeshed>

--
Thanks,
Oliver

>  	reg = counter_index_to_reg(select_idx);
> -	__vcpu_sys_reg(vcpu, reg) += (s64)val - kvm_pmu_get_counter_value(vcpu, select_idx);
> +	__vcpu_sys_reg(vcpu, reg) = val;
>  
>  	/* Recreate the perf event to reflect the updated sample_period */
>  	kvm_pmu_create_perf_event(vcpu, select_idx);
> -- 
> 2.34.1
> 
>
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
