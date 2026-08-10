Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A9A039D3FC
	for <kvmarm@lists.linux.dev>; Mon, 10 Aug 2026 21:22:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786396963; cv=none; b=TAFSEyVrk/Y9fAKIZY+2rlGrxXdhVWtKWpPuoHk6vJOCHpKeTuk6C+Sa7Cj5iHD3CmK4PZptWNf/hygOJoePC2vwZj33hEPY4ybISX2x5JHmkFoiBKKQQCdqbAeG//9wD3vnHGbXqCR4A8cOpHWUgI7K6/zEW0TrRk6zLY+5Wuw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786396963; c=relaxed/simple;
	bh=iZFB5O3yYls89/a7prTviepZAmlHYtU3yy8LB94oET4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ErqD+T/VjwILQXAm4rg94gNxgXqd+gEMS/HgqEb7C6g8K8MW3+Pz9PhpugAma51OHB70cnCHH+anUNQ00548M/cc6Az1pj76rZVjMrJbZPLTcprjs5A/RkTvY4zE2rLWDCu9AT2HuSrrGOq3axbETWDjEEKKXvnoFpakkc/8mhk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=kDuOPApv; arc=none smtp.client-ip=209.85.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kDuOPApv"
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-4921eed3fa2so17320855e9.0
        for <kvmarm@lists.linux.dev>; Mon, 10 Aug 2026 14:22:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786396960; x=1787001760; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=xYpJjvMop3p/gly/It61F2813t5+gwnEvzTnI0j75g0=;
        b=kDuOPApvwyiqTmYQixFRm373A1v1O8+w3qmyVUDsZN4Mf8LheXnm2AAmrhDTGo3Z9R
         fzxhxNgjmIKyNIqlIo7/Z/2qe/bfoyCd0Qz6BGkyqVlWKiq2QS53wmUnSsT8WMdZpne6
         rwDX1iTLWp7z21e8ghvieMQ+1XedaYhdos/eUmiJY1D9n8x0482r1uAu+dkiwnrGxktm
         oXs8e/weD7b2M86O+lCfdq8ayyoGvffB3RlI6e/tnQh44jzWkhNCJnKO/7uVHqZRgZIx
         jhcFuJOCbAH8udqBQivjCubDBSpVurAJqGAby5QvaidZj/PBnxSOZ9RdbfP2s+vEJ16x
         yBpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786396960; x=1787001760;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=xYpJjvMop3p/gly/It61F2813t5+gwnEvzTnI0j75g0=;
        b=BHciXJSQw4s7ODW8kZoMHxj6CtxaDdihpf/adCosMj39iAsIA2OSUkcyD18rVqZuqn
         1nHY5/R7mlToSYxfpC4amjMOWhvsSzdd0jhVBL+D6HBHRDuEoBqechnhCGwobD3aoLjm
         IzxQ7N0XrBIpR5/HJGDRGxgR0e6iOil8lo3KX+HJPWS0awnI5y7IKfLb7vsC48lhcEmL
         4DdPPYh2Ra2eJQyjLNABOSAtjlpnTPonRlrJZtfHC5B30+Fpnbmf45Aobg0JTrokYnIr
         5TfiReywj3c+gxjXecAQHkgZCXZvRy53/rAdXtJCGdkWMASoaEO4Sjpm1ksjyTvvXj0w
         AljQ==
X-Forwarded-Encrypted: i=1; AHgh+RpEaV76GDwXCgbnx2aCIumN+YmagbbkuJ+MboQhwEh7opMAb+dRxOmqHp6G5bLGW3L2r57IzVY=@lists.linux.dev
X-Gm-Message-State: AOJu0YxsPDw0q4LgcSZRmU2zoiDw789SMFKSo37zYhRem7QNHLITk8yh
	MFPd2iroBF2JnoKXKAd3BgpY5wQy3nb/8kwPjHogjjIvQxbp9I7rEb9z
