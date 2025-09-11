Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED7EB343D78
	for <kvmarm@lists.linux.dev>; Thu, 11 Sep 2025 14:49:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757602175; cv=none; b=Aj3cYFy4kk6sx052brLJD5pkYyO2w8zVUXVbClrvewzLikG9JpBNwAENOhoutngNgyjFdosjc5KfBNlUqfzYtxPvaDIUzGjB0ztbZqqB7bgOKO2cPDG0KV32qkD/m6qdxj6X/BZP7JkmpBoY8sCc9gcJCZWsS5OiPbRgUbmrFVk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757602175; c=relaxed/simple;
	bh=f4itS6SmhD+1bAHAW2RGqoDzpqerAJXPPgtLewtu/Tw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:content-type; b=YJDUPu1HqZ7QuA+63m4YuMsOCKbFfhUEC5CS3VBn98fjjP2NmKA9xzBE5kc8p3mhJmw+VjfKWEvGRrQYCOhxTpC9G+BCtDeVOIc4ynYkGUn/+U2bOkhUuu0T90cJ04U4e0Y9vkwauzlBJTt9vQuDA+n9+yh455ocv2AzDPR/o2Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=UDbswekQ; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="UDbswekQ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1757602172;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=oF2cIsPBN8qXmdEgTfizvTF3d/SEeert5/n3uAYGGo4=;
	b=UDbswekQu4FB+9SdZbE9K+8EtoqdgUVJmfz3vqSo9Fdj6ZxZzDspr6hfEeYyJGoD5CPSk/
	ftIRUROBSeTBGKfmZKxBDs24T6sPR18NjXYxV1in/VuPfkBBVXOZB+S8K0Hrpz+tgRL1hA
	HV+RU5nYl9Gv24YWw8MvzK2ljln2XSc=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-512-K1NmH5fsOHKeITfAjxwoZA-1; Thu, 11 Sep 2025 10:49:31 -0400
X-MC-Unique: K1NmH5fsOHKeITfAjxwoZA-1
X-Mimecast-MFC-AGG-ID: K1NmH5fsOHKeITfAjxwoZA_1757602170
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-45ddbdb92dfso6085745e9.1
        for <kvmarm@lists.linux.dev>; Thu, 11 Sep 2025 07:49:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757602170; x=1758206970;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=oF2cIsPBN8qXmdEgTfizvTF3d/SEeert5/n3uAYGGo4=;
        b=H7ouSoXPIu7YAoT8oI67QpUI5oR5ZJtAGGCgB7qvG2erG0yskz1DQ+hc3l8MX/TMob
         k5Mur604FgV6SHH7Foz82GkHUWBmil2aPqBblNsCudhu/G3ZbNUvGy1L3hIe2dchyPKX
         X6Tt1hhbkNmoQsBm9DyYyKrhJ3zjXgm6kJMI68RM3+EI31Enw05Nx8k3W5c1nhPE527N
         UNZdG8IyISkd66c2KV45V9pSdyNck5HwqBbJ5XXJ1BPX4Hi+u525A16M7ckwC/XMrTn0
         4/XjWKxib1JmD4UgxCd1FfccRprdz+8ZBPe/Dco2AtFy1TLjGjEipEDChqsRbz8U/jnO
         5mOA==
X-Forwarded-Encrypted: i=1; AJvYcCVoLVG+NYVXUz23ALwHlzUIVCoPY56/IhXZCnSQUt0itT22nvjvuBGSYeM5HTDFLUk0Nb4ggS8=@lists.linux.dev
X-Gm-Message-State: AOJu0YxG81uJAGLvx+YysPYUFZI54SnGXJD7/6DmeIQa2w7ILAlN34j3
	ynI/onQF3K/VRX/0dpD5lyC5tkVa6R9O0jtrlW+9Lq/0pSzm2/5Umb3zqjd0JVa++9jUBVsN9o7
	0o7NxMdLkqNXO0k2ugU4FpGhHbBCaki/GpoZxuOKxWCVmAynicVqNkBb6+Q==
X-Gm-Gg: ASbGncsnPOnNU331ZgS+nlr0vocTb4/MR0apdEi+QL3oPkXryXaaIWmb5J/jSXmQKTq
	DRzMx6rSB7Yl/FniZgl7Sz9yzsH4LapB7oEZ1dGOXbVtJIGd7fwnzu6use+4+phM6QMXO774JHt
	VUR7AWWbOsiXbifq4UTNz7YyMXDba+NMe0ib1wHChzLjulwfNNGlLBljpz6VyD9eq3apqLf0U1F
	+S6VGHBcR5Sidl5ycQMOfHHquGQmlFP0pKj2yEAxXD0wInoMuKnoIV5UO/QX++K7+aK70YDVpVa
	dgDY1ysvzzRkcPH3hGpzS72rpxdgN5rQdAJWIU4+8/QsbtvvbJLCkSvuJQQdJlBMLSXCXDxx0x/
	4rUmoqzEAgMkD/bueD2G1fq2bBICA
X-Received: by 2002:a05:600c:4688:b0:45d:d2d2:f095 with SMTP id 5b1f17b1804b1-45deb702e1dmr110544255e9.19.1757602170348;
        Thu, 11 Sep 2025 07:49:30 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IF8qtF1qAnlROs8xNUfS1Rs+dPLZYcpuM3doPWb7N6ekPV01fUhC82BPE/uzS0/3A1DBuiZ9g==
X-Received: by 2002:a05:600c:4688:b0:45d:d2d2:f095 with SMTP id 5b1f17b1804b1-45deb702e1dmr110544065e9.19.1757602169950;
        Thu, 11 Sep 2025 07:49:29 -0700 (PDT)
Received: from rh.redhat.com (p200300f6af131a0027bd20bfc18c447d.dip0.t-ipconnect.de. [2003:f6:af13:1a00:27bd:20bf:c18c:447d])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45e0159c27csm14941575e9.8.2025.09.11.07.49.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Sep 2025 07:49:29 -0700 (PDT)
From: Sebastian Ott <sebott@redhat.com>
To: Peter Maydell <peter.maydell@linaro.org>,
	Paolo Bonzini <pbonzini@redhat.com>
Cc: qemu-arm@nongnu.org,
	qemu-devel@nongnu.org,
	kvm@vger.kernel.org,
	kvmarm@lists.linux.dev,
	Sebastian Ott <sebott@redhat.com>
Subject: [PATCH 0/2] arm: add kvm-psci-version vcpu property
Date: Thu, 11 Sep 2025 16:49:21 +0200
Message-ID: <20250911144923.24259-1-sebott@redhat.com>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: aXspwAgcDJK22Ryq2_kEjRp6-q9Xx0wtf9jcrw267kk_1757602170
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

This series adds a vcpu knob to request a specific PSCI version
from KVM via the KVM_REG_ARM_PSCI_VERSION FW register.

Note: in order to support PSCI v0.1 we need to drop vcpu
initialization with KVM_CAP_ARM_PSCI_0_2 in that case.
Alternatively we could limit support to versions >=0.2 .

Sebastian Ott (2):
  target/arm/kvm: add constants for new PSCI versions
  target/arm/kvm: add kvm-psci-version vcpu property

 docs/system/arm/cpu-features.rst |  5 +++
 target/arm/cpu.h                 |  6 +++
 target/arm/kvm-consts.h          |  2 +
 target/arm/kvm.c                 | 70 +++++++++++++++++++++++++++++++-
 4 files changed, 82 insertions(+), 1 deletion(-)

-- 
2.42.0

