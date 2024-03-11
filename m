Received: from out-185.mta0.migadu.com (out-185.mta0.migadu.com [91.218.175.185])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1030A57312
	for <kvmarm@lists.linux.dev>; Mon, 11 Mar 2024 21:21:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.185
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710192100; cv=none; b=EplJc7LO774WY2sShdVav+lu/A+DdvGp+KlMZjryWxA6gC7guEb0eokhHH8AUgC8THvmAknA84gfbpG8pXfRneDK7NAqFCRwcXvS22w3D61OJ8BqypQxYrsqSoGrg9/1P/U/9dFgBqpuZzNAwxZqhkGpkvcKFkAqEBVSUutgUgI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710192100; c=relaxed/simple;
	bh=w4t2z9lIWD6PRlVmGfRKSpZ+qk+SJzuSZHzgHEeBwDk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sIPsSopGMIA0eTqQnPJieLsxn55tQTzzxzwnn9MS89hO4QJ2Vp+GfbUNtM7MPVnTZvG6OROlR4Yc4cMe2G1uGTNm/og4klVELbcRo6H27UDn7d/S604lNpgaDNdNkFVY5oThw++HkxJzxEzbF69D7vtb7pmH5UGnc45WEcHDxQM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=JDc6r03g; arc=none smtp.client-ip=91.218.175.185
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="JDc6r03g"
Date: Mon, 11 Mar 2024 21:21:28 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1710192095;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=GyQ0ysw8I+Q95ceNsfL2Bdbg5666+zaoSDt+ddjY9LE=;
	b=JDc6r03gsNPf53wZFl0XDvL7mhTYjrfpnqQTNNoSWqWDfcaTR08ecf44YiohCQ0EsU6TBF
	4isDDloaexp0JIzyrqLJLiqdhjHyVgx3Aem8VJheIm5l3QRfK8Kr7fyFeUzoUSUfUGY+uy
	RD28Bf23rBh0X9/JqMv4mbSFGzI3rxA=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Anish Moorthy <amoorthy@google.com>
Cc: Sean Christopherson <seanjc@google.com>,
	David Matlack <dmatlack@google.com>, maz@kernel.org,
	kvm@vger.kernel.org, kvmarm@lists.linux.dev,
	robert.hoo.linux@gmail.com, jthoughton@google.com,
	axelrasmussen@google.com, peterx@redhat.com, nadav.amit@gmail.com,
	isaku.yamahata@gmail.com, kconsul@linux.vnet.ibm.com
Subject: Re: [PATCH v7 06/14] KVM: Add memslot flag to let userspace force an
 exit on missing hva mappings
Message-ID: <Ze912ONhTo99RRpR@linux.dev>
References: <20240215235405.368539-1-amoorthy@google.com>
 <20240215235405.368539-7-amoorthy@google.com>
 <ZeuMEdQTFADDSFkX@google.com>
 <ZeuxaHlZzI4qnnFq@google.com>
 <Ze6Md/RF8Lbg38Rf@thinky-boi>
 <Ze8y-vGzbDSLP-2G@google.com>
 <CAF7b7mpgeLJudcT9YhjQOqsXxz07Y9PY1a-F0ts6oVsVJwrnpA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAF7b7mpgeLJudcT9YhjQOqsXxz07Y9PY1a-F0ts6oVsVJwrnpA@mail.gmail.com>
X-Migadu-Flow: FLOW_OUT

On Mon, Mar 11, 2024 at 10:08:56AM -0700, Anish Moorthy wrote:
> I think patches 10/11/12 are useful changes to the selftest that make
> sense to merge even with KVM_MEM_EXIT_ON_MISSING being mothballed-
> they should rebase without any issues. And the annotations on the
> stage-2 fault handlers seem like they should still be added, but I
> suppose David can do that with his series.

Yeah, let's fold the vCPU exit portions of the UAPI into the overall KVM
userfault series. In that case there is sufficient context at the time
of the "memory fault" to generate a 'precise' fault context (this GFN
failed since it isn't marked as present).

Compare that to the current implementation, which actually annotates
_any_ __gfn_to_pfn_memslot() failures on the way out to userspace. I
haven't seen anyone saying their userspace wants to use this, and I'd
rather not take a new feature without a user, even if it is comparably
trivial.

-- 
Thanks,
Oliver
