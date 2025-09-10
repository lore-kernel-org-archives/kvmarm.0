Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD306433A0
	for <kvmarm@lists.linux.dev>; Wed, 10 Sep 2025 16:47:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.40.44.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757522824; cv=none; b=rCPjY9Dk7lF3CUXU//kJQPkAfT//4NkI5/I3hCh36ag6j5qVDT6R1nLEprbUUcBrQDlaQU8/U6T7JcDUB6CrGSTtbZI8iousWQq/AcGMkiy+R2OdgnCIOscUd7dcc3KWd9cNozNHIo08Y2HEVW/TnsN0Ud7S8VF3U7rtEKlYfm0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757522824; c=relaxed/simple;
	bh=3UE4uHR6aO+OFaypXOwwNEdnfkfmlNq6uFNa5BjW4uI=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=IYk83d75OypfyvZObmwPngs7c20inEJlnmgdJ/iFyHNX+BX/iNHjBGLzkl7uJugECSB8Ji69pdqNmxKAex2ZccMxfcQ06eKi7BfD3PA+p/YR3WlXbIZwP1ypCQk9dlul2NLz+cgsAFiKFjtFCmlPKNdf3vV8cUPRjEBYwYwRmlc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=goodmis.org; spf=pass smtp.mailfrom=goodmis.org; arc=none smtp.client-ip=216.40.44.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=goodmis.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=goodmis.org
Received: from omf04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 5C5F61179B7;
	Wed, 10 Sep 2025 16:46:55 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: rostedt@goodmis.org) by omf04.hostedemail.com (Postfix) with ESMTPA id F405F20024;
	Wed, 10 Sep 2025 16:46:51 +0000 (UTC)
Date: Wed, 10 Sep 2025 12:47:42 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Vincent Donnefort <vdonnefort@google.com>
Cc: mhiramat@kernel.org, mathieu.desnoyers@efficios.com,
 linux-trace-kernel@vger.kernel.org, maz@kernel.org, oliver.upton@linux.dev,
 joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com,
 kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
 jstultz@google.com, qperret@google.com, will@kernel.org,
 aneesh.kumar@kernel.org, kernel-team@android.com,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH v6 15/24] KVM: arm64: Support unaligned fixmap in the
 pKVM hyp
Message-ID: <20250910124742.34185645@gandalf.local.home>
In-Reply-To: <20250821081412.1008261-16-vdonnefort@google.com>
References: <20250821081412.1008261-1-vdonnefort@google.com>
	<20250821081412.1008261-16-vdonnefort@google.com>
X-Mailer: Claws Mail 3.20.0git84 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: q9cbx38hryj33o5fwyipu7ui3mmw96do
X-Rspamd-Server: rspamout03
X-Rspamd-Queue-Id: F405F20024
X-Session-Marker: 726F737465647440676F6F646D69732E6F7267
X-Session-ID: U2FsdGVkX19JP+3dHgVZ3OldSVYgQj0MefUC8Z85EjM=
X-HE-Tag: 1757522811-725488
X-HE-Meta: U2FsdGVkX18yi2o/B62gDqm8AYG/9T+wf5t8LxVLQsiafH2QQ0ZSJcX1Vb7j7AiT4OouF7YoGLFO2B2fGds+ZHAWLiDNewTEYVHdqKFpaeyLhLEv9JLayHPnToecZQWsjUPlDVCbcqL3bL4AeMUcrCTQb4kM6TyxEqIA+jRCS/V3seDhQUEPG0w8Fa/+uWh0Uou/l/T1IRlDdcVFx6Kb7kaJ1gtG2oReVEQomDU1nXZWBWMF5eFh4PUamQfSfxJPHT0Q2JNTiLTuW7BnjLlcz0p2nXNAoVRZjazY3QOnAkakhg8Unj47qVdWCCseW1W1wQstnQ5n7CfASD/U738xhId8P4KuziyF


Would be nice if the arm KVM folks could review the second part of this
patch series.

Vincent, I finished my review, and you can post a new version. But it would
still be good to get some input from the architecture folks.

-- Steve


On Thu, 21 Aug 2025 09:14:03 +0100
Vincent Donnefort <vdonnefort@google.com> wrote:

> Return the fixmap VA with the page offset, instead of the page base
> address. This allows to use hyp_fixmap_map() seamlessly regardless of
> the address alignment.
> 
> Signed-off-by: Vincent Donnefort <vdonnefort@google.com>
> 
> diff --git a/arch/arm64/kvm/hyp/nvhe/mm.c b/arch/arm64/kvm/hyp/nvhe/mm.c
> index ae8391baebc3..75014dc7d82e 100644
> --- a/arch/arm64/kvm/hyp/nvhe/mm.c
> +++ b/arch/arm64/kvm/hyp/nvhe/mm.c
> @@ -239,7 +239,7 @@ static void *fixmap_map_slot(struct hyp_fixmap_slot *slot, phys_addr_t phys)
>  	WRITE_ONCE(*ptep, pte);
>  	dsb(ishst);
>  
> -	return (void *)slot->addr;
> +	return (void *)slot->addr + offset_in_page(phys);
>  }
>  
>  void *hyp_fixmap_map(phys_addr_t phys)

