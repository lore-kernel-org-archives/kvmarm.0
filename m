Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 411E91B6D18
	for <kvmarm@lists.linux.dev>; Tue, 18 Feb 2025 16:34:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739896492; cv=none; b=aSDqDvs39aBvAZQZTHhT6DmZcH5pltSmBoyBCfV4q+KBBi/YpyAt4stuc5kpRFJFyRRsHr9c55A27IEzmcxQG67BTB2Imk9rX8SuEoH1lGJdkIjYWG/fT6FeKTN54BLrBE04EWT1SiN3mDVPFmcxlPRvDZ1FBKWrJIGqhBbARwE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739896492; c=relaxed/simple;
	bh=T/ly0o90dhVgf9HUX5LFvqfOCtsTYYBB0fxJeY45Kyc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:content-type; b=m0q/mF1fErtwAm6TS126njxKfngo95WoHWIvETFOZV4mmEQMIVCKDhd6QlTj8Q9/0HIu3FGJ2Pd0QQsh6tg+/kh1gHx8ifbAYxjiHHTfgx9IHN1CItsfq70F+pogMVFrzkBuLHFG7M9QvCokH+mCjSnkdT1nwO0B1vGPU8S8bYU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=OU4cPu9q; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="OU4cPu9q"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1739896488;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=K6IEI5vquogVwrhJmkiNA7kkUfSBC2YjenMZuFUbeAk=;
	b=OU4cPu9q6+15BJNxA0DKDANReZlzeTeEIATStiXwIdfauOSS56yS6Y1l4jJqnugDsdppJ0
	K4+a4/6bAvWwGYCN8jFna+aVQYcuIucTIC+WCcS8KTVshjI2ahd8ql8aZs9QlGJmTAC2TE
	ONY7Vw4iJLAB/3GrzSF20t8CgMTd8EI=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-569-QMCNudVQOouiYgTKAvKkeg-1; Tue, 18 Feb 2025 11:34:46 -0500
X-MC-Unique: QMCNudVQOouiYgTKAvKkeg-1
X-Mimecast-MFC-AGG-ID: QMCNudVQOouiYgTKAvKkeg_1739896485
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-43942e82719so49554855e9.2
        for <kvmarm@lists.linux.dev>; Tue, 18 Feb 2025 08:34:46 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739896485; x=1740501285;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=K6IEI5vquogVwrhJmkiNA7kkUfSBC2YjenMZuFUbeAk=;
        b=LpHFTyyBAe2jYNhxKqAQ3VQ+fqFLjK7/YCRF8XbUKL2dOoGf33rTGFI1GLzjHIaQOY
         Jh3ernrNFhHs9wYQXjF0duIqkhGq+r7u1K4N00z0l8K2TKCmgQWlGsi3PEw0xeXuMMC9
         TDomcy2eSUQjWOAInGGgkdiFTHWJRVY8yP4uv5pI1Lfh5IKz1B+pzxWY1xhhJuZICok8
         T+4YhFWjs2hHqpEiHF+VNc7MDqFaNriQx/K9FVUt+EY+F6cugrfv6/PRLy+eonJhnE9e
         UZo3k2r3aQISUq4d+oOYbkWBNtr9jFvYKPCNMhRMqyIWtDF89DlWVZ5uPBRIbrBuLRAp
         2hfg==
X-Forwarded-Encrypted: i=1; AJvYcCWR9ZGxMUwaOp3LHpk7JpDLiM7P0hbL4OoCVI7Md1VXjIzNyxfXQ9Gg67r/C6tJGi2einkTS4M=@lists.linux.dev
X-Gm-Message-State: AOJu0YztD+mU6vkagtEH1v3/SeAvY2PsXU5C5VKBw7moCf0gdJZP+zu3
	vGd4p4JPqDRFzVZu80xamZmFRktDElDTlEgQkFd289Y1WRgDGNIg/GNddi30v8RvjeWJK79x0zr
	+/QJ4sXgoj2YC8zaOOLAk2fZffWoVj5zgVTExPQlpUlngDtpzNfNxpA==
X-Gm-Gg: ASbGncvLlZOKEINWhvd9w8fYJKX+UEZPxbBL2uUY6wAxcnpa5T4AyXhbgnMgE2esPRx
	cwexie6w4oEdIcL3BGu+jrBCplZNY2Q3EK4dcSeD0L9BrmKm/YkReR5MtXHhWhQMEhQ6ZtVD22O
	qOxrZUA+c5FauGAHr8zdYggE7OAYwm4R/FlQ6s0fHRpa/mZ0riQDvB4uOTdvHJh8+JBelp3mQD/
	JfvXH7g8qhoqyjHMdHH7WONjYvGqiyp/z+jExr/1z5ufxEgAox10tBMWT7KruBIEoFVyniF75eP
	1zkvsJgS7tWKaZ1W5cDWQNhodOMRo7t+Fqc0JjVc1vqOvkOeeaqTxJsRGiUWxEV/j0tD
X-Received: by 2002:a05:600c:3b9c:b0:439:967b:46fc with SMTP id 5b1f17b1804b1-43999d8f506mr3283305e9.8.1739896485364;
        Tue, 18 Feb 2025 08:34:45 -0800 (PST)
X-Google-Smtp-Source: AGHT+IF2rMqgMj306LdPnffqreiahb80iBIENo1q+8mjRXF/AC5FQTrmlj/WNJxrORGdnqPcYDinew==
X-Received: by 2002:a05:600c:3b9c:b0:439:967b:46fc with SMTP id 5b1f17b1804b1-43999d8f506mr3283035e9.8.1739896484985;
        Tue, 18 Feb 2025 08:34:44 -0800 (PST)
Received: from rh.redhat.com (p200300f6af0e4d00dda53016e366575f.dip0.t-ipconnect.de. [2003:f6:af0e:4d00:dda5:3016:e366:575f])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4396b5267eesm85091845e9.0.2025.02.18.08.34.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Feb 2025 08:34:44 -0800 (PST)
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
Subject: [PATCH v3 0/4] KVM: arm64: writable MIDR/REVIDR
Date: Tue, 18 Feb 2025 17:34:39 +0100
Message-ID: <20250218163443.32836-1-sebott@redhat.com>
X-Mailer: git-send-email 2.48.1
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: SUgY0kT7CmofsMx1OsW3rMU-YTz87-pahQgeO33J2m4_1739896485
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

Based on prior discussion [1] this series allows VMMs to change
MIDR/REVIDR to enable migration between machines that differ in
these registers. Since these are used for errata handling the
errata management series [2] is a prerequisite for this one.

changes for V3:
* handle VPIDR_EL2 as part of vcpu ctxt - thanks Oliver!

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
 arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h    |   5 +-
 arch/arm64/kvm/hyp/nvhe/sysreg-sr.c           |  10 +-
 arch/arm64/kvm/hyp/vhe/sysreg-sr.c            |  28 ++--
 arch/arm64/kvm/sys_regs.c                     | 137 +++++++-----------
 .../testing/selftests/kvm/arm64/set_id_regs.c |  32 +++-
 6 files changed, 108 insertions(+), 113 deletions(-)

-- 
2.42.0

