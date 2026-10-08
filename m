Received: from mta1.migadu.com (out-9.mta1.migadu.com [95.215.58.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01C893B47EF
	for <kvmarm@lists.linux.dev>; Thu,  8 Oct 2026 19:13:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791486800; cv=none; b=a9JuCQGvJgrcsH0Z8TQrgYflaQqmlR6Dgep/vxrIalFGCdeSWUpYiC7SH/Y3BEVQYtrj5fezsgqF61JWercgYw0FLY8XgInz2yzMfQS3vEo8d7T9Sun2/3MGLJ7Et0t/kxdo8qjIaVBOaFaFfbih/wU3HVsCWVxZSGFGcQ6UlFo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791486800; c=relaxed/simple;
	bh=0GTmQaFxokRtWOJdiFeBX/Ou/YTJPcm5FTNprMVwfos=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=mxw0Ex3zgR45AEHyDF7eiSbX9zVael904jOxJhjf0klTkbNzLIqUbOQ4bVv4/Zpb+urN4b+6w7wJHCrY7GZnNZye8oX2FA1YJ4jjx19UA+0XpZ1BXZ16awddQRsy07OBmLkLtHuj/6d5H1jvVCSTVLLN/fhAvopMJkZcS3Laips=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=qmiDuX1t; arc=none smtp.client-ip=95.215.58.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="qmiDuX1t"
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=0GTmQaFxokRtWOJdiFeBX/Ou/YTJPcm5FTNprMVwfos=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1791486796; v=1; x=1792091596;
 b=qmiDuX1tYNXKTIwmZOXkIFB6Fb39sRgLr1Wj+bbRInUNozRo1qZccZHNoMwprW4EfqcK0YCL
 Se0xwgeOYDCeudmyh+ljMixmLdp8XkjslSswIZQ6TY0DIAFK/h50FrFCDlw4wYqN+nXSZY2zox6
 5hyv0vsQ9orz884ZWmYuADrA=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id 32b792a39c59baf9;
	Thu, 08 Oct 2026 19:13:16 +0000
X-Mizu-Trace-ID: 32b792a39c59baf9
X-Migadu-Flow: FLOW_OUT
Received: by mail-lf1-f48.google.com with SMTP id 2adb3069b0e04-5ba40832934so211e87.1
        for <kvmarm@lists.linux.dev>; Thu, 08 Oct 2026 12:13:12 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBz2FFmGOxA8Opn2qGjioeVrlNc8xcoym4wtsiizmg/ZnvzkmRjfkd1ZbYsGgnG3+0kuArpJfks=@lists.linux.dev
X-Gm-Message-State: AFq9FYJdTXDdocU8YDgnBqNLrsNQCVy37sEtBgFs+vj60PqdzhTYOGNd
	PcY4HxNC4e++HMCxmM8FQO5oAWBf3Dj5JmLSLwmWJWVttN6cLaGaAQFFUPpNlYTHVVTjEsKs1uA
	l5EmugGFCOuOlwT9JlunGDtXadsQBxAcKPVqJ0bdp
X-Received: by 2002:a05:6512:3b25:b0:5b8:ebf3:3370 with SMTP id
 2adb3069b0e04-5bcdd51a3c2mr4841e87.5.1791486791535; Thu, 08 Oct 2026 12:13:11
 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20261008104212.3134550-1-vdonnefort@google.com> <20261008104212.3134550-2-vdonnefort@google.com>
In-Reply-To: <20261008104212.3134550-2-vdonnefort@google.com>
From: Fuad Tabba <fuad.tabba@linux.dev>
Date: Thu, 8 Oct 2026 20:12:35 +0100
X-Gmail-Original-Message-ID: <CA+EHjTzworzPjJNdsFuOn8Jy_qDm_dhrgKqVsVKAdhzu7n6+KQ@mail.gmail.com>
X-Gm-Features: AclHuK_YRyUU2-fzg9DOXVPL5Sq1bOD0ID3Nxy6JWAxfr7jy9NZNQ53tG52YgK0
Message-ID: <CA+EHjTzworzPjJNdsFuOn8Jy_qDm_dhrgKqVsVKAdhzu7n6+KQ@mail.gmail.com>
Subject: Re: [PATCH v1 1/2] KVM: arm64: Prevent 64-bit overflow when computing
 hyp clock rate
To: Vincent Donnefort <vdonnefort@google.com>
Cc: maz@kernel.org, oupton@kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, joey.gouly@arm.com, 
	seiden@linux.ibm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, 
	catalin.marinas@arm.com, will@kernel.org, kernel-team@android.com, 
	qperret@google.com, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Thu, 8 Oct 2026 at 11:42, 'Vincent Donnefort' via kernel-team
<kernel-team@android.com> wrote:
>
> The hypervisor clock rate is delta_cycles * NSEC_PER_SEC / delta_boot.
> It is computed whenever a deviation occurs. If the delta between two
> rate updates is big enough, delta_cycles * NSEC_PER_SEC will overflow.
>
> Prevent overflow with mul_u64_u64_div_u64(). And as a bonus, simplify
> the clock estimation with mul_u64_u32_shr().
>
> Fixes: b22888917fa4 ("KVM: arm64: Sync boot clock with the nVHE/pKVM hyp")
> Cc: stable@vger.kernel.org
> Signed-off-by: Vincent Donnefort <vdonnefort@google.com>

Reviewed-by: Fuad Tabba <fuad.tabba@linux.dev>
Tested-by: Fuad Tabba <fuad.tabba@linux.dev>

Cheers,
/fuad
