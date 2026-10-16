Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C0BBD4ED1AA
	for <kvmarm@lists.linux.dev>; Fri, 16 Oct 2026 15:40:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792165206; cv=none; b=paBmw7MX0ER/P6f5Huyjiym5penbNaB5bbQRjNI7jWnN8JYMV8BAOfeb1G5Mzziab5MsmmAa3yCPOM3nGqwusxIgtFHtO9QLoDzOnZwpPO1iBuKMXyGDryviVjqYhiumxKgxa2v8mvmTTq+lHfS7mKddl6t74dK1ugcHDgYx5Lw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792165206; c=relaxed/simple;
	bh=YEvjpe34JNdvhahE0TdEOvG0zDmeOrC3IGffCX51Zlg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=kNXFWgv0uJ8cVQMq08exWqj0vSd6HKTqsZ0Kb3tpmXEudsnYaECIpNU3qBvpSUh6KACx2zquBM2kZZSsBX0gKbl5AjVwFdoZ0aupoBBOSFDnROT5/SLlsIO4BTwHkziVU6Sym8oVXWM3smvP7aG5GvImYHyQjuxHyfQFUaj1QTo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=BzexEfpd; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="BzexEfpd"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id E23F9143D;
	Fri, 16 Oct 2026 08:40:00 -0700 (PDT)
Received: from e133894.cambridge.arm.com (e133894.arm.com [10.2.80.62])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 345EF3F673;
	Fri, 16 Oct 2026 08:40:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1792165204; bh=YEvjpe34JNdvhahE0TdEOvG0zDmeOrC3IGffCX51Zlg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BzexEfpdroAY31solHwJFjRz4WFp71WyA4USe7j4DBTGuDAieiZrBSu6w+oyIWu7N
	 QZ7G+Q2dIL1Bk77toNjD1eLQI0/UYTiWletFYP9JNLrMa5mtDSNbkOORVy7d0p3r/b
	 9Y2E8LeoJTB9OHBqN3fjHLJcohpyJwO3FUDAjxrA=
From: Sascha Bischoff <sascha.bischoff@arm.com>
To: will@kernel.org,
	julien.thierry.kdev@gmail.com
Cc: maz@kernel.org,
	kvm@vger.kernel.org,
	kvmarm@lists.linux.dev,
	timothy.hayes@arm.com,
	Peter Maydell <peter.maydell@linaro.org>
Subject: [PATCH kvmtool v3 02/21] arm64: Close the ITS descriptor when setup fails
Date: Fri, 16 Oct 2026 16:39:20 +0100
Message-Id: <20261016153939.913764-3-sascha.bischoff@arm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20261016153939.913764-1-sascha.bischoff@arm.com>
References: <20261016153939.913764-1-sascha.bischoff@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

gic__create_its_frame() closes the device fd if the address attribute
is unavailable, but returns without closing it if setting the address
or initialising the ITS fails. Route all errors after device creation
through the same close path.

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

