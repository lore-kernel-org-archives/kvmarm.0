Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793724496;
	b=jfMlxZUkLhyhja2Ec8ujQX5YPvojZ96IXR/UlwTjjmewf9aS8c0P48aK1M3EMWYMKlOu
	 bYnjhkCEXi+C0upcn89fBnVAqM6tfRLhPucmVnMYf07NLDqoVJJLKz1UVP/ZWB2Hnph0Q
	 o3mdjDjJbwPYKP8v/d1UQNqtqslzLowOjinvOMwRdwoQHAKMvq1EMX0ZBfCyuZXPezfux
	 j6QBzaNRgy50bsEZjwWqUHgOgM5OM49J643g78W6a4aLRI6933wIZBdDxUsDXDMoHbzQW
	 J8ZNnAowUXuJ0/cgJ+1TtcwS0vGIgvlG0fm7WLeF/QSN8/Ve4dToHkkmxqqwzzF5M5g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793724496;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=l2PUnbLRvVKCeeWmqzWIWxHl8MNmgKSAW2Fw91nyKLI=;
	b=giA3+dDMYMO25CttH0BHI2MvFe97jCaVqeDSF5fMEbQ14i/Qn7uhlVIrtZOXGliG4iPi
	 BsheqaMqVjkN56S7evpB6YDuBG+8kqq0dfU+7Y860f9Y70q6iQfvOcTzY6nFT0VMfL/Pd
	 ac8uvfTt4YYgrb7/KqGORxl05aPA+wHRM9RUH3aa2q3azKSNpFcbG7HCQwZMRM6f6aAVo
	 KeRrUhrvt3u2WikvL6bd166UaHRI1pp+dpMnKglUDN75fh8VGjiGSJ+04G5j0x/HYgAjC
	 3qzV1UgNBpzGxz8V01ljaWLFs0AhJAsHISS24JFMVw9bAls8odH+ZiyNI+8JCLabF4Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=FgrZ2i1+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CAD8606A328;
	Tue,  3 Nov 2026 16:48:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=FgrZ2i1+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5E1E1F000C1;
	Tue,  3 Nov 2026 16:48:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793724496;
	bh=l2PUnbLRvVKCeeWmqzWIWxHl8MNmgKSAW2Fw91nyKLI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=FgrZ2i1+J+WK+vodFp2ovSXNFdwdlFJaTFd8IMGA6W1WY6waPIpnLf7ufNTEC5hqU
	 pRIK76PgnaLTk/aitEW7yHQbPu9xAsxKKt1mmN2CqhGoYmSRMaDMJLdfPZxr2bHhvT
	 rlJ2EEhaF4PoByjkBunCVYXLEDlM0L8aevI9cpzk6l+8kgW9C4zcpxOkx7fyEfmEuO
	 0mQSjVoo40D+Z/pFif/QqQJ+FUiKOrX0rdH65WhkSvsA0ejBMe+ne7xTQxbp+GZxyB
	 hz9erxg30S1taUiUvNlfgJ3+4CN7VXZNhCRrYsDFYf+vE7OrGnE6YJlHVSZhf6rfo5
	 su0cUG62lpQDg==
Date: Tue, 3 Nov 2026 08:48:14 -0800
From: Oliver Upton <oupton@kernel.org>
To: Vincent Donnefort <vdonnefort@google.com>
Cc: Fuad Tabba <fuad.tabba@linux.dev>, Marc Zyngier <maz@kernel.org>,
	kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org, Joey Gouly <joey.gouly@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
	Raghavendra Rao Ananta <rananta@google.com>,
	Fuad Tabba <tabba@google.com>
Subject: Re: [PATCH 1/3] KVM: arm64: Don't walk the whole IPA space when
 destroying a pKVM stage-2
Message-ID: <auoQTpm_UJWs4RK1@kernel.org>
References: <20261103084742.1302597-1-fuad.tabba@linux.dev>
 <20261103084742.1302597-2-fuad.tabba@linux.dev>
 <auoN4h8iloqPuepc@google.com>
 <auoQIzfM8tF4F98q@kernel.org>
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <auoQIzfM8tF4F98q@kernel.org>

On Tue, Nov 03, 2026 at 08:47:31AM -0800, Oliver Upton wrote:
> On Tue, Nov 03, 2026 at 04:37:54PM +0000, Vincent Donnefort wrote:
> > > @@ -513,10 +514,18 @@ void pkvm_pgtable_stage2_destroy_range(struct kvm_pgtable *pgt,
> > >  		kvm->arch.pkvm.is_dying = true;
> > >  	}
> > >  
> > > -	if (kvm_vm_is_protected(kvm))
> > > -		__pkvm_pgtable_stage2_reclaim(pgt, addr, addr + size);
> > > -	else
> > > -		__pkvm_pgtable_stage2_unshare(pgt, addr, addr + size);
> > > +	/* Called once for the whole IPA space, so reschedule between mappings */
> > > +	for_each_mapping_in_range_safe(pgt, addr, addr + size, mapping) {
> > > +		u64 start = __pkvm_mapping_start(mapping);
> > > +		u64 end = __pkvm_mapping_end(mapping) + 1;
> > > +
> > > +		if (kvm_vm_is_protected(kvm))
> > > +			__pkvm_pgtable_stage2_reclaim(pgt, start, end);
> > > +		else
> > > +			__pkvm_pgtable_stage2_unshare(pgt, start, end);
> > > +
> > > +		cond_resched();
> > > +	}
> > >  }
> > 
> > Just thought that it is a bit weird that pkvm_pgtable_stage2_destroy_range()
> > does cond_resched() while kvm_pgtable_stage2_destroy_range() does not.
> > 
> > How about instead kvm_stage2_destroy() refines start/end with some accessors
> > calling in pkvm.c pkvm_mapping_iter_first() / pkvm_mapping_iter_last()?
> 
> Yeah, I'd rather we tackle this as a general problem than doing some
> pKVM specific hacks.
> 
> Seems to me that we do a lot of wasted work even in the non-pKVM case
> where the outer loop will continue to iterate KVM_PGTABLE_MIN_BLOCK_LEVEL
> worth of IPA even if the underlying table is empty.
> 
> What we'd want is for the kvm_pgtable_stage2_destroy_range()
> implementation to report back how much of the IPA space it actually
> iterated over. We wouldn't want to keep re-visiting the same invalid PGD
> entry only because it's larger than our max block size.

Next patch heh :)
