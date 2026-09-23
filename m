Received: from mta0.migadu.com (out-162.mta0.migadu.com [91.218.175.162])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEE58486E5A
	for <kvmarm@lists.linux.dev>; Wed, 23 Sep 2026 11:01:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.162
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790161304; cv=none; b=D31MUjApRQO0B3wnkqv8dhJwRlU9zwwhwU2GPoa7OUSak9pJzkxOEQsqtp/TMX3cE3V53jeJH07O2/jJfDC8KwYyFJnDfTYww0H4z+RnSFT0yDpTLIA2xnWXC3Cse/1ucH5VbOCQ18lRtRUifydQ/r0bqomr7S8gSuyay5yXJpA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790161304; c=relaxed/simple;
	bh=5K+iPpF8DDgclPsRQeL7zsBmY6cYvKrH6RbiTc5jglc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=SiWUDsvJ9M6FfOhZF/IKmZVN8whhykUWswVwU9LRot3WYknC2rU7388QtvCntscVzR9mbmYTWD54Fl340vJrW9xCBqopSjPCHmgWHGR7TEdA7Y2htqkFP4t2Gf5y4etlUyuwlZt7lE02qiXkedougvuugJN0r4t6Kf/3UjlxsWg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=rsfuoUsx; arc=none smtp.client-ip=91.218.175.162
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="rsfuoUsx"
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=5K+iPpF8DDgclPsRQeL7zsBmY6cYvKrH6RbiTc5jglc=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790161296; v=1; x=1790766096;
 b=rsfuoUsx8B6H+6nfqjVMSMbRyksXnU8C+h4NBxFoCnFhbb3wXev4a8kzRTMxK7YBnzurG8UH
 fyWIi4mYpqhwfSdjrhnuExBnykc3mRfyNwXgNmKs6zuuYptHMFAGMNveGtokVynban5U7eiFEsI
 IZKP7S72cfSyhQcCktv2tocY=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id 2218cf4d9aeb7adb;
	Wed, 23 Sep 2026 11:01:36 +0000
X-Mizu-Trace-ID: 2218cf4d9aeb7adb
X-Migadu-Flow: FLOW_OUT
Received: by mail-lf1-f46.google.com with SMTP id 2adb3069b0e04-5b8c42da963so5262e87.0
        for <kvmarm@lists.linux.dev>; Wed, 23 Sep 2026 04:01:32 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBydRWlVFGKJgBZpII6uRTV4kNyv0KaSHoYMR/870kRD/q+mIM8kPa+BT5VX2Ybqq/2RrNnSJHE=@lists.linux.dev
X-Gm-Message-State: AFuF++n5yLpum/RSYOXcr5xs5HHrrWUajmh3H0DOwe8SCzUY76sITc75
	wQrLzOOjHhqeJLd6WVS6pbfX+T2Ah/iK2hMzGpGevZ4ul+NYMvb7/zQrldAuURIw95zBKT5aQNV
	Q9mt+D7hvVVyUMrQY9ksL9zykg/VSDUG1AMbJbgNO
X-Received: by 2002:a05:6512:648a:b0:5b6:4ad:d6ba with SMTP id
 2adb3069b0e04-5b8d91673a2mr101791e87.15.1790161291757; Wed, 23 Sep 2026
 04:01:31 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260922-kvm-arm-prefault-v3-0-787bd3bc7e3f@kernel.org>
 <20260922-kvm-arm-prefault-v3-7-787bd3bc7e3f@kernel.org> <20260922143157.0E84B1F000FF@smtp.kernel.org>
In-Reply-To: <20260922143157.0E84B1F000FF@smtp.kernel.org>
From: Fuad Tabba <fuad.tabba@linux.dev>
Date: Wed, 23 Sep 2026 12:00:55 +0100
X-Gmail-Original-Message-ID: <CA+EHjTziT=qEvCpjGriVhC5g7=nyQNfvEQenw-JXSJuWtJwTRg@mail.gmail.com>
X-Gm-Features: AcwNN1VlY5oTU2GdC6G6YKOfl5LmibKipPAp5RDM2yTy_ZaXda-g-wUfh5go1wI
Message-ID: <CA+EHjTziT=qEvCpjGriVhC5g7=nyQNfvEQenw-JXSJuWtJwTRg@mail.gmail.com>
Subject: Re: [PATCH v3 07/14] KVM: arm64: Size the stage-2 memcache from the
 fault MMU
To: sashiko-reviews@lists.linux.dev
Cc: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>, Oliver Upton <oupton@kernel.org>, kvmarm@lists.linux.dev, 
	Marc Zyngier <maz@kernel.org>, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Hi Lorenzo,

On Tue, 22 Sep 2026 15:31:56 +0100, sashiko-bot@kernel.org wrote:
[...]
> Does this decoupling of s2fd->mmu and vcpu->arch.hw_mmu cause a spurious
> allocation downstream in kvm_s2_fault_map()?
[...]
> Could this lead to an unnecessary allocation in the ioctl path that might
> spuriously fail and return -ENOMEM to userspace?

Sashiko might be right about this one, though the mismatch comes from
patch 5 rather than this patch: patch 5 moves kvm_s2_fault_map()'s pgt
to s2fd->mmu and leaves the allocation check above it on
s2fd->vcpu->arch.hw_mmu. Could patch 5 switch that check to s2fd->mmu
as well, the way gmem_abort() tests pgt->mmu?

This patch looks fine to me though.

Reviewed-by: Fuad Tabba <fuad.tabba@linux.dev>

Cheers,
/fuad
