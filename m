Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.140.110.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795619651;
	b=qnioJlr4LV067Vbb2I7YqQPvU5LnpGRe79RBxYVXnI//ZqzTIlP9zz8N+cQgNRBMW+ns
	 li6teM9dTf94BSd9YFUcRCeTVZSGydl49+/n6nNbqqJ8ZNJ+nFS84ZMOeVf0lbeF6vv3T
	 0DtxklXGmwBHj1dFidUPgAVOl9m0/YaedZSwxp5d3DfNMDOy/VTfcSu3RY5MjSH0+O21P
	 KUZmTEOdbelFAwWuGkyAvCnAYQ2UQK4J3weEoxF87eF8hPSnSn1cs61zR5PK7yfT3PjHL
	 FiXzTjLCXx1SKx7Krh8NPasZBEma/IGc7X346PTLgHx2jtOUpQAtQJfl3AfQUJ3hopw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795619651;
	h=DMARC-Filter:Received:Received:DKIM-Signature:From:To:Cc:Subject:
	 Date:Message-Id:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=ptB7HBBIXmODENruQ/1q8o5lWV2aQFT5cwp/uxamfAM=;
	b=z1KlTvHfVg4898K5zPcOw5jS5URyHbPjXkJRnQT3NzJa20138sEg14DJ6MHCggmWDOMc
	 a3+2Vo8zKnOeVictjOfYwy5c99djcFLK6m7WBd5RRU3BRaJqHhCEXJpRe8VNDuGZnHBlm
	 G1MRx+uCvsyg0lfeXbSaiO3lEh7KGTkNqQ1S1TTDfB83bpK5Df/t8/EG5+WWvQTrR122d
	 HbmMzk3gVxnacLgWn2hTVXLIs5T7OzkNI3TnVN0uWZj1IkC1A1pCQBrdVoKr/Bp1HIi0A
	 vMHEV1v4/OrUbFkHEv89kWus+oU3/aN08I+08MA+WOCugrXaQqTnpPka7XgA5TA64sw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=arm.com;
	spf=pass smtp.mailfrom=arm.com;
	dkim=pass header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=oS8O1is6;
	arc=none smtp.remote-ip=217.140.110.172
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 32DC7606A31E
	for <kvmarm@lists.linux.dev>; Wed, 25 Nov 2026 15:14:11 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 32DC7606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=oS8O1is6
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id D85281596;
	Wed, 25 Nov 2026 07:14:07 -0800 (PST)
Received: from e133894.cambridge.arm.com (e133894.arm.com [10.2.80.62])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 9A6833F86F;
	Wed, 25 Nov 2026 07:14:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1795619650; bh=N8bg3ar1PWVMdyOQLfF0aNd7/iiEv1kXMmOX+0mXlJQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oS8O1is6mIAzLqfbYz0NWgEuRMOfzVJN2WX8IbNjwnrWaD2JfmZ3PHQzByASSTUrj
	 lE32q6axuXkhpsto6sG+JKIE2vPZAb3NJd+KJ6PQiO/vF15PV3C6zBqg4zKQu1n7HS
	 JN6j81v41NpmOZQtIEaY+OI5egygFuG9KjG3OoTk=
From: Sascha Bischoff <sascha.bischoff@arm.com>
To: will@kernel.org,
	julien.thierry.kdev@gmail.com
Cc: vladimir.murzin@arm.com,
	maz@kernel.org,
	kvm@vger.kernel.org,
	kvmarm@lists.linux.dev,
	timothy.hayes@arm.com,
	Peter Maydell <peter.maydell@linaro.org>
Subject: [PATCH kvmtool v6 02/23] arm64: Close the ITS descriptor when setup fails
Date: Wed, 25 Nov 2026 15:13:35 +0000
Message-Id: <20261125151356.2875108-3-sascha.bischoff@arm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20261125151356.2875108-1-sascha.bischoff@arm.com>
References: <20261125151356.2875108-1-sascha.bischoff@arm.com>
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

gic__create_its_frame() closes the device fd if the address attribute
is unavailable, but returns without closing it if setting the address
or initialising the ITS fails. Route all errors after device creation
through the same close path.

Reviewed-by: Vladimir Murzin <vladimir.murzin@arm.com>
Tested-by: Vladimir Murzin <vladimir.murzin@arm.com>
Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 arm64/gic.c | 19 ++++++++++++-------
 1 file changed, 12 insertions(+), 7 deletions(-)

diff --git a/arm64/gic.c b/arm64/gic.c
index debb0381..f8371f50 100644
--- a/arm64/gic.c
+++ b/arm64/gic.c
@@ -124,17 +124,22 @@ static int gic__create_its_frame(struct kvm *kvm, u64 its_frame_addr)
 	}
 
 	err = ioctl(its_device.fd, KVM_HAS_DEVICE_ATTR, &its_attr);
-	if (err) {
-		close(its_device.fd);
-		its_device.fd = -1;
-		return err;
-	}
+	if (err)
+		goto out_close;
 
 	err = ioctl(its_device.fd, KVM_SET_DEVICE_ATTR, &its_attr);
 	if (err)
-		return err;
+		goto out_close;
 
-	return ioctl(its_device.fd, KVM_SET_DEVICE_ATTR, &its_init_attr);
+	err = ioctl(its_device.fd, KVM_SET_DEVICE_ATTR, &its_init_attr);
+	if (err)
+		goto out_close;
+
+	return 0;
+
+out_close:
+	close(its_device.fd);
+	return err;
 }
 
 static int gic__create_msi_frame(struct kvm *kvm, enum irqchip_type type,
-- 
2.34.1

