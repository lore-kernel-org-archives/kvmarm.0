Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53ACF3C463
	for <kvmarm@lists.linux.dev>; Tue, 22 Oct 2024 00:47:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729558040; cv=none; b=A1xzmGnsbmA3kAz9CKbA+XhgKZqHj/5sb3QBrFbDu76itpFf2tullwJyWteYu9blHBGERbG+bXVFtfgH1W9/6SYY+rQSggwFdcK45iqYfE8t5QoDlnLFzi2+qiBimXOsiDYe4QvdsgM7Xr0NKid9meO2GP1T1eNKoYaUEMnc7rM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729558040; c=relaxed/simple;
	bh=esQoNZuXsR24jwPl1DfQPAsmfQfBH1AfjOxCgQQxj50=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=K9Tmb+vK17WFYVmZ2g7xmUyj8MHd8LyJAnB612qJex1jz7Lp4lEcEvCQzSCuTvHxf8ltRxZcZRPmczvnKo56eGvGzgoWFqFsHXt/Rjua4Ff1J12Y3Pj8s83Mqv99tYhkgq6XC4A79bD9GYTads68dxa2HYS35W4ETxGXsgqvelE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--rananta.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=gdOfQnzR; arc=none smtp.client-ip=209.85.219.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--rananta.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="gdOfQnzR"
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-e2605ce4276so9149126276.3
        for <kvmarm@lists.linux.dev>; Mon, 21 Oct 2024 17:47:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1729558037; x=1730162837; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=eTpDcLprhbUi5YHe62ZQ4u0o+/QxbhbJTnRiVU+yROI=;
        b=gdOfQnzRyc+qIF0l1e8clSNIzaKjBoXvCuKBfzWUavk4amdVCtwZy0ctvMLhGGOBHK
         3DVhK/ZnYPKb3mpMRP5VhR8RM5Zvllhap7Ln7S5doJpepk9Y+PKi/0h7mzTjXFgS6mpe
         AnDEjW/f/ZXyttl2kgj+3rtSU8auEOIdGfRLomLAeaoZjzcQOPS/OTeZFJMmbgDcvUMw
         IXxKF5QjIsHOMf5uwwkL/rDVIRWTagmgfqbgjyCA+CsLw5iSOzn+qIQjHSmG5/qX73yc
         iVJ+n3PHPw4+UwwZL9YXhgrdc4tmaWU0G++1huADeyhPs3t4cWCRf+rfnQdeG7jGQfy+
         F1Kg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729558037; x=1730162837;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=eTpDcLprhbUi5YHe62ZQ4u0o+/QxbhbJTnRiVU+yROI=;
        b=daqyjqrcgHdWCTrqfWzatFXQrUmdsCGAA+8X70XJLYbhIQUJb8WacY8pCXZlyJkEEf
         aI+Ix1m32eCyFpao5BGLpl6uii5ZFGGGQ8JwGz44wCrgJXQRAV84c8cqHE7tSVywmW6l
         bS/t4lhxqMYERFRm/RqMrFOPxR5I/oLQJ/FaPItPCSmUxeHTYuk6F0PIZOjxHGd76Bvm
         zecq24rfyHzpIC9cxU7G6eDSlF+EDw1JHXGxpu78ahOgxWelOZaznzlK20dBHKPL2VaX
         /wVzWMcbZh+DPpd0Oz+Fj1XLJjjLKHo9ZnZIvZ90LNfyqfWWeX2ipKW9GSVUbZtnvl6x
         etkg==
X-Forwarded-Encrypted: i=1; AJvYcCVgmgb24BcuzfJcbMzV4X/jMVQNCz6/Z/vH+nvUlNT6rixSqBm11nxlrd1SAcR09YqQJ7+49K8=@lists.linux.dev
X-Gm-Message-State: AOJu0YyBaiIlLhwV0I7dAxfGjiH3DmRpu6TOXbzhSXdNN91Ib8Zg62Lp
	PWcSEkjdsgonI/4wib8TVfb2cGzkStnnR0FzsvLAgrkrpZinYXPaN7qDXBlD6TtruEVbTQkBSju
	f80ppwQ==
X-Google-Smtp-Source: AGHT+IFHeu+s/6VJ8LwG/ln9c8VqGvj+9fWSI0sc1LDHdzQR9YS0qXRVl8XWuhvxBjalS3fnwkBU6xUhXVdb
X-Received: from rananta-linux.c.googlers.com ([fda3:e722:ac3:cc00:11b:3898:ac11:fac1])
 (user=rananta job=sendgmr) by 2002:a05:6902:1807:b0:e29:7454:a4da with SMTP
 id 3f1490d57ef6-e2bb12ed271mr8273276.4.1729558037283; Mon, 21 Oct 2024
 17:47:17 -0700 (PDT)
Date: Tue, 22 Oct 2024 00:47:08 +0000
In-Reply-To: <20241022004710.1888067-1-rananta@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20241022004710.1888067-1-rananta@google.com>
X-Mailer: git-send-email 2.47.0.105.g07ac214952-goog
Message-ID: <20241022004710.1888067-2-rananta@google.com>
Subject: [kvm-unit-tests PATCH 1/3] arm: Fix clang error in sve_vl()
From: Raghavendra Rao Ananta <rananta@google.com>
To: Subhasish Ghosh <subhasish.ghosh@arm.com>, Joey Gouly <joey.gouly@arm.com>, 
	Andrew Jones <andrew.jones@linux.dev>
Cc: Oliver Upton <oliver.upton@linux.dev>, Marc Zyngier <maz@kernel.org>, 
	Raghavendra Rao Anata <rananta@google.com>, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Fix the following clang error in sve_vl():

In file included from arm/selftest.c:16:
kvm-unit-tests/lib/asm/processor.h:163:16:
error: value size does not match register size specified by the
constraint and modifier [-Werror,-Wasm-operand-widths]
                     : "=r" (vl));
                             ^
kvm-unit-tests/lib/asm/processor.h:162:14:
note: use constraint modifier "w"
                     "rdvl %0, #8"
                           ^~
                           %w0
1 error generated.

Fixes: d47d370c8f ("arm: Add test for FPU/SIMD context save/restore")
Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
---
 lib/arm64/asm/processor.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/arm64/asm/processor.h b/lib/arm64/asm/processor.h
index b28d41fd..e261e74d 100644
--- a/lib/arm64/asm/processor.h
+++ b/lib/arm64/asm/processor.h
@@ -159,7 +159,7 @@ static inline int sve_vl(void)
 	int vl;
 
 	asm volatile(".arch_extension sve\n"
-		     "rdvl %0, #8"
+		     "rdvl %w0, #8"
 		     : "=r" (vl));
 
 	return vl;
-- 
2.47.0.105.g07ac214952-goog

