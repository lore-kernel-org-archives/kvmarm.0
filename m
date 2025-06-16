Received: from mail-pg1-f180.google.com (mail-pg1-f180.google.com [209.85.215.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7A2019E97A
	for <kvmarm@lists.linux.dev>; Mon, 16 Jun 2025 14:37:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750084653; cv=none; b=mZkwFGG5OAyZXyUgrhbVB5lXI5WYF16peSaaqFxQKiNpU3tvf8YjeNXBrLpmx1l3HahyuJIAhJ8lLxfYGDDUbsfPZfWK8DsoPX2bFhwfA6H4j09Zb2CfGhpWlAzaVHjVXB2in0O71o1lX6qWsc01ZxdDo5PCjeomI6wkbu/KnZ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750084653; c=relaxed/simple;
	bh=Tv1Lo6YhzFqNH8VTTXLCD9vFqIYM6L+1w8v2FhylPYg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AAnuZQ/2Z6DarwHWU7v9xcT6CwWjEkvbiULN4Xb/DI6Q3uzgqwXfnuvKQv0W5A4KYhYIqd+VKtcClNPD+xscb/gXrx1cS8hJvWKUK893aJM5hblKKpAeViRYBQ90m0CqMxFAfcwFKB+eV0XqUKMJM3RCXod9l5mILQ1VduLczdY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=csie.ntu.edu.tw; spf=pass smtp.mailfrom=csie.ntu.edu.tw; dkim=pass (2048-bit key) header.d=csie.ntu.edu.tw header.i=@csie.ntu.edu.tw header.b=gQVhUd+p; arc=none smtp.client-ip=209.85.215.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=csie.ntu.edu.tw
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=csie.ntu.edu.tw
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=csie.ntu.edu.tw header.i=@csie.ntu.edu.tw header.b="gQVhUd+p"
Received: by mail-pg1-f180.google.com with SMTP id 41be03b00d2f7-b170c99aa49so3007242a12.1
        for <kvmarm@lists.linux.dev>; Mon, 16 Jun 2025 07:37:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=csie.ntu.edu.tw; s=google; t=1750084651; x=1750689451; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=AkrvKj4WRhOO8zn50L5JIugDkJwYWJauK6qeewS2paw=;
        b=gQVhUd+pavNL1kjtbSUlIRSTrdCZ8PSBgsjoH5/Dn3Y4bz5tAuXq/xWgZ4f1WDL7Mx
         YXXtp1rc4vLp+9Hy391RUQ2DhY2D5WOYV2Zm4MAq3f/jnG1JlOkF5txTF7zAvTcB8p3W
         IXh4jwUhv9LqEK8OZ4t+aVb96iVOGQllzXj/O8BmkLm4VHLLGKks7XCifY0dfJPTuCLz
         7bBe/jIRGcchySDlPrwEU4hYnsb6wD9g8glpJibs3/AjkoOZeFWNgq61y/A5nCa2jvLt
         qkj1Y8XH7R5PLZccrYFujEmh8g+vEosmx/F541yUySndpl3VaFiCgyfW7M06ieUTxUSI
         kwAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750084651; x=1750689451;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=AkrvKj4WRhOO8zn50L5JIugDkJwYWJauK6qeewS2paw=;
        b=szBN5jYxVIhMPMucO6JvtAM8gtmO6pppAqVKTs9TXqoFzzN5f5/iBq7McD6LpAQn+c
         utP0kp6NhK5tpYoWwgrQ5FnUDDdnoeduech0TJnddcxHyZ6BVQNEn0/Pg3I1Iw/206Ea
         tn+WcJj9Ij/NoHLreeMkqXGgFkzjuAyrlR/jp37Iy4lVK/3aRPwq11JpF6SFlzBo6Jlq
         TJXd0345ghckG5Fzp0VACfbL+dZcaPPMcbuIbyl4l0KBAyY9jVoDgmI+D5c1DkGKz18X
         U01s6mlj/VORtzFc1gG7/tWIjM+0DINeSPp04MErTVpPwR4r1LNu+9T8ylwqvvb84Isq
         OaQQ==
X-Forwarded-Encrypted: i=1; AJvYcCUp92/RNoU/2eXEfdt97XKpMzsYoLfqKPtvZDabWlvg+s4f4LUBXs14uUuTUoqkbNSF5S5aaS8=@lists.linux.dev
X-Gm-Message-State: AOJu0YzEWeSXtqerN2WQATx026oDR1hQfc3n102nJvnjHIqTnppV2AVw
	4W0uDZkrjWGi/Um919AZkF71Mi3NVkxFWD4hGCrcWFtWSKVIIEb28Sfb1YfFnxwEsr25K7BZeGb
	akwzgcbq/7g2R+I8INgoj4MOPsedrUnQh6hj2TTcBuAFkdQj9eCE=
X-Gm-Gg: ASbGncvtLu6ySvykS3sSBRc41a/RzQzy4HIY9qV8tTA8XPB3jhI3x+igtbEObEEkiL9
	FB2T6G/moe4sQPJ36kVzga8p7fVc4WE7U29a4OORKlDihtS2CSu41cxpGM2Ne2kYypL0XH0LXjg
	+mfSAS+dAbyQCju7fw5ku5XsmBEzly42wR1lsWV2dAxGaSsWiBdDRO59N8oKx2ncB+tn5hoC3+z
	59mSjnQ5RCgDLcdk7L2dynlBkMHXBTH0bYp72DApLgJq1oc6ILP1qZoa7E8N7T3dPN+VkriUK5h
	DM7obmd2MYT1SwKBUrg8GGhc1gZG1jfqOtC8p7y+j0ndtv0ZPWNosYTM79ze5QOBMkkunR9lCND
	6yXoXcyh13Ju4u2GaGK/1S1+soI6C3GdAouY=
X-Google-Smtp-Source: AGHT+IHiHWhPvC3rzDccVIiloYznB+/CDW0xPfXegwCPoIernL0gBJI4EEGAaNyjQ6pQCOBf+YUk3g==
X-Received: by 2002:a05:6a21:600b:b0:218:76dd:a66 with SMTP id adf61e73a8af0-21fbd527f54mr16043044637.13.1750084651197;
        Mon, 16 Jun 2025 07:37:31 -0700 (PDT)
Received: from zenbook (36-228-20-239.dynamic-ip.hinet.net. [36.228.20.239])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b2fe168a4b2sm6996769a12.61.2025.06.16.07.37.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Jun 2025 07:37:30 -0700 (PDT)
Date: Mon, 16 Jun 2025 22:40:03 +0800
From: Wei-Lin Chang <r09922117@csie.ntu.edu.tw>
To: Oliver Upton <oliver.upton@linux.dev>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-kernel@vger.kernel.org, Marc Zyngier <maz@kernel.org>, Joey Gouly <joey.gouly@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
	Jintack Lim <jintack@cs.columbia.edu>, Christoffer Dall <christoffer.dall@arm.com>
Subject: Re: [PATCH] KVM: arm64: nv: Fix s_cpu_if->vgic_lr[] indexing in
 vgic_v3_put_nested()
Message-ID: <b5jwzhkkg2ensclxfj4uozpbibo5sgbcdm7tngharnjmqxswqc@ktywljdle6of>
References: <20250614145721.2504524-1-r09922117@csie.ntu.edu.tw>
 <aE-xyGGpHXdJ_pcF@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aE-xyGGpHXdJ_pcF@linux.dev>
X-Gm-Spam: 0
X-Gm-Phishy: 0

On Sun, Jun 15, 2025 at 10:55:20PM -0700, Oliver Upton wrote:
> On Sat, Jun 14, 2025 at 10:57:21PM +0800, Wei-Lin Chang wrote:
> > s_cpu_if->vgic_lr[] is filled continuously from index 0 to
> > s_cpu_if->used_lrs - 1, but vgic_v3_put_nested() is indexing it using
> > the positions of the set bits in shadow_if->lr_map. So correct it.
> 
> The changelog is a bit too mechanical and doesn't actually add anything
> to the diff. Maybe:
> 
>   Shadow LRs may exist at different indices from the corresponding LRs
>   in the guest hypervisor's vgic, as the shadow LRs are populated
>   contiguously in vgic_v3_create_shadow_lr().
> 
>   Use the correct shadow LR index when forwarding vIRQ state back to the
>   guest hypervisor's vgic in vgic_v3_put_nested().
> 

Hi Oliver,

Although we're not taking this, I still appreciate your help on the
commit message.

Thanks,
Wei-Lin Chang

> Diff itself LGTM.
> 
> Reviewed-by: Oliver Upton <oliver.upton@linux.dev>
> 
> Thanks,
> Oliver
