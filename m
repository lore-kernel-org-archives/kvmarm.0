Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01AA221B9D8
	for <kvmarm@lists.linux.dev>; Wed, 18 Jun 2025 20:33:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750278801; cv=none; b=aw86vRUMIld4NpWmw1g+1iLvUklcxvJdxxX4eulCSNGESGjz15GG+oGGjVI0nRQQeBEV0xAunFEqGYGkMZY9WJ0Fd01GOb5NvNmkWNx6d3SQkQQDAJNxBMHGdRYhdT491MRi8UkW2z4YLGuuZT+SP2PBhqkLQ2FMZQE6sD9L+Fw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750278801; c=relaxed/simple;
	bh=WigYENNcjq7/m8IhfXdsszpaOXxacvRR6pnDnWZxlMc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=srxdFOG9ka5rIZFOtRhyRdXVVFbRkB/3Z3TDiUI77Qr222QSqK46m+haJQPy5eTc3/TCPqe1fUqTWJQ3NeBbHVyuQCl3WjjNqDpoTr1hs6BCTpwOn8wzYFH5fJ5rQkDilt/WnYc59NmkT7ZlrdBi9fgRBIcEPsYcNxjhOOOvFCo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=YVvv92sY; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="YVvv92sY"
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-b31831b0335so116332a12.3
        for <kvmarm@lists.linux.dev>; Wed, 18 Jun 2025 13:33:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1750278799; x=1750883599; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=42sjWHF9K9fXhUOTdWTuqVb5UO4E3+WdeqqnFDGgg5g=;
        b=YVvv92sYqQufo6ncSLK2WKf+jlvBnZVdk8zjC1HZj/Hb+9yR9bZc7ayctfYce6wypc
         KrDLG8zUMKk/EZZWTKZhbxKxqrrdp5JvPByeXlVni6ZfjpQVSxhCP5ztIlHpPxNZ51yh
         kjSNPSgNC1zTVNFLL4fwuACjjYrYHvP1gWzEm1uRWDs3FwLI5fEXGEInk4ayngYnv1ie
         H+R7UB98McojZt6FJP46LLs7u6vw71J6lnG8/IerKejLyNqqP2+M3XEas7CK7nzBKpt0
         apKD99kF8HsWKM8jMui3trS6XRTo6B96yylHSPwBSn8cLoevu3NMeOSOx0Kem8o6HHsw
         pcDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750278799; x=1750883599;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=42sjWHF9K9fXhUOTdWTuqVb5UO4E3+WdeqqnFDGgg5g=;
        b=gXmYCWOSwWR/LrRkErIULMcfqVfWh93tR0A0kS3FQJNRXD9W6qrzK+LOAwujoPoTLS
         Ob1fR0oWzIWP0a95Kp2DT9cRrZOTA+W2arONF9LfbH/S+qmvlz6Shbd1W+Fa0ILoOrPP
         ZItH3WqXAP53Gb+6HnzjzBvGpa02wWPftvzKEt9ehAOzoUIJedaCua5OiZlm7wFUO1Ic
         LUAu2evfCSedEHK3JMDBwfaqPjY5+nIU0jsm41A59vCn+Os3mHhHClajszAivrMRpPzh
         p7aYWZv5Sy7NS5Gjvdije/VTHhamv91hnQkzhzSFqDfhGmIjvz/JgS4sl18eCdE6ZSVW
         ZoJg==
X-Forwarded-Encrypted: i=1; AJvYcCUtkOMo6k3YP4l0pdwnc55Vuf5Ywsmv3Y47q/9RJjAga+DRjqnplPtOMQBFBPsKYaKXpaW260k=@lists.linux.dev
X-Gm-Message-State: AOJu0YwsldSpELkF+j7Gx3/1emO/RAI0mcnT+LgRlVgKtdQemViRobfN
	ArU+Ka5OcwaUlsFBFdGr7uV7lI5nRXbyh68pZSm4ngMAFNV8nF/7257Acyv5OUXuP64byWyNqRf
	9bMcxng==
X-Google-Smtp-Source: AGHT+IEnBs/fyXDZxBhLtmzxgsodc8isEpYWLiF7lsMkgK4GDRL+j/j0sf7eKoTQsS9Mi2OcofOzygboUp4=
X-Received: from pgkk127.prod.google.com ([2002:a63:2485:0:b0:b2e:c3bd:cf90])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a21:69b:b0:215:dfee:bb70
 with SMTP id adf61e73a8af0-21fbd57ac35mr30705672637.29.1750278799173; Wed, 18
 Jun 2025 13:33:19 -0700 (PDT)
Date: Wed, 18 Jun 2025 13:33:17 -0700
In-Reply-To: <aFMWQ5_zMXGTCE98@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250618042424.330664-1-jthoughton@google.com>
 <20250618042424.330664-5-jthoughton@google.com> <aFMWQ5_zMXGTCE98@linux.dev>
Message-ID: <aFMh51vXbTNCf9mv@google.com>
Subject: Re: [PATCH v3 04/15] KVM: Add common infrastructure for KVM Userfaults
From: Sean Christopherson <seanjc@google.com>
To: Oliver Upton <oliver.upton@linux.dev>
Cc: James Houghton <jthoughton@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Jonathan Corbet <corbet@lwn.net>, Marc Zyngier <maz@kernel.org>, Yan Zhao <yan.y.zhao@intel.com>, 
	Nikita Kalyazin <kalyazin@amazon.com>, Anish Moorthy <amoorthy@google.com>, 
	Peter Gonda <pgonda@google.com>, Peter Xu <peterx@redhat.com>, 
	David Matlack <dmatlack@google.com>, wei.w.wang@intel.com, kvm@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev
Content-Type: text/plain; charset="us-ascii"

On Wed, Jun 18, 2025, Oliver Upton wrote:
> > Signed-off-by: Sean Christopherson <seanjc@google.com>

No need for my SoB.

> > +#ifdef CONFIG_KVM_GENERIC_PAGE_FAULT
> > +bool kvm_do_userfault(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
> 
> The polarity of the return here feels weird. If we want a value of 0 to
> indicate success then int is a better return type.

The boolean is my fault/suggestion.  My thinking is that it would make the callers
more intuitive, e.g. so that this reads "if do userfault, then exit to userspace
with -EFAULT".

	if (kvm_do_userfault(vcpu, fault))
		return -EFAULT;


> > +{
> > +	struct kvm_memory_slot *slot = fault->slot;
> > +	unsigned long __user *user_chunk;
> > +	unsigned long chunk;
> > +	gfn_t offset;
> > +
> > +	if (!kvm_is_userfault_memslot(slot))
> > +		return false;
> > +
> > +	offset = fault->gfn - slot->base_gfn;
> > +	user_chunk = slot->userfault_bitmap + (offset / BITS_PER_LONG);
> > +
> > +	if (__get_user(chunk, user_chunk))
> > +		return true;

And this path is other motiviation for returning a boolean.  To me, return "success"
when a uaccess fails looks all kinds of wrong:

	if (__get_user(chunk, user_chunk))
		return 0;

That said, I don't have a super strong preference; normally I'm fanatical about
not returning booleans.  :-D