X-Gm-Gg: AR+sD12hKv/E1jlY2qtkcUoxVsUrOKync1SUDNqRlylOQkLkwIiWAnsS/h4+C1tyzQB
	TCqAdYL9XWasHw4eQ4ivSfWvCRIj3ezOatooiqC3kpMSFY81bXIoq/0gvCebi2yjm34P3DaCcMP
	BGDOIMLPYcMz2KYXJRNWP3zFqYp1nKwCGc5vTpba74wKtActGLRMXeGPGTaysDmXfKyKCZ/YOl5
	fNLRcbqjE/9j0r48CUVL8wKMQK1BhLkp0xM+QzDig3AzPlUabjzqwKmSXw35bwmXdddYy/3DIrt
	vsLQywPHNIiNrQAaocLzkNK/Ht7HNy/wKfkl6/9sfHXq0vZDIFFXYT1aedokoxGvpMvN+8vvZvu
	eg/bWlexMaShLtVWTGYOgTm/oL5rzQB8E4au1d7uf+2bJjcDQ/HKcZ8TccNOxrUOhLP3tzvA3QL
	Px5Y3cGURvShm4lGIQUGv2ZhQmJT68swQiqpmczU9vFZ+9SGxNj6hFVTxb0OC49Ip+GmwKmQ1n7
	Pou5gpogVoMhCf6hpr7uhmUwCmZyYll+zl2Ds/eJShRVJ2MObGXZGqTWnCEKbHME9OL/7Ca7fFj
	NGY/Xop+E6uY3M8ZAdQ3P0Fd3GVI1r9EoJr6uQ6JabekfZuYCg51gTblOaFeKD27IK0Ny84=
X-Received: by 2002:a05:600c:3585:b0:493:e451:a9e1 with SMTP id 5b1f17b1804b1-49972740d07mr52058455e9.2.1786396959461;
        Mon, 10 Aug 2026 14:22:39 -0700 (PDT)
Received: from unknown748F3CBA5068 (dynamic-2a02-3100-a1e8-7401-316d-6c00-7a9a-8fac.310.pool.telefonica.de. [2a02:3100:a1e8:7401:316d:6c00:7a9a:8fac])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-499740d2c6fsm18342935e9.9.2026.08.10.14.22.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Aug 2026 14:22:39 -0700 (PDT)
Date: Mon, 10 Aug 2026 23:22:37 +0200
From: Karl Mehltretter <kmehltretter@gmail.com>
To: Marc Zyngier <maz@kernel.org>
Cc: Oliver Upton <oupton@kernel.org>, kvmarm@lists.linux.dev, 
	Fuad Tabba <fuad.tabba@linux.dev>, Joey Gouly <joey.gouly@arm.com>, 
	Steffen Eiden <seiden@linux.ibm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, 
	Shuah Khan <shuah@kernel.org>, Eric Auger <eric.auger@redhat.com>, kvm@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org
Subject: Re: [RFC PATCH 1/2] KVM: arm64: vgic-v3: Roll back failed
 redistributor region setup
Message-ID: <anotFcOP0kcQJwrA@gmail.com>
References: <cover.1786344511.git.kmehltretter@gmail.com>
 <4e00fc25aa61ec52e6ef033a53588ce3f5550982.1786344511.git.kmehltretter@gmail.com>
 <86tsp2139b.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86tsp2139b.wl-maz@kernel.org>

On Mon, Aug 10, 2026 at 03:03:44PM +0100, Marc Zyngier wrote:
> 
> > A later REDIST_REGION attribute can be inserted successfully and then
> 
> Later than what?

I meant a REDIST_REGION write after earlier
region writes have already assigned RDs to some vCPUs.

In the selftest (patch 2) 
- region 0 contains RDs for vCPUs 0 and 1
- region 1 contains RD for vCPU 2
- the REDIST_REGION write for region 2 fails while KVM processes vCPU 3

> Holes in the MMIO space are the norm. The IPA space can multi-TB
> large, and there is no reason why it'd cover everything (where would
> you place the RAM otherwise?).
> 
> Is the problem here that you are left with vcpus that seem to have
> been matched to an RD (base_addr being set), but that really are left
> unconnected?

Yes I guess "hole" is the wrong term. The vCPU still has an RD and a
base address, but its iodev has been removed from KVM_MMIO_BUS.
An access to that RD address then causes KVM_RUN to return
to userspace with KVM_EXIT_MMIO.

> 
> > failing vCPU already has its base address and region assigned, but the
> > old i < c rollback does not include it.
> 
> What is "it"?

