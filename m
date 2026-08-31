Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EEA33CB557
	for <kvmarm@lists.linux.dev>; Mon, 31 Aug 2026 08:10:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788163824; cv=none; b=UnsHJ3jYbe6U7fwLNfHM2jaBJ+xXcEpmn7HztpnidkDFx/N90LfSh091NpgAjqX51aW5kCEQvCbznqfm2Og7ddw1PT+SqLryZyx+dyuOArAev6xi9uBvDlcPrk0OoWPNQMm14KyVjxpBOI7iADXHN/yFtCq3v6gMLN7LHsuTWjs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788163824; c=relaxed/simple;
	bh=r/bufVq0OkVZwEdQ//AHO/OTUOmVemWl8G+OQpZ2wJw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=uHR4Y+OYFCUxNvbrXAfWNCCvh54Ua3oohL+tos7dSl6IxyEbGVIlLmihoJKA48YoUCV45yec7T11ft/iDjHw36chRPAyp+KuI6fc40rvPdTQBFrwHP/SklKE45MqNPTQXGO+dCGVrbX18+qVvKQ3NWGLgMnAAVDGZ9PbSBTbW34=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=CDCEVpMS; arc=none smtp.client-ip=209.85.128.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="CDCEVpMS"
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-49ccfbe062eso12666035e9.3
        for <kvmarm@lists.linux.dev>; Mon, 31 Aug 2026 01:10:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788163821; x=1788768621; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Mg0FhLj+v96vUWe+LyIXKQir5MTYCv01Q4cNbefOBGw=;
        b=CDCEVpMSUvQzx/TWF6wf1R0vc4iJ1VrSvclL7UqDsm117NfPkxRYTHRugcl1lr+/6X
         jQxouOYWsv6aU1mwWs2ZSODcCtLFmK1BmgOZutpOrPQaOpecVlPULcnYomdB2pjdKPbK
         cxeYGeXE8Pl9RguhG2He+NwolYjZfr0uqAbOK+QhA8Sedw0hD8StSuVQZy2MbyssaiBC
         rQKvZ7vv3mnzooFGxhSSxWDtcMZfFfpN4UBt9TJKjMoPI0Ht5SKIfM/9+Q2rG4Hp6WLw
         mnXKRA3hE7S5TVls6kSXnYebchfNJejvlqHgjb/giJ/fKAWNsTSlcywaJwRcq+Of+kL6
         zLrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788163821; x=1788768621;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=Mg0FhLj+v96vUWe+LyIXKQir5MTYCv01Q4cNbefOBGw=;
        b=HmymfPqIFriF4rz5tEMKTi2zad7MQxACoqEH2Ygn3ZRaIHX1LRBFk556xuVBFIKHso
         qHGQ4U//W+4VWXNQYv4DEXY9fe+0oGv8VA70i4XF3w59CnTrm+b81/+3URdhA7TYyfBS
         TopeZSD3poZuIoLa21T75sPSFF74MAja/cLOS77ciCzC9g8Hm29+ivIux3PTCAPFnH+f
         D0jpD8bTCnuOt82G0nCJMrCY0mjhttyOPwEGkHEutmBj/6e3jWvFmgToSauZ9JpkPwjl
         9ur/wpnmhXpk2BWnjQvBGXq1vw8KmE2IMO7U9dEm7G7qYyB0GvihJiYrmeMLQE3C1uDO
         gaeA==
X-Forwarded-Encrypted: i=1; AHgh+Rr848wxvJWK0ElpkYAY/5FtoZMSrjYh6aehbx8k2oHFA7NNJuoLsPFllOtvsKuEL/GbYumjbpo=@lists.linux.dev
X-Gm-Message-State: AFuF++nMSUakNXart4XH4c3yV8MQj4Mo5zCY1IPwAkROdpQUorRzYiBH
	p3948GmM0O036pmYO7SeuSu3s+ig6tNa7wJs/vj3Ip7Cc6NkLuphRLGK
X-Gm-Gg: AR+sD13gpcM03Hdkcw7O28jo9LkW/XrwMrRqUgZuZCwRUUf/VMz7/qebURzP44dCEfM
	FPxJ2U6J+PMmozqbsWeDG4UdTN3vkATy8LU5cStpTHvrYYKCu11ZPcNwVveWhO0GdbaLgwWVbK1
	6Y4HoKeFxLvOmoQCjijLXgGGalyNeM/4ujErt+6klCyYIgYnD2LQUVNVx9QUa9qslHNK/vlzREk
	lEaPJVWnPp3iq+LyV3h94YFZ6MlfugdVu8kqTjr8dYiF7JAKVR2UQwp6gN2nUpMoZ60ZuUgyswa
	RLXuBXjx6rdi6eJlQ4qT7FInsF0Goq37KoAsJXf46mYK6FyCwquq0EMjIP6Rmt2C3o7yWLKVWfT
	33B+XfNCIE6QLmjXHq3+iJ9+2T3nLsoBA2k0KBeDwvRksLDSRiAItbuKG5jZYeiywzpUt14cmnw
	ykytFyegJqpBOUKW78+Q7wSlYRGYRTe8NifZo6BtAKyy3nOBwOSin/t/avtXltwrpYONdljfcFz
	YNGVh6c5kphfyjScFLX0Vvh5ctP2Ip64aNl8gQgI+oELHGe44j52PRFKfM5SFqE+kCIyYUJh9Is
	jcVSIOfhad4f+YSRxXxPNtG+leuXyMZsxbI+bQzd1T+ce+zhf5gtVhhbPYqs0NyUk5wAUH4=
