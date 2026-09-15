Received: from esa4.hc1455-7.c3s2.iphmx.com (esa4.hc1455-7.c3s2.iphmx.com [68.232.139.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B503B3B05AF
	for <kvmarm@lists.linux.dev>; Tue, 15 Sep 2026 23:27:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=68.232.139.117
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789514861; cv=none; b=s5no8NYdxxrhAin4CPgJpHmr8p0vLGAUFKTrvvOANKYT6dN06Ue4LNlHHa3gkXjvYBx5dnM+HfR6GXsbGIbbmYwnUmWNAgGe0114K2j5Sse2sWqA0ACJqHxG2ARmkvXjOF8n0r9xEVFZJJbPJb23rSTeLQ5P/wDV3NiRy7ZtANg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789514861; c=relaxed/simple;
	bh=KSim44TEkk941GEs+6Vkv7QcLI3hbxOBT/IOZZGSsEc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=o8SJ+PzcsfGDr0Ryz7wWQu6MyleTE2rPEZlqq+baCNt+uYE4U2npC07D4RmB4YmfXxptIKslncOHj/cig6lxNKIqKvC9e2oHaWAiwHm6NJUvO9zrphbHVBTS2T0KL6T9dX1jbnru2UcE2QMeI2VblFmH2SgRge5nvlaCgIfuZkw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fujitsu.com; spf=pass smtp.mailfrom=fujitsu.com; dkim=pass (2048-bit key) header.d=fujitsu.com header.i=@fujitsu.com header.b=XqmQMjrl; arc=none smtp.client-ip=68.232.139.117
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fujitsu.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fujitsu.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fujitsu.com header.i=@fujitsu.com header.b="XqmQMjrl"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=fujitsu.com; i=@fujitsu.com; q=dns/txt; s=fj2;
  t=1789514860; x=1821050860;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=KSim44TEkk941GEs+6Vkv7QcLI3hbxOBT/IOZZGSsEc=;
  b=XqmQMjrlSA5aoYx7md0VxEdtLX6gRTMjGpZkQuCvB9TYxmAah5x5UPjw
   pwPUCuSyh/PJtXx10SdYYKZFFHeAsIjHD6phFrLNasmR3EFqn+j+/0qLM
   R04sdIlvl+VLNCa8vs1gYb1JyTnYm3LHcKzmNcrQFPfUb0R9Oesl7sm8g
   GcgcCs+/47XN7wlULIWWI+Wb8wWamGZtmO4M8YHCVT+qVujdRsW4FNRo4
   aQOvIJ5HevUdy8UeSh1olntCq21kNL44uYI5uwvQ0/J8QdlY5LuAjRb3W
   bU19vebZ6LQU8cGiO8xCxJ1MjgCBJgu54J0Ghss+2Wx2HZ3G4B8wiv5CA
   A==;
X-CSE-ConnectionGUID: 4WeRfq4ySVyza9sdQ0u3xQ==
X-CSE-MsgGUID: +3xEkE9YTAeRoZvpv2CrjA==
X-IronPort-AV: E=McAfee;i="6800,10657,11905"; a="254674025"
X-IronPort-AV: E=Sophos;i="6.27,103,1786978800"; 
   d="scan'208";a="254674025"
Received: from gmgwnl01.global.fujitsu.com ([52.143.17.124])
  by esa4.hc1455-7.c3s2.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Sep 2026 08:27:31 +0900
Received: from az2nlsmgm4.fujitsu.com (unknown [10.150.26.204])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by gmgwnl01.global.fujitsu.com (Postfix) with ESMTPS id 9F0CD100034D
	for <kvmarm@lists.linux.dev>; Tue, 15 Sep 2026 23:27:31 +0000 (UTC)
Received: from az2nlsmom1.o.css.fujitsu.com (unknown [10.150.26.198])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by az2nlsmgm4.fujitsu.com (Postfix) with ESMTPS id 50ED010003A5
	for <kvmarm@lists.linux.dev>; Tue, 15 Sep 2026 23:27:31 +0000 (UTC)
Received: from sm-arm-grace07 (unknown [10.124.178.20])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by az2nlsmom1.o.css.fujitsu.com (Postfix) with ESMTPS id 4878A8288F1;
	Tue, 15 Sep 2026 23:27:25 +0000 (UTC)
Date: Wed, 16 Sep 2026 08:27:22 +0900
From: Itaru Kitayama <itaru.kitayama@fujitsu.com>
To: Wei-Lin Chang <weilin.chang@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>, Fuad Tabba <fuad.tabba@linux.dev>,
	Joey Gouly <joey.gouly@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
	Wang Han <wanghan@linux.alibaba.com>,
	Shuai Xue <xueshuai@linux.alibaba.com>,
	"Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Subject: Re: [PATCH v6 0/7] KVM: arm64: nv: Implement nested stage-2 reverse
 map
Message-ID: <aqnUWp_VJXUCcJnQ@sm-arm-grace07>
References: <20260915154305.3852871-1-weilin.chang@arm.com>
 <aqm9hXB6X9IQ8wHz@sm-arm-grace07>
 <m6ldbr7hdafmoycx7xjcbsg62mblcakcu52ndowwzqgxdjb3q3@huv4i5bfxtza>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m6ldbr7hdafmoycx7xjcbsg62mblcakcu52ndowwzqgxdjb3q3@huv4i5bfxtza>

On Wed, Sep 16, 2026 at 12:22:30AM +0100, Wei-Lin Chang wrote:
> On Wed, Sep 16, 2026 at 06:49:57AM +0900, Itaru Kitayama wrote:
> > On Tue, Sep 15, 2026 at 04:42:58PM +0100, Wei-Lin Chang wrote:
> > > Hi,
> > > 
> > > This is v6 of optimizing the shadow s2 mmu unmapping during MMU
> > > notifiers.
> > > 
> > > This version fixes a few issues, and adds Marc's space optimization
> > > for kvm_guest_s2_mapping [1]. Please see the changelog for the details.
> > > 
> > > Tested by booting L3, and running in-kernel targetted tests described
> > > in [2]. v5 got some tested-by's from Itaru and Wang (thanks), I didn't
> > > carry them over since some bugs fixed in v6 are non-obvious. Some
> > > retest would be much appreciated!
> > 
> > How did you boot into L3, with KVM selftest or recrusively boot on HW?
> 
> I just recrusively booted VMs on hardware. :)

Good. Then I actually tried that on Grace CPUs, but letting L1 boot 
with nested mode did not print "VHE+NV2" KVM init log in dmesg, thus not
able to boot L3. Do I need to add other than kvm.arm-mode=nested to command line?

Thanks,
Itaru.

> 
> Thanks,
> Wei-Lin Chang
> 
> > 
> > Thanks,
> > Itaru.
> > 
> 
> [...]
> 
