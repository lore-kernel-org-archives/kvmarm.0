Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 91B64ECAAA1
	for <kvmarm@archiver.kernel.org>; Fri,  9 Sep 2022 17:28:46 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 008A04C513;
	Fri,  9 Sep 2022 13:28:46 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id cOvPaUuMBl5k; Fri,  9 Sep 2022 13:28:44 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E49684C519;
	Fri,  9 Sep 2022 13:28:44 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C91434C514
 for <kvmarm@lists.cs.columbia.edu>; Fri,  9 Sep 2022 13:28:43 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id fiiiwsQYiAYq for <kvmarm@lists.cs.columbia.edu>;
 Fri,  9 Sep 2022 13:28:42 -0400 (EDT)
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 943454C513
 for <kvmarm@lists.cs.columbia.edu>; Fri,  9 Sep 2022 13:28:42 -0400 (EDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ams.source.kernel.org (Postfix) with ESMTPS id 47939B82588;
 Fri,  9 Sep 2022 17:28:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 619F1C433D6;
 Fri,  9 Sep 2022 17:28:38 +0000 (UTC)
Date: Fri, 9 Sep 2022 18:28:34 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Elliot Berman <quic_eberman@quicinc.com>
Subject: Re: [PATCH v2] KVM: arm64: Only set KVM_MODE_PROTECTED if
 is_hyp_mode_available()
Message-ID: <Yxt3wmXYYbWraXrd@arm.com>
References: <20220909144552.3000716-1-quic_eberman@quicinc.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20220909144552.3000716-1-quic_eberman@quicinc.com>
Cc: Marc Zyngier <maz@kernel.org>, linux-kernel@vger.kernel.org,
 Will Deacon <will@kernel.org>, kvmarm@lists.cs.columbia.edu,
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

On Fri, Sep 09, 2022 at 07:45:52AM -0700, Elliot Berman wrote:
> Do not switch kvm_mode to KVM_MODE_PROTECTED if hypervisor mode is not
> available. This prevents "Protected KVM" cpu capability being reported
> when Linux is booting in EL1 and would not have KVM enabled.
> 
> Signed-off-by: Elliot Berman <quic_eberman@quicinc.com>
> ---
>  arch/arm64/kvm/arm.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> index 8fe73ee5fa84..861f4b388879 100644
> --- a/arch/arm64/kvm/arm.c
> +++ b/arch/arm64/kvm/arm.c
> @@ -2272,7 +2272,9 @@ static int __init early_kvm_mode_cfg(char *arg)
>  		return -EINVAL;
>  
>  	if (strcmp(arg, "protected") == 0) {
> -		if (!is_kernel_in_hyp_mode())
> +		if (!is_hyp_mode_available())
> +			kvm_mode = KVM_MODE_DEFAULT;

I think kvm_mode is already KVM_MODE_DEFAULT at this point. You may want
to print a warning instead.

-- 
Catalin
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
