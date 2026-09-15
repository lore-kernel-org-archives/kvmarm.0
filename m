Received: from mail-wr2-f12.google.com (mail-wr2-f12.google.com [74.125.225.76])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 449A135F5ED
	for <kvmarm@lists.linux.dev>; Tue, 15 Sep 2026 07:41:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.225.76
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789458079; cv=none; b=qbj7mhHAebk1u3zLJVP8cPIx7VdmsVZ305LDl27FqPE5K9Dq/nug0fNiOuaVeVNgSvxQ84hrTZlvVIHqdIeH8eV67gIQsF8l6nS+JvhOv/QL3BTr/pI83qcUrPkCooLEDOzCEj74leWGZa+Kv3INd4EdSlWqDTQ8bkpAn/H+y/c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789458079; c=relaxed/simple;
	bh=kGrKfINzZexDuYxniulIsxOAKrXMWE2mntRu5HUl90I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fBhvUdapvfj4IjJrwWkBgg/AYkbGJlGKq9zV/KhI7Xgoeaj2aQ8QnAuLAm08DMQVyPrGueH522RJQLU6AdOi7KU0Qx8QpJ4arqbvfRNx15zLnTIVmmymrt+iVK86iV6N4M8yJvaEw3M051u5Lwgtvz4sfsH57Cryo8xSFSto/cA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=WT5UpoL5; arc=none smtp.client-ip=74.125.225.76
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="WT5UpoL5"
Received: by mail-wr2-f12.google.com with SMTP id ffacd0b85a97d-48434392b02so2293860f8f.3
        for <kvmarm@lists.linux.dev>; Tue, 15 Sep 2026 00:41:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1789458077; x=1790062877; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=r9GzEG0V2MFSbPgXHqAbp6UbKpY+Or+jzCuC6xa616s=;
        b=WT5UpoL5ofDf1EdoKB69ZrADcN1e4ch52Mjq5IE27xXjgnCl9Q0umTwHkzBUvh2gBa
         JfpntWKQg9+dlNiLOFbOwJWLexV8PsNw5bDwyRzrkrMA0dXQ1kv2bXZWGd+YmCqbxuyC
         waKvhCctTS34cNxT3Gm1Qlni2w1XLmJGo18NUXBkFFCddA7vD5g3W/4Kbtr50dWp0Npb
         GEka0XX+thvhrVUNP35EtagjAHPpBgcemYIemF3LYmoLfjcyd5YnhSyYp3HF7+7HMZd4
         QBBlFJv2b2XCZ1bZDiFsy8j4QjvmGrGIbQpQiv8K8P/5lolfRH9OoVeclWR/izBYCZVc
         J3Hg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789458077; x=1790062877;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=r9GzEG0V2MFSbPgXHqAbp6UbKpY+Or+jzCuC6xa616s=;
        b=ubSHtBXWUPsZG2/y5zavbhg8ry9JvuVANTMUPEp/fBtSa8SJ+NUtX2M0NBoolbb8N1
         UvBAGYjFeK7pUMIoe2UjD9AeyG9aN3R6nBRAFHbT6uLYL6HbMNGFr6NP+h6QIdPV5Pyu
         YaZ+YLX7ekSqfI1PGPZgcLbJiQ8PYyib4kAWC5kCQmwMt1OmHFwpEVFgEZSQVp6dNcxl
         70uLoisX0cZblAW6VaYQrD8XVY1NDByAw49h59eOHzzNSazA+qk2Jb7XgtJJumvAv+50
         Wm/whJfo9XvEIiKokg6irA2gFweUmmnPOAB15k57VR4cSpEJGSDHxmPz8qEGn5+xJBIT
         YqUw==
X-Forwarded-Encrypted: i=1; AKwUvBwsXp+l25VimmHROCpu3L7PuFvuO/MtnDsAXffE/K6TW8mVmR6nhjDZHRcB4YuK3YKdnqYqVzM=@lists.linux.dev
X-Gm-Message-State: AFuF++kOvZYrrj69Agw0KBODARnOVIrUsYHHOn8Tf0hntvH9rsaMZav4
	m4cJc8dXUReB9zEEU70WDA0uoTs5mwiHMhONIb4gA6cacbX/yWCI/z8whgxus3a5aQ==
