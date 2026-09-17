Received: from esa1.hc1455-7.c3s2.iphmx.com (esa1.hc1455-7.c3s2.iphmx.com [207.54.90.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F7DD40927A
	for <kvmarm@lists.linux.dev>; Thu, 17 Sep 2026 21:46:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=207.54.90.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789681581; cv=none; b=BH4dFYPrNYZWVTPDwILhVHKbwiPk9ScJJUPVJaLe+UVvIHw06Zj1ycbxcZBblYit+SeG3k2ZMMyzf4NCrnHBMJ56g5uOcAyHhF7E9UMm9RcYwUwB0ltcq4nSyG2VwoN5vuBeMHHdqZtgYrBP8cxeK/fN1YEHY3F/oJkJuRZZl48=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789681581; c=relaxed/simple;
	bh=G6VEcTe0RdoY9YKFGLw9AYrd5zP6uMtJfwKDShjkvKg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=c2Qgl1QGq3geViDasTx2meG3MCXmMANkgcY/FuAVdcR7J8Lhqpj6xdNwQcXMRZi3+o9AVT43F23agdQnavdZFZMCdUnPF0yyKvP3JgTlhFLfCdFk6SCZehdT2JQHNhsy0qLyLbzBsQI98JqQ0jC8vwzZXL0fNYCD81MciW3JP9Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fujitsu.com; spf=pass smtp.mailfrom=fujitsu.com; dkim=pass (2048-bit key) header.d=fujitsu.com header.i=@fujitsu.com header.b=TpWhrh1e; arc=none smtp.client-ip=207.54.90.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fujitsu.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fujitsu.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fujitsu.com header.i=@fujitsu.com header.b="TpWhrh1e"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=fujitsu.com; i=@fujitsu.com; q=dns/txt; s=fj2;
  t=1789681580; x=1821217580;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=G6VEcTe0RdoY9YKFGLw9AYrd5zP6uMtJfwKDShjkvKg=;
  b=TpWhrh1eezeWYBkjVBx6wcY99EXBuUggkzP30JtbcX5ZRgRjan0/HdND
   vlCU8bmP2aFOQuFun/ZClieR34NdwEdnbN4lD3TLdOK9Ez/qUyie63OXk
   +j58W0dv1JlwJ+EIcsaiq5eHDdFGqUFALh8ZP3Zc0ujQZd1UtWUC246DK
   DntHZCGE0ASsI3QXMswOSW4v3inng+xosPtER2md1/o+Iuw2y0A1cSfIx
   7svsFoOsw5jIu/0WkbVG9I8B3oLU2VK5i5FTfVaOPVN/vxLcwlMxlbQZ1
   LlM1hRW0aA39fryOxSQukqNg8/E80gXZIQMRPbk6Wuuy7nC9nr9cJUAHO
   w==;
X-CSE-ConnectionGUID: IAJgTk7KSuqFdCXw/jNKvQ==
X-CSE-MsgGUID: E1zLTjlPRrC3Gk0ScuY+ng==
X-IronPort-AV: E=McAfee;i="6800,10657,11905"; a="255411695"
X-IronPort-AV: E=Sophos;i="6.27,103,1786978800"; 
   d="scan'208";a="255411695"
Received: from gmgwuk01.global.fujitsu.com ([172.187.114.235])
  by esa1.hc1455-7.c3s2.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Sep 2026 06:46:12 +0900
Received: from az2uksmgm4.o.css.fujitsu.com (unknown [10.151.22.201])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by gmgwuk01.global.fujitsu.com (Postfix) with ESMTPS id 28C1E1C1C705
	for <kvmarm@lists.linux.dev>; Thu, 17 Sep 2026 21:46:12 +0000 (UTC)
Received: from az2nlsmom2.o.css.fujitsu.com (unknown [10.150.26.200])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by az2uksmgm4.o.css.fujitsu.com (Postfix) with ESMTPS id D20731400600
	for <kvmarm@lists.linux.dev>; Thu, 17 Sep 2026 21:46:11 +0000 (UTC)
Received: from sm-arm-grace07 (unknown [10.124.178.20])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by az2nlsmom2.o.css.fujitsu.com (Postfix) with ESMTPS id 9AB4618002F1;
	Thu, 17 Sep 2026 21:46:05 +0000 (UTC)
Date: Fri, 18 Sep 2026 06:46:02 +0900
From: Itaru Kitayama <itaru.kitayama@fujitsu.com>
To: Marc Zyngier <maz@kernel.org>
Cc: Wei-Lin Chang <weilin.chang@arm.com>,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org, Oliver Upton <oupton@kernel.org>,
	Fuad Tabba <fuad.tabba@linux.dev>, Joey Gouly <joey.gouly@arm.com>,
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
Message-ID: <aqxfmvvHlCwemeNp@sm-arm-grace07>
References: <20260915154305.3852871-1-weilin.chang@arm.com>
 <aqm9hXB6X9IQ8wHz@sm-arm-grace07>
 <m6ldbr7hdafmoycx7xjcbsg62mblcakcu52ndowwzqgxdjb3q3@huv4i5bfxtza>
 <aqnUWp_VJXUCcJnQ@sm-arm-grace07>
 <86ld9165cr.wl-maz@kernel.org>
 <aquN5ytDxt44uORD@sm-arm-grace07>
 <867bkk5n07.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <867bkk5n07.wl-maz@kernel.org>

On Thu, Sep 17, 2026 at 08:56:56AM +0100, Marc Zyngier wrote:

> What have you tested exactly? If you're not able to boot a working L1
> guest as a NV2 hypervisor, you're probably doing something wrong.

Can you just stop being dismissive, if you can?

Thanks,
Itaru.

> 
> 	M.
> 
> -- 
> Without deviation from the norm, progress is not possible.
