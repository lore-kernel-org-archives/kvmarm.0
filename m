Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15E4033F5B6;
	Thu, 18 Jun 2026 19:06:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781809575; cv=none; b=YjMLqgHWzS0JOcxiwA5ywkJLQVjg7zzkYf3Ks7wE9pg6qMQHRW+PkvNCa9FPodq4mBjjr15m19cKSfWt3CYL0u2LwTVpYVzpyB6ZMTDUr/PTAdty59MB2gaKGMVjVVrxZE8HZ0t8aWv0oRZn4fYwhdYwZaQ9RTligTARjUNHdtA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781809575; c=relaxed/simple;
	bh=1Tv0YmVhkx8ud0qt22F8mlihvisOlxy+ZlCpIP1c5vE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ml92Wb4hae3YMHf0hkQe6w94XZkTgLxl9u82DfMdCKcclfxHeTK5e/x+809W09AaXKh6qIKe6zq4jzALaJES9R9Gcu+rjgSTZbAoNluTHOVQ6lExlm1UFcgC5xp1U1kv8BF0GiJvYclPq4IYqJ79QWnMgbDX8w+IaWBwNE43kC8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QJFYo1fH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QJFYo1fH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C0601F000E9;
	Thu, 18 Jun 2026 19:06:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781809573;
	bh=wR6Mtq5nZ+5UapL5g8Gruh6bzm0GAsMPkKV4VGUnpD0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=QJFYo1fHYvc3pXPSZSAyFDU4Z0SNbW8oFKZ8rnOuhLSFy9g3a3hdDVJ/DyK45vkU/
	 o7sj9BqU7NRvNOIfnVx+H9IhJRHLBnrCTnoGe+MWP+++QpUbpxQ/NB+6eySUFtDWQP
	 fXtMJCCjGqSYFIjJqcXXpVVTGolsmDvW3Pf961XCU1S0IYWcU0rsR5xFV++L+mNbad
	 29wz1z0MgzqDfYbDN/ppBvt+4vcqPHX2uK6nilp6uRIhZ+nRyQMDEooNftiA7d6ejd
	 vi4YMnbwPcLAeTtRHfk8uAzNTofi6LAi2y5dSiC4Jqb2MwQjeq0Yb2AFJHeW3kLZGa
	 skCgxmdzudOGQ==
Date: Thu, 18 Jun 2026 12:06:12 -0700
From: Oliver Upton <oupton@kernel.org>
To: Alexandru Elisei <alexandru.elisei@arm.com>
Cc: will@kernel.org, julien.thierry.kdev@gmail.com, maz@kernel.org,
	jean-philippe.brucker@arm.com, andre.przywara@arm.com,
	suzuki.poulose@arm.com, kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev
Subject: Re: [PATCH kvmtool v2 7/7] arm64: Improve KVM_ARM_VCPU_PMU_V3_CTRL
 diagnostics
Message-ID: <ajRBpMnlcNkhWzQL@kernel.org>
References: <20260618155001.226266-1-alexandru.elisei@arm.com>
 <20260618155001.226266-8-alexandru.elisei@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260618155001.226266-8-alexandru.elisei@arm.com>

On Thu, Jun 18, 2026 at 04:50:01PM +0100, Alexandru Elisei wrote:
> kvmtool issues several ioctls when configuring the PMU, and each of them
> can fail for different reasons. Be more specific about the ioctl that
> failed when that happens.
> 
> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
> ---
>  arm64/pmu.c | 31 ++++++++++++++++++++++++-------
>  1 file changed, 24 insertions(+), 7 deletions(-)
> 
> diff --git a/arm64/pmu.c b/arm64/pmu.c
> index 92cacd62479e..78c15f153fad 100644
> --- a/arm64/pmu.c
> +++ b/arm64/pmu.c
> @@ -12,6 +12,24 @@
>  
>  #include "asm/pmu.h"
>  
> +static const char *pmu_attr_names[] = {
> +	[KVM_ARM_VCPU_PMU_V3_IRQ]	= "KVM_ARM_VCPU_PMU_V3_IRQ",
> +	[KVM_ARM_VCPU_PMU_V3_INIT]	= "KVM_ARM_VCPU_PMU_V3_INIT",
> +	[KVM_ARM_VCPU_PMU_V3_FILTER]	= "KVM_ARM_VCPU_PMU_V3_FILTER",
> +	[KVM_ARM_VCPU_PMU_V3_SET_PMU]	= "KVM_ARM_VCPU_PMU_V3_SET_PMU",
> +	[KVM_ARM_VCPU_PMU_V3_SET_NR_COUNTERS] = "KVM_ARM_VCPU_PMU_V3_SET_NR_COUNTER",
> +};
> +
> +static const char *pmu_get_attr_name(u64 attr)
> +{
> +	switch (attr) {
> +	case KVM_ARM_VCPU_PMU_V3_IRQ ... KVM_ARM_VCPU_PMU_V3_SET_NR_COUNTERS:
> +		return pmu_attr_names[attr];
> +	default:
> +		return "UNKNOWN";
> +	}
> +}
> +
>  static bool pmu_has_attr(struct kvm_cpu *vcpu, u64 attr)
>  {
>  	struct kvm_device_attr pmu_attr = {
> @@ -32,13 +50,12 @@ static void set_pmu_attr(struct kvm_cpu *vcpu, void *addr, u64 attr)
>  	};
>  	int ret;
>  
> -	if (pmu_has_attr(vcpu, attr)) {
> -		ret = ioctl(vcpu->vcpu_fd, KVM_SET_DEVICE_ATTR, &pmu_attr);
> -		if (ret)
> -			die_perror("PMU KVM_SET_DEVICE_ATTR");
> -	} else {
> -		die_perror("PMU KVM_HAS_DEVICE_ATTR");
> -	}
> +	if (!pmu_has_attr(vcpu, attr))
> +		die_perror("KVM_HAS_DEVICE_ATTR(%s)", pmu_get_attr_name(attr));
> +
> +	ret = ioctl(vcpu->vcpu_fd, KVM_SET_DEVICE_ATTR, &pmu_attr);
> +	if (ret)
> +		die_perror("KVM_SET_DEVICE_ATTR(%s)", pmu_get_attr_name(attr));
>  }

