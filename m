Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76BB524C671
	for <kvmarm@lists.linux.dev>; Tue, 11 Feb 2025 14:39:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739284758; cv=none; b=NVZUusZrQTS8MmMS0KMGH/bjFcYAXjyxzxjqpF9pp+qU6PncDn8JaGfj+fCwmaGjIJJT1sfDreZz3zVwS9+SJVFQ/DuFGDn1wA+PZU+0Ek4dmHUTSV1/46mXhDu0HGbBCo1cJBC6wDDcg12qiCaDkPrlcblhGGw268X91BS6Z6U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739284758; c=relaxed/simple;
	bh=ihZTUnNCx7oVvaG3vXkXUqPeXG57VCMH8qkgDKmY3cM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:content-type; b=XsuoyiBHgE9PUiKeFPNYtTY2O+CKJhZyjtNJ/BPVFdNUpON4NWLGG9kVe/nkKZ+gluQDv69gI88usbgcjgjkMIRwdBs/V1RysVn+kBWeR0q2uVwRZpLEnTpvJ2T3L2V4FXiJ0hVcSwDVnjfm288wRyF2LzGjz0w5+lm4txmnI4s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=JvGhwD7E; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="JvGhwD7E"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1739284755;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=ZoQgH8y9XMOLCDCfjmngqj84Bs20C5H4G6N3AWreEs4=;
	b=JvGhwD7ESQZ+9UcNAc4riz5XqO5qIn8FA8FR2hiUqj3/tv4KhQM3Bv46SETkkuSkTjf3md
	l2ZCri5J5ZQfxtminG37dYkJYy3jwpgMtqTWZ9PRx+qH2zb9kIzugFVGj2CPOpfhNYHt5q
	RG3yc+4Pc4hZZpM0cTiIktpLwlYI5As=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-151-ZW_DIiuFMQq2O9XnlG3V7g-1; Tue, 11 Feb 2025 09:39:14 -0500
X-MC-Unique: ZW_DIiuFMQq2O9XnlG3V7g-1
X-Mimecast-MFC-AGG-ID: ZW_DIiuFMQq2O9XnlG3V7g
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-38dcd8ddc5eso2908636f8f.3
        for <kvmarm@lists.linux.dev>; Tue, 11 Feb 2025 06:39:13 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739284753; x=1739889553;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ZoQgH8y9XMOLCDCfjmngqj84Bs20C5H4G6N3AWreEs4=;
        b=Lh2U9nNNZ9qNnjSJmpbykHKhug8OcwmHN4xU7zYoV+48ImTvd0slX3AnjO+VExI0mD
         QUNhKh0E4ML1lURXZKldCer4W9GILDAaxz+EH6475nihgZSq0/hDuhh5Jk0U7AJ/rEEM
         l15xJjQkoVGQxLzSYlvnFZikUm18z2AScWvwY2sOtn8q+pzwprO7er+ht4v82V9ubGr7
         S7Y7JKhIpBQop1OXQb2IbXe0Y8WGqONdBohM6D+PCCy82pqPURldB3QAGE3PygkSwlWV
         dsuPgqt5YdDWCgBbjcZiaHiMJQtYEn2LaBbqOiWxnK0jDACZjkwABl4sggX5Z+RWgPfr
         GnZw==
X-Forwarded-Encrypted: i=1; AJvYcCUhmsiFCaGHT78dcr4TNNstMyldbVSkro9LSiIGEUlHZ8Eia19OgpY/mWTGAqKZrDVE1i6huoU=@lists.linux.dev
X-Gm-Message-State: AOJu0YwkTQIIZy6mNxVw4O99EC3Q6WxuAapO/PeEb2kk+kDqasvZegIR
	/2nIROMFBlXCSAaAfpUolIZ5CigKyaG0HoQxRZiUHsAtwRmLBKO52Z1Tg+Uiplg0WukUbvnB3vb
	5tHhEU/C0WmCqpqw9kZieD8MZM9jc+xSnSdh9XRJLPc5cBheNCfsHTQ==
