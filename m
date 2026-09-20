Received: from mail-yx2-f42.google.com (mail-yx2-f42.google.com [74.125.224.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADF89477287
	for <kvmarm@lists.linux.dev>; Sun, 20 Sep 2026 19:39:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.224.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789933160; cv=none; b=Uyci3MJXU9TK+LtzH0vL+VhIw4Q/yM4vv8PuHcoNtjHNMxgZGfcrWt803duHLwXLxGaaapV4foLuxiqcZcdtBi1fY1fSRIOvTAsW4M8Ptui0f5R0/3ZGYJ4Oj7f0mFjwO+Sn4yDv2sZsDUsCYx6ySWp8MK4eSzztIF2Ope95yUc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789933160; c=relaxed/simple;
	bh=ecMTvF3y9YX9wt5R/rOdU59+hWMsUmT0QbE/UEYrczY=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ibIFv8jhs1HZZPs33RrNCbTMzSRckTa7TJAg/fdP9tuOekAYNPZSP9A0YPnGgy91etMzvtrIcstUhTa/sPOKR4XQhJHb63+BURqE5E6CF5EP1omDMT3pjaCF6LmTWFKaVJ4bpVtNeJLTTc5Vm+ogSdX0dv8yjnZWcXOLPw0XRZY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=soleen.com; spf=pass smtp.mailfrom=soleen.com; dkim=pass (2048-bit key) header.d=soleen.com header.i=@soleen.com header.b=PZnhJIGa; arc=none smtp.client-ip=74.125.224.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=soleen.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=soleen.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=soleen.com header.i=@soleen.com header.b="PZnhJIGa"
Received: by mail-yx2-f42.google.com with SMTP id 00721157ae682-895fd505832so15693347b3.3
        for <kvmarm@lists.linux.dev>; Sun, 20 Sep 2026 12:39:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1789933157; x=1790537957; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=GOyD94xneAEU7+yzaxi3P4vCBB/CkWgVuLYMi+o49fI=;
        b=PZnhJIGahrgPhlrPcBj1I2oeTLO/o9sZgmLK7cJoIZLAJezSQbBJzcDfoDQGgX5bq9
         zhdmQmX067AgQQwu+pzcUdQQGTiu7PfC4FxqFVUe7heCYWgzXARXMa65IkMBjQxp6xkf
         V/TKE4Ugr26I1qHCcs2e/MC5r7wbv+1cZEKPdwHl3ua+AwjQo6aGF1O0hvP1n5A4BlUq
         O0Jo1ZueDAt2A8peh46cj/yqO0Xgu+nZExQ5KCH+94nG6FipMm3OaPBo++eatn0CgQMx
         o1c0pVbtjrEu3++cwClaY8dQxICR7bDVtMzx6JywGEVGSGlElACSO5aAqpsdLNTAVtbj
         tqjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789933157; x=1790537957;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=GOyD94xneAEU7+yzaxi3P4vCBB/CkWgVuLYMi+o49fI=;
        b=UUEKZktzrd1641+g/AmTlkbX04acWes9hQuMHRvZlkgscZFeOVnOP3Sph2nVpR+/UG
         PdtU01lLgHwDCOHOBt3aIIrhwzijrU8pMo45OlJWiYRU+RdaUc85fGEnwH9qwLI7Y+oV
         5ebH9mPlvp+caUdgiSKx97RZ83paBe6nvPWOF0OD3yygl1162Ti3y/thCLFu7HnFA36d
         6rCqp76CbdfhiLoYLJVTuT9KLI3ayuivANkEI7hcn9PL8u5SkLnmUXm0KgkjR+YVbkNZ
         3cavCM0P4T9rO76KT7WcOaiow8vV+5HlPfUZPQSbDbwcpEMhLsIdMF2K4L4aNfn9EKA6
         pGVQ==
X-Forwarded-Encrypted: i=1; AKwUvBxY9ihHPvV7BEmV6kDzc1nv+eHxNeg87hsJtq/FxDjRN+AdGXwZGlq267BSG2K+8W0/gFHN2tY=@lists.linux.dev
X-Gm-Message-State: AFuF++nctZIxQOM5Z7UZaYZaGGi1+DZ98Bd7x45PNO8KXpbWywUoDLep
	PlDNlMb44cAYNsM1ItF7nefb1zZy2Pm7SSl/k/JPLoOMUX2gUyiB7NLQLZbdP5WNnA8=
X-Gm-Gg: AYBFou0VYLA9Wk43PGQIPwto21iixovjwqmfmrwtoqoC170ZVNJwbKMYvcos19JkUy/
	0xW0snbQya7S5w73zNr06MV0arIDIo4pzdyVG9fUE/JO2RbQNlSfNvYwlKn0StWN7eI3A7wbB7P
	ooIlXp04f78M//rMSlUjkVk3qh8Q622qKZ+xK/2qX3Fd09sFGlnCtkYVVK7Mk83/x632vAKtY5q
	0LW2cHxbA3iLgfgiXsO9Uz/txzG2QkWoCMqAavGeEEh0u9NPZOZn9NWWeCTvmUY25lgtmYAHmfm
	AAX0tgMNBPq8bD+qPb5GNTFWQ2VdPMsF/95csV6s+/wOQ34fhD9o3NO9968ROtgF6IJ4qbqOPXM
	qB1lWBKwvQFwTVglPCoNwsNNJ5UNqilARixGJqdFAsP+ZnlQKCoPF2uAB3A0Ltp36UgYhgTO1gI
	R6+QroepC1MZaR+hyDJGRgZrElsTgZ5hNVRCmmQXpC1ayDqDDc0HZZtV7SGjJfuY0hxyPdQuMtp
	9MqPjkC7mpgh+tQHZlStnwQQhq3NCX4NSKz9+HcxkiZAGph48FgYT9fmAtdCrOnvQoNBrBbvLDJ
	LMFX51w/NnQ6/gAZvW4=
X-Received: by 2002:a05:690c:e3cf:b0:845:ddf4:a399 with SMTP id 00721157ae682-897308f89e5mr31680887b3.11.1789933156801;
        Sun, 20 Sep 2026 12:39:16 -0700 (PDT)
Received: from soleen.c.googlers.com.com (16.49.199.35.bc.googleusercontent.com. [35.199.49.16])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-89a4761747asm18686667b3.30.2026.09.20.12.39.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 20 Sep 2026 12:39:15 -0700 (PDT)
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: linux-kselftest@vger.kernel.org,
	legion@kernel.org,
	kees@kernel.org,
	will@kernel.org,
	ruanjinjie@huawei.com,
	atomlin@atomlin.com,
	rppt@kernel.org,
	jani.nikula@intel.com,
	hamzamahfooz@linux.microsoft.com,
	joey.gouly@arm.com,
	tglx@kernel.org,
	nsc@kernel.org,
	alexandre.chartre@oracle.com,
	james.morse@arm.com,
	dianders@chromium.org,
	bp@alien8.de,
	jpoimboe@kernel.org,
	shuah@kernel.org,
	catalin.marinas@arm.com,
	linux-kbuild@vger.kernel.org,
	linux-arch@vger.kernel.org,
	kvmarm@lists.linux.dev,
	jaredwhite@microsoft.com,
	johan@kernel.org,
	pbonzini@redhat.com,
	mingo@redhat.com,
	linux-mm@kvack.org,
	seanjc@google.com,
	mark.rutland@arm.com,
	vdonnefort@google.com,
	tarunsahu@google.com,
	gshan@redhat.com,
	skhan@linuxfoundation.org,
	linux-doc@vger.kernel.org,
	xur@google.com,
	djbw@kernel.org,
	oupton@kernel.org,
	nogikh@google.com,
	sumitg@nvidia.com,
	linux-kernel@vger.kernel.org,
	zengheng4@huawei.com,
	peterz@infradead.org,
	corbet@lwn.net,
	suzuki.poulose@arm.com,
	luto@kernel.org,
	hpa@zytor.com,
	zhangpengjie2@huawei.com,
	x86@kernel.org,
	yuzenghui@huawei.com,
	jic23@kernel.org,
	ardb@kernel.org,
	pasha.tatashin@soleen.com,
	petr.pavlu@suse.com,
	ryan.roberts@arm.com,
	kexec@lists.infradead.org,
	pratyush@kernel.org,
	dave.hansen@linux.intel.com,
	rdunlap@infradead.org,
	kvm@vger.kernel.org,
	fuad.tabba@linux.dev,
	maz@kernel.org,
	mbenes@suse.cz,
	jgross@suse.com,
	seiden@linux.ibm.com,
	pierre.gondois@arm.com,
	song@kernel.org,
	nathan@kernel.org,
	pmladek@suse.com,
	graf@amazon.com,
	chao.gao@intel.com,
	zhenglifeng1@huawei.com,
	arnd@arndb.de,
	sidnayyar@google.com,
	linux-arm-kernel@lists.infradead.org,
	vladimir.murzin@arm.com,
	kas@kernel.org
Subject: [RFC PATCH 24/46] MAINTAINERS: Add entry for KVM Caretaker
Date: Sun, 20 Sep 2026 15:36:28 -0400
Message-ID: <20260920193650.3373435-25-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.55.0.1082.g2b9226bbc0-goog
In-Reply-To: <20260920193650.3373435-1-pasha.tatashin@soleen.com>
References: <20260920193650.3373435-1-pasha.tatashin@soleen.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add KERNEL VIRTUAL MACHINE CARETAKER section in MAINTAINERS covering
Caretaker headers, architecture backends, and core execution files.

Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
---
 MAINTAINERS | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 23f332cfbd16..86806245041e 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -14296,6 +14296,17 @@ F:	tools/kvm/
 F:	tools/testing/selftests/kvm/
 F:	virt/kvm/*
 
+KERNEL VIRTUAL MACHINE CARETAKER
+M:	Pasha Tatashin <pasha.tatashin@soleen.com>
+L:	kvm@vger.kernel.org
+L:	kexec@lists.infradead.org
+S:	Maintained
+F:	arch/*/include/asm/kvm_caretaker*
+F:	arch/*/kvm/*caretaker*
+F:	arch/x86/kvm/mmu/kho.c
+F:	include/linux/kvm_caretaker.h
+F:	virt/kvm/caretaker*.c
+
 KERNEL VIRTUAL MACHINE FOR ARM64 (KVM/arm64)
 M:	Marc Zyngier <maz@kernel.org>
 M:	Oliver Upton <oupton@kernel.org>
-- 
2.55.0.1082.g2b9226bbc0-goog

