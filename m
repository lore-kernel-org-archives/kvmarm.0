Received: from out-173.mta1.migadu.com (out-173.mta1.migadu.com [95.215.58.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C5BF47773
	for <kvmarm@lists.linux.dev>; Mon, 12 Feb 2024 20:55:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707771315; cv=none; b=J5Iyh70LyaQUk/4yfCswjUJysTi8UrKmh6pvY44lK6cREEIAVKhVGt7kmHFAjU5bm62d1XA/APZSvp7YtUT295KSE8GdC6P3msT0InAKHnlhfq2ThbkFZVFp9N0ZvJAoIS5KBJUY854/mlCH88J41p5S0KJskstuMXEDUqdYe80=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707771315; c=relaxed/simple;
	bh=hYrwD2jyM1YoV8NSAy83Vgp5NfJRs9jP9j3gkH0cboE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jMiPYUAYf/7a5dwTeixq0Fo80j+lRHZw/WN96wQX6V9yspc8HzpnJhQim+IZoM5w2bGltIHEia5cyo5l5sJYOuGMrAkptVkHk2/PI9ElVKaT+3ZwH+qNUDyxK6UdKbv81MOhnhuzzDncp9g8I6h8MKnvM+YBoX36i1c5+1eVVCk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=fx6X2FZm; arc=none smtp.client-ip=95.215.58.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="fx6X2FZm"
Date: Mon, 12 Feb 2024 20:55:02 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1707771311;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Jg+S1eA0mQzeAlYCXpsQrlGlqFnthigQE9V3fAICXlU=;
	b=fx6X2FZmzNXQV2YECP4e4BbYmms09hnPPo30mpZJ6dQkvs0BcZBOrPY1HgwJKFD2nfrPMP
	tfrP/TfFxIvrJUc1UUnxCWRPH56IsEQfyDm8IB5xrQ3H3vHDyKRL92mPMwhW6mixiJP4qM
	g6ZzuPUSdy7kXr1jGEC9gi0RBBVzSKA=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Sean Christopherson <seanjc@google.com>
Cc: Marc Zyngier <maz@kernel.org>, linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org,
	Anup Patel <anup@brainfault.org>
Subject: Re: [PATCH] KVM: selftests: Fix GUEST_PRINTF() format warnings in
 ARM code
Message-ID: <ZcqFpn9y4eHfkRJX@linux.dev>
References: <20240202234603.366925-1-seanjc@google.com>
 <ZcqEk16eBKovb-hb@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZcqEk16eBKovb-hb@linux.dev>
X-Migadu-Flow: FLOW_OUT

Dammit, forgot to actually CC Anup. I'll blame jet lag.

On Mon, Feb 12, 2024 at 08:50:38PM +0000, Oliver Upton wrote:
> +cc Anup
> 
> FYI -- this patch is touching the arch_timer code. I did a test merge
> with kvm_riscv_queue and there weren't any conflicts, but in case that
> changes this patch will appear on kvm-arm64/misc in my tree.
> 
> -- 
> Thanks,
> Oliver
> 
> On Fri, Feb 02, 2024 at 03:46:03PM -0800, Sean Christopherson wrote:
> > Fix a pile of -Wformat warnings in the KVM ARM selftests code, almost all
> > of which are benign "long" versus "long long" issues (selftests are 64-bit
> > only, and the guest printf code treats "ll" the same as "l").  The code
> > itself isn't problematic, but the warnings make it impossible to build ARM
> > selftests with -Werror, which does detect real issues from time to time.
> > 
> > Opportunistically have GUEST_ASSERT_BITMAP_REG() interpret set_expected,
> > which is a bool, as an unsigned decimal value, i.e. have it print '0' or
> > '1' instead of '0x0' or '0x1'.
> > 
> > Signed-off-by: Sean Christopherson <seanjc@google.com>

-- 
Thanks,
Oliver
