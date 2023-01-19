Received: from out0.migadu.com (out0.migadu.com [94.23.1.103])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32600B43E;
	Thu, 19 Jan 2023 19:46:23 +0000 (UTC)
Date: Thu, 19 Jan 2023 19:46:16 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1674157581;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Ny5pbFcUDicEKi2kQlKMNoopMQxdvl4TAC0NXH0FWZc=;
	b=lQclnKO49SxNR+ip+srDOZF4ojQRaxsKsDP61gap4s4i2v1bZmFg0XsAF39r6FsaTjUS3V
	V6lZh7A2hzM1Jefk9R1hMMoYohp4/1i8UM7GYMSopzrNUMbfTn5BqZ8vkBY4ajH8SrOu8l
	7N7ix/3EhvbqAfTJqoe1qdMbq6iKJKE=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Akihiko Odaki <akihiko.odaki@daynix.com>
Cc: Mark Brown <broonie@kernel.org>, Marc Zyngier <maz@kernel.org>,
	linux-kernel@vger.kernel.org, kvmarm@lists.linux.dev,
	kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org,
	Mathieu Poirier <mathieu.poirier@linaro.org>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	James Morse <james.morse@arm.com>, Will Deacon <will@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>, asahi@lists.linux.dev,
	Alyssa Rosenzweig <alyssa@rosenzweig.io>,
	Sven Peter <sven@svenpeter.dev>, Hector Martin <marcan@marcan.st>
Subject: Re: [PATCH v7 7/7] KVM: arm64: Normalize cache configuration
Message-ID: <Y8meCFkrVXurXlTk@google.com>
References: <20230112023852.42012-1-akihiko.odaki@daynix.com>
 <20230112023852.42012-8-akihiko.odaki@daynix.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230112023852.42012-8-akihiko.odaki@daynix.com>
X-Migadu-Flow: FLOW_OUT

Hi Akihiko,

On Thu, Jan 12, 2023 at 11:38:52AM +0900, Akihiko Odaki wrote:
> Before this change, the cache configuration of the physical CPU was
> exposed to vcpus. This is problematic because the cache configuration a
> vcpu sees varies when it migrates between vcpus with different cache
> configurations.
> 
> Fabricate cache configuration from the sanitized value, which holds the
> CTR_EL0 value the userspace sees regardless of which physical CPU it
> resides on.
> 
> CLIDR_EL1 and CCSIDR_EL1 are now writable from the userspace so that
> the VMM can restore the values saved with the old kernel.
> 
> Suggested-by: Marc Zyngier <maz@kernel.org>
> Signed-off-by: Akihiko Odaki <akihiko.odaki@daynix.com>

I needed to squash in the patch below to get all of this working.
Writing back the value read for a given cache level was failing, which I
caught with the get-reg-list selftest.

Pushed the result here if you want to have a look:

  https://github.com/oupton/linux/tree/kvm-arm64/virtual-cache-geometry

--
Thanks,
Oliver

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 459e6d358dab..b6228f7d1d8d 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -148,17 +148,19 @@ static u32 get_ccsidr(struct kvm_vcpu *vcpu, u32 csselr)
 
 static int set_ccsidr(struct kvm_vcpu *vcpu, u32 csselr, u32 val)
 {
-	u8 line_size = FIELD_GET(CCSIDR_EL1_LineSize, val);
+	u8 line_size = SYS_FIELD_GET(CCSIDR_EL1, LineSize, val);
+	u32 cur = get_ccsidr(vcpu, csselr);
+	u8 min_line_size = SYS_FIELD_GET(CCSIDR_EL1, LineSize, cur);
 	u32 *ccsidr = vcpu->arch.ccsidr;
 	u32 i;
 
-	if ((val & CCSIDR_EL1_RES0) || line_size < get_min_cache_line_size(csselr))
+	if (cur == val)
+		return 0;
+
+	if ((val & CCSIDR_EL1_RES0) || line_size < min_line_size)
 		return -EINVAL;
 
 	if (!ccsidr) {
-		if (val == get_ccsidr(vcpu, csselr))
-			return 0;
-
 		ccsidr = kmalloc_array(CSSELR_MAX, sizeof(u32), GFP_KERNEL);
 		if (!ccsidr)
 			return -ENOMEM;
