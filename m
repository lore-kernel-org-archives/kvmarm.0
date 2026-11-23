Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.208.54
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795429838;
	b=jl7oZ647xthVUsi4dJazf9j4h/xQpGS0+PZO+sy6xI7qFPf8q4OenmI1gX1hhLt5Fbl/
	 y20g74m1FGzLmakUh0uuK07vu4yYme958O5YxFq5W9tiFDMsn9edu6yPX0jkkwA8aQams
	 xynHCzC4wjyRPncGn1YkIoMEISUOA87+iFAHgmsmx5gX4XubqaO43bfXuEG5rS5ksr966
	 7XkPeSdVFv40ZJ1cOZ1Syf5s/ljn7GxZpX1l8CxErBf7d0BqwJ/HO89blXaSL8OLeiK+D
	 BtWEcjAE1lMAXz1b9gygsaXx4uP2w+/DYz9yx/fOALUS9nEkv69BeaoUeBqFiE2i7NQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795429838;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:Date:Subject:MIME-Version:Content-Type:Content-Transfer-Encoding:
	 Message-Id:X-B4-Tracking:X-Change-ID:To:Cc:X-Mailer;
	bh=1xhgl5syMRg8qmPTHhAybLDTRj/xX0FiPUcwE+TXMJQ=;
	b=dXxExlNqLZaK9ZN5AhXd8yQtVBNt3zjSdsr4AKtrKmwhQ7WkO+BhfEyTbKkHC1f/iA+e
	 OkvXxo1+rrhMMzLG9KQOrzb5pZqEZ342TuqOTmOEUByLsF6wUFIhTjtJU7AajBKzDhpZO
	 EKgDrt2j18lFfOenSC7EI9ZEl/2KNzHomNKXSLRhYhHtmu0HWehBipCLzwGyq2DJzEZ1/
	 98hudKwpu2CC0APQoTUnRaZoJGVphVFPzmfJle8u2WdNT6TJHHquCkrQUx6nOWv9gmODi
	 TsyAMpeJ8kM8eyoYrjvOLC8TGWiK0lFO0q9uXFmZ7D2bmKFDMhpU0adR8/OdkdhuUZw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=pereq.eu;
	spf=pass smtp.mailfrom=cryspen.com;
	dkim=pass header.d=pereq.eu header.i=@pereq.eu header.a=rsa-sha256 header.s=google header.b=BrjF9aEE;
	arc=none smtp.remote-ip=209.85.208.54
Received: from mail-ed1-f54.google.com (mail-ed1-f54.google.com [209.85.208.54])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F21E2606A31A
	for <kvmarm@lists.linux.dev>; Mon, 23 Nov 2026 10:30:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org F21E2606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=pereq.eu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cryspen.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=pereq.eu header.i=@pereq.eu header.a=rsa-sha256 header.s=google header.b=BrjF9aEE
