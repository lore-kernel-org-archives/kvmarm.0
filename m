Return-Path: <SRS0=76eI=ZU=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.0 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 819B3C432C3
	for <kvmarm@archiver.kernel.org>; Thu, 28 Nov 2019 08:57:10 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 029902176D
	for <kvmarm@archiver.kernel.org>; Thu, 28 Nov 2019 08:57:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="gLy9OlMf"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 029902176D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 75CA14A598;
	Thu, 28 Nov 2019 03:57:09 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id e5XueeMkahwy; Thu, 28 Nov 2019 03:57:08 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 58A994A7D9;
	Thu, 28 Nov 2019 03:57:08 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7D85E4A52C
 for <kvmarm@lists.cs.columbia.edu>; Thu, 28 Nov 2019 03:57:07 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id EhbcFJ4Oev+o for <kvmarm@lists.cs.columbia.edu>;
 Thu, 28 Nov 2019 03:57:06 -0500 (EST)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8B6664A4FC
 for <kvmarm@lists.cs.columbia.edu>; Thu, 28 Nov 2019 03:57:06 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1574931426;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=UTqyxfqplr5cCVGYbvk1+6dr+xn0FSeXRHiQCzbM5Do=;
 b=gLy9OlMfaMj5GVvF5/GIc3JFmn9VlDnDDzCGMETRVFHDBgwHwyw+NDQgXrVB2QWM5QZwHV
 kwqhyYHvVmQ9b08JPAA44jEpVJ0xLLJUjNyj/YTN+EZ9qHIlNOT8i+sTQj2fjeqxXRLBvh
 ApAYcVboUsuv3v5B+RgsboaMkeruG68=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-223-tdG362LsNXq1vxkm-wtRyA-1; Thu, 28 Nov 2019 03:57:04 -0500
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com
 [10.5.11.11])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5381018B9FC1;
 Thu, 28 Nov 2019 08:57:02 +0000 (UTC)
Received: from [10.36.116.37] (ovpn-116-37.ams2.redhat.com [10.36.116.37])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 5B57B600C8;
 Thu, 28 Nov 2019 08:56:56 +0000 (UTC)
Subject: Re: [PATCH] KVM: arm64: eliminate unnecessary var err and jump label
 in set_core_reg()
To: linmiaohe <linmiaohe@huawei.com>, maz@kernel.org, pbonzini@redhat.com,
 rkrcmar@redhat.com, james.morse@arm.com, julien.thierry.kdev@gmail.com,
 suzuki.poulose@arm.com, christoffer.dall@arm.com, catalin.marinas@arm.com,
 gregkh@linuxfoundation.org, will@kernel.org, andre.przywara@arm.com,
 tglx@linutronix.de
References: <1574910598-14468-1-git-send-email-linmiaohe@huawei.com>
From: Auger Eric <eric.auger@redhat.com>
Message-ID: <7210b73f-66a0-e276-74b4-83d011b57d21@redhat.com>
Date: Thu, 28 Nov 2019 09:56:54 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <1574910598-14468-1-git-send-email-linmiaohe@huawei.com>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-MC-Unique: tdG362LsNXq1vxkm-wtRyA-1
X-Mimecast-Spam-Score: 0
Cc: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
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

Hi,

On 11/28/19 4:09 AM, linmiaohe wrote:
> From: Miaohe Lin <linmiaohe@huawei.com>
> 
> The var err and jump label out isn't really needed in
> set_core_reg(). Clean them up.
> Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Reviewed-by: Eric Auger <eric.auger@redhat.com>

Thanks

Eric

> ---
>  arch/arm64/kvm/guest.c | 13 ++++---------
>  1 file changed, 4 insertions(+), 9 deletions(-)
> 
> diff --git a/arch/arm64/kvm/guest.c b/arch/arm64/kvm/guest.c
> index 3b836c91609e..88eb6e5399ed 100644
> --- a/arch/arm64/kvm/guest.c
> +++ b/arch/arm64/kvm/guest.c
> @@ -159,7 +159,6 @@ static int set_core_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
>  	__uint128_t tmp;
>  	void *valp = &tmp;
>  	u64 off;
> -	int err = 0;
>  
>  	/* Our ID is an index into the kvm_regs struct. */
>  	off = core_reg_offset_from_id(reg->id);
> @@ -173,10 +172,8 @@ static int set_core_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
>  	if (KVM_REG_SIZE(reg->id) > sizeof(tmp))
>  		return -EINVAL;
>  
> -	if (copy_from_user(valp, uaddr, KVM_REG_SIZE(reg->id))) {
> -		err = -EFAULT;
> -		goto out;
> -	}
> +	if (copy_from_user(valp, uaddr, KVM_REG_SIZE(reg->id)))
> +		return -EFAULT;
>  
>  	if (off == KVM_REG_ARM_CORE_REG(regs.pstate)) {
>  		u64 mode = (*(u64 *)valp) & PSR_AA32_MODE_MASK;
> @@ -200,14 +197,12 @@ static int set_core_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
>  				return -EINVAL;
>  			break;
>  		default:
> -			err = -EINVAL;
> -			goto out;
> +			return -EINVAL;
>  		}
>  	}
>  
>  	memcpy((u32 *)regs + off, valp, KVM_REG_SIZE(reg->id));
> -out:
> -	return err;
> +	return 0;
>  }
>  
>  #define vq_word(vq) (((vq) - SVE_VQ_MIN) / 64)
> 

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
