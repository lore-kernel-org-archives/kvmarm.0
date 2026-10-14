Received: from mta0.migadu.com (out-177.mta0.migadu.com [91.218.175.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93A2E52269B
	for <kvmarm@lists.linux.dev>; Wed, 14 Oct 2026 13:20:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791984012; cv=none; b=YBc3rA3u90X41+0EPb67EMjasEBLpx3qUcUEVU4jOC8V6w9UuC/PbZAH6GPSfF6KvJZQ9rV6rRmcucLO5exNMOwhOpDMV+GXdJ91mDumkGyKexU8BXlc1+qIoB9uAY1M1dYMr7tebElAyr5DgfjAoYpLhkYzrFXeZAIbXsyk3NE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791984012; c=relaxed/simple;
	bh=E+DMpe7t/dGxE3sBJyyEWhe+11Lj4NA7Gz+f3SNlCqM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=dQQHZ3+B8UCzzPLnrE6f6vCOvbJwuPQZpiv0fritRkPAA7o7wBfxzVdbdBFnsc0Cx3OwknJWqCbLc+9u5WWdQ8wO0ZyHy3wSG19UaD+WVDn235IZyOGtXqi/3VHVG8FcYD6dAx9X7SXBcKdPdsnvM2c4Hpv3Kk3UCK2KzuyiJ1o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=cJqDseIw; arc=none smtp.client-ip=91.218.175.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="cJqDseIw"
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=E+DMpe7t/dGxE3sBJyyEWhe+11Lj4NA7Gz+f3SNlCqM=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1791984008; v=1; x=1792588808;
 b=cJqDseIwrXRDK5uZ0njwU6CkHGzi9BzoBceIgQz8ttaBEjaWcyQTFD+/EgQLIzsSTgYb9Qge
 BKn+QPUJnwzvjyW41OvDtvfpgOGrBBG46aX/QcHUfNLZe80oiaD4Y6tyzJ5Ef8BPbs+xdMF+Cnd
 PXBrzGc/o5J64yCQajSKmw8g=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id 0cb992b5e2aba3ea;
	Wed, 14 Oct 2026 13:20:08 +0000
X-Mizu-Trace-ID: 0cb992b5e2aba3ea
X-Migadu-Flow: FLOW_OUT
Received: by mail-lf1-f50.google.com with SMTP id 2adb3069b0e04-5ba429b64c5so31739e87.1
        for <kvmarm@lists.linux.dev>; Wed, 14 Oct 2026 06:20:03 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBxIJEad9r7Jpx+XvCmvYnQWlVkr8v6/F6ARaM5cjEjXOFUDArjd2QYWR/pY6iUgPW2bpjZ7Fro=@lists.linux.dev
X-Gm-Message-State: AFq9FYI9zRsKObnunTGZ1/cTtYeEianNP73WJut4dSrDKZAq7ekQOFj9
	Gx4agioaiVuLeIOac47pDIeoagGPKNeNG68x3Qy6/casITb+SmQO13BwBCXLsyRBQDZLlZxurCA
	5rWhVjLClYw0dBPjcnw2oJw3ACezNNkJYzzylpe7N
X-Received: by 2002:a05:6512:39d1:b0:5bc:ed54:d5b1 with SMTP id
 2adb3069b0e04-5be35cbd990mr74741e87.14.1791984002197; Wed, 14 Oct 2026
 06:20:02 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260605153248.2412064-1-weilin.chang@arm.com> <20260605153248.2412064-3-weilin.chang@arm.com>
In-Reply-To: <20260605153248.2412064-3-weilin.chang@arm.com>
From: Fuad Tabba <fuad.tabba@linux.dev>
Date: Wed, 14 Oct 2026 14:19:24 +0100
X-Gmail-Original-Message-ID: <CA+EHjTw=vMvvmoQ==6pGDZb9Y3rgZN6Bg29cOoYAjhmK-eTQwA@mail.gmail.com>
X-Gm-Features: AclHuK-2zxxhToktFj1rc-j8CjjTBanqw9vP7b14CdsYAEhgF95q11O9e8ZWNkE
Message-ID: <CA+EHjTw=vMvvmoQ==6pGDZb9Y3rgZN6Bg29cOoYAjhmK-eTQwA@mail.gmail.com>
Subject: Re: [PATCH 2/2] KVM: arm64: Remove superfluous aligning of gfn for
 dirty logging
To: Wei-Lin Chang <weilin.chang@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-kernel@vger.kernel.org, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oupton@kernel.org>, Joey Gouly <joey.gouly@arm.com>, 
	Steffen Eiden <seiden@linux.ibm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>, Gavin Shan <gshan@redhat.com>
Content-Type: text/plain; charset="UTF-8"

On Fri, 05 Jun 2026 16:32:48 +0100, Wei-Lin Chang <weilin.chang@arm.com> wrote:
> Stage-2 mapping size is forced to PAGE_SIZE when dirty logging is
> enabled for a memslot, therefore we don't need to align it down to
> a possibly larger vma size or THP adjusted size, they won't happen.

Reviewed-by: Fuad Tabba <fuad.tabba@linux.dev>
Tested-by: Fuad Tabba <fuad.tabba@linux.dev>

Cheers,
/fuad
