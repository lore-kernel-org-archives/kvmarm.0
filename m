Received: from mail-ej1-f73.google.com (mail-ej1-f73.google.com [209.85.218.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB39486344
	for <kvmarm@lists.linux.dev>; Tue, 25 Feb 2025 01:53:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740448417; cv=none; b=OBVDnO7KY0gSfPRX5FyUNv0aMVv69QLlG7XxUPo98z5yDgyiOI3Z6Fs7gycYt4/wGGo49JBy0sTT5V6xEpiE7Qc9qfNeb8YqBdy4Vl0/brtyq2DLJ71UtAXFySZUqht44YOlchmGwIi6PNk9AoYK7Tixu2eE8YqfsaVGWjyX29Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740448417; c=relaxed/simple;
	bh=e7B/eoAwu89jaT4gQ5rsNPl33ADnwHw9PC0+ErFwCr4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=j9ELGZoNf2WV6ncGhjE53uWEif/H/QKffLY0ux1n+/Rmks4ioW6/PxV5cInXI4a9hzppHfFgFe8kS1RaK/FMqNTwPX7y4N5ZtjZTFc2JW4mIUk4/UV+VsbKbRaTXbS8Wj2Bz8bl/71VShMzh1pMbAzjEt5xewKZxN+zO4kN6V+o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--qperret.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=rDSHf9F/; arc=none smtp.client-ip=209.85.218.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--qperret.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="rDSHf9F/"
Received: by mail-ej1-f73.google.com with SMTP id a640c23a62f3a-ab39f65dc10so547716266b.1
        for <kvmarm@lists.linux.dev>; Mon, 24 Feb 2025 17:53:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1740448414; x=1741053214; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=wgX4G/wyCIy27tIesuPjLRJPT0WJaWFAbFWUEeP8CW8=;
        b=rDSHf9F/6h40jJzxuXT7WviV1KP/ZepVY0N5IehVy2C7gJ7vY1HK3pThcvDelR0D7Y
         t85Kz98cXySbf4uhZixa7H6PCOzTpHwsCNL5nKRc77H3S7VFoFKEIEIleClTkYy44VLR
         gtNEKhWKJo3NQms4w3A6lqaIWQS+OwXd4RcyGkWNGshS3l4oWT9It2r9PXexTbQxzvdS
         nG0QBOrNi2EdghyABYW6WMuACoXIPBpIWHaEcR1jzRjCtlbEhRHK7pQkICqk7FadYE84
         p81wXPDNCjQpUSgpZlxjvPQ/9HksYyTrFmtQT5h4g5mGMTxBebXru0RhlVQcuAnZpm/W
         EDzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740448414; x=1741053214;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=wgX4G/wyCIy27tIesuPjLRJPT0WJaWFAbFWUEeP8CW8=;
        b=mLs43oIMRJakNlFlgyKkK6YFDXqp62zxeSlAggfj5pEz1bLcEoke+B2eaTdfRkX841
         vBfap3gmK1Qx/YUFqbnFjaesT9u4O6BFxrobUuaM3bgNZx2WAbLmT9cGB9NdK7eBoPMK
         9WAvYEPLwmrypDZJefiZHLrGY2k2nrH0V0XEWB+P8yWt4lchJ2ADFHgBlsVkXgGCkn8P
         4iYFKUKV/e2r6ofBL8kJfrBILMaoNul8kRex4Ub99WJeM9DLZz7U4/m+Dsu95bVISu+A
         Ri5LZDGaRsp5eAs+aGXQaVC0Ni/n7nirRu9Xdad3e3NANmGsy91IY5O/iO+0vA895e5Q
         eLTQ==
X-Forwarded-Encrypted: i=1; AJvYcCXFycoFRrxd0aEYOXnHmgIT+FDsCsizp5TN80m8iQtUkXQ9v/npOf+zLzbVZughReCuTWY91E0=@lists.linux.dev
X-Gm-Message-State: AOJu0Yyi4W5ohQYuxEOZ3QQhlkj1PaWH4spCvOf70xYUJNGrj1up/Lw2
	jw6OYCNVAWM6VaCy8UqReC2TTDhQwwRJPgi0U0uMBcpUtcbWpG0Hxd/Dsl9qUSvu6QStG+YCA71
	JR3Dopw==
X-Google-Smtp-Source: AGHT+IHaEufhivqbAqPz8dmOr7ipMkvz7Mo3kJou3GygxqUP3Pfy+Ob1mNc3FS5PEksGnbTAMER6tHUCQA2u
X-Received: from ejcux14.prod.google.com ([2002:a17:907:cf8e:b0:abb:b80e:12f4])
 (user=qperret job=prod-delivery.src-stubby-dispatcher) by 2002:a17:906:3181:b0:ab7:e8d6:3b21
 with SMTP id a640c23a62f3a-abed0d764demr127674066b.28.1740448414099; Mon, 24
 Feb 2025 17:53:34 -0800 (PST)
Date: Tue, 25 Feb 2025 01:53:25 +0000
In-Reply-To: <20250225015327.3708420-1-qperret@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250225015327.3708420-1-qperret@google.com>
X-Mailer: git-send-email 2.48.1.658.g4767266eb4-goog
Message-ID: <20250225015327.3708420-3-qperret@google.com>
Subject: [PATCH v2 2/4] KVM: arm64: Don't WARN from __pkvm_host_share_guest()
From: Quentin Perret <qperret@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-kernel@vger.kernel.org, qperret@google.com
Content-Type: text/plain; charset="UTF-8"

We currently WARN() if the host attempts to share a page that is not in
an acceptable state with a guest. This isn't strictly necessary and
makes testing much harder, so drop the WARN and fix the error code.

Signed-off-by: Quentin Perret <qperret@google.com>
---
 arch/arm64/kvm/hyp/nvhe/mem_protect.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
index 19c3c631708c..ae39abc7e604 100644
--- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
+++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
@@ -912,7 +912,6 @@ int __pkvm_host_share_guest(u64 pfn, u64 gfn, struct pkvm_hyp_vcpu *vcpu,
 		if (page->host_share_guest_count)
 			break;
 		/* Only host to np-guest multi-sharing is tolerated */
-		WARN_ON(1);
 		fallthrough;
 	default:
 		ret = -EPERM;
-- 
2.48.1.658.g4767266eb4-goog

