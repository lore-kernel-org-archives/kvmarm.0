Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 876A928F50F
	for <kvmarm@lists.linux.dev>; Tue,  2 Dec 2025 16:09:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764691748; cv=none; b=Q62zGZR2I4q0v+PERedcqh6U1W+jiCfr9mhbbPkcPBYiKsjCgPKnuX+JHP8OrSwf1U+0srya8BFV6ZIUn1sawHJGdxttw2GnQESwquSGY7xMDXVS0jZe66xZ3fIaDBz1QMYNGRLwqkxDYPAZaKgNKgGaxI3W6NPmqQZHL4HcL0w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764691748; c=relaxed/simple;
	bh=gC6Q+HMpFAJH1tp5fCDIRqEJ1MHUxFI/yXEXmBCtKx0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:content-type; b=gVDb62xHVhOarL3n5Om9yUYNdkeMD3RFOCX4hOkwKIk6UwTEWP+WpUdLHRFjdYkXmgDICro/QSBn7ovzu1rN35dXF1u25d34mkgmF+IM9wLf4D8aQJO7HhG6LSlyyo56Rzqj04wZeyp9bxnLlfKGnDWb9fB7BihnO/KNl+atpB4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=JdAOE42a; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="JdAOE42a"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1764691745;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=VN5D96R/t76acLMeIjKxcWybmi4kuwmjRsxRAB7XktE=;
	b=JdAOE42adKhi0PotzJlTTZN5msRN79iinQp5SyJSTgJmjyIyayza15OIZnkrwhKv/mwllN
	frzYwvVILHu/5aETCQBMOZBUi2tkZRC5mfo2T/Zjp0bUxWWObPOv6N6y1hDARkQm6etvp2
	XittpccsSKyttxARFds59ddg+naQ164=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-280-FnHKjx9bM5yvYi_7G04osg-1; Tue, 02 Dec 2025 11:09:03 -0500
X-MC-Unique: FnHKjx9bM5yvYi_7G04osg-1
X-Mimecast-MFC-AGG-ID: FnHKjx9bM5yvYi_7G04osg_1764691739
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-42b2c8fb84fso3459584f8f.2
        for <kvmarm@lists.linux.dev>; Tue, 02 Dec 2025 08:09:03 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764691739; x=1765296539;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VN5D96R/t76acLMeIjKxcWybmi4kuwmjRsxRAB7XktE=;
        b=cT4SjgwnLC+txYLzCZgngj9RQDPVozg2Q1pgPBZt+qPVSMxuq91eGK4Zb7aSNQS+od
         /feklpdgr/xJE+6lWBDlwqM++5qMA2DsYzegpM5nv2rH5Ilo4xGbLWYdW/FWi1UTNn9d
         0KPatyWzqDnz09wMgSZNuZYxYhBDbjkIsu9ZdEtvXjbOeROeP35pyMaEnQZHMJSIv1VF
         h+QRkUqJ2+QBKgxaTs3jUAhirK2luBSJD6FK53/DkuAAFK4lR3IOOVP655EwDRvc4mz+
         8+TIULjrBlggzj7j546W0BbmANzWjfSsjVLowjXFvf7NyWfUzUL+DH8ZPJMocE7cpOQT
         toeg==
X-Forwarded-Encrypted: i=1; AJvYcCUzOvzd/oAk8rg3c3u6YpxyZt2CLfn6HvfZ5WLmHwimuQzqMRV1NNPL9vcfJ3VOky8IRLUm7NM=@lists.linux.dev
X-Gm-Message-State: AOJu0YyDDtLBgv5ti/cwuRI74X3xDiQdJDFKmvHhP+lPTF7APF5dl/gY
	J92jQFOWVro/sfZOrbga98fBa5eiDwDSm1VuJFBYVse7yLqqby9BVTUJXWB150BwvuuQ9jA42fG
	mQft5Qv7oVGia3cqgfV9nc+GgfxdJSUvQl13M2ZDtkcDpL5qIEJSmAi0KO9pkl0SWWA==
