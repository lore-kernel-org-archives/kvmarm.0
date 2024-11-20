Received: from out-177.mta0.migadu.com (out-177.mta0.migadu.com [91.218.175.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47553A932
	for <kvmarm@lists.linux.dev>; Wed, 20 Nov 2024 01:00:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732064427; cv=none; b=ti+efJ6P9xq7EkYV8hnsa09G1MR/2fidyDaVKJT6L+PCKJQR80djUbuW7QuCyFzvzswqg4vKAMaMG9f8EA87lO7dAgrVS83HGLRUj823P2G54iLJHR3qp2T82wIKTm2Cl3g1y25YI5Ra4CA1O9lGOvsBsMc2+jz2x7VOnY4Nm4g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732064427; c=relaxed/simple;
	bh=i1HmAha5voIxPPHXBAwywrDS2y07je9dBbIp4uwbSmA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=k1xE5HyNx25dFJNb2bSQHkvu/hAeDea12G0uCIWiYUsyFedoyH71H2kZYMeWDMEbzNf6cK9gVgetp5n/TIaO4Owbksc0aEt885eKQ6GiShD+R2Wa3EbKYw7ATkLL46ARaeDfG4+BtWmzRm34dn5l4CGADZLsmnWG6bjZBR1RNQk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=ADfa6zEp; arc=none smtp.client-ip=91.218.175.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="ADfa6zEp"
Date: Tue, 19 Nov 2024 17:00:13 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1732064423;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=BmY4VqOGQNNjUWhmuGP/BX1u17NfvSpk8rw0PnOTo7I=;
	b=ADfa6zEpsIoEnrTkcw39l7eM3hZwqRUnEL8JA/LXcIWyJ7mZY7HpGvK1gclbIqSGqH/xHB
	ByoOHB30rAikR0c6nGasYY2PCP9j39Z/SE+5me11Zvxzb3FSo+J5GXgW8e1dfWjoZ9eL+p
	fjfZd53iDct7OxhWjybidautvIrbzOQ=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>, Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Mingwei Zhang <mizhang@google.com>,
	Colton Lewis <coltonlewis@google.com>,
	Raghavendra Rao Ananta <rananta@google.com>
Subject: Re: [PATCH v2 2/2] KVM: arm64: Use MDCR_EL2.HPME to evaluate
 overflow of hyp counters
Message-ID: <Zz00nVBgzOE79J6N@linux.dev>
References: <20241120005230.2335682-1-oliver.upton@linux.dev>
 <20241120005230.2335682-3-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241120005230.2335682-3-oliver.upton@linux.dev>
X-Migadu-Flow: FLOW_OUT

On Tue, Nov 19, 2024 at 04:52:30PM -0800, Oliver Upton wrote:
> The 'global enable control' (as it is termed in the architecture) for
> counters reserved by EL2 is MDCR_EL2.HPME. Use that instead of
> PMCR_EL0.E when evaluating the overflow state for hyp counters.
> 
> Change the return value to a bool while at it, which better reflects the
> fact that the overflow state is a shared signal and not a per-counter
> property.

... and the untested garbage award goes to:

> Signed-off-by: Oliver Upton <oliver.upton@linux.dev>

diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
index fb79fa689ae5..456102bc0b55 100644
--- a/arch/arm64/kvm/pmu-emul.c
+++ b/arch/arm64/kvm/pmu-emul.c
@@ -276,6 +276,8 @@ void kvm_pmu_vcpu_destroy(struct kvm_vcpu *vcpu)
 
 static u64 kvm_pmu_hyp_counter_mask(struct kvm_vcpu *vcpu)
 {
+	unsigned int hpmn, n;
+
 	if (!vcpu_has_nv(vcpu))
 		return 0;
 
@@ -308,7 +310,6 @@ bool kvm_pmu_counter_is_hyp(struct kvm_vcpu *vcpu, unsigned int idx)
 u64 kvm_pmu_accessible_counter_mask(struct kvm_vcpu *vcpu)
 {
 	u64 mask = kvm_pmu_implemented_counter_mask(vcpu);
-	u64 hpmn;
 
 	if (!vcpu_has_nv(vcpu) || vcpu_is_el2(vcpu))
 		return mask;
