Received: from mta0.migadu.com (out-165.mta0.migadu.com [91.218.175.165])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF7763264D9
	for <kvmarm@lists.linux.dev>; Sun, 20 Sep 2026 14:42:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.165
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789915373; cv=none; b=aC2qwU3b2DPm6Lr8OibYQlixDMv0vEq0tH73yA8CnhC/8o5XDCvIhR5PKkJ+5NNZFnRHdNlCeK9ieqKvpIx7V4EkE3RWgg66lxp9xRk0smeR+mUPYBDNMuMhv7lyARDf2gB88hncedw6VFeWus7W/36Jdj8I3OSrMr4YFHiwR5c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789915373; c=relaxed/simple;
	bh=1fWy5x8YUx7dVmmzZ+KhqPpbDf3gNkSDlagAqcQGkLg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Z5CSbi/SxwvRygh6WN36ehxi+Vh/PHxUJKitUxpbQfKSP8Z3791Bd3/X5F5xMIa4aIwd/zaV9aMlL5douHn/ZzZG2MTidyz4LMJE+V7Xsjqvx9cPbnTQPqX39xh3CZg6HJDB69DY53RyKa0fnOMWHLPzN7g0GNB6XlrNc9V2DNM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=jAb/baiS; arc=none smtp.client-ip=91.218.175.165
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="jAb/baiS"
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=1fWy5x8YUx7dVmmzZ+KhqPpbDf3gNkSDlagAqcQGkLg=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789915368; v=1; x=1790520168;
 b=jAb/baiSXnulFYVtTP7sHLsqzD9gtAR3Bj/SMUqO29dxQXfFpOLb9Wp+V8KdiGa6v/i9HL9b
 kaoD0CvR8s5MY2zzzOeBQ1NPexbzR3PcqHQUen+ABBOTc128FsbDx5tT28eHLyP/PTyiMvNlhf8
 zOiup3GDtdyG5DvPusULn8uY=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id 33d434ae7e7de002;
	Sun, 20 Sep 2026 14:42:48 +0000
X-Mizu-Trace-ID: 33d434ae7e7de002
X-Migadu-Flow: FLOW_OUT
Received: by mail-lf1-f46.google.com with SMTP id 2adb3069b0e04-5b8c42da963so5594e87.0
        for <kvmarm@lists.linux.dev>; Sun, 20 Sep 2026 07:42:47 -0700 (PDT)
X-Gm-Message-State: AFuF++mhuhCsPpFNadezF1LphDLnaU9E3+BskYcf5en4cUo6AyKkSyIM
	3cSIdzMsBJ5M+apkl9ocjapPidwYTUB1Xo5XBIIVAnAtt4E6mKFynE+XO7o0ox+TJRNSoFPFbsa
	hJfV+KvLlk7+LSrz74GIYT9qAM2J0QR3Lp58D8RW/
X-Received: by 2002:a05:6512:3e08:b0:5b8:9e63:dfb4 with SMTP id
 2adb3069b0e04-5b8c751430amr119379e87.14.1789915366405; Sun, 20 Sep 2026
 07:42:46 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260919123150.3283606-1-maz@kernel.org> <20260919123150.3283606-5-maz@kernel.org>
In-Reply-To: <20260919123150.3283606-5-maz@kernel.org>
From: Fuad Tabba <fuad.tabba@linux.dev>
Date: Sun, 20 Sep 2026 15:42:10 +0100
X-Gmail-Original-Message-ID: <CA+EHjTxDmJe=3zEoeFFdwW6yhjGiQRUQJOZpanFNd0wKcR4CBA@mail.gmail.com>
X-Gm-Features: AcwNN1XruSsA5ybOhhOfItuSbQn7x4kogACoIWKSQ7hmigHvGBaPd17FPkfXrfw
Message-ID: <CA+EHjTxDmJe=3zEoeFFdwW6yhjGiQRUQJOZpanFNd0wKcR4CBA@mail.gmail.com>
Subject: Re: [PATCH 4/4] KVM: arm64: vgic-v5: Correctly handle host ISTE
 __le32 conversion
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	Steffen Eiden <seiden@linux.ibm.com>, Joey Gouly <joey.gouly@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Oliver Upton <oupton@kernel.org>, 
	Zenghui Yu <yuzenghui@huawei.com>, Sascha Bischoff <sascha.bischoff@arm.com>
Content-Type: text/plain; charset="UTF-8"

Hi Marc,

On Sat, 19 Sep 2026 13:31:50 +0100, Marc Zyngier <maz@kernel.org> wrote:
[...]
> diff --git a/arch/arm64/kvm/vgic/vgic-v5-tables.c b/arch/arm64/kvm/vgic/vgic-v5-tables.c
[...]
> @@ -1466,8 +1465,9 @@ static int vgic_v5_save_linear_ist(const struct vgic_v5_ist_desc *ist,
>
>          for (index = 0; index < nr_entries; index++) {
>                  __le32 *h_iste_addr = ist->base + index * ist->iste_size;
> +                u32 h_iste;
>
> -                h_iste = READ_ONCE(*h_iste_addr);
> +                h_iste = le32_to_cpu(READ_ONCE(*h_iste_addr));
>                  ret = put_user(h_iste, uaddr);

arm-vgic-v5.rst documents the IST buffers as little-endian entries,
which is what the raw __le32 copy gave userspace. With le32_to_cpu()
here a BE host would hand out native-endian entries instead. Making
uaddr a __le32 __user * (it's a u32 __user * today) keeps the
documented format, and sparse is clean with it too.

With that:

Reviewed-by: Fuad Tabba <fuad.tabba@linux.dev>

Cheers,
/fuad
