Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4EBE6258EC2;
	Sat, 21 Mar 2026 16:23:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774110234; cv=none; b=P0Gq0q3+GUD+KpsJB5O2kiPfeQ2rqlKNjCkVm9ndv9oZereYZA82/P2044TZQJU8fF8ZQqi6GxG4z6hhhetFXe9KADx4KzhVrjfon7W652ed7HdH2d5Gt7nCGbsrYovICKiE9UEHQ8tZtHOzh6oQgGXRc5R7xh+GJ07RyfqVqgY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774110234; c=relaxed/simple;
	bh=0ic02BYgkj2UJoCoR7WsElLuzm200ZRLM7wqQAQInhQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ll69YlzPoTP8wuFGag5OFHCTI8b8GnUQ8Fv2M7w/rm42ZqIkXIdH+DKcd3cqcmvWFLdeJA9Q53hZoCdIvMs9u7QnEd1W9XGQrZv2mxz+wzfky9xutmFhIQ8n0HZ2Qk5/qh08g2CofOGAwKtguFLiNexOWrPHau4Nj5krq3ICZy0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A1FDC1595;
	Sat, 21 Mar 2026 09:23:45 -0700 (PDT)
Received: from thinkpad-e142931.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id BCE2B3F73B;
	Sat, 21 Mar 2026 09:23:46 -0700 (PDT)
Date: Sat, 21 Mar 2026 16:23:34 +0000
From: Wei-Lin Chang <weilin.chang@arm.com>
To: Steven Price <steven.price@arm.com>, kvm@vger.kernel.org, 
	kvmarm@lists.linux.dev
Cc: Catalin Marinas <catalin.marinas@arm.com>, 
	Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>, James Morse <james.morse@arm.com>, 
	Oliver Upton <oliver.upton@linux.dev>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, linux-arm-kernel@lists.infradead.org, 
	linux-kernel@vger.kernel.org, Joey Gouly <joey.gouly@arm.com>, 
	Alexandru Elisei <alexandru.elisei@arm.com>, Christoffer Dall <christoffer.dall@arm.com>, 
	Fuad Tabba <tabba@google.com>, linux-coco@lists.linux.dev, 
	Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>, Gavin Shan <gshan@redhat.com>, 
	Shanker Donthineni <sdonthineni@nvidia.com>, Alper Gun <alpergun@google.com>, 
	"Aneesh Kumar K . V" <aneesh.kumar@kernel.org>, Emi Kisanuki <fj0570is@fujitsu.com>, 
	Vishal Annapurve <vannapurve@google.com>
Subject: Re: [PATCH v13 37/48] arm64: RMI: Prevent Device mappings for Realms
Message-ID: <c3pr5dnbyvq5g5fzrrfbcauwknzvpes7hcunvcdgq4ywsa6pp3@dht272pf3dkn>
References: <20260318155413.793430-1-steven.price@arm.com>
 <20260318155413.793430-38-steven.price@arm.com>
 <t3ge5bfjteubidjhcupkvzi4zdvepv2mtp7tan4mma6xd4jgnb@a6kjjbmt4aqk>
 <a0584809-31b0-4055-a73f-cddd9760cb9b@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a0584809-31b0-4055-a73f-cddd9760cb9b@arm.com>

On Fri, Mar 20, 2026 at 04:45:07PM +0000, Steven Price wrote:
> On 19/03/2026 18:46, Wei-Lin Chang wrote:
> > On Wed, Mar 18, 2026 at 03:54:01PM +0000, Steven Price wrote:
> >> Physical device assignment is not supported by RMM v1.0, so it
> >> doesn't make much sense to allow device mappings within the realm.
> >> Prevent them when the guest is a realm.
> >>
> >> Signed-off-by: Steven Price <steven.price@arm.com>
> >> ---
> >> Changes from v6:
> >>  * Fix the check in user_mem_abort() to prevent all pages that are not
> >>    guest_memfd() from being mapped into the protected half of the IPA.
> >> Changes from v5:
> >>  * Also prevent accesses in user_mem_abort()
> >> ---
> >>  arch/arm64/kvm/mmu.c | 13 +++++++++++++
> >>  1 file changed, 13 insertions(+)
> >>
> >> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> >> index ad1300f366df..7d7caab8f573 100644
> >> --- a/arch/arm64/kvm/mmu.c
> >> +++ b/arch/arm64/kvm/mmu.c
> >> @@ -1222,6 +1222,10 @@ int kvm_phys_addr_ioremap(struct kvm *kvm, phys_addr_t guest_ipa,
> >>  	if (is_protected_kvm_enabled())
> >>  		return -EPERM;
> >>  
> >> +	/* We don't support mapping special pages into a Realm */
> >> +	if (kvm_is_realm(kvm))
> >> +		return -EPERM;
> >> +
> >>  	size += offset_in_page(guest_ipa);
> >>  	guest_ipa &= PAGE_MASK;
> >>  
> >> @@ -1965,6 +1969,15 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
> >>  		return 1;
> >>  	}
> >>  
> >> +	/*
> >> +	 * For now we shouldn't be hitting protected addresses because they are
> >> +	 * handled in private_memslot_fault(). In the future this check may be
> > 
> > Hi,
> > 
> > What is private_memslot_fault()? I don't see it anywhere in the series &
> > upstream.
> 
> Oh dear, that comment is out of date ;) It's now become gmem_abort()...

Ah no wonder!

Thanks,
Wei-Lin Chang

> 
> >> +	 * relaxed to support e.g. protected devices.
> >> +	 */
> >> +	if (vcpu_is_rec(vcpu) &&
> >> +	    kvm_gpa_from_fault(kvm, fault_ipa) == fault_ipa)
> >> +		return -EINVAL;
> >> +
> > 
> > Additionally, there is a hunk almost identical to this one here in added
> > in patch 27.
> 
> Which is what this chunk says. It appears I screwed up a rebase at some
> point! This whole patch can really be dropped and the
> kvm_phys_addr_ioremap() change moved into another patch.
> 
> Thanks,
> Steve
> 
> > Thanks,
> > Wei-Lin Chang
> > 
> >>  	if (nested)
> >>  		adjust_nested_fault_perms(nested, &prot, &writable);
> >>  
> >> -- 
> >> 2.43.0
> >>
> 
