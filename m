Received: from mail-pz2-f12.google.com (mail-pz2-f12.google.com [74.125.228.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A16235E1A8
	for <kvmarm@lists.linux.dev>; Thu, 24 Sep 2026 03:35:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.228.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790220943; cv=none; b=NHxrrop8T+OQOLn/1hdUSNxMc+pwkHDVvAVcGVYCxjSFuzCDvrMTJ1OWMiKOJRg01dtwDL94z+297Ia6L1rlH9zbAO6X2Z9WCLAzVOKSKLOdwDUtUHG9YuQDaWfRBcQL4klRL8y8xktG0gBDCWJOKQfLQf1ZXtTzoSUrpQOhjwA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790220943; c=relaxed/simple;
	bh=J+qJTJCzlOSHShptOsHG8Wmg2/iGttMxKSw3kni3Xxc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=UidGso4bVlsrILDEN3w4wuCF4VLtC80gUjtI7fhOThP+f+iEFpYOo+r/fX3S/a3O2BNufEO/5/FIGnRpbqBavjusHt6Tr9GP/Z8TgOoPQspLiD29LYIdJdCHVwoN0lAP7/F3yS0ssXJoGIaC09s/tS7dGaX9If2d3vvGRf/96Vw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=IwM84CNl; arc=none smtp.client-ip=74.125.228.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="IwM84CNl"
Received: by mail-pz2-f12.google.com with SMTP id d2e1a72fcca58-85a4329731cso916150b3a.3
        for <kvmarm@lists.linux.dev>; Wed, 23 Sep 2026 20:35:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790220941; x=1790825741; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=zmL50e1570AozJUJI4tJM1sQ+A41ismnbTdm3fKsoqg=;
        b=IwM84CNlr7/6wWz7ek3CEzwfIKKrPd7cdiCq6lzRpxchLaXnM88ZxcBNUWg69WoVqY
         wT3fG53bky6yd7LG//npTsGpSVQCAwII131Exopv3S526AjiRse5+oFQLTTrlLqkNqIe
         8jCubSjWUFzsCUQx0XcznKlCcY2FBtj3K1nkZIKDiahtfLw2wW9wcDcpYIGBJ0+OtcNm
         ZcpR30L5NzzUzTuOjeHzw4iS8qH2Zqm9vZ46I6Ih7etYrwAhILiJvyBDtqkyrCPKKtrZ
         kDOzjQBQwSgElK1pl+0g04Y00Z6LXM8D9S2sldvsesNJ9kQ/4kVPU8hdaFAfZO16nR+1
         xFSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790220941; x=1790825741;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=zmL50e1570AozJUJI4tJM1sQ+A41ismnbTdm3fKsoqg=;
        b=FsINfIJ6RT/MOpiuYZk/ClF5c6do5x6+ow6mK21hJHVQybC8PhaSv78Oy7QB2tUUee
         uwKKNtW9gcbaWAcR1nfJfajOu3GJIylbDAh//TWa2yJl4JhLwn0lMGzVdRjndcfpV1pu
         JXWJBNHjRCaA/NzzjuYVgJLvyoUxdVC4c5zcnMZP274Isx4F5BNR8+GSk6znPK/cnDkH
         u24YawK58tvOnn6JhZ31b5hErp3fs4Gk0Om83wDCNZXviDn92w33dTn75e3ppD2Eb/ks
         rTjJx/mCybxtaWZ3z7xtERjSwDUA4JIOYrOBhp2+8Rn/Wt+MjyXIaRuIY+2ZlaAxvLL/
         JaEw==
X-Forwarded-Encrypted: i=1; AKwUvBwv78DxLJKlvOHVd87mU2tpNQ68LviUWqlspk6NO4W447Udf5jr3cuUshe44+C79EUQSEqVTZ4=@lists.linux.dev
X-Gm-Message-State: AFuF++mFu2z5iNxeJo32hFuHoHt6+D1dtiL30cZ1G33jlLH+ig9GYkjC
	4QKZEt5YZJpEEI0V/L8tzPRMT69pX58GvT26ftJtNRyr5pDIq5urtklk
X-Gm-Gg: AYBFou3NrPzDcZJwr0epwBFTigJJPM99g1VMJbMUolsXSpF2gNLxPjBOUoMGHXo/Hlm
	nv+78caFB5QTVzJFSWFi8KTUTk1D/qXrOlbv1P/sTvIEffj74KGzpK3WP9CPu89QCKIcN64sFgH
	ZjmVNm3RLb4vSEOAbnGJGLiM2kjhravl3uZ/34TjcN93TdOnc1GMOex7LdQTvZMQsiRmPpP9wET
	otY5ffJyVFpL7i7tqLTBDLktTFwmepnuhPVD8PVz7Bjb13OjQbI6Lboc7xRZykiJJ1CVhBP8kk1
	vTzai1GNJ5yDX0Cw6wPk8EmjDFmwB9L43xXVv7TCwhdsAOFw+EeG2lU1N6aq9+7TNLiwpF7shJS
	Y8jyh4JWgm/Uu4b1/i6p+T/Sr3SmC0qlEvElAAYzAn+FYdxu8r+2CPTJqEd6sPSRvX49RkuFWnP
	jHf8NZNy1Aa0Wx+jQvQN2r7JDhU2bDlKC7SpQvQhYtJ//R1XwdMf2TUiLQYyjFgJ8cA+tEQK7MS
	E9to6CfiR/fgb4MLw9wFU8Ln51e/UquybtQBPkuboAeVLT/zTbiJz1/yVlb0c7zVUGIFDP34qOm
	f8K+eo4Px4POrSIgcqaOta+66gKfl4Z0G0AGllRE2ISAtWMA93akV/Suyq0=
X-Received: by 2002:a05:6a21:820c:b0:3c3:a20f:f729 with SMTP id adf61e73a8af0-3de0e6783b6mr1486724637.7.1790220941322;
        Wed, 23 Sep 2026 20:35:41 -0700 (PDT)
Received: from spider.bream-herring.ts.net ([103.6.151.236])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cc75f2251f5sm1896780a12.1.2026.09.23.20.35.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Sep 2026 20:35:40 -0700 (PDT)
From: Matthias Goergens <matthias.goergens@gmail.com>
To: Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>
Cc: Fuad Tabba <fuad.tabba@linux.dev>,
	Joey Gouly <joey.gouly@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev
Subject: [PATCH] MAINTAINERS: name the kvmarm/kvmarm next branch
Date: Thu, 24 Sep 2026 11:35:36 +0800
Message-ID: <20260924033536.3624334-1-matthias.goergens@gmail.com>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The T: entry for KERNEL VIRTUAL MACHINE FOR ARM64 (KVM/arm64) names
kvmarm/kvmarm without a branch.  The repository's HEAD (master,
0225fd5e0a6a) is a commit from 2020-05-01 that mainline already
contains.  linux-next pulls next from this repository (Next/Trees,
next-20260923), and on 2026-09-24 that branch carried work not yet in
mainline.  Name the branch so the entry identifies where development
happens.

Documentation/process/submitting-patches.rst sends contributors to the
T: entry to find the tree to prepare patches against, so a branch-less
entry whose HEAD is already in mainline points them at the wrong tree.

Signed-off-by: Matthias Goergens <matthias.goergens@gmail.com>
---
 MAINTAINERS | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index cc3cae2e378b..8394e0a1c149 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -14301,7 +14301,7 @@ R:	Zenghui Yu <yuzenghui@huawei.com>
 L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
 L:	kvmarm@lists.linux.dev
 S:	Maintained
-T:	git git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git next
 F:	Documentation/virt/kvm/arm/
 F:	Documentation/virt/kvm/devices/arm*
 F:	arch/arm64/include/asm/kvm*

base-commit: 40288c9206c17eb66a603262e06a58d300d0f279
-- 
2.55.0

