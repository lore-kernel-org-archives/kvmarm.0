Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAF8773195
	for <kvmarm@lists.linux.dev>; Tue,  6 Feb 2024 03:23:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707189808; cv=none; b=dc2UcMD7QGlz0zC21qDqsxCkDnphaMH4njpU7ecpOd4OowSJ4YFVR34cSuVKzY9lrriQHbJ/k4O+GRnmcng4Vr7u93MKG4rCuAY9Mnt0oPFQCBGYKSQKfKJvMw/rvG8w6ZugClRUQAfkVVKF9U88jcllDruZFvXZDmbMnuz5K5I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707189808; c=relaxed/simple;
	bh=UDDsuWPSW+daCIoSbgJFsD9FLwQJiP9p3QmcFSmkrL8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=NX7ysuCaojgNOHVRX1VXAji9z+dpcvpGSlA08GLVIPl6iY+GbapnWlaHYjlUa88hhz3JuhAn1If+8qobjCNNHizY5q/hOIXa3o8HfbKojD6xmCQ7ztmjwGiHXihPTPLWkBxz7PzEaJFsucGcHNSIVi/Bo+qY0w9ncFncf/2G890=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=IPp+JQSL; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="IPp+JQSL"
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-5ce97b87716so437273a12.0
        for <kvmarm@lists.linux.dev>; Mon, 05 Feb 2024 19:23:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1707189806; x=1707794606; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=8R1ERRzsuzMxbDKKjiu7D3XS5GbZ63vNtb/cSGihhOs=;
        b=IPp+JQSL/ZA+CUEx7LrmhZsaSiuojcxFdXs4Y6DIA5TTBAPEx4gMK/2kjWihTK2o2p
         jRUtSwU+m2DAbT0wLEZ7PjeEJKT/HnThtWJyTk2iIpZqK5tBRXi7kpLPaRpMx8LMAHZh
         sdLu2REfx7+rjv6MoMjt3/wxRVM0JtcZdauY6WpufU5WidJd09IrbBM1K4AOstKKgCPJ
         ReCa+BpPQfHkEdo0xQ9Rbq9uakU7BEk7IyljY+vwGDP6r/zkCiJmTRfSHHQTSOwofGFr
         nFkTD5TywI7BiUbaG9FGk8UJMHi3nwMulNhNTgBSOffWG8NEbahbPkE2ZkdbyKI9bH3T
         gRZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707189806; x=1707794606;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=8R1ERRzsuzMxbDKKjiu7D3XS5GbZ63vNtb/cSGihhOs=;
        b=B22mClv1ifAWeOwgMQmnmiZiN0izpNLJTyDMjJVG3gUd7MUfuvSi1oToZ6w71GubUT
         bpTfwzOC7y5qMN7AISQxBfxccCJCnPvvTNV179MQUDqF2NrYtFmgzSE0/Kf4/0NZJKsr
         7NANykqi4bANerMTzQYklcHblahkC+i7T4Y9lOhW37SZCQIVlkOK0YyHoHpzJuDZVl3d
         +Ki0cCNr6+EQrw/LliRQ6xIu0nuWxL5G3JynL1oRbXl89WZhdBRESJPUkCazqFFMfMtm
         CWpPeQynZ8CGWSRwcFMG3fFrtFeLC7xyxRiPwr5P9AdsG3AsSmwvFqSjB+Gt1idG7+o5
         Tnlg==
X-Gm-Message-State: AOJu0YwmC6bIGFE1aBrlNN9/ZAT81DYnNYCDcruNbCcriYuDjPThpPR+
	HUv2lJCwe9lWN8lCB8pSgvvn7O2h+IGrA2R8mYgtKQZPYu/6gf0I4FevzgWZPNsJWoaQMsNh0wB
	Y4g==
X-Google-Smtp-Source: AGHT+IE0G4SfzxxNcKBnPCRpYFdxC7UqdFDNFLn6IxTgkrQsyF2NU6Q4LbGrsElpxhUbA99G5w1BV9ZQ7JY=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:903:22c4:b0:1d9:6380:5485 with SMTP id
 y4-20020a17090322c400b001d963805485mr1077plg.13.1707189805737; Mon, 05 Feb
 2024 19:23:25 -0800 (PST)
Date: Mon, 5 Feb 2024 19:23:24 -0800
In-Reply-To: <20230911021637.1941096-7-stevensd@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230911021637.1941096-1-stevensd@google.com> <20230911021637.1941096-7-stevensd@google.com>
Message-ID: <ZcGmLKbLV2bVTxD1@google.com>
Subject: Re: [PATCH v9 6/6] KVM: x86/mmu: Handle non-refcounted pages
From: Sean Christopherson <seanjc@google.com>
To: David Stevens <stevensd@chromium.org>
Cc: Yu Zhang <yu.c.zhang@linux.intel.com>, Isaku Yamahata <isaku.yamahata@gmail.com>, 
	Zhi Wang <zhi.wang.linux@gmail.com>, kvmarm@lists.linux.dev, 
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Mon, Sep 11, 2023, David Stevens wrote:
> From: David Stevens <stevensd@chromium.org>
> 
> Handle non-refcounted pages in __kvm_faultin_pfn. This allows the host
> to map memory into the guest that is backed by non-refcounted struct
> pages - for example, the tail pages of higher order non-compound pages
> allocated by the amdgpu driver via ttm_pool_alloc_page.
> 
> The bulk of this change is tracking the is_refcounted_page flag so that
> non-refcounted pages don't trigger page_count() == 0 warnings. This is
> done by storing the flag in an unused bit in the sptes. There are no
> bits available in PAE SPTEs, so non-refcounted pages can only be handled
> on TDP and x86-64.

Can you split this into two patches?  One to add all of the SPTE tracking, and
then one final patch to allow faulting in non-refcounted pages.  I want to isolate
the latter as much as possible, both for review purposes and in case something
goes awry and needs to be reverted.

> @@ -4254,13 +4265,18 @@ void kvm_arch_async_page_ready(struct kvm_vcpu *vcpu, struct kvm_async_pf *work)
>  static int __kvm_faultin_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
>  {
>  	struct kvm_memory_slot *slot = fault->slot;
> +	/*
> +	 * There are no extra bits for tracking non-refcounted pages in
> +	 * PAE SPTEs, so reject non-refcounted struct pages in that case.
> +	 */
> +	bool has_spte_refcount_bit = tdp_enabled && IS_ENABLED(CONFIG_X86_64);

Eh, just drop the local variable and do

		.allow_non_refcounted_struct_page = tdp_enabled &&
						    IS_ENABLED(CONFIG_X86_64);
(but keep the comment)

