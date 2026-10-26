Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.72
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793032794;
	b=jnfyFdkA21IO9gmqlC/vN8a8v7g/a8nSx26X2c9NWl8WxvV/Ej2CZOG+5HMxe5wcCoek
	 b7cmH9uOmc0o7XJZ78ynYnSCcLrDCKbB5QwFEp3VUhV8n6SsxlVdbyGryRcVdOYbUqkIl
	 BQS0dUbZdC4iM1byYomIK/nNJMRz3dthdkpkiobIcYz9lguZqkeLoIMndn0rKGBZGfNUf
	 lphpzdq3QVCkeNvqwWnjMRi/GMYuXxnNE0wgdfX4GZ9rYuGuAiQHUC8OZzwKLRzRIr5GO
	 Nh7soY9dmqzEQe1oIriSu+ynKsm5F4emWyDOu85vlvSkFnvBlJoCpR51274TXPhY8oA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793032794;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Received:Date:In-Reply-To:
	 Mime-Version:References:X-Mailer:Message-ID:Subject:From:To:Cc:
	 Content-Type;
	bh=OXDmnK4c79f+FW2pDf6xtmzKTKKXsR1KPBjgvsrCMSU=;
	b=Yxpq1Wr9yxlglKkYfKV6baU7iJpTWkhHlbx47zQyMql8+3w4gBTQbo0kYVFhnVr/YDw0
	 kp3X6VHcqmncm3KujTdMHQv6ZI2AE1nDAwzTX2r7Fkg02N0HmfCsEAS09V5c7pg739w1r
	 6SP4Bg3Vj21MnqcV3CA4S1lRE+IW11JOFXtSUDfVjxHZXiaf4hXlno1RhBxmJq0WFH/Jk
	 EAAvAQaAsvQVgqLkDQ67fHYW6nV/pVEBjWjDFFB1tV3768gxGfCkoEN1/Wc2oqKdqgi4c
	 PgjqfpkEh1MEfUHIFJeTQfk6zzCG9pKVyk+tccftz0jI3+kGbH9Yk59C0maAJtN02RQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b=lBndTYZi;
	arc=none smtp.remote-ip=209.85.128.72
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com [209.85.128.72])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE055606A326
	for <kvmarm@lists.linux.dev>; Mon, 26 Oct 2026 16:39:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org BE055606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b=lBndTYZi
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-49953abe51fso24956535e9.1
        for <kvmarm@lists.linux.dev>; Mon, 26 Oct 2026 09:39:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1793032792; x=1793637592; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=OXDmnK4c79f+FW2pDf6xtmzKTKKXsR1KPBjgvsrCMSU=;
        b=lBndTYZisbJsESBT+ZueNLxx2sTFtqcg4tAhJQUNUz9BruLS49So9tKMgn+R1Uk9pc
         ehZyy1FIK3tTkk5Z8sdBIB60nmxAu58AiekiDMPbSonLgShrd0LMWVxWN116KnV373JB
         94kWhtSOvivK9nYd5AlJo8hoK/sKOA8jj4u1f4ygIoM31c7MFFViWJoUr5/pslpb1Fhu
         xCvrslDG6LBpb1vjQUPjbeSQ0Du+njxOfM/of46RzJzMLdYhGi5FK95j0f6HzC8uyoC5
         lACLOc2lbc9f9gC4ervmteOIVdYMGtjmlZZD/3jzK1nDSoArjFerIQlBO8OtiLreq2co
         O96Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793032792; x=1793637592;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=OXDmnK4c79f+FW2pDf6xtmzKTKKXsR1KPBjgvsrCMSU=;
        b=UujBOYk21xpmamIOCOFs9W8HQ2zS8ls0VzerwMGSoYtuoruaTUxAIT64TPCXXm/cEJ
         KL2oUXGZx8gdSiavachC0BQ4bDj7wGSbkx+vXpXXrgnWOUZQMfRKNweETGrdniX6O4jJ
         WwYv6D+MquiQ9XxKV+lqNFx/c5s9oC3N3T92GC97FlgpprJY8mLupIprlbWKb4aEOGDP
         XwUEk7YH4emGBiFCJBl8KyDYwsUfG6bvgx/bqmrbYMltmV5T0lAsrwNlVp9C8H3LwnSK
         TccDIuT2+ZYiEvYDzAKu4PIlK6wnXmkHBkCXSSOnYlKqoRAGdR4GmEnBsZ+f7bgo3zUQ
         dndA==
