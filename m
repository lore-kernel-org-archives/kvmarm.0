Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 390211C8610
	for <kvmarm@lists.linux.dev>; Thu, 26 Jun 2025 08:53:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750928017; cv=none; b=iidEiNvNu/4NWe4YtZiEj+dS5yeg64rTGPINSU11uN5hQF4JkgpNoXh5Q0ozycJs8RN6DxJstFxxJtHpnCw/Nv7SYBKUK7jDbnCJTzdqHOp1XCmSxrz5ezLTn/5DyFvSv+KyrAvUxar8GSRycnxVpUT6XjqpH+icqVIQGfE54xU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750928017; c=relaxed/simple;
	bh=qjCW5fANYpBxZMos/0B9Lmzp0fOKP2cSn0Aj7JueaHQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=RACe5dYR/wJRZDiMA2E61BPitoBAgc/VFvRhDfairzO3p/n9Gdzk8ixHeKlcHtZjZDjlMm7hLnt3b1HY+Jz8Ly4QbE2CAnOmd0BRHbHuiBRjPmb3M/JqLEIQYuvvb+0tUwhB/KxK8XUh1pk5///lQxU7GSdqLi/fLY5wVZWFQVU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=icBIYPOP; arc=none smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="icBIYPOP"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1750928016; x=1782464016;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=qjCW5fANYpBxZMos/0B9Lmzp0fOKP2cSn0Aj7JueaHQ=;
  b=icBIYPOPcX3lU+RwIN10hhshbJEo8Q+NweJ+8zjGD2Z4JDqKvya2i/td
   G7rqmGc/rU9CvN1F2UACmmKOIuX5oxUIIuW7IqkrxjOKwkfA7VoyLZTbd
   DCvUHdm2jsTx8i1fB4LtvZe4x5ZpvxL9i0cbFGO8MkgKffqwM4wEVaVGr
   AWJ89zALK+Gz/8INzbSfwoyXmjEVNO087zza6r/JedeE73N8MUdxerozP
   jKT3JpeJGF5u1vcYP+bpal3ffk9toplq7LvemliMt2fugwHx5nQrxqj1K
   Wo3Jnp0c/B7uJZBBwuwq1k1vpehl79ZcJcwn2L73tVhOlZwLuFPV7gCac
   Q==;
X-CSE-ConnectionGUID: F+tSyue1R2C7vDuy7AdTnA==
X-CSE-MsgGUID: jkOO9NDUQhmAe6pMO9yIVg==
X-IronPort-AV: E=McAfee;i="6800,10657,11475"; a="64649481"
X-IronPort-AV: E=Sophos;i="6.16,267,1744095600"; 
   d="scan'208";a="64649481"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jun 2025 01:53:36 -0700
X-CSE-ConnectionGUID: MYHDrDs1T4GgRk7RUyBgsQ==
X-CSE-MsgGUID: BuxoA7uNSmmxTflue01UJg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,267,1744095600"; 
   d="scan'208";a="151975111"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.247.1]) ([10.124.247.1])
  by orviesa006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jun 2025 01:53:33 -0700
Message-ID: <b8b3f43d-5e02-4072-8954-1f0c6f80eaae@intel.com>
Date: Thu, 26 Jun 2025 16:53:28 +0800
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 1/5] KVM: x86: Replace growing set of *_in_guest bools
 with a u64
To: Sean Christopherson <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>,
 Oliver Upton <oliver.upton@linux.dev>
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org,
 Jim Mattson <jmattson@google.com>
References: <20250626001225.744268-1-seanjc@google.com>
 <20250626001225.744268-2-seanjc@google.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <20250626001225.744268-2-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 6/26/2025 8:12 AM, Sean Christopherson wrote:
> From: Jim Mattson <jmattson@google.com>
> 
> Store each "disabled exit" boolean in a single bit rather than a byte.
> 
> No functional change intended.

Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>

