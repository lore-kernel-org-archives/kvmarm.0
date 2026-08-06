Received: from out30-133.freemail.mail.aliyun.com (out30-133.freemail.mail.aliyun.com [115.124.30.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB1B5314D18
	for <kvmarm@lists.linux.dev>; Thu,  6 Aug 2026 06:52:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785999123; cv=none; b=OqCU7ZoYyz2Igtp+JVOO68DlxKoSS3V2t6/bd/MqdId0akS1TrbA266NhQSLk/HO4X/pIpnrHpdWQvWzzR/rUFGRF7pev1gbURdtGup6okQyYBaCkR8Yu94Ze/U4Hqb+YzUnzBWYz4q3v0X9lSMvQOQA0eZ+tCGxCxHdTw+XeD8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785999123; c=relaxed/simple;
	bh=vkG8XIqRe+o8AgwJqlAVMeUNOmNm0mUbnlXEHa/a/14=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=o2PNe9etdgPlai5+N4FjLwy8OA0uEeduJg3OxkqaG0xA7pX+wCjzgERq8il42an8ml8UnmCa9obfaUeYrEWcueMbX3/BhWNk4QFsF7lVxExeDGa//QoLQD3/oqRffXLfHtAPz0Hc8KDL5+JpZrLw9UTJ4a3Jyu2ONm5DBy+8XQ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=r5kLjVWj; arc=none smtp.client-ip=115.124.30.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="r5kLjVWj"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1785999118; h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type;
	bh=aGK/RoC19nUT02iTa9oP7JFher0vxY/EWJohRihzv6k=;
	b=r5kLjVWjQyf39TRWFihnyL0MDzQWHeNVWN/QHW+7QcnbIGUvWMtGNM9PQom+r2HiMxJRKaK+kArfIC+B25/Qcx+eCJqhhA460yWNdQFU92v6etRY7xKdt/yQRIG2xrai/UXN4QbphQLBd8xWm3PX9+vRrzU2866HdBm/kZVoUAU=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R111e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037009110;MF=yaoyuan@linux.alibaba.com;NM=1;PH=DS;RN=15;SR=0;TI=SMTPD_---0X8TCDP1_1785999116;
Received: from localhost(mailfrom:yaoyuan@linux.alibaba.com fp:SMTPD_---0X8TCDP1_1785999116 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 06 Aug 2026 14:51:57 +0800
Date: Thu, 6 Aug 2026 14:51:55 +0800
From: Yao Yuan <yaoyuan@linux.alibaba.com>
To: Mark Brown <broonie@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>, Joey Gouly <joey.gouly@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Shuah Khan <shuah@kernel.org>, Fuad Tabba <tabba@google.com>, 
	Oliver Upton <oupton@kernel.org>, Peter Maydell <peter.maydell@linaro.org>, 
	linux-arm-kernel@lists.infradead.org, linux-doc@vger.kernel.org, kvmarm@lists.linux.dev, 
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v18 03/14] KVM: arm64: Manage GCS access and registers
 for guests
Message-ID: <rduid57zbypxwiujgfez67walqgqkekhyktkbibtiqcjh5buge@jqqcu52yl5nc>
References: <20260803-arm64-gcs-v18-0-fd8c40f5ad88@kernel.org>
 <20260803-arm64-gcs-v18-3-fd8c40f5ad88@kernel.org>
 <enhoyivbkdaacgyazubgfzftt34xjemtrybvgpuqvr4czjtbhm@7qvrce5lmdyw>
 <6d63905e-8c6e-4c88-b60b-d34ab1401783@sirena.org.uk>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6d63905e-8c6e-4c88-b60b-d34ab1401783@sirena.org.uk>

On Wed, Aug 05, 2026 at 01:32:26PM +0800, Mark Brown wrote:
> On Wed, Aug 05, 2026 at 05:48:04PM +0800, Yao Yuan wrote:
> > On Mon, Aug 03, 2026 at 11:56:48PM +0800, Mark Brown wrote:
>
> > >
> > >  		if (ctxt_has_s1poe(&vcpu->arch.ctxt))
> > >  			write_sysreg_el1(__vcpu_sys_reg(vcpu, POR_EL2), SYS_POR);
> > > +
> > > +		if (ctxt_has_gcs(&vcpu->arch.ctxt)) {
> > > +			write_sysreg_el1(__vcpu_sys_reg(vcpu, GCSCR_EL2), SYS_GCSCR);
> > > +			write_sysreg_el1(__vcpu_sys_reg(vcpu, GCSPR_EL2), SYS_GCSPR);
> > > +		}
>
> > Looks the s1pie checking for GCS vEL2 context switch is
> > necessary yet IIUC, KVM does vEL2 context switch for nested
> > L1's EL2, it should follow same rule as non-nested L1's EL1
> > context switch.
>
> Right, it's not really needed in either case but hopefully helps code
> generation a bit.  Thanks for spotting that.
>
> Please delete unneeded context from mails when replying.  Doing this
> makes it much easier to find your reply in the message, helping ensure
> it won't be missed by people scrolling through the irrelevant quoted
> material.

Sure. let me try delete more next time.
I delete some but decide to leave the whole context switch
diffs to help other guys to see the realted changes when
read my comment.
