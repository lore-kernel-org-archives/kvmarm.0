Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.43
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795094762;
	b=Xz/0oxxh8ivxf742Bcqz6km3IN9BdNlQMIxBevaHm8QEzpt0DcGtbNJ1972GUc9E+YgN
	 mK79FC747TbMFhV3gQSQRg6zQ5rTruB5QAPwJn6ET9/jkiF9thF89m2OvissxCaSg8IVR
	 k5giEM4vqxPqI7sr4wzuxD1joszKNi8MG/gA2rU7odz3eQRe9TfOBswYx53YO9YfGg3kq
	 L5t59wZ27ggBtc4jq/tgdgxezh2cqxYsSn9tBoveWgL8kBeeIl7NJJWOpEssaXl8qKDCi
	 4dO8xI6hte0y0dumTv4PDoOIaI5bRSRld9otNPOam0/qIfvbTe2NXRHxJ4y6K0JOKTw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795094762;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:Subject:Date:Message-Id:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:X-B4-Tracking:X-Change-ID:To:Cc:X-Mailer;
	bh=QBF+AGHQifO+3u233pASAlE3TnXlBjN6SI3Ox9FZ8jo=;
	b=jzcG8LSRfQPdk589HZMT1849KgD/FHUr9Ii1/jUOslph+qqeZ8PtKpgJG+2zF1WPyMNw
	 Sc4oV0aZYJSJUh2X9XwboZbhPM+bJcqTVEYkw+YbheJTki7GxeaAKX8XXSjSX5K4DY2ds
	 hmL06X1FYJndCkc+90hrOhi+fzgF1WWEKBRZNg9iN3UrEODy+rDQ6gRrg9SDRZYL2NOAp
	 KWX05Euc3qVA+QrvezaLu5F3AIJC4CMlfE6id2snITBAfCYdsNnPnMPy2HQYlW8w1q7XW
	 EeXwUZPyZd81p4xAq5ecaK2UBjp4OGu3eebJoZxm3VqwxXOt99Z1htERBtBTXLTKn+Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=pereq.eu;
	spf=pass smtp.mailfrom=cryspen.com;
	dkim=pass header.d=pereq.eu header.i=@pereq.eu header.a=rsa-sha256 header.s=google header.b=dEtl0Ewk;
	arc=none smtp.remote-ip=209.85.128.43
Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23C23606A324
	for <kvmarm@lists.linux.dev>; Thu, 19 Nov 2026 13:26:00 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 23C23606A324
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=pereq.eu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cryspen.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=pereq.eu header.i=@pereq.eu header.a=rsa-sha256 header.s=google header.b=dEtl0Ewk
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-4b467581b98so26349245e9.0
        for <kvmarm@lists.linux.dev>; Thu, 19 Nov 2026 05:26:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pereq.eu; s=google; t=1795094759; x=1795699559; darn=lists.linux.dev;
        h=cc:to:content-transfer-encoding:content-type:mime-version
         :message-id:date:subject:from:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=QBF+AGHQifO+3u233pASAlE3TnXlBjN6SI3Ox9FZ8jo=;
        b=dEtl0Ewk5l2fs7Xi19N8J5mlPOJjRDO9fgUxBkOvQWVaEWcPD23OgzF8tnBO+Gtvp8
         +UHXBhEfXzu2F0lHSPoddHUr+qUURvyrK8R7NPydUwrzZV5x8aME8NLrU04ggTSbQNK5
         iUIGoTSy/Hl6THtN0xaCaajXoRQPmWjdih/EmDhZZRuyHV8zgti0No6ZXf4zK7RJ0PLm
         /dOIRge8cPS0v3/nX1zTcip81uVmdYuvkhoONixR2iGiegfCdoGuuwUHtUbhA25U3I/s
         zzCi0U1UqD+iIMIJm4sX9p8rfM4qzye9VRRs8mWORqPliK28he8KCp463zIDbgngD7N9
         uRPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795094759; x=1795699559;
        h=cc:to:content-transfer-encoding:content-type:mime-version
         :message-id:date:subject:from:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=QBF+AGHQifO+3u233pASAlE3TnXlBjN6SI3Ox9FZ8jo=;
        b=RyjaZt2+ljo4u2EF0v6pRirRezV1DBxf3AI9mwyzmYcXgMME3QSEM0IWQXvVIirB6Y
         YRsegR2mkDlKMSoegWreQoPTHDxdjNwSBXz8tUoh0Hu5pVL0HfRkYuOpPF9rJ6FsmzCl
         TfvagsC86phMVD1sOw9sJW8jramyCZ6GopdrzsXPL4ZVYBt+vPkt25z/ELIOA8JBhWlJ
         0b66KMupOO2we68flTiUO9K6QrfWHXmTQPBp9aZ2Sk+hD094cWEISWX08pC5hW+XXebd
         3/3J7y7pZCm1uYg30SR4NVFKYxbcc1uSpumddRlCnLGh0PCvkI6C0Q0VgDEd4IXmsoct
         ONLw==
X-Forwarded-Encrypted: i=1; AL+hErEQ/OlfZ41516nmCCr6S9gDu0Fe9QkL2eLYzH9sA1W7i4sPRvhqreo9ijMY0eA6vSPRbk8ekSM=@lists.linux.dev
X-Gm-Message-State: APuU4Z+ZhaPQQypNE+/YoT+AuNCoabESWEEhGvwoZOaDaTbBaoEJvFe+
	lLRQ1oetUhGVk5fDe0YxjIjiCRMPAiB6GOQRng4SDkX0LCjNVrUHGCcIKNDDOeSAyLc=
