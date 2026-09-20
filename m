Received: from mta0.migadu.com (out-172.mta0.migadu.com [91.218.175.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A77AF35E1AD
	for <kvmarm@lists.linux.dev>; Sun, 20 Sep 2026 14:43:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789915426; cv=none; b=PP4c1k8/SV+mvaMn1zRek6x3dufSUpP0YIyE2pAEd02nzO0nPqPjTsaLvDFtTr/pWz2BJzGl2GUFPzKMaKnyznTUclDdHNlPmBbAcdEfAvw5B2waPytKdHCJHPoaM8ZjRREUXgbRfRs9Rmq0ReWNOnzioJAaXAyup/BWXHA0vfA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789915426; c=relaxed/simple;
	bh=MTh/Rh8efZWBx15ABw7iMVCiV0cUUTDH8XrvmFa84wg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=kGB/MT2q91zcIsmwW/L0X6+BpZCt1URDCifu5HUz+bshGWAJyG5xljDR4NwSwGk3sIVwyqB70aMwQOObKLzYIczeRlHRpSaCa2uyTIk4D8a+ni90Ib2wxnYbljj5AzG0aIwWgeECr8Ui6Fm3CHGHxhFyF8EMRfVJCOEtLe9kDCQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=rdyt9Wbv; arc=none smtp.client-ip=91.218.175.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="rdyt9Wbv"
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=MTh/Rh8efZWBx15ABw7iMVCiV0cUUTDH8XrvmFa84wg=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789915422; v=1; x=1790520222;
 b=rdyt9WbvKsWxQXrSsGYP7NZYMgN23PmRk+O2WCv3+eVvoyMiQiU0PdwVeDkXksbVHNghQNfK
 70l1mbwTb/aZOCMpX+GDx+VR5ULwgKWx15DSYLTYFRFfxmTXJ9UswWYe6h72MzWV+C16eVkMe4f
 N4OJErXPoAjQw+JC8HI8mzIc=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id 22af061beb359480;
	Sun, 20 Sep 2026 14:43:42 +0000
X-Mizu-Trace-ID: 22af061beb359480
X-Migadu-Flow: FLOW_OUT
Received: by mail-lf1-f45.google.com with SMTP id 2adb3069b0e04-5b5e5aaf7deso4274e87.0
        for <kvmarm@lists.linux.dev>; Sun, 20 Sep 2026 07:43:38 -0700 (PDT)
X-Gm-Message-State: AFuF++mDLxYKevX0tYgzjW1E5+IoknR4AYGyxFeEyZw4+/dB5EOXTY3G
	Oiad14yCUZHqdD0h+/LivNZla4uoOLYNBR0bAAr5CD/hFzS4zBtZJ+x25z8E+c2ZvBltEYvmWJW
	mgSma+HMge1g3xpS8agZLBx9rn/xZkMgm5d+8/ooD
X-Received: by 2002:a05:6512:ba8:b0:5b6:4ae:3ff0 with SMTP id
 2adb3069b0e04-5b8c7eae35bmr74990e87.15.1789915417530; Sun, 20 Sep 2026
 07:43:37 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260919123150.3283606-1-maz@kernel.org> <20260919123150.3283606-2-maz@kernel.org>
In-Reply-To: <20260919123150.3283606-2-maz@kernel.org>
From: Fuad Tabba <fuad.tabba@linux.dev>
Date: Sun, 20 Sep 2026 15:43:01 +0100
X-Gmail-Original-Message-ID: <CA+EHjTzYhaG+J+JQNA=oU6230_AfNQnPnbg0jysjsU-F_ZrKWQ@mail.gmail.com>
X-Gm-Features: AcwNN1WjAy57Oih6nCrLbvUS6fVUqyWByy2r3gykJEx1FzTGQZWbKmo2YjjSows
Message-ID: <CA+EHjTzYhaG+J+JQNA=oU6230_AfNQnPnbg0jysjsU-F_ZrKWQ@mail.gmail.com>
Subject: Re: [PATCH 1/4] KVM: arm64: vgic-v5: Drop __iomem attribute from {vmd,vpet}_base
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	Steffen Eiden <seiden@linux.ibm.com>, Joey Gouly <joey.gouly@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Oliver Upton <oupton@kernel.org>, 
	Zenghui Yu <yuzenghui@huawei.com>, Sascha Bischoff <sascha.bischoff@arm.com>
Content-Type: text/plain; charset="UTF-8"

On Sat, 19 Sept 2026 at 13:31, Marc Zyngier <maz@kernel.org> wrote:
>
> Both vmd_base and vpet_base are pointers to kmalloc'd memory, and
> therefore cannot carry the __iomem attribute, which designates pointers
> to MMIO.
>
> Drop the abusive qualifier.
>
> Reported-by: kernel test robot <lkp@intel.com>
> Closes: https://lore.kernel.org/oe-kbuild-all/202609190650.liMAzwjF-lkp@intel.com/
> Signed-off-by: Marc Zyngier <maz@kernel.org>

Reviewed-by: Fuad Tabba <fuad.tabba@linux.dev>

Cheers,
/fuad


> ---
>  arch/arm64/kvm/vgic/vgic-v5-tables.h | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/arch/arm64/kvm/vgic/vgic-v5-tables.h b/arch/arm64/kvm/vgic/vgic-v5-tables.h
> index b2ffbe68c05b4..89096926563f7 100644
> --- a/arch/arm64/kvm/vgic/vgic-v5-tables.h
> +++ b/arch/arm64/kvm/vgic/vgic-v5-tables.h
> @@ -23,8 +23,8 @@ struct vmtl2_entry {
>  typedef __le64 vpe_entry;
>
>  struct vgic_v5_vm_info {
> -       void __iomem            *vmd_base;
> -       vpe_entry __iomem       *vpet_base;
> +       void                    *vmd_base;
> +       vpe_entry               *vpet_base;
>         void                    *vped_base;
>         u8                      vpe_id_bits;
>
> --
> 2.47.3
>
