Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.140.110.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795791931;
	b=amELMX8q9pzp3bwMQ538KNvikdmU/xKq9M52CFhxZfRIh4w36xOf+zDMWAa2/zQfJ0lg
	 PKappVUKlooKV2SBLeu1YBtNx4hGFKotDPdi0AmhCFZTEU4xXvnalqlH2XO0IOw3ZwVzB
	 wR2s4kfSLe7g5oAUAHEgCZNGfdvw/GObPpxCB310UKKgJ4mnhb4IrlwgaFIeqxxCir50F
	 Upo3k07JKH/lJQCA35nanhZnRUERlQk6qT3rSp3TGZL8hcitcGPuaAwiY6wc3fPAgi5Vj
	 rTRFdWDwz/MVswbC5gQo8dXTg80MAvKcEHcRIALUOlru67uOYohvq/a0H8TABgbFWnA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795791931;
	h=DMARC-Filter:Received:Received:DKIM-Signature:Date:From:To:Cc:
	 Subject:Message-ID:References:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To;
	bh=56wtRs1M69TfCxyKRriFEbro7oso/WPBNs4QdzumLlU=;
	b=hIE7egzv5TpeDvAvbmUnXfKqpN31QPAUYXSzXuxNCcq79YlwxTQ6OVSiROEVmqUQiNgz
	 AeHVZvwYrr7E4IYfpJIThhQb8wKOlb+QdlOZixMcrpvfqHrotLN76EqLAcCvYBsZ7mCfV
	 ryunWP/kC+TdcpIHcHS+VdWixYc5AcU0zFkzLrNUsHCFbAazD3Pstg5Czuyr7qIGieNjq
	 AmiR1vdtby3h9JLW9LiUpgb5VlvT1TcnEMmu3ILr3sGXq1Au20NOSdwdb1J1IUCn+E5oI
	 tf2udqBJvevqaNZELZSpYNYye+MmAco7DHfuuCRxA0mRwgx0xyyzIATnUjGiCCi1ckg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=arm.com;
	spf=pass smtp.mailfrom=arm.com;
	dkim=pass header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=bxTk8UKi;
	arc=none smtp.remote-ip=217.140.110.172
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4B58E606A31C
	for <kvmarm@lists.linux.dev>; Fri, 27 Nov 2026 15:05:31 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4B58E606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=bxTk8UKi
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 1131A169E;
	Fri, 27 Nov 2026 07:05:28 -0800 (PST)
Received: from raptor (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 07FD33F632;
	Fri, 27 Nov 2026 07:05:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1795791930; bh=6+qcC6DMiA9X/fESkEBuCB99oeGyTOfZOAFheP/qEaY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=bxTk8UKigkW2i6QP64PKfkBE6TTSh0PM5R8aILg4zrs2oBmGXKQbaHMsfFX73CJ9X
	 +4DFK3cwskxa7I1xlhvClaogtdgO2EjDI+b27iwEyXINlLAt41XeXjn12CV6lA7mwL
	 Mw7UdFo8lKsZTZZYD7ptGl+3kJMSqdFBV6HlVVxY=
Date: Fri, 27 Nov 2026 15:05:25 +0000
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: maz@kernel.org, oupton@kernel.org, fuad.tabba@linux.dev,
	joey.gouly@arm.com, seiden@linux.ibm.com, suzuki.poulose@arm.com,
	yuzenghui@huawei.com, linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev, will@kernel.org, mark.rutland@arm.com,
	linux-perf-users@vger.kernel.org, catalin.marinas@arm.com,
	james.clark@linaro.org, Sudeep Holla <sudeep.holla@arm.com>
Subject: Re: [RFC PATCH v7 11/28] KVM: arm64: Add a new VCPU device control
 group for SPE
Message-ID: <awmcNYh43YWkB7IW@raptor>
References: <20260903160623.315525-1-alexandru.elisei@arm.com>
 <20260903160623.315525-12-alexandru.elisei@arm.com>
 <atI1NfqxWsPOhvBX@gremlin>
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
In-Reply-To: <atI1NfqxWsPOhvBX@gremlin>

Hi Lorenzo,

On Fri, Oct 16, 2026 at 03:44:33PM +0100, Lorenzo Stoakes (ARM) wrote:
> On Thu, Sep 03, 2026 at 05:06:06PM +0100, Alexandru Elisei wrote:
> > From: Sudeep Holla <sudeep.holla@arm.com>
> >
> > Add a new VCPU device control group to control various aspects of KVM's SPE
> > emulation. Functionality will be added in later patches.
> 
> Again fairly thin commit message, be useful to provide more details.
> 
> I'd also explicitly say you're adding stubs and the foundations for this but the
> actual implementation isn't in place yet.

Okay.

> 
> >
> > [ Alexandru E: Major rework ]
> 
> Generally [] stuff is for small fixups done to a patch, so a major rework isn't
> really suited to this form.
> 
> The done thing for this kind of thing I think is something like:
> 
> Co-developed-by: Sudeep Holla <sudeep.holla@arm.com>
> Signed-off-by: Sudeep Holla <sudeep.holla@arm.com>
> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
> 
> Note that you require Sudeep's explicit permission to do this though! :)

Asked Sudeep, he agreed with the Co-developed-by tag. Will update in the next
iteration.

> 
> >
> > Signed-off-by: Sudeep Holla <sudeep.holla@arm.com>
> > Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
> 
> Overall this looks obviously correct (TM), so with the commit message +
> authorship stuff addressed:
> 
> Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

Thanks!

Alex
