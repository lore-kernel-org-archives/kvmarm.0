Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.41
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795015797;
	b=PY4hjnrpes7AYmCCN5XKuJP6O4iSUU4h3mUyJrwxaEFxI53cJSgqtwgtbUjSkv3X/Tf2
	 +Q8D2KFZW9iB9RxCDQVFGoMn5EsvivqsdcMbW2GC3ne0sOYhOUpvm7Y7gagBosxpXlOrJ
	 wU1tLcc6DrYLvF7uJQtGu7u1ULrXwYN8P2tQ0lGA6LhQv7bey7cbKhFrp+WvyYacCleKM
	 0d+IKolyZk2OA2TDYkvMZZKDmGmJL9fHIbG/683yE74JkGgj5ypXkSkZbYO81p3msBDUq
	 M8+XeGxpT2XCbPX1K2bUg9gPuc8T1gPAtdsJPxeTHExF0fKGaNnkcmQ5jG3Cs1BTjbg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795015797;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To;
	bh=ocgERdCX40/QdZP3bdVNa/cddm/zWvOFkBxBwp4HIFM=;
	b=ucFk4nXYUfFCFtd2s08D3+An4qVKgXVEFpDxWUMpXbnv9aB720AX9k6B9dEkKzsbwbgP
	 9x87GFxVUULgJxIfVxxtKs2Z0Dufyo6fzaa++ywZxvsf6t5coeeEHEQKp47Jjf48Wr1iI
	 13IZ8Omwh4nIgsi/wydzwDXLK449cgpo+Qc6zSUMKoE5dtuPOKDfcOZUJLg5g3i5xuhsx
	 g8UdtL/NssmtV142umiS5zwXr3ogWjmwKgiEhGYlu0NDdX+FLPJ0wXcKZSw+5uFUFgzgT
	 HE8zKGgiUEE+JqSu4EZ4QoAioLMhwWyAQOct/PMtYdX4pblOQFXQEtbfjQs2DZUyJjQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=pereq.eu;
	spf=pass smtp.mailfrom=cryspen.com;
	dkim=pass header.d=pereq.eu header.i=@pereq.eu header.a=rsa-sha256 header.s=google header.b=TDoHJfdb;
	arc=none smtp.remote-ip=209.85.128.41
Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD59F606A320
	for <kvmarm@lists.linux.dev>; Wed, 18 Nov 2026 15:29:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org BD59F606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=pereq.eu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cryspen.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=pereq.eu header.i=@pereq.eu header.a=rsa-sha256 header.s=google header.b=TDoHJfdb
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-4bb5b8ef642so9234765e9.1
        for <kvmarm@lists.linux.dev>; Wed, 18 Nov 2026 07:29:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pereq.eu; s=google; t=1795015795; x=1795620595; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=ocgERdCX40/QdZP3bdVNa/cddm/zWvOFkBxBwp4HIFM=;
        b=TDoHJfdbBmh/RDlNT9AWjTXvF6204IhYXmLNnJbAtXka0Ys9hS3swxtqBaYeT1aQj8
         3GXq7qC11vcPG8qw7338dV3pBE2cU28bM5D5E+ow1T2QreEdR+7XpCYQCIClpZb6XRyE
         17FRfjAygqTbIQcWBnui3K5WojWvbL1CHXiSlQM9wIvkRPwlaVv+/yeZeLFy4yrg62oJ
         WnGIPknagCryt2c8wICY/Om663fUtUQj2Tr0Fm1s5IVj4o9Hi3qCbsf9pu+we3zkmkji
         vxHbCyh4A04wnHt21vVj3Ef9J0tJXjde7eAGaMnB2u/EWpxccXhEa6oIzas6gKRhbmMy
         muEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795015795; x=1795620595;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ocgERdCX40/QdZP3bdVNa/cddm/zWvOFkBxBwp4HIFM=;
        b=oXGDFT1qM8xTKK6m5MJlmZ4FCE9bFXvMrkRDlI0HmvfErFwImrSKJv6rGzmWxmI2E2
         F21i9+7kBCQotZ88a6Hcns07vvPj0VZy2fUkzZaXp/6sfWiXT0XMyT6t4qRwvX6qydVy
         PyrQJ1FGF4vzsmCb5zpEaejAGtKcdZv6cnXzMExDYUE5rgy3ZWUQWZZbQX4c9vyR4XdA
         kwaR+tbkYqZ/6Vr53Z8x5L5wjawkJa6+9XMBirJO95c6jprULpm9XOzw0DY/D4LyJQHB
         Nq8ql4gJBXPMT428Ssd5ubLIsI0uDIgGdzIr5GkPVS8qxh+Gtu9My4nKh8Xi8nRY1mNJ
         SjPA==
X-Forwarded-Encrypted: i=1; AL+hErGk74CEi65ew6La4K2oRCXpkwijQSVhuK8lRIVSQGYIFcaZGFYHKkh+mLHUvpRnYxLu4hvTMM8=@lists.linux.dev
X-Gm-Message-State: APuU4Z+ZtDs0EyqY6l/LjHRQoQfeikGuGBgWDaGIV6wsQaLfLvQg/Ab0
	crSgAMQ54WmSG3158LdApowiav6Si1Okg8ljOTck6vONGFr7v4dknxyMyVXhCb+KzEY=
