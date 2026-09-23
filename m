Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CA5C5293F5;
	Wed, 23 Sep 2026 13:26:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790169998; cv=none; b=iYeQwnpBZzARxI7FLDjcV6ucEwi2g0aN6RvZZ22KI5Crpt5ZEDV7tQAEBg2eJcKnrOawQ5wzuf2C+TUh4DHRTeb3I6r0QumHXXQ669kTvGvbl2pMus417JtUhse0GLCGgakJV0BjSNkAX+h5Xw26FmSSVS+mUjXOHiws/p7M5Gk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790169998; c=relaxed/simple;
	bh=Qneni/y1L9wtkUrCQWZpYXdDS8cW8S7vhcwJPEM3A90=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nFMF9olVo6MwSIyODPRzTz2nQF4L7kfcEpMjPRHIZbwRr/10pkg1R/VfOLiWCO0baD+TDtg1QzRRKYbg7itQfhrUwIQgYqriWoED5U6QYzQbwtIF9pcxmylQ3qjYS+RJYrtY90tQREU/v62E2QhcG95nZ7FtlwupuGtrBj62WNY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HcljQSRZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HcljQSRZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7690C1F000FF;
	Wed, 23 Sep 2026 13:26:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790169996;
	bh=DpBDbIP8yvq+Fmf2FciZjevO7LeQexU7dyJwxxAp6co=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=HcljQSRZTXKzCzv23eDmZBXttSKnJHWt75BS8zBW7Dn+gQ/EsaHyv/vAdAU1yxgF9
	 v7o+8DfaKQtuEMMP9qnWhtLIIYxEQNCdV2LAqJVTwpcRmwz/QHcq01BSoYaN7JVGrY
	 2t4NCRUHgdviRapBHeY1O+/BvNkTCH4B1mJA1wxn9UbZE1gVIq58CiLcL9g0zoQqdz
	 4zKMdnUQVLjYRbg77a+bFzT6NjfP58YiyVBXuNJsnaYo2mgIHmYcUakuRA7o5XRPMQ
	 3erdKXC5v48l2BEy0MRZu0Oj8s8W29nkdgG18lVsJmypxt+8Wh5uHb+Yp0u3aOK4X/
	 oBVZEWQxsAq5w==
Date: Wed, 23 Sep 2026 14:26:27 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Fuad Tabba <fuad.tabba@linux.dev>
Cc: Oliver Upton <oupton@kernel.org>, 
	Sean Christopherson <seanjc@google.com>, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>, Joey Gouly <joey.gouly@arm.com>, 
	Steffen Eiden <seiden@linux.ibm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Jonathan Corbet <corbet@lwn.net>, Mark Rutland <mark.rutland@arm.com>, 
	Randy Dunlap <rdunlap@infradead.org>, linux-arm-kernel@lists.infradead.org, 
	linux-kernel@vger.kernel.org, kvmarm@lists.linux.dev, kvm@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	Jack Thomson <jackabt@amazon.com>, Jack Thomson <jackabt.amazon@gmail.com>, 
	Alexandru Elisei <alexandru.elisei@arm.com>, Vincent Donnefort <vdonnefort@google.com>, 
	"Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, Claudio Imbrenda <imbrenda@linux.ibm.com>, 
	Leo Soares Passos <Leo.Bras@arm.com>, Wei-Lin Chang <weilin.chang@arm.com>
Subject: Re: [PATCH v3 01/14] KVM: Allow architectures to disallow pre-fault
Message-ID: <arPTeFAcxA5MJqxg@gremlin>
References: <20260922-kvm-arm-prefault-v3-0-787bd3bc7e3f@kernel.org>
 <20260922-kvm-arm-prefault-v3-1-787bd3bc7e3f@kernel.org>
 <arKxjsxuO1F5ExrY@kernel.org>
 <arK5n9HrbZMCOHOt@google.com>
 <arK5ynpRi7VbY7Ek@gremlin>
 <arK8seJVT9wYgVCP@google.com>
 <arLD-eZ6dRvfZ52q@kernel.org>
 <CA+EHjTxFVWHUBCD+SZvSG7T6=i6ZMWWRkNqQ3rMmSt6LwrcjtQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+EHjTxFVWHUBCD+SZvSG7T6=i6ZMWWRkNqQ3rMmSt6LwrcjtQ@mail.gmail.com>

On Wed, Sep 23, 2026 at 11:54:15AM +0100, Fuad Tabba wrote:
> Hi Lorenzo,
>
> On Tue, 22 Sep 2026 19:07:53 +0100, Oliver Upton <oupton@kernel.org> wrote:
> [...]
> > I'd favor doing something like below and sticking the comment inline in
> > the ioctl handler. Unless I'm missing something blatantly obvious, I
> > don't see why the x86 or s390 pre-conditions can't be tested early too.
> [...]
> > diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> [...]
> > +int kvm_arch_pre_fault_allowed(struct kvm_vcpu *vcpu)
> > +{
> > +        if (!kvm_vcpu_initialized(vcpu))
> > +                return -ENOEXEC;
> > +
> > +        return 0;
> > +}
>
> The same goes for arm64's pKVM check: kvm_arch_vcpu_pre_fault_memory()
> returns -EOPNOTSUPP for is_protected_kvm_enabled() only after
> vcpu_load(), so on a pKVM host the ioctl loads a vCPU the hypervisor
> may not have created yet before rejecting it. Could that check move
> into kvm_arch_pre_fault_allowed() as well?

Ack yeah that sounds good, will do for v4!

>
> Cheers,
> /fuad

--
Cheers, Lorenzo
