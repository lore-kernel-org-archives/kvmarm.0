Received: from mail-wr2-f34.google.com (mail-wr2-f34.google.com [74.125.225.98])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E20B74BF921
	for <kvmarm@lists.linux.dev>; Fri,  2 Oct 2026 17:45:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.225.98
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790963133; cv=none; b=h+Z+ybo/ODORVYxFhHOYfdWN193eR674MXAzA4YHeTGTFW9C0//X6Dwkh6bY0eYIYSDSgUeP0SnpoZ0pS8MbazJnNhzncZQuBst8PBRxTVpGxLHgD4J7kyp5WCDWDGjHtVVM23nPSU39Azas10uW2lKIA8bJ6WE6PwxUKdxo6q0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790963133; c=relaxed/simple;
	bh=tuUKQXYkGnUCxDjJE1nQ+gDpYskdzNay7lbXkALLVfM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=H48O7UO9+oBOUgKtUPxp3/AWdCgSbaWFzgEelAvBQBWGa3VBJPSJ6btxKffJYhvZ3nbZocgnMBi1rWbG1YW6wpTaQz0izsptSKmvv1s0waoctq/R9KzCmDa1GwCrEhsP/5ftmNQ7mdHZ3QIBFK6HQhC0TSxNT6+oHbHFfNSqCNQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=H+FdG8yj; arc=none smtp.client-ip=74.125.225.98
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="H+FdG8yj"
Received: by mail-wr2-f34.google.com with SMTP id ffacd0b85a97d-48af0707d41so72089f8f.1
        for <kvmarm@lists.linux.dev>; Fri, 02 Oct 2026 10:45:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790963125; x=1791567925; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=N1e269Lu4xtW2duTVHt20I/6VEWYe79hxf4w6LtBB3g=;
        b=H+FdG8yjvfjrfl6Z6f9I1h1KhrPu5OVejehjj7GGgg5xZdhLZ1TnmkKn8HWaAZHfIv
         DyF/DYp7leV/zFFHKfJQwz3tUwCLBVFRH3LlNaoAf1Ya+PgkH1mZ/RW+5vhABa7TNB5w
         GKwBs38B3AVJlqOk9zpJWKMiFHYa7S1Aksf8FAhLzLc7rOEHzfrNOYGgBYoYHCXPziai
         ArOJXYaeVbPfUWGfvdp34h5vxBEokY01dns3ECw47yW8791fnrcpryUc7hpqK5YMHD/s
         JnMqIrhVvhskhBAjyztMLGM/nu9qAtHrbw9KGDr0k+edCCd7MEnVS5vhveQMBFFtQLVL
         0pjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790963125; x=1791567925;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=N1e269Lu4xtW2duTVHt20I/6VEWYe79hxf4w6LtBB3g=;
        b=pPEYFkttbaI6JlpEnppxFylEmr1iOOnfrCHCtBWoKiHqex06L3tViWQq62dz/juxsF
         173akhAgQXCYjn4HG+Ch28IpBHgFb9T5hI+yan99yaJZPS2J7xf7cWZGhMxbhDTDd4g3
         xAUuUq19ixPh3fekGrZc8jihOPP4aDSRd/nc08GSQo9m3JLHPcrqjVIuhRQw9Ii77wD6
         nIOA7dhEtMpEs+6lqRqkapeyyKi5eSDN9tGeH23dv42rcKV4nO01AmRokuNn5q9orkMg
         Ls01fWgaT7B34iZ7PteYB8gc3tp21vWit5iUaum1dpm/HenU8bIKLqUB3tS8wEYJ+5tG
         tmJQ==
X-Forwarded-Encrypted: i=1; AKwUvBzPayItS6QBAPnw+FFhdYqyCeoUuBaSKKMW5G/gK8lhD0yCHvwC7y/3cliN7XORHxUw0I259yw=@lists.linux.dev
X-Gm-Message-State: AFq9FYInPc2aKYq2V6Z1PYcbmGuNW9XxOpl/OS0bY1SHyx2vNKbGoTWG
	9sRfU80lN0sQTQ8R6yyE8mybgH7bx9RIlGE7G79a+E+VMUC16DSaVElD
