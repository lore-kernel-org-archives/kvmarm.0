Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.218.175.221
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793088716;
	b=XZfsMxmO0eWawHRernaI7knA1UCLK20h13wEnwnOM1iw4YLQHAED/AITiihPtK3V8jTB
	 YGNwjbjTE9D644+NvpQ1ePP/TZYq62K2jOjqVrudA6h1bv+/jQqyFCRDezgYRTjw2iUoa
	 5G+r8DgFeJ8Qy7MZogwtOtuw8ASuAGFqKTIr3ad5g/luPTxx05A3KaSRLHLmXObupXqBS
	 1jD2dvguTF7fSxH7kvb8wZrUlg8iKFsVHd0cvI0kUB8faok1kvLwglhFtvRmk+aWGcqjr
	 6O+zV1TXzUTTZLg1L66HFzi6eNXOvPy7HVR664SFJuoWPaJTrEhAEIiXQSlJNK21eJQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793088716;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=/dqcNV2rxcj+H+N6V1Q7pF0i14uOvWt3XmYVtpF0Vwo=;
	b=kMufXX5TB4mMWQ/tJD501m+UiNWCtJYkoO/OFaCqVu0+FBJqX/49UMQs77ZRN5L0pTbl
	 D+l5ij8eVqaJNoAG7HANPbMqynDvJsJmBma8t0LkEy5VENAmph6ejAExcD3eEsdkGYcRu
	 N4lZgsvCt2oX4Oy9aG/swWKvPp8i4522gQz2c180SVrwSmadBPJ7bGM6sYItxLM6mmrHU
	 ANxz4VgPBQkImPScbwZ0WUEokNmzyb+5gfW3RxhhRRsnB5wjPE8HAg+MXACOurvoA5ozl
	 Rjbt4tbt4xctJrBwcvd6TrOfvJfYJvl4A8nHGhugt8vU01mg1cUTNHPa0B3YuWigBww==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=DO30WsaM;
	arc=none smtp.remote-ip=91.218.175.221
Received: from mta0.migadu.com (out-221.mta0.migadu.com [91.218.175.221])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FFE7606A31F
	for <kvmarm@lists.linux.dev>; Tue, 27 Oct 2026 08:11:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9FFE7606A31F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=DO30WsaM
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=hOfLyCvPxdoMK3iGT2snLIRtrBmcqixK3sf0MGFjqIg=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793088713; v=1; x=1793693513;
 b=DO30WsaMONIhhJJccnNUyYpn4khrV8ieI51OrfrEkW/HFHx28z2V7fLZzG2F2d6r744ClNSn
 Mm7KG7Mev4TjbTFsh5dQRFd1uaLFAR6rVvWt6gIIMwK4Sc+ykyExsSKIjLm14EIxz+uuiP/GlFy
 90ePGutgRkqRnnEsWKJGUY44=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id da38054059dc04e0;
	Tue, 27 Oct 2026 08:11:53 +0000
X-Mizu-Trace-ID: da38054059dc04e0
X-Migadu-Flow: FLOW_OUT
From: Fuad Tabba <fuad.tabba@linux.dev>
To: Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>,
	kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Vincent Donnefort <vdonnefort@google.com>,
	kernel-team@android.com,
	linux-kernel@vger.kernel.org,
	Oculytic <oculytic@gmail.com>,
	Fuad Tabba <tabba@google.com>
Subject: [PATCH 1/3] KVM: arm64: Synchronise kvm_host_data before host deprivileging
Date: Tue, 27 Oct 2026 08:11:45 +0000
Message-ID: <20261027081147.498183-2-fuad.tabba@linux.dev>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261027081147.498183-1-fuad.tabba@linux.dev>
References: <20261027081147.498183-1-fuad.tabba@linux.dev>
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

From: Vincent Donnefort <vdonnefort@google.com>

When protected mode is enabled, the host is populating and reading the
hypervisor copy of kvm_host_data until it is deprivileged. This is an
issue for nr_event_counters which is only used by the host to populate
mdcr_el2. After deprivileging, it is reading an uninitialised value and
sets HPMN to 0, preventing programmable event counters from counting a
non-protected guest.

Before the host is entirely deprivileged, copy the entire kvm_host_data
content from the hypervisor copy to the host-accessible one.

Fixes: 2417218f2f23 ("KVM: arm64: Get rid of __kvm_get_mdcr_el2() and related warts")
Signed-off-by: Vincent Donnefort <vdonnefort@google.com>
Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>
---
 arch/arm64/kvm/pkvm.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/arm64/kvm/pkvm.c b/arch/arm64/kvm/pkvm.c
index 380dfb1db0be4..58190ff6723d6 100644
--- a/arch/arm64/kvm/pkvm.c
+++ b/arch/arm64/kvm/pkvm.c
@@ -316,6 +316,12 @@ static void __init _kvm_host_prot_finalize(void *arg)
 {
 	int *err = arg;
 
+	/*
+	 * After __pkvm_prot_finalize, access to the hypervisor copy of
+	 * kvm_host_data is lost. Save it into the host-accessible version.
+	 */
+	*this_cpu_ptr(&kvm_host_data) = *this_cpu_ptr_nvhe_sym(kvm_host_data);
+
 	if (WARN_ON(kvm_call_hyp_nvhe(__pkvm_prot_finalize)))
 		WRITE_ONCE(*err, -EINVAL);
 }
-- 
2.47.3

