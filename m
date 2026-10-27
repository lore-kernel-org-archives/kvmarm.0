Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=95.215.58.47
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793086603;
	b=VMxKkgjv8BGcPj4PE/4A9Fi/pWwHs+YKQBE1kUWfCYELj0X8Y+eWG6y+mTzg5ZoR4TR7
	 1COiZUc5gG0lUYsYJli7yLyxAFZm+2ughLMsmUE8Mr2PgkK0NoCIUJwn3eYljJx619gZx
	 N70D2nAw0ck/Y/h+iZoMxZcb7JWJ/XUYlkkzEbjCK5i6F5itmIBOqG1pCLiFgYbPjsQU+
	 bO8aLHS9j6BQzi/icSjSk41V1EFqgjMxagqmEgHNHhxP3DDS18QfvcewjhyL6POnBHI81
	 M62p0CXyuOhVSRZhIIVbOrD/a1MWppGjfcHfhxegZj7VJ5S22LbyLZmdrkw49Vw6Wlw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793086603;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=1iqiUC774uIz1noqTv66R/pcx1jq2Y3gBT5EkDOI8+U=;
	b=Z3JZpJZycZVk6ARgbp+NsfRB63ncBUeIevqoEOmgrVIYTkl0QQMW2p9ptg9oYyhlHOIx
	 8wGrCyR3kHPUg2X2XjKf4f2xtTIpk2NKo6CL8GYrLcr3zJzIBxkO6OBpXzo72gpi6b+oi
	 f0EC6Plp5NWa+oUgkuvTUgKuEOBh44GTJpnlhqIM67ZBGa6Luw1xU85iLJgib4gqRZfCY
	 Svyh8X0OK6rR32e1XtBMbPo1mZmoXVq2s0NJCUDJCRF83q+2VKJA8eoZmoA8nCmOc1fp1
	 SkDq0xC+jzwce9hMCxVPhCYwD2qInPODeo16K5WisTU1qPVlW5GagV7js27RH0Dsw1A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=bjQq2tyx;
	arc=none smtp.remote-ip=95.215.58.47
Received: from mta1.migadu.com (out-47.mta1.migadu.com [95.215.58.47])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB21760A380C
	for <kvmarm@lists.linux.dev>; Tue, 27 Oct 2026 07:36:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org AB21760A380C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=bjQq2tyx
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=dmqT96w8wTTUeTOZNcr8vlUEdj+NSgO8Wwrd2wCr44Y=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793086595; v=1; x=1793691395;
 b=bjQq2tyxEe9OTBmG0Dqfb2eCsJWmXyMGMm82E3d8RYDnkAPLIxekObBnzI0Gj+Fo7wI6Y92I
 4Aua35paKGksXn8hML4IsMX2SEiQLAhuPembjW9cFF6PVkL4OsC0novNkOoisMmtfEFTbUSuWg/
 fUcPWee6J4fMrnmpzLSp5d+E=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id 77ba2e4eb353bbfd;
	Tue, 27 Oct 2026 07:36:35 +0000
X-Mizu-Trace-ID: 77ba2e4eb353bbfd
X-Migadu-Flow: FLOW_OUT
From: Fuad Tabba <fuad.tabba@linux.dev>
To: Oliver Upton <oupton@kernel.org>
Cc: Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Raghavendra Rao Ananta <rananta@google.com>,
	Eric Auger <eric.auger@redhat.com>,
	Will Deacon <will@kernel.org>,
	Fuad Tabba <tabba@google.com>,
	kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] KVM: arm64: vgic-v4: Don't allocate vPEs when userspace clears nASSGIcap
Date: Tue, 27 Oct 2026 07:36:34 +0000
Message-ID: <20261027073634.440288-1-fuad.tabba@linux.dev>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <at-saZT_ixQxsZIr@kernel.org>
References: <at-saZT_ixQxsZIr@kernel.org>
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

Hi Oliver,

On Mon, 26 Oct 2026 19:39:21 +0000, Oliver Upton <oupton@kernel.org> wrote:
[...]
> Looking at both of the patches now, I'd rather we just fix the
> predicates and use those to consistently gate GICv4. Untested as always:

I open coded the nASSGIcap check because vgic_its_create() only sets
has_its after vgic_v4_init(), but the predicate is the better place for
it.

> diff --git a/arch/arm64/kvm/vgic/vgic-its.c b/arch/arm64/kvm/vgic/vgic-its.c
[...]
> @@ -1866,9 +1866,16 @@ static int vgic_its_create(struct kvm_device *dev, u32 type)
>  
>          mutex_lock(&dev->kvm->arch.config_lock);
>  
> +        /*
> +         * Make an early indication that this VM has an ITS so calls to
> +         * vgic_supports_direct_irqs() work as intended, rolling back state
> +         * if we fail to setup GICv4.
> +         */
> +        dev->kvm->arch.vgic.has_its = true;