X-Gm-Gg: AYBFou2EPZ5k/J8L7ZBR0C1V1AIfkSnsepvWZJIr7D7PmQRMRQh+9aGO0YdI4Af68gI
	LMh460zK5VUGIgqqIlvqCCcbcTRO2lQMG2VyjUoN3V/YNnnndarGSQdSO0ScMAEILy5wcIEy4pt
	H9q/NZjL5jI3oZjFwk6EabfZkef7QDpQhAbF6itFeiXB80dspg57Gml5RfJUpKnLOdqVPykDjPl
	P1ZghcdBWq9IElZIxBmOa5fsBOl2nkD6isAMKV5XGflCtOhhAYau+c9R0AFUa0m3Vuf8dMvLig1
	jQAQX1X/zGElWWFcj0qN9uTJDiWrSx5c3OMtJNlQgVtta3Owyzgr9ysiE6f0DCpyf/sFdWHmI9f
	06rmIfGpm3SU2iFAErQg8LCKAnKvv+b/I9eUjqIxFRItv6LWEkIuV3xk/uoWl6hCl4JXwftzAzp
	kVGz+YExmmOAAqh4pu7PCr7DVjsiPoBs4Die+JQiY1WYrIKnUwKJqaPIu5M2QdCUINhrTaEop9Q
	GtnF5/ih2BtapvYlDXcGFC0HkYWw9fYIqSHWN8foK7ZhHxv6Msrpu38NIT9LLo3rxoeBCQU8VcQ
	U1AFXqq9MElP4A1UJ7mACZ8jNILLHWeGQEmZKAzO
X-Received: by 2002:a05:600c:4e04:b0:4a1:fc98:1cb1 with SMTP id 5b1f17b1804b1-4bb7d5d4113mr52050185e9.2.1795015795013;
        Wed, 18 Nov 2026 07:29:55 -0800 (PST)
Received: from localhost ([2c0f:3d00:6be:8900:ce5e:9212:ea4b:f30])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb7d2c3c93sm106797465e9.13.2026.11.18.07.29.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Nov 2026 07:29:54 -0800 (PST)
Date: Wed, 18 Nov 2026 18:29:51 +0300
From: Dan Carpenter <dan@pereq.eu>
To: Marc Zyngier <maz@kernel.org>
Cc: Oliver Upton <oupton@kernel.org>, Fuad Tabba <fuad.tabba@linux.dev>,
	Joey Gouly <joey.gouly@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	Karthik Bhargavan <karthik@pereq.eu>,
	=?iso-8859-1?Q?Cl=E9ment?= Blaudeau <clement@cryspen.com>
Subject: [PATCH 1/3] KVM: arm64: nv: Forward PIR_EL2, PIRE0_EL2 and POR_EL2
 traps
Message-ID: <79097fe98499631673fd536ef2f1b8cfc92b979d.1795014776.git.dan@pereq.eu>
References: <cover.1795014776.git.dan@pereq.eu>
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1795014776.git.dan@pereq.eu>

These registers were added to KVM, but not to the encoding_to_cgt[]
table which decides when a trap is forwarded to a nested hypervisor.

The result is that if an L1 hypervisor runs its L2 with HCR_EL2.NV set
(meaning the L2 is itself a hypervisor), and the L2 accesses these
registers, KVM handles the access itself and it goes to the L1's own
registers instead of being emulated on L1.  This is quite a serious bug
because it lets the L2 change the permissions of the L1's own stage 1
translations.  It could mark everything as no-access and cause a crash
in L1 or mark everything as read-write-execute which weakens the
protections in L1.

Add the three registers with CGT_HCR_NV, MAIR_EL2 and AMAIR_EL2.

Fixes: 874ae1d48e60 ("KVM: arm64: Handle PIR{,E0}_EL2 traps")
Fixes: 5970e9903f03 ("KVM: arm64: Add basic support for POR_EL2")
Cc: stable@vger.kernel.org
Signed-off-by: Dan Carpenter <dan@pereq.eu>
---
 arch/arm64/kvm/emulate-nested.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/arm64/kvm/emulate-nested.c b/arch/arm64/kvm/emulate-nested.c
index 2bec81668361..bf4b8a44b9c4 100644
--- a/arch/arm64/kvm/emulate-nested.c
+++ b/arch/arm64/kvm/emulate-nested.c
@@ -889,6 +889,9 @@ static const struct encoding_to_trap_config encoding_to_cgt[] __initconst = {
 	SR_TRAP(SYS_PMSCR_EL2,		CGT_HCR_NV),
 	SR_TRAP(SYS_MAIR_EL2,		CGT_HCR_NV),
 	SR_TRAP(SYS_AMAIR_EL2,		CGT_HCR_NV),
+	SR_TRAP(SYS_PIR_EL2,		CGT_HCR_NV),
+	SR_TRAP(SYS_PIRE0_EL2,		CGT_HCR_NV),
+	SR_TRAP(SYS_POR_EL2,		CGT_HCR_NV),
 	SR_TRAP(SYS_MPAMHCR_EL2,	CGT_HCR_NV),
 	SR_TRAP(SYS_MPAMVPMV_EL2,	CGT_HCR_NV),
 	SR_TRAP(SYS_MPAM2_EL2,		CGT_HCR_NV),
-- 
2.53.0

