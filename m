Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F1932441A1
	for <kvmarm@lists.linux.dev>; Mon, 10 Feb 2025 15:50:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739202605; cv=none; b=leu9XC5vKCwiTAph44vQWxT3P2IrsCA1szjANglw3v4VYCF6R5UbKFX/00PzH62JJAgFsUprKoURsRLel6XbZnQvPwTnkzPSZwrpPSB/+hARpfoTRP2WARv5Mnz3HXXv3CnUZcDapEcKWcqkKcUrtsx89B2OCW3KBNTRVT+pAuQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739202605; c=relaxed/simple;
	bh=JwX0FTJ7E53zMSff4xw/NDJGkvTh/vf9GUmKygpIM2k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:content-type; b=BBI/+cdQBmFdp7fMk90Wc9gBhtHKeFUc8CL7vLCnFpFIOv6d59gHiok8+6CRbbAvnPUbbiyXD9bWeOggnCN9XvsK32JKdoSTBw38ZpX+NO+VmDO7NPwGu2QTds+pU9DVt34HqjJqHoARPfLaHD3XehvNcxQ4+nbIahSl79IveQA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ZLPuOQFu; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ZLPuOQFu"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1739202603;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=BLF8Cf/xB+6V3hagRkehtOvA3nhCvcxfhJ41oAzlRW8=;
	b=ZLPuOQFun7vNbHcb92kiCUxiHUAV9kJ7AoDP1SvAY/3ra1BjvBzkaJ3dHvuAW81PQD11qa
	4dEFNNAZqC/b/9mwfoh8MWlw+PO/gb8WdPGMb4RP4fhjhvNZDYUSb0RrbP1viSXT1c9bOY
	nwjExcmKG/Zry+PB+fz6/E14zX0kim0=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-575-6PvneRxKNCes7C_pRYfEag-1; Mon, 10 Feb 2025 10:50:01 -0500
X-MC-Unique: 6PvneRxKNCes7C_pRYfEag-1
X-Mimecast-MFC-AGG-ID: 6PvneRxKNCes7C_pRYfEag
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-43945f32e2dso7753605e9.2
        for <kvmarm@lists.linux.dev>; Mon, 10 Feb 2025 07:50:01 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739202600; x=1739807400;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=BLF8Cf/xB+6V3hagRkehtOvA3nhCvcxfhJ41oAzlRW8=;
        b=E4IKjti7w5FRPeb+SYwqm17I+r78voVyg2cP3tjnTixAvwJPqEizp48lmz1B5watVZ
         ht6HDzELd2AOxJCRvAspxq0nzoZ9PJrh+gFV0K1hRdL4t2eF9WEe/ySgM1JAMIOJPwef
         Pv0blDVsGJkd1W+ne/ThwDB8JJUgiyVcJXii4kYtwjsXcKr5I7WFlTIJdmpdnNumFH8w
         +hM1DbHxiYgNuDsgVDmVPYl+xmfVWnrTVjZ/1156yePb87L0U+Wb3K3/IkaYQrn9X/90
         UrKKZI3xnmx81l/czEssDtnwZBp4+RZuLg50PqQ1hzw96rMzYIiPk875OcJZZVfuzqCU
         GpkA==
X-Forwarded-Encrypted: i=1; AJvYcCWdbFQj7SHeR4OJygvhgbf+2ZX1RPvaNVk90Etbx2l9ZF6xT4hOquSOQHKFC7ezHtLouX/f3lg=@lists.linux.dev
X-Gm-Message-State: AOJu0YxStlHJ+A/8GkWsAAu1i/o9o/gkFqfwlqabt47xA3hF4zWv9LTM
	1b3u3sSHAVQrQduIF2wlsVodfgS1kZ0X7wP6Ipxhhx/JLYkmnqwvZ5QLIHaDkslbkvgJUfg2jvA
	pVtTrecZbLTgjeEGjkFX8+hgkl9kwN3SUUtaw6/xQCEQFA6v9to61xg==
X-Gm-Gg: ASbGncs3GMZAdLCCFuGXgtxI0Z+GBNNQjeKIwU7e10ZmG4ZeNNlsRh0dcJePX2zXNZ8
	WkBXikzGLkuqB/zRVuL1Q8oeAsHcYfNl3b0nwZYziQQybEpq0m8767xdnpAG3eR+ts+aKe7hrvy
	lP3ResF7BY/dP/H48VP5dvASRg81NTVfmRpfqyn90fRbRqpLueCsxgxBudDaRRqe9tcOgiknrFJ
	+D7gWHxLiFbn3Ai9Y1naz4CAuwoSNK4kV6sa6jnmHiO72A9Hmdz/RSHA8d2xVbwuPpFb8qd4I1N
	CDsBMhcoZmkTSNMwJyiSYvKJH1YrComOekoqMYoMgrzj57tMMMOM4qT4Zb9GXqY2wic=
X-Received: by 2002:a05:600c:3d06:b0:436:2238:97f6 with SMTP id 5b1f17b1804b1-4392f1b8e78mr67201645e9.1.1739202600503;
        Mon, 10 Feb 2025 07:50:00 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHO3zxKwhpNf5G9RIMWhyWsZJwinpmx8lRLWXcdVcXxH5R1Bp8BJUV0bb9Jd4M71qBY3iU3wQ==
X-Received: by 2002:a05:600c:3d06:b0:436:2238:97f6 with SMTP id 5b1f17b1804b1-4392f1b8e78mr67201305e9.1.1739202600117;
        Mon, 10 Feb 2025 07:50:00 -0800 (PST)
Received: from rh.fritz.box (p200300f6af0e4d00dda53016e366575f.dip0.t-ipconnect.de. [2003:f6:af0e:4d00:dda5:3016:e366:575f])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4391da96502sm153559395e9.1.2025.02.10.07.49.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Feb 2025 07:49:59 -0800 (PST)
From: Sebastian Ott <sebott@redhat.com>
To: Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
Cc: Cornelia Huck <cohuck@redhat.com>,
	Eric Auger <eric.auger@redhat.com>,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH 4/4] KVM: arm64: trap guest access for REVIDR_EL1 and AIDR_EL1
Date: Mon, 10 Feb 2025 16:49:53 +0100
Message-ID: <20250210154953.27002-5-sebott@redhat.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250210154953.27002-1-sebott@redhat.com>
References: <20250210154953.27002-1-sebott@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: lH6p06FagNgSmT3sv1cP0SwpAsPO0PjxZMUOhAEBskI_1739202600
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

Setup a trap for guest access of REVIDR_EL1 and AIDR_EL1 when
the VMs value differs from hardware.

Signed-off-by: Sebastian Ott <sebott@redhat.com>
---
 arch/arm64/kvm/sys_regs.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 7d588fedb50a..2918872e3d2a 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -4910,6 +4910,10 @@ static void vcpu_set_hcr(struct kvm_vcpu *vcpu)
 	else
 		vcpu->arch.hcr_el2 |= HCR_TID2;
 
+	if ((kvm_read_vm_id_reg(kvm, SYS_REVIDR_EL1) != read_sysreg(REVIDR_EL1)) ||
+	    (kvm_read_vm_id_reg(kvm, SYS_AIDR_EL1) != read_sysreg(AIDR_EL1)))
+		vcpu->arch.hcr_el2 |= HCR_TID1;
+
 	if (vcpu_el1_is_32bit(vcpu))
 		vcpu->arch.hcr_el2 &= ~HCR_RW;
 
-- 
2.42.0

