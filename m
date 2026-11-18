Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=95.215.58.101
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795015233;
	b=gm0wthPYE588ej13Q/seOGe5AXQXfvxSnJkLjOU5CcYCXQOWddfK3TopHVPE0qx4C78J
	 aZ6zeJMr90MSdNU5UWN5FUp2K8a6eea5FegmIVylDlb4RWTcJKT9HaTQwwTucWfZ78Yky
	 3eME2xvKLrA8c9qXl8MuAcbUVmzP/mIjUfD0Y1EI05CpiUM1QHOyPHJiTr8TGDLt9SDF5
	 GH/BDCYS+JFBE5uJ/vYC863X3x4VTT5tmjaTE0doOphW928w3b3aFWtoNRQcfjx1ihjW5
	 16Eklzsg7S0ElIdpEG2OjSvkyL4WghIqZY6tMhIz0kcXVH90MbUdlsopGnsDwz743XQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795015233;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=oQ7/76fO2leskAhxJa0tMmqKEgvrv4+HDmHvOOSZhVQ=;
	b=0gVayIbBeMO63E064x+asIIk+bYlDBB5grzc6HTpqPTOdf/TN1UdLrbdsktbDP6+RDzO
	 YrzC6IdRwyPJWzP9QF4il9kEZjp8wT4KVlbBg2NgdNiN8E2Q7BZ1zivcTH9HLZpKw1Txv
	 zIhH3jQq1hdEiRpiNBW6b2jVEaVwRp4rE+Z5NLZ+3PubYSxzx/Uhg/oTXOwDnZHM+oufK
	 gwq4kkNsXrW3npWtaNennnKUuDfhFNlOxC19l3Jwuc95s7N0IK/75K2WmNd3sB03Gg/YJ
	 xPpaN5VjsMxQKlLDRWJS/zf2Cxc8Z7aAoaaOuYj/7pJF/dGZehQMVZOqni4bndUK4Qw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=RzsZh72W;
	arc=none smtp.remote-ip=95.215.58.101
Received: from mta1.migadu.com (out-101.mta1.migadu.com [95.215.58.101])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20ECD606A320
	for <kvmarm@lists.linux.dev>; Wed, 18 Nov 2026 15:20:32 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 20ECD606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=RzsZh72W
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=47gIjtTcGEzXpA6nYjzGeB64WTHu7X3hRByD7TlCFJY=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795015231; v=1; x=1795620031;
 b=RzsZh72W29An4z+Rx19sTLALKG21qoU+4mM0dWuc/Nm4M8/d7du8laOTf6uYnAtU/mt76ijR
 pcCSNCI7woV4TSW/Z6Yh/+bMHzcgACYwxXIpC41ihHEjh/AIcetIuuFpBsawfYIigmL+Tx0I5rJ
 N9rz0tVurpezu96MLqbjqL7c=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id c3287a313e6c4790;
	Wed, 18 Nov 2026 15:20:26 +0000
X-Mizu-Trace-ID: c3287a313e6c4790
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
Subject: [PATCH v4 13/13] Documentation: KVM: arm64: Describe the ITS hardening
Date: Wed, 18 Nov 2026 15:19:04 +0000
Message-ID: <20261118151904.4099560-14-fuad.tabba@linux.dev>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261118151904.4099560-1-fuad.tabba@linux.dev>
References: <20261118151904.4099560-1-fuad.tabba@linux.dev>
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

Describe in pkvm.rst why the hypervisor emulates the host's ITS, and how
protected mode differs from non-protected mode as a result.

Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>
---
 Documentation/virt/kvm/arm/pkvm.rst | 34 +++++++++++++++++++++++++++++
 1 file changed, 34 insertions(+)

diff --git a/Documentation/virt/kvm/arm/pkvm.rst b/Documentation/virt/kvm/arm/pkvm.rst
index b75bb8ad6f26d..c1b1b8089ff72 100644
--- a/Documentation/virt/kvm/arm/pkvm.rst
+++ b/Documentation/virt/kvm/arm/pkvm.rst
@@ -89,6 +89,40 @@ DMA isolation using an IOMMU
 
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
+ensure that the host cannot point the ITS command queue or tables at
+hypervisor or pVM memory. The hypervisor owns the command queue and
+the ITS tables for as long as the ITS can access them, and it owns each
+device's interrupt translation table from the device's first mapping
+onwards.
+
+This gives rise to some user-visible differences when compared to
+non-protected mode:
+
+* Protected mode requires the hypervisor to take control of every ITS
+  that the host uses. KVM does not initialise with more than 8 ITSes, and
+  if the takeover fails the host is not deprivileged and
+  ``KVM_CREATE_VM`` returns ``-ENODEV``.
+* An ITS command or register access that the hypervisor rejects is
+  delivered to the host as a data abort.
+* The number of device IDs used through each ITS since boot is limited
+  by the hypervisor, and MSI allocation fails with ``-ENOMEM`` beyond
+  that limit.
+* Interrupt translation tables are page-aligned and are not freed when
+  a device is removed, so each device ID used since boot holds at least
+  one page.
+* GICv4 is disabled. Direct injection of LPIs is not available to
+  non-protected guests, and restoring a guest migrated from a host with
+  ``GICD_TYPER2.nASSGIcap`` set fails with ``-EINVAL``.
+
 Proxying of Trustzone services
 ------------------------------
 
-- 
2.47.3