The whole if (ret) die_perror(...) thing is a bit repetetive IMO. A
treewide cleanup replacing this with macros would be nice, then you could
stringize the ioctl under the hood.

diff --git a/arm64/pmu.c b/arm64/pmu.c
index 5f31d6b..0d9f3df 100644
--- a/arm64/pmu.c
+++ b/arm64/pmu.c
@@ -23,23 +23,19 @@ static bool pmu_has_attr(struct kvm_cpu *vcpu, u64 attr)
 	return ret == 0;
 }
 
-static void set_pmu_attr(struct kvm_cpu *vcpu, void *addr, u64 attr)
-{
-	struct kvm_device_attr pmu_attr = {
-		.group	= KVM_ARM_VCPU_PMU_V3_CTRL,
-		.addr	= (u64)addr,
-		.attr	= attr,
-	};
-	int ret;
-
-	if (pmu_has_attr(vcpu, attr)) {
-		ret = ioctl(vcpu->vcpu_fd, KVM_SET_DEVICE_ATTR, &pmu_attr);
-		if (ret)
-			die_perror("PMU KVM_SET_DEVICE_ATTR");
-	} else {
-		die_perror("PMU KVM_HAS_DEVICE_ATTR");
-	}
-}
+#define kvm_set_device_attr(fd, _group, _attr, _addr)					\
+do {											\
+	struct kvm_device_attr __attr = {						\
+		.group	= (_group),							\
+		.attr	= (_attr),							\
+		.addr	= (u64)(_addr),							\
+	};										\
+	int r;										\
+											\
+	r = ioctl((fd), KVM_SET_DEVICE_ATTR, &__attr);					\
+	if (r)										\
+		die_perror("KVM_SET_DEVICE_ATTR(group:"#_group", attr:"#_attr")");	\
+} while (0)
 
 #define SYS_EVENT_SOURCE	"/sys/bus/event_source/devices/"
 /*
@@ -218,14 +214,18 @@ void pmu__generate_fdt_nodes(void *fdt, struct kvm *kvm)
 
 	for (i = 0; i < kvm->nrcpus; i++) {
 		vcpu = kvm->cpus[i];
-		set_pmu_attr(vcpu, &irq, KVM_ARM_VCPU_PMU_V3_IRQ);
+		kvm_set_device_attr(vcpu->vcpu_fd, KVM_ARM_VCPU_PMU_V3_CTRL,
+				    KVM_ARM_VCPU_PMU_V3_IRQ, &irq);
 		/*
 		 * PMU IDs 0-5 are reserved; a positive value means a PMU was
 		 * found.
 		 */
 		if (pmu_id > 0)
-			set_pmu_attr(vcpu, &pmu_id, KVM_ARM_VCPU_PMU_V3_SET_PMU);
-		set_pmu_attr(vcpu, NULL, KVM_ARM_VCPU_PMU_V3_INIT);
+			kvm_set_device_attr(vcpu->vcpu_fd, KVM_ARM_VCPU_PMU_V3_CTRL,
+					    KVM_ARM_VCPU_PMU_V3_SET_PMU, &pmu_id);
+
+		kvm_set_device_attr(vcpu->vcpu_fd, KVM_ARM_VCPU_PMU_V3_CTRL,
+				    KVM_ARM_VCPU_PMU_V3_INIT, NULL);
 	}
 
 	_FDT(fdt_begin_node(fdt, "pmu"));