X-Forwarded-Encrypted: i=1; AKwUvBzqevSLQqDrFgD1cNYU2flnfgaUafBcjilSg8Gcpqezq8QARPiz/riE0kzNdM0pBXiIiP8dZMA=@lists.linux.dev
X-Gm-Message-State: AFq9FYJlo1je8veNM0WWVU23pPJv+H7Hcvn3jSCzA7ZAvFB3aqBThXGo
	AdBJQKj023xr96ELmDh7nK8WhcmjiaTRDj47ql+3QVpRwVBbJFRw+YCsjMeQaa3xnqORTLtFm2x
	I1Ut22UGNPE4fO22mLTNs1g==
X-Received: from wmsm36.prod.google.com ([2002:a05:600c:3b24:b0:4a1:ae53:2fe9])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:314f:b0:4a7:76fa:87e9 with SMTP id 5b1f17b1804b1-4a776fa87f9mr20820985e9.21.1793032791927;
 Mon, 26 Oct 2026 09:39:51 -0700 (PDT)
Date: Mon, 26 Oct 2026 16:39:37 +0000
In-Reply-To: <20261026163937.963087-1-vdonnefort@google.com>
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
Mime-Version: 1.0
References: <20261026163937.963087-1-vdonnefort@google.com>
X-Mailer: git-send-email 2.56.0.257.gf7497c7d27-goog
Message-ID: <20261026163937.963087-4-vdonnefort@google.com>
Subject: [PATCH v3 3/3] KVM: arm64: pkvm: Reset GICv3 LRs in the hypervisor
From: Vincent Donnefort <vdonnefort@google.com>
To: maz@kernel.org, oupton@kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org
Cc: joey.gouly@arm.com, seiden@linux.ibm.com, suzuki.poulose@arm.com, 
	yuzenghui@huawei.com, catalin.marinas@arm.com, will@kernel.org, 
	kernel-team@android.com, fuad.tabba@linux.dev, 
	Vincent Donnefort <vdonnefort@google.com>
Content-Type: text/plain; charset="UTF-8"

After the host is deprivileged, pKVM can't trust the host for resetting
the vGIC LRs whose value is architecturally UNKNOWN when the CPU boots
or resumes. Add a blanket cover in the CPU_ON/CPU_SUSPEND path.

Fixes: 1025c8c0c6ac ("KVM: arm64: Wrap the host with a stage 2")
Tested-by: Fuad Tabba <fuad.tabba@linux.dev>
Reviewed-by: Fuad Tabba <fuad.tabba@linux.dev>
Signed-off-by: Vincent Donnefort <vdonnefort@google.com>
---
 arch/arm64/kvm/hyp/nvhe/psci-relay.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/arm64/kvm/hyp/nvhe/psci-relay.c b/arch/arm64/kvm/hyp/nvhe/psci-relay.c
index e20db999e328..2863b4b90ea8 100644
--- a/arch/arm64/kvm/hyp/nvhe/psci-relay.c
+++ b/arch/arm64/kvm/hyp/nvhe/psci-relay.c
@@ -213,6 +213,10 @@ static void __noreturn __kvm_host_psci_cpu_entry(unsigned long pc, unsigned long
 	write_sysreg_el1(INIT_SCTLR_EL1_MMU_OFF, SYS_SCTLR);
 	write_sysreg(INIT_PSTATE_EL1, SPSR_EL2);
 
+	/* We can't trust the host to reset the LRs */
+	if (hyp_gicv3_nr_lr)
+		__vgic_v3_init_lrs();
+
 	trace_hyp_exit(host_ctxt, HYP_REASON_PSCI);
 	__host_enter(host_ctxt);
 }
-- 
2.56.0.257.gf7497c7d27-goog

