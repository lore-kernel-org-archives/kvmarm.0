Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 062B43FC7
	for <kvmarm@lists.linux.dev>; Tue,  6 Feb 2024 03:16:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707189397; cv=none; b=NYio56TYCbnBNqR4cxSng7OBIX8mdx2EmsIwsv32olteITQ/xM1MeH7s/D3g2eFBxQRUZhtaYbRd6u6kvZUxhNUMzv9b9uS3rwoCH+jdCTA5jVnFfRtRDO3jO5EuCSnRvJeEvDtJDDY8TEQIBt74BbEkUQg8t4Rc9fUE2DX1Aj4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707189397; c=relaxed/simple;
	bh=CDLsR1ZUUpDk/9u8x2Knc8vzwibGd3+lwfgVYBEFEPQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=qh+stXnQYZLWVTHFtfYsqCHnzRtPMVpaJ0Q4xTiOnMmQmpHvvI2U1za8b5bZW/gXK2TNuosT7PHnjzPLj1yKAeIRZiWs3I/iGhn895s+NNrdkv1bJ+2/hR+2kkqI0c4fNPt9LindtyEvwfP4S5VGLtdYC53WD6vUi8/U+hla+Jk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=lLa7Hwn6; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="lLa7Hwn6"
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-6041c633cfaso82266627b3.1
        for <kvmarm@lists.linux.dev>; Mon, 05 Feb 2024 19:16:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1707189395; x=1707794195; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=MvC3MRJutUaxpyhNW1LkFy2eJ5hLYgf9cMf+Ks5GEgE=;
        b=lLa7Hwn64sIZYkNPz0bHLHmvPC2RbLfB4LcGpBbd3iPTtHKPf4WCBwWat6x5J23vU+
         KyRUJENy0DDXfk+p7q9BvW8Y2nvGNCGU0SMwkApjOV88IA9mp0b9ehFCoYd/pD1w223W
         3ie8fTQDTY0K6LO402e0nVKzqbl2wEPGR0tih73t3cD4BhuEx/N0XDkMe3vR6BLFq5yB
         5Q9CJnTRZOP6oLXL4iiFLm+vBcNPO3l5xwMwroFicDOMDBGYj5biOJnmmvAQP/0IkIBl
         Py7BFLSdUfHNKhBwCIhi8iKg/Pf/BIIoBHSt/zFIbreGdoIWKMirS4LKrBxTJGSOlj95
         AYJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707189395; x=1707794195;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=MvC3MRJutUaxpyhNW1LkFy2eJ5hLYgf9cMf+Ks5GEgE=;
        b=Ccr0CVPCKNA4a59RSnWx6Yu7hXszvHaoC26doFJeB2Mghc2ZjXlXdvHCf3Ugyi1gD/
         TpNtLcra1Ey0EE3AL19bJMFnJ6Lrpu8mMKxSDBBpkK98afRVCwmbCASNM5eBdZVEVGFe
         /xxxks6UZebxAkSwuqIMbyV294Vlg9sj+EfHzI7JZusicXucNJQvI//92Eg/EzOZiPNx
         wVhBTkMgj54GIotdTM9gXHD3Wx5OTP2cbnwuKEADK8oUapqOBiUCl0Su5XM6rE91GfxK
         tMdTnpuQI0IUKxnJn1SzJXZ2cgfggXYZbGVctxU0TX5Qq/ClQtsiBz6No5pM3C5C70v8
         p8hg==
X-Gm-Message-State: AOJu0YxCqwHFsjsLcIcg137KQXr8miYodPBVzGkk8QNCMyGwuDV6UNEI
	K8nH79f5FcrfkLvXFFaw1YXnlOYmt5fDN2I/j/5AjfPrvLBdBSlgShDHZiINPiYq3gWxV1aZHYQ
	y1g==
X-Google-Smtp-Source: AGHT+IGm+xDF5ifX2TC/Wxist3sFnZeSnqNK6H+2R746GyxgyO5yCoDonpYAqmwboZsm2R0fmqQgQqI4SF8=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:cc6:b0:dc2:23db:1bc8 with SMTP id
 cq6-20020a0569020cc600b00dc223db1bc8mr18446ybb.3.1707189394995; Mon, 05 Feb
 2024 19:16:34 -0800 (PST)
Date: Mon, 5 Feb 2024 19:16:33 -0800
In-Reply-To: <20230911021637.1941096-3-stevensd@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230911021637.1941096-1-stevensd@google.com> <20230911021637.1941096-3-stevensd@google.com>
Message-ID: <ZcGkkVAaT_Lz_ZVQ@google.com>
Subject: Re: [PATCH v9 2/6] KVM: mmu: Introduce __kvm_follow_pfn function
From: Sean Christopherson <seanjc@google.com>
To: David Stevens <stevensd@chromium.org>
Cc: Yu Zhang <yu.c.zhang@linux.intel.com>, Isaku Yamahata <isaku.yamahata@gmail.com>, 
	Zhi Wang <zhi.wang.linux@gmail.com>, kvmarm@lists.linux.dev, 
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Mon, Sep 11, 2023, David Stevens wrote:
> @@ -2681,24 +2668,22 @@ static int hva_to_pfn_remapped(struct vm_area_struct *vma,
>   * 2): @write_fault = false && @writable, @writable will tell the caller
>   *     whether the mapping is writable.
>   */
> -kvm_pfn_t hva_to_pfn(unsigned long addr, bool atomic, bool interruptible,
> -		     bool *async, bool write_fault, bool *writable)
> +kvm_pfn_t hva_to_pfn(struct kvm_follow_pfn *foll)
>  {
>  	struct vm_area_struct *vma;
>  	kvm_pfn_t pfn;
>  	int npages, r;
>  
>  	/* we can do it either atomically or asynchronously, not both */

Can you change this comment?  Not your fault, as it's already wierd, but it ends
being really confusing after the conversion to FOLL_NOWAIT, because not waiting
in atomic context seems completely sane.

> -	BUG_ON(atomic && async);
> +	BUG_ON(foll->atomic && (foll->flags & FOLL_NOWAIT));

Side topic, a BUG_ON() here is ridiculous overkill.  Can you add a patch somewhere
in the series to convert this to a WARN_ON_ONCE()?  The check is there purely to
guard against incorrect usage in KVM, the absolutely worst case scenario is that
KVM simply doesn't go down the slow path when it should and effectively DoS's the
guest.
