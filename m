Received: from mta1.migadu.com (out-147.mta1.migadu.com [95.215.58.147])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F1AC3D9DBC
	for <kvmarm@lists.linux.dev>; Wed,  7 Oct 2026 10:44:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.147
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791369909; cv=none; b=popkzes06LZ4A6orPkIL/4o0eW3c2Cwu4rGAmYJ9Qx+0D893g6JSCdoOcr2hhM3k/SQXDad/bd9NuK4FX+yq7iU4qXFu3YioSnFlboFptzUIZoD5GKToMaKQX+362D9eYhliaFKyV5UWUmXesjc0jqzWS7QmHOELHjJC3155oWI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791369909; c=relaxed/simple;
	bh=/01lQesds7Qu15IlWJStcj8pAkrlNp3+XW9pTMK80Mw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=BtW+wUSgvDSxx4DlyjVqTvqPJfBOxGIIIjjwx3qus+aRJlaG4OlHuK3xieMrRr2VkvWocllA/cDR5c1qfMqCZjkWqqWL4qi36Bx2zdykz/4h59QD5wTIdx6q7TeEmWC+LsH75V4Ip4g1dJUYv6SWO5nCVg89hkJ6k2/ghsZIinI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=ggf02xtr; arc=none smtp.client-ip=95.215.58.147
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="ggf02xtr"
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=/01lQesds7Qu15IlWJStcj8pAkrlNp3+XW9pTMK80Mw=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1791369865; v=1; x=1791974665;
 b=ggf02xtrLPDITP4JstEBlxtfrPO9RQajrPPpG5+puboHO2c1frjgSgN33HSGgziDMHMXyCkY
 BWEdGK+Lh2rIv/tpNLicXtRW2yBA5CfvXlmhdBDwyfuDtinQ3ZEiYXTpakZMtjDmvVBoGM1qTsE
 WTQV0zKwMLUKxazScL/BSRlQ=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id 95f10c7bbfdbd443;
	Wed, 07 Oct 2026 10:44:25 +0000
X-Mizu-Trace-ID: 95f10c7bbfdbd443
X-Migadu-Flow: FLOW_OUT
Received: by mail-lf1-f42.google.com with SMTP id 2adb3069b0e04-5bcbb378fc9so7738e87.0
        for <kvmarm@lists.linux.dev>; Wed, 07 Oct 2026 03:44:21 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBzCtUYbamc8fnV/TSFXA5BEyXcamxtsVGdb0MHHSwdHssErFFtVOrT3oAfMjrfyYAooZI+33gY=@lists.linux.dev
X-Gm-Message-State: AFq9FYJv/V072dDJDkkWdqw93/CV9lNYAonDSb00G1UUE2ctCm5CpLlr
	08cuwACYa7iVjNxpLpsKyEprU62woh9BiKtDQBVtly7qq6FtNe8ETu2cnKrBlv0Pk7Y3yinxSs8
	Q3DAf+qK4yX9k2GmvBOtJblQI2FcVo5HJSkNvkhBs
X-Received: by 2002:a05:6512:2c9b:b0:5bb:27df:415f with SMTP id
 2adb3069b0e04-5bcca969b08mr280500e87.15.1791369860573; Wed, 07 Oct 2026
 03:44:20 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20261007073537.2454351-1-suzuki.poulose@arm.com> <20261007073537.2454351-2-suzuki.poulose@arm.com>
In-Reply-To: <20261007073537.2454351-2-suzuki.poulose@arm.com>
From: Fuad Tabba <fuad.tabba@linux.dev>
Date: Wed, 7 Oct 2026 12:43:44 +0200
X-Gmail-Original-Message-ID: <CA+EHjTy44W8srPO2y2MJT7nijeWcek-BLsiwYfSPXVOA8DpRCQ@mail.gmail.com>
X-Gm-Features: AclHuK9bYO3-lIjbLvu1WEmia2gdqzHBdvJpWxSZu00WMWjDLerDBVC4C9fwiYI
Message-ID: <CA+EHjTy44W8srPO2y2MJT7nijeWcek-BLsiwYfSPXVOA8DpRCQ@mail.gmail.com>
Subject: Re: [PATCH v23 01/14] KVM: arm64: protected VM: Handle user writes to CNTVCT_EL0/CNTPCT_EL0
To: Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev, maz@kernel.org, 
	will@kernel.org, catalin.marinas@arm.com, linux-kernel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, steven.price@arm.com, 
	aneesh.kumar@kernel.org, oupton@kernel.org, gshan@redhat.com, 
	joey.gouly@arm.com, yuzenghui@huawei.com, linux-coco@lists.linux.dev, 
	gankulkarni@os.amperecomputing.com, sdonthineni@nvidia.com, 
	alpergun@google.com, fj0570is@fujitsu.com, WeiLin.Chang@arm.com, 
	lpieralisi@kernel.org, enju.kohei@fujitsu.com, sudeep.holla@arm.com, 
	jonathan.cameron@oss.qualcomm.com
Content-Type: text/plain; charset="UTF-8"

On Wed, 7 Oct 2026 at 09:35, Suzuki K Poulose <suzuki.poulose@arm.com> wrote:
>
> Protected VMs doesn't allow setting offsets for virtual and physical
> counters, as the offset is always fixed to 0. The VM ioctl is filtered
> out based on the cap. However we don't prevent the userspace from trying
> to write to the CNTVCT/CNTPCT registers. This would lead to KVM triggering
> a WARN() in timer_set_offset() as the vm_offset pointer is set to NULL.
>
> Fix this by always "fixing" the timer offsets to 0 and marking that the
> timer offset is set in the kvm->arch.flags at KVM init time for protected
> VMs. This prevents the access to the VM specific vm_offset at low cost.
> A userspace writing to the CNT*CT_EL0 would observe success, without
> any real effect. This is cleaner over spilling "*_is_protected()"
> checks and "matches" what we really do in practise. i.e., always run
> with "fixed counter offset of 0".
>
> Reported by Sashiko
>
> Link: https://lore.kernel.org/all/20260908164641.416911F00A3A@smtp.kernel.org
> Fixes: f7d05ee84a6a ("KVM: arm64: Prevent host from managing timer offsets for protected VMs")
> Suggested-by: Marc Zyngier <maz@kernel.org>
> Reviewed-by: Gavin Shan <gshan@redhat.com>
> Tested-by: Gavin Shan <gshan@redhat.com>
> Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>

Reviewed-by: Fuad Tabba <fuad.tabba@linux.dev>

Cheers,
/fuad