X-Gm-Gg: AYBFou2Vy34JBfGKu6eXSBR45PPmoXmJBYDUcE+RgNddtavQ3vtwvwxhiCEkFfYcoiz
	r075etVISvTATumACnydNqZDjZoHf22DESZI3fiJnR4MzlaO/S84z3vHOuD/C5OGVP+yVTVXAdi
	xFEz5x6BNyYh5AhGgMPfXa50sRjtnJjlOZH8I7E7homCBu2zajk4/HtPE6v/hc4bkoEuyynk9yZ
	Cxox0FM+tx1yaAkIIYCpwbYvZdu4O7QOwU/5eXCICd/BN9vhnYdYJkOCUyJh8+CDBCvtaixVTNy
	fmhPnBo03ximBtvexEBg6EXngxUtMKwe33xJw3yZYfKAcsfGOSlv7OFzHAws608hNLDOx8FkDrV
	o3jDiiF/recrFqgwBJDToJpS15ovwuBDKkq7h2fAtHqjKHO9FuZBdfHx054qO5O5JXpYu+pdXpB
	YFOycpj01d9srX+wr9XhvKOghHi2zlAKQqkbUJFEXQY8giL36IV2nb96tyfzUMWOqTjV/PMM43c
	4IIrlYqbtnYMmwMST/h1weS1UsQQzwZKysyOzKvWJ1+781OikpIMHaDohHuVjY+mGtu43Tg8VpW
	8vnr+Wkq+kbQBX0pwkTv2bgz7jsU7Ed3nfWRHFZmQvHxoskzeElRFJLw7Kh87KA4nclPjdCwzz+
	iVQT58g==
X-Received: by 2002:a05:6000:260e:b0:48b:226:839 with SMTP id ffacd0b85a97d-48b1273bfcdmr6851497f8f.14.1790963124443;
        Fri, 02 Oct 2026 10:45:24 -0700 (PDT)
Received: from MacBook-Pro-von-Karl (dynamic-2a02-3100-af35-1901-81da-eee8-c2d0-ee3b.310.pool.telefonica.de. [2a02:3100:af35:1901:81da:eee8:c2d0:ee3b])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48b380f0661sm6839400f8f.14.2026.10.02.10.45.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Oct 2026 10:45:23 -0700 (PDT)
Date: Fri, 2 Oct 2026 19:45:21 +0200
From: Karl Mehltretter <kmehltretter@gmail.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, 
	kvmarm@lists.linux.dev
Cc: Fuad Tabba <fuad.tabba@linux.dev>, Joey Gouly <joey.gouly@arm.com>, 
	Steffen Eiden <seiden@linux.ibm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, 
	Shuah Khan <shuah@kernel.org>, Eric Auger <eric.auger@redhat.com>, 
	Christoffer Dall <christoffer.dall@arm.com>, linux-arm-kernel@lists.infradead.org, 
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH v4 0/4] KVM: arm64: fix VGICv3 redistributor rollback
Message-ID: <ar_tdaYQO-t1K2F_@gmail.com>
References: <20260831081005.41346-1-kmehltretter@gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260831081005.41346-1-kmehltretter@gmail.com>

On Mon, Aug 31, 2026 at 10:10:00AM +0100, Karl Mehltretter wrote:
> Changes since v3:
> - Dropped the REDIST/REDIST_REGION serialization and VGIC init/destroy
>   rework, keeping the fix close to v2. (Marc)
> - Limited rollback to assignments from the new region so an older-region
>   assignment cannot be missed during concurrent vCPU creation.
> - Added Fuad's Reviewed-by tags to patches 1, 3 and 4. These are otherwise
>   unchanged from v3 (formerly patches 1, 4 and 5).
> 
> Previous version:
> v3: https://lore.kernel.org/r/20260822095346.53882-1-kmehltretter@gmail.com
> 
> Karl Mehltretter (4):
>   KVM: arm64: vgic-v3: Undo assignment on iodev registration failure
>   KVM: arm64: vgic-v3: Roll back assignments from the new region
>   KVM: arm64: selftests: Pass guest code to vm_gic_create_with_vcpus()
>   KVM: arm64: selftests: Test VGICv3 redistributor region retry
> 
>  arch/arm64/kvm/vgic/vgic-mmio-v3.c            |  54 ++++++--
>  tools/testing/selftests/kvm/arm64/vgic_init.c | 116 ++++++++++++++++--
>  2 files changed, 151 insertions(+), 19 deletions(-)

A friendly ping on v4. Patches 1, 3, and 4 have Fuad's Reviewed-by;
patch 2 was revised following Marc's feedback.

Thanks,
Karl
