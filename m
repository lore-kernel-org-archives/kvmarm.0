Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=68.232.139.130
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795500342;
	b=zPPGi0/bQ5zyHhH+ImzJ7sMQLWoDbHF8Bp7AWBhMHqLHFNP15M+NAzljSzBQHJ52k0yv
	 wUnPyPbzfSZv6THMENZInxCM4TQ8l33bT8iZwGtGV+msP4LOLgKW5x107bceA1a0GBo0O
	 9Jm5trJvJ9s9oU/fu0kOEaw1vkGoKX3C/8fpB9fWiQFcZeNZ22fhk5gJhlIqlxBJFD0hV
	 yjd0VuClEVqpUBr8m6zpIQNMcbmBdYdDwMwQlfPWhzV5BSFRZ+ZcI0n+ozfOw+BmzlBC/
	 4XUuguspU26pfpFhe/Kr8N6B7UzHnqb85c6IsusPpY3oW7KD0MHShJ1qaNi2VZ2GGEw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795500342;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:X-IronPort-AV:Received:Received:Received:Received:Date:
	 From:To:Cc:Subject:Message-ID:References:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To;
	bh=eBczXh2rwT/tVRir2/HArzL/+HYC+3RjuBz4lTVxOt8=;
	b=5b87oFWWe5J/w2luRMOBl4U/fMFgVryIEi7WQP5idEhO51JgP3VvVgqqNBF/CFVImm5X
	 +zeWN7/ExK2xbt25IUXisHb57NvatrRCG9qF5xrOXRU6DT4H5VHEOtoWuzRwyHtvko9sa
	 +h2ld1RDU77avAAPVSgxuBrLQrUzyF6nRUzNGrnsocnOJ0E8+233wM6EFX4gRohjBhh2H
	 KrlDssU6M3WQGHjN5IFmjtPx9WqpwnHC2ykcVaepzy/D3z4WHzXik/zF4UpDwkz9OIjDQ
	 Xh12I7ClaAfIhxwC6MrbPBt+Xc8OpihchJGynWXVQL96FrLyWJkfM+bqlyoyBh1l8+w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=fujitsu.com;
	spf=pass smtp.mailfrom=fujitsu.com;
	dkim=pass header.d=fujitsu.com header.i=@fujitsu.com header.a=rsa-sha256 header.s=fj2 header.b=QYHM+eBJ;
	arc=none smtp.remote-ip=68.232.139.130
Received: from esa5.hc1455-7.c3s2.iphmx.com (esa5.hc1455-7.c3s2.iphmx.com [68.232.139.130])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 954AC606A31E;
	Tue, 24 Nov 2026 06:05:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 954AC606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fujitsu.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fujitsu.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fujitsu.com header.i=@fujitsu.com header.a=rsa-sha256 header.s=fj2 header.b=QYHM+eBJ
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=fujitsu.com; i=@fujitsu.com; q=dns/txt; s=fj2;
  t=1795500350; x=1827036350;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=hGKQ4qS9S+b/Gx7erQ6F7hfdQX2hbg0Db7UCm3AICPE=;
  b=QYHM+eBJaZZhMPgGowXR5CIYmue9q+GGBoaFaKC7Xs8whYlZwpAWnFS9
   K0L+P1fMfkdGNDjF3RO0dhgzkT7sa7nmOpCYJQa9zZDBLMFkVBlZpAeq2
   818pSM7NSBYLAgO0T94/ykNrYmmSMq2r/ixmS7RPl9hGHP15SSSnvT/ej
   +a++D2sn7w4JlZX9du17kilnyv8CDds3+QjQhZ3YJusJ7qEmGN1j4VUXK
   JH7A+BGYKxlTuPywDjZvqo0eqBNMnuRf1Cq3C6Sa/uk9kR4cFFzOcw9aX
   ItlOkEdEJSw//vJV8B0Oki0M0sNundJXAOH9CIh1l8ZlWmeCeUSzrmbow
   g==;
X-CSE-ConnectionGUID: JW1AXXsTT2SIREQTI4ouYw==
X-CSE-MsgGUID: ekaL0TSRR3ika0XmtZhqEA==
X-IronPort-AV: E=McAfee;i="6800,10657,11975"; a="261067064"
X-IronPort-AV: E=Sophos;i="6.27,230,1786978800"; 
   d="scan'208";a="261067064"
Received: from gmgwnl01.global.fujitsu.com (HELO mgmgwnl01.global.fujitsu.com) ([52.143.17.124])
  by esa5.hc1455-7.c3s2.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Nov 2026 15:05:42 +0900
Received: from az2nlsmgm2.o.css.fujitsu.com (unknown [10.150.26.202])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mgmgwnl01.global.fujitsu.com (Postfix) with ESMTPS id 75BFB33FD;
	Tue, 24 Nov 2026 06:05:34 +0000 (UTC)
Received: from az2uksmom3.o.css.fujitsu.com (unknown [10.151.22.205])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by az2nlsmgm2.o.css.fujitsu.com (Postfix) with ESMTPS id 289661C002E6;
	Tue, 24 Nov 2026 06:05:34 +0000 (UTC)
Received: from FCCLS0092175.localdomain (unknown [10.9.1.165])
	by az2uksmom3.o.css.fujitsu.com (Postfix) with SMTP id C7E5D100008E;
	Tue, 24 Nov 2026 06:05:30 +0000 (UTC)
Date: Tue, 24 Nov 2026 15:05:29 +0900
From: Kohei Enju <enju.kohei@fujitsu.com>
To: sashiko-reviews@lists.linux.dev
Cc: Tomohiro Misono <misono.tomohiro@fujitsu.com>, 
	linux-perf-users@vger.kernel.org, kvmarm@lists.linux.dev, Oliver Upton <oupton@kernel.org>, 
	Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH v3 4/5] irqchip/gicv3: Add workaround for FUJITSU-MONAKA
 Erratum E#030003
Message-ID: <awUo0MClQ_hYIbpE@FCCLS0092175.localdomain>
References: <20261119-monaka-fix-for-upstream-v3-0-057df4d2ca3c@fujitsu.com>
 <20261119-monaka-fix-for-upstream-v3-4-057df4d2ca3c@fujitsu.com>
 <sashiko-outbox-222816@kernel.org>
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <sashiko-outbox-222816@kernel.org>

On 11/19 09:21, sashiko-bot@kernel.org wrote:
> [Severity: Low]
> Does defining gic_fujitsu_030003_erratum unconditionally trigger a
> -Wunused-variable warning when building with CONFIG_ARM=y and
> CONFIG_SMP=n?
> 
> Its only two users are gic_ipi_send_mask() (under #ifdef CONFIG_SMP) and
> gic_enable_quirk_fujitsu_030003() (under #ifdef CONFIG_ARM64), so both are
> compiled out on 32-bit ARM UP builds.  Marking it __maybe_unused (like
> broken_rdists earlier in the file) or guarding it with #ifdef CONFIG_SMP
> would avoid the warning.

I'll fix this in the next revision.

Thanks,
Kohei
