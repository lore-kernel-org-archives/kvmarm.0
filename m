Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=90.155.92.199
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794529802;
	b=NK4L1Qz0TWjwpXSkpthMkO3ICK06/qKh46Fyha0wj6A5haH5F1PwrlQlKOkOoZUmihZJ
	 aq6h88LWUym47Cse+KwKL7gpE3F1MgtGgLUTU1fxb35YStyPjlZ1OWfYxV2Y8ERUGUuKz
	 19URoXw6O+ErCe8FyHSeVpIdrmIOutI889rHullib1BSbFh9VdV9xrMQq2IYD2WsPoY81
	 /OSFyj1z0Eov/vRMFcD3/Yd6y9ATy93JfXeddWGbhrVY9DV5bMviUrcm7x87MeM7PahpW
	 ZfFVeM6/APS8p6v2Dk1I5AkxZdGolDmaLWmMZsGrx0Lfg3colCtoS17Wr+CVRggxBMw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794529802;
	h=DMARC-Filter:DKIM-Signature:Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:Sender:X-SRS-Rewrite;
	bh=WUzZAc94TsS7Jml651A4i89wAxxOVIQCfAZAmZSXQi4=;
	b=hB9i8sH67X2kk964XfBffgrGLV2Ni5h0YFErbzTJWJ+dXERlyd20QdTe0howYfXHswBJ
	 U8bpmLtwp7gYTtT0TUPoUtqkXVpLGghCBS3WmyDTy0hEIWFBdlKAwNaZhwGsb4NsHxMiW
	 FB1Z7NcNVxbRYHbSqYf3SZnhlJldq3t/C76asJrn+xZjQK/v6T/jtP3PQz8t+mP/T3fiB
	 8WrKMlAF6QetfVx9nUsIvFRpqLtRWN1MxdXRO/jyuoiEM3cAHWeo2em64D6sg04n9N3nw
	 Yjynwpn81iZLCmF2GhalnnCk/cOMQx83GBNSwhbcQBfX1aQIpMGrKJ4RQs/LVr4YLPQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=infradead.org;
	spf=none smtp.mailfrom=desiato.srs.infradead.org;
	dkim=pass header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=desiato.20200630 header.b="E2UibT/+";
	arc=none smtp.remote-ip=90.155.92.199
Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBE75606A323;
	Fri, 13 Nov 2026 00:30:00 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org DBE75606A323
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=desiato.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=desiato.20200630 header.b=E2UibT/+
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=WUzZAc94TsS7Jml651A4i89wAxxOVIQCfAZAmZSXQi4=; b=E2UibT/+k5GThbDF7kF1kpxCWv
	3iflL7tFohUAGCfEHj7vzeKG8ozJ3nn5nLuxUjav9wzS8efjNIJ0+uTTEW/Qryp1HFnmjrkLoeURq
	af+HJwcsGTeARjxvnm+1yi/ijLHpxMB/n0oZcE5hOuvUC6hppnvXcrTk0p7esTg6pS5VYDfX1K77y
	9Rk84h7wESXJ2Yafz+0bczwrCSx6Q2VvFyNCWPw+pO/L6vdg09OQh9L8kXufrI5kla8wcPmMGLs/M
	ZPRua1PeNQs0VJHG/KqgeC2nrwrNo00TnjnBaElzeLrmgFZXSEdPpJUFFOx+e9swWCRhqnCxy+s7o
	5sU7mb2Q==;
Received: from [2001:8b0:10b:1::425] (helo=i7.infradead.org)
	by desiato.infradead.org with esmtpsa (Exim 4.100.1 #2 (Red Hat Linux))
	id 1xRfAt-0000000AqdF-0X34;
	Fri, 13 Nov 2026 00:29:51 +0000
Received: from dwoodhou by i7.infradead.org with local (Exim 4.99.5 #2 (Red Hat Linux))
	id 1xRfAq-00000000DvM-0tIh;
	Fri, 13 Nov 2026 00:29:48 +0000
From: David Woodhouse <dwmw2@infradead.org>
To: =?UTF-8?q?J=C3=B6rg=20R=C3=B6del?= <joro@8bytes.org>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	Tom Lendacky <thomas.lendacky@amd.com>,
	ashish.kalra@amd.com,
	michael.roth@amd.com,
	nsaenz@amazon.com,
	anelkz@amazon.de,
	James.Bottomley@HansenPartnership.com,
	Melody Wang <huibo.wang@amd.com>,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	kvmarm@lists.linux.dev,
	loongarch@lists.linux.dev,
	linux-mips@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org,
	kvm-riscv@lists.infradead.org,
	x86@kernel.org,
	coconut-svsm@lists.linux.dev,
	joerg.roedel@amd.com,
	Mushahid Hussain <hmushi@amazon.co.uk>,
	Sriram Nambakam <snambakam@linux.microsoft.com>,
	David Woodhouse <dwmw@amazon.co.uk>
Subject: [PATCH 17/16] Documentation: kvm: Renumber KVM_CREATE_PLANE and restore the kvm_run label
Date: Thu, 12 Nov 2026 17:29:47 -0700
Message-ID: <20261113002948.53522-1-dwmw2@infradead.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261111222911.477-1-dwmw2@infradead.org>
References: <20261111222911.477-1-dwmw2@infradead.org>
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
Sender: David Woodhouse <dwmw2@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by desiato.infradead.org. See http://www.infradead.org/rpr.html

From: David Woodhouse <dwmw@amazon.co.uk>

The KVM_CREATE_PLANE section was inserted between the .. _kvm_run:
label and "5. The kvm_run structure", so the :ref:`kvm_run` in the
KVM_CAP_SYNC_REGS text now links to KVM_CREATE_PLANE. It also took the
number 4.145, which KVM_PPC_GET_COMPAT_CAPS already has, leaving 4.147
unused.

Move the label back above section 5 and number the section 4.147.

Found by a local Sashiko review.

Fixes the section placement in "Documentation: kvm: introduce "VM
plane" concept".

Fixes: https://lore.kernel.org/all/20260608144252.351443-9-joro@8bytes.org/
Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
---
 Documentation/virt/kvm/api.rst | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index c1a6536354fd..9aa09d8a39dc 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -6821,11 +6821,9 @@ if the guest_memfd memory was pinned in IOMMU page tables.
 
 See also: :ref:`KVM_SET_MEMORY_ATTRIBUTES`.
 
-.. _kvm_run:
-
 .. _KVM_CREATE_PLANE:
 
-4.145 KVM_CREATE_PLANE
+4.147 KVM_CREATE_PLANE
 ----------------------
 
 :Capability: KVM_CAP_PLANES
@@ -6843,6 +6841,8 @@ in the future may use the plane id when planes are supported by hardware (as is
 the case for VMPLs in AMD), or if KVM supports accelerated plane switch
 operations (as might be the case for Hyper-V VTLs).
 
+.. _kvm_run:
+
 5. The kvm_run structure
 ========================
 
-- 
2.50.1

