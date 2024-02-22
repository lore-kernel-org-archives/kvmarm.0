Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71263157E81
	for <kvmarm@lists.linux.dev>; Thu, 22 Feb 2024 16:11:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708618314; cv=none; b=ooOXstP2owgl3fsvUe+Xm6HhOAdqJFg05zypDHmQLKjy9vwcKm9V/7/HJ6iU2I53+xqquKHU4K9Ieb2ai5Mbh4b6HTVQwIDS7+49QZORkVuIb3ItimAp24QquJU8qV4nYUSQkFERy6X2pr9N0n8dIWvto055Eh3pFdhk7SOp7os=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708618314; c=relaxed/simple;
	bh=X5CTKYo58HHafOhpr0rnGZtDOO9drroKYxobKreBkos=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=XCOgTsgDzlxuWHijVxxtpxO5O6Cbk5zJZNMiw6in3jQ6JyQ3iZcWetXuLtr9LGEeLZJCi3M2gyExDAWP9q7u7TqgolNen0ceIMbiFNFuPabgXIDKLH+F/V6/ZfosVvgZrGW9Q2tp3HLqjTcmykwFdNkNLToSDRvKiuCH2v8szf4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=JHGwkSx2; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="JHGwkSx2"
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-608852fc324so34221897b3.2
        for <kvmarm@lists.linux.dev>; Thu, 22 Feb 2024 08:11:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1708618312; x=1709223112; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=x7q06n6+Cfi5piogEKrJk5NdgWbh3+ffeAar7OiRx3s=;
        b=JHGwkSx2L+Wjtq97RSn3uhexOeCLNe4/yaANEPvKMAsdv8Y2alZ79hPuBOmP6lqu7E
         42OBDLY8LMxueTYz4VdVLn0AVmCyEM4UpRG1h06AoqfMdrWBDd2lOk4+ZLQ9S3Q04rDW
         EzE0VEJ62GlPu0kamybqtJCULiGi4K9YQn8LwgdyfydrqGcjgpbqNFYBTVTvOi3FiNR7
         BoY1TcdSUoxdJX91SbtVf1tfW8UusAFyjfvF9whCE9DoIak9T5XuWdlOj1+KWiCVo/5c
         B+K+llFdvuamF3DuUvn4ngmTprD60jxFtebFrZy/wlY0t+XDYKXybcfoycSZinuUcdVl
         CPUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708618312; x=1709223112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=x7q06n6+Cfi5piogEKrJk5NdgWbh3+ffeAar7OiRx3s=;
        b=mgJoHXOjwQTRb6KqJjvKQhnBOeIHILvXes1EKFk7OzIclQo1IuA0zzBroaEuyV3vWR
         SLsSCc1OtG9IDcKxzQ1A36XfrvBn3T+YKqwmPeO9aZxGSO8Wd9HkEtRLQh6b82jLYMGR
         ZujUVXTXVe1APz9HTfkqqg7xxeRaEEDEt7Togmk1FLU+zGtxmiS0rT9vo1qZm5mCImtj
         9bEbrr7QSliXfvNOt/KmfoBmiR/sO3gq2HbdjOgUKzFp3UxMJ1VnCqkME1ILyMkJ9Tm9
         4Eiji0suh9decJ9eKbUaATUPuW6MZdVwuxBEq8aA9f58jZdl03iLvMYfjqSW2WrWJlqW
         9UuQ==
X-Forwarded-Encrypted: i=1; AJvYcCWmLCYdZgbLG/Ikknv+uopifmwpL6Uj4w+TmeVuKvvcZn566lyP1pXmpZ39cONdzAQCKwSMcanC8qWq5VNYvMQ2rxYxEb2d
X-Gm-Message-State: AOJu0Yy/VGSdjSCukp0rSLfLHecZUAIt4RWYh3rA9KfGJdXG5FGK6krn
	gF2RdbOzEcM+MbRrp8lfnm+U1antoFr6l7YAyLFcrPq/Calrb1pGpuVS0CtuXb/MCTgsJpwleA=
	=
X-Google-Smtp-Source: AGHT+IHMwP7mtHKT127TxYqntr8FVuJ7TVNM66KxywWU4Ngx0R+m7wXDu6r4saiVjzNmhTgu/W91QxWrOg==
X-Received: from fuad.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1613])
 (user=tabba job=sendgmr) by 2002:a81:f101:0:b0:608:9758:e8b with SMTP id
 h1-20020a81f101000000b0060897580e8bmr613552ywm.8.1708618312398; Thu, 22 Feb
 2024 08:11:52 -0800 (PST)
Date: Thu, 22 Feb 2024 16:10:47 +0000
In-Reply-To: <20240222161047.402609-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240222161047.402609-1-tabba@google.com>
X-Mailer: git-send-email 2.44.0.rc1.240.g4c46232300-goog
Message-ID: <20240222161047.402609-27-tabba@google.com>
Subject: [RFC PATCH v1 26/26] KVM: arm64: Enable private memory kconfig for arm64
From: Fuad Tabba <tabba@google.com>
To: kvm@vger.kernel.org, kvmarm@lists.linux.dev
Cc: pbonzini@redhat.com, chenhuacai@kernel.org, mpe@ellerman.id.au, 
	anup@brainfault.org, paul.walmsley@sifive.com, palmer@dabbelt.com, 
	aou@eecs.berkeley.edu, seanjc@google.com, viro@zeniv.linux.org.uk, 
	brauner@kernel.org, willy@infradead.org, akpm@linux-foundation.org, 
	xiaoyao.li@intel.com, yilun.xu@intel.com, chao.p.peng@linux.intel.com, 
	jarkko@kernel.org, amoorthy@google.com, dmatlack@google.com, 
	yu.c.zhang@linux.intel.com, isaku.yamahata@intel.com, mic@digikod.net, 
	vbabka@suse.cz, vannapurve@google.com, ackerleytng@google.com, 
	mail@maciej.szmigiero.name, david@redhat.com, michael.roth@amd.com, 
	wei.w.wang@intel.com, liam.merwick@oracle.com, isaku.yamahata@gmail.com, 
	kirill.shutemov@linux.intel.com, suzuki.poulose@arm.com, steven.price@arm.com, 
	quic_eberman@quicinc.com, quic_mnalajal@quicinc.com, quic_tsoni@quicinc.com, 
	quic_svaddagi@quicinc.com, quic_cvanscha@quicinc.com, 
	quic_pderrin@quicinc.com, quic_pheragu@quicinc.com, catalin.marinas@arm.com, 
	james.morse@arm.com, yuzenghui@huawei.com, oliver.upton@linux.dev, 
	maz@kernel.org, will@kernel.org, qperret@google.com, keirf@google.com, 
	tabba@google.com
Content-Type: text/plain; charset="UTF-8"

Now that the infrastructure is in place for arm64 to support
guest private memory, enable it in the arm64 kernel
configuration.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/kvm/Kconfig | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm64/kvm/Kconfig b/arch/arm64/kvm/Kconfig
index 6c3c8ca73e7f..559eb9d34447 100644
--- a/arch/arm64/kvm/Kconfig
+++ b/arch/arm64/kvm/Kconfig
@@ -40,6 +40,8 @@ menuconfig KVM
 	select SCHED_INFO
 	select GUEST_PERF_EVENTS if PERF_EVENTS
 	select XARRAY_MULTI
+	select KVM_GENERIC_PRIVATE_MEM
+	select KVM_GENERIC_PRIVATE_MEM_MAPPABLE
 	help
 	  Support hosting virtualized guest machines.
 
-- 
2.44.0.rc1.240.g4c46232300-goog

