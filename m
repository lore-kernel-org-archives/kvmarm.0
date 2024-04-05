Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 657D933989
	for <kvmarm@lists.linux.dev>; Fri,  5 Apr 2024 12:01:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712318478; cv=none; b=goUyNu5VhRh3n71jX4AuQKwVKzZUazC4Ac/KkUPowbiPG2tZ1UDc7fvMxDeCPMxBvg0fjooD4jHj9yt//5OQjuppy3JNPKM1k1sPSf6sOupA2HEZ9vZiedmvUND/spEJ0r98z/b5kkGNRWExNCO50TGqHNzZlUEerKte5XauPTM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712318478; c=relaxed/simple;
	bh=dAWJ3+cXxiuZbHkwBo+d8CXVXZTUmlRT6gNYyEXFD3Q=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=Wf/Lehy3LVcNF0MmuLhBS7OPWveWK0rM0z4/Nw7/4KfC3ou2oEgLZmUv6fX0eEPSKwAjQl76+NjfSQn64GK1kVmGz5iOuEpzpgn0ZHe5OPd44dZSYyGk74A/41wrWVL/qqy+w5XhnlVb5tl0OFfDSPLvyCOFeDj8vUu6aGNpgAI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=VhpvfAah; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="VhpvfAah"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1712318476;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=fOyfVcrOV/57WM6ff0FNPDEGtLigdW9U20TrqvIPj9w=;
	b=VhpvfAah5gqyM04kxSCA6GZu3K2giRzi1vlRsFdJSwsaqKXPsHp3LzXxFuQUrCvNb1doiH
	iy1p7E9O6oDS44T3Yo9D6cQcFYLJ7HOWyfRZVez0DtV40Jr6CBC6LBtKjDKGgkzJQWfBbf
	rg9mGSP6zBE+MixDB0ZyLNudu64CWTk=
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com
 [209.85.160.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-582-XWlBmTlLP4yHmGyxu4066A-1; Fri, 05 Apr 2024 08:01:15 -0400
X-MC-Unique: XWlBmTlLP4yHmGyxu4066A-1
Received: by mail-qt1-f198.google.com with SMTP id d75a77b69052e-430b327e703so18947621cf.3
        for <kvmarm@lists.linux.dev>; Fri, 05 Apr 2024 05:01:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712318475; x=1712923275;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=fOyfVcrOV/57WM6ff0FNPDEGtLigdW9U20TrqvIPj9w=;
        b=GJnCG7hshsJh6mRlYpNHDZQGNtvs1SVDFOvE21L7Msg8b4Pk3mw5Jrf8kcZlTosUFh
         FLvKzehCP/DChSh85b2KssBmDRPNfbNwRr6K9HEl0YZ9wcDqW8qIVH77d7jzu0IARJNt
         jZi+sRkAlK5OFiul+dqFf4IRaKYSWWShllxLLDkjkMiXEHlbOKeC3Bjb4XAjv5BAJ/cJ
         EV1ptAlgIB8hLc1leFSJb933GAkKFi3BgSsjGfgFifKxRQWC2BRs6Mp4AD4ht2g79gJx
         LZ/4XEJTeWuHzgyKXKphLXLIx7RvBi1206FStagl0NYzlSyu5lLapMjnMuamoyp3gBL/
         FZeA==
X-Forwarded-Encrypted: i=1; AJvYcCWlbGZeqmx+IEYKXLJ6isNlXIHjUz8Sz2MMqPIsSxMLRKDVO/eYIg/1Gva7orJeCbe+sPWRj8C6/YsBvDrwf0Bf9afhfYTO
X-Gm-Message-State: AOJu0YxvyPUKI1obI/FoOGkePQo6pUYHmxdpPgB7WGzYffhy2iH0csl3
	4m2sqz4w3RZQL0H66W265GHsr+qNoIu8SmD/bzsMcWdrfPmk8DewJnvq/FZ+j1IkgeLcj4tgtB+
	zML71FGikOHKxc03c1mQazeAhwED6SCGQX3sIkTbG5rSZFjpSM6l+XQ==
X-Received: by 2002:ac8:5f06:0:b0:432:cfa6:5d20 with SMTP id x6-20020ac85f06000000b00432cfa65d20mr1214266qta.12.1712318474889;
        Fri, 05 Apr 2024 05:01:14 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFbkyu7lrarVuj8TBoNoTnVyIyQO0Zw8ghmwwqUIjLkAEOkX/uFF9qF4MU9eU2zyyX3VCAVhQ==
X-Received: by 2002:ac8:5f06:0:b0:432:cfa6:5d20 with SMTP id x6-20020ac85f06000000b00432cfa65d20mr1214188qta.12.1712318473883;
        Fri, 05 Apr 2024 05:01:13 -0700 (PDT)
Received: from rh.redhat.com (p200300c93f4c24001316a1e598258370.dip0.t-ipconnect.de. [2003:c9:3f4c:2400:1316:a1e5:9825:8370])
        by smtp.gmail.com with ESMTPSA id fb17-20020a05622a481100b00434383f2518sm679808qtb.87.2024.04.05.05.01.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Apr 2024 05:01:13 -0700 (PDT)
From: Sebastian Ott <sebott@redhat.com>
To: linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Cc: Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>
Subject: [PATCH 0/4] KVM: arm64: emulation for CTR_EL0
Date: Fri,  5 Apr 2024 14:01:04 +0200
Message-ID: <20240405120108.11844-1-sebott@redhat.com>
X-Mailer: git-send-email 2.44.0
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="US-ASCII"; x-default=true

Hej folks,

I'm looking into supporting migration between 2 Ampere Altra (Max)
machines (using Neoverse-N1). They are almost identical regarding
their feature id register state except for CTR_EL0.DIC which is set
on one machine but not the other.

CTR_EL0 is currently marked as invariant and migrating a VM between
those 2 machines using qemu fails.

I've send this out as an RFC before [0]. What I've changed here
based on feedback I've got from Marc was:
 * store the emulated value per VM and not per VCPU
 * allow to change more values than just the DIC bit
 * only trap guest access to that reg when needed
 * make sure to not present the guest with an inconsistent register set

Patch 2 adds a ctr_el0 member to struct kvm_arch - would it be preferred
to add it into kvm->arch.id_regs[] (this would mean to increase that
array 4x)?

Patch 3 resets CLIDR_EL1 after a write to CTR_EL0 potentially changing
the value for CLIDR_EL1 - would that be ok for userspace?

Thanks,
Sebastian

[0]: https://lore.kernel.org/all/20240318111636.10613-1-sebott@redhat.com/T/


Sebastian Ott (4):
  KVM: arm64: change return value in arm64_check_features()
  KVM: arm64: maintain per VM value for CTR_EL0
  KVM: arm64: add emulation for CTR_EL0 register
  KVM: arm64: show writable masks for feature registers

 arch/arm64/include/asm/kvm_host.h |   1 +
 arch/arm64/kvm/sys_regs.c         | 131 ++++++++++++++++++++----------
 2 files changed, 89 insertions(+), 43 deletions(-)

-- 
2.42.0