X-Received: by 2002:a05:600c:4f92:b0:49b:90cc:3c87 with SMTP id 5b1f17b1804b1-49b91c487b2mr367309225e9.13.1788163820227;
        Mon, 31 Aug 2026 01:10:20 -0700 (PDT)
Received: from localhost.localdomain (dynamic-2a02-3100-acb9-0201-68d0-34d2-ad1a-175a.310.pool.telefonica.de. [2a02:3100:acb9:201:68d0:34d2:ad1a:175a])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49b95013d06sm370393515e9.12.2026.08.31.01.10.18
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 31 Aug 2026 01:10:19 -0700 (PDT)
From: Karl Mehltretter <kmehltretter@gmail.com>
To: Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>,
	kvmarm@lists.linux.dev
Cc: Karl Mehltretter <kmehltretter@gmail.com>,
	Fuad Tabba <fuad.tabba@linux.dev>,
	Joey Gouly <joey.gouly@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Shuah Khan <shuah@kernel.org>,
	Eric Auger <eric.auger@redhat.com>,
	Christoffer Dall <christoffer.dall@arm.com>,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org,
	linux-kselftest@vger.kernel.org
Subject: [PATCH v4 1/4] KVM: arm64: vgic-v3: Undo assignment on iodev registration failure
Date: Mon, 31 Aug 2026 10:10:01 +0200
Message-Id: <20260831081005.41346-2-kmehltretter@gmail.com>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
In-Reply-To: <20260831081005.41346-1-kmehltretter@gmail.com>
References: <20260831081005.41346-1-kmehltretter@gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

vgic_register_redist_iodev() assigns a redistributor region and base
address to the vCPU before adding its iodev to the MMIO bus. However, the
region's free_index is advanced only after registration succeeds.

If kvm_io_bus_register_dev() fails, the vCPU retains the assignment while
free_index still identifies the same slot as free. A later registration can
therefore reuse a slot that remains assigned to the vCPU.

Reserve the slot before registering its iodev. The caller holds slots_lock,
so a registration failure cannot race with a later assignment. Undo the
reservation and clear the cached assignment on failure.

Fixes: dbd9733ab674 ("KVM: arm/arm64: Replace the single rdist region by a list")
Cc: stable@vger.kernel.org
Assisted-by: Codex:gpt-5.6-sol
Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
Reviewed-by: Fuad Tabba <fuad.tabba@linux.dev>
---
 arch/arm64/kvm/vgic/vgic-mmio-v3.c | 22 ++++++++++++++++++----
 1 file changed, 18 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/kvm/vgic/vgic-mmio-v3.c b/arch/arm64/kvm/vgic/vgic-mmio-v3.c
index 5913a20d8301..22897ce64dbf 100644
--- a/arch/arm64/kvm/vgic/vgic-mmio-v3.c
+++ b/arch/arm64/kvm/vgic/vgic-mmio-v3.c
@@ -766,6 +766,19 @@ unsigned int vgic_v3_init_dist_iodev(struct vgic_io_device *dev)
 	return SZ_64K;
 }
 
+static void vgic_undo_redist_assignment(struct kvm_vcpu *vcpu)
+{
+	struct vgic_cpu *vgic_cpu = &vcpu->arch.vgic_cpu;
+
+	lockdep_assert_held(&vcpu->kvm->slots_lock);
+
+	guard(mutex)(&vcpu->kvm->arch.config_lock);
+
+	vgic_cpu->rdreg->free_index--;
+	vgic_cpu->rdreg = NULL;
+	vgic_cpu->rd_iodev.base_addr = VGIC_ADDR_UNDEF;
+}
+
 /**
  * vgic_register_redist_iodev - register a single redist iodev
  * @vcpu:    The VCPU to which the redistributor belongs
@@ -818,16 +831,17 @@ int vgic_register_redist_iodev(struct kvm_vcpu *vcpu)
 	rd_dev->nr_regions = ARRAY_SIZE(vgic_v3_rd_registers);
 	rd_dev->redist_vcpu = vcpu;
 
+	/* Protected by slots_lock */
+	rdreg->free_index++;
+
 	mutex_unlock(&kvm->arch.config_lock);
 
 	ret = kvm_io_bus_register_dev(kvm, KVM_MMIO_BUS, rd_base,
 				      2 * SZ_64K, &rd_dev->dev);
 	if (ret)
-		return ret;
+		vgic_undo_redist_assignment(vcpu);
 
-	/* Protected by slots_lock */
-	rdreg->free_index++;
-	return 0;
+	return ret;
 
 out_unlock:
 	mutex_unlock(&kvm->arch.config_lock);

base-commit: cf72cbb39da84b6f02f90c07f33b102fc10b16f0
-- 
2.39.5 (Apple Git-154)
