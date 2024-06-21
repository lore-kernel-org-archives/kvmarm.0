Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70A1016A924
	for <kvmarm@lists.linux.dev>; Fri, 21 Jun 2024 18:32:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718994758; cv=none; b=QGQCx24YNCYKL5JjNQSWw4fMgDq5y3D9v/HpXYtnsmtDYPh1lU2pJUw/A+DpuzO+Faa2n6wDTk7qwZ6GBnfouX6/kjBv7IYfda9ifwHmF8qo5Jg73KG/AGcmr83thEblLM+o2oQuHdFox/SS1dBDQrF8U6Xlfzf9A52fItAfyR8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718994758; c=relaxed/simple;
	bh=0H34soARn+l9ua3hOFI0BtyYnn5z/+diQyMIqihfAwY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ofUcvnX3ZW6l0K8y2cm2xTEObw8KyuF6cPFwtEZRX7yLAr7WOiom/2qCq3eQFEqHpm5g1StG2t5Ko9WG4NsY5W4Sy8iOBpKDY7rGFfCKG3RNTFWSPyWgz5xad2jTRt59w2oQ7zj68Ck/NHf6zDmJLoeixKQPtdUZzXz4d8DZcMo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=tQEUQBG0; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="tQEUQBG0"
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-62fa71fbfc4so41859807b3.2
        for <kvmarm@lists.linux.dev>; Fri, 21 Jun 2024 11:32:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1718994756; x=1719599556; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Wjq+poPO8VKzj2zS+5inMc+koR44iKdQ85yHH57Hmm4=;
        b=tQEUQBG0VPvcGrAzexPheXwQ0FSDwUGRguRKIyCjx6gO87OAB9DtMg9Gibi0BTkZdw
         21vfFATRjyW/nSIXRDBJJdybzBB3VwbJRkXkdgVMPHYwbbVo/M+mDVQilT46JmW20OQ6
         JhRfrncZSZQoahpISlRBg+xLeMsGEP9ydZnVmvWUoNLeiBzZtcH28P/0Rmr7dlmluiUU
         GFuzDt86Cc6mNeirfmYXYe6T3v/HJZrteaNdHg72HUbPqlCAKy81v/uZNduYIhLu6XGH
         JBevZWfT899AoA7DK8s6N1rdpmrc0ypKSKFnbrRb6R6PL2REalRBOH4zGnYNPWRhIWpY
         Kc/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718994756; x=1719599556;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Wjq+poPO8VKzj2zS+5inMc+koR44iKdQ85yHH57Hmm4=;
        b=kPePqVmMUwGLY+/6+kvTCm07keLitB32umY8yIdMaAojlUK4MoCfs4+BZc0ZFzrbxK
         avxDlASns8Z2t5C8mpba4ivO93F+rIsnm49ewBr9b3KhgxjnMXAGegdi6XT+Km142Od+
         Uaz966KD6ZClwUH15Qm72MeKiH4+Y3ujAySj+Tdn0SNL3E5sfKCXkutmf2n2V067cW6q
         ccbUhh9a1wzBWHYUXS8ncBak5Kx2b/vikJj7W7maNNFJVXQNmWHJRs5GfpPniIBBz3eS
         x9UKJEQVYajBocmLgCly5KS7MrHmF35fgF2Dgq3YJtuNsR456lvmr1g7G1rPEV2FJhek
         qyzg==
X-Forwarded-Encrypted: i=1; AJvYcCVhPemjltM35AEHjB6vMCNQR8iwsHjPrbii8kJkdytJO25tA9lMx+YR9sYqR3sBwf9VhyePca+fAixT/gxhBAl/dN1A4MxR
X-Gm-Message-State: AOJu0YyRSOc56RATKZcoWxMv87HIvbqwPohcSRYH5UvtcO4kL1O1RrS/
	tlKdw3RhoQDeqgJUaeRrvwirAg9ms7PkLV/LO0yKUAbfeHUKYrTAx7Gzd6mO2kQS0+Poln/m2QF
	LSg==
X-Google-Smtp-Source: AGHT+IGEjW89Y/O/38ZL3Tnu7qb0RJLIju4LabxToEhzi7MadqEX4RhJshNX3Tuav4hl19hd3OuuQC4QDCc=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:690c:25c7:b0:62c:de05:5a78 with SMTP id
 00721157ae682-63a8f524cebmr11574467b3.6.1718994756418; Fri, 21 Jun 2024
 11:32:36 -0700 (PDT)
Date: Fri, 21 Jun 2024 11:32:34 -0700
In-Reply-To: <20240229025759.1187910-1-stevensd@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240229025759.1187910-1-stevensd@google.com>
Message-ID: <ZnXHQid_N1w4kLoC@google.com>
Subject: Re: [PATCH v11 0/8] KVM: allow mapping non-refcounted pages
From: Sean Christopherson <seanjc@google.com>
To: David Stevens <stevensd@chromium.org>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Yu Zhang <yu.c.zhang@linux.intel.com>, 
	Isaku Yamahata <isaku.yamahata@gmail.com>, Zhi Wang <zhi.wang.linux@gmail.com>, 
	Maxim Levitsky <mlevitsk@redhat.com>, kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org, 
	kvm@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Thu, Feb 29, 2024, David Stevens wrote:
> From: David Stevens <stevensd@chromium.org>
> 
> This patch series adds support for mapping VM_IO and VM_PFNMAP memory
> that is backed by struct pages that aren't currently being refcounted
> (e.g. tail pages of non-compound higher order allocations) into the
> guest.
> 
> Our use case is virtio-gpu blob resources [1], which directly map host
> graphics buffers into the guest as "vram" for the virtio-gpu device.
> This feature currently does not work on systems using the amdgpu driver,
> as that driver allocates non-compound higher order pages via
> ttm_pool_alloc_page().
> 
> First, this series replaces the gfn_to_pfn_memslot() API with a more
> extensible kvm_follow_pfn() API. The updated API rearranges
> gfn_to_pfn_memslot()'s args into a struct and where possible packs the
> bool arguments into a FOLL_ flags argument. The refactoring changes do
> not change any behavior.
> 
> From there, this series extends the kvm_follow_pfn() API so that
> non-refconuted pages can be safely handled. This invloves adding an
> input parameter to indicate whether the caller can safely use
> non-refcounted pfns and an output parameter to tell the caller whether
> or not the returned page is refcounted. This change includes a breaking
> change, by disallowing non-refcounted pfn mappings by default, as such
> mappings are unsafe. To allow such systems to continue to function, an
> opt-in module parameter is added to allow the unsafe behavior.
> 
> This series only adds support for non-refcounted pages to x86. Other
> MMUs can likely be updated without too much difficulty, but it is not
> needed at this point. Updating other parts of KVM (e.g. pfncache) is not
> straightforward [2].

FYI, on the off chance that someone else is eyeballing this, I am working on
revamping this series.  It's still a ways out, but I'm optimistic that we'll be
able to address the concerns raised by Christoph and Christian, and maybe even
get KVM out of the weeds straightaway (PPC looks thorny :-/).
