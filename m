Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=95.215.58.7
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793624592;
	b=Xnysf8poPj0Z6CE2YYCmc+zq72V3sKeNe5M7AfRe4FYajy3uXAATPAMOEfe7vyvMwvFZ
	 7RETC3wk3ye3PPCmirlhn2kFgor69bYjV5qQHL/MSAsdC8Mf82VBqLExhCGYue+J4d55A
	 oCFhv7dN3BzZDWeTLvRGoKetFoXk6BpifwinU/ifwlv8gx4wWGIC3glZy0Aq1zqT9FM4B
	 M009RqNwWmYC2pCYgHrLSxr6ekhyCjAVKmGSuitASxvAS8En+XmXGRu8DU46wTn4Z6+qt
	 t8aavQqa1rIL7Bfo3vrcUp+kT5N5G+IXRqM63OWK3TtPU2bf/UOPAVHBXqD9OwgoVuA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793624592;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=LWyZ1UkaDVoP3VWJmfwDCKmpQUjYhiraBCsKNKTFD9o=;
	b=vk2GDJgNZVMlz+pKzhA7guT5US1xXxVQ7qS4s7no876+kLGXNEQEnqn9Jq6EdtYXqi9P
	 2RWhMPCO449mi3t5BDQWX2rllt8ngzc4RpBGodVV0l688jEL19B0L2HB/H2xKzcisqZ4C
	 lKb6rSSKgXVXWAWTCqJdqb228deSWG8MhwVMkbSzHOKeqMD1SDFL59hNzsNzkj1SFTvSm
	 AEFU8PSXuipj9/iDdVrzvn+CEfefebFULU/stQ1dVv8z7/KelVPGieUq3QtWhMTC1WAtF
	 pgiSczQ1NUTKwFuQfc7jZDJp7CCOpDUipQUip5Um1wxxt+Zc6fBkDSKnf74HpjSp/RQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=AyNUsiyW;
	arc=none smtp.remote-ip=95.215.58.7
Received: from mta1.migadu.com (out-7.mta1.migadu.com [95.215.58.7])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2652A606A324
	for <kvmarm@lists.linux.dev>; Mon,  2 Nov 2026 13:03:11 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2652A606A324
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=AyNUsiyW
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=DS9B5U4J+iTHwDTvPcTcDhDaIW+dVQnOIDk5Q84LEB8=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793624590; v=1; x=1794229390;
 b=AyNUsiyWPHUvVlLm0Ch+hskD0hLC+FTCjlnZY8sp3N9AFrVOsYilvnhDTRAL5FSwum5dJGyC
 aXwJ0D5Gv0OUNQfdN1xo0hajYpoR9LqRXlOf0FwMg0R45SA1PmmYtY/4J2dajfX0I/PFLUVuHhb
 eXnW07vHhxA+dayiKJfaxGT4=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id 28a34c058c471d7f;
	Mon, 02 Nov 2026 13:03:10 +0000
X-Mizu-Trace-ID: 28a34c058c471d7f
X-Migadu-Flow: FLOW_OUT
From: Fuad Tabba <fuad.tabba@linux.dev>
To: Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>
Cc: Will Deacon <will@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Raghavendra Rao Ananta <rananta@google.com>,
	Sascha Bischoff <Sascha.Bischoff@arm.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Sebastian Ene <sebastianene@google.com>,
	=?UTF-8?q?Bart=C5=82omiej=20Grzesik?= <bgrzesik@google.com>,
	Mostafa Saleh <smostafa@google.com>,
	Vincent Donnefort <vdonnefort@google.com>,
	Vladimir Murzin <vladimir.murzin@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Zenghui Yu <zenghui.yu@linux.dev>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Radu Rendec <radu@rendec.net>,
	Fuad Tabba <tabba@google.com>,
	kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v3 13/13] Documentation: KVM: arm64: Describe the ITS hardening
Date: Mon,  2 Nov 2026 13:01:33 +0000
Message-ID: <20261102130133.3684226-14-fuad.tabba@linux.dev>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261102130133.3684226-1-fuad.tabba@linux.dev>
References: <20261102130133.3684226-1-fuad.tabba@linux.dev>
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add the ITS hardening to pkvm.rst: why the hypervisor emulates the
host's ITS, and how protected mode differs from non-protected mode as a
result.

Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>
---
 Documentation/virt/kvm/arm/pkvm.rst | 32 +++++++++++++++++++++++++++++
 1 file changed, 32 insertions(+)

diff --git a/Documentation/virt/kvm/arm/pkvm.rst b/Documentation/virt/kvm/arm/pkvm.rst
index b75bb8ad6f26d..1ebae35f8373e 100644
--- a/Documentation/virt/kvm/arm/pkvm.rst
+++ b/Documentation/virt/kvm/arm/pkvm.rst
@@ -89,6 +89,38 @@ DMA isolation using an IOMMU
 
 Status: **Unimplemented.**
 
+GICv3 ITS hardening
+-------------------
+
+Status: Host accesses to the ITS control registers are trapped and
+emulated by the hypervisor. The LPI configuration and pending tables
+remain under host control.
+
+The ITS reads and writes memory at addresses programmed by the host, so
+the hypervisor emulates the ITS control registers and command queue to
+ensure that the host cannot use the ITS as a confused deputy to write
+to hypervisor or pVM memory. The command queue, the ITS tables and each
+device's interrupt translation table are owned by the hypervisor while
+the ITS can access them.
+
+This gives rise to some user-visible differences when compared to
+non-protected mode:
+
+* Protected mode requires the hypervisor to take control of every ITS
+  in the system: KVM does not initialise with more than 8 ITSes, and
+  if the takeover fails the host is not deprivileged and
+  ``KVM_CREATE_VM`` returns ``-ENODEV``.
+* An ITS command or register write that the hypervisor rejects is
+  delivered to the host as a data abort.
+* The number of devices that can be mapped through each ITS is limited
+  by the hypervisor, and MSI allocation fails with ``-ENOMEM`` beyond
+  that limit.
+* Interrupt translation tables are page-aligned, so each device
+  consumes at least one page.
+* GICv4 is disabled: direct injection of LPIs is not available to
+  non-protected guests, and a guest saved with ``GICD_TYPER2.nASSGIcap``
+  set cannot be restored (``-EINVAL``).
+
 Proxying of Trustzone services
 ------------------------------
 
-- 
2.47.3

