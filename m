Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=95.215.58.78
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793695665;
	b=qIVwwjcYDXTBNGtD8pN0jjJiJE61j+0DDSa6J28ygJt5OlEGkpw2T4C0jEywkN4ucXTD
	 faoBdRWbAtmwIpdtt5QfZvEH1cEUNd0Qf594OzARSJ69UlKz6MOq8k0KZrPEy1oGD8u9Z
	 3VhDnharQ4JARBEbHhGjZXDAtSd85Ip09Fc8nd7XlcG3eL4FqifMEi7rS7gFQFuU13Llc
	 gNCfq0GpAHyeVVPaAOg95hjCBSfLjPP5T6Wypg3zt1T83vFyXXH68d0efuuN9Zgyp+gIg
	 ODb3uWpyspWnxI8XgX3UdTLmWjFZdJDaFNxD+Y57nmhDudlZwW+scwDktSkIk+FLWcg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793695665;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=7OZDcry484hFtiEDsHMeu9Vb1PBCwc08Fystmbso2yg=;
	b=nqa5NyUJ0EiW95mJ/wV2cqk7Gi/0Fge3JJqI1Xcx23GDN0sVUTKc7GGs5/FDtCWJtyek
	 fEBqlniqLXFgRt0k88oj+sp/ICvezPHezKTJUTCqa7zqb+p1pvnv4qlLHdaRdaQK3I/X+
	 LrNz26aBNi1JqoRoKj9bANMHlem2KHZ0luGTxK0BlMRUHTQ388e4YRUfX1XcypieWohKA
	 OeCjGJIn6YL3McaA5n/hdfAGJOPF2XVy0F/ZFgCW4G0nWEj6IjiRTVKXfB+sLYe1sKc/+
	 sIMLMDaFAXkPZN9TLs4jqk/RFGPet/DKmGb/RsAzwX8F4zTpMEeaQhUUzqxFVjETRjg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b="p/wfeKAm";
	arc=none smtp.remote-ip=95.215.58.78
Received: from mta1.migadu.com (out-78.mta1.migadu.com [95.215.58.78])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63C24606A94A
	for <kvmarm@lists.linux.dev>; Tue,  3 Nov 2026 08:47:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 63C24606A94A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=p/wfeKAm
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=Sc7XzR1F0B2mglhUJrIyIo1lpOjbjlFeRWehGGCyC88=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793695662; v=1; x=1794300462;
 b=p/wfeKAmmURwMhMhocRJeQ7uKxogG77Ispk7mg+UEZOnmn8QtA/lBWL5HsBcpt/iLkR7+Oxv
 x5D2mxHYyPkrh3lktlWaZ0HDSo8KzZg+7gY9/hT69mTNJuXqcP71zx27m0sxT+xGbVS12d57UzW
 wmaP1iey/2yJr/TEsEhbdVDg=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id af8506901e183db4;
	Tue, 03 Nov 2026 08:47:42 +0000
X-Mizu-Trace-ID: af8506901e183db4
X-Migadu-Flow: FLOW_OUT
From: Fuad Tabba <fuad.tabba@linux.dev>
To: Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>
Cc: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	Joey Gouly <joey.gouly@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Raghavendra Rao Ananta <rananta@google.com>,
	Fuad Tabba <tabba@google.com>
Subject: [PATCH 0/3] KVM: arm64: Stop stage-2 teardown scaling with the IPA size
Date: Tue,  3 Nov 2026 08:47:39 +0000
Message-ID: <20261103084742.1302597-1-fuad.tabba@linux.dev>
X-Mailer: git-send-email 2.47.3
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

Hi folks,

Two fixes for stage-2 teardown, which since 4ddfab5436b6 takes time
proportional to the size of the IPA space rather than to what is mapped.

Under QEMU TCG ('-cpu max', 16K pages with LPA2), destroying even an
empty VM takes about 7 seconds in pKVM. Without pKVM it takes about 19
seconds if the VM requests a 52-bit IPA (crosvm requests the host's
limit). I would expect it to scale the same way in hardware. I tested
only under QEMU, since I don't have hardware with LPA2.

pKVM gives every VM the host's IPA limit. The first makes it release the
VM's mappings from its tree instead of walking that space. My series
honoring KVM_VM_TYPE_ARM_IPA_SIZE in pKVM [1] (respinning it soon)
doesn't replace the fix, as crosvm requests the limit there too.

The second makes the non-pKVM teardown step over an empty entry larger
than the largest block in one go, rather than start a new walk for each
block-sized chunk of it. It depends on the first, as the lookup it adds
reads fields that hold the mapping tree on a pKVM stage-2.

The third moves the pKVM/non-pKVM split in the teardown into
kvm_vm_s2_ops, with no functional change. The first two apply back to
7.1, except that a backport of the second drops the flags argument 7.4
added to kvm_pgtable_get_leaf().

Based on Linux 7.4-rc1 (6628e7d4c6b25).

Cheers,
/fuad

[1] https://lore.kernel.org/all/20260917091826.2639205-1-fuad.tabba@linux.dev/

Fuad Tabba (3):
  KVM: arm64: Don't walk the whole IPA space when destroying a pKVM
    stage-2
  KVM: arm64: Skip empty IPA ranges when destroying stage-2 page-tables
  KVM: arm64: Move stage-2 teardown into kvm_vm_s2_ops

 arch/arm64/include/asm/kvm_host.h |  2 ++
 arch/arm64/kvm/mmu.c              | 34 +++++++++++++++++++++++--------
 arch/arm64/kvm/pkvm.c             | 17 ++++++++++++----
 3 files changed, 41 insertions(+), 12 deletions(-)


base-commit: 6628e7d4c6b25c8d18f1345e3a20d21829aae7e4
-- 
2.47.3

