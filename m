Received: from mta0.migadu.com (out-15.mta0.migadu.com [91.218.175.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EB514BD37C
	for <kvmarm@lists.linux.dev>; Thu, 17 Sep 2026 10:14:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789640049; cv=none; b=hHXJf0xvXCcAS17NCx8Ir/8+PEsbjj8ettK3mxIA3c409ChcaDakNFaMzEH9pBwaNJYkgDsWSruY5ntAqO2dhijahwMdb3YK19zVdsTavL4Y/WvmMcYg9sr8+kpZe9K2Zxe+oTWyoYBYAfagDbl21ltnwQZa34ILNTmFOfljcf8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789640049; c=relaxed/simple;
	bh=Rbo7h4rkxRDnvPMepezk1IQU7FqRhlGxXh1btLN5y2E=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=RpnbhY07anSFrWSPCTgKDV7RhzGd77+DbYtV0Kbwv2/NUMU4IPNH4yxv9w3LTL1JmB7XwLO8Ho6MWO3H7XK/6moA+lvJN7YYKIhaE8oeE9ShhX2qPsEl+17CHLXz7Ubs5naNIr3ymXWAIKm6nhSW4PfUU4V4EFUhuBBx0lNPu7w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=BqWF7g4l; arc=none smtp.client-ip=91.218.175.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="BqWF7g4l"
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=Rbo7h4rkxRDnvPMepezk1IQU7FqRhlGxXh1btLN5y2E=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789640040; v=1; x=1790244840;
 b=BqWF7g4lvcVWDqDnNWw24XIyP1iH6aNOJTA2/AuJpZAoRpHChJhY8bO7oeSfuye9D4UOrOdL
 hcdt2Fnee7YvygHHj5J9lmwur3ckvlui0AdKV2UMB8PAAy/MtEeESFCU+5jWdHspMMJCb/G3VA/
 Q6s7DUzRS+iICaJUu8KYAvro=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id 583573aaa3766c0d;
	Thu, 17 Sep 2026 10:14:00 +0000
X-Mizu-Trace-ID: 583573aaa3766c0d
X-Migadu-Flow: FLOW_OUT
Received: by mail-lf1-f53.google.com with SMTP id 2adb3069b0e04-5b7658501ccso402e87.0
        for <kvmarm@lists.linux.dev>; Thu, 17 Sep 2026 03:14:00 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBy9sI75by2awugRK9t4Tf/1b04TdXG2diDtYpLhX1JERVWCyngVvnnAQ7MXIHobRFStBswoRuY=@lists.linux.dev
X-Gm-Message-State: AFuF++k4hqRErLR0q2yzY64SNxDBYulhVPRusMNtBNpN3U7qA0X78tfE
	axYgMeXqx66K37Fa0rA8PJ+locjcROlSqV64+Ro4wZQtEzLHgB5hmTnxveS4Oz3m6Llbudhw+1H
	Av7kQKMluOMSjFrlH5hhnZUZCn4TRsN5ysTE+shIa
X-Received: by 2002:a05:6512:2241:b0:5b4:9dba:7403 with SMTP id
 2adb3069b0e04-5b8bff3eb66mr3729e87.13.1789640039154; Thu, 17 Sep 2026
 03:13:59 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260917081510.1539013-1-vdonnefort@google.com>
In-Reply-To: <20260917081510.1539013-1-vdonnefort@google.com>
From: Fuad Tabba <fuad.tabba@linux.dev>
Date: Thu, 17 Sep 2026 11:13:23 +0100
X-Gmail-Original-Message-ID: <CA+EHjTy+4m9Ot6ffBaGDyGEHu-aTSrLGUAGn+e9EvWnapeSv4Q@mail.gmail.com>
X-Gm-Features: AcwNN1VBxrUJEsCWo-F6cReUIsV9zhdoQgfQgwlbqAmSpDfO-6YQjEKPuIzcJo0
Message-ID: <CA+EHjTy+4m9Ot6ffBaGDyGEHu-aTSrLGUAGn+e9EvWnapeSv4Q@mail.gmail.com>
Subject: Re: [PATCH v1] KVM: arm64: Disable stage-2 ptdump of pKVM
To: Vincent Donnefort <vdonnefort@google.com>
Cc: maz@kernel.org, oupton@kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, joey.gouly@arm.com, 
	seiden@linux.ibm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, 
	catalin.marinas@arm.com, will@kernel.org, kernel-team@android.com
Content-Type: text/plain; charset="UTF-8"

Hi Vincent,

On Thu, 17 Sep 2026 09:15:10 +0100, Vincent Donnefort
<vdonnefort@google.com> wrote:
[...]
> Fixes: 7c4f73548ed1 ("KVM: arm64: Register ptdump with debugfs on guest creation")

I was wondering if this should be fce886a60207 ("KVM: arm64: Plumb the
pKVM MMU in KVM") instead? Before that commit EL2 ran the guest on the
host's kvm_s2_mmu, so the files dumped the tables in use.

> Signed-off-by: Vincent Donnefort <vdonnefort@google.com>

Reviewed-by: Fuad Tabba <fuad.tabba@linux.dev>
Tested-by: Fuad Tabba <fuad.tabba@linux.dev>

Cheers,
/fuad
