Received: from mail.8bytes.org (mail.8bytes.org [85.214.250.239])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 24A603438A1;
	Tue,  9 Jun 2026 14:27:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=85.214.250.239
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781015264; cv=none; b=QCe1pgdadQIXExkCtH5IAzpiH9Dc35IjyCaxbgAN19DpDplKu9dUKf2vaYrPtfP/p6PmBA+iticAuvZMomqVxN7IK9ynjDGQO5iGy0CofCY4ytvPPir4Mv2NDzbEzOboiZpXMLT1eGC5krZSuwzKWyo5Esjh3p7jddZq39eJ3C8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781015264; c=relaxed/simple;
	bh=fTsYvLeJ0N/YqVfkN9T0KlSw7FGqkfT38Irf9mhEx14=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Yt4a61+wh9aZw1dtUPLRdM3DGuW9D8MgqMAHZ/88scP3AVRLD/uJ9O5hBH3paBiJespR2CUDt43bapBqYDWPZk5avyFmsLmho8T//seoNCY6LR4HQ9AQH6nSkjBkfnvD/ggB9puQ1mPWnsQDhqwwNreO1lkKecCNaEphjcXZt6k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=8bytes.org; spf=pass smtp.mailfrom=8bytes.org; arc=none smtp.client-ip=85.214.250.239
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=8bytes.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=8bytes.org
Received: from 8bytes.org (p4ffe1d30.dip0.t-ipconnect.de [79.254.29.48])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mail.8bytes.org (Postfix) with ESMTPSA id 86023222F08;
	Tue,  9 Jun 2026 16:27:41 +0200 (CEST)
Date: Tue, 9 Jun 2026 16:27:40 +0200
From: =?utf-8?B?SsO2cmcgUsO2ZGVs?= <joro@8bytes.org>
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, 
	Sean Christopherson <seanjc@google.com>, Tom Lendacky <thomas.lendacky@amd.com>, ashish.kalra@amd.com, 
	michael.roth@amd.com, nsaenz@amazon.com, anelkz@amazon.de, 
	Melody Wang <huibo.wang@amd.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	kvmarm@lists.linux.dev, loongarch@lists.linux.dev, linux-mips@vger.kernel.org, 
	linuxppc-dev@lists.ozlabs.org, kvm-riscv@lists.infradead.org, x86@kernel.org, 
	coconut-svsm@lists.linux.dev, joerg.roedel@amd.com
Subject: Re: [PATCH 35/60] kvm: Add VCPU plane-scheduling state and helpers
Message-ID: <aigifVmRZA0TXIrK@8bytes.org>
References: <20260608144252.351443-1-joro@8bytes.org>
 <20260608144252.351443-36-joro@8bytes.org>
 <e7eb0dba-790a-4644-9895-5c9a7420d7fe@redhat.com>
 <aib8n5lO6HKbLC4Y@8bytes.org>
 <CABgObfbUsDeStnZF-7oyR-W-Bvd4qTMoeUwGizgn10UTdKtZ2A@mail.gmail.com>
 <aigE2EvJyZlYDz0V@8bytes.org>
 <51421426e0d4b154281e80d9f1c6c9a628d21c94.camel@HansenPartnership.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51421426e0d4b154281e80d9f1c6c9a628d21c94.camel@HansenPartnership.com>

Hi James,

On Tue, Jun 09, 2026 at 08:59:02AM -0400, James Bottomley wrote:
> Are the details of this anywhere?  The last PUCK information I saw on
> the kvm list was the cancellation of the March and April calls.

Here is the calendar link I use, which has the appointments GMeet links:

https://calendar.google.com/calendar/embed?src=c_61a5b1f644739bf5bed7e5ea5fc3669ce32a2544c5db1c7c891702ca5090c7d5%40group.calendar.google.com


-Joerg