X-Gm-Gg: ASbGncvEZpgDkatJbsfXEjSaZp07y9jEjAJCqJQLsaQZ0kqFKhigg8RedPc4FH68hlf
	ZhrKMLyWTIwR3tMH9V5tJN7Yp4c1hhKmr3e/Q/n/tov4F2aXcS6Az0o5m+xRJuV6Kj+sCoof8Qc
	fzCmuo78FhAaoFkbNqiz4DnQ1ZTEVaFYHsVB48JeiZFs1nRnDWcHp2o6X+RewZz5EQREKXMvobk
	XQV1Z3eDQo2PrHZY9bCGnoiWbru7ftvfB07JXYr/0eTMX7xNEU+xm+deyb69YAIIXcquz2pQqN2
	EenTTK8BSwnNF8oeWLm1zzKTjUCfLK47nsGeu4+R7t7Aj2ZPlnEYSQC4g5XmvbIlz9A=
X-Received: by 2002:a5d:6c65:0:b0:38d:e21e:13c6 with SMTP id ffacd0b85a97d-38de21e15bbmr5428382f8f.42.1739284752800;
        Tue, 11 Feb 2025 06:39:12 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFnmCgl2Neh2gVGj5aqOcVFIT+QLH9P2T4wOLD+vmwJJ0KUgupsifZ5q/dSypBIiLmFb5E3VQ==
X-Received: by 2002:a5d:6c65:0:b0:38d:e21e:13c6 with SMTP id ffacd0b85a97d-38de21e15bbmr5428350f8f.42.1739284752401;
        Tue, 11 Feb 2025 06:39:12 -0800 (PST)
Received: from rh.fritz.box (p200300f6af0e4d00dda53016e366575f.dip0.t-ipconnect.de. [2003:f6:af0e:4d00:dda5:3016:e366:575f])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-38dcc9bd251sm11745833f8f.9.2025.02.11.06.39.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Feb 2025 06:39:12 -0800 (PST)
From: Sebastian Ott <sebott@redhat.com>
To: Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
Cc: Cornelia Huck <cohuck@redhat.com>,
	Eric Auger <eric.auger@redhat.com>,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 0/4] KVM: arm64: writable MIDR/REVIDR
Date: Tue, 11 Feb 2025 15:39:06 +0100
Message-ID: <20250211143910.16775-1-sebott@redhat.com>
X-Mailer: git-send-email 2.48.1
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: Ux1gTcG2F3LLewVWlWqC66hy0-9YtBzjuMGm9uBSNAs_1739284753
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

Based on prior discussion [1] this series allows VMMs to change
MIDR/REVIDR to enable migration between machines that differ in
these registers. Since these are used for errata handling the
errata management series [2] is a prerequisite for this one.

changes for V2:
* let the guest actually observe the changed MIDR_EL1 value
* extra .set_user function
* added selftest

[1] https://lore.kernel.org/kvmarm/20250124151732.6072-1-shameerali.kolothum.thodi@huawei.com/T/#mb855bc51714095a164a7b26bb8bead1606e4b753
[2] https://lore.kernel.org/kvmarm/20250205132222.55816-1-shameerali.kolothum.thodi@huawei.com/T/

Sebastian Ott (4):
  KVM: arm64: Allow userspace to change MIDR_EL1
  KVM: arm64: Allow userspace to change REVIDR_EL1
  KVM: arm64: Allow userspace to change AIDR_EL1
  KVM: selftests: arm64: Test writes to MIDR,REVIDR,AIDR

 arch/arm64/include/asm/kvm_host.h             |   9 ++
 arch/arm64/kvm/sys_regs.c                     | 151 ++++++++----------
 .../testing/selftests/kvm/arm64/set_id_regs.c |  32 +++-
 3 files changed, 100 insertions(+), 92 deletions(-)

-- 
2.42.0

