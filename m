Received: from mta1.migadu.com (out-78.mta1.migadu.com [95.215.58.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FF2D38BF75
	for <kvmarm@lists.linux.dev>; Tue, 25 Aug 2026 16:42:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.78
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787676150; cv=none; b=Hw+u2MS66VNMSNidSV0oFBtvwb3gdNy0fe8MfqZbP6qFJnZmbJm3Fo7EGqM8CJCulPOnX0qdTCV3Zo7zjGdNCfaO/IuYF+1LvdHrbH+rf70EJIqeAVPJ/zmdbJTsWz7gG3VHwgVhwSLn8YoRaeWgGMqBN/vzGlkf3/9CJzwEwaQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787676150; c=relaxed/simple;
	bh=m4Ir8Cavv78G8+hX1oUwWO13M0HehJctD/4dIgHdMAc=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=dVvHAciGhQ0iHD/QR28m+N2/eTbBRwKHdtF8832XxJXCUJvtB8kmUFK1lzY5mNCrNBsp2aEo6tQvs3dikz/mcewkPLAhUXL59BzZsDKcnO1NRQzbJBfh77DTEyHa93rifus5Fq2HNOMO0g45d2Gdy0MJKwJIceLf0/JVhtLYwUc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=oXzYqLhF; arc=none smtp.client-ip=95.215.58.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="oXzYqLhF"
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=m4Ir8Cavv78G8+hX1oUwWO13M0HehJctD/4dIgHdMAc=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787676145; v=1; x=1788280945;
 b=oXzYqLhFaBc18cwa1SLhpAo7QhuxWELEZC2ZEVZO2nElJqnUdjqzLQuyODS4k7u9JXOHXxzW
 xe1/jv68a0SprmKRoGo9YY969KeeziGKL9TmHR89D5qO9vMQP0Wzww75wlY7ADlDs03c9Yml4uw
 Wr79I1WdT5mnEJ8L6loVAV9A=
X-Envelope-To: kvmarm@lists.linux.dev
Received: from claudy.local (2a01:4b00:ad36:1d00:3a05:25ff:fe33:35a9)
	by smtp.migadu.com with ESMTPS id 78016a66fb8f874d;
	Tue, 25 Aug 2026 16:42:25 +0000
X-Mizu-Trace-ID: 78016a66fb8f874d
X-Migadu-Flow: FLOW_OUT
From: Fuad Tabba <fuad.tabba@linux.dev>
To: Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	linux-arm-kernel@lists.infradead.org
Cc: Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Mark Brown <broonie@kernel.org>,
	kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Fuad Tabba <tabba@google.com>
Subject: [PATCH v4 0/2] arm64: Clamp ID overrides and gate the GMID_EL1 read
Date: Tue, 25 Aug 2026 17:42:17 +0100
Message-Id: <20260825164219.3347229-1-fuad.tabba@linux.dev>
X-Mailer: git-send-email 2.39.5
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi folks,

Changes since v3 [1]:
  - Gate on __read_sysreg_by_encoding() and drop the helper's argument,
    so the command-line override is not open-coded in the header.
    (Catalin)
  - Pick up Suzuki's override clamp as patch 1, rather than adding a
    raw-presence check to the gate. (Will)

Patch 2 fixes a GMID_EL1 read that traps to EL2 when the kernel has
disabled MTE, panicking the host under pKVM on a CPU that is offlined
and brought back online. It gates the read on
__read_sysreg_by_encoding().

That needs patch 1, Suzuki's override clamp [2]. Without it
__read_sysreg_by_encoding() applies the command-line override raw, so
id_aa64pfr1.mte=2 on a CPU without FEAT_MTE2 makes the gate true and the
kernel reads a GMID_EL1 that is not there. On the boot CPU that read
comes before init_cpu_ftr_reg() strips the unsafe override, so the gate
cannot rely on it.

Tested on QEMU under pKVM. With -machine virt,mte=on, offlining and
onlining CPU1 with arm64.nomte panics an unpatched v7.2 in
__cpuinfo_store_cpu() and does not with the series. Without tag memory,
where QEMU implements no GMID_EL1, id_aa64pfr1.mte=2 covers the
force-up case.

Based on Linux 7.2 (8d3ae59288f1e).

Cheers,
/fuad

[1] https://lore.kernel.org/all/20260824184155.2644646-1-fuad.tabba@linux.dev/
[2] https://lore.kernel.org/all/afc5bd00-28ca-413b-b047-ee53589c285d@arm.com/

Fuad Tabba (1):
  arm64: Don't read GMID_EL1 when MTE is disabled

Suzuki K Poulose (1):
  arm64: Apply overrides to CPU local capabilities

 arch/arm64/include/asm/cpufeature.h |  9 ++++++
 arch/arm64/kernel/cpufeature.c      | 48 +++++++++++++++++++++--------
 arch/arm64/kernel/cpuinfo.c         |  2 +-
 3 files changed, 46 insertions(+), 13 deletions(-)

-- 
2.39.5

