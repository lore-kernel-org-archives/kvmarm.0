Received: from mail.8bytes.org (mail.8bytes.org [85.214.250.239])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E0106367283;
	Mon,  8 Jun 2026 17:52:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=85.214.250.239
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780941132; cv=none; b=iz2cmYtYJKuYU4/tpeRohdgAX5oZ5snV4T/fRGloWQiej+78Du2IRwi7J9/FnWswr53aymDJacPfJdyvyeZrNWdgdLXkORwGLYX8aWqtjLPXvTDHdpuyWP2mOjiEo7cXHO3u1UmIvq9NHpbr4F9P/U8PeBmITSf64k3vBLij+dg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780941132; c=relaxed/simple;
	bh=QSal/tVkHxeb9vLgIzl1B7joICUP1agySJd1l/0Ed44=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RzNipArLblF7NScUg67dY01kGA+1fLn6U66jStt4aqwF/Btz7hPBfVPkVbXRunkUEaiQ8gEodi3m5ggUK7oy23z/mdD5Rt3l6ivwUtOrIwd09y0Blfd8XUn8AdfloWyA03B6aMLgHAp3Ywd+LJywUKhOj9ATW57500ZKavLbxvA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=8bytes.org; spf=pass smtp.mailfrom=8bytes.org; arc=none smtp.client-ip=85.214.250.239
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=8bytes.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=8bytes.org
Received: from 8bytes.org (p4ffe1d30.dip0.t-ipconnect.de [79.254.29.48])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mail.8bytes.org (Postfix) with ESMTPSA id 46872202AB5;
	Mon,  8 Jun 2026 19:52:09 +0200 (CEST)
Date: Mon, 8 Jun 2026 19:52:08 +0200
From: =?utf-8?B?SsO2cmcgUsO2ZGVs?= <joro@8bytes.org>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Sean Christopherson <seanjc@google.com>, 
	Tom Lendacky <thomas.lendacky@amd.com>, ashish.kalra@amd.com, michael.roth@amd.com, nsaenz@amazon.com, 
	anelkz@amazon.de, James.Bottomley@hansenpartnership.com, 
	Melody Wang <huibo.wang@amd.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	kvmarm@lists.linux.dev, loongarch@lists.linux.dev, linux-mips@vger.kernel.org, 
	linuxppc-dev@lists.ozlabs.org, kvm-riscv@lists.infradead.org, x86@kernel.org, 
	coconut-svsm@lists.linux.dev, joerg.roedel@amd.com
Subject: Re: [PATCH 35/60] kvm: Add VCPU plane-scheduling state and helpers
Message-ID: <aib8n5lO6HKbLC4Y@8bytes.org>
References: <20260608144252.351443-1-joro@8bytes.org>
 <20260608144252.351443-36-joro@8bytes.org>
 <e7eb0dba-790a-4644-9895-5c9a7420d7fe@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <e7eb0dba-790a-4644-9895-5c9a7420d7fe@redhat.com>

Hi Paolo,

On Mon, Jun 08, 2026 at 06:47:54PM +0200, Paolo Bonzini wrote:
> On 6/8/26 16:42, Jörg Rödel wrote:
> > From: Joerg Roedel <joerg.roedel@amd.com>
> > 
> > The algorithm is to always run the lowest runnable plane. Plane
> > switches are done by stopping the current plane and setting another
> > runnable.
> > 
> > Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
> 
> This was left arbitrary in my version because for example Hyper-V VTLs use
> highest-runnable instead.  It also made pure userspace scheduling possible,
> though that may not be very important in the grand scheme of things.

IIRC what Hyper-V does is always the run the highest-privileged runnable level,
no?  Maybe in their numbering level 0 has the least privileges?  Anyway, I am
happy to make changes here, also based on input from the VSM side.

> Did you drop it because it didn't work, or just for simplicity?

The user-space scheduling worked, my 6.17 planes implementation used it. But
there are some problems with it going forward, because TDX Partitioning (and
likely ARM CCA Planes as well) do not allow arbitrary switches forced by the
hypervisor. All they allow is a forced switch to the highest privileged plane,
the SVSM on SNP will force the same constraints by making lower-privilege VMSAs
not-runnable when it executes.

So exposing an interface for user-space to chose which plane to run does seem
to gain some weird, platform dependent semantics going forward. TDX and CCA
also require in-kernel switching as they can switch planes without a VMEXIT, so
I decided to have it from the start.


-Joerg
