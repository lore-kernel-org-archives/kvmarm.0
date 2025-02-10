Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CFAB1E32A2
	for <kvmarm@lists.linux.dev>; Mon, 10 Feb 2025 15:49:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739202600; cv=none; b=CXzN7elhNVVXPexPnwmqI/3L9VwL8nuqMpB3vj37j0eJPYSRd3XLKEJlOKDzJ0suskjuIaDL2VZzA53P6U33cJaWDQdExsFRk4dfwgBFZwy3LHG6ppNencC6Oz9EjgvFMqAA5av1SA7c/G6nn0DQyUcagJubwWKGkcSrHVX2gZw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739202600; c=relaxed/simple;
	bh=hTF9BBpSp14sdvnM3Qbav0GMODhgNlVIj19eZpklVHo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:content-type; b=q0yoXplL/5b/UazcJfh9FG6UKdi7Y+GNQ3RiDg3ssua3N8cSRQBWGFFLN5BshRa0KfjHKLnuVwr684iouQ6J6XlXD10RVzdSlWwsZgVxHrje8/j18/WoOY/GMXNNFcckq0JZGrq4rz7KVDW1Aln9vj3wfIKXKO9GkXLVk2Lg+L8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=CtoRWvlF; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="CtoRWvlF"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1739202598;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=XD0KIaPZUowHnH+rhCFRqX97yTDIYw3TwTQ1B3wDB2g=;
	b=CtoRWvlFMWWc7whG5PaDPWblajSP38tosZyh0XVZ72Qkzwsf55sC6ETw9wZIj2O/T+tAj+
	1exy7WWvds/P98Se9223YHEzjVX9qoTfOmwtR6vsD366LuSz3zvk6Nv3/SkPpRhdKwmiQz
	C45qU0WYXFVvifhwR1EbuMoCIx2uxmI=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-167-LmXqnZhGMHS1v9uOnibtjQ-1; Mon, 10 Feb 2025 10:49:56 -0500
X-MC-Unique: LmXqnZhGMHS1v9uOnibtjQ-1
X-Mimecast-MFC-AGG-ID: LmXqnZhGMHS1v9uOnibtjQ
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-438da39bb69so34519725e9.0
        for <kvmarm@lists.linux.dev>; Mon, 10 Feb 2025 07:49:56 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739202596; x=1739807396;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=XD0KIaPZUowHnH+rhCFRqX97yTDIYw3TwTQ1B3wDB2g=;
        b=X4mBQPO0EtYOSgRx3843VvcZUIO1SeZXcKb3RVbGz/BfIPxLr+VJwHQvv9i3GGAqTn
         nTzP3+pPrNNFrh+XGi1zhQ9KdUr6vdC9Wr400DRQbgmcnKIKDp5gMM19ukug1zY7vPe/
         KlFZQOLsvZ8ffWlSKfc/cewDHpWIeFewfCJfmqtB5HOZ5LjY1vZ76CMQ13sqgRPAuIEN
         AkS4gf8iTORMGmSPgDOFQIFV5LYeZM7HoHbV4oAAEc6ixHSp9CDb4HPx7MjzRcFOR073
         zCAOs3l3/O/9OQGSTUySFftUNkv3MLuIjt1IkkiFCFgjP9Gwr+RJ6gHvB0aUT6OKdbp2
         b0kQ==
X-Forwarded-Encrypted: i=1; AJvYcCVE90CHAhTckTwE5bBydX5T1nvCJxDVJSVueugDtan6YDa2DSgdjmY+qw4Ixgrkh54piZ9z5t4=@lists.linux.dev
X-Gm-Message-State: AOJu0YxUJbnILmOROvDYp9TU41UjVGcqRpOxTpoc7r9svzDuTVsq9jNH
	1F8uZ1jeeifF1PelP4nLjxiA00pz6h7t5TrgBkA7/e9JyxGbjkydJ8bPxZwqLu6mqpxZ+hdqoLM
	5UbQMPorT69TRtKzA8oJ4CRngfToEMxr5HYFWkdyerH0xHjyzFbvqug==
X-Gm-Gg: ASbGncuGHOUrQkgPU7wP5WhN0YDQh/I0PB3s25cJNc1ekrJVTryBXbQwp+lzL3NFwQu
	TNutP1ZyIzsUvud+is60ukoi0RFzpEsdxtU5ASJBZibZZGlxzgHE8wzD1SP6UNaGSxUT/E1wnAj
	EVLCdr9fmLlG0LDLygA+9woxGHCfVE7slfrd04bXytUwndExhUxZ5fcJQs/WK+yHsF76XPmUoO8
	DbP1s004wRmgJKqjbMGEoEJ+WoPrJ77NNuR27a2ju4tktUz3M101repODQ1OeNsdSQHnPdNGbOD
	lUivd/eC9gnrH827Ecb4qlX6aoSy5O3HVJmPF92fzRLisFUBgwwFSEA2BAoZSRKRQLc=
X-Received: by 2002:a05:600c:1e25:b0:436:17e4:ad4c with SMTP id 5b1f17b1804b1-43924972ce9mr110358905e9.6.1739202595724;
        Mon, 10 Feb 2025 07:49:55 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEOvLjTF4S/WYvn3O6o65yj9aqhnQ/dCaqnHrrF3Js86fWc5irhrJ2sZiow1ffrtpyp0aYWnQ==
X-Received: by 2002:a05:600c:1e25:b0:436:17e4:ad4c with SMTP id 5b1f17b1804b1-43924972ce9mr110358615e9.6.1739202595321;
        Mon, 10 Feb 2025 07:49:55 -0800 (PST)
Received: from rh.fritz.box (p200300f6af0e4d00dda53016e366575f.dip0.t-ipconnect.de. [2003:f6:af0e:4d00:dda5:3016:e366:575f])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4391da96502sm153559395e9.1.2025.02.10.07.49.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Feb 2025 07:49:55 -0800 (PST)
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
Subject: [PATCH 0/4] KVM: arm64: writable MIDR/REVIDR
Date: Mon, 10 Feb 2025 16:49:49 +0100
Message-ID: <20250210154953.27002-1-sebott@redhat.com>
X-Mailer: git-send-email 2.48.1
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: RD7q6nEf3ernM4jR9rYmfwgp5dd8FhNiryYtBa4xOHw_1739202596
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

Based on prior discussion [1] this series allows VMMs to change
MIDR/REVIDR to enable migration between machines that differ in
these registers. Since these are used for errata handling the
errata management series [2] is a prerequisite for this one.

Note that guest access to MIDR_EL1 is not trapped.

[1] https://lore.kernel.org/kvmarm/20250124151732.6072-1-shameerali.kolothum.thodi@huawei.com/T/#mb855bc51714095a164a7b26bb8bead1606e4b753
[2] https://lore.kernel.org/kvmarm/20250205132222.55816-1-shameerali.kolothum.thodi@huawei.com/T/

Sebastian Ott (4):
  KVM: arm64: Allow userspace to change MIDR_EL1
  KVM: arm64: Allow userspace to change REVIDR_EL1
  KVM: arm64: Allow userspace to change AIDR_EL1
  KVM: arm64: trap guest access for REVIDR_EL1 and AIDR_EL1

 arch/arm64/include/asm/kvm_host.h |   9 ++
 arch/arm64/kvm/sys_regs.c         | 134 +++++++++++-------------------
 2 files changed, 56 insertions(+), 87 deletions(-)

-- 
2.42.0

