Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A65D2FBE15
	for <kvmarm@lists.linux.dev>; Mon, 27 Oct 2025 11:38:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761565085; cv=none; b=gedcPYUQ9V+KRM1EiGEHkQOEwBlpfdhDa7YhgEosXSnu/SRUQi95aIaxCsRrWTjJb7EDBwJoYnG7COXZF6rDgiSx3w9XodxnuIMf4xmQcOkG6Rlz9Sv8HRCNZwFdu+RVsb7ozDpuaEu44+4tTJmrHne5vFq/zD504ZdvfBgg2Xs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761565085; c=relaxed/simple;
	bh=JtPobr8U8OyEtWz0+PGGaZRwq4swI0tEr8EEUNz/8Bo=;
	h=Date:From:To:cc:Subject:Message-ID:MIME-Version:Content-Type; b=dpBBjhkDnuQnCxkK7xc+rnSiXC1l5K8N/91y4dyyJ/SVo8hGEC9AzxhVar2iVm76Hb+DpvA49dopu6tPYv1nDRQPq0G52Sui9n5w8CSfJD3QMPmkJNsuf1b9DYQ0g36MI6ymhjFTpo2L6yTQjtY8SiKG3FyTeMkDzk//BsphN38=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=KJ3dEIKA; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="KJ3dEIKA"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1761565083;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type;
	bh=0IYenQhIa9PZj00vW7IIruD0UnAnXJ3V9tGf3ph9/f0=;
	b=KJ3dEIKAHSFiz4goVblGUoKumA6UI50fLNVvCWXzO71iOkFMO17qg2U3eFpqplXUMIkz69
	CrNKVfvgkgDkCOUHWnCjPZT0G1RmsH+FOx53BXv8btG29f5UZuW/8yp7XcrQhtrfWQMJlP
	AnpUVV/0SKkxfs7AxX8sE1EnUNyQWwg=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-176-BqyPbWcFM6OX82aD0l9LgQ-1; Mon, 27 Oct 2025 07:37:58 -0400
X-MC-Unique: BqyPbWcFM6OX82aD0l9LgQ-1
X-Mimecast-MFC-AGG-ID: BqyPbWcFM6OX82aD0l9LgQ_1761565077
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-42700099ff5so4246106f8f.2
        for <kvmarm@lists.linux.dev>; Mon, 27 Oct 2025 04:37:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761565077; x=1762169877;
        h=mime-version:message-id:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=0IYenQhIa9PZj00vW7IIruD0UnAnXJ3V9tGf3ph9/f0=;
        b=cyHJVf1u6dSO8B/pbpDYOHotYOY/WCHZjsGgT6SG/Rq+llDa1dFJtoXWBUrL40yl8Q
         nuExeNKazM82JU+WcSWrjMKLZefAeZ6sUhoYMqHeRu7m+16K3uZL2QNC22NOI3GOQgE9
         mqCPi2GXAva1Ynu4/d5zp8a90eVCeL6mZh/qwXwfDmt6PG8WoGbnPSrRWi+RY6ls/RvO
         8qrhShJ+ljm4PqTa7nwt4SAMZuv7dslLWNGv9w0p+T3ZTf8OjmwoQoeRN0wxYhuB0MHe
         NkbOPrTEIno+eYZaP4QqRd7n8mCTxdL5bl0tnswjPvBPi44ZDPv9guipsgFRw3uBXu+Q
         DxBg==
X-Forwarded-Encrypted: i=1; AJvYcCXQIqoH6KJGiF9fX0JuIpJt8wJIGO1mTPoEaPgjLbCAoJ/LvL/Xo/zPOmHEzltxnNl7MShEImM=@lists.linux.dev
X-Gm-Message-State: AOJu0Yy/C/nbI437lyKmaLIQwqscveslMtyBm7zmINXw03OcshxMSYFC
	4bNQWZCjlVU+sZjvpVy3ASAQr2qCCSgmBYkegh9tTNmcFa2LZZHPNUFQkAzkil2bbmYGvKmnwT3
	IALqrt397behgOc2jOSqBywCI+ijDjdiGYG78Gh/1zxDK1442ybo+F4UUuQ==
X-Gm-Gg: ASbGncsmaGfdn0TuA+DUYFQLLviM7kzD49BJmdk59xpA2ULXp+hqvz7+GFfSWuq6eF9
	yEMq69nxzNtlk0dFrm5UTqVVeT+41zcJTakUqUwzaEbM02QyiNB9+CMPggjM3pPkC0u9fRDIY+F
	lvTXdpSI3qcPPNVKVvaySSj/ixwEweKJgeRd/Do7a2m/7Au8skmBFxTTDFpychA8PaZJgaVxHJg
	LRYuwRHfiRdwR4UQhgMilTz61UjjEA9BYUbx+HFLINCm+pE9baLIgP5E3T+WttkGDfW3cicy7bt
	g8m2JivRzVoyn4i8mSOH70WvJd5xTMtTxi98io4lD9nJdqqjO8clMyXtlOtPKeIp4YUGb7h8lBU
	I4dVbMjmcaZMlOFW7mP4qnPHP2C4of59ksJ3//9xMzM5s7oOC
X-Received: by 2002:a5d:5c89:0:b0:425:7406:d298 with SMTP id ffacd0b85a97d-42704d7e9ebmr30407490f8f.5.1761565076780;
        Mon, 27 Oct 2025 04:37:56 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEGx4uKgsYoM0fU52HYyWEvQMrYgypwVSrAUmI9lNjcwUX5i2uMZCdkDcF1SDu586SVN9WApQ==
