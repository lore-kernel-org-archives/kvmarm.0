Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 578D228EA
	for <kvmarm@lists.linux.dev>; Tue, 11 Feb 2025 00:09:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739232578; cv=none; b=SEoIUQqaCKbP4j5crRr3oIqrJylB0ThDwbO69kPFuLKnPGwsQfSNXkIiqZ0UNsXZuhZqM8T1evNjeN7XE5zMF+25PzYpa3K/jf9Mz9r8XjqDmL0qbRT6x0v2mMSX1nS+Dl9WPGguIbjvbhcz8S3UyGN2SUdTR03v5Sq6a5eOfII=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739232578; c=relaxed/simple;
	bh=kbNjG86W9AzGPqRCEhKG6CUtamg2Jt2c0Ij/m45WACk=;
	h=From:To:Cc:Subject:Date:Message-Id:Content-Type:MIME-Version; b=bO5R8b7fYjK4TsVF+MvD0uOE9l5usaSuR2qBt36cjl9jG0+VZuvy9G7WFcbYftNWTAog26kDNHoKoorlJk5r/GuNa+ni4LGtsok50YxhTP7vrGWgD0wVWpAFfst+xlHIcTfTeKxYyk3fNqj2JrlvYin79DkEE/gV0owssELns+Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=N0srzDoB; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="N0srzDoB"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1739232575;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=jAgG5PbVpxfjPiUq1P9KoLaJMoVyaxTfP/N5PAh92BE=;
	b=N0srzDoBbGkSTkTw/1kYLbP/4yc5fNMMiKxDtqpra4AE2f9W/L/0J19MRiDFVV5+AGhPwi
	W3bZZnK22BUckBBLoWmdIzP6jeAxb9IDq1oU3c2pkyOsZH7uxps6+gzQFwiya12ZH/NULC
	FFB8gTu6fv0vPhln6eyUjQsN5x3fkKI=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-450-4NLqzznmNha3XRZVRKy4uw-1; Mon,
 10 Feb 2025 19:09:30 -0500
X-MC-Unique: 4NLqzznmNha3XRZVRKy4uw-1
X-Mimecast-MFC-AGG-ID: 4NLqzznmNha3XRZVRKy4uw
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id BCD7B1956086;
	Tue, 11 Feb 2025 00:09:25 +0000 (UTC)
Received: from starship.lan (unknown [10.22.65.174])
	by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 6AAFB19560A3;
	Tue, 11 Feb 2025 00:09:18 +0000 (UTC)
From: Maxim Levitsky <mlevitsk@redhat.com>
To: kvm@vger.kernel.org
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	Jing Zhang <jingzhangos@google.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	linux-arm-kernel@lists.infradead.org,
	Marc Zyngier <maz@kernel.org>,
	linux-kernel@vger.kernel.org,
	Randy Dunlap <rdunlap@infradead.org>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	kvm-riscv@lists.infradead.org,
	Ingo Molnar <mingo@redhat.com>,
	linux-riscv@lists.infradead.org,
	Joey Gouly <joey.gouly@arm.com>,
	Paul Walmsley <paul.walmsley@sifive.com>,
	Maxim Levitsky <mlevitsk@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Albert Ou <aou@eecs.berkeley.edu>,
	kvmarm@lists.linux.dev,
	Alexander Potapenko <glider@google.com>,
	x86@kernel.org,
	Sean Christopherson <seanjc@google.com>,
	Anup Patel <anup@brainfault.org>,
	Kunkun Jiang <jiangkunkun@huawei.com>,
	Atish Patra <atishp@atishpatra.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH 0/3] KVM: extract lock_all_vcpus/unlock_all_vcpus
Date: Mon, 10 Feb 2025 19:09:14 -0500
Message-Id: <20250211000917.166856-1-mlevitsk@redhat.com>
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.40

Implement Paolo's suggestion of reusing=0D
sev_lock/unlock_vcpus_for_migration in arm and riscv code=0D
for the purpose of taking vcpu->mutex of all vcpus of a VM.=0D
=0D
Because sev_lock/unlock_vcpus_for_migration already have a workaround=0D
for lockdep max lock depth, this fixes the lockdep warnings on arm=0D
which were the inspiration for this refactoring.=0D
=0D
This patch series was only compile tested on all 3 architectures.=0D
=0D
Best regards,=0D
	Maxim Levitsky=0D
=0D
Maxim Levitsky (3):=0D
  KVM: x86: move sev_lock/unlock_vcpus_for_migration to kvm_main.c=0D
  KVM: arm64: switch to using kvm_lock/unlock_all_vcpus=0D
  RISC-V: KVM: switch to kvm_lock/unlock_all_vcpus=0D
=0D
 arch/arm64/include/asm/kvm_host.h     |  3 --=0D
 arch/arm64/kvm/arch_timer.c           |  8 ++--=0D
 arch/arm64/kvm/arm.c                  | 32 -------------=0D
 arch/arm64/kvm/vgic/vgic-init.c       | 11 +++--=0D
 arch/arm64/kvm/vgic/vgic-its.c        | 18 +++----=0D
 arch/arm64/kvm/vgic/vgic-kvm-device.c | 21 ++++----=0D
 arch/riscv/kvm/aia_device.c           | 36 ++------------=0D
 arch/x86/kvm/svm/sev.c                | 65 ++-----------------------=0D
 include/linux/kvm_host.h              |  6 +++=0D
 virt/kvm/kvm_main.c                   | 69 +++++++++++++++++++++++++++=0D
 10 files changed, 115 insertions(+), 154 deletions(-)=0D
=0D
-- =0D
2.26.3=0D
=0D

