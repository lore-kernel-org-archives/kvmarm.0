Received: from mta0.migadu.com (out-231.mta0.migadu.com [91.218.175.231])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BF8F3D16E9
	for <kvmarm@lists.linux.dev>; Mon, 14 Sep 2026 06:15:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.231
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789366542; cv=none; b=Hqa61Fiv2IjB4RqtgNxCVQRvBj1cewiNF4ed0V9h8Mzwqz0o2zbA6eEtK46QeW0WvsaPYmyFHQSrYlrgnfuCfGX0OYfAynqEMN6doEa4kmOi0RRqaI0SztLjM//GHW4Bqmt9IY7py0nhUt8URX0y2bwNVYCf9pRXzoyspgZZXQ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789366542; c=relaxed/simple;
	bh=bco0eZaaCo0kOj6rwGEtGduTKDKE8JkIclgbB8/hdn4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=npJX5/3ArDO4gFc8nrXfA3nBoXgp4y11MhxRTDMw4ZWPnTxU0StdSWVwNRyZzNMvJWi8uBEvW49/f0ejskzxofTscuaC151A8ElnmeTfaEkChHzHlrsdlnlieEwCETCCXKhhTmNlsoHa2jmtFRE9EKMjyH7oOmz4O4NfoJ4w1g8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=uHps0zFI; arc=none smtp.client-ip=91.218.175.231
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="uHps0zFI"
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=bco0eZaaCo0kOj6rwGEtGduTKDKE8JkIclgbB8/hdn4=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789366538; v=1; x=1789971338;
 b=uHps0zFIi/QVE2cePZ4w3JsHCEOVJK43mD/yCBVnv4oPZRX5/T7SWMjqHpnYJ8GyXYx5HYWO
 WxEvkGnPIHijwCCmxRyKYhuhSEfFed41niyi78dKCUKRI3N2BmyipaqjPgjvkMXoUNhHzsFK5aP
 zfu6SwGOqsAjslzt8g1KoCy4=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id 9684c99f88629aef;
	Mon, 14 Sep 2026 06:15:38 +0000
X-Mizu-Trace-ID: 9684c99f88629aef
X-Migadu-Flow: FLOW_OUT
Received: by mail-lf2-f12.google.com with SMTP id 2adb3069b0e04-5b78e073980so4928e87.1
        for <kvmarm@lists.linux.dev>; Sun, 13 Sep 2026 23:15:33 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBy01nvkJLu7AyAFY678Ri2pBdWq7ln1Gd90bJH+7r7dvklVhSH2nsEln+yEE55WsHbjvlb5dN4=@lists.linux.dev
X-Gm-Message-State: AFuF++kdpAsJAJ63T5UxnYYqqmXBUFbPO6ZPuz2L3ygsSJB74yab7Ksm
	rglLul5wAcFDr+RVUtltQV4GGcR/n1ogmivNo9gBnBs7UP5nvuGlFt+4uwb03uYPrboKPUw4U47
	ZQzkgpWh+0fCRfjpbip5MXP1WuG+lpymG/zu4Fc+R
X-Received: by 2002:a05:6512:3503:b0:5b4:9dba:4ecf with SMTP id
 2adb3069b0e04-5b8af7af84amr10114e87.13.1789366532332; Sun, 13 Sep 2026
 23:15:32 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260907070002.3333525-1-fuad.tabba@linux.dev>
 <20260907070002.3333525-11-fuad.tabba@linux.dev> <86ik4b7uvh.wl-maz@kernel.org>
In-Reply-To: <86ik4b7uvh.wl-maz@kernel.org>
From: Fuad Tabba <fuad.tabba@linux.dev>
Date: Mon, 14 Sep 2026 07:15:00 +0100
X-Gmail-Original-Message-ID: <CA+EHjTw0mERkhV+nf7KdbzOCbGGqJ6N31360dOFKshj5td38LQ@mail.gmail.com>
X-Gm-Features: AcwNN1Vrar7EeAIoZzg3TV6xpg1zXNdc3Yebl-ujX0EmE0S2Uy_2l65154ZS_Tw
Message-ID: <CA+EHjTw0mERkhV+nf7KdbzOCbGGqJ6N31360dOFKshj5td38LQ@mail.gmail.com>
Subject: Re: [PATCH v2 10/17] KVM: arm64: Prevent host PC adjustments for
 protected vCPUs
To: Marc Zyngier <maz@kernel.org>
Cc: Oliver Upton <oupton@kernel.org>, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
	Joey Gouly <joey.gouly@arm.com>, Steffen Eiden <seiden@linux.ibm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Vincent Donnefort <vdonnefort@google.com>, Quentin Perret <qperret@google.com>
Content-Type: text/plain; charset="UTF-8"

Hi Marc,

...

> So this is the sole reason why we need to access the kvm structure,
> and the cause for all of this churn. Can't this be written as some
> form of:
>
>     kvm = vcpu_get_kvm(vcpu);
>
>     [do whatever is needed]
>
>     vcpu_put_kvm(vcpu, kvm);
>
> where get/put do the pinning/unpinning as required? These helpers
> would become NOPs on VHE, for example.

I've put the get/put pair one level up instead, in __kvm_adjust_pc()
itself: pkvm_adjust_pc_get() returns the vCPU to adjust and
pkvm_adjust_pc_put() copies PC_UPDATE_REQ back, both no-ops outside
the nVHE build and outside protected mode. The kvm read goes back to
the base's kern_hyp_va(vcpu->kvm), and exception.c keeps its
signatures.

> And this stuff could simply be a similar set of helpers in
> __kvm_adjust_pc(), the original one.

That's where it lives now, and this patch no longer touches
handle___kvm_adjust_pc().

> > +    /* The host copy is authoritative, used only while pinned. */
> > +    if (hyp_pin_shared_mem(host_vcpu, host_vcpu + 1))
> > +        return;
>
> Huh. Really?

After taking a closer look I realized that we have a live bug, and
this is actually a fix. The base dereferences the host vCPU unpinned
in this handler, and the vCPU and its VM are mapped at EL2 only once
pinned, at the first KVM_RUN. KVM_SET_VCPU_EVENTS with
ext_dabt_pending gets to __kvm_adjust_pc() before that, and the
hypervisor panics on the read. Any process with /dev/kvm on a pKVM
host can trigger it, since 6.17 (efa1368ba9f4b). I'll send it as a
separate fix before sending V3 (later today).

Cheers,
/fuad
