Received: from mta0.migadu.com (out-191.mta0.migadu.com [91.218.175.191])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD5273B8D7B
	for <kvmarm@lists.linux.dev>; Mon, 28 Sep 2026 07:45:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.191
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790581520; cv=none; b=eS8D7l2oYTuC+z+r92NBtH/Ycg/IaMH9eB1X+ZOWvyE6I0BMNLG438kamP/HM9uAytsibJ2SPhqhZz67StFRjaIG5stxkUg5TE/14/ENUHnDPMesPWK/a+fp0jbU145MOd0//JVQaU3H7NLH231AvI7JaxngeitxaqBBAycUuM0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790581520; c=relaxed/simple;
	bh=szjlKSRr4QKhQ/BXliXytwAbzwuxRJ9hxfloPYxH0y4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=sd1b4WuNhTO5q65EUAr7Qv3EAAXCNLXZOoN6SOf5o6lnWcn9QIfGTLIue5O+xXZ/7tQp283Ntn/IBXJiwWYje86d6pyfSRljRRI0blF7z4sEy0E3DEGpB7tEmGkgXYilpLhwSDrw3AOhvJprVY/8iaPS5MB5duJua4zeTWvFBXc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Ys1MQIke; arc=none smtp.client-ip=91.218.175.191
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Ys1MQIke"
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=szjlKSRr4QKhQ/BXliXytwAbzwuxRJ9hxfloPYxH0y4=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790581516; v=1; x=1791186316;
 b=Ys1MQIkeV/eujertlX2VWFwU5ezKap/9dVAzfbmEUf6DnUlEv6WYezG9dz1+jOx+y/kygCmf
 E2Xhp5k25mlYqXyOL/YxtHl/EB3OaMU3Fehd+dE86cLoeZNIy9JYdk79KTmR5rCWZM7RY+6/9lv
 RyZDhXCfnIXPT3us1N30YlYk=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id ed11c0e404fd6af9;
	Mon, 28 Sep 2026 07:45:16 +0000
X-Mizu-Trace-ID: ed11c0e404fd6af9
X-Migadu-Flow: FLOW_OUT
Received: by mail-lf1-f52.google.com with SMTP id 2adb3069b0e04-5b8c42da963so9545e87.0
        for <kvmarm@lists.linux.dev>; Mon, 28 Sep 2026 00:45:11 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBwKo9FIDhpeObMi7GffUj1PQ89ZuOzpjbsqv3TxXihuqo4kcXB7oq5t3oxXYaL8HvLubrg7f3Y=@lists.linux.dev
X-Gm-Message-State: AFq9FYK3JSK3uE9pkuTrDsCNe4VOUqNnkor6lzl9QcEdzV7qSpvjtFAu
	k8VP3Ry/VvR5cX1Niw1tjGH8Sx3c4gPWDBm+XiP3sQQ6ke4cKDLQDSPVSRjV+WGeHQD7YjXjZ8V
	RL3mJ0Sc8DESfSzjbOeolwuoOac2hvUwp/rHCK79J
X-Received: by 2002:a05:6512:1386:b0:5ae:cf5f:4a88 with SMTP id
 2adb3069b0e04-5b8ef2571demr154509e87.8.1790581510337; Mon, 28 Sep 2026
 00:45:10 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260922130821.1666713-1-vdonnefort@google.com>
 <20260922130821.1666713-6-vdonnefort@google.com> <am2rfnuwjkglavbtzkt2lk2gclahvca5irrv5me4vppzkotexf@yauajpybhsnm>
 <87qzie3beb.wl-maz@kernel.org>
In-Reply-To: <87qzie3beb.wl-maz@kernel.org>
From: Fuad Tabba <fuad.tabba@linux.dev>
Date: Mon, 28 Sep 2026 08:44:33 +0100
X-Gmail-Original-Message-ID: <CA+EHjTwwxL3Cs-7B2NgEyedu-ZQFt96ck_V-erCUaTB=hrh5eg@mail.gmail.com>
X-Gm-Features: AclHuK-ALEhQXkggSsAxXnC2DJjXeZyCoNf81U4HcBABH4AnShcbMTLpdrkikjI
Message-ID: <CA+EHjTwwxL3Cs-7B2NgEyedu-ZQFt96ck_V-erCUaTB=hrh5eg@mail.gmail.com>
Subject: Re: [PATCH v1 5/6] KVM: arm64: Use kvm_s2_fault_vma_info in gmem_abort()
To: Marc Zyngier <maz@kernel.org>
Cc: Wei-Lin Chang <weilin.chang@arm.com>, Vincent Donnefort <vdonnefort@google.com>, oupton@kernel.org, 
	kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	joey.gouly@arm.com, seiden@linux.ibm.com, suzuki.poulose@arm.com, 
	yuzenghui@huawei.com, catalin.marinas@arm.com, will@kernel.org, 
	kernel-team@android.com, qperret@google.com, Sashiko <sashiko-bot@kernel.org>, 
	stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Hi Marc, Wei-Lin,

On Sun, 27 Sep 2026 17:30:04 +0100, Marc Zyngier <maz@kernel.org> wrote:
[...]
> > Perhaps it is worth reserving plain "gfn" for the value we use as the
> > IA of the (shadow) page table, and name this variable something like
> > canonical_gfn. Similar to what kvm_s2_fault_map() does.
>
> Maybe. We have gfn in the vncr fault handling code as well, but that
> one is the result of a S1 walk, so maybe more obvious.

Agreed, now that s2vi.gfn sits next to it. I'll rename it to
canonical_gfn for v2.

> > Huh, I guess you also fixed a bug here? s2fd->fault_ipa could be the
> > nested ipa instead of the canonical ipa.
>
> Yeah, it appears so. Worth capturing in Fixes: as well.

That one came in with a7b57e0995927 too, so the existing Fixes: covers
it. I'll mention it in the commit message.

Cheers,
/fuad
