Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.140.110.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795619647;
	b=MP1XmqXK1ZP7Ka0acjEKPPLX6377T/oDm7IGDgZo3KRcpBZ/HkVZC3r3A8AqqIH/5uUj
	 sq/tJtbA5qa4nw+hN0+PuKOGCN4ZwXppQkzQBDB959eCKYRq6qVY0AxRyJVwe5B6gAxOt
	 DGK3RrO1p3xqnZHSZ7yTmdc6/C41OdjHR73M/5SN5p+teH7nFowBF6maGd5jPpTVRJW1b
	 +3RDhQh8PQ8yk3JhwV/vGxoDg7l3JR7R4U32gIengmOT9LMJgfgGm/n60aweD6h0Igsx2
	 AS+k18+fz1eDU/pxQih9/QVclhutVjWTCAcyOiQoBMFE2c8milp+6y7fMbgy650l+6Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795619647;
	h=DMARC-Filter:Received:Received:DKIM-Signature:From:To:Cc:Subject:
	 Date:Message-Id:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=R7arVPQFINgfmvaThkX4cGwxR9rvbSIVuD6b/IWXSj8=;
	b=uXM5dzjzIJPajwYFOH9+I2ytOQ0wqjdKpmKz+roZfvO41UJ5ezLqpAKuBWiZ52AnDqA0
	 USQwoUp2adgY5IsgfmW5AZfxx0OBbElb/ZsUboqD0c6IBxrn3dmHr0Z66y8skrFXeecD7
	 hiKSZbF2kxz04h5YVAKtEdVIeKQXOgTwYlauMmTD6Xru9Ucoj7cZvBE+WGk5JniG8YuDS
	 WE7z9+EPCA0aeqDRs/VuUszHZAKAh9ccrZM+qIn/nrKI1/tF2R27Gtd8OiNmlA08SwUTK
	 oVH7S3c2O79hq96ZrPTgtqEDp0Bv57fruvAAFf2h9rpVk4Md7oEcrtFErULJnLlfNng==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=arm.com;
	spf=pass smtp.mailfrom=arm.com;
	dkim=pass header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=AnUamhRx;
	arc=none smtp.remote-ip=217.140.110.172
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7AE05606A326
	for <kvmarm@lists.linux.dev>; Wed, 25 Nov 2026 15:14:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7AE05606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=AnUamhRx
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 01B9D339;
	Wed, 25 Nov 2026 07:14:04 -0800 (PST)
Received: from e133894.cambridge.arm.com (e133894.arm.com [10.2.80.62])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id C00EE3FA7A;
	Wed, 25 Nov 2026 07:14:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1795619646; bh=2CrNkn059Py+6JSBmj/RbmhlCO93bsgfPfqoA1+/+pA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AnUamhRxRm9nMXLMQzNCSwQeFxqX20SNxKKPQBqfTOAh1cLgchkaMgKasKYIvhPty
	 ovrATfFfJqu04Tj2nGnLNT6B8f0L3ziyrInbleaCTIn8pyuHmqBLXp0cvR2m+FYx9k
	 yiwf2/hKVoDGds7/RC8mdggZgDtN/B3qPo6qo9Sw=
From: Sascha Bischoff <sascha.bischoff@arm.com>
To: will@kernel.org,
	julien.thierry.kdev@gmail.com
Cc: vladimir.murzin@arm.com,
	maz@kernel.org,
	kvm@vger.kernel.org,
	kvmarm@lists.linux.dev,
	timothy.hayes@arm.com,
	Peter Maydell <peter.maydell@linaro.org>
Subject: [PATCH kvmtool v6 01/23] arm64: Propagate IRQ routing initialisation errors
Date: Wed, 25 Nov 2026 15:13:34 +0000
Message-Id: <20261125151356.2875108-2-sascha.bischoff@arm.com>
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

