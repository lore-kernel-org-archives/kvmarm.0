Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBB432C15B7
	for <kvmarm@lists.linux.dev>; Mon,  3 Nov 2025 21:08:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762204093; cv=none; b=jTCZnax72H+oNzdEuRKqweYRIlhwzhGCol/QD1n0oVkITbXUqXN85HwqVUZtyw1bHoIGDBv9hx7Hh7CKpoPVJP5z2xfDEq9dJUC2TY7pK1sojPGUlUomoW3lFRyh0Nzf/ZwN4TUg1CnsMnX2UKD0L1ie2xqPlAZJKOKKP5yFiJQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762204093; c=relaxed/simple;
	bh=lqImQkBIX2RKNa9y7sFTmTERfIUIhbfGh0MuI1pu61o=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Png0wwKMDx3jR20Q3LOh6VtR7zWow0vDs+H1oJ62XzNiCHn4XGSczYidVx0De811LnxZ9VkbsWkl94bSWbXGk52poSfd1Cak3bR3fc4WKrz50yQtN7bMZ/DlU/Rc/MgqX854hqYcMFzMw3ghM9elaiDGMhgCPVMN3+26JYhwN+A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Uyh0zJLD; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Uyh0zJLD"
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-2953deecdaeso70004645ad.2
        for <kvmarm@lists.linux.dev>; Mon, 03 Nov 2025 13:08:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1762204091; x=1762808891; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=l1jgaIFuU1qR4r59NFbF5NuManKscXsOZ/dpS/a+5oA=;
        b=Uyh0zJLDAN8S1fxzp3mB72biJXZivaF3Pe8XwXalcC3Tr5XYxxZbWLh86UkwYlpHhp
         /mXao+XtQB3cxMkSvqonpNCSY9sLeWH4yaOXZTKp5v8uPjEvYm1Fe4leE49k243FiIEl
         U2WSS3hTUeQeSZ4rkfJ0HvOuU52HJ1geMQGQJoAWcL5RS/C4KGegTr2AQHGakOgUN1mR
         WQa3bPl5O2fL4uT9uJo9+y9ukTtQOpb5uRpthwfiBSB/G25ZwZZybHnryhrbGL4w6sHp
         6fvUINe5jrvZZi+Bp1lkJBRL5P38f2vHXhxstPFveRermzAPQXmy3N+NcPZTXmuiDHgG
         F81Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762204091; x=1762808891;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=l1jgaIFuU1qR4r59NFbF5NuManKscXsOZ/dpS/a+5oA=;
        b=WqdSY5Cr+qG+WpVElKpvuxRogq2SAerGvkXR0tXdAGYUWnGEsWndrXt/TFzYK9b+nB
         1iCHFbfriKQXkr710rv2vTeOpktvJP49/U8ph3PttklH1Ku+P4Vtpw3Fa8ca64J81tAL
         ws+3zKYDh+UnraiRbyvbIbtVgiZ7Ur1+gr9ZmERMQ2xIqyhdLv0D5nCDY1paeL3MM5Mk
         M4JHfJ9oByCRzZyGpokA53ex0Tw/6R0iqvkyTMcq+326CmAHljeaKMS8Ws7tI2kTbIGO
         Ny6GIBrbQvDruNLcBPMVNx+e9VVUOw2AGk4bBc8S9pXimzKPuQhnhi7nicY4x5E2CWWX
         Vw4Q==
X-Forwarded-Encrypted: i=1; AJvYcCVtMQJG+bqbWft2wL1G5yioEKqQqcFWP01Mcr/IWrB/y4aONvr6nyMLz3+JJ8XBpzzXdRvynGk=@lists.linux.dev
X-Gm-Message-State: AOJu0YwXj2uD/k1YKyd7mNDYj5UaJ1EVSne3Hktmnn1aSrkTNhc1Syvc
	M5+che7UpYtSbAABLCALEOuKlpalaRqWs/O8PbFmUzsMTUvwTlLrXT/714CrTFynocaY0/B7znF
	bLiSWEA==
X-Google-Smtp-Source: AGHT+IFmLCYVwXdeteTbsVspNCQQNa07ZbCjVAqI5KUDK7A2fmNFJ3jDRmAVUCA7gp+ckzqh33TY6g3AxJw=
X-Received: from plbmn15.prod.google.com ([2002:a17:903:a4f:b0:261:3bf9:662a])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:c947:b0:295:1e50:e7cb
 with SMTP id d9443c01a7336-2951e50eb4amr164854455ad.23.1762204090972; Mon, 03
 Nov 2025 13:08:10 -0800 (PST)
Date: Mon, 3 Nov 2025 13:08:06 -0800
In-Reply-To: <c52db7bf-494f-49a8-9829-3805db6dda7c@gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20251013151502.6679-1-jackabt.amazon@gmail.com>
 <20251013151502.6679-3-jackabt.amazon@gmail.com> <aPpi1c-8EpWuo87B@google.com>
 <c52db7bf-494f-49a8-9829-3805db6dda7c@gmail.com>
Message-ID: <aQkZtjLt6lIULffA@google.com>
Subject: Re: [PATCH v2 2/4] KVM: selftests: Fix unaligned mmap allocations
From: Sean Christopherson <seanjc@google.com>
To: Jack Thomson <jackabt.amazon@gmail.com>
Cc: maz@kernel.org, oliver.upton@linux.dev, pbonzini@redhat.com, 
	joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, 
	catalin.marinas@arm.com, will@kernel.org, shuah@kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	isaku.yamahata@intel.com, roypat@amazon.co.uk, kalyazin@amazon.co.uk, 
	jackabt@amazon.com
Content-Type: text/plain; charset="us-ascii"

On Tue, Oct 28, 2025, Jack Thomson wrote:
> 
> 
> On 23/10/2025 6:16 pm, Sean Christopherson wrote:
> > On Mon, Oct 13, 2025, Jack Thomson wrote:
> > > From: Jack Thomson <jackabt@amazon.com>
> > > 
> > > When creating a VM using mmap with huge pages, and the memory amount does
> > > not align with the underlying page size. The stored mmap_size value does
> > > not account for the fact that mmap will automatically align the length
> > > to a multiple of the underlying page size. During the teardown of the
> > > test, munmap is used. However, munmap requires the length to be a
> > > multiple of the underlying page size.
> > 
> > What happens when selftests use the wrong map_size?  E.g. is munmap() silently
> > failing?  If so, then I should probably take this particular patch through
> > kvm-x86/gmem, otherwise it means we'll start getting asserts due to:
> > 
> >    3223560c93eb ("KVM: selftests: Define wrappers for common syscalls to assert success")
> > 
> > If munmap() isn't failing, then that begs the question of what this patch is
> > actually doing :-)
> > 
> 
> Hi Sean, sorry I completely missed your reply.
> 
> Yeah currently with a misaligned map_size it causes munmap() to fail, I
> noticed when tested with different backings.

Exactly which tests fail?  I ask because I'm not sure we want to fix this by
having vm_mem_add() paper over test issues (I vaguely recall looking at this in
the past, but I can't find or recall the details).