X-Gm-Gg: ASbGncuw7dYSocjA14H9N7Y/px9KZjKcU7LSbUk9LdxUKEZSRljLjUoOMN4si3+kGna
	e/VjKmLhylSXUsW95D1wo7pYb6nQVczym7UWTIB0q9rS7kMEXvOAdnyDS8mlCnlJtyolEoPsfzE
	QYIvfgNO2//D9bJOwWUTvS0yb1kiVzND+JZ76MCqe5WWrLEq5iEFgv7YVCeM7D+JOL/scm/s+i2
	IHzItLkvrho+cj9txWrrRSMhUEFHLO6g20YzDssU3A3YTUTkEHf96kixL6WLfxBwE4p7kZzDEyA
	x3Uj/lOZZEA6GzK1lzk1L4HjxjEopYBP2W3rNjQ2AwcnGhfgXKtvoyWCLEstBPa9Q9z0q5y6sZn
	I40WDOCOQXqdjnsexaFPl9D0HL0Cu7LKjvnQWs+pDbP9Kk39j57qvGBs1Qqe2wiGl6UHgqSV6
X-Received: by 2002:a05:6000:2307:b0:42b:3bc4:16dc with SMTP id ffacd0b85a97d-42e0f213b9emr32166630f8f.21.1764691738804;
        Tue, 02 Dec 2025 08:08:58 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFlWgvgyCrCdB68a/vDVtdUnY3Hzqt9cNDCyK0z8du3Hyb0hPWF5OXcMS0TvNkdQ42xNIogkQ==
X-Received: by 2002:a05:6000:2307:b0:42b:3bc4:16dc with SMTP id ffacd0b85a97d-42e0f213b9emr32166604f8f.21.1764691738387;
        Tue, 02 Dec 2025 08:08:58 -0800 (PST)
Received: from rh.redhat.com (p200300f6af35a800883b071bf1f3e4b6.dip0.t-ipconnect.de. [2003:f6:af35:a800:883b:71b:f1f3:e4b6])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-42e1caa767dsm34300899f8f.38.2025.12.02.08.08.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Dec 2025 08:08:58 -0800 (PST)
From: Sebastian Ott <sebott@redhat.com>
To: Peter Maydell <peter.maydell@linaro.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Eric Auger <eric.auger@redhat.com>
Cc: qemu-arm@nongnu.org,
	qemu-devel@nongnu.org,
	kvm@vger.kernel.org,
	kvmarm@lists.linux.dev,
	Sebastian Ott <sebott@redhat.com>
Subject: [PATCH v4 0/2] arm: add kvm-psci-version vcpu property
Date: Tue,  2 Dec 2025 17:08:51 +0100
Message-ID: <20251202160853.22560-1-sebott@redhat.com>
X-Mailer: git-send-email 2.52.0
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: HRuzon1YPHm-rIe7CYymRuOj-fBp_7OLxv-sMUlq8_w_1764691739
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

This series adds a vcpu knob to request a specific PSCI version
from KVM via the KVM_REG_ARM_PSCI_VERSION FW register.

The use case for this is to support migration between host kernels
that differ in their default (a.k.a. most recent) PSCI version.

Note: in order to support PSCI v0.1 we need to drop vcpu
initialization with KVM_CAP_ARM_PSCI_0_2 in that case.
Alternatively we could limit support to versions >=0.2 .

Changes since V3 [3]:
* changed variable name as requested by Eric
* added R-B
Changes since V2 [2]:
* fix kvm_get_psci_version() when the prop is not specified - thanks Eric!
* removed the assertion in kvm_get_psci_version() so that this also works
  with a future kernel/psci version
* added R-B
Changes since V1 [1]:
* incorporated feedback from Peter and Eric

[1] https://lore.kernel.org/kvmarm/20250911144923.24259-1-sebott@redhat.com/
[2] https://lore.kernel.org/kvmarm/20251030165905.73295-1-sebott@redhat.com/
[3] https://lore.kernel.org/kvmarm/20251112181357.38999-1-sebott@redhat.com/

Sebastian Ott (2):
  target/arm/kvm: add constants for new PSCI versions
  target/arm/kvm: add kvm-psci-version vcpu property

 docs/system/arm/cpu-features.rst |  5 +++
 target/arm/cpu.h                 |  6 +++
 target/arm/kvm-consts.h          |  2 +
 target/arm/kvm.c                 | 64 +++++++++++++++++++++++++++++++-
 4 files changed, 76 insertions(+), 1 deletion(-)

-- 
2.42.0

