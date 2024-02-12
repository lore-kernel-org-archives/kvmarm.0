Received: from out-189.mta0.migadu.com (out-189.mta0.migadu.com [91.218.175.189])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74CC943AA8
	for <kvmarm@lists.linux.dev>; Mon, 12 Feb 2024 20:50:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.189
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707771043; cv=none; b=JFkqr7OHL2K595PufRv0dzw18cniKI9JG/AhnjXOrUwY7SkxecQB7WKRE0jAHMawFHuxVaELgHKNYZJCqUJWDV29aWocVjHkVlW9ZxSYoskM1vy/uPg7bfrPOrW/2lZE32C8ghC7HNk5ObGdoFmGusivyYYm8D3WKby1NIkKOZY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707771043; c=relaxed/simple;
	bh=83/Rq5+9VR33j4Elywo0ZdM8hdp6fKuCdQOKK21jY+g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CYcJW4sqgCIgQywp6PlWg8cXjEKbU1v3iDFLy88D3FrRL9dcLch2i3qKCGsQgDJ5HvkLD2kKecPbzxwx3e17wlhm18gxzCxlDfS8e35dOa64Q7AeeTY0BrokROsfRyGNVWAzUCc+5aW2HZmQsTKgblzirE8rgbvFFsUSFa25+jE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=WbZ6Hs7h; arc=none smtp.client-ip=91.218.175.189
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="WbZ6Hs7h"
Date: Mon, 12 Feb 2024 20:50:27 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1707771038;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=zYpPKL/Y1qQVtjq1JAXZQxRcIoamgeLdOfY6ECA0RJI=;
	b=WbZ6Hs7hakWIivaDx59Q0n3ptB0lNcjUMcBj/8oZgwngQ02s2WPXO5Z9PxO4MUTpUyiiS8
	ID6C8WG10tdl9bUU02Awcs6vMs05uKronOQ4lBYIsvhUMjwnH16bZvOQ0acOh/cOZ5TK/k
	o8N2xr1AMl+l7kvOqRMCBiE+CfFWVB8=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Sean Christopherson <seanjc@google.com>
Cc: Marc Zyngier <maz@kernel.org>, linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM: selftests: Fix GUEST_PRINTF() format warnings in
 ARM code
Message-ID: <ZcqEk16eBKovb-hb@linux.dev>
References: <20240202234603.366925-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240202234603.366925-1-seanjc@google.com>
X-Migadu-Flow: FLOW_OUT

+cc Anup

FYI -- this patch is touching the arch_timer code. I did a test merge
with kvm_riscv_queue and there weren't any conflicts, but in case that
changes this patch will appear on kvm-arm64/misc in my tree.

-- 
Thanks,
Oliver

On Fri, Feb 02, 2024 at 03:46:03PM -0800, Sean Christopherson wrote:
> Fix a pile of -Wformat warnings in the KVM ARM selftests code, almost all
> of which are benign "long" versus "long long" issues (selftests are 64-bit
> only, and the guest printf code treats "ll" the same as "l").  The code
> itself isn't problematic, but the warnings make it impossible to build ARM
> selftests with -Werror, which does detect real issues from time to time.
> 
> Opportunistically have GUEST_ASSERT_BITMAP_REG() interpret set_expected,
> which is a bool, as an unsigned decimal value, i.e. have it print '0' or
> '1' instead of '0x0' or '0x1'.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
