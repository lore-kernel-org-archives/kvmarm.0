Received: from mail-wr1-f74.google.com (mail-wr1-f74.google.com [209.85.221.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 530B72E64B
	for <kvmarm@lists.linux.dev>; Thu, 14 Dec 2023 10:02:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Ut3D9taJ"
Received: by mail-wr1-f74.google.com with SMTP id ffacd0b85a97d-33331e69698so6595687f8f.1
        for <kvmarm@lists.linux.dev>; Thu, 14 Dec 2023 02:02:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1702548122; x=1703152922; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=lK/UD9rywANKR7blVX9d/xN+XkoswxGXvB4reNM2bgU=;
        b=Ut3D9taJQMWkKHj/hAsXVi7wkAzTVYRsQoyWjJPa73oBOEQ6fX4s58p4XtE+b35fwR
         RHw+B9FAT1EF3vPvEvCEG8VyNvYrd4bc2QWORi/n3AIlnqT09PnQIxmUg+yG+VoIeUDt
         3zYTATIf/OnU/pNjUGS9R5ekjzmmgL1SomonQ1NeqcCduJhJC60KyN9IouMVAjk8AZT1
         v+J+TgFxoffzxwB3hJGWZ14V/PdKuf1aA+b+BEv0qkgzFmDA1DrBPS36piqkOxH4svK1
         X8ls+9loSqYaNGyadUB7jgv3WuTFNGk2Ej/vdClxlcthOUsUpyjkiAErvrX6hIFmXfh3
         wgQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702548122; x=1703152922;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=lK/UD9rywANKR7blVX9d/xN+XkoswxGXvB4reNM2bgU=;
        b=TrOy523sJ0Fmg15RJMrtxUdvKfsEd6kZL9FQqFm9OLNUDGCyYCuInwsVDK9kZ7XVrk
         0LQxnQj5zvbc9NuNiJ1ihgeNzSosJnUuyF0LiL/n0nTmWcvz2TzJN60H8I5OZek0ih75
         IbQ1uuiOUb0bnYovRiMyuCHaxrzwqzRATuLrdNQMVwTAkXpf0qiq/IWeQDK5ftSYubcP
         6vHxbXG4EETdl7OPu1C5tKFVB1EnL64V47o7VmlTGUqneFZqnwo8+ZhPuz7SmC75ZXVS
         8mGALWFxLVTYJ/9/Sv5KOieH2AsYRGN3QsAmZrg74BaJJVtPiHRP0+BefhFzSzlNFIg3
         /AdA==
X-Gm-Message-State: AOJu0YzpTi9gq0N6pVewG3lFIAwmsp89fDJSihfPQ6yDciXPDaaTIbml
	JoFIU7ILelURtKBKZc6VQMZUaX9GP3JJEAhKjkKGU4X6uuzVC7i2lVpMXTleemLatTSugP8JhKM
	0UzSUtWf0KumsdcB1DZzCvA2gZuRDTv8Wu3god4hKk9ajZitXtYU2PEauQew=
X-Google-Smtp-Source: AGHT+IGJJHIsD1xjhl63UW9V8Ndxpk7q0cp06ihFUj9uAXgwk16GOxymoaVfreWidlYvo/hi+CCyO8rG8A==
X-Received: from fuad.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1613])
 (user=tabba job=sendgmr) by 2002:adf:f2ca:0:b0:336:471e:ada7 with SMTP id
 d10-20020adff2ca000000b00336471eada7mr4618wrp.0.1702548122478; Thu, 14 Dec
 2023 02:02:02 -0800 (PST)
Date: Thu, 14 Dec 2023 10:01:41 +0000
In-Reply-To: <20231214100158.2305400-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20231214100158.2305400-1-tabba@google.com>
X-Mailer: git-send-email 2.43.0.472.g3155946c3a-goog
Message-ID: <20231214100158.2305400-2-tabba@google.com>
Subject: [PATCH v3 01/17] arm64/sysreg: Add missing Pauth_LR field definitions
 to ID_AA64ISAR1_EL1
From: Fuad Tabba <tabba@google.com>
To: kvmarm@lists.linux.dev
Cc: maz@kernel.org, oliver.upton@linux.dev, broonie@kernel.org, 
	james.morse@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, 
	catalin.marinas@arm.com, will@kernel.org, eric.auger@redhat.com, 
	jingzhangos@google.com, joey.gouly@arm.com, tabba@google.com, 
	linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"

Add the Pauth_LR field definitions to ID_AA64ISAR1_EL1, based on
DDI0601 2023-09.

These fields aren't used yet. Adding them for completeness and
consistency (definition already exists for ID_AA64ISAR2_EL1).

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/tools/sysreg | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm64/tools/sysreg b/arch/arm64/tools/sysreg
index 2c4b6665c5bf..d596be2599d1 100644
--- a/arch/arm64/tools/sysreg
+++ b/arch/arm64/tools/sysreg
@@ -1401,6 +1401,7 @@ UnsignedEnum	11:8	API
 	0b0011	PAuth2
 	0b0100	FPAC
 	0b0101	FPACCOMBINE
+	0b0110	PAuth_LR
 EndEnum
 UnsignedEnum	7:4	APA
 	0b0000	NI
@@ -1409,6 +1410,7 @@ UnsignedEnum	7:4	APA
 	0b0011	PAuth2
 	0b0100	FPAC
 	0b0101	FPACCOMBINE
+	0b0110	PAuth_LR
 EndEnum
 UnsignedEnum	3:0	DPB
 	0b0000	NI
-- 
2.43.0.472.g3155946c3a-goog

