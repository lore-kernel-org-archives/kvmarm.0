Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACD10346E40
	for <kvmarm@lists.linux.dev>; Sat,  6 Jun 2026 17:57:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780768638; cv=none; b=uqrC58KOcZn4RE8TLYlEWVTpCs1tmlYrJKGw8n/EM8/gQLMmXq+FKP5MRyEzsZcRra5JBw8Pa5LOh2XOQ16FcN7RukG3C8Nrcq7uyf0qPczWxQrqrZ7nRHtzv/UoJB475Ip4g07LxGiwzOyflYLjoLXjCS7fx2K8N09a0YoahNA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780768638; c=relaxed/simple;
	bh=6fmYE5D4pZ1hMhe2KPEF9CIGn+2+DUUFbJBJNxmOlNg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sLCQFRCcBwxlth3FbPu2wJObaWmiRVUOb8eMw+JQfd10jY3Zsft9aEdItTCPTn3Uhfj/cYja8tkzpLo1+x7ru8ZBtunCR0qqTeOqw9+CUlrX3WorFMk4BnVzTGKotEcZNwMwEvJ7PhjnnE6ZhKWVznziW+UHEK1Q9dEkktWtAWw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=QD0WMjGr; arc=none smtp.client-ip=209.85.214.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QD0WMjGr"
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-2bf18c30bb2so20263755ad.0
        for <kvmarm@lists.linux.dev>; Sat, 06 Jun 2026 10:57:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780768637; x=1781373437; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DtrLaj5ltFoAG/++WffsPSgWGaLrPwS8Itqpcy4i6xY=;
        b=QD0WMjGrIhHfnELQCdtdIPCcbCu3Qbi3U/qFFzreuE7gba9ei+uUzzWjoSG/P0Ln3+
         3RXT+d5He4+jDtQFCs0kO6Wx1KLd7BhX0ApcK9rVhUR0FAcQ9szEhVPd0iRTgerYs65u
         dRpH1WoolEwur9FPaf7gEIW1HM+1ZWpIo2P6/moNpOSGevNHmSYSTS99QrEln/5MiN9C
         q+WvnKgS47OwJXmzrOwacFTIMrEkCu1h9YrX0hDo+vRWGcCjy8R6VtaFb14yDjzm4B5Q
         wCUhAaEAaVhLVaumvPm6d3a52pzw4OutZq8FRb6W/g9e+aHxxNVzs262m9KiPEEIUHCz
         hwHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780768637; x=1781373437;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=DtrLaj5ltFoAG/++WffsPSgWGaLrPwS8Itqpcy4i6xY=;
        b=jZCYhC2MHNRra1hJ5peis12NiAES6qnqmMCwoqZxUDeCRf9hc3eg0YixzH9mFunyB8
         GAjtBsMni/yhevG1ZsfMGxkWhGcO0HRPq0a0Dhb/JL9oScd47douItccPaWWINnOvJPm
         3zP7vJF53yv+nGGo32VCXjfT8q04tcuQYuvqgQnwIu5TUx40+qwQodmWYY8683DBW5mh
         fgv0tn2vvi2tmBcThHam1KA4THBHvefYRy3zLaP63NlqDqYYSOt2JkznZA+7MjA7ceWW
         JPatNe/tGKkGn+JVNTecVmHtG4vJy7MZhAd4Tj/aL4haBwUHUTefxAyW/SI/Ty+jwOcf
         zZJw==
X-Forwarded-Encrypted: i=1; AFNElJ9kQ80lyTF6EQ+MDW6O1WlzkI/3T19zSsNUTcnTleUcr8IhtyeiU2p5bXZgAImDOXzKmPIQd74=@lists.linux.dev
X-Gm-Message-State: AOJu0YyGBZjoyQNbrz6g6/4gi3yQhMFG4Qgln8pXUMjJp+mAX44SM76I
	QUIuyPSeH58qIIL61J5tYK+OrPsukZ96VVIMaU4dwPgjbYs0+wX8ihgl
