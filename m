Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A3D0151477D
	for <kvmarm@lists.linux.dev>; Thu, 17 Sep 2026 13:10:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789650623; cv=none; b=d+csnIucDIyj96CIxH/Zyq6SXuNesxsW8XIzuKEPwrAqcdh+xmmkt+L083EhSKXrx6QQupqFQb222QcKlamtac/RNKq5i+05m0AoVQ4jAhbq+n3hb4CY5/W/iRB7eaxXG9f0uicvqh24415hmcfP4c7IkX/oeJne3B/aeshsoTs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789650623; c=relaxed/simple;
	bh=8g2Hl15QHCdOC9CCW8r88cxWOvni9RLKJzm2oJjk8hU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nUq0ZbunDMhj1tQEiFf+9y1CiH/osh2FBWr4WXt2FsW1YlO7awGIo/rcRmKDUfrVh5tn4gfXNf9FfWDYBui+Tkx6lo/wDL+S9AsGISqn5JCFqapKf5UalSzJdjXkLrNht3eU2AMy5ycXmto9NlpAHs3xVNulQNC47l7FXfUHKQc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=NJe9mzHo; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="NJe9mzHo"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 18C83143D;
	Thu, 17 Sep 2026 06:10:14 -0700 (PDT)
Received: from thinkpad-e142931.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id B59773F7B4;
	Thu, 17 Sep 2026 06:10:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1789650617; bh=8g2Hl15QHCdOC9CCW8r88cxWOvni9RLKJzm2oJjk8hU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=NJe9mzHoryiEfw6XtB5v8p8/e2oE3zGCJA7l8BfNRixqxKExCGwFMO8sOWitejOKH
	 hebfkN6+0WygqeddyugzEWlz/aVq/BjEqdTwWeZaLj2pGear6JwdunwS2Ajk9ZNeoi
	 aew8XnHW2Qt/tdO/vbtT+8TuoDxGmvql4AeyXDDA=
Date: Thu, 17 Sep 2026 14:10:00 +0100
From: Wei-Lin Chang <weilin.chang@arm.com>
To: Itaru Kitayama <itaru.kitayama@fujitsu.com>, 
	Marc Zyngier <maz@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-kernel@vger.kernel.org, Oliver Upton <oupton@kernel.org>, 
	Fuad Tabba <fuad.tabba@linux.dev>, Joey Gouly <joey.gouly@arm.com>, 
	Steffen Eiden <seiden@linux.ibm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>, 
	Wang Han <wanghan@linux.alibaba.com>, Shuai Xue <xueshuai@linux.alibaba.com>, 
	"Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Subject: Re: [PATCH v6 0/7] KVM: arm64: nv: Implement nested stage-2 reverse
 map
Message-ID: <rxvpsusccy6xanwik5ierefwi5jgue5ifgqd27pxaxzhbqlovl@odobtcfgizzx>
References: <20260915154305.3852871-1-weilin.chang@arm.com>
 <aqm9hXB6X9IQ8wHz@sm-arm-grace07>
 <m6ldbr7hdafmoycx7xjcbsg62mblcakcu52ndowwzqgxdjb3q3@huv4i5bfxtza>
 <aqnUWp_VJXUCcJnQ@sm-arm-grace07>
 <86ld9165cr.wl-maz@kernel.org>
 <aquN5ytDxt44uORD@sm-arm-grace07>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aquN5ytDxt44uORD@sm-arm-grace07>

On Thu, Sep 17, 2026 at 03:51:19PM +0900, Itaru Kitayama wrote:
> On Wed, Sep 16, 2026 at 08:08:20AM +0100, Marc Zyngier wrote:
> > On Wed, 16 Sep 2026 00:27:22 +0100,
> > Itaru Kitayama <itaru.kitayama@fujitsu.com> wrote:
> > > 
> > > On Wed, Sep 16, 2026 at 12:22:30AM +0100, Wei-Lin Chang wrote:
> > > > On Wed, Sep 16, 2026 at 06:49:57AM +0900, Itaru Kitayama wrote:
> > > > > On Tue, Sep 15, 2026 at 04:42:58PM +0100, Wei-Lin Chang wrote:
> > > > > > Hi,
> > > > > > 
> > > > > > This is v6 of optimizing the shadow s2 mmu unmapping during MMU
> > > > > > notifiers.
> > > > > > 
> > > > > > This version fixes a few issues, and adds Marc's space optimization
> > > > > > for kvm_guest_s2_mapping [1]. Please see the changelog for the details.
> > > > > > 
> > > > > > Tested by booting L3, and running in-kernel targetted tests described
> > > > > > in [2]. v5 got some tested-by's from Itaru and Wang (thanks), I didn't
> > > > > > carry them over since some bugs fixed in v6 are non-obvious. Some
> > > > > > retest would be much appreciated!
> > > > > 
> > > > > How did you boot into L3, with KVM selftest or recrusively boot on HW?
> > > > 
> > > > I just recrusively booted VMs on hardware. :)
> > > 
> > > Good. Then I actually tried that on Grace CPUs, but letting L1 boot 
> > > with nested mode did not print "VHE+NV2" KVM init log in dmesg, thus not
> > > able to boot L3. Do I need to add other than kvm.arm-mode=nested to command line?
> > 
> > kvm-arm.mode=nested, as documented. That also puts in perspective your
> > TB tag on the whole series...
> 
> Yes. Using kvmtool's --nested option did not bring vCPU with the VHE+NV2 boot
> log. The Host kernel is Wei-Lin's version 6 booted on Grace CPUs, and
> the guest kernel is today's kvmarm/fixes plus Wei-Lin's shadow stage 2 ptdump fix.

I'm not sure what you did exactly, but just to be clear, you need to
pass kvm-arm.mode=nested to L1's command line as well, in addition to
kvmtool's --nested option.

./lkvm run --nested -p kvm-arm.mode=nested <...>

Thanks,
Wei-Lin Chang

> 
> Thanks,
> Itaru.
> 
> > 
> > 	M.
> > 
> > 
> > -- 
> > Without deviation from the norm, progress is not possible.
