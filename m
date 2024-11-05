Received: from out-173.mta1.migadu.com (out-173.mta1.migadu.com [95.215.58.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2334383
	for <kvmarm@lists.linux.dev>; Tue,  5 Nov 2024 21:33:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730842429; cv=none; b=CwIjIVC2qk4aeSLy71E/BaLe/tWVYSywQPt+x5gMpTMmiAc8bCxsShCas6TvgmE/tgKavIFgecRjrLiCFM0IeZtxQUNW0gjp4OzTdt+i9u36boIoMUM7IJ5siUsqEGvJvo9bBA1HwcHfWdDWBzZmSqP6PPKJdOALfx4FGP9zzzo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730842429; c=relaxed/simple;
	bh=XJNYFQm/qJEHR89hnKM/3pFjjHdMWXtl34mOzRBAuzw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sIiG/67oL3U8Z7Rut64szhnIkuqX5OvsrdbKMPQWQU5543BzUib0NByxllcyXfKi6bAlmrd6ZIm8bbYaJ3AcJYBjCzHkqgOM4X9ZvMbfHHrdi6H63XwxGTVuWGzV5B7l+UqMvzOuK0DNpiUkk/1ca5tTvXbD5L43EyeQZjIAtSI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=bFhytUZO; arc=none smtp.client-ip=95.215.58.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="bFhytUZO"
Date: Tue, 5 Nov 2024 13:33:37 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1730842425;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=h4AAGHq98f/2bOvzTIrNfRJRjw7gM/lfEoOYvvlJdnI=;
	b=bFhytUZOyC/f1TCNrAfrs28StEuuNrIcK7n5DpDtR8IaFGfxVzXkGjNW2HcFGk6j5xXsWd
	rZQFPH3nqbS3JApRSRnLpTi+xGik0iw7OjGeHrI3TQvSs528rYUA9ehEqAa/K4xIArEzOH
	5T044bjv0otgWZozioGZ7ANKt06Bcac=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Jing Zhang <jingzhangos@google.com>
Cc: KVM <kvm@vger.kernel.org>, KVMARM <kvmarm@lists.linux.dev>,
	ARMLinux <linux-arm-kernel@lists.infradead.org>,
	Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@google.com>,
	Joey Gouly <joey.gouly@arm.com>, Zenghui Yu <yuzenghui@huawei.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Andre Przywara <andre.przywara@arm.com>,
	Colton Lewis <coltonlewis@google.coma>,
	Raghavendra Rao Ananta <rananta@google.com>
Subject: Re: [PATCH v1 0/4] Fix a bug in VGIC ITS tables' save/restore
Message-ID: <ZyqPMdH4anLEIq8G@linux.dev>
References: <20241105193422.1094875-1-jingzhangos@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241105193422.1094875-1-jingzhangos@google.com>
X-Migadu-Flow: FLOW_OUT

Hi Jing,

On Tue, Nov 05, 2024 at 11:34:18AM -0800, Jing Zhang wrote:
> The core issue stems from the static linked list implementation of DTEs/ITEs,
> requiring a full table scan to locate the list head during restoration. This
> scan increases the likelihood of encountering orphaned entries.  To rectify
> this, the patch series introduces a dummy head to the list, enabling immediate
> access to the list head and bypassing the scan. This optimization not only
> resolves the bug but also significantly enhances restore performance,
> particularly in edge cases where valid entries reside at the end of the table.

I think we need a more targeted fix (i.e. Kunkun's patch) to stop the
bleeding + backport it to stable.

Then we can have a separate discussion about improving the save/restore
performance with your approach.

-- 
Thanks,
Oliver