X-Gm-Gg: Acq92OFBV8lsVmVRoSjwqtOwjQns6nZvWg8fWn2rkroA+m5ZghxvqJxqZfN3LJ8ooJp
	1M+xQPkLg4hJZRIvPteBF4ZwgKZRxTDy/PN7Krutu/HajPffvUsxsprNH32Uqk/6OHxjmzsD23Z
	oDQpFaZ+Uo6teK1xkPc4q4FILEA19h8P27Se0bLa9U8+pcU3732oPtNjX74xBxugJxxkwn+xzbX
	k3P4joLeXr3Ke8HE4tC19ZTPVGxy0rCqJ8SDajGeQeH+tsFcpY1+LWIHLJdS2IdJKPNQyMz3Q7g
	Wkcc7tmmygfoXrDjroC7uJbJCSCTQKaG1R6IHlFOG+p5wYGcP9MsftM3Plgh77ELzfX2rgt4VFH
	QN5h4o0iULEQ3o5fXTJOWycDpM1YyfVuuKcn1L/87pUKnXRhJdaMxEaA8ExBqddCyfpVSa1TPbo
	IBz4du7UE9i7QR6AwEfn9PJR25y24AeqrI6nXH051V3HJT5ZbNimtKxyI7
X-Received: by 2002:a17:902:c952:b0:2c0:fa4e:91ed with SMTP id d9443c01a7336-2c1e834699fmr108804645ad.18.1780768636898;
        Sat, 06 Jun 2026 10:57:16 -0700 (PDT)
Received: from v4bel.. ([58.123.110.97])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2c164f6d69csm129196425ad.2.2026.06.06.10.57.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 06 Jun 2026 10:57:16 -0700 (PDT)
From: Hyunwoo Kim <imv4bel@gmail.com>
To: tabba@google.com,
	maz@kernel.org,
	oupton@kernel.org,
	joey.gouly@arm.com,
	seiden@linux.ibm.com,
	suzuki.poulose@arm.com,
	yuzenghui@huawei.com,
	catalin.marinas@arm.com,
	will@kernel.org
Cc: linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	stable@vger.kernel.org,
	imv4bel@gmail.com
Subject: [PATCH v3 1/2] KVM: arm64: Clear __hyp_running_vcpu when flushing the pKVM hyp vCPU
Date: Sun,  7 Jun 2026 02:56:10 +0900
Message-ID: <20260606175614.83273-2-imv4bel@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260606175614.83273-1-imv4bel@gmail.com>
References: <20260606175614.83273-1-imv4bel@gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

flush_hyp_vcpu() copies the host vCPU context into the hyp's private
vCPU on every run. ctxt_to_vcpu() expects a guest context to have a
NULL __hyp_running_vcpu, which is only ever set on the host context, so
that it resolves the vCPU via container_of(). While this is generally
the case, flush_hyp_vcpu() copies the context verbatim and does not
enforce this, so a value provided by the host is dereferenced at EL2
(host -> EL2).

Fix by clearing __hyp_running_vcpu after the copy.

Cc: stable@vger.kernel.org
Fixes: be66e67f1750 ("KVM: arm64: Use the pKVM hyp vCPU structure in handle___kvm_vcpu_run()")
Signed-off-by: Hyunwoo Kim <imv4bel@gmail.com>
---
 arch/arm64/kvm/hyp/nvhe/hyp-main.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
index 06db299c37a8..02c5d6e5abcb 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
@@ -128,6 +128,9 @@ static void flush_hyp_vcpu(struct pkvm_hyp_vcpu *hyp_vcpu)
 
 	hyp_vcpu->vcpu.arch.ctxt	= host_vcpu->arch.ctxt;
 
+	/* __hyp_running_vcpu must be NULL in a guest context. */
+	hyp_vcpu->vcpu.arch.ctxt.__hyp_running_vcpu = NULL;
+
 	hyp_vcpu->vcpu.arch.mdcr_el2	= host_vcpu->arch.mdcr_el2;
 	hyp_vcpu->vcpu.arch.hcr_el2 &= ~(HCR_TWI | HCR_TWE);
 	hyp_vcpu->vcpu.arch.hcr_el2 |= READ_ONCE(host_vcpu->arch.hcr_el2) &
-- 
2.43.0

