Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76287298CAF
	for <kvmarm@lists.linux.dev>; Mon, 12 May 2025 18:04:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747073072; cv=none; b=nVjq4xwX/DRTjYfeY6m2XAxktS42pzUAaGa6Cc2sFgmttdAbApyo3JI+qbzqJ+oChbQr2iqxzyQ4BQDkut6IMZgpBgSL8W109SOAtOuFkeQo+rqIYtHBUfVveUituxwSZGVkBxxl2UCBzn7HeHBDXcrIjb/IfZ1OEv01F/YNhOw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747073072; c=relaxed/simple;
	bh=01AxGl5y9sewo+AjNmG3P95dBC2IXR63aHqvqvehehg=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=ROOq+bx+hVGsGTtJEmzpZdD6d21cW71Mz/lDLFWGXEV/m67DuKTBqLm6RGD6qQtyYAF+EV2wZMl+ch+A1pbc9jineA6bcypCtBfzf8bm2BfiUtV2yrWFdYcREPTDiec8gPDh4NLlg+sjMtjifadCWb/LqYVQIU1US5FvCsyhjFs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Oq+W8lz+; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Oq+W8lz+"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1747073069;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=Jzez9beQL600E+agH2Z2p3TWupq3wuiKJM0KPUz5arQ=;
	b=Oq+W8lz+0qFGdeY/yW1MzLEyssNDWjNY//QWWZjDfvRKmtgooGA4R1z4yKj3I8NQXF6HP5
	ODUTGRiGvGbvxYjMOPiKL/DfRY0MifVrDluGoL7Phb8vvNCoGajgMNAL1j8X4NQOVfXiMG
	2DjRtr/I6Ai21UDBuinaXPfrJFMwrK0=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-617-Mc8z2qJpM0WcOmyyGPFIow-1; Mon,
 12 May 2025 14:04:25 -0400
X-MC-Unique: Mc8z2qJpM0WcOmyyGPFIow-1
X-Mimecast-MFC-AGG-ID: Mc8z2qJpM0WcOmyyGPFIow_1747073061
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 7837C1800263;
	Mon, 12 May 2025 18:04:17 +0000 (UTC)
Received: from intellaptop.lan (unknown [10.22.80.5])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id B909630002D4;
	Mon, 12 May 2025 18:04:08 +0000 (UTC)
From: Maxim Levitsky <mlevitsk@redhat.com>
To: kvm@vger.kernel.org
Cc: Suzuki K Poulose <suzuki.poulose@arm.com>,
	Jing Zhang <jingzhangos@google.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Sebastian Ott <sebott@redhat.com>,
	Shusen Li <lishusen2@huawei.com>,
	Waiman Long <longman@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	linux-arm-kernel@lists.infradead.org,
	Bjorn Helgaas <bhelgaas@google.com>,
	Borislav Petkov <bp@alien8.de>,
	Anup Patel <anup@brainfault.org>,
	Will Deacon <will@kernel.org>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Alexander Potapenko <glider@google.com>,
	kvmarm@lists.linux.dev,
	Keisuke Nishimura <keisuke.nishimura@inria.fr>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Atish Patra <atishp@atishpatra.org>,
	Joey Gouly <joey.gouly@arm.com>,
	x86@kernel.org,
	Marc Zyngier <maz@kernel.org>,
	Sean Christopherson <seanjc@google.com>,
	Andre Przywara <andre.przywara@arm.com>,
	Kunkun Jiang <jiangkunkun@huawei.com>,
	linux-riscv@lists.infradead.org,
	Randy Dunlap <rdunlap@infradead.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Boqun Feng <boqun.feng@gmail.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Alexandre Ghiti <alex@ghiti.fr>,
	linux-kernel@vger.kernel.org,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	kvm-riscv@lists.infradead.org,
	Maxim Levitsky <mlevitsk@redhat.com>,
	Ingo Molnar <mingo@redhat.com>,
	Paul Walmsley <paul.walmsley@sifive.com>,
	Albert Ou <aou@eecs.berkeley.edu>
Subject: [PATCH v5 0/6] KVM: lockdep improvements
Date: Mon, 12 May 2025 14:04:01 -0400
Message-ID: <20250512180407.659015-1-mlevitsk@redhat.com>
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

This is	a continuation of my 'extract lock_all_vcpus/unlock_all_vcpus'=0D
patch series.=0D
=0D
Implement the suggestion of using lockdep's "nest_lock" feature=0D
when locking all KVM vCPUs by adding mutex_trylock_nest_lock() and=0D
mutex_lock_killable_nest_lock() and use these functions	in the=0D
implementation of the=0D
kvm_trylock_all_vcpus()/kvm_lock_all_vcpus()/kvm_unlock_all_vcpus().=0D
=0D
Those changes allow removal of a custom workaround that was needed to=0D
silence the lockdep warning in the SEV code and also stop lockdep from=0D
complaining in case of ARM and RISC-V code which doesn't include the above=
=0D
mentioned workaround.=0D
=0D
Finally, it's worth noting that this patch series removes a fair=0D
amount of duplicate code by implementing the logic in one place.=0D
=0D
V5: addressed review feedback.=0D
=0D
Best regards,=0D
	Maxim Levitsky=0D
=0D
Maxim Levitsky (6):=0D
  locking/mutex: implement mutex_trylock_nested=0D
  locking/mutex: implement mutex_lock_killable_nest_lock=0D
  KVM: add kvm_lock_all_vcpus and kvm_trylock_all_vcpus=0D
  x86: KVM: SVM: use kvm_lock_all_vcpus instead of a custom=0D
    implementation=0D
  KVM: arm64: use kvm_trylock_all_vcpus when locking all vCPUs=0D
  RISC-V: KVM: use kvm_trylock_all_vcpus when locking all vCPUs=0D
=0D
 arch/arm64/include/asm/kvm_host.h     |  3 --=0D
 arch/arm64/kvm/arch_timer.c           |  4 +-=0D
 arch/arm64/kvm/arm.c                  | 43 ----------------=0D
 arch/arm64/kvm/vgic/vgic-init.c       |  4 +-=0D
 arch/arm64/kvm/vgic/vgic-its.c        |  8 +--=0D
 arch/arm64/kvm/vgic/vgic-kvm-device.c | 12 ++---=0D
 arch/riscv/kvm/aia_device.c           | 34 +------------=0D
 arch/x86/kvm/svm/sev.c                | 72 ++-------------------------=0D
 include/linux/kvm_host.h              |  4 ++=0D
 include/linux/mutex.h                 | 32 ++++++++++--=0D
 kernel/locking/mutex.c                | 21 +++++---=0D
 virt/kvm/kvm_main.c                   | 59 ++++++++++++++++++++++=0D
 12 files changed, 126 insertions(+), 170 deletions(-)=0D
=0D
-- =0D
2.46.0=0D
=0D

