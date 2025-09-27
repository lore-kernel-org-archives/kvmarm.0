Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E4892AE8D;
	Sat, 27 Sep 2025 11:29:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758972590; cv=none; b=SHXSGht07bxRatEDj0AOsy/1vUPks7pt+lKTlP+0NZlXryP0/sHyq7tCVJLLj9VKzsgrx1yqGqKyXpadBdHpxNRtBnaNXckZKx5UkI0VhB/XXd5fcLbi8jXq56W330Vly1JQbEoMIfppsPd8nT4I0DJz50sA6j7s/hL+VwynNb8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758972590; c=relaxed/simple;
	bh=woOJMQVx2gK/ZTrYKUvp8Kze1O8Xv6dnLbcVNoWtA9U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=AP0yOU7FP24+pD99HVBo+UL71Y6Aeo+AZ35YWPkPfq1Kzv9PUiYLjR5zcPgMBGNti/DkdfJWbBjWI+VS9/fUcTfUQIdGMyVACefLxYN0DtQoVYuJ/aPi9TYFhPeOhdBkkayigDouvJsWpy9/6v6F4P518coL18zPN6maPH9EekY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SVgcX3cw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SVgcX3cw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21754C4CEE7;
	Sat, 27 Sep 2025 11:29:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758972590;
	bh=woOJMQVx2gK/ZTrYKUvp8Kze1O8Xv6dnLbcVNoWtA9U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SVgcX3cww3I4jhHCG7p2ABBDtOytr0l9MxhhncYqy5LR8JN5xjlQyUF3pl5FRss0U
	 kyeZAAZrF01Cms/Qa0DPHwW8Jjzr0pNLck4xq5y7BTLcUW/oKuLos+2GxbPcsGa/8i
	 BYMt7JRiLicMmrc26p6bmo82Wyf4/jl+8OJngpMBtWqT8k6SRHtKyvDeHNtuafos98
	 8PREpN34kn2BwkHuHiFubyMPM3l/tYJmn+subZv71IHRQVn4bk39d8IiA/VnN5bHJ8
	 4Jr5gAjstzMheamBOOVLdgUUxsnsA0ix7Y8S+hJ7CniqBhq4gX+zxMoOhLSkWQ4l3b
	 FD21L0Hje1EPQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1v2T7b-00000009rcA-2IVo;
	Sat, 27 Sep 2025 11:29:47 +0000
From: Marc Zyngier <maz@kernel.org>
To: Oliver Upton <oliver.upton@linux.dev>,
	Sean Christopherson <seanjc@google.com>
Cc: linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Sebastian Ott <sebott@redhat.com>
Subject: Re: [PATCH] KVM: selftests: Track width of arm64's timer counter as "int", not "uint64_t"
Date: Sat, 27 Sep 2025 12:29:01 +0100
Message-ID: <175897248729.2798309.11771785872259733527.b4-ty@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20250926155838.2612205-1-seanjc@google.com>
References: <20250926155838.2612205-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: oliver.upton@linux.dev, seanjc@google.com, linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org, sebott@redhat.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

On Fri, 26 Sep 2025 08:58:38 -0700, Sean Christopherson wrote:
> Store the width of arm64's timer counter as an "int", not a "uint64_t".
> ilog2() returns an "int", and more importantly using what is an "unsigned
> long" under the hood makes clang unhappy due to a type mismatch when
> clamping the width to a sane value.
> 
>   arm64/arch_timer_edge_cases.c:1032:10: error: comparison of distinct pointer types
>      ('typeof (width) *' (aka 'unsigned long *') and 'typeof (56) *' (aka 'int *'))
>      [-Werror,-Wcompare-distinct-pointer-types]
>    1032 |         width = clamp(width, 56, 64);
>         |                 ^~~~~~~~~~~~~~~~~~~~
>   tools/include/linux/kernel.h:47:45: note: expanded from macro 'clamp'
>      47 | #define clamp(val, lo, hi)      min((typeof(val))max(val, lo), hi)
>         |                                                  ^~~~~~~~~~~~
>   tools/include/linux/kernel.h:33:17: note: expanded from macro 'max'
>      33 |         (void) (&_max1 == &_max2);              \
>         |                 ~~~~~~ ^  ~~~~~~
>   tools/include/linux/kernel.h:39:9: note: expanded from macro 'min'
>      39 |         typeof(x) _min1 = (x);                  \
>         |                ^
> 
> [...]

Applied to fixes, thanks!

[1/1] KVM: selftests: Track width of arm64's timer counter as "int", not "uint64_t"
      commit 34f46fecfe96b404ef14e97b8e59cde693276f28.

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


