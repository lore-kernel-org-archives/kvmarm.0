Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AE9C32CCB9
	for <kvmarm@lists.linux.dev>; Wed,  9 Sep 2026 13:00:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788958817; cv=none; b=Pvempw6nVD25/ejVqMCk6gGBgPxp+YZoUBvPufuMPbpCb5FDP6hRs6Ymia5W8735yt+A/+w/R5To3xZ73ZBrt8OgzaWV/4sDsZsDsKSVZl5Xgb5xgib2ZeLH8/Hhhl+r7M//rleR6ru7hs+p5KEd7xHqhRyg3lFcpfwnCvngoyM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788958817; c=relaxed/simple;
	bh=COoomdSG2FlqAOqhScp/Ic2bx4OeDuloT0b59UMRbdY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type:Content-Disposition; b=K7edIsdE+ZvdqCn4lotMVsSje4uQk9jIAC2bOGHinmVTVWXUTu4fKBTUCpTjBpk7aah3s/HsOaddGQ3SjrARm8q6sxNA8RSbO5iiGQaYNRLZs+SCBZ5mRaV/gQCcVM67L0QA1IDazeV0pLZAbDSHXOLpmUyf+942jRCWJw4Jb+Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=s58mQgbn; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="s58mQgbn"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 52BEA1691;
	Wed,  9 Sep 2026 06:00:11 -0700 (PDT)
Received: from LeoBrasDK.cambridge.arm.com (LeoBrasDK.cambridge.arm.com [10.2.212.21])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 545113F7B4;
	Wed,  9 Sep 2026 06:00:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1788958815; bh=COoomdSG2FlqAOqhScp/Ic2bx4OeDuloT0b59UMRbdY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=s58mQgbnP66N0tSsR0ISNWZsvL2/PwI5BHGINryKYJdKCuLFiMKLHOvStA5xDsP4h
	 HqJj8VAURT88yoH+vmDsR5Yo4Ea99qNf7dbdm+V55Qia3YuxFhOXOL8gqZ/CPX+7VP
	 LVy3xukrI30eMDBzoMp9lI45Uq4J0Wnq6ZUaoJPQ=
From: Leonardo Bras <leo.bras@arm.com>
To: Mark Brown <broonie@kernel.org>
Cc: Leonardo Bras <leo.bras@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Shuah Khan <shuah@kernel.org>,
	Oliver Upton <oupton@kernel.org>,
	Fuad Tabba <fuad.tabba@linux.dev>,
	Peter Maydell <peter.maydell@linaro.org>,
	Wei-Lin Chang <weilin.chang@arm.com>,
	Yao Yuan <yaoyuan@linux.alibaba.com>,
	linux-arm-kernel@lists.infradead.org,
	linux-doc@vger.kernel.org,
	kvmarm@lists.linux.dev,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v20 07/14] KVM: arm64: Forward GCS exceptions to nested guests
Date: Wed,  9 Sep 2026 14:00:06 +0100
Message-ID: <aqFYVnIgvXGXzHk7@LeoBrasDK>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260901-arm64-gcs-v20-7-f31750bdfadb@kernel.org>
References: <20260901-arm64-gcs-v20-0-f31750bdfadb@kernel.org> <20260901-arm64-gcs-v20-7-f31750bdfadb@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On Tue, Sep 01, 2026 at 10:47:05PM +0100, Mark Brown wrote:
> For nested guests where HFGITR_EL2.nGCSSTR_EL1 is clear or when there are
> L2 GCS data check exceptions we need to forward the exception to the guest.
> Add handling to do so.
> 
> Signed-off-by: Mark Brown <broonie@kernel.org>
> ---
>  arch/arm64/kvm/handle_exit.c | 18 +++++++++++++++---
>  1 file changed, 15 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/arm64/kvm/handle_exit.c b/arch/arm64/kvm/handle_exit.c
> index db37678dcb05..a8198e96fcb4 100644
> --- a/arch/arm64/kvm/handle_exit.c
> +++ b/arch/arm64/kvm/handle_exit.c
> @@ -304,12 +304,24 @@ static int handle_svc(struct kvm_vcpu *vcpu)
>  	return 1;
>  }
>  
> +/*
> + * We might get GCS exceptions that need to be forwarded to the
> + * hypervisor when a nested guest has HFGITR_EL2.nGCSSTR_EL1 clear, or
> + * for a GCS data check exception for a L2 guest.
> + */
>  static int kvm_handle_gcs(struct kvm_vcpu *vcpu)
>  {
> -	/* We don't expect GCS, so treat it with contempt */
> -	if (kvm_has_feat(vcpu->kvm, ID_AA64PFR1_EL1, GCS, IMP))
> -		WARN_ON_ONCE(1);
> +	if (!kvm_has_gcs(vcpu->kvm)) {
> +		kvm_inject_undefined(vcpu);
> +		return 1;
> +	}
>  
> +	if (vcpu_has_nv(vcpu)) {
> +		kvm_inject_nested_sync(vcpu, kvm_vcpu_get_esr(vcpu));
> +		return 1;
> +	}
> +
> +	WARN_ON_ONCE(1);
>  	kvm_inject_undefined(vcpu);
>  	return 1;
>  }

Oh handle_gcs, if kvm_has_gcs() && kvm_has_nv() -> Inject synchronous 
exception. Makes sense.

(it kept bothering me that the !gcs and the gcs case do the same thing, 
except for a warn_once. So I thougt on suggesting:

+	if (!kvm_has_gcs(vcpu->kvm))
+		goto inject_undef;
[...]
+	WARN_ON_ONCE(1);
+inject_undef:
>       kvm_inject_undefined(vcpu);
>       return 1;

But after it was done it did not look better.)


So, FWIW:
Reviewed-by: Leonardo Bras <leo.bras@arm.com>

Thanks!
Leo
