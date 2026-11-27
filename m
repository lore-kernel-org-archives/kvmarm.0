Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.140.110.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795798917;
	b=AIKqa0HTefKpy/HOPgqD7ND751KrDN/Kx6b13pR/QSIY/YAcH97s1sVrSbDXiLKlq947
	 UEkU0wEZ1ymWzxtRIDROu8xc/ohl01T+MxKydsfILzbb+Ai1Pn7cqnB+ud4Yvqoh1wBo8
	 9kPw2dCswYW6K9wLgUD7OdzgDfa3txLiVeSoM3muQaKPYvpJlN47APLuoZLESr3DSUhIf
	 K9Er3UCKP7RRyY2uCf6pPQSvEXkMh8v7YwwvYXKl4hUsRNqHsxaTlXaolHojyihiXET47
	 MQ75qArJtDgWCODaFWRAB2Ku68wTxM1RqhxEo5gQ1S1h8USom4aspJaRcUdainRII4A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795798917;
	h=DMARC-Filter:Received:Received:DKIM-Signature:From:To:Cc:Subject:
	 Date:Message-Id:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=R7arVPQFINgfmvaThkX4cGwxR9rvbSIVuD6b/IWXSj8=;
	b=qRwB4ePYXqlfBx3nNDmR9hz7fYp4L98IRUdAvEXtwmMfjjrwci5ixVghohMNd4HSCNcv
	 GVnm9IGSefdO5x/Mxv6L5cp6Q/aN0R/IhBs5Y23uRAgnMBGq5hrmHZ6Leve8vsPDEM7IF
	 Ag6xLoq3ZxLYcu3eYDQdnX/dI17KyVPB25+DzWOo1VivgTCy7lCRwaWp+9MfEh4eAlNSg
	 6qFX3hkLbcBcI708nUhuWc1uF3+y+I5ZtFBJlSPOGldn5we/QSS2fqEAWSIefs3iz0fAl
	 YOuTg50LeJ+KxJ7lG2SxzPQxz6n7YG0HeW9knh+B4N5O9VGhLGJ1Slh1VSPQ3U2Qpyw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=arm.com;
	spf=pass smtp.mailfrom=arm.com;
	dkim=pass header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b="ud3C/80H";
	arc=none smtp.remote-ip=217.140.110.172
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CBE49606A32C
	for <kvmarm@lists.linux.dev>; Fri, 27 Nov 2026 17:01:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org CBE49606A32C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=ud3C/80H
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 5C496169E;
	Fri, 27 Nov 2026 09:01:53 -0800 (PST)
Received: from e133894.cambridge.arm.com (e133894.arm.com [10.2.80.62])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 1D08E3F632;
	Fri, 27 Nov 2026 09:01:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1795798916; bh=2CrNkn059Py+6JSBmj/RbmhlCO93bsgfPfqoA1+/+pA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ud3C/80H2+1gki93e+zQlhENeKJu4dfgXnRE1DcxFwVRJmf3THldzlZmiWCgBQAbn
	 +nhKoLGIXhgPi5G5K4BoTwx9HAlsmsyMQOvheftm2uZkp24YySPDIkza+5V+A7Xcey
	 bCLbucQhPXIBDyrkPZ1sGUQGoHVhi60YR0yC854Y=
From: Sascha Bischoff <sascha.bischoff@arm.com>
To: will@kernel.org,
	julien.thierry.kdev@gmail.com
Cc: vladimir.murzin@arm.com,
	maz@kernel.org,
	kvm@vger.kernel.org,
	kvmarm@lists.linux.dev,
	timothy.hayes@arm.com,
	Peter Maydell <peter.maydell@linaro.org>
Subject: [PATCH kvmtool v7 01/23] arm64: Propagate IRQ routing initialisation errors
Date: Fri, 27 Nov 2026 17:01:23 +0000
Message-Id: <20261127170145.4138182-2-sascha.bischoff@arm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20261127170145.4138182-1-sascha.bischoff@arm.com>
References: <20261127170145.4138182-1-sascha.bischoff@arm.com>
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

irq__routing_init() can fail while allocating entries for the default
routing table. gic__init_gic() currently ignores that error and
continues with a partially populated table. Return the error before
the VGIC is marked as initialised.

Reviewed-by: Vladimir Murzin <vladimir.murzin@arm.com>
Tested-by: Vladimir Murzin <vladimir.murzin@arm.com>
Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 arm64/gic.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/arm64/gic.c b/arm64/gic.c
index 1e400962..debb0381 100644
--- a/arm64/gic.c
+++ b/arm64/gic.c
@@ -344,7 +344,9 @@ static int gic__init_gic(struct kvm *kvm)
 		}
 	}
 
-	irq__routing_init(kvm);
+	ret = irq__routing_init(kvm);
+	if (ret)
+		return ret;
 
 	if (!ioctl(gic_fd, KVM_HAS_DEVICE_ATTR, &vgic_init_attr)) {
 		ret = ioctl(gic_fd, KVM_SET_DEVICE_ATTR, &vgic_init_attr);
-- 
2.34.1

