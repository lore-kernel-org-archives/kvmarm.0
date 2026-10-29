Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.140.110.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793311483;
	b=THgJ2Xh5HEsCOB4B5GK4qx3Zw+jba4CPCu2WLP3xkpBayB6yrWdSCBrcaPBSSUxNn4KG
	 k6QvV+wom8L4AlC080TCt8ZuT/sKiW8OC7L6J/2gMoWsMnP46yJej0c3SFEIWRgUZlHKB
	 DdMPFbq5Grr/6U2wUdDFdt9fSiBEWcfOdhiuf96nOsPD+ZWoE13wwSuhz4/ydw9e4qY0J
	 Wgq2DnxwGCbqRehhRfavg/qwJbTE4Ki/zb4FduSH/ueY6Y6pSzon7uoqSZvCcdz293COa
	 9CwCimyOoxrR6R/hqoze1PbnAnxqde7yeox9JeitxMp8NT80VurRRNnZkXAnzmk81HQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793311483;
	h=DMARC-Filter:Received:Received:DKIM-Signature:Date:From:To:Cc:
	 Subject:Message-ID:References:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To;
	bh=qYbQzwwz9h4FO+VW0r/egh1lxyBMUI0Ck4LAOJSy2I0=;
	b=l6lbDD1jR2JtWx2ip8WP+loi99COj9oUaFv4autl7L3UC3iSSdWfGJLDfWOiJpwhnAUQ
	 FIVqGCE2TqUoOWgQDUzviUl3+iNnl58+LYr2H20hhCO/ajo5pr9Y/QIjTCLlY9Ek3S3Zu
	 R8jh8wcyClHm9imVvwbd2jatT7EgxZqKwG0spX1ZnIXCcZ3KB1Tpvnbe1kt8/Vn1ey99j
	 YgXeG/95uv1Jd5Nhkh2tHl52U3WUwCvHMoquNc2kzgAYRsjbojDuJUgvW4dnFUgoIYVqL
	 qXzF+cMI/E2Ck7v8thdPp+M1WV7r03unfEalaelWuljpDLn7ScYWeTR75GuqZdR8A4w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=arm.com;
	spf=pass smtp.mailfrom=arm.com;
	dkim=pass header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=upv+BRLR;
	arc=none smtp.remote-ip=217.140.110.172
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B101E606A31C
	for <kvmarm@lists.linux.dev>; Thu, 29 Oct 2026 22:04:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B101E606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=upv+BRLR
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id CD07815A1;
	Thu, 29 Oct 2026 15:04:38 -0700 (PDT)
Received: from arm.com (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id DE4453F673;
	Thu, 29 Oct 2026 15:04:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1793311481; bh=cF8ZXU+yg8O7anxbXOyalOzsUNIxFJB1v9XBEV+iq38=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=upv+BRLRwQd8M2cIlnBmc1JNLj9LEYmnebc9S1iNqq1j4x5hI/D9+E1myTzbd/rym
	 1p/DchbDZg2h79bXS7E+j03dg7Lpn9wXbnSDrELDsekIhhybEFQAAIGGco0MdD6FYB
	 hPBp7C8PNo1dzEk0Ho99RvctNqSedz751cjm88fU=
Date: Thu, 29 Oct 2026 22:04:37 +0000
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
Subject: Re: [PATCH v2 3/4] KVM: arm64: Sanitise MTE tags when a permission
 fault installs a mapping
Message-ID: <auPC9aOxXE1mIJn7@arm.com>
References: <20261021110700.493315-1-fuad.tabba@linux.dev>
 <20261021110700.493315-4-fuad.tabba@linux.dev>
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
In-Reply-To: <20261021110700.493315-4-fuad.tabba@linux.dev>

On Wed, Oct 21, 2026 at 12:06:59PM +0100, Fuad Tabba wrote:
> The stage-2 fault path sanitises MTE tags only on translation faults, as
> a permission fault normally just relaxes an existing leaf. However, when
> the page is backed by a THP, a permission fault at page granule installs
> a block whose other pages may never have been mapped or sanitised. Once
> dirty logging is off, a guest write to a page mapped read-only during
> logging installs the block, and the guest can read the tags those pages'
> previous owners left.
> 
> Sanitise whenever the fault path calls kvm_pgtable_stage2_map() rather
> than relaxing permissions. If the VMM replaces the VMA after the guest
> takes a permission fault but before vma_lookup(), that path would map
> and sanitise memory from the new VMA without checking it. Run the
> VM_MTE_ALLOWED check in kvm_s2_fault_compute_prot() on permission
> faults too.
> 
> Fixes: ea7fc1bb1cd1b ("KVM: arm64: Introduce MTE VM feature")
> Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> Cc: stable@vger.kernel.org
> Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>

Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