This makes vgic_supports_direct_irqs() true for running vCPUs before
vgic_v4_init() has allocated their vPEs. On GICv4.0, a vCPU loaded in
that window hits the WARN_ON(vgic_v4_load()) in vgic_v3_load()
(vpe->irq is still 0). With an msleep() holding vgic_its_create()
there, my reproducer, which creates an ITS while a vCPU runs, hits it
on the FVP. Keeping the store after vgic_v4_init(), where it is today,
avoids that window (diff below).

[...]
> diff --git a/arch/arm64/kvm/vgic/vgic-v4.c b/arch/arm64/kvm/vgic/vgic-v4.c
[...]
> @@ -248,8 +248,8 @@ int vgic_v4_init(struct kvm *kvm)
>  
>          lockdep_assert_held(&kvm->arch.config_lock);
>  
> -        if (!kvm_vgic_global_state.has_gicv4)
> -                return 0; /* Nothing to see here... move along. */
> +        if (!vgic_supports_direct_irqs(kvm))
> +                return 0;

vgic_supports_direct_irqs() is also true for any vGICv5 VM, so with
this, creating an ITS on an initialised one, on a GICv5 host with
legacy support, reaches its_alloc_vcpu_irqs() with no GICv4 irqdomain,
where irq_domain_create_hierarchy() dereferences a NULL vpe_domain_ops.
The diff below keeps the has_gicv4 test.

It gates vgic_v4_init() on the part of vgic_supports_direct_msis()
that doesn't read has_its. That part is false for the GICv2 VM from
patch 1 and for a vGICv5 VM, so the diff drops your vgic.h hunk:

diff --git a/arch/arm64/kvm/vgic/vgic-mmio-v3.c b/arch/arm64/kvm/vgic/vgic-mmio-v3.c
index 5913a20d83019..a60697238a7a7 100644
--- a/arch/arm64/kvm/vgic/vgic-mmio-v3.c
+++ b/arch/arm64/kvm/vgic/vgic-mmio-v3.c
@@ -48,7 +48,7 @@ bool vgic_has_its(struct kvm *kvm)
 	return dist->has_its;
 }
 
-bool vgic_supports_direct_msis(struct kvm *kvm)
+bool vgic_supports_vpes(struct kvm *kvm)
 {
 	/*
 	 * Deliberately conflate vLPI and vSGI support on GICv4.1 hardware,
@@ -58,7 +58,12 @@ bool vgic_supports_direct_msis(struct kvm *kvm)
 	if (system_supports_direct_sgis() && !vgic_supports_direct_sgis(kvm))
 		return false;
 
-	return kvm_vgic_global_state.has_gicv4 && vgic_has_its(kvm);
+	return kvm_vgic_global_state.has_gicv4 && vgic_is_v3(kvm);
+}
+
+bool vgic_supports_direct_msis(struct kvm *kvm)
+{
+	return vgic_supports_vpes(kvm) && vgic_has_its(kvm);
 }
 
 bool system_supports_direct_sgis(void)
diff --git a/arch/arm64/kvm/vgic/vgic-v4.c b/arch/arm64/kvm/vgic/vgic-v4.c
index ed236f083f0d7..0a4b9a74425b4 100644
--- a/arch/arm64/kvm/vgic/vgic-v4.c
+++ b/arch/arm64/kvm/vgic/vgic-v4.c
@@ -248,7 +248,7 @@ int vgic_v4_init(struct kvm *kvm)
 
 	lockdep_assert_held(&kvm->arch.config_lock);
 
-	if (!kvm_vgic_global_state.has_gicv4)
+	if (!vgic_supports_vpes(kvm))
 		return 0; /* Nothing to see here... move along. */
 
 	if (dist->its_vm.vpes)
diff --git a/arch/arm64/kvm/vgic/vgic.h b/arch/arm64/kvm/vgic/vgic.h
index b71d486ae5145..7fc29a395a7db 100644
--- a/arch/arm64/kvm/vgic/vgic.h
+++ b/arch/arm64/kvm/vgic/vgic.h
@@ -500,6 +500,7 @@ static inline bool vgic_host_has_gicv5(void)
 }
 
 bool system_supports_direct_sgis(void);
+bool vgic_supports_vpes(struct kvm *kvm);
 bool vgic_supports_direct_msis(struct kvm *kvm);
 bool vgic_supports_direct_sgis(struct kvm *kvm);
 

Tested on the FVP (GICv4.0 and GICv4.1): KVM doesn't leak doorbells in
either patch's case, a GICv3 VM still gets its vPEs when the ITS is
created, and the reproducer above doesn't hit the WARN. Does that work
for you? If so, I'll send it as v2.

Cheers,
/fuad
