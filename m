Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.140.110.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795024697;
	b=07Awtdg3/BrulZiqNs8H8//N1+PHkKkYxDhN9NGpstOMHJ2EyAI4uMPjekjWqg4nWdES
	 FCvU2GEmFHIFDXhrFdQWX/6RG60ABnY2KsG5E3IHUbrOFV9qvPPCW1rzuflK4eZ/6f+cy
	 m6WhM15T5sTZdJefzEcKZ9QJX7WEXHCX4D4sZCmdqru29uNs1qqL74XCeefvZfkUAQd8T
	 LFfP9jrrCFLajdSzwBa5JEqSKdwaGQ1+bsMjALu2WhfCwQqJjfOZyN/y3pAjoIXdNeFs4
	 vUEE+ad4yw+jO4sirUpau4pT0UtKnOyKId4HthMCyZ8ZX9PFjhPxFL+hmVM6J//YxdQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795024697;
	h=DMARC-Filter:Received:Received:DKIM-Signature:From:To:Cc:Subject:
	 Date:Message-Id:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=ptB7HBBIXmODENruQ/1q8o5lWV2aQFT5cwp/uxamfAM=;
	b=ZVhFtoPKUNHlxG++thfPjgMZsXRkIK1FaDke83WkJ08bJzw9c5B99/9t0By3GQCiLn0F
	 GUDABB1Lc1u5VOpyACFOI4pvnUW00qUbJg8U9n+g6FgijHWuLM3N6T0lvHd5s1nUJuhNZ
	 lfv00R5Res8Po3xBAJkewtczk6J9zjp2A1bNFQvQ6/7pfJI2iYjcphYkpt4L21o0QkAzN
	 r2ZCsU6Rv498U9VGKl8vfhEJze3uwg9wy0BbEiTejwfUIyA3q5qdaQlB1q2yCyd22moYi
	 RMSlVUYgT86EViM/Lgz4DkOffxPdq1Ru3psNrMLrX15MyNigq48GpGtBENPn8ar++kA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=arm.com;
	spf=pass smtp.mailfrom=arm.com;
	dkim=pass header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=l4QwO42Y;
	arc=none smtp.remote-ip=217.140.110.172
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 34A5D606A325
	for <kvmarm@lists.linux.dev>; Wed, 18 Nov 2026 17:58:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 34A5D606A325
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=l4QwO42Y
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A12D41477;
	Wed, 18 Nov 2026 09:58:12 -0800 (PST)
Received: from e133894.cambridge.arm.com (e133894.arm.com [10.2.80.62])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 7BDB63F632;
	Wed, 18 Nov 2026 09:58:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1795024695; bh=N8bg3ar1PWVMdyOQLfF0aNd7/iiEv1kXMmOX+0mXlJQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=l4QwO42YLmlTvxNmdIxzCJJZ9htVn58cQfoy51LMXpa6YoFNDIW7HPlFZ/0iQyNt8
	 iI44r520nHMMorA9hVeeeMZVJhhqXM/7O0nmLaf/3EnlhK4dJIFswS/KbugeOB4ldd
	 NSSGKb25Wu4j62dcO7tVePI8FELh6uivaYOT2W4A=
From: Sascha Bischoff <sascha.bischoff@arm.com>
To: will@kernel.org,
	julien.thierry.kdev@gmail.com
Cc: vladimir.murzin@arm.com,
	maz@kernel.org,
	kvm@vger.kernel.org,
	kvmarm@lists.linux.dev,
	timothy.hayes@arm.com,
	Peter Maydell <peter.maydell@linaro.org>
Subject: [PATCH kvmtool v5 02/23] arm64: Close the ITS descriptor when setup fails
Date: Wed, 18 Nov 2026 17:57:34 +0000
Message-Id: <20261118175755.1946977-3-sascha.bischoff@arm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20261118175755.1946977-1-sascha.bischoff@arm.com>
References: <20261118175755.1946977-1-sascha.bischoff@arm.com>
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

