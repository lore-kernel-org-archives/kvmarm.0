Received: from mail-ej1-f73.google.com (mail-ej1-f73.google.com [209.85.218.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BE9428369A
	for <kvmarm@lists.linux.dev>; Fri, 29 Aug 2025 09:51:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756461112; cv=none; b=oy1vGSWPsCpPvLeETLcIwiq/izygxIgFQE+l1qxYL0q5EGNq8dKbHi7IGptyE1n1VyAD7B5vi/b1OzR0BBBHha88tfzlvt4Lpue11s1oQYThWRLbNnrhGtQxjekFzTbDRslZsozA/LD4mzZb+tnOLKrt1Z//NY6IxJ3O8HDmJOI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756461112; c=relaxed/simple;
	bh=lksI2jKU28HrZtTGgs1EPVdYlgWh0QdD50hktHvA6+o=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=iT8fClEBRlDNGf/KVVht9Nkof7iyyMkZecRZZvBFqcBTpxk7AeXo3fZcPYhX00o/DQDsFXzFfSqYkI4x8FYWp3+NFFcpVln0yWfU+PdXZHTSQbvn0NylxA2aDCpsi6JcQCFXnIPo1rzSWSesoMMmHYkiV0FthSp+qhI9pkzP3Iw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=nFntK7Xr; arc=none smtp.client-ip=209.85.218.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="nFntK7Xr"
Received: by mail-ej1-f73.google.com with SMTP id a640c23a62f3a-afeeb44fe3fso132073666b.2
        for <kvmarm@lists.linux.dev>; Fri, 29 Aug 2025 02:51:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1756461109; x=1757065909; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Gw5w0sz05Swx/D5s5S+tVMdpbV1mbvdjC9hyE4WVYq0=;
        b=nFntK7XrBtmVBI27YoskXjBcn4d2sYSpgTL7pqjllxv/3wd3cVQrXTXxdB13RBibgo
         +GnSXfc5zCmWw18s3U43yjAbb1zepY2EFUdE5L+MqvGW4MkgYYRrXBXPNVvu9DSOO7qo
         Ilh6J5c/b8amB4yzweIxlVEgTqb729hBFqD3tjQ9DKzVochAm5Lp5/BxXbyPin9q3c8e
         2thojdjoyofeKz7zzQSinRwIwD3ckeboBOgyv2Y+kaoUUaueWW01I+qMk0hLQu44BC7p
         KDJ5VvLFNX0gCnr0a+IaxXSVfwZHEpQBuxLW5QTVIAfrHTT3r/wh1/r4gIGa01aL2oU0
         09/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756461109; x=1757065909;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Gw5w0sz05Swx/D5s5S+tVMdpbV1mbvdjC9hyE4WVYq0=;
        b=gtB5ZdZfl0iIkFMkZL7XEX0rPMH3qRczn/a1lrWOBXHWGDdC65pgLDkSpeE7d65tsD
         a5lbGtLN3nR17EG2Q6L3ZQr23gyQqSUScUppzlbMvB+s3FAWAygUKsI8ecMzowNbgwDa
         y2R0lxe0eiTu7CPX6WTjRo684Ek5NMcIC063QydzUTMO76dyZqgng0Jur0WXPRj6bmfg
         SCA1S/sON1zsKsWPZlu1lmFSzmJ+tIWetLrxwVayOqffsBNddMxdWbAsYYvQjmuiGoTz
         jJ85EK7M5OEm3vKh8VOhQ2z4kNoA5pUe5OHdD1irc+vCkTU0rMolzRJbdJQas22s/08o
         4LfA==
X-Gm-Message-State: AOJu0YzQdBJTNkWYEjrk3sCRIKWUytGGr/Bz/dvTRXfys1294vH/nXCQ
	9ePjB4c4L1lljoLmd5fnV2eWSfCHWnFo5EFsR5kWb+bGalaB82L7yQz8zzR2KuyKgKHgUE+I9eZ
	Ymw9w13aSxvv9UzVSMgpTXevKHRLFaDcKJVbtIEWxYH32UPyaxviZe3sgFOaKfedUTT3EhoalZj
	x5MKIz3bnNUpt2p05hVUJ1QiLUmjDK81I=
X-Google-Smtp-Source: AGHT+IF6FutuYKvLC2HNxGQ4PouB2oLcU6dsNYrQeWs2luM5mjJznhreK0ql2EW4HhyCno6WaQzxHWoMCg==
X-Received: from edbio8.prod.google.com ([2002:a05:6402:2188:b0:61c:8a5d:cca4])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6402:27cf:b0:61c:d606:9ce5
 with SMTP id 4fb4d7f45d1cf-61cd6069f73mr4653161a12.4.1756461108823; Fri, 29
 Aug 2025 02:51:48 -0700 (PDT)
Date: Fri, 29 Aug 2025 10:51:42 +0100
In-Reply-To: <20250829095143.123476-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250829095143.123476-1-tabba@google.com>
X-Mailer: git-send-email 2.51.0.338.gd7d06c2dae-goog
Message-ID: <20250829095143.123476-3-tabba@google.com>
Subject: [PATCH v3 2/3] arm64: sysreg: Correct sign definitions for EIESB and DoubleLock
From: Fuad Tabba <tabba@google.com>
To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org
Cc: maz@kernel.org, oliver.upton@linux.dev, will@kernel.org, 
	joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, 
	catalin.marinas@arm.com, vdonnefort@google.com, qperret@google.com, 
	sebastianene@google.com, keirf@google.com, smostafa@google.com, 
	tabba@google.com
Content-Type: text/plain; charset="UTF-8"

The `ID_AA64MMFR4_EL1.EIESB` field, is an unsigned enumeration, but was
incorrectly defined as a `SignedEnum` when introduced in commit
cfc680bb04c5 ("arm64: sysreg: Add layout for ID_AA64MMFR4_EL1"). This is
corrected to `UnsignedEnum`.

Conversely, the `ID_AA64DFR0_EL1.DoubleLock` field, is a signed
enumeration, but was incorrectly defined as an `UnsignedEnum`. This is
corrected to `SignedEnum`, which wasn't correctly set when annotated as
such in commit ad16d4cf0b4f ("arm64/sysreg: Initial unsigned annotations
for ID registers").

Signed-off-by: Fuad Tabba <tabba@google.com>
---
Note: No active users in the kernel for these two fields yet. pKVM
checks DoubleLock, but only for protected VMs, which aren't enabled
upstream yet. Hence no Fixes tag.
---
 arch/arm64/tools/sysreg | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/tools/sysreg b/arch/arm64/tools/sysreg
index f1a012ee0db6..d396fa587ec1 100644
--- a/arch/arm64/tools/sysreg
+++ b/arch/arm64/tools/sysreg
@@ -1693,7 +1693,7 @@ UnsignedEnum	43:40	TraceFilt
 	0b0000	NI
 	0b0001	IMP
 EndEnum
-UnsignedEnum	39:36	DoubleLock
+SignedEnum	39:36	DoubleLock
 	0b0000	IMP
 	0b1111	NI
 EndEnum
@@ -2409,7 +2409,7 @@ UnsignedEnum	11:8	ASID2
 	0b0000	NI
 	0b0001	IMP
 EndEnum
-SignedEnum	7:4	EIESB
+UnsignedEnum	7:4	EIESB
 	0b0000	NI
 	0b0001	ToEL3
 	0b0010	ToELx
-- 
2.51.0.338.gd7d06c2dae-goog

