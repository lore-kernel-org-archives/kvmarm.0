Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.140.110.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793655271;
	b=0CQEEmRgpNdOSZi4mu3Oz2/jwrswuWPzCLvEQO6l8Y8gasgkEXabJnvS/4vuI+nNeAPj
	 hqJKx7aUL1FdPJdQ47hWVRttFhtIhqJlmmxDFOYMjCStYlU607i76gZ9kp/vWrrKOpmBm
	 pXKM3HKx0B6TEf5wBmYVDmxKP6QlkfRQbHsvTWX4zVWzSb0EHR6UMcxL6/NvK6VCx/bp3
	 ee/wsyGN0+d8Y4GarcNTP7S9Z5/ZmepatjlX3TTrCTqVRe7ZTiJNIEC/Z4qE0S3HbabqZ
	 AlsSzg+FIJHK2djjdZnAxwVf1vVvbloj0obKCpsB7h8OF+czfblPnXOp6RkpmLpOLvg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793655271;
	h=DMARC-Filter:Received:Received:DKIM-Signature:From:To:Cc:Subject:
	 Date:Message-Id:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=ptB7HBBIXmODENruQ/1q8o5lWV2aQFT5cwp/uxamfAM=;
	b=YWSlEaqBfH+1fb16kn2NG8rzCIcOUXyuqr32ee8Rb2MdKY0ms9XWJ7La5umU8VYLLIFR
	 jq2VY7ps8YBaS19XMgbEHm3RxolVp7KdF6fNsCO7+y8O4ErQb6nnX52gsslZmVcgFYy0q
	 mXfIPnQIB8Ys7A+pc8y5GvXtc1TQqcOEF65yZS34BXRdRxPNmpzgN5GYF30LKhS68V5pv
	 E6cjZSKqvQWUq5sfKGJcxb9PzjlBMpCDFmre3wkulsHlYjGQ1rG1dxsVFWxqB9h1XAnVX
	 pEDRNl+Rx5LUmtQ7h3ZjiP2LmTwybo6Rkp3YPDHeJztpfQCRH+oPOy8s/wBnxIH0FWw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=arm.com;
	spf=pass smtp.mailfrom=arm.com;
	dkim=pass header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=QbBkXnfW;
	arc=none smtp.remote-ip=217.140.110.172
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5C6C0606A327
	for <kvmarm@lists.linux.dev>; Mon,  2 Nov 2026 21:34:31 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5C6C0606A327
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=QbBkXnfW
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 8BBF51595;
	Mon,  2 Nov 2026 13:34:27 -0800 (PST)
Received: from e133894.cambridge.arm.com (e133894.arm.com [10.2.80.62])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 892DB3F673;
	Mon,  2 Nov 2026 13:34:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1793655270; bh=N8bg3ar1PWVMdyOQLfF0aNd7/iiEv1kXMmOX+0mXlJQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QbBkXnfWSBXI5gKPh9UMdQlpnQGYg2rh1GhZu8aUeZqpVk2LfoSiPCSSXdnVRzpbD
	 CBiKBdHEAvQ5g0PdbbyZYQwLA6VslyKMBg7ouGMDpBl7+fnnKlgELGGtcMXQsnyklR
	 Bg9Yp/vhFX6L+PUWjgcYzYvqpVGQxw5RKo8rQ0J8=
From: Sascha Bischoff <sascha.bischoff@arm.com>
To: will@kernel.org,
	julien.thierry.kdev@gmail.com
Cc: vladimir.murzin@arm.com,
	maz@kernel.org,
	kvm@vger.kernel.org,
	kvmarm@lists.linux.dev,
	timothy.hayes@arm.com,
	Peter Maydell <peter.maydell@linaro.org>
Subject: [PATCH kvmtool v4 02/23] arm64: Close the ITS descriptor when setup fails
Date: Mon,  2 Nov 2026 21:33:52 +0000
Message-Id: <20261102213413.4136118-3-sascha.bischoff@arm.com>
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

