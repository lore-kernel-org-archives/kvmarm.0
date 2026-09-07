Received: from mail-ej1-f52.google.com (mail-ej1-f52.google.com [209.85.218.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE6CF456DF3
	for <kvmarm@lists.linux.dev>; Mon,  7 Sep 2026 10:26:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788776811; cv=none; b=oXY7kXbcXx7kVq1ykhc9nszvYqsAMgg7DMjCd92k8gV81VwUpB/g3WlGji28DuRW03WmE42Y8/TkMgGw663fpn7XD31iaiBqZwvGtxt7S6siebJSSOwXwUj9bdG1pZcPxhwu1G0PhXjn5SEUwPtJnKBBOUcvOYXqUjV0LeaI8ME=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788776811; c=relaxed/simple;
	bh=p5HmnQvWHOjyvcUny5gt5xYv8IKsXutNKR2VnOqh4y4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NKKYIZTsTYUicsVKyd9jHP0q7+eApTKgrX/IAJSe5Lsxt6aQgug+Jfs3FCPzfJSFLIjORoslUE3mCzDoJaGo8qV2thxMGf4wgkvNGGmVoiGPtUv4x4V/ZUJU8nxXn5jAYtluiNLoa5WuqQItI2WZljBd7MbxFF2znNZFDmkEsS8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=NB1T7V5g; arc=none smtp.client-ip=209.85.218.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="NB1T7V5g"
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-c253425b253so475450166b.1
        for <kvmarm@lists.linux.dev>; Mon, 07 Sep 2026 03:26:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1788776808; x=1789381608; darn=lists.linux.dev;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=zLowNBOJqUu3Tto51bSyxZ9lkn4QcoPSK7MWliyNp/8=;
        b=NB1T7V5gwu3eMV58g4B9q5UKfgvG7nA7+w7FA8lPOf439Qo7m1hIvsfOkaVUqtruIe
         io12/cZbMef+Ep0CkjnEXNeXLsXQtgNVkvXtQdY/zIjpXQM4ZeTiozd1yJfZPLiN8f4Y
         QnSe29bEfyUSwtWZ/UWAthIk1W7nJsEfrtHwPcAH6PBXGIqrGr/7efc38x7gKSIMLj9z
         YXIZmkIfvuJfZ4YqiTexPGxz4ECb3PgS9Xvxvcjo0yHVVJ4/jDdYsacJCwBFG8S6lRWc
         leIRUPrAJfUlQRALlpLQUJlxYu1X3DrpJPKNU1br4czVMMKatpXXHKReYI1jedITVtOp
         VfWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788776808; x=1789381608;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=zLowNBOJqUu3Tto51bSyxZ9lkn4QcoPSK7MWliyNp/8=;
        b=Z8ScgBKzTveFHCd1/sDUERp8cZtKMDoSuNLJp04AVbErAv1VRvbHqkCfUAAcOAO2fF
         H86evhl0tOkbkYp5G9/IMunITjZ1/Jx7At0TZhG8jfK1nMSq8BuTtqWR9NbPzPja2bTw
         mXqFY6QKQudlC8pIaeLxZ9DQLMK7oYzeknnxyGk19Xxx5qRQQL4GJAX4aNi4H/9RtJjD
         2XgYQdCL4ug5i3QizWKgGTTXDCL+2hUduajgCHwINe4pxdw2Q2KQMPjUzDhlq/MFHPpL
         Br4eOYm3NBghbgx2zFnfuz681PKiN6EnFOM7USo63G2Ds4qcZFSSKqsusQ3/lyEQOr93
         Ui9g==
X-Gm-Message-State: AFuF++m3KJDwt2XzIL3t9evu7r1X5TbxRrKTwBbSThBVG09RgVAxuT2W
	WZzFdJWuyH/+B/rzdsFDZqIMIoAnWWOTSdtYheuNUSkIKtKJJFqhuWJfcSHiKTvzcQ==
X-Gm-Gg: AYBFou1LnHTbs4U7ITfv+Bevpiq6y0KEaA5tbwBfGp8OoVgRZZKWH6c9DGZYweuA4WF
	ajm32oNE0qIvoexul3WzA5lSkmGv4WQZ43pYfqv7F1oFxsdFlYYv5RshqIJ7jTKv0l2vI71CiB4
	m1nm1k8crHbE7UM5WuHfQ7L+oL2GPSPbGbtDMd3YbJK9Km93ZCuwDOFIYSNHCBNvtxJ4yZcay/a
	YLOkMdfV8vrtl56w58s0aC6GtLRWp/uBVwCCK0gAy+WHiw9Nc9ea3NAEqHprKs3YiQIZd51va1y
	2UNvXJONltcxDku4ZJ1+Go6vZmvAg+p/A1UiOhJKwnXive3RkIY9v4MJx5tUqOn/Ce4hV6feIiT
	9VGA3Lb/EiH0vX1CCVT2xM4ISMwc2Y1nHMRZM5+qCa7d0b5i+qW5m8H8bKYShFW8edwzWizTA1F
	xLbq0vhOorhg3tSqJ+7pFEY1kO4vn4+mDf/Cahxuup3WCABnDoCKn6hJGDkF2ek3nbvlsXmWucF
	9vIhvx3buK4Hhqc0m316rF7/h7TiFCV
X-Received: by 2002:a17:906:c14c:b0:c26:19de:9ae0 with SMTP id a640c23a62f3a-c2619dea7d1mr676057666b.31.1788776807270;
        Mon, 07 Sep 2026 03:26:47 -0700 (PDT)
Received: from google.com (135.91.155.104.bc.googleusercontent.com. [104.155.91.135])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c260d5277e6sm439479366b.27.2026.09.07.03.26.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Sep 2026 03:26:46 -0700 (PDT)
Date: Mon, 7 Sep 2026 11:26:43 +0100
From: Vincent Donnefort <vdonnefort@google.com>
To: sashiko-reviews@lists.linux.dev
Cc: kvmarm@lists.linux.dev, Oliver Upton <oupton@kernel.org>,
	Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH 19/20] KVM: arm64: Raise PKVM_HYP_REQ_SPLIT on guest to
 host sharing
Message-ID: <ap6RY3HDxaiVQTpy@google.com>
References: <20260803100904.3563942-1-vdonnefort@google.com>
 <20260803100904.3563942-20-vdonnefort@google.com>
 <20260803110203.0EB441F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260803110203.0EB441F000E9@smtp.kernel.org>

On Mon, Aug 03, 2026 at 11:02:02AM +0000, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 1 potential issue(s) to consider:
> - [High] Concurrent MEM_SHARE or MEM_UNSHARE on the same huge block causes the VM to be terminated with -EINVAL.
> --
> 
> --- Patch [19]: [PATCH 19/20] KVM: arm64: Raise PKVM_HYP_REQ_SPLIT on guest to host sharing ---
> commit 267c394d1b60753f90e3da486356d60c47b19643
> Author: Vincent Donnefort <vdonnefort@google.com>
> 
> KVM: arm64: Raise PKVM_HYP_REQ_SPLIT on guest to host sharing
> 
> Pages shared by the guest with the host are annotated into the guest
> stage-2. If the shared page is backed by a huge mapping, we need to
> split it first.
> 
> > diff --git a/arch/arm64/kvm/hyp/nvhe/pkvm.c b/arch/arm64/kvm/hyp/nvhe/pkvm.c
> > index 3b8e95b83bf45..57f4303aede10 100644
> > --- a/arch/arm64/kvm/hyp/nvhe/pkvm.c
> > +++ b/arch/arm64/kvm/hyp/nvhe/pkvm.c
> 
> [ ... ]
> 
> > -static void pkvm_memunshare_call(u64 *ret, struct kvm_vcpu *vcpu)
> > +static bool pkvm_memunshare_call(u64 *ret, struct kvm_vcpu *vcpu, u64 *exit_code)
> >  {
> >  	struct pkvm_hyp_vcpu *hyp_vcpu;
> >  	u64 ipa = smccc_get_arg1(vcpu);
> > +	u64 gfn = hyp_phys_to_pfn(ipa);
> >  
> >  	if (!PAGE_ALIGNED(ipa))
> > -		return;
> > +		goto out_guest;
> >  
> >  	hyp_vcpu = container_of(vcpu, struct pkvm_hyp_vcpu, vcpu);
> > -	if (!__pkvm_guest_unshare_host(hyp_vcpu, hyp_phys_to_pfn(ipa), 1))
> > +	switch (__pkvm_guest_unshare_host(hyp_vcpu, gfn, 1)) {
> > +	case 0:
> >  		ret[0] = SMCCC_RET_SUCCESS;
> > +		goto out_guest;
> > +	case -E2BIG:
> > +		*exit_code = pkvm_request_split(hyp_vcpu, gfn, 1);
> > +		goto out_host;
> 
> [Severity: High]
> Does this code handle concurrent MEM_UNSHARE or MEM_SHARE requests on the
> same huge block correctly?
> 
> If two guest vCPUs concurrently execute HVC MEM_SHARE (or MEM_UNSHARE) on
> different pages within the same PMD_SIZE stage-2 block, both vCPUs would
> receive -E2BIG from get_valid_guest_pte() in EL2 and exit to the host with
> PKVM_HYP_REQ_SPLIT.
> 
> Host thread A successfully handles the split request, splitting the block in
> EL2 and the host's pkvm_mappings tree.
> 
> When host thread B handles the split request for the same block, it looks up
> the mapping in __pkvm_pgtable_stage2_split():
> 
> arch/arm64/kvm/pkvm.c:__pkvm_pgtable_stage2_split() {
>     ...
> 	mapping = pkvm_mapping_iter_first(&pgt->pkvm_mappings, ipa,
> 					  ipa + size - 1);
> 	if (!pkvm_mapping_can_split(mapping)) {
> 		ret = -EINVAL;
> 		goto unlock_mmu;
> 	}
>     ...
> }
> 
> Because it finds a PAGE_SIZE mapping (since it was just split),
> pkvm_mapping_can_split() returns false, causing __pkvm_pgtable_stage2_split()
> to return -EINVAL instead of returning 0 (success) or -EAGAIN to retry.
> 
> This -EINVAL error propagates up through pkvm_hyp_req_handle_split() and
> handle_exit(), returning -EINVAL to userspace from KVM_RUN, which causes the
> VMM to terminate the VM.
> 
> > +	}
> > +
> > +out_guest:
> > +	return true;
> > +out_host:
> > +	return false;
> >  }
> 
> -- 
> Sashiko AI review · https://sashiko.dev/#/patchset/20260803100904.3563942-1-vdonnefort@google.com?part=19

Hum, that is a good point. __pkvm_pgtable_stage2_split() shouldn't return an
error if the mapping is already PAGE_SIZE.

-- 
Vincent
