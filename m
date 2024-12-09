Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2C4BE1B0422
	for <kvmarm@lists.linux.dev>; Mon,  9 Dec 2024 14:24:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733754276; cv=none; b=DlePlV8sCwoQljQhW9oi2ssoSRfulMm/xoGoVlynWWhLXh7R98Qoj335nvbbjMbLd+Vjbcg7AdWpjC0GF60KDNpamb7lrBUZqyaUo7+UsVPC/pd1osG83+0Cgpl2XgEbm9d9rCZcNVuu8Vul57c7RRB5HCFM4DOX83yvgSUhq2U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733754276; c=relaxed/simple;
	bh=Oeo32UMYg5H8XyPLX7x3SN757WLg8xYyo5+dfHLDgN0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=iUraOaraKmx/4CDs91HfTjhoJQAeD40J8Xzg006pvby9/HP5+6qUmpQKfNIY2MJUcgNtJgX/7VKXf32FciSGcYVLld5t82+ZhahQdqqhxfiSdbKg2T3HWXUnggR6YvnqGnDS6dg//m5bJuSV5YeK6E481KBTukkjIbmWTQh0FWc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 69FD91650;
	Mon,  9 Dec 2024 06:24:59 -0800 (PST)
Received: from T9219K2H65.arm.com (unknown [10.119.39.206])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id B0FBC3F720;
	Mon,  9 Dec 2024 06:24:30 -0800 (PST)
From: Chase Conklin <chase.conklin@arm.com>
To: maz@kernel.org
Cc: andersson@kernel.org,
	christoffer.dall@arm.com,
	joey.gouly@arm.com,
	kvm@vger.kernel.org,
	kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	oliver.upton@linux.dev,
	suzuki.poulose@arm.com,
	yuzenghui@huawei.com
Subject: Re: [PATCH 00/11] KVM: arm64: Add NV timer support
Date: Mon,  9 Dec 2024 08:24:29 -0600
Message-Id: <20241209142429.882-1-chase.conklin@arm.com>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
In-Reply-To: <20241202172134.384923-1-maz@kernel.org>
References: <20241202172134.384923-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi Marc,

On Mon, 2 Dec 2024 17:21:23 +0000, Marc Zyngier <maz@kernel.org> wrote: 
> Here's another batch of NV-related patches, this time bringing in most
> of the timer support for EL2 as well as nested guests.
> 
> The code is pretty convoluted for a bunch of reasons:
> 
> - FEAT_NV2 breaks the timer semantics by redirecting HW controls to
>   memory, meaning that a guest could setup a timer and never see it
>   firing until the next exit
> 
> - We go try hard to reflect the timer state in memory, but that's not
>   great.
> 
> - With FEAT_ECV, we can finally correctly emulate the virtual timer,
>   but this emulation is pretty costly
> 
> - As a way to make things suck less, we handle timer reads as early as
>   possible, and only defer writes to the normal trap handling
> 
> - Finally, some implementations are badly broken, and require some
>   hand-holding, irrespective of NV support. So we try and reuse the NV
>   infrastructure to make them usable. This could be further optimised,
>   but I'm running out of patience for this sort of HW.
> 
> What this is not implementing is support for CNTPOFF_EL2. It appears
> that the architecture doesn't let you correctly emulate it, so I guess
> this will be trap/emulate for the foreseeable future.
> 
> This series is on top of v6.13-rc1, and has been tested on my usual M2
> setup, but also on a Snapdragon X1 Elite devkit. I would like to thank
> Qualcomm for the free hardware with no strings (nor support) attached!
> 
> If you are feeling brave, you can run the whole thing from [1].
> 
> [1] https://git.kernel.org/pub/scm/linux/kernel/git/maz/arm-platforms.git/log/?h=kvm-arm64/nv-next
>

I was feeling brave, and I think I see an issue in the cpufeature change
in the kvm-arm64/nv-e2h-select branch that's a part of
kvm-arm64/nv-next. In d75a4820a897 ("arm64: cpufeature: Handle NV_frac as a synonym of NV2"),
I don't see NV_frac being added to the FTR bits. I believe that means it
will get sanitized out and consequently not seen by the NV feature
detection code. Does that commit also need:

diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
index 9fa8bd77ae0..f97459e160b 100644
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -480,6 +480,7 @@ static const struct arm64_ftr_bits ftr_id_aa64mmfr3[] = {

 static const struct arm64_ftr_bits ftr_id_aa64mmfr4[] = {
        S_ARM64_FTR_BITS(FTR_HIDDEN, FTR_STRICT, FTR_LOWER_SAFE, ID_AA64MMFR4_EL1_E2H0_SHIFT, 4, 0),
+       S_ARM64_FTR_BITS(FTR_HIDDEN, FTR_STRICT, FTR_LOWER_SAFE, ID_AA64MMFR4_EL1_NV_frac_SHIFT, 4, 0),
        ARM64_FTR_END,
 };

Thanks,
Chase
