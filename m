Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.140.110.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793655268;
	b=bvR+BSTUi97+E2qTiJciZq94eker7NJU/Xc2S0xxlYmzjJttudE74Wz2BtKXFJ67pPhO
	 ORqLZ1uJqwJtBrhEtE2U2CVw2rpiptOZVkCM4AkyyK8+E9fnU6ULscve2+dNhkDdm/07J
	 Rk3A+xRi/5/dAfWyCMzS5sT9JpfCd3ScXIzFyq8Jkp0yh5NROJ7+HjQEe8XW2XVnRFPsE
	 o+SlFRr6zwwbAFoxuJZOas4FfB28BmwIFvcgCPpK+ORt3zvO9n5nLy/8q9OSSncGmDbSc
	 SsREDMKDJPslP3ZzLRi2xYH/Ua1E+GUqOfrCLzyZ236KZe27hXEAMU24Hu1RqTy+3CQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793655268;
	h=DMARC-Filter:Received:Received:DKIM-Signature:From:To:Cc:Subject:
	 Date:Message-Id:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=R7arVPQFINgfmvaThkX4cGwxR9rvbSIVuD6b/IWXSj8=;
	b=AjTn6p9i7n4uC9utnWTRHxahcBdoFV7/B87RYwfbGcYVJAqLs/wgyz4DZGOIAvxCOxCT
	 PRuYPkRNfl+HmTHZ1Ns1bi2bIX2SK+S5/DQEgF+EtzvcroHBuUhMl35Da/rD8OrV+zkdr
	 VU09bHWYQ9u8q+7lLUyKvPNY+rXXq7rn2HYkyXJXoxioYijfUcOAE0zcJE5nhtFsipcsV
	 R314ZWHHWVctZOjM3mTbBiKy+bPO5mIMz0OushIWxdCeL9lKV76AFmvA+xmQI9jvETQLk
	 mfhWn7mfnz/zwPK97WElcApOQFBYiABjyrgHYne9KrTzuMDJ+90xI1i2ZAhMZ4OjKSA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=arm.com;
	spf=pass smtp.mailfrom=arm.com;
	dkim=pass header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=bZm1XxQC;
	arc=none smtp.remote-ip=217.140.110.172
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B00DB606A32D
	for <kvmarm@lists.linux.dev>; Mon,  2 Nov 2026 21:34:27 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B00DB606A32D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=bZm1XxQC
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id D11051595;
	Mon,  2 Nov 2026 13:34:23 -0800 (PST)
Received: from e133894.cambridge.arm.com (e133894.arm.com [10.2.80.62])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id CC1C63F673;
	Mon,  2 Nov 2026 13:34:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1793655266; bh=2CrNkn059Py+6JSBmj/RbmhlCO93bsgfPfqoA1+/+pA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bZm1XxQCwNEfB27ntjEZ51HFJsKMrNkhlQildTW+IbngNWLhOFZhKY48jdv+dqTRE
	 0eQAh17oloQN1ExPrVbJclq7N1/opTTVa3CkPCHZrbflHs2vGT3jbiBacWF94/Us+J
	 Vh+Ue09skqp+VYjwNBFb2sUCzsIqSP55rruJeOdM=
From: Sascha Bischoff <sascha.bischoff@arm.com>
To: will@kernel.org,
	julien.thierry.kdev@gmail.com
Cc: vladimir.murzin@arm.com,
	maz@kernel.org,
	kvm@vger.kernel.org,
	kvmarm@lists.linux.dev,
	timothy.hayes@arm.com,
	Peter Maydell <peter.maydell@linaro.org>
Subject: [PATCH kvmtool v4 01/23] arm64: Propagate IRQ routing initialisation errors
Date: Mon,  2 Nov 2026 21:33:51 +0000
Message-Id: <20261102213413.4136118-2-sascha.bischoff@arm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20261102213413.4136118-1-sascha.bischoff@arm.com>
References: <20261102213413.4136118-1-sascha.bischoff@arm.com>
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

