Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6F7613B794
	for <kvmarm@lists.linux.dev>; Fri, 23 Feb 2024 18:03:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708711426; cv=none; b=VjXxTEoJbPYM/LVmjhlv+hT3Mh2NgdE/BOrtxX/YdjJvpTCMy9zRCVwMF9dwzn2IOC7T+Ht3efOXEpZtiwjZ2lxiY6WzN9xXRTKu9plLJgiFEUfFdSD/nDPWWBqX52hcWCURkneYEkthT1ywc37LtwRvEjAYEtS/4YgZdfa8S5k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708711426; c=relaxed/simple;
	bh=DdRMPpgG9Tb6SaT0/ZIVpJjpD80lyxQTMLWdPoxSyYI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=CrylvXlbm+Nl8JUkfNsEkQYJcpKqLC2Yvz4bgzAJ/xX2B3iadJpkVRK3yCfwSWcuk1Cmah/6NTHvinPq2yCEcFygZVdOfGR/dih0CVUBEFfeHFymNYgi0fFoArBwYByxoddyizTa438qhLQ+MB6RQjuUcZ0shrx4jmSCMzvpoHM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=BzUWCxn0; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="BzUWCxn0"
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-607e613a1baso11743737b3.1
        for <kvmarm@lists.linux.dev>; Fri, 23 Feb 2024 10:03:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1708711424; x=1709316224; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=y5GBsdPl7urgMkjHsKUTWfcFYRbv5pqvr/pTSqxUepM=;
        b=BzUWCxn0C2BN+rwCLbaS1drmCrMu1JIPUPiVuxxPNlPY34dypiNva7v0J9cwmJ91Wd
         aHtUKLfU5c2u2TYbj7PFVS1zwLu80gRU6YYzFVSKskC0JJZGxgfG4qs1zck1HyRUXRTW
         qC5EIEW2pVSUJM1g+fs4mts6GUAeE027Ey+S8NQIyptdCzEdNdHYk8RnrwiKnc9GDuKt
         Nn/12mJz42ooLvzGRcdkUb1ZYbk0KX0bdNVrfpvXmNwvlpKpEp6tJPhLgOsAO+jqKJmY
         WAIouZM2iA15eXP+OZJeEJ6c3Mi0gxcnO76nUDtdqvj8jTByku1ooZkwfxqQF25hkv9T
         8GWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708711424; x=1709316224;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=y5GBsdPl7urgMkjHsKUTWfcFYRbv5pqvr/pTSqxUepM=;
        b=e14gOSlGpFBKnM7ngVxXqcZoi9YjSba0rXtCh71I0pGl9wtFmRjY+BtbYrRnZr6E1L
         B3lpuUbMojPozhPDCs9Gl3av1Badpl9A+4+6SSJ9D7hDbWBc+ab/sVCym0TBsGWr/gMQ
         XUfPAEwIJ5DdYJD97EPz5Iy0NnM76njMRgxgWBIkwS1DSF+pk+fitty9o6AQ824gxwk0
         rAEYFMAx+oLIUm/aFtQk2qpFw2HrYy4DgVHPDst3VF8eCkSuLffzKXdHFDbblINP/VRj
         SyRz/guQn+oeYlRsjUqIYtRiAwzZ20zbPyrUe5gxqBv+iccLwKtYuMay4RPeNjT+iQm8
         3w7w==
X-Forwarded-Encrypted: i=1; AJvYcCUp/E2u5K4Sx/go5lJ5jsx/iaqzagOVKkA02j+mcrpV0oozVOlzCccd7bp0MKruViS67B93hG3KA7gOeCxmF9TLfy1mMeCi
X-Gm-Message-State: AOJu0Yyz1lBY6UZviIBqGL751QKYfNdrz5h/S2g9boJGW+DE7gAuLVq+
	4StjAd/BV//gWQsAiJXArRg2YlEAkcWnUWLNlzrX/NTmTWv/eQR8JDCm1tA2n71AimWLEq8DRJH
	IsA==
X-Google-Smtp-Source: AGHT+IFWV3CfQ94wgLPhbMGbDfgw7i7VWpWYNFZJz5bzHf5O44Xtwf6QXZWVPyjjqZKenQtiCT2ymWP+BkY=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a0d:d9d4:0:b0:608:a901:469a with SMTP id
 b203-20020a0dd9d4000000b00608a901469amr123120ywe.1.1708711423876; Fri, 23 Feb
 2024 10:03:43 -0800 (PST)
Date: Fri, 23 Feb 2024 10:03:42 -0800
In-Reply-To: <f6296a0c-df91-4de8-833e-dc13b9286a2e@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240221072528.2702048-1-stevensd@google.com> <20240221072528.2702048-10-stevensd@google.com>
 <f6296a0c-df91-4de8-833e-dc13b9286a2e@redhat.com>
Message-ID: <Zdjd_loCXRAV3aVb@google.com>
Subject: Re: [PATCH v10 7/8] KVM: x86/mmu: Track if sptes refer to refcounted pages
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: David Stevens <stevensd@chromium.org>, Yu Zhang <yu.c.zhang@linux.intel.com>, 
	Isaku Yamahata <isaku.yamahata@gmail.com>, Zhi Wang <zhi.wang.linux@gmail.com>, 
	Maxim Levitsky <mlevitsk@redhat.com>, kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org, 
	kvm@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Fri, Feb 23, 2024, Paolo Bonzini wrote:
> On 2/21/24 08:25, David Stevens wrote:
> > From: David Stevens <stevensd@chromium.org>
> > 
> > Use one of the unused bits in EPT sptes to track whether or not an spte
> > refers to a struct page that has a valid refcount, in preparation for
> > adding support for mapping such pages into guests. The new bit is used
> > to avoid triggering a page_count() == 0 warning and to avoid touching
> > A/D bits of unknown usage.
> > 
> > Non-EPT sptes don't have any free bits to use, so this tracking is not
> > possible when TDP is disabled or on 32-bit x86.
> 
> TDX will add support for non-zero non-present PTEs.  We could use this to
> use inverted bit 8 to mark present PTEs (bit 8 set for non-present, bit 8
> clear for present) for both shadow paging and AMD NPT.  This would free bit
> 11 for SPTE_MMU_PAGE_REFCOUNTED.

Ooh, that's much more clever than where I was headed, which was to abuse the PAT
bit (kernel configures 0400 to be WB), which would actually be quite elegant if
(a) the PAT bit didn't move around or (b) the kernel used a non-zero PCD or PWT
bit for WB :-/
