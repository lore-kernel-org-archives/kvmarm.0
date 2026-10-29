Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.140.110.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793310291;
	b=SZExbk/YmLpaFwwc2P0vKJc0R+pI6N7Sfb+hvaR7UJq5giHRkarCMbl9sHDNnlOpOOZF
	 watZREcL9apfd4kSAFOVP01ZA7Tn2iB7T7ZZSc6CSlb09y9xcliQJpoV2n3L5wO+ziIWp
	 TgHT+tTdhK5VabqOagXY1c6HBWRjRMFAsT4Swa9R67X+yfNoJJIy/CnXFyLSPaTbsQ5Q4
	 /xh6tg8R8rAjG6AAVzuxTCc58HMRZNZkabG38RzbksVXSFv+I4ZukPB+lVR+gWW7ZNryH
	 +dXWW3AXbcqerPaLYiL/R++vzGPAjoDiY+vDWimj7Ka0794Ozp6DEykqVYFYYatDxow==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793310291;
	h=DMARC-Filter:Received:Received:DKIM-Signature:Date:From:To:Cc:
	 Subject:Message-ID:References:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To;
	bh=Xrs5nmJVJab8tRZxFKVKeWjGi/2IO56BZp571uVAax4=;
	b=gVQCIb/OzBgr6Hq2oM4dYNofsuDQ0zvvUpOpY7xicngDN2ufXuk94WFLzP0OhQritw5H
	 H5P5Y2kC93f6rkywAXGT4HMGxRefw26pLPFnJPl4EYk7gkwpilGtTzipAsZ74J0sQP9vg
	 yLLeHHO+7i5U/3Z6cv2t/90lJ7YfoNh+vdbI0HBAuEa28yVAwB2AsGJSs6AfbHO6XhdZW
	 TindTuHmds/7PcR8IYOKjEdkVRqAHYREIlwOJARo6bduAOh+GXwe1FwumnRIzGRE8EdXD
	 dcAipF00qvQHWIMHqyYh/EjovvYhkkvy3PGhwPRY4fBq/fhqGD82BG7t8ZmXh9hRNQw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=arm.com;
	spf=pass smtp.mailfrom=arm.com;
	arc=none smtp.remote-ip=217.140.110.172
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 65830606A31C
	for <kvmarm@lists.linux.dev>; Thu, 29 Oct 2026 21:44:40 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 65830606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 7CBD11682;
	Thu, 29 Oct 2026 14:44:36 -0700 (PDT)
Received: from arm.com (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 807CA3F59E;
	Thu, 29 Oct 2026 14:44:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1793310279; bh=1Jc6BQnB39kf9zB+DQFACw/SOjdeZK68FOMqJEkdGZw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ZvaTBnXwk4vEh9RGdEieYrP+lcbbLQFeswH4ozshE0llEbLfdUJT22PqsrlbpTnwp
	 RPeiQtuyX1sWs06Kh6O1kM+aQZudBXMLuPvlUaKRZ5/1cxj3tLJSYILv7GVESBB/H/
	 MsCtUL3cBXEqH4nzkhbDr5bv3ZjwFLSEy4lCwIq8=
Date: Thu, 29 Oct 2026 21:44:31 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: Fuad Tabba <fuad.tabba@linux.dev>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>,
	kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Steffen Eiden <seiden@linux.ibm.com>, Will Deacon <will@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Steven Price <steven.price@arm.com>,
	Yang Shi <yang@os.amperecomputing.com>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>, Fuad Tabba <tabba@google.com>,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/4] KVM: arm64: Clear the whole hugetlb folio when
 sanitising MTE tags
Message-ID: <auO-Pzqy-bp8fT4m@arm.com>
References: <20261021110700.493315-1-fuad.tabba@linux.dev>
 <20261021110700.493315-2-fuad.tabba@linux.dev>
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
In-Reply-To: <20261021110700.493315-2-fuad.tabba@linux.dev>

On Wed, Oct 21, 2026 at 12:06:57PM +0100, Fuad Tabba wrote:
> sanitise_mte_tags() clears the tags of the pages about to be mapped at
> stage-2 before marking them tagged. For a hugetlb folio the flag covers
> every page in the folio, but the loop only covers the mapping being
> installed. Stage-2 maps a folio in pieces for the contiguous hugetlb
> sizes, and for any size under dirty logging. The first fault then marks
> the whole folio after clearing only its own piece, and the rest keeps
> its previous owner's tags for the guest to read.
> 
> Clear the whole folio, as mte_sync_tags() does.
> 
> Fixes: 25c17c4b55def ("hugetlb: arm64: add mte support")
> Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> Cc: stable@vger.kernel.org
> Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>

Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