Received: by mail-ed1-f54.google.com with SMTP id 4fb4d7f45d1cf-6b87408c797so3877242a12.1
        for <kvmarm@lists.linux.dev>; Mon, 23 Nov 2026 02:30:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pereq.eu; s=google; t=1795429836; x=1796034636; darn=lists.linux.dev;
        h=cc:to:message-id:content-transfer-encoding:content-type
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=1xhgl5syMRg8qmPTHhAybLDTRj/xX0FiPUcwE+TXMJQ=;
        b=BrjF9aEEu97FVbiSI30ff+5XWngRYF4+oKrv+fLV73cRzPUW/jg3+l+swlHDf7LVIl
         7jt9D+B96i/bCC2pbprtCwtoFuOkfrX1T+1Hls876ruS/J49G5DJdpwKM07WPR4ffvBW
         MqDa0GkUtB9nu5kez+oFuWWAoBSst50YRpoq6yDpzQf5z3XJ4lJ/2KZ/v1rBEcYLphF4
         +jKawO/F1uo2T8CYbC+Ktg8FwndzZJSje2TbkpLNqDDABnWgWbZORG8QfKqtO49SlA78
         As1OMowYDSCW2ki945pbwErip4l4j8hIo3I+GNuMvanYELivNlzunYqy0wlZ1i0YIgwf
         sVZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795429836; x=1796034636;
        h=cc:to:message-id:content-transfer-encoding:content-type
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=1xhgl5syMRg8qmPTHhAybLDTRj/xX0FiPUcwE+TXMJQ=;
        b=DowIM7z0vEnEeC1Cm6eAjORBXST5c2jpT4kzrfqLKFcNm/ebEloScO5DKfnVNAbxNS
         jrrR5Pmc20I2yLEK4ua1c8AVlUozRE5kBsCK5Ig5aYueWuYfdckWjh1X7LJvf3N74hFe
         CWRuh4jGjCVy6+lgfS42AJf6WDpTsUvJpnoP+08I7NQG9GDjUicGVrWRA/dn5mYsfuGp
         8eLWQ4ryYkrt89Pmj6tyNy3EbEi6HJk0ItbyXFdDm1vZuXJeiveTq/zJgzgN8Eedq3XJ
         6P253jWKd5oMqTezVBQL/bm3efpj9zR3rcqAn7IVpVb7JOSqi10hlvzIl4ovDIsy+XDy
         xIjQ==
X-Forwarded-Encrypted: i=1; AL+hErF6PRNhZhD9lT6W+GyT+5qNU067lNgSgEpYG/+gzFLgDLSWyTSo08UNiCmJQ4dDR/Y37dX50Ik=@lists.linux.dev
X-Gm-Message-State: APuU4Z8jJB+PgCI/wUslp11MU+74yxx3fdos2kegoUZe0Q82yo1h9lL+
	UAihH0v2MUVIz34TuSrNhTh/JFyhYlF9ZrHlEQTaYeEwZvTaLQFbR0msIrOefmSMq9M=
X-Gm-Gg: AZFdTZe0Ac80tIAkug/Gz6KahwqkurZhS7Cgn38bfrquzTGbiXkW+KCXmOMiZuMvrlc
	0YxzFTybkSScjuEnhfeLAPdjrIbHIWkhvxPf5UV3TeILSt1be3SeaXMGKUFq8IHfdT3fv9zKhuq
	NKgoNHz+arIHThN+KZlKwSWrztDno7kTA9n5lhfKJ721wntCDs/XdD2CK9RGRTqhmLY43hymidY
	NdeY0WgQHxEjoFj62bjrbPHLaEZ7KBp6rZDHCfKxsfoG+JljELJUFn8741t8ks+GvpRM0pE5e8e
	CD/15DAeHKYobYYbx5GpJcPn8ok7ktsMUax8+KYXmBBxjvnPGCf5kYK1ts340AsH7qR3vIVy4ZE
	pjWFD2lyCWjeEwmQGh9Cltabe5yYiE0LOJWzJUc1nYn/bTsQrPWyzCiWzs09ugNyAX3vp5g2WOp
	J7NdNeAiBCbasoa19LZkxJ5FzMZp5hAChKWl0/GK43YDKUyi78T5DBIrQtaN8wwsz0F6HCz4gf/
	JH/GvkSr/LZyJBWNuSIUJI8xal15i6e16ck45SRex/r9vrGeY1Dl1Jgu0khgyrJ7zVzrJOMcBDk
	WLK4ZqVld4/evnCTuv4=
X-Received: by 2002:a05:6402:28c3:b0:6b3:b10c:40f9 with SMTP id 4fb4d7f45d1cf-6ba37e9532dmr7417775a12.31.1795429835843;
        Mon, 23 Nov 2026 02:30:35 -0800 (PST)
