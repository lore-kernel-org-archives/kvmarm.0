Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 610271FECBE
	for <kvmarm@lists.linux.dev>; Mon, 27 Jan 2025 12:47:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737982056; cv=none; b=RyOrSk8e4O1/iDWswKsPlkTBInATR2WIXimYAXnW0fz3hnhQzYgPXK0p5GZzdFigsU+//nAcOo83sPeUUzEgWZdKrYeyGcOxaCwxgaN4Jagl5AjG1Xnl0U6+kHVS/E7ZwiW9YADig5F/urT+VL6NOMhsC32Gpy8Ah7YT8frfoyA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737982056; c=relaxed/simple;
	bh=KWDwRZ2z5xhJDO+D5k7fSjK6cHOWWjgKHu1nMuvb3Qk=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=aVo7rDQmAPK9pNpAihv0y3TdJf8gtkYK5AQAJ4xLoIxpwXkUIEuG+ZgVMeEAY3us0Ih1EBUNtw3M5o25mfqwXmrsQk79Hmgd4dV9PTfmYla9lf5sJaBMXMhsouZI+sKOyBgU4k8OL4CaaFFmq9t+FKD+3lzaVgs7QI6dpbVn/+E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=FBCr++XH; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="FBCr++XH"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1737982053;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=gZGVYJ/cTpa0FGMzvMGF5E/FDOf1q03ZLF/tzzLerLU=;
	b=FBCr++XHVVkgQRFTcylXHGYDDpUMk5uhZC/y3fC/VDE3XmH1189mtmz4RTXedRcUzJNE5w
	JaXu89WJvocPPGYdh3AZEAX0RaGZ6raWziSw13On0sNl8CdIcTUyodPkG1oCZT3sqlida3
	gAL0IpImCg+EyQdmc9hM8wbEf0Ht+jA=
Received: from mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-634-xKD-f8DgNvu6sX4y5ipZ8g-1; Mon,
 27 Jan 2025 07:47:31 -0500
X-MC-Unique: xKD-f8DgNvu6sX4y5ipZ8g-1
X-Mimecast-MFC-AGG-ID: xKD-f8DgNvu6sX4y5ipZ8g
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 7F0AA19560A1;
	Mon, 27 Jan 2025 12:47:28 +0000 (UTC)
Received: from localhost (dhcp-192-212.str.redhat.com [10.33.192.212])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 17F80180034C;
	Mon, 27 Jan 2025 12:47:25 +0000 (UTC)
From: Cornelia Huck <cohuck@redhat.com>
To: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
 kvmarm@lists.linux.dev, maz@kernel.org, oliver.upton@linux.dev
Cc: catalin.marinas@arm.com, will@kernel.org, mark.rutland@arm.com,
 eric.auger@redhat.com, sebott@redhat.com, yuzenghui@huawei.com,
 wangzhou1@hisilicon.com, jiangkunkun@huawei.com,
 jonathan.cameron@huawei.com, anthony.jebson@huawei.com,
 linux-arm-kernel@lists.infradead.org, linuxarm@huawei.com
Subject: Re: [PATCH v5 3/4] KVM: arm64: Report all the KVM/arm64-specific
 hypercalls
In-Reply-To: <20250124151732.6072-4-shameerali.kolothum.thodi@huawei.com>
Organization: "Red Hat GmbH, Sitz: Werner-von-Siemens-Ring 12, D-85630
 Grasbrunn, Handelsregister: Amtsgericht =?utf-8?Q?M=C3=BCnchen=2C?= HRB
 153243,
 =?utf-8?Q?Gesch=C3=A4ftsf=C3=BChrer=3A?= Ryan Barnhart, Charles Cachera,
 Michael O'Neill, Amy
 Ross"
References: <20250124151732.6072-1-shameerali.kolothum.thodi@huawei.com>
 <20250124151732.6072-4-shameerali.kolothum.thodi@huawei.com>
User-Agent: Notmuch/0.38.3 (https://notmuchmail.org)
Date: Mon, 27 Jan 2025 13:47:23 +0100
Message-ID: <8734h48lus.fsf@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: uUyHAl6TNolK3zUovnj_ddctjFEVehH3EWv7x1-JxTE_1737982049
X-Mimecast-Originator: redhat.com
Content-Type: text/plain

On Fri, Jan 24 2025, Shameer Kolothum <shameerali.kolothum.thodi@huawei.com> wrote:

> Currently ARM_SMCCC_VENDOR_HYP_KVM_FEATURES_FUNC_ID returns the
> bitmap corresponding to KVM_REG_ARM_VENDOR_HYP_BMAP and it only
> returns _KVM_FEATURES_FUNC_ID and _KVM_PTP_FUNC_ID. Change that
> to return all the KVM/arm64-specific hypercalls exposed by
> KVM/arm64 to guest operating systems.
>
> Signed-off-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
> ---
>  arch/arm64/kvm/hypercalls.c | 6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
>
> diff --git a/arch/arm64/kvm/hypercalls.c b/arch/arm64/kvm/hypercalls.c
> index 27ce4cb44904..6132cb542200 100644
> --- a/arch/arm64/kvm/hypercalls.c
> +++ b/arch/arm64/kvm/hypercalls.c
> @@ -359,7 +359,11 @@ int kvm_smccc_call_handler(struct kvm_vcpu *vcpu)
>  		val[3] = ARM_SMCCC_VENDOR_HYP_UID_KVM_REG_3;
>  		break;
>  	case ARM_SMCCC_VENDOR_HYP_KVM_FEATURES_FUNC_ID:
> -		val[0] = smccc_feat->vendor_hyp_bmap;
> +		val[0] = GENMASK(ARM_SMCCC_KVM_FUNC_MMIO_GUARD,
> +				 ARM_SMCCC_KVM_FUNC_FEATURES);

Don't you need to exclude the reserved ids 5 and 6?

> +		/* Function numbers 8-63 are reserved for pKVM for now */
> +		val[2] = GENMASK((ARM_SMCCC_KVM_FUNC_DISCOVER_IMPL_CPUS - 64),
> +				 (ARM_SMCCC_KVM_FUNC_DISCOVER_IMPL_VER - 64));
>  		break;
>  	case ARM_SMCCC_VENDOR_HYP_KVM_PTP_FUNC_ID:
>  		kvm_ptp_get_time(vcpu, val);