X-Received: by 2002:a5d:5c89:0:b0:425:7406:d298 with SMTP id ffacd0b85a97d-42704d7e9ebmr30407464f8f.5.1761565076305;
        Mon, 27 Oct 2025 04:37:56 -0700 (PDT)
Received: from rh (p200300f6af131a0027bd20bfc18c447d.dip0.t-ipconnect.de. [2003:f6:af13:1a00:27bd:20bf:c18c:447d])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-429952cb7e8sm14108931f8f.19.2025.10.27.04.37.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Oct 2025 04:37:55 -0700 (PDT)
Date: Mon, 27 Oct 2025 12:37:54 +0100 (CET)
From: Sebastian Ott <sebott@redhat.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
    Sascha Bischoff <Sascha.Bischoff@arm.com>
cc: Suzuki K Poulose <suzuki.poulose@arm.com>, 
    Zenghui Yu <yuzenghui@huawei.com>, Joey Gouly <joey.gouly@arm.com>, 
    Joey Gouly <joey.gouly@arm.com>, Will Deacon <will@kernel.org>, 
    linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
    linux-kernel@vger.kernel.org
Subject: Failing no-vgic-v3 test
Message-ID: <f9c7fffa-53ba-a506-b48b-07e3df2d1d5a@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: KQABKHCGjWZhJXl9D2ZKdIWiOgIAmuf6R4YDMA9Ce30_1761565077
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; format=flowed; charset=US-ASCII

Hey,

on an ampere altra I've got a sad selftest:

[root@virtlab-arm11 kvm]# ./arm64/no-vgic-v3
Random seed: 0x6b8b4567
==== Test Assertion Failure ====
   arm64/no-vgic-v3.c:66: handled
   pid=3793 tid=3793 errno=4 - Interrupted system call
      1  0x0000000000402feb: test_run_vcpu at no-vgic-v3.c:128
      2  0x000000000040214f: test_guest_no_gicv3 at no-vgic-v3.c:155 (discriminator 17)
      3   (inlined by) main at no-vgic-v3.c:174 (discriminator 17)
      4  0x0000ffff873eb587: ?? ??:0
      5  0x0000ffff873eb65f: ?? ??:0
      6  0x00000000004022af: _start at ??:?
   ICC_PMR_EL1 no read trap

This is a guest without VGICv3 on GICv3 HW. The test expects UNDEF on reg
access - which is not happening since:

3193287ddffb KVM: arm64: gic-v3: Only set ICH_HCR traps for v2-on-v3 or v3 guests

As a local fix I've done:
diff --git a/arch/arm64/kvm/vgic/vgic-v3.c b/arch/arm64/kvm/vgic/vgic-v3.c
index 6fbb4b099855..1fe53a021926 100644
--- a/arch/arm64/kvm/vgic/vgic-v3.c
+++ b/arch/arm64/kvm/vgic/vgic-v3.c
@@ -297,11 +297,15 @@ void vcpu_set_ich_hcr(struct kvm_vcpu *vcpu)
  {
  	struct vgic_v3_cpu_if *vgic_v3 = &vcpu->arch.vgic_cpu.vgic_v3;

  	if (!vgic_is_v3(vcpu->kvm))
  		return;

  	/* Hide GICv3 sysreg if necessary */
-	if (vcpu->kvm->arch.vgic.vgic_model == KVM_DEV_TYPE_ARM_VGIC_V2) {
+	if (!kvm_has_gicv3(vcpu->kvm) ||
+	    vcpu->kvm->arch.vgic.vgic_model == KVM_DEV_TYPE_ARM_VGIC_V2) {
  		vgic_v3->vgic_hcr |= (ICH_HCR_EL2_TALL0 | ICH_HCR_EL2_TALL1 |
  				      ICH_HCR_EL2_TC);
  		return;


but following the intention of the patch above maybe we should do smth
like:
diff --git a/arch/arm64/kvm/vgic/vgic-v3.c b/arch/arm64/kvm/vgic/vgic-v3.c
index 6fbb4b099855..1fe53a021926 100644
--- a/arch/arm64/kvm/vgic/vgic-v3.c
+++ b/arch/arm64/kvm/vgic/vgic-v3.c
@@ -297,11 +297,15 @@ void vcpu_set_ich_hcr(struct kvm_vcpu *vcpu)
  {
  	struct vgic_v3_cpu_if *vgic_v3 = &vcpu->arch.vgic_cpu.vgic_v3;

  	if (!vgic_is_v3(vcpu->kvm))
  		return;

  	/* Hide GICv3 sysreg if necessary */
-	if (vcpu->kvm->arch.vgic.vgic_model == KVM_DEV_TYPE_ARM_VGIC_V2) {
+	if (kvm_has_feat(vcpu->kvm, ID_AA64PFR0_EL1, GIC, NI) ||
+	    vcpu->kvm->arch.vgic.vgic_model == KVM_DEV_TYPE_ARM_VGIC_V2) {
  		vgic_v3->vgic_hcr |= (ICH_HCR_EL2_TALL0 | ICH_HCR_EL2_TALL1 |
  				      ICH_HCR_EL2_TC);
  		return;

Thoughts?
Sebastian

