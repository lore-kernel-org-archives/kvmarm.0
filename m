Received: from out-178.mta1.migadu.com (out-178.mta1.migadu.com [95.215.58.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F0EA1E498
	for <kvmarm@lists.linux.dev>; Wed,  7 Feb 2024 16:41:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707324093; cv=none; b=Uh4Erhmr+gpqXJpVWRinFsy+Cx2f7YlaFroW1hnomRqNF5g7clTugGL5UiFoslGFxjYR+mnsM/yY3EqaopQHuOR9xSoi8/cFEbIQp1oYSPhFCqbG8OusyKJfv0OunoMhzv9osob8+rzf++b5QKoxAB5mkXlLDrcdrwbgcuWT+6A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707324093; c=relaxed/simple;
	bh=U7bZjJIVn7iu5ZSISZoEhaiGptV+4BzXZAANlSNHTnQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QJGFVZFK7rx1Ll8jun51XFu1SBaa5Gw38V3tX3xy17H9dsOKZLwvao72i98v9NAghaq+B9ofj1xAhK9B80OsSvcGr1Iw7yr+tPaXpYnS9Jq61aH5UKlAlayvBw0FkdQ3BnTqk9bRVL/eNqaXQHOf5M3f5kTvDJT8yongM48J5KI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=r6ZmOxhS; arc=none smtp.client-ip=95.215.58.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="r6ZmOxhS"
Date: Wed, 7 Feb 2024 16:41:21 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1707324088;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=h3brB2Ix88lEEru6Nu3xjSB5Ty9y6qBPZLW9/MaXNCE=;
	b=r6ZmOxhSCGZ1xBPeSYxeAuiAv9pVBchEI4FOy3CyE/+mRVXCiugZyzFN8crHASGa/pQJH+
	jAaP8SUzIWZvvDp1fS0whOoPCUgbSZ7u07lKam4W7KQZtzOoyZX+kNlfhxul6kXvr+lNiF
	cd0tqWYejaWtRSVT7fqFIa+ZNAUXO2M=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Sean Christopherson <seanjc@google.com>
Cc: Anish Moorthy <amoorthy@google.com>, kvm@vger.kernel.org,
	kvmarm@lists.linux.dev, pbonzini@redhat.com, maz@kernel.org,
	robert.hoo.linux@gmail.com, jthoughton@google.com,
	dmatlack@google.com, axelrasmussen@google.com, peterx@redhat.com,
	nadav.amit@gmail.com, isaku.yamahata@gmail.com,
	kconsul@linux.vnet.ibm.com
Subject: Re: [PATCH v6 08/14] KVM: arm64: Enable KVM_CAP_MEMORY_FAULT_INFO
Message-ID: <ZcOysZC2TI7hZBPA@linux.dev>
References: <20231109210325.3806151-1-amoorthy@google.com>
 <20231109210325.3806151-9-amoorthy@google.com>
 <CAF7b7mqDN97OM7kgS--KsDygokUHd=wiZjYPVz3yk7UB0jF_6w@mail.gmail.com>
 <ZcOkRoQn7Q-GcQ_s@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ZcOkRoQn7Q-GcQ_s@google.com>
X-Migadu-Flow: FLOW_OUT

On Wed, Feb 07, 2024 at 07:39:50AM -0800, Sean Christopherson wrote:
> On Thu, Nov 09, 2023, Anish Moorthy wrote:
> > On Thu, Nov 9, 2023 at 1:03 PM Anish Moorthy <amoorthy@google.com> wrote:
> > >
> > > TODO: Changelog -- and possibly just merge into the "god" arm commit?
> > 
> > *Facepalm*
> > 
> > Well as you can tell, I wasn't sure if there was anything to actually
> > put in the long-form log. Lmk if you have suggestions
> 
> I think the right way to organize things is to have this chunk:
> 
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index b1e5e42bdeb4..bc978260d2be 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -3309,6 +3309,10 @@ static int kvm_handle_error_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fa
>                 return RET_PF_RETRY;
>         }
> 
> +       WARN_ON_ONCE(fault->goal_level != PG_LEVEL_4K);
> +
> +       kvm_prepare_memory_fault_exit(vcpu, gfn_to_gpa(fault->gfn), PAGE_SIZE,
> +                                     fault->write, fault->exec, fault->is_private);
>         return -EFAULT;
>  }

Err.. This is the arm64 patch. x86 already advertises KVM_CAP_MEMORY_FAULT_INFO.
The rest of the advertisement happens over in the arch-neutral code when
the arch selects CONFIG_HAVE_KVM_EXIT_ON_MISSING.

Having said that...

> be part of this patch.  Because otherwise, advertising KVM_CAP_MEMORY_FAULT_INFO
> is a lie.  Userspace can't catch KVM in the lie, but that doesn't make it right.
> 
> That should in turn make it easier to write a useful changelog.

The feedback still stands. The capability needs to be squashed into the
patch that actually introduces the functionality.

-- 
Thanks,
Oliver
