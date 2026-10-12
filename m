Received: from mta0.migadu.com (out-100.mta0.migadu.com [91.218.175.100])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE7E030D41B
	for <kvmarm@lists.linux.dev>; Mon, 12 Oct 2026 14:14:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.100
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791814475; cv=none; b=tralBorXr5FVrSA9WBeP7+aaCdi54ZggXQ1P5o8ZwBJwrVHISNx0LJd+m8KnWzHaT+J9bzyXq3F9ZyV8YW6PN6GI9s+znc8XDrql5vf4CYvgyT2CjFoaT8DNB8j8YtRE2wHB8xJjTy9OSP4FkGHnq5TC0XP1u6B9ZYCnU9u+V5Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791814475; c=relaxed/simple;
	bh=BU8FrrYxJtVjuWI+jaNz6hLEtjMMOJYa/QcIW3P8I8U=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=F2slcuVth9eT8Fdf4IJwRcr0snPqtFZrDoGqJpbusl07K47d0eF2192Z94uicLAvJxQvRHZDsFx7cl8QVhlVseBlfY0RTeNE0avcrbOQw+6Rt6JQWdV4f010RF1T3HIAwITSfnNuo+KdhD9fVqm9byGp/FmL//Az23U1VoUMxV4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=N9T3SVF0; arc=none smtp.client-ip=91.218.175.100
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="N9T3SVF0"
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=BU8FrrYxJtVjuWI+jaNz6hLEtjMMOJYa/QcIW3P8I8U=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1791814469; v=1; x=1792419269;
 b=N9T3SVF0nUZhqqcpvEwAbb3RrcVW2DMqtRuMp4Gm7LCs6YiICocesBgderiLIFG6zRR9fcM4
 YaYrdGuXqCjX+GMTt2v4pW4JPVNMYESfbEt1tLuI+tDQ4VqCy/akDJElRvR1mbx2Q1fwEIGGcM6
 uaNh7AP7r37A49B4wL38hyjU=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id da8de25c92919491;
	Mon, 12 Oct 2026 14:14:29 +0000
X-Mizu-Trace-ID: da8de25c92919491
X-Migadu-Flow: FLOW_OUT
Received: by mail-lf1-f41.google.com with SMTP id 2adb3069b0e04-5ba40832934so7810e87.1
        for <kvmarm@lists.linux.dev>; Mon, 12 Oct 2026 07:14:28 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBxYGAkCtQI1LqiYvU3sba0SMZAu94J0pYW31eaYLoSmumjKEo3ovbnbYDr7CcAbkRsU16bpcmk=@lists.linux.dev
X-Gm-Message-State: AFq9FYKYjO7V+OUEJINEh89jwKpAV2lTs8z8yWIP4JfzyYOwR/TNSnCq
	CqxS8w/JuG79ZnLutCW6ePgL938oXjeSkBlNA8eNgZ1sIodMbHj7Z7TzJkWBZm1UM7zOuGwqRlh
	BcKahiluh5Hmt3Gt6E3avGZBme5QxMUZWqZJmaZLU
X-Received: by 2002:a05:6512:3043:b0:5bb:661:7db4 with SMTP id
 2adb3069b0e04-5bce97ff24cmr161841e87.0.1791814467633; Mon, 12 Oct 2026
 07:14:27 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20261012084743.2228612-1-fuad.tabba@linux.dev> <8633ub2mlg.wl-maz@kernel.org>
In-Reply-To: <8633ub2mlg.wl-maz@kernel.org>
From: Fuad Tabba <fuad.tabba@linux.dev>
Date: Mon, 12 Oct 2026 15:13:51 +0100
X-Gmail-Original-Message-ID: <CA+EHjTwyQPPVG4tGY0i0DRk=kwbdEmjca6+GNjLDXrGxkNbMOw@mail.gmail.com>
X-Gm-Features: AclHuK8JAr7VKAyNHjXlm8W06MLq8y4tWsehOxWPWjdhocCzuow2M7Ozid4Azug
Message-ID: <CA+EHjTwyQPPVG4tGY0i0DRk=kwbdEmjca6+GNjLDXrGxkNbMOw@mail.gmail.com>
Subject: Re: [PATCH v1] KVM: arm64: vgic-v4: Don't forward an LPI with no
 target vCPU
To: Marc Zyngier <maz@kernel.org>
Cc: Oliver Upton <oupton@kernel.org>, Joey Gouly <joey.gouly@arm.com>, 
	Steffen Eiden <seiden@linux.ibm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Hi Marc,

On Mon, 12 Oct 2026 12:18:51 +0100, Marc Zyngier <maz@kernel.org> wrote:
[...]
> Isn't the core problem that we don't correctly handle the UNPRED
> double mapping of the same LPI? I'd rather we attack the issue at the
> source instead of papering over the consequences.
>
> I hacked the following, which is obviously untested. Can you give it a
> go?

With your diff on rc3, the second MAPTI is dropped, and forwarding the
vfio-pci MSI to its event leaves the host up.

However, a vgic_irq outlives its ITE while the LPI is pending on a
vCPU, so the check also drops a legitimate remap: a guest that
DISCARDs a pending LPI and then maps it again loses the new mapping.
On QEMU, rc3 (baseline) keeps it and your diff drops it.
vgic_its_restore_ite() also goes through vgic_add_lpi(), so restoring
tables that hold a double mapping fails with -EEXIST.

v2, which I'm still testing, drops the second mapping at MAPTI too,
but tracks in the vgic_irq whether an ITE maps it and checks that
instead. A restore keeps the first ITE and drops the duplicate. I'll
send it tomorrow.

Cheers,
/fuad