Received: from localhost ([2c0f:3d00:6be:8900:ce5e:9212:ea4b:f30])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6ba854bed08sm2967549a12.30.2026.11.23.02.30.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Nov 2026 02:30:35 -0800 (PST)
From: Dan Carpenter <dan@pereq.eu>
Date: Mon, 23 Nov 2026 13:30:16 +0300
Subject: [PATCH] KVM: arm64: nv: Never invalidate less than a page for a
 TTL hint
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261123-inval_range-v1-1-815e15797089@pereq.eu>
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/02MywqDMBBFf0VmbSAPFOqvFJEkTupISUvGSkH8d
 xPduDz3cTZgTIQMXbVBwpWYPjGDqivwk40vFDRmBi11q5Q2guJq30M6K/loXAhWjgYN5Mc3YaD
 /aXv2F/PPzeiXoigLZxmFy28/leguKxXs+wF3KZ0pkgAAAA==
X-Change-ID: 20261123-inval_range-095bffa0d3e3
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, 
 Fuad Tabba <fuad.tabba@linux.dev>, Joey Gouly <joey.gouly@arm.com>, 
 Steffen Eiden <seiden@linux.ibm.com>, 
 Suzuki K Poulose <suzuki.poulose@arm.com>, 
 Zenghui Yu <yuzenghui@huawei.com>, 
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
 Mark Rutland <mark.rutland@arm.com>
Cc: Karthik Bhargavan <karthik@pereq.eu>, 
 =?utf-8?q?Cl=C3=A9ment_Blaudeau?= <clement@cryspen.com>, 
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
 stable@vger.kernel.org, Dan Carpenter <dan@pereq.eu>
X-Mailer: b4 0.16.0

The compute_tlb_inval_range() function takes the size of a nested TLB
invalidation from the TTL hint in the TLBI operand.  A guest hypervisor
can give a 4K level-3 hint, which asks for a 4K invalidation.  On a host
with 16K or 64K pages that is less than one page.  s2_mmu_unmap_ipa()
passes the 4K size to kvm_stage2_unmap_range(), which hits
WARN_ON(size & ~PAGE_MASK).

WARNING: arch/arm64/kvm/mmu.c:407 at kvm_stage2_unmap_range+0x38/0x60, CPU#1: ipas2e1_ttl_tes/568
Call trace:
 kvm_stage2_unmap_range (arch/arm64/kvm/mmu.c:410) (P)
 s2_mmu_unmap_ipa (arch/arm64/kvm/sys_regs.c:4246)
 kvm_s2_mmu_iterate_by_vmid (arch/arm64/kvm/nested.c:770)
 handle_ipas2e1is (arch/arm64/kvm/sys_regs.c:4258)
 perform_access (arch/arm64/kvm/sys_regs.c:4917)
 kvm_handle_sys_reg (arch/arm64/kvm/sys_regs.c:5455)
 handle_exit (arch/arm64/kvm/handle_exit.c:466)
 kvm_arch_vcpu_ioctl_run (arch/arm64/kvm/arm.c:1583)
 kvm_vcpu_ioctl (virt/kvm/kvm_main.c:4595)

The shadow stage-2 is built from host pages, so invalidating less than
a page makes no sense.  Return at least PAGE_SIZE.

Fixes: d1de1576dc21 ("KVM: arm64: nv: Handle FEAT_TTL hinted TLB operations")
Cc: stable@vger.kernel.org
Signed-off-by: Dan Carpenter <dan@pereq.eu>
---
 arch/arm64/kvm/nested.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
index 78d5b18dbd2d..e964b122e9d0 100644
--- a/arch/arm64/kvm/nested.c
+++ b/arch/arm64/kvm/nested.c
@@ -735,7 +735,7 @@ unsigned long compute_tlb_inval_range(struct kvm_s2_mmu *mmu, u64 val)
 	}
 
 	WARN_ON(!max_size);
-	return max_size;
+	return max(max_size, PAGE_SIZE);
 }
 
 /*

---
base-commit: adcad7f4e6332cff3d6d7165f41584899f598534
change-id: 20261123-inval_range-095bffa0d3e3

Best regards,
--  
Dan Carpenter <dan@pereq.eu>

