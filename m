Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73E232641F4
	for <kvmarm@lists.linux.dev>; Thu, 13 Mar 2025 09:13:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741857234; cv=none; b=EFAObQ+nNCBx+Ii168nNxYB0I2TeCAklKuMhOZGt0FuyOJGoK18Q5sX75mzQOIHKUPm70UTXZ0S7B9kc1UFL5GQsx3yogV2cmHSQWjgb+2fCwwZG7fXdv2nquDCBBe4ZPElsumqIVSX1ueENBXMTUjEJSyibkLLIrIqeI8AAZXg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741857234; c=relaxed/simple;
	bh=ydB9bTeNot+OE1Xz0uP/spOJpO+hHXQWfxo/NKrFah0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=i6am8Bi1KeYTO/Ssw17q6lafJn9oAZeu2nEATSSToUyi9HyiEu1TUdCuJDXCLkBaYyavk9q5x3eF0VJIJcL1CemrmYVhGgOSItN9drTwOOPoLVtAaT8tnrBefiOcZvBYb152MQXMLLqJTsJZVjx8RYSeKiSbzku0bBdP3q5ulKI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=No8IbcU9; arc=none smtp.client-ip=209.85.128.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="No8IbcU9"
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-43cec5cd73bso4017635e9.3
        for <kvmarm@lists.linux.dev>; Thu, 13 Mar 2025 02:13:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1741857230; x=1742462030; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=A1vA9sHgurzlxpNTPQ3LIOp8IB6esizGYotCRKHRMvg=;
        b=No8IbcU9wYtxSYykeJHH9wVY7+UPIdYkUw2s7Mqq2ODsIPRDWjaDMrPJXNQSSOrAZo
         HyB5PiGgeYtk5aPhYiPgJKGq3SOZYuxVIiaK34FBomObBKakqEAcW0PMCoyRvjLY7i8v
         KPppIz1MxV/ngIKFgMFkWwGX66uNkBSdiyZ6LbTd/bj5cdTo2UfejAJ0pUD4LwI29yhh
         oYfkGUaYI0TmSXBU3KWHlYoNwWP6TO6NQwDz9NQj3W8XRvrS+Wa549yocRUYbjl5dYvG
         yzbXbFMYMtoF7jMOL7o8/9NL1VCKyMmN4rY3H9/OkJDjkwLr1J2F0iaMtSLaEJDvK/de
         aWWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741857230; x=1742462030;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=A1vA9sHgurzlxpNTPQ3LIOp8IB6esizGYotCRKHRMvg=;
        b=CPcLqHyNzuK8P7z9phWc5YI7JrIAgdEeE+wY6mUIvf/pUgRNxnGPE9xYanFeUdT8K3
         PdKNDec8CQeP+Y7teB1J0gTviuhba28XUN9j5VsRmqBXVcpyDumPQPSnamHoWjygL6Fv
         Qe3sq0TtIBMQ7+oBrhpk5RoFBsU/A1DcX4P+iGhsMaZQDfATcrHr+4MVjmcAhTQr/HUS
         tBtebbJi9nLAQqZJvG2PZ+d8OlJlCGticau1JzFJftyPZzBLu84Fsf4Kxn/Eideuu3oK
         NWHDYWucnLq0+31058jR6Yq1cGVm4kkDKAogSjgioK0GJRdFh7J6lEtwMEbUNMaFSWMr
         6Gjw==
X-Forwarded-Encrypted: i=1; AJvYcCVgUgERmsIdfXkR4LDphtTywTSWDakyaUAxkOv0MClNKStv46IxbumTxb3/uDCyfdyJV1O/X0U=@lists.linux.dev
X-Gm-Message-State: AOJu0Yy8NwrywnCTc9NHsW8LeGdb1yJfxDOaQc+xdZ8Afr8MS9rCMYar
	tK1JWYITCVga0NpqJU9ZP0nSROzUTjTnTr//yDkQtr8gdq7EmIFPJj3eIExqxA==
X-Gm-Gg: ASbGnctr2qGwa+P9ZjEP35/XhX2tPkGrWA3lBQ259gWG9TsshPbH53GgmOYRzIjenEo
	nUIYeCO3P2nCF0Fsy93dknBaE2i6ZIX2zJUlqQHSKH7CMaNR5fwxHSsgxg5N8R+PdQYd0j73ucF
	lAaOtlES+1rP+Vty4TGJR7VLTlFWtqNDbDZgWEaLjNiDFX3T/geEmScz32xwp7SD9YfP4ciGmXL
	yYAytfT/pA9fc4rDL3eBxngafwVicS9Z1W1steH0kX14Y1/gMFj0qpnHBbXkZ0ZRi0XfWVTRF4b
	sZTziVzpSohpXZzhCE7p7RgeaAnDmbzmnmVSuTFB5z2PULNMXO1GqFWzaiE4y1/RFF4cqHUEPZq
	cockfxZWep9GX
