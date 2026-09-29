Received: from mta1.migadu.com (out-115.mta1.migadu.com [95.215.58.115])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8F513D5661
	for <kvmarm@lists.linux.dev>; Tue, 29 Sep 2026 18:45:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.115
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790707551; cv=none; b=HXFc7qnLhw5Zmfmu3PsZCcHlPHQtNUW/IWP8B2aYFMgyDsrVYRONSRlSjJErX6oDQy1sGJuxbmJRQ7LuzmP9owQ/MM4RNNUiuo+jVBpS8bHGsE1iTzvh6Oai6shdAFgCEaS+S0AZSCPFTX3VnRRip2yblFP/JDzC7LIo4jreZsA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790707551; c=relaxed/simple;
	bh=mx1pndh9NACF4v//8sWUqY+ii9IXnTRJQEeestc8TIE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=B/3SJS3JmwUo6A8Dgh/yLwSgB7DkcPxOfO8GaGApQl4b3iIOluryMbtYe3kWPRrQA/8elGXlcEHOnqkfIvJ2jAGg6RKLi99unq+wd5lBmWQ5DKZWnyspXss8ZTz+jbTojTUmmJ+5gFARwN+JR/fJbg58yXVyLvz2sMXMbI6qu2Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=kYCDV+Wz; arc=none smtp.client-ip=95.215.58.115
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="kYCDV+Wz"
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=mx1pndh9NACF4v//8sWUqY+ii9IXnTRJQEeestc8TIE=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790707547; v=1; x=1791312347;
 b=kYCDV+Wz/oIiw/7CAqYDLaSdzzN3PSBeNDAZGP4AeCK5U+uPdtNR2c8+Lk0DsAgQX8254jnC
 Z9PvhTn7nl/8aGcTMHAK+h6cSkrXKPOsiaGiDWrOF3jD4MW3TLJr/sS1+PpbfuGHn9rZlyGzORB
 jeYwiUR15f4xteH/9JeVpxL0=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id 4445f44e488d0c9f;
	Tue, 29 Sep 2026 18:45:46 +0000
X-Mizu-Trace-ID: 4445f44e488d0c9f
X-Migadu-Flow: FLOW_OUT
Received: by mail-lf1-f51.google.com with SMTP id 2adb3069b0e04-5b8ea0ca5baso1078e87.1
        for <kvmarm@lists.linux.dev>; Tue, 29 Sep 2026 11:45:42 -0700 (PDT)
X-Gm-Message-State: AFq9FYK6RH3qBpU7eaJbeEaOYLBLvW5KgivUcs5Jpq3wtRX0aLMhtxNN
	PcsyF4adECrATmsqf4l3dvpRxsvQobEK8lZrnHdMXs/L1JaHHSTXPKybRAoZQdcuZ5hgW9hPq6I
	o4pNurmkTmTts6KOQzSqRuCjN2z4COVT8pXa6+huL
X-Received: by 2002:a05:6512:1052:b0:5b8:c95d:529c with SMTP id
 2adb3069b0e04-5ba3c039e63mr21526e87.0.1790707541274; Tue, 29 Sep 2026
 11:45:41 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260929093548.3598547-1-maz@kernel.org> <20260929093548.3598547-8-maz@kernel.org>
In-Reply-To: <20260929093548.3598547-8-maz@kernel.org>
From: Fuad Tabba <fuad.tabba@linux.dev>
Date: Tue, 29 Sep 2026 19:45:05 +0100
X-Gmail-Original-Message-ID: <CA+EHjTyT7_DvnnPM3H4=o=aTkBksNQuQTTyXB=Jh=uzpRsnEXQ@mail.gmail.com>
X-Gm-Features: AclHuK9ckX2XdpBIMn2iv43c3Ok9eDLeQw0Pba9h2d2_EeCe5NJES3JhNqa7_ho
Message-ID: <CA+EHjTyT7_DvnnPM3H4=o=aTkBksNQuQTTyXB=Jh=uzpRsnEXQ@mail.gmail.com>
Subject: Re: [PATCH v2 7/7] KVM: arm64: vgic-its: Stop the VM when handling MOVALL
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	Steffen Eiden <seiden@linux.ibm.com>, Joey Gouly <joey.gouly@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Oliver Upton <oupton@kernel.org>, 
	Zenghui Yu <yuzenghui@huawei.com>, Yuchao Zhang <ndaugoing@gmail.com>
Content-Type: text/plain; charset="UTF-8"

On Tue, 29 Sept 2026 at 10:36, Marc Zyngier <maz@kernel.org> wrote:
>
> MOVALL is a royal pain, as it requires us to iterate over all the LPIs
> and move them around if they are on the correct source vcpu, and
> requiring locking for each of them.
>
> This locking can result in contention for vcpus that enter and exit
> the guest, and hinders forward progress. In order to make sure such
> process is not contended, just stop the VM altogether.
>
> Nobody in their right mind uses MOVALL anyway, as this is a rather
> braindead aspect of the GICv3 architecture.
>
> Signed-off-by: Marc Zyngier <maz@kernel.org>

This is the only patch in the series without Cc: stable. Was that deliberate?

Reviewed-by: Fuad Tabba <fuad.tabba@linux.dev>
Tested-by: Fuad Tabba < fuad.tabba@linux.dev>

Cheers,
/fuad


> ---
>  arch/arm64/kvm/vgic/vgic-its.c | 11 +++++++++++
>  1 file changed, 11 insertions(+)
>
> diff --git a/arch/arm64/kvm/vgic/vgic-its.c b/arch/arm64/kvm/vgic/vgic-its.c
> index cc02d9b62bd95..094eede267e54 100644
> --- a/arch/arm64/kvm/vgic/vgic-its.c
> +++ b/arch/arm64/kvm/vgic/vgic-its.c
> @@ -1382,6 +1382,15 @@ static int vgic_its_cmd_handle_movall(struct kvm *kvm, struct vgic_its *its,
>         if (vcpu1 == vcpu2)
>                 return 0;
>
> +       /*
> +        * Bulk operations such as MOVALL are a pain, as they can clash
> +        * badly locking-wise with other vcpus entering and exiting the
> +        * guest, should they be affected by it. Stopping the guest is a
> +        * safer bet to ensure uncontended access and ultimately forward
> +        * progress. Yeah...
> +        */
> +       kvm_arm_halt_guest(kvm);
> +
>         xa_for_each(&dist->lpi_xa, intid, irq) {
>                 irq = vgic_get_irq(kvm, intid);
>                 if (!irq)
> @@ -1394,6 +1403,8 @@ static int vgic_its_cmd_handle_movall(struct kvm *kvm, struct vgic_its *its,
>
>         vgic_its_invalidate_cache(its);
>
> +       kvm_arm_resume_guest(kvm);
> +
>         return 0;
>  }
>
> --
> 2.47.3
>