X-Gm-Gg: AYBFou1XtHjv23zlOoPF2rvKpDTRus5HaqpeQucBpKo360FCRemQmprhYu2bpUOZRcq
	k8Ny0q1s9qVQRiBz+VVEAK6TwcYbj5i/bUBJz4h7qKYimZ6+YNbL+ONxPFN8f267NYw6NS6UG9v
	UbtKQQeTWVHkQsZ5vbhUe2fHZezualXbWOHGvQCBqvWqW0BIlyWY9p5pIxmR5fdjWRn0g9eSsIV
	2cHVf7iBCtmEzovWhmPoEkcvX2j/Ld70F4pLHFsnCaZ1+1nFrc/+/OH9fQLJTSZB4asxQ5Odq3P
	vlgWBeLZTBZt5L2/e6Q2N3aJgcCz5gw3URXK45yuuYYwmEql3oYiDev6YOH62y+FfwbjeEn6RY2
	poCxNB3OdbzlHs57L+DLa7Qv3Zt1XcugKVGsSTFTJOzsG3pawk8nZHnM3/UISMgYQe+yDjgsM/a
	9PNghzhABGGCTOSeWK9El1nuk+9mCV1Zd11Yr4h/TVCzKOm7D+K437y9AkAftdKbvCpYEOIzwHv
	UBBTjM0yXTPtrAHD/cH/+pfU98qX6HfbwKWuUPOxUaZ
X-Received: by 2002:a05:6000:41f0:b0:487:89c:3adf with SMTP id ffacd0b85a97d-487089c3b93mr2625551f8f.11.1789458075963;
        Tue, 15 Sep 2026 00:41:15 -0700 (PDT)
Received: from google.com (135.91.155.104.bc.googleusercontent.com. [104.155.91.135])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-486eb33e020sm34226386f8f.18.2026.09.15.00.41.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Sep 2026 00:41:15 -0700 (PDT)
Date: Tue, 15 Sep 2026 08:41:12 +0100
From: Vincent Donnefort <vdonnefort@google.com>
To: Fuad Tabba <fuad.tabba@linux.dev>
Cc: maz@kernel.org, oupton@kernel.org, kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	catalin.marinas@arm.com, will@kernel.org, joey.gouly@arm.com,
	seiden@linux.ibm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com,
	mark.rutland@arm.com, steven.price@arm.com, qperret@google.com,
	tabba@google.com
Subject: Re: [PATCH v2 2/2] KVM: arm64: Pin the host vCPU before adjusting
 its PC under pKVM
Message-ID: <aqj2mOjeNWJD6726@google.com>
References: <20260915070418.3209779-1-fuad.tabba@linux.dev>
 <20260915070418.3209779-3-fuad.tabba@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260915070418.3209779-3-fuad.tabba@linux.dev>

On Tue, Sep 15, 2026 at 08:04:18AM +0100, Fuad Tabba wrote:
> Under pKVM, a page the host shares with EL2 is mapped at EL2 only while
> it's pinned, and the host vCPU is pinned at its first KVM_RUN.
> KVM_SET_VCPU_EVENTS with ext_dabt_pending reaches __kvm_adjust_pc() at
> EL2 before that, and dereferencing the unmapped host vCPU panics the
> hypervisor. Any process holding /dev/kvm on a pKVM host can trigger it.
> 
> Pin the host vCPU around the adjustment when no hyp vCPU is loaded for
> it. A loaded hyp vCPU implies it's pinned. A pin fails only for memory
> the host never shared, and the request is then dropped like any other
> bad host pointer.
> 
> Fixes: efa1368ba9f4b ("KVM: arm64: Commit exceptions from KVM_SET_VCPU_EVENTS immediately")
> Cc: stable@vger.kernel.org
> Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>
> ---
>  arch/arm64/kvm/hyp/nvhe/hyp-main.c | 19 ++++++++++++++++++-
>  1 file changed, 18 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> index 9a3b92e626adb..4cb7347db2514 100644
> --- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> +++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> @@ -542,8 +542,25 @@ static void handle___pkvm_host_mkyoung_guest(struct kvm_cpu_context *host_ctxt)
>  static void handle___kvm_adjust_pc(struct kvm_cpu_context *host_ctxt)
>  {
>  	DECLARE_REG(struct kvm_vcpu *, vcpu, host_ctxt, 1);
> +	struct pkvm_hyp_vcpu *hyp_vcpu;
> +	struct kvm_vcpu *host_vcpu;
>  
> -	__kvm_adjust_pc(kern_hyp_va(vcpu));
> +	host_vcpu = __get_host_hyp_vcpus(vcpu, &hyp_vcpu);
> +	if (host_vcpu) {
> +		__kvm_adjust_pc(host_vcpu);
> +		return;
> +	}
> +
> +	/*
> +	 * With no hyp vCPU loaded for it, the host vCPU may be unpinned,
> +	 * and so unmapped at EL2: its first run pins it.
> +	 */
> +	host_vcpu = kern_hyp_va(vcpu);
> +	if (hyp_pin_shared_mem(host_vcpu, host_vcpu + 1))
> +		return;
> +
> +	__kvm_adjust_pc(host_vcpu);
> +	hyp_unpin_shared_mem(host_vcpu, host_vcpu + 1);
>  }
>  
>  static void handle___kvm_flush_vm_context(struct kvm_cpu_context *host_ctxt)
> -- 
> 2.39.5
>

Reviewed-by: Vincent Donnefort <vdonnefor@google.com>

-- 
Vincent
