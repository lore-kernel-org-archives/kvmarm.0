Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 16C71326952
	for <kvmarm@lists.linux.dev>; Fri, 27 Feb 2026 17:04:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772211850; cv=none; b=IXrJoS4xtTkxFZosu/33N/MiwKXp8SIIdUcw56n1kVWFA9barS8rAcc7Pu+f+wANX3OwdQtQs0W2kBrGDclha44rlXEcB/zg83xLwvYDhFP0T5KRW3IiEXEsK+KnnF04QlI6m1NVuo57BGArQvW69Ks/fYerCxbVQP/zDEo/9Ks=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772211850; c=relaxed/simple;
	bh=k7qGFv2TnDZxF63BSsh/tQM8hrU5ZueyqeqiDCPZNAo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZxcY1xheD5sxLQMrlI1oHVwF8TRRVewIiFwz2vvoe1B1zViaJbeAv0dKe/Poh48Up4bczSOlADwQfbBL5a0dkDAi+7yot96+GgITsi7KQXItee08SYIO0ZnQZay3/nAZle4MF5r0XX4pOIaxhOKSqOAHaw9WufTG43eL9sVz9g8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 5AE9D14BF;
	Fri, 27 Feb 2026 09:04:02 -0800 (PST)
Received: from arm.com (arrakis.cambridge.arm.com [10.1.197.46])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id BD8263F73B;
	Fri, 27 Feb 2026 09:04:03 -0800 (PST)
Date: Fri, 27 Feb 2026 17:04:01 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: Ben Horgan <ben.horgan@arm.com>
Cc: amitsinght@marvell.com, baisheng.gao@unisoc.com,
	baolin.wang@linux.alibaba.com, carl@os.amperecomputing.com,
	dave.martin@arm.com, david@kernel.org, dfustini@baylibre.com,
	fenghuay@nvidia.com, gshan@redhat.com, james.morse@arm.com,
	jonathan.cameron@huawei.com, kobak@nvidia.com, lcherian@marvell.com,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	peternewman@google.com, punit.agrawal@oss.qualcomm.com,
	quic_jiles@quicinc.com, reinette.chatre@intel.com,
	rohit.mathew@arm.com, scott@os.amperecomputing.com,
	sdonthineni@nvidia.com, tan.shaopeng@fujitsu.com,
	xhao@linux.alibaba.com, will@kernel.org, corbet@lwn.net,
	maz@kernel.org, oupton@kernel.org, joey.gouly@arm.com,
	suzuki.poulose@arm.com, kvmarm@lists.linux.dev,
	zengheng4@huawei.com, linux-doc@vger.kernel.org
Subject: Re: [PATCH v5 00/41] arm_mpam: Add KVM/arm64 and resctrl glue code
Message-ID: <aaHOgZFWnjMHNirr@arm.com>
References: <20260224175720.2663924-1-ben.horgan@arm.com>
 <6051a508-1e77-4216-9b41-4b93b21c18c3@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6051a508-1e77-4216-9b41-4b93b21c18c3@arm.com>

On Wed, Feb 25, 2026 at 09:10:08PM +0000, Ben Horgan wrote:
> On 2/24/26 17:56, Ben Horgan wrote:
> > The main change in this version of the mpam missing pieces series is to
> > update the cdp emulation to match the resctrl interface. L2 and L3
> > resources can now enable cdp separately. Cdp can't be hidden correctly for
> > memory bandwidth allocation, as max per partid can't be emulated with more
> > partids, and so we hide this completely when cdp is enabled. There is a little
> > restructuring and a few smaller changes.
> > 
> > Changelogs in patches
> > 
> > It would be great to get this series merged this cycle. For that we'll need
> > more testing and reviewing. Thanks!
> > 
> 
> There is a small build conflict with resctrl abmc precursors, [1]. The
> last patch of that series applies on top of this series and if the abmc
> precursors go first that patch should go with this series to fix the
> build. Alternatively, if it's obvious ahead of time it can be squashed
> into pathc 33 with the other empty resctrl arch hooks.
> 
> [1]
> https://lore.kernel.org/lkml/20260225201905.3568624-5-ben.horgan@arm.com/

Typically we resolve these by having the first three patches in the
above series on a stable branch (could be tip as it touches x86) and we
can base the 41 patches here on top, together with the last one from the
abmc series.

Alternatively, happy to take them all via the arm64 tree as long as
Reinette/Tony are ok with this and ack the abmc patches.

-- 
Catalin
