Received: from mail-wr1-f50.google.com (mail-wr1-f50.google.com [209.85.221.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46F05153598
	for <kvmarm@lists.linux.dev>; Mon,  3 Mar 2025 09:47:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740995275; cv=none; b=V7/Mqocxr0FKbCMzvH1/L91HDYH0EEcTrmlP0k5973derJlGMe6sXWZ/5gf7dil7TytZuN/TuY+nQ39RFa0BXQnI9Dav5GgE7e3bHBUvkWwFCcWyAWzmph/k5kgRtWMXW7iww/dxrzCEBA2r/OaYhNIyG5nrwJTs3wnLpVNHvTQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740995275; c=relaxed/simple;
	bh=sSIGCV1NJMucwdo63O6AoWB/mxERMptnXw9CEzSBXF4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jWVzsVcRd31Xv2VO6NdwEs3cCrrxYoAviguvRdWMhYtVEpE5V5vVNMGnf0mVO8mbl/JTDWHNs6RaDZmHKq6WgNslEldGn/ynxVqVnpu6qUbz1unP6mfUU0LM2GLBAtQqBrlIVtqrGm1oIhYNwUn1vmufFHrzPCgsZSQIaWEz1jg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Rup4ZMg2; arc=none smtp.client-ip=209.85.221.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Rup4ZMg2"
Received: by mail-wr1-f50.google.com with SMTP id ffacd0b85a97d-390df0138beso2215834f8f.0
        for <kvmarm@lists.linux.dev>; Mon, 03 Mar 2025 01:47:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1740995272; x=1741600072; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=CKA+Otx0H3SSzEwciVvwkw/A8oV7+p3SzrtXzaI0oPU=;
        b=Rup4ZMg2++mp2G715CwHexjzloWUMZpSesHCDIyOojcvMN3thMV3uhU2qXbyCaq08v
         1DaBlE/qJkYNpl0233Shm07TVRryN4nOyIjVjUxdX6Cmc8qiqmV/pHEhwxa0PCFbLnX9
         d597FRv2CjOAU5Wg6yUSq2q5JCIG7zjwiQJZ7HKN0dEIbrQGKN3XDsr7joybAWqX19Ca
         IFh6sxMVMRrDKAO+14Eks067fMfPeSKJhDuSviS5LxPuFwU93XkiJ61Pi+hAHh5SCkLv
         wCxWHQbP5PF/eFHdXaKctmfNk56BDaAyJa9CmiNQYZAFsjJs6vk1lbreEc7XF5he0B3/
         62bw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740995272; x=1741600072;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CKA+Otx0H3SSzEwciVvwkw/A8oV7+p3SzrtXzaI0oPU=;
        b=ih38+hH7u1SRiV5DDf/Q6oihYJP34RSVwc/i4eL1Bf1Bpx0Vbf58sECVVxcDOE+2PR
         XbHror9vgcS3VFLv5Iuokyxc/0qXUA6WnbqoAgM48njBgaDoR6Q9boX6nKFWP67Mz7YI
         LKHFHiQlAu4LeplHhAUWZ1UrWkw+zAzVahYNneIaUnDo+awZq4QV7zvfBIM8kUW3zznN
         SIDrut+irwctCikrOzCpnzQ+g4r/L0wn7gFRfsGvhZ28OUIpPIM6qe0Gb4UNGxKfVSk5
         i337YruQxmGXgft2uNMV1n3ohXadvJSSddOKlz0I/KAYByvMYs2UfHZAqvePm3xz+6Ue
         T8sA==
X-Forwarded-Encrypted: i=1; AJvYcCWBDTdEBbJdYJzZRl5F79AouyDc2nChKb+EohfzFTePpN9RWFiLlrHyaveGWbEfu4U3P+JNlxU=@lists.linux.dev
X-Gm-Message-State: AOJu0Yxu2tYBWmr/0qH7OW9ezkuErmFAuOkeQ3ngz+TLEaFSXIc8WfM8
	aoRIO022HZw2dVu2pcBnMudMkJtc5PoYmxfqkPfpxbWeqGmEpHKK7GlB1a1pmA==
X-Gm-Gg: ASbGncsncxqxdv8JOpX4dcFSx8q36tGrZSJz4UMG70UAtplW36DUoicXlc726EOHjIp
	Rmad3CUsJ5ZNrPiUkJbtO7cZ/gMjwNaYLSqAY241nMm9xkm94t9kT8KoZ3JmKHxDFyuKB+uZ543
	igv34mQ/l0vNEdqtd+Npk3H9o5PtB1KWOjvW9CNYVazDg7SaX71q2uQr1CGiaxIxJrs4Bb1MASB
	UbcIq8JWjgxE2wkW+WOPnCJUTUTLEcuFcjPUU1I0Ek5fNydg2toi4s7/6fD/21tmtXszD9W2mY2
	IVekIEq09cyLKWKup3nBxdBXEOJihWMW497POMscC+j8IJ8zzoROJK3NG6Ng/7qV3AAOkVt9dzm
	7A35MVKSKq6VM
X-Google-Smtp-Source: AGHT+IGZadExtmq2ZKN18m9L/PK1JThIrBLdkTgdsuEaaAEPwP3+f2+949dpjiKHv0jHI9BGV6sDlw==
X-Received: by 2002:a05:6000:2ce:b0:390:f9d0:5e3 with SMTP id ffacd0b85a97d-390f9d0075cmr4936619f8f.1.1740995272497;
        Mon, 03 Mar 2025 01:47:52 -0800 (PST)
Received: from google.com (105.168.195.35.bc.googleusercontent.com. [35.195.168.105])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-390e4796051sm14170400f8f.12.2025.03.03.01.47.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Mar 2025 01:47:52 -0800 (PST)
Date: Mon, 3 Mar 2025 09:47:48 +0000
From: Vincent Donnefort <vdonnefort@google.com>
To: Quentin Perret <qperret@google.com>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/6] KVM: arm64: Move hyp state to hyp_vmemmap
Message-ID: <Z8V6xOVCPp7OOX6g@google.com>
References: <20250227003310.367350-1-qperret@google.com>
 <20250227003310.367350-5-qperret@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250227003310.367350-5-qperret@google.com>

[...]

> diff --git a/arch/arm64/kvm/hyp/nvhe/setup.c b/arch/arm64/kvm/hyp/nvhe/setup.c
> index 1a414288fe8c..955c431af5d0 100644
> --- a/arch/arm64/kvm/hyp/nvhe/setup.c
> +++ b/arch/arm64/kvm/hyp/nvhe/setup.c
> @@ -194,16 +194,20 @@ static int fix_host_ownership_walker(const struct kvm_pgtable_visit_ctx *ctx,
>  
>  	/*
>  	 * Adjust the host stage-2 mappings to match the ownership attributes
> -	 * configured in the hypervisor stage-1.
> +	 * configured in the hypervisor stage-1, and make sure to propagate them
> +	 * to the hyp_vmemmap state.
>  	 */
>  	state = pkvm_getstate(kvm_pgtable_hyp_pte_prot(ctx->old));
>  	switch (state) {
>  	case PKVM_PAGE_OWNED:
> +		set_hyp_state(phys, PKVM_PAGE_OWNED);
>  		return host_stage2_set_owner_locked(phys, PAGE_SIZE, PKVM_ID_HYP);
>  	case PKVM_PAGE_SHARED_OWNED:
> +		set_hyp_state(phys, PKVM_PAGE_SHARED_OWNED);
>  		set_host_state(phys, PKVM_PAGE_SHARED_BORROWED);
>  		break;
>  	case PKVM_PAGE_SHARED_BORROWED:
> +		set_hyp_state(phys, PKVM_PAGE_SHARED_BORROWED);
>  		set_host_state(phys, PKVM_PAGE_SHARED_OWNED);
>  		break;
>  	default:

Are the SHARED_OWNED/SHARED_BORROWED still relevant since the introduction of
"KVM: arm64: Don't map 'kvm_vgic_global_state' at EL2 with pKVM"? It doesn't
seem we have any !OWNED pages in the hyp anymore at setup, do we?

> -- 
> 2.48.1.658.g4767266eb4-goog
> 
