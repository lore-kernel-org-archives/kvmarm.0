Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 99BB3C00140
	for <kvmarm@archiver.kernel.org>; Wed, 10 Aug 2022 07:17:02 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 42AEE4D5D2;
	Wed, 10 Aug 2022 03:17:02 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@linux.dev
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id kh185k8i7mxP; Wed, 10 Aug 2022 03:17:01 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2848A4D5D4;
	Wed, 10 Aug 2022 03:17:01 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7D0CF4D5CE
 for <kvmarm@lists.cs.columbia.edu>; Wed, 10 Aug 2022 03:17:00 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Hq5PChbZX-Jh for <kvmarm@lists.cs.columbia.edu>;
 Wed, 10 Aug 2022 03:16:59 -0400 (EDT)
Received: from out1.migadu.com (out1.migadu.com [91.121.223.63])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 7C69C4D5CD
 for <kvmarm@lists.cs.columbia.edu>; Wed, 10 Aug 2022 03:16:59 -0400 (EDT)
Date: Wed, 10 Aug 2022 02:16:51 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
 t=1660115818;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=lnnnucUQ8BNoxijHKdwN8wjZqldMe4thNdHyaMFPMKo=;
 b=GupU2arkRASHme5PDc96/86JA+M8qFQV4cxtah7aEb1nJ4V4U3iSpefNFfbrnr4K6Nr859
 EnHHrzQWoRr8r5DLx224eIbtKnK+LigVDxshj6LxERc8Xqh+iIw2yIOEHuhdKwjCmBNlmB
 mn5lF9pfKPn5ra/Hq0pbHIPr4gj+N98=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and
 include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH 9/9] KVM: arm64: PMU: Allow PMUv3p5 to be exposed to the
 guest
Message-ID: <YvNbYyS6eM9mo+Pq@google.com>
References: <20220805135813.2102034-1-maz@kernel.org>
 <20220805135813.2102034-10-maz@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20220805135813.2102034-10-maz@kernel.org>
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

On Fri, Aug 05, 2022 at 02:58:13PM +0100, Marc Zyngier wrote:
> Now that the infrastructure is in place, bummp the PMU support up

typo: bump

> to PMUv3p5.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/kvm/pmu-emul.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
> index b33a2953cbf6..fbbe6a7e3837 100644
> --- a/arch/arm64/kvm/pmu-emul.c
> +++ b/arch/arm64/kvm/pmu-emul.c
> @@ -1031,6 +1031,6 @@ u8 kvm_arm_pmu_get_host_pmuver(void)
>  	tmp = read_sanitised_ftr_reg(SYS_ID_AA64DFR0_EL1);
>  	tmp = cpuid_feature_cap_perfmon_field(tmp,
>  					      ID_AA64DFR0_PMUVER_SHIFT,
> -					      ID_AA64DFR0_PMUVER_8_4);
> +					      ID_AA64DFR0_PMUVER_8_5);
>  	return FIELD_GET(ARM64_FEATURE_MASK(ID_AA64DFR0_PMUVER), tmp);
>  }
> -- 
> 2.34.1
> 
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