X-Google-Smtp-Source: AGHT+IE8nhdSI8oCc7HhvHZ8FNICrr82pSWj5KiIjJGm0gYMIEOr9ifulYDK2iTUrARjY9lcII5V5Q==
X-Received: by 2002:a05:600c:3591:b0:43c:f16a:641e with SMTP id 5b1f17b1804b1-43cf16a6b0cmr139569915e9.6.1741857230356;
        Thu, 13 Mar 2025 02:13:50 -0700 (PDT)
Received: from google.com (105.168.195.35.bc.googleusercontent.com. [35.195.168.105])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-43d188affdbsm13931305e9.7.2025.03.13.02.13.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Mar 2025 02:13:49 -0700 (PDT)
Date: Thu, 13 Mar 2025 09:13:45 +0000
From: Vincent Donnefort <vdonnefort@google.com>
To: Marc Zyngier <maz@kernel.org>
Cc: oliver.upton@linux.dev, joey.gouly@arm.com, suzuki.poulose@arm.com,
	yuzenghui@huawei.com, catalin.marinas@arm.com, will@kernel.org,
	qperret@google.com, linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org,
	kernel-team@android.com
Subject: Re: [PATCH v3 2/3] KVM: arm64: Distinct pKVM teardown memcache for
 stage-2
Message-ID: <Z9KhybW0J2WIX1eU@google.com>
References: <20250307113411.469018-1-vdonnefort@google.com>
 <20250307113411.469018-3-vdonnefort@google.com>
 <87plim7hgc.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87plim7hgc.wl-maz@kernel.org>

On Wed, Mar 12, 2025 at 08:59:15AM +0000, Marc Zyngier wrote:
> On Fri, 07 Mar 2025 11:34:10 +0000,
> Vincent Donnefort <vdonnefort@google.com> wrote:
> > 
> > In order to account for memory dedicated to the stage-2 page-tables, use
> > a separated memcache when tearing down the VM.
> > 
> > Signed-off-by: Vincent Donnefort <vdonnefort@google.com>
> > 
> > diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> > index 12691ae23d4c..ace3969e8106 100644
> > --- a/arch/arm64/include/asm/kvm_host.h
> > +++ b/arch/arm64/include/asm/kvm_host.h
> > @@ -246,6 +246,7 @@ typedef unsigned int pkvm_handle_t;
> >  struct kvm_protected_vm {
> >  	pkvm_handle_t handle;
> >  	struct kvm_hyp_memcache teardown_mc;
> > +	struct kvm_hyp_memcache stage2_teardown_mc;
> >  	bool enabled;
> >  };
> >  
> > diff --git a/arch/arm64/kvm/hyp/nvhe/pkvm.c b/arch/arm64/kvm/hyp/nvhe/pkvm.c
> > index 3927fe52a3dd..15f8d5315959 100644
> > --- a/arch/arm64/kvm/hyp/nvhe/pkvm.c
> > +++ b/arch/arm64/kvm/hyp/nvhe/pkvm.c
> > @@ -678,7 +678,7 @@ teardown_donated_memory(struct kvm_hyp_memcache *mc, void *addr, size_t size)
> >  
> >  int __pkvm_teardown_vm(pkvm_handle_t handle)
> >  {
> > -	struct kvm_hyp_memcache *mc;
> > +	struct kvm_hyp_memcache *mc, *stage2_mc;
> >  	struct pkvm_hyp_vm *hyp_vm;
> >  	struct kvm *host_kvm;
> >  	unsigned int idx;
> > @@ -706,7 +706,8 @@ int __pkvm_teardown_vm(pkvm_handle_t handle)
> >  
> >  	/* Reclaim guest pages (including page-table pages) */
> >  	mc = &host_kvm->arch.pkvm.teardown_mc;
> > -	reclaim_guest_pages(hyp_vm, mc);
> > +	stage2_mc = &host_kvm->arch.pkvm.stage2_teardown_mc;
> > +	reclaim_guest_pages(hyp_vm, stage2_mc);
> 
> This looks odd. What counts as stage-2 pages here? Or is it that
> reclaim_guest_pages() is very badly named?

Yes, this is a naming issue here. How about 

  reclaim_pgtable_pages(hyp_vm, stage2_mc);

Then I can probably drop that /* Push the metadata pages to the teardown
memcache */  comment as it is clear what is pgtable and what is meta-data?

> 
> Thanks,
> 
> 	M.
> 
> -- 
> Without deviation from the norm, progress is not possible.