I meant the current vCPU redistributor iodev.
vgic_register_redist_iodev() sets the vCPU's region and base address
before calling kvm_io_bus_register_dev(). If this call fails for
vCPU c, the rollback in vgic_register_all_redist_iodevs() processes only
vCPUs with indices below c.

> > Preserve devices assigned by earlier successful setters. On failure,
> > unregister only vCPUs associated with the newly inserted region, clear
> > their cached base addresses, and free that region. This also includes the
> > current vCPU when iodev registration itself fails.
> 
> What I don't see here is an argument explaining that doing this
> doesn't change the guest-visible assignment of RDs, which would be a
> regression.

vgic_register_redist_iodev() returns immediately if a vCPU's RD base
address is already set, so its RD region and address don't change.

Regions are filled in index order, a vCPU without an RD address can
use the new region only after older regions are full.

So freeing the new region and clearing the RD state of vCPUs associated
with it restores the state before the failed write.

> Based on what I understand of your earlier description, why isn't this
> as simple as this untested hack:

I ran the selftest (patch 2) with this, still failed with:

  Unexpected MMIO exit at 0x8050008

When redistributor registration for vCPU 3 fails, the for loop does
vCPUs 0 to 3. The issue is that the iodevs for vCPUs 0 to 2 were
registered by earlier successful region writes and should not be
unregistered.

On retry, vgic_register_redist_iodev() sees the set addresses
and does not re-register those iodevs.

> I don't mind the cleaning up, but not as part of fixing the issue,
> which has to be as small as possible (think of the backports).

I reworked the change without a new helper (see below).
Is this closer to what you had in mind?

diff --git a/arch/arm64/kvm/vgic/vgic-mmio-v3.c b/arch/arm64/kvm/vgic/vgic-mmio-v3.c
index 5913a20d83019..d9a28b983ecca 100644
--- a/arch/arm64/kvm/vgic/vgic-mmio-v3.c
+++ b/arch/arm64/kvm/vgic/vgic-mmio-v3.c
@@ -841,7 +841,7 @@ void vgic_unregister_redist_iodev(struct kvm_vcpu *vcpu)
 	kvm_io_bus_unregister_dev(vcpu->kvm, KVM_MMIO_BUS, &rd_dev->dev);
 }
 
-static int vgic_register_all_redist_iodevs(struct kvm *kvm)
+static int vgic_register_all_redist_iodevs(struct kvm *kvm, u32 index)
 {
 	struct kvm_vcpu *vcpu;
 	unsigned long c;
@@ -856,12 +856,15 @@ static int vgic_register_all_redist_iodevs(struct kvm *kvm)
 	}
 
 	if (ret) {
-		/* The current c failed, so iterate over the previous ones. */
+		struct vgic_redist_region *rdreg;
 		int i;
 
-		for (i = 0; i < c; i++) {
+		rdreg = vgic_v3_rdist_region_from_index(kvm, index);
+
+		for (i = 0; i <= c; i++) {
 			vcpu = kvm_get_vcpu(kvm, i);
-			vgic_unregister_redist_iodev(vcpu);
+			if (vcpu->arch.vgic_cpu.rdreg == rdreg)
+				vgic_unregister_redist_iodev(vcpu);
 		}
 	}
 
@@ -960,8 +963,10 @@ void vgic_v3_free_redist_region(struct kvm *kvm, struct vgic_redist_region *rdre
 
 	/* Garbage collect the region */
 	kvm_for_each_vcpu(c, vcpu, kvm) {
-		if (vcpu->arch.vgic_cpu.rdreg == rdreg)
+		if (vcpu->arch.vgic_cpu.rdreg == rdreg) {
 			vcpu->arch.vgic_cpu.rdreg = NULL;
+			vcpu->arch.vgic_cpu.rd_iodev.base_addr = VGIC_ADDR_UNDEF;
+		}
 	}
 
 	list_del(&rdreg->list);
@@ -982,7 +987,7 @@ int vgic_v3_set_redist_base(struct kvm *kvm, u32 index, u64 addr, u32 count)
 	 * Register iodevs for each existing VCPU.  Adding more VCPUs
 	 * afterwards will register the iodevs when needed.
 	 */
-	ret = vgic_register_all_redist_iodevs(kvm);
+	ret = vgic_register_all_redist_iodevs(kvm, index);
 	if (ret) {
 		struct vgic_redist_region *rdreg;
 

Thanks,
Karl