X-Gm-Gg: AYBFou1i7VuAr1hQ9d8tM0t/gsTZBW9L7EyttXVvg6jrR5RnXpenOb16yIgAX3U6P/I
	8N/Q3vePA9zr4t0wovLUyPIADxFiCUlY/I77BW/NIUNY80BPiCXm+ielFSugYqMBp3S24LTV4oO
	6byEf7AqOgl4/drjKNqs4q6+iAInYTA8Z1z0wW7R4q8LiYXZmTTf7wuBkDpuEWdt+WRt/iH4iPv
	2U+5hi/qfhor23O06tqT6FsQ+ZqvCpa69IokQWDlSTJGZTQnG99iUxV3bk98A2rhB6wO4UqDf1D
	nJZAvjzZjYIsXcoznDX8hzxl0BrRXa2m8TtQ7D6l8HoOhr2r/isFusEkCrGe9rf20u3iJqTs+pc
	3/FZb8XCp5loyryZRkj1oyDTn+/R6pBfa0xZldcyVoj2eObmyd1/wK4rGm6LPNo4Z46/wWE3wCt
	7XiqF9NkGA0UunLqu/m7L2z3NpeOu5bKjsk3fbHGJ+SD5lm0TmJJNCvzlXQCOfqRBnmwTbSMElw
	xgLVg31T4rReEczIRGFbSWviz/lkWabEpERBKzXzVZ2bwlundeUfD1aKAjs5slJdAgSxqttwVFp
	3gPCNzK5CmTtWg2G9w0=
X-Received: by 2002:a05:600c:4f4e:b0:4bb:7033:c92f with SMTP id 5b1f17b1804b1-4bb7da0f671mr139545245e9.11.1795094759145;
        Thu, 19 Nov 2026 05:25:59 -0800 (PST)
Received: from localhost ([2c0f:3d00:6be:8900:ce5e:9212:ea4b:f30])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb84cc09b1sm33094945e9.0.2026.11.19.05.25.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Nov 2026 05:25:57 -0800 (PST)
From: Dan Carpenter <dan@pereq.eu>
Subject: [PATCH v2 0/4] KVM: arm64: nv: Fix AT emulation for nested
 virtualization
Date: Thu, 19 Nov 2026 16:25:33 +0300
Message-Id: <20261119-nv-tcr2-v2-0-3deb1a6cdba8@pereq.eu>
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/zWMQQqDMBBFryKz7oBJUbBXKV0k40Sni7TMWCmId
 29Scfke/78NjFXY4NZsoLyKySsX8JcGaA55YpSxMPjW9865AfOKC6nHbojuOqaOKfVQ1m/lJN9
 /6f442D7xybTUe13EYIxRQ6a5qjNUNez7D617AWCKAAAA
X-Change-ID: 20261119-nv-tcr2-59b13df5ecf6
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, 
 Fuad Tabba <fuad.tabba@linux.dev>, Joey Gouly <joey.gouly@arm.com>, 
 Steffen Eiden <seiden@linux.ibm.com>, 
 Suzuki K Poulose <suzuki.poulose@arm.com>, 
 Zenghui Yu <yuzenghui@huawei.com>, 
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
 Mark Rutland <mark.rutland@arm.com>, Jintack Lim <jintack.lim@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
 Dan Carpenter <dan@pereq.eu>, Karthik Bhargavan <karthik@pereq.eu>, 
 =?utf-8?q?Cl=C3=A9ment_Blaudeau?= <clement@cryspen.com>, 
 stable@vger.kernel.org
X-Mailer: b4 0.16.0

This fixes two issues in handling AT emulation for nested virt.
* VMs were potentially using the TCR2 bits which weren't intended for
  them.
* It turned out that guests could write to the TCR2 bits even when
  those were supposed to be hidden.  That is patches 2 and 3.
* The VMID wasn't handled correctly.  Roll over could happen before
  or during the AT execution leading to invalid results.

Changes in v2:
1) Sashiko pointed out that we need to restore the original TCR2
   bits at the end of the AT command.
2) Clean up based on Marc's feed back.
3) Trap the writes to the TCR2 registers (normal and nested)

Signed-off-by: Dan Carpenter <dan@pereq.eu>
---
Dan Carpenter (4):
      KVM: arm64: nv: Fix AT emulation for TCR2_EL1
      KVM: arm64: Trap TCR2_EL1 writes when S1PIE or S1POE is hidden
      KVM: arm64: nv: Clear hidden TCR2 bits for nested guests
      KVM: arm64: nv: Update the shadow MMU's VMID for AT emulation

 arch/arm64/kvm/at.c                        | 54 +++++++++++++++++++++++++++---
 arch/arm64/kvm/config.c                    |  5 +++
 arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h | 10 +++++-
 arch/arm64/kvm/sys_regs.c                  | 33 ++++++++++++++++--
 4 files changed, 95 insertions(+), 7 deletions(-)
---
base-commit: 5a7235e9adff42aa043ac9473dbeb0354dca0967
change-id: 20261119-nv-tcr2-59b13df5ecf6

Best regards,
--  
Dan Carpenter <dan@pereq.eu>

